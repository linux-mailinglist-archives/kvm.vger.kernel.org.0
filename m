Return-Path: <kvm+bounces-35669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6726AA13D29
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 16:03:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54F593A379A
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 15:03:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EBBD22B8DF;
	Thu, 16 Jan 2025 15:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e35hNg5u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6356DCE1
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 15:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737039783; cv=none; b=p8xGJNsr071Fn059App76tlB8UJfN+cB8Tmv12ciC9V054/5aNDxZPOvANYtB9F1yBJqjkHFVo/15bd1EaEmoWBQdezo78pEyB5tRh1K3pDkLF+62Zl2V+oNzdIEyi4b0M3uadyg1tomRqQwN4mejtBlPR07tFl4D50VK79a6dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737039783; c=relaxed/simple;
	bh=A30ZctwoXfsNf3EywXJmMJRQwL/MpikPxxAnMrPE3fk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bZVEftrPLYyWU18tQDB1snl3hW2AMku+Y/ggXVbfYIgoXsoK44cF4EOPxLQkE/wjCANYwu2mrYZSMwGNoclsO5my0TBmWWFXCICanBVMEsu2SgVcnWSGFq8ON5SftOCWLUrLjmych2twoNiUoDe8JvTEWqu1k1Yu18C5XP7G3w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e35hNg5u; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4368a290e0dso46385e9.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 07:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737039780; x=1737644580; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kqfFof4DiRiEcVNWi8Q8TQdmOIxGyZ0otuRpv/IQwnY=;
        b=e35hNg5uhBIL9g4rSVSVz1TGyGs9BkamhvpNsJ2kXhh1AeaZYoJS/G347SqgPdzBWy
         g6ZLDmPluTEvTVDD2tY7dZ+Hv/qyRiC69T4qkLCU9pXfRTt24VmDH6U33UstBvIgV8Xf
         LFD6SP8O+prBBxabTFUNcXvef8P7tT3LCKl2StwsH5DtVPa0jrrfSksBmhOUd5EmfCmo
         IAf+rFrz01BjBAjfqk40HyLZcL2mW5wJ85ZZDTRKVm/J3AENyuZi4VrJlHCCwmcT+ObZ
         yQTw9DOx+b6ZN33b1jnu44Au2W4ihQiz/b2QQwoy1ZX0U5jRN6H8kYekTMKvf6p1hjYh
         IXOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737039780; x=1737644580;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kqfFof4DiRiEcVNWi8Q8TQdmOIxGyZ0otuRpv/IQwnY=;
        b=BviaNnqh0ssYNmhfJo1Ukw1saG23go2nAqMNiN+6+Ta1M816Y5jrgA4kJf6SA0ni3a
         /6rhlhBztO7ngs5Qnv15z83Tu4ezKOhGYKGpSbZw+gaKJNJH0SmEzkR3E5RettMFLfNJ
         Ir9FqURpD5Jhg5Lyunns/JIZQ2RAJdP7lWicW7QMznSuYFhJpffi2tzUlk5mG6pjAzwh
         wfgu3+Va7oV8+w5Bt7tg1QmQQ99FosMqdgzDlUSb7D+ScZrqfc+oQUsNhiZqGdUAh2FA
         V77R9ZRtOgL7saXtiHyjwOcIH0D43fULcUhNivyJEWwIPcgYUDvxXENskAUtiigHc1uD
         6X/Q==
X-Gm-Message-State: AOJu0Yz6jo5sk6DQdniESitfCIdU957uxvYVqczX3pRQYy5zoRc9HLin
	S2YSpE5RyGLvyWluCiGdUHzp2h8gWXm/JtJl4trAtt07ZEBAfHUEn+NvVI0PpWV+YcxFUNdHJ/T
	sG0wkTSfVFe6JtANP9Omf4F0Stje/VNtNSPel
