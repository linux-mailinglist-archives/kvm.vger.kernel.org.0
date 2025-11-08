Return-Path: <kvm+bounces-62383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 72B0FC424BE
	for <lists+kvm@lfdr.de>; Sat, 08 Nov 2025 03:29:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 372774E7667
	for <lists+kvm@lfdr.de>; Sat,  8 Nov 2025 02:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E86992BEC28;
	Sat,  8 Nov 2025 02:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YV/VIDfG"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A752BD5A1
	for <kvm@vger.kernel.org>; Sat,  8 Nov 2025 02:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762568981; cv=none; b=cERs33u0G7PPbIS1NMEDhtEOj6ZASlASlWCmAotwzBFRBDDW3Uhxytc3iO5PM5oK4/DmYBOGK4tDhCI1YUNNUaCGtdUO+Pn8Tta4nIyMqF/iXIfry51fWNmgZ+4mB86kkVP8rq8uS08Jl5dILQUxpOss362MLP8IfR63+xJL+kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762568981; c=relaxed/simple;
	bh=XVurSsv1aIwvZ4BJpc+wPo/EabBysHlT0g93N6AY5rY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eAHDLk+XzKc7y2SXVXkzu7dfT5mkTCiPYRVF1Gj8lxswUZNYcf1XXAKkWn5NHyeLUO0bleaZXPhD+jJo1d4+ggbzFzzw+jidLoZ4dCFMyzZb92TSnBuvImkZpdivKG63uYwWJh526keyoHEwoWZFAdiWc0MXM/8UMl+lVY2NmdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YV/VIDfG; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sat, 8 Nov 2025 02:29:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762568973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5tgR3etyK3VdmVwBi3kc59mcat7vAR0R4Hvxt/4DwrE=;
	b=YV/VIDfGtwwKhsAg+0iuP2XXzFU2DaPsupSgDCSGpok+e8YajCdPtT+6s1veFJ2oRsQUUK
	P+fCCSBJl/kM837Q/fqunxQiMiGpa9Gwu5+igtzla2vJf1LxG/zhrAo9/M9sGx38mR2ROB
	CqMran3urSy543eIvcyQlDA7lAHz4TU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] KVM: nSVM: Add missing consistency check for
 event_inj
Message-ID: <pw3at4bjmtxa2xdwheqn5a33ahpudqhl2urnbrsuqn7yaa5l5m@5yddcnjwevnd>
References: <20251104195949.3528411-1-yosry.ahmed@linux.dev>
 <20251104195949.3528411-4-yosry.ahmed@linux.dev>
 <aQub_AbP6l6BJlB2@google.com>
 <heahqrdiujkusb42hir3qbejwnc6svspt3owwtat345myquny4@5ebkzc6mt2y3>
 <aQv3Ml60dVpQ-fvz@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aQv3Ml60dVpQ-fvz@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 05, 2025 at 05:17:38PM -0800, Sean Christopherson wrote:
