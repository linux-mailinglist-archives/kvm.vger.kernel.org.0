Return-Path: <kvm+bounces-35066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 731A6A0988B
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 18:30:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7063216AF77
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 17:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B84C6212B17;
	Fri, 10 Jan 2025 17:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wb9fweTe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF4F212B23
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 17:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736530219; cv=none; b=oMuEhEtBnAE4Kl6GBiQvDHvFm+W2GyKIOSgWP2GJZUIinalPrcs1uZKcGS6+vsOx8cUoZGi6GLOEgJOFeRAHNi3halzepka3DdlaMHLBhNhYe6DyjlEprfuyKdC+a5kJX0FtmPgQpJPNSsXrqKGd5xU+op92SlDTgK/dFUVKld8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736530219; c=relaxed/simple;
	bh=UecL0rmV/RtOmhy4eU0CDC1T9Ho3fxIykBDXndyVrQM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WL4bx88ichaSJPuFrL06ow22eNXEYzVkCojwzM6iDNK2pzrAYxc+S35GjtbIDTDyQwx5ip4leJAzn8JNtuoysjvPa680GdldlCZTOVxc7Ddyk3/xg9kxbia3AE8Ef4iLOfkfHrChuxqGymq+ZbXZW/nQNuVZ0cnfMa1FU9Lj6js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wb9fweTe; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef79d9c692so6037904a91.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 09:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736530217; x=1737135017; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WU8/cZyJS3LtHAIQS3nzhyGUsnTReJQm3G6wf8zzOtE=;
        b=Wb9fweTeIbnWlwCeebUCN3UQQrf6Yp+zXG8pfEcePX4xJqM1r2dk3a3aAXFG7nivHc
         8qPz4p+ifnVC6EUmSCvNtTsTv6KfBfZIgQ8LgY/8ZjHcC/lVyakeCgV44mt5sfelfUP5
         3l2GKlYu0K37j5dLVlTkuhr6lVcreEjZUsHiIowTDwsOPoUoSltWUctAgHIHMvOsozJf
         /Th1DFhosQdo17l/OGE6s1aH7iA+z/yt8/WiNUfrnEhbWlbvypS50faeiL5uEoRm0tD2
         L3XXCRXc6rK0MrDjhOsQwBojqqx4WcKDlR7B5uRgMpo9AWA5zrX04Q/2KMYxCP59+AAJ
         /zyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736530217; x=1737135017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WU8/cZyJS3LtHAIQS3nzhyGUsnTReJQm3G6wf8zzOtE=;
        b=utFgvEF9Mks0yi4ve2FEUD3QxHfDsw6nweBmLCrwMYg/clhLKdzbbih5DoXIJAx3z3
         cQr0fGarOyOw0hZhczIe7qSxN1mHeHAFQPKe3uz7QILOoNpEAkGIrKpxQeHBsD/1YdXi
         GSPmDpk8bgTzvr2A8tux9vZ6bYQPMJG5CY4SMGLloJicIJCUJcU+IjxlUrcc9i7hh6lF
         IaEk1Gt7P6YmNap0aeEW/YIRfkLdmzNqyiGr5S+ZcYJaPDGkHAqOVmxSxe7JiZ4ghlxi
         2sRQTJvaLscG3dCK1tuL7d9b/77CJ+BpxgdAb0gAFHCL9cDpdp006q0ryRbmFrpX3uNo
         2NIQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9E24cWOzttXnJPVo0Yp8Eodds3jwHuWfAMC3ZME5iVQ3Z8TsbSk4yQ7px7PYU6TdMGOQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGJSmYQVJGlmE0dTMsoBc7XH252IJqWw0MGZhrDfFWBHpFi5f0
	khA/+A8PARRyNYCAmWg9bxazFR+MzrqCroBhpaogb6OmPJC1S3H2H+xeNsEVVIyJsMOXQVd/abl
	1hA==
X-Google-Smtp-Source: AGHT+IFREOWHilBv/Qir68+4IrqFvRayUQZHL0sz/GwEjNVI+IFYq8WiN8K/Gr2ttL/qBlLMZMSWlJC6k6g=
X-Received: from pjyd3.prod.google.com ([2002:a17:90a:dfc3:b0:2ef:6ef8:6567])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:6c3:b0:2ee:c918:cd42
 with SMTP id 98e67ed59e1d1-2f548ecf156mr14585659a91.22.1736530217665; Fri, 10
 Jan 2025 09:30:17 -0800 (PST)
