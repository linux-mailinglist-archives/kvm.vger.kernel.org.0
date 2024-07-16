Return-Path: <kvm+bounces-21741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34D36933474
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 01:08:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E779028495C
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 23:08:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2506143C70;
	Tue, 16 Jul 2024 23:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EBKIP0hE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A440D1422D1
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 23:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721171291; cv=none; b=j6Pp+yGqmXAPiz4jvwlnW8y8geW1GvSp09KBtqxEchWAf9Q7TgVl1D7TTF4JwDqQrfHpiLpx7k+ua4Eop8TR3S36dGWVcHSuzW3GO8nkbHocbSCNUpB3EN+2eOUiQraAX6icaxP2miM/8SxeZd/Kr/7og7tIexkp7GAESHiuTqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721171291; c=relaxed/simple;
	bh=rOoiuML7N6qLySS+ei9Dpf8UnpznrZNuBP9vY6eYx/A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nQeYhjQCsF51QO9ckJqEsa5OQ2usw0dmN8kQ49zLZ3PD26Ic6VVTuHFr8Y89ru70VfrDR5HjxJZqWtf1LOWK+eHTw3xwbv4A5Tf0puQCQ4u7X+7g/mwjjBaumbIcThZhkOnadMtVtFx4W0xbbChPib9yl3+38KAzCYWppZLE9SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EBKIP0hE; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70af548db1eso235673b3a.0
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 16:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721171289; x=1721776089; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vnpo2whe8OxkxqrwKjatwsuFtnr7PRgQtu5m92egNWc=;
        b=EBKIP0hEBasvq2evTJ3C8HeA9TM7ejyZrAvFMGnoJxO1y4ghACReB7gWhxhZCgLZzZ
         kjXhVT9bbKsBfx6ipqIhvRbiOfYYpnMjJYAq/MBju2vLYk/iLo0XkLB5wGuR5gjSiLCg
         ES3rB1tNpbhCLQfmHaPbV1rYyeBHvTlBenMMxLuDAo0LZbEdSmUM3xx0LJ78hPhPv/eo
         0bw+YbnwTLuJM78KIZFYxl6jtuK2D0MX2jTdwd0/764OQVUuHFFXs7i7UifPx4LdZOPO
         PKAwW30Ql79VX7Y2VlVtBr62+44EFrX/+dVgU8uWrYg5UkeZY57U3RPFK/HmUJkT6LNl
         tI4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721171289; x=1721776089;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vnpo2whe8OxkxqrwKjatwsuFtnr7PRgQtu5m92egNWc=;
        b=GcZ2Ss/KFQMn4JQIOKn9FPegS/FQUNPv0UpW+EqRKl7ERb+4TX1xq2v9DzoPiEWu86
         GLTJkgrSZdmM4rA4vtbiDSddFlQmVESBpB76xcWDiXHzodSNY00SBnTW6qLRY8nRsbm3
         p7RnDiNICmgM0S+VKIchtriHHR5x9djdplWL5GKje3XC1mdmHP+0UQH2rPa86uHXVxht
         vFKka/V6j9eoVjrvHtRNyuaa8JImcOXJ0Ysw+T/NlrLWag0pa9BF9cwjFkupBx9wKDUW
         mIbVgQP4uT4JcuXIBOl9HViUroWNN2OFY/ePLqBx1MRDZsd93K0nyHVX+Sr+zo+0fr4c
         EsJw==
X-Forwarded-Encrypted: i=1; AJvYcCXFX4KmCXlrsoXF3NgR/KEqfTeD8PqRJTqF9hx9XVAXQx+gs0KB6aGGNj1MeVfX4a2viDShWThMxJ5LDpCxsPLIjRb/
X-Gm-Message-State: AOJu0Yz8rxjYPomzhPwRXz/1dKXiro5Bw2p6A1UGdHq0mLw/FlTvsTFt
	XXJDaPJmQAd6JgV/O1D1AcxQsMlZUKV2mtlDavQU3z9WyCdFFnrPXIj7g5JTBOqnmAaZzNa75Gf
	NDg==
X-Google-Smtp-Source: AGHT+IHodyyfVvBZCeBo6zYHTnPh0oez+CNhQpAKC/JZhU9iwhP65w+2Cd3FMnyDUtKJfzU6NybR4fMYCt4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8b98:b0:70a:ef84:7682 with SMTP id
 d2e1a72fcca58-70cd8378e45mr18771b3a.1.1721171288672; Tue, 16 Jul 2024
 16:08:08 -0700 (PDT)
