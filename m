Return-Path: <kvm+bounces-69816-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UO7oKLlmgGlA7wIAu9opvQ
	(envelope-from <kvm+bounces-69816-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 09:56:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CE17C9D49
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 09:56:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E08FC301F33D
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 08:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 316892C0272;
	Mon,  2 Feb 2026 08:54:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D547528B3E7
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 08:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770022462; cv=none; b=qa6jNMcLn2qvxBHEK4Y6CvINPjqo0cqELa4iB5iONoM+ZGfQ1SZq6reYetsYicSXeeq9z80N38kVDQVimFLSnpHI3KmG9j63nX9n9IUGZucT1MQ/+VvN/pIehaCmopimLh1/MdkhzxMY9agGpCRctNJ8Mytx5hhDDCYWInYg8xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770022462; c=relaxed/simple;
	bh=gDcDauHcfS9dj0xbn2kWtFMV6ayihwcDBnsbP4PskHo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LL3W6RA8IV+5eWdwPrhW3ESYkC3DThYAHP1YCs+mftE4uTD2G/v4U6mhLx65dmXiThxCjDvQP5HEPqJe7UXx7BSXRdKNkCemBur575BDtQRsuodawd0q/GYD0QbTmNHzsiA3/yDw5NJL2nwzPDBywJEKg0xZZ7XNrzWU05UquHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A20C339;
	Mon,  2 Feb 2026 00:54:14 -0800 (PST)
Received: from [192.168.178.72] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E19B53F740;
	Mon,  2 Feb 2026 00:54:18 -0800 (PST)
Message-ID: <32cdc804-9ba7-4400-9c93-e94c4b934fa1@arm.com>
Date: Mon, 2 Feb 2026 09:54:09 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v5 3/7] arm64: nested: Add support for setting
 maintenance IRQ
To: Sascha Bischoff <Sascha.Bischoff@arm.com>, "maz@kernel.org"
 <maz@kernel.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 Alexandru Elisei <Alexandru.Elisei@arm.com>,
 "will@kernel.org" <will@kernel.org>,
 "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>
References: <20260123142729.604737-1-andre.przywara@arm.com>
 <20260123142729.604737-4-andre.przywara@arm.com>
 <86fr7sb69h.wl-maz@kernel.org> <8db77da0-4772-499d-b140-350e4470e30d@arm.com>
 <c3b611b88e47c534ac050d02a8b4706111d679da.camel@arm.com>
 <15de1a60-1dfb-41fd-a747-bd9564572d22@arm.com>
 <38537f6988b599a9f69ba19b80aa5959d4ea64b8.camel@arm.com>
Content-Language: en-US
From: Andre Przywara <andre.przywara@arm.com>
In-Reply-To: <38537f6988b599a9f69ba19b80aa5959d4ea64b8.camel@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.linux.dev,arm.com,kernel.org,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-69816-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andre.przywara@arm.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[]
X-Rspamd-Queue-Id: 0CE17C9D49
X-Rspamd-Action: no action

Hi Sascha,

