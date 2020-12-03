Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1F92CD69D
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 14:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388397AbgLCNXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 08:23:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27447 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388022AbgLCNXE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 08:23:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607001697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=17TeDiAi7K0S6jRLyvG5tS2QR8aHxbPehr3O5F8cUhM=;
        b=OIXeNNWlmZWXlDIcna6USG9ZJi9YAOU85DIrWwmhso4fiS4LsNaNsqONnP7MtFU2Wwl3cQ
        iLZhDFkxYlx+flOzxtban3ec3TiMEego+xP6dptPfVI2a1GIrdGSfh5b/gfYH3dYZ1pM19
        0egntsJMDI/lQvP7xi7YbnesqaWLIwU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-cvC7Zs4DNKGhVXB9qF5XVQ-1; Thu, 03 Dec 2020 08:21:33 -0500
X-MC-Unique: cvC7Zs4DNKGhVXB9qF5XVQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F62AA0CA6;
        Thu,  3 Dec 2020 13:21:32 +0000 (UTC)
Received: from [10.36.112.89] (ovpn-112-89.ams2.redhat.com [10.36.112.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A97715D9CA;
        Thu,  3 Dec 2020 13:21:30 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 07/10] arm/arm64: gic: Wait for writes to
 acked or spurious to complete
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc:     andre.przywara@arm.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-8-alexandru.elisei@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <179b4f5f-8bdf-1922-f79a-930bde2ed103@redhat.com>
Date:   Thu, 3 Dec 2020 14:21:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201125155113.192079-8-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 11/25/20 4:51 PM, Alexandru Elisei wrote:
> The IPI test has two parts: in the first part, it tests that the sender CPU
> can send an IPI to itself (ipi_test_self()), and in the second part it
> sends interrupts to even-numbered CPUs (ipi_test_smp()). When acknowledging
> an interrupt, if we read back a spurious interrupt ID (1023), the handler
> increments the index in the static array spurious corresponding to the CPU
> ID that the handler is running on; if we get the expected interrupt ID, we
> increment the same index in the acked array.
> 
> Reads of the spurious and acked arrays are synchronized with writes
> performed before sending the IPI. The synchronization is done either in the
> IPI sender function (GICv3), either by creating a data dependency (GICv2).
> 
> At the end of the test, the sender CPU reads from the acked and spurious
> arrays to check against the expected behaviour. We need to make sure the
> that writes in ipi_handler() are observable by the sender CPU. Use a DSB
> ISHST to make sure that the writes have completed.
> 
> One might rightfully argue that there are no guarantees regarding when the
> DSB instruction completes, just like there are no guarantees regarding when
> the value is observed by the other CPUs. However, let's do our best and
> instruct the CPU to complete the memory access when we know that it will be
> needed.
> 
> We still need to follow the message passing pattern for the acked,
> respectively bad_irq and bad_sender, because DSB guarantees that all memory
> accesses that come before the barrier have completed, not that they have
> completed in program order.
I guess the removal of the smp_rmb in check_spurious should belong to
that patch?
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Besides, AFAIU

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  arm/gic.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index 5727d72a0ef3..544c283f5f47 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -161,8 +161,10 @@ static void ipi_handler(struct pt_regs *regs __unused)
>  		++acked[smp_processor_id()];
>  	} else {
>  		++spurious[smp_processor_id()];
> -		smp_wmb();
>  	}
> +
> +	/* Wait for writes to acked/spurious to complete */
> +	dsb(ishst);
>  }
>  
>  static void setup_irq(irq_handler_fn handler)
> 

