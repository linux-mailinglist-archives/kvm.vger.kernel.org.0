Return-Path: <kvm+bounces-12326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A06B8818D5
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 21:55:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E3362B209EC
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 20:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01DEF85947;
	Wed, 20 Mar 2024 20:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3AhsXYS/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4292E481C0
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 20:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710968090; cv=none; b=JlqzE87Kvla+/sw7vU6zhVy8O3A+Uoqi09V1h04g3NfXFnrZrNUy95mSdM0a2qqkiBAcW5VnfL3HCWM3nkyr8RgmJaVQCYWETcFpREy1DDGwitfK5pvbT+eyBTY0NAkimXiEt8C34KYQT3mJ7M47B+8ZI/e0aL5hu7DmmHheISM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710968090; c=relaxed/simple;
	bh=XhFojGRriaPCLI2McEy+lswO1UFG6gWja66SzVIzjrc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NqOsJBAZ3Xw/mI9cO6w1Q61ftx9yNtS+M9Nrm3EpFUXM6kSOvJ8kZ0gdftjCVOlcVEzqiJvcdp83xlIB0SM7PEMTYLh+SrRc4p9XQnCEIv6qtmNyIsRaglhWA2F9XUQqj47SFXDJhEIaF28Sb1TSzsYHoyuCyIdhfrY5v9YP9g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3AhsXYS/; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-341950a6c9aso156106f8f.1
        for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 13:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710968086; x=1711572886; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M9OJbJMLYpLTqaMrgQ5F4CTDV8TnBXcToRrQB4UYTw0=;
        b=3AhsXYS/i0NY1pAmQrwKXOH99Y8G9fzcglG2kv+lEMJulNGI7uNY/j5xZ5d3SbN+Fo
         6SHmTmgkGftF1kt22LfPiqtg4X6SEq83K5bPuItaeMmKnOzLfVSXCFgLr85Od2ep6CYB
         0GKEMXSTe44nTJVNKA6EJ4LOYuUATvZZsOIzKRFCbQSwHU+XE0eYlqv0GBu5tno5/EFk
         iIToq1yuk1I1tJF/gimflZS3B2wwA3FeNXnF94E/4CatBXt/4DUZhQpvWXlacE4x8CgN
         dR/poragRQThCtr8gdSRtpmTZ9It9kVpUwh+yxVVp0cwtQVwb3PrBL9HRuwg0bJAD2dM
         H3JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710968086; x=1711572886;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M9OJbJMLYpLTqaMrgQ5F4CTDV8TnBXcToRrQB4UYTw0=;
        b=VYjLOGlp5LiFxv4lREydQCNZswY9ZTJ607Kz0sHrQPUjHJEV4GeFZlS3ZVkAsg0lFv
         VTvi6K7WYEI5XoRLO6m5ZIC683kd2BPdhEGGjhLm2ZACCBYvm4ZcUsp0FTjkzryHlKL7
         bxn4VDiv39++umiPLoTjcwfXjEBJiMqy7+Xqv2JV2Rcb97udN6AbIeo2L97mQsJgfR4Y
         G60vkXZIIofWdP/EkNfabtXqXAFUWp7OqmDaz/sRj2mjApYZdt99p/173+rA4ARV3geP
         QVHt1FmTnC8Ax8BUxBJp3KYSY6UFqFW6FmWqr4fLFGgeT0jlB7zUI/v+UF9iR/Xu4hC3
         yiJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtN5WwMMlVCJtwhnMhAb5fQGGBNEyaQSNC57gWCVRlyLESouY8FkEBu7OzOa7iFu/k1qEJukQJISUBmlNjHR2HAp1q
X-Gm-Message-State: AOJu0YzOPrQzZiOKh4TOLXt+uiEWs0J+UYdyi7RU3hIJ5Ogpf0aeiZxP
	dFTFRyltHvVIUDSOf0AqZTZNIs3B45HlavIZsHVMDxDVhUJSjlhc1csi/EkdamckrzU8qXckbNq
	RwO1GjmNosIgztwyVUlkk2kqJ53kaaUrlm7DL