Date: Fri, 10 Jan 2025 09:30:16 -0800
In-Reply-To: <3a7d93aa-781b-445e-a67a-25b0ffea0dff@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-5-adrian.hunter@intel.com> <Z0AbZWd/avwcMoyX@intel.com>
 <a42183ab-a25a-423e-9ef3-947abec20561@intel.com> <Z2GiQS_RmYeHU09L@google.com>
 <487a32e6-54cd-43b7-bfa6-945c725a313d@intel.com> <Z2WZ091z8GmGjSbC@google.com>
 <96f7204b-6eb4-4fac-b5bb-1cd5c1fc6def@intel.com> <Z4Aff2QTJeOyrEUY@google.com>
 <3a7d93aa-781b-445e-a67a-25b0ffea0dff@intel.com>
Message-ID: <Z4FZKOzXIdhLOlU8@google.com>
Subject: Re: [PATCH 4/7] KVM: TDX: restore host xsave state when exit from the
 guest TD
From: Sean Christopherson <seanjc@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org, 
	x86@kernel.org, yan.y.zhao@intel.com, weijiang.yang@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 10, 2025, Adrian Hunter wrote:
> On 9/01/25 21:11, Sean Christopherson wrote:
> > On Fri, Jan 03, 2025, Adrian Hunter wrote:
> >> +static u64 tdx_guest_cr4(struct kvm_vcpu *vcpu)
> >> +{
> >> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> >> +	u64 cr4;
> >> +
> >> +	rdmsrl(MSR_IA32_VMX_CR4_FIXED1, cr4);
> > 
> > This won't be accurate long-term.  E.g. run KVM on hardware with CR4 bits that
> > neither KVM nor TDX know about, and vcpu->arch.cr4 will end up with bits set that
> > KVM think are illegal, which will cause it's own problems.
> 
> Currently validation of CR4 is only done when user space changes it,
> which should not be allowed for TDX.  For that it looks like TDX
> would need:
> 
> 	kvm->arch.has_protected_state = true;
> 
> Not sure why it doesn't already?

Sorry, I didn't follow any of that.

> > For CR0 and CR4, we should be able to start with KVM's set of allowed bits, not
> > the CPU's.  That will mean there will likely be missing bits, in vcpu->arch.cr{0,4},
> > but if KVM doesn't know about a bit, the fact that it's missing should be a complete
> > non-issue.
> 
> What about adding:
> 
> 	cr4 &= ~cr4_reserved_bits;
> 
> and
> 
> 	cr0 &= ~CR0_RESERVED_BITS

I was thinking a much more explicit:

	vcpu->arch.cr4 = ~vcpu->arch.cr4_guest_rsvd_bits;

which if it's done in tdx_vcpu_init(), in conjunction with freezing the vCPU
model (see below), should be solid.

> >> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >> index d2ea7db896ba..f2b1980f830d 100644
> >> --- a/arch/x86/kvm/x86.c
> >> +++ b/arch/x86/kvm/x86.c
> >> @@ -1240,6 +1240,11 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
> >>  	u64 old_xcr0 = vcpu->arch.xcr0;
> >>  	u64 valid_bits;
> >>  
> >> +	if (vcpu->arch.guest_state_protected) {
> > 
> > This should be a WARN_ON_ONCE() + return 1, no?
> 
> With kvm->arch.has_protected_state = true, KVM_SET_XCRS
> would fail, which would probably be fine except for KVM selftests:
> 
> Currently the KVM selftests expect to be able to set XCR0:
> 
>     td_vcpu_add()
> 	vm_vcpu_add()
> 	    vm_arch_vcpu_add()
> 		vcpu_init_xcrs()
> 		    vcpu_xcrs_set()
> 			vcpu_ioctl(KVM_SET_XCRS)
> 			    __TEST_ASSERT_VM_VCPU_IOCTL(!ret)
> 
> Seems like vm->arch.has_protected_state is needed for KVM selftests?

I doubt it's truly needed, my guess (without looking at the code) is that selftests
are fudging around the fact that KVM doesn't stuff arch.xcr0.

> >> +		kvm_update_cpuid_runtime(vcpu);
> 
> And kvm_update_cpuid_runtime() never gets called otherwise.
> Not sure where would be a good place to call it.

I think we should call it in tdx_vcpu_init(), and then also freeze the vCPU model
at that time.  KVM currently "freezes" the model based on last_vmentry_cpu, but
that's a bit of a hack and might even be flawed, e.g. I wouldn't be surprised if
it's possible to lead KVM astray by trying to get a signal to race with KVM_RUN
so that last_vmentry_cpu isn't set despite getting quite far into KVM_RUN.

I'll test and post a patch to add vcpu_model_is_frozen (the below will conflict
mightily with the CPUID rework that's queued for v6.14), as I think it's a good
change even if we don't end up freezing the model at tdx_vcpu_init() (though I
can't think of any reason to allow CPUID updates after that point).

---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/cpuid.c            | 2 +-
 arch/x86/kvm/mmu/mmu.c          | 4 ++--
 arch/x86/kvm/pmu.c              | 2 +-
 arch/x86/kvm/vmx/tdx.c          | 7 +++++++
 arch/x86/kvm/x86.c              | 9 ++++++++-
 arch/x86/kvm/x86.h              | 5 -----
 7 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0787855ab006..41c31a69924d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -779,6 +779,7 @@ struct kvm_vcpu_arch {
 	u64 ia32_misc_enable_msr;
 	u64 smbase;
 	u64 smi_count;
+	bool vcpu_model_is_frozen;
 	bool at_instruction_boundary;
 	bool tpr_access_reporting;
 	bool xfd_no_write_intercept;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6c7ab125f582..678518ec1c72 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -465,7 +465,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	 * KVM_SET_CPUID{,2} again. To support this legacy behavior, check
 	 * whether the supplied CPUID data is equal to what's already set.
 	 */
-	if (kvm_vcpu_has_run(vcpu)) {
+	if (vcpu->arch.vcpu_model_is_frozen) {
 		r = kvm_cpuid_check_equal(vcpu, e2, nent);
 		if (r)
 			return r;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 713ca857f2c2..75350a5c6c54 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5716,9 +5716,9 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	/*
 	 * Changing guest CPUID after KVM_RUN is forbidden, see the comment in
-	 * kvm_arch_vcpu_ioctl().
+	 * kvm_arch_vcpu_ioctl_run().
 	 */
-	KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm);
+	KVM_BUG_ON(vcpu->arch.vcpu_model_is_frozen, vcpu->kvm);
 }
 
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 47a46283c866..4f487a980eae 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -752,7 +752,7 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
-	if (KVM_BUG_ON(kvm_vcpu_has_run(vcpu), vcpu->kvm))
+	if (KVM_BUG_ON(vcpu->arch.vcpu_model_is_frozen, vcpu->kvm))
 		return;
 
 	/*
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a587f59167a7..997d14506a1f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2822,6 +2822,13 @@ static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
 	td_vmcs_write64(tdx, POSTED_INTR_DESC_ADDR, __pa(&tdx->pi_desc));
 	td_vmcs_setbit32(tdx, PIN_BASED_VM_EXEC_CONTROL, PIN_BASED_POSTED_INTR);
 
+	/*
+	 * Freeze the vCPU model, as KVM relies on guest CPUID and capabilities
+	 * to be consistent with the TDX Module's view from here on out.
+	 */
+	vcpu->arch.vcpu_model_is_frozen = true;
+	kvm_update_cpuid_runtime(vcpu);
+
 	tdx->state = VCPU_TD_STATE_INITIALIZED;
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d2ea7db896ba..3db935737b59 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2218,7 +2218,8 @@ static int do_set_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 	 * writes of the same value, e.g. to allow userspace to blindly stuff
 	 * all MSRs when emulating RESET.
 	 */
-	if (kvm_vcpu_has_run(vcpu) && kvm_is_immutable_feature_msr(index) &&
+	if (vcpu->arch.vcpu_model_is_frozen &&
+	    kvm_is_immutable_feature_msr(index) &&
 	    (do_get_msr(vcpu, index, &val) || *data != val))
 		return -EINVAL;
 
@@ -11469,6 +11470,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	struct kvm_run *kvm_run = vcpu->run;
 	int r;
 
+	/*
+	 * Freeze the vCPU model, i.e. disallow changing CPUID, feature MSRs,
+	 * etc.  KVM doesn't support changing the model once the vCPU has run.
+	 */
+	vcpu->arch.vcpu_model_is_frozen = true;
+
 	vcpu_load(vcpu);
 	kvm_sigset_activate(vcpu);
 	kvm_run->flags = 0;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 514ffd7513f3..6ed074d03616 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -118,11 +118,6 @@ static inline void kvm_leave_nested(struct kvm_vcpu *vcpu)
 	kvm_x86_ops.nested_ops->leave_nested(vcpu);
 }
 
-static inline bool kvm_vcpu_has_run(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.last_vmentry_cpu != -1;
-}
-
 static inline bool kvm_is_exception_pending(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.exception.pending ||

base-commit: d12b37e67b767a9e89b221067d48b257708d3044
-- 

