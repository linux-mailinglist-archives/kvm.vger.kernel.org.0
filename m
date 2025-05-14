Return-Path: <kvm+bounces-46468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84847AB67E6
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 11:47:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75F684A850E
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11DE322DA0A;
	Wed, 14 May 2025 09:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LL6VlOGD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480B325B682
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 09:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747215985; cv=none; b=b2Ix5hPrZ3P0cRNL5v8yR+3AS36gwoU9QJ/gv15d7HrTSceh423z6fgBRVPIeE0o1aDHnX/G/sFDjKqsjmTAGin0bGxXxBZc19WREm7pY5aAJaW+SnvksgnEkCSXJXxJr/MAU6JokY1FphEqDx9GNke2ufNt0j5n1odszbk/veY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747215985; c=relaxed/simple;
	bh=J+rly1GbWCb4aI+Mkhoyrk3uNvYxGwd8P3DWWOSoeOs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GYC7L3EBjhksfWlPngmX113DlSYnLOKeKP3Us/0PDsVHicmpss+ZL219mRSXoxpC1TRwSpGCJmfm7XJuCPEKWLZKB+O/VftmEF3iXOPQIhgmxyVSh9JEhqvemuSsFzhtYWZOvcBPIRGIdAa9hniXK8FTwqyErBRwk5aIL5xj6CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LL6VlOGD; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-48b7747f881so212961cf.1
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 02:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747215982; x=1747820782; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iOR+pgYJTWweXD6yG07hJucbInjcwioB90Ea884+nYE=;
        b=LL6VlOGDieG4/n39R8hux2U80ctVrVNVAYWQYZ3pWcSNONjP6i+pvfdSMslnuo/1G7
         5kORU5EpiSlvfMo8J3Nr/2NsmqtyUEKOlP7VjyL9CeY3+d8+j0F+qGxE+5+y0gyjcAlG
         hzUcdCoQkAL1EE+YMjnlRH4MjxeXexwuc73UwmhEYxki9GBko3/wSVtUPYpCd9LtRatN
         dpjXMKqNGiJzviOPqF9egxtpicvCgOBB7dBsvzROghDbD6SbE3ob8EljGQOYteeeerEM
         Dlg2Up/bfXKvSe/LjTUXRzTo9ZhoTVhg5aEI8JpWjpSVLzFVjgJvCljjFrKKSpuK/yDu
         EClg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747215982; x=1747820782;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iOR+pgYJTWweXD6yG07hJucbInjcwioB90Ea884+nYE=;
        b=kB9UEEMvHLOPaZGFXVK2o0FJlvPZeJ9ghl6dv7TkPW+nRPSjNAe2jV3Fiozu9OIWVD
         IbK5WuxBxfQCE9u+1w7KPyk1+/BymuUa1tmfgYuSQ9YzQ9FvLyXLhHCML1uXpYByvZv8
         JSMYghnhto9icu956I0uSXbUEjxz5jIRcVVA/GmNDjtTupkrlS4Y17nMnGSDwinBYK9D
         5FrpcweAA6JqC3N1BN4Wvmju9U6Qzuln0iV0wkygafdAVD7ug1A+Fm7tr0l0M54Rm5oc
         oCSp/rbyPvMUBbVxVV/ejUgU6kjfqHDPoiaP2+A1RQES21a1sZ7zaVEaL+IozTTPqwLw
         C7Tw==
X-Gm-Message-State: AOJu0YyDpOjtkxwj5K745fn8kJHU2/18x08/Sh7WAtvSeO1kP0Q1RQ/i
	vxCpyqXVnIOrAIGch+X1+bstRTZ09U8Fd4LXePwCSvRlz3uMCBVBq5mf8wDwUPLnCAVkVIiMNAb
	fVefG5NIlyX3ttr1ghQNIIurie+3ItbknmsALX4J8
X-Gm-Gg: ASbGncs4dak6Cid4e9PF/gUTzhNecN5GBp7rTYi58fBxvPEgkwHBOtwC+uZQX5SegbV
	lO6tbyfGIQtTYcDCGKDRZafJgFHNoj0BqbZej2uhs+l29gNMVnf8ZwqUGSI//8D6NTW75Yxor6I
	M4cyzlEZ98SocypDR8f7Ydla6lP66MWpLrxQ==
X-Google-Smtp-Source: AGHT+IHyXlMRKjAmg9V7IyA3mOWuDec01j7eEOwdXb9gDqhAhTkKneyeDAXJK2yiqrmn020zaP9OVr8cS2btAa7PV0w=
X-Received: by 2002:a05:622a:1444:b0:494:58a3:d3d3 with SMTP id
 d75a77b69052e-494961696a3mr3574791cf.20.1747215981711; Wed, 14 May 2025
 02:46:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com> <20250513163438.3942405-8-tabba@google.com>
 <ca08a552-5d9d-4839-9d3e-0d3c73959cf8@amd.com>
