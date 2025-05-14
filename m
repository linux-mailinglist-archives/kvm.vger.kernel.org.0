Return-Path: <kvm+bounces-46544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C89E7AB7733
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 22:40:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAD948650D9
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 20:40:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1EEF296173;
	Wed, 14 May 2025 20:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HOVSjksD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D15A156C6F
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 20:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747255246; cv=none; b=XxBLRylrIq/rfJLUtQ90DrTPNa3z36dduxAWdocZTPO9i4YqsB6W3Y+4zoJQEJU+aNpNEvCOszSr9snRDAHLPFfQEr9I8zbC7ZJetybnxDGe+ZVUu0f3qQAVG9sqo5jweHSVXbIgiyvd/dmBlN6P+244HLbkgIKIl4A04xn4LL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747255246; c=relaxed/simple;
	bh=vrW2FSdPgIX7PzIoHiNHHY5rcWWp2rmJQgDUkY4gCu8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XhnhkZ8Maq7AAiBYED8llPEfHG9s9XiQQUHke6QhIzCs/cr55ahqcowQKJAvucnC/32Y5u0sOUlAeaRe3lFLkc61hHkr/wMAfxlwOtBmrn+l0SLcm0836tvlDCuVf9Ij2SIY1W/6PBeiL9osxalgbLIzY8GhD72//fipaEi90Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HOVSjksD; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-7081165a238so1853537b3.1
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 13:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747255243; x=1747860043; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T/7+afizZx7+/RQDjCUDJIpgGk5iqWIyw/rWqCvD/nw=;
        b=HOVSjksDbdxvAMixpbw5y0ocHbZDqYxtx4UOSZ1YA06S6fed0EDW1EpoI16ZNmkC+D
         Vl/34dE/Scc/xHUP0mWuyg1ZI16l89wxqUtbJoc82md8CQrihW0qZjA5rT/sz+BO4RN3
         /db+Y4J+JkxCcyRWT56GroDaLw4/Z8NegddrS03OgQNHhOBfOlvT4adXnAhGPmBtRAvq
         HouCfc93kug0d3sH/WuAfMTSbKYniK5GeG5imyffsbJRg1gYM5MKk9sjJkaZQTUe7pyM
         jO9q2SWJu7mn+Z+w0vfXldjUFq7iBJhXW5OVueQqVLh1D2vai3pJE1+tTpQDuhuT2bCz
         cQOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747255243; x=1747860043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T/7+afizZx7+/RQDjCUDJIpgGk5iqWIyw/rWqCvD/nw=;
        b=lsvUp6g9HFP0l3+IRiVhhWr7rhdLysMLAMhPgbb/bvyqzxuIRWNISw+/3f5VN7NZO6
         OpzVwZiw1CMrKOKFbGByreU1L8G+nnYKt6rqtCUs9y9369uFWPXMCqC/+CwTP4eXkf3L
         wNXvQlPTyy2yNFHzfFfvSgaRCjK/G4oHwj/bn/cza3hG8Fg4bftbNBXsCA0X7JSdVMC+
         te//3JnJ76tOrxmqT+w47WsNO21Mg0kWtmZdyRfDtiQ3YyCbYG/rlaxvbs74s67waWN1
         JrEC4Gm1eyzdj3AXQXGiutS6qHsoJwANBZTfEF+mam6MHBQ7ft830VsTM/bMDL26hza4
         MTyA==
X-Gm-Message-State: AOJu0Yz4Iijpt/AstLw2ruqqn0gunzLWWDxXvELqM1UIXEA+NGRx5KFw
	t3bJyxjLYXr/wsN9ch02VclR0U8WCbmhjurFFgyVYCmDSFH8shfkQKlL5T/3KON1yDdpj1m7LYV
	hS2OPUeMZ5vIlxruxA1emNskoNk6OkkvEDoevoVTLN3qxWUcr1aQLxEN56Q==
