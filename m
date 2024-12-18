Return-Path: <kvm+bounces-34062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24E209F6AC7
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 17:11:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E77837A2016
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 16:10:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92AA71F12FE;
	Wed, 18 Dec 2024 16:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i80S6ucz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4641E9B38
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 16:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734538251; cv=none; b=BiqR3hcJXh6uOQvfcXAPqOhXXtqd0RehiB6MFqIi8npmUHHNreMj/ONDFdsUIm5N3knl6KAsMFETMrOux/rEOPRQwbIHox7LvJ13sccMA/W0jTjIf+3SfoWW79X3OtJGLqjaW39dyQthSompzrNUqw88ILZqrDHIv2zLzSW+osQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734538251; c=relaxed/simple;
	bh=tm2idR5oCI96oSwbL8AhpE0TKqNCyhE1Sx+p/lQYVE4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z3c+mXAK8gfCuT8hYmYmHZa/Qw6IG0orq2YLWLEyNGyB7uyzz8Ot/lYGT5qAdXSZhi1JzhaIRDSbKiwJy3Bjks6MuCSY/6iSbisUebG0DHLBoblr9fvurLfFaPeJEZTon8U9rDZpt7Ag7Z5wOkG4nTQtCCZc5SAiSIG6wqz2zMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i80S6ucz; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-72aa68f306fso200535b3a.0
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 08:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734538249; x=1735143049; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Su6tksW57BKWOWTqO35gQ+U3eN3S8xYiaD0KOZC+Wxw=;
        b=i80S6ucz0ubxPnQl4kzl0MfDE4Mn4uL/FrBl8aiSo1lwOQETyHEpwloVe3THEAb2tB
         eMefC9381xy75Q7IxujgR0fKjNLTM+YslPvQEgsdQrcnsWf6xQYQFdQzAel0c7M+B/Bm
         czxrVRNqcGZISvTIe0qd2BOoJ7n2GGhdu9giJciO3ygyYVKdYJMtkulLyI4viSsFmvTe
         A6RfT8zpQQr0Ky2qsSV61++U8kzkSRPTlqMa0e1ds5TWhmGgs+pIm7D8Sr59W4KNDEH4
         AML+VliIccASaD9ZmNHRHji/BlzXpHp8K39cwr8pQ9CFirwwTcMS8Dn0nYKH3iEagti2
         9iDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734538249; x=1735143049;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Su6tksW57BKWOWTqO35gQ+U3eN3S8xYiaD0KOZC+Wxw=;
        b=WiERDx9jWWmRXPe/qDlEN8/thG9kXYNzHlvzi1xk7Xo3uoee/XY7d4GGjxpJe9frIz
         1iiiKWl0nr8FAZby3+NNwhJLX5zGb0a6gnnBCFcCx34SLnuMIlI1B69r3NMS/kBZ3AxQ
         WIDwQeWokEcyGV7J3A5V65oZ0dOUspuP0i/hMqUyQlxXq2awAAJ6VL86+LUIJR/RN2jG
         ycKCV8BkbtJuDHUlXbpJ/L5KqtmkmfqquZjgZS7qgCjO48AuMw+vSJkvXYdccS+ReXf1
         oLicjJ1YsROF9lhn9drIZBmCH99uyyoJ0P7PkN0brxOc1TFD+cTFkuqwlcP3tntLBYz9
         vJUA==
X-Forwarded-Encrypted: i=1; AJvYcCWvQRTnklyj8+7AqEC1c5vnvdiVxOwvcxnYK51gVTHDftMEsGMP5F6cPaEhzFJPgOBFjZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyg/ONUZZJxi4YLKS2hSU/MwELDh1GBBwrLlh6B6AG7NqtkHK2W
	G65H0At43gibuxIO7HeZ4ZJO935mCld1yTzT1NeH2PwmPwXc8fpsH4FhFCUrdzbGqNqXnHIKFsa
	EeQ==
