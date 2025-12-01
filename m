Return-Path: <kvm+bounces-64978-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89057C95818
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 02:36:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AF493A2B05
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 01:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B79A13AD1C;
	Mon,  1 Dec 2025 01:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aipkmuEN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2EA36D4F7
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 01:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764552958; cv=none; b=GpnUBsjXWwxbzpdLpJZF8JrOuUh595WDP5i2MR6I5TpajRQPMOWW/xjl8r9TXoWiPmO6mGAy1o3vJhG8URJ2pR+Rjk0t9utxozGSGURcVVfljv93iPufymDDQiLtUgOmb9S4sfigFupLvYcNwdpW2rFSeioudaOZH7ds09rWWto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764552958; c=relaxed/simple;
	bh=H3eA7r+v1s9E1ms+i8tK4B9scMb9qfYyiDP24C11NNI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rqfXpPcC3NY4v2OlFHSR0VBuG02csreoNVAG8CEW4Pa9BEJgAIfeY+Svuqvo99fc4EvboZT0IrcWcProam2cuxNcG25/+dKp5uyP1PZPpzRtgQQ3FXVAMwSQkMo/01mN1+K0ElhcXlQkhr6rfh57w7KmceIAWEyQb1dyhv5fg28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aipkmuEN; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-295c64cb951so638635ad.0
        for <kvm@vger.kernel.org>; Sun, 30 Nov 2025 17:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764552955; x=1765157755; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NqMTDdZDQx07C1ZaPMQnb45Si66LI4igGTkIU2isIPo=;
        b=aipkmuENOfWrMTonefk1kwdaI93xCRMkGaTVBdjPcCtqr7ed560+PVOQH8603JkFhZ
         +8rNj02Q6ptF94RUym8sT52DcV6WwCWcqydRfiDheQBNi9zboC6Tfmy4WxUp5LLYAbFm
         O9E8ZiXw+DrTzoHDEnbHbsjmh0sMAJyQ1HwWol8lYs8MpcaLljlMkvx/28avPPtCIQiT
         4dxrkTXzabH0Anz/nykhjIpB1k9jSNNQB2hkz40jH8Pka0aH+XtzRwMNlFJPR8NKmfYT
         7+q7w4NJzcTI8WUjNM5v4RnIPCwWNISaM+dPL7Ykx7imxuc9mIhP8WBmbFOmbyVA1BVt
         fOSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764552955; x=1765157755;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NqMTDdZDQx07C1ZaPMQnb45Si66LI4igGTkIU2isIPo=;
        b=T8kdjdpvAMTuyYKJxLrE5cKG7+DQK3zvS2Y76Bt1PfCQTVSBTdZs0CjLNSyIn5ddir
         akWMG/UoR4K9T6hq/RbYNUrIfzvpa5BjOyAZQlwGu6yt0dqKjpxbKexbgecxNjP5MC+Q
         P42nCIk8+Ch7dSS940mXkwJ4SUFcmjaoCpHCBlZq25NoXuvuY6/anGkAaa3F1bRlV4Pm
         AVxdylAuLYCTkkopaimk7iRrWvdt5s5ixZyhN4+Gn8EBlVnGq7agujJC6btzHj1OSz0t
         VYmL0tfDEmpKGgEM36na6OzdvBKbJqDmMKifIi/kfMVqkQU0w2kA7pNv2veQtd585noI
         n2Lg==
X-Forwarded-Encrypted: i=1; AJvYcCWurDGa9mydao4DBpV7k3i1P11hmFniiwuSM+1S82apl5bi10/nfvoOevUt0AVZOcB8Rjg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoWH2Nuv9uew9NildNyDm2p2ZhhIrHw72OqRYoGS9M+mSvRhL2
	+tmRoHzAAV3Tka3SComY1trGDP7aThoKvfEh8Jb0rf6bcgT2c6zpkPQ+iyG75HoYFmmjBUddgkl
	yU61HkA8dA/xEIKeUO0U+x4MOgwLu8uGQYy0gw4rz
