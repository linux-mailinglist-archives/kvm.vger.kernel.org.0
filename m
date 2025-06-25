Return-Path: <kvm+bounces-50635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92F6DAE7952
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 10:01:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D91363A7AC5
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 08:00:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EB5C20B1F5;
	Wed, 25 Jun 2025 08:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kgdcbtQ+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FB01DF25D
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 08:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750838467; cv=none; b=tSoDQfMAc2qbr7F3DbZFsLaTEiqDWDx71uAEkUcPS4LFdVVwrJI8iVigoKDUF/UvSMPJcifCRZSlCo9De1U6klHY1JG5XVYsKrBFaVoQqrIkQkqCCCGKq78IqLAk6ywFV3fXlTNS/BTSN9yCZ/AMgfm3YIUOV2dVqAlxqMJyUdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750838467; c=relaxed/simple;
	bh=tJ84ame5uiAFGLHTvwxXieWj1I5PmlAvpENctmLN3rM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d6kO9g6MlklNJojZUNmA23RsMRzKlJzaLoeaZYZhiDVqSxPwP3lso+ywTvcY5JTXjk1ud4E4EOyTKX9kHrMrbGMY77FAvMU9P4bgj82qV8u/ex4DDbAKoxRblsGwmAhY3FLkW8ik6USqnug1wxrUQ02V+VpqlXeKGF/pTT5UMko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kgdcbtQ+; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4a58197794eso111391cf.1
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 01:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750838465; x=1751443265; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pkejM18C3GfrxytsVF12qg6ifmp82uJ44inAGNHh7OU=;
        b=kgdcbtQ+MBzu3FVclZ66c4IA7rWz8L6Gco4jld7iRq5c88RrTh3q0wuTokPfuUeVnH
         Ac/3HjcZMCH39P6sj9uwTodaVImHqvRRzwq0oVlYGOU5a/fFRr7m4fdyFcbw3wLon1Lt
         X1RR2QvmHpqhzsMdRo4X3I9bqyASC0YZswWW0YzWoDJtbupllSntJm1/3XnejVxjEPiT
         K44DyqBah5o6CuNpI8aUOCuyzZ+LIX59Z/2/obnIi6M6oTYhV73bdlaVTVV7B4PZhcnP
         EmApyY8U0ybSQalRjuRqh72EbwDDZrUebLcq8ayeCwgQr8Zz6MwfPO8KAF3JbCfRjhkB
         xDBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750838465; x=1751443265;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pkejM18C3GfrxytsVF12qg6ifmp82uJ44inAGNHh7OU=;
        b=BJQBvlF2AzA6ODTKGyO/+4mZkRU8Lh1discB9aL3BHbLvJpcr4ehvYYpAV+cLI4VFX
         AtVTbzzDWK3M5adC8bpAr7i+ra+c7jEPomBy1UDPP3LxbKH78CMGuSeWdkxeI0g+cXSQ
         0Zxiru33XorYEBC/PscU+d5hBf/TPK99RYcpVeJYGF7Qa28OKuRTRdoloYML1O7gpykl
         WfzDzIM6GZqUjX3DK6OLqIyvoT1OwOlUgrFkFgEQnn2PskRR4tTX4erEbLOPIJlGw+Uo
         oF0J3U3+tP23fNK/w8Y0+t4jMBuHrKEJ963bskoElfevLCl6wH4clhBy9GNi8XwjkJJu
         Yrng==
X-Forwarded-Encrypted: i=1; AJvYcCXgrN93xdHlUiss1LzDzCp626Jegz3Th2LMlwnMlrJIounPlfMErsxIytbWrTaVUBewICs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0zlJOI9BQK1VDaEhIXZR0Y3+W6/+S9IE1nXKKaeQLigf4X7K5
	Ro7hh336k7UFmgAaXDhfMI9xO/hgGYDJJPuVoByj/mC8VDxxh6HSBeUFXTj0HrN8ID7wk1/zg2Z
	f0EEjqIz6YOKGTPhddDHVBhcUfxD26yqh3PMZ/AcQ
