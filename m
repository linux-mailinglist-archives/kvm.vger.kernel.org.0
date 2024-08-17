Return-Path: <kvm+bounces-24462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0054695540E
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 02:13:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48318B21EDA
	for <lists+kvm@lfdr.de>; Sat, 17 Aug 2024 00:13:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E5AB65C;
	Sat, 17 Aug 2024 00:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qe8FUw0D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F65391
	for <kvm@vger.kernel.org>; Sat, 17 Aug 2024 00:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723853607; cv=none; b=T3V1wL7+ssg1GbLHkbYhQOqGUAhKEiNXmCEZED2Dr4C/70T/k6W5bTLidBrWhnxF+JaSQMmT0d0eJ1moHJePCfq+lN1g0ur1WHe6A39St2Ahr1l/LzJZi3ouvqnrdSDh+wCoWydGqeExDDEXst/8LHMsfpKyFXm2x+yvb27lAvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723853607; c=relaxed/simple;
	bh=SpIjzJc0NlGGMGuCcq/WnANtKMkY7KDl6JVSdF0bP7s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rvNoXjfrArIZs3Kta99hzYjc0ffdUukNH6/R75KLEtAR9F0w9i9LkJiuevZ3aa3Ykm3mX/8HwgFfmiPXVydENx2qdAHNfAP+IHbmRY4vXI+djVaTHdte6NtrudEam7fQAPFkgPz4XJkE2QvSNDuHABnQSKua39gA9mQN7XCX8q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qe8FUw0D; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6b44f75f886so8420817b3.1
        for <kvm@vger.kernel.org>; Fri, 16 Aug 2024 17:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723853604; x=1724458404; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zG87Hua2vkNi5Jf3T7cPpY7RUfNYDh1NRNWyIu15Z2A=;
        b=Qe8FUw0DJLydZWyjAnhWj0EgqyknzydvpK3wRzrxxKnHYy5G7W2uUhMYML9i31f1Q8
         kLRPxhFmK7bObCfKtMKqrQpLt457rOt2SIn8hdAzz2eXfMCqxvuZxI5L2pQd5auPnVEX
         YOm0hLDzZ4+vWMKna0HP0Kk3sWlCqwE6DGvnbFnsiwdQmkUp0V+8ixS483utwI7Nrtik
         CklTaWjd6egvtprJP8q8QJRJOa5ECUwQj1+zMCiG7+JaViz84AYvtXAX/o1tFtLGEgUx
         b//zGizfneKwBtKgRcK77j8E7y6gUx68Apec+DMsSo2JMDVTBywq+ipuCDkAna4KD6N3
         cXmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723853604; x=1724458404;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zG87Hua2vkNi5Jf3T7cPpY7RUfNYDh1NRNWyIu15Z2A=;
        b=RLAreGXhj4TRNKBMeMWEcTT9LCDvW3QwOTDvBJcaCFhwhZ0mhCIGbLdpacojMZeXze
         JRJVQjjYJspa2JEkdyCWdZygs36KzeLPpfUZ0Ico4UkpJyFUVy6ZDV7mict7eGGurRqb
         feuUcIUxE3IXIe9wt3bIj1fzTWry68OWlvGsSgQamhoyzORNXutz4kgFXOn2HFYy95jp
         D0DU35nWz3WC1Kf83ZKMQLWotIFVNbRXxVEzSTPPWdbN9jP3NnIqrLnDLHR7+JrN5cgp
         m7avx4+eFtA/l8wNQawRhCqyEZ5RVGT+zWa1hBpp8bd6lmsSnfysNGGLp20V2rQTz8QO
         trhg==
X-Forwarded-Encrypted: i=1; AJvYcCUK6DitKnoUmbOXgeYYyIPSu7QoBWQbQFEo+mTZ4vqFIHSad9oXogrseqV0KRV1cLUqERiOus7iE1xmaKhLgg+AURsq
X-Gm-Message-State: AOJu0YxX33Gr5V/5Kd7gqt4XjLE2HoQfzCjtaMVy2YYdGVIQG8Bj4vfO
	+crzcXte7wFSl1FmeguoKwuNT9jL9zvwwyUxdPOvxGrRsHndh7fy7ddXLde0t03S4Mk5XuE6qJT
	HCw==
