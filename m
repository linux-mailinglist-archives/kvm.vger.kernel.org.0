Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6A52DE252
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 13:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgLRMFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 07:05:13 -0500
Received: from foss.arm.com ([217.140.110.172]:34090 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726561AbgLRMFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Dec 2020 07:05:13 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78AAD101E;
        Fri, 18 Dec 2020 04:04:27 -0800 (PST)
Received: from [192.168.2.22] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A0A1E3F66E;
        Fri, 18 Dec 2020 04:04:26 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 03/12] arm/arm64: gic: Remove SMP
 synchronization from ipi_clear_active_handler()
To:     Alexandru Elisei <alexandru.elisei@arm.com>, drjones@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     eric.auger@redhat.com, yuzenghui@huawei.com
References: <20201217141400.106137-1-alexandru.elisei@arm.com>
 <20201217141400.106137-4-alexandru.elisei@arm.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Organization: ARM Ltd.
Message-ID: <b928a9ea-4104-b867-d140-3fe80816128e@arm.com>
Date:   Fri, 18 Dec 2020 12:04:11 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201217141400.106137-4-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/12/2020 14:13, Alexandru Elisei wrote:
> The gicv{2,3}-active test sends an IPI from the boot CPU to itself, then
> checks that the interrupt has been received as expected. There is no need
> to use inter-processor memory synchronization primitives on code that runs
> on the same CPU, so remove the unneeded memory barriers.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

I am not fully convinced this is a wise move. Indeed the existing
barriers look wrong, and *currently* we just use
ipi_clear_active_handler() for a single CPU test only, but the handler
function itself is not restricted to that use case, if I am not mistaken.
But I think for now this fix is fine, and the comment should point out
the limitation well enough, so:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre


> ---
>  arm/gic.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index ca61dba2986c..1c9f4a01b6e4 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -364,6 +364,7 @@ static struct gic gicv3 = {
>  	},
>  };
>  
> +/* Runs on the same CPU as the sender, no need for memory synchronization */
>  static void ipi_clear_active_handler(struct pt_regs *regs __unused)
>  {
>  	u32 irqstat = gic_read_iar();
> @@ -380,13 +381,10 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
>  
>  		writel(val, base + GICD_ICACTIVER);
>  
> -		smp_rmb(); /* pairs with wmb in stats_reset */
>  		++acked[smp_processor_id()];
>  		check_irqnr(irqnr);
> -		smp_wmb(); /* pairs with rmb in check_acked */
>  	} else {
>  		++spurious[smp_processor_id()];
> -		smp_wmb();
>  	}
>  }
>  
> 

