Return-Path: <kvm+bounces-46377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 80B75AB5C5A
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 20:38:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 45FC119E5B11
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 18:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEE052BF99D;
	Tue, 13 May 2025 18:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DCMYmHZh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3901F2BEC41
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 18:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747161471; cv=none; b=GDEK+NT21ZU5dbFIgczWV96rIrWUn9oYcMSAxKUYZDRKSLT+GzZJf4jNtfBD7M3hGW+9mKDZx1Xj8xoqsZ6yO2x76+izFPGbJBRMXbvaZbGfJtaQC06uZTcZBGP3mccRFnUk2AafJc2juYr6dVIH8m+ayrYSXDJgx8A+H6/BJRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747161471; c=relaxed/simple;
	bh=5nOLHaqyExrxnpuoDJU4PrlfZ8ckzsOVQE2UfnvlHr4=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=VI/EnAWBfdkWNuUZxE/39SgkdvwzBuXzDGqcFK835p6VMW8gQcSkBNQyrFgnhSFYcpQNG5Cpw1gz4WyDuPnDdh9l/OjzNk1xcZwEVxtrf1bvvDpmf4B856z6nc4ApzUdZYtgFstgVjvf3CBslvgE1CCxvdW7EzBiYqGnSq5E5NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DCMYmHZh; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30a39fa0765so9536769a91.3
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 11:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747161469; x=1747766269; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=b9MDuR/Dl6kL0FyxL+7OxnJbF8Mp0T3/2fFmI1SGZh0=;
        b=DCMYmHZhZCawWPXFCa/CunLlYcKp4pXh8Qmgt5pUetr244J9fsS4qh+jgJnPG/KAMc
         pOdIGBu87PPd092hC9+i7pdWta48kyyrdp9HR8tweSOCGoGpXA5BX9Ic4e3Q/NM83ERe
         ycNRAoaeOjEMGe5ojZD51fRU3uFyDp644EwECytdgLo1pZzyPKpMHET7Uw7M4jakKSmo
         9Qqf0bSvw3nsZzm0nkJoG5Tt5NwBIKGbssYfgZXba9IOL79Uw2yFxUXc5PDwA0whig/k
         UMB3FteMmonIAlBwURCjwtuQzDoXTnKZNdWGpqS1iwNYB0rLEHvIjGiAhjOsclgSt8pf
         82BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747161469; x=1747766269;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b9MDuR/Dl6kL0FyxL+7OxnJbF8Mp0T3/2fFmI1SGZh0=;
        b=H/EUgMHHON0OygTXp94xfFl0iS+HtuROS41CK+uvZ/pQzIBsRV4sJ/BVSQzBQCwreL
         mFRLMpoij2jEHNxry85UAjPy3wjF05LvVovs0ZoT8q5sQLRpbJYUQCy3XOX+UTPIMYJ+
         W0vkWsTkXp0tiKLrKgS5eh2cdvxch5Guhoqu0c3LlGAS5XM7k33gQM0WyHUJENfPUu/T
         84QZmCIUlAaHWqtJ0PRAfrIC92qEHaHkvUz1WSIlHHYjEMZ4x+LX19kzcTVc9mC/wmTo
         dDUrzf3hKk33L2n+rTN9w+LEQApZ9Jdr8EsFUGvT3C3v7WF8f5LLrNU1oAAI9Cwy4LeI
         xXlQ==
X-Gm-Message-State: AOJu0YzJw2X8OB7ZRZWnYQDo9Umj3/FPCD7aHFCB8ehzdkVzHv0JEIgF
	Z5NPIK5I3Ce754/UYy+laYPSt2z04ucpx5wNXNzq2REtpvNcuLL7AeAXYAGCgHF/FD7KQzY2GiV
	TnC4M6L30TshNrWIGEoHQPg==
X-Google-Smtp-Source: AGHT+IHh48dnUNnPj0jVGNHdz5yY1x34jSSkfzq+soIDIBQwcVrmJ1EYujTkYpGapSQ59E8CIvectH0AL1mRigl+MA==
X-Received: from pjtq3.prod.google.com ([2002:a17:90a:c103:b0:2ff:8471:8e53])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5590:b0:2ea:7cd5:4ad6 with SMTP id 98e67ed59e1d1-30e2e633695mr794444a91.32.1747161469403;
 Tue, 13 May 2025 11:37:49 -0700 (PDT)
