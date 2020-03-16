Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8260D1874EF
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 22:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732741AbgCPVnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 17:43:31 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:42690 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732714AbgCPVnb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 17:43:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584395009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Miipgu0UxsqEQXnuF5qqtIQaGQJVXJmSSN/HUx7b+p4=;
        b=dhn6D3yUF0zS0DaQWmzj2S5JwF3bubSx7YC+b4KVg02nH4iagvyqc+z5AWiNXGwQEPZTWQ
        WVvN5cUg6xoSACm7eVdvpttImK6xT+TAQOSY7X6ZrsPKL+aByfZqRWhoslRY2FpoiUhENV
        kvNKaQhmJjx5miYf1ghTywEBbiAaWwI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-fGRj8VcfN0-XHR6WqLS96A-1; Mon, 16 Mar 2020 17:43:25 -0400
X-MC-Unique: fGRj8VcfN0-XHR6WqLS96A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3843518A6ECD;
        Mon, 16 Mar 2020 21:43:23 +0000 (UTC)
Received: from [10.3.117.77] (ovpn-117-77.phx2.redhat.com [10.3.117.77])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DDD283AC;
        Mon, 16 Mar 2020 21:43:19 +0000 (UTC)
Subject: Re: [PATCH v5 11/23] irqchip/gic-v4.1: Plumb get/set_irqchip_state
 SGI callbacks
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-12-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <d6b95eeb-b1c7-802b-e29e-a6c6ecf9ea33@redhat.com>
Date:   Mon, 16 Mar 2020 22:43:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-12-maz@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 3/4/20 9:33 PM, Marc Zyngier wrote:
> To implement the get/set_irqchip_state callbacks (limited to the
> PENDING state), we have to use a particular set of hacks:
> 
> - Reading the pending state is done by using a pair of new redistributor
>   registers (GICR_VSGIR, GICR_VSGIPENDR), which allow the 16 interrupts
>   state to be retrieved.
> - Setting the pending state is done by generating it as we'd otherwise do
>   for a guest (writing to GITS_SGIR).
> - Clearing the pending state is done by emiting a VSGI command with the
emitting
>   "clear" bit set.
> 
> This requires some interesting locking though:
> - When talking to the redistributor, we must make sure that the VPE
>   affinity doesn't change, hence taking the VPE lock.
> - At the same time, we must ensure that nobody accesses the same
>   redistributor's GICR_VSGI*R registers for a different VPE, which
GICR_VSGIR
>   would corrupt the reading of the pending bits. We thus take the
>   per-RD spinlock. Much fun.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  drivers/irqchip/irq-gic-v3-its.c   | 73 ++++++++++++++++++++++++++++++
>  include/linux/irqchip/arm-gic-v3.h | 14 ++++++
>  2 files changed, 87 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index c93f178914ee..fb2b836c31ff 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -3962,11 +3962,84 @@ static int its_sgi_set_affinity(struct irq_data *d,
>  	return -EINVAL;
>  }
>  
> +static int its_sgi_set_irqchip_state(struct irq_data *d,
> +				     enum irqchip_irq_state which,
> +				     bool state)
> +{
> +	if (which != IRQCHIP_STATE_PENDING)
> +		return -EINVAL;
> +
> +	if (state) {
> +		struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
> +		struct its_node *its = find_4_1_its();
> +		u64 val;
> +
> +		val  = FIELD_PREP(GITS_SGIR_VPEID, vpe->vpe_id);
> +		val |= FIELD_PREP(GITS_SGIR_VINTID, d->hwirq);
> +		writeq_relaxed(val, its->sgir_base + GITS_SGIR - SZ_128K);
> +	} else {
> +		its_configure_sgi(d, true);
> +	}
> +
> +	return 0;
> +}
> +
> +static int its_sgi_get_irqchip_state(struct irq_data *d,
> +				     enum irqchip_irq_state which, bool *val)
> +{
> +	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
> +	void __iomem *base;
> +	unsigned long flags;
> +	u32 count = 1000000;	/* 1s! */
where does it come from? I did not find any info in the spec about this
delay.
> +	u32 status;
> +	int cpu;
> +
> +	if (which != IRQCHIP_STATE_PENDING)
> +		return -EINVAL;
> +
> +	/*
> +	 * Locking galore! We can race against two different events:
> +	 *
> +	 * - Concurent vPE affinity change: we must make sure it cannot
> +         *   happen, or we'll talk to the wrong redistributor. This is
> +         *   identical to what happens with vLPIs.
> +	 *
> +	 * - Concurrent VSGIPENDR access: As it involves accessing two
> +         *   MMIO registers, this must be made atomic one way or another.
> +	 */
> +	cpu = vpe_to_cpuid_lock(vpe, &flags);
> +	raw_spin_lock(&gic_data_rdist_cpu(cpu)->rd_lock);
> +	base = gic_data_rdist_cpu(cpu)->rd_base + SZ_128K;
> +	writel_relaxed(vpe->vpe_id, base + GICR_VSGIR);
> +	do {
> +		status = readl_relaxed(base + GICR_VSGIPENDR);
> +		if (!(status & GICR_VSGIPENDR_BUSY))
> +			goto out;
> +
> +		count--;
> +		if (!count) {
> +			pr_err_ratelimited("Unable to get SGI status\n");
> +			goto out;
> +		}
> +		cpu_relax();
> +		udelay(1);
> +	} while(count);
> +
> +out:
> +	raw_spin_unlock(&gic_data_rdist_cpu(cpu)->rd_lock);
> +	vpe_to_cpuid_unlock(vpe, flags);
> +	*val = !!(status & (1 << d->hwirq));
> +
> +	return 0;
cascade an error on timeout?
> +}
> +
>  static struct irq_chip its_sgi_irq_chip = {
>  	.name			= "GICv4.1-sgi",
>  	.irq_mask		= its_sgi_mask_irq,
>  	.irq_unmask		= its_sgi_unmask_irq,
>  	.irq_set_affinity	= its_sgi_set_affinity,
> +	.irq_set_irqchip_state	= its_sgi_set_irqchip_state,
> +	.irq_get_irqchip_state	= its_sgi_get_irqchip_state,
>  };
>  
>  static int its_sgi_irq_domain_alloc(struct irq_domain *domain,
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index fd3be49ac9a5..830d2abf14b3 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -345,6 +345,15 @@
>  #define GICR_VPENDBASER_4_1_VGRP1EN	(1ULL << 58)
>  #define GICR_VPENDBASER_4_1_VPEID	GENMASK_ULL(15, 0)
>  
> +#define GICR_VSGIR			0x0080
> +
> +#define GICR_VSGIR_VPEID		GENMASK(15, 0)
> +
> +#define GICR_VSGIPENDR			0x0088
> +
> +#define GICR_VSGIPENDR_BUSY		(1U << 31)
> +#define GICR_VSGIPENDR_PENDING		GENMASK(15, 0)
> +
>  /*
>   * ITS registers, offsets from ITS_base
>   */
> @@ -368,6 +377,11 @@
>  
>  #define GITS_TRANSLATER			0x10040
>  
> +#define GITS_SGIR			0x20020
> +
> +#define GITS_SGIR_VPEID			GENMASK_ULL(47, 32)
> +#define GITS_SGIR_VINTID		GENMASK_ULL(7, 0)
as spotted by Zenghui 3, 0
> +
>  #define GITS_CTLR_ENABLE		(1U << 0)
>  #define GITS_CTLR_ImDe			(1U << 1)
>  #define	GITS_CTLR_ITS_NUMBER_SHIFT	4
> 

Thanks

Eric

