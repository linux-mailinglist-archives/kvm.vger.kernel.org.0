Return-Path: <kvm+bounces-69240-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sLh+GI6qeGl9rwEAu9opvQ
	(envelope-from <kvm+bounces-69240-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 13:07:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C06A79406E
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 13:07:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 099F3302FAA5
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 12:07:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40CCA34B40F;
	Tue, 27 Jan 2026 12:07:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A04913101BB
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 12:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769515644; cv=none; b=cFLPaWy1q8U9gpgENG1n/GJx6LCXE3+7rZrxK98exKcJhxFQJg4WzQ6UJ9fhVIveelwADCEngFpCiu68UxJzV/uO/Vro8QHZT0a+wcE7BXWYDVoP6TAKKCIsg2AtBCOodIfj8V13SA2b+O4HDcunkV5p1GBQ30k0sZkRANjzik0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769515644; c=relaxed/simple;
	bh=pbhI8i3o45XB6gQAhZmwhKFiQPOdFU7tvfbEsAAHnE4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=TFErgLfiteiBy73X2DZO+jWCANccKZPRirIIufYO+cppOd4/ZCQTZRodgutkLtHU3nFjfMTwlSKpSXbAa3rO6xlzfhZSvlqP16fXoo8pNq5D05T04a/nOJjcaRdElYjHB60jroWBlRROzzf21BpRaYkG60WR4+TtaF5XMWBvWOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 062D81595;
	Tue, 27 Jan 2026 04:07:15 -0800 (PST)
Received: from [10.33.46.47] (unknown [10.33.46.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 65E113F73F;
	Tue, 27 Jan 2026 04:07:20 -0800 (PST)
Message-ID: <8db77da0-4772-499d-b140-350e4470e30d@arm.com>
Date: Tue, 27 Jan 2026 12:07:17 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH kvmtool v5 3/7] arm64: nested: Add support for setting
 maintenance IRQ
To: Marc Zyngier <maz@kernel.org>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>,
 Will Deacon <will@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Sascha Bischoff <sascha.bischoff@arm.com>
References: <20260123142729.604737-1-andre.przywara@arm.com>
 <20260123142729.604737-4-andre.przywara@arm.com>
 <86fr7sb69h.wl-maz@kernel.org>
Content-Language: en-US
In-Reply-To: <86fr7sb69h.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.org,vger.kernel.org,lists.linux.dev,arm.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69240-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andre.przywara@arm.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-0.971];
	RCPT_COUNT_SEVEN(0.00)[7];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:mid,arm.com:email]
X-Rspamd-Queue-Id: C06A79406E
X-Rspamd-Action: no action

Hi Marc,

