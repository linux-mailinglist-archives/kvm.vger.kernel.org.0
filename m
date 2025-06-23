Return-Path: <kvm+bounces-50410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F32D2AE4D8C
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 21:22:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2EF23A2471
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 19:22:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1357F2D323F;
	Mon, 23 Jun 2025 19:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mqEumHpz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEF01078F
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 19:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750706559; cv=none; b=WBTuGL0fqHn6PzNNrzfCuLRNZOBqik88dNNJa7oHCOCdrjuRDfJxjIYgnVxoFfNd5GFqnwljjIjcP8eSwbByV0kCI8Nxz+TxxGakXyIOXEZOP1eM4WENotwCiwRhs0Y4s7N+Oe2WKgFlMyWK10a3JW5yr0vokKVoUxnPkaQwGK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750706559; c=relaxed/simple;
	bh=8sfjrM8xdtDx8xihK4hO86kfCv6rfj6jYTGptLagxzM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FVmtDWio3xGOPchgN36PTIwUZgHgsa1BJCRLCqvtJrTFvq5AII1hNtIACwNmAFgV+ADOdUmriGl0QNJ2kwhw3h31JFm/4dr7ymAqdW2Mrrk5LZVpWTDTI/Z7vqj32Q0JgjDzc+5FzyjU8KZ+QO850SLgWQsW0pUV244H1TjYTaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mqEumHpz; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2fdba7f818so5152115a12.2
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750706556; x=1751311356; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mH1izpCgKOdRs0luEnasPZfMbo2anYXefmEsOxYxfQI=;
        b=mqEumHpzoOj+ZwQpYVeZ8ROSgG1vRLia39lxfC/b/SJ/9lppYGHzswONhL1lqZ6S6w
         Zh/orO30V0YqdIZpV0mQXxQSfhVjxYA2bc11leQK+fpc4nSlhfHgMgFMOetkDmN9sj/d
         wmP7oPZ6GECUp/Ft7w4DCai+drwYYElqwcC4ohTceiQtK0xGLLirG6yiwFXMBrP82WbQ
         SYC381+gnxqn+FogChZ25KxcRTpNZiBha6CAswmFAKGX1vmi9cp+GK0Y0CuHtrs8Kot1
         FYjcPzCfgkHUDLD6rJ/67EqycPrTnJ8wJEHV3B/lBUHsa9rPqfGTIjbowDVEfkQ/1WnQ
         Y5lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750706556; x=1751311356;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mH1izpCgKOdRs0luEnasPZfMbo2anYXefmEsOxYxfQI=;
        b=UujUWFvdVNloyb5vw6UELTXSbBOyHOq5w0MSXKl0pB8Pd1WHhK+0XElbC4aOt/vynb
         b4ps+KkWMud59YPH6n5+r+HLgAP22M1Gd+JLo7T2C4SIOu94mCklSSckPYo0VYEqBlb9
         l2gR7ulgXz3kmDm504wW8zhzzcXzj36mijEAQ+Ej/o3ELFaw30o6MeSrXLB90DsRiepe
         5nRH2i4wg0Zb8fyMGNA1Y8mFLQA0LdIjAtOBQPMep91wBBIk+qwi4FrZp3RSzko82YY/
         EDUBca/ECWTH67YIl65NO4nTHOoSd0zlxmQ5+LgYVqmeRCczVWqAknK/Xr+xkczx3ZYe
         dYyg==
X-Forwarded-Encrypted: i=1; AJvYcCXoqMRO2J+SEoZVDdmVVLe/vKM1aGLArXQVr0Hngh6cLyBgcYYkrW2NmCOH1g5p9NZBOj4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaVWqNb8PW1IeMQ0LmKsQbS6d0aF+V37a23qfkmJqjp5RCil+7
	x7KEhm87e8ysxQtx5gqqc9q2S3u8GuUZesmxA1d12D4KybVrQk3wLJyjBFCazoZ99CtETWLbjkQ
	e0SPSFw==
