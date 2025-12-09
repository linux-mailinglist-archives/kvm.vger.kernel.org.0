Return-Path: <kvm+bounces-65580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B08F2CB0CBC
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 19:08:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5826230FACD7
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 18:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0AE22ED15F;
	Tue,  9 Dec 2025 18:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RM4jhQGM"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2448221FCA
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 18:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765303651; cv=none; b=bxZrodPUPuBFFe+l2IRZ2wQBoptn9v62xviVJwnIcvtSEeS15S8ZjpUWDKr/PI9lnBVbxe2pKCBleGg4ef6VYGggzFnLdJ1hZq+uCPq3yB75cYnn9uSC0Ugqu+GlraMVE/w6OSptSWYquuiNI+mFT4/n3Em+LJ7kC2yzM/72lXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765303651; c=relaxed/simple;
	bh=O/V/wmgg718J8Hf157mPnUzZMNSaNpqFhCatWOXwsGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JPpwl7WrRuJSdiUS9GdZSDPTgUseBqly+GAd/nch2IhptMZaQqGJjFIL3KKMj5o0kN1gB+zXl9/Pcg6Y02zn3U9RyDtkTzfS+uJGTCWbi0CDmc0QdEa+HQMijwjZtjxVNNJN5MJ3wwyL/zX8utCUPUb7Qo7JwZm0Jsw6nBbDIz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RM4jhQGM; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 9 Dec 2025 18:07:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765303645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dtw2hz0t5mCUfsLqXAqarJnG0CFf11kQNlPUc9nejF8=;
	b=RM4jhQGMPsR+RMjDnyC+UXf4Thcp1oYpuRMs6TRqhmEiJkE2cRhhmq0RYdmdNcfJfwBM5v
	6/4b7AZvqAAMv7sbkD4idUrDovcoNB3vXlQjNBU+mL2mlIeZjIpCWv/9yxZReOZJfefxNn
	vVJLnFazIhm7QMyBbtmnx790PIieJRg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 04/13] KVM: nSVM: Fix consistency checks for NP_ENABLE
Message-ID: <nyuyxccvnhscbo7qtlbsfl2fgxwood24nn4bvskhfqghgli3jo@xsv4zbdkolij>
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
 <20251110222922.613224-5-yosry.ahmed@linux.dev>
 <aThN-xUbQeFSy_F7@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aThN-xUbQeFSy_F7@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 09, 2025 at 08:27:39AM -0800, Sean Christopherson wrote:
> On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> > KVM currenty fails a nested VMRUN and injects VMEXIT_INVALID (aka
> > SVM_EXIT_ERR) if L1 sets NP_ENABLE and the host does not support NPTs.
> > On first glance, it seems like the check should actually be for
> > guest_cpu_cap_has(X86_FEATURE_NPT) instead, as it is possible for the
> > host to support NPTs but the guest CPUID to not advertise it.
> > 
> > However, the consistency check is not architectural to begin with. The
> > APM does not mention VMEXIT_INVALID if NP_ENABLE is set on a processor
> > that does not have X86_FEATURE_NPT. Hence, NP_ENABLE should be ignored
> > if X86_FEATURE_NPT is not available for L1. Apart from the consistency
> > check, this is currently the case because NP_ENABLE is actually copied
> > from VMCB01 to VMCB02, not from VMCB12.
> > 
> > On the other hand, the APM does mention two other consistency checks for
> > NP_ENABLE, both of which are missing (paraphrased):
> > 
> > In Volume #2, 15.25.3 (24593—Rev. 3.42—March 2024):
> > 
> >   If VMRUN is executed with hCR0.PG cleared to zero and NP_ENABLE set to
> >   1, VMRUN terminates with #VMEXIT(VMEXIT_INVALID)
> > 
> > In Volume #2, 15.25.4 (24593—Rev. 3.42—March 2024):
> > 
> >   When VMRUN is executed with nested paging enabled (NP_ENABLE = 1), the
> >   following conditions are considered illegal state combinations, in
> >   addition to those mentioned in “Canonicalization and Consistency
> >   Checks”:
> >     • Any MBZ bit of nCR3 is set.
> >     • Any G_PAT.PA field has an unsupported type encoding or any
> >     reserved field in G_PAT has a nonzero value.
> 
> This should be three patches, one each for the new consistency checks, and one
> to the made-up check.  Shortlogs like "Fix all the bugs" are strong hints that
> a patch is doing too much.

Ack, will split it.

