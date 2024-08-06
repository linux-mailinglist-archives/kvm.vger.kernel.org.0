Return-Path: <kvm+bounces-23397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC02294950B
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 18:00:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90C0328159C
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 16:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CA163FB1B;
	Tue,  6 Aug 2024 15:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lZqfK3fh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2521E3B7AC
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 15:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722959879; cv=none; b=D4DPh+SIZUCSnkCG5l9zVs+uNBOpccD/BPzrIijX18DjxXfWhw8BQbCtMYWpbd50w7YSgD7W3vzl/piCaI+qpx2yghKkXERvUwiVz1oSkMmxw+E6fQkCHdrMsIJCZSC8bXcy57LWaas/Jy0fyBq5xGamRCE8VEcK+C3BwUr65qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722959879; c=relaxed/simple;
	bh=OGGMAjOwlhW2rsfolNhMYTqFynIuhRKSFSaVNX4vztU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oHDdJNiM0s5vDT7wsVOjis0rm6LtNpKwzt+6sVegz4Ve9mZvjlBQEdOhlS3LE/2CWZXAzn8qUGVBwBZZcUdbHv/Wt0Sit2TcoMupBcpsQyGrqNT5K41BMZ6/XEdU84r7wGHVOjAKXm6VslZTcXrK+nH94ij0lxxm0SyCmxJZ5fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lZqfK3fh; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc54c57a92so10123325ad.3
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 08:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722959877; x=1723564677; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mlT/xC9MI26w/5mH5bjuBQLZaiCef0X6LB6LYMI3QIk=;
        b=lZqfK3fhRxU2d0ZWbDFL7U7IEUwguHIzXSnwUs+OT1/A9uz6DkKAfLPI1DLq6HGvtf
         xX2E2ZHGBG7qsqic+RKuOSVL06xq5/BRjszDy0joUltS+DPdcP0RL0p220hzb1GHG/6v
         BQk906SQOt0wQz1HiI/RJzAexZ1xxZ/GeKauh9jSZdLkbxzpXgeBAEGcXklru7XRpzxO
         QVtdN3/fl8MfqQyVQcegGCEeLnVi5jP0aF0fnVwDLagcY+3zAZnXkLS+z1AgA/Ao7Kl6
         1h/FX0q5TiaSVdVvaSgW1vzAMq7odwwXSAAQfekFcBQaFQCtT1d7Cxd+F/9soa+5gVvI
         rvvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722959877; x=1723564677;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mlT/xC9MI26w/5mH5bjuBQLZaiCef0X6LB6LYMI3QIk=;
        b=qVd4s2NiwHEe5O5wba3imx6K3c42BFg34Wd1/Z5fjaSsyYZZknalFInJhufy28Rkgl
         zCt9mVeg2ogcTVnAHwswWNUokEwBrRIB8Cl3oDen2jC1KqVVJ/xhg3p3A5ARaONAcG5L
         szfRpgoE0CdCh0QMBwm7o8v3xgZkDIpkvXxQ3qcFvTGcKZYBl+ccfb4fYzG0yi8t1nxG
         +g2b/hc/MII0ASgn7Z2W0E2I9VxKTH+kbcjPHQlLSis+iC2mBD3Wy9UVT05EuABbr/bH
         ENlFw240LU+J2tT2e6fCxHl76DNFRwRVXpV83Yt5juwW2vrT9LEUICFQCoFLgRLNyPXD
         jiQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVW06PkFbsxtXOy4oQHcZ6M8JMcTgHJG2WbWhj49ftYeXkJ9EFWu5CPIzvKA6jGW8TIJ/iENThjAZXVGyFKK4PFai4O
X-Gm-Message-State: AOJu0YyCC1h17sWTevkCPenuWY30mBZSqUkbm6vE6F8R9rHAM6KjPGVS
	QX6yC0L5u0rUjFxagqPP8dNYgnLnEADUKrw6DNW4oYeNDBVB1cQ99zSEYaGePM7N1wHd45h+T3M
	nDA==
X-Google-Smtp-Source: AGHT+IELGJ9f0ZjvLPU8gCHpfqrCA0BDimPIfZAm14efTEPA1jwu6vtA8DKMXcUzX+n1HWsm4VBvaWnsy/w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f54b:b0:1fb:5a07:7977 with SMTP id
 d9443c01a7336-1ff572549b5mr13868505ad.3.1722959877237; Tue, 06 Aug 2024
 08:57:57 -0700 (PDT)
