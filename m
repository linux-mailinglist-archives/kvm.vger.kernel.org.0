Return-Path: <kvm+bounces-56865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A9CB4513E
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 10:23:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21C003B996F
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 08:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B863002C4;
	Fri,  5 Sep 2025 08:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CrAvtl8D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE0B285C91
	for <kvm@vger.kernel.org>; Fri,  5 Sep 2025 08:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757060608; cv=none; b=tejPNEzYXZPAJAY4HuP5tTknptMhHGGc514FI5wn0x0no+5vDQkXcmOXWPE0uUaZKq3O/6YBqS77s6+2De313oydFK2O7bd+7E3AnYQfbS1/Y4ua7Fa2K7RPD9+w+53n0XwjBCuXkSXw/0xaAiGBpI1P3cKcuQ3w+5kfV8IgNvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757060608; c=relaxed/simple;
	bh=APGqKF3GyU/I3fMyI+XPtYWiVqEWpTDET7JPhtTGQV8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Wgm5fMxqdgGQrw1guoHoa1ZTcOeSE6ydzn2Fd10KgyYLRtkOmvVUkFNoanwR0kfFEcHum2zu3HUkuEHwx0JrsG2ai6hro1ntyldLmHt1i4E+m7Ge1WRkUPfR3Cf8vRoDjygILm+GvwTy2Eb+49ycSAoeC7xiEOluoQqIteWwXR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CrAvtl8D; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7724688833bso2074301b3a.2
        for <kvm@vger.kernel.org>; Fri, 05 Sep 2025 01:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757060606; x=1757665406; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XJnhSI4zKDT3ImFhZhJBvG+6tvoITddVraqHrrqOWpc=;
        b=CrAvtl8Dvy16B69I1/8/nF3mRCSVXYcExVPjCMsr7bJSbsnblfIuWfKGs+LcJDYVj/
         kjINdr+Hyeq5iiulmbNdIDZwcbuq0oQ6/a+EOoPMKoHT6Emj+kDMou4fRBPqjZYzbqiJ
         IOrKggTDOxPtQlf8WS0gzBFSDfh9Y4Kl2v0RYEC1betj2EhhP0esTUDFj7EiltYfmqp8
         tvhAMPhMuSiJY7lD5tpON1/5qcfx01KDytZVRHhgxvifgD1c9O8y0g2EXyqqtTKhhHKI
         zlmL5Ek7FY8i6hx6qGndsrAFRcjDOeOCyjih3ZZzQG2ttL0qo7HxScZgmi+50OeqKwDi
         h5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757060606; x=1757665406;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XJnhSI4zKDT3ImFhZhJBvG+6tvoITddVraqHrrqOWpc=;
        b=e390P91eFIUVL/lU8Y5rKDxbaEm9kKqZrkZ7Q1oIgHYTEzh1rdvyo0GTI293ksIhNk
         KoDuaPgQBQ/hdZT1cpF04EH1eZcDm544BIFriE6KmGYtjyClWwjssG7hKlS8eqzHnV9G
         TsBSzeoi91o0tdnhlVBw25i4lKabWKA29GUSsC8QQ/P41uXdixsSwCwo0/X+TsMKvBpb
         AShrG9Bo5jZl+tJom4B2FI0AFIYINU8EiFq0mYNlIRKJIugQLcWcE2gTppNkcRWOYWoN
         QFwbGchY0KFQaSyUaoczsQrWotGtmX4zUaNwAe/VGtN1sdbgNRXTZP+5kL2X2wmCUx7c
         dqfA==
X-Forwarded-Encrypted: i=1; AJvYcCUc6rbyAwTkrZoa2hznL2UVfPXeRGBTMY+aSXBIH/9UyyjsOrcBZO7MXFryy30PB/0pZ7A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPvUR20IV3BU9W997uk7lERxtfcTXzBhSvi+9POOo7vbG3AjHi
	lPqrxuJXV4uiguNAsJ9ZheagydRfShw9+8BM+FWYXDm+YB9Cw5GKqTZzhj7k1OdMs3N7NVXjyXw
	pLb6JoQ==
