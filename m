Return-Path: <kvm+bounces-53949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ABC14B1ABAD
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 02:22:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 513F0189FE59
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 00:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 165E5128819;
	Tue,  5 Aug 2025 00:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2EQODNeP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60FA2F85B
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 00:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754353345; cv=none; b=eWkTXWi8zYjUl41SZyicB8en5C0ur5TmBtA2gU3D1HhYxUjBPxosTNRwjuhNfuY5R4+PnP/owY8uyH4UDfcRcV8tMfszpPSRpqQ085Mn1MOqgo2SsBuT//J3bff94K+gLXCCH5xNjqyM6H4/ZAOBqdtLLsWxzmx5suXCeK69vsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754353345; c=relaxed/simple;
	bh=GTYkiHK4LuEKa6unGC5o8/MLi5fCRxnx8HjDDuiebrw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pXP8p07wH4iwT2TjmjCQs14JRF/ZVEQpWL7s3HjlAjJBsPDfM3KGH9aAIX/+4nBNiU2cNYXqvvXcu45akl4RLY3RmRIOFD7esLOG+gKTvlYmmGxGRrMQo4ddM/+t2HoecxH8DBzF5tPyLVrpnICncOk3JH67qD10/ytV+1A21zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2EQODNeP; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-75ab147e0f7so4989277b3a.2
        for <kvm@vger.kernel.org>; Mon, 04 Aug 2025 17:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754353343; x=1754958143; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bWPjk1bMnsG6kZRnLxQs3s1/wB89f8uKncOvV38w/Y8=;
        b=2EQODNePh6Vuv74qIVzDwbwZqL6MeGQhXVubF9zt7KkWoFvqD/0N7CAP3iNZkU2jur
         iIOPifjnwwVhXsyRZtT7msQNn42CY3tSSvpNkPgx8CryOb6xpWSXHXPsX0nr4psTj5Rj
         3GhBkcuqBgJE81Afge9H1VwfRuppv6QLwPaAOCokDjsFLDXuzYhMw0f1qWyu8vy/CYzq
         c4K4FW8KdP49LQfaVHfiTkUA3S551NKU31i8i3hY+NFnsgdO/E5TKaIVRsM9dtYdNLRw
         4ct4LkGVGS7ttrrivV+Dc8Pyo2ZDWACeyYRQ35tUaMTSUzliePBjNl21p+EmFM9zlIKm
         TrDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754353343; x=1754958143;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bWPjk1bMnsG6kZRnLxQs3s1/wB89f8uKncOvV38w/Y8=;
        b=jpMvo3upS/Jx523pF84kwTHBq5c0PuTVBjO4QRQlzZ7ncGAqpDS2RMDyUs2DYcoAt2
         XdqRI/Tj2XLffzeBaAeAdNdhtOQS7iYDbu2/qHJWRw9UJKxWb9pJXu/BiYi7Nh2H0mHr
         BKKBXd3q/ztMpjVXTGVo20/SiXiSfVuFkDdGyoH09qV5mVJ/dPQorjU5NOxRAMhO3wI4
         8z4tOMldnEWg3vTE0vUyFYh8sUnsVBXpdnESZao3lyCtJg8R3ZdRU6oaDDPYTquaatAK
         q9qb2GTX3j2ObciAqYrLYJ+fpAmz+2m5KUeauAMZFBKcisGxtU6/QxumLuQRNJNRN77z
         3ydg==
X-Forwarded-Encrypted: i=1; AJvYcCXsFqDX0u4uUfyoAfoKWN4uSUS7XmVIb3DJVVIdXVFuhLrgMu7oczzy1MIyyu57w4VCPP0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3S14fOUuueK0wMImxKADemLyHlIBQ/WDkXv/NWaOH54J54FzR
	3vCtQ1KwghDVmz05+Uf5iy11IDzNUwK8kIoZFWAUT7YAGXLxfgsN3Ezpw3KU6NG5UM+T97UvSxU
	YLiaNkg==
X-Google-Smtp-Source: AGHT+IGAzTZpbOI4XqoyR/bUkResNIws7778susHgMvqpi2UL/IvSnHeUCN8Egv3XK4V/yzP0XNLaqejD5U=
X-Received: from pfbhj8.prod.google.com ([2002:a05:6a00:8708:b0:76b:fefc:8d72])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:14d3:b0:76b:f9c9:2160
 with SMTP id d2e1a72fcca58-76bf9c93355mr10484381b3a.6.1754353342932; Mon, 04
 Aug 2025 17:22:22 -0700 (PDT)
