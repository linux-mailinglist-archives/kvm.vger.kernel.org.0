Return-Path: <kvm+bounces-48378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11F38ACD9F9
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 10:38:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A672F3A390E
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 08:37:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09F6F28935F;
	Wed,  4 Jun 2025 08:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IiL5nweP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D6E284B38
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 08:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749026283; cv=none; b=NprCBPiuEVh4etZUVc721wSDtl6niXP9agMfqZeStZL1hK08o7YQscAypiXdyPbwhf8SwxtfnOpmHyt0yBXkULdaZs3Y+s9sIMYoCVCC7/W3Y9Zxf/+6kLtWTDSklzS/8ah5P+EVDU1+3z2yf1Aphmrth39cDTGKnokiS+Ca7rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749026283; c=relaxed/simple;
	bh=pPH8pgHv/C/kF876Yw5nNH2TdMKPay5vY33JcD4Pt10=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tiIvVygcfPBMYHoIx31ZYpMVBLCySlQ7ktCcpmKxvmpMBtIEJPxo+4IKDeOEfvcEODp4yyj6bDngJcWTrZKiUxQddBDxTsYXNULiuBhDU+WqCjNmATC9PMwd4WJVZdwdu/8EApw0WwVp112VOM7Yg92M3HYGX59XkLZ+Wo1BUhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IiL5nweP; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4a433f52485so346831cf.0
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 01:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749026280; x=1749631080; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=a2nRJ1Q/J0IOV9UAbVb9ieUJGGlK4N6jfQ5hZo/FrXs=;
        b=IiL5nwePkiIXEkydBfGR8YBVDczqPAUV0GWtFhDmN2CRrWo2BjVEDEMryLrkHgTLHH
         LG8p9z4CGGSiu9EIDcTOzxbx2tmJKON2sj5+v96hxNcGY6m8JmHL2jbIvQerc3aAcuqA
         xzybpYxrqL8fZrpcypLcdlEfvNZcR8AEyDajC98Ra+1rFPtKG76rvNVgogboMrBJnGAD
         jZj3Ag1ad8P5vkIKhqUDcjTHJYU43WmRLy5OfThWp8a/RgvU9+IRARTzs8L5N4X4at3q
         8KPyc8XeL9pekdBTS90gOfhxE9MHkRBXJ6w8rQ389v5W/GDkIs0CgVL3pQ5PW7u80Ivw
         NbDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749026280; x=1749631080;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a2nRJ1Q/J0IOV9UAbVb9ieUJGGlK4N6jfQ5hZo/FrXs=;
        b=JO/SGGcFL8MZ8BXmOjKOZZ8LIAbxa4jK8EGPBC806ZycF1o0dpJvL1AcGSsYzPff1K
         VfzC2zAiSzLcncdIR3ylkwCQWJD6OkpfZja8QPVDQIBmdSYXitkm3k6KnOSv3H498GpJ
         AzoJ4hgKpv0CV3bni4BNaJsgMWx/K7ZpouizOu7borW04+PM+GeIlc4ilv633Cjf0XVt
         Quqirc16komoMFAY5FWN7TBQ8oApCM/9Usf1SBt+azep16T+20TP4BqYbfsYe0syZWgX
         9GpuQm1Qs8PK1wgy2duioXiJ8GkGzqu9Mvg3cWJEUgcnGedeBwSVdaae/BFRwrUOL5Cx
         eIUA==
X-Gm-Message-State: AOJu0YxvbJKUdbSI6RYfriFIJPXmdvtsVdFZ7li1OMR6Btn9yM/NUYzs
	3StrN0QrjgqR95CxWmF0tiZ7BDoxbeJtkAySVS1Wr2WUfnuB9P1KRqKLk4bbyEhRxQl2JMlEMJc
	kwUurgUe1MbODMB/CKLnZb2xyt2vJFGxCIH7c0v2w
X-Gm-Gg: ASbGncuVA7ZS1B2sMksBXkh++6MEQGT6g92GSMOGbjPUFPnPjmHJxusG8WaQy9Rg4Ik
	AbxTThUQpBr0hw5uRLGK2SK5yeq8gEAqemEWruEoinahNZnjhIdrdSh22fzgUUj9ycRydeqgW3l
	AVtVaXEX7YAo2fqwyRRjnO4vzEV7qQF6w23zNUiKmd2bdF7rgeMKilZrDoo6Sq6osdpxki5ZPyS
	uqpEpL9JQ==