X-Google-Smtp-Source: AGHT+IH87XnoWDBP/JxyANKouNDuOvhC2d4maSHSsazIVN31uoJwJMNqdiRF8UnED+uAboiXZOXtAHHYnunpxv28wyE=
X-Received: by 2002:a05:6000:4020:b0:341:906b:3351 with SMTP id
 cp32-20020a056000402000b00341906b3351mr284860wrb.0.1710968086423; Wed, 20 Mar
 2024 13:54:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZfG801lYHRxlhZGT@google.com> <9e604f99-5b63-44d7-8476-00859dae1dc4@amd.com>
 <ZfHKoxVMcBAMqcSC@google.com> <93df19f9-6dab-41fc-bbcd-b108e52ff50b@amd.com>
 <ZfHhqzKVZeOxXMnx@google.com> <c84fcf0a-f944-4908-b7f6-a1b66a66a6bc@amd.com>
 <d2a95b5c-4c93-47b1-bb5b-ef71370be287@amd.com> <CAD=HUj5k+N+zrv-Yybj6K3EvfYpfGNf-Ab+ov5Jv+Zopf-LJ+g@mail.gmail.com>
 <ZfMjCXZWuUD76r_5@google.com> <ZfMxj_e7M_toVR3a@google.com> <ZfSMaUFa5hsPP-eR@google.com>
In-Reply-To: <ZfSMaUFa5hsPP-eR@google.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Wed, 20 Mar 2024 13:54:07 -0700
Message-ID: <CAJHvVchGxd3ECA4mySYmUBNgq+N_4ws3aE6thSjBtjicJDJD=g@mail.gmail.com>
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
To: Sean Christopherson <seanjc@google.com>
Cc: David Stevens <stevensd@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@gmail.com>, 
	Zhi Wang <zhi.wang.linux@gmail.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 15, 2024 at 10:59=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Thu, Mar 14, 2024, Sean Christopherson wrote:
> > +Alex, who is looking at the huge-VM_PFNMAP angle in particular.
>
> Oof, *Axel*.  Sorry Axel.


No worries. Believe it or not this happens frequently. :) I'm well
past being bothered about it.

>
>
> > On Thu, Mar 14, 2024, Sean Christopherson wrote:
> > > -Christ{oph,ian} to avoid creating more noise...
> > >
> > > On Thu, Mar 14, 2024, David Stevens wrote:
> > > > Because of that, the specific type of pfns that don't work right no=
w are
> > > > pfn_valid() && !PG_Reserved && !page_ref_count() - what I called th=
e
> > > > non-refcounted pages in a bad choice of words. If that's correct, t=
hen
> > > > perhaps this series should go a little bit further in modifying
> > > > hva_to_pfn_remapped, but it isn't fundamentally wrong.
> > >
> > > Loosely related to all of this, I have a mildly ambitious idea.  Well=
, one mildly
> > > ambitious idea, and one crazy ambitious idea.  Crazy ambitious idea f=
irst...
> > >
> > > Something we (GCE side of Google) have been eyeballing is adding supp=
ort for huge
> > > VM_PFNMAP memory, e.g. for mapping large amounts of device (a.k.a. GP=
U) memory
> > > into guests using hugepages.  One of the hiccups is that follow_pte()=
 doesn't play
> > > nice with hugepages, at all, e.g. even has a "VM_BUG_ON(pmd_trans_hug=
e(*pmd))".
> > > Teaching follow_pte() to play nice with hugepage probably is doing, b=
ut making
> > > sure all existing users are aware, maybe not so much.


Right. The really basic idea I had was, to modify remap_pfn_range so
it can, if possible (if it sees a (sub)range which is aligned + big
enough), it can just install a leaf pud or pmd instead of always going
down to the pte level.

follow_pte is problematic though, because it returns a pte
specifically so it's unclear to me how to have it "just work" for
existing callers with an area mapped this way. So I think the idea
would be to change follow_pte to detect this case and bail out
(-EINVAL I guess), and then add some new function which can properly
support these mappings.

>
> > >
> > > My first (half baked, crazy ambitious) idea is to move away from foll=
ow_pte() and
> > > get_user_page_fast_only() for mmu_notifier-aware lookups, i.e. that d=
on't need
> > > to grab references, and replace them with a new converged API that lo=
cklessly walks
> > > host userspace page tables, and grabs the hugepage size along the way=
, e.g. so that
> > > arch code wouldn't have to do a second walk of the page tables just t=
o get the
> > > hugepage size.
> > >
> > > In other words, for the common case (mmu_notifier integration, no ref=
erence needed),
> > > route hva_to_pfn_fast() into the new API and walk the userspace page =
tables (probably
> > > only for write faults, to avoid CoW compliciations) before doing anyt=
hing else.
> > >
> > > Uses of hva_to_pfn() that need to get a reference to the struct page =
couldn't be
> > > converted, e.g. when stuffing physical addresses into the VMCS for ne=
sted virtualization.
> > > But for everything else, grabbing a reference is a non-goal, i.e. act=
ually "getting"
> > > a user page is wasted effort and actively gets in the way.
> > >
> > > I was initially hoping we could go super simple and use something lik=
e x86's
> > > host_pfn_mapping_level(), but there are too many edge cases in gup() =
that need to
> > > be respected, e.g. to avoid mapping memfd_secret pages into KVM guest=
s.  I.e. the
> > > API would need to be a formal mm-owned thing, not some homebrewed KVM=
 implementation.
