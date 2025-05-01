Return-Path: <kvm+bounces-45072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B669AA5CCF
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 11:54:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 116013BCCBB
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 09:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D3DC22CBF6;
	Thu,  1 May 2025 09:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0gt3KJcX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BAC21422B
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 09:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746093279; cv=none; b=pdGCzhLbK4+ve1DJDyJkWP+5BJZpr2UnFLKNRors5ZYz0S+PQ2csb3NNbS4yhc8yEzLO+SBcSdxKhS1AW2EsvexABgTVhV4+KuS4EYqqcimE7wZAFAAxMiFhVOm9x9Nht9p3z7GlZ9RedLcOSg98rBF9tFQ2DFG8joiAI0I4R+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746093279; c=relaxed/simple;
	bh=tPojNAE9X8jNNMKGZxV1mHKo3clJ6jvnrxnAIv0gQkY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H5LeBj0iJiskqdgUvF5OFRr9/CxDuCvgEYI+Ab5UH3QhQICE+louQosod+HinE0IA+FJvP/gn6XvOS1j6kZYGxC1jheH7NjnGU3lo58bAPOmQk0ZB6n3jCAtON/1cQiZ3sreQl3bjZzaGcADhVUEjK+MXvfx7ZPA+3y3buCX/aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0gt3KJcX; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-47e9fea29easo122231cf.1
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 02:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746093277; x=1746698077; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Si4JfXR6mP4IYYMT29UOVbb1otTt0axA6CZ1YDI9+AQ=;
        b=0gt3KJcXOI0kFpAafYIsghTHfoIs5v5BXGKaavQTiZa/Gw4BZwR0ES00VzMxdhFy/4
         zvBOmOXCqcAxtJ+PUszzVEfgW2/KZsaRq+m/VlAueuFvjRJdmQWX7Wi6abjo1poKNYb1
         ZQM6w6b+qDZaXL9Ptv578GnQVgt9ZbAAsNiTnBzBKp49WscgycwXX0GkuL7Wr3pOsQW+
         B5njOJjT9f1pAyfVU9GCOCsHshVCnJym4yJ+UlvQO9uInhpD1VmJmK9SkdoWQn9Y+AeN
         9JNvjYzQBgTvH9Dz6aHaZetewfuT3Vbkn7QwsBrdzjt8+W/6StdOtdyeqcwe/jCCbcyO
         wglw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746093277; x=1746698077;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Si4JfXR6mP4IYYMT29UOVbb1otTt0axA6CZ1YDI9+AQ=;
        b=O6uPHEFxND66yXTmQq/vA1gQk+m/S0ql1OTEZqAmktGNz8AxerqQ5kXNoyJBkc+WUx
         s4FM1/AwjW+aksMKe5rNQ5efeOk54HaGi90ng/x7fdO3BA8EmdGHnfJ8iujf89C2N3aP
         XTEQDKNX/bs9khVajUXQJs4j0m2dZu1lkxPTnhqX6hswJpCypMkiks6kwV1LZs+OkeLi
         Cb8g1WOVOJbkJJAaN7Pg1Ym5j9ZnnEShNwn+/A+xQjU+8ogx39qJLaJQpd6wwTCCQxlB
         EufsBxPFbmtUvKvuxQDVQdvdTCfkgNTfDH4rTP99+vZUtUU5Okx33DCkYts7pYn5/f/4
         5ojg==
X-Gm-Message-State: AOJu0Yxex5J5eILnfVj3PudFGp0GiVa1FXNvUTTPrkYI2fb+RQ7zpWNd
	I9OEzsdGv0n1ll5Z2e+/2UjKgX+r57sM3BCQ6N10f+pD12Td4AZkVsr2i4qTz+VyXNCyO+3hWwc
	gnbO1KTnSGycdTLbBBU7XS4pPsUBPSEYk/kWK
X-Gm-Gg: ASbGncvDYzjLFxfqiAObVK0HkDVYNvFBf8ar/2i0bADOlI+6qoJ1fDMziZEQWZkMHpA
	XSB3+inPAuWZ+5t6mFHzRG9cnZ02lJhVBgo9Lumxwf7SoK3tlcoD0V7Cf8jmOvb+icwbDHMCcdr
	aECBIIJPHR404ZFpNjNxL4fjE=
X-Google-Smtp-Source: AGHT+IFNyZ/h02gsvbeC0up9ulk27D2jhI3Rj1d7Wg620REgI9FAowU+ytZ0JoiwZxsj9oFSBbg/OCpnsoepTeOuk68=
X-Received: by 2002:a05:622a:11:b0:486:8711:19af with SMTP id
 d75a77b69052e-48ae773409emr3692911cf.0.1746093276598; Thu, 01 May 2025
 02:54:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250430165655.605595-7-tabba@google.com> <diqz7c31xyqs.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqz7c31xyqs.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 1 May 2025 10:53:59 +0100
X-Gm-Features: ATxdqUE9VBlSm4IZL3pfrNaYkV2w1NjQaMBOEepCOPF4Q4EKmdB3yi6epRoxCN0
Message-ID: <CA+EHjTy5_KuSkqu+BGtS_aLoRv9Kv=kM6NOJtFTR3pbrJ12N1A@mail.gmail.com>
Subject: Re: [PATCH v8 06/13] KVM: x86: Generalize private fault lookups to
 guest_memfd fault lookups
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
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
	pankaj.gupta@amd.com
Content-Type: text/plain; charset="UTF-8"

Hi Ackerley,

