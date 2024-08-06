Return-Path: <kvm+bounces-23374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F93894928F
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 16:04:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F52C1C214E2
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 14:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 298AF17ADEE;
	Tue,  6 Aug 2024 14:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JDzTsCTa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70D416B741
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 14:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722952998; cv=none; b=PVhtkrx6u5VaSzn18NXcG4RdNYFcdWK4QvIU0qjkK1EN+QjA1W0mYqREPY1auWSVbhMBnBtvoCXpnDsqv0T5HCWIoNZVanoTx1iENg7Zzz3p8sYto6EQA0vcKqEkXhbw2VKBXBOHL7VzWPAWCRmlngnQoKCUes3ehLTISApfJ9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722952998; c=relaxed/simple;
	bh=p9ZVmTdp+MSHPZCDiYNhr72+FrIxO5hIK6X0gOSKUBw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mAv1P77XEh5pj60FOEq/L/Z/bO1A4MmBDcrvPJ1ZELxex8K6IaIcqtmZfMo5ABvuwrQ1fHZNtSbw7uj2uzBQLkEzLQuGNJUk6WNLlFh5RL2PhF6haVpVqY/3dRDVSp93TbdNx7R8zVN3Vzk6A1LbGiMjR0uSqj9cMB3Na00DJIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JDzTsCTa; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e03623b24ddso998554276.1
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 07:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722952996; x=1723557796; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uqGT2mTXRSzZVlXU0nXvRQaIKYNQT+/mO2u06f0vChA=;
        b=JDzTsCTapuq6R60wlzcPS5LVQ50+8zyNc+Y/A0rQlgY8AYEirfrcZqJQjFGMG5ITXm
         oJXq+3adOlh0wEur39vdzVG5FFHAkrpjaEDvkAv2PO3xwVy4xNHfMXzLVyb/5r+UmPGP
         jK2xajxBQECE8QPWTvTN2tzml+3qtZ8FOCM1lFt7dGaS2/fu+nIYeiDXn5sPTKM7N/mD
         3z+EzMhc+CyEP8krdl24J1anMSNX6DY3bCIKrQBCmBLgIIgaOh78XyHSe5o3e2un+LaP
         7bKbAzaWU1xz6Xg+eZU1BbkBhvaFWoq8YREpSgwU6dhgj+8qyX7RF8+VbXakkGDFSuGx
         a8pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722952996; x=1723557796;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uqGT2mTXRSzZVlXU0nXvRQaIKYNQT+/mO2u06f0vChA=;
        b=MZFZBKUoxbR83hruhHHCLdO1LCme9pOvrbOcOo3YehmoHKLNhEkRn5RP1pn3MC5eaF
         o4VQEvlIQqWMTQtY32/a1gaMKq5lys5JeSda3HLcj5lR0jXVYu7KmB7hBhMs1Lo+jK3B
         yl0o/flZD4ztcvunZDQKswFhf1GNmYKvTa/uq7ReXCF1QpDDMgpMQjFW6+YXPhINPbsK
         osjqZN0FQkbSRulRP4CFP1UfvOySqoAcARmtdw9yRgwmayWzdmBVuZbZMoHfKvlEDFxS
         GZoQxai3/gZMoVu2nzSZUpQJWrTMI1yFgeU011mZnv6dmb9B2fxwW5kSl8WvNT0aYEX6
         dOaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUiFprP7ahy9iPkM3k21JtuD6IQn3XAhV4qcgLIEPnPKDXcDSiDqQmfcfLafRr48ieZZMaNsHLvp3unV/0DUR8pxbLe
X-Gm-Message-State: AOJu0YywgUKColMnAUxk8wBismPWk+cUrWdzdM60yE69M8kncBapA/iq
	Cvmz1iXjx8aR7eGk2uAGDJsxfE0d96uZIqem15Tobw4L8ApvWcuAn9nCT49gX2xFKJEkwDsCBDc
	org==