X-Gm-Gg: ASbGncvD1a3CMMv1NolCikMTh9Jbta4zWKXlciIBeTV40WIFHjUwKK2KQ7CkV9TXuII
	GybEW8pO+h06E5oKzxjvBtksfZE61QtH/cIPyp21LXvNUhT6QsGN6Y4laRgYasQvxnJol6j9F1X
	uzm5LHfbWbL+/Ub++wJjndcwBlfpaIuv9U0pI/EfUOb7no8P/+InOccwwDF8ryi6g=
X-Google-Smtp-Source: AGHT+IHMOoxxNuOHFNWO8IK0boxKcMaNPhWodorBvd9h9FTfRV8OHIpNfD/gZaEW3uynJG2ygIW8tBaT72OOCtVP8aM=
X-Received: by 2002:a05:690c:508d:b0:70c:9364:2c61 with SMTP id
 00721157ae682-70c936433d2mr1717257b3.9.1747255242891; Wed, 14 May 2025
 13:40:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com> <20250513163438.3942405-8-tabba@google.com>
In-Reply-To: <20250513163438.3942405-8-tabba@google.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 14 May 2025 13:40:06 -0700
X-Gm-Features: AX0GCFtK2DyiNvyhImWHSxXTuu1QIux7oSRN4_q-FDUfQ5BDQ4-9OKFnUEDKbWU
Message-ID: <CADrL8HW+Rv4k-VX2s96n7m8OZ9R_NsHOCvtpAKUiwybiyJ63Pg@mail.gmail.com>
Subject: Re: [PATCH v9 07/17] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
To: Fuad Tabba <tabba@google.com>
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
	peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

,

On Tue, May 13, 2025 at 9:34=E2=80=AFAM Fuad Tabba <tabba@google.com> wrote=
:
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
>  include/linux/kvm_host.h        | 13 +++++
>  include/uapi/linux/kvm.h        |  1 +
>  virt/kvm/Kconfig                |  5 ++
>  virt/kvm/guest_memfd.c          | 88 +++++++++++++++++++++++++++++++++
>  5 files changed, 117 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 709cc2a7ba66..f72722949cae 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2255,8 +2255,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_fo=
rced_root_level,
>
>  #ifdef CONFIG_KVM_GMEM
>  #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
> +
> +/*
> + * CoCo VMs with hardware support that use guest_memfd only for backing =
private
> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enab=
led.
> + */
> +#define kvm_arch_vm_supports_gmem_shared_mem(kvm)                      \
> +       (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&                      \
> +        ((kvm)->arch.vm_type =3D=3D KVM_X86_SW_PROTECTED_VM ||          =
   \
> +         (kvm)->arch.vm_type =3D=3D KVM_X86_DEFAULT_VM))
>  #else
>  #define kvm_arch_supports_gmem(kvm) false
> +#define kvm_arch_vm_supports_gmem_shared_mem(kvm) false
>  #endif
>
>  #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state=
)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ae70e4e19700..2ec89c214978 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -729,6 +729,19 @@ static inline bool kvm_arch_supports_gmem(struct kvm=
 *kvm)
