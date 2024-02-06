Return-Path: <kvm+bounces-8066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F76A84AC6B
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 03:54:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA1E22879BB
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 02:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59D3A6A005;
	Tue,  6 Feb 2024 02:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V+de5hb8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D124F6E2B0
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 02:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707188057; cv=none; b=aKOBHreXTsSGm3sBP/0IWvcRsgPMLGOSc3DCu3t6XqW9Xe0qVPqVjyuww4UeYoYpqEceKRBeYoCSIEBOZsugMPG4dwDcPPZ9hp18ElYK0bgSLhpK48Tg0Z9G7+2WU7UhINoEEfGmzdSi5MW+Vz+rMtatBZOnd+BQXkj6fuFUWlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707188057; c=relaxed/simple;
	bh=D2q0b2o4Z7APki3fn4YvD4ddqaMhZR/spymtio8X6wQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pf/lYscPJPFj6GVAcOvq0VDjt8rMIIhSK2XzjSZos9ToAPmW7XCMHJHWsBQ7Sdo8yTdTflRisB7/lvYCsYbNnFvwOMaTXwez1mto8Bb+6w2yoQsuVoGVHOa2woU6TedckG29d0hhiTHKgc63eTKyHcrGyAV+SHA2m02Pa4w91dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V+de5hb8; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e0382c0447so2245467b3a.3
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 18:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707188055; x=1707792855; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BxnDC9PEjh2Qaq1re7GgqS1U0z2T5fJxN7gaOqoJ4CQ=;
        b=V+de5hb8w9zg3BeTfo6MPug76mBSF87FYPJuG724dxM+l8xeJsdlKj9cd+ZrM5uDUo
         AX/60wQmlMhOrqnoWVL4fz24A6jFZtcWiVGeaamsTBCUzXvxogYWPKu7/73Aq4p3D3wD
         9B1u9ixiAwhDcRGUQXsDMaJCOVhCAqXs3k5JkL8P5Hl2v/oV/w59Z1lT5h2JLs7+Eps1
         aYMZqK9tOoUT7BMN42YYvoQMnva+neKuigGVyrJ71iTZlHxdoSu6vP5zyqqMwDv8xkKT
         8v7oYXoPBk7wBJqNftHVuHHuYvx/Ni/AIBHw6SNynThKhp/XUAmZrBFpQOR+EbcKtW6R
         RweQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707188055; x=1707792855;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BxnDC9PEjh2Qaq1re7GgqS1U0z2T5fJxN7gaOqoJ4CQ=;
        b=Uq97Pxw3Yepov/bkpKozNf/OaiQXFi3odjij62mMOpnpoL2lpk1pMlTJ4MTTD7/hTS
         uKDZCKN1OZexlyoW3/xatREsiowpyIl2mLzL/d75ebdOTHmQAWbml+dC7wd4nflbXOBU
         7yqraL2b0dcvpV0Ob0qmivhNr8q5B/lIwuCHhHU0iXmBfrRiUftqQ79FZE009/GGVQHr
         4hSnfF74jiyX2BmsIVzJgEb2dRd1/u0qmoqhUCYsWl6x+flpBJQwuEMbp5xGRcKko0nl
         nAu2+Tgm2ncxfD65rlo2w/zLRW++TbtfIinlMIYhg2EEnM4E3IzYOXdG0U5VDxRFwuoW
         PHow==
X-Gm-Message-State: AOJu0Yzt2Gc1IQgtVkoSWvJ2I2Y3qZeMxZi0H4tKDbqAVl+MfoxFWs/l
	rIO93PfuCHcf9nVEBosEhtzHuTn/xalJoiXLQqSLKbr2RNIeMgU3P7h0pTS9jXQAKpdSB1Y++aZ
	rKQ==
X-Google-Smtp-Source: AGHT+IHSYeFR6s+Vr1FAbsEgBRv1jPSIvn/jfhYNPnvMF5ySJNTuzlbNCgmGA/LEAVQ2w75wt3mkYNdAwJc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:93a6:b0:6df:e45b:3ef8 with SMTP id
 ka38-20020a056a0093a600b006dfe45b3ef8mr93164pfb.3.1707188055193; Mon, 05 Feb
 2024 18:54:15 -0800 (PST)
Date: Mon, 5 Feb 2024 18:54:13 -0800
In-Reply-To: <91b97ed81a70c778352b2f569001820ea8b1c48b.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <20230911021637.1941096-4-stevensd@google.com>
 <91b97ed81a70c778352b2f569001820ea8b1c48b.camel@redhat.com>
