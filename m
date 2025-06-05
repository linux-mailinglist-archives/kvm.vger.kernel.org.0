Return-Path: <kvm+bounces-48503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 335B5ACEBCA
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 10:26:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E38D816AE6E
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:26:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C5E2063F0;
	Thu,  5 Jun 2025 08:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IHmzfp0w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D80205ACF
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 08:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749111968; cv=none; b=Gwhn3ig8chXP8x7Z7rnthIE2GlUGgr6uHp8l/WOi6egqDg+FlkNfh9V4wAZEwNDBhH66TZYOYFKQktKKW397tKg9YhOs3h+yQiuDKRQ7QGZmqJBTU0B4rIz6rSwkzUi8wPHtMpKhD3SGGfDdurJzDtD6GddKjY+LSxncOCcd6dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749111968; c=relaxed/simple;
	bh=addpY3NRN5A2qJZ3Gohb63rN65zloo1rLUynaGXufQ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QmemkuXig50RpOQIi9ibTEDrOJwqcOjTFlPKGTaYyiaufL7j2oP0If3yPNMxHW2q4hAgWJCvUVGR0R0hTtDGGHu7zKG5+aUKMALy2JRdi9H2i8tws69p4ywFOd9pR7AOnFRb3dIB2P9cvZosnEwwCHeW2bXSkf66beINurF82Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IHmzfp0w; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-47e9fea29easo925691cf.1
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 01:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749111965; x=1749716765; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=z7oK883NyicLlnYnS2RhH8YbYFe6iN8Md3yC/ZesZyQ=;
        b=IHmzfp0wYrMVmJYzmWwyYfpKIYVQztYU0gxxypNAVbB562IpVzgsHlLXZXdTxCgZkf
         BmSOBJZ9ufvV2MamgCikdTvcvZ86nYVTbGD0IA/Z8my6ta7N0TwzDH8/3p8AbbjJysC4
         OJc/2ArLDpUMeskozPlAPDdbHtaULevjl1hih32CRUFolNXb1MJ5deOSKCkD4MC5lrLz
         EJKZwwfB5u1aYlFTv8ycddtyMruwrDw2h+/59ajM+nrJodXM5lWZ87HvkOPkwt2p7LsQ
         RnAO5q0kjhQ1BfwK72dsPDHjrtlIIa7NsuAC5BfQDzGsXLXLuR2clhohFAkfhRePMzl4
         w7qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749111965; x=1749716765;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z7oK883NyicLlnYnS2RhH8YbYFe6iN8Md3yC/ZesZyQ=;
        b=pKmX1/GJs19cIaZ+0+8CyIKjvK94yL+tGJegQf1qb/rWCgSmuM6YFjyBTgek8Tra4I
         pKDJVCrIvN6zVFkAadlNmM3WSLZ9D7nyzzpfb5N+D8+Cyby8eFViz0sp2AzPzlu88VXG
         QRly1ZusGVQA170vnCsBQLZ5bEKsf1XiQY7QjDQDmRQRFsM6q5rAGAzK1qOoAqxZeZ+N
         UT00UcOz4hPh6dVGb8xBbRiQ5MhT/JRkYXcJ7v0BK+50vjTw9mCtUst2WZfVPEKwm0kt
         vaiE+Bt4xNZcJaw7gwiI5WZkUBhQUkCB0hyaWtnFTWSygkD2s9+tfyeSihYqpH52Yh1N
         Ih8Q==
X-Gm-Message-State: AOJu0YxkWyTfkFS0/89cTsZJ5GgJnTqkhyhWLV1d8twQPWOJj2UdOuX6
	X/9Jd0JttTIdj6SiJBlZnwNUSnSxfzedrq+FiBat5py/Dw+cjGJ+T4rriaM2HOkEQVILwXMgtha
	Qsn5NqV+EgDyo+OierKS1WTNJflKEVXYMjPk2PIRx