Date: Tue, 6 Aug 2024 08:57:55 -0700
In-Reply-To: <a21a90c76af446951956b4423b1f87beb91cb660.camel@infradead.org>
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
 <ZrItHce2GqAWoN0o@google.com> <a21a90c76af446951956b4423b1f87beb91cb660.camel@infradead.org>
Message-ID: <ZrJIA6t8S9Ucjqzn@google.com>
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
> On Tue, 2024-08-06 at 07:03 -0700, Sean Christopherson wrote:
> > On Tue, Aug 06, 2024, David Woodhouse wrote:
> > > On Mon, 2024-08-05 at 17:45 -0700, Sean Christopherson wrote:
> > > > On Mon, Aug 05, 2024, David Woodhouse wrote:
> > > > > From: David Woodhouse <dwmw@amazon.co.uk>
> > > > Servicing guest pages faults has the same problem, which is why
> > > > mmu_invalidate_retry_gfn() was added.=C2=A0 Supporting hva-only GPC=
s made our lives a
> > > > little harder, but not horrifically so (there are ordering differen=
ces regardless).
> > > >=20
> > > > Woefully incomplete, but I think this is the gist of what you want:
> > >=20
> > > Hm, maybe. It does mean that migration occurring all through memory
> > > (indeed, just one at top and bottom of guest memory space) would
> > > perturb GPCs which remain present.
> >=20
> > If that happens with a real world VMM, and it's not a blatant VMM goof,=
 then we
> > can fix KVM.=C2=A0 The stage-2 page fault path hammers the mmu_notifier=
 retry logic
> > far more than GPCs, so if a range-based check is inadequate for some us=
e case,
> > then we definitely need to fix both.
> >=20
> > In short, I don't see any reason to invent something different for GPCs=
.
> >=20
> > > > > @@ -849,6 +837,8 @@ static void kvm_mmu_notifier_invalidate_range=
_end(struct mmu_notifier *mn,
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0wake =3D !kvm->mn=
_active_invalidate_count;
> > > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_unlock(&kvm-=
>mn_invalidate_lock);
> > > > > =C2=A0
> > > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0gfn_to_pfn_cache_inval=
idate(kvm, range->start, range->end);
> > > >=20
> > > > We can't do this.=C2=A0 The contract with mmu_notifiers is that sec=
ondary MMUs must
> > > > unmap the hva before returning from invalidate_range_start(), and m=
ust not create
> > > > new mappings until invalidate_range_end().
>=20
> Looking at that assertion harder... where is that rule written?

The big comment for invalidate_range_{start,end}() in include/linux/mmu_not=
ifier.h.
The relevant snippets are:

	 * If the subsystem can't guarantee that no additional references are
	 * taken to the pages in the range, it has to implement the
	 * invalidate_range() notifier to remove any references taken after
	 * invalidate_range_start().

	 * invalidate_range_start() is called when all pages in the
	 * range are still mapped and have at least a refcount of one.
	 *
	 * invalidate_range_end() is called when all pages in the
	 * range have been unmapped and the pages have been freed by
	 * the VM.

The last one is key: the pages have already been freed when invalidate_rang=
e_end()
is called, and so unmapping at that time would be too late.

> It seems counter-intuitive to me; that isn't how TLBs work. Another CPU c=
an
> populate a TLB entry right up to the moment the PTE is actually *changed*=
 in
> the page tables, and then the CPU which is modifying/zapping the PTE need=
s to
> perform a remote TLB flush. That remote TLB flush is analogous to the
> invalidate_range_end() call, surely?

KVM's usage isn't about (hardware) TLBs.  Ah, and the history is even somew=
hat
evident in the above comment I referenced.  invalidate_range() no longer ex=
ists,
it was morphed into arch_invalidate_secondary_tlbs().  For secondary MMUs t=
hat
reuse the primary MMU's PTEs, mmu_notifier_arch_invalidate_secondary_tlbs()=
 is
indeed called after the PTEs have been modified.

KVM's usage is different.  Because KVM has its own (Secondary) PTEs (commit
1af5a8109904 ("mmu_notifiers: rename invalidate_range notifier") calls them
"software TLBs", but I find that to be a confusing description), zapping on=
-demand
when the primary PTEs are modified is tricky and ultimately undesirable.

E.g. invoking mmu_notifiers while holding a PTE lock would prevent KVM from
blocking, which can be problematic if KVM needs to zap a large number SPTEs=
.

And doing invalidation on-demand for each primary PTE would be suboptimal f=
or
cases where a large VMA range is unmapped/modified, e.g. KVM would get a la=
rge
number of invalidation events instead of one big, all-encompassing invalida=
tion.

