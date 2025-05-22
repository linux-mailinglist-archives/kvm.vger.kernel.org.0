Return-Path: <kvm+bounces-47347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE0A2AC0592
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 09:23:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 030919E2252
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 07:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9191E221FAF;
	Thu, 22 May 2025 07:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bBYvWVjV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1611D221D9B
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 07:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747898588; cv=none; b=TWuphpHR9obcerXQPEIZIiWryIpJy/KqN/FFMeW0kesfS/u5iIL2/rBeCbzwgveEBFTUJi7P2A/wmp7oXWruuO04+mCIdFD45TDrd0xEp1qYjQhCBfB0R6FPIsuy2eiLArsF8kmSY1H+8+SZE55g99aI8XhAemiiqRI9U+BjAzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747898588; c=relaxed/simple;
	bh=+T+GWyAo8i86XQKcDhUD1ze7DXCVuoV97N0vO9vwzyM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VEB2j3y8G/0YMXw7Uycx9o9+cg4C9Dk43M1kcH7z2KHzTN4WNNop4/INkds/PrnwlmpP1otKD9PDp8EcgDjT8dlaRlQjnrbWRj6ebBLtbc3Eh20p8MmrDqOjjMVohNRlZ5ePelp7wi+A7FE8KfS/nLlfWBSuzZfu1U3M9H3vT2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bBYvWVjV; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-47666573242so1731811cf.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 00:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747898586; x=1748503386; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Mk2bLjyUEb287XK00LoxvtVw12EbKu/I8cWfAApuOuI=;
        b=bBYvWVjV87wfxeyBDZm+chHqOI+lODa6euDhmljn+mMPNrsYaG8daeapeg74oHzrpQ
         XYLCB97cgazPicNsB/RSynWXXqXUx0qyR12uKbbMrbZVuVttIyUbfg5m7Gh/bkD2YV5N
         aQx5Z91NC6LP9vamGQcYP08bFXufa48i3GSYzQAgvqEZ1uzQ47VMwStz5Dz2DTQ1UpbF
         +pLDvvb/4aZjQUe/3w3SeSiZYtBPr+hx3A1pK4h708JIx2z8qmxL2kSz4c+eumzPEzHX
         8gD+vONHJhnLi8jDKewMGPHTrhIsdGyDlXSdefVZKdw9d57wHN+0Y7QEs5yUz1UXY+fR
         EV1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747898586; x=1748503386;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mk2bLjyUEb287XK00LoxvtVw12EbKu/I8cWfAApuOuI=;
        b=hD0RJzM0E5f9nHZfqZDBahW4vTlDYIAzBex3OFd+dl1j/khIBpnIQXqdY5YBxdMs1Z
         DJwiVNz9auuYmA0ZXYdizvZgP57UsMcZ7GLYKQvNs4WrWDQM3CMNJiKDh07OTNk7WYys
         PuZk0oly/QX9sLk0jW7t330I2OR4ck+G7+qSGEWjPmgDb///BxQ8j+yusG0vY5VdhLPj
         xonOKsA45xbPCV+Hu9kv8WoZiHnmoGUiBwdEN96c4DLW1qNHmRQAphKDvnwOSXpyoNjP
         pZXat8R4dbencKVHKC/VABI/TQOAouvX6uFA0XdMR/NzaYRU9mBT/Ih67pI4I2AC92xd
         Hd1g==
X-Gm-Message-State: AOJu0YxqRnEQoJ6ArdfKU1DkNp6RWr44dMTq9nUXyZqtDFDQ09pbPjta
	sPwDcBlMn7/WlFvuJ3An+rrp4B6wecIKWWylM9/eLyeYzffp1BzavrZMQT959Sl7p0kx/5Q7IeR
	aWwQfyAE1Cl5vcxtKHmWRXcNjVX99ca/8pYhFANB9
X-Gm-Gg: ASbGnct+2YJ7e8RZ8LsOgzlCrbgH+lnG1mvO30Z6UI2QFzod7wnbbYIxvKHoAQlCzp/
	AjArrMwj98f39iZ+ulsdv29He2/ir8zbOfKKjm+dycjLlWDRn0u6gHIDRX7ebJnB8pkoT58AunR
	4DB067LVUOWQDUnrZoIE4YtvW1GugqQrSxpcScUF+CITU=
