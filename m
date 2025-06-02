Return-Path: <kvm+bounces-48160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF820ACAC3D
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 12:06:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B816C189D9FD
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 10:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E56E1F55F8;
	Mon,  2 Jun 2025 10:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c6NrA3b7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DA77E0FF
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 10:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748858765; cv=none; b=CBdrk29OnkKhEJVztTQqECReYSeO/T+Vs8LN968aASTfQORu/G9MkyQYIwF0JnaJUvXiTUaUPuNtK/ClCC0SR0wdvAQHLxy06/w/wLSlUaLvPD1b22tJL3m8U28TzMN1OkmEKihpty4N3wEZDLLybZb2TPjTe2XpV9w8Mnl8UXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748858765; c=relaxed/simple;
	bh=wOoCaR/vKf4ws17GET7rgLq9+1+WKelHGDcczylC/OM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PmdYeQziByIvZf4MGPX88vIJhETvJXQB7Vx6zUKHVO79ZSI3HDAlNLDVKH4kUwBtTwaVRnbHScG5I6P6DpJAg9QbDqhToaFDGhHpZvDsVIRbvoP+yv/uZEcQY9FQKtFuwlTzCRY83GD4rIMxoDdBi9hLvyAAMg8fbWwc2ctz//4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c6NrA3b7; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4a58ef58a38so136961cf.0
        for <kvm@vger.kernel.org>; Mon, 02 Jun 2025 03:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748858762; x=1749463562; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oDnupqKBJ89TBuL3pS2miqNuWw2n9YI4lkYLTdJhC1Q=;
        b=c6NrA3b75h2QF+X+a5VgbsIhaFyWyaZOntQtbIGfNaofUTAthQJLpTnx/iJaW9zCDz
         sSOq+9PMWXx8sJ+J5lqTOfWJ3UpriylG2LVk6E0TR3S3ZxsrqRTHvFayrz+SoEDR8AEY
         1OXm/XfEMA2isSDx2WkdMk4ZZOprrudSY2hI0QOnNT+XP4N+eqd7XNsN1Lc6E5VXG3Ne
         /utzmQCYSXOjQMpFxL4/LAYHQpm5/SoKupnfxADYlEpzYn3Zs46qZe6lEYOK1PjxcNRq
         XipVLZIYrZjL5KLTNZwgEsxP87JGEzastaOt1r/jLaN9s2eSn1EmIE77JosDsWkvTJlE
         dMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748858762; x=1749463562;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oDnupqKBJ89TBuL3pS2miqNuWw2n9YI4lkYLTdJhC1Q=;
        b=fEyVktWHiKsnSqozF032Wwct9Fk0NCiWARJFEOVig8f4dkA/MlmKcDlnpe3PCyrEjq
         VBo2AMTkPDp0nM/Xis8Ime4mPjxz61HTuu4rbLj5tXrKQgYRUG9yoZWIAd/biZHScN+0
         Xe8CiPNZJCq9oWu0nDHW4L1YZAKKNHbZZznd/ealw4Eo0Ieg0D1ssOfxBHCTCYC9BXOe
         MrmKpOQYfSNcbg9h33WUrD5LMn23sNzkfHMBJPWShRn1Dl7uiwShIPN5G3E8H9+vCaed
         XGtya2pBNFroLrllj8bbjziI3PAs4Vvxv/1uDs6p4xEP8dP712K4gk+nUHuwvRgYzUW0
         ZaGQ==
X-Gm-Message-State: AOJu0YwWoLrMY6o6oK/P6IASDja8VXTgg3ON9lr0YLHYkqYhYZ1HYOYn
	8tYs9mt/79HrFyL+PWXyCKtW5C/wEMAOj20heIVhtlgoTaRdH7ANnS2xp/ALPaaEc4OEgR2f3+S
	bAj14TFPALz0qw+u6hpU4Y8MQeFm4xRb9DLs3HwaxQKhdgSVdnrgcCkr/ZCrWQQ==