Date: Mon, 4 Aug 2025 17:22:15 -0700
In-Reply-To: <6888f7e4129b9_ec573294fa@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aHEwT4X0RcfZzHlt@google.com> <aHSgdEJpY/JF+a1f@yzhao56-desk>
 <aHUmcxuh0a6WfiVr@google.com> <aHWqkodwIDZZOtX8@yzhao56-desk>
 <aHoQa4dBSi877f1a@yzhao56-desk.sh.intel.com> <CAGtprH9kwV1RCu9j6LqToa5M97_aidGN2Lc2XveQdeR799SK6A@mail.gmail.com>
 <aIdHdCzhrXtwVqAO@yzhao56-desk.sh.intel.com> <CAGtprH-xGHGfieOCV2xJen+GG66rVrpFw_s9jdWABuLQ2hos5A@mail.gmail.com>
 <aIgl7pl5ZiEJKpwk@yzhao56-desk.sh.intel.com> <6888f7e4129b9_ec573294fa@iweiny-mobl.notmuch>
Message-ID: <aJFOt64k2EFjaufd@google.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from kvm_gmem_populate()
From: Sean Christopherson <seanjc@google.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Michael Roth <michael.roth@amd.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	adrian.hunter@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@intel.com, binbin.wu@linux.intel.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, david@redhat.com, ackerleytng@google.com, 
	tabba@google.com, chao.p.peng@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2025, Ira Weiny wrote:
> Yan Zhao wrote:
> > On Mon, Jul 28, 2025 at 05:45:35PM -0700, Vishal Annapurve wrote:
> > > On Mon, Jul 28, 2025 at 2:49=E2=80=AFAM Yan Zhao <yan.y.zhao@intel.co=
m> wrote:
> > > >
> > > > On Fri, Jul 18, 2025 at 08:57:10AM -0700, Vishal Annapurve wrote:
> > > > > On Fri, Jul 18, 2025 at 2:15=E2=80=AFAM Yan Zhao <yan.y.zhao@inte=
l.com> wrote:
> > > > > >
> > > > > > On Tue, Jul 15, 2025 at 09:10:42AM +0800, Yan Zhao wrote:
> > > > > > > On Mon, Jul 14, 2025 at 08:46:59AM -0700, Sean Christopherson=
 wrote:
> > > > > > > > > >         folio =3D __kvm_gmem_get_pfn(file, slot, index,=
 &pfn, &is_prepared, &max_order);
> > > > > > > > > If max_order > 0 is returned, the next invocation of __kv=
m_gmem_populate() for
> > > > > > > > > GFN+1 will return is_prepared =3D=3D true.
> > > > > > > >
> > > > > > > > I don't see any reason to try and make the current code tru=
ly work with hugepages.
> > > > > > > > Unless I've misundertood where we stand, the correctness of=
 hugepage support is
> > > > > > > Hmm. I thought your stand was to address the AB-BA lock issue=
 which will be
> > > > > > > introduced by huge pages, so you moved the get_user_pages() f=
rom vendor code to
> > > > > > > the common code in guest_memfd :)
> > > > > > >
> > > > > > > > going to depend heavily on the implementation for preparedn=
ess.  I.e. trying to
> > > > > > > > make this all work with per-folio granulartiy just isn't po=
ssible, no?
> > > > > > > Ah. I understand now. You mean the right implementation of __=
kvm_gmem_get_pfn()
> > > > > > > should return is_prepared at 4KB granularity rather than per-=
folio granularity.
> > > > > > >
> > > > > > > So, huge pages still has dependency on the implementation for=
 preparedness.
