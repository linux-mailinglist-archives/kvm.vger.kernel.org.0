Return-Path: <kvm+bounces-55200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E70FEB2E306
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 19:10:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 238CA16C7AF
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 17:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F1AE334709;
	Wed, 20 Aug 2025 17:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DZoDMZQq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF0C3277AA
	for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 17:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755709820; cv=none; b=dp1kFq7dXM3Kxf+2ToH/2gaDuJBKcAmQsp96IxRiUJo4zREIn9UQgohmS5tl/7nknjYHDtUZKagoNFLASjlWrHfx/pTK9On2rzVLuwwGT6f6DZmeP0Ct6N5B/o3OhlWotkyOczOniIBiLNApytnVBbj+BuDV+D3wywhKIsTKUgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755709820; c=relaxed/simple;
	bh=dhBXRqsSJw/h0IlJlmUF0e8yLbJ5Wn30E33N9axnkjQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wbk6bjFicA9s2Gx63FWcup5UKyDASk+Nrx6oeylFz5C105inpf3ij1HljSfUrwGoa5g1I/1IP8hVFNPKjRfZWY09m8qJaMKk/BfNScKL/NqfuFZtupTpq1iVS2xxtyoUtmYn6NOZg81ytxiVbN5aR6lquXT5jpCyIOEb5zCWTyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DZoDMZQq; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e8ae86ab3so166765b3a.1
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 10:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755709818; x=1756314618; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5t4FcDSGXwLSgTF0EICUfOCBIN34cesCy1ccnNe/UjE=;
        b=DZoDMZQqPwzWfr2071stHOs+HffAAAPcUQrL4a8Zr3DPt4L8NLRpLzwJJZCA7h9QFu
         yHb18xC0Pr/3MDgpziagShcdy80g09o0lRBVR4CYhFy2h5MQXAyjJNWaJ3+oVOEn58Lf
         +zm7iaEJD1Fz/C+9XJvgle1OF8WWFSGg3nNy0sY7Vs3PWQDnN+JBGol2C9SZQ8YsfCVW
         mEp5rmFEN4TWTcuLKd0TPLMOeK5q9eQU7b5Dac0zevF8yQp/PWpOrim7BeoJtZJngBAr
         kXNWGZl/IXBHqOWl1bROsY3mFkDKcJcC4lUCVGzMdJhykiFLLRCCW312utuDWlDjGkS8
         X56g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755709818; x=1756314618;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5t4FcDSGXwLSgTF0EICUfOCBIN34cesCy1ccnNe/UjE=;
        b=gp0wGw1rPV+J7hW0nFJV37yhm6f/x3pc//xsbtKITgNrdZcOay+c5t7d47+4QzyL3B
         hAvhCl7NS1mw2yXga25ychx9FBsokAaYsMhULl60wsDeRTl2GfROQr+n5LF5n65Na707
         soiJ1HhGOTaeFb9vELgp7waSvLbPeN7LxuC4XF9uM+zOWG1Fee2cSzfYsde/Y+xFmJH9
         nqUm8NxxppBDYnkbDh1EExCdMmoQ1PVQkkjLKA+jkQvt/l6+vuZhf/Rdl+tJpduWdtSE
         VLZ8BDT0SYYEWqKVdBvFTRHo+4W5OlqRMJtScoEdgdUlHnMe+HWwcU+OCWi/MV/MCXof
         k7gA==
X-Forwarded-Encrypted: i=1; AJvYcCUf36jY1mheFWpm17ZEmAb7A94rFy/uiWR7NCE1v1j6Ui5vflsN8ogWyMaG+nKQIXwcywE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgVHe7Fl6Rb8DuOx8bLBFG55sScYqjdDhFPOmu+R6vxNVlGpkW
	giqfnRGuxkMhfBcizY0Mc7XL3vgCipnMaFnNYruuAp/vgc9JAkvBdXsIVrZYWDDdh4r/+uz4hgC
	bpuNNsw==