Date: Tue, 16 Jul 2024 16:08:07 -0700
In-Reply-To: <2b3e7111f6d7caffe6477a0a7da5edb5050079f7.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <fdddad066c88c6cd8f2090f11e32e54f7d5c6178.1721092739.git.isaku.yamahata@intel.com>
 <ZpbKqG_ZhCWxl-Fc@google.com> <2b3e7111f6d7caffe6477a0a7da5edb5050079f7.camel@intel.com>
Message-ID: <Zpb9Vwcmp4T-0ufJ@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Allow per VM kvm_mmu_max_gfn()
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 16, 2024, Rick P Edgecombe wrote:
> On Tue, 2024-07-16 at 12:31 -0700, Sean Christopherson wrote:
> >=20
> > No, it most definitely is not more correct.=C2=A0 There is absolutely n=
o issue
> > zapping
> > SPTEs that should never exist.=C2=A0 In fact, restricting the zapping p=
ath is far
> > more
> > likely to *cause* correctness issues, e.g. see=20
> >=20
> > =C2=A0 524a1e4e381f ("KVM: x86/mmu: Don't leak non-leaf SPTEs when zapp=
ing all
> > SPTEs")
> > =C2=A0 86931ff7207b ("KVM: x86/mmu: Do not create SPTEs for GFNs that e=
xceed
> > host.MAXPHYADDR")
>=20
> The type of correctness this was going for was around the new treatment o=
f GFNs
> not having the shared/alias bit. As you know it can get confusing which
> variables have these bits and which have them stripped. Part of the recen=
t MMU
> work involved making sure at least GFN's didn't contain the shared bit.

That's fine, and doesn't conflict with what I'm asserting, which is that it=
's
a-ok to process SPTEs a range of GFNs that, barring KVM bugs, should never =
have
"valid" entries.

> Then in TDP MMU where it iterates from start to end, for example:
> static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> 			      gfn_t start, gfn_t end, bool can_yield, bool
> flush)
> {
> 	struct tdp_iter iter;
>=20
> 	end =3D min(end, tdp_mmu_max_gfn_exclusive());
>=20
> 	lockdep_assert_held_write(&kvm->mmu_lock);
>=20
> 	rcu_read_lock();
>=20
> 	for_each_tdp_pte_min_level(iter, kvm, root, PG_LEVEL_4K, start, end) {
> 		if (can_yield &&
> 		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
> 			flush =3D false;
> 			continue;
> 		}
> ...
>=20
> The math gets a bit confused. For the private/mirror root, start will beg=
in at
> 0, and iterate to a range that includes the shared bit. No functional pro=
blem
> because we are zapping things that shouldn't be set. But it means the 'gf=
n' has
> the bit position of the shared bit set. Although it is not acting as the =
shared
> bit in this case, just an out of range bit.
>
> For the shared/direct root, it will iterate from (shared_bit | 0) to (sha=
red_bit
> | max_gfn). So where the mirror root iterates through the whole range, th=
e
> shared case skips it in the current code anyway.
>=20
> And then the fact that the code already takes care here to avoid zapping =
over
> ranges that exceed the max gfn.
>=20
> So it's a bit asymmetric, and just overall weird. We are weighing functio=
nal
> correctness risk with known code weirdness.

IMO, you're looking at it with too much of a TDX lens and not thinking abou=
t all
the people that don't care about TDX, which is the majority of KVM develope=
rs.

The unaliased GFN is definitely not the max GFN of all the VM's MMUs, since=
 the
shared EPT must be able to process GPAs with bits set above the "max" GFN. =
 And
to me, _that's_ far more weird than saying that "S-EPT MMUs never set the s=
hared
bit, and shared EPT MMUs never clear the shared bit".  I'm guessing the S-E=
PT
support ORs in the shared bit, but it's still a GFN.

If you were adding a per-MMU max GFN, then I'd buy that it legitimately is =
the max
GFN, but why not have a full GFN range for the MMU?  E.g.

  static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root=
,
			         bool shared, int zap_level)
  {
	struct tdp_iter iter;

	gfn_t end =3D tdp_mmu_max_gfn_exclusive(root);
	gfn_t start =3D tdp_mmu_min_gfn_inclusive(root);

and then have the helpers incorporated the S-EPT vs. EPT information.  That=
 gets
us optimized, precise zapping without needing to muddy the waters by tracki=
ng a
per-VM "max" GFN that is only kinda sorta the max if you close your eyes an=
d don't
think too hard about the shared MMU usage.

> My inclination was to try to reduce the places where TDX MMU needs paths
> happen to work for subtle reasons for the cost of the VM field.=20

But it doesn't happen to work for subtle reasons.  It works because it has =
to
work.  Processing !PRESENT SPTEs should always work, regardless of why KVM =
can
guarantee there are no SPTEs in a given GFN range.

