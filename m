Return-Path: <kvm+bounces-28931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ECEE399F45D
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 19:49:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78ECE1F24A2C
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 17:49:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD0CD1FAEE8;
	Tue, 15 Oct 2024 17:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wYWX1zSw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDE11B3952
	for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 17:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729014572; cv=none; b=pFBPp4M6qrh14kDzbAQowOajXTS6C3kb9Q0mAM3+Ap3BKtMq0U1tw+lmNbnJ+PwRHNawRop9E0XtB1wY/lLkstyxDbN5wPgSSnozksAauIL0wh2EsREgPGzJthufe4Jo1ETQ8FbArpVuPspP3HY4CQpF/93rR3H3I2wjNT1Bw8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729014572; c=relaxed/simple;
	bh=w9yMTpgtlDlP754RfEhuFkd4gEYT0k8nxVOTmQuqx2o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=brNbuCwMppwzPe0nfrkcZzkNf/4TlJAiyPr9QtZAf8ZXecRttyNqgeVVRZRZAWBKCykiRbTLG/Sxfdursn55if3mrNaON0ZLdr4wE/2B3t2YmPkKEwIzWdl7UzBA32ApSl555ZNyISm6OOSPB4G3M0uhrOutBHmINkYXfqOThyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wYWX1zSw; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e321d26b38so98736517b3.2
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 10:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729014569; x=1729619369; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GiiBUKq/Br4LnO+B7B/w0RrpVPB7A0yLxa2YC2SgL2I=;
        b=wYWX1zSwFNBHK6Gd3laiwCESDUEQe+FZrl2O5AbmeDA5oTaH1wFnejObcJp52HjyEA
         sfBeRG5Nq7Wb75SzmMK4CBwGrP03OtoKV/PwZMQSxssBHUzFg3+pLCb3AWjM1nMNnQXU
         JpKf2Rcbo5VjEBjpPl+le7owJG781lYxS93J9eFyCM9aEcjxx2VCLw6O6LufnCMO6Cj/
         tK4jDZ+P8vitO/Wt6CaDEFZPecbTvpY/VdV1qYbZLNCRm4uTE+ax5srk7kga2KHI/OQ0
         1x3UtLWHubeDn3zWhcZ4KB7yJI1wmy1Vpc24oqULwjWqcaKRq51HNRvcKpje1hDuucYy
         KRxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729014569; x=1729619369;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GiiBUKq/Br4LnO+B7B/w0RrpVPB7A0yLxa2YC2SgL2I=;
        b=BorDoTuMZXk2O/l1RjviDUmWov7buE4HTSWj0LqdQ/dm46LX+XkgMvCY8hN7ltLswV
         T4WXKWOdEfU0E0z5wOZHW57RLN0yA5My+vB84dsQDWoVHiBdaEdD3CzUdHjBanQhdZfv
         EJWmf60C0frPt+NslnFQiKUyyYxFKrS1jsRnXXYVKDOaN7sPVON/+B1ZuJW8elZdtuxT
         Dbj0ov2xDSEfV6vbSvUT+JgBGqfQZB1+iVL46Fmqb+tW64l+ySPK97HWv49stFkSvOyx
         mia6IH44AIWLd5cTjIAiT6BQLzoqyKEEtWX80xVPKCvMHYb3b3SXPiubsxuxdXw+gGkq
         26QQ==
X-Gm-Message-State: AOJu0YwcuICqGtmQE+no5Ucuo99+LmubWpST4gKZhzaFfrky7f+FCwHu
	r7iT4O9z+B3nS/nK5FaM92YYyS8FirGEfHi9xkuqiMT6sPzPz5aMSjbATLPeR6xalqa+3Z8lMg2
	ccQ==
X-Google-Smtp-Source: AGHT+IE/YiL/RV4FORlISN4dF2xXXd541OizlA8+9usEslVyJoJ9fDrmjw2rVWFNgk8jb3YQySDzZQxG1nY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6504:b0:6db:b2ed:7625 with SMTP id
 00721157ae682-6e3d3bdfc62mr270877b3.0.1729014569323; Tue, 15 Oct 2024
 10:49:29 -0700 (PDT)
Date: Tue, 15 Oct 2024 10:49:27 -0700
In-Reply-To: <20241004053341.5726-3-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241004053341.5726-1-manali.shukla@amd.com> <20241004053341.5726-3-manali.shukla@amd.com>
Message-ID: <Zw6rJ3y_F-10xBcH@google.com>
Subject: Re: [PATCH v3 2/4] KVM: SVM: Enable Bus lock threshold exit
From: Sean Christopherson <seanjc@google.com>
To: Manali Shukla <manali.shukla@amd.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, pbonzini@redhat.com, 
	shuah@kernel.org, nikunj@amd.com, thomas.lendacky@amd.com, 
	vkuznets@redhat.com, bp@alien8.de, babu.moger@amd.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 04, 2024, Manali Shukla wrote:
