Return-Path: <kvm+bounces-13406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E173D896090
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 02:17:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9EC0B287C58
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 00:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD50810FD;
	Wed,  3 Apr 2024 00:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tPc4BS6Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545B8161
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 00:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712103453; cv=none; b=bSrLeBCGIrq6vW7qoqw1FOgvDnbc8KaatITtR4gt4q4Yy0sSdaRni6H4Ryjehf/4VHVHgYH0HUNYJcz07S0+VI96jygJq0jgVQyL02ryxEGzw+doGxPaIhCcbkv5KQJNPbTcdmLosbsK1KLDU/FZuqZwVaaf2ZdxLzSOXM6QaAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712103453; c=relaxed/simple;
	bh=fqB/m9++hw+vMxpLmBSdwI1jLPOHELq27hUeMesb0hY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P4/IM2/3kx4ViXJWUmZ+d/SI4p4fbHAKyfmZBevt1X6usSXXTq4mNJEJwJOOsWeoCRC5TbwipR5TNdR4re/AdV3uwP64zswwPeXfmIQm3yoBvWEY9Vs+wPHl9WfZtcOPj4t1n5Kx1SbOGWlKge6cxzp6awmOaCLnN0sHG0jeY7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tPc4BS6Z; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5d396a57ea5so4014845a12.2
        for <kvm@vger.kernel.org>; Tue, 02 Apr 2024 17:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712103451; x=1712708251; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mH8+NVv/PsCFy6RnKusUXowZHBPGIyHQHxPOHPE7gWk=;
        b=tPc4BS6ZJfI2KfrHih+05THTGI4cGJFp1cmWyE0ZvzLVXKBf2M5X5UirvAVkJhKW3b
         x5p7xhHFv2/VlfGCiEi0a1dbdpWFzqeizUdCgUEeGWyabHvf0DNx3PA/Kc5+cZkL7uMQ
         RTkkpUG2q12khLX0SmGJmSnbSbx5uHTPPi/1ooXa6MFB3+S3rMHdiyLstYw9ljSo9hDX
         j3LEtCecaQshe30Tjuq/DiRp/97DuPwYyos+BFv7RVH+4fYbtGe2lwl0BbJ5nrHhNEOw
         q4h1Y43jlzVvdiBC+CriHVRjXoHDwjS3o6kRszVoXlorhI9L2RBuBwBePz6YQqtYrNcU
         NQcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712103451; x=1712708251;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mH8+NVv/PsCFy6RnKusUXowZHBPGIyHQHxPOHPE7gWk=;
        b=kZ005n/afdFF1+iEliWq1Dr9t3c2v4RCxPSy2MDUnDwTLoPxMH4rQAlMWxsM+PUdEt
         A4tGwxnMnsOjjh0Nq0VD6CFNIPlr6+9+H7ATWf4uixZNaK8gZ4qrImfpgaTV9hejfC9G
         XAf/Ii7ORYxllS/S6LPr/XltAK0td1qy1DdrPpS3zbP92MAyPQ1COjvdD6LPxc95UoAx
         lWOVRC2AxUMeCAaEKLXkXlIO9jI/g1BySejVMoKZjYsjCfldMptTh5J/ytIGlv+QEE6o
         1Ozm1VnfTzo/Syuua6ei35BJyC56pQBDpnQX3vO+z73kb7ou9MIyv4ej1k8fGVT1erwT
         bV3w==
X-Forwarded-Encrypted: i=1; AJvYcCXUNDre1luJpsoOFJzpRf3+NKlKzkGz2srJX/26zDM8R+//LWzc7Pm3jCqQC2580ER7YCbOJ9rut2IKVXwhQQMqr7yv
X-Gm-Message-State: AOJu0Ywn9mBZJWrrYTBPx8sRMoA4Ft8IA5bGCijwPV6CO57iqm7pT1tj
	a3IM9AhfHeXaIGowvoniG+cRXcY14i1AMYnjMOYb+W/aJ18l2YcmKKZDIv8doVNzWkB6eG0QzRX
	Umw==
