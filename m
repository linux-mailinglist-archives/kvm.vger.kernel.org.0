Return-Path: <kvm+bounces-46492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8888BAB6A04
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 13:31:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BFF41B62389
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 11:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B422B272E5D;
	Wed, 14 May 2025 11:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mEnQb2mF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC94A20102D
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 11:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747222287; cv=none; b=nXJwGkrLO9gOU+QGZdgyUU/tW64ioe3ckCW9eSKcvyoxvg28IFoSy9T4Wky4QvrV3+KHu/24H/LS28Wu1vOAKeLaNZ/mKyzoflK9pxbzWiBCH+vvaVEuGIjIESiHiBHBk7x3RTzYgjpz2aWl45iVVi+YeWdfyUmyReZIKC9SIc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747222287; c=relaxed/simple;
	bh=7SKAleR5kK+Fyu6mdHWXf0jBa2od39fIMX+E61JcTcU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M+JpLSQb6BYDtdAfxI/I0j/ONV+O6W+jIiPVOVD0Wg87Dgy62iIhxIXeDPebEAB+qSLvL6i/P33Zl017G92v/9+BHHVtZEHbwMQC3r8i9IS9+bhkL9tm+2zVsXmOdjMxz2vBFGHqZs4KjLo71xj/1r7xUyBtFqZlt8HIEVRcHoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mEnQb2mF; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-48b7747f881so244781cf.1
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 04:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747222284; x=1747827084; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fzbRmUOC8ih6fzt67RICwBbXDv0dt0XTfbOliydLBUI=;
        b=mEnQb2mFRPwEHYab0UjI+BV7/mtu2sUzf2Cxx3IBTVETA5YTJMsAw5w4381IxQS49B
         JQoaVU2H9IbShPtj4C2P7Zxx2xC0E1zjItWGYXxtdqmFG6BI8/SDvOp3yGlRBFvyJApQ
         mDAxbBivwZ+BkV4uHLHAUYKIAqevt5YpII/cmlRVzoirQ52PlicjdVeeFTbGOY4XRxn/
         AFAadZpdazbJ28dFqB5kZCGTmeAKHx+klmGHGV0nP6PA8CtQ4TvQYuFJjYi0YIombagp
         AKuDoiQHdPlH4LNsEZpBeNmruaFP6iVUb8oeOeh7Wn+/Pek5e7UlhA75CVFemABA8evH
         oVFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747222284; x=1747827084;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fzbRmUOC8ih6fzt67RICwBbXDv0dt0XTfbOliydLBUI=;
        b=ldhybN9p/X1Uvz9fNqaYnBdLXngx1J1aJVT2bumTVgi+fSP/gO8JuPkIEiVRW5dvu/
         /6jSz/jmhBMyqD4rqdfaaH/OzYQOLd7aqmDnRZhWbSCg/dZch7m2LF3NvcUU2jo5jWze
         xQR4Y6JTotO7ytrC8CSBO8kOu6PYDp6xi5hT2Gf8UMfY0Vces1x19WaTb+wTO4cEAW6I
         567sIj1YFKu6unM8q4W1+wvEY/drBxqctAjryMPtyKtgdB0wDz5CrF9+a9MtdXReCeSj
         VTKVwFMCsUIXHxSYH455BCxp0MnEUQGUeGJqenSCc0KLYnJuBhqXuCg4dPTfqAT5/TkC
         weVw==
X-Forwarded-Encrypted: i=1; AJvYcCVnr2rFDGVuKMQLZqQ4NoLhUlQ0AJFB42/sWX0GBvx+RAIKrbLZn2L/MFxerIlf0ebnaWs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyehmyrCP8JnqJ51EPLfD0MVjgZ/N46Ow01sgt9s+KkyPqc7rcU
	RQxICqZ8wQ05Cn9Z8bmABAb98VxPSSpfmB9nRJZBnTHM0P3HHdpCCT9RUz7N21kEjWuM6iDFDZK
	RPgz0xrV3dWIeEs39sUFOLZdtYCPHWvNhXddfhOwd
