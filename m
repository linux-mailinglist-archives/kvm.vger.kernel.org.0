Return-Path: <kvm+bounces-9570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 316D2861C95
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 20:34:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA700284834
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 19:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13E71448FF;
	Fri, 23 Feb 2024 19:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eMv5K1aQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4FD143C6A
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 19:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708716838; cv=none; b=NUvydN8Hs5QgmP/fxFRRhjgX6HkCc0FwMK4nHhLpMJywXcKT/GyUD4pdqRbhTFPeCiVSQKCgwCKuxoy4VNJM3qaCp0wqugcyO0cL3OOYpqXmKmwML/SdkEaniXlCaR2Ah0PlXcF8GC5SC85S5rO5nlskb0tCWNx44s5g2ozPRrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708716838; c=relaxed/simple;
	bh=3JP2Y+lMrx4bgfNqs453NNL0xZbM58Cy1copOn6C0Wc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ermVA5Fiv3pfby6clpNRpRP3iNmVZXgdsERp9n6cFQ0jQy3n8fiK1ePVCmypVQzHOi60POzKS5WcDT3BI2kZ3D2rwXGPmn6E9lGlHJftv6v+7Cv8ZGyVTvxZyb2HsnO3H/QxLFJjd7AjKEq3SQpySTL69amcWRTPCwSlSBiXtEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eMv5K1aQ; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5dc90074016so976313a12.0
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 11:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708716836; x=1709321636; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gt7meJqTVoP9FlWAMNFY5PaFjI18IsSFLr+lpcXAyOc=;
        b=eMv5K1aQ8M0W85NudSfBQHnSFGZ+/fjwLAIh1XUNlgSk+Cco1OHnCs91SEH5FIdkwv
         NK+olC6RwhrU28biCzO38LBstKIh+wUSUzgFpOgKSqj59LBoBMbgENWQVOX6OScMlwiR
         St8++9JVpLYsWCPqqUhXtOgDBNfn0u54My1MV0LAHQuOjCULNsIRJGD4spteQ7kFHe4T
         L/yYTCV7tOLu6wn1R3mm5EYkrXu8KFZhKxGDi8UIVjXdFPJriZ3REzYqi9XuIJTRozZB
         6jFaTvs76wNpPsBrPQ/+4GxDuNhQ8CSIn4Ikc30SwLY+e3plHH6OoyLrP7XGY9gXrOxI
         5aLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708716836; x=1709321636;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gt7meJqTVoP9FlWAMNFY5PaFjI18IsSFLr+lpcXAyOc=;
        b=gCRoSX6Oa449G8cJGcPlNRuvE3anJ+mzFym8uHgmy/XrlmvLBpU8c57WkcDHHNtYeF
         SmrOKW5kkLT9WMQhLK+5PSHoD5JeOyTUg/nE1sUZM1Z4ZbFIKznjt6aer77VaktAj5nM
         ZSJo9AbsBL/q7rYij7HVXDz5FteiJsHuIlzNkv/8U9cCp2aC5AFznt2XU309NOiGSvcQ
         e8joY/Gjn21ilIg6XMcv10yhHQopDumLY6HOYJGLaNfJzfKyMlTMDChzkgLkKIIN01U+
         FFepRS6fxDMvjdbL2CV7b9tghck8lOcxrddSQ4SH4u+5jkCbVJV0Dd03/yBS+cJamStm
         taZw==
X-Gm-Message-State: AOJu0YzuLgLVGyrWmlLn3IJunZ/qPkH4cYjFfozMr5HuRZcjIjixBuxs
	+rmZZ574SqYE8VD4qtCfl252w4D+Eo4UXEeXvtiW6t6WPfaDndNfOSkEq51RVJ1M6n0mu0t/HUt
	jXw==
X-Google-Smtp-Source: AGHT+IGGf71nIP5YN9DMXPrh3Ny4KHnDmPfhv6X1EDcC2lJIByupjzHqtCY7Y0Ow4FzYH3bftMA6W+7ND4A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2e8e:b0:29a:75cd:14d6 with SMTP id
 sn14-20020a17090b2e8e00b0029a75cd14d6mr1717pjb.7.1708716836612; Fri, 23 Feb
 2024 11:33:56 -0800 (PST)
