Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD1F1D4D1A
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 13:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgEOL5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 07:57:33 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36389 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726047AbgEOL5d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 07:57:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589543851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aUH+TtwSJFbCU3USF38P3lC5oZW0dOM6MBq1iuuUyrA=;
        b=DI1b97D1D7lcsF5uulhxYcLZvQHg2Qly6ldZwFHqBUz2S0sN0SwJ620gmHH9E4EJqfQC1S
        pFU1g0UvieI2+yRPPT4oP7L9JzRY4HHXJfSkx28/4s5Fl3eb9ukAuYCWN1F+30oeHw/2UD
        YcyRngQZMWjUp7KTgDJELrvA2Jp7c28=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-B_J2d5_RO2ig6l7tRXwB0w-1; Fri, 15 May 2020 07:57:29 -0400
X-MC-Unique: B_J2d5_RO2ig6l7tRXwB0w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6BD7107ACCD;
        Fri, 15 May 2020 11:57:28 +0000 (UTC)
Received: from work-vm (ovpn-114-149.ams2.redhat.com [10.36.114.149])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C97D660F8D;
        Fri, 15 May 2020 11:57:17 +0000 (UTC)
Date:   Fri, 15 May 2020 12:57:14 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v1 03/17] accel/kvm: Convert to
 ram_block_discard_set_broken()
Message-ID: <20200515115714.GC2954@work-vm>
References: <20200506094948.76388-1-david@redhat.com>
 <20200506094948.76388-4-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506094948.76388-4-david@redhat.com>
User-Agent: Mutt/1.13.4 (2020-02-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* David Hildenbrand (david@redhat.com) wrote:
> Discarding memory does not work as expected. At the time this is called,
> we cannot have anyone active that relies on discards to work properly.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  accel/kvm/kvm-all.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 439a4efe52..33421184ac 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -40,7 +40,6 @@
>  #include "trace.h"
>  #include "hw/irq.h"
>  #include "sysemu/sev.h"
> -#include "sysemu/balloon.h"
>  #include "qapi/visitor.h"
>  #include "qapi/qapi-types-common.h"
>  #include "qapi/qapi-visit-common.h"
> @@ -2107,7 +2106,7 @@ static int kvm_init(MachineState *ms)
>  
>      s->sync_mmu = !!kvm_vm_check_extension(kvm_state, KVM_CAP_SYNC_MMU);
>      if (!s->sync_mmu) {
> -        qemu_balloon_inhibit(true);
> +        g_assert(ram_block_discard_set_broken(true));
>      }
>  
>      return 0;
> -- 
> 2.25.3
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

