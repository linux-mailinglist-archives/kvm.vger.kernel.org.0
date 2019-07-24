Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC6F972CC0
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 13:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfGXLBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 07:01:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbfGXLBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 07:01:08 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E802D30BD1CA;
        Wed, 24 Jul 2019 11:01:07 +0000 (UTC)
Received: from work-vm (ovpn-117-166.ams2.redhat.com [10.36.117.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B997600C7;
        Wed, 24 Jul 2019 11:01:05 +0000 (UTC)
Date:   Wed, 24 Jul 2019 12:01:03 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Juan Quintela <quintela@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH 3/4] migration: Make explicit that we are quitting multifd
Message-ID: <20190724110103.GC2717@work-vm>
References: <20190724095523.1527-1-quintela@redhat.com>
 <20190724095523.1527-4-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724095523.1527-4-quintela@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 24 Jul 2019 11:01:07 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Juan Quintela (quintela@redhat.com) wrote:
> We add a bool to indicate that.
> 
> Signed-off-by: Juan Quintela <quintela@redhat.com>

OK, similar to send.


Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  migration/ram.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/migration/ram.c b/migration/ram.c
> index 87bb7da8e2..eb6716710e 100644
> --- a/migration/ram.c
> +++ b/migration/ram.c
> @@ -677,6 +677,8 @@ typedef struct {
>      QemuMutex mutex;
>      /* is this channel thread running */
>      bool running;
> +    /* should this thread finish */
> +    bool quit;
>      /* array of pages to receive */
>      MultiFDPages_t *pages;
>      /* packet allocated len */
> @@ -1266,6 +1268,7 @@ static void multifd_recv_terminate_threads(Error *err)
>          MultiFDRecvParams *p = &multifd_recv_state->params[i];
>  
>          qemu_mutex_lock(&p->mutex);
> +        p->quit = true;
>          /* We could arrive here for two reasons:
>             - normal quit, i.e. everything went fine, just finished
>             - error quit: We close the channels so the channel threads
> @@ -1288,6 +1291,7 @@ int multifd_load_cleanup(Error **errp)
>          MultiFDRecvParams *p = &multifd_recv_state->params[i];
>  
>          if (p->running) {
> +            p->quit = true;
>              qemu_thread_join(&p->thread);
>          }
>          object_unref(OBJECT(p->c));
> @@ -1351,6 +1355,10 @@ static void *multifd_recv_thread(void *opaque)
>          uint32_t used;
>          uint32_t flags;
>  
> +        if (p->quit) {
> +            break;
> +        }
> +
>          ret = qio_channel_read_all_eof(p->c, (void *)p->packet,
>                                         p->packet_len, &local_err);
>          if (ret == 0) {   /* EOF */
> @@ -1422,6 +1430,7 @@ int multifd_load_setup(void)
>  
>          qemu_mutex_init(&p->mutex);
>          qemu_sem_init(&p->sem_sync, 0);
> +        p->quit = false;
>          p->id = i;
>          p->pages = multifd_pages_init(page_count);
>          p->packet_len = sizeof(MultiFDPacket_t)
> -- 
> 2.21.0
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