Message-ID: <ZcGfVRhp2WmCsyhi@google.com>
Subject: Re: [PATCH v9 3/6] KVM: mmu: Improve handling of non-refcounted pfns
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: David Stevens <stevensd@chromium.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 03, 2023, Maxim Levitsky wrote:
> =D0=A3 =D0=BF=D0=BD, 2023-09-11 =D1=83 11:16 +0900, David Stevens =D0=BF=
=D0=B8=D1=88=D0=B5:
> > From: David Stevens <stevensd@chromium.org>
> > The fact that non-refcounted pfns can no longer be accessed without mmu
> > notifier protection is a breaking change. Since there is no timeline fo=
r
> > updating everything in KVM to use mmu notifiers, this change adds an
> > opt-in module parameter called allow_unsafe_mappings to allow such
> > mappings. Systems which trust userspace not to tear down such unsafe
> > mappings while KVM is using them can set this parameter to re-enable th=
e
> > legacy behavior.
>=20
> Do you have a practical example of a VM that can break with this change?
> E.g will a normal VM break? will a VM with VFIO devices break? Will a VM =
with
> hugepages mapped into it break?
>=20
> Will the trick of limiting the kernel memory with 'mem=3DX', and then use=
 the=20
> extra 'upper memory' for VMs still work?

This is the trick that will require an opt-in from the admin.  Anything whe=
re KVM
is effectively relying on userspace to pinky swear that the memory won't be
migrated, freed, etc.

It's unlikely, but theoretically possible that it might break existing setu=
ps for
"normal" VMs.  E.g. if a VM is using VM_PFNMAP'd memory for a nested VMCS. =
 But
such setups are already wildly broken, their users just don't know it.  The=
 proposal
here is to require admins for such setups to opt-in to the "unsafe" behavio=
r,
i.e. give backwards compatibility, but make the admin explicitly acknowledg=
e that
what they are doing may have unwanted consequences.

> > +	/*
> > +	 * True if the returned pfn is for a page with a valid refcount. Fals=
e
> > +	 * if the returned pfn has no struct page or if the struct page is no=
t
> > +	 * being refcounted (e.g. tail pages of non-compound higher order
> > +	 * allocations from IO/PFNMAP mappings).
> >=20
> Aren't all tail pages not-refcounted (e.g tail page of a hugepage?)
> I haven't researched this topic yet.

Nope.  As Christoph stated, they are most definitely "weird" allocations th=
ough.
In this case, IIRC, it's the DRM's Translation Table Manager (TTM) code tha=
t
kmalloc's a large chunk of memory, and then stuffs the pfn into the page ta=
bles
courtesy of the vmf_insert_pfn_prot() in ttm_bo_vm_fault_reserved().

The head page has a non-zero refcount, but it's not really refcounted.  And=
 the
tail pages have nothing, which IIRC, results in KVM inadvertantly causing p=
ages
to be freed due to putting the last refeferences.

[*] https://lore.kernel.org/all/ZRZeaP7W5SuereMX@infradead.org


> > +	 *
> > +	 * When this output flag is false, callers should not try to convert
> > +	 * the pfn to a struct page.

This should explain what the flag tracks, not what callers should or should=
n't
do with the flag.  E.g. strictly speaking, there's no danger in grabbing th=
e
corresponding "struct page" if the caller verifies it's a valid PFN.  Tryin=
g to
use the page outside of mmu_notifier protection is where things would get d=
icey.

> > +	 */
> > +	bool is_refcounted_page;
> >  };
> > =20
> >  kvm_pfn_t __kvm_follow_pfn(struct kvm_follow_pfn *foll);
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 9b33a59c6d65..235c5cb3fdac 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -96,6 +96,10 @@ unsigned int halt_poll_ns_shrink;
> >  module_param(halt_poll_ns_shrink, uint, 0644);
> >  EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
> > =20
> > +/* Allow non-struct page memory to be mapped without MMU notifier prot=
ection. */
> > +static bool allow_unsafe_mappings;
> > +module_param(allow_unsafe_mappings, bool, 0444);
> > +
> >  /*
> >   * Ordering of locks:
> >   *
> > @@ -2507,6 +2511,15 @@ static inline int check_user_page_hwpoison(unsig=
ned long addr)
> >  	return rc =3D=3D -EHWPOISON;
> >  }
> > =20
> > +static kvm_pfn_t kvm_follow_refcounted_pfn(struct kvm_follow_pfn *foll=
,
> > +					   struct page *page)
> > +{
> > +	kvm_pfn_t pfn =3D page_to_pfn(page);
> > +
> > +	foll->is_refcounted_page =3D true;
> > +	return pfn;
> > +}
>=20
> Just a matter of taste but to me this function looks confusing.
> IMHO, just duplicating these two lines of code is better.
> However if you prefer I won't argue over this.

Hrm, when I suggested this, there was also a put_page() and a comment about=
 hacky
code in there:

static kvm_pfn_t kvm_follow_refcounted_pfn(struct kvm_follow_pfn *foll,
                                          struct page *page)
{
       kvm_pfn_t pfn =3D page_to_pfn(page);

       foll->is_refcounted_page =3D true;

       /*
        * FIXME: Ideally, KVM wouldn't pass FOLL_GET to gup() when the call=
er
        * doesn't want to grab a reference, but gup() doesn't support getti=
ng
        * just the pfn, i.e. FOLL_GET is effectively mandatory.  If that ev=
er
        * changes, drop this and simply don't pass FOLL_GET to gup().
        */
       if (!(foll->flags & FOLL_GET))
               put_page(page);

       return pfn;
}