X-Gm-Gg: ASbGncuvRX/uJSHFv/A1h3KSeKcllSubGrbRjhGFdBN4o+Kb9DrRHsjVfeSjMaQQ8xm
	qM+DA7VclY/8X21oTLRhgdLtmfHZcpM36e1DP4o9K5EjEm146uzYfDZb3uOXuXR00UbPRztPHGJ
	NYqhxo0SOyRoFvN4d2CMnYrlzMMgDW0Y4eup7aUl/ir5FXKn/uq+yWMeIqQr6RLRGPM6yy+GacO
	pQatzANfBGgbmYt7aQcpccmgayNzG/ek56LQ2byf8w7Mupwyf4l7XiavQUgEnUiBKj5p0SznBp/
	AZqGR5cjUSL2c79D8ciWm35Pe85z
X-Google-Smtp-Source: AGHT+IHEIEDZv76b8TRa1Qq061l1oB83PxjhPadbC3bezpK0erCqAD68jFap6vD+r6SRmAZ5XU1p/iYTpAphAiRdI4I=
X-Received: by 2002:a05:7022:e1d:b0:119:e56b:c1e1 with SMTP id
 a92af1059eb24-11dc93b618emr441412c88.12.1764552954586; Sun, 30 Nov 2025
 17:35:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113230759.1562024-1-michael.roth@amd.com>
 <20251113230759.1562024-2-michael.roth@amd.com> <aR7blxIx6tKD2xiQ@yzhao56-desk.sh.intel.com>
 <20251121124314.36zlpzhwm5zglih2@amd.com> <aSUe1UfD3hXg2iMZ@yzhao56-desk.sh.intel.com>
In-Reply-To: <aSUe1UfD3hXg2iMZ@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Sun, 30 Nov 2025 17:35:41 -0800
X-Gm-Features: AWmQ_bnH7rPpu--Cc2pGsK-pw880zjcxq8IZgsPMdV1b8UL-1xfVljIN1Z8nNyQ
Message-ID: <CAGtprH-ZhHO4C5gTqWgMNpf5MKvL0yz6QG2h01sz=0o=ZwOF0g@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: guest_memfd: Remove preparation tracking
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, 
	pbonzini@redhat.com, seanjc@google.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	liam.merwick@oracle.com, david@redhat.com, ackerleytng@google.com, 
	aik@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2025 at 7:15=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wro=
