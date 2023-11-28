Return-Path: <kvm+bounces-2561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B12ED7FB232
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 07:56:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDE2F1C20BA2
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 06:56:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E827611C97;
	Tue, 28 Nov 2023 06:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Iqi/N3Cj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434C0197
	for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 22:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701154573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ch3OE1ozu2gGY8h80hPSM9UE3L6wgjuXbkMspcLV54s=;
	b=Iqi/N3CjIZd31ZtGlu+4Jyb793TBIb3mlpFdCX6bg48mlj9w0ceRQHxKSZq5sMbyDSvJ1j
	IxD3kUtHYlRzyTfIa0hf9DbPU+k2fKEPHT6eBJyf59Z+vd8XARRpAinHJV1Tw3BrRphJ9Y
	kJc7oceNgtvUfWpTfEvrCpCU9/w4coM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-yhwMRqYkNkWld2qFzrpxug-1; Tue, 28 Nov 2023 01:56:11 -0500
X-MC-Unique: yhwMRqYkNkWld2qFzrpxug-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-332e61e2480so3170314f8f.0
        for <kvm@vger.kernel.org>; Mon, 27 Nov 2023 22:56:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701154570; x=1701759370;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ch3OE1ozu2gGY8h80hPSM9UE3L6wgjuXbkMspcLV54s=;
        b=jychuiNDhjkXX+QIWFb6UfO10/9eetn3HvCbSF3goZX18hWaOg1iyrGMcESTv70yfg
         K0sBRLfiFt1TPkIfnrXurHdeFwdasziEEHljUlwYunujx5Qt6Htpd+yoNX9DMRNQ/nOr
         7k1mdyYMAiSP1GDt0mFL3N3L8mFor+J5own0L6FH3agldIHBbHCILwzXD9oYhH0wkVA1
         PcWhQj2RVv1KIam5kpRXbqJxVc3llZi2omYfIx4meO50gMFkO/J6iLog8NkqHh4YQ2B6
         +T9/nyChu37waISvR+A80MunyIao6J6EtrQd5JcFs1CG7vN2t2YNB+uM8tR5Ttewf0HP
         8TYw==
X-Gm-Message-State: AOJu0YwHt5KN3CLOf4WdNHAPbQOGJorpP+y3Q/WioTMCIuU0XmX7yO13
	cQhuf94eDmJAiUIo5vsfuk+kpRKBqFUI9ux9UjJG3VXs1isBLXDkk3dSocRqMC4V+s9rB9VMP0J
	T+6UQlf00672e
X-Received: by 2002:a05:6000:183:b0:332:d060:c7e2 with SMTP id p3-20020a056000018300b00332d060c7e2mr9775737wrx.3.1701154570249;
        Mon, 27 Nov 2023 22:56:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFdJHZLsBu/zyS6DfoQUfP78E9xsHwlMtJuzM/aA154AvvOhwjjUdU6mZr/DsTKEzgLoV/Slw==
X-Received: by 2002:a05:6000:183:b0:332:d060:c7e2 with SMTP id p3-20020a056000018300b00332d060c7e2mr9775719wrx.3.1701154569865;
        Mon, 27 Nov 2023 22:56:09 -0800 (PST)
Received: from starship ([77.137.131.4])
        by smtp.gmail.com with ESMTPSA id o10-20020adfcf0a000000b00332cda91c85sm13950140wrj.12.2023.11.27.22.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 22:56:09 -0800 (PST)
Message-ID: <98eee37ed7f4b7b9c16bccbe41737e47a116d1f1.camel@redhat.com>
Subject: Re: [RFC 02/33] KVM: x86: Introduce KVM_CAP_APIC_ID_GROUPS
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 anelkz@amazon.com,  graf@amazon.com, dwmw@amazon.co.uk, jgowans@amazon.com,
 corbert@lwn.net,  kys@microsoft.com, haiyangz@microsoft.com,
 decui@microsoft.com, x86@kernel.org,  linux-doc@vger.kernel.org, Anel
 Orazgaliyeva <anelkz@amazon.de>
Date: Tue, 28 Nov 2023 08:56:07 +0200
In-Reply-To: <20231108111806.92604-3-nsaenz@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
	 <20231108111806.92604-3-nsaenz@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-11-08 at 11:17 +0000, Nicolas Saenz Julienne wrote:
