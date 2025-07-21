Return-Path: <kvm+bounces-53015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75F45B0C9B0
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 19:29:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9952A17A522
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 17:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A3D92E11AE;
	Mon, 21 Jul 2025 17:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4ps3m5WG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E322C2D3EF9
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 17:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753118984; cv=none; b=daQ+geT/forqrS2P5eWoxrJIDuF1Z8kRhGgXUuvyFIZzLn+YctasVfvL0nl3qivPm23kUzicJ7yYymYBxNyW0OP48BAv2o3Ftd/VGlWoItBm44hQ92B4JqJegZD3QAtk18qM5gFTuwUw9nmeTso9JFvsVekrMy/ptKtXO4Sz1z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753118984; c=relaxed/simple;
	bh=bCPBYcrgZPJnQrdDLmfZ1ILRwRzBYyAsU8a1QcwRpXU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fhNWwtgZHCKYhgNtnH+4rLZY2XISg7O+mIJJ+BX3P3Di43e/fMIHl0sg3ctMukjtVRxuO6TVbl9sOyMIO023bG3Yilfav8Ctd9QsO5ok3MWMMF7lOsed0phgeRjMkKh2eaunzAWgw6cmLNJRHyT3RXf3/nauYyAbu8w1R5o7+kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4ps3m5WG; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2355651d204so39953265ad.2
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 10:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753118982; x=1753723782; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9OvpY0AOd4TKj+pOT3DzWszlAggjOKWS4p4sbX0uowc=;
        b=4ps3m5WGlxEMm5IHt+zjnvfihTePcOAJYb22zT+DymAdQBtBFNTVYGUhk59lk0zXgL
         ReTZGjOtbmlmYWbH6KLu61nnrAOMBlcg+tahW0IbkkQT1JN+nw9OBzrAiwYhBQdkiZn7
         IXT+7BgBrepDxKBp4YIfkbGJc0yui78qPYD8SuyunBfWmO01QySWtOOhO/h/w/BZ6nxT
         o+OMc1iusI5cOJ0wDQofQFiu+rmqKvjDGioJmiQadzJi9IMf/pUGQRkpIMh7nJH+Q6sE
         DZv63LHfrbVv0U4zMPdEH8QaUBYAoSUOoZJaInbYxEiE6G1rJ/lLDpstNo6+UnR8H89d
         w87g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753118982; x=1753723782;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9OvpY0AOd4TKj+pOT3DzWszlAggjOKWS4p4sbX0uowc=;
        b=KzjNE9as6xWPbZMn8PYP/0GAb7Z2vO6NIAgBfeDjQwQVCHtn9UBjj1eMlwZihT1hLG
         Y4ggf7S1v7MRyvN+n2oTWalQNWg9opLfmKyyOWUJY6RsPDO11JtXPOWqPEVhhHNCk4hk
         yyFBa19Qlb4ZEGeSSn7TuGlxN2JBg8Zmutf1mwFzltmCRidsfJojsDl+OyTmpLKvAx7a
         gBMZewdKDDrCzu+u/m59SrI/X3/m04wALvfzT10k2uWw7abrDoBKqAQ/rTBCXL8FnpCB
         E7LqStvsG0lo43VZ2sShnUFU1SMKOwmDw6ojr46WPgBpV/hT8y73msctNMFcvV4RrVqP
         cgXA==
X-Forwarded-Encrypted: i=1; AJvYcCUeqsIbXINTFi2AC/MbNKq9RZ++NoNCbNfjTobbuqjB9FmTXfI9omsFnh4iYsD2gZrHsh0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSNSGu24c9WeliRK3rAfUA6ZF0MiMa+kqNA6M6+toO8eaOvLT7
	muy20OM5r37/DQXlWS471I+BY3HR4wEtsRVjPBm3fGtP6EcFOfZ6TfnCoWUY/J+5YN9LGf90aeD
	uVQSExA==
X-Google-Smtp-Source: AGHT+IFhRVu6/b0PqYJW3muXwv7nDoSYEeLC8OqW5axU4suctUJzDOyv4LU8g7tON33RpjxB06RUczbhKIA=
X-Received: from pjzz15.prod.google.com ([2002:a17:90b:58ef:b0:311:ef56:7694])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:580c:b0:313:d6d9:8891
 with SMTP id 98e67ed59e1d1-31c9e6e5584mr28813484a91.3.1753118982212; Mon, 21
 Jul 2025 10:29:42 -0700 (PDT)
Date: Mon, 21 Jul 2025 10:29:40 -0700
In-Reply-To: <1fe0f46a-152a-4b5b-99e2-2a74873dafdc@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com> <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
 <aH5RxqcTXRnQbP5R@google.com> <1fe0f46a-152a-4b5b-99e2-2a74873dafdc@intel.com>
Message-ID: <aH55BLkx7UkdeBfT@google.com>
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Vishal Annapurve <vannapurve@google.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
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

On Mon, Jul 21, 2025, Xiaoyao Li wrote:
> On 7/21/2025 10:42 PM, Sean Christopherson wrote:
> > > > However, it fails actually, because the kvm_arch_suports_gmem_mmap()
> > > > returns false for TDX VMs, which means userspace cannot allocate gmem
> > > > with mmap just for shared memory for TDX.
> > > 
> > > Why do you want such a usecase to work?
> > 
> > I'm guessing Xiaoyao was asking an honest question in response to finding a
> > perceived flaw when trying to get this all working in QEMU.
> 
> I'm not sure if it is an flaw. Such usecase is not supported is just
> anti-intuition to me.
> 
> > > If kvm allows mappable guest_memfd files for TDX VMs without
> > > conversion support, userspace will be able to use those for backing
> > 
> > s/able/unable?
> 
> I think vishal meant "able", because ...
> 
> > > private memory unless:
> > > 1) KVM checks at binding time if the guest_memfd passed during memslot
> > > creation is not a mappable one and doesn't enforce "not mappable"
> > > requirement for TDX VMs at creation time.
> > 
> > Xiaoyao's question is about "just for shared memory", so this is irrelevant for
> > the question at hand.
> 
> ... if we allow gmem mmap for TDX, KVM needs to ensure the mmapable gmem
> should only be passed via userspace_addr. IOW, KVM needs to forbid userspace
> from passing the mmap'able guest_memfd to
> kvm_userspace_memory_region2.guest_memfd. Because it allows userspace to
> access the private mmeory.

TDX support needs to be gated (and is gated) on private vs. shared being tracked
in guest_memfd.  And that restriction should be (and is) reflected in
KVM_CAP_GUEST_MEMFD_MMAP when invoked on a VM (versus on /dev/kvm).

> 
> > > 2) KVM fetches shared faults through userspace page tables and not
> > > guest_memfd directly.
> > 
> > This is also irrelevant.  KVM _already_ supports resolving shared faults through
> > userspace page tables.  That support won't go away as KVM will always need/want
> > to support mapping VM_IO and/or VM_PFNMAP memory into the guest (even for TDX).
> > 
> > > I don't see value in trying to go out of way to support such a usecase.
> > 
> > But if/when KVM gains support for tracking shared vs. private in guest_memfd
> > itself, i.e. when TDX _does_ support mmap() on guest_memfd, KVM won't have to go
> > out of its to support using guest_memfd for the @userspace_addr backing store.
> > Unless I'm missing something, the only thing needed to "support" this scenario is:
> 
> As above, we need 1) mentioned by Vishal as well, to prevent userspace from
> passing mmapable guest_memfd to serve as private memory.

Ya, I'm talking specifically about what the world will look like once KVM tracks
private vs. shared in guest_memfd.  I'm not in any way advocating we do this
right now.

