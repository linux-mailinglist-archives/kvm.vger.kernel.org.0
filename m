Return-Path: <kvm+bounces-47361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6441CAC08D5
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 11:35:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B7AC4E2F3E
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 09:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2450A286425;
	Thu, 22 May 2025 09:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L45BUgfx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0EC21ADA0
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 09:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747906502; cv=none; b=bOGUQxeN+QFjbBjrPUg1rryM8ZDNk42Onyl4zoltnes84f4ulMoKB78ROSyPKV0sTtjW65HLqmnVJyUtehpSZ9pt15E5H+AiTXcAQLPXRA9qqK0BdZ9QSaJtG/+9mi5uYUfQoAB2Py0rQo5pFcDPAYZ+XcGN3SMRMYHpKnqkVm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747906502; c=relaxed/simple;
	bh=58P1KmovK8E0jT7GX7NXpA6gJreewwgB0cFZyH3Y3/A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=epQuKx6bNWJEGZ9kiZtWjtkwHVimZtltYfK2cEFscZOhZkPTSOQMNpPg/7Ow0WQBCQNzst0INgFZeMwhZX8Zstr/KOucrVzrOvEJCPLnJN55A9/Sd7rxxwDREF+LuVtK5KwG5K3UClBUWQ046LgPOIbZckiiXxfUiTqIkI+Esvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L45BUgfx; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4774611d40bso1419681cf.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 02:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747906499; x=1748511299; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jy79b00HYU3PgVrvLmPpXmz4H8JXcASWwXNlNoTyvAg=;
        b=L45BUgfxERcNkbDdEQ8k2mBUZMKnG5y+/R7owbqbaWXmJiOhMHPgvJzLUavv1aPLIu
         JcfxVdaxerVczHYFDYtMV96zyIQ5F1Xf38LMJaTQ607amH4PdrdAuDAVOxdPFi3WINt6
         uFKuToSsVZawYl5iwUSKBiBHCRewpRmEEslipVPVfsFTqlJxSC2kdU9NarL9T8eQht+D
         r7N9VNWx2T6oA1LMoIBjnXNCwdt8F4o4A6klc7qCh3WYZsTCdb5YpRbumAJ+qMrKtNEp
         HHT6sZypiZ9Q8khB09172MmXPvKJ2A/EaYnBaBx/HynSIFJawt5hG8RQOFfHw5wooyPK
         mSxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747906499; x=1748511299;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jy79b00HYU3PgVrvLmPpXmz4H8JXcASWwXNlNoTyvAg=;
        b=ULwQtSvWJKxIBH1eONdTVWY9Ynof2zZ+Q7FQLsOfi7yOkiV0eeOlaZFRLSI0i49b5H
         q7ku/ZHdnCCpe5hxj3yJ3GZH+HTDKoMnQuT2WwxFgOlGtgbRrdajuzqYNjaxWYQZ1vIB
         V55MsIZu2iY45WVs2qJoD7ECnP6tQZ1E1djb8sq5QQ836KIHhi7/nM0K2bMQV5N2NRRC
         m7+3emOOlaMDhNZna0h/tpKiDYEu5QiToHDR5rU3IsTBP5rMg1N6wR3Hp7lBFLtOW0Qx
         AqZOTMtBdEWOijuHSHT/8lhndxDtoNfiswmEYyY4oANl12+424Uz6BkHLoBKRw3YrgCf
         1oZQ==
X-Gm-Message-State: AOJu0YwHlJZmDC8k8tAfPWf60/VQ695k+OP5e85eAQA9V/ZzjY/9Sul8
	nN8tXLRaB0pVmWRuG4Kc6HTui5g9BEma376ap94FqbDNLTCdbRdkHI+E76kJ7OESNZddN+77abN
	En6we6ZfbWC1SnH9q7kpu3MomQnm4afZ4+Z2cc7bK
X-Gm-Gg: ASbGncuJuN1QjgN516pQD1aLNbH2uMGHluJGueHDzKB+TR+IhofEp4ClQAnoXfZ7wxJ
	52oImUOHmLbXtFkpS9HB8KoIBdSTxnM2ZnHtwTGpRGaYh1Dxsx+SrIISNqxJcbYmg6ANSrFUmkO
	ulGngwqBBttgPCJrP5j10zdVzT65J5yUIr8pWXmNisqMXIK2GQEdQh+A==
X-Google-Smtp-Source: AGHT+IHkrB0CTaEIuNQ7Dtb6ZGwkgF2U8LyJwoedpdOy6ZMdbF4DAs4s8wGA3z/M3baeoC2jvhF3ZXjjXGuLzYaFc0U=
X-Received: by 2002:a05:622a:1491:b0:494:763e:d971 with SMTP id
 d75a77b69052e-49cf199560emr2054371cf.23.1747906499041; Thu, 22 May 2025
 02:34:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com> <20250513163438.3942405-11-tabba@google.com>
 <5ace54d1-800b-4122-8c05-041aa0ee12a1@redhat.com> <CA+EHjTyiiA84spuKqr-2ioiVjEHrcksENLR5uGhY-Avke28-2w@mail.gmail.com>
 <396dce13-dd72-4efc-9b8e-5b19c1b06386@redhat.com>
