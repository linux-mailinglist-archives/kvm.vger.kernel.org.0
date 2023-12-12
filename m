Return-Path: <kvm+bounces-4222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11C2680F4DB
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 18:46:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCE801F2102C
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 17:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F82D7D8B4;
	Tue, 12 Dec 2023 17:46:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1297D8AB;
	Tue, 12 Dec 2023 17:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BECC433C8;
	Tue, 12 Dec 2023 17:46:36 +0000 (UTC)
Date: Tue, 12 Dec 2023 17:46:34 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: ankita@nvidia.com
Cc: jgg@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org,
	gshan@redhat.com, linux-mm@kvack.org, lpieralisi@kernel.org,
	aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
	apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
	mochs@nvidia.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/2] kvm: arm64: set io memory s2 pte as normalnc for
 vfio pci devices
Message-ID: <ZXicemDzXm8NShs1@arm.com>
References: <20231208164709.23101-1-ankita@nvidia.com>
 <20231208164709.23101-3-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231208164709.23101-3-ankita@nvidia.com>

On Fri, Dec 08, 2023 at 10:17:09PM +0530, ankita@nvidia.com wrote:
>  arch/arm64/kvm/hyp/pgtable.c     |  3 +++
>  arch/arm64/kvm/mmu.c             | 16 +++++++++++++---
>  drivers/vfio/pci/vfio_pci_core.c |  3 ++-
>  include/linux/mm.h               |  7 +++++++
>  4 files changed, 25 insertions(+), 4 deletions(-)

It might be worth factoring out the vfio bits into a separate patch
together with a bit of documentation around this new vma flag (up to
Alex really).

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index d4835d553c61..c8696c9e7a60 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -722,6 +722,9 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
>  	kvm_pte_t attr;
>  	u32 sh = KVM_PTE_LEAF_ATTR_LO_S2_SH_IS;
>  
> +	if (device && normal_nc)
> +		return -EINVAL;

Ah, the comment Will and I made on patch 1 is handled here. Add a
WARN_ON_ONCE() and please move this hunk to the first patch, it makes
more sense there.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d14504821b79..1ce1b6d89bf9 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1381,7 +1381,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	int ret = 0;
>  	bool write_fault, writable, force_pte = false;
>  	bool exec_fault, mte_allowed;
> -	bool device = false;
> +	bool device = false, vfio_pci_device = false;

I don't think the variable here should be named vfio_pci_device, the
VM_* flag doesn't mention PCI. So just something like "vfio_allow_wc".

>  	unsigned long mmu_seq;
>  	struct kvm *kvm = vcpu->kvm;
>  	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
> @@ -1472,6 +1472,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	gfn = fault_ipa >> PAGE_SHIFT;
>  	mte_allowed = kvm_vma_mte_allowed(vma);
>  
> +	vfio_pci_device = !!(vma->vm_flags & VM_VFIO_ALLOW_WC);

Nitpick: no need for !!, you are assigning to a bool variable already.

> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1cbc990d42e0..c3f95ec7fc3a 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1863,7 +1863,8 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
>  	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
>  	 * change vm_flags within the fault handler.  Set them now.
>  	 */
> -	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
> +	vm_flags_set(vma, VM_VFIO_ALLOW_WC | VM_IO | VM_PFNMAP |
> +			VM_DONTEXPAND | VM_DONTDUMP);

Please add a comment here that write-combining is allowed to be enabled
by the arch (KVM) code but the default user mmap() will still use
pgprot_noncached().

>  	vma->vm_ops = &vfio_pci_mmap_ops;
>  
>  	return 0;
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index a422cc123a2d..8d3c4820c492 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -391,6 +391,13 @@ extern unsigned int kobjsize(const void *objp);
>  # define VM_UFFD_MINOR		VM_NONE
>  #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
>  
> +#ifdef CONFIG_64BIT
> +#define VM_VFIO_ALLOW_WC_BIT	39	/* Convey KVM to map S2 NORMAL_NC */

This comment shouldn't be in the core header file. It knows nothing
about S2 and Normal-NC, that's arm64 terminology. You can mention
something like VFIO can use this flag hint that write-combining is
allowed.

> +#define VM_VFIO_ALLOW_WC	BIT(VM_VFIO_ALLOW_WC_BIT)
> +#else
> +#define VM_VFIO_ALLOW_WC	VM_NONE
> +#endif

And I think we need to add some documentation (is there any
VFIO-specific doc) that describes what this flag actually means, what is
permitted. For example, arm64 doesn't have write-combining without
speculative fetches. So if one adds this flag to a new driver, they
should know the implications. There's also an expectation that the
actual driver (KVM guests) or maybe later DPDK can choose the safe
non-cacheable or write-combine (Linux terminology) attributes for the
BAR.

-- 
Catalin