te:
>
> On Fri, Nov 21, 2025 at 06:43:14AM -0600, Michael Roth wrote:
> > On Thu, Nov 20, 2025 at 05:12:55PM +0800, Yan Zhao wrote:
> > > On Thu, Nov 13, 2025 at 05:07:57PM -0600, Michael Roth wrote:
> > > > @@ -797,19 +782,25 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct =
kvm_memory_slot *slot,
> > > >  {
> > > >   pgoff_t index =3D kvm_gmem_get_index(slot, gfn);
> > > >   struct folio *folio;
> > > > - bool is_prepared =3D false;
> > > >   int r =3D 0;
> > > >
> > > >   CLASS(gmem_get_file, file)(slot);
> > > >   if (!file)
> > > >           return -EFAULT;
> > > >
> > > > - folio =3D __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared=
, max_order);
> > > > + folio =3D __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
> > > >   if (IS_ERR(folio))
> > > >           return PTR_ERR(folio);
> > > >
> > > > - if (!is_prepared)
> > > > -         r =3D kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> > > > + if (!folio_test_uptodate(folio)) {
> > > > +         unsigned long i, nr_pages =3D folio_nr_pages(folio);
> > > > +
> > > > +         for (i =3D 0; i < nr_pages; i++)
> > > > +                 clear_highpage(folio_page(folio, i));
> > > > +         folio_mark_uptodate(folio);
> > > Here, the entire folio is cleared only when the folio is not marked u=
ptodate.
> > > Then, please check my questions at the bottom
> >
> > Yes, in this patch at least where I tried to mirror the current logic. =
I
> > would not be surprised if we need to rework things for inplace/hugepage
> > support though, but decoupling 'preparation' from the uptodate flag is
> > the main goal here.
> Could you elaborate a little why the decoupling is needed if it's not for
> hugepage?

IMO, decoupling is useful in general and we don't necessarily need to
wait till hugepage support lands to clean up this logic. Current
preparation logic has created some confusion regarding multiple
features for guest_memfd under discussion such as generic write, uffd
support, and direct map removal. It would be useful to simplify the
guest_memfd logic in this regard.

>
>
> > > > + }
> > > > +
> > > > + r =3D kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> > > >
> > > >   folio_unlock(folio);
> > > >
> > > > @@ -852,7 +843,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t s=
tart_gfn, void __user *src, long
> > > >           struct folio *folio;
> > > >           gfn_t gfn =3D start_gfn + i;
> > > >           pgoff_t index =3D kvm_gmem_get_index(slot, gfn);
> > > > -         bool is_prepared =3D false;
> > > >           kvm_pfn_t pfn;
> > > >
> > > >           if (signal_pending(current)) {
> > > > @@ -860,19 +850,12 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t=
 start_gfn, void __user *src, long
> > > >                   break;
> > > >           }
> > > >
> > > > -         folio =3D __kvm_gmem_get_pfn(file, slot, index, &pfn, &is=
_prepared, &max_order);
> > > > +         folio =3D __kvm_gmem_get_pfn(file, slot, index, &pfn, &ma=
x_order);
> > > >           if (IS_ERR(folio)) {
> > > >                   ret =3D PTR_ERR(folio);
> > > >                   break;
> > > >           }
> > > >
> > > > -         if (is_prepared) {
> > > > -                 folio_unlock(folio);
> > > > -                 folio_put(folio);
> > > > -                 ret =3D -EEXIST;
> > > > -                 break;
> > > > -         }
> > > > -
> > > >           folio_unlock(folio);
> > > >           WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
> > > >                   (npages - i) < (1 << max_order));
> > > TDX could hit this warning easily when npages =3D=3D 1, max_order =3D=
=3D 9.
> >
> > Yes, this will need to change to handle that. I don't think I had to
> > change this for previous iterations of SNP hugepage support, but
> > there are definitely cases where a sub-2M range might get populated
> > even though it's backed by a 2M folio, so I'm not sure why I didn't
> > hit it there.
> >
> > But I'm taking Sean's cue on touching as little of the existing
> > hugepage logic as possible in this particular series so we can revisit
> > the remaining changes with some better context.
> Frankly, I don't understand why this patch 1 is required if we only want =
"moving
> GUP out of post_populate()" to work for 4KB folios.
>
> > >
> > > > @@ -889,7 +872,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t s=
tart_gfn, void __user *src, long
> > > >           p =3D src ? src + i * PAGE_SIZE : NULL;
> > > >           ret =3D post_populate(kvm, gfn, pfn, p, max_order, opaque=
);
> > > >           if (!ret)
> > > > -                 kvm_gmem_mark_prepared(folio);
> > > > +                 folio_mark_uptodate(folio);
> > > As also asked in [1], why is the entire folio marked as uptodate here=
? Why does
> > > kvm_gmem_get_pfn() clear all pages of a huge folio when the folio isn=
't marked
> > > uptodate?
> >
> > Quoting your example from[1] for more context:
> >
> > > I also have a question about this patch:
> > >
> > > Suppose there's a 2MB huge folio A, where
> > > A1 and A2 are 4KB pages belonging to folio A.
> > >
> > > (1) kvm_gmem_populate() invokes __kvm_gmem_get_pfn() and gets folio A=
.
> > >     It adds page A1 and invokes folio_mark_uptodate() on folio A.
> >
> > In SNP hugepage patchset you responded to, it would only mark A1 as
> You mean code in
> https://github.com/amdese/linux/commits/snp-inplace-conversion-rfc1 ?
>
> > prepared/cleared. There was 4K-granularity tracking added to handle thi=
s.
> I don't find the code that marks only A1 as "prepared/cleared".
> Instead, I just found folio_mark_uptodate() is invoked by kvm_gmem_popula=
te()
> to mark the entire folio A as uptodate.
>
> However, according to your statement below that "uptodate flag only track=
s
> whether a folio has been cleared", I don't follow why and where the entir=
e folio
> A would be cleared if kvm_gmem_populate() only adds page A1.