On Wed, 30 Apr 2025 at 19:58, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> > Until now, faults to private memory backed by guest_memfd are always
> > consumed from guest_memfd whereas faults to shared memory are consumed
> > from anonymous memory. Subsequent patches will allow sharing guest_memfd
> > backed memory in-place, and mapping it by the host. Faults to in-place
> > shared memory should be consumed from guest_memfd as well.
> >
> > In order to facilitate that, generalize the fault lookups. Currently,
> > only private memory is consumed from guest_memfd and therefore as it
> > stands, this patch does not change the behavior.
> >
> > Co-developed-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c   | 19 +++++++++----------
> >  include/linux/kvm_host.h |  6 ++++++
> >  2 files changed, 15 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 6d5dd869c890..08eebd24a0e1 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3258,7 +3258,7 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
> >
> >  static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
> >                                      const struct kvm_memory_slot *slot,
> > -                                    gfn_t gfn, int max_level, bool is_private)
> > +                                    gfn_t gfn, int max_level, bool is_gmem)
> >  {
> >       struct kvm_lpage_info *linfo;
> >       int host_level;
> > @@ -3270,7 +3270,7 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
> >                       break;
> >       }
> >
> > -     if (is_private)
> > +     if (is_gmem)
> >               return max_level;
>
> I think this renaming isn't quite accurate.
>
> IIUC in __kvm_mmu_max_mapping_level(), we skip considering
> host_pfn_mapping_level() if the gfn is private because private memory
> will not be mapped to userspace, so there's no need to query userspace
> page tables in host_pfn_mapping_level().
>
> Renaming is_private to is_gmem in this function implies that as long as
> gmem is used, especially for shared pages from gmem, lpage_info will
> always be updated and there's no need to query userspace page tables.
>

I understand.

> >
> >       if (max_level == PG_LEVEL_4K)
> > @@ -3283,10 +3283,9 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
> >  int kvm_mmu_max_mapping_level(struct kvm *kvm,
> >                             const struct kvm_memory_slot *slot, gfn_t gfn)
> >  {
> > -     bool is_private = kvm_slot_has_gmem(slot) &&
> > -                       kvm_mem_is_private(kvm, gfn);
> > +     bool is_gmem = kvm_slot_has_gmem(slot) && kvm_mem_from_gmem(kvm, gfn);
>
> This renaming should probably be undone too.

Ack.

> >
> > -     return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
> > +     return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_gmem);
> >  }
> >
> >  void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > @@ -4465,7 +4464,7 @@ static inline u8 kvm_max_level_for_order(int order)
> >       return PG_LEVEL_4K;
> >  }
> >
> > -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> > +static u8 kvm_max_gmem_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
> >                                       u8 max_level, int gmem_order)
> >  {
> >       u8 req_max_level;
> > @@ -4491,7 +4490,7 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
> >                                r == RET_PF_RETRY, fault->map_writable);
> >  }
> >
> > -static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
> > +static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
> >                                      struct kvm_page_fault *fault)
> >  {
> >       int max_order, r;
> > @@ -4509,8 +4508,8 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
> >       }
> >
> >       fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
> > -     fault->max_level = kvm_max_private_mapping_level(vcpu->kvm, fault->pfn,
> > -                                                      fault->max_level, max_order);
> > +     fault->max_level = kvm_max_gmem_mapping_level(vcpu->kvm, fault->pfn,
> > +                                                   fault->max_level, max_order);
> >
> >       return RET_PF_CONTINUE;
> >  }
> > @@ -4521,7 +4520,7 @@ static int __kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
> >       unsigned int foll = fault->write ? FOLL_WRITE : 0;
> >
> >       if (fault->is_private)
> > -             return kvm_mmu_faultin_pfn_private(vcpu, fault);
> > +             return kvm_mmu_faultin_pfn_gmem(vcpu, fault);
> >
> >       foll |= FOLL_NOWAIT;
> >       fault->pfn = __kvm_faultin_pfn(fault->slot, fault->gfn, foll,
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index d9616ee6acc7..cdcd7ac091b5 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2514,6 +2514,12 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >  }
> >  #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
> >
> > +static inline bool kvm_mem_from_gmem(struct kvm *kvm, gfn_t gfn)
> > +{
> > +     /* For now, only private memory gets consumed from guest_memfd. */
> > +     return kvm_mem_is_private(kvm, gfn);
> > +}
>
> Can I understand this function as "should fault from gmem"? And hence
> also "was faulted from gmem"?
>
> After this entire patch series, for arm64, KVM will always service stage
> 2 faults from gmem.
>
> Perhaps this function should retain your suggested name of
> kvm_mem_from_gmem() but only depend on
> kvm_arch_gmem_supports_shared_mem(), since this patch series doesn't
> update the MMU in X86. So something like this,

Ack.

> +static inline bool kvm_mem_from_gmem(struct kvm *kvm, gfn_t gfn)
> +{
> +       return kvm_arch_gmem_supports_shared_mem(kvm);
> +}
>
> with the only usage in arm64.
>
> When the MMU code for X86 is updated, we could then update the above
> with
>
> static inline bool kvm_mem_from_gmem(struct kvm *kvm, gfn_t gfn)
> {
> -       return kvm_arch_gmem_supports_shared_mem(kvm);
> +       return kvm_arch_gmem_supports_shared_mem(kvm) ||
> +              kvm_gmem_should_always_use_gmem(gfn_to_memslot(kvm, gfn)->gmem.file) ||
> +              kvm_mem_is_private(kvm, gfn);
> }
>
> where kvm_gmem_should_always_use_gmem() will read a guest_memfd flag?

I'm not sure I follow this one... Could you please explain what you
mean a bit more?

Thanks,
/fuad

> > +
> >  #ifdef CONFIG_KVM_GMEM
> >  int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> >                    gfn_t gfn, kvm_pfn_t *pfn, struct page **page,

