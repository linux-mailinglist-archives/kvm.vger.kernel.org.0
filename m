Return-Path: <kvm+bounces-11699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15766879F26
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 23:55:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98DB61F22D4F
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 22:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC70744C8C;
	Tue, 12 Mar 2024 22:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1wkv9pDY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4927F41740
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 22:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710284111; cv=none; b=XB7ryO9oauQyGAIyIh/cTWwA1UzqDNIXMxTAp/aQ84a6DJqYybqOULX65aFz3OuMYgclADQ8rQMv99lDiVKlZkaBIo9OdFNcT3Oh3K3cI8fkTj1m3dl7K1Mmpp9edazPGtPrMN6iv69apMVrj2bWCagZm+AkEVDSApCDso66Jws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710284111; c=relaxed/simple;
	bh=PjTThnS897JBeeLLZ2v/9plHI69Lx4l02jlhaD0hgO4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qv372B3F44KinqNWIh2A0a4EaTUXT5O+MuCp2x1fB48h6SRy/YN3xtZT7ReIv0x5t14eyzseGGYI+fhsUxlWf1fGc60Pg6FXKFyjatr+iy4FBSxflscwQko6kEwxpKOYDkODFwzsQbl9eUGyAdXwB4BlqwRzj4znjcIYXpmO1kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1wkv9pDY; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1dd9ffd1e99so27415655ad.3
        for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 15:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710284109; x=1710888909; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jU95RMg0fdFREnYHW4aRlJKTf827qSXmLhHuHKLFqbs=;
        b=1wkv9pDYiSG5C8sSGQhoZX25SpnzlE63R6NIk9/Zpd1D84bbUgaSJkemcYRhM8ztrg
         5Y7M7eHvjPQ9M5Vxc+BdeYaz0gCu1waL2TT55sS3I72cC7BDdFAYQ6wVUrkbi1kQ3oUu
         nV9XFJ5EgWGw1VrMbhWOolJoRlHPLmqMGg+xvAMEYnAWJ377V8eHpYcgsU/9f0VNsFQG
         gXI4ue/sY4dGyS4oSXvgdQ2rHuMYoQLB4Q/DXEiQ9GXtsS2m9sshp3ch7wnsVxrLgwwM
         m43vB1P2X2m1htb+tfQXbSyJokXccALRxVlxIx/DKdYpJjRIMiIrk+eJ9xhPJsDh2+m/
         ztNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710284109; x=1710888909;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jU95RMg0fdFREnYHW4aRlJKTf827qSXmLhHuHKLFqbs=;
        b=gn9ybkxSsakewSa66Ax0gAHOcs1SZMhC9zW9shcpskQjvR7JT/HBxVcj7kQRcVkRwZ
         i/AJ2QqIPBkkkDWiySXDHiE/SGC9x1KzRdffXWISSHfHRNqznZHIRDEchu3HO6xL9YHo
         RLvLyJMFTU66Fn6pW6JDt/TukYwrf7rrt5Kq93VM0uxNjtq1vuwHq4rwkVw99xSZ/tiY
         wlD4j97BY7A0THvT9jnMFynV8pf/P8y9PZ1aHnmpCEIbcht12kK5KTkf2/swCmVMnzEb
         UVZIX5om/gD5NNnriwx832mlRbuhOq8jJ5jlllAt+xjPhVpFdcqi2e+Yf7BGJ7kblyX2
         hulQ==
X-Forwarded-Encrypted: i=1; AJvYcCU0lROi2oeaFYY8gihmfMe2auEdn2PJ71/QSr5ftgPYkb2sg6p8rHy3zrtko58ldDgcWhZlGeeauHy+jcThW/Y+Ra0D
X-Gm-Message-State: AOJu0Yy2ssdbVJTgWweFERCAptBMoNcbllLa+Vsr6SDnEEhMJ2VHPpNC
	grcRwvETXSYbXVpuCBeeMynMrdBuaiJnoGMh49PjJrklTb+andhwThCyPBLqGfd+Wwv4CkqM5FK
	Dxg==
X-Google-Smtp-Source: AGHT+IEsmFMb35JDWyUf7Z0C3Jb/NUl//hA1C6c4K7I8zAn8oJ3QRU6G6WKtQFWdJ+z8U/3qFn8KpL4ck2Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:244d:b0:1dd:a17f:e7d8 with SMTP id
 l13-20020a170903244d00b001dda17fe7d8mr25271pls.12.1710284109303; Tue, 12 Mar
 2024 15:55:09 -0700 (PDT)
Date: Tue, 12 Mar 2024 15:55:07 -0700
In-Reply-To: <20240219074733.122080-21-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240219074733.122080-1-weijiang.yang@intel.com> <20240219074733.122080-21-weijiang.yang@intel.com>
Message-ID: <ZfDdS8rtVtyEr0UR@google.com>
Subject: Re: [PATCH v10 20/27] KVM: VMX: Emulate read and write to CET MSRs
From: Sean Christopherson <seanjc@google.com>
To: Yang Weijiang <weijiang.yang@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, mlevitsk@redhat.com, 
	john.allen@amd.com, Aaron Lewis <aaronlewis@google.com>, 
	Jim Mattson <jmattson@google.com>, Oliver Upton <oupton@google.com>, 
	Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="us-ascii"

-non-KVM people, +Mingwei, Aaron, Oliver, and Jim

On Sun, Feb 18, 2024, Yang Weijiang wrote:
>  	case MSR_IA32_PERF_CAPABILITIES:
>  		if (data && !vcpu_to_pmu(vcpu)->version)
>  			return 1;