On 26/01/2026 18:03, Marc Zyngier wrote:
> On Fri, 23 Jan 2026 14:27:25 +0000,
> Andre Przywara <andre.przywara@arm.com> wrote:
>>
>> Uses the new VGIC KVM device attribute to set the maintenance IRQ.
>> This is fixed to use PPI 9, as a platform decision made by kvmtool,
>> matching the SBSA recommendation.
>> Use the opportunity to pass the kvm pointer to gic__generate_fdt_nodes(),
>> as this simplifies the call and allows us access to the nested_virt
>> config variable on the way.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>   arm64/arm-cpu.c         |  2 +-
>>   arm64/gic.c             | 29 +++++++++++++++++++++++++++--
>>   arm64/include/kvm/gic.h |  2 +-
>>   3 files changed, 29 insertions(+), 4 deletions(-)
>>
>> diff --git a/arm64/arm-cpu.c b/arm64/arm-cpu.c
>> index 69bb2cb2..0843ac05 100644
>> --- a/arm64/arm-cpu.c
>> +++ b/arm64/arm-cpu.c
>> @@ -14,7 +14,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
>>   {
>>   	int timer_interrupts[4] = {13, 14, 11, 10};
>>   
>> -	gic__generate_fdt_nodes(fdt, kvm->cfg.arch.irqchip);
>> +	gic__generate_fdt_nodes(fdt, kvm);
>>   	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
>>   	pmu__generate_fdt_nodes(fdt, kvm);
>>   }
>> diff --git a/arm64/gic.c b/arm64/gic.c
>> index b0d3a1ab..2a595184 100644
>> --- a/arm64/gic.c
>> +++ b/arm64/gic.c
>> @@ -11,6 +11,8 @@
>>   
>>   #define IRQCHIP_GIC 0
>>   
>> +#define GIC_MAINT_IRQ	9
>> +
>>   static int gic_fd = -1;
>>   static u64 gic_redists_base;
>>   static u64 gic_redists_size;
>> @@ -302,10 +304,15 @@ static int gic__init_gic(struct kvm *kvm)
>>   
>>   	int lines = irq__get_nr_allocated_lines();
>>   	u32 nr_irqs = ALIGN(lines, 32) + GIC_SPI_IRQ_BASE;
>> +	u32 maint_irq = GIC_PPI_IRQ_BASE + GIC_MAINT_IRQ;
>>   	struct kvm_device_attr nr_irqs_attr = {
>>   		.group	= KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
>>   		.addr	= (u64)(unsigned long)&nr_irqs,
>>   	};
>> +	struct kvm_device_attr maint_irq_attr = {
>> +		.group	= KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ,
>> +		.addr	= (u64)(unsigned long)&maint_irq,
>> +	};
>>   	struct kvm_device_attr vgic_init_attr = {
>>   		.group	= KVM_DEV_ARM_VGIC_GRP_CTRL,
>>   		.attr	= KVM_DEV_ARM_VGIC_CTRL_INIT,
>> @@ -325,6 +332,16 @@ static int gic__init_gic(struct kvm *kvm)
>>   			return ret;
>>   	}
>>   
>> +	if (kvm->cfg.arch.nested_virt) {
>> +		ret = ioctl(gic_fd, KVM_HAS_DEVICE_ATTR, &maint_irq_attr);
>> +		if (!ret)
>> +			ret = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &maint_irq_attr);
>> +		if (ret) {
>> +			pr_err("could not set maintenance IRQ\n");
>> +			return ret;
>> +		}
>> +	}
>> +
>>   	irq__routing_init(kvm);
>>   
>>   	if (!ioctl(gic_fd, KVM_HAS_DEVICE_ATTR, &vgic_init_attr)) {
>> @@ -342,7 +359,7 @@ static int gic__init_gic(struct kvm *kvm)
>>   }
>>   late_init(gic__init_gic)
>>   
>> -void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
>> +void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
>>   {
>>   	const char *compatible, *msi_compatible = NULL;
>>   	u64 msi_prop[2];
>> @@ -350,8 +367,12 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
>>   		cpu_to_fdt64(ARM_GIC_DIST_BASE), cpu_to_fdt64(ARM_GIC_DIST_SIZE),
>>   		0, 0,				/* to be filled */
>>   	};
>> +	u32 maint_irq[] = {
>> +		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI), cpu_to_fdt32(GIC_MAINT_IRQ),
>> +		gic__get_fdt_irq_cpumask(kvm) | IRQ_TYPE_LEVEL_HIGH
>> +	};
> 
> This looks utterly broken, and my guests barf on this:
> 
>          intc {
>                  compatible = "arm,gic-v3";
>                  #interrupt-cells = <0x03>;
>                  interrupt-controller;
>                  reg = <0x00 0x3fff0000 0x00 0x10000 0x00 0x3fef0000 0x00 0x100000>;
>                  interrupts = <0x01 0x09 0x4000000>;

Ah yeah, sorry, that's of course complete blunder, this got lost in 
translation between v3 and v4.
                                           ^^^^^^^^^^^
> Are you testing on a big-endian box??? I fixed it with the patchlet
> below, but I also wonder why you added gic__get_fdt_irq_cpumask()...

this was to accommodate GICv2 (it returns 0 for GICv3), and was the 
equivalent of the hardcoded 0xff04 we had before. And though I guess 
there would be no overlap between machines supporting nested virt and 
having a GICv2 or a GICv2 emulation capable GICv3, I added this for the 
sake of completeness anyway, as it didn't feel right to make this 
assumption in the otherwise generic code.

Consider this fixed.

Cheers,
Andre

> 
> 	M.
> 
> diff --git a/arm64/gic.c b/arm64/gic.c
> index 2a59518..640ff35 100644
> --- a/arm64/gic.c
> +++ b/arm64/gic.c
> @@ -369,7 +369,7 @@ void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
>   	};
>   	u32 maint_irq[] = {
>   		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI), cpu_to_fdt32(GIC_MAINT_IRQ),
> -		gic__get_fdt_irq_cpumask(kvm) | IRQ_TYPE_LEVEL_HIGH
> +		cpu_to_fdt32(gic__get_fdt_irq_cpumask(kvm) | IRQ_TYPE_LEVEL_HIGH),
>   	};
>   
>   	switch (kvm->cfg.arch.irqchip) {
> 


