Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D646172CB6
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 12:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfGXK6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 06:58:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55052 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726070AbfGXK6k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 06:58:40 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7A89F8F02B;
        Wed, 24 Jul 2019 10:58:40 +0000 (UTC)
Received: from work-vm (ovpn-117-166.ams2.redhat.com [10.36.117.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A078160A9F;
        Wed, 24 Jul 2019 10:58:38 +0000 (UTC)
Date:   Wed, 24 Jul 2019 11:58:36 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Juan Quintela <quintela@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Ren <renyime@gmail.com>, Ivan Ren <ivanren@tencent.com>
Subject: Re: [PATCH 2/4] migration: fix migrate_cancel leads live_migration
 thread hung forever
Message-ID: <20190724105836.GB2717@work-vm>
References: <20190724095523.1527-1-quintela@redhat.com>
 <20190724095523.1527-3-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724095523.1527-3-quintela@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 24 Jul 2019 10:58:40 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Juan Quintela (quintela@redhat.com) wrote:
> From: Ivan Ren <renyime@gmail.com>
> 
> When we 'migrate_cancel' a multifd migration, live_migration thread may
> hung forever at some points, because of multifd_send_thread has already
> exit for socket error:
> 1. multifd_send_pages may hung at qemu_sem_wait(&multifd_send_state->
>    channels_ready)
> 2. multifd_send_sync_main my hung at qemu_sem_wait(&multifd_send_state->
>    sem_sync)
> 
> Signed-off-by: Ivan Ren <ivanren@tencent.com>
> Message-Id: <1561468699-9819-3-git-send-email-ivanren@tencent.com>
> Reviewed-by: Juan Quintela <quintela@redhat.com>
> Signed-off-by: Juan Quintela <quintela@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> 
> ---
> 
> Remove spurious not needed bits
> ---
>  migration/ram.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/migration/ram.c b/migration/ram.c
> index 52a2d498e4..87bb7da8e2 100644
> --- a/migration/ram.c
> +++ b/migration/ram.c
> @@ -1097,7 +1097,8 @@ static void *multifd_send_thread(void *opaque)
>  {
>      MultiFDSendParams *p = opaque;
>      Error *local_err = NULL;
> -    int ret;
> +    int ret = 0;
> +    uint32_t flags = 0;
>  
>      trace_multifd_send_thread_start(p->id);
>      rcu_register_thread();
> @@ -1115,7 +1116,7 @@ static void *multifd_send_thread(void *opaque)
>          if (p->pending_job) {
>              uint32_t used = p->pages->used;
>              uint64_t packet_num = p->packet_num;
> -            uint32_t flags = p->flags;
> +            flags = p->flags;
>  
>              p->next_packet_size = used * qemu_target_page_size();
>              multifd_send_fill_packet(p);
> @@ -1164,6 +1165,17 @@ out:
>          multifd_send_terminate_threads(local_err);
>      }
>  
> +    /*
> +     * Error happen, I will exit, but I can't just leave, tell
> +     * who pay attention to me.
> +     */
> +    if (ret != 0) {
> +        if (flags & MULTIFD_FLAG_SYNC) {
> +            qemu_sem_post(&multifd_send_state->sem_sync);
> +        }
> +        qemu_sem_post(&multifd_send_state->channels_ready);
> +    }
> +
>      qemu_mutex_lock(&p->mutex);
>      p->running = false;
>      qemu_mutex_unlock(&p->mutex);
> -- 
> 2.21.0
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