X-Google-Smtp-Source: AGHT+IE6TUwGBI1cmNGcUjN1t5C7h5vmven6pZhphBLAx9IXkOGEoC44GQiPmocw0Fg1uk/d51KtCCBMhOc=
X-Received: from pjvb16.prod.google.com ([2002:a17:90a:d890:b0:31e:c1fb:dbb2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3291:b0:222:d191:5bbd
 with SMTP id adf61e73a8af0-2431b939322mr5779179637.39.1755709818245; Wed, 20
 Aug 2025 10:10:18 -0700 (PDT)
Date: Wed, 20 Aug 2025 10:10:16 -0700
In-Reply-To: <20250515152621.50648-2-amit@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250515152621.50648-1-amit@kernel.org> <20250515152621.50648-2-amit@kernel.org>
Message-ID: <aKYBeIokyVC8AKHe@google.com>
Subject: Re: [PATCH v5 1/1] x86: kvm: svm: set up ERAPS support for guests
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

On Thu, May 15, 2025, Amit Shah wrote:
> From: Amit Shah <amit.shah@amd.com>
> 
> AMD CPUs with the Enhanced Return Address Predictor (ERAPS) feature
> Zen5+) obviate the need for FILL_RETURN_BUFFER sequences right after
> VMEXITs.  The feature adds guest/host tags to entries in the RSB (a.k.a.
> RAP).  This helps with speculation protection across the VM boundary,
> and it also preserves host and guest entries in the RSB that can improve
> software performance (which would otherwise be flushed due to the
> FILL_RETURN_BUFFER sequences).  This feature also extends the size of
> the RSB from the older standard (of 32 entries) to a new default
> enumerated in CPUID leaf 0x80000021:EBX bits 23:16 -- which is 64
> entries in Zen5 CPUs.
> 
> In addition to flushing the RSB across VMEXIT boundaries, CPUs with
> this feature also flush the RSB when the CR3 is updated (i.e. whenever
> there's a context switch), to prevent one userspace process poisoning
> the RSB that may affect another process.  The relevance of this for KVM
> is explained below in caveat 2.
> 
> The hardware feature is always-on, and the host context uses the full
> default RSB size without any software changes necessary.  The presence
> of this feature allows software (both in host and guest contexts) to
> drop all RSB filling routines in favour of the hardware doing it.
> 
> For guests to observe and use this feature, 

Guests don't necessarily "use" this feature.  It's something that's enabled by
KVM and affects harware behavior regardless of whether or not the guest is even
aware ERAPS is a thing.

> the hypervisor needs to expose the CPUID bit, and also set a VMCB bit.
> Without one or both of those, 

No?  If there's no enabling for bare metal usage, I don't see how emulation of
CPUID can possibly impact usage of RAP size.  The only thing that matters is the
VMCB bit.  And nothing in this patch queries guest CPUID.

Observing ERAPS _might_ cause the guest to forego certain mitigations, but KVM
has zero visibility into whether or not such mitigations exist, if the guest will
care about ERAPS, etc.

> guests continue to use the older default RSB size and behaviour for backwards
> compatibility.  This means the hardware RSB size is limited to 32 entries for
> guests that do not have this feature exposed to them.
> 
> There are two guest/host configurations that need to be addressed before
> allowing a guest to use this feature: nested guests, and hosts using
> shadow paging (or when NPT is disabled):
> 
> 1. Nested guests: the ERAPS feature adds host/guest tagging to entries
>    in the RSB, but does not distinguish between the guest ASIDs.  To
>    prevent the case of an L2 guest poisoning the RSB to attack the L1
>    guest, the CPU exposes a new VMCB bit (FLUSH_RAP_ON_VMRUN).  The next
>    VMRUN with a VMCB that has this bit set causes the CPU to flush the
>    RSB before entering the guest context.  In this patch, we set the bit

"this patch", "we".

>    in VMCB01 after a nested #VMEXIT to ensure the next time the L1 guest
>    runs, its RSB contents aren't polluted by the L2's contents.
>    Similarly, when an exit from L1 to the hypervisor happens, we set
>    that bit for VMCB02, so that the L1 guest's RSB contents are not
>    leaked/used in the L2 context.
> 
> 2. Hosts that disable NPT: the ERAPS feature also flushes the RSB
>    entries when the CR3 is updated.  When using shadow paging, CR3
>    updates within the guest do not update the CPU's CR3 register.

Yes they do, just indirectly.  KVM changes the effective CR3 in reaction to the
guest's new CR3.  If hardware doesn't flush in that situation, then it's trivially
easy to set ERAP_CONTROL_FLUSH_RAP on writes to CR3.

>    In this case, do not expose the ERAPS feature to guests,
>    and the guests continue with existing mitigations to fill the RSB.
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 571c906ffcbf..0cca1865826e 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1187,6 +1187,9 @@ void kvm_set_cpu_caps(void)
>  		F(SRSO_USER_KERNEL_NO),
>  	);
>  
> +	if (tdp_enabled)
> +		kvm_cpu_cap_check_and_set(X86_FEATURE_ERAPS);

_If_ ERAPS is conditionally enabled, then it probably makes sense to do this in
svm_set_cpu_caps().  But I think we can just support ERAPS unconditionally.

> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a89c271a1951..a2b075ed4133 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1363,6 +1363,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>  	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>  		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
>  
> +	if (boot_cpu_has(X86_FEATURE_ERAPS) && npt_enabled)
	
Don't regurgitate the same check in multiple places.

	if (kvm_cpu_cap_has(X86_FEATURE_ERAPS))


	
> +		vmcb_enable_extended_rap(svm->vmcb);
> +
>  	if (kvm_vcpu_apicv_active(vcpu))
>  		avic_init_vmcb(svm, vmcb);
>  
> @@ -3482,6 +3485,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>  	pr_err("%-20s%016llx\n", "tsc_offset:", control->tsc_offset);
>  	pr_err("%-20s%d\n", "asid:", control->asid);
>  	pr_err("%-20s%d\n", "tlb_ctl:", control->tlb_ctl);
> +	pr_err("%-20s%d\n", "erap_ctl:", control->erap_ctl);
>  	pr_err("%-20s%08x\n", "int_ctl:", control->int_ctl);
>  	pr_err("%-20s%08x\n", "int_vector:", control->int_vector);
>  	pr_err("%-20s%08x\n", "int_state:", control->int_state);
> @@ -3663,6 +3667,11 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  
>  		trace_kvm_nested_vmexit(vcpu, KVM_ISA_SVM);
>  
> +		if (vmcb_is_extended_rap(svm->vmcb01.ptr)) {
> +			vmcb_set_flush_guest_rap(svm->vmcb01.ptr);
> +			vmcb_clr_flush_guest_rap(svm->nested.vmcb02.ptr);
> +		}
> +
>  		vmexit = nested_svm_exit_special(svm);
>  
>  		if (vmexit == NESTED_EXIT_CONTINUE)
> @@ -3670,6 +3679,11 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  
>  		if (vmexit == NESTED_EXIT_DONE)
>  			return 1;
> +	} else {
> +		if (vmcb_is_extended_rap(svm->vmcb01.ptr) && svm->nested.initialized) {
> +			vmcb_set_flush_guest_rap(svm->nested.vmcb02.ptr);
> +			vmcb_clr_flush_guest_rap(svm->vmcb01.ptr);
> +		}

Handling this in the common exit path is confusing, inefficient, and lacking.

Assuming hardware doesn't automatically clear ERAP_CONTROL_FLUSH_RAP, then KVM
should clear the flag after _any_ exit, not just exits that reach this point,
e.g. if KVM stays in the fast path.

And IIUC, ERAP_CONTROL_FLUSH_RAP needs to be done on _every_ nested transition,
not just those that occur in direct response to a hardware #VMEXIT. So, hook
nested_vmcb02_prepare_control() for nested VMRUN and nested_svm_vmexit() for
nested #VMEXIT.

Side topic, the changelog should call out that KVM deliberately ignores guest
CPUID, and instead unconditionally enables the full size RAP when ERAPS is
supported.  I.e. KVM _could_ check guest_cpu_cap_has() instead of kvm_cpu_cap_has()
in all locations, to avoid having to flush the RAP on nested transitions when
ERAPS isn't enumerated to the guest, but presumably using the full size RAP is
better for overall performance.

The changelog should also call out that if the full size RAP is enabled, then
it's KVM's responsibility to flush the RAP on nested transitions irrespective
of whether or not ERAPS is advertised to the guest.  Because if ERAPS isn't
advertised, the the guest's mitigations will likely be insufficient.

>  	}
>  
>  	if (svm->vmcb->control.exit_code == SVM_EXIT_ERR) {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index f16b068c4228..7f44f7c9b1d5 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -493,6 +493,26 @@ static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
>  	return vmcb_is_intercept(&svm->vmcb->control, bit);
>  }
>  
> +static inline void vmcb_set_flush_guest_rap(struct vmcb *vmcb)
> +{
> +	vmcb->control.erap_ctl |= ERAP_CONTROL_FLUSH_RAP;
> +}
> +
> +static inline void vmcb_clr_flush_guest_rap(struct vmcb *vmcb)
> +{
> +	vmcb->control.erap_ctl &= ~ERAP_CONTROL_FLUSH_RAP;
> +}
> +
> +static inline void vmcb_enable_extended_rap(struct vmcb *vmcb)
> +{
> +	vmcb->control.erap_ctl |= ERAP_CONTROL_ALLOW_LARGER_RAP;
> +}
> +
> +static inline bool vmcb_is_extended_rap(struct vmcb *vmcb)
> +{
> +	return !!(vmcb->control.erap_ctl & ERAP_CONTROL_ALLOW_LARGER_RAP);
> +}