> > > > > > Looks with [3], is_prepared will not be checked in kvm_gmem_pop=
ulate().
> > > > > >
> > > > > > > Will you post code [1][2] to fix non-hugepages first? Or can =
I pull them to use
> > > > > > > as prerequisites for TDX huge page v2?
> > > > > > So, maybe I can use [1][2][3] as the base.
> > > > > >
> > > > > > > [1] https://lore.kernel.org/all/aG_pLUlHdYIZ2luh@google.com/
> > > > > > > [2] https://lore.kernel.org/all/aHEwT4X0RcfZzHlt@google.com/
> > > >
> > > > From the PUCK, looks Sean said he'll post [1][2] for 6.18 and Micha=
el will post
> > > > [3] soon.
> > > >
> > > > hi, Sean, is this understanding correct?
> > > >
> > > > > IMO, unless there is any objection to [1], it's un-necessary to
> > > > > maintain kvm_gmem_populate for any arch (even for SNP). All the
> > > > > initial memory population logic needs is the stable pfn for a giv=
en
> > > > > gfn, which ideally should be available using the standard mechani=
sms
> > > > > such as EPT/NPT page table walk within a read KVM mmu lock (This =
patch
> > > > > already demonstrates it to be working).
> > > > >
> > > > > It will be hard to clean-up this logic once we have all the
> > > > > architectures using this path.
> > > > >
> > > > > [1] https://lore.kernel.org/lkml/CAGtprH8+x5Z=3DtPz=3DNcrQM6Dor2A=
YBu3jiZdo+Lg4NqAk0pUJ3w@mail.gmail.com/
> > > > IIUC, the suggestion in the link is to abandon kvm_gmem_populate().
> > > > For TDX, it means adopting the approach in this RFC patch, right?
> > > Yes, IMO this RFC is following the right approach as posted.

I don't think we want to abandon kvm_gmem_populate().  Unless I'm missing s=
omething,
SNP has the same AB-BA problem as TDX.  The copy_from_user() on @src can tr=
igger
a page fault, and resolving the page fault may require taking mm->mmap_lock=
.

Fundamentally, TDX and SNP are doing the same thing: copying from source to=
 guest
memory.  The only differences are in the mechanics of the copy+encrypt, eve=
rything
else is the same.  I.e. I don't expect that we'll find a magic solution tha=
t works
well for one and not the other.

I also don't want to end up with wildly different ABI for SNP vs. everythin=
g else.
E.g. cond_resched() needs to be called if the to-be-initialzied range is la=
rge,
which means dropping mmu_lock between pages, whereas kvm_gmem_populate() ca=
n
yield without dropping invalidate_lock, which means that the behavior of po=
pulating
guest_memfd memory will be quite different with respect to guest_memfd oper=
ations.

Pulling in the RFC text:

: I think the only different scenario is SNP, where the host must write
: initial contents to guest memory.
:=20
: Will this work for all cases CCA/SNP/TDX during initial memory
: population from within KVM:
: 1) Simulate stage2 fault
: 2) Take a KVM mmu read lock

Doing all of this under mmu_lock is pretty much a non-starter.

: 3) Check that the needed gpa is mapped in EPT/NPT entries

No, KVM's page tables are not the source of truth.  S-EPT is a special snow=
flake,
and I'd like to avoid foisting the same requirements on NPT.

: 4) For SNP, if src !=3D null, make the target pfn to be shared, copy
: contents and then make the target pfn back to private.

Copying from userspace under spinlock (rwlock) is illegal, as accessing use=
rspace
memory might_fault() and thus might_sleep().

: 5) For TDX, if src !=3D null, pass the same address for source and
: target (likely this works for CCA too)
: 6) Invoke appropriate memory encryption operations
: 7) measure contents
: 8) release the KVM mmu read lock
:=20
: If this scheme works, ideally we should also not call RMP table
: population logic from guest_memfd, but from KVM NPT fault handling
: logic directly (a bit of cosmetic change).=20

LOL, that's not a cosmetic change.  It would be a non-trivial ABI change as=
 KVM's
ABI (ignoring S-EPT) is that userspace can delete and recreate memslots at =
will.

: Ideally any outgoing interaction from guest_memfd to KVM should be only v=
ia
  invalidation notifiers.

Why?  It's all KVM code.  I don't see how this is any different than e.g. c=
ommon
code, arch code, and vendor code all calling into one another.  Artificiall=
y
limiting guest_memfd to a super generic interface pretty much defeats the w=
hole
purpose of having KVM provide a backing store.

> > Ira has been investigating this for a while, see if he has any comment.
>=20
> So far I have not seen any reason to keep kvm_gmem_populate() either.
>=20
> Sean, did yall post the patch you suggested here and I missed it?

No, I have a partially baked patch, but I've been trying to finish up v5 of=
 the
mediated PMU series and haven't had time to focus on this.  Hopefully I'll =
post
a compile-tested patch later this week.