X-Gm-Gg: ASbGncsKBQ+1K/QUE2TcdFLLH3bfy4ouXyrNsEM0QB9++IwN//ZDEfEsG9dxQv9T7w4
	mRbDy6f5itKzYlbdrQQbRnX1yCb4anSj11dK3JTrbRAjV9ygwdBxIsbIwJJQt2nNJlsTfWCSo4r
	M5xCVxXFA/PBXFU+6UIJ22Q38h664ORk1HxZlUxL6xrE4=
X-Google-Smtp-Source: AGHT+IGjtDvWKPjsQwttjetZqd6yOwD85TsjgbQbjKh5u7fOObhMkVIXbKMs9yfE60wIO2iTa8nnat+Nix0m78ewaJU=
X-Received: by 2002:a05:622a:5449:b0:4a5:ae61:9457 with SMTP id
 d75a77b69052e-4a5b0d5dd16mr2461801cf.1.1749111964701; Thu, 05 Jun 2025
 01:26:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250527180245.1413463-1-tabba@google.com> <20250527180245.1413463-9-tabba@google.com>
 <a3d6ff25-236b-4dfd-8a04-6df437ecb4bb@redhat.com>
In-Reply-To: <a3d6ff25-236b-4dfd-8a04-6df437ecb4bb@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 5 Jun 2025 09:25:28 +0100
X-Gm-Features: AX0GCFs9T7yVKRzbqvNzb0JgLynaAb3KtZWYi-fjaVFBuUJrPmfOOFqECR0Tt2E
Message-ID: <CA+EHjTzFkTJr+gD7ZEbRMXhg9KwQDNjqy0Smss37+13Dz-bnnQ@mail.gmail.com>
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

On Thu, 5 Jun 2025 at 07:41, Gavin Shan <gshan@redhat.com> wrote:
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
> >   static struct file_operations kvm_gmem_fops = {
> > +     .mmap           = kvm_gmem_mmap,
> >       .open           = generic_file_open,
> >       .release        = kvm_gmem_release,
> >       .fallocate      = kvm_gmem_fallocate,
> > @@ -463,6 +537,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
> >       u64 flags = args->flags;
> >       u64 valid_flags = 0;
> >
>
> It seems there is an uncovered corner case, which exists in current code (not directly
> caused by this patch): After .mmap is hooked, the address space (inode->i_mapping) is
> exposed to user space for futher requests like madvise().madvise(MADV_COLLAPSE) can
> potentially collapse the pages to a huge page (folio) with the following assumptions.
> It's not the expected behavior since huge page isn't supported yet.
>
> - CONFIG_READ_ONLY_THP_FOR_FS = y
> - the folios in the pagecache have been fully populated, it can be done by kvm_gmem_fallocate()
>    or kvm_gmem_get_pfn().
> - mmap(0x00000f0100000000, ..., MAP_FIXED_NOREPLACE) on the guest-memfd, and then do
>    madvise(buf, size, MADV_COLLAPSE).
>
> sys_madvise
>    do_madvise
>      madvise_do_behavior
>        madvise_vma_behavior
>          madvise_collapse
>            thp_vma_allowable_order
>              file_thp_enabled             // need to return false to bail from the path earlier at least
>            hpage_collapse_scan_file
>            collapse_pte_mapped_thp
>
> The fix would be to increase inode->i_writecount using allow_write_access() in
> __kvm_gmem_create() to break the check done by file_thp_enabled().

Thanks for catching this. Even though it's not an issue until huge
page support is added, we might as well handle it now.

Out of curiosity, how did you spot this?

Cheers,
/fuad



> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 0cd12f94958b..fe706c9f21cf 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -502,6 +502,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>          }
>
>          file->f_flags |= O_LARGEFILE;
> +       allow_write_access(file);
>
>
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
> >       filemap_invalidate_lock(inode->i_mapping);
> >
> >       start = offset >> PAGE_SHIFT;
>
> Thanks,
> Gavin
>

