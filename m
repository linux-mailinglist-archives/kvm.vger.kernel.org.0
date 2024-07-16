Return-Path: <kvm+bounces-21734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD32C9332D5
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 22:17:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 782AE1F24B1A
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 20:17:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDF3F1A0725;
	Tue, 16 Jul 2024 20:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ndSvZI7Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B89A249F5
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 20:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721161052; cv=none; b=kM+gd6JEVsjuKdOacp/rtMsHtvTXLubcDhZRtWnD38O+y+1JuH6h5glV5OtQalsc59ZVd0VFQ8iMq2bvHPUbAW4ciCYCDPRl3O6CZ0jjIualyH2EeVwErxiXgUfQvbrm4gVaAuF06zTpUgNhGnVtvf8bhT9BubcIYhm3t1nZUnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721161052; c=relaxed/simple;
	bh=4i0tukDdryBy+1o7Tb1p58HpS8KOuPhwIPWJfouqnD0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EGOPIOQaG76osfl7EZyEmrHfjnFEbIAD2y4BmjBbjCJkvzLWoFExnWMpskV7cepRG3aJQ+D8tp2ZHnlNApkYdzqxYrH3gCqZS/Ed5gi6lHS3XWy6IiaiV2LgYMS4Dezi+kxixk9uVpoHb+xRMGips8crNx5gj11eohgFWeop0Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ndSvZI7Q; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7633a1f50b5so5104670a12.2
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 13:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721161049; x=1721765849; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=elyCeO1yxP+oLhFpLqA+ERVkMqI51S2kQKHZu0TLY8I=;
        b=ndSvZI7Qm2jHdJBHeuLFsYmyPkPR76i2jZmLOIEinvBz7EC1SRD2C4umMHFgBI2jW7
         tj6LK+GcG2wRtjkF2MW5kTMdg0pIyI8N1cIuXXVyt+emN8mq9JtJpkgKncjSpeqF0pO5
         dgAsWPLP4b4qUecXd95R/24NCQCGfPOdziR+tpJQjunYJUW8l/PagTXv2YGUFqVDgi5+
         CIBBf3ph3MOBBucTf0MOZWn+Z0/Xt2yZ8Zt1QVRlMT0c83xN8wOiMBnEtorJ+CmH+NHn
         YJDtjG5xXGdlfftcxMz3Iw9inTlHupTtI4oWJfC+xVlL/uL5j4WjPa0Xvlu6xjIGSgPW
         WDvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721161049; x=1721765849;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=elyCeO1yxP+oLhFpLqA+ERVkMqI51S2kQKHZu0TLY8I=;
        b=UkKSrmMIknimWV4H/4Ujgmpe+IDR2LVEu3D1tponPxNFxu6NocEaalZdIw7grYZZv2
         kY73eperEvJEQ6U414JNPUiAZov5tQFe4KAVCsfZjutXDRLDWhp74FumAWudv4RkWvuL
         /k4mRP525Rwd2QeftybXzDDdjR3lCUwBHrvPjPBYes/yIweX4hJ5X5QHqxjY0QcCLkKl
         o5QrriIPWOYR28RODN8n/mhIXsMwWHXjjdlv209YWl/eAKGEBLmKOJBCcG3cf0gPuKjb
         utMvo1yMhI5MdyMv+iTKQZIITEF2BRlD7qdvvp7AC5Hq1yyjz2pA6ORH4jCLuuBg04Uk
         8FyA==
X-Gm-Message-State: AOJu0YyCC+PrB4ccJxTFNUOwuP3zUES55nyWqF8k/zCwpKewE3/YTyNw
	4Qfj6NqQQbYtuBsR0I9IcG6v9SxeP1Euvgv/sPKxxJKMMR+16oDZDDWQA9SV3WjNI3049PeKFk1
	j/Q==
X-Google-Smtp-Source: AGHT+IHDXZIblc1DmqnAZKCixA0rT+GjSDpG2dS2nuRIcMK0CzQIpKzYZw7kiYteKVZq/Id57VgeTu7cxrw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:445:b0:694:4311:6eb4 with SMTP id
 41be03b00d2f7-795c64260f6mr9088a12.8.1721161048351; Tue, 16 Jul 2024 13:17:28
 -0700 (PDT)