X-Gm-Gg: ASbGncsSSYXXWruP6bqVi0xIX4N8rKHbmvMgwKfHb+PSZl6LF45agSwGeqQDw7/rxwB
	FmHTGBTJkgkYZqYk/RoeDwNNAL+j/3x5Xc4xOEjVAUQR8VNA736cloiDvenFDoSUUKrNuCb4qr7
	L8dj08IWnr6KmTsS8TK5Pn3LgcupwDrBoytA==
X-Google-Smtp-Source: AGHT+IHgGMrxKe+8f4ldm2sEcuMXD0OaFpCmvdvmLS2UUv2zI6SPX0N053OInUzyGM05Tewp75qyfVmEX240o0OveMI=
X-Received: by 2002:a05:622a:103:b0:471:eab0:ef21 with SMTP id
 d75a77b69052e-49496d491b2mr2857851cf.13.1747222284066; Wed, 14 May 2025
 04:31:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250513163438.3942405-8-tabba@google.com> <20250514100733.4079-1-roypat@amazon.co.uk>
In-Reply-To: <20250514100733.4079-1-roypat@amazon.co.uk>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 14 May 2025 12:30:20 +0100
X-Gm-Features: AX0GCFudl35qoFdeYv31Tchf1U4v66DqL82wE2IKqy4K6nZ-04hlTThZs-DR5lE
Message-ID: <CA+EHjTy611=7g7D93P2X491p9=BEcPmmif5gUN25BaFXnTvk7A@mail.gmail.com>
Subject: Re: [PATCH v9 07/17] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "ackerleytng@google.com" <ackerleytng@google.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "amoorthy@google.com" <amoorthy@google.com>, 
	"anup@brainfault.org" <anup@brainfault.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, 
	"brauner@kernel.org" <brauner@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, 
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, 
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "david@redhat.com" <david@redhat.com>, 
	"dmatlack@google.com" <dmatlack@google.com>, "fvdl@google.com" <fvdl@google.com>, 
	"hch@infradead.org" <hch@infradead.org>, "hughd@google.com" <hughd@google.com>, 
	"ira.weiny@intel.com" <ira.weiny@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"isaku.yamahata@intel.com" <isaku.yamahata@intel.com>, "james.morse@arm.com" <james.morse@arm.com>, 
	"jarkko@kernel.org" <jarkko@kernel.org>, "jgg@nvidia.com" <jgg@nvidia.com>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "jthoughton@google.com" <jthoughton@google.com>, 
	"keirf@google.com" <keirf@google.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "liam.merwick@oracle.com" <liam.merwick@oracle.com>, 
	"linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"mail@maciej.szmigiero.name" <mail@maciej.szmigiero.name>, "maz@kernel.org" <maz@kernel.org>, 
	"mic@digikod.net" <mic@digikod.net>, "michael.roth@amd.com" <michael.roth@amd.com>, 
	"mpe@ellerman.id.au" <mpe@ellerman.id.au>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>, 
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, 
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"peterx@redhat.com" <peterx@redhat.com>, "qperret@google.com" <qperret@google.com>, 
	"quic_cvanscha@quicinc.com" <quic_cvanscha@quicinc.com>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, 
	"quic_mnalajal@quicinc.com" <quic_mnalajal@quicinc.com>, 
	"quic_pderrin@quicinc.com" <quic_pderrin@quicinc.com>, 
	"quic_pheragu@quicinc.com" <quic_pheragu@quicinc.com>, 
	"quic_svaddagi@quicinc.com" <quic_svaddagi@quicinc.com>, 
	"quic_tsoni@quicinc.com" <quic_tsoni@quicinc.com>, "rientjes@google.com" <rientjes@google.com>, 
	"seanjc@google.com" <seanjc@google.com>, "shuah@kernel.org" <shuah@kernel.org>, 
	"steven.price@arm.com" <steven.price@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, 
	"vannapurve@google.com" <vannapurve@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "wei.w.wang@intel.com" <wei.w.wang@intel.com>, 
	"will@kernel.org" <will@kernel.org>, "willy@infradead.org" <willy@infradead.org>, 
	"xiaoyao.li@intel.com" <xiaoyao.li@intel.com>, "yilun.xu@intel.com" <yilun.xu@intel.com>, 
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Patrick,