X-Google-Smtp-Source: AGHT+IHe+8rltjxQpERvGlnh1BE+Qb+AyjiyXr0NHbslF7o6q6+hHqMnR/sx/OcJ6plG1reS8jBIkRgriDdO9djZwwM=
X-Received: by 2002:a05:622a:2284:b0:49d:9782:5c53 with SMTP id
 d75a77b69052e-4a5a52d36d4mr3127361cf.22.1749026279368; Wed, 04 Jun 2025
 01:37:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250527180245.1413463-1-tabba@google.com> <20250527180245.1413463-9-tabba@google.com>
 <e1ce3a20-4edb-475e-8401-d3af1b8967b8@redhat.com>
In-Reply-To: <e1ce3a20-4edb-475e-8401-d3af1b8967b8@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 4 Jun 2025 09:37:22 +0100
X-Gm-Features: AX0GCFvfuFQgjgGz6fhOBu2X3BjrPjlVCK3TUMn9rtOaIi991YFOepXnJmCsqZk
Message-ID: <CA+EHjTxovnrGM0vZaJRs0vY-RLo9tQ+eCu6SKRzYa4wirs0V4g@mail.gmail.com>
Subject: Re: [PATCH v10 08/16] KVM: guest_memfd: Allow host to map guest_memfd pages
To: Gavin Shan <gshan@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
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

Hi Gavin,

