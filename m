Return-Path: <kvm+bounces-71744-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WEuvIF9QnmlIUgQAu9opvQ
	(envelope-from <kvm+bounces-71744-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:29:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 081D018EB9A
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 02:29:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EDB34304FFBF
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 01:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D31AB256C6C;
	Wed, 25 Feb 2026 01:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0EFQtS/K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29F61D5ABA
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 01:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982754; cv=none; b=IEojdKiRpzQ/KfcVRYc1/VHYHdz3Y9dQHSfKTGexWsCPEtgEsqZiExAvkn1CvJcFlTgZOdp0b87gZin7Ev8x2AbWrtR2OvJx+h0eTG8Kk2jUBW2aY18RxcPtnRGf29Dwrbrc0IIVY76d4LPbBCvlG/R3pPkKau7gcJFnz85jmlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982754; c=relaxed/simple;
	bh=ryim3kBKfVpNClBm87uaeHeC28gK3jBN4xRGvEH2sTo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Geffd/h+qhsR3E9+xlWyZq5ygXZXZiwx115RNe4B5crF0s06M2NmTZAQG/vhaM2wbAEv8r63Jrg1JaARNTGZ+x8NGcKAr7EiSuX899JNwHYOixQKb+8b5EZiqt+xjIYnoq4Syy5LtcOOI9IWmqlqVkmCPVux00aXKIefZlemTf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0EFQtS/K; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35449510446so6100465a91.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 17:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771982752; x=1772587552; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O/dMkWi/E0gzEc9xlKrxZrN+8RFKbCVIlfOl5w/8K8Y=;
        b=0EFQtS/KT1thHFV9tfcvpczJxk3g5SeTrr0uSyDAJ3+UEMl4FdqYUuG/56DfZXI2S7
         YZGap1Sfsqz/XclpY/JinY31UWfjnDjeEIeKPVdUEPOcV+K3hGd1ZMYsCpmmBoTuM7ro
         jpJN5AaWg7WiHO+5PWvCL9MFpHagNIOQw6DEcUsStcHwTe9fYdEmWC5cHTnh6EXrZKe0
         YZm7+4g9RZWuKLmu9PkLnhgfTbK2SdnQM/SE/gy2/aOKnJ0QhpAwxs1izgdfdMg5O0dv
         fJv/WkCBSkItjo93dRV2HScnHjGGTxzs8XkMXhn8C2W7QsGxEZtgCAS/O7WnhK1h2gxk
         RDEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771982752; x=1772587552;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=O/dMkWi/E0gzEc9xlKrxZrN+8RFKbCVIlfOl5w/8K8Y=;
        b=nu0mH0VLqMYCY8AZFQj8i6QXG7/I7o1R58BuI6O+YzQ5e4RPYr0g7YAU2m7lvpsWjs
         ygbWuXlKZFTn3sZLVEr43iJQFhoT5pCdppFSjNdSutsBI2vzX+vBZDvMxs/ZXVGtRQiM
         YaAY+mJvtpYfLRAOW1OWLdKaOWJmulwrQ+nqttjgdontV5IV+0AFR10QLnYkGU9Wci6o
         GhQCzbYzZQXtyk8vzwcgCNBf7UTf6SI3Anuehw5knVbwjifV9/tSY7wXps9MuwN0cvRV
         JK7e1k/AvthXqBhSJra6JvYRihrNYGDGlU8xi0iXAb8ilutViJLSr6O0kcl2CAdknBxp
         z98w==
X-Forwarded-Encrypted: i=1; AJvYcCVfjr9XYjysc3XskZXbBEqCtZcHJm2DRVX3dObBq7K349/Y3g3XeutDKbK0JyUt+r6cwV4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyV1A3h4rcVzS/j5Y0QOz69cqhC3zwkDSNLQNjxPdTfH7HlO8V1
	G0VL7jHX0xm1jfhw0jJO95S3B4DRrnX/EwimbvITlBPHkQibWVwt8wuOU9s+tQYVnLAlmAfX6Tq
	xWBGbTg==
X-Received: from pjbge3.prod.google.com ([2002:a17:90b:e03:b0:354:be64:d426])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2812:b0:354:a9f3:68bc
 with SMTP id 98e67ed59e1d1-358ae8e8390mr10841719a91.30.1771982752378; Tue, 24
 Feb 2026 17:25:52 -0800 (PST)
Date: Tue, 24 Feb 2026 17:25:50 -0800
In-Reply-To: <CAO9r8zO+Eej0AjzQt6dnELKLKHZ33DGLbDv=_sP1J1qLMVWpvw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260223154636.116671-1-yosry@kernel.org> <20260223154636.116671-3-yosry@kernel.org>
 <CAO9r8zPsAMaiU794xoXDso3sdAM0_EN2PyE13vR4NqqEh9e2=g@mail.gmail.com>
 <aZ5ItfEUtIlVbzuQ@google.com> <CAO9r8zPbu1BsOsPU02YcCLDbRXZoDmVd8XiMHssSDnkjdDPC4g@mail.gmail.com>
 <aZ5MF8_RK56C8B9Q@google.com> <CAO9r8zO+Eej0AjzQt6dnELKLKHZ33DGLbDv=_sP1J1qLMVWpvw@mail.gmail.com>
Message-ID: <aZ5Pnvb4OAVWWtuR@google.com>
Subject: Re: [PATCH v1 2/4] KVM: nSVM: Delay stuffing L2's current RIP into
 NextRIP until vCPU run
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71744-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: 081D018EB9A
X-Rspamd-Action: no action

On Tue, Feb 24, 2026, Yosry Ahmed wrote:
> On Tue, Feb 24, 2026 at 5:10=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Tue, Feb 24, 2026, Yosry Ahmed wrote:
> > > > > Doing this in svm_prepare_switch_to_guest() is wrong, or at least
> > > > > after the svm->guest_state_loaded check. It's possible to emulate=
 the
> > > > > nested VMRUN without doing a vcpu_put(), which means
> > > > > svm->guest_state_loaded will remain true and this code will be
> > > > > skipped.
> > > > >
> > > > > In fact, this breaks the svm_nested_soft_inject_test test. Funny
> > > > > enough, I was only running it with my repro changes, which papere=
d
> > > > > over the bug because it forced an exit to userspace after VMRUN d=
ue to
> > > > > single-stepping, so svm->guest_state_loaded got cleared and the c=
ode
> > > > > was executed on the next KVM_RUN, before L2 runs.
> > > > >
> > > > > I can move it above the svm->guest_state_loaded check, but I thin=
k I
> > > > > will just put it in pre_svm_run() instead.
> > > >
> > > > I would rather not expand pre_svm_run(), and instead just open code=
 it in
> > > > svm_vcpu_run().  pre_svm_run() probably should never have been adde=
d, because
> > > > it's far from a generic "pre run" API.  E.g. if we want to keep the=
 helper around,
> > > > it should probably be named something something ASID.
> > >
> > > I sent a new version before I saw your response.. sorry.
> > >
> > > How strongly do you feel about this? :P
> >
> > Strong enough that I'll fix it up when applying, unless it's a sticking=
 point on
> > your end.
>=20
> It's just that 99% of the time someone is reading svm_vcpu_run(), they
> won't care about this code, and it's also cognitive load to filter it
> out. We can add a helper for this code (and the soft IRQ inject),
> something like svm_fixup_nested_rips() or sth.

I don't entirely disagree, but at the same time, why is someome reading svm=
_vcpu_run()
if they don't want to look at the gory details?

> We discussed a helper before and you didn't like it, but that was in a
> different context (a helper that combined normal and special cases).
> WDYT?

A helper would work.  svm_fixup_nested_rips() is good, the only flaw is the=
 CS.base
chunk, but I'm not sure I care enough about 32-bit to reject the name just =
because
of that :-)

