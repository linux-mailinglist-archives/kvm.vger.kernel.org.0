Return-Path: <kvm+bounces-48489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DEEF3ACEA5E
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:41:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0772173CAD
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 06:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBF631F4E48;
	Thu,  5 Jun 2025 06:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G9VncJ2i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D676D17
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 06:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749105689; cv=none; b=aMjko0XpjoVjuDj2tgvTND6I7fsy7x6OmzEk3KJFtZJnsqpMFgp4RIGdgaFs39MSQ2IdTa7o2e2JECKumdJPUsfaw2VgGLn2xOULSJlsOzKHqWkg+AuUXwsdUvDbcFRTlftW2KLvQfSahbudr0HxrXGBniCUjeTC1T6cVa/duHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749105689; c=relaxed/simple;
	bh=zK1idPoWfYzaAbLDlliseqTwTPgUSfgFMTOZQ5fFD4Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ejov63gdM8G30GBdgfaolc0s04xMba/NKxNx9cq2v9AjeNJSJclOefznmLbcWu5p6+wG4AZLx1igBRJ03Ft6d5VM1F+iOAOZN3NhpmwELj3T2qfx5aA3UnFFtNQxKtTj46vbPL05w46QnqdZYce1dozb0XjR6zG+IV8CtRdL708=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G9VncJ2i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749105686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IBYi22l8NE2qlwrg6wnTflQbCIyI+eUBwCzVMPoOjIs=;
	b=G9VncJ2i+ohShygfrAdPOTLzjS1e+RvpjgdPqA1heNrjy51YKBh7wenScPqp+vsALzaKgb
	HobWlSvU0Ie7PD6462eGLizJLY9IqqHor8HA4sj/bT8KGLwgtlF+zCFb35y1aXpunsLzMc
	Yv3ytsla146vTIh5FSL9fA+ofVy55AM=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-BNNSf-OvNPa5ZEys6NepxA-1; Thu, 05 Jun 2025 02:41:22 -0400
X-MC-Unique: BNNSf-OvNPa5ZEys6NepxA-1
X-Mimecast-MFC-AGG-ID: BNNSf-OvNPa5ZEys6NepxA_1749105681
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-311f4f2e6baso740927a91.0
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 23:41:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749105681; x=1749710481;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IBYi22l8NE2qlwrg6wnTflQbCIyI+eUBwCzVMPoOjIs=;
        b=xRmO7enf4M1SU8Bib938aZpyKmTSm5SOr0JAf8mniDx/BLXn7EBB1uXguaNTLgG2LJ
         1sZ9VGhAbgPjQxDmcvwVaAthKsfm0CjMTxxdLBMYvcp78iDl8xSwyuDBbxmjhFiesgST
         ldjPXTjP5mIhpAz0FPXLwStktn0zdbgn6uxMylHs5FMBHz2wzXDk7IGsijFTg8L3avfK
         a+n9y+JN+kef0Fl2TUk52NPl6FTbrF4k4L2/QZNBxoPDP7V9zsv/ZmBlI+QZIteaht5s
         wtsL3wcWw7hETlj6kxWi8GKrLJszuEIUYWTmkd9H9ukeq2cZqt/pPDLpu5YoV/pQv4be
         mYew==
X-Forwarded-Encrypted: i=1; AJvYcCU3nicBL42McdJVDI8jksTpxEADx44W+dEe3MtxfVvpWVhXtmmDYKSb1YBXyriITZGuU8g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1BlxTE6rfHfekty/Z+yt4CWMJUMf+q2sUKvLjxjbkA9hkD4KU
	fXn6JjrwJn7T81Bisq0YoXOqpMJdJnTuT6991jffu0rIXzxBVR+9GVbLG4lwMCB8ICReP5Cmpci
	RScGe3ttGRfcCwCIMuJdNGMUd0+o3eKopICIpSBFdLoW6g1BM9pNzJg==
X-Gm-Gg: ASbGncs6sc9GLJJ9kvNHFQaiPTgBp9CbdoIyf+LirpGhctiRm9edpTsdjfIlzUowJ1R
	22Yn9yPBSCXO7MkOUk6VyHqoeqkBMGXMGS75ezUvy1MPeZxG17BdK44PZT0BTaFGlMmJx6nWyv9
	5nyPQEOzDvjIJcMF1TsTqx7hJGAljWlFcPHjsJLjxgHd7pF1z7mKa70j8UGFlKh5kvahXJNvKVl
	TDhWNOB7rHF1mZzYjOiAJf2T+rKvnTyi/2laFI2VzF7zoSx9xfTCU1s0b2RZQ+ZPW4pjtnsEWa+
	QOvIsmmxihM74NrvjCFSadgM/8O9MDbGX4ottkH9RDl/0Mxgjb4=
X-Received: by 2002:a17:90b:2ec3:b0:311:f99e:7f57 with SMTP id 98e67ed59e1d1-3130cda9edfmr6668526a91.23.1749105681022;
        Wed, 04 Jun 2025 23:41:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHKDIu35gKi+SsG314jYhsqDm09mbkp1rGLceVlPWDzysTJYqePCcBoH3coIrcY1U3MQIEuag==
X-Received: by 2002:a17:90b:2ec3:b0:311:f99e:7f57 with SMTP id 98e67ed59e1d1-3130cda9edfmr6668472a91.23.1749105680483;
        Wed, 04 Jun 2025 23:41:20 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506bc8db2sm113392715ad.41.2025.06.04.23.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 23:41:19 -0700 (PDT)
Message-ID: <a3d6ff25-236b-4dfd-8a04-6df437ecb4bb@redhat.com>
Date: Thu, 5 Jun 2025 16:40:58 +1000
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
>   static struct file_operations kvm_gmem_fops = {
> +	.mmap		= kvm_gmem_mmap,
>   	.open		= generic_file_open,
>   	.release	= kvm_gmem_release,
>   	.fallocate	= kvm_gmem_fallocate,
> @@ -463,6 +537,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
>   	u64 flags = args->flags;
>   	u64 valid_flags = 0;
>   

It seems there is an uncovered corner case, which exists in current code (not directly
caused by this patch): After .mmap is hooked, the address space (inode->i_mapping) is
exposed to user space for futher requests like madvise().madvise(MADV_COLLAPSE) can
potentially collapse the pages to a huge page (folio) with the following assumptions.
It's not the expected behavior since huge page isn't supported yet.

- CONFIG_READ_ONLY_THP_FOR_FS = y
- the folios in the pagecache have been fully populated, it can be done by kvm_gmem_fallocate()
   or kvm_gmem_get_pfn().
- mmap(0x00000f0100000000, ..., MAP_FIXED_NOREPLACE) on the guest-memfd, and then do
   madvise(buf, size, MADV_COLLAPSE).

sys_madvise
   do_madvise
     madvise_do_behavior
       madvise_vma_behavior
         madvise_collapse
           thp_vma_allowable_order
             file_thp_enabled             // need to return false to bail from the path earlier at least
           hpage_collapse_scan_file
           collapse_pte_mapped_thp

The fix would be to increase inode->i_writecount using allow_write_access() in
__kvm_gmem_create() to break the check done by file_thp_enabled().

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 0cd12f94958b..fe706c9f21cf 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -502,6 +502,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
         }
  
         file->f_flags |= O_LARGEFILE;
+       allow_write_access(file);


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
>   	filemap_invalidate_lock(inode->i_mapping);
>   
>   	start = offset >> PAGE_SHIFT;

Thanks,
Gavin