In-Reply-To: <396dce13-dd72-4efc-9b8e-5b19c1b06386@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 22 May 2025 10:34:22 +0100
X-Gm-Features: AX0GCFtiRA83JePbGS8oYvnrZc8qR-vDopez1aCFD727cyCPFwE77yoD1LOwOUo
Message-ID: <CA+EHjTyT-5bhStuO_3UFdUTMNtA6_7eDd7zXQwdDR4PuwHC=8A@mail.gmail.com>
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

On Thu, 22 May 2025 at 09:56, David Hildenbrand <david@redhat.com> wrote:
>
> On 22.05.25 09:22, Fuad Tabba wrote:
> > Hi David,
> >
> > On Wed, 21 May 2025 at 09:01, David Hildenbrand <david@redhat.com> wrote:
> >>
> >> On 13.05.25 18:34, Fuad Tabba wrote:
> >>> From: Ackerley Tng <ackerleytng@google.com>
> >>>
> >>> This patch adds kvm_gmem_max_mapping_level(), which always returns
> >>> PG_LEVEL_4K since guest_memfd only supports 4K pages for now.
> >>>
> >>> When guest_memfd supports shared memory, max_mapping_level (especially
> >>> when recovering huge pages - see call to __kvm_mmu_max_mapping_level()
> >>> from recover_huge_pages_range()) should take input from
> >>> guest_memfd.
> >>>
> >>> Input from guest_memfd should be taken in these cases:
> >>>
> >>> + if the memslot supports shared memory (guest_memfd is used for
> >>>     shared memory, or in future both shared and private memory) or
> >>> + if the memslot is only used for private memory and that gfn is
> >>>     private.
> >>>
> >>> If the memslot doesn't use guest_memfd, figure out the
> >>> max_mapping_level using the host page tables like before.
> >>>
> >>> This patch also refactors and inlines the other call to
> >>> __kvm_mmu_max_mapping_level().
> >>>
> >>> In kvm_mmu_hugepage_adjust(), guest_memfd's input is already
> >>> provided (if applicable) in fault->max_level. Hence, there is no need
> >>> to query guest_memfd.
> >>>
> >>> lpage_info is queried like before, and then if the fault is not from
> >>> guest_memfd, adjust fault->req_level based on input from host page
> >>> tables.
> >>>
> >>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >>> Signed-off-by: Fuad Tabba <tabba@google.com>
> >>> ---
> >>>    arch/x86/kvm/mmu/mmu.c   | 92 ++++++++++++++++++++++++++--------------
> >>>    include/linux/kvm_host.h |  7 +++
> >>>    virt/kvm/guest_memfd.c   | 12 ++++++
> >>>    3 files changed, 79 insertions(+), 32 deletions(-)
> >>>
> >>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >>> index cfbb471f7c70..9e0bc8114859 100644
> >>> --- a/arch/x86/kvm/mmu/mmu.c
> >>> +++ b/arch/x86/kvm/mmu/mmu.c
> >>> @@ -3256,12 +3256,11 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
> >>>        return level;
> >>>    }
> >> [...]
> >>
> >>>    static u8 kvm_max_level_for_fault_and_order(struct kvm *kvm,
> >>>                                            struct kvm_page_fault *fault,
> >>>                                            int order)
> >>> @@ -4523,7 +4551,7 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
> >>>    {
> >>>        unsigned int foll = fault->write ? FOLL_WRITE : 0;
> >>>
> >>> -     if (fault->is_private || kvm_gmem_memslot_supports_shared(fault->slot))
> >>> +     if (fault_from_gmem(fault))
> >>
> >> Should this change rather have been done in the previous patch?
> >>
> >> (then only adjust fault_from_gmem() in this function as required)
> >>
> >>>                return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
> >>>
> >>>        foll |= FOLL_NOWAIT;
> >>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> >>> index de7b46ee1762..f9bb025327c3 100644
> >>> --- a/include/linux/kvm_host.h
> >>> +++ b/include/linux/kvm_host.h
> >>> @@ -2560,6 +2560,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >>>    int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >>>                     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
> >>>                     int *max_order);
> >>> +int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot, gfn_t gfn);
> >>>    #else
> >>>    static inline int kvm_gmem_get_pfn(struct kvm *kvm,
> >>>                                   struct kvm_memory_slot *slot, gfn_t gfn,
> >>> @@ -2569,6 +2570,12 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
> >>>        KVM_BUG_ON(1, kvm);
> >>>        return -EIO;
> >>>    }
> >>> +static inline int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot,
> >>> +                                      gfn_t gfn)
> >>
> >> Probably should indent with two tabs here.
> >
> > (I'm fixing the patch before respinning, hence it's me asking)
> >
> > Not sure I understand. Indentation here matches the same style as that
> > for kvm_gmem_get_pfn() right above it in the alignment of the
> > parameters, i.e., the parameter `gfn_t gfn` is aligned with the
> > parameter `const struct kvm_memory_slot *slot` (four tabs and a
> > space).
>
> Yeah, that way of indenting is rather bad practice. Especially for new
> code we're adding or when we touch existing code, we should just use two
> tabs.
>
> That way, we can fit more stuff into a single line, and when doing
> simple changes, such as renaming the function or changing the return
> type, we won't have to touch all the parameters.
>
> Maybe KVM has its own rules on that ... that's why I said "probably" :)

:)

I see, although I agree with you, I'd rather that indentation be
consistent within the same file.

Thanks,
/fuad
> --
> Cheers,
>
> David / dhildenb
>

