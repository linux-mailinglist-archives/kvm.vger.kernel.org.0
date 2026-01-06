Return-Path: <kvm+bounces-67188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B96CCFB5F0
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 00:44:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 714A230145A2
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 23:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3375C30FF25;
	Tue,  6 Jan 2026 23:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OtsSXerD"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917D1309F13
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 23:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767742972; cv=none; b=X0uuaa6E4mqc9x9Ha69gyHoTvi6NG8iCvxWbu3H/Tqep4nBRXSLuQR0Vx7eJaK3O7JcJ8eNF8hgkbKCkGoldXVurcc5joBTQuqB9u7UERVLtkVPEjHvQWrXj872mftd5U3cP1ttK2LG5jfAaBjmgScfU/04Bqz7bJR+NeAIirMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767742972; c=relaxed/simple;
	bh=XcWW53ho6KpRS9wdFYa1O3pJojYNwpBFNqCVb4c+HhQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lC+w0c2YFTRW7fnEekmsHeY+GuACHUBtw6UmFB+6bGbQGmK0cD3FpqTvZ4Gf/N52c7Mi7sP1KhICnqCDIFIy0hqsOqIIbShJlw5q1GCfE5mgbmZKStZg0TzAhnRhpS41skBoayRYzfgEV835RNxMf13TZPJ4au2309WhdM4Bk4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OtsSXerD; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 6 Jan 2026 23:42:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767742955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g0kHvVKEYR2tFC4f+wap2zLWs9ZQUZ3yV7zCuk433yE=;
	b=OtsSXerDcgenk74qSqgCN4VrtdvcfEBU1x5C/64TvlQZvQg4co1jn2dxHEILfHC0EutJEG
	KogPO3YZQu4YF50dVh0IqnT6CTjKOvrGGsnQ2E9n8+Xxzpr8J7GgqknkTdbYUWoVbqREB9
	ZQ8Q/1zAuwFaoxJ6UWEvVNxLOFFjbow=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Kevin Cheng <chengkev@google.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: SVM: Generate #UD for certain instructions when
 SVME.EFER is disabled
Message-ID: <5uwzlb3jvmebvienef5tw7cd6r4wgvtb5m5gu3wcaxh5sery3o@crh6m6cpuaqy>
References: <20260106041250.2125920-1-chengkev@google.com>
 <20260106041250.2125920-2-chengkev@google.com>
 <aV1StCzKWxAQ-B93@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aV1StCzKWxAQ-B93@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 06, 2026 at 10:21:40AM -0800, Sean Christopherson wrote:
