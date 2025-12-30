Return-Path: <kvm+bounces-66814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F2BCCE8AA2
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 05:03:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1F0F230124CA
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 04:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D10662D9EDC;
	Tue, 30 Dec 2025 04:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ibkNrMiP"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A732B9B7
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 04:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767067404; cv=none; b=XiaJ5NaEEHJfedv5QZh5wLwIJk1ODz1npZnpnnL5Y1QHrekoGR13An3oUq2ksC9CosCg98VRt8wj5T76CgO15XRvzeJ6GZSIEbXDH12/44Y7nwtKJiO8Dg40GDBlJQi80VmcjjqzfauDZ2DUOGYtD5w4Wsbg0UeyhLYUp1ROqXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767067404; c=relaxed/simple;
	bh=OZupLpzGa/jPKVQAuKFTnV94ODfqT9xVj6Iaa9WMbXc=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=EhJTkNPr5jOnDgEjLTb3O791prCaGllGuTvXGIOUwyUlJCsHnhf+yQnhXFLjfQgz/6ySHSMPYUpjzaoSEdx1C3Q5fMUdqmNRafDG9dE8PowbrD+zVR5hzEkTA8/EYmxZo33ssLuvpE9S06uudF8IIhOrsDK+NKeSdjTFRuINzvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ibkNrMiP; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767067400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=39oy40eJV/NuKgTYJpLKiidg67i03EGym/IW1kDlQL0=;
	b=ibkNrMiPxq4LQnH9qbZhdLdBQDadUZylX/X9kWvpZ0YwgSG7DvZBYwSNA271COOkUplAHZ
	M2hT0gzo/eF/M485Yemout5iKXmzoE3sPrAA8XjUu582Peujre0ppyCnSXiXqI9Bn31p2Y
	w4tt2yS7RZ6aazT96zOqHZ8SDkKOfM8=
Date: Tue, 30 Dec 2025 04:03:14 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yosry Ahmed" <yosry.ahmed@linux.dev>
Message-ID: <e0ce2edb275d2f249beb8ab908f0bad55f8b9037@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v3 10/16] KVM: selftests: Reuse virt mapping functions
 for nested EPTs
To: "Sean Christopherson" <seanjc@google.com>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
In-Reply-To: <aVMX9a2gVxToXjlL@google.com>
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
 <20251127013440.3324671-11-yosry.ahmed@linux.dev>
 <aUshyQad7LjdhYAY@google.com>
 <2sw7xjtjh4ianp2dz7p24cht2v6u55wcdac4xlrxn5vjgqti77@4ohtwtywinmi>
 <aVMX9a2gVxToXjlL@google.com>
X-Migadu-Flow: FLOW_OUT

December 29, 2025 at 4:08 PM, "Sean Christopherson" <seanjc@google.com ma=
ilto:seanjc@google.com?to=3D%22Sean%20Christopherson%22%20%3Cseanjc%40goo=
gle.com%3E > wrote:


>=20
>=20On Tue, Dec 23, 2025, Yosry Ahmed wrote:
>=20
>=20>=20
>=20> On Tue, Dec 23, 2025 at 03:12:09PM -0800, Sean Christopherson wrote=
:
> >  On Thu, Nov 27, 2025, Yosry Ahmed wrote:
> >  > diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b=
/tools/testing/selftests/kvm/include/x86/processor.h
> >  > index fb2b2e53d453..62e10b296719 100644
> >  > --- a/tools/testing/selftests/kvm/include/x86/processor.h
> >  > +++ b/tools/testing/selftests/kvm/include/x86/processor.h
> >  > @@ -1447,6 +1447,7 @@ struct pte_masks {
> >  > uint64_t dirty;
> >  > uint64_t huge;
> >  > uint64_t nx;
> >  > + uint64_t x;
> >=20=20
>=20>  To be consistent with e.g. writable, call this executable.
> >=20=20
>=20>  Was trying to be consistent with 'nx' :)=20
>=20>=20=20
>=20>=20=20
>=20>  > uint64_t c;
> >  > uint64_t s;
> >  > };
> >  > @@ -1464,6 +1465,7 @@ struct kvm_mmu {
> >  > #define PTE_DIRTY_MASK(mmu) ((mmu)->pte_masks.dirty)
> >  > #define PTE_HUGE_MASK(mmu) ((mmu)->pte_masks.huge)
> >  > #define PTE_NX_MASK(mmu) ((mmu)->pte_masks.nx)
> >  > +#define PTE_X_MASK(mmu) ((mmu)->pte_masks.x)
> >  > #define PTE_C_MASK(mmu) ((mmu)->pte_masks.c)
> >  > #define PTE_S_MASK(mmu) ((mmu)->pte_masks.s)
> >  >=20
>=20>  > @@ -1474,6 +1476,7 @@ struct kvm_mmu {
> >  > #define pte_dirty(mmu, pte) (!!(*(pte) & PTE_DIRTY_MASK(mmu)))
> >  > #define pte_huge(mmu, pte) (!!(*(pte) & PTE_HUGE_MASK(mmu)))
> >  > #define pte_nx(mmu, pte) (!!(*(pte) & PTE_NX_MASK(mmu)))
> >  > +#define pte_x(mmu, pte) (!!(*(pte) & PTE_X_MASK(mmu)))
> >=20=20
>=20>  And then here to not assume PRESENT =3D=3D READABLE, just check if=
 the MMU even has
> >  a PRESENT bit. We may still need changes, e.g. the page table builde=
rs actually
> >  need to verify a PTE is _writable_, not just present, but that's lar=
gely an
> >  orthogonal issue.
> >=20=20
>=20>  Not sure what you mean? How is the PTE being writable relevant to
> >  assuming PRESENT =3D=3D READABLE?
> >=20
>=20Only tangentially, I was try to say that if we ever get to a point wh=
ere selftests
> support read-only mappings, then the below check won't suffice because =
walking
> page tables would get false positives on whether or not an entry is usa=
ble, e.g.
> if a test wants to create a writable mapping and ends up re-using a rea=
d-only
> mapping.
>=20
>=20The PRESENT =3D=3D READABLE thing is much more about execute-only map=
pings (which
> selftests also don't support, but as you allude to below, don't require=
 new
> hardware functionality).

Oh okay, thanks for clarifying. Yeah that makes sense, if/when read-only =
mappings are ever supported the page table builders will need to be updat=
ed accordingly.

Although now that you point this out, I think it would be easy to miss. I=
f new helpers are introduced that just modify existing page tables to rem=
ove the write bit, then we'll probably miss updating the page table build=
ers to check for writable mappings. Then again, we'll probably only updat=
e the leaf PTEs to be read-only, and the page table builders already do n=
ot re-use leaf entries.

We could be paranoid and add some TEST_ASSERT() calls to guard against th=
at (e.g. in virt_create_upper_pte()), but probably not worth it.

>=20
>=20>=20
>=20> #define is_present_pte(mmu, pte) \
> >  (PTE_PRESENT_MASK(mmu) ? \
> >  !!(*(pte) & PTE_PRESENT_MASK(mmu)) : \
> >  !!(*(pte) & (PTE_READABLE_MASK(mmu) | PTE_EXECUTABLE_MASK(mmu))))
> >=20=20
>=20>  and then Intel will introduce VMX_EPT_WRITE_ONLY_BIT :P
> >
>

