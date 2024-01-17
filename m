Return-Path: <kvm+bounces-6398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EF02830AAA
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 17:13:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B701B1F29CC9
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 16:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA0EA224C8;
	Wed, 17 Jan 2024 16:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0c8FIGCH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F797219F6
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 16:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705507788; cv=none; b=Ynna1yztDXO0EiB5jIOGpYCRBCBKIR1hN61DPW1ziDmhOWnzvfoR/8dMEQ5ck5QPhrzhtgqdRWF9ezUCY26C0AhHeMcCtyE1OZ4GVFYPikhl8JYHI5Gcd9iUuIOclMrxzKbfLTbBIcR2iF3Dsq/JJyWyjVUpbWyK+WFN+ycuCMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705507788; c=relaxed/simple;
	bh=iZ8aNowrMIZ0+mioT+MD7L+Kmihe5cjQNpPjxhCMoD4=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Date:
	 In-Reply-To:Mime-Version:References:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding; b=VaokKvQ7qYHEikx71oq4ZtUCU1xp4cgygwFm+avW/F+KmVeWV46y3YPoNXuuonnwTwAGpxRJK2w7lrzILPdDJfzBm1UK+NR7Mx3IdhkI1DtS80vTEUmho6zkBogswFzIvncFudrVONuulZqht5YDYRldKIM/DLI2S/pFzdNH6OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0c8FIGCH; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-28b3b3633f2so6819372a91.0
        for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 08:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705507786; x=1706112586; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JweR8yqT68aUtme2ZhS1aRwVfHUDyDbTDcBh9dWH83E=;
        b=0c8FIGCHeHPsOP929pV0lXJGd7i1fNHOw16cZHdaFCXs4nMurG7KnFpx74upiSp8Tk
         IpyIZJ6AU3adADLPoWVHzS/LoK0pDs+bVoHAm+rkIy3QteGyx92UzXCk8v8zJRdzw8un
         91045xSZdCY8bKzJDLSUKnGk1zILOu9EhUyLuMobEOhYEdYitKcjF3/087gg+FO8NDsz
         sR5G+RxqLI/F/TV1M0/VJnYmYUHwWb6XCy2JTLQy3JpY9IhDwJaoIHMi/Sd8TieihjXE
         KiQ/URWYbAlFPQ74et/yG4uFkGODAuT9OmiQBnDEuXZSGhDyxw2pqGf17djRb2W7P7cC
         th9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705507786; x=1706112586;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JweR8yqT68aUtme2ZhS1aRwVfHUDyDbTDcBh9dWH83E=;
        b=IfVELLmA4zYFXkfZdGsCxoPUJosUDZrf47YwcCCLnfrZXceE9zyEd71AxrdTXfdxlz
         eGxp6TH4q3ZOZEAXVUyWv21sTs2hqjYKBNuKNUw37BtoaZ9cVTqdiIzjoU+Q0hGQk8Ck
         zOJ4NcNp2adLE8cjCbauHPI7Gw2enJWrJMQ0KhOvjHAgKv2sluyPuI25ryxA1hrfG+Sg
         dldDX016G4BUaYBlhnVPln/AhfvH87gNWV8PKMD+QPnz/MsBbio9/tY3S/RYf1IZcbTf
         O00eHQ6RLiraNzoioSFxE/AVS+qan6oE2qAiE+3qoJ8GTLdJzGH341JUag5fTgDYaTq8
         hoDg==
X-Gm-Message-State: AOJu0Yy9srkfKQG0od9qmtd6NUFFVrY86Hv90VZjTUfGBavD9iu9jCBt
	g55ncvclugTPTRQRWSsl22jHIX24LzmlzVOblw==
X-Google-Smtp-Source: AGHT+IFq02IYTTcuHjpornNwGXnfHE9oTTiB9D1zPBhCesM+SZS1Uo4R3ObnxxixfsEV3iKxN3wGpK/y8SA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:5105:b0:28b:f540:7262 with SMTP id
 sc5-20020a17090b510500b0028bf5407262mr614356pjb.9.1705507785918; Wed, 17 Jan
 2024 08:09:45 -0800 (PST)