In-Reply-To: <ca08a552-5d9d-4839-9d3e-0d3c73959cf8@amd.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 14 May 2025 10:45:45 +0100
X-Gm-Features: AX0GCFvlOF6eIA97TFqNjFliq9ZQWn-Oxff0pXN7KQAMo9uomoYCYAE-vSm4W_I
Message-ID: <CA+EHjTxwO3gwZJoY_rBxJgvmYEVyT9fw4kaGQF=fbyavdrK5Qw@mail.gmail.com>
Subject: Re: [PATCH v9 07/17] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
To: Shivank Garg <shivankg@amd.com>
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

Thanks Shivank,

On Wed, 14 May 2025 at 09:03, Shivank Garg <shivankg@amd.com> wrote:
>
> On 5/13/2025 10:04 PM, Fuad Tabba wrote:
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
> > +#define kvm_arch_vm_supports_gmem_shared_mem(kvm)                    \
> > +     (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&                      \
> > +      ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||             \
> > +       (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
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
> > +     return false;
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
> >  #define KVM_CREATE_GUEST_MEMFD       _IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> > +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED      (1UL << 0)
> >
> >  struct kvm_create_guest_memfd {
> >       __u64 size;
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
>
> Hi,
>
> I noticed following warnings with checkpatch.pl:
>
> WARNING: Argument 'kvm' is not used in function-like macro
> #42: FILE: arch/x86/include/asm/kvm_host.h:2269:
> +#define kvm_arch_vm_supports_gmem_shared_mem(kvm) false
>
> WARNING: please write a help paragraph that fully describes the config symbol with at least 4 lines
> #91: FILE: virt/kvm/Kconfig:132:
> +config KVM_GMEM_SHARED_MEM
> +       select KVM_GMEM
> +       bool
> +       prompt "Enables in-place shared memory for guest_memfd"
>
> 0003-KVM-Rename-kvm_arch_has_private_mem-to-kvm_arch_supp.patch
> -----------------------------------------------------------------------------
> WARNING: Argument 'kvm' is not used in function-like macro
> #35: FILE: arch/x86/include/asm/kvm_host.h:2259:
> +#define kvm_arch_supports_gmem(kvm) false
>
> total: 0 errors, 1 warnings, 91 lines checked
>
> Please let me know if these are ignored intentionally - if so, sorry for the noise.

Yes, I did intentionally ignore these.
kvm_arch_vm_supports_gmem_shared_mem() follows the same pattern as
kvm_arch_supports_gmem(). As for the comment, I couldn't think of four
lines to describe the config option that's not just fluff :)

Cheers,
/fuad

> Best Regards,
> Shivank
>
>
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 6db515833f61..8e6d1866b55e 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -312,7 +312,88 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
> >       return gfn - slot->base_gfn + slot->gmem.pgoff;
> >  }
> >
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +
> > +static bool kvm_gmem_supports_shared(struct inode *inode)
> > +{
> > +     uint64_t flags = (uint64_t)inode->i_private;
> > +
> > +     return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> > +}
> > +
> > +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> > +{
> > +     struct inode *inode = file_inode(vmf->vma->vm_file);
> > +     struct folio *folio;
> > +     vm_fault_t ret = VM_FAULT_LOCKED;
> > +
> > +     filemap_invalidate_lock_shared(inode->i_mapping);
> > +
> > +     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> > +     if (IS_ERR(folio)) {
> > +             int err = PTR_ERR(folio);
> > +
> > +             if (err == -EAGAIN)
> > +                     ret = VM_FAULT_RETRY;
> > +             else
> > +                     ret = vmf_error(err);
> > +
> > +             goto out_filemap;
> > +     }
> > +
> > +     if (folio_test_hwpoison(folio)) {
> > +             ret = VM_FAULT_HWPOISON;
> > +             goto out_folio;
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
> > +out_filemap:
> > +     filemap_invalidate_unlock_shared(inode->i_mapping);
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
> >  static struct file_operations kvm_gmem_fops = {
> > +     .mmap           = kvm_gmem_mmap,
> >       .open           = generic_file_open,
> >       .release        = kvm_gmem_release,
> >       .fallocate      = kvm_gmem_fallocate,
> > @@ -463,6 +544,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
> >       u64 flags = args->flags;
> >       u64 valid_flags = 0;
> >
> > +     if (kvm_arch_vm_supports_gmem_shared_mem(kvm))
> > +             valid_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> > +
> >       if (flags & ~valid_flags)
> >               return -EINVAL;
> >
> > @@ -501,6 +585,10 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
> >           offset + size > i_size_read(inode))
> >               goto err;
> >
> > +     if (kvm_gmem_supports_shared(inode) &&
> > +         !kvm_arch_vm_supports_gmem_shared_mem(kvm))
> > +             goto err;
> > +
> >       filemap_invalidate_lock(inode->i_mapping);
> >
> >       start = offset >> PAGE_SHIFT;
>