On 1/30/26 10:29, Sascha Bischoff wrote:
> On Thu, 2026-01-29 at 18:08 +0100, Andre Przywara wrote:
>> Hi Sascha,
>>
>> On 1/27/26 14:23, Sascha Bischoff wrote:
>>> On Tue, 2026-01-27 at 12:07 +0000, Andre Przywara wrote:
>>>> Hi Marc,
>>>>
>>>> On 26/01/2026 18:03, Marc Zyngier wrote:
>>>>> On Fri, 23 Jan 2026 14:27:25 +0000,
>>>>> Andre Przywara <andre.przywara@arm.com> wrote:
>>>>>>
>>>>>> Uses the new VGIC KVM device attribute to set the maintenance
>>>>>> IRQ.
>>>>>> This is fixed to use PPI 9, as a platform decision made by
>>>>>> kvmtool,
>>>>>> matching the SBSA recommendation.
>>>>>> Use the opportunity to pass the kvm pointer to
>>>>>> gic__generate_fdt_nodes(),
>>>>>> as this simplifies the call and allows us access to the
>>>>>> nested_virt
>>>>>> config variable on the way.
>>>>>>
>>>>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>>>>> ---
>>>>>>     arm64/arm-cpu.c         |  2 +-
>>>>>>     arm64/gic.c             | 29 +++++++++++++++++++++++++++--
>>>>>>     arm64/include/kvm/gic.h |  2 +-
>>>>>>     3 files changed, 29 insertions(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/arm64/arm-cpu.c b/arm64/arm-cpu.c
>>>>>> index 69bb2cb2..0843ac05 100644
>>>>>> --- a/arm64/arm-cpu.c
>>>>>> +++ b/arm64/arm-cpu.c
>>>>>> @@ -14,7 +14,7 @@ static void generate_fdt_nodes(void *fdt,
>>>>>> struct kvm *kvm)
>>>>>>     {
>>>>>>     	int timer_interrupts[4] = {13, 14, 11, 10};
>>>>>>     
>>>>>> -	gic__generate_fdt_nodes(fdt, kvm->cfg.arch.irqchip);
>>>>>> +	gic__generate_fdt_nodes(fdt, kvm);
>>>>>>     	timer__generate_fdt_nodes(fdt, kvm,
>>>>>> timer_interrupts);
>>>>>>     	pmu__generate_fdt_nodes(fdt, kvm);
>>>>>>     }
>>>>>> diff --git a/arm64/gic.c b/arm64/gic.c
>>>>>> index b0d3a1ab..2a595184 100644
>>>>>> --- a/arm64/gic.c
>>>>>> +++ b/arm64/gic.c
>>>>>> @@ -11,6 +11,8 @@
>>>>>>     
>>>>>>     #define IRQCHIP_GIC 0
>>>>>>     
>>>>>> +#define GIC_MAINT_IRQ	9
>>>>>> +
>>>>>>     static int gic_fd = -1;
>>>>>>     static u64 gic_redists_base;
>>>>>>     static u64 gic_redists_size;
>>>>>> @@ -302,10 +304,15 @@ static int gic__init_gic(struct kvm
>>>>>> *kvm)
>>>>>>     
>>>>>>     	int lines = irq__get_nr_allocated_lines();
>>>>>>     	u32 nr_irqs = ALIGN(lines, 32) + GIC_SPI_IRQ_BASE;
>>>>>> +	u32 maint_irq = GIC_PPI_IRQ_BASE + GIC_MAINT_IRQ;
>>>>>>     	struct kvm_device_attr nr_irqs_attr = {
>>>>>>     		.group	= KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
>>>>>>     		.addr	= (u64)(unsigned long)&nr_irqs,
>>>>>>     	};
>>>>>> +	struct kvm_device_attr maint_irq_attr = {
>>>>>> +		.group	= KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ,
>>>>>> +		.addr	= (u64)(unsigned long)&maint_irq,
>>>>>> +	};
>>>>>>     	struct kvm_device_attr vgic_init_attr = {
>>>>>>     		.group	= KVM_DEV_ARM_VGIC_GRP_CTRL,
>>>>>>     		.attr	= KVM_DEV_ARM_VGIC_CTRL_INIT,
>>>>>> @@ -325,6 +332,16 @@ static int gic__init_gic(struct kvm
>>>>>> *kvm)
>>>>>>     			return ret;
>>>>>>     	}
>>>>>>     
>>>>>> +	if (kvm->cfg.arch.nested_virt) {
>>>>>> +		ret = ioctl(gic_fd, KVM_HAS_DEVICE_ATTR,
>>>>>> &maint_irq_attr);
>>>>>> +		if (!ret)
>>>>>> +			ret = ioctl(gic_fd,
>>>>>> KVM_SET_DEVICE_ATTR,
>>>>>> &maint_irq_attr);
>>>>>> +		if (ret) {
>>>>>> +			pr_err("could not set maintenance
>>>>>> IRQ\n");
>>>>>> +			return ret;
>>>>>> +		}
>>>>>> +	}
>>>>>> +
>>>>>>     	irq__routing_init(kvm);
>>>>>>     
>>>>>>     	if (!ioctl(gic_fd, KVM_HAS_DEVICE_ATTR,
>>>>>> &vgic_init_attr)) {
>>>>>> @@ -342,7 +359,7 @@ static int gic__init_gic(struct kvm *kvm)
>>>>>>     }
>>>>>>     late_init(gic__init_gic)
>>>>>>     
>>>>>> -void gic__generate_fdt_nodes(void *fdt, enum irqchip_type
>>>>>> type)
>>>>>> +void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
>>>>>>     {
>>>>>>     	const char *compatible, *msi_compatible = NULL;
>>>>>>     	u64 msi_prop[2];
>>>>>> @@ -350,8 +367,12 @@ void gic__generate_fdt_nodes(void *fdt,
>>>>>> enum
>>>>>> irqchip_type type)
>>>>>>     		cpu_to_fdt64(ARM_GIC_DIST_BASE),
>>>>>> cpu_to_fdt64(ARM_GIC_DIST_SIZE),
>>>>>>     		0, 0,				/* to be
>>>>>> filled
>>>>>> */
>>>>>>     	};
>>>>>> +	u32 maint_irq[] = {
>>>>>> +		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
>>>>>> cpu_to_fdt32(GIC_MAINT_IRQ),
>>>>>> +		gic__get_fdt_irq_cpumask(kvm) |
>>>>>> IRQ_TYPE_LEVEL_HIGH
>>>>>> +	};
>>>>>
>>>>> This looks utterly broken, and my guests barf on this:
>>>>>
>>>>>            intc {
>>>>>                    compatible = "arm,gic-v3";
>>>>>                    #interrupt-cells = <0x03>;
>>>>>                    interrupt-controller;
>>>>>                    reg = <0x00 0x3fff0000 0x00 0x10000 0x00
>>>>> 0x3fef0000 0x00 0x100000>;
>>>>>                    interrupts = <0x01 0x09 0x4000000>;
>>>>
>>>> Ah yeah, sorry, that's of course complete blunder, this got lost
>>>> in
>>>> translation between v3 and v4.
>>>>                                              ^^^^^^^^^^^
>>>>> Are you testing on a big-endian box??? I fixed it with the
>>>>> patchlet
>>>>> below, but I also wonder why you added
>>>>> gic__get_fdt_irq_cpumask()...
>>>>
>>>> this was to accommodate GICv2 (it returns 0 for GICv3), and was
>>>> the
>>>> equivalent of the hardcoded 0xff04 we had before. And though I
>>>> guess
>>>> there would be no overlap between machines supporting nested virt
>>>> and
>>>> having a GICv2 or a GICv2 emulation capable GICv3, I added this
>>>> for
>>>> the
>>>> sake of completeness anyway, as it didn't feel right to make this
>>>> assumption in the otherwise generic code.
>>>>
>>>> Consider this fixed.
>>>>
>>>> Cheers,
>>>> Andre
>>>
>>> Seems I'd missed this in v4. Sorry!
>>>
>>> However, this made me think about GICv5 guests.
> 
> Hi Andre!
> 
> Apologies for confusing things. It seems that my muscle memory kicked
> in when I replied, and I typed GICv5 where I'd meant GICv2! Argh!

No worries, I sed'ed it while reading ;-)

>>> Right now one can try
>>> and create a nested guest with GICv2. Attempting to do so fails a
>>> little ungracefully:
>>>
>>>     Error: could not set maintenance IRQ
>>>
>>>     Warning: Failed init: gic__init_gic
>>>
>>>     Fatal: Initialisation failed
>>>
>>> It might be worth catching the v2 + nested combo explicitly and
>>> returning a slightly more useful error.
>>
>> Mmmh, would that be really useful? You created that situation on the
>> model, right? I don't think it's a common scenario to run a guest in
>> EL2
>> while having a GICv2 interrupt controller.
> 
> I did create this on the model, but it was a GICv3 FVP. So, this was `-
> -irqchip=gicv2 --nested` on a GICv3 host.

So the model is then providing a GICv2-compatible GICv3, which is quite 
rare in real silicon. Any halfway recent GIC would not support this, I 
think.

> I think that we are somewhat in agreement that running an EL2 guest on
> GICv2 isn't a common or expected use-case. My main thinking is that it
> doesn't really make sense allow the combination of anything but --
> irqchip=gicv3(-its) and --nested (and eventually GICv5 once there is
> nested support in KVM).

I don't think kvmtool should do this kind of predicting and filtering 
when this is eventually a feature of the running *kernel*. At the moment 
GICv3 is indeed the only supported GIC for nested, but this might change 
(with GICv5, for instance). The kernel returning an error should be the 
actual cause of a bailout.

>> And while we cannot
>> completely rule this out (as you have shown), I don't think it's
>> common
>> enough to warrant an explicit check or message. At least it failed
>> (because the vGICv2 device doesn't implement
>> KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ), and barfed about the GIC, which
>> should
>> give people that tinker with the GIC enough clues, right?
> 
> Yeah, it should give enough clues. I was just observing that the error
> could have been more explicit. I was just thinking of something along
> the following lines when validating the config (and actually not as
> part of this change). Feel free to disregard if you think it is
> overkill.

With what I said above and the fact that trying to run in EL2 with a 
GICv2 is fringe anyway, I'd prefer to not have any explicit test.

Cheers,
Andre

> 
> Thanks,
> Sascha
> 
> diff --git a/arm64/kvm.c b/arm64/kvm.c
> index ed0f1264..a50bcc23 100644
> --- a/arm64/kvm.c
> +++ b/arm64/kvm.c
> @@ -440,8 +440,14 @@ void kvm__arch_validate_cfg(struct kvm *kvm)
>              kvm->cfg.ram_addr + kvm->cfg.ram_size > SZ_4G) {
>                  die("RAM extends above 4GB");
>          }
> +
>          if (kvm->cfg.arch.e2h0 && !kvm->cfg.arch.nested_virt)
>                  pr_warning("--e2h0 requires --nested, ignoring");
> +
> +       if (kvm->cfg.arch.nested_virt &&
> +           kvm->cfg.arch.irqchip != IRQCHIP_GICV3 &&
> +           kvm->cfg.arch.irqchip != IRQCHIP_GICV3-ITS)
> +               die("--nested requires a GICv3-based guest");
>   }
>   
>   u64 kvm__arch_default_ram_address(void)
> 
>>
>> Please let me know what you think!
>>
>> Cheers,
>> Andre
>>
>>>
>>> Thanks,
>>> Sascha
>>>
>>>>
>>>>>
>>>>> 	M.
>>>>>
>>>>> diff --git a/arm64/gic.c b/arm64/gic.c
>>>>> index 2a59518..640ff35 100644
>>>>> --- a/arm64/gic.c
>>>>> +++ b/arm64/gic.c
>>>>> @@ -369,7 +369,7 @@ void gic__generate_fdt_nodes(void *fdt,
>>>>> struct
>>>>> kvm *kvm)
>>>>>     	};
>>>>>     	u32 maint_irq[] = {
>>>>>     		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI),
>>>>> cpu_to_fdt32(GIC_MAINT_IRQ),
>>>>> -		gic__get_fdt_irq_cpumask(kvm) |
>>>>> IRQ_TYPE_LEVEL_HIGH
>>>>> +		cpu_to_fdt32(gic__get_fdt_irq_cpumask(kvm) |
>>>>> IRQ_TYPE_LEVEL_HIGH),
>>>>>     	};
>>>>>     
>>>>>     	switch (kvm->cfg.arch.irqchip) {
>>>>>
>>>>
>>>
>>
> 


