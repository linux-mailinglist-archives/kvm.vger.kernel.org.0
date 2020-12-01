Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6E72CA8BF
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 17:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403911AbgLAQty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 11:49:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35891 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387395AbgLAQty (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Dec 2020 11:49:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606841308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vpMhzaU2abbcao7cGimKKlT9EwdNIa/FDzsVcWgRAAE=;
        b=chPU6iMPsBOs7DFwX7h3BsqBkz1nORwyDhbdIm8hvd8fxhlqbRevd6Ymu8pFSfAUif22Un
        A94KztkvVZB2cX51cqhTEXPDY9QMJ+/DaOTzdSE1+pcyVBlsY0JNSuXeajjFxqqxOiLfZF
        IFZZDb3Fj+xDL7ZOC36Q6kCvOhJPsEA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-AXgftOptOn61Nf2UyWdK8A-1; Tue, 01 Dec 2020 11:48:24 -0500
X-MC-Unique: AXgftOptOn61Nf2UyWdK8A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 342AD100E421;
        Tue,  1 Dec 2020 16:48:23 +0000 (UTC)
Received: from [10.36.112.89] (ovpn-112-89.ams2.redhat.com [10.36.112.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CAA2660C17;
        Tue,  1 Dec 2020 16:48:21 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 04/10] arm/arm64: gic: Remove unnecessary
 synchronization with stats_reset()
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc:     andre.przywara@arm.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-5-alexandru.elisei@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <e7bd5d3a-831a-ba47-9fe3-b820c33e5972@redhat.com>
Date:   Tue, 1 Dec 2020 17:48:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201125155113.192079-5-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 11/25/20 4:51 PM, Alexandru Elisei wrote:
> The GICv3 driver executes a DSB barrier before sending an IPI, which
> ensures that memory accesses have completed. This removes the need to
> enforce ordering with respect to stats_reset() in the IPI handler.
> 
> For GICv2, we still need the DMB to ensure ordering between the read of the
> GICC_IAR MMIO register and the read from the acked array. It also matches
> what the Linux GICv2 driver does in gic_handle_irq().
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/gic.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index 4e947e8516a2..7befda2a8673 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -60,7 +60,6 @@ static void stats_reset(void)
>  		bad_sender[i] = -1;
>  		bad_irq[i] = -1;
>  	}
> -	smp_wmb();
Here we are (pair removed). Still the one in check_acked still exists.
>  }
>  
>  static void check_acked(const char *testname, cpumask_t *mask)
> @@ -150,7 +149,13 @@ static void ipi_handler(struct pt_regs *regs __unused)
>  
>  	if (irqnr != GICC_INT_SPURIOUS) {
>  		gic_write_eoir(irqstat);
> -		smp_rmb(); /* pairs with wmb in stats_reset */
> +		/*
> +		 * Make sure data written before the IPI was triggered is
> +		 * observed after the IAR is read. Pairs with the smp_wmb
> +		 * when sending the IPI.
> +		 */
> +		if (gic_version() == 2)
> +			smp_rmb();
>  		++acked[smp_processor_id()];
>  		check_ipi_sender(irqstat);
>  		check_irqnr(irqnr);
> 
Thanks

Eric

