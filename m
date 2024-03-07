Return-Path: <kvm+bounces-11319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C638A87562A
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 19:36:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 766EC2884BF
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 18:36:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B36FD133406;
	Thu,  7 Mar 2024 18:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jo3kuQ5w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B61C12DDA2
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 18:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709836558; cv=none; b=hee/sLjnk3t+p2BMyiICBIZdtlL/SncL3Tk4ERH96J/VzHCM5mqi/UGUBHlE4/j6fqp/MEHq+U8WDE8FsUkYh5X8lMfzqMQ97eOV5RmQjSk33a7f5kFwAHVyX/s4l62vU4Oe5nQ2MYMl4x8no5HJtFNCCiMrrQWDpvyt1UISPXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709836558; c=relaxed/simple;
	bh=iEEp31JydCDbDDWUypoDZzp7A7ngZJq4AsyQqSmOJcQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d8+7vJtg7XjmAQgU8t6VFZ6AkVT8/BOD2md6NdUWO27KFTiDi6RN68cNFKpEmm3bD98PGFkcp5Yco6bcHVgU+IjyoyqH+W5Fc63kiA4y9W9JyfmN9KM0dHyV4JkGbpS+xDCsPI+s5IPohAqNWskPG6C3w1P8Q41TvGZjD80c1x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jo3kuQ5w; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5f38d676cecso29277607b3.0
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 10:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709836556; x=1710441356; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6gcB7rs/ZShkZQFSJOEoG/IHLW4vs94Ivr+W9yFak8E=;
        b=jo3kuQ5wbdX/qCJSNc2SUfUcCL8no5pI9za0iS5c5rznTyUPsWskbhr5hWtZ1Cg5h1
         yGDB/dPRvw3ECkaDmPO+P1twDgLMSnk35kj0VR8TKYRIvcC1h8gyv3/vOxyPxXEHaMcl
         6aKvofj9YvbY0ER8y8XzYFvdbHnr4yYEDK0Wvdme9mAjHoVrYxEvcjyMYFejVC9gRuY7
         6AbOYloTfqq2PavZ+j2o2XigebgUZ0TvlFKO5rbaSvoIG0gm4R19BxTmkZ1OzpucFl41
         FOl3xdxq7xyHes2BfBGVEdXN6D8RWVrnvq0Bhl8qKyLr8I1UFsl8e0uBlA0hTxr3Hxt4
         2o+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709836556; x=1710441356;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6gcB7rs/ZShkZQFSJOEoG/IHLW4vs94Ivr+W9yFak8E=;
        b=WNqimRn2veOegNo6GwM8dMlX6rbi0AQQVskilPkMCAuYY7P+wcTIEDy8kQn/NNXqG2
         XZ+wvaJ+aWCo/KIfb/8d3GSEMXeSpFf0nL8Oh67+2DZsXnKTqkOp8vg0X/k1wQTXTtdo
         bK8ebpNQMG+bxZ2fAWTsNCxJYKjE/RUZ78MdrFqEnHPlM/y2LlkfssQuVVpB6n2f4A1t
         DW0RnY6cYCw82M73coxvnmBlJQzNBM9Sa8hDn+QaAO8VU52Ap8F+bbbvQ2tR8AWcHloF
         PVySKPJqxCXzjSnkooXbqFdRRisq4EMXyCWgBdStiko2zT3DBNzuR7hr+sUtMyFEYeRb
         BxZg==
X-Forwarded-Encrypted: i=1; AJvYcCXck1t/3aRBDXUDQhjHe0Y/8TirqY3nOae5+fuxwHL2C3sDtl6te4IisY8OJFGM+sA47HmXIfqrfW+VFpRxvMXpWnPl
X-Gm-Message-State: AOJu0YybEizilMBc4bjMycSYd4iLPcTP7Icuwt6tkFbnEEprrR7ObFTl
	3UZFykdZtFes/Fo3VoAaNDXHQMUrrY7K6JsQ3oClDOwLQING6kfJAISxpStRaPM8nubKA/TWY5J
	A4w==
X-Google-Smtp-Source: AGHT+IHhc6mNz1ANHVaB8ZUkzXjf7omeklnG6f34tO4A4cjqMQbKxS6N5ItrFCgNVIFlWJO4BMBghA0Z8Wk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3a03:0:b0:dc7:463a:46d2 with SMTP id
 h3-20020a253a03000000b00dc7463a46d2mr49728yba.0.1709836556326; Thu, 07 Mar
 2024 10:35:56 -0800 (PST)