X-Gm-Gg: ASbGncsyARoxzjrG6SjIIhZJIZFL3xZk7IPx6hDOCNPaz1g9KjA7dr4QszJz3wryx+V
	VkcsFskZv07BtahrUYW0BCl8aYFfEmeJnDFTo3pHGwStNuGn1uNaK4OD/9LTHGzvX2fWw0RO6U+
	3eJpLfjfdj4qQcgBf3xKBdLZPsnp5OelMuGBS7P1PM56E=
X-Google-Smtp-Source: AGHT+IHseQwlGftOnTSXZN097ipT59f3MdfnkMqM29TDQLa+TkxCTxy1LmXXlj92PC/XKqYqz3jp7/vyVB9f2AqYDMQ=
X-Received: by 2002:a05:622a:4894:b0:497:905a:a278 with SMTP id
 d75a77b69052e-4a45a160230mr5903331cf.17.1748858761590; Mon, 02 Jun 2025
 03:06:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250527180245.1413463-1-tabba@google.com> <20250527180245.1413463-9-tabba@google.com>
In-Reply-To: <20250527180245.1413463-9-tabba@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Jun 2025 11:05:25 +0100
X-Gm-Features: AX0GCFvqKsap8kI0rwUo76wMQFwTRV67pcNR-RKL1HcTS7IxSyvId4-DGclgees
Message-ID: <CA+EHjTx1bxEXxtKHReT7QEhbPUZNiemgiSK2Q2X1UawPXXZFiA@mail.gmail.com>
Subject: Re: [PATCH v10 08/16] KVM: guest_memfd: Allow host to map guest_memfd pages
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
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

Hi,