X-Google-Smtp-Source: AGHT+IH7I9v6zHc4cbTrZUDYu8elviPUdSP6+QeYRx4dISPv8ZdbFyj5Ye/636EGB3YXaNdeSrOpFVWoN8I=
X-Received: from pjboe18.prod.google.com ([2002:a17:90b:3952:b0:312:f88d:25f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e87:b0:313:1769:eb49
 with SMTP id 98e67ed59e1d1-3159d63cf11mr22012299a91.8.1750706555935; Mon, 23
 Jun 2025 12:22:35 -0700 (PDT)
Date: Mon, 23 Jun 2025 12:22:34 -0700
In-Reply-To: <e255fa3ee192b136eeef7e9a63e8d1506d5e85a8.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
 <20250326193619.3714986-13-yosry.ahmed@linux.dev> <e255fa3ee192b136eeef7e9a63e8d1506d5e85a8.camel@redhat.com>
Message-ID: <aFmpeqtEbVmTl5N-@google.com>
Subject: Re: [RFC PATCH 12/24] KVM: x86: hyper-v: Pass is_guest_mode to kvm_hv_vcpu_purge_flush_tlb()
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Rik van Riel <riel@surriel.com>, Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 03, 2025, Maxim Levitsky wrote:
> On Wed, 2025-03-26 at 19:36 +0000, Yosry Ahmed wrote:
> > Instead of calling is_guest_mode() inside kvm_hv_vcpu_purge_flush_tlb()
> > pass the value from the caller. Future changes will pass different
> > values than is_guest_mode(vcpu).
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/hyperv.h  | 8 +++++---
> >  arch/x86/kvm/svm/svm.c | 2 +-
> >  arch/x86/kvm/x86.c     | 2 +-
> >  3 files changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
> > index 913bfc96959cb..be715deaeb003 100644
> > --- a/arch/x86/kvm/hyperv.h
> > +++ b/arch/x86/kvm/hyperv.h
> > @@ -203,14 +203,15 @@ static inline struct kvm_vcpu_hv_tlb_flush_fifo *kvm_hv_get_tlb_flush_fifo(struc
> >  	return &hv_vcpu->tlb_flush_fifo[i];
> >  }
> >  
> > -static inline void kvm_hv_vcpu_purge_flush_tlb(struct kvm_vcpu *vcpu)
> > +static inline void kvm_hv_vcpu_purge_flush_tlb(struct kvm_vcpu *vcpu,
> > +					       bool is_guest_mode)

NAK, passing around is_guest_mode is going to cause problems.  All it takes is
one snippet of code that operates on the current vCPU state for KVM to end up
with bugs.  It's unfortunate that kvm_hv_get_tlb_flush_fifo() takes in an
@is_guest_mode param, but that's "necessary" due to the cross-vCPU nature of
the usage.  For this case, there is no such requirement/restriction.

I also think that being super explicit isn't a bad thing, even if it means we
might end up with duplicate code.  I.e. having this

	vmcb_set_flush_asid(svm->vmcb01.ptr);
	if (svm->nested.vmcb02.ptr)
		vmcb_set_flush_asid(svm->nested.vmcb02.ptr);

in svm_flush_tlb_all() is a net positive IMO, because it explicitly reads "flush
vmcb01's ASID, and vmcb02's ASID if vmcb02 is valid".  Whereas this

        svm_flush_tlb_asid(vcpu, false);
        svm_flush_tlb_asid(vcpu, true);

isn't anywhere near as explicit.  I can make a good guess as to what true/false
are specifying, but many readers will need to go at least a layer or two deeper
to understand what's going on.  More importantly, it's not at all clear in
svm_flush_tlb_asid() that the vmcb can/should only be NULL in the is_guest_mode=true
case.

        if (vmcb)
                vmcb_set_flush_asid(vmcb);

And it's even actively dangerous, in that a bug where a vmcb is unexpectedly NULL
could lead to a missed TLB flush.  I.e. we *want* a NULL pointer #GP in a case
like this, so that the host yells loudly (even if it means panicking), versus
silently doing nothing and potentially corrupting guest data.  In practice, I can't
imagine such a bug ever being truly silent, e.g. KVM is all but guaranteed to
consume the NULL vmcb sooner than later.  But I still don't like creating such a
possibility.

> >  {
> >  	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
> >  
> >  	if (!to_hv_vcpu(vcpu) || !kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))

Case in point, kvm_check_request() is destructive (the name sucks, but it is what
it is), i.e. KVM_REQ_HV_TLB_FLUSH will be cleared, and so only the first of the
calls to svm_flush_tlb_asid() and thus kvm_hv_vcpu_purge_flush_tlb() will actually
do anything.  This particular bug is functionally benign (KVM will over-flush),
but it's still a bug.

Somewhat of a side topic, I think we should rename kvm_hv_vcpu_purge_flush_tlb()
to something like kvm_hv_purge_tlb_flush_fifo().  I initially read the first one
as "purge *and* flush TLBs", whereas the function is actually "purge the TLB
flush FIFO".

Completely untested, but I think we should shoot for something like this, over
2 or 3 patches.

---
 arch/x86/kvm/hyperv.h     | 14 +++++++++++++-
 arch/x86/kvm/svm/nested.c |  1 -
 arch/x86/kvm/svm/svm.c    | 17 ++++++++---------
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 913bfc96959c..f2c17459dd8b 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -203,7 +203,7 @@ static inline struct kvm_vcpu_hv_tlb_flush_fifo *kvm_hv_get_tlb_flush_fifo(struc
 	return &hv_vcpu->tlb_flush_fifo[i];
 }
 
-static inline void kvm_hv_vcpu_purge_flush_tlb(struct kvm_vcpu *vcpu)
+static inline void kvm_hv_purge_tlb_flush_fifo(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
 
@@ -215,6 +215,18 @@ static inline void kvm_hv_vcpu_purge_flush_tlb(struct kvm_vcpu *vcpu)
 	kfifo_reset_out(&tlb_flush_fifo->entries);
 }
 
+static inline void kvm_hv_purge_tlb_flush_fifo(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+	int i;
+
+	if (!hv_vcpu || !kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(hv_vcpu->tlb_flush_fifo); i++)
+		kfifo_reset_out(&hv_vcpu->tlb_flush_fifo[i]->entries);
+}
+
 static inline bool guest_hv_cpuid_has_l2_tlb_flush(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b6c27b34f8e5..7e9156f27a96 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -491,7 +491,6 @@ static void nested_svm_entry_tlb_flush(struct kvm_vcpu *vcpu)
 	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
 	 * things to fix before this can be conditional:
 	 *
-	 *  - Flush TLBs for both L1 and L2 remote TLB flush
 	 *  - Honor L1's request to flush an ASID on nested VMRUN
 	 *  - Sync nested NPT MMU on VMRUN that flushes L2's ASID[*]
 	 *  - Don't crush a pending TLB flush in vmcb02 on nested VMRUN
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 371593c4b629..f7be29733c9d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4163,15 +4163,8 @@ static void svm_flush_tlb_asid(struct kvm_vcpu *vcpu)
 	 * A TLB flush for the current ASID flushes both "host" and "guest" TLB
 	 * entries, and thus is a superset of Hyper-V's fine grained flushing.
 	 */
-	kvm_hv_vcpu_purge_flush_tlb(vcpu);
+	kvm_hv_purge_tlb_flush_fifo(vcpu);
 
-	/*
-	 * Flush only the current ASID even if the TLB flush was invoked via
-	 * kvm_flush_remote_tlbs().  Although flushing remote TLBs requires all
-	 * ASIDs to be flushed, KVM uses a single ASID for L1 and L2, and
-	 * unconditionally does a TLB flush on both nested VM-Enter and nested
-	 * VM-Exit (via kvm_mmu_reset_context()).
-	 */
 	vmcb_set_flush_asid(svm->vmcb);
 }
 
@@ -4193,6 +4186,8 @@ static void svm_flush_tlb_current(struct kvm_vcpu *vcpu)
 
 static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
 	/*
 	 * When running on Hyper-V with EnlightenedNptTlb enabled, remote TLB
 	 * flushes should be routed to hv_flush_remote_tlbs() without requesting
@@ -4203,7 +4198,11 @@ static void svm_flush_tlb_all(struct kvm_vcpu *vcpu)
 	if (WARN_ON_ONCE(svm_hv_is_enlightened_tlb_enabled(vcpu)))
 		hv_flush_remote_tlbs(vcpu->kvm);
 
-	svm_flush_tlb_asid(vcpu);
+	kvm_hv_vcpu_purge_flush_tlb_all(vcpu);
+
+	vmcb_set_flush_asid(svm->vmcb01.ptr);
+	if (svm->nested.vmcb02.ptr)
+		vmcb_set_flush_asid(svm->nested.vmcb02.ptr);
 }
 
 static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)

base-commit: ba550af5af66a83ad055519b2271f6a21f28cb1b
--

