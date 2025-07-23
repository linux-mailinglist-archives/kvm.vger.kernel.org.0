Return-Path: <kvm+bounces-53195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 49F12B0EE3C
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 11:19:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1E4CE5681CB
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 09:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 776372820C6;
	Wed, 23 Jul 2025 09:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SB6TSAYT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20246271454
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 09:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753262345; cv=none; b=HpimkCzUmvx64Y0+r21Ps9eNEZkNRdivejj9sbYO6hLz1OVVs6EjlVslKa6TAMl/ZQHj1EGwwr6OmnDfmapynNJh34VS6kmvJCDJBz0R8c42piM/cRTS3b02r6vE4Lz1yTWj3In0+7soW0yCPnIQaRA8XlLVplx9k/N39a1LJVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753262345; c=relaxed/simple;
	bh=idmQmOpX6xjvfYbM56fP1LbrUFARTFTQP9VymBIxlTE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E+dYRYrCy/IN1TVIsoMHWfkea33NgX2tL869Nr807glbRUrwUkFdRcMcRfV93lSsIfS4DogM4T708epIrmPLlfBGJinrEPukZZoJS9qy0hlZsnaWuLHDd1rj4VW9VYC6zIkRC8Cvtutsv6EX7EZcSJvOwapEtRhgCYtTadcmNa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SB6TSAYT; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso348581cf.0
        for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 02:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753262342; x=1753867142; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fFB2lKlzZGrzhbM4PzD3lroism4M1bEmsmifGbcd/Mo=;
        b=SB6TSAYTvdFHbAosX1WzNcUeFVRRrC6p+8gK83MQy5EoVSK1hfC9ilQo03MkstnME3
         w9+E/A/S4Fpnzh71v/8DJ8vvIvZq9mzlMz6XusFc8HkdSY8galwtj2GMf1vI+xxh+GoF
         lR8pSnHOtgNUppuc3+fQ26ea5s0aL6UPIequb8Aur/Rv2lmpoDZo0QgUzX74r/PeIOZl
         7WN+tN9DYNtch5We1JgJbjSMU04ALyApUBRaVZQ3GW9RDUaje+TlampA0HNz2/kolS1h
         qwBir7QWaz8bEoERLeLt5V2jQDETkLFqISIGnX4/GSiO2KXn0CjYIRe51N5bRNy9rLBz
         ZwSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753262342; x=1753867142;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fFB2lKlzZGrzhbM4PzD3lroism4M1bEmsmifGbcd/Mo=;
        b=LNeLxc1mysx4n5fz7uKH4bdVD738mC9HLilwzMxq7CysnziUnZYqxKfC08s0Ed344B
         h/d2MCiriypuQwmB9ab5CSd8NkMF6VDo2cepzquaa2U01HkwEoQPjHr4BDfj8l6NBc7n
         M2BmU+8isYd+9Rw6LBjsDNtjXXrTZGqtTe8F3wmjXOLv6AMXH73Jo2c1+TLWnXs8ehFw
         AeztWfKQMXvlSO85kkJMiD7WSJYtAxl3zzl3fF507K6h9juY5pBg3WS2DVRFTjcph/NH
         VXMaqmyz3dE5rwTlLmtlQ5VFd6yExYzq2/1NcqtN/RNw5oPWpLRztdQVl638XwgqLx0X
         Z1LA==
X-Gm-Message-State: AOJu0YxvbpfRP+t7NFQ6ZnopDgOHmhkYWTwNTiQW/uO8n8gba+HYfLjc
	K/OPjytcwfnVc0G1ErDULuVJgmh8OuSsD4PouvmbV1Iv1SWPqrtdFHKXrBMlofLgUrcwKA5Wv3V
	gQs0a7VzwfgL0SN3KEAHnJHtV9YOS2NX9szQl763V