X-Google-Smtp-Source: AGHT+IEi6TeZEBQL7um7FKqCXxTH/kqET5/tP1WXTytlUTA+PhEPtgEimYOH7KJhSyxp6z55soK1OdIsMdoatnXAmqk=
X-Received: by 2002:ac8:5d44:0:b0:477:8577:1532 with SMTP id
 d75a77b69052e-49cf1c95ae4mr1960781cf.28.1747898585469; Thu, 22 May 2025
 00:23:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com> <20250513163438.3942405-11-tabba@google.com>
 <5ace54d1-800b-4122-8c05-041aa0ee12a1@redhat.com>
In-Reply-To: <5ace54d1-800b-4122-8c05-041aa0ee12a1@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 22 May 2025 08:22:28 +0100
X-Gm-Features: AX0GCFv4mD5QSYe80sAfF24snOg1C15DZpx2nFDhhQZIJov6N04QVy00YLzfTio
Message-ID: <CA+EHjTyiiA84spuKqr-2ioiVjEHrcksENLR5uGhY-Avke28-2w@mail.gmail.com>
Subject: Re: [PATCH v9 10/17] KVM: x86: Compute max_mapping_level with input
 from guest_memfd
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi David,

On Wed, 21 May 2025 at 09:01, David Hildenbrand <david@redhat.com> wrote:
>
> On 13.05.25 18:34, Fuad Tabba wrote:
> > From: Ackerley Tng <ackerleytng@google.com>
> >
> > This patch adds kvm_gmem_max_mapping_level(), which always returns
> > PG_LEVEL_4K since guest_memfd only supports 4K pages for now.
> >
> > When guest_memfd supports shared memory, max_mapping_level (especially
> > when recovering huge pages - see call to __kvm_mmu_max_mapping_level()
> > from recover_huge_pages_range()) should take input from
> > guest_memfd.
> >
> > Input from guest_memfd should be taken in these cases:
> >
> > + if the memslot supports shared memory (guest_memfd is used for
> >    shared memory, or in future both shared and private memory) or
> > + if the memslot is only used for private memory and that gfn is
> >    private.
> >
> > If the memslot doesn't use guest_memfd, figure out the
> > max_mapping_level using the host page tables like before.
> >
> > This patch also refactors and inlines the other call to
> > __kvm_mmu_max_mapping_level().
> >
> > In kvm_mmu_hugepage_adjust(), guest_memfd's input is already
> > provided (if applicable) in fault->max_level. Hence, there is no need
> > to query guest_memfd.
> >
> > lpage_info is queried like before, and then if the fault is not from
> > guest_memfd, adjust fault->req_level based on input from host page
> > tables.
> >
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   arch/x86/kvm/mmu/mmu.c   | 92 ++++++++++++++++++++++++++--------------
> >   include/linux/kvm_host.h |  7 +++
> >   virt/kvm/guest_memfd.c   | 12 ++++++
> >   3 files changed, 79 insertions(+), 32 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index cfbb471f7c70..9e0bc8114859 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3256,12 +3256,11 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
> >       return level;
> >   }
> [...]
>
> >   static u8 kvm_max_level_for_fault_and_order(struct kvm *kvm,
> >                                           struct kvm_page_fault *fault,
> >                                           int order)
> > @@ -4523,7 +4551,7 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
> >   {
> >       unsigned int foll = fault->write ? FOLL_WRITE : 0;
> >
> > -     if (fault->is_private || kvm_gmem_memslot_supports_shared(fault->slot))
> > +     if (fault_from_gmem(fault))
>
> Should this change rather have been done in the previous patch?
>
> (then only adjust fault_from_gmem() in this function as required)
>
> >               return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
> >
> >       foll |= FOLL_NOWAIT;
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index de7b46ee1762..f9bb025327c3 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2560,6 +2560,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >   int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >                    gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
> >                    int *max_order);
> > +int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot, gfn_t gfn);
> >   #else
> >   static inline int kvm_gmem_get_pfn(struct kvm *kvm,
> >                                  struct kvm_memory_slot *slot, gfn_t gfn,
> > @@ -2569,6 +2570,12 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
> >       KVM_BUG_ON(1, kvm);
> >       return -EIO;
> >   }
> > +static inline int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot,
> > +                                      gfn_t gfn)
>
> Probably should indent with two tabs here.

(I'm fixing the patch before respinning, hence it's me asking)

Not sure I understand. Indentation here matches the same style as that
for kvm_gmem_get_pfn() right above it in the alignment of the
parameters, i.e., the parameter `gfn_t gfn` is aligned with the
parameter `const struct kvm_memory_slot *slot` (four tabs and a
space).

Thanks,
/fuad


>
>
> --
> Cheers,
>
> David / dhildenb
>