X-Gm-Gg: ASbGncvGY3G5uAjRa9RPxdno0lEKOHWWyca9WURBiGk0DYBJxFdNHZXJEa8PcU5aIMl
	Kk/fHkj2FhLxCSbLQ5+FvJcnm8fWUDjx+xc9rwnqR/m4dtQ4C7Arz9KKm8UGmUW7NdkuPWePfFg
	Brt0giLTBqknuMcVSmg5mw8/AnoUXnrXmtsBfZe+BPbUj/n8rW8klmo0BLSpt++nWQ7IaV9pdr
X-Google-Smtp-Source: AGHT+IE2Z7ybLIm8G7t7Cyt3+6pzdghtibzBxlp3eQYjFPTUgErAfVsE5Z7imWnMwgGVA5CdNcPQ+V+dHuEnxerz1hc=
X-Received: by 2002:a05:622a:9010:b0:4a5:9b0f:9a54 with SMTP id
 d75a77b69052e-4a7c2378969mr1821891cf.18.1750838464297; Wed, 25 Jun 2025
 01:01:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <80e062dd-2445-45a6-ba4a-8f5fe3286909@redhat.com>
 <CA+EHjTx2MUq98=j=5J+GwSJ1gd7ax-RrpS8WhEJg4Lk9_USUmA@mail.gmail.com>
 <372bbfa5-1869-4bf2-9c16-0b828cdb86f5@redhat.com> <CA+EHjTyxwdu5YhtZRcwb-iR7aaEq1beV+4VWSsv7-X2tDVBkrA@mail.gmail.com>
 <11b23ea3-cadd-442b-88d7-491bba99dabe@redhat.com> <CA+EHjTyginj74a+A58aAODZ72q9bye5Gm=pTxMmLHrqrRxaSww@mail.gmail.com>
 <aFrlcYYM5k5kstUO@google.com>
In-Reply-To: <aFrlcYYM5k5kstUO@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 25 Jun 2025 09:00:27 +0100
X-Gm-Features: Ac12FXyOZYq0_oSfy0HtoaRPA-7sk9XG35u6SnLqNIC2Y6Zwbb2K7V88hLfiL88
Message-ID: <CA+EHjTygKUN8xYM10sVHFDpV5GDZJLGK2JaFPbLhB1pHU7jAkw@mail.gmail.com>
Subject: Re: [PATCH v12 00/18] KVM: Mapping guest_memfd backed memory at the
 host for software protected VMs
To: Sean Christopherson <seanjc@google.com>
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
Content-Type: text/plain; charset="UTF-8"

Thanks Sean,