On Wed, 4 Jun 2025 at 07:02, Gavin Shan <gshan@redhat.com> wrote:
>
> Hi Fuad,
>
> On 5/28/25 4:02 AM, Fuad Tabba wrote:
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
> >   arch/x86/include/asm/kvm_host.h | 10 ++++
> >   arch/x86/kvm/x86.c              |  3 +-
> >   include/linux/kvm_host.h        | 13 ++++++
> >   include/uapi/linux/kvm.h        |  1 +
> >   virt/kvm/Kconfig                |  5 ++
> >   virt/kvm/guest_memfd.c          | 81 +++++++++++++++++++++++++++++++++
> >   6 files changed, 112 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 709cc2a7ba66..ce9ad4cd93c5 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -2255,8 +2255,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> >
> >   #ifdef CONFIG_KVM_GMEM
> >   #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
> > +
> > +/*
> > + * CoCo VMs with hardware support that use guest_memfd only for backing private
> > + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
> > + */
> > +#define kvm_arch_supports_gmem_shared_mem(kvm)                       \
> > +     (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&                      \
> > +      ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||             \
> > +       (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
> >   #else
> >   #define kvm_arch_supports_gmem(kvm) false
> > +#define kvm_arch_supports_gmem_shared_mem(kvm) false
> >   #endif
> >
> >   #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 035ced06b2dd..2a02f2457c42 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12718,7 +12718,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >               return -EINVAL;
> >
> >       kvm->arch.vm_type = type;
> > -     kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
> > +     kvm->arch.supports_gmem =
> > +             type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
> >       /* Decided by the vendor code for other VM types.  */
> >       kvm->arch.pre_fault_allowed =
> >               type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 80371475818f..ba83547e62b0 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -729,6 +729,19 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
> >   }
> >   #endif
> >
> > +/*
> > + * Returns true if this VM supports shared mem in guest_memfd.
> > + *
> > + * Arch code must define kvm_arch_supports_gmem_shared_mem if support for
> > + * guest_memfd is enabled.
> > + */
> > +#if !defined(kvm_arch_supports_gmem_shared_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
> > +static inline bool kvm_arch_supports_gmem_shared_mem(struct kvm *kvm)
> > +{
> > +     return false;
> > +}
> > +#endif
> > +
> >   #ifndef kvm_arch_has_readonly_mem
> >   static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
> >   {
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index b6ae8ad8934b..c2714c9d1a0e 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1566,6 +1566,7 @@ struct kvm_memory_attributes {
> >   #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
> >
> >   #define KVM_CREATE_GUEST_MEMFD      _IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> > +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED      (1ULL << 0)
> >
> >   struct kvm_create_guest_memfd {
> >       __u64 size;
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > index 559c93ad90be..df225298ab10 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -128,3 +128,8 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
> >   config HAVE_KVM_ARCH_GMEM_INVALIDATE
> >          bool
> >          depends on KVM_GMEM
> > +
> > +config KVM_GMEM_SHARED_MEM
> > +       select KVM_GMEM
> > +       bool
> > +       prompt "Enable support for non-private (shared) memory in guest_memfd"
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 6db515833f61..5d34712f64fc 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -312,7 +312,81 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
> >       return gfn - slot->base_gfn + slot->gmem.pgoff;
> >   }
> >
> > +static bool kvm_gmem_supports_shared(struct inode *inode)
> > +{
> > +     u64 flags;
> > +
> > +     if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
> > +             return false;
> > +
> > +     flags = (u64)inode->i_private;
> > +
> > +     return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> > +}
> > +
> > +
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> > +{
> > +     struct inode *inode = file_inode(vmf->vma->vm_file);
> > +     struct folio *folio;
> > +     vm_fault_t ret = VM_FAULT_LOCKED;
> > +
> > +     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> > +     if (IS_ERR(folio)) {
> > +             int err = PTR_ERR(folio);
> > +
> > +             if (err == -EAGAIN)
> > +                     return VM_FAULT_RETRY;
> > +
> > +             return vmf_error(err);
> > +     }
> > +
> > +     if (WARN_ON_ONCE(folio_test_large(folio))) {
> > +             ret = VM_FAULT_SIGBUS;
> > +             goto out_folio;
> > +     }
> > +
> > +     if (!folio_test_uptodate(folio)) {
> > +             clear_highpage(folio_page(folio, 0));
> > +             kvm_gmem_mark_prepared(folio);
> > +     }
> > +
> > +     vmf->page = folio_file_page(folio, vmf->pgoff);
> > +
> > +out_folio:
> > +     if (ret != VM_FAULT_LOCKED) {
> > +             folio_unlock(folio);
> > +             folio_put(folio);
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +static const struct vm_operations_struct kvm_gmem_vm_ops = {
> > +     .fault = kvm_gmem_fault_shared,
> > +};
> > +
> > +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> > +{
> > +     if (!kvm_gmem_supports_shared(file_inode(file)))
> > +             return -ENODEV;
> > +
> > +     if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> > +         (VM_SHARED | VM_MAYSHARE)) {
> > +             return -EINVAL;
> > +     }
> > +
> > +     vma->vm_ops = &kvm_gmem_vm_ops;
> > +
> > +     return 0;
> > +}
> > +#else
> > +#define kvm_gmem_mmap NULL
> > +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
> > +
>
> nit: The hunk of code doesn't have to be guarded by CONFIG_KVM_GMEM_SHARED_MEM.
> With the guard removed, we run into error (-ENODEV) returned by kvm_gmem_mmap()
> for non-sharable (or non-mapped) file, same effect as to "kvm_gmem_fops.mmap = NULL".
>
> I may have missed other intentions to have this guard here.

You're right. This guard is here because it was needed before, but not
anymore. I'll remove it.

> >   static struct file_operations kvm_gmem_fops = {
> > +     .mmap           = kvm_gmem_mmap,
> >       .open           = generic_file_open,
> >       .release        = kvm_gmem_release,
> >       .fallocate      = kvm_gmem_fallocate,
> > @@ -463,6 +537,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
> >       u64 flags = args->flags;
> >       u64 valid_flags = 0;
> >
> > +     if (kvm_arch_supports_gmem_shared_mem(kvm))
> > +             valid_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> > +
> >       if (flags & ~valid_flags)
> >               return -EINVAL;
> >
> > @@ -501,6 +578,10 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
> >           offset + size > i_size_read(inode))
> >               goto err;
> >
> > +     if (kvm_gmem_supports_shared(inode) &&
> > +         !kvm_arch_supports_gmem_shared_mem(kvm))
> > +             goto err;
> > +
>
> This check looks unnecessary if I'm not missing anything. The file (inode) can't be created
> by kvm_gmem_create(GUEST_MEMFD_FLAG_SUPPORT_SHARED) on !kvm_arch_supports_gmem_shared_mem().
> It means "kvm_gmem_supports_shared(inode) == true" is indicating "kvm_arch_supports_gmem_shared_mem(kvm) == true".
> In this case, we won't never break the check? :-)

You're right here as well. This check was there before that flag was
added, and I should have removed it after having added that. Consider
it gone!

Thanks!

/fuad

> >       filemap_invalidate_lock(inode->i_mapping);
> >
> >       start = offset >> PAGE_SHIFT;
>
> Thanks,
> Gavin
>