Date: Tue, 16 Jul 2024 13:17:27 -0700
In-Reply-To: <f2a46971d37ee3bf32ff33dc730e16bf0f755410.1721091397.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <f2a46971d37ee3bf32ff33dc730e16bf0f755410.1721091397.git.isaku.yamahata@intel.com>
Message-ID: <ZpbVVyp3YvCJp3Am@google.com>
Subject: Re: [PATCH] KVM: x86: Add GPA limit check to kvm_arch_vcpu_pre_fault_memory()
From: Sean Christopherson <seanjc@google.com>
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, isaku.yamahata@gmail.com, 
	Paolo Bonzini <pbonzini@redhat.com>, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 15, 2024, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add GPA limit check to kvm_arch_vcpu_pre_fault_memory() with guest
> maxphyaddr and kvm_mmu_max_gfn().
> 
> The KVM page fault handler decides which level of TDP to use, 4-level TDP
> or 5-level TDP based on guest maxphyaddr (CPUID[0x80000008].EAX[7:0]), the
> host maxphyaddr, and whether the host supports 5-level TDP or not.  The
> 4-level TDP can map GPA up to 48 bits, and the 5-level TDP can map GPA up
> to 52 bits.  If guest maxphyaddr <= 48, KVM uses 4-level TDP even when the
> host supports 5-level TDP.
> 
> If we pass GPA > beyond the TDP mappable limit to the TDP MMU fault handler
> (concretely GPA > 48-bits with 4-level TDP), it will operate on GPA without
> upper bits, (GPA & ((1UL < 48) - 1)), not the specified GPA.  It is not
> expected behavior.  It wrongly maps GPA without upper bits with the page
> for GPA with upper bits.
> 
> KVM_PRE_FAULT_MEMORY calls x86 KVM page fault handler, kvm_tdp_page_fault()
> with a user-space-supplied GPA without the limit check so that the user
> space can trigger WARN_ON_ONCE().  Check the GPA limit to fix it.

Which WARN?

> - For non-TDX case (DEFAULT_VM, SW_PROTECTED_VM, or SEV):
>   When the host supports 5-level TDP, KVM decides to use 4-level TDP if
>   cpuid_maxphyaddr() <= 48.  cpuid_maxhyaddr() check prevents
>   KVM_PRE_FAULT_MEMORY from passing GFN beyond mappable GFN.

Hardening against cpuid_maxphyaddr() should be out of scope.  We don't enforce
it for guest faults, e.g. KVM doesn't kill the guest if allow_smaller_maxphyaddr
is false and the GPA is supposed to be illegal.  And trying to enforce it here is
a fool's errand since userspace can simply do KVM_SET_CPUID2 to circumvent the
restriction.

> - For TDX case:
>   We'd like to exclude shared bit (or gfn_direct_mask in [1]) from GPA
>   passed to the TDP MMU so that the TDP MMU can handle Secure-EPT or
>   Shared-EPT (direct or mirrored in [1]) without explicitly
>   setting/clearing the GPA (except setting up the TDP iterator,
>   tdp_iter_refresh_sptep()).  We'd like to make kvm_mmu_max_gfn() per VM
>   for TDX to be 52 or 47 independent of the guest maxphyaddr with other
>   patches.
> 
> Fixes: 6e01b7601dfe ("KVM: x86: Implement kvm_arch_vcpu_pre_fault_memory()")
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4e0e9963066f..6ee5af55cee1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4756,6 +4756,11 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  	u64 end;
>  	int r;
>  
> +	if (range->gpa >= (1UL << cpuid_maxphyaddr(vcpu)))
> +		return -E2BIG;
> +	if (gpa_to_gfn(range->gpa) > kvm_mmu_max_gfn())
> +		return -E2BIG;


Related to my thoughts on making kvm_mmu_max_gfn() and rejecting aliased memslots,
I think we should add a common helper that's used by kvm_arch_prepare_memory_region()
and kvm_arch_vcpu_pre_fault_memory() to reject GPAs that are disallowed.

https://lore.kernel.org/all/ZpbKqG_ZhCWxl-Fc@google.com

> +
>  	/*
>  	 * reload is efficient when called repeatedly, so we can do it on
>  	 * every iteration.
> 
> base-commit: c8b8b8190a80b591aa73c27c70a668799f8db547
> -- 
> 2.45.2
> 

