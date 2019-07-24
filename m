Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0026E72CB4
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 12:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfGXK5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 06:57:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40108 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbfGXK5Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 06:57:16 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C007A85550;
        Wed, 24 Jul 2019 10:57:15 +0000 (UTC)
Received: from work-vm (ovpn-117-166.ams2.redhat.com [10.36.117.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D4E8E60A9F;
        Wed, 24 Jul 2019 10:57:13 +0000 (UTC)
Date:   Wed, 24 Jul 2019 11:57:11 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Juan Quintela <quintela@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Ren <renyime@gmail.com>, Ivan Ren <ivanren@tencent.com>
Subject: Re: [PATCH 1/4] migration: fix migrate_cancel leads live_migration
 thread endless loop
Message-ID: <20190724105711.GA2717@work-vm>
References: <20190724095523.1527-1-quintela@redhat.com>
 <20190724095523.1527-2-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724095523.1527-2-quintela@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 24 Jul 2019 10:57:16 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Juan Quintela (quintela@redhat.com) wrote:
> From: Ivan Ren <renyime@gmail.com>
> 
> When we 'migrate_cancel' a multifd migration, live_migration thread may
> go into endless loop in multifd_send_pages functions.
> 
> Reproduce steps:
> 
> (qemu) migrate_set_capability multifd on
> (qemu) migrate -d url
> (qemu) [wait a while]
> (qemu) migrate_cancel
> 
> Then may get live_migration 100% cpu usage in following stack:
> 
> pthread_mutex_lock
> qemu_mutex_lock_impl
> multifd_send_pages
> multifd_queue_page
> ram_save_multifd_page
> ram_save_target_page
> ram_save_host_page
> ram_find_and_save_block
> ram_find_and_save_block
> ram_save_iterate
> qemu_savevm_state_iterate
> migration_iteration_run
> migration_thread
> qemu_thread_start
> start_thread
> clone
> 
> Signed-off-by: Ivan Ren <ivanren@tencent.com>
> Message-Id: <1561468699-9819-2-git-send-email-ivanren@tencent.com>
> Reviewed-by: Juan Quintela <quintela@redhat.com>
> Signed-off-by: Juan Quintela <quintela@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  migration/ram.c | 36 +++++++++++++++++++++++++++++-------
>  1 file changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/migration/ram.c b/migration/ram.c
> index 2b0774c2bf..52a2d498e4 100644
> --- a/migration/ram.c
> +++ b/migration/ram.c
> @@ -920,7 +920,7 @@ struct {
>   * false.
>   */
>  
> -static void multifd_send_pages(void)
> +static int multifd_send_pages(void)
>  {
>      int i;
>      static int next_channel;
> @@ -933,6 +933,11 @@ static void multifd_send_pages(void)
>          p = &multifd_send_state->params[i];
>  
>          qemu_mutex_lock(&p->mutex);
> +        if (p->quit) {
> +            error_report("%s: channel %d has already quit!", __func__, i);
> +            qemu_mutex_unlock(&p->mutex);
> +            return -1;
> +        }
>          if (!p->pending_job) {
>              p->pending_job++;
>              next_channel = (i + 1) % migrate_multifd_channels();
> @@ -951,9 +956,11 @@ static void multifd_send_pages(void)
>      ram_counters.transferred += transferred;;
>      qemu_mutex_unlock(&p->mutex);
>      qemu_sem_post(&p->sem);
> +
> +    return 1;
>  }
>  
> -static void multifd_queue_page(RAMBlock *block, ram_addr_t offset)
> +static int multifd_queue_page(RAMBlock *block, ram_addr_t offset)
>  {
>      MultiFDPages_t *pages = multifd_send_state->pages;
>  
> @@ -968,15 +975,19 @@ static void multifd_queue_page(RAMBlock *block, ram_addr_t offset)
>          pages->used++;
>  
>          if (pages->used < pages->allocated) {
> -            return;
> +            return 1;
>          }
>      }
>  
> -    multifd_send_pages();
> +    if (multifd_send_pages() < 0) {
> +        return -1;
> +    }
>  
>      if (pages->block != block) {
> -        multifd_queue_page(block, offset);
> +        return  multifd_queue_page(block, offset);
>      }
> +
> +    return 1;
>  }
>  
>  static void multifd_send_terminate_threads(Error *err)
> @@ -1049,7 +1060,10 @@ static void multifd_send_sync_main(void)
>          return;
>      }
>      if (multifd_send_state->pages->used) {
> -        multifd_send_pages();
> +        if (multifd_send_pages() < 0) {
> +            error_report("%s: multifd_send_pages fail", __func__);
> +            return;
> +        }
>      }
>      for (i = 0; i < migrate_multifd_channels(); i++) {
>          MultiFDSendParams *p = &multifd_send_state->params[i];
> @@ -1058,6 +1072,12 @@ static void multifd_send_sync_main(void)
>  
>          qemu_mutex_lock(&p->mutex);
>  
> +        if (p->quit) {
> +            error_report("%s: channel %d has already quit", __func__, i);
> +            qemu_mutex_unlock(&p->mutex);
> +            return;
> +        }
> +
>          p->packet_num = multifd_send_state->packet_num++;
>          p->flags |= MULTIFD_FLAG_SYNC;
>          p->pending_job++;
> @@ -2033,7 +2053,9 @@ static int ram_save_page(RAMState *rs, PageSearchStatus *pss, bool last_stage)
>  static int ram_save_multifd_page(RAMState *rs, RAMBlock *block,
>                                   ram_addr_t offset)
>  {
> -    multifd_queue_page(block, offset);
> +    if (multifd_queue_page(block, offset) < 0) {
> +        return -1;
> +    }
>      ram_counters.normal++;
>  
>      return 1;
> -- 
> 2.21.0
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