Date: Fri, 23 Feb 2024 11:33:54 -0800
In-Reply-To: <f393da364d3389f8e65c7fae3e5d9210ffe7a2db.1702974319.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1702974319.git.isaku.yamahata@intel.com> <f393da364d3389f8e65c7fae3e5d9210ffe7a2db.1702974319.git.isaku.yamahata@intel.com>
Message-ID: <ZdjzIgS6EAeCsUue@google.com>
Subject: Re: [PATCH v3 3/4] KVM: X86: Add a capability to configure bus
 frequency for APIC timer
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com, 
	Vishal Annapurve <vannapurve@google.com>, Jim Mattson <jmattson@google.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 19, 2023, Isaku Yamahata wrote:
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 7025b3751027..cc976df2651e 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7858,6 +7858,20 @@ This capability is aimed to mitigate the threat that malicious VMs can
>  cause CPU stuck (due to event windows don't open up) and make the CPU
>  unavailable to host or other VMs.
>  
> +7.34 KVM_CAP_X86_BUS_FREQUENCY_CONTROL

BUS_FREQUENCY_CONTROL is simultaneously too long, yet not descriptive enough.
Depending on whether people get hung up on nanoseconds not being a "frequency",
either KVM_CAP_X86_APIC_BUS_FREQUENCY or KVM_CAP_X86_APIC_BUS_CYCLES_NS.

Also, this series needs to be rebased onto kvm-x86/next.

> +:Architectures: x86
> +:Target: VM
> +:Parameters: args[0] is the value of apic bus clock frequency
> +:Returns: 0 on success, -EINVAL if args[0] contains invalid value for the
> +          frequency, or -ENXIO if virtual local APIC isn't enabled by
> +          KVM_CREATE_IRQCHIP, or -EBUSY if any vcpu is created.
> +
> +This capability sets the APIC bus clock frequency (or core crystal clock
> +frequency) for kvm to emulate APIC in the kernel.  The default value is 1000000
> +(1GHz).

If we're going to add a capability, might as well make KVM's default value
discoverable.

This also needs to clarify the units.  Having to count the number of zeros in the
code to figure that out is ridiculous.

And as Xiaoyao, this is NOT the core crystal clock.  Though conversely, this
documentation should make it clear that setting CPUID 0x15 is userspace's problem.
E.g.

7.35 KVM_CAP_X86_APIC_BUS_FREQUENCY
-----------------------------------

:Architectures: x86
:Target: VM
:Parameters: args[0] is the desired APIC bus clock rate, in nanoseconds
:Returns: 0 on success, -EINVAL if args[0] contains invalid value for the
          frequency, or -ENXIO if virtual local APIC isn't enabled by
          KVM_CREATE_IRQCHIP, or -EBUSY if any vcpu is created.

This capability sets VM's APIC bus clock frequency, used by KVM's in-kernel
virtual APIC when emulating APIC timers.  KVM's default value can be retrieved
by KVM_CHECK_EXTENSION.

Note: Userspace is responsible for correctly configuring CPUID 0x15, a.k.a. the
core crystal clock frequency, if a non-zero CPUID 0x15 is exposed to the guest.

>  8. Other capabilities.
>  ======================
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d7d865f7c847..97f81d612366 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4625,6 +4625,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_ENABLE_CAP:
>  	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
>  	case KVM_CAP_IRQFD_RESAMPLE:
> +	case KVM_CAP_X86_BUS_FREQUENCY_CONTROL:
>  		r = 1;

And instead of returning '1', return APIC_BUS_CYCLE_NS_DEFAULT (which is amusingly
also '1', but there's no reason to rely on that, it's unnecessarily confusing).

>  		break;
>  	case KVM_CAP_EXIT_HYPERCALL:
> @@ -6616,6 +6617,38 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		}
>  		mutex_unlock(&kvm->lock);
>  		break;
> +	case KVM_CAP_X86_BUS_FREQUENCY_CONTROL: {
> +		u64 bus_frequency = cap->args[0];
> +		u64 bus_cycle_ns;
> +
> +		if (!bus_frequency)
> +			return -EINVAL;
> +		/* CPUID[0x15] only support 32bits.  */

So?  This capability might exist to play nice with TDX forcing CPUID 0x15, but
that doesn't mean the capability is beholden to CPUID 0x15.

> +		if (bus_frequency != (u32)bus_frequency)
> +			return -EINVAL;
> +
> +		/* Cast to avoid 64bit division on 32bit platform. */
> +		bus_cycle_ns = 1000000000UL / (u32)bus_frequency;

Why take the userspace value as a frequency?  That will unnecessarily result in
loss of fidelity if 1000000000UL isn't cleanly disibile by bus_frequency, e.g.
reversing the math in the Hyper-V code will yield the "wrong" frequency.

> +		if (!bus_cycle_ns)

This needs to guard against overflow in tmict_to_ns().  The max divide count is
14, I think?  Whatever this yields:

	apic->divide_count = 0x1 << (tmp2 & 0x7);

So from that, we can derive the max allowed bus_cycle_ns.

> +			return -EINVAL;

Use break, like literally every other case statement.  Burying a return in the
middle of this pile will result in breakage if kvm_vm_ioctl_enable_cap() ever
gains an epilogue.

> +
> +		r = 0;
> +		mutex_lock(&kvm->lock);
> +		/*
> +		 * Don't allow to change the frequency dynamically during vcpu
> +		 * running to avoid potentially bizarre behavior.
> +		 */
> +		if (kvm->created_vcpus)
> +			r = -EBUSY;

EINVAL, not EBUSY, because userspace can't magically uncreate vCPUs.

> +		/* This is for in-kernel vAPIC emulation. */

Meh, just drop the comment.  Same for the one above created_vcpus, it's fairly
self-explantory.

> +		else if (!irqchip_in_kernel(kvm))
> +			r = -ENXIO;

This should go before created_vcpus, e.g. creating a vCPU shouldn't change the
error code.

> +
> +		if (!r)

Make this an else...

> +			kvm->arch.apic_bus_cycle_ns = bus_cycle_ns;

> +		mutex_unlock(&kvm->lock);
> +		return r;

		break;

Something like:

	case KVM_CAP_X86_APIC_BUS_FREQUENCY: {
		u64 bus_cycle_ns = cap->args[0];

		r = -EINVAL;
		if (!bus_frequency || bus_frequency > (whatever cause overflow))
			break;

		r = 0;
		mutex_lock(&kvm->lock);
		if (!irqchip_in_kernel(kvm))
			r = -ENXIO;
		else if (kvm->created_vcpus)
			r = -EINVAL;
		else
			kvm->arch.apic_bus_cycle_ns = bus_cycle_ns;
		mutex_unlock(&kvm->lock);
		break;
	}


