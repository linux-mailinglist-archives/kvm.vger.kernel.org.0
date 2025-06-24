Return-Path: <kvm+bounces-50527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8150FAE6DDF
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 19:50:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E68D516E85A
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 17:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B80492E3B16;
	Tue, 24 Jun 2025 17:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o0QwmnT8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7147F221FD2
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 17:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750787444; cv=none; b=PeQHgMxghUyGzNzhzByPeZhDgEB6zKP9Se2nvxDT2lZVktHyCHdAhv3hldmt+OBqkV7Dku3tsnmPwgxzRwx8ZvwI3C1EHuT4J0oFXUeRAG6j8nDn1Bk/FGlCV6zifmJ7Eg8KBwngWoJvpyPD6ywkN/KKfuP3pktF+7aruAaRXGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750787444; c=relaxed/simple;
	bh=zvusT+EwbJnfWdzCvqB4CYbGs4mtqTDF968Xj9rM9E0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l6ZxPDwnwLxdp/qQ/Ap0UExtqkDHXwQ7DsuXXLf3WOmEcTR8hg6puS4zqnC9d8n5CeqtHMaMOwrnP2FTjK79+i8hwNdBI9R/wivL2RgQyVw3tYl0mLe089F0tV43rHtyKm5svCwG8USipNeEUyG/hyaSbvvl9SFADmH3njEIZM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o0QwmnT8; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31ff607527so2892677a12.0
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 10:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750787442; x=1751392242; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JfToG4W/8T4MN37HjczsbaeM2xUggUJm/FAUuhEMyM0=;
        b=o0QwmnT8Qy/5FM/pV3tJI45iUeNleMMz58gE1QUwhPlDf0h9b4UxpuvOWHgincf/ff
         7SVF2TJlrVTxm/U7RV42SVetRbaD6WEVGtCQe5phr7qTkEKdfENm71lITk5tO8hxx8Tn
         HhruRvIgGG+9Xo0pENmr/CEG6dSWu4krbF9VtkL1AJ/aJsT+ZuyDOQrmZ6cfeig8axzJ
         vVVKyW1WvdBz8Zw5iAsRW1LopV5s5ZEu2fo5h979KkqNjCQ5neHAP3TDARJ1YmxOnUtg
         pEeId+zcv0UIFI76REOcH6jDaSXcJicGo7jHwS+2YlChz/W4bQUHH0PNZLs7GjyEqZ5s
         o7+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750787442; x=1751392242;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JfToG4W/8T4MN37HjczsbaeM2xUggUJm/FAUuhEMyM0=;
        b=bpUK7P7liA+hboY+h7lgPYe4p7I8zVYUcP1IC2dJdEgCFUD+7Fn72F2mLcAroB8Bu5
         tiFW1Q8pT6u9tuXP+VzaM11EJxBTn5Lo26OyK3q0M+5C6D29VMo3UlaB07rqev64OlYU
         6wQUr4v61LcYfR07mvisQ0KD2o4WOkwxVV3l3bPgbvTb16/7SE3cbqeHexRg2EL2Js3g
         iiSKOUmmDAexOaX+skS5bbPuDxEBplSfaibdSlsZor44XFFXCkmQ+h5iTgX3t0r53F2n
         mpCb80Nbdehw4BzgvyEPnXTzhmz2j5u1M5T92PcrvlxbdH/XOICkkUcDkHEAAt77Zjiz
         hHXA==
X-Forwarded-Encrypted: i=1; AJvYcCWUK5dXgYwEPPFAQLTdTp05tkf7If0TSvNFcc+BF/2L2UOqneBv3p3mVt7wPgcIqz3mxwg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCOhTsyfb0SqTwB53ihyT9rOAhIDpBO7YVHcz2LUMSiKyOa4VP
	n47Dyf2vvio9DITbb4/82xzpFFss01f8keLhgCXZVi7rGU0xpU8epJqxd0TKs6cafSnywes8Ttq
	chJXTtw==
X-Google-Smtp-Source: AGHT+IHcTeFnioFY8M93iMUzLc4QtOv451+sf1rj5bXR4qDBc1fgUxAPuE+TJu11BtZIFYPrgJNb4J/QJco=
X-Received: from plbkr7.prod.google.com ([2002:a17:903:807:b0:234:8ec2:bf02])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:da88:b0:234:a139:1216
 with SMTP id d9443c01a7336-23824087149mr3780495ad.44.1750787442548; Tue, 24
 Jun 2025 10:50:42 -0700 (PDT)
Date: Tue, 24 Jun 2025 10:50:41 -0700
In-Reply-To: <CA+EHjTyginj74a+A58aAODZ72q9bye5Gm=pTxMmLHrqrRxaSww@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <80e062dd-2445-45a6-ba4a-8f5fe3286909@redhat.com>
 <CA+EHjTx2MUq98=j=5J+GwSJ1gd7ax-RrpS8WhEJg4Lk9_USUmA@mail.gmail.com>
 <372bbfa5-1869-4bf2-9c16-0b828cdb86f5@redhat.com> <CA+EHjTyxwdu5YhtZRcwb-iR7aaEq1beV+4VWSsv7-X2tDVBkrA@mail.gmail.com>
 <11b23ea3-cadd-442b-88d7-491bba99dabe@redhat.com> <CA+EHjTyginj74a+A58aAODZ72q9bye5Gm=pTxMmLHrqrRxaSww@mail.gmail.com>