The obvious downside is what you've run into, where the start+end approach =
forces
KVM to wait for all in-flight invalidations to go away.  But again, in prac=
tice
the rudimentary range tracking suffices for all known use cases.

> I'm fairly sure that's how it works for PASID support too; nothing
> prevents the IOMMU+device from populating an IOTLB entry until the PTE
> is actually changed in the process page tables.
>=20
> So why can't we do the same for the GPC?
>=20
> > > But in the context of the GPC, it is only "mapped" when the ->valid b=
it is set.=20
> > >=20
> > > Even the invalidation callback just clears the valid bit, and that
> > > means nobody is allowed to dereference the ->khva any more. It doesn'=
t
> > > matter that the underlying (stale) PFN is still kmapped.
> > >=20
> > > Can we not apply the same logic to the hva_to_pfn_retry() loop? Yes, =
it
> > > might kmap a page that gets removed, but it's not actually created a
> > > new mapping if it hasn't set the ->valid bit.
> > >=20
> > > I don't think this version quite meets the constraints, and I might
> > > need to hook *both* the start and end notifiers, and might not like i=
t
> > > once I get there. But I'll have a go...
> >=20
> > I'm pretty sure you're going to need the range-based retry logic.=C2=A0=
 KVM can't
> > safely set gpc->valid until mn_active_invalidate_count reaches zero, so=
 if a GPC
> > refresh comes along after mn_active_invalidate_count has been elevated,=
 it won't
> > be able to set gpc->valid until the MADV_DONTNEED storm goes away.=C2=
=A0 Without
> > range-based tracking, there's no way to know if a previous invalidation=
 was
> > relevant to the GPC.
>=20
> If it is indeed the case that KVM can't just behave like a normal TLB,
> so it and can't set gpc->valid until mn_active_invalidate_count reaches
> zero, it still only needs to *wait* (or spin, maybe). It certainly
> doesn't need to keep looping and remapping the same PFN over and over
> again, as it does at the moment.
>=20
> When mn_active_invalidate_count does reach zero, either the young GPC
> will have been invalidated by clearing the (to be renamed) ->validating
> flag, or it won't have been. If it *has* been invalidated, that's when
> hva_to_pfn_retry() needs to go one more time round its full loop.
>=20
> So it just needs to wait until any pending (relevant) invalidations
> have completed, *then* check and potentially loop once more.
>=20
> And yes, making that *wait* range-based does make some sense, I
> suppose. It becomes "wait for gpc->uhva not to be within the range of
> kvm->mmu_gpc_invalidate_range_{start,end}."

Yep, exactly.  Without range-based tracking, there's no way for KVM to know=
 when
a relevant in-flight invalidation has completed.

> Except... that range can never shrink *except* when
> mn_active_invalidate_count becomes zero, can it?

Not without more sophisticated logic, no.  E.g. if KVM supported tracking m=
ultiple
distinct ranges, then individual invalidation ranges could be dropped.  But=
 to
to avoid memory allocations in invalidate_range_start(), KVM would still ne=
ed to
hardcode the maximum number of in-flight ranges.  E.g. even if KVM used a d=
ynamic
container, we'd probably want the container entries to be "allocated" out o=
f a
cache, and that cache would need a maximum capacity.

With a max limit on the number of ranges, KVM would still be forced to comb=
ine
ranges if there are too many in-flight invalidations.

So, because tracking a single range has sufficed for all known use cases, a=
nd
it's significantly simpler than tracking multiple ranges, AFAIK no one has =
pursued
a multi-range tracking implementation.

> So if we do end up waiting, the wake condition is *still* just that the c=
ount
> has become zero. There's already a wakeup in that case, on kvm-
> >mn_memslots_update_rcuwait. Can I wait on that?

I suspect you're trying to solve a problem that doesn't exist in practice.
hva_to_pfn_retry() already has a cond_resched(), so getting stuck for a lon=
g
duration isn't fatal, just suboptimal.  And similar to the range-based trac=
king,
_if_ there's a problem in practice, then it also affects guest page faults.=
  KVM
simply resumes the vCPU and keeps re-faulting until the in-flight invalidat=
ion(s)
has gone away.

Not without reworking mn_memslots_update_rcuwait.  KVM assumes there is at =
most
one waiter, as that wait+wake combination is specifically to handle the cas=
e where
a _relevant_ in-flight mmu_notifier invalidation needs to block a userspace=
 memslot
deletion.  KVM takes mmu_lock in invalidate_range_{start,end}() if and only=
 if
there is an overlapping memslot, and so KVM needs to prevent a memslot from=
 being
deleted between start() and end().