> When a VMRUN instruction is executed, the bus lock threshold count is
> loaded into an internal count register. Before the processor executes
> a bus lock in the guest, it checks the value of this register:
> 
>  - If the value is greater than '0', the processor successfully
>    executes the bus lock and decrements the count.
> 
>  - If the value is '0', the bus lock is not executed, and a #VMEXIT to
>    the VMM is taken.
> 
> The bus lock threshold #VMEXIT is reported to the VMM with the VMEXIT
> code A5h, SVM_EXIT_BUS_LOCK.

I vote to split this into two patches: one to add the architectural collateral,
with the above as the changelog, and a second to actually implement support in
KVM.  Having the above background is useful, but it makes it quite hard to find
information on the KVM design and implementation.
 
> This implementation is set up to intercept every guest bus lock.

"This implementation" is a variation on "This patch".  Drop it, and simply state
what the patch is doing.

> initial value of the Bus Lock Threshold counter is '0' in the VMCB, so
> the very first bus lock will exit, set the Bus Lock Threshold counter
> to '1' (so that the offending instruction can make forward progress)
> but then the value is at '0' again so the next bus lock will exit.
> 
> The generated SVM_EXIT_BUS_LOCK in kvm will exit to user space by

s/kvm/KVM

And again, the tone is wrong.

Something is what I would aim for:

  Add support for KVM_CAP_X86_BUS_LOCK_EXIT on SVM CPUs with Bus Lock
  Threshold, which is close enough to VMX's Bus Lock Detection VM-Exit to
  allow reusing KVM_CAP_X86_BUS_LOCK_EXIT.

  The biggest difference between the two features is that Threshold is
  fault-like, whereas Detection is trap-like.  To allow the guest to make
  forward progress, Threshold provides a per-VMCB counter which is
  decremented every time a bus lock occurs, and a VM-Exit is triggered if
  and only if the counter is '0'.

  To provide Detection-like semantics, initialize the counter to '0', i.e.
  exit on every bus lock, and when re-executing the guilty instruction, set
  the counter to '1' to effectively step past the instruction.

  Note, in the unlikely scenario that re-executing the instruction doesn't
  trigger a bus lock, e.g. because the guest has changed memory types or
  patched the guilty instruction, the bus lock counter will be left at '1',
  i.e. the guest will be able to do a bus lock on a different instruction.
  In a perfect world, KVM would ensure the counter is '0' if the guest has
  made forward progress, e.g. if RIP has changed.  But trying to close that
  hole would incur non-trivial complexity, for marginal benefit; the intent
  of KVM_CAP_X86_BUS_LOCK_EXIT is to allow userspace rate-limit bus locks,
  not to allow for precise detection of problematic guest code.  And, it's
  simply not feasible to fully close the hole, e.g. if an interrupt arrives
  before the original instruction can re-execute, the guest could step past
  a different bus lock.

> setting the KVM_RUN_BUS_LOCK flag in vcpu->run->flags, indicating to
> the user space that a bus lock has been detected in the guest.
> 
> Use the already available KVM capability KVM_CAP_X86_BUS_LOCK_EXIT to
> enable the feature. This feature is disabled by default, it can be
> enabled explicitly from user space.
> 
> More details about the Bus Lock Threshold feature can be found in AMD
> APM [1].

...

> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index d5314cb7dff4..ca1c42201894 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -669,6 +669,11 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
>  	vmcb02->control.iopm_base_pa = vmcb01->control.iopm_base_pa;
>  	vmcb02->control.msrpm_base_pa = vmcb01->control.msrpm_base_pa;
>  
> +	/*
> +	 * The bus lock threshold count should keep running across nested
> +	 * transitions. Copy the buslock threshold count from vmcb01 to vmcb02.

No, it should be reset to '0'.  The bus lock can't have been on VMRUN, because KVM
is emulating the VMRUN.  That leaves two possibilities: the bus lock happened in
L1 on an instruction before VMRUN, or the bus lock happened in _an_ L2, before a
nested VM-Exit to L1 occurred.

In the first case, the bus lock firmly happened on an instruction in the past.
Even if vmcb01's counter is still '1', e.g. because the guilty instruction got
patched, the vCPU has clearly made forward progress and so KVM should reset vmcb02's
counter to '0'.

In the second case, KVM has no idea if L2 has made forward progress.  The only
way to _try to_ detect if L2 has made forward progress would to be to track the
counter on a per-vmcb12 basis, but even that is flawed because KVM doesn't have
visibility into L1's management of L2.
 
I do think we may need to stash vmcb02's counter though.  E.g. if userspace rate-
limits the vCPU, then it's entirely possible that L1's tick interrupt is pending
by the time userspace re-runs the vCPU.  If KVM unconditionally clears the counter
on VMRUN, then when L1 re-enters L2, the same instruction will trigger a VM-Exit
and the entire cycle starts over.

Anything we do is going to be imperfect, but the best idea I can come up with is
also relatively simple, especially in conjunction with my suggestion below.  If
KVM tracks the RIP that triggered the bus lock, then on nested VM-Exit KVM can
propagate that RIP into svm_nested_state as appropriate.  E.g.

	if (vmcb02->control.bus_lock_counter &&
	    svm->bus_lock_rip == vmcb02->save.rip)
		svm->nested.bus_lock_rip = svm->bus_lock_rip;
	else
		svm->nested.bus_lock_rip = INVALID_GVA; /* or '0', as much as that bugs me */