On Wed, 14 May 2025 at 11:07, Roy, Patrick <roypat@amazon.co.uk> wrote:
>
> On Tue, 2025-05-13 at 17:34 +0100, Fuad Tabba wrote:
> > This patch enables support for shared memory in guest_memfd, including
> > mapping that memory at the host userspace. This support is gated by the
> > configuration option KVM_GMEM_SHARED_MEM, and toggled by the guest_memfd
> > flag GUEST_MEMFD_FLAG_SUPPORT_SHARED, which can be set when creating a
> > guest_memfd instance.
> >
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 10 ++++
> >  include/linux/kvm_host.h        | 13 +++++
> >  include/uapi/linux/kvm.h        |  1 +
> >  virt/kvm/Kconfig                |  5 ++
> >  virt/kvm/guest_memfd.c          | 88 +++++++++++++++++++++++++++++++++
> >  5 files changed, 117 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 709cc2a7ba66..f72722949cae 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -2255,8 +2255,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> >
> >  #ifdef CONFIG_KVM_GMEM
> >  #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
> > +
> > +/*
> > + * CoCo VMs with hardware support that use guest_memfd only for backing private
> > + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
> > + */
> > +#define kvm_arch_vm_supports_gmem_shared_mem(kvm)                      \
> > +       (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&                      \
> > +        ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||             \
> > +         (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
>
> I forgot what we ended up deciding wrt "allow guest_memfd usage for default VMs
> on x86" in the call two weeks ago, but if we want to do that as part of this
> series, then this also needs

Yes we did. I missed it in this patch. I'll fix it.

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 12433b1e755b..904b15c678d6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12716,7 +12716,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>                 return -EINVAL;
>
>         kvm->arch.vm_type = type;
> -       kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
> +       kvm->arch.supports_gmem = type == KVM_X86_SW_PROTECTED_VM || type == KVM_X86_DEFAULT_VM;
>         /* Decided by the vendor code for other VM types.  */
>         kvm->arch.pre_fault_allowed =
>                 type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
>
> and with that I was able to run my firecracker tests on top of this patch
> series with X86_DEFAULT_VM. But I did wonder about this define in
> x86/include/asm/kvm_host.h:
>
> /* SMM is currently unsupported for guests with guest_memfd (esp private) memory. */
> # define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_supports_gmem(kvm) ? 1 : 2)
>
> which I'm not really sure what to make of, but which I think means enabling
> guest_memfd for X86_DEFAULT_VM isn't as straight-forward as the above diff :/

Not quite, but I'll sort it out.

Thanks,
/fuad

> Best,
> Patrick
>
> >  #else
> >  #define kvm_arch_supports_gmem(kvm) false
> > +#define kvm_arch_vm_supports_gmem_shared_mem(kvm) false
> >  #endif
> >
> >  #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index ae70e4e19700..2ec89c214978 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -729,6 +729,19 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
> >  }
> >  #endif
> >
> > +/*
> > + * Returns true if this VM supports shared mem in guest_memfd.
> > + *
> > + * Arch code must define kvm_arch_vm_supports_gmem_shared_mem if support for
> > + * guest_memfd is enabled.
> > + */
> > +#if !defined(kvm_arch_vm_supports_gmem_shared_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
> > +static inline bool kvm_arch_vm_supports_gmem_shared_mem(struct kvm *kvm)
> > +{
> > +       return false;
> > +}
> > +#endif
> > +
> >  #ifndef kvm_arch_has_readonly_mem
> >  static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
> >  {
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index b6ae8ad8934b..9857022a0f0c 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1566,6 +1566,7 @@ struct kvm_memory_attributes {
> >  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
> >
> >  #define KVM_CREATE_GUEST_MEMFD _IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> > +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED        (1UL << 0)
> >
> >  struct kvm_create_guest_memfd {
> >         __u64 size;
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > index 559c93ad90be..f4e469a62a60 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -128,3 +128,8 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
> >  config HAVE_KVM_ARCH_GMEM_INVALIDATE
> >         bool
> >         depends on KVM_GMEM
> > +
> > +config KVM_GMEM_SHARED_MEM
> > +       select KVM_GMEM
> > +       bool
> > +       prompt "Enables in-place shared memory for guest_memfd"
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 6db515833f61..8e6d1866b55e 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -312,7 +312,88 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
> >         return gfn - slot->base_gfn + slot->gmem.pgoff;
> >  }
> >
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +
> > +static bool kvm_gmem_supports_shared(struct inode *inode)
> > +{
> > +       uint64_t flags = (uint64_t)inode->i_private;
> > +
> > +       return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> > +}
> > +
> > +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> > +{
> > +       struct inode *inode = file_inode(vmf->vma->vm_file);
> > +       struct folio *folio;
> > +       vm_fault_t ret = VM_FAULT_LOCKED;
> > +
> > +       filemap_invalidate_lock_shared(inode->i_mapping);
> > +
> > +       folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> > +       if (IS_ERR(folio)) {
> > +               int err = PTR_ERR(folio);
> > +
> > +               if (err == -EAGAIN)
> > +                       ret = VM_FAULT_RETRY;
> > +               else
> > +                       ret = vmf_error(err);
> > +
> > +               goto out_filemap;
> > +       }
> > +
> > +       if (folio_test_hwpoison(folio)) {
> > +               ret = VM_FAULT_HWPOISON;
> > +               goto out_folio;
> > +       }
> > +
> > +       if (WARN_ON_ONCE(folio_test_large(folio))) {
> > +               ret = VM_FAULT_SIGBUS;
> > +               goto out_folio;
> > +       }
> > +
> > +       if (!folio_test_uptodate(folio)) {
> > +               clear_highpage(folio_page(folio, 0));
> > +               kvm_gmem_mark_prepared(folio);
> > +       }
> > +
> > +       vmf->page = folio_file_page(folio, vmf->pgoff);
> > +
> > +out_folio:
> > +       if (ret != VM_FAULT_LOCKED) {
> > +               folio_unlock(folio);
> > +               folio_put(folio);
> > +       }
> > +
> > +out_filemap:
> > +       filemap_invalidate_unlock_shared(inode->i_mapping);
> > +
> > +       return ret;
> > +}
> > +
> > +static const struct vm_operations_struct kvm_gmem_vm_ops = {
> > +       .fault = kvm_gmem_fault_shared,
> > +};
> > +
> > +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> > +{
> > +       if (!kvm_gmem_supports_shared(file_inode(file)))
> > +               return -ENODEV;
> > +
> > +       if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> > +           (VM_SHARED | VM_MAYSHARE)) {
> > +               return -EINVAL;
> > +       }
> > +
> > +       vma->vm_ops = &kvm_gmem_vm_ops;
> > +
> > +       return 0;
> > +}
> > +#else
> > +#define kvm_gmem_mmap NULL
> > +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
> > +
> >  static struct file_operations kvm_gmem_fops = {
> > +       .mmap           = kvm_gmem_mmap,
> >         .open           = generic_file_open,
> >         .release        = kvm_gmem_release,
> >         .fallocate      = kvm_gmem_fallocate,
> > @@ -463,6 +544,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
> >         u64 flags = args->flags;
> >         u64 valid_flags = 0;
> >
> > +       if (kvm_arch_vm_supports_gmem_shared_mem(kvm))
> > +               valid_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> > +
> >         if (flags & ~valid_flags)
> >                 return -EINVAL;
> >
> > @@ -501,6 +585,10 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
> >             offset + size > i_size_read(inode))
> >                 goto err;
> >
> > +       if (kvm_gmem_supports_shared(inode) &&
> > +           !kvm_arch_vm_supports_gmem_shared_mem(kvm))
> > +               goto err;
> > +
> >         filemap_invalidate_lock(inode->i_mapping);
> >
> >         start = offset >> PAGE_SHIFT;
> > --
> > 2.49.0.1045.g170613ef41-goog
> >
>

