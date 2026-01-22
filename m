Return-Path: <kvm+bounces-68906-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2DJsOCFXcmlUiwAAu9opvQ
	(envelope-from <kvm+bounces-68906-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 17:58:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 210286A805
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 17:58:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B192A307F7CD
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 16:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 236A93542E7;
	Thu, 22 Jan 2026 15:54:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F298F1A9F88
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 15:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769097280; cv=none; b=GgE1nEvBndzX+y87yn8t+rTm1P1w/M4KgyNp4h7AT0FPGBHdjw2ZRcr55luSJ7RPLBoSkBBgfyAr+TavNyb0PoDgkxeodt0rCFkIdkOZlHgcAy+qG1NN6mtz2VJKsvIKbRFygtrHYEr+77fg3TGumgA0UY/9iiDXhyVwwgvSGwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769097280; c=relaxed/simple;
	bh=pmZ573aErmXEJQfvpdj39t6Luwct0Y4/EMwrSrD2q8g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OrIwL2Dyi5ibOpTrtlq/pZb2hspvH3GZFbSRjZ3h7V2XJn4ubXp0epCjkrcTD0o71Rf1Wf/F9WxwP5Cvc75QLEkP2AcC/7rVTuhCP8uW8gwqxgqt0h2vi+oh2hsCkTwZ+SZyCzDqm8EhSPTW1HeYKgPMIqK4NBawmeMg+WnxlW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9620B1476;
	Thu, 22 Jan 2026 07:54:21 -0800 (PST)
Received: from [10.1.39.184] (e134369.arm.com [10.1.39.184])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A3DC3F694;
	Thu, 22 Jan 2026 07:54:26 -0800 (PST)
Message-ID: <a8e44aea-89a3-40d0-82e8-295d5f315065@arm.com>
Date: Thu, 22 Jan 2026 15:54:24 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v4 3/7] arm64: nested: Add support for setting
 maintenance IRQ
To: Sascha Bischoff <Sascha.Bischoff@arm.com>,
 "will@kernel.org" <will@kernel.org>,
 "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>
Cc: "maz@kernel.org" <maz@kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 Alexandru Elisei <Alexandru.Elisei@arm.com>
References: <20250924134511.4109935-1-andre.przywara@arm.com>
 <20250924134511.4109935-4-andre.przywara@arm.com>
 <3d2a364595956d06624102684418bdad2a9d20b6.camel@arm.com>
