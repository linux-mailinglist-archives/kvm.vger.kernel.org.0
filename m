Return-Path: <kvm+bounces-35894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A291AA15A38
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 01:03:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6C5F188B7B0
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D6D21853;
	Sat, 18 Jan 2025 00:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RNbErqVw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABE6173
	for <kvm@vger.kernel.org>; Sat, 18 Jan 2025 00:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737158613; cv=none; b=svjKbyuYcnFJb6VW2F1fF97VIgSqfSd9cHeDKFlSQqNX3o1tMOcvx24YEfIv++0APYA5cOsF/bo0zOncdg/ixgg0j/P+peMdaKUQCdKXAyoy17ezc0OOfPuRSJ/cW25SoBjGDRRak+TlZYLUYRa+Nqd/upcjlss9Q+veZyiDeXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737158613; c=relaxed/simple;
	bh=qJdY9x8suc1rcBEi6tXK+0Y9fSUvD+XII4lshzIJFHI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MR0Meql9SWpneX6RJplgkYW8f7s4IU4JF3EYSTgyq0gfe4Zm8znF+JArxcs7vLmfb8vL7c2TXj2F2uQDWZuv/xrqEsXWtBGyBFzIgN33eVHyKoRmtD9lmGpHixCyYEwsbTKVjySEzFkaS8RIlZTgIgosO61R5zSK9s8YkfCdM84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RNbErqVw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef35de8901so5040374a91.3
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 16:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737158611; x=1737763411; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=etfdB542KXwDSKrqFlaD50tTuvndpX1rN0vVPU52dZU=;
        b=RNbErqVw3YJQnS/7KeiewE6/IgE50XX2Yq5aujxBJv0E5Hokv2UQXGbxSFwI2FMkpf
         dSEDmb38iZoKElSRfLefRm6hgH3H/ufWYN+8WhC26w17sPEGUq7+tLuerXTVg5aZcmvk
         rvFCBADSif6Z7a05x7DPh/2sGDYj2pHXYNURiCgqA+3fR6Bu44Rphe5lF5swIFdRfN75
         c8JwbMwIg+ANoA2XCVZ0ndj3c/DZ9Ej0JsI27ghLwW9W2skiNzbBLvfnaF/h5Anbt/DQ
         FfXVErS+yk4ogfcLri8LS9Hq3fHhWedcvT2XQJ7Qj+wxdTjrh9s9hSMsFeTRp2HNfOOS
         nC+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737158611; x=1737763411;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=etfdB542KXwDSKrqFlaD50tTuvndpX1rN0vVPU52dZU=;
        b=T9yQ4KCxSSx+p4IXysL1Nb2SrmBzY6yVGqp8MtpvS8X0MXQ+AlZ25OumjdYF7J0lMn
         TXApCvoqmdOw2spdarUGa/mXXEHqX8u+YDVrtgyi2J4B1klclQcm62OiRzMt9vdgJs+s
         8PA02SY1GYoZ2enaZBnWUSJbgSQ+BKFXnRaNFfqe92Fc1kyCoYtZ30e/CdtFu7NhtX6l
         vUn+a8HRtWZmw+L0cgyV97M+weCNfmdtoTtAREBqvEceVbnHr8hJmeg56M7YOQ3G5Lr9
         PjMvL6NCpULDkvvXSGblvPntM2CMWtckb4ZyofAJxPuFr7jU2oSy45yBp0yPcldHgwHX
         awiA==
X-Forwarded-Encrypted: i=1; AJvYcCUp8g9izQMNk334iA0Vx0g9BPCMRFkcb3LdlpKJWzGiOMsXZwwBp3AMEoYaIwdqPy0o9Bs=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywk8JAFTlU/qX6l68zxZ6mEVT0ZzE0LW5mzPn3kP5VpcgSoXega
	072vOrKnSK4H22vnkCruLBJmdogwenENhMr4YIWJ949gkwq5Z7Uo4EYn7IMaWe2uDgSG7UBCAwb
	tZg==
X-Google-Smtp-Source: AGHT+IHfKny2wEdvKVczFtFx/BNFEUOaoX62L1v/XH5SA10ePHOYZXPulOMMzYqGAfpFB2ydGgUrznkTLDg=
X-Received: from pjbli9.prod.google.com ([2002:a17:90b:48c9:b0:2ee:3cc1:7944])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f8e:b0:2ef:114d:7bf8
 with SMTP id 98e67ed59e1d1-2f782c4ff33mr6042973a91.6.1737158611359; Fri, 17
 Jan 2025 16:03:31 -0800 (PST)