Message-ID: <aFrlcYYM5k5kstUO@google.com>
Subject: Re: [PATCH v12 00/18] KVM: Mapping guest_memfd backed memory at the
 host for software protected VMs
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 24, 2025, Fuad Tabba wrote:
> On Tue, 24 Jun 2025 at 12:44, David Hildenbrand <david@redhat.com> wrote:
> >
> > On 24.06.25 12:25, Fuad Tabba wrote:
> > > Hi David,
> > >
> > > On Tue, 24 Jun 2025 at 11:16, David Hildenbrand <david@redhat.com> wrote:
> > >>
> > >> On 24.06.25 12:02, Fuad Tabba wrote:
> > >>> Hi,
> > >>>
> > >>> Before I respin this, I thought I'd outline the planned changes for
> > >>> V13, especially since it involves a lot of repainting. I hope that
> > >>> by presenting this first, we could reduce the number of times I'll
> > >>> need to respin it.
> > >>>
> > >>> In struct kvm_arch: add bool supports_gmem instead of renaming
> > >>> has_private_mem
> > >>>
> > >>> The guest_memfd flag GUEST_MEMFD_FLAG_SUPPORT_SHARED should be
> > >>> called GUEST_MEMFD_FLAG_MMAP
> > >>>
> > >>> The memslot internal flag KVM_MEMSLOT_SUPPORTS_GMEM_SHARED should be
> > >>> called KVM_MEMSLOT_SUPPORTS_GMEM_MMAP

This one...

> > >>> kvm_arch_supports_gmem_shared_mem() should be called
> > >>> kvm_arch_supports_gmem_mmap()
> > >>>
> > >>> kvm_gmem_memslot_supports_shared() should be called
> > >>> kvm_gmem_memslot_supports_mmap()

...and this one are the only names I don't like.  Explanation below.

> > >>> Rename  kvm_slot_can_be_private() to kvm_slot_has_gmem(): since
> > >>> private does imply that it has gmem
> > >>
> > >> Right. It's a little more tricky in reality at least with this series:
> > >> without in-place conversion, not all gmem can have private memory. But
> > >> the places that check kvm_slot_can_be_private() likely only care about
> > >> if this memslot is backed by gmem.
> > >
> > > Exactly. Reading the code, all the places that check
> > > kvm_slot_can_be_private() are really checking whether the slot has gmem.

Yeah, I'm fine with this change.  There are a few KVM x86 uses where
kvm_slot_can_be_private() is slightly better in a vacuum, but in all but one of
those cases, the check immediately gates a kvm_gmem_xxx() call.  I.e. when
looking at the code as a whole, I think kvm_slot_has_gmem() will be easier for
new readers to understand.

The only outlier is kvm_mmu_max_mapping_level(), but that'll probably get ripped
apart by this series, i.e. I'm guessing kvm_slot_has_gmem() will probably work
out better there too.

> > > After this series, if a caller is interested in finding out whether a
> > > slot can be private could achieve the same effect by checking that a gmem
> > > slot doesn't support mmap (i.e., kvm_slot_has_gmem() &&
> > > kvm_arch_supports_gmem_mmap() ). If that happens, we can reintroduce
> > > kvm_slot_can_be_private() as such.
> > >
> > > Otherwise, I could keep it and already define it as so. What do you think?
> > >
> > >> Sean also raised a "kvm_is_memslot_gmem_only()", how did you end up
> > >> calling that?
> > >
> > > Good point, I'd missed that. Isn't it true that
> > > kvm_is_memslot_gmem_only() is synonymous (at least for now) with
> > > kvm_gmem_memslot_supports_mmap()?
> >
> > Yes. I think having a simple kvm_is_memslot_gmem_only() helper might
> > make fault handling code easier to read, though.

Yep, exactly.  The fact that a memslot is bound to a guest_memfd instance that
supports mmap() isn't actually what KVM cares about.  The important part is that
the userspace_addr in the memslot needs to be ignored when mapping memory into
the guest, because the bound guest_memfd is the single source of truth for guest
mappings.

E.g. userspace could actually point userspace_addr at a completely different
mapping, in which case walking the userspace page tables to get the max mapping
size would be all kinds of wrong.

KVM will still use userspace_addr when access guest memory from within KVM,
but that's not dangerous to the host kernel/KVM, only to the guest (and userspace
is firmly in the TCB for that side of things).

So I think KVM_MEMSLOT_IS_GMEM_ONLY and kvm_is_memslot_gmem_only()?

Those names are technically not entirely true, because as above, there is no
guarantee that userspace_addr actually points at the bound guest_memfd.  But
for all intents and purposes, that will hold true for all non-buggy setups.