> On Tue, Jan 06, 2026, Kevin Cheng wrote:
> > The AMD APM states that VMRUN, VMLOAD, VMSAVE, CLGI, VMMCALL, and
> > INVLPGA instructions should generate a #UD when EFER.SVME is cleared.
> > Currently, when VMLOAD, VMSAVE, or CLGI are executed in L1 with
> > EFER.SVME cleared, no #UD is generated in certain cases. This is because
> > the intercepts for these instructions are cleared based on whether or
> > not vls or vgif is enabled. The #UD fails to be generated when the
> > intercepts are absent.
> > 
> > INVLPGA is always intercepted, but there is no call to
> > nested_svm_check_permissions() which is responsible for checking
> > EFER.SVME and queuing the #UD exception.
> 
> Please split the INVLPGA fix to a separate patch, it's very much a separate
> logical change.  That will allow for more precise shortlogs, e.g.
> 
>   KVM: SVM: Recalc instructions intercepts when EFER.SVME is toggled
> 
> and
> 
>   KVM: SVM: Inject #UD for INVLPGA if EFER.SVME=0
> 
> > Fix the missing #UD generation by ensuring that all relevant
> > instructions have intercepts set when SVME.EFER is disabled and that the
> > exit handlers contain the necessary checks.
> > 
> > VMMCALL is special because KVM's ABI is that VMCALL/VMMCALL are always
> > supported for L1 and never fault.
> > 
> > Signed-off-by: Kevin Cheng <chengkev@google.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 27 +++++++++++++++++++++++++--
> >  1 file changed, 25 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 24d59ccfa40d9..fc1b8707bb00c 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -228,6 +228,14 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
> >  			if (!is_smm(vcpu))
> >  				svm_free_nested(svm);
> >  
> > +			/*
> > +			 * If EFER.SVME is being cleared, we must intercept these
> 
> No pronouns.
> 
> 			/*
> 			 * Intercept instructions that #UD if EFER.SVME=0, as
> 			 * SVME must be set even when running the guest, i.e.
> 			 * hardware will only ever see EFER.SVME=1.
> 			 */
> 
> > +			 * instructions to ensure #UD is generated.
> > +			 */
> > +			svm_set_intercept(svm, INTERCEPT_CLGI);
> 
> What about STGI?  Per the APM, it #UDs if:
> 
>   Secure Virtual Machine was not enabled (EFER.SVME=0) and both of the following
>   conditions were true:
>     • SVM Lock is not available, as indicated by CPUID Fn8000_000A_EDX[SVML] = 0.
>     • DEV is not available, as indicated by CPUID Fn8000_0001_ECX[SKINIT] = 0.
> 
> 
> And this code in init_vmcb() can/should be dropped:
> 
> 	if (vgif) {
> 		svm_clr_intercept(svm, INTERCEPT_STGI);
> 		svm_clr_intercept(svm, INTERCEPT_CLGI);
> 		svm->vmcb->control.int_ctl |= V_GIF_ENABLE_MASK;
> 	}
> 
> > +			svm_set_intercept(svm, INTERCEPT_VMSAVE);
> > +			svm_set_intercept(svm, INTERCEPT_VMLOAD);
> > +			svm->vmcb->control.virt_ext &= ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
> >  		} else {
> >  			int ret = svm_allocate_nested(svm);
> >  
> > @@ -242,6 +250,15 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
> >  			 */
> >  			if (svm_gp_erratum_intercept && !sev_guest(vcpu->kvm))
> >  				set_exception_intercept(svm, GP_VECTOR);
> > +
> > +			if (vgif)
> > +				svm_clr_intercept(svm, INTERCEPT_CLGI);
> > +
> > +			if (vls) {
> > +				svm_clr_intercept(svm, INTERCEPT_VMSAVE);
> > +				svm_clr_intercept(svm, INTERCEPT_VMLOAD);
> > +				svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
> 
> This is wrong.  In the rather absurd scenario that the vCPU model presented to
> the guest is an Intel CPU, KVM needs to intercept VMSAVE/VMLOAD to deal with the
> SYSENTER MSRs.
> 
> This logic will also get blasted away if svm_recalc_instruction_intercepts()
> runs.
> 
> So rather than manually handle the intercepts in svm_set_efer() and fight recalcs,
> trigger KVM_REQ_RECALC_INTERCEPTS and teach svm_recalc_instruction_intercepts()
> about EFER.SVME handling.
> 
> After the dust settles, it might make sense to move the #GP intercept logic into
> svm_recalc_intercepts() as well, but that's not a priority.

Unrelated question about the #GP intercept logic, it seems like if
enable_vmware_backdoor is set, the #GP intercept will be set, even for
SEV guests, which goes against the in svm_set_efer():

	/*
	 * Never intercept #GP for SEV guests, KVM can't
	 * decrypt guest memory to workaround the erratum.
	 */
	if (svm_gp_erratum_intercept && !sev_guest(vcpu->kvm))
		set_exception_intercept(svm, GP_VECTOR);

I initially thought if userspace sets enable_vmware_backdoor and runs
SEV guests it's shooting itself in the foot, but given that
enable_vmware_backdoor is a module parameter (i.e. global), isn't it
possible that the host runs some SEV and some non-SEV VMs, where the
non-SEV VMs require the vmware backdoor?