More below.

> > -	/*
> > -	 * Get a reference here because callers of *hva_to_pfn* and
> > -	 * *gfn_to_pfn* ultimately call kvm_release_pfn_clean on the
> > -	 * returned pfn.  This is only needed if the VMA has VM_MIXEDMAP
> > -	 * set, but the kvm_try_get_pfn/kvm_release_pfn_clean pair will
> > -	 * simply do nothing for reserved pfns.
> > -	 *
> > -	 * Whoever called remap_pfn_range is also going to call e.g.
> > -	 * unmap_mapping_range before the underlying pages are freed,
> > -	 * causing a call to our MMU notifier.
> > -	 *
> > -	 * Certain IO or PFNMAP mappings can be backed with valid
> > -	 * struct pages, but be allocated without refcounting e.g.,
> > -	 * tail pages of non-compound higher order allocations, which
> > -	 * would then underflow the refcount when the caller does the
> > -	 * required put_page. Don't allow those pages here.
> > -	 */
>=20
> Why the comment is removed? as far as I see the code still grabs a refere=
nce
> to the page.

Because what the above comment is saying is effectively obsoleted by is_ref=
counted_page.
The old comment is essentially saying, "grab a reference because KVM expect=
s to
put a reference", whereas as the new code grabs a reference because it's ne=
cessary
to honor allow_unsafe_mappings.

So I agree with David that the existing comment should go away, but I agree=
 with
you in that kvm_follow_refcounted_pfn() really needs a comment, e.g. to exp=
lain
how KVM manages struct page refcounts.

> > -	if (!kvm_try_get_pfn(pfn))
> > -		r =3D -EFAULT;
> > +	if (get_page_unless_zero(page))
> > +		WARN_ON_ONCE(kvm_follow_refcounted_pfn(foll, page) !=3D pfn);
>=20
> Once again, the kvm_follow_refcounted_pfn usage is confusing IMHO.  It se=
ts
> the 'foll->is_refcounted_page', and yet someone can think that it's only
> there for the WARN_ON_ONCE.
>=20
> That IMHO would read better:
>=20
> if (get_page_unless_zero(page))
> 	foll->is_refcounted_page =3D true;
>=20
> WARN_ON_ONCE(page_to_pfn(page) !=3D pfn);
>=20
> Note that I moved the warn out of the 'get_page_unless_zero' condition
> because I think that this condition should be true for non refcounted pag=
es
> as well.

Yeah, let me see if I can piece together what happened to the put_page() ca=
ll.

> Also I don't understand why 'get_page_unless_zero(page)' result is ignore=
d.
> As I understand it, it will increase refcount of a page unless it is zero=
.=20
>=20
> If a refcount of a refcounted page is 0 isn't that a bug?

Yes, the problem is that KVM doesn't know if a page is refcounted or not, w=
ithout
actually trying to acquire a reference.  See the TTM mess mentioned above.

Note, Christoph is suggesting that KVM instead refuse to play nice and forc=
e the
TTM code to properly refcount things.  I very much like that idea in theory=
, but
I have no idea how feasible it is (that code is all kinds of twisty).

> The page was returned from kvm_pfn_to_refcounted_page which supposed only=
 to
> return pages that are refcounted.
>=20
> I might not understand something in regard to 'get_page_unless_zero(page)=
'
> usage both in old and the new code.


