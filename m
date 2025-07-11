Return-Path: <kvm+bounces-52173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 30672B01F40
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 16:35:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3237170EF7
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 14:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 432461F583A;
	Fri, 11 Jul 2025 14:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xtDd20Ec"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92F015533F
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 14:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752244532; cv=none; b=Bftm+6HJBc9eKDk/Co57OPgyUZu8VdAGsA1woXHr+/K94EqPWbGjElijx8r8JRERDMV9EHh9z4pPzsZ+an1FI71byLOzag/b/3ITxT0LE1WbIOHbW2ozsNo2G/lYHgD5V9ruCYFlywsCND0JA2gwIXY3XFh0qoEP3Ntj5VNCJVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752244532; c=relaxed/simple;
	bh=3+YsQ5DYqKVY+sCSEKk64n7MH3GtivRvMp+hTl+36G4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IxtIEn5f1JoHyaE3MJuExX44LKgHsExnnxXn7YW1UaRXpgrEyjQ48EeRlz43jQ/irUFYV/l/eez+Gg+8amKkuKyjMLQHjbV3OZA8VKaqUYiEozxO83wt5zPHKCNJavrfYjIgFbdOfoxfKFFOiuU7LvdJfiOOXogXPRDIxop+89o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xtDd20Ec; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso174101cf.0
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 07:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752244529; x=1752849329; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lq9VKw2x/Ujw6EnIVfnsvSfkn8foGEThRri1rsKatHU=;
        b=xtDd20EcQK05Lf+k1QniF5yJE2HYBEXKreMZqrjgmFkfjbnVMO7+R1q8c4vS+BDQJq
         FXdwylf2sQseWO4qxIO23N3tSoJMCajKUW7/xCEsnJMRAtsxjZSZNgFEFv9VKbzjU3FU
         vyO5MdrIUq3gb6EDRtog9tWQ7jIGkezfMMXIyV8EE0pcy8myn54KtxC5DE/fNYC74Bac
         fzOV3TLKfnJXjcFLv6Qc6kVqtx0rHs7+ZlqZ1MMrbP8Gb2aXNjC/zG6vQwUnrhom8f5i
         OcS9P0osBVp1UNgqIR7HLhVN+mJhXHBS4nDU+VBUcgXfs3Wx/lO3ON4kZb1E8F6eSz3g
         9BNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752244529; x=1752849329;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lq9VKw2x/Ujw6EnIVfnsvSfkn8foGEThRri1rsKatHU=;
        b=DvhNbqgQ3PrWb0VhLjeHeOPm7G0K7Dd8n4Dm9qEhkeOjY42914dTZ+UPUcVYNRzl17
         vTjhOd4RftOcj1GqQ0HycozKjEYkzojC6LTwOx46ljf/CL83rSN2xD6+JPz4YwEXOIUN
         dWvELeSu67XsMl8QA0lPxJV6c8a7TC+XbRoCqGemh7rYOilNV2XeNg9YQa8McHMQZjRq
         gK5gCDTM78EUdqPv24LtcS74CzO3yTdh2ZT5YgLUUX01SDAwzwmR1VCgfm5X/gKojpBw
         /LygtPvL6v+D8XoreIkvjL8gfDzom6WfLOMPauzldpmHXKe6W74il9O2qVY6ScIBuR/b
         XbKg==
X-Gm-Message-State: AOJu0YzBDWsT+8wDfBxiETJxSITDXJaILrLpSlQm6/+K/6cwKXzWpUp1
	EUvTafK7twLfmv35HWbrxBQQZR/KqdKnOiHJxl2EfrLFlIb6GsbX1kCss+pRm4ic/SDFh8uH0rH
	XrE4e+zSinPTfb+rqtXPnAl6sMcE+3q47TBhKCcUr
X-Gm-Gg: ASbGncvJPh8MP9KXAIJRYYQFJbGowSoTbNHdOE5YSO1mZBOPkZlLXuyqezeJbPvuu/O
	MItc4fdWYBMV5Y5GyR1mLfxrCs4FqBVfgCG34zJIkjEg2ELOdzU53yvW4KEz6ytF287KgviXtHu
	OSQ8F7sGfB5UeGUMYgty2RzA6qFaRLDr/aWr9C6IJdsPVcJYKiBybUS+egA6x9U7myD3e3CI2Js
	AGSVTo=
X-Google-Smtp-Source: AGHT+IEg2fONqFcuPbkvHSvdaQWL9AC5pLiTMJKYpsFoLYghSZ8SAhnIGrRn3LSgKjXg81dETxMVSTy5T/qS3dgr4ks=
X-Received: by 2002:a05:622a:49:b0:4a9:d263:d983 with SMTP id
 d75a77b69052e-4a9fbf49438mr3781321cf.22.1752244528763; Fri, 11 Jul 2025
 07:35:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709105946.4009897-1-tabba@google.com> <20250709105946.4009897-18-tabba@google.com>
 <868qkuajp2.wl-maz@kernel.org>