X-Gm-Gg: ASbGncuiOs+Z7nlUwbQhLqfbZKs2Y8gs9cElcreA7uXikuMFlEl++EZdkiwRiOBZ8z8
	9yJzd+wR658VXdMBtU+SDviizc/u/pGBmWERUKPZjYy2C6Hfc9nl61eMy64A4AtpbweW/ldhC/z
	ikEhxWYetIS1El/NtjcyEci/2xCtl9c/LudkmnBPcr6RlyNOt/BytD7Tofcq0ujY4d/Yq3EsqS7
	MDGr9/NEFmQdBC/h102dIpy4T5SmEobypjk
X-Google-Smtp-Source: AGHT+IHdI2zc5g2uWgDeX7Xhmwb1mpmaFyW9th1coHtjrfDNoMegvkEq3o1bYX03LBqz87TbJvCehtEqjQU8oKdI5oI=
X-Received: by 2002:a05:622a:a6d1:b0:476:f1a6:d8e8 with SMTP id
 d75a77b69052e-4ae6f066f1dmr2244731cf.11.1753262341305; Wed, 23 Jul 2025
 02:19:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-19-tabba@google.com>
 <87ldoftifr.wl-maz@kernel.org>
In-Reply-To: <87ldoftifr.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 23 Jul 2025 10:18:24 +0100
X-Gm-Features: Ac12FXyK6HoWGYh74-rCEgCwyYrKUEnXSOccYJU3yg7243P0WML9CgqAKaoNvVc
Message-ID: <CA+EHjTyD6kXBGF0QitHtALSmX5rVDe7Sew99dwEEPXzjnPzfXQ@mail.gmail.com>
Subject: Re: [PATCH v15 18/21] KVM: arm64: Enable host mapping of shared
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

On Wed, 23 Jul 2025 at 09:33, Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 17 Jul 2025 17:27:28 +0100,
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
> > * Enforce KVM_MEMSLOT_GMEM_ONLY for guest_memfd on arm64: Checks are
> >   added to ensure that if guest_memfd is enabled on arm64,
> >   KVM_GMEM_SUPPORTS_MMAP must also be enabled. This means
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
> >  arch/arm64/kvm/Kconfig            | 2 ++
> >  arch/arm64/kvm/mmu.c              | 7 +++++++
> >  3 files changed, 13 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 3e41a880b062..63f7827cfa1b 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1674,5 +1674,9 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
> >  void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1);
> >  void check_feature_map(void);
> >
> > +#ifdef CONFIG_KVM_GMEM
> > +#define kvm_arch_supports_gmem(kvm) true
> > +#define kvm_arch_supports_gmem_mmap(kvm) IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP)
> > +#endif
>
> nit: these two lines should be trivially 'true', and the #ifdef-ery
> removed, since both KVM_GMEM and KVM_GMEM_SUPPORTS_MMAP are always
> selected, no ifs, no buts.

I'll fix these.

> >
> >  #endif /* __ARM64_KVM_HOST_H__ */
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> > index 713248f240e0..323b46b7c82f 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -37,6 +37,8 @@ menuconfig KVM
> >       select HAVE_KVM_VCPU_RUN_PID_CHANGE
> >       select SCHED_INFO
> >       select GUEST_PERF_EVENTS if PERF_EVENTS
> > +     select KVM_GMEM
> > +     select KVM_GMEM_SUPPORTS_MMAP
> >       help
> >         Support hosting virtualized guest machines.
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 8c82df80a835..85559b8a0845 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -2276,6 +2276,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
> >       if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT))
> >               return -EFAULT;
> >
> > +     /*
> > +      * Only support guest_memfd backed memslots with mappable memory, since
> > +      * there aren't any CoCo VMs that support only private memory on arm64.
> > +      */
> > +     if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
> > +             return -EINVAL;
> > +
> >       hva = new->userspace_addr;
> >       reg_end = hva + (new->npages << PAGE_SHIFT);
> >
>
> Otherwise,
>
> Reviewed-by: Marc Zyngier <maz@kernel.org>

Thanks for the reviews!

Cheers,
/fuad

>         M.
>
> --
> Jazz isn't dead. It just smells funny.