I think kvm_gmem_populate() is currently only used by SNP and TDX
logic, I don't see an issue with marking the complete folio as
uptodate even if its partially updated by kvm_gmem_populate() paths as
the private memory will eventually get initialized anyways.

>
> > There was an odd subtlety in that series though: it was defaulting to t=
he
> > folio_order() for the prep-tracking/post-populate, but it would then cl=
amp
> > it down based on the max order possible according whether that particul=
ar
> > order was a homogenous range of KVM_MEMORY_ATTRIBUTE_PRIVATE. Which is =
not
> > a great way to handle things, and I don't remember if I'd actually inte=
nded
> > to implement it that way or not... that's probably why I never tripped =
over
> > the WARN_ON() above, now that I think of it.
> >
> > But neither of these these apply to any current plans for hugepage supp=
ort
> > that I'm aware of, so probably not worth working through what that seri=
es
> > did and look at this from a fresh perspective.
> >
> > >
> > > (2) kvm_gmem_get_pfn() later faults in page A2.
> > >     As folio A is uptodate, clear_highpage() is not invoked on page A=
2.
> > >     kvm_gmem_prepare_folio() is invoked on the whole folio A.
> > >
> > > (2) could occur at least in TDX when only a part the 2MB page is adde=
d as guest
> > > initial memory.
> > >
> > > My questions:
> > > - Would (2) occur on SEV?
> > > - If it does, is the lack of clear_highpage() on A2 a problem ?
> > > - Is invoking gmem_prepare on page A1 a problem?
> >
> > Assuming this patch goes upstream in some form, we will now have the
> > following major differences versus previous code:
> >
> >   1) uptodate flag only tracks whether a folio has been cleared
> >   2) gmem always calls kvm_arch_gmem_prepare() via kvm_gmem_get_pfn() a=
nd
> >      the architecture can handle it's own tracking at whatever granular=
ity
> >      it likes.
> 2) looks good to me.
>
> > My hope is that 1) can similarly be done in such a way that gmem does n=
ot
> > need to track things at sub-hugepage granularity and necessitate the ne=
ed
> > for some new data structure/state/flag to track sub-page status.
> I actually don't understand what uptodate flag helps gmem to track.
> Why can't clear_highpage() be done inside arch specific code? TDX doesn't=
 need
> this clearing after all.

Target audience for guest_memfd includes non-confidential VMs as well.
Inline with shmem and other filesystems, guest_memfd should clear
pages on fault before handing them out to the users. There should be a
way to opt-out of this behavior for certain private faults like for
SNP/TDX and possibly for CCA as well.

>
> > My understanding based on prior discussion in guest_memfd calls was tha=
t
> > it would be okay to go ahead and clear the entire folio at initial allo=
cation
> > time, and basically never mess with it again. It was also my understand=
ing
> That's where I don't follow in this patch.
> I don't see where the entire folio A is cleared if it's only partially ma=
pped by
> kvm_gmem_populate(). kvm_gmem_get_pfn() won't clear folio A either due to
> kvm_gmem_populate() has set the uptodate flag.

Since kvm_gmem_populate() is specific to SNP and TDX VMs, I don't
think this behavior is concerning.

