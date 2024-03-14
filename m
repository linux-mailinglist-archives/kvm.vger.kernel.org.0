Return-Path: <kvm+bounces-11803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2495C87C11A
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 17:17:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A42141F22729
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 16:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 109BE73529;
	Thu, 14 Mar 2024 16:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r6o4tyn2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFB07318B
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 16:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710433038; cv=none; b=uExFZNrfE5wAqrILWngBo+LhFcjEYx+rU+gYRlAymz82tbqgmlRAX7/3mNBpoRt+41XTrws13pBOd8rc4DLkbafzUphJ2aJQUK7kmbF9MMt7U0bd3EnbZwhHxgNjiCIz0qVmKa8wx40GdNv+zYLhnh7Elz6G7ia2g+oFAlnoFbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710433038; c=relaxed/simple;
	bh=sz96ucSlpxY0fStS++TYywmUfo9RtayZN4KhGhuC0tg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sgHH/pn8sltiBV/rIUUqm5rL9abIeO05FYNNf14hk7gonCRBxzpt5vPq69vRxXzodvwWEYi8iqudaCCp5X3bJH+8ggX0S45DCJEYpJBl6veWpEIBWU5sUIaLAcVyGMD0ezwme4wEPZSAiBp6By73+msuWOWgVuIxjEHu5jH9wuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r6o4tyn2; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc647f65573so1878242276.2
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 09:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710433035; x=1711037835; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U+ZIbp6HNyG0E4TQ0X2k6SxB0un7ns3x5HKX2GIis+s=;
        b=r6o4tyn2xo+spYXEmnzz7UVtLuygO3Ova90EuzqeZDrpT2TxMh+Mx6UnLANuKtzlQF
         NwdQ2aUzOguD23vyMbk6QuDKyKNO36qD4FkvF/B99kCxlChPqiSTGOiwSMo4bbhAvlF8
         xvSAeOToB7JDgqZf/cA66tkKb8OMy5k2nFzsJaRMaBVxcdB+AW7Fqem427AVsz6Lfqkb
         GaJcHhQ5yStX7jXnuWnNGdeQdFVK/Z/bxobaQHtvdxOJJlyvz0OxrILlUWovwADQSnmU
         0SZ81u4xdx1P2T8TToNFmrY9O6an5i6xqVD/Xr8MNDmFQuX7/DHFp4ZlUK0mWHT8N8ns
         WCzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710433035; x=1711037835;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U+ZIbp6HNyG0E4TQ0X2k6SxB0un7ns3x5HKX2GIis+s=;
        b=SWPm/ZhV5RHPce4ti+X46CEu3GQe2Dw4Z4Y2tbrVYwKgWMSBTtlqv1li9+pvl4rur3
         9ku5LBvrXyWyaO73VSrtjzhAW/5ar4VVhtrweAtyy6tw/Y276IFZY4PHE4r0uDCwcqvi
         a7NVUqL83y9QFk2W/ef2Ue1c+jfuwAmHLIfIYsh+BGUNeGhptBV/jv8+mwTYmgJ5x3O1
         sGdBg40rF+ECs59YGx3Ba697nGPC064rFtHfjQCCmy5ICMgTqOE7QlShkJRJOqjxWsaO
         SwWVX8cHsAMPlsVMVsYh9hAlWw8arr3SIs9EXOAJb3Ck1rF20FbMU2BSIDTUYfYDut/M
         an8w==
X-Forwarded-Encrypted: i=1; AJvYcCXGEFz2hjgh2UqygDDSYWsFtYmvNDLAnJU/fU+08PYsRRRQhRYEPJFszg6i+Cfe6AeachkL4sHrXslg/JKonb91HPsb
X-Gm-Message-State: AOJu0Yyko1ciiJnROAyvi+YHhLDfJ6Jf/p84jdGtfZ4vxesXdTLel9M9
	Pn5YbTS9lV4BmIlgnIF4J0ZCrd4Dk2fjsiRRhofm3JuzDbARGHozMbwNczlFcL6SQFb3K6oFT/3
	z7w==
X-Google-Smtp-Source: AGHT+IFj6zsz6UprtwwuVeWzWxsr2V9qe7+sAPM1bdWCJoRKSwnUj5UGCGfLBihDdD5DId2z6mWdKFp6P1E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2783:b0:dc7:48ce:d17f with SMTP id
 eb3-20020a056902278300b00dc748ced17fmr615498ybb.10.1710433035389; Thu, 14 Mar
 2024 09:17:15 -0700 (PDT)
Date: Thu, 14 Mar 2024 09:17:13 -0700
In-Reply-To: <CAD=HUj5k+N+zrv-Yybj6K3EvfYpfGNf-Ab+ov5Jv+Zopf-LJ+g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZfGrS4QS_WhBWiDl@google.com> <0b109bc4-ee4c-4f13-996f-b89fbee09c0b@amd.com>
 <ZfG801lYHRxlhZGT@google.com> <9e604f99-5b63-44d7-8476-00859dae1dc4@amd.com>
 <ZfHKoxVMcBAMqcSC@google.com> <93df19f9-6dab-41fc-bbcd-b108e52ff50b@amd.com>
 <ZfHhqzKVZeOxXMnx@google.com> <c84fcf0a-f944-4908-b7f6-a1b66a66a6bc@amd.com>
 <d2a95b5c-4c93-47b1-bb5b-ef71370be287@amd.com> <CAD=HUj5k+N+zrv-Yybj6K3EvfYpfGNf-Ab+ov5Jv+Zopf-LJ+g@mail.gmail.com>