On Tue, 27 May 2025 at 19:03, Fuad Tabba <tabba@google.com> wrote:
>
> This patch enables support for shared memory in guest_memfd, including
> mapping that memory at the host userspace. This support is gated by the
> configuration option KVM_GMEM_SHARED_MEM, and toggled by the guest_memfd
> flag GUEST_MEMFD_FLAG_SUPPORT_SHARED, which can be set when creating a
> guest_memfd instance.
>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 10 ++++
>  arch/x86/kvm/x86.c              |  3 +-
>  include/linux/kvm_host.h        | 13 ++++++
>  include/uapi/linux/kvm.h        |  1 +
>  virt/kvm/Kconfig                |  5 ++
>  virt/kvm/guest_memfd.c          | 81 +++++++++++++++++++++++++++++++++
>  6 files changed, 112 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 709cc2a7ba66..ce9ad4cd93c5 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2255,8 +2255,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>
>  #ifdef CONFIG_KVM_GMEM
>  #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
> +
> +/*
> + * CoCo VMs with hardware support that use guest_memfd only for backing private
> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
> + */
> +#define kvm_arch_supports_gmem_shared_mem(kvm)                 \
> +       (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&                      \
> +        ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||             \
> +         (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
>  #else
>  #define kvm_arch_supports_gmem(kvm) false
> +#define kvm_arch_supports_gmem_shared_mem(kvm) false
>  #endif
>
>  #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 035ced06b2dd..2a02f2457c42 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12718,7 +12718,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>                 return -EINVAL;
>
>         kvm->arch.vm_type = type;
> -       kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
> +       kvm->arch.supports_gmem =
> +               type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
>         /* Decided by the vendor code for other VM types.  */
>         kvm->arch.pre_fault_allowed =
>                 type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 80371475818f..ba83547e62b0 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -729,6 +729,19 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
>  }
>  #endif
>
> +/*
> + * Returns true if this VM supports shared mem in guest_memfd.
> + *
> + * Arch code must define kvm_arch_supports_gmem_shared_mem if support for
> + * guest_memfd is enabled.
> + */
> +#if !defined(kvm_arch_supports_gmem_shared_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
> +static inline bool kvm_arch_supports_gmem_shared_mem(struct kvm *kvm)
> +{
> +       return false;
> +}
> +#endif
> +
>  #ifndef kvm_arch_has_readonly_mem
>  static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
>  {
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index b6ae8ad8934b..c2714c9d1a0e 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1566,6 +1566,7 @@ struct kvm_memory_attributes {
>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>
>  #define KVM_CREATE_GUEST_MEMFD _IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED        (1ULL << 0)
>
>  struct kvm_create_guest_memfd {
>         __u64 size;
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 559c93ad90be..df225298ab10 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -128,3 +128,8 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
>  config HAVE_KVM_ARCH_GMEM_INVALIDATE
>         bool
>         depends on KVM_GMEM
> +
> +config KVM_GMEM_SHARED_MEM
> +       select KVM_GMEM
> +       bool
> +       prompt "Enable support for non-private (shared) memory in guest_memfd"
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 6db515833f61..5d34712f64fc 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -312,7 +312,81 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>         return gfn - slot->base_gfn + slot->gmem.pgoff;
>  }
>
> +static bool kvm_gmem_supports_shared(struct inode *inode)
> +{
> +       u64 flags;
> +
> +       if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
> +               return false;
> +
> +       flags = (u64)inode->i_private;
> +
> +       return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> +}
> +
> +
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> +{
> +       struct inode *inode = file_inode(vmf->vma->vm_file);
> +       struct folio *folio;
> +       vm_fault_t ret = VM_FAULT_LOCKED;
> +

This was mentioned in a different thread [*], but it should also be
mentioned here. This is missing a bound check. I have added the
following for the next spin:

+       if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
+               return VM_FAULT_SIGBUS;
+

I've also added a selftest to test this.

Cheers,
/fuad

[*] https://lore.kernel.org/all/CA+EHjTyv9KsRsbf6ec9u5mLjBbcnNti9k8hPi9Do59Mw7ayYqw@mail.gmail.com/

> +       folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +       if (IS_ERR(folio)) {
> +               int err = PTR_ERR(folio);
> +
> +               if (err == -EAGAIN)
> +                       return VM_FAULT_RETRY;
> +
> +               return vmf_error(err);
> +       }
> +
> +       if (WARN_ON_ONCE(folio_test_large(folio))) {
> +               ret = VM_FAULT_SIGBUS;
> +               goto out_folio;
> +       }
> +
> +       if (!folio_test_uptodate(folio)) {
> +               clear_highpage(folio_page(folio, 0));
> +               kvm_gmem_mark_prepared(folio);
> +       }
> +
> +       vmf->page = folio_file_page(folio, vmf->pgoff);
> +
> +out_folio:
> +       if (ret != VM_FAULT_LOCKED) {
> +               folio_unlock(folio);
> +               folio_put(folio);
> +       }
> +
> +       return ret;
> +}
> +
> +static const struct vm_operations_struct kvm_gmem_vm_ops = {
> +       .fault = kvm_gmem_fault_shared,
> +};
> +
> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +       if (!kvm_gmem_supports_shared(file_inode(file)))
> +               return -ENODEV;
> +
> +       if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> +           (VM_SHARED | VM_MAYSHARE)) {
> +               return -EINVAL;
> +       }
> +
> +       vma->vm_ops = &kvm_gmem_vm_ops;
> +
> +       return 0;
> +}
> +#else
> +#define kvm_gmem_mmap NULL
> +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
> +
>  static struct file_operations kvm_gmem_fops = {
> +       .mmap           = kvm_gmem_mmap,
>         .open           = generic_file_open,
>         .release        = kvm_gmem_release,
>         .fallocate      = kvm_gmem_fallocate,
> @@ -463,6 +537,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>         u64 flags = args->flags;
>         u64 valid_flags = 0;
>
> +       if (kvm_arch_supports_gmem_shared_mem(kvm))
> +               valid_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> +
>         if (flags & ~valid_flags)
>                 return -EINVAL;
>
> @@ -501,6 +578,10 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>             offset + size > i_size_read(inode))
>                 goto err;
>
> +       if (kvm_gmem_supports_shared(inode) &&
> +           !kvm_arch_supports_gmem_shared_mem(kvm))
> +               goto err;
> +
>         filemap_invalidate_lock(inode->i_mapping);
>
>         start = offset >> PAGE_SHIFT;
> --
> 2.49.0.1164.gab81da1b16-goog
>

