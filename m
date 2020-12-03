Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0162CD668
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 14:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388080AbgLCNLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 08:11:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51808 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726302AbgLCNLf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 08:11:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607001009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LwgoOs5E5Ovcg2MMucVFYdx7gaKmgNlB/n+8+BKw/wI=;
        b=eewdk0iRHW+7/r3TEueJDmZfaQUCHPQyNiKjAcsU/nGeRiDURn+f7/PljC3rBg16DHJW91
        8q0I5vc3TmjNkazytpoLbHFRE75/iqDxDBWXeqPy4NxOz65KyYkNHlarGsNuXLt/E3yrMB
        K82UgHLRDJ6oZDUFxIPTKgrOG8QAO9A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-6HAakISzOAWgki1QiQGMzA-1; Thu, 03 Dec 2020 08:10:06 -0500
X-MC-Unique: 6HAakISzOAWgki1QiQGMzA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3ED621012E88;
        Thu,  3 Dec 2020 13:10:05 +0000 (UTC)
Received: from [10.36.112.89] (ovpn-112-89.ams2.redhat.com [10.36.112.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0FFDE18AD4;
        Thu,  3 Dec 2020 13:10:03 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 06/10] arm/arm64: gic: Check spurious and
 bad_sender in the active test
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc:     andre.przywara@arm.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-7-alexandru.elisei@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <71a4e466-657d-c2ad-e174-9e15f649243c@redhat.com>
Date:   Thu, 3 Dec 2020 14:10:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201125155113.192079-7-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 11/25/20 4:51 PM, Alexandru Elisei wrote:
> The gicv{2,3}-active test sends an IPI from the boot CPU to itself, then
> checks that the interrupt has been received as expected. The
> ipi_clear_active_handler() clears the active state of the interrupt with a
> write to the GICD_ICACTIVER register instead of writing the to EOI
> register.
> 
> When acknowledging the interrupt it is possible to get back an spurious
> interrupt ID (ID 1023), and the interrupt handler increments the number of
> spurious interrupts received on the current processor. However, this is not
> checked at the end of the test. Let's also check for spurious interrupts,
> like the IPI test does.
> 
> For IPIs on GICv2, the value returned by a read of the GICC_IAR register
> performed when acknowledging the interrupt also contains the sender CPU
> ID. Add a check for that too.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arm/gic.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index bcb834406d23..5727d72a0ef3 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -125,12 +125,12 @@ static void check_spurious(void)
>  	}
>  }
>  
> -static void check_ipi_sender(u32 irqstat)
> +static void check_ipi_sender(u32 irqstat, int sender)
>  {
>  	if (gic_version() == 2) {
>  		int src = (irqstat >> 10) & 7;
>  
> -		if (src != IPI_SENDER)
> +		if (src != sender)
>  			bad_sender[smp_processor_id()] = src;
>  	}
>  }
> @@ -155,7 +155,7 @@ static void ipi_handler(struct pt_regs *regs __unused)
>  		 */
>  		if (gic_version() == 2)
>  			smp_rmb();
> -		check_ipi_sender(irqstat);
> +		check_ipi_sender(irqstat, IPI_SENDER);
>  		check_irqnr(irqnr);
>  		smp_wmb(); /* pairs with smp_rmb in check_acked */
>  		++acked[smp_processor_id()];
> @@ -382,6 +382,7 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
>  
>  		writel(val, base + GICD_ICACTIVER);
>  
> +		check_ipi_sender(irqstat, smp_processor_id());
>  		check_irqnr(irqnr);
>  		++acked[smp_processor_id()];
>  	} else {
> @@ -394,6 +395,7 @@ static void run_active_clear_test(void)
>  	report_prefix_push("active");
>  	setup_irq(ipi_clear_active_handler);
>  	ipi_test_self();
> +	check_spurious();
>  	report_prefix_pop();
>  }
>  
> 

