Return-Path: <kvm+bounces-72065-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cDbUAi+ToGllkwQAu9opvQ
	(envelope-from <kvm+bounces-72065-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:38:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 206421ADCB6
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:38:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9CB8530E84F8
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 18:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C4123876D7;
	Thu, 26 Feb 2026 18:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CXyW/zTp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BCA332603
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 18:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772130030; cv=none; b=Y6G4s3MPSf4asD9hFvJFbuEILIjH4cZLJqo9DIKBMlC3FuV+Ane5pPlZakq3nEGKB9TLDWa/7j8sZqcZz6AaztQQX1FM8xoGc3szXsN7xJx1503dLyTneQLt78UcsaHsQ+7E8jDgrQY7Sanmjs31yB1eRFEsBbiidlxwV/JqieE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772130030; c=relaxed/simple;
	bh=nFE5m8dbsWGYttneL42uy16ZH1lEqGJBSIkbjkfM/EM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WFjv0WchRuD0APsWh1epjrwq4oomyyH/GnsT98bCh1XwEt1wwztLjSVE66fONR0jMgCmbY9dy6UTl+Ky5Wz1suFPgT5uw+u90ot9qO5TIt4wtHpt5x1rzF5eTOLcTaInvzt6mXJSQ2gpn059tbzWtJTKvvoy+NHfqOlEKBbV7Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CXyW/zTp; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6e1e748213so609921a12.2
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 10:20:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772130029; x=1772734829; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qA6rN9/U0k1KmfITPBKJsGW+h1Irca1/Mbc92gpAgJ8=;
        b=CXyW/zTp0cNyirYtTL0Jj8tHxtR/5d2bc9ejCPezRnIicrWDwN3FXdVyP6v/Kl+okd
         C6WbEgwcWDWvu6uWvlaAtBWEABibyLRE6gVtSVTD1hEmIu/xSJLH2A09+kwBGnhYQv/W
         RaOfZbAOZY505ig64jqX+M5J+pddd3p3jx92KoRj7JyjGbD4CN0hXlvote28GD/Kz+iv
         PhiNGGb4zChbnDPH2zIwJs8Ev+j02Kiqm4UuLMEbRnXJPFQ8UnGq1aKpTEC0bAM/QuEG
         KIx5EdUuiifqvCm9ZQ6RKpDHFqiPKtk3LeUKwaF5WZ8G4l25ietzPgvaR7yfm+nGlU4k
         AMtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772130029; x=1772734829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qA6rN9/U0k1KmfITPBKJsGW+h1Irca1/Mbc92gpAgJ8=;
        b=uMCCVkDCN67J+y2pWSwThgSPhSqKGvlCdKmc0a0rgRF+ubchvFZQ0+SHMnJr0jGDAW
         TF4X7fGx7aSrftISjCH9PaYLwLUWZ5V8cWPbt4MZssa2fFQuh5n4WR1zVmE0V/FiNVZs
         UDuUVUBfSwL/aEoQQWbbHBg6tplf8RKtdP1TAM2FLvhRBFnumd3rOtQIQMp3asiccGOX
         k8sN9U5sbOGQ/ck946NtAmIOeg775rCWxl57EdTWoxaKkBwXYU4gVu1fv194GaBIQ90c
         cNRbQRi63AVNafXm08KMKttA2aqUvRzaZ56RSVC8/P0I4cpTEVAv1VAiPokVzftTDL8z
         gyWA==
X-Forwarded-Encrypted: i=1; AJvYcCWDOuziBGkLHGaKwhC9n2wstTIwlEEbWynnsX5R9Bey7atns+1BiZo65TyH5jl18aDR/8g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw35sJ/jVHkMgLmi6dagEM0C2qGRc1I8BhjasAMb0D8Yp7iC0bU
	4WvpUGMgO2wKVWETUuPgSOgKoeIhVG2Tc3C8+7B0K/nB1wzGwDTp43ECmgIC2AbP9IAbStJGp4I
	Ve7WdTQ==
X-Received: from pgmh15.prod.google.com ([2002:a63:574f:0:b0:c1d:67e2:834])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3405:b0:35e:8b76:c960
 with SMTP id adf61e73a8af0-395c3b16cf8mr166728637.48.1772130028579; Thu, 26
 Feb 2026 10:20:28 -0800 (PST)
Date: Thu, 26 Feb 2026 10:20:27 -0800
In-Reply-To: <txfn2izdpaavep6yrcujlxkqrqf2gwk2ccb6dplwcfnsstdnie@lgx74e27nus7>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260209195142.2554532-1-yosry.ahmed@linux.dev>
 <20260209195142.2554532-2-yosry.ahmed@linux.dev> <txfn2izdpaavep6yrcujlxkqrqf2gwk2ccb6dplwcfnsstdnie@lgx74e27nus7>
Message-ID: <aaCO62eQiZX5pvSk@google.com>
Subject: Re: [PATCH v2 1/2] KVM: SVM: Triple fault L1 on unintercepted
 EFER.SVME clear by L2
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72065-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,linux.dev:email]
X-Rspamd-Queue-Id: 206421ADCB6
X-Rspamd-Action: no action

