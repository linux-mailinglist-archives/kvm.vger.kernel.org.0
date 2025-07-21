Return-Path: <kvm+bounces-53012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4B44B0C919
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 18:52:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 009CA3B502C
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:52:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBF002E0922;
	Mon, 21 Jul 2025 16:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mtlQOMFK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64842DAFCF
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 16:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753116755; cv=none; b=L/2GmmTUZr9cXtVmze7h62RhsYNhTuMeKpAwH5A+UM3SFsf0/XAlXnsCoo2nSRmksniyqDrPy74nqGJBT28ufiaJ6gcZwww1vDF/TRm3MwvCnv44BiDKRAOo7syqGX0sCprrl6PeIpFLZVhuBxXzlSc6LycFqtNRDqpuQ4rtF2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753116755; c=relaxed/simple;
	bh=YTgoCtcIb1Xocy2i/gsYLmx5ar4S6QDlw5nb+Ar94wc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JUgLdwaylbo7vEbV392RIhXl6rwBrk9PM2pGok8UXo0GWlhdRe4EG/oNLtH5KUmKvjN1kscf5eJ5CVmtMQruMhAnhOSDITRBgvoiVJ78YUNAczL6TqHiRhLJRBOMeRVXSX3hck1qUk1IFw2LowU4N4PKecjvVTBJ7IkXsTcJ2a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mtlQOMFK; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ab3855fca3so7451cf.1
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 09:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753116752; x=1753721552; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OVbIhPTZSUfrHjiY+ZSOVnOk9LC04Qu6SThiAjt8gV0=;
        b=mtlQOMFKyg2+HdqIF0FAWQG1khBAE0tO4EcIkos9513NoHQF4FpTRUAysF5SQZn/3q
         hsSFRJpG49l3SyzkqG3uiEP5TPnLnxTt6biAiT+dYTEKh5aHDNa084j+H/793dgcq8uH
         jHZES6eTe3vDeQlOsbFzXhRWKFAnzJUR24Xk8SAZ3dD9f9XqX0ijuDHXscf1fcquX1kM
         7w222uRYYOeD9DHk+8RwVYmnS1OfYMb2Gj6SSblg+iWIdZj8JL3deysL5m9RVf8BDq4I
         h602navEBvz9ks3U3voFAr4997TLcKIowEsw5jwmVvQvKop3UTOTO/EN+tUDZVEP5AVf
         h18A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753116752; x=1753721552;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OVbIhPTZSUfrHjiY+ZSOVnOk9LC04Qu6SThiAjt8gV0=;
        b=pjaK6QsGaJu0FQetetLBuUq1E7IrJdpq3k3+lhAG0Kyl4BkLaGzX+StXRo3/6aVHvj
         O7ZPEvEmBkNwh55+K65E107wAn5Fz5RlcS3pQ90zNOw2e4jrMf1X41aSOJiK03twlXkg
         UxzRNJnvhfvJDTc3GsYa2c69FD/jb7GOpMmZM+M2WPJd/6HO5fv4Z37CEenSTp5NPKTU
         j7O3u6QZ8iiqrAhtmMBTELIC2bUl25EqWwSFsqIlELVZjWLOcySpExNrQo7BraQHub4x
         kTxZGWx6TffM7hrzKY4p3FDoBkIp8h72eKibkiUpNDQPfJkvjPlF5k4IQxKl72oiA7BX
         E14w==
X-Gm-Message-State: AOJu0Yye56J+1oTIh6QXxbHhBy5R2KzkgnT1YV2zp6dwZUk+AiKqlj0p
	NRf1O0ZLMKS17NJQ+66Ja7mqI4FH8BSHxu0l3+sLmKi2uhISwkrYv0ZQucQgkOa07xXVJgtocpC
	PHjx9/wjX9eHPdFIFCjUbU9hMVurq+MQaWmrR2s+6
X-Gm-Gg: ASbGnctxWBJwXfNbV0zJ9LP+CS2l6R+x2kzLp0y2auwI9hxiota3sBIjCtJKw9Pm3v1
	d8mL62pnZXV1UhgLtiJXjY2Yw26Y49rk+hKpXFQvVmXFNbRIrAw/noDBDXhb7kCNvpMtf6xZZHJ
	UOoiSjCwBuo2ZsZIpaMruliutFFcqxt/x1msoWhRZePJ3W1sUI8oItoUijzMhfIOXQ7bVuGRdmE
	rTeL7Q=