> 
> > Replace the existing consistency check with consistency checks on
> > hCR0.PG and nCR3. Only perform the consistency checks if L1 has
> > X86_FEATURE_NPT and NP_ENABLE is set in VMCB12. The G_PAT consistency
> > check will be addressed separately.
> > 
> > As it is now possible for an L1 to run L2 with NP_ENABLE set but
> > ignored, also check that L1 has X86_FEATURE_NPT in nested_npt_enabled().
> > 
> > Pass L1's CR0 to __nested_vmcb_check_controls(). In
> > nested_vmcb_check_controls(), L1's CR0 is available through
> > kvm_read_cr0(), as vcpu->arch.cr0 is not updated to L2's CR0 until later
> > through nested_vmcb02_prepare_save() -> svm_set_cr0().
> > 
> > In svm_set_nested_state(), L1's CR0 is available in the captured save
> > area, as svm_get_nested_state() captures L1's save area when running L2,
> > and L1's CR0 is stashed in VMCB01 on nested VMRUN (in
> > nested_svm_vmrun()).
> > 
> > Fixes: 4b16184c1cca ("KVM: SVM: Initialize Nested Nested MMU context on VMRUN")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/nested.c | 21 ++++++++++++++++-----
> >  arch/x86/kvm/svm/svm.h    |  3 ++-
> >  2 files changed, 18 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 74211c5c68026..87bcc5eff96e8 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -325,7 +325,8 @@ static bool nested_svm_check_bitmap_pa(struct kvm_vcpu *vcpu, u64 pa, u32 size)
> >  }
> >  
> >  static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
> > -					 struct vmcb_ctrl_area_cached *control)
> > +					 struct vmcb_ctrl_area_cached *control,
> > +					 unsigned long l1_cr0)
> >  {
> >  	if (CC(!vmcb12_is_intercept(control, INTERCEPT_VMRUN)))
> >  		return false;
> > @@ -333,8 +334,12 @@ static bool __nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
> >  	if (CC(control->asid == 0))
> >  		return false;
> >  
> > -	if (CC((control->nested_ctl & SVM_NESTED_CTL_NP_ENABLE) && !npt_enabled))
> > -		return false;
> > +	if (nested_npt_enabled(to_svm(vcpu))) {
> > +		if (CC(!kvm_vcpu_is_legal_gpa(vcpu, control->nested_cr3)))
> > +			return false;
> > +		if (CC(!(l1_cr0 & X86_CR0_PG)))
> > +			return false;
> > +	}
> >  
> >  	if (CC(!nested_svm_check_bitmap_pa(vcpu, control->msrpm_base_pa,
> >  					   MSRPM_SIZE)))
> > @@ -400,7 +405,12 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu)
> >  	struct vcpu_svm *svm = to_svm(vcpu);
> >  	struct vmcb_ctrl_area_cached *ctl = &svm->nested.ctl;
> >  
> > -	return __nested_vmcb_check_controls(vcpu, ctl);
> > +	/*
> > +	 * Make sure we did not enter guest mode yet, in which case
> 
> No pronouns.

I thought that rule was for commit logs. There are plenty of 'we's in
the KVM x86 code (and all x86 code for that matter) :P

> 
> > +	 * kvm_read_cr0() could return L2's CR0.
> > +	 */
> > +	WARN_ON_ONCE(is_guest_mode(vcpu));
> > +	return __nested_vmcb_check_controls(vcpu, ctl, kvm_read_cr0(vcpu));
> >  }
> >  
> >  static
> > @@ -1831,7 +1841,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
> >  
> >  	ret = -EINVAL;
> >  	__nested_copy_vmcb_control_to_cache(vcpu, &ctl_cached, ctl);
> > -	if (!__nested_vmcb_check_controls(vcpu, &ctl_cached))
> > +	/* 'save' contains L1 state saved from before VMRUN */
> > +	if (!__nested_vmcb_check_controls(vcpu, &ctl_cached, save->cr0))
> >  		goto out_free;
> >  
> >  	/*
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index f6fb70ddf7272..3e805a43ffcdb 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -552,7 +552,8 @@ static inline bool gif_set(struct vcpu_svm *svm)
> >  
> >  static inline bool nested_npt_enabled(struct vcpu_svm *svm)
> >  {
> > -	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
> > +	return guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_NPT) &&
> > +		svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
> 
> I would rather rely on Kevin's patch to clear unsupported features.

Not sure how Kevin's patch is relevant here, could you please clarify?

This is to account for removing the artifical consistency check. It's
now possible to have SVM_NESTED_CTL_NP_ENABLE set and ignored, so we
need to also check that the guest can actually use NPTs here.

> 
> >  }
> >  
> >  static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
> > -- 
> > 2.51.2.1041.gc1ab5b90ca-goog
> > 