X-Google-Smtp-Source: AGHT+IHr0cjXP2WYBxQNM2DFAMasCde6kX0ZJgK/KZ2REvTSlG5RrUyWL0rGH3moNZ4O8mUg1dBZlOQRgtI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:150a:b0:e0b:edb:143c with SMTP id
 3f1490d57ef6-e0bdde81b6cmr199586276.0.1722952995798; Tue, 06 Aug 2024
 07:03:15 -0700 (PDT)
Date: Tue, 6 Aug 2024 07:03:09 -0700
In-Reply-To: <dd6ca54cfd23dba0d3cba7c1ceefea1fdfcdecbe.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20220427014004.1992589-1-seanjc@google.com> <20220427014004.1992589-7-seanjc@google.com>
 <294c8c437c2e48b318b8c27eb7467430dfcba92b.camel@infradead.org>
 <f862cefff2ed3f4211b69d785670f41667703cf3.camel@infradead.org>
 <ZrFyM8rJZYjfFawx@google.com> <dd6ca54cfd23dba0d3cba7c1ceefea1fdfcdecbe.camel@infradead.org>
Message-ID: <ZrItHce2GqAWoN0o@google.com>
Subject: Re: [PATCH] KVM: Move gfn_to_pfn_cache invalidation to
 invalidate_range_end hook
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Mushahid Hussain <hmushi@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 06, 2024, David Woodhouse wrote:
> On Mon, 2024-08-05 at 17:45 -0700, Sean Christopherson wrote:
> > On Mon, Aug 05, 2024, David Woodhouse wrote:
> > > From: David Woodhouse <dwmw@amazon.co.uk>
> > Servicing guest pages faults has the same problem, which is why
> > mmu_invalidate_retry_gfn() was added.=C2=A0 Supporting hva-only GPCs ma=
de our lives a
> > little harder, but not horrifically so (there are ordering differences =
regardless).
> >=20
> > Woefully incomplete, but I think this is the gist of what you want:
>=20
> Hm, maybe. It does mean that migration occurring all through memory
> (indeed, just one at top and bottom of guest memory space) would
> perturb GPCs which remain present.

If that happens with a real world VMM, and it's not a blatant VMM goof, the=
n we
can fix KVM.  The stage-2 page fault path hammers the mmu_notifier retry lo=
gic
far more than GPCs, so if a range-based check is inadequate for some use ca=
se,
then we definitely need to fix both.

In short, I don't see any reason to invent something different for GPCs.

> > > @@ -849,6 +837,8 @@ static void kvm_mmu_notifier_invalidate_range_end=
(struct mmu_notifier *mn,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0wake =3D !kvm->mn_act=
ive_invalidate_count;
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_unlock(&kvm->mn_=
invalidate_lock);
> > > =C2=A0
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0gfn_to_pfn_cache_invalidat=
e(kvm, range->start, range->end);
> >=20
> > We can't do this.=C2=A0 The contract with mmu_notifiers is that seconda=
ry MMUs must
> > unmap the hva before returning from invalidate_range_start(), and must =
not create
> > new mappings until invalidate_range_end().
>=20
> But in the context of the GPC, it is only "mapped" when the ->valid bit i=
s set.=20
>=20
> Even the invalidation callback just clears the valid bit, and that
> means nobody is allowed to dereference the ->khva any more. It doesn't
> matter that the underlying (stale) PFN is still kmapped.
>=20
> Can we not apply the same logic to the hva_to_pfn_retry() loop? Yes, it
> might kmap a page that gets removed, but it's not actually created a
> new mapping if it hasn't set the ->valid bit.
>=20
> I don't think this version quite meets the constraints, and I might
> need to hook *both* the start and end notifiers, and might not like it
> once I get there. But I'll have a go...

I'm pretty sure you're going to need the range-based retry logic.  KVM can'=
t
safely set gpc->valid until mn_active_invalidate_count reaches zero, so if =
a GPC
refresh comes along after mn_active_invalidate_count has been elevated, it =
won't
be able to set gpc->valid until the MADV_DONTNEED storm goes away.  Without
range-based tracking, there's no way to know if a previous invalidation was
relevant to the GPC.