Eh, just drop all of these wrappers.

With the caveat that I'm taking a wild guess on the !npt behavior, something
like this?

---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/include/asm/svm.h         | 6 +++++-
 arch/x86/kvm/cpuid.c               | 7 ++++++-
 arch/x86/kvm/svm/nested.c          | 6 ++++++
 arch/x86/kvm/svm/svm.c             | 9 +++++++++
 5 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index eb859299d514..87d9284c166a 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -466,6 +466,7 @@
 #define X86_FEATURE_GP_ON_USER_CPUID	(20*32+17) /* User CPUID faulting */
 
 #define X86_FEATURE_PREFETCHI		(20*32+20) /* Prefetch Data/Instruction to Cache Level */
+#define X86_FEATURE_ERAPS		(20*32+24) /* Enhanced Return Address Predictor Security */
 #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barrier */
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ffc27f676243..58a079d6c3ef 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -131,7 +131,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u64 tsc_offset;
 	u32 asid;
 	u8 tlb_ctl;
-	u8 reserved_2[3];
+	u8 erap_ctl;
+	u8 reserved_2[2];
 	u32 int_ctl;
 	u32 int_vector;
 	u32 int_state;
@@ -182,6 +183,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define TLB_CONTROL_FLUSH_ASID 3
 #define TLB_CONTROL_FLUSH_ASID_LOCAL 7
 
