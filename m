Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A05318B150
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 11:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgCSK1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 06:27:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbgCSK1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 06:27:48 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F38A5206D7;
        Thu, 19 Mar 2020 10:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584613667;
        bh=uwoazedwTNP0+xIsOawzejd5iSeA0BwzwkyqJeruVqE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RkCD8EU7JV2FdgiasHUyA76NEFCRtSZNlIezGQCI0JeR1C3P0bTgIZMV/jJEofEz+
         alTAqUt2mV0EkoXDUnrrrSOBx8vcrswnCMUqqAdt4g0BWvgKRVRVA31AjrB/YcAAS1
         w8HvzmpttbnMQBxq0GkQgopeKhARA/Lh/HsH5ql8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jEsOu-00Dua1-W4; Thu, 19 Mar 2020 10:27:45 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 19 Mar 2020 10:27:44 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v5 11/23] irqchip/gic-v4.1: Plumb get/set_irqchip_state
 SGI callbacks
In-Reply-To: <d6b95eeb-b1c7-802b-e29e-a6c6ecf9ea33@redhat.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-12-maz@kernel.org>
 <d6b95eeb-b1c7-802b-e29e-a6c6ecf9ea33@redhat.com>
Message-ID: <6b2fec7cdc53536997edf4db971e1d47@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, rrichter@marvell.com, tglx@linutronix.de, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020-03-16 21:43, Auger Eric wrote:
> Hi Marc,
> 
> On 3/4/20 9:33 PM, Marc Zyngier wrote:
>> To implement the get/set_irqchip_state callbacks (limited to the
>> PENDING state), we have to use a particular set of hacks:
>> 
>> - Reading the pending state is done by using a pair of new 
>> redistributor
>>   registers (GICR_VSGIR, GICR_VSGIPENDR), which allow the 16 
>> interrupts
>>   state to be retrieved.
>> - Setting the pending state is done by generating it as we'd otherwise 
>> do
>>   for a guest (writing to GITS_SGIR).
>> - Clearing the pending state is done by emiting a VSGI command with 
>> the
> emitting
>>   "clear" bit set.
>> 
>> This requires some interesting locking though:
>> - When talking to the redistributor, we must make sure that the VPE
>>   affinity doesn't change, hence taking the VPE lock.
>> - At the same time, we must ensure that nobody accesses the same
>>   redistributor's GICR_VSGI*R registers for a different VPE, which
> GICR_VSGIR
>>   would corrupt the reading of the pending bits. We thus take the
>>   per-RD spinlock. Much fun.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  drivers/irqchip/irq-gic-v3-its.c   | 73 
>> ++++++++++++++++++++++++++++++
>>  include/linux/irqchip/arm-gic-v3.h | 14 ++++++
>>  2 files changed, 87 insertions(+)
>> 
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c 
>> b/drivers/irqchip/irq-gic-v3-its.c
>> index c93f178914ee..fb2b836c31ff 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -3962,11 +3962,84 @@ static int its_sgi_set_affinity(struct 
>> irq_data *d,
>>  	return -EINVAL;
>>  }
>> 
>> +static int its_sgi_set_irqchip_state(struct irq_data *d,
>> +				     enum irqchip_irq_state which,
>> +				     bool state)
>> +{
>> +	if (which != IRQCHIP_STATE_PENDING)
>> +		return -EINVAL;
>> +
>> +	if (state) {
>> +		struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
>> +		struct its_node *its = find_4_1_its();
>> +		u64 val;
>> +
>> +		val  = FIELD_PREP(GITS_SGIR_VPEID, vpe->vpe_id);
>> +		val |= FIELD_PREP(GITS_SGIR_VINTID, d->hwirq);
>> +		writeq_relaxed(val, its->sgir_base + GITS_SGIR - SZ_128K);
>> +	} else {
>> +		its_configure_sgi(d, true);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int its_sgi_get_irqchip_state(struct irq_data *d,
>> +				     enum irqchip_irq_state which, bool *val)
>> +{
>> +	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
>> +	void __iomem *base;
>> +	unsigned long flags;
>> +	u32 count = 1000000;	/* 1s! */
> where does it come from? I did not find any info in the spec about this
> delay.

There is no such thing in the spec. However, these timeouts have proven 
to be
very useful in detecting broken HW (I'm lucky enough to have such 
wonders
at hand...), as well as SW bugs. The ! second value is purely empirical
(if a whole second is not enough for things to move, they're as good as 
dead).

>> +	u32 status;
>> +	int cpu;
>> +
>> +	if (which != IRQCHIP_STATE_PENDING)
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * Locking galore! We can race against two different events:
>> +	 *
>> +	 * - Concurent vPE affinity change: we must make sure it cannot
>> +         *   happen, or we'll talk to the wrong redistributor. This 
>> is
>> +         *   identical to what happens with vLPIs.
>> +	 *
>> +	 * - Concurrent VSGIPENDR access: As it involves accessing two
>> +         *   MMIO registers, this must be made atomic one way or 
>> another.
>> +	 */
>> +	cpu = vpe_to_cpuid_lock(vpe, &flags);
>> +	raw_spin_lock(&gic_data_rdist_cpu(cpu)->rd_lock);
>> +	base = gic_data_rdist_cpu(cpu)->rd_base + SZ_128K;
>> +	writel_relaxed(vpe->vpe_id, base + GICR_VSGIR);
>> +	do {
>> +		status = readl_relaxed(base + GICR_VSGIPENDR);
>> +		if (!(status & GICR_VSGIPENDR_BUSY))
>> +			goto out;
>> +
>> +		count--;
>> +		if (!count) {
>> +			pr_err_ratelimited("Unable to get SGI status\n");
>> +			goto out;
>> +		}
>> +		cpu_relax();
>> +		udelay(1);
>> +	} while(count);
>> +
>> +out:
>> +	raw_spin_unlock(&gic_data_rdist_cpu(cpu)->rd_lock);
>> +	vpe_to_cpuid_unlock(vpe, flags);
>> +	*val = !!(status & (1 << d->hwirq));
>> +
>> +	return 0;
> cascade an error on timeout?

Sure, that's a good idea.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
