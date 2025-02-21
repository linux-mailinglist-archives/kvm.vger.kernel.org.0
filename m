Return-Path: <kvm+bounces-38886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9083CA3FEF5
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 19:39:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4ABC3BA7E0
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 18:39:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78E7E2512F1;
	Fri, 21 Feb 2025 18:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XI+HWLYh"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665291F7561
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 18:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740163169; cv=none; b=b4NSOdV712VdBxNgx2alQxIGemfeJnvi8WfwZySlBR15KJNrnojOMmeZJb3JKzXz4qkHwlO5i9yXstVv7gYzyk1OdebkWUWMhXS+CGsXPSOk+RL2Bt0vO8kk/zif/4nh5u0Dw8LTVX1lgthyujXqvQob79ZdgrLU7dEYaZOxh00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740163169; c=relaxed/simple;
	bh=6AHL/G8uttBxKepl+7pdnmUUijdjqWx8+q7dQqdEkSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ot+9nHceiOjdE3DwBSvfCD7S3BA6lhike6/hZ9182AKzTVgNLvGeyqRjFLaDVgw5MTaYiYWH428AUeCtAKSz1KWnX6O9NtXR5uMHznqURBvGBIh3Emi/5cZfMQoxZJA38RLd/F5ixnCMK7VH1iYRyiVQyupLENwjsaM1NEKSP2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XI+HWLYh; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 21 Feb 2025 18:39:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740163155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YYOzcW3/wUhqtSdeDFGvWSSU0rjTLpUqP729zE3PxN8=;
	b=XI+HWLYhQr0C8OERvJOjJINyX/9ZDl8jt/mnv/8ZCE74SiGktFazhjCQTNdM0OrewVJLEY
	lg3a9PTzfr6fODzY3Vq+95BkDpekNPGDEHtHIqywk+182eQOpVFbHhvnDYd+A9xDPxlvpk
	FGyLqdJYBxIUSLBzTx2ALWwmyP45EoA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Jim Mattson <jmattson@google.com>
Cc: x86@kernel.org, Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Kaplan, David" <David.Kaplan@amd.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: x86: Generalize IBRS virtualization on emulated
 VM-exit
Message-ID: <Z7jISUVBeAbw8zt6@google.com>
References: <20250221163352.3818347-1-yosry.ahmed@linux.dev>
 <20250221163352.3818347-4-yosry.ahmed@linux.dev>
 <CALMp9eSPVDYC7v4Rm13ZUcE4wWPb8dUfm=qBx_jETAQEQrt4_w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eSPVDYC7v4Rm13ZUcE4wWPb8dUfm=qBx_jETAQEQrt4_w@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 21, 2025 at 09:59:04AM -0800, Jim Mattson wrote:
> On Fri, Feb 21, 2025 at 8:34 AM Yosry Ahmed <yosry.ahmed@linux.dev> wrote:
> >
> > Commit 2e7eab81425a ("KVM: VMX: Execute IBPB on emulated VM-exit when
> > guest has IBRS") added an IBPB in the emulated VM-exit path on Intel to
> > properly virtualize IBRS by providing separate predictor modes for L1
> > and L2.
> >
> > AMD requires similar handling, except when IbrsSameMode is enumerated by
> > the host CPU (which is the case on most/all AMD CPUs). With
> > IbrsSameMode, hardware IBRS is sufficient and no extra handling is
> > needed from KVM.
> >
> > Generalize the handling in nested_vmx_vmexit() by moving it into a
> > generic function, add the AMD handling, and use it in
> > nested_svm_vmexit() too. The main reason for using a generic function is
> > to have a single place to park the huge comment about virtualizing IBRS.
> >
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/nested.c |  2 ++
> >  arch/x86/kvm/vmx/nested.c | 11 +----------
> >  arch/x86/kvm/x86.h        | 18 ++++++++++++++++++
> >  3 files changed, 21 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index d77b094d9a4d6..61b73ff30807e 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1041,6 +1041,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
> >
> >         nested_svm_copy_common_state(svm->nested.vmcb02.ptr, svm->vmcb01.ptr);
> >
> > +       kvm_nested_vmexit_handle_spec_ctrl(vcpu);
> > +
> >         svm_switch_vmcb(svm, &svm->vmcb01);
> >
> >         /*
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 8a7af02d466e9..453d52a6e836a 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -5018,16 +5018,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
> >
> >         vmx_switch_vmcs(vcpu, &vmx->vmcs01);
> >
> > -       /*
> > -        * If IBRS is advertised to the vCPU, KVM must flush the indirect
> > -        * branch predictors when transitioning from L2 to L1, as L1 expects
> > -        * hardware (KVM in this case) to provide separate predictor modes.
> > -        * Bare metal isolates VMX root (host) from VMX non-root (guest), but
> > -        * doesn't isolate different VMCSs, i.e. in this case, doesn't provide
> > -        * separate modes for L2 vs L1.
> > -        */
> > -       if (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL))
> > -               indirect_branch_prediction_barrier();
> > +       kvm_nested_vmexit_handle_spec_ctrl(vcpu);
> >
> >         /* Update any VMCS fields that might have changed while L2 ran */
> >         vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index 7a87c5fc57f1b..008c8d381c253 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -116,6 +116,24 @@ static inline void kvm_leave_nested(struct kvm_vcpu *vcpu)
> >         kvm_x86_ops.nested_ops->leave_nested(vcpu);
> >  }
> >
> > +/*
> > + * If IBRS is advertised to the vCPU, KVM must flush the indirect branch
> > + * predictors when transitioning from L2 to L1, as L1 expects hardware (KVM in
> > + * this case) to provide separate predictor modes.  Bare metal isolates the host
> > + * from the guest, but doesn't isolate different guests from one another (in
> > + * this case L1 and L2). The exception is if bare metal supports same mode IBRS,
> > + * which offers protection within the same mode, and hence protects L1 from L2.
> > + */
> > +static inline void kvm_nested_vmexit_handle_spec_ctrl(struct kvm_vcpu *vcpu)
> 
> Maybe just kvm_nested_vmexit_handle_ibrs?

I was trying to use a generic name to accomodate any future handling
needed for non-IBRS speculation control virtualization. But I could just
be overthinking. Happy to take whatever name is agreed upon in during
reviews.

> 
> > +{
> > +       if (cpu_feature_enabled(X86_FEATURE_AMD_IBRS_SAME_MODE))
> > +               return;
> > +
> > +       if (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
> > +           guest_cpu_cap_has(vcpu, X86_FEATURE_AMD_IBRS))
> 
> This is a bit conservative, but I don't think there's any ROI in being
> more pedantic.

Could you elaborate on this?

Is this about doing the IBPB even if L1 does not actually execute an
IBRS? I thought about this for a bit, but otherwise we'd have to
intercept the MSR write IIUC, and I am not sure if that's better. Also,
that's what we are already doing so I just kept it as-is.

Or maybe about whether we need this on AMD only with AUTOIBRS? The APM
is a bit unclear to me in this regard, but I believe may be needed even
for 'normal' IBRS.

> 
> For the series,
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>

Thanks!

> 
> > +               indirect_branch_prediction_barrier();
> > +}
> > +
> >  static inline bool kvm_vcpu_has_run(struct kvm_vcpu *vcpu)
> >  {
> >         return vcpu->arch.last_vmentry_cpu != -1;
> > --
> > 2.48.1.601.g30ceb7b040-goog
> >

