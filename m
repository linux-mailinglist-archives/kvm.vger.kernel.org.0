Return-Path: <kvm+bounces-65795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B4823CB6F72
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 20:00:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5B4603032FDD
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 18:59:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 474A8319619;
	Thu, 11 Dec 2025 18:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L0vK13EG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD58E283FC5
	for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 18:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765479591; cv=none; b=DWvnwZpaZQi9oAtJO5jbrgvM/M8h+IOILepBXxWGpd9pWy7+EIlzDqh9ZEPNSacINjgYtTYjpaHJbR1KPmHCv1T9XgYz/AtC0giZQxG6ih0mDCE7tV6sK8KOpEJ7C+PJbolb/EHi2EhBfnGwlOITDRbQq8ZHzhLQr+9dfr9KRXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765479591; c=relaxed/simple;
	bh=BovM0o+QyCWcHoAbIi88TceAQzr30hZ05Wc+ZD2Zv7Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sg3VfrdpE8jfZ7ixgnP6zJFeBRm5Ox3nOqhwaFsJPH2mahUxqX6Xjin3PK/kYE+jWqVZINcr9PeRRuUJEwAL/p4RO3HxlZaACD6Hb3v6dMC51YlGxhbPr+ZGVLoyfvloSKsTBqRopZvsVfPl69OO+7hZ4MIFS3jwWP6QnG0BFeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L0vK13EG; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-297ddb3c707so3756215ad.2
        for <kvm@vger.kernel.org>; Thu, 11 Dec 2025 10:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765479589; x=1766084389; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VdN8NAO7eD861tYknpGT7rKlcQ4OtscBRzixxIDE0Y8=;
        b=L0vK13EGZLQs1Bc+lOBZTcItM3wEkNpbZSNJJXi9RbqNMOeN091KKSbpZPoBg/BVsT
         uGKz4RGLgZfaU/XQkHjR0yXDuL6w0VJ0zxS/meIrhia5O0DnS1OfMEUbZWNpJ70Kkep9
         eH715JWQFxnoEF7AOg5dQXYRtUvDcUaPVtaKs91FgbpWXLhsbjJgmuWMNz8XkwU+0t0A
         H3gSI1H9ieKx9fxFT6dFdv2H5MXv1pbt8/OQ6Zf+V0gP8OD+6CMNBha6LEDPtxZqbfgX
         +Cx5FN4+GBqa4VWNLuEA7igbqPa1Zd5VSIeTO1cE1foof7X86Q8SqxByMqT7m9RYTwjp
         7GCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765479589; x=1766084389;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VdN8NAO7eD861tYknpGT7rKlcQ4OtscBRzixxIDE0Y8=;
        b=lyp+uD2XO/GcnLcEqtcImOS+7Ac1C7ftZ/6SAUBFSlVX527mGNwfeiypZ7WSXx/N8S
         ORPD28UmkAISyxGSajoi1PbR5jpuYddvX4INNBMxLVJ/i7HthLpnutgOoUFEEkaYv7ZA
         89rd8LK7FwXUgb2fiylhhlkTLWsDkvmUATCCT28RsExS5KZYP0Xmk2fV0qMRpeEZ9iUF
         Z3AmuaiT1A4SSpQQNVY0iInvDOIU8q9vB0X7Js2ZrXJNT7puKPK0/6To5Jbt6UisYXnS
         K8YtavAsv0pst/S44pyUSw9tAYdwerJSESx7qhBr4e+dt/triQJq0YJBGzuQwizVh0T6
         cU6g==
X-Forwarded-Encrypted: i=1; AJvYcCUgfBKbkkrS1uN3X/qlVPD5kEaJRW46k/nvDX+Zx01QupUJ7b3SPejPk3WE5SU7cLD5Ihg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjAPJU/YP+z+JV0df+94CEvWe4Xvc+mVEPCM9UWUgnh9fpxzQh
	wkXIkgiex4ebl3Ah7dtMKYl+P1SD8Taz7EYi6oop8OaZYa3TpNrIho8jt85UthqVzqZvByfcbLo
	rT+QjTg==