Message-ID: <ZfMjCXZWuUD76r_5@google.com>
Subject: Re: [PATCH v11 0/8] KVM: allow mapping non-refcounted pages
From: Sean Christopherson <seanjc@google.com>
To: David Stevens <stevensd@chromium.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Isaku Yamahata <isaku.yamahata@gmail.com>, Zhi Wang <zhi.wang.linux@gmail.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

-Christ{oph,ian} to avoid creating more noise...

On Thu, Mar 14, 2024, David Stevens wrote:
> Because of that, the specific type of pfns that don't work right now are
> pfn_valid() && !PG_Reserved && !page_ref_count() - what I called the
> non-refcounted pages in a bad choice of words. If that's correct, then
> perhaps this series should go a little bit further in modifying
> hva_to_pfn_remapped, but it isn't fundamentally wrong.

Loosely related to all of this, I have a mildly ambitious idea.  Well, one mildly
ambitious idea, and one crazy ambitious idea.  Crazy ambitious idea first...

Something we (GCE side of Google) have been eyeballing is adding support for huge
VM_PFNMAP memory, e.g. for mapping large amounts of device (a.k.a. GPU) memory
into guests using hugepages.  One of the hiccups is that follow_pte() doesn't play
nice with hugepages, at all, e.g. even has a "VM_BUG_ON(pmd_trans_huge(*pmd))".
Teaching follow_pte() to play nice with hugepage probably is doing, but making
sure all existing users are aware, maybe not so much.

My first (half baked, crazy ambitious) idea is to move away from follow_pte() and
get_user_page_fast_only() for mmu_notifier-aware lookups, i.e. that don't need
to grab references, and replace them with a new converged API that locklessly walks
host userspace page tables, and grabs the hugepage size along the way, e.g. so that
arch code wouldn't have to do a second walk of the page tables just to get the
hugepage size.

In other words, for the common case (mmu_notifier integration, no reference needed),
route hva_to_pfn_fast() into the new API and walk the userspace page tables (probably
only for write faults, to avoid CoW compliciations) before doing anything else.

Uses of hva_to_pfn() that need to get a reference to the struct page couldn't be
converted, e.g. when stuffing physical addresses into the VMCS for nested virtualization.
But for everything else, grabbing a reference is a non-goal, i.e. actually "getting"
a user page is wasted effort and actively gets in the way.

I was initially hoping we could go super simple and use something like x86's
host_pfn_mapping_level(), but there are too many edge cases in gup() that need to
be respected, e.g. to avoid mapping memfd_secret pages into KVM guests.  I.e. the
API would need to be a formal mm-owned thing, not some homebrewed KVM implementation.

I can't tell if the payoff would be big enough to justify the effort involved, i.e.
having a single unified API for grabbing PFNs from the primary MMU might just be a
pie-in-the-sky type idea.

My second, less ambitious idea: the previously linked LWN[*] article about the
writeback issues reminded me of something that has bugged me for a long time.  IIUC,
getting a writable mapping from the primary MMU marks the page/folio dirty, and that
page/folio stays dirty until the data is written back and the mapping is made read-only.
And because KVM is tapped into the mmu_notifiers, KVM will be notified *before* the
RW=>RO conversion completes, i.e. before the page/folio is marked clean.

I _think_ that means that calling kvm_set_page_dirty() when zapping a SPTE (or
dropping any mmu_notifier-aware mapping) is completely unnecessary.  If that is the
case, _and_ we can weasel our way out of calling kvm_set_page_accessed() too, then
with FOLL_GET plumbed into hva_to_pfn(), we can:

  - Drop kvm_{set,release}_pfn_{accessed,dirty}(), because all callers of hva_to_pfn()
    that aren't tied into mmu_notifiers, i.e. aren't guaranteed to drop mappings
    before the page/folio is cleaned, will *know* that they hold a refcounted struct
    page.

  - Skip "KVM: x86/mmu: Track if sptes refer to refcounted pages" entirely, because
    KVM never needs to know if a SPTE points at a refcounted page.

In other words, double down on immediately doing put_page() after gup() if FOLL_GET
isn't specified, and naturally make all KVM MMUs compatible with pfn_valid() PFNs
that are acquired by follow_pte().

I suspect we can simply mark pages as access when a page is retrieved from the primary
MMU, as marking a page accessed when its *removed* from the guest is rather nonsensical.
E.g. if a page is mapped into the guest for a long time and it gets swapped out, marking
the page accessed when KVM drops its SPTEs in response to the swap adds no value.  And
through the mmu_notifiers, KVM already plays nice with setups that use idle page
tracking to make reclaim decisions.

[*] https://lwn.net/Articles/930667