X-Gm-Gg: ASbGncv8KledJqg1xp4eLMTHWd005fItUyR1SwTCtexi4n1bRZYMycuYD7ePOcVwgOf
	qY6uspEDGNuRFxR925NTndWB0v/5/cUnT0+rlQTsl5glntIHy9/Dk7VfploVxhIVqoOg=
X-Google-Smtp-Source: AGHT+IHuSl+wSG7mPzyQ8i1CvkOu3Nq8nbQwjdEsJxg1QVxRkdYoVp//rZUu/ZKT6BmKz7T5dYlDGSX92vZeFHZaEpE=
X-Received: by 2002:a05:600c:1c84:b0:436:4e4c:7bae with SMTP id
 5b1f17b1804b1-4388b96edf5mr1026695e9.1.1737039777705; Thu, 16 Jan 2025
 07:02:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241213164811.2006197-1-tabba@google.com> <31f1229d-40c8-4a75-b0f1-be315150379f@amazon.co.uk>
In-Reply-To: <31f1229d-40c8-4a75-b0f1-be315150379f@amazon.co.uk>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 16 Jan 2025 15:02:21 +0000
X-Gm-Features: AbW1kvbTLlkR0MZtthgK7xg1MWWIvrDI_YynsmM_Oky84q5rjpd6sEQHrbgJ4aI
Message-ID: <CA+EHjTzCmmOnoAkXdE8JoURUwf=8by=+PX9LpB9NrfsWe5xAwg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 00/14] KVM: Restricted mapping of guest_memfd at
 the host and arm64 support
To: Patrick Roy <roypat@amazon.co.uk>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, 
	jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>, 
	"Cali, Marco" <xmarcalx@amazon.co.uk>, James Gowans <jgowans@amazon.com>
Content-Type: text/plain; charset="UTF-8"

Hi Patrick,

On Thu, 16 Jan 2025 at 14:48, Patrick Roy <roypat@amazon.co.uk> wrote:
>
> Hi Fuad!
>
> I finally got around to giving this patch series a spin for my non-CoCo
> usecase. I used the below diff to expose the functionality outside of pKVM
> (Based on Steven P.'s ARM CCA patch for custom VM types on ARM [2]).
> There's two small things that were broken for me (will post as responses
> to individual patches), but after fixing those, I was able to boot some
> guests using a modified Firecracker [1].

That's great, thanks for that, and for your comments on the patches.

> Just wondering, are you still looking into posting a separate series
> with just the MMU changes (e.g. something to have a bare-bones
> KVM_SW_PROTECTED_VM on ARM, like we do for x86), like you mentioned in
> the guest_memfd call before Christmas? We're pretty keen to
> get our hands something like that for our non-CoCo VMs (and ofc, am
> happy to help with any work required to get there :)

Yes I am. I'm almost done with it now. That said, I need to make it
work with attributes as well (as you mention in your comments on the
other patch). I should to send it out next week, before the biweekly
meeting in case we need to discuss it.

Cheers,
/fuad