X-Google-Smtp-Source: AGHT+IH2U5ytdiPfKvE1BzIEqn2u6/ksPDJS6vknajJueRcfSEUy1H/tlRKs+DLwt79jmJbnxifs7s3T2dE=
X-Received: from plry15.prod.google.com ([2002:a17:902:b48f:b0:297:e887:3f69])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:fa7:b0:298:58ae:f91a
 with SMTP id d9443c01a7336-29ec280db55mr74958565ad.57.1765479589077; Thu, 11
 Dec 2025 10:59:49 -0800 (PST)
Date: Thu, 11 Dec 2025 10:59:47 -0800
In-Reply-To: <20251211110024.1409489-1-khushit.shah@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251211110024.1409489-1-khushit.shah@nutanix.com>
Message-ID: <aTsUo9Fc6uu2A7rs@google.com>
Subject: Re: [PATCH v4] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
From: Sean Christopherson <seanjc@google.com>
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: pbonzini@redhat.com, kai.huang@intel.com, mingo@redhat.com, x86@kernel.org, 
	bp@alien8.de, hpa@zytor.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, dave.hansen@linux.intel.com, tglx@linutronix.de, 
	jon@nutanix.com, shaju.abraham@nutanix.com, dwmw2@infradead.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

A bunch of nits, but I'll fix them up when applying, assuming on one else has
feedback.

On Thu, Dec 11, 2025, Khushit Shah wrote:
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 48598d017d6f..4a6d94dc7a2a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1229,6 +1229,12 @@ enum kvm_irqchip_mode {
>  	KVM_IRQCHIP_SPLIT,        /* created with KVM_CAP_SPLIT_IRQCHIP */
>  };
>  
> +enum kvm_suppress_eoi_broadcast_mode {
> +	KVM_SUPPRESS_EOI_BROADCAST_QUIRKED, /* Legacy behavior */
> +	KVM_SUPPRESS_EOI_BROADCAST_ENABLED, /* Enable Suppress EOI broadcast */
> +	KVM_SUPPRESS_EOI_BROADCAST_DISABLED /* Disable Suppress EOI broadcast */
> +};
> +
>  struct kvm_x86_msr_filter {
>  	u8 count;
>  	bool default_allow:1;
> @@ -1480,6 +1486,7 @@ struct kvm_arch {
>  
>  	bool x2apic_format;
>  	bool x2apic_broadcast_quirk_disabled;
> +	enum kvm_suppress_eoi_broadcast_mode suppress_eoi_broadcast_mode;

For brevity, I vote for eoi_broadcast_mode here, i.e.:

	enum kvm_suppress_eoi_broadcast_mode eoi_broadcast_mode;

> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 0ae7f913d782..1ef0bd3eff1e 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -105,6 +105,34 @@ bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector)
>  		apic_test_vector(vector, apic->regs + APIC_IRR);
>  }
>  
> +static inline bool kvm_lapic_advertise_suppress_eoi_broadcast(struct kvm *kvm)

Formletter...

Do not use "inline" for functions that are visible only to the local compilation
unit.  "inline" is just a hint, and modern compilers are smart enough to inline
functions when appropriate without a hint.

A longer explanation/rant here: https://lore.kernel.org/all/ZAdfX+S323JVWNZC@google.com