In-Reply-To: <868qkuajp2.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 11 Jul 2025 15:34:52 +0100
X-Gm-Features: Ac12FXzYWJsd6Iwz-ekA2LSj-AUmL9hUg1W3iguQuC8VOR_mqt0hoqU_djhQ6-A
Message-ID: <CA+EHjTxa+8ec8rX5R2_AY76Eq0PSurB3k4oXJtx8D0eSCx6kVw@mail.gmail.com>
Subject: Re: [PATCH v13 17/20] KVM: arm64: Enable host mapping of shared
 guest_memfd memory
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk, 
	shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, 
	jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com, 
	peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Fri, 11 Jul 2025 at 15:25, Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 09 Jul 2025 11:59:43 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Enable host userspace mmap support for guest_memfd-backed memory on
> > arm64. This change provides arm64 with the capability to map guest
> > memory at the host directly from guest_memfd:
> >
> > * Define kvm_arch_supports_gmem_mmap() for arm64: The
> >   kvm_arch_supports_gmem_mmap() macro is defined for arm64 to be true if
> >   CONFIG_KVM_GMEM_SUPPORTS_MMAP is enabled. For existing arm64 KVM VM
> >   types that support guest_memfd, this enables them to use guest_memfd
> >   with host userspace mappings. This provides a consistent behavior as
> >   there are currently no arm64 CoCo VMs that rely on guest_memfd solely
> >   for private, non-mappable memory. Future arm64 VM types can override
> >   or restrict this behavior via the kvm_arch_supports_gmem_mmap() hook
> >   if needed.
> >
> > * Select CONFIG_KVM_GMEM_SUPPORTS_MMAP in arm64 Kconfig.
> >
> > * Enforce KVM_MEMSLOT_GMEM_ONLY for guest_memfd on arm64: Compile and
> >   runtime checks are added to ensure that if guest_memfd is enabled on
> >   arm64, KVM_GMEM_SUPPORTS_MMAP must also be enabled. This means
> >   guest_memfd-backed memory slots on arm64 are currently only supported
> >   if they are intended for shared memory use cases (i.e.,
> >   kvm_memslot_is_gmem_only() is true). This design reflects the current
> >   arm64 KVM ecosystem where guest_memfd is primarily being introduced
> >   for VMs that support shared memory.
> >
> > Reviewed-by: James Houghton <jthoughton@google.com>
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 4 ++++
> >  arch/arm64/kvm/Kconfig            | 1 +
> >  arch/arm64/kvm/mmu.c              | 8 ++++++++
> >  3 files changed, 13 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index d27079968341..bd2af5470c66 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1675,5 +1675,9 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
> >  void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1);
> >  void check_feature_map(void);
> >
> > +#ifdef CONFIG_KVM_GMEM
> > +#define kvm_arch_supports_gmem(kvm) true
> > +#define kvm_arch_supports_gmem_mmap(kvm) IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP)
> > +#endif
> >
> >  #endif /* __ARM64_KVM_HOST_H__ */
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index 713248f240e0..28539479f083 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -37,6 +37,7 @@ menuconfig KVM
> >       select HAVE_KVM_VCPU_RUN_PID_CHANGE
> >       select SCHED_INFO
> >       select GUEST_PERF_EVENTS if PERF_EVENTS
> > +     select KVM_GMEM_SUPPORTS_MMAP
> >       help
> >         Support hosting virtualized guest machines.
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 71f8b53683e7..b92ce4d9b4e0 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -2274,6 +2274,14 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
> >       if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT))
> >               return -EFAULT;
> >
> > +     /*
> > +      * Only support guest_memfd backed memslots with mappable memory, since
> > +      * there aren't any CoCo VMs that support only private memory on arm64.
> > +      */
> > +     BUILD_BUG_ON(IS_ENABLED(CONFIG_KVM_GMEM) && !IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP));
> > +     if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
> > +             return -EINVAL;
> > +
> >       hva = new->userspace_addr;
> >       reg_end = hva + (new->npages << PAGE_SHIFT);
> >
>
> Honestly, I don't see the point in making CONFIG_KVM_GMEM a buy in. We
> have *no* configurability for KVM/arm64, the only exception being the
> PMU support, and that has been a pain at every step of the way.
>
> Either KVM is enabled, and it comes with "batteries included", or it's
> not. Either way, we know exactly what we're getting, and it makes
> reproducing problems much easier.

Batteries included is always best I think (all the times I got
disappointed as a kid..... sight :) ). I'll always enable guest_memfd
when KVM is enabled on arm64.

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