> Best,
> Patrick
>
> [1]: https://github.com/roypat/firecracker/tree/secret-freedom-mmap
> [2]: https://lore.kernel.org/kvm/20241004152804.72508-12-steven.price@arm.com/
>
> ---
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 8dfae9183651..0b8dfb855e51 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -380,6 +380,8 @@ struct kvm_arch {
>          * the associated pKVM instance in the hypervisor.
>          */
>         struct kvm_protected_vm pkvm;
> +
> +       unsigned long type;
>  };
>
>  struct kvm_vcpu_fault_info {
> @@ -1529,7 +1531,11 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
>  #define kvm_has_s1poe(k)                               \
>         (kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
>
> -#define kvm_arch_has_private_mem(kvm)                                  \
> -       (IS_ENABLED(CONFIG_KVM_PRIVATE_MEM) && is_protected_kvm_enabled())
> +#ifdef CONFIG_KVM_PRIVATE_MEM
> +#define kvm_arch_has_private_mem(kvm)  \
> +       ((kvm)->arch.type == KVM_VM_TYPE_ARM_SW_PROTECTED || is_protected_kvm_enabled())
> +#else
> +#define kvm_arch_has_private_mem(kvm) false
> +#endif
>
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index fe3451f244b5..2da26aa3b0b5 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -38,6 +38,7 @@ menuconfig KVM
>         select HAVE_KVM_VCPU_RUN_PID_CHANGE
>         select SCHED_INFO
>         select GUEST_PERF_EVENTS if PERF_EVENTS
> +       select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
>         select KVM_GMEM_MAPPABLE
>         help
>           Support hosting virtualized guest machines.
> @@ -84,4 +85,10 @@ config PTDUMP_STAGE2_DEBUGFS
>
>           If in doubt, say N.
>
> +config KVM_SW_PROTECTED_VM
> +    bool "Enable support for KVM software-protected VMs"
> +    depends on EXPERT
> +    depends on KVM && ARM64
> +    select KVM_GENERIC_PRIVATE_MEM
> +
>  endif # VIRTUALIZATION
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index a102c3aebdbc..35683868c0e4 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -181,6 +181,19 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>         mutex_unlock(&kvm->lock);
>  #endif
>
> +       if (type & ~(KVM_VM_TYPE_ARM_MASK | KVM_VM_TYPE_ARM_IPA_SIZE_MASK))
> +               return -EINVAL;
> +
> +       switch (type & KVM_VM_TYPE_ARM_MASK) {
> +       case KVM_VM_TYPE_ARM_NORMAL:
> +       case KVM_VM_TYPE_ARM_SW_PROTECTED:
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       kvm->arch.type = type & KVM_VM_TYPE_ARM_MASK;
> +
>         kvm_init_nested(kvm);
>
>         ret = kvm_share_hyp(kvm, kvm + 1);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1c4b3871967c..9dbb472eb96a 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -869,9 +869,6 @@ static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
>         u64 mmfr0, mmfr1;
>         u32 phys_shift;
>
> -       if (type & ~KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
> -               return -EINVAL;
> -
>         phys_shift = KVM_VM_TYPE_ARM_IPA_SIZE(type);
>         if (is_protected_kvm_enabled()) {
>                 phys_shift = kvm_ipa_limit;
> @@ -2373,3 +2370,31 @@ void kvm_toggle_cache(struct kvm_vcpu *vcpu, bool was_enabled)
>
>         trace_kvm_toggle_cache(*vcpu_pc(vcpu), was_enabled, now_enabled);
>  }
> +
> +#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> +bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
> +                                       struct kvm_gfn_range *range)
> +{
> +       /*
> +        * Zap SPTEs even if the slot can't be mapped PRIVATE.  KVM only
> +        * supports KVM_MEMORY_ATTRIBUTE_PRIVATE, and so it *seems* like KVM
> +        * can simply ignore such slots.  But if userspace is making memory
> +        * PRIVATE, then KVM must prevent the guest from accessing the memory
> +        * as shared.  And if userspace is making memory SHARED and this point
> +        * is reached, then at least one page within the range was previously
> +        * PRIVATE, i.e. the slot's possible hugepage ranges are changing.
> +        * Zapping SPTEs in this case ensures KVM will reassess whether or not
> +        * a hugepage can be used for affected ranges.
> +        */
> +       if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
> +               return false;
> +
> +       return kvm_unmap_gfn_range(kvm, range);
> +}
> +
> +bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
> +                                        struct kvm_gfn_range *range)
> +{
> +       return false;
> +}
> +#endif
> \ No newline at end of file
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index b34aed04ffa5..214f6b5da43f 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -653,6 +653,13 @@ struct kvm_enable_cap {
>   * PA size shift (i.e, log2(PA_Size)). For backward compatibility,
>   * value 0 implies the default IPA size, 40bits.
>   */
> +#define KVM_VM_TYPE_ARM_SHIFT              8
> +#define KVM_VM_TYPE_ARM_MASK               (0xfULL << KVM_VM_TYPE_ARM_SHIFT)
> +#define KVM_VM_TYPE_ARM(_type)         \
> +       (((_type) << KVM_VM_TYPE_ARM_SHIFT) & KVM_VM_TYPE_ARM_MASK)
> +#define KVM_VM_TYPE_ARM_NORMAL             KVM_VM_TYPE_ARM(0)
> +#define KVM_VM_TYPE_ARM_SW_PROTECTED    KVM_VM_TYPE_ARM(1)
> +
>  #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK  0xffULL
>  #define KVM_VM_TYPE_ARM_IPA_SIZE(x)            \
>         ((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
>
>
> On Fri, 2024-12-13 at 16:47 +0000, Fuad Tabba wrote:
> > This series adds restricted mmap() support to guest_memfd, as
> > well as support for guest_memfd on arm64. It is based on Linux
> > 6.13-rc2.  Please refer to v3 for the context [1].
> >
> > Main changes since v3:
> > - Added a new folio type for guestmem, used to register a
> >   callback when a folio's reference count reaches 0 (Matthew
> >   Wilcox, DavidH) [2]
> > - Introduce new mappability states for folios, where a folio can
> > be mappable by the host and the guest, only the guest, or by no
> > one (transient state)
> > - Rebased on Linux 6.13-rc2
> > - Refactoring and tidying up
> >
> > Cheers,
> > /fuad
> >
> > [1] https://lore.kernel.org/all/20241010085930.1546800-1-tabba@google.com/
> > [2] https://lore.kernel.org/all/20241108162040.159038-1-tabba@google.com/
> >
> > Ackerley Tng (2):
> >   KVM: guest_memfd: Make guest mem use guest mem inodes instead of
> >     anonymous inodes
> >   KVM: guest_memfd: Track mappability within a struct kvm_gmem_private
> >
> > Fuad Tabba (12):
> >   mm: Consolidate freeing of typed folios on final folio_put()
> >   KVM: guest_memfd: Introduce kvm_gmem_get_pfn_locked(), which retains
> >     the folio lock
> >   KVM: guest_memfd: Folio mappability states and functions that manage
> >     their transition
> >   KVM: guest_memfd: Handle final folio_put() of guestmem pages
> >   KVM: guest_memfd: Allow host to mmap guest_memfd() pages when shared
> >   KVM: guest_memfd: Add guest_memfd support to
> >     kvm_(read|/write)_guest_page()
> >   KVM: guest_memfd: Add KVM capability to check if guest_memfd is host
> >     mappable
> >   KVM: guest_memfd: Add a guest_memfd() flag to initialize it as
> >     mappable
> >   KVM: guest_memfd: selftests: guest_memfd mmap() test when mapping is
> >     allowed
> >   KVM: arm64: Skip VMA checks for slots without userspace address
> >   KVM: arm64: Handle guest_memfd()-backed guest page faults
> >   KVM: arm64: Enable guest_memfd private memory when pKVM is enabled
> >
> >  Documentation/virt/kvm/api.rst                |   4 +
> >  arch/arm64/include/asm/kvm_host.h             |   3 +
> >  arch/arm64/kvm/Kconfig                        |   1 +
> >  arch/arm64/kvm/mmu.c                          | 119 +++-
> >  include/linux/kvm_host.h                      |  75 +++
> >  include/linux/page-flags.h                    |  22 +
> >  include/uapi/linux/kvm.h                      |   2 +
> >  include/uapi/linux/magic.h                    |   1 +
> >  mm/debug.c                                    |   1 +
> >  mm/swap.c                                     |  28 +-
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  .../testing/selftests/kvm/guest_memfd_test.c  |  64 +-
> >  virt/kvm/Kconfig                              |   4 +
> >  virt/kvm/guest_memfd.c                        | 579 +++++++++++++++++-
> >  virt/kvm/kvm_main.c                           | 229 ++++++-
> >  15 files changed, 1074 insertions(+), 59 deletions(-)
> >
> >
> > base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
> > --
> > 2.47.1.613.gc27f4b7a9f-goog

