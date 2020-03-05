Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AED217A3BD
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 12:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgCELKj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 06:10:39 -0500
Received: from foss.arm.com ([217.140.110.172]:47210 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgCELKj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 06:10:39 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 33FA831B;
        Thu,  5 Mar 2020 03:10:38 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C02B33F6C4;
        Thu,  5 Mar 2020 03:10:36 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 8/9] arm: gic: Provide per-IRQ helper
 functions
To:     Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        peter.maydell@linaro.org, andrew.murray@arm.com,
        andre.przywara@arm.com
References: <20200130112510.15154-1-eric.auger@redhat.com>
 <20200130112510.15154-9-eric.auger@redhat.com>
 <20200305095529.hkdyhghkofquat75@kamzik.brq.redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <80417be0-b897-2e09-ad56-05ae6b6a5fd6@arm.com>
Date:   Thu, 5 Mar 2020 11:10:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200305095529.hkdyhghkofquat75@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I'm going to reiterate the comments I posted on this exact same patch sent by
Andre [1], and add a few new ones.

[1] https://www.spinics.net/lists/arm-kernel/msg767690.html

On 3/5/20 9:55 AM, Andrew Jones wrote:
> On Thu, Jan 30, 2020 at 12:25:09PM +0100, Eric Auger wrote:
>> From: Andre Przywara <andre.przywara@arm.com>
>>
>> A common theme when accessing per-IRQ parameters in the GIC distributor
>> is to set fields of a certain bit width in a range of MMIO registers.
>> Examples are the enabled status (one bit per IRQ), the level/edge
>> configuration (2 bits per IRQ) or the priority (8 bits per IRQ).
>>
>> Add a generic helper function which is able to mask and set the
>> respective number of bits, given the IRQ number and the MMIO offset.
>> Provide wrappers using this function to easily allow configuring an IRQ.
>>
>> For now assume that private IRQ numbers always refer to the current CPU.
>> In a GICv2 accessing the "other" private IRQs is not easily doable (the
>> registers are banked per CPU on the same MMIO address), so we impose the
>> same limitation on GICv3, even though those registers are not banked
>> there anymore.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> Missing Eric's s-b.
>
>> ---
>>
>> initialize reg
>> ---
>>  lib/arm/asm/gic-v3.h |  2 +
>>  lib/arm/asm/gic.h    |  9 +++++
>>  lib/arm/gic.c        | 90 ++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 101 insertions(+)
>>
>> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
>> index 347be2f..4a445a5 100644
>> --- a/lib/arm/asm/gic-v3.h
>> +++ b/lib/arm/asm/gic-v3.h
>> @@ -23,6 +23,8 @@
>>  #define GICD_CTLR_ENABLE_G1A		(1U << 1)
>>  #define GICD_CTLR_ENABLE_G1		(1U << 0)
>>  
>> +#define GICD_IROUTER			0x6000
>> +
>>  /* Re-Distributor registers, offsets from RD_base */
>>  #define GICR_TYPER			0x0008
>>  
>> diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
>> index 1fc10a0..21cdb58 100644
>> --- a/lib/arm/asm/gic.h
>> +++ b/lib/arm/asm/gic.h
>> @@ -15,6 +15,7 @@
>>  #define GICD_IIDR			0x0008
>>  #define GICD_IGROUPR			0x0080
>>  #define GICD_ISENABLER			0x0100
>> +#define GICD_ICENABLER			0x0180
>>  #define GICD_ISPENDR			0x0200
>>  #define GICD_ICPENDR			0x0280
>>  #define GICD_ISACTIVER			0x0300
>> @@ -73,5 +74,13 @@ extern void gic_write_eoir(u32 irqstat);
>>  extern void gic_ipi_send_single(int irq, int cpu);
>>  extern void gic_ipi_send_mask(int irq, const cpumask_t *dest);
>>  
>> +void gic_set_irq_bit(int irq, int offset);
>> +void gic_enable_irq(int irq);
>> +void gic_disable_irq(int irq);
>> +void gic_set_irq_priority(int irq, u8 prio);
>> +void gic_set_irq_target(int irq, int cpu);
>> +void gic_set_irq_group(int irq, int group);
>> +int gic_get_irq_group(int irq);
>> +
>>  #endif /* !__ASSEMBLY__ */
>>  #endif /* _ASMARM_GIC_H_ */
>> diff --git a/lib/arm/gic.c b/lib/arm/gic.c
>> index 9430116..aa9cb86 100644
>> --- a/lib/arm/gic.c
>> +++ b/lib/arm/gic.c
>> @@ -146,3 +146,93 @@ void gic_ipi_send_mask(int irq, const cpumask_t *dest)
>>  	assert(gic_common_ops && gic_common_ops->ipi_send_mask);
>>  	gic_common_ops->ipi_send_mask(irq, dest);
>>  }
>> +
>> +enum gic_bit_access {
>> +	ACCESS_READ,
>> +	ACCESS_SET,
>> +	ACCESS_RMW
>> +};
>> +
>> +static u8 gic_masked_irq_bits(int irq, int offset, int bits, u8 value,
>> +			      enum gic_bit_access access)
>> +{
>> +	void *base;
>> +	int split = 32 / bits;
>> +	int shift = (irq % split) * bits;
>> +	u32 reg = 0, mask = ((1U << bits) - 1) << shift;
>> +
>> +	switch (gic_version()) {
>> +	case 2:
>> +		base = gicv2_dist_base();
>> +		break;
>> +	case 3:
>> +		if (irq < 32)
>> +			base = gicv3_sgi_base();
>> +		else
>> +			base = gicv3_dist_base();
>> +		break;
>> +	default:
>> +		return 0;
>> +	}
>> +	base += offset + (irq / split) * 4;
>> +
>> +	switch (access) {
>> +	case ACCESS_READ:
>> +		return (readl(base) & mask) >> shift;
>> +	case ACCESS_SET:
>> +		reg = 0;
>> +		break;
>> +	case ACCESS_RMW:
>> +		reg = readl(base) & ~mask;
>> +		break;
>> +	}
>> +
>> +	writel(reg | ((u32)value << shift), base);
>> +
>> +	return 0;
>> +}