X-Google-Smtp-Source: AGHT+IF349552GT13Po4cUSXoxXNT8kDuTD1Q1OQDc9T2EDq42EP/PDKUPEXnt4B6nyuOStBDkTUDu8oxLg=
X-Received: from pfgu35.prod.google.com ([2002:a05:6a00:9a3:b0:772:8559:f89f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:734d:b0:24b:c7d9:88e4
 with SMTP id adf61e73a8af0-24bc7d99007mr7502786637.42.1757060606101; Fri, 05
 Sep 2025 01:23:26 -0700 (PDT)
Date: Fri, 5 Sep 2025 01:23:17 -0700
In-Reply-To: <CAHBxVyHFkNtFdX-vciPvYnTOH=GXvHVW7hjFrLA4MFr9wqWVvQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829-pmu_event_info-v5-0-9dca26139a33@rivosinc.com>
 <20250829-pmu_event_info-v5-6-9dca26139a33@rivosinc.com> <aLIR3deQPxVI2VrE@google.com>
 <CAHBxVyHFkNtFdX-vciPvYnTOH=GXvHVW7hjFrLA4MFr9wqWVvQ@mail.gmail.com>
Message-ID: <aLqd9bKB6ucarR3e@google.com>
Subject: Re: [PATCH v5 6/9] KVM: Add a helper function to check if a gpa is in
 writable memselot
From: Sean Christopherson <seanjc@google.com>
To: Atish Kumar Patra <atishp@rivosinc.com>
Cc: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 03, 2025, Atish Kumar Patra wrote:
> On Fri, Aug 29, 2025 at 1:47=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Fri, Aug 29, 2025, Atish Patra wrote:
> > > +static inline bool kvm_is_gpa_in_writable_memslot(struct kvm *kvm, g=
pa_t gpa)
> > > +{
> > > +     bool writable;
> > > +     unsigned long hva =3D gfn_to_hva_prot(kvm, gpa_to_gfn(gpa), &wr=
itable);
> > > +
> > > +     return !kvm_is_error_hva(hva) && writable;
> >
> > I don't hate this API, but I don't love it either.  Because knowing tha=
t the
> > _memslot_ is writable doesn't mean all that much.  E.g. in this usage:
> >
> >         hva =3D kvm_vcpu_gfn_to_hva_prot(vcpu, shmem >> PAGE_SHIFT, &wr=
itable);
> >         if (kvm_is_error_hva(hva) || !writable)
> >                 return SBI_ERR_INVALID_ADDRESS;
> >
> >         ret =3D kvm_vcpu_write_guest(vcpu, shmem, &zero_sta, sizeof(zer=
o_sta));
> >         if (ret)
> >                 return SBI_ERR_FAILURE;
> >
> > the error code returned to the guest will be different if the memslot i=
s read-only
> > versus if the VMA is read-only (or not even mapped!).  Unless every rea=
d-only
> > memslot is explicitly communicated as such to the guest, I don't see ho=
w the guest
> > can *know* that a memslot is read-only, so returning INVALID_ADDRESS in=
 that case
> > but not when the underlying VMA isn't writable seems odd.
> >
> > It's also entirely possible the memslot could be replaced with a read-o=
nly memslot
> > after the check, or vice versa, i.e. become writable after being reject=
ed.  Is it
> > *really* a problem to return FAILURE if the guest attempts to setup ste=
al-time in
> > a read-only memslot?  I.e. why not do this and call it good?
> >
>=20
> Reposting the response as gmail converted my previous response as
> html. Sorry for the spam.
>=20
> From a functionality pov, that should be fine. However, we have
> explicit error conditions for read only memory defined in the SBI STA
> specification[1].
> Technically, we will violate the spec if we return FAILURE instead of
> INVALID_ADDRESS for read only memslot.

But KVM is already violating the spec, as kvm_vcpu_write_guest() redoes the
memslot lookup and so could encounter a read-only memslot (if it races with
a memslot update), and because the underlying memory could be read-only eve=
n if
the memslot is writable.

Why not simply return SBI_ERR_INVALID_ADDRESS on kvm_vcpu_write_guest() fai=
lure?
The only downside of that is KVM will also return SBI_ERR_INVALID_ADDRESS i=
f the
userspace mapping is completely missing, but AFAICT that doesn't seem to be=
 an
outright spec violation.