That would make it easier to reduce indentation, e.g.

static void svm_fixup_nested_rips(struct kvm_vcpu *vcpu)
{
	struct vcpu_svm *svm =3D to_svm(vcpu);

	/*
	 * If nrips is supported in hardware but not exposed to L1, stuff the
	 * actual L2 RIP to emulate what a nrips=3D0 CPU would do (L1 is
	 * responsible for advancing RIP prior to injecting the event). Once L2
	 * runs after L1 executes VMRUN, NextRIP is updated by the CPU and/or
	 * KVM, and this is no longer needed.
	 *
	 * This is done here (as opposed to when preparing vmcb02) to use the
	 * most up-to-date value of RIP regardless of the order of restoring
	 * registers and nested state in the vCPU save+restore path.
	 *
	 * Simiarly, initialize svm->soft_int_* fields here to use the most
	 * up-to-date values of RIP and CS base, regardless of restore order.
	 */
	if (!is_guest_mode(vcpu) || !svm->nested.nested_run_pending)
		return;

	if (boot_cpu_has(X86_FEATURE_NRIPS) &&
	    !guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
		svm->vmcb->control.next_rip =3D kvm_rip_read(vcpu);

	if (svm->soft_int_injected) {
		svm->soft_int_csbase =3D svm->vmcb->save.cs.base;
		svm->soft_int_old_rip =3D kvm_rip_read(vcpu);
		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
			svm->soft_int_next_rip =3D kvm_rip_read(vcpu);
	}
}