On Tue, 24 Jun 2025 at 18:50, Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jun 24, 2025, Fuad Tabba wrote:
> > On Tue, 24 Jun 2025 at 12:44, David Hildenbrand <david@redhat.com> wrote:
> > >
> > > On 24.06.25 12:25, Fuad Tabba wrote:
> > > > Hi David,
> > > >
> > > > On Tue, 24 Jun 2025 at 11:16, David Hildenbrand <david@redhat.com> wrote:
> > > >>
> > > >> On 24.06.25 12:02, Fuad Tabba wrote:
> > > >>> Hi,
> > > >>>
> > > >>> Before I respin this, I thought I'd outline the planned changes for
> > > >>> V13, especially since it involves a lot of repainting. I hope that
> > > >>> by presenting this first, we could reduce the number of times I'll
> > > >>> need to respin it.
> > > >>>
> > > >>> In struct kvm_arch: add bool supports_gmem instead of renaming
> > > >>> has_private_mem
> > > >>>
> > > >>> The guest_memfd flag GUEST_MEMFD_FLAG_SUPPORT_SHARED should be
> > > >>> called GUEST_MEMFD_FLAG_MMAP
> > > >>>
> > > >>> The memslot internal flag KVM_MEMSLOT_SUPPORTS_GMEM_SHARED should be
> > > >>> called KVM_MEMSLOT_SUPPORTS_GMEM_MMAP
>
> This one...
>
> > > >>> kvm_arch_supports_gmem_shared_mem() should be called
> > > >>> kvm_arch_supports_gmem_mmap()
> > > >>>
> > > >>> kvm_gmem_memslot_supports_shared() should be called
> > > >>> kvm_gmem_memslot_supports_mmap()
>
> ...and this one are the only names I don't like.  Explanation below.
>
> > > >>> Rename  kvm_slot_can_be_private() to kvm_slot_has_gmem(): since
> > > >>> private does imply that it has gmem
> > > >>
> > > >> Right. It's a little more tricky in reality at least with this series:
> > > >> without in-place conversion, not all gmem can have private memory. But
> > > >> the places that check kvm_slot_can_be_private() likely only care about
> > > >> if this memslot is backed by gmem.
> > > >
> > > > Exactly. Reading the code, all the places that check
> > > > kvm_slot_can_be_private() are really checking whether the slot has gmem.
>
> Yeah, I'm fine with this change.  There are a few KVM x86 uses where
> kvm_slot_can_be_private() is slightly better in a vacuum, but in all but one of
> those cases, the check immediately gates a kvm_gmem_xxx() call.  I.e. when
> looking at the code as a whole, I think kvm_slot_has_gmem() will be easier for
> new readers to understand.
>
> The only outlier is kvm_mmu_max_mapping_level(), but that'll probably get ripped
> apart by this series, i.e. I'm guessing kvm_slot_has_gmem() will probably work
> out better there too.
>
> > > > After this series, if a caller is interested in finding out whether a
> > > > slot can be private could achieve the same effect by checking that a gmem
> > > > slot doesn't support mmap (i.e., kvm_slot_has_gmem() &&
> > > > kvm_arch_supports_gmem_mmap() ). If that happens, we can reintroduce
> > > > kvm_slot_can_be_private() as such.
> > > >
> > > > Otherwise, I could keep it and already define it as so. What do you think?
> > > >
> > > >> Sean also raised a "kvm_is_memslot_gmem_only()", how did you end up
> > > >> calling that?
> > > >
> > > > Good point, I'd missed that. Isn't it true that
> > > > kvm_is_memslot_gmem_only() is synonymous (at least for now) with
> > > > kvm_gmem_memslot_supports_mmap()?
> > >
> > > Yes. I think having a simple kvm_is_memslot_gmem_only() helper might
> > > make fault handling code easier to read, though.
>
> Yep, exactly.  The fact that a memslot is bound to a guest_memfd instance that
> supports mmap() isn't actually what KVM cares about.  The important part is that
> the userspace_addr in the memslot needs to be ignored when mapping memory into
> the guest, because the bound guest_memfd is the single source of truth for guest
> mappings.
>
> E.g. userspace could actually point userspace_addr at a completely different
> mapping, in which case walking the userspace page tables to get the max mapping
> size would be all kinds of wrong.
>
> KVM will still use userspace_addr when access guest memory from within KVM,
> but that's not dangerous to the host kernel/KVM, only to the guest (and userspace
> is firmly in the TCB for that side of things).
>
> So I think KVM_MEMSLOT_IS_GMEM_ONLY and kvm_is_memslot_gmem_only()?
>
> Those names are technically not entirely true, because as above, there is no
> guarantee that userspace_addr actually points at the bound guest_memfd.  But
> for all intents and purposes, that will hold true for all non-buggy setups.

Got it. So, to summarize again:

    In struct kvm_arch: add `bool supports_gmem` instead of renaming
`bool has_private_mem`

    The guest_memfd flag GUEST_MEMFD_FLAG_SUPPORT_SHARED becomes
GUEST_MEMFD_FLAG_MMAP

    The memslot internal flag KVM_MEMSLOT_SUPPORTS_GMEM_SHARED becomes
KVM_MEMSLOT_GMEM_ONLY

    kvm_gmem_memslot_supports_shared() becomes kvm_memslot_is_gmem_only()

    kvm_arch_supports_gmem_shared_mem() becomes kvm_arch_supports_gmem_mmap()

    kvm_gmem_fault_shared(struct vm_fault *vmf) becomes
kvm_gmem_fault_user_mapping(struct vm_fault *vmf)

    The capability KVM_CAP_GMEM_SHARED_MEM becomes KVM_CAP_GMEM_MMAP

    The Kconfig CONFIG_KVM_GMEM_SHARED_MEM becomes CONFIG_KVM_GMEM_SUPPORTS_MMAP

What will stay the same as V12:

    CONFIG_KVM_PRIVATE_MEM becomes CONFIG_KVM_GMEM

    CONFIG_KVM_GENERIC_PRIVATE_MEM becomes CONFIG_KVM_GENERIC_GMEM_POPULATE

    kvm_slot_can_be_private() becomes kvm_slot_has_gmem()

Thanks,
/fuad

