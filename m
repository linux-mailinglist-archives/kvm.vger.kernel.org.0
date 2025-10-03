Return-Path: <kvm+bounces-59465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CFDCBBB7739
	for <lists+kvm@lfdr.de>; Fri, 03 Oct 2025 18:06:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7B2ED4ED517
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 16:06:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB9A2BE7AC;
	Fri,  3 Oct 2025 16:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PxPRkymo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7322BD00C
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 16:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507560; cv=none; b=KLEWd0w9AusNPGbHgy4qIZTL+J7MRKvko31D7HYOaxvCCRgQY88wb3ZZtGg/7+5h490jrsw7QD1c5dijFs3aAirDjyfhSizmBV3TUwDZjP7mlGS0xxkh6ymtAUb+2v+qI9QM+J2pJVkW+3jrYzsmcaHoCFfu86Bk/ow28XY7IcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507560; c=relaxed/simple;
	bh=DTBd9BA1usFwsidcGi2Him6mYDP+NXsirmy/wzo3TNc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XIN6hcOeqUwEUMI8+OpEtTDLcKpuBcQ5wAsF4Gob+D63CzruTPlAeFDjrNqoufg5lt7jEdcvYJVfVWOOelpPtBjJht96oGiIMhX5P/rmoISZrFzMRpQSwurkUUIiWZLlknPq290GTmlAWyEFwPpD+TYfUkH0RfCXJ2HqMtjzWqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PxPRkymo; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77f5e6a324fso3921429b3a.0
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 09:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759507559; x=1760112359; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rr9Zgpsr/95Zre8MDjbJaLg4HUOz/eRCvS4su6KFtWM=;
        b=PxPRkymolx7gOqlpYtTASk6OrDG6NSjHhBprkdzdQOeWDj4emw400t/npBbLGlrUGr
         WhEw6ySe7rOh2SGvUtDScizbL4RJPtQ4Qamjc0ARY4fvbfhpGN112k2qg3OtyHAAuInG
         AY6WrQFu/2LQgHdRz3KDlpiSEXbaA/LK969+ke13KinIAjeR1I/gwrjatfPKOPQJ8yy+
         0OnFo2+MsCynUmO/f8K6qzRGNvbFZKDhLchqJwdgN9kUbePWdjrRn9mR+nJjePTA8DKc
         Z9U2NxTLi0AAYG2iu1JSTyJo2a48XAV8EZDwneGt8pGwRn3OLwdLz4CxFZOUflCR7BCR
         CVuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759507559; x=1760112359;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rr9Zgpsr/95Zre8MDjbJaLg4HUOz/eRCvS4su6KFtWM=;
        b=cCmybmlsLiCFxNQY4Ju6VXMKX551eVLISq8Pd/2FxST3pYvi3XCNUwRof1rcf8Tqno
         1K0PKGklnvYA0JCOpimzDBPqXuWFYfBwlkbubNTAAO3Pt174W8xmMDTnoHXIVhlbmB2+
         y5rNI381UGlaLYqh/n328j56BB/Nn4z++N1kijTkzlrd26AukAc1IFfZKtSu7pMpYWzV
         Pk3DSfk4R9MZeQwYM+PD+vtDXZAE03n/Km+Y1yb+JyHT/Ob34YMtJfZ7gxJM7Vd/qyNg
         suJOcmUfArEPHwLfwFP/1THVmiFCVjr8UCaSPYd8te/teXtoRDLg0TbvbQgxlMhJE/bb
         a7Og==
X-Gm-Message-State: AOJu0YyGhXTb1Z6HzvbPKup/f1RcXGvIz6Oozju7hN8h7I8hu9IBSHmg
	WwjVPELG6TW/PBgiiUbGFTg/FruEkjpJiPsbQpbtr8uIyjtop+SCvCZf9Dx6KCV3LqY/GFZj80V
	G3mXbeg==