Date: Tue, 13 May 2025 11:37:48 -0700
In-Reply-To: <20250513163438.3942405-8-tabba@google.com> (message from Fuad
 Tabba on Tue, 13 May 2025 17:34:28 +0100)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzsel8pdab.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v9 07/17] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com, ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

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
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 709cc2a7ba66..f72722949cae 100644
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
> +#define kvm_arch_vm_supports_gmem_shared_mem(kvm)			\
> +	(IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&			\
> +	 ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||		\
> +	  (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
>  #else
>  #define kvm_arch_supports_gmem(kvm) false
> +#define kvm_arch_vm_supports_gmem_shared_mem(kvm) false
>  #endif
>  
>  #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ae70e4e19700..2ec89c214978 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -729,6 +729,19 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
>  }
>  #endif
>  
> +/*
> + * Returns true if this VM supports shared mem in guest_memfd.
> + *
> + * Arch code must define kvm_arch_vm_supports_gmem_shared_mem if support for
> + * guest_memfd is enabled.
> + */
> +#if !defined(kvm_arch_vm_supports_gmem_shared_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
> +static inline bool kvm_arch_vm_supports_gmem_shared_mem(struct kvm *kvm)
> +{
> +	return false;
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
>  #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED	(1UL << 0)
>  
>  struct kvm_create_guest_memfd {
>  	__u64 size;
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
> @@ -312,7 +312,88 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>  	return gfn - slot->base_gfn + slot->gmem.pgoff;
>  }
>  
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> +
> +static bool kvm_gmem_supports_shared(struct inode *inode)
> +{
> +	uint64_t flags = (uint64_t)inode->i_private;
> +
> +	return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> +}
> +
> +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> +{
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	struct folio *folio;
> +	vm_fault_t ret = VM_FAULT_LOCKED;
> +
> +	filemap_invalidate_lock_shared(inode->i_mapping);
> +
> +	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +	if (IS_ERR(folio)) {
> +		int err = PTR_ERR(folio);
> +
> +		if (err == -EAGAIN)
> +			ret = VM_FAULT_RETRY;
> +		else
> +			ret = vmf_error(err);
> +
> +		goto out_filemap;
> +	}
> +
> +	if (folio_test_hwpoison(folio)) {
> +		ret = VM_FAULT_HWPOISON;
> +		goto out_folio;
> +	}
> +
> +	if (WARN_ON_ONCE(folio_test_large(folio))) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_folio;
> +	}
> +
> +	if (!folio_test_uptodate(folio)) {
> +		clear_highpage(folio_page(folio, 0));
> +		kvm_gmem_mark_prepared(folio);
> +	}
> +
> +	vmf->page = folio_file_page(folio, vmf->pgoff);
> +
> +out_folio:
> +	if (ret != VM_FAULT_LOCKED) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +
> +out_filemap:
> +	filemap_invalidate_unlock_shared(inode->i_mapping);

Do we need to hold the filemap_invalidate_lock while zeroing? Would
holding the folio lock be enough?

> +
> +	return ret;
> +}
> +
> +static const struct vm_operations_struct kvm_gmem_vm_ops = {
> +	.fault = kvm_gmem_fault_shared,
> +};
> +
> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	if (!kvm_gmem_supports_shared(file_inode(file)))
> +		return -ENODEV;
> +
> +	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> +	    (VM_SHARED | VM_MAYSHARE)) {
> +		return -EINVAL;
> +	}
> +
> +	vma->vm_ops = &kvm_gmem_vm_ops;
> +
> +	return 0;
> +}
> +#else
> +#define kvm_gmem_mmap NULL
> +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
> +
>  static struct file_operations kvm_gmem_fops = {
> +	.mmap		= kvm_gmem_mmap,
>  	.open		= generic_file_open,
>  	.release	= kvm_gmem_release,
>  	.fallocate	= kvm_gmem_fallocate,
> @@ -463,6 +544,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>  	u64 flags = args->flags;
>  	u64 valid_flags = 0;
>  
> +	if (kvm_arch_vm_supports_gmem_shared_mem(kvm))
> +		valid_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> +
>  	if (flags & ~valid_flags)
>  		return -EINVAL;
>  
> @@ -501,6 +585,10 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	    offset + size > i_size_read(inode))
>  		goto err;
>  
> +	if (kvm_gmem_supports_shared(inode) &&
> +	    !kvm_arch_vm_supports_gmem_shared_mem(kvm))
> +		goto err;
> +
>  	filemap_invalidate_lock(inode->i_mapping);
>  
>  	start = offset >> PAGE_SHIFT;