and then on nested VMRUN

	if (svm->nested.bus_lock_rip == vmcb02->save.rip) {
		vmcb02->control.bus_lock_counter = 1;
		svm->bus_lock_rip = svm->nested.bus_lock_rip;
	} else {
		vmcb02->control.bus_lock_counter = 0;
	}

	svm->nested.bus_lock_rip = INVALID_GVA;

Again, it's imperfect, e.g. if L1 happens to run a different vCPU at the same
RIP, then KVM will allow a bus lock for the wrong vCPU.  But the odds of that
happening are absurdly low unless L1 is deliberately doing weird things, and so
I don't think

> +	 */
> +	vmcb02->control.bus_lock_counter = vmcb01->control.bus_lock_counter;
>  	/* Done at vmrun: asid.  */
>  
>  	/* Also overwritten later if necessary.  */
> @@ -1035,6 +1040,11 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  
>  	}
>  
> +	/*
> +	 * The bus lock threshold count should keep running across nested
> +	 * transitions. Copy the buslock threshold count from vmcb02 to vmcb01.
> +	 */
> +	vmcb01->control.bus_lock_counter = vmcb02->control.bus_lock_counter;

KVM should definitely reset the counter to '0' on a nested VM-Exit, because L1
can't be interrupted by L2, i.e. there is zero chance that KVM needs to allow a
bus lock in L1 to ensure L1 makes forward progress.

>  	nested_svm_copy_common_state(svm->nested.vmcb02.ptr, svm->vmcb01.ptr);
>  
>  	svm_switch_vmcb(svm, &svm->vmcb01);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 9df3e1e5ae81..0d0407f1ee6a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1372,6 +1372,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>  		svm->vmcb->control.int_ctl |= V_GIF_ENABLE_MASK;
>  	}
>  
> +	if (vcpu->kvm->arch.bus_lock_detection_enabled)
> +		svm_set_intercept(svm, INTERCEPT_BUSLOCK);
> +
>  	if (sev_guest(vcpu->kvm))
>  		sev_init_vmcb(svm);
>  
> @@ -3286,6 +3289,24 @@ static int invpcid_interception(struct kvm_vcpu *vcpu)
>  	return kvm_handle_invpcid(vcpu, type, gva);
>  }
>  
> +static int bus_lock_exit(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	vcpu->run->exit_reason = KVM_EXIT_X86_BUS_LOCK;
> +	vcpu->run->flags |= KVM_RUN_X86_BUS_LOCK;
> +
> +	/*
> +	 * Reload the counter with value greater than '0'.

The value quite obviously must be exactly '1', not simply greater than '0.  I also
think this is the wrong place to set the counter.  Rather than set the counter at
the time of exit, KVM should implement a vcpu->arch.complete_userspace_io callback
and set the counter to '1' if and only if RIP (or LIP, but I have no objection to
keeping things simple) is unchanged.  It's a bit of extra complexity, but it will
make it super obvious why KVM is setting the counter to '1'.  And, if userspace
wants to stuff state and move past the instruction, e.g. by emulating the guilty
instruction, then KVM won't unnecessarily allow a bus lock in the guest.

And then the comment can be:

	/*
	 * If userspace has NOT change RIP, then KVM's ABI is to let the guest
	 * execute the bus-locking instruction.  Set the bus lock counter to '1'
	 * to effectively step past the bus lock.
	 */

> +	 * The bus lock exit on SVM happens with RIP pointing to the guilty
> +	 * instruction. So, reloading the value of bus_lock_counter to '0'
> +	 * results into generating continuous bus lock exits.
> +	 */
> +	svm->vmcb->control.bus_lock_counter = 1;
> +
> +	return 0;
> +}
> +
>  static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[SVM_EXIT_READ_CR0]			= cr_interception,
>  	[SVM_EXIT_READ_CR3]			= cr_interception,
> @@ -3353,6 +3374,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[SVM_EXIT_CR4_WRITE_TRAP]		= cr_trap,
>  	[SVM_EXIT_CR8_WRITE_TRAP]		= cr_trap,
>  	[SVM_EXIT_INVPCID]                      = invpcid_interception,
> +	[SVM_EXIT_BUS_LOCK]			= bus_lock_exit,
>  	[SVM_EXIT_NPF]				= npf_interception,
>  	[SVM_EXIT_RSM]                          = rsm_interception,
>  	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
> @@ -5227,6 +5249,11 @@ static __init void svm_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
>  	}
>  
> +	if (cpu_feature_enabled(X86_FEATURE_BUS_LOCK_THRESHOLD)) {
> +		pr_info("Bus Lock Threashold supported\n");
> +		kvm_caps.has_bus_lock_exit = true;
> +	}
> +
>  	/* CPUID 0x80000008 */
>  	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
>  	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
> -- 
> 2.34.1
> 

