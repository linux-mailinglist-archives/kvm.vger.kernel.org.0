Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09392DE248
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 13:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgLRMEs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 07:04:48 -0500
Received: from foss.arm.com ([217.140.110.172]:34068 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726519AbgLRMEr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Dec 2020 07:04:47 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DADA71FB;
        Fri, 18 Dec 2020 04:04:01 -0800 (PST)
Received: from [192.168.2.22] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D65823F66E;
        Fri, 18 Dec 2020 04:04:00 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 01/12] lib: arm/arm64: gicv3: Add
 missing barrier when sending IPIs
To:     Alexandru Elisei <alexandru.elisei@arm.com>, drjones@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     eric.auger@redhat.com, yuzenghui@huawei.com
References: <20201217141400.106137-1-alexandru.elisei@arm.com>
 <20201217141400.106137-2-alexandru.elisei@arm.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Organization: ARM Ltd.
Message-ID: <911a9bfb-061c-69b7-1915-1877f1898e55@arm.com>
Date:   Fri, 18 Dec 2020 12:03:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201217141400.106137-2-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/12/2020 14:13, Alexandru Elisei wrote:
> One common usage for IPIs is for one CPU to write to a shared memory
> location, send the IPI to kick another CPU, and the receiver to read from
> the same location. Proper synchronization is needed to make sure that the
> IPI receiver reads the most recent value and not stale data (for example,
> the write from the sender CPU might still be in a store buffer).
> 
> For GICv3, IPIs are generated with a write to the ICC_SGI1R_EL1 register.
> To make sure the memory stores are observable by other CPUs, we need a
> wmb() barrier (DSB ST), which waits for stores to complete.
> 
> From the definition of DSB from ARM DDI 0487F.b, page B2-139:
> 
> "In addition, no instruction that appears in program order after the DSB
> instruction can alter any state of the system or perform any part of its
> functionality until the DSB completes other than:
> 
> - Being fetched from memory and decoded.
> - Reading the general-purpose, SIMD and floating-point, Special-purpose, or
> System registers that are directly or indirectly read without causing
> side-effects."
> 
> Similar definition for armv7 (ARM DDI 0406C.d, page A3-150).
> 
> The DSB instruction is enough to prevent reordering of the GIC register
> write which comes in program order after the memory access.
> 
> This also matches what the Linux GICv3 irqchip driver does (commit
> 21ec30c0ef52 ("irqchip/gic-v3: Use wmb() instead of smb_wmb() in
> gic_raise_softirq()")).
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Yes, makes sense. Also verified the references in both the ARM ARM and
the Linux code.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  lib/arm/gic-v3.c | 6 ++++++
>  arm/gic.c        | 5 +++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
> index a7e2cb819746..2c067e4e9ba2 100644
> --- a/lib/arm/gic-v3.c
> +++ b/lib/arm/gic-v3.c
> @@ -77,6 +77,12 @@ void gicv3_ipi_send_mask(int irq, const cpumask_t *dest)
>  
>  	assert(irq < 16);
>  
> +	/*
> +	 * Ensure stores to Normal memory are visible to other CPUs before
> +	 * sending the IPI.
> +	 */
> +	wmb();
> +
>  	/*
>  	 * For each cpu in the mask collect its peers, which are also in
>  	 * the mask, in order to form target lists.
> diff --git a/arm/gic.c b/arm/gic.c
> index acb060585fae..fee48f9b4ccb 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -275,6 +275,11 @@ static void gicv3_ipi_send_self(void)
>  
>  static void gicv3_ipi_send_broadcast(void)
>  {
> +	/*
> +	 * Ensure stores to Normal memory are visible to other CPUs before
> +	 * sending the IPI
> +	 */
> +	wmb();
>  	gicv3_write_sgi1r(1ULL << 40 | IPI_IRQ << 24);
>  	isb();
>  }
> 