+#define ERAP_CONTROL_FULL_SIZE_RAP BIT(0)
+#define ERAP_CONTROL_FLUSH_RAP BIT(1)
+
 #define V_TPR_MASK 0x0f
 
 #define V_IRQ_SHIFT 8
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ad6cadf09930..184a810b53e3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1177,6 +1177,7 @@ void kvm_set_cpu_caps(void)
 		F(AUTOIBRS),
 		F(PREFETCHI),
 		EMULATED_F(NO_SMM_CTL_MSR),
+		F(ERAPS),
 		/* PrefetchCtlMsr */
 		/* GpOnUserCpuid */
 		/* EPSF */
@@ -1760,9 +1761,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 		break;
 	case 0x80000021:
-		entry->ebx = entry->edx = 0;
+		entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
 		cpuid_entry_override(entry, CPUID_8000_0021_ECX);
+		if (kvm_cpu_cap_has(X86_FEATURE_ERAPS))
+			entry->ebx &= GENMASK(23, 16);
+		else
+			entry->ebx = 0;
 		break;
 	/* AMD Extended Performance Monitoring and Debug */
 	case 0x80000022: {
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b7fd2e869998..77794fd809e1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -861,6 +861,9 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 		}
 	}
 
+	if (kvm_cpu_cap_has(X86_FEATURE_ERAPS))
+		vmcb02->control.erap_ctl |= ERAP_CONTROL_FLUSH_RAP;
+
 	/*
 	 * Merge guest and host intercepts - must be called with vcpu in
 	 * guest-mode to take effect.
@@ -1144,6 +1147,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	kvm_nested_vmexit_handle_ibrs(vcpu);
 
+	if (kvm_cpu_cap_has(X86_FEATURE_ERAPS))
+		vmcb01->control.erap_ctl |= ERAP_CONTROL_FLUSH_RAP;
+
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7e7821ee8ee1..501596e56d39 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1205,6 +1205,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 		svm_clr_intercept(svm, INTERCEPT_PAUSE);
 	}
 
+	if (kvm_cpu_cap_has(X86_FEATURE_ERAPS))
+		svm->vmcb->control.erap_ctl |= ERAP_CONTROL_FULL_SIZE_RAP;
+
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm, vmcb);
 
@@ -2560,6 +2563,8 @@ static int cr_interception(struct kvm_vcpu *vcpu)
 			break;
 		case 3:
 			err = kvm_set_cr3(vcpu, val);
+			if (!err && nested && kvm_cpu_cap_has(X86_FEATURE_ERAPS))
+				svm->vmcb->control.erap_ctl |= ERAP_CONTROL_FLUSH_RAP;
 			break;
 		case 4:
 			err = kvm_set_cr4(vcpu, val);
@@ -3322,6 +3327,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "tsc_offset:", control->tsc_offset);
 	pr_err("%-20s%d\n", "asid:", control->asid);
 	pr_err("%-20s%d\n", "tlb_ctl:", control->tlb_ctl);
+	pr_err("%-20s%d\n", "erap_ctl:", control->erap_ctl);
 	pr_err("%-20s%08x\n", "int_ctl:", control->int_ctl);
 	pr_err("%-20s%08x\n", "int_vector:", control->int_vector);
 	pr_err("%-20s%08x\n", "int_state:", control->int_state);
@@ -4366,6 +4372,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	}
 
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
+	if (cpu_feature_enabled(X86_FEATURE_ERAPS))
+		svm->vmcb->control.erap_ctl &= ~ERAP_CONTROL_FLUSH_RAP;
+
 	vmcb_mark_all_clean(svm->vmcb);
 
 	/* if exit due to PF check for async PF */

base-commit: 91b392ada892a2e8b1c621b9493c50f6fb49880f
--