> From: Anel Orazgaliyeva <anelkz@amazon.de>
> 
> Introduce KVM_CAP_APIC_ID_GROUPS, this capability segments the VM's APIC
> ids into two. The lower bits, the physical APIC id, represent the part
> that's exposed to the guest. The higher bits, which are private to KVM,
> groups APICs together. APICs in different groups are isolated from each
> other, and IPIs can only be directed at APICs that share the same group
> as its source. Furthermore, groups are only relevant to IPIs, anything
> incoming from outside the local APIC complex: from the IOAPIC, MSIs, or
> PV-IPIs is targeted at the default APIC group, group 0.
> 
> When routing IPIs with physical destinations, KVM will OR the source's
> vCPU APIC group with the ICR's destination ID and use that to resolve
> the target lAPIC. The APIC physical map is also made group aware in
> order to speed up this process. For the sake of simplicity, the logical
> map is not built while KVM_CAP_APIC_ID_GROUPS is in use and we defer IPI
> routing to the slower per-vCPU scan method.
> 
> This capability serves as a building block to implement virtualisation
> based security features like Hyper-V's Virtual Secure Mode (VSM). VSM
> introduces a para-virtualised switch that allows for guest CPUs to jump
> into a different execution context, this switches into a different CPU
> state, lAPIC state, and memory protections. We model this in KVM by
> using distinct kvm_vcpus for each context. Moreover, execution contexts
> are hierarchical and its APICs are meant to remain functional even when
> the context isn't 'scheduled in'. For example, we have to keep track of
> timers' expirations, and interrupt execution of lesser priority contexts
> when relevant. Hence the need to alias physical APIC ids, while keeping
> the ability to target specific execution contexts.


A few general remarks on this patch (assuming that we don't go with
the approach of a VM per VTL, in which case this patch is not needed)

-> This feature has to be done in the kernel because vCPUs sharing same VTL,
   will have same APIC ID.
   (In addition to that, APIC state is private to a VTL so each VTL
   can even change its apic id).

   Because of this KVM has to have at least some awareness of this.

-> APICv/AVIC should be supported with VTL eventually: 
   This is thankfully possible by having separate physid/pid tables per VTL,
   and will mostly just work but needs KVM awareness.

-> I am somewhat against reserving bits in apic id, because that will limit
   the number of apic id bits available to userspace. Currently this is not
   a problem but it might be in the future if for some reason the userspace
   will want an apic id with high bits set.

   But still things change, and with this being part of KVM's ABI, it might backfire.
   A better idea IMHO is just to have 'APIC namespaces', which like say PID namespaces,
   such as each namespace is isolated IPI wise on its own, and let each vCPU belong to
   a one namespace.

   In fact Intel's PRM has a brief mention of a 'hierarchical cluster' mode in which
   roughly describes this situation in which there are multiple not interconnected APIC buses, 
   and communication between them needs a 'cluster manager device'

   However I don't think that we need an explicit pairs of vCPUs and VTL awareness in the kernel
   all of this I think can be done in userspace.

   TL;DR: Lets have APIC namespace. a vCPU can belong to a single namespace, and all vCPUs
   in a namespace send IPIs to each other and know nothing about vCPUs from other namespace.
   
   A vCPU sending IPI to a different VTL thankfully can only do this using a hypercall,
   and thus can be handled in the userspace.


Overall though IMHO the approach of a VM per VTL is better unless some show stoppers show up.
If we go with a VM per VTL, we gain APIC namespaces for free, together with AVIC support and
such.

Best regards,
	Maxim Levitsky