Date: Fri, 17 Jan 2025 16:03:30 -0800
In-Reply-To: <CAJD7tkaa1cqUeUUKNdQADBqXH-G9h=5Liv+wj=5gitgbdO9Tsw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CALMp9eQoGsO8KvugXP631tL0kWbrcwMrPR_ErLa9c9-OCg7GaA@mail.gmail.com>
 <CAJD7tkbHARZSUNmoKjax=DHUioP1XBWhf639=7twYC63Dq0vwg@mail.gmail.com>
 <Z4k9seeAK09VAKiz@google.com> <CAJD7tkZQQUqh1GG5RpfYFT4-jK-CV7H+z9p2rTudLsrBe3WgbA@mail.gmail.com>
 <Z4mJpu3MvBeL4d1Q@google.com> <CAJD7tkbqxXQVd5s7adVqzdLBP22ef2Gs+R-SxuM7GtmetaWN+Q@mail.gmail.com>
 <Z4mlsr-xJnKxnDKc@google.com> <CAJD7tkahmyjXvwKO2=EfQRWu_BHPJ-8+eSEteZH5TGG3+jHtWw@mail.gmail.com>
 <Z4qbDBduEYWEwjkS@google.com> <CAJD7tkaa1cqUeUUKNdQADBqXH-G9h=5Liv+wj=5gitgbdO9Tsw@mail.gmail.com>
Message-ID: <Z4rv0jzFILtUxK4q@google.com>
Subject: Re: [PATCH] KVM: nVMX: Always use TLB_FLUSH_GUEST for nested VM-Enter/VM-Exit
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 17, 2025, Yosry Ahmed wrote:
> On Fri, Jan 17, 2025 at 10:01=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > Yep.  I suspect the issue is lack of documentation for TLB_FLUSH_GUEST =
and
> > TLB_FLUSH_CURRENT.  I'm not entirely sure where it would be best to doc=
ument
> > them.  I guess maybe where they are #defined?
>=20
> I guess at the #define we can just mention that they result in calling
> kvm_vcpu_flush_tlb_{guest/current}() before entering the guest, if
> anything.

Yeah, a "See xx for details" redirect is probably the best option.

> The specific documentation about what they do could be above the
> functions themselves, and describing the potential MMU sync is
> naturally part of documenting kvm_vcpu_flush_tlb_guest() (kinda
> already there).
>=20
> The flush_tlb_guest() callback is documented in kvm_host.h, but not
> flush_tlb_current(). I was going to suggest just documenting that. But
> kvm_vcpu_flush_tlb_guest() does not only call flush_tlb_guest(), but
> it also potentially synchronizes the MMU. So only documenting the
> callbacks does not paint a full picture.
>=20
> FTR, I initially confused myself because all kvm_vcpu_flush_tlb_*()
> functions are more-or-less thin wrappers around the per-vendor
> callbacks -- except kvm_vcpu_flush_tlb_guest().
>=20
> >
> > TLB_FLUSH_GUEST is used when a flush of the guest's TLB, from the guest=
's
> > perspective, is architecturally required.  The one oddity with TLB_FLUS=
H_GUEST
> > is that it does NOT include guest-physical mappings, i.e. TLB entries t=
hat are
> > associated with an EPT root.
>=20
> The way I think about this is how it's documented above the per-vendor
> callback. It flushes translations created by the guest. The guest does
> not (directly) create guest-physical translations, only linear and
> combined translations.

That's not accurate either.  When L1 is using nested TDP, it does create gu=
est-
physical translations.  The lack of any form of handling in TLB_FLUSH_GUEST=
 is
a reflection of two things: EPT is weird, and nested SVM doesn't yet suppor=
t
precise flushing on transitions, i.e. nested NPT handling is missing becaus=
e KVM
unconditionally flushes and synchronizes.

EPT is "weird" because the _only_ time guest-physical translations are flus=
hed
is when the "wrong" KVM MMU is loaded.  The only way to flush guest-physica=
l
translations (short of RESET :-D) is via INVEPT, and INVEPT is a root-only =
(VMX
terminology) instruction, i.e. can only be executed by L1.  And because L1 =
can't
itself be using EPT[*], INVEPT can never target/flush the current context.

Furthermore, INVEPT isn't strictly tied to a VMCS, e.g. deferring the emula=
ted
flush until the next time KVM runs a vmcs12 isn't viable.  Rather than add
dedicated tracking, KVM simply unloads the roots and lets the normal root
"allocation" handle the flush+sync the next time the vCPU uses the associat=
ed MMU.

Nested NPT is different, as there is no INVNPT.  Instead, there's the ASID =
itself
and a flushing control, both of which are properties of the VMCB.  As a res=
ult,
NPT TLB flushes that are initiated by a hypervisor always take effect at VM=
RUN,
e.g. by bumping the ASID, or via the dedicated flushing control.

So when proper handling of TLB flushing on nested SVM transition comes alon=
g, I
do expect that either kvm_vcpu_flush_tlb_guest() will grow.  Or maybe we'll=
 add
yet another TLB_FLUSH_XXX flavor :-)

One thing that could be helpful would be to document that KVM doesn't use
TLB_FLUSH_GUEST to handle INVEPT, and so there's no need to sync nested TDP=
 MMUs.

[*] Even in a deprivileged scenario like pKVM, the guest kernel would becom=
e L2
    from KVM's perspective.