> > >
> > > I can't tell if the payoff would be big enough to justify the effort =
involved, i.e.
> > > having a single unified API for grabbing PFNs from the primary MMU mi=
ght just be a
> > > pie-in-the-sky type idea.

Yeah, I have been thinking about this.

One thing is, KVM is not the only caller of follow_pte today. At least
naively it would be nice if any existing callers could benefit from
this new support, not just KVM.

Another thing I noticed is, most callers don't need much; they don't
need a reference to the page, they don't even really need the pte
itself. Most callers just want a ptl held, and they want to know the
pgprot flags or whether the pte is writable or not, and they want to
know the pfn for this address. IOW follow_pte is sort of overkill for
most callers.

KVM is a bit different, it does call GUP to get the page. One other
thing is, KVM at least on x86 also cares about the "level" of the
mapping, in host_pfn_mapping_level(). That code is all fairly x86
specific so I'm not sure how to generalize it. Also I haven't looked
closely at what's going on for other architectures.

I'm not sure yet where is the right place to end up, but I at least
think it's worth trying to build some general API under mm/ which
supports these various things.

In general I'm thinking of proceeding in two steps. First,
enlightening remap_pfn_range, updating follow_pte to return -EINVAL,
and then adding some new function which tries to be somewhat close to
a drop-in replacement for existing follow_pte callers. Once I get that
proof of concept working / tested, I think the next step is figuring
out how we can extend it a bit to build some more general solution
like Sean is describing here.

> > >
> > > My second, less ambitious idea: the previously linked LWN[*] article =
about the
> > > writeback issues reminded me of something that has bugged me for a lo=
ng time.  IIUC,
> > > getting a writable mapping from the primary MMU marks the page/folio =
dirty, and that
> > > page/folio stays dirty until the data is written back and the mapping=
 is made read-only.
> > > And because KVM is tapped into the mmu_notifiers, KVM will be notifie=
d *before* the
> > > RW=3D>RO conversion completes, i.e. before the page/folio is marked c=
lean.
> > >
> > > I _think_ that means that calling kvm_set_page_dirty() when zapping a=
 SPTE (or
> > > dropping any mmu_notifier-aware mapping) is completely unnecessary.  =
If that is the
> > > case, _and_ we can weasel our way out of calling kvm_set_page_accesse=
d() too, then
> > > with FOLL_GET plumbed into hva_to_pfn(), we can:
> > >
> > >   - Drop kvm_{set,release}_pfn_{accessed,dirty}(), because all caller=
s of hva_to_pfn()
> > >     that aren't tied into mmu_notifiers, i.e. aren't guaranteed to dr=
op mappings
> > >     before the page/folio is cleaned, will *know* that they hold a re=
fcounted struct
> > >     page.
> > >
> > >   - Skip "KVM: x86/mmu: Track if sptes refer to refcounted pages" ent=
irely, because
> > >     KVM never needs to know if a SPTE points at a refcounted page.
> > >
> > > In other words, double down on immediately doing put_page() after gup=
() if FOLL_GET
> > > isn't specified, and naturally make all KVM MMUs compatible with pfn_=
valid() PFNs
> > > that are acquired by follow_pte().
> > >
> > > I suspect we can simply mark pages as access when a page is retrieved=
 from the primary
> > > MMU, as marking a page accessed when its *removed* from the guest is =
rather nonsensical.
> > > E.g. if a page is mapped into the guest for a long time and it gets s=
wapped out, marking
> > > the page accessed when KVM drops its SPTEs in response to the swap ad=
ds no value.  And
> > > through the mmu_notifiers, KVM already plays nice with setups that us=
e idle page
> > > tracking to make reclaim decisions.
> > >
> > > [*] https://lwn.net/Articles/930667