> 
> Signed-off-by: Anel Orazgaliyeva <anelkz@amazon.de>
> Co-developed-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 ++
>  arch/x86/include/uapi/asm/kvm.h |  5 +++
>  arch/x86/kvm/lapic.c            | 59 ++++++++++++++++++++++++++++-----
>  arch/x86/kvm/lapic.h            | 33 ++++++++++++++++++
>  arch/x86/kvm/x86.c              | 15 +++++++++
>  include/uapi/linux/kvm.h        |  2 ++
>  6 files changed, 108 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index dff10051e9b6..a2f224f95404 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1298,6 +1298,9 @@ struct kvm_arch {
>  	struct rw_semaphore apicv_update_lock;
>  	unsigned long apicv_inhibit_reasons;
>  
> +	u32 apic_id_group_mask;
> +	u8 apic_id_group_shift;
> +
>  	gpa_t wall_clock;
>  
>  	bool mwait_in_guest;
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index a448d0964fc0..f73d137784d7 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -565,4 +565,9 @@ struct kvm_pmu_event_filter {
>  #define KVM_X86_DEFAULT_VM	0
>  #define KVM_X86_SW_PROTECTED_VM	1
>  
> +/* for KVM_SET_APIC_ID_GROUPS */
> +struct kvm_apic_id_groups {
> +	__u8 n_bits; /* nr of bits used to represent group in the APIC ID */
> +};
> +
>  #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 3e977dbbf993..f55d216cb2a0 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -141,7 +141,7 @@ static inline int apic_enabled(struct kvm_lapic *apic)
>  
>  static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
>  {
> -	return apic->vcpu->vcpu_id;
> +	return kvm_apic_id(apic->vcpu);
>  }
>  
>  static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
> @@ -219,8 +219,8 @@ static int kvm_recalculate_phys_map(struct kvm_apic_map *new,
>  				    bool *xapic_id_mismatch)
>  {
>  	struct kvm_lapic *apic = vcpu->arch.apic;
> -	u32 x2apic_id = kvm_x2apic_id(apic);
> -	u32 xapic_id = kvm_xapic_id(apic);
> +	u32 x2apic_id = kvm_apic_id_and_group(vcpu);
> +	u32 xapic_id = kvm_apic_id_and_group(vcpu);
>  	u32 physical_id;
>  
>  	/*
> @@ -299,6 +299,13 @@ static void kvm_recalculate_logical_map(struct kvm_apic_map *new,
>  	u16 mask;
>  	u32 ldr;
>  
> +	/*
> +	 * Using maps for logical destinations when KVM_CAP_APIC_ID_GRUPS is in
> +	 * use isn't supported.
> +	 */
> +	if (kvm_apic_group(vcpu))
> +		new->logical_mode = KVM_APIC_MODE_MAP_DISABLED;
> +
>  	if (new->logical_mode == KVM_APIC_MODE_MAP_DISABLED)
>  		return;
>  
> @@ -370,6 +377,25 @@ enum {
>  	DIRTY
>  };
>  
> +int kvm_vm_ioctl_set_apic_id_groups(struct kvm *kvm,
> +				    struct kvm_apic_id_groups *groups)
> +{
> +	u8 n_bits = groups->n_bits;
> +
> +	if (n_bits > 32)
> +		return -EINVAL;
> +
> +	kvm->arch.apic_id_group_mask = n_bits ? GENMASK(31, 32 - n_bits): 0;
> +	/*
> +	 * Bitshifts >= than the width of the type are UD, so set the
> +	 * apic group shift to 0 when n_bits == 0. The group mask above will
> +	 * clear the APIC ID, so group querying functions will return the
> +	 * correct value.
> +	 */
> +	kvm->arch.apic_id_group_shift = n_bits ? 32 - n_bits : 0;
> +	return 0;
> +}
> +
>  void kvm_recalculate_apic_map(struct kvm *kvm)
>  {
>  	struct kvm_apic_map *new, *old = NULL;
> @@ -414,7 +440,7 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm)
>  		if (kvm_apic_present(vcpu))
> -			max_id = max(max_id, kvm_x2apic_id(vcpu->arch.apic));
> +			max_id = max(max_id, kvm_apic_id_and_group(vcpu));
>  
>  	new = kvzalloc(sizeof(struct kvm_apic_map) +
>  	                   sizeof(struct kvm_lapic *) * ((u64)max_id + 1),
> @@ -525,7 +551,7 @@ static inline void kvm_apic_set_x2apic_id(struct kvm_lapic *apic, u32 id)
>  {
>  	u32 ldr = kvm_apic_calc_x2apic_ldr(id);
>  
> -	WARN_ON_ONCE(id != apic->vcpu->vcpu_id);
> +	WARN_ON_ONCE(id != kvm_apic_id(apic->vcpu));
>  
>  	kvm_lapic_set_reg(apic, APIC_ID, id);
>  	kvm_lapic_set_reg(apic, APIC_LDR, ldr);
> @@ -1067,6 +1093,17 @@ bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
>  	struct kvm_lapic *target = vcpu->arch.apic;
>  	u32 mda = kvm_apic_mda(vcpu, dest, source, target);
>  
> +	/*
> +	 * Make sure vCPUs belong to the same APIC group, it's not possible
> +	 * to send interrupts across groups.
> +	 *
> +	 * Non-IPIs and PV-IPIs can only be injected into the default APIC
> +	 * group (group 0).
> +	 */
> +	if ((source && !kvm_match_apic_group(source->vcpu, vcpu)) ||
> +	    kvm_apic_group(vcpu))
> +		return false;
> +
>  	ASSERT(target);
>  	switch (shorthand) {
>  	case APIC_DEST_NOSHORT:
> @@ -1518,6 +1555,10 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
>  	else
>  		irq.dest_id = GET_XAPIC_DEST_FIELD(icr_high);
>  
> +	if (irq.dest_mode == APIC_DEST_PHYSICAL)
> +		kvm_apic_id_set_group(apic->vcpu->kvm,
> +				      kvm_apic_group(apic->vcpu), &irq.dest_id);
> +
>  	trace_kvm_apic_ipi(icr_low, irq.dest_id);
>  
>  	kvm_irq_delivery_to_apic(apic->vcpu->kvm, apic, &irq, NULL);
> @@ -2541,7 +2582,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>  	/* update jump label if enable bit changes */
>  	if ((old_value ^ value) & MSR_IA32_APICBASE_ENABLE) {
>  		if (value & MSR_IA32_APICBASE_ENABLE) {
> -			kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
> +			kvm_apic_set_xapic_id(apic, kvm_apic_id(vcpu));
>  			static_branch_slow_dec_deferred(&apic_hw_disabled);
>  			/* Check if there are APF page ready requests pending */
>  			kvm_make_request(KVM_REQ_APF_READY, vcpu);
> @@ -2553,9 +2594,9 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>  
>  	if ((old_value ^ value) & X2APIC_ENABLE) {
>  		if (value & X2APIC_ENABLE)
> -			kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
> +			kvm_apic_set_x2apic_id(apic, kvm_apic_id(vcpu));
>  		else if (value & MSR_IA32_APICBASE_ENABLE)
> -			kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
> +			kvm_apic_set_xapic_id(apic, kvm_apic_id(vcpu));
>  	}
>  
>  	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)) {
> @@ -2685,7 +2726,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  
>  	/* The xAPIC ID is set at RESET even if the APIC was already enabled. */
>  	if (!init_event)
> -		kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
> +		kvm_apic_set_xapic_id(apic, kvm_apic_id(vcpu));
>  	kvm_apic_set_version(apic->vcpu);
>  
>  	for (i = 0; i < apic->nr_lvt_entries; i++)
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index e1021517cf04..542bd208e52b 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -97,6 +97,8 @@ void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
>  void kvm_lapic_set_eoi(struct kvm_vcpu *vcpu);
>  void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
>  u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);
> +int kvm_vm_ioctl_set_apic_id_groups(struct kvm *kvm,
> +				    struct kvm_apic_id_groups *groups);
>  void kvm_recalculate_apic_map(struct kvm *kvm);
>  void kvm_apic_set_version(struct kvm_vcpu *vcpu);
>  void kvm_apic_after_set_mcg_cap(struct kvm_vcpu *vcpu);
> @@ -277,4 +279,35 @@ static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
>  	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
>  }
>  
> +static inline u32 kvm_apic_id(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->vcpu_id & ~vcpu->kvm->arch.apic_id_group_mask;
> +}
> +
> +static inline u32 kvm_apic_id_and_group(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->vcpu_id;
> +}
> +
> +static inline u32 kvm_apic_group(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	return (vcpu->vcpu_id & kvm->arch.apic_id_group_mask) >>
> +	       kvm->arch.apic_id_group_shift;
> +}
> +
> +static inline void kvm_apic_id_set_group(struct kvm *kvm, u32 group,
> +					 u32 *apic_id)
> +{
> +	*apic_id |= ((group << kvm->arch.apic_id_group_shift) &
> +		     kvm->arch.apic_id_group_mask);
> +}
> +
> +static inline bool kvm_match_apic_group(struct kvm_vcpu *src,
> +					struct kvm_vcpu *dst)
> +{
> +	return kvm_apic_group(src) == kvm_apic_group(dst);
> +}
> +
>  #endif
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e3eb608b6692..4cd3f00475c1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4526,6 +4526,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
>  	case KVM_CAP_IRQFD_RESAMPLE:
>  	case KVM_CAP_MEMORY_FAULT_INFO:
> +	case KVM_CAP_APIC_ID_GROUPS:
>  		r = 1;
>  		break;
>  	case KVM_CAP_EXIT_HYPERCALL:
> @@ -7112,6 +7113,20 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  		r = kvm_vm_ioctl_set_msr_filter(kvm, &filter);
>  		break;
>  	}
> +	case KVM_SET_APIC_ID_GROUPS: {
> +		struct kvm_apic_id_groups groups;
> +
> +		r = -EINVAL;
> +		if (kvm->created_vcpus)
> +			goto out;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&groups, argp, sizeof(groups)))
> +			goto out;
> +
> +		r = kvm_vm_ioctl_set_apic_id_groups(kvm, &groups);
> +		break;
> +	}
>  	default:
>  		r = -ENOTTY;
>  	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 5b5820d19e71..d7a01766bf21 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1219,6 +1219,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_MEMORY_ATTRIBUTES 232
>  #define KVM_CAP_GUEST_MEMFD 233
>  #define KVM_CAP_VM_TYPES 234
> +#define KVM_CAP_APIC_ID_GROUPS 235
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  
> @@ -2307,4 +2308,5 @@ struct kvm_create_guest_memfd {
>  
>  #define KVM_GUEST_MEMFD_ALLOW_HUGEPAGE		(1ULL << 0)
>  
> +#define KVM_SET_APIC_ID_GROUPS _IOW(KVMIO, 0xd7, struct kvm_apic_id_groups)
>  #endif /* __LINUX_KVM_H */