Content-Language: en-US
From: Andre Przywara <andre.przywara@arm.com>
In-Reply-To: <3d2a364595956d06624102684418bdad2a9d20b6.camel@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-68906-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[arm.com,kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andre.przywara@arm.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	R_DKIM_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 210286A805
X-Rspamd-Action: no action

Hi Sascha,

many thanks for having a look!

On 16/01/2026 18:10, Sascha Bischoff wrote:
> On Wed, 2025-09-24 at 14:45 +0100, Andre Przywara wrote:
>> Uses the new VGIC KVM device attribute to set the maintenance IRQ.
>> This is fixed to use PPI 9, as a platform decision made by kvmtool,
>> matching the SBSA recommendation.
>> Use the opportunity to pass the kvm pointer to
>> gic__generate_fdt_nodes(),
>> as this simplifies the call and allows us access to the nested_virt
>> on
>> the way.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>   arm64/arm-cpu.c         |  2 +-
>>   arm64/gic.c             | 26 ++++++++++++++++++++++++--
>>   arm64/include/kvm/gic.h |  2 +-
>>   3 files changed, 26 insertions(+), 4 deletions(-)
>>
>> diff --git a/arm64/arm-cpu.c b/arm64/arm-cpu.c
>> index 69bb2cb2c..0843ac051 100644
>> --- a/arm64/arm-cpu.c
>> +++ b/arm64/arm-cpu.c
>> @@ -14,7 +14,7 @@ static void generate_fdt_nodes(void *fdt, struct
>> kvm *kvm)
>>   {
>>   	int timer_interrupts[4] = {13, 14, 11, 10};
>>   
>> -	gic__generate_fdt_nodes(fdt, kvm->cfg.arch.irqchip);
>> +	gic__generate_fdt_nodes(fdt, kvm);
>>   	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
>>   	pmu__generate_fdt_nodes(fdt, kvm);
>>   }
>> diff --git a/arm64/gic.c b/arm64/gic.c
>> index b0d3a1abb..e35986c06 100644
>> --- a/arm64/gic.c
>> +++ b/arm64/gic.c
>> @@ -11,6 +11,8 @@
>>   
>>   #define IRQCHIP_GIC 0
>>   
>> +#define GIC_MAINT_IRQ	9
>> +
>>   static int gic_fd = -1;
>>   static u64 gic_redists_base;
>>   static u64 gic_redists_size;
>> @@ -302,10 +304,15 @@ static int gic__init_gic(struct kvm *kvm)
>>   
>>   	int lines = irq__get_nr_allocated_lines();
>>   	u32 nr_irqs = ALIGN(lines, 32) + GIC_SPI_IRQ_BASE;
>> +	u32 maint_irq = GIC_PPI_IRQ_BASE + GIC_MAINT_IRQ;
>>   	struct kvm_device_attr nr_irqs_attr = {
>>   		.group	= KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
>>   		.addr	= (u64)(unsigned long)&nr_irqs,
>>   	};
>> +	struct kvm_device_attr maint_irq_attr = {
>> +		.group	= KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ,
>> +		.addr	= (u64)(unsigned long)&maint_irq,
>> +	};
>>   	struct kvm_device_attr vgic_init_attr = {
>>   		.group	= KVM_DEV_ARM_VGIC_GRP_CTRL,
>>   		.attr	= KVM_DEV_ARM_VGIC_CTRL_INIT,
>> @@ -325,6 +332,13 @@ static int gic__init_gic(struct kvm *kvm)
>>   			return ret;
>>   	}
>>   
>> +	if (kvm->cfg.arch.nested_virt &&
>> +	    !ioctl(gic_fd, KVM_HAS_DEVICE_ATTR, &maint_irq_attr)) {
>> +		ret = ioctl(gic_fd, KVM_SET_DEVICE_ATTR,
>> &maint_irq_attr);
>> +		if (ret)
>> +			return ret;
>> +	}
> 
> With GICv3 are things not a little broken if we're trying to do nested
> but don't have the ability to set the maint IRQ? It feels to me as if
> an error should be returned if the attr doesn't exist.

OK, I changed it slightly to return an error now if either the HAS call 
or the SET call fails.

> Also, the way that the FDT is generated means that we'd still generate
> the property for the maint IRQ, even if we can't set it here.

That should now be solved automatically, because the DT addition depends 
on --nested, but that fails above now if the kernel doesn't support the 
device ATTR.

Does that sound okay? Or do you want more refactoring to make things 
more explicit, to accommodate GICv5 better?

Cheers,
Andre

> 
> Thanks,
> Sascha
> 
>> +
>>   	irq__routing_init(kvm);
>>   
>>   	if (!ioctl(gic_fd, KVM_HAS_DEVICE_ATTR, &vgic_init_attr)) {
>> @@ -342,7 +356,7 @@ static int gic__init_gic(struct kvm *kvm)
>>   }
>>   late_init(gic__init_gic)
>>   
>> -void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
>> +void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
>>   {
>>   	const char *compatible, *msi_compatible = NULL;
>>   	u64 msi_prop[2];
>> @@ -350,8 +364,12 @@ void gic__generate_fdt_nodes(void *fdt, enum
>> irqchip_type type)
>>   		cpu_to_fdt64(ARM_GIC_DIST_BASE),
>> cpu_to_fdt64(ARM_GIC_DIST_SIZE),
>>   		0, 0,				/* to be filled */
>>   	};
>> +	u32 maint_irq[] = {
>> +		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
>> cpu_to_fdt32(GIC_MAINT_IRQ),
>> +		gic__get_fdt_irq_cpumask(kvm) | IRQ_TYPE_LEVEL_HIGH
>> +	};
>>   
>> -	switch (type) {
>> +	switch (kvm->cfg.arch.irqchip) {
>>   	case IRQCHIP_GICV2M:
>>   		msi_compatible = "arm,gic-v2m-frame";
>>   		/* fall-through */
>> @@ -377,6 +395,10 @@ void gic__generate_fdt_nodes(void *fdt, enum
>> irqchip_type type)
>>   	_FDT(fdt_property_cell(fdt, "#interrupt-cells",
>> GIC_FDT_IRQ_NUM_CELLS));
>>   	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
>>   	_FDT(fdt_property(fdt, "reg", reg_prop, sizeof(reg_prop)));
>> +	if (kvm->cfg.arch.nested_virt) {
>> +		_FDT(fdt_property(fdt, "interrupts", maint_irq,
>> +				  sizeof(maint_irq)));
>> +	}
>>   	_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_GIC));
>>   	_FDT(fdt_property_cell(fdt, "#address-cells", 2));
>>   	_FDT(fdt_property_cell(fdt, "#size-cells", 2));
>> diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
>> index ad8bcbf21..8490cca60 100644
>> --- a/arm64/include/kvm/gic.h
>> +++ b/arm64/include/kvm/gic.h
>> @@ -36,7 +36,7 @@ struct kvm;
>>   int gic__alloc_irqnum(void);
>>   int gic__create(struct kvm *kvm, enum irqchip_type type);
>>   int gic__create_gicv2m_frame(struct kvm *kvm, u64 msi_frame_addr);
>> -void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type);
>> +void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm);
>>   u32 gic__get_fdt_irq_cpumask(struct kvm *kvm);
>>   
>>   int gic__add_irqfd(struct kvm *kvm, unsigned int gsi, int
>> trigger_fd,
> 