On Thu, Feb 26, 2026, Yosry Ahmed wrote:
> On Mon, Feb 09, 2026 at 07:51:41PM +0000, Yosry Ahmed wrote:
> > KVM tracks when EFER.SVME is set and cleared to initialize and tear down
> > nested state. However, it doesn't differentiate if EFER.SVME is getting
> > toggled in L1 or L2+. If L2 clears EFER.SVME, and L1 does not intercept
> > the EFER write, KVM exits guest mode and tears down nested state while
> > L2 is running, executing L1 without injecting a proper #VMEXIT.
> > 
> > According to the APM:
> > 
> >     The effect of turning off EFER.SVME while a guest is running is
> >     undefined; therefore, the VMM should always prevent guests from
> >     writing EFER.
> > 
> > Since the behavior is architecturally undefined, KVM gets to choose what
> > to do. Inject a triple fault into L1 as a more graceful option that
> > running L1 with corrupted state.
> > 
> > Co-developed-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/kvm/svm/svm.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 5f0136dbdde6..ccd73a3be3f9 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -216,6 +216,17 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
> >  
> >  	if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
> >  		if (!(efer & EFER_SVME)) {
> > +			/*
> > +			 * Architecturally, clearing EFER.SVME while a guest is
> > +			 * running yields undefined behavior, i.e. KVM can do
> > +			 * literally anything.  Force the vCPU back into L1 as
> > +			 * that is the safest option for KVM, but synthesize a
> > +			 * triple fault (for L1!) so that KVM at least doesn't
> > +			 * run random L2 code in the context of L1.
> > +			 */
> > +			if (is_guest_mode(vcpu))
> > +				kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> > +
> 
> Sigh, I think this is not correct in all cases:
> 
> 1. If userspace restores a vCPU with EFER.SVME=0 to a vCPU with
> EFER.SVME=1 (e.g. restoring a vCPU running to a vCPU running L2).
> Typically KVM_SET_SREGS is done before KVM_SET_NESTED_STATE, so we may
> set EFER.SVME = 0 before leaving guest mode.
> 
> 2. On vCPU reset, we clear EFER. Hmm, this one is seemingly okay tho,
> looking at kvm_vcpu_reset(), we leave nested first:
> 
> 	/*
> 	 * SVM doesn't unconditionally VM-Exit on INIT and SHUTDOWN, thus it's
> 	 * possible to INIT the vCPU while L2 is active.  Force the vCPU back
> 	 * into L1 as EFER.SVME is cleared on INIT (along with all other EFER
> 	 * bits), i.e. virtualization is disabled.
> 	 */
> 	if (is_guest_mode(vcpu))
> 		kvm_leave_nested(vcpu);
> 
> 	...
> 
> 	kvm_x86_call(set_efer)(vcpu, 0);
> 
> So I think the only problematic case is (1). We can probably fix this by
> plumbing host_initiated through set_efer? This is getting more
> complicated than I would have liked..

What if we instead hook WRMSR interception?  A little fugly (well, more than a
little), but I think it would minimize the chances of a false-positive.  The
biggest potential flaw I see is that this will incorrectly triple fault if KVM
synthesizes a #VMEXIT while emulating the WRMSR.  But that really shouldn't
happen, because even a #GP=>#VMEXIT needs to be queued but not synthesized until
the emulation sequence completes (any other behavior would risk confusing KVM).

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8f8bc863e214..1d8d9960df20 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3119,10 +3119,28 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 static int msr_interception(struct kvm_vcpu *vcpu)
 {
-       if (to_svm(vcpu)->vmcb->control.exit_info_1)
-               return kvm_emulate_wrmsr(vcpu);
-       else
+       bool efer_l2 = is_guest_mode(vcpu) && kvm_rcx_read(vcpu) == MSR_EFER;
+       int r;
+
+       if (!to_svm(vcpu)->vmcb->control.exit_info_1)
                return kvm_emulate_rdmsr(vcpu);
+
+       r = kvm_emulate_wrmsr(vcpu);
+
+       /*
+        * If EFER.SVME is cleared while the vCPU is in L2, KVM forces the vCPU
+        * back into L1 as that is the safest option for KVM.  Architecturally,
+        * clearing EFER.SVME while a guest is running yields undefined behavior,
+        * i.e. KVM can do literally anything.  Synthesize a shutdown (for L1!)
+        * if EFER.SVME was cleared on a guest WRMSR (to avoid false positives
+        * on userspace restoring state), so that so that KVM at least doesn't
+        * run random L2 code in the
+        * context of L1.
+        */
+       if (r && efer_l2 && !is_guest_mode(vcpu))
+               kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+
+       return r;
 }
 
 static int interrupt_window_interception(struct kvm_vcpu *vcpu)

