Return-Path: <kvm+bounces-29026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCC9A9A120D
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 20:55:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B565B24EB1
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 18:55:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D42B215F79;
	Wed, 16 Oct 2024 18:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tcqi7kj7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BED5212F10
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 18:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729104878; cv=none; b=KSfJRenwvi4nMOWe1hlH/jtUbxRgyF4dqwFP/4nittB9BdDqRGmCiFdJ1Gip0zhXHbS2gIp5comddjfyk6KDtJoqLWvEeCaLMrFHAJRkCfvz+S57uBX89t8KSKzrRuNH1O1vAqH+xGpvZSFtmbbNla8I6T7j/sJGIohs+H6hJV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729104878; c=relaxed/simple;
	bh=acJ3ioyp/DOU7wsOKFr+uLibyRAqoHdzwcK6UIKLnAw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HoupwWHUSyqz5jQ4uzJWK2QddkNv0zlLdCdIhDkvii8W7CgtYhS/Q6pD39MOF9rn3V9FVCwkUMR+UZFjeWxjZlCkuqnUKS8usP5MGQvnMiCZyTxLcPs65k+LFRvK4s587uyrIRYYGL0qQBkpcTXbK9sfVf4br0RHRZdo9QbSabc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tcqi7kj7; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6d9e31e66eeso5092367b3.1
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 11:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729104876; x=1729709676; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J0/8QZoT17A3EROr47LCPpO2aoyicep5UUu5G7/3+TQ=;
        b=tcqi7kj7TPjaTo8Ei3D9Qqi1tdMJhKVBZSv9UMfIUMU2WNkaQfKzA2OeaUL/d72Syw
         /uKhlmJQ4yjfzFAkl0+aSMl/b0vhl0v4NxO21PC+qlakUHjDMuLy7FK7t4dF1G/0cndd
         Qj8z1H7DIE8en5YWBBELQoRSP3eE+WFROmrL1alX09fcj9hjtCyBKokEm1Q0BJCdnvL5
         zifGGnHIAQ4k7acAP1tcUAqucyRkksInLPt+Fn3rVH3stVRP/u4uAxXTFZGgYU3fOiAG
         85mxNly6Ymy273vBlKfuu4X0oSwHKamK2Eg/y1yLXS5+ljhukn0wwBZctzhp1a7B1unI
         MZog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729104876; x=1729709676;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J0/8QZoT17A3EROr47LCPpO2aoyicep5UUu5G7/3+TQ=;
        b=Odo+pVbektrNLsSluO4pDHpfZyVSCGRwIYBCBCQOlw0civOMP8RNjgk8NW4xPg8iCH
         FBIH0/fHPmxpyWMjBu3Yl/O+6XNs+KWeFPxJRjmuMtTzCEJU1HOe3IJFYNQcyYWhDY5d
         nhWcb12MutbbEX/xDV4SsTei5Y9QnQhgE5AMD3KwnqDQdyw7HyiGuGpe7WTwPEsKd5uj
         vNnG4QFN53B1+4l/G6inc0w23NpoPg8IFFa77WrDf2mkvu36VpE+DQgO3GRaRXByOlkC
         DsTAAWJHxuimKu9iP9aVyYLlsx/eMh4ncUnjbdhJwLwj2sRSnP2j6vYz6JAwgnitFp0F
         BIBw==
X-Forwarded-Encrypted: i=1; AJvYcCW5IcfYR0sFxT82U+nnCuT/l5lRp3qwumRyP+7+yv91DY2FDd7UVNbUNFxwtr+BdUF8eaE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsLPNIR3AT+G02u7K6hUZOLH7JJHREB3xsf3aQ1nYYLVAedtpI
	BUowcNE5LW8YH2HY6Lu2OevqXUWSAR5IN2TmDXOm/RyWp3cN9+AzqlMhScBVVsPb19nsTdy5+4W
	mpQ==
X-Google-Smtp-Source: AGHT+IGs9SUMgB5/fvEZ+YcbF2zWPEo1ZtZhn/bKOtUhnEycWjUvwWralHKNqXT9eNkXrZYNERhQOnYQAU8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:4447:b0:6e3:189a:ad65 with SMTP id
 00721157ae682-6e3d41c8134mr875717b3.5.1729104876083; Wed, 16 Oct 2024
 11:54:36 -0700 (PDT)
Date: Wed, 16 Oct 2024 11:54:34 -0700
In-Reply-To: <ZwezvcaZJOg7A9el@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Zu0vvRyCyUaQ2S2a@google.com> <20241002124324.14360-1-mankku@gmail.com>
 <Zv1gbzT1KTYpNgY1@google.com> <Zv15trTQIBxxiSFy@google.com>
 <Zv2Ay9Y3TswTwW_B@google.com> <ZwezvcaZJOg7A9el@intel.com>
Message-ID: <ZxAL6thxEH67CpW7@google.com>
Subject: Re: [PATCH 1/1] KVM: nVMX: update VPPR on vmlaunch/vmresume
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: "Markku =?utf-8?Q?Ahvenj=C3=A4rvi?=" <mankku@gmail.com>, bp@alien8.de, dave.hansen@linux.intel.com, 
	hpa@zytor.com, janne.karhunen@gmail.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 10, 2024, Chao Gao wrote:
