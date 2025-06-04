Return-Path: <kvm+bounces-48370-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D821DACD7B6
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 08:03:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33BB5176942
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 06:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DADC262FD9;
	Wed,  4 Jun 2025 06:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OwMIDZ50"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603DE199FAB
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 06:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749016972; cv=none; b=SVgVtzLPSieKhqGW2HmdLpKGjGfxKvz5tGr7rRwgxN8xiSOKHR1WRd6mhMEukFado2azQp6w0l7G3Bac3HbI0vXC5sReKM3oYkMr09rhnLI5EJ/QJhqh4t/tFPBZe3dSsek2fgbzPwAo9LSlp+w1uyRIv5dCHhebmoCYhOTSIXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749016972; c=relaxed/simple;
	bh=0S+zKM1VTG03hJ7FkjXHPl1Q2BTrRfNEHJufTC1rUYQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rIFmoPAlnhhTVDLavNYKdceuB+Z0CCYaA2zGEMevdckf1/STs3UogvwPKS5iZPNXJ2TbnE8Zj39UlZavP8ci0QHZXyFeRX2bzDepsY9MTMMJbfYKkaPBYRb8CTNz5u8QpCkOpUgTHJfaeqfXNX4LoadyNvrXvp39yKSMnBtPvkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OwMIDZ50; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749016969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k5uLUF947dFAnsNE7++/VYYbP4qG+tIlvwWDVTd+HiU=;
	b=OwMIDZ50HYW3sxUHziLdQpd12urGmS9AHGAK5Fj2YahpDVhnr1ocq4VxNEiqnKCumdJaT6
	ZF2RIL3ruZFmWC+2OV6F8TUPsNH6dPuOo+AiYAQhYmxJ0QbNVFwI9+mxrc5wOnvIxljHDm
	u/c27Qxr0UcKY4vkUFPPoCUhnNbYH3M=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-426-R-qvp6Z3PP2reO7IXJBUkw-1; Wed, 04 Jun 2025 02:02:47 -0400
X-MC-Unique: R-qvp6Z3PP2reO7IXJBUkw-1
X-Mimecast-MFC-AGG-ID: R-qvp6Z3PP2reO7IXJBUkw_1749016966
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-740774348f6so5475962b3a.1
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 23:02:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749016966; x=1749621766;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k5uLUF947dFAnsNE7++/VYYbP4qG+tIlvwWDVTd+HiU=;
        b=MCubtJ7obQapIgfM/BDAd2eIalrUJZqPxN2OMzEeP1+KrUqN0FXs8COyfeqtVCin0C
         4Fs0jhUVXXXkaJb7oshTndrR50zwSsfrjbDvnF+rOpraICWr2ZcavuUg6Zx0zpWfTtwm
         ZhZ3QPtTNRSJvrsKbyYI7ut33VHXaSOTRS50neVF4nqwCch3s1fa5vVIcxQ/Iq65bnCX
         ptl2H7JkppIvElcRPPv1UZlnW6389IvwGlIM9ypovwc10sz4jxzTeoFsLJpbqgLf0rsp
         RVLfdJPXlepabSKBkuIrJ6b2pV+pLzpdN5lXkjUx96BL68eQVnp9T1GFZATKcHJCasQv
         nsjg==
X-Forwarded-Encrypted: i=1; AJvYcCUbSQkJx4grd8iySES3j/91TLRkxC4FsO/MzbTB3gacj9GCbHfcoBicuSlu/Yz3BLzrxJc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzL1N/Gm8u5UULWiEXvtI0hLaMtNY18KrkjbgAPol1WvU0eOA5D
	GKFb6EaapyWRp0Y6BRdgbT+kutwAmDTXRy8HgE44hJDLVmjn5cpgs3NqxSC9R7U2xYVsr4dJQoQ
	fmk7yB4SAhWWiqnlUipgRk4j/WLe0XD4j+sH4+7MIzPjbnZ1KxdwahA==
X-Gm-Gg: ASbGncskHd0GQm4DJQDN8AvOZ8n93X7FQxQjz/mygScau20+UgxobED5oZ5y6fiYhu8
	Co04wn7EzeGf1JHhD1ibASPg0DfcCvq8Jf4FruR2Tc+OKdwB1j6UtNFsMbFfGLbMK95dt8yjQO9
	MqcosA2d4Odg+Ob6GKQyeroG5F6LXLvvst+gYIDFjLOcLLbugG78GbJ1oAIXtxxh5zivUt6WPz3
	6jBkeXeaUTYRPtnskzfS/6L9PA95ZRszyZ1V7Uis2iHjcPXW6Xppuju1O6Vdb9qmkFGdM4mD3cg
	+iQdAoU+MGexMab5HvFF1wRO9PPnhQP1DXhULQq+Eyd/V39VEoSiBNmt32EyNQ==
X-Received: by 2002:a05:6a21:4cc1:b0:1f3:2e85:c052 with SMTP id adf61e73a8af0-21d22b7f532mr2763342637.35.1749016966106;
        Tue, 03 Jun 2025 23:02:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbPgoAdH13lfHhim2/QFoHMd+Hf9TCaoInZNikaO5lQ5+Ego2tu4vOwUsU7zQXeW98WoOuzw==