>  }
>  #endif
>
> +/*
> + * Returns true if this VM supports shared mem in guest_memfd.
> + *
> + * Arch code must define kvm_arch_vm_supports_gmem_shared_mem if support=
 for
> + * guest_memfd is enabled.
> + */
> +#if !defined(kvm_arch_vm_supports_gmem_shared_mem) && !IS_ENABLED(CONFIG=
_KVM_GMEM)
> +static inline bool kvm_arch_vm_supports_gmem_shared_mem(struct kvm *kvm)
> +{
> +       return false;
> +}
> +#endif
> +
>  #ifndef kvm_arch_has_readonly_mem
>  static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
>  {
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index b6ae8ad8934b..9857022a0f0c 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1566,6 +1566,7 @@ struct kvm_memory_attributes {
>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>
>  #define KVM_CREATE_GUEST_MEMFD _IOWR(KVMIO,  0xd4, struct kvm_create_gue=
st_memfd)
> +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED        (1UL << 0)
>
>  struct kvm_create_guest_memfd {
>         __u64 size;
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 559c93ad90be..f4e469a62a60 100644
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
> +       prompt "Enables in-place shared memory for guest_memfd"
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 6db515833f61..8e6d1866b55e 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -312,7 +312,88 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_=
slot *slot, gfn_t gfn)
>         return gfn - slot->base_gfn + slot->gmem.pgoff;
>  }
>
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> +
> +static bool kvm_gmem_supports_shared(struct inode *inode)
> +{
> +       uint64_t flags =3D (uint64_t)inode->i_private;
> +
> +       return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> +}
> +
> +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> +{
> +       struct inode *inode =3D file_inode(vmf->vma->vm_file);
> +       struct folio *folio;
> +       vm_fault_t ret =3D VM_FAULT_LOCKED;
> +
> +       filemap_invalidate_lock_shared(inode->i_mapping);
> +
> +       folio =3D kvm_gmem_get_folio(inode, vmf->pgoff);
> +       if (IS_ERR(folio)) {
> +               int err =3D PTR_ERR(folio);
> +
> +               if (err =3D=3D -EAGAIN)
> +                       ret =3D VM_FAULT_RETRY;
> +               else
> +                       ret =3D vmf_error(err);
> +
> +               goto out_filemap;
> +       }
> +
> +       if (folio_test_hwpoison(folio)) {
> +               ret =3D VM_FAULT_HWPOISON;
> +               goto out_folio;
> +       }
> +
> +       if (WARN_ON_ONCE(folio_test_large(folio))) {
> +               ret =3D VM_FAULT_SIGBUS;
> +               goto out_folio;
> +       }
> +
> +       if (!folio_test_uptodate(folio)) {
> +               clear_highpage(folio_page(folio, 0));
> +               kvm_gmem_mark_prepared(folio);
> +       }
> +
> +       vmf->page =3D folio_file_page(folio, vmf->pgoff);
> +
> +out_folio:
> +       if (ret !=3D VM_FAULT_LOCKED) {
> +               folio_unlock(folio);
> +               folio_put(folio);
> +       }
> +
> +out_filemap:
> +       filemap_invalidate_unlock_shared(inode->i_mapping);
> +
> +       return ret;
> +}
> +
> +static const struct vm_operations_struct kvm_gmem_vm_ops =3D {
> +       .fault =3D kvm_gmem_fault_shared,
> +};
> +
> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +       if (!kvm_gmem_supports_shared(file_inode(file)))
> +               return -ENODEV;
> +
> +       if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=3D
> +           (VM_SHARED | VM_MAYSHARE)) {
> +               return -EINVAL;
> +       }
> +
> +       vma->vm_ops =3D &kvm_gmem_vm_ops;
> +
> +       return 0;
> +}
> +#else
> +#define kvm_gmem_mmap NULL
> +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
> +
>  static struct file_operations kvm_gmem_fops =3D {
> +       .mmap           =3D kvm_gmem_mmap,
>         .open           =3D generic_file_open,
>         .release        =3D kvm_gmem_release,
>         .fallocate      =3D kvm_gmem_fallocate,
> @@ -463,6 +544,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_creat=
e_guest_memfd *args)
>         u64 flags =3D args->flags;
>         u64 valid_flags =3D 0;
>
> +       if (kvm_arch_vm_supports_gmem_shared_mem(kvm))
> +               valid_flags |=3D GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> +
>         if (flags & ~valid_flags)
>                 return -EINVAL;
>
> @@ -501,6 +585,10 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory=
_slot *slot,
>             offset + size > i_size_read(inode))
>                 goto err;
>
> +       if (kvm_gmem_supports_shared(inode) &&

When building without CONFIG_KVM_GMEM_SHARED_MEM, my compiler
complains that kvm_gmem_supports_shared() is not defined.

> +           !kvm_arch_vm_supports_gmem_shared_mem(kvm))
> +               goto err;
> +
>         filemap_invalidate_lock(inode->i_mapping);
>
>         start =3D offset >> PAGE_SHIFT;
> --
> 2.49.0.1045.g170613ef41-goog
>

