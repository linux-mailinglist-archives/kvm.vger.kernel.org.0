Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7FF1D4DF6
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 14:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgEOMpT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 08:45:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55733 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726122AbgEOMpS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 08:45:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589546717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H87g0Tj+TOSKAiDl3QcQhSylCj8jOchmaFTlfTy2Rvk=;
        b=DikEfFCQwqLxwV/LeFroS2tLCf0YGQI+gBHgY9d+syXYdvEiea8Gtnut55uYYKzU4BHNXY
        AVIGsTNl8+HIy5dJlslKziPdWzbgxclTq9KTwVYOPU5y+O1i5rw8YLKxhaUYfkjKwTa/Ub
        4sXpF5zASwYDrJ7uyfubiVIbAsVG1oc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-bBH6pIYQNVWvADNZeh7MPA-1; Fri, 15 May 2020 08:45:13 -0400
X-MC-Unique: bBH6pIYQNVWvADNZeh7MPA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28D5F19200DD;
        Fri, 15 May 2020 12:45:12 +0000 (UTC)
Received: from work-vm (ovpn-114-149.ams2.redhat.com [10.36.114.149])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DA5E2E16D;
        Fri, 15 May 2020 12:45:03 +0000 (UTC)
Date:   Fri, 15 May 2020 13:45:01 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Subject: Re: [PATCH v1 07/17] migration/rdma: Use
 ram_block_discard_set_broken()
Message-ID: <20200515124501.GE2954@work-vm>
References: <20200506094948.76388-1-david@redhat.com>
 <20200506094948.76388-8-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506094948.76388-8-david@redhat.com>
User-Agent: Mutt/1.13.4 (2020-02-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* David Hildenbrand (david@redhat.com) wrote:
> RDMA will pin all guest memory (as documented in docs/rdma.txt). We want
> to mark RAM block discards to be broken - however, to keep it simple
> use ram_block_discard_is_required() instead of inhibiting.

Should this be dependent on whether rdma->pin_all is set?
Even with !pin_all some will be pinned at any given time
(when it's registered with the rdma stack).

Dave

> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Juan Quintela <quintela@redhat.com>
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  migration/rdma.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/migration/rdma.c b/migration/rdma.c
> index f61587891b..029adbb950 100644
> --- a/migration/rdma.c
> +++ b/migration/rdma.c
> @@ -29,6 +29,7 @@
>  #include "qemu/sockets.h"
>  #include "qemu/bitmap.h"
>  #include "qemu/coroutine.h"
> +#include "exec/memory.h"
>  #include <sys/socket.h>
>  #include <netdb.h>
>  #include <arpa/inet.h>
> @@ -4017,8 +4018,14 @@ void rdma_start_incoming_migration(const char *host_port, Error **errp)
>      Error *local_err = NULL;
>  
>      trace_rdma_start_incoming_migration();
> -    rdma = qemu_rdma_data_init(host_port, &local_err);
>  
> +    /* Avoid ram_block_discard_set_broken(), cannot change during migration. */
> +    if (ram_block_discard_is_required()) {
> +        error_setg(errp, "RDMA: cannot set discarding of RAM broken");
> +        return;
> +    }
> +
> +    rdma = qemu_rdma_data_init(host_port, &local_err);
>      if (rdma == NULL) {
>          goto err;
>      }
> @@ -4064,10 +4071,17 @@ void rdma_start_outgoing_migration(void *opaque,
>                              const char *host_port, Error **errp)
>  {
>      MigrationState *s = opaque;
> -    RDMAContext *rdma = qemu_rdma_data_init(host_port, errp);
>      RDMAContext *rdma_return_path = NULL;
> +    RDMAContext *rdma;
>      int ret = 0;
>  
> +    /* Avoid ram_block_discard_set_broken(), cannot change during migration. */
> +    if (ram_block_discard_is_required()) {
> +        error_setg(errp, "RDMA: cannot set discarding of RAM broken");
> +        return;
> +    }
> +
> +    rdma = qemu_rdma_data_init(host_port, errp);
>      if (rdma == NULL) {
>          goto err;
>      }
> -- 
> 2.25.3
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