X-Received: by 2002:a05:6a21:4cc1:b0:1f3:2e85:c052 with SMTP id adf61e73a8af0-21d22b7f532mr2763286637.35.1749016965618;
        Tue, 03 Jun 2025 23:02:45 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2eceb96f74sm7965235a12.62.2025.06.03.23.02.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 23:02:45 -0700 (PDT)
Message-ID: <e1ce3a20-4edb-475e-8401-d3af1b8967b8@redhat.com>
Date: Wed, 4 Jun 2025 16:02:23 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 08/16] KVM: guest_memfd: Allow host to map guest_memfd
 pages
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
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
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250527180245.1413463-1-tabba@google.com>
 <20250527180245.1413463-9-tabba@google.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250527180245.1413463-9-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Fuad,

On 5/28/25 4:02 AM, Fuad Tabba wrote:
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
>   arch/x86/include/asm/kvm_host.h | 10 ++++
>   arch/x86/kvm/x86.c              |  3 +-
>   include/linux/kvm_host.h        | 13 ++++++
>   include/uapi/linux/kvm.h        |  1 +
>   virt/kvm/Kconfig                |  5 ++
>   virt/kvm/guest_memfd.c          | 81 +++++++++++++++++++++++++++++++++
>   6 files changed, 112 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 709cc2a7ba66..ce9ad4cd93c5 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2255,8 +2255,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
>   
>   #ifdef CONFIG_KVM_GMEM
>   #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
> +
> +/*
> + * CoCo VMs with hardware support that use guest_memfd only for backing private
> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
> + */
> +#define kvm_arch_supports_gmem_shared_mem(kvm)			\
> +	(IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&			\
> +	 ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||		\
> +	  (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
>   #else
>   #define kvm_arch_supports_gmem(kvm) false
> +#define kvm_arch_supports_gmem_shared_mem(kvm) false
>   #endif
>   
>   #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 035ced06b2dd..2a02f2457c42 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12718,7 +12718,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   		return -EINVAL;
>   
>   	kvm->arch.vm_type = type;
> -	kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
> +	kvm->arch.supports_gmem =
> +		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
>   	/* Decided by the vendor code for other VM types.  */
>   	kvm->arch.pre_fault_allowed =
>   		type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 80371475818f..ba83547e62b0 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -729,6 +729,19 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
>   }
>   #endif
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
> +	return false;
> +}
> +#endif
> +
>   #ifndef kvm_arch_has_readonly_mem
>   static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
>   {
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index b6ae8ad8934b..c2714c9d1a0e 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1566,6 +1566,7 @@ struct kvm_memory_attributes {
>   #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>   
>   #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED	(1ULL << 0)
>   
>   struct kvm_create_guest_memfd {
>   	__u64 size;
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 559c93ad90be..df225298ab10 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -128,3 +128,8 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
>   config HAVE_KVM_ARCH_GMEM_INVALIDATE
>          bool
>          depends on KVM_GMEM
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
>   	return gfn - slot->base_gfn + slot->gmem.pgoff;
>   }
>   
> +static bool kvm_gmem_supports_shared(struct inode *inode)
> +{
> +	u64 flags;
> +
> +	if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
> +		return false;
> +
> +	flags = (u64)inode->i_private;
> +
> +	return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> +}
> +
> +
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> +{
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	struct folio *folio;
> +	vm_fault_t ret = VM_FAULT_LOCKED;
> +
> +	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +	if (IS_ERR(folio)) {
> +		int err = PTR_ERR(folio);
> +
> +		if (err == -EAGAIN)
> +			return VM_FAULT_RETRY;
> +
> +		return vmf_error(err);
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

nit: The hunk of code doesn't have to be guarded by CONFIG_KVM_GMEM_SHARED_MEM.
With the guard removed, we run into error (-ENODEV) returned by kvm_gmem_mmap()
for non-sharable (or non-mapped) file, same effect as to "kvm_gmem_fops.mmap = NULL".

I may have missed other intentions to have this guard here.

>   static struct file_operations kvm_gmem_fops = {
> +	.mmap		= kvm_gmem_mmap,
>   	.open		= generic_file_open,
>   	.release	= kvm_gmem_release,
>   	.fallocate	= kvm_gmem_fallocate,
> @@ -463,6 +537,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>   	u64 flags = args->flags;
>   	u64 valid_flags = 0;
>   
> +	if (kvm_arch_supports_gmem_shared_mem(kvm))
> +		valid_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> +
>   	if (flags & ~valid_flags)
>   		return -EINVAL;
>   
> @@ -501,6 +578,10 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>   	    offset + size > i_size_read(inode))
>   		goto err;
>   
> +	if (kvm_gmem_supports_shared(inode) &&
> +	    !kvm_arch_supports_gmem_shared_mem(kvm))
> +		goto err;
> +

This check looks unnecessary if I'm not missing anything. The file (inode) can't be created
by kvm_gmem_create(GUEST_MEMFD_FLAG_SUPPORT_SHARED) on !kvm_arch_supports_gmem_shared_mem().
It means "kvm_gmem_supports_shared(inode) == true" is indicating "kvm_arch_supports_gmem_shared_mem(kvm) == true".
In this case, we won't never break the check? :-)

>   	filemap_invalidate_lock(inode->i_mapping);
>   
>   	start = offset >> PAGE_SHIFT;

Thanks,
Gavin