X-Google-Smtp-Source: AGHT+IERuG6/bwzVsHG+IYGRLcPBcZTylhpM0GzVLUHso5qFqBHgvoT4LrS+S/6KcA/5K/QPbm7PmHQgVRA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:184:b0:1e0:f478:992d with SMTP id
 z4-20020a170903018400b001e0f478992dmr1295910plg.2.1712103451547; Tue, 02 Apr
 2024 17:17:31 -0700 (PDT)
Date: Tue, 2 Apr 2024 17:17:30 -0700
In-Reply-To: <a2fff462-dfe6-4979-a7b2-131c6e0b5017@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240320005024.3216282-1-seanjc@google.com> <4d04b010-98f3-4eae-b320-a7dd6104b0bf@redhat.com>
 <CALzav=eLH+V_5Y6ZWsRkmnbEb6fxPa55B7xyWxP3o6qsrs_nHA@mail.gmail.com> <a2fff462-dfe6-4979-a7b2-131c6e0b5017@redhat.com>
Message-ID: <ZgygGmaEuddZGKyX@google.com>
Subject: Re: [RFC PATCH 0/4] KVM: x86/mmu: Rework marking folios dirty/accessed
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Stevens <stevensd@chromium.org>, 
	Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 02, 2024, David Hildenbrand wrote:
> On 02.04.24 19:38, David Matlack wrote:
> > On Wed, Mar 20, 2024 at 5:56=E2=80=AFAM David Hildenbrand <david@redhat=
.com> wrote:
> > > Secondary page tables are different to ordinary GUP, and KVM ends up
> > > using GUP to some degree to simulate HW access; regarding NUMA-hintin=
g,
> > > KVM already revealed to be very different to all other GUP users. [1]
> > >=20
> > > And I recall that at some point I raised that we might want to have a
> > > dedicate interface for these "mmu-notifier" based page table
> > > synchonization mechanism.
> > >=20
> > > But KVM ends up setting folio dirty/access flags itself, like other G=
UP
> > > users. I do wonder if secondary page tables should be messing with fo=
lio
> > > flags *at all*, and if there would be ways to to it differently using=
 PTEs.
> > >=20
> > > We make sure to synchronize the secondary page tables to the process
> > > page tables using MMU notifiers: when we write-protect/unmap a PTE, w=
e
> > > write-protect/unmap the SPTE. Yet, we handle accessed/dirty completel=
y
> > > different.
> >=20
> > Accessed bits have the test/clear young MMU-notifiers. But I agree
> > there aren't any notifiers for dirty tracking.
>
> Yes, and I am questioning if the "test" part should exist -- or if having=
 a
> spte in the secondary MMU should require the access bit to be set (derive=
d
> from the primary MMU). (again, my explanation about fake HW page table
> walkers)
>=20
> There might be a good reason to do it like that nowadays, so I'm only
> raising it as something I was wondering. Likely, frequent clearing of the
> access bit would result in many PTEs in the secondary MMU getting
> invalidated, requiring a new GUP-fast lookup where we would set the acces=
s
> bit in the primary MMU PTE. But I'm not an expert on the implications wit=
h
> MMU notifiers and access bit clearing.

Ya.  KVM already does something similar this for dirty logging, where SPTEs=
 are
write-protected, i.e. generate faults to track dirty status.  But KVM x86 h=
as a
lot of code to mitigates the resulting pain, e.g. has a lockless fast-path =
to
make the SPTE writable and propagate the dirty status to bitmaps, and users=
pace
is heavily/carefully optimized to balance harvesting/clearing dirty status =
against
guest activity.

In general, assumptions that core MM makes about the cost of PTE modificati=
ons
tend to fall apart for KVM.  Much of that comes down to mmu_notifiers inval=
idations
being an imperfect boundary between the primary MMU and secondary MMUs.  E.=
g.
any prot changes (NUMA balancing in particular) can have disastrous impact =
on KVM
guests because those changes invalidate secondary MMUs at PMD granularity, =
and
effective force KVM to do a remote TLB for every PMD that is affected, wher=
eas
the primary is able to batch TLB flushes until the entire VMA is processed.