Date: Wed, 17 Jan 2024 08:09:44 -0800
In-Reply-To: <9a82db197449bdb97ee889d2f3cdd7998abd9692.camel@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <9a82db197449bdb97ee889d2f3cdd7998abd9692.camel@amazon.co.uk>
Message-ID: <Zaf7yCYt8XFuMhAd@google.com>
Subject: Re: [PATCH] KVM: pfncache: rework __kvm_gpc_refresh() to fix locking issues
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw@amazon.co.uk>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Paul Durrant <pdurrant@amazon.co.uk>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 12, 2024, David Woodhouse wrote:
> This function can race with kvm_gpc_deactivate(). Since that function
> does not take the ->refresh_lock, it can wipe and unmap the pfn and
> khva while hva_to_pfn_retry() has dropped its write lock on gpc->lock.
>=20
> Then if hva_to_pfn_retry() determines that the PFN hasn't changed and
> that it can re-use the old pfn and khva, they get assigned back to
> gpc->pfn and gpc->khva even though the khva was already unmapped by
> kvm_gpc_deactivate(). This leaves the cache in an apparently valid
> state but with ->khva pointing to an address which has been unmapped.
> Which in turn leads to oopses in e.g. __kvm_xen_has_interrupt() and
> set_shinfo_evtchn_pending().
>=20
> It may be possible to fix this just by making kvm_gpc_deactivate()
> take the ->refresh_lock, but that still leaves ->refresh_lock being
> basically redundant with the write lock on ->lock, which frankly
> makes my skin itch, with the way that pfn_to_hva_retry() operates on
> fields in the gpc without holding ->lock.
>=20
> Instead, fix it by cleaning up the semantis of hva_to_pfn_retry(). It
> no longer operates on the gpc object at all; it's called with a uhva
> and returns the corresponding pfn (pinned), and a mapped khva for it.
>=20
> The calling function __kvm_gpc_refresh() now drops ->lock before calling
> hva_to_pfn_retry(), then retakes the lock before checking for changes,
> and discards the new mapping if it lost a race. And will correctly
> note the old pfn/khva to be unmapped at the right time, instead of
> preserving them in a local variable while dropping the lock.
>=20
> The optimisation in hva_to_pfn_retry() where it attempts to use the
> old mapping if the pfn doesn't change is dropped, since it makes the
> pinning more complex. It's a pointless optimisation anyway, since the
> odds of the pfn ending up the same when the uhva has changed (i.e.
> the odds of the two userspace addresses both pointing to the same
> underlying physical page) are negligible,
>=20
> I remain slightly confused because although this is clearly a race in
> the gfn_to_pfn_cache code, I don't quite know how the Xen support code
> actually managed to trigger it. We've seen oopses from dereferencing a
> valid-looking ->khva in both __kvm_xen_has_interrupt() (the vcpu_info)
> and in set_shinfo_evtchn_pending() (the shared_info). But surely the
> race shouldn't happen for the vcpu_info gpc because all calls to both
> refresh and deactivate hold the vcpu mutex, and it shouldn't happen

FWIW, neither kvm_xen_destroy_vcpu() nor kvm_xen_destroy_vm() holds the app=
ropriate
mutex. =20

> for the shared_info gpc because all calls to both will hold the
> kvm->arch.xen.xen_lock mutex.
>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>=20
> This is based on (and in) my tree at
> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/xenfv
> which has all the other outstanding KVM/Xen fixes.
>=20
> =C2=A0virt/kvm/pfncache.c | 181 +++++++++++++++++++++--------------------=
---
> =C2=A01 file changed, 85 insertions(+), 96 deletions(-)

NAK, at least as a bug fix.  We've already shuffled deck chairs on the Tita=
nic
several times, I have zero confidence that doing so one more time is going =
to
truly solve the underlying mess.

The contract with the gfn_to_pfn_cache, or rather the lack thereof, is all =
kinds
of screwed up.  E.g. I added the mutex in commit 93984f19e7bc ("KVM: Fully =
serialize
gfn=3D>pfn cache refresh via mutex") to guard against concurrent unmap(), b=
ut the
unmap() API has since been removed.  We need to define an actual contract i=
nstead
of continuing to throw noodles as the wall in the hope that something stick=
s.

As you note above, some other mutex _should_ be held.  I think we should le=
an
into that.  E.g.

  1. Pass in the guarding mutex to kvm_gpc_init() and assert that said mute=
x is
     held for __refresh(), activate(), and deactivate().
  2. Fix the cases where that doesn't hold true.
  3. Drop refresh_mutex