X-Google-Smtp-Source: AGHT+IH36xJ7IS0L0vENo7BJkYmLiRSWFHCZuvhJ+/03qqbIAu/UTaTGIFyPyYeAe4OqD30nJpnP+Wd1wGk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2fc3:b0:6a9:3d52:79e9 with SMTP id
 00721157ae682-6b1ba5f69cemr371237b3.4.1723853604464; Fri, 16 Aug 2024
 17:13:24 -0700 (PDT)
Date: Fri, 16 Aug 2024 17:13:22 -0700
In-Reply-To: <20240808062937.1149-5-ravi.bangoria@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240808062937.1149-1-ravi.bangoria@amd.com> <20240808062937.1149-5-ravi.bangoria@amd.com>
Message-ID: <Zr_rIrJpWmuipInQ@google.com>
Subject: Re: [PATCH v4 4/4] KVM: SVM: Add Bus Lock Detect support
From: Sean Christopherson <seanjc@google.com>
To: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, pbonzini@redhat.com, thomas.lendacky@amd.com, 
	jmattson@google.com, hpa@zytor.com, rmk+kernel@armlinux.org.uk, 
	peterz@infradead.org, james.morse@arm.com, lukas.bulwahn@gmail.com, 
	arjan@linux.intel.com, j.granados@samsung.com, sibs@chinatelecom.cn, 
	nik.borisov@suse.com, michael.roth@amd.com, nikunj.dadhania@amd.com, 
	babu.moger@amd.com, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, santosh.shukla@amd.com, ananth.narayan@amd.com, 
	sandipan.das@amd.com, manali.shukla@amd.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 08, 2024, Ravi Bangoria wrote:
> Add Bus Lock Detect support in AMD SVM. Bus Lock Detect is enabled through
> MSR_IA32_DEBUGCTLMSR and MSR_IA32_DEBUGCTLMSR is virtualized only if LBR
> Virtualization is enabled. Add this dependency in the SVM.

This doesn't depend on the x86 patches that have gone into tip-tree, correct?

In the future, unless there's an actual depenency in code or functionality,
please send separate series for patches that obviously need to be routed through
different trees.

> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/kvm/svm/nested.c |  3 ++-
>  arch/x86/kvm/svm/svm.c    | 17 ++++++++++++++---
>  2 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 6f704c1037e5..1df9158c72c1 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -586,7 +586,8 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>  	/* These bits will be set properly on the first execution when new_vmc12 is true */
>  	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DR))) {
>  		vmcb02->save.dr7 = svm->nested.save.dr7 | DR7_FIXED_1;
> -		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_ACTIVE_LOW;
> +		/* DR6_RTM is a reserved bit on AMD and as such must be set to 1 */
> +		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_FIXED_1 | DR6_RTM;
>  		vmcb_mark_dirty(vmcb02, VMCB_DR);
>  	}
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e1b6a16e97c0..9f3d31a5d231 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1047,7 +1047,8 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
> -	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & DEBUGCTLMSR_LBR) ||
> +	u64 dbgctl_buslock_lbr = DEBUGCTLMSR_BUS_LOCK_DETECT | DEBUGCTLMSR_LBR;
> +	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & dbgctl_buslock_lbr) ||
>  			    (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
>  			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));

Out of sight, but this leads to calling svm_enable_lbrv() even when the guest
just wants to enable BUS_LOCK_DETECT.  Ignoring SEV-ES guests, KVM will intercept
writes to DEBUGCTL, so can't KVM defer mucking with the intercepts and
svm_copy_lbrs() until the guest actually wants to use LBRs?

Hmm, and I think the existing code is broken.  If L1 passes DEBUGCTL through to
L2, then KVM will handles writes to L1's effective value.  And if L1 also passes
through the LBRs, then KVM will fail to update the MSR bitmaps for vmcb02.

Ah, it's just a performance issue though, because KVM will still emulate RDMSR.

