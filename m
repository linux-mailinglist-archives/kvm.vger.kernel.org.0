Return-Path: <kvm+bounces-72254-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IHw3OyM6omk71AQAu9opvQ
	(envelope-from <kvm+bounces-72254-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:43:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5675C1BF765
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:43:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 856FD309A109
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:42:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D057525A659;
	Sat, 28 Feb 2026 00:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2tepMcmV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6CE247280
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 00:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772239323; cv=none; b=ezAAYJaPprdfh7MfmDBNoFUIAUYoDVngwtlICsszJGfp1axmD9BfhhObKG0seyjld+7UOIvrFqMF+CHQENp3+uxkpwfQsncV0kas61scfFQxiQG3aMwbNA64AgyQKR6UGShQXcg/dUcSg8Y9JJuPBtLeJkfQlvKA0nC328d7vuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772239323; c=relaxed/simple;
	bh=9toE/TcnwEPtzvF1qEKJ6RNkBU4CPRu0UNU7oHtucVs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XHwwykQtGRzy5EsPfif7yrH/2mqa3bJcZvJQsP8vcpH+siHY0Gbj3DoJxyLjd3XpLySgyA4XMgH1WJ9F8pFOOOxlBPRH1SKitCPTKywmyGuHfgvn6Vdtck7DgVLFJnk1FhNRUPYfEpuCIQWGs3JCnKmtqEy7YnbOm12/u4hsdRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2tepMcmV; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2aad3380076so19893745ad.1
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 16:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772239321; x=1772844121; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=68Ry/xHu2ReJVA+wcicUUHRYF79mXS1sKh11XfGJAsw=;
        b=2tepMcmVVPapfjZCh3IseRLjXbFOBemnPuK232Y7WbBRCdQx0wD1O1DJ8fPZYqqYR2
         w2EJDv0+3QsRry/gnw11F2CvJyP9T59KmjNItMLWoiUR6hV1PRvUdKuhRRskLYAwi1o6
         EiCtNvUlRCbEVJEYfJ9eo4LonK4Aj0yqAXYoNE7p3O5Pu2pFy2Lxy+WcmkaR/ppnVf9l
         vU01jcSc00BmRtMozdxhgzPhTuotdFU3JXMgZ17fGE5FhXfpv9uhJkIxf+VHz/DOp5PN
         C/paSzmLwugEgbEU+bTRBdxG44TfmzewqFaVVEDEhyOo0asZZNIgVuQgX4c/yHdBAMYC
         VLLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772239321; x=1772844121;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=68Ry/xHu2ReJVA+wcicUUHRYF79mXS1sKh11XfGJAsw=;
        b=Ov9ameE5FB1MgBeiGmVoPrh09/2KeSQQXrQHAQWhZDXUUtZlvhssJ8AHg/77e650SL
         bLdA2/XzRwQ5XoEv47FwFMIArYghtQNSaHD3NW7rDnkXEsEjQeN3oha4TpBNXmTjUk0Q
         IEdKQmP2MKf3AwUTVqj8OFaNVGZzCSSAZRg1x0nI5lpp8KUDCgUM2lQSnrXp8mnMMGr6
         eXGVjG1vBv2onNZIvxE0qoi6eSpZNYQFggbGqKnrUq1He4Qz4by0qlguDabNNABSOOIH
         9bREFX2leQqBSAWA0WpTGh9iLrKtyRZ7BxKXN2zA+HYS9Z+zYi+qOEo8PNjkSZl2+9oW
         q0dg==
X-Forwarded-Encrypted: i=1; AJvYcCUSS7whFnL1xRqXZ738v+l28BkcAZIfzAsln63HN2+9v+HSSB4vDutNVVKd4JSjvlu5vqA=@vger.kernel.org
X-Gm-Message-State: AOJu0YygkRJp7+Z4ox04zWKFWpyqrI5uApIdDwFHtEnwldwwqSLsQbYF
	X9TOBu5ZpE9OqNTJMWZ/t1Gkztq5VTBomWE0qYTgUt26TqDXXCQw6j18eyqteEmBWZvBDHD1DUC
	XOBPYNQ==
X-Received: from pgbfe11.prod.google.com ([2002:a05:6a02:288b:b0:c08:3dd8:1e39])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:4d05:b0:38e:916c:b701
 with SMTP id adf61e73a8af0-395b1cf4e96mr7607546637.3.1772239320992; Fri, 27
 Feb 2026 16:42:00 -0800 (PST)
Date: Fri, 27 Feb 2026 16:41:59 -0800
In-Reply-To: <CAO9r8zOcBbgtNzy6FizPe8Xm8W=jg3CR8pmdByfszfEM3rqzsA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260209195142.2554532-1-yosry.ahmed@linux.dev>
 <20260209195142.2554532-2-yosry.ahmed@linux.dev> <txfn2izdpaavep6yrcujlxkqrqf2gwk2ccb6dplwcfnsstdnie@lgx74e27nus7>
 <aaCO62eQiZX5pvSk@google.com> <CAO9r8zOcBbgtNzy6FizPe8Xm8W=jg3CR8pmdByfszfEM3rqzsA@mail.gmail.com>
Message-ID: <aaI51_1_bR4zRTXY@google.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72254-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: 5675C1BF765
X-Rspamd-Action: no action

On Fri, Feb 27, 2026, Yosry Ahmed wrote:
> > > > @@ -216,6 +216,17 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
> > > >
> > > >     if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
> > > >             if (!(efer & EFER_SVME)) {
> > > > +                   /*
> > > > +                    * Architecturally, clearing EFER.SVME while a guest is
> > > > +                    * running yields undefined behavior, i.e. KVM can do
> > > > +                    * literally anything.  Force the vCPU back into L1 as
> > > > +                    * that is the safest option for KVM, but synthesize a
> > > > +                    * triple fault (for L1!) so that KVM at least doesn't
> > > > +                    * run random L2 code in the context of L1.
> > > > +                    */
> > > > +                   if (is_guest_mode(vcpu))
> > > > +                           kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> > > > +
> > >
> > > Sigh, I think this is not correct in all cases:
> > >
> > > 1. If userspace restores a vCPU with EFER.SVME=0 to a vCPU with
> > > EFER.SVME=1 (e.g. restoring a vCPU running to a vCPU running L2).
> > > Typically KVM_SET_SREGS is done before KVM_SET_NESTED_STATE, so we may
> > > set EFER.SVME = 0 before leaving guest mode.
> > >
> > > 2. On vCPU reset, we clear EFER. Hmm, this one is seemingly okay tho,
> > > looking at kvm_vcpu_reset(), we leave nested first:
> > >
> > >       /*
> > >        * SVM doesn't unconditionally VM-Exit on INIT and SHUTDOWN, thus it's
> > >        * possible to INIT the vCPU while L2 is active.  Force the vCPU back
> > >        * into L1 as EFER.SVME is cleared on INIT (along with all other EFER
> > >        * bits), i.e. virtualization is disabled.
> > >        */
> > >       if (is_guest_mode(vcpu))
> > >               kvm_leave_nested(vcpu);
> > >
> > >       ...
> > >
> > >       kvm_x86_call(set_efer)(vcpu, 0);
> > >
> > > So I think the only problematic case is (1). We can probably fix this by
> > > plumbing host_initiated through set_efer? This is getting more
> > > complicated than I would have liked..
> >
> > What if we instead hook WRMSR interception?  A little fugly (well, more than a
> > little), but I think it would minimize the chances of a false-positive.  The
> > biggest potential flaw I see is that this will incorrectly triple fault if KVM
> > synthesizes a #VMEXIT while emulating the WRMSR.  But that really shouldn't
> > happen, because even a #GP=>#VMEXIT needs to be queued but not synthesized until
> > the emulation sequence completes (any other behavior would risk confusing KVM).
> 
> What if we key off vcpu->wants_to_run?

That crossed my mind too.

> It's less protection against false positives from things like
> kvm_vcpu_reset() if it didn't leave nested before clearing EFER, but
> more protection against the #VMEXIT case you mentioned. Also should be
> much lower on the fugliness scale imo.

Yeah, I had pretty much the exact same thought process and assessment.  I suggested
the WRMSR approach because I'm not sure how I feel about using wants_to_run for
functional behavior.  But after realizing that hooking WRMSR won't handle RSM,
I'm solidly against my WRMSR idea.

Honestly, I'm leaning slightly towards dropping this patch entirely since it's
not a bug fix.  But I'm definitely not completely against it either.  So what if
we throw it in, but plan on reverting if there are any more problems (that aren't
obviously due to goofs elsewhere in KVM).

Is this what you were thinking?

---
 arch/x86/kvm/svm/svm.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1b31b033d79b..3e48e9c1c955 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -216,6 +216,19 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 
 	if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
 		if (!(efer & EFER_SVME)) {
+			/*
+			 * Architecturally, clearing EFER.SVME while a guest is
+			 * running yields undefined behavior, i.e. KVM can do
+			 * literally anything.  Force the vCPU back into L1 as
+			 * that is the safest option for KVM, but synthesize a
+			 * triple fault (for L1!) so that KVM at least doesn't
+			 * run random L2 code in the context of L1.  Do so if
+			 * and only if the vCPU is actively running, e.g. to
+			 * avoid positives if userspace is stuffing state.
+			 */
+			if (is_guest_mode(vcpu) && vcpu->wants_to_run)
+				kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+
 			svm_leave_nested(vcpu);
 			/* #GP intercept is still needed for vmware backdoor */
 			if (!enable_vmware_backdoor)

base-commit: 95deaec3557dced322e2540bfa426e60e5373d46
--