Ha, perfect, this is already in the diff context.

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c0ed69353674..281c3fe728c5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1849,6 +1849,36 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
>  }
>  EXPORT_SYMBOL_GPL(kvm_msr_allowed);
>  
> +#define CET_US_RESERVED_BITS		GENMASK(9, 6)
> +#define CET_US_SHSTK_MASK_BITS		GENMASK(1, 0)
> +#define CET_US_IBT_MASK_BITS		(GENMASK_ULL(5, 2) | GENMASK_ULL(63, 10))
> +#define CET_US_LEGACY_BITMAP_BASE(data)	((data) >> 12)
> +
> +static bool is_set_cet_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u64 data,
> +				   bool host_initiated)
> +{

...

> +	/*
> +	 * If KVM supports the MSR, i.e. has enumerated the MSR existence to
> +	 * userspace, then userspace is allowed to write '0' irrespective of
> +	 * whether or not the MSR is exposed to the guest.
> +	 */
> +	if (!host_initiated || data)
> +		return false;

...

> @@ -1951,6 +2017,20 @@ static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
>  			return 1;
>  		break;
> +	case MSR_IA32_U_CET:
> +	case MSR_IA32_S_CET:
> +		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
> +		    !guest_can_use(vcpu, X86_FEATURE_IBT))
> +			return 1;

As pointed out by Mingwei in a conversation about PERF_CAPABILITIES, rejecting
host *reads* while allowing host writes of '0' is inconsistent.  Which, while
arguably par for the course for KVM's ABI, will likely result in the exact problem
we're trying to avoid: killing userspace because it attempts to access an MSR KVM
has said exists.

PERF_CAPABILITIES has a similar, but opposite, problem where KVM returns a non-zero
value on reads, but rejects that same non-zero value on write.  PERF_CAPABILITIES
is even more complicated because KVM stuff a non-zero value at vCPU creation, but
that's not really relevant to this discussion, just another data point for how
messed up this all is.

Also relevant to this discussion are KVM's PV MSRs, e.g. MSR_KVM_ASYNC_PF_ACK,
as KVM rejects attempts to write '0' if the guest doesn't support the MSR, but
if and only userspace has enabled KVM_CAP_ENFORCE_PV_FEATURE_CPUID.

Coming to the point, this mess is getting too hard to maintain, both from a code
perspective and "what is KVM's ABI?" perspective.

Rather than play whack-a-mole and inevitably end up with bugs and/or inconsistencies,
what if we (a) return KVM_MSR_RET_INVALID when an MSR access is denied based on
guest CPUID, (b) wrap userspace MSR accesses at the very top level and convert
KVM_MSR_RET_INVALID to "success" when KVM reported the MSR as savable and userspace
is reading or writing '0', and (c) drop all of the host_initiated checks that
exist purely to exempt userspace access from guest CPUID checks.

The only possible hiccup I can think of is that this could subtly break userspace
that is setting CPUID _after_ MSRs, but my understanding is that we've agreed to
draw a line and say that that's unsupported.  And I think it's low risk, because
I don't see how code like this:

	case MSR_TSC_AUX:
		if (!kvm_is_supported_user_return_msr(MSR_TSC_AUX))
			return 1;

		if (!host_initiated &&
		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
			return 1;

		if (guest_cpuid_is_intel(vcpu) && (data >> 32) != 0)
			return 1;

can possibly work if userspace sets MSRs first.  The RDTSCP/RDPID checks are
exempt, but the vendor in guest CPUID would be '0', not Intel's magic string,
and so setting MSRs before CPUID would fail, at least if the target vCPU model
is Intel.

P.S. I also want to rename KVM_MSR_RET_INVALID => KVM_MSR_RET_UNSUPPORTED, because
I can never remember that "invalid" doesn't mean the value was invalid, it means
the MSR index was invalid.

It'll take a few patches, but I believe we can end up with something like this:

static bool kvm_is_msr_to_save(u32 msr_index)
{
	unsigned int i;

	for (i = 0; i < num_msrs_to_save; i++) {
		if (msrs_to_save[i] == msr_index)
			return true;
	}

	return false;
}
typedef int (*msr_uaccess_t)(struct kvm_vcpu *vcpu, u32 index, u64 *data,
			     bool host_initiated);

static __always_inline int kvm_do_msr_uaccess(struct kvm_vcpu *vcpu, u32 msr,
					      u64 *data, bool host_initiated,
					      enum kvm_msr_access rw,
					      msr_uaccess_t msr_uaccess_fn)
{
	const char *op = rw == MSR_TYPE_W ? "wrmsr" : "rdmsr";
	int ret;

	BUILD_BUG_ON(rw != MSR_TYPE_R && rw != MSR_TYPE_W);

	/*
	 * Zero the data on read failures to avoid leaking stack data to the
	 * guest and/or userspace, e.g. if the failure is ignored below.
	 */
	ret = msr_uaccess_fn(vcpu, msr, data, host_initiated);
	if (ret && rw == MSR_TYPE_R)
		*data = 0;

	if (ret != KVM_MSR_RET_UNSUPPORTED)
		return ret;

	/*
	 * Userspace is allowed to read MSRs, and write '0' to MSRs, that KVM
	 * reports as to-be-saved, even if an MSRs isn't fully supported.
	 * Simply check that @data is '0', which covers both the write '0' case
	 * and all reads (in which case @data is zeroed on failure; see above).
	 */
	if (kvm_is_msr_to_save(msr) && !*data)
		return 0;

	if (!ignore_msrs) {
		kvm_debug_ratelimited("unhandled %s: 0x%x data 0x%llx\n",
				      op, msr, *data);
		return ret;
	}

	if (report_ignored_msrs)
		kvm_pr_unimpl("ignored %s: 0x%x data 0x%llx\n", op, msr, *data);
	
	return 0;
}