> +{
> +	/*
> +	 * Advertise Suppress EOI broadcast support to the guest unless the VMM
> +	 * explicitly disabled it.
> +	 *
> +	 * Historically, KVM advertised this capability even though it did not
> +	 * actually suppress EOIs.
> +	 */
> +	return kvm->arch.suppress_eoi_broadcast_mode !=
> +			KVM_SUPPRESS_EOI_BROADCAST_DISABLED;

With a shorter field name, this can more comfortably be:

	return kvm->arch.eoi_broadcast_mode != KVM_SUPPRESS_EOI_BROADCAST_DISABLED;

> +}
> +
> +static inline bool kvm_lapic_ignore_suppress_eoi_broadcast(struct kvm *kvm)
> +{
> +	/*
> +	 * Returns true if KVM should ignore the suppress EOI broadcast bit set by
> +	 * the guest and broadcast EOIs anyway.
> +	 *
> +	 * Only returns false when the VMM explicitly enabled Suppress EOI
> +	 * broadcast. If disabled by VMM, the bit should be ignored as it is not
> +	 * supported. Legacy behavior was to ignore the bit and broadcast EOIs
> +	 * anyway.
> +	 */
> +	return kvm->arch.suppress_eoi_broadcast_mode !=
> +			KVM_SUPPRESS_EOI_BROADCAST_ENABLED;

And then...

	return kvm->arch.eoi_broadcast_mode != KVM_SUPPRESS_EOI_BROADCAST_ENABLED;

> +}
> +
>  __read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
>  EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_has_noapic_vcpu);
>  
> @@ -562,6 +590,7 @@ void kvm_apic_set_version(struct kvm_vcpu *vcpu)
>  	 * IOAPIC.
>  	 */
>  	if (guest_cpu_cap_has(vcpu, X86_FEATURE_X2APIC) &&
> +		kvm_lapic_advertise_suppress_eoi_broadcast(vcpu->kvm) &&

Align indentation.

>  	    !ioapic_in_kernel(vcpu->kvm))
>  		v |= APIC_LVR_DIRECTED_EOI;
>  	kvm_lapic_set_reg(apic, APIC_LVR, v);
> @@ -1517,6 +1546,17 @@ static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
>  
>  	/* Request a KVM exit to inform the userspace IOAPIC. */
>  	if (irqchip_split(apic->vcpu->kvm)) {
> +		/*
> +		 * Don't exit to userspace if the guest has enabled Directed
> +		 * EOI, a.k.a. Suppress EOI Broadcasts, in which case the local
> +		 * APIC doesn't broadcast EOIs (the guest must EOI the target
> +		 * I/O APIC(s) directly).  Ignore the suppression if userspace
> +		 * has NOT explicitly enabled Suppress EOI broadcast.
> +		 */
> +		if ((kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI) &&
> +		     !kvm_lapic_ignore_suppress_eoi_broadcast(apic->vcpu->kvm))
> +			return;
> +
>  		apic->vcpu->arch.pending_ioapic_eoi = vector;
>  		kvm_make_request(KVM_REQ_IOAPIC_EOI_EXIT, apic->vcpu);
>  		return;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c9c2aa6f4705..81b40fdb5f5f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -121,8 +121,11 @@ static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
>  
>  #define KVM_CAP_PMU_VALID_MASK KVM_PMU_CAP_DISABLE
>  
> -#define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
> -                                    KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
> +#define KVM_X2APIC_API_VALID_FLAGS	\
> +	(KVM_X2APIC_API_USE_32BIT_IDS |	\
> +	KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK |	\
> +	KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST |	\
> +	KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST)

Unless someone feels strongly, I think I'd prefer to keep the existing style, e.g.

#define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS |		\
				    KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK |	\
				    KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST |	\
				    KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST)

>  
>  static void update_cr8_intercept(struct kvm_vcpu *vcpu);
>  static void process_nmi(struct kvm_vcpu *vcpu);
> @@ -6777,12 +6780,22 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		r = -EINVAL;
>  		if (cap->args[0] & ~KVM_X2APIC_API_VALID_FLAGS)
>  			break;
> +		if ((cap->args[0] & KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST) &&
> +		    (cap->args[0] & KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST))
> +			break;
> +		if (!irqchip_split(kvm) &&
> +		    ((cap->args[0] & KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST) ||
> +		     (cap->args[0] & KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST)))
> +			break;

Again, unless someone feels strongly, I'd prefer to have some newlines here, i.e.

		r = -EINVAL;
		if (cap->args[0] & ~KVM_X2APIC_API_VALID_FLAGS)
			break;

		if ((cap->args[0] & KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST) &&
		    (cap->args[0] & KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST))
			break;

		if (!irqchip_split(kvm) &&
		    ((cap->args[0] & KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST) ||
		     (cap->args[0] & KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST)))
			break;

		if (cap->args[0] & KVM_X2APIC_API_USE_32BIT_IDS)