So yeah, forcing KVM to zap and re-fault SPTEs in order to do page aging wo=
uld be
comically slow for KVM guests without a crazy amount of optimization.

> > Are there any cases where the primary MMU transfers the PTE dirty bit
> > to the folio _other_ than zapping (which already has an MMU-notifier
> > to KVM). If not then there might not be any reason to add a new
> > notifier. Instead the contract should just be that secondary MMUs must
> > also transfer their dirty bits to folios in sync (or before) the
> > primary MMU zaps its PTE.
>=20
> Grepping for pte_mkclean(), there might be some cases. Many cases use MMU
> notifier, because they either clear the PTE or also remove write
> permissions.
>=20
> But these is madvise_free_pte_range() and
> clean_record_shared_mapping_range()...->clean_record_pte(), that might on=
ly
> clear the dirty bit without clearing/changing permissions and consequentl=
y
> not calling MMU notifiers.

Heh, I was staring at these earlier today.  They all are wrapped with
mmu_notifier_invalidate_range_{start,end}(), and KVM's hyper aggressive res=
ponse
to mmu_notifier invalidations ensure all KVM SPTEs get dropped.

> Getting a writable PTE without the dirty bit set should be possible.
>=20
> So I am questioning whether having a writable PTE in the secondary MMU wi=
th
> a clean PTE in the primary MMU should be valid to exist. It can exist tod=
ay,
> and I am not sure if that's the right approach.

I came to the same conclusion (that it can exist today).  Without (sane) FO=
LL_TOUCH,
KVM could retrieve the new PTE (W=3D1,D=3D0) after an mmu_notifier invaliat=
ion, and
thus end up with a writable SPTE that isn't dirty in core MM.

For MADV_FREE, I don't see how KVM's current behavior of marking the folio =
dirty
at zap time changes anything.  Ah, try_to_unmap_one() checks folio_test_dir=
ty()
*after* invoking mmu_notifier_invalidate_range_start(), which ensures that =
KVM's
dirty status is propagated to the folio, and thus try_to_unmap_one() keeps =
the
folio.

Aha!  But try_to_unmap_one() also checks that refcount=3D=3Dmapcount+1, i.e=
. will
also keep the folio if it has been GUP'd.  And __remove_mapping() explicitl=
y states
that it needs to play nice with a GUP'd page being marked dirty before the
reference is dropped.

	 * Must be careful with the order of the tests. When someone has
	 * a ref to the folio, it may be possible that they dirty it then
	 * drop the reference. So if the dirty flag is tested before the
	 * refcount here, then the following race may occur:

So while it's totally possible for KVM to get a W=3D1,D=3D0 PTE, if I'm rea=
ding the
code correctly it's safe/legal so long as KVM either (a) marks the folio di=
rty
while holding a reference or (b) marks the folio dirty before returning fro=
m its
mmu_notifier_invalidate_range_start() hook, *AND* obviously if KVM drops it=
s
mappings in response to mmu_notifier_invalidate_range_start().

> > > I once had the following idea, but I am not sure about all implicatio=
ns,
> > > just wanted to raise it because it matches the topic here:
> > >=20
> > > Secondary page tables kind-of behave like "HW" access. If there is a
> > > write access, we would expect the original PTE to become dirty, not t=
he
> > > mapped folio.
> >=20
> > Propagating SPTE dirty bits to folios indirectly via the primary MMU
> > PTEs won't work for guest_memfd where there is no primary MMU PTE. In
> > order to avoid having two different ways to propagate SPTE dirty bits,
> > KVM should probably be responsible for updating the folio directly.
> >=20
>=20
> But who really cares about access/dirty bits for guest_memfd?
>=20
> guest_memfd already wants to disable/bypass all of core-MM, so different
> rules are to be expected. This discussion is all about integration with
> core-MM that relies on correct dirty bits, which does not really apply to
> guest_memfd.

+1, this is one of many reasons I don't want to support swap/relcaim for gu=
est_memfd.
The instant guest_memfd gets involved with anything LRU related, the intera=
ctions
and complexity skyrockets.