Date: Thu, 7 Mar 2024 10:35:54 -0800
In-Reply-To: <23a1af5f-e08d-4cf6-b4bd-8cfb6266f441@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240301074423.643779-1-sandipan.das@amd.com> <CALMp9eRbOQpVsKkZ9N1VYTyOrKPWCmvi0B5WZCFXAPsSkShmEA@mail.gmail.com>
 <ZeYz7zPGcIQSH_NI@google.com> <23a1af5f-e08d-4cf6-b4bd-8cfb6266f441@amd.com>
Message-ID: <ZeoJCrx7K_FLGLNA@google.com>
Subject: Re: [PATCH] KVM: x86: Do not mask LVTPC when handling a PMI on AMD platforms
From: Sean Christopherson <seanjc@google.com>
To: Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	mlevitsk@redhat.com, vkuznets@redhat.com, mizhang@google.com, 
	tao1.su@linux.intel.com, andriy.shevchenko@linux.intel.com, 
	ravi.bangoria@amd.com, ananth.narayan@amd.com, nikunj.dadhania@amd.com, 
	santosh.shukla@amd.com, manali.shukla@amd.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 07, 2024, Sandipan Das wrote:
> On 3/5/2024 2:19 AM, Sean Christopherson wrote:
> The following are excerpts from some changes that I have been working on. Instead
> of a boolean flag, this saves the compatible vendor in kvm_vcpu_arch and tries
> to match it against X86_VENDOR_* values. The goal is to replace
> guest_cpuid_is_{intel,amd_or_hygon}() with
> guest_vendor_is_compatible(vcpu, X86_VENDOR_{INTEL,AMD}). Is this viable?
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d271ba20a0b2..c4ada5b12fc3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1042,6 +1042,7 @@ struct kvm_vcpu_arch {
>  #if IS_ENABLED(CONFIG_HYPERV)
>         hpa_t hv_root_tdp;
>  #endif
> +       u8 compat_vendor;

Ooh, clever, much better than my idea of using multiple booleans.

One potential flaw though: the vCPU structure is zero-allocated, and so this will
get a false positive on X86_VENDOR_INTEL if userspace never sets guest CPUID.

That might actually be desirable though?  E.g. it's closer to KVM's current
behavior.  Maybe.  I dunno :-)

Anyways, KVM *does* need to be consistent, i.e. the default needs to yield the
same behavior as guest CPUID without entry 0x0 so that setting *other* CPUID
entries doesn't change from INTEL=>UNKNOWN.  More below.

>  };
> 
>  struct kvm_lpage_info {
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index adba49afb5fe..00170762e72a 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -376,6 +376,13 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>         kvm_hv_set_cpuid(vcpu, kvm_cpuid_has_hyperv(vcpu->arch.cpuid_entries,
>                                                     vcpu->arch.cpuid_nent));
> 
> +       if (guest_cpuid_is_intel_compatible(vcpu))
> +               vcpu->arch.compat_vendor = X86_VENDOR_INTEL;
> +       else if (guest_cpuid_is_amd_or_hygon(vcpu))
> +               vcpu->arch.compat_vendor = X86_VENDOR_AMD;
> +       else
> +               vcpu->arch.compat_vendor = X86_VENDOR_UNKNOWN;

I would prefer to provide a helper for just getting the compat vendor.  E.g.

static u8 kvm_vcpu_get_compat_vendor(struct kvm_vcpu *vcpu)
{
	struct kvm_cpuid_entry2 *best;

	best = kvm_find_cpuid_entry(vcpu, 0);
	if (!best)
		return ???;

	if (is_guest_vendor_intel(best->ebx, best->ecx, best->edx) ||     
	    is_guest_vendor_centaur(best->ebx, best->ecx, best->edx) ||   
	    is_guest_vendor_zhaoxin(best->ebx, best->ecx, best->edx))
		return X86_VENDOR_INTEL;

	if (is_guest_vendor_amd(best->ebx, best->ecx, best->edx) ||
	    is_guest_vendor_hygon(best->ebx, best->ecx, best->edx))
		return X86_VENDOR_AMD;

	return X86_VENDOR_UNKNOWN;
}

and then a follow-up patch can remove guest_cpuid_is_amd_or_hygon() once all
users are converted to guest_vendor_is_compatible().	