X-Google-Smtp-Source: AGHT+IGkAn/LwerysZuGwJxYNVKUT2Gz4Ib8pIhMx4SKsJOPx+xTCSenhBS2G7GLP8kza9/oaz73nVHnf4c=
X-Received: from pgct2.prod.google.com ([2002:a05:6a02:5282:b0:b55:135:7cb9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3ca8:b0:245:fb85:ef69
 with SMTP id adf61e73a8af0-32b620cbda2mr5197670637.40.1759507558303; Fri, 03
 Oct 2025 09:05:58 -0700 (PDT)
Date: Fri, 3 Oct 2025 09:05:56 -0700
In-Reply-To: <aN_fJEZXo6wkcHOh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <b3c2da681c5bf139e2eaf0ea82c7422f972f6288.1747264138.git.ackerleytng@google.com>
 <aN_fJEZXo6wkcHOh@google.com>
Message-ID: <aN_0ZMduyGlX0QwU@google.com>
Subject: Re: [RFC PATCH v2 29/51] mm: guestmem_hugetlb: Wrap HugeTLB as an
 allocator for guest_memfd
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-fsdevel@vger.kernel.org, aik@amd.com, 
	ajones@ventanamicro.com, akpm@linux-foundation.org, amoorthy@google.com, 
	anthony.yznaga@oracle.com, anup@brainfault.org, aou@eecs.berkeley.edu, 
	bfoster@redhat.com, binbin.wu@linux.intel.com, brauner@kernel.org, 
	catalin.marinas@arm.com, chao.p.peng@intel.com, chenhuacai@kernel.org, 
	dave.hansen@intel.com, david@redhat.com, dmatlack@google.com, 
	dwmw@amazon.co.uk, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	graf@amazon.com, haibo1.xu@intel.com, hch@infradead.org, hughd@google.com, 
	ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, kirill.shutemov@intel.com, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, maz@kernel.org, 
	mic@digikod.net, michael.roth@amd.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, pdurrant@amazon.co.uk, 
	peterx@redhat.com, pgonda@google.com, pvorel@suse.cz, qperret@google.com, 
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_tsoni@quicinc.com, richard.weiyang@gmail.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, roypat@amazon.co.uk, 
	rppt@kernel.org, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	thomas.lendacky@amd.com, usama.arif@bytedance.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Oct 03, 2025, Sean Christopherson wrote:
> On Wed, May 14, 2025, Ackerley Tng wrote:
> > guestmem_hugetlb is an allocator for guest_memfd. It wraps HugeTLB to
> > provide huge folios for guest_memfd.
> > 
> > This patch also introduces guestmem_allocator_operations as a set of
> > operations that allocators for guest_memfd can provide. In a later
> > patch, guest_memfd will use these operations to manage pages from an
> > allocator.
> > 
> > The allocator operations are memory-management specific and are placed
> > in mm/ so key mm-specific functions do not have to be exposed
> > unnecessarily.
> 
> This code doesn't have to be put in mm/, all of the #includes are to <linux/xxx.h>.
> Unless I'm missing something, what you actually want to avoid is _exporting_ mm/
> APIs, and for that all that is needed is ensure the code is built-in to the kernel
> binary, not to kvm.ko.
> 
> diff --git a/virt/kvm/Makefile.kvm b/virt/kvm/Makefile.kvm
> index d047d4cf58c9..c18c77e8a638 100644
> --- a/virt/kvm/Makefile.kvm
> +++ b/virt/kvm/Makefile.kvm
> @@ -13,3 +13,5 @@ kvm-$(CONFIG_HAVE_KVM_IRQ_ROUTING) += $(KVM)/irqchip.o
>  kvm-$(CONFIG_HAVE_KVM_DIRTY_RING) += $(KVM)/dirty_ring.o
>  kvm-$(CONFIG_HAVE_KVM_PFNCACHE) += $(KVM)/pfncache.o
>  kvm-$(CONFIG_KVM_GUEST_MEMFD) += $(KVM)/guest_memfd.o
> +
> +obj-$(subst m,y,$(CONFIG_KVM_GUEST_MEMFD)) += $(KVM)/guest_memfd_hugepages.o
> \ No newline at end of file
> 
> People may want the code to live in mm/ for maintenance and ownership reasons
> (or not, I haven't followed the discussions on hugepage support), but that's a
> very different justification than what's described in the changelog.
> 
> And if the _only_ user is guest_memfd, putting this in mm/ feels quite weird.
> And if we anticipate other users, the name guestmem_hugetlb is weird, because
> AFAICT there's nothing in here that is in any way guest specific, it's just a
> few APIs for allocating and accounting hugepages.
> 
> Personally, I don't see much point in trying to make this a "generic" library,
> in quotes because the whole guestmem_xxx namespace makes it anything but generic.
> I don't see anything in mm/guestmem_hugetlb.c that makes me go "ooh, that's nasty,
> I'm glad this is handled by a library".  But if we want to go straight to a
> library, it should be something that is really truly generic, i.e. not "guest"
> specific in any way.

Ah, the complexity and the mm-internal dependencies come along in the splitting
and merging patch.  Putting that code in mm/ makes perfect sense, but I'm still
not convinced that putting _all_ of this code in mm/ is the correct split.

As proposed, this is a weird combination of being an extension of guest_memfd, a
somewhat generic library, _and_ a subsystem (e.g. the global workqueue and stash).

_If_ we need a library, then IMO it should be a truly generic library.  Any pieces
that are guest_memfd specific belong in KVM.  And any subsystem-like things should
should probably be implemented as an extension to HugeTLB itself, which is already
it's own subsytem.  Emphasis on "if", because it's not clear to me that that a
library is warranted.

AFAICT, the novelty here is the splitting and re-merging of hugetlb folios, and
that seems like it should be explicitly an extension of the hugetlb subsystem.
E.g. that behavior needs to take hugetlb_lock, interact with global vmemmap state
like hugetlb_optimize_vmemmap_key, etc.  If that's implemented as something like
hugetlb_splittable.c or whatever, and wired up to be explicitly configured via
hugetlb_init(), then there may not be much left for a library.