X-Google-Smtp-Source: AGHT+IGV+dnDsh5YHuf/aDQfWo6BcIQgZhCb9E1Soa3+RVgn/fIxPWs+msRMFxUTUC6jIZslol/Y1mO5mr2H1LacLlw=
X-Received: by 2002:a05:622a:1a04:b0:4a9:e17a:6288 with SMTP id
 d75a77b69052e-4ae5b7e8042mr322701cf.13.1753116750962; Mon, 21 Jul 2025
 09:52:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-3-tabba@google.com>
 <aH5uY74Uev9hEWbM@google.com>
In-Reply-To: <aH5uY74Uev9hEWbM@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 21 Jul 2025 17:51:54 +0100
X-Gm-Features: Ac12FXxB4yJHaicF6fJ6C594q60dkOxhyVSDn9pX_r-kqLs7h5_EmkqV1iY7K5k
Message-ID: <CA+EHjTxcgCLzwK5k+rTf2v_ufgsX0AcEzhy0EQL-pvmsg9QQeg@mail.gmail.com>
Subject: Re: [PATCH v15 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
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
Content-Type: text/plain; charset="UTF-8"

Hi Sean,

On Mon, 21 Jul 2025 at 17:44, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jul 17, 2025, Fuad Tabba wrote:
> > The original name was vague regarding its functionality.
>
> It was intentionally vague/broad so that KVM didn't end up with an explosion of
> Kconfigs.
>
> > This Kconfig option specifically enables and gates the kvm_gmem_populate()
> > function, which is responsible for populating a GPA range with guest data.
>
> And obviously selects KVM_GENERIC_MEMORY_ATTRIBUTES...
>
> > The new name, KVM_GENERIC_GMEM_POPULATE, describes the purpose of the
> > option: to enable generic guest_memfd population mechanisms.
>
> As above, the purpose of KVM_GENERIC_PRIVATE_MEM isn't just to enable
> kvm_gmem_populate().  In fact, the Kconfig predates kvm_gmem_populate().  The
> main reason KVM_GENERIC_PRIVATE_MEM was added was to avoid having to select the
> same set of Kconfigs in every flavor of CoCo-ish VM, i.e. was to avoid what this
> patch does.
>
> There was a bit of mis-speculation in that x86 ended up being the only arch that
> wants KVM_GENERIC_MEMORY_ATTRIBUTES, so we should simply remedy that.  Providing
> KVM_PRIVATE_MEM in x86 would also clean up this mess:
>
>         select KVM_GMEM if KVM_SW_PROTECTED_VM
>         select KVM_GENERIC_MEMORY_ATTRIBUTES if KVM_SW_PROTECTED_VM
>         select KVM_GMEM_SUPPORTS_MMAP if X86_64
>
> Where KVM_GMEM_SUPPORTS_MMAP and thus KVM_GUEST_MEMFD is selected by X86_64.
> I.e. X86_64 is subtly *unconditionally* enabling guest_memfd.  I have no objection
> to always supporting guest_memfd for 64-bit, but it should be obvious, not buried
> in a Kconfig config.
>
> More importantly, the above means it's impossible to have KVM_GMEM without
> KVM_GMEM_SUPPORTS_MMAP, because arm64 always selects KVM_GMEM_SUPPORTS_MMAP, and
> x86 can only select KVM_GMEM when KVM_GMEM_SUPPORTS_MMAP is forced/selected.
>
> Following that trail of breadcrumbs, x86 ends up with another tautology that isn't
> captured.  kvm_arch_supports_gmem() is true for literally every type of VM.  It
> isn't true for every #defined VM type, since it's not allowed for KVM_X86_SEV_VM
> or KVM_X86_SEV_ES_VM.  But those are recent additions that are entirely optional.
> I.e. userspace can create SEV and/or SEV-ES VMs using KVM_X86_DEFAULT_VM.
>
> And if we fix that oddity, and follow more breadcrumbs, we arrive at
> kvm_arch_supports_gmem_mmap(), where it unnecessarily open codes a check on
> KVM_X86_DEFAULT_VM when in fact the real restriction is that guest_memfd mmap()
> is currently incompatible with kvm_arch_has_private_mem().
>
> I already have a NAK typed up for patch 3 for completely unrelated reasons (adding
> arch.supports_gmem creates unnecessary potential for bugs, e.g. allows checking
> kvm_arch_supports_gmem() before the flag is set).  That's all the more reason to
> kill off as many of these #defines and checks as possible.
>
> Oh, and that also ties into Xiaoyao's question about what to do with mapping
> guest_memfd into a memslot without a guest_memfd file descriptor.  Once we add
> private vs. shared tracking in guest_memfd, kvm_arch_supports_gmem_mmap() becomes
> true if CONFIG_KVM_GUEST_MEMFD=y.
>
> Heh, so going through all of that, KVM_PRIVATE_MEM just ends up being this:
>
> config KVM_PRIVATE_MEM
>         depends on X86_64
>         select KVM_GENERIC_MEMORY_ATTRIBUTES
>         bool
>
> which means my initial feedback that prompted this becomes null and void :-)