> On Wed, Nov 05, 2025, Yosry Ahmed wrote:
> > On Wed, Nov 05, 2025 at 10:48:28AM -0800, Sean Christopherson wrote:
> > > On Tue, Nov 04, 2025, Yosry Ahmed wrote:
> > > > According to the APM Volume #2, 15.20 (24593—Rev. 3.42—March 2024):
> > > > 
> > > >   VMRUN exits with VMEXIT_INVALID error code if either:
> > > >   • Reserved values of TYPE have been specified, or
> > > >   • TYPE = 3 (exception) has been specified with a vector that does not
> > > >     correspond to an exception (this includes vector 2, which is an NMI,
> > > >     not an exception).
> > > > 
> > > > Add the missing consistency checks to KVM. For the second point, inject
> > > > VMEXIT_INVALID if the vector is anything but the vectors defined by the
> > > > APM for exceptions. Reserved vectors are also considered invalid, which
> > > > matches the HW behavior.
> > > 
> > > Ugh.  Strictly speaking, that means KVM needs to match the capabilities of the
> > > virtual CPU.  E.g. if the virtual CPU predates SEV-ES, then #VC should be reserved
> > > from the guest's perspective.
> > > 
> > > > Vector 9 (i.e. #CSO) is considered invalid because it is reserved on modern
> > > > CPUs, and according to LLMs no CPUs exist supporting SVM and producing #CSOs.
> > > > 
> > > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > > ---
> > > >  arch/x86/include/asm/svm.h |  5 +++++
> > > >  arch/x86/kvm/svm/nested.c  | 33 +++++++++++++++++++++++++++++++++
> > > >  2 files changed, 38 insertions(+)
> > > > 
> > > > diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> > > > index e69b6d0dedcf0..3a9441a8954f3 100644
> > > > --- a/arch/x86/include/asm/svm.h
> > > > +++ b/arch/x86/include/asm/svm.h
> > > > @@ -633,6 +633,11 @@ static inline void __unused_size_checks(void)
> > > >  #define SVM_EVTINJ_VALID (1 << 31)
> > > >  #define SVM_EVTINJ_VALID_ERR (1 << 11)
> > > >  
> > > > +/* Only valid exceptions (and not NMIs) are allowed for SVM_EVTINJ_TYPE_EXEPT */
> > > > +#define SVM_EVNTINJ_INVALID_EXEPTS (NMI_VECTOR | BIT_ULL(9) | BIT_ULL(15) | \
> > > > +				    BIT_ULL(20) | GENMASK_ULL(27, 22) | \
> > > > +				    BIT_ULL(31))
> > > 
> > > As above, hardcoding this won't work.  E.g. if a VM is migrated from a CPU where
> > > vector X is reserved to a CPU where vector X is valid, then the VM will observe
> > > a change in behavior. 
> > > 
> > > Even if we're ok being overly permissive today (e.g. by taking an erratum), this
> > > will create problems in the future when one of the reserved vectors is defined,
> > > at which point we'll end up changing guest-visible behavior (and will have to
> > > take another erratum, or maybe define the erratum to be that KVM straight up
> > > doesn't enforce this correctly?)
> > > 
> > > And if we do throw in the towel and don't try to enforce this, we'll still want
> > > a safeguard against this becoming stale, e.g. when KVM adds support for new
> > > feature XYZ that comes with a new vector.
> > > 
> > > Off the cuff, the best idea I have is to define the positive set of vectors
> > > somewhere common with a static assert, and then invert that.  E.g. maybe something
> > > shared with kvm_trace_sym_exc()?
> > 
> > Do you mean define the positive set of vectors dynamically based on the
> > vCPU caps? Like a helper returning a dynamic bitmask instead of
> > SVM_EVNTINJ_INVALID_EXEPTS?
> 
> Ya, that would be option #1, though I'm not entirely sure it's a good option.
> The validity of vectors aren't architecturally tied to the existince of any
> particular feature, at least not explicitly.  For the "newer" vectors, i.e. the
> ones that we can treat as conditionally valid, it's pretty obvious which features
> they "belong" to, but even then I hesitate to draw connections, e.g. on the off
> chance that some weird hypervisor checks Family/Model/Stepping or something.
> 
> > If we'll reuse that for kvm_trace_sym_exc() it will need more work, but
> > I don't see why we need a dynamic list for kvm_trace_sym_exc().
> 
> Sorry, this is for option #2.  Hardcode the set of vectors that KVM allows (to
> prevent L1 from throwing pure garbage at hardware), but otherwise defer to the
> CPU to enforce the reserved vectors.
> 
> Hrm, but option #2 just delays the inevitable, e.g. we'll be stuck once again
> when KVM supports some new vector, in which case we'll have to change guest
> visible behavior _again_, or bite the bullet and do option #1.
> 
> So I guess do option #1 straight away and hope nothing breaks?  Maybe hardcode
> everything as supported except #CP (SHSTK) and #VC (SEV-ES)?

Ack, will do something like:

#define ALWAYS_VALID_EVTINJ_EXEPTS (DE_VECTOR | DB_VECTOR | BP_VECTOR | \
                                    OF_VECTOR | BR_VECTOR | UD_VECTOR | \
                                    NM_VECTOR | DF_VECTOR | TS_VECTOR | \
                                    NP_VECTOR | SS_VECTOR | GP_VECTOR | \
                                    PF_VECTOR | MF_VECTOR | AC_VECTOR | \
                                    MC_VECTOR | XM_VECTOR | VE_VECTOR | \
                                    HV_VECTOR | SX_VECTOR)

static bool nested_svm_event_inj_valid_exept(struct kvm_vcpu *vcpu, u8 vector)
{
        return ((1 << vector) & ALWAYS_VALID_EVTINJ_EXEPTS) ||
                (vector == CP_VECTOR && guest_cpu_cap_has(X86_FEATURE_SHSTK)) ||
                (vector == VC_VECTOR && guest_cpu_cap_has(X86_FEATURE_SEV_ES));
}

I will rebase this on top of the LBRV fixes I just sent out and include
this change and send a v2 early next week.

> 
> > So my best guess is that I didn't really understand your suggestion :)