This function looks a bit out of place:
- the function name has a verb in the past tense ('masked'), which makes me think
it should return a bool, but the function actually performs an access to a GIC
register.
- the return value is an u8, but it returns an u32 on a read, because readl
returns an u32.
- the semantics of the function and the return value change based on the access
parameter; worse yet, the return value on a write is completely ignored by the
callers and the value parameter is ignored on reads.

And a few new niggles:
- the accessor functions are hard to read: git_masked_irq_bits(irq, offset, 1, 1, ACCESS_SET). What the 1's represent is not obvious without reading the gic_masked_irq_bits functions.
- Andrew introduced a function to check the IRQ state at the GIC level [2]. The function is clear and nice to read because it has no indirection. How about we follow this pattern for all the accessors below and we remove the calls to gic_masked_irq_bits entirely? 

[2] https://www.spinics.net/lists/kvm/msg207073.html

Thanks,
Alex

>> +
>> +void gic_set_irq_bit(int irq, int offset)
>> +{
>> +	gic_masked_irq_bits(irq, offset, 1, 1, ACCESS_SET);
>> +}
>> +
>> +void gic_enable_irq(int irq)
>> +{
>> +	gic_set_irq_bit(irq, GICD_ISENABLER);
>> +}
>> +
>> +void gic_disable_irq(int irq)
>> +{
>> +	gic_set_irq_bit(irq, GICD_ICENABLER);
>> +}
>> +
>> +void gic_set_irq_priority(int irq, u8 prio)
>> +{
>> +	gic_masked_irq_bits(irq, GICD_IPRIORITYR, 8, prio, ACCESS_RMW);
>> +}
>> +
>> +void gic_set_irq_target(int irq, int cpu)
>> +{
>> +	if (irq < 32)
>> +		return;
>> +
>> +	if (gic_version() == 2) {
>> +		gic_masked_irq_bits(irq, GICD_ITARGETSR, 8, 1U << cpu,
>> +				    ACCESS_RMW);
>> +
>> +		return;
>> +	}
>> +
>> +	writeq(cpus[cpu], gicv3_dist_base() + GICD_IROUTER + irq * 8);
>> +}
>> +
>> +void gic_set_irq_group(int irq, int group)
>> +{
>> +	gic_masked_irq_bits(irq, GICD_IGROUPR, 1, group, ACCESS_RMW);
>> +}
>> +
>> +int gic_get_irq_group(int irq)
>> +{
>> +	return gic_masked_irq_bits(irq, GICD_IGROUPR, 1, 0, ACCESS_READ);
>> +}
>> -- 
>> 2.20.1
>>
>>
> Looks good to me.
>
> Thanks,
> drew
>
