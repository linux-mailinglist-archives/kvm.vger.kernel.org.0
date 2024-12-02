Return-Path: <kvm+bounces-32842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E2079E0B5A
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 19:53:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 37689B35CFB
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 18:30:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DADAB1DE2D4;
	Mon,  2 Dec 2024 18:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yUceKNg2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CD71DDC28
	for <kvm@vger.kernel.org>; Mon,  2 Dec 2024 18:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733164228; cv=none; b=csNk4eKv+g6rT7MoMZFYkzx1JhhIdY2nbU0u7+Z80RK/QGi9MTPrKWE3waDkHybZhVmEk5VwkZTpZKPoVHiUcmSh6yRoMc5VtHQ4/p1iIChq2ItWd2wGcORm2ielb72vdqYliLBvdiifzc8EHNwd6JIGGEuyle58rI1YmuYy9oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733164228; c=relaxed/simple;
	bh=jfYPmuPcseGgs18akshQku6eeOGrei89q0mSBpAdsoM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=exzA313+lQWP619vMJZ9vPVCccBYQq9NKB9U7vTV9TG7qC5/ymTI9fD5ATvbu/prGzTv2lCWgWCqv1nTtFPeF4b7NHu+iA1lgFGn1gvXnXQwaP3BfdiejLxJXIYumALZh+qFrdboqvZWX4scDI6I9sgfIChxCZ/RDsCWaxDQTzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yUceKNg2; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee4f3785f6so3346733a91.2
        for <kvm@vger.kernel.org>; Mon, 02 Dec 2024 10:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733164225; x=1733769025; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qUy8x4/Y3tpGiB0Zi5q2SYxfMtOPsbv3PZOW89BEvLY=;
        b=yUceKNg2NBm8GBDkDfBVit5QxYy6v/bjS6bpddIWFnoch3XX9VedbsbuQDVP7ZHgoY
         ZQ8ki1Z6bpAe8H9xNyX/JFzJxZqsafrZd8An9J5jA/ptMeKkvKWwnTHuLm5CKQ0iQfT3
         nuFkTtA2G8lKCbnyjc21Lz7zlC3EKfJ524AP0dUaOsgBevQKXLZVCKUhycVThvl0g87y
         EJ+szr9Eg+mGicPxeH5OhHTXGrgYd3msZYm2+8gTw5ZrJBD22N9tYGr8KUhOIDZUZFL2
         eAts9ddxB/gKrK4OOw9XSCo8GS3ZsXXX8PWI6/EwcmKHlELYaF9oSJks8ANJSmEAnwOI
         b0kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733164225; x=1733769025;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qUy8x4/Y3tpGiB0Zi5q2SYxfMtOPsbv3PZOW89BEvLY=;
        b=ahEduXIWcA9vckJiczj0yOlTUcLCs30CuoN8oXTEs7M3Hs1wFG4JHRsDEeW+6DVI5v
         JJd939CsT0EfZmnzMplkh/UYJeSbVXqRqgOirlTp2PmQKHvzXtd9fDEKinUUuMLV25h5
         cOuaKq4n22jeU0iz4mex19qty6gK71MR4JxsDxa/WXVzcL39MBKmsany08VwB1ZilgkF
         YFWnJXIQyK8Tg62VKwh1GG4hFEb0iCtNLASZXdIB9kx3Pr6Qc12+40K8UbGm+MZ+3FDl
         c5Zw1VEU0bmPyjSNj3AVTBc1NyVNWs0zQa+21Fd3t3jSnqRyAf/WVgRJxcL4I8CBY28v
         9kDg==
X-Forwarded-Encrypted: i=1; AJvYcCWdT62Yr/A/8CDBGP/g8ABGtxayys0JZQ1flbAKHQigg/fcMF2tAKjgKLQ79YoDEkpGqiM=@vger.kernel.org
X-Gm-Message-State: AOJu0YySpAyWX01N4li+Wz+HM7owwz27J9TZU6J99jdcevKzC4YuH1hp
	3S/6fB5q6Ac7Q5FWAFq9onGYX2T68N8h+hQ9zTGOZU/7/eGA7yRqIxLJs9IlGGC3KdwDEthB3ix
	JRQ==