> The issue is that KVM does not properly update vmcs01's SVI. In this case, L1
> does not intercept EOI MSR writes from the deprivileged host (L2), so KVM

Oof.  It's not simply that L1 doesn't intercept EOI, it's also that L1 doesn't
have APICv enabled.

Note, the only reason there aren't a slew of other issues in this setup is that
KVM takes all APICv-related controls from vmcs12.  I.e. if L1 is sharing its APIC
with L2, then KVM will effectively disable APICv when running L2.  Which is
rather unfortunate for the pKVM-on-KVM case (lost performance), but functionally
it's ok.

E.g. if KVM enabled APICv in an APIC-passthrough scenario, then KVM would need
to load the correct EOI bitmaps when running L2, and keep them up-to-date for
both L1 and L2.

> emulates EOI writes by clearing the highest bit in vISR and updating vPPR.
> However, SVI in vmcs01 is not updated, causing it to retain the interrupt vector
> that was just EOI'd. On the next VM-entry to L1, the CPU performs PPR
> virtualization, setting vPPR to SVI & 0xf0, which results in an incorrect vPPR
> 
> Can you try this fix?
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4a93ac1b9be9..3d24194a648d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -122,6 +122,8 @@
>  #define KVM_REQ_HV_TLB_FLUSH \
>  	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(34)
> +#define KVM_REQ_UPDATE_HWAPIC_ISR \
> +	KVM_ARCH_REQ_FLAGS(35, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  
>  #define CR0_RESERVED_BITS                                               \
>  	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
> @@ -764,6 +766,7 @@ struct kvm_vcpu_arch {
>  	u64 apic_base;
>  	struct kvm_lapic *apic;    /* kernel irqchip context */
>  	bool load_eoi_exitmap_pending;
> +	bool update_hwapic_isr;

Obviously not your fault, but I'm really beginning to hate all of the flags we're
accumulating, e.g. in addition to load_eoi_exitmap_pending and potentially
update_hwapic_isr, VMX also has:

	bool change_vmcs01_virtual_apic_mode;
	bool reload_vmcs01_apic_access_page;
	bool update_vmcs01_cpu_dirty_logging;
	bool update_vmcs01_apicv_status;

Doesn't (and shouldn't) need to be handled as part of this, but I wonder if we
can clean things up a bit by impementing something along the lines of deferred
requests, e.g. nested_vmx_defer_request(NESTED_VMX_REQ_XXX, vcpu).  We'd still
need to add each request, but it would cut down on some of the boilerplate, e.g.

	if (vmx->nested.change_vmcs01_virtual_apic_mode) {
		vmx->nested.change_vmcs01_virtual_apic_mode = false;
		vmx_set_virtual_apic_mode(vcpu);
	}

would become

	if (nested_vmx_check_request(NESTED_VMX_REQ_VAPIC_MODE, vcpu))
		vmx_set_virtual_apic_mode(vcpu);

An alternative idea would be to use KVM_REQ_XXX directly, and shuffle them from
vmx->nested to vcpu, but that would pollute KVM_REQ_XXX for the cases where KVM
doesn't need a "normal" request.

Another idea would be to temporarily switch to vmcs01 as needed, which would
probably be ok for most cases since they are uncommon events, but for EOIs in
this, situation the overhead would be non-trivial and completely unnecessary.

>  	DECLARE_BITMAP(ioapic_handled_vectors, 256);
>  	unsigned long apic_attention;
>  	int32_t apic_arb_prio;
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index b1eb46e26b2e..a8dad16161e4 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -220,6 +220,11 @@ static inline void leave_guest_mode(struct kvm_vcpu *vcpu)
>  		kvm_make_request(KVM_REQ_LOAD_EOI_EXITMAP, vcpu);
>  	}
>  
> +	if (vcpu->arch.update_hwapic_isr) {
> +		vcpu->arch.update_hwapic_isr = false;
> +		kvm_make_request(KVM_REQ_UPDATE_HWAPIC_ISR, vcpu);

I don't think we need a new request for this, KVM can refresh SVI directly in
nested_vmx_vmexit(), e.g. along with change_vmcs01_virtual_apic_mode and friends.

> +	}
> +
>  	vcpu->stat.guest_mode = 0;
>  }
>  
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 5bb481aefcbc..d6a03c30f085 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -800,6 +800,9 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
>  	if (!__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
>  		return;
>  
> +	if (is_guest_mode(apic->vcpu))

As above, I think this needs to be

	if (is_guest_mode(apic->vcpu) && !nested_cpu_has_vid(get_vmcs12(vcpu)))

because if virtual interrupt delivery is enabled, then EOIs are virtualized.
Which means that this needs to be handled in vmx_hwapic_isr_update().

Hmm, actually, there's more to it, I think.  If virtual interrupt deliver is
disabled for L2, then writing vmcs02 is pointless because GUEST_INTR_STATUS is
unused by the CPU.

Argh, but hwapic_isr_update() doesn't take @vcpu.  That's easy enough to fix,
just annoying.

Chao, can you provide your SoB for your code?  If you've no objections, I'll
massage it to avoid using a request and write a changelog, and then post it as
part of a small series.

Thanks again!

> +		apic->vcpu->arch.update_hwapic_isr = true;
> +
>  	/*
>  	 * We do get here for APIC virtualization enabled if the guest
>  	 * uses the Hyper-V APIC enlightenment.  In this case we may need

