Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66B11DB8B4
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 17:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgETPxJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 11:53:09 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40951 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726596AbgETPxI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 11:53:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589989987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MWxes5zfMaG9o/8NEN/0d/Rm32meUmr2iQZPwMdi3lg=;
        b=jBdHwLzXf2D1d+8swKSSZ29XBhIOvKmhnTPnd/SmsmTA5X3jXIDGFKOl/Qfa145wb207hf
        CHjQho7IWSH/G7kBxu72bNW2AqlrTK8e0KCpw7P+3S+Nr5+5cfGf8PqhP8Ctb+TnrQMoek
        tKP4apx0A9eRUHjSD38RlHEmErCV4p8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-d951aKoFOkGPom9rMP8BQg-1; Wed, 20 May 2020 11:53:05 -0400
X-MC-Unique: d951aKoFOkGPom9rMP8BQg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4AA531005510;
        Wed, 20 May 2020 15:53:04 +0000 (UTC)
Received: from work-vm (ovpn-114-169.ams2.redhat.com [10.36.114.169])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A7C455D9E2;
        Wed, 20 May 2020 15:52:56 +0000 (UTC)
Date:   Wed, 20 May 2020 16:52:54 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Subject: Re: [PATCH v2 07/19] migration/rdma: Use ram_block_discard_disable()
Message-ID: <20200520155254.GE2820@work-vm>
References: <20200520123152.60527-1-david@redhat.com>
 <20200520123152.60527-8-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520123152.60527-8-david@redhat.com>
User-Agent: Mutt/1.13.4 (2020-02-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* David Hildenbrand (david@redhat.com) wrote:
> RDMA will pin all guest memory (as documented in docs/rdma.txt). We want
> to disable RAM block discards - however, to keep it simple use
> ram_block_discard_is_required() instead of inhibiting.
> 
> Note: It is not sufficient to limit disabling to pin_all. Even when only
> conditionally pinning 1 MB chunks, as soon as one page within such a
> chunk was discarded and one page not, the discarded pages will be pinned
> as well.
> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Juan Quintela <quintela@redhat.com>
> Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  migration/rdma.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/migration/rdma.c b/migration/rdma.c
> index 967fda5b0c..57e2cbc8ca 100644
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
> +    /* Avoid ram_block_discard_disable(), cannot change during migration. */
> +    if (ram_block_discard_is_required()) {
> +        error_setg(errp, "RDMA: cannot disable RAM discard");
> +        return;
> +    }
> +
> +    rdma = qemu_rdma_data_init(host_port, &local_err);
>      if (rdma == NULL) {
>          goto err;
>      }
> @@ -4065,10 +4072,17 @@ void rdma_start_outgoing_migration(void *opaque,
>                              const char *host_port, Error **errp)
>  {
>      MigrationState *s = opaque;
> -    RDMAContext *rdma = qemu_rdma_data_init(host_port, errp);
>      RDMAContext *rdma_return_path = NULL;
> +    RDMAContext *rdma;
>      int ret = 0;
>  
> +    /* Avoid ram_block_discard_disable(), cannot change during migration. */
> +    if (ram_block_discard_is_required()) {
> +        error_setg(errp, "RDMA: cannot disable RAM discard");
> +        return;
> +    }
> +
> +    rdma = qemu_rdma_data_init(host_port, errp);
>      if (rdma == NULL) {
>          goto err;
>      }
> -- 
> 2.25.4
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