X-Google-Smtp-Source: AGHT+IGwaNwxXMXEV3k2ZvbOJITQYIG7oMCZBKKK13JflpmqU8EUD4VR+m3D0LjUFvc/1eB/zqc8rBfXtAw=
X-Received: from pjbli9.prod.google.com ([2002:a17:90b:48c9:b0:2e9:38ea:ca0f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c8e:b0:2ee:8430:b831
 with SMTP id 98e67ed59e1d1-2ee8430ba90mr13618408a91.2.1733164225516; Mon, 02
 Dec 2024 10:30:25 -0800 (PST)
Date: Mon, 2 Dec 2024 10:30:24 -0800
In-Reply-To: <20241128132834.15126-3-amit@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1732219175.git.jpoimboe@kernel.org> <20241128132834.15126-1-amit@kernel.org>
 <20241128132834.15126-3-amit@kernel.org>
Message-ID: <Z038wBhWfVAFNhJJ@google.com>
Subject: Re: [RFC PATCH v3 2/2] x86: kvm: svm: advertise ERAPS (larger RSB)
 support to guests
From: Sean Christopherson <seanjc@google.com>
To: Amit Shah <amit@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	linux-doc@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com, 
	bp@alien8.de, tglx@linutronix.de, peterz@infradead.org, jpoimboe@kernel.org, 
	pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com, 
	dave.hansen@linux.intel.com, hpa@zytor.com, pbonzini@redhat.com, 
	daniel.sneddon@linux.intel.com, kai.huang@intel.com, sandipan.das@amd.com, 
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com, david.kaplan@amd.com, 
	dwmw@amazon.co.uk, andrew.cooper3@citrix.com
Content-Type: text/plain; charset="us-ascii"

KVM: SVM:

Please through the relevant maintainer handbooks, there are warts all over.

  Documentation/process/maintainer-kvm-x86.rst
  Documentation/process/maintainer-tip.rst

And the shortlog is wrong.  The patch itself is also broken.  KVM should (a) add
support for virtualizing ERAPS and (b) advertise support to *userspace*.  The
userspace VMM ultimately decides what to expose/enable for the guest.

On Thu, Nov 28, 2024, Amit Shah wrote:
> From: Amit Shah <amit.shah@amd.com>
> 
> AMD CPUs with the ERAPS feature (Zen5+) have a larger RSB (aka RAP).

Please spell out ERAPS at least once (I assume it's "Enhanced RAPs"?) and very
briefly document what it does.

> While the new default RSB size is used on the host without any software
> modification necessary, the RSB size for guests is limited to the older

Please describe hardware behavior, and make it abundantly clear that the changelog
is talking about hardware behavior.  One of my pet peeves (understatement) with
the APM is that it does a shit job of explaining the actual architectural behavior.

> value (32 entries) for backwards compatibility.

Backwards compatibility with what?  And how far back?  E.g. have CPUs with a RAP
always had 32 entries?

> With this patch, KVM

No "this patch"

> enables guest mode 

Use imperative mood.

> to also use the default number of entries by setting

"default" is clearly wrong, since the *default* behavior is to use

> the new ALLOW_LARGER_RAP bit in the VMCB.

I detest the "ALLOW_LARGER" name.  "Allow" implies the guest somehow has a choice.
And "Larger" implies there's an even larger size

And again, please explicitly describe what this bit does.

> The two cases for backward compatibility that need special handling are
> nested guests, and guests using shadow paging

Guests don't use shadow paging, *KVM* uses 

> (or when NPT is disabled):

"i.e", not "or".  "Or" makes it sound like "NPT is disabled" is separate case
from shadow paging.

> For nested guests: the ERAPS feature adds host/guest tagging to entries
> in the RSB, but does not distinguish between ASIDs.  On a nested exit,
> the L0 hypervisor instructs the hardware (via another new VMCB bit,

I strongly suspect this was copied from the APM.  Please don't do that.  State
what change is being for *KVM*, not for "the L0 hypervisor".  This verbiage mixes
hardware behavior with software behavior, which again is why I hate much of the
APM's wording.

> FLUSH_RAP_ON_VMRUN) to flush the RSB on the next VMRUN to prevent RSB
> poisoning attacks from an L2 guest to an L1 guest.  With that in place,
> this feature can be exposed to guests.

ERAPS can also be advertised if nested virtualization is disabled, no?  I think
it makes sense to first add support for ERAPS if "!nested", and then in a separate
path, add support for ERAPS when nested virtualization is enabled.  Partly so that
it's easier for readers to understand why nested VMs are special, but mainly because
the nested virtualization support is sorely lacking.

> For shadow paging guests: do not expose this feature to guests; only
> expose if nested paging is enabled, to ensure a context switch within
> a guest triggers a context switch on the CPU -- thereby ensuring guest
> context switches flush guest RSB entries.

Huh?

> For shadow paging, the CPU's CR3 is not used for guest processes, and hence
> cannot benefit from this feature.

What does that have to do with anything?

> Signed-off-by: Amit Shah <amit.shah@amd.com>
> ---
>  arch/x86/include/asm/svm.h |  6 +++++-
>  arch/x86/kvm/cpuid.c       | 18 ++++++++++++++++--
>  arch/x86/kvm/svm/svm.c     | 29 +++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.h     | 15 +++++++++++++++
>  4 files changed, 65 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 2b59b9951c90..f8584a63c859 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -129,7 +129,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  	u64 tsc_offset;
>  	u32 asid;
>  	u8 tlb_ctl;
> -	u8 reserved_2[3];
> +	u8 erap_ctl;
> +	u8 reserved_2[2];
>  	u32 int_ctl;
>  	u32 int_vector;
>  	u32 int_state;
> @@ -175,6 +176,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  #define TLB_CONTROL_FLUSH_ASID 3
>  #define TLB_CONTROL_FLUSH_ASID_LOCAL 7
>  
> +#define ERAP_CONTROL_ALLOW_LARGER_RAP 0
> +#define ERAP_CONTROL_FLUSH_RAP 1

Assuming the control enables using the full RAP size, these should be something
like:

#define ERAP_CONTROL_ENABLE_FULL_RAP_MASK	BIT(0)
#define ERAP_CONTROL_FLUSH_RAP_ON_VMRUN		BIT(1)

>  #define V_TPR_MASK 0x0f
>  
>  #define V_IRQ_SHIFT 8
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 097bdc022d0f..dd589670a716 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -803,6 +803,8 @@ void kvm_set_cpu_caps(void)
>  		F(WRMSR_XX_BASE_NS)
>  	);
>  
> +	if (tdp_enabled)
> +		kvm_cpu_cap_check_and_set(X86_FEATURE_ERAPS);
>  	kvm_cpu_cap_check_and_set(X86_FEATURE_SBPB);
>  	kvm_cpu_cap_check_and_set(X86_FEATURE_IBPB_BRTYPE);
>  	kvm_cpu_cap_check_and_set(X86_FEATURE_SRSO_NO);
> @@ -1362,10 +1364,22 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  	case 0x80000020:
>  		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>  		break;
> -	case 0x80000021:
> -		entry->ebx = entry->ecx = entry->edx = 0;
> +	case 0x80000021: {
> +		unsigned int ebx_mask = 0;
> +
> +		entry->ecx = entry->edx = 0;
>  		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
> +
> +		/*
> +		 * Bits 23:16 in EBX indicate the size of the RSB.

Is this enumeration explicitly tied to ERAPS?

> +		 * Expose the value in the hardware to the guest.

__do_cpuid_func() is used to advertise KVM's supported CPUID to host userspace,
not to the guest.

Side topic, what happens when Zen6 adds EVEN_LARGER_RAP?  Enumerating the size of
the RAP suggets it's likely to change in the future.

> +		 */
> +		if (kvm_cpu_cap_has(X86_FEATURE_ERAPS))
> +			ebx_mask |= GENMASK(23, 16);
> +
> +		entry->ebx &= ebx_mask;

This is a waste of code and makes it unnecessarily difficult to read.  Just do:

		if (kvm_cpu_cap_has(X86_FEATURE_ERAPS))
			entry->ebx &= GENMASK(23, 16);
		else
			entry->ebx = 0;

>  		break;
> +	}
>  	/* AMD Extended Performance Monitoring and Debug */
>  	case 0x80000022: {
>  		union cpuid_0x80000022_ebx ebx;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index dd15cc635655..9b055de079cb 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1360,6 +1360,13 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>  	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>  		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
>  
> +	/*
> +	 * If the hardware has a larger RSB, use it in the guest context as
> +	 * well.
> +	 */
> +	if (cpu_feature_enabled(X86_FEATURE_ERAPS) && npt_enabled)

This is wrong.  Userspace owns the vCPU model, not KVM.  If userspace wants to
disable ERAPS for the guest, say because of a hardware vulnerability, then KVM
needs to honor that.

And this should be kvm_cpu_cap_has(), not copy+paste of the code that enables
the KVM capability.

> +		vmcb_set_larger_rap(svm->vmcb);

s/set/enable.  "set" implies a value in this context.

> +
>  	if (kvm_vcpu_apicv_active(vcpu))
>  		avic_init_vmcb(svm, vmcb);
>  
> @@ -3395,6 +3402,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>  	pr_err("%-20s%016llx\n", "tsc_offset:", control->tsc_offset);
>  	pr_err("%-20s%d\n", "asid:", control->asid);
>  	pr_err("%-20s%d\n", "tlb_ctl:", control->tlb_ctl);
> +	pr_err("%-20s%d\n", "erap_ctl:", control->erap_ctl);
>  	pr_err("%-20s%08x\n", "int_ctl:", control->int_ctl);
>  	pr_err("%-20s%08x\n", "int_vector:", control->int_vector);
>  	pr_err("%-20s%08x\n", "int_state:", control->int_state);
> @@ -3561,6 +3569,27 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  
>  		trace_kvm_nested_vmexit(vcpu, KVM_ISA_SVM);
>  
> +		if (boot_cpu_has(X86_FEATURE_ERAPS)
> +		    && 

&& goes on the previous line.

> vmcb_is_larger_rap(svm->vmcb01.ptr)) {

This should be something like "vmcb_is_full_rap_size_enabled()".  "is_larger_rap()"
begs the question: is larger than what? 

> +			/*
> +			 * XXX a few further optimizations can be made:
> +			 *
> +			 * 1. In pre_svm_run() we can reset this bit when a hw
> +			 * TLB flush has happened - any context switch on a
> +			 * CPU (which causes a TLB flush) auto-flushes the RSB
> +			 * - eg when this vCPU is scheduled on a different
> +			 * pCPU.
> +			 *
> +			 * 2. This is also not needed in the case where the
> +			 * vCPU is being scheduled on the same pCPU, but there
> +			 * was a context switch between the #VMEXIT and VMRUN.

Either do the optimizations straightaway, or call them out as possible optimizations
in the changelog and then explain why it's not worth doing them.

The above also mixes hardware behavior and software behavior, to the point where
I honestly have no idea who is doing what.  "A context switch" tells me nothing
useful.

> +			 *
> +			 * 3. If the guest returns to L2 again after this
> +			 * #VMEXIT, there's no need to flush the RSB.

This one in particular is trivially easy to implement correctly.

This also highlights the fact that KVM completely fails to emulate FLUSH_RAP_ON_VMRUN
if it's set in vmcb12, though that's somewhat of a moot point because unless I'm
missing something, KVM is responsible for emulating host vs. guest hardware tagging.

From L1's perspective, the (virtual) CPU, a.k.a. KVM, is responsible for isolating
guest (L2) RAP entries from host (L1) RAP entries.  And so KVM must flush the RAP
on every nested VM-Exit *and* nested VM-Enter, not just on nested VM-Exit.

> +			 */
> +			vmcb_set_flush_rap(svm->vmcb01.ptr);

Eh, follow the TLB flush helpers and just go with vmcb_flush_rap().

> +		}
> +
>  		vmexit = nested_svm_exit_special(svm);
>  
>  		if (vmexit == NESTED_EXIT_CONTINUE)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 43fa6a16eb19..8a7877f46dc5 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -500,6 +500,21 @@ static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
>  	return vmcb_is_intercept(&svm->vmcb->control, bit);
>  }
>  
> +static inline void vmcb_set_flush_rap(struct vmcb *vmcb)
> +{
> +	__set_bit(ERAP_CONTROL_FLUSH_RAP, (unsigned long *)&vmcb->control.erap_ctl);

Eww.  Don't use the bitops helpers, casting a u8 to an unsigned long, and then
having to use the non-atomic helpers makes this way, way more complicated then
it actually is.

	vmcb->control.erap_ctl |= ERAP_CONTROL_FLUSH_RAP_ON_VMRUN;

> +}
> +
> +static inline void vmcb_set_larger_rap(struct vmcb *vmcb)
> +{
> +	__set_bit(ERAP_CONTROL_ALLOW_LARGER_RAP, (unsigned long *)&vmcb->control.erap_ctl);
> +}
> +
> +static inline bool vmcb_is_larger_rap(struct vmcb *vmcb)
> +{
> +	return test_bit(ERAP_CONTROL_ALLOW_LARGER_RAP, (unsigned long *)&vmcb->control.erap_ctl);
> +}
> +
>  static inline bool nested_vgif_enabled(struct vcpu_svm *svm)
>  {
>  	return guest_can_use(&svm->vcpu, X86_FEATURE_VGIF) &&
> -- 
> 2.47.0
> 