X-Google-Smtp-Source: AGHT+IHDp6bKNXmrY8dloG12vtDgp74rrLlhvzbwBVviqYvE7fCLItLRlLdveyCHfjjkMrdDYFqDNBsI6Sg=
X-Received: from pgnq3.prod.google.com ([2002:a63:8c43:0:b0:7fd:5670:5a2d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d806:b0:1d9:3b81:cdd3
 with SMTP id adf61e73a8af0-1e5b46000e5mr6129262637.1.1734538249491; Wed, 18
 Dec 2024 08:10:49 -0800 (PST)
Date: Wed, 18 Dec 2024 08:10:48 -0800
In-Reply-To: <Z2JhXfA14UjC1/fs@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121115139.26338-1-yan.y.zhao@intel.com> <20241121115703.26381-1-yan.y.zhao@intel.com>
 <Z2IJP-T8NVsanjNd@google.com> <Z2JhXfA14UjC1/fs@yzhao56-desk.sh.intel.com>
Message-ID: <Z2L0CPLKg9dh6imZ@google.com>
Subject: Re: [RFC PATCH 2/2] KVM: TDX: Kick off vCPUs when SEAMCALL is busy
 during TD page removal
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, dave.hansen@linux.intel.com, 
	rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, tony.lindgren@intel.com, 
	binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	isaku.yamahata@gmail.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org, 
	x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 18, 2024, Yan Zhao wrote:
> On Tue, Dec 17, 2024 at 03:29:03PM -0800, Sean Christopherson wrote:
> > On Thu, Nov 21, 2024, Yan Zhao wrote:
> > > For tdh_mem_range_block(), tdh_mem_track(), tdh_mem_page_remove(),
> > > 
> > > - Upon detection of TDX_OPERAND_BUSY, retry each SEAMCALL only once.
> > > - During the retry, kick off all vCPUs and prevent any vCPU from entering
> > >   to avoid potential contentions.
> > > 
> > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > ---
> > >  arch/x86/include/asm/kvm_host.h |  2 ++
> > >  arch/x86/kvm/vmx/tdx.c          | 49 +++++++++++++++++++++++++--------
> > >  2 files changed, 40 insertions(+), 11 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index 521c7cf725bc..bb7592110337 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -123,6 +123,8 @@
> > >  #define KVM_REQ_HV_TLB_FLUSH \
> > >  	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> > >  #define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(34)
> > > +#define KVM_REQ_NO_VCPU_ENTER_INPROGRESS \
> > > +	KVM_ARCH_REQ_FLAGS(33, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> > >  
> > >  #define CR0_RESERVED_BITS                                               \
> > >  	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
> > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > index 60d9e9d050ad..ed6b41bbcec6 100644
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -311,6 +311,20 @@ static void tdx_clear_page(unsigned long page_pa)
> > >  	__mb();
> > >  }
> > >  
> > > +static void tdx_no_vcpus_enter_start(struct kvm *kvm)
> > > +{
> > > +	kvm_make_all_cpus_request(kvm, KVM_REQ_NO_VCPU_ENTER_INPROGRESS);
> > 
> > I vote for making this a common request with a more succient name, e.g. KVM_REQ_PAUSE.
> KVM_REQ_PAUSE looks good to me. But will the "pause" cause any confusion with
> the guest's pause state?

Maybe?

> > And with appropriate helpers in common code.  I could have sworn I floated this
> > idea in the past for something else, but apparently not.  The only thing I can
> Yes, you suggested me to implement it via a request, similar to
> KVM_REQ_MCLOCK_INPROGRESS. [1].
> (I didn't add your suggested-by tag in this patch because it's just an RFC).
> 
> [1] https://lore.kernel.org/kvm/ZuR09EqzU1WbQYGd@google.com/
> 
> > find is an old arm64 version for pausing vCPUs to emulated.  Hmm, maybe I was
> > thinking of KVM_REQ_OUTSIDE_GUEST_MODE?
> KVM_REQ_OUTSIDE_GUEST_MODE just kicks vCPUs outside guest mode, it does not set
> a bit in vcpu->requests to prevent later vCPUs entering.

Yeah, I was mostly just talking to myself. :-)

> > Anyways, I don't see any reason to make this an arch specific request.
> After making it non-arch specific, probably we need an atomic counter for the
> start/stop requests in the common helpers. So I just made it TDX-specific to
> keep it simple in the RFC.

Oh, right.  I didn't consider the complications with multiple users.  Hrm.

Actually, this doesn't need to be a request.  KVM_REQ_OUTSIDE_GUEST_MODE will
forces vCPUs to exit, at which point tdx_vcpu_run() can return immediately with
EXIT_FASTPATH_EXIT_HANDLED, which is all that kvm_vcpu_exit_request() does.  E.g.
have the zap side set wait_for_sept_zap before blasting the request to all vCPU,
and then in tdx_vcpu_run():

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b49dcf32206b..508ad6462e6d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -921,6 +921,9 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
                return EXIT_FASTPATH_NONE;
        }
 
+       if (unlikely(READ_ONCE(to_kvm_tdx(vcpu->kvm)->wait_for_sept_zap)))
+               return EXIT_FASTPATH_EXIT_HANDLED;
+
        trace_kvm_entry(vcpu, force_immediate_exit);
 
        if (pi_test_on(&tdx->pi_desc)) {


Ooh, but there's a subtle flaw with that approach.  Unlike kvm_vcpu_exit_request(),
the above check would obviously happen before entry to the guest, which means that,
in theory, KVM needs to goto cancel_injection to re-request req_immediate_exit and
cancel injection:

	if (req_immediate_exit)
		kvm_make_request(KVM_REQ_EVENT, vcpu);
	kvm_x86_call(cancel_injection)(vcpu);

But!  This actually an opportunity to harden KVM.  Because the TDX module doesn't
guarantee entry, it's already possible for KVM to _think_ it completely entry to
the guest without actually having done so.  It just happens to work because KVM
never needs to force an immediate exit for TDX, and can't do direct injection,
i.e. can "safely" skip the cancel_injection path.

So, I think can and should go with the above suggestion, but also add a WARN on
req_immediate_exit being set, because TDX ignores it entirely.

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b49dcf32206b..e23cd8231144 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -914,6 +914,9 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
        struct vcpu_tdx *tdx = to_tdx(vcpu);
        struct vcpu_vt *vt = to_tdx(vcpu);
 
+       /* <comment goes here> */
+       WARN_ON_ONCE(force_immediate_exit);
+
        /* TDX exit handle takes care of this error case. */
        if (unlikely(tdx->state != VCPU_TD_STATE_INITIALIZED)) {
                tdx->vp_enter_ret = TDX_SW_ERROR;
@@ -921,6 +924,9 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
                return EXIT_FASTPATH_NONE;
        }
 
+       if (unlikely(to_kvm_tdx(vcpu->kvm)->wait_for_sept_zap))
+               return EXIT_FASTPATH_EXIT_HANDLED;
+
        trace_kvm_entry(vcpu, force_immediate_exit);
 
        if (pi_test_on(&tdx->pi_desc)) {