:)

> That said, I think we should take this opportunity to select KVM_GENERIC_MEMORY_ATTRIBUTES
> directly instead of having it selected from "config KVM".  There's a similar
> oddity with TDX.
>
> > improves clarity for developers and ensures the name accurately reflects
> > the functionality it controls, especially as guest_memfd support expands
> > beyond purely "private" memory scenarios.
> >
> > Note that the vm type KVM_X86_SW_PROTECTED_VM does not need the populate
> > function. Therefore, ensure that the correct configuration is selected
> > when KVM_SW_PROTECTED_VM is enabled.
> >
> > Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Reviewed-by: Shivank Garg <shivankg@amd.com>
> > Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> > Co-developed-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/x86/kvm/Kconfig     | 7 ++++---
> >  include/linux/kvm_host.h | 2 +-
> >  virt/kvm/Kconfig         | 2 +-
> >  virt/kvm/guest_memfd.c   | 2 +-
> >  4 files changed, 7 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> > index 2eeffcec5382..12e723bb76cc 100644
> > --- a/arch/x86/kvm/Kconfig
> > +++ b/arch/x86/kvm/Kconfig
> > @@ -46,7 +46,8 @@ config KVM_X86
> >       select HAVE_KVM_PM_NOTIFIER if PM
> >       select KVM_GENERIC_HARDWARE_ENABLING
> >       select KVM_GENERIC_PRE_FAULT_MEMORY
> > -     select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
> > +     select KVM_GMEM if KVM_SW_PROTECTED_VM
> > +     select KVM_GENERIC_MEMORY_ATTRIBUTES if KVM_SW_PROTECTED_VM
> >       select KVM_WERROR if WERROR
> >
> >  config KVM
> > @@ -95,7 +96,7 @@ config KVM_SW_PROTECTED_VM
> >  config KVM_INTEL
> >       tristate "KVM for Intel (and compatible) processors support"
> >       depends on KVM && IA32_FEAT_CTL
> > -     select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
> > +     select KVM_GENERIC_GMEM_POPULATE if INTEL_TDX_HOST
> >       select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
> >       help
> >         Provides support for KVM on processors equipped with Intel's VT
> > @@ -157,7 +158,7 @@ config KVM_AMD_SEV
> >       depends on KVM_AMD && X86_64
> >       depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
> >       select ARCH_HAS_CC_PLATFORM
> > -     select KVM_GENERIC_PRIVATE_MEM
> > +     select KVM_GENERIC_GMEM_POPULATE
> >       select HAVE_KVM_ARCH_GMEM_PREPARE
> >       select HAVE_KVM_ARCH_GMEM_INVALIDATE
> >       help
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 755b09dcafce..359baaae5e9f 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -2556,7 +2556,7 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
> >  int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
> >  #endif
> >
> > -#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
> > +#ifdef CONFIG_KVM_GENERIC_GMEM_POPULATE
> >  /**
> >   * kvm_gmem_populate() - Populate/prepare a GPA range with guest data
> >   *
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > index 49df4e32bff7..559c93ad90be 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -116,7 +116,7 @@ config KVM_GMEM
> >         select XARRAY_MULTI
> >         bool
> >
> > -config KVM_GENERIC_PRIVATE_MEM
> > +config KVM_GENERIC_GMEM_POPULATE
> >         select KVM_GENERIC_MEMORY_ATTRIBUTES
> >         select KVM_GMEM
>
> This is where things really start to break down.  Selecting KVM_GUEST_MEMFD and
> KVM_GENERIC_MEMORY_ATTRIBUTES when KVM_GENERIC_PRIVATE_MEM=y is decent logic.
> *Selecting* KVM_GUEST_MEMFD from a sub-feature of guest_memfd is weird.
>
> I don't love HAVE_KVM_ARCH_GMEM_INVALIDATE and HAVE_KVM_ARCH_GMEM_PREPARE, as I
> think they're too fine-grained.  But that's largely an orthogonal problem, and
> it's not clear that bundling them together would be an improvement.  So, I think
> we should just follow those and add HAVE_KVM_ARCH_GMEM_POPULATE, selected by SEV
> and TDX.
>
> The below diff applies on top.  I'm guessing there may be some intermediate
> ugliness (I haven't mapped out exactly where/how to squash this throughout the
> series, and there is feedback relevant to future patches), but IMO this is a much
> cleaner resting state (see the diff stats).

So just so that I am clear, applying the diff below to the appropriate
patches would address all the concerns that you have mentioned in this
email?

Thanks,
/fuad

> ---
>  arch/arm64/include/asm/kvm_host.h |  5 -----
>  arch/arm64/kvm/Kconfig            |  3 +--
>  arch/x86/include/asm/kvm_host.h   | 15 +-------------
>  arch/x86/kvm/Kconfig              | 10 +++++----
>  arch/x86/kvm/x86.c                | 13 ++++++++++--
>  include/linux/kvm_host.h          | 34 +++++--------------------------
>  virt/kvm/Kconfig                  | 11 +++-------
>  virt/kvm/guest_memfd.c            | 10 +++++----
>  virt/kvm/kvm_main.c               |  8 +++-----
>  9 files changed, 36 insertions(+), 73 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 63f7827cfa1b..3408174ec945 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1674,9 +1674,4 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
>  void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1);
>  void check_feature_map(void);
>
> -#ifdef CONFIG_KVM_GMEM
> -#define kvm_arch_supports_gmem(kvm) true
> -#define kvm_arch_supports_gmem_mmap(kvm) IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP)
> -#endif
> -
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 323b46b7c82f..bff62e75d681 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -37,8 +37,7 @@ menuconfig KVM
>         select HAVE_KVM_VCPU_RUN_PID_CHANGE
>         select SCHED_INFO
>         select GUEST_PERF_EVENTS if PERF_EVENTS
> -       select KVM_GMEM
> -       select KVM_GMEM_SUPPORTS_MMAP
> +       select KVM_GUEST_MEMFD
>         help
>           Support hosting virtualized guest machines.
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e1426adfa93e..d93560769465 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2276,21 +2276,8 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>                        int tdp_max_root_level, int tdp_huge_page_level);
>
>
> -#ifdef CONFIG_KVM_GMEM
> +#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>  #define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
> -#define kvm_arch_supports_gmem(kvm)  ((kvm)->arch.supports_gmem)
> -
> -/*
> - * CoCo VMs with hardware support that use guest_memfd only for backing private
> - * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
> - */
> -#define kvm_arch_supports_gmem_mmap(kvm)               \
> -       (IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&   \
> -        (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM)
> -#else
> -#define kvm_arch_has_private_mem(kvm) false
> -#define kvm_arch_supports_gmem(kvm) false
> -#define kvm_arch_supports_gmem_mmap(kvm) false
>  #endif
>
>  #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 2eeffcec5382..afcf8628f615 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -46,8 +46,8 @@ config KVM_X86
>         select HAVE_KVM_PM_NOTIFIER if PM
>         select KVM_GENERIC_HARDWARE_ENABLING
>         select KVM_GENERIC_PRE_FAULT_MEMORY
> -       select KVM_GENERIC_PRIVATE_MEM if KVM_SW_PROTECTED_VM
>         select KVM_WERROR if WERROR
> +       select KVM_GUEST_MEMFD if X86_64
>
>  config KVM
>         tristate "Kernel-based Virtual Machine (KVM) support"
> @@ -84,6 +84,7 @@ config KVM_SW_PROTECTED_VM
>         bool "Enable support for KVM software-protected VMs"
>         depends on EXPERT
>         depends on KVM && X86_64
> +       select KVM_GENERIC_MEMORY_ATTRIBUTES
>         help
>           Enable support for KVM software-protected VMs.  Currently, software-
>           protected VMs are purely a development and testing vehicle for
> @@ -95,8 +96,6 @@ config KVM_SW_PROTECTED_VM
>  config KVM_INTEL
>         tristate "KVM for Intel (and compatible) processors support"
>         depends on KVM && IA32_FEAT_CTL
> -       select KVM_GENERIC_PRIVATE_MEM if INTEL_TDX_HOST
> -       select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
>         help
>           Provides support for KVM on processors equipped with Intel's VT
>           extensions, a.k.a. Virtual Machine Extensions (VMX).
> @@ -135,6 +134,8 @@ config KVM_INTEL_TDX
>         bool "Intel Trust Domain Extensions (TDX) support"
>         default y
>         depends on INTEL_TDX_HOST
> +       select KVM_GENERIC_MEMORY_ATTRIBUTES
> +       select HAVE_KVM_ARCH_GMEM_POPULATE
>         help
>           Provides support for launching Intel Trust Domain Extensions (TDX)
>           confidential VMs on Intel processors.
> @@ -157,9 +158,10 @@ config KVM_AMD_SEV
>         depends on KVM_AMD && X86_64
>         depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
>         select ARCH_HAS_CC_PLATFORM
> -       select KVM_GENERIC_PRIVATE_MEM
> +       select KVM_GENERIC_MEMORY_ATTRIBUTES
>         select HAVE_KVM_ARCH_GMEM_PREPARE
>         select HAVE_KVM_ARCH_GMEM_INVALIDATE
> +       select HAVE_KVM_ARCH_GMEM_POPULATE
>         help
>           Provides support for launching encrypted VMs which use Secure
>           Encrypted Virtualization (SEV), Secure Encrypted Virtualization with
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ca99187a566e..b6961b4b7aee 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12781,8 +12781,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>
>         kvm->arch.vm_type = type;
>         kvm->arch.has_private_mem = (type == KVM_X86_SW_PROTECTED_VM);
> -       kvm->arch.supports_gmem =
> -               type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
>         /* Decided by the vendor code for other VM types.  */
>         kvm->arch.pre_fault_allowed =
>                 type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
> @@ -13708,6 +13706,16 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
>  }
>  EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
>
> +#ifdef CONFIG_KVM_GUEST_MEMFD
> +/*
> + * KVM doesn't yet support mmap() on guest_memfd for VMs with private memory
> + * (the private vs. shared tracking needs to be moved into guest_memfd).
> + */
> +bool kvm_arch_supports_gmem_mmap(struct kvm *kvm)
> +{
> +       return !kvm_arch_has_private_mem(kvm);
> +}
> +
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
>  int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
>  {
> @@ -13721,6 +13729,7 @@ void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
>         kvm_x86_call(gmem_invalidate)(start, end);
>  }
>  #endif
> +#endif
>
>  int kvm_spec_ctrl_test_value(u64 value)
>  {
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 2c1dcd3967d9..a9f31b2b63b1 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -719,39 +719,15 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>  }
>  #endif
>
> -/*
> - * Arch code must define kvm_arch_has_private_mem if support for guest_memfd is
> - * enabled.
> - */
> -#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
> +#ifndef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>  static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>  {
>         return false;
>  }
>  #endif
>
> -/*
> - * Arch code must define kvm_arch_supports_gmem if support for guest_memfd is
> - * enabled.
> - */
> -#if !defined(kvm_arch_supports_gmem) && !IS_ENABLED(CONFIG_KVM_GMEM)
> -static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
> -{
> -       return false;
> -}
> -#endif
> -
> -/*
> - * Returns true if this VM supports mmap() in guest_memfd.
> - *
> - * Arch code must define kvm_arch_supports_gmem_mmap if support for guest_memfd
> - * is enabled.
> - */
> -#if !defined(kvm_arch_supports_gmem_mmap)
> -static inline bool kvm_arch_supports_gmem_mmap(struct kvm *kvm)
> -{
> -       return false;
> -}
> +#ifdef CONFIG_KVM_GUEST_MEMFD
> +bool kvm_arch_supports_gmem_mmap(struct kvm *kvm);
>  #endif
>
>  #ifndef kvm_arch_has_readonly_mem
> @@ -2539,7 +2515,7 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
>
>  static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
>  {
> -       if (!IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP))
> +       if (!IS_ENABLED(CONFIG_KVM_GUEST_MEMFD))
>                 return false;
>
>         return slot->flags & KVM_MEMSLOT_GMEM_ONLY;
> @@ -2596,7 +2572,7 @@ static inline int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot,
>  int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
>  #endif
>
> -#ifdef CONFIG_KVM_GENERIC_PRIVATE_MEM
> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
>  /**
>   * kvm_gmem_populate() - Populate/prepare a GPA range with guest data
>   *
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 96cf4ab0d534..9d472f46ebf1 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -112,15 +112,10 @@ config KVM_GENERIC_MEMORY_ATTRIBUTES
>         depends on KVM_GENERIC_MMU_NOTIFIER
>         bool
>
> -config KVM_GMEM
> +config KVM_GUEST_MEMFD
>         select XARRAY_MULTI
>         bool
>
> -config KVM_GENERIC_PRIVATE_MEM
> -       select KVM_GENERIC_MEMORY_ATTRIBUTES
> -       select KVM_GMEM
> -       bool
> -
>  config HAVE_KVM_ARCH_GMEM_PREPARE
>         bool
>         depends on KVM_GMEM
> @@ -129,6 +124,6 @@ config HAVE_KVM_ARCH_GMEM_INVALIDATE
>         bool
>         depends on KVM_GMEM
>
> -config KVM_GMEM_SUPPORTS_MMAP
> -       select KVM_GMEM
> +config HAVE_KVM_ARCH_GMEM_POPULATE
>         bool
> +       depends on KVM_GMEM
> \ No newline at end of file
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index d01bd7a2c2bd..57db0041047a 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -316,9 +316,6 @@ static bool kvm_gmem_supports_mmap(struct inode *inode)
>  {
>         const u64 flags = (u64)inode->i_private;
>
> -       if (!IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP))
> -               return false;
> -
>         return flags & GUEST_MEMFD_FLAG_MMAP;
>  }
>
> @@ -527,6 +524,11 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>         return err;
>  }
>
> +bool __weak kvm_arch_supports_gmem_mmap(struct kvm *kvm)
> +{
> +       return true;
> +}
> +
>  int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>  {
>         loff_t size = args->size;
> @@ -730,7 +732,7 @@ int kvm_gmem_mapping_order(const struct kvm_memory_slot *slot, gfn_t gfn)
>  }
>  EXPORT_SYMBOL_GPL(kvm_gmem_mapping_order);
>
> -#ifdef CONFIG_KVM_GENERIC_GMEM_POPULATE
> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
>  long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
>                        kvm_gmem_populate_cb post_populate, void *opaque)
>  {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f1ac872e01e9..1b609e35303f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1588,7 +1588,7 @@ static int check_memory_region_flags(struct kvm *kvm,
>  {
>         u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
>
> -       if (kvm_arch_supports_gmem(kvm))
> +       if (IS_ENABLED(CONFIG_KVM_GUEST_MEMFD))
>                 valid_flags |= KVM_MEM_GUEST_MEMFD;
>
>         /* Dirty logging private memory is not currently supported. */
> @@ -4915,10 +4915,8 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  #endif
>  #ifdef CONFIG_KVM_GMEM
>         case KVM_CAP_GUEST_MEMFD:
> -               return !kvm || kvm_arch_supports_gmem(kvm);
> -#endif
> -#ifdef CONFIG_KVM_GMEM_SUPPORTS_MMAP
> -       case KVM_CAP_GMEM_MMAP:
> +               return 1;
> +       case KVM_CAP_GUEST_MEMFD_MMAP:
>                 return !kvm || kvm_arch_supports_gmem_mmap(kvm);
>  #endif
>         default:
>
> base-commit: 9eba3a9ac9cd5922da7f6e966c01190f909ed640
> --