Ugh, this code is silly.  The LBR MSRs are read-only, yet KVM passes them through
for write.

Anyways, I'm thinking something like this?  Note, using msr_write_intercepted()
is wrong, because that'll check L2's bitmap if is_guest_mode(), and the idea is
to use L1's bitmap as the canary.

static void svm_update_passthrough_lbrs(struct kvm_vcpu *vcpu, bool passthrough)
{
	struct vcpu_svm *svm = to_svm(vcpu);

	KVM_BUG_ON(!passthrough && sev_es_guest(vcpu->kvm), vcpu->kvm);

	if (!msr_write_intercepted(vcpu, MSR_IA32_LASTBRANCHFROMIP) == passthrough)
		return;

	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHFROMIP, passthrough, 0);
	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, passthrough, 0);
	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, passthrough, 0);
	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, passthrough, 0);

	/*
	 * When enabling, move the LBR msrs to vmcb02 so that L2 can see them,
	 * and then move them back to vmcb01 when disabling to avoid copying
	 * them on nested guest entries.
	 */
	if (is_guest_mode(vcpu)) {
		if (passthrough)
			svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);
		else
			svm_copy_lbrs(svm->vmcb01.ptr, svm->vmcb);
	}
}

void svm_enable_lbrv(struct kvm_vcpu *vcpu)
{
	struct vcpu_svm *svm = to_svm(vcpu);

	if (WARN_ON_ONCE(!sev_es_guest(vcpu->kvm)))
		return;

	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
	svm_update_passthrough_lbrs(vcpu, true);

	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_DEBUGCTLMSR, 1, 1);
}

static struct vmcb *svm_get_lbr_vmcb(struct vcpu_svm *svm)
{
	/*
	 * If LBR virtualization is disabled, the LBR MSRs are always kept in
	 * vmcb01.  If LBR virtualization is enabled and L1 is running VMs of
	 * its own, the MSRs are moved between vmcb01 and vmcb02 as needed.
	 */
	return svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK ? svm->vmcb :
								   svm->vmcb01.ptr;
}

void svm_update_lbrv(struct kvm_vcpu *vcpu)
{
	struct vcpu_svm *svm = to_svm(vcpu);
	u64 guest_debugctl = svm_get_lbr_vmcb(svm)->save.dbgctl;
	bool enable_lbrv = (guest_debugctl & DEBUGCTLMSR_LBR) ||
			    (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));

	if (enable_lbrv || (guest_debugctl & DEBUGCTLMSR_BUS_LOCK_DETECT))
		svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
	else
		svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;

	svm_update_passthrough_lbrs(vcpu, enable_lbrv);
}


> @@ -3158,6 +3159,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		if (data & DEBUGCTL_RESERVED_BITS)

Not your code, but why does DEBUGCTL_RESERVED_BITS = ~0x3f!?!?  That means the
introduction of the below check, which is architecturally correct, has the
potential to break guests.  *sigh*

I doubt it will cause a problem, but it's something to look out for.

>  			return 1;
>  
> +		if ((data & DEBUGCTLMSR_BUS_LOCK_DETECT) &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
> +			return 1;
> +
>  		svm_get_lbr_vmcb(svm)->save.dbgctl = data;
>  		svm_update_lbrv(vcpu);
>  		break;
> @@ -5225,8 +5230,14 @@ static __init void svm_set_cpu_caps(void)
>  	/* CPUID 0x8000001F (SME/SEV features) */
>  	sev_set_cpu_caps();
>  
> -	/* Don't advertise Bus Lock Detect to guest if SVM support is absent */
> -	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
> +	/*
> +	 * LBR Virtualization must be enabled to support BusLockTrap inside the
> +	 * guest, since BusLockTrap is enabled through MSR_IA32_DEBUGCTLMSR and
> +	 * MSR_IA32_DEBUGCTLMSR is virtualized only if LBR Virtualization is
> +	 * enabled.
> +	 */
> +	if (!lbrv)
> +		kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
>  }
>  
>  static __init int svm_hardware_setup(void)
> -- 
> 2.34.1
> 

