Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1A538063C
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2019 14:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390791AbfHCMv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Aug 2019 08:51:26 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:47317 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389830AbfHCMvZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 3 Aug 2019 08:51:25 -0400
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1httVD-00081Q-QI; Sat, 03 Aug 2019 14:51:17 +0200
Date:   Sat, 3 Aug 2019 13:51:13 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Steven Price <steven.price@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] KVM: arm64: Provide a PV_TIME device to user space
Message-ID: <20190803135113.6cdf500c@why>
In-Reply-To: <20190802145017.42543-7-steven.price@arm.com>
References: <20190802145017.42543-1-steven.price@arm.com>
        <20190802145017.42543-7-steven.price@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: steven.price@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Aug 2019 15:50:14 +0100
Steven Price <steven.price@arm.com> wrote:

> Allow user space to inform the KVM host where in the physical memory
> map the paravirtualized time structures should be located.
> 
> A device is created which provides the base address of an array of
> Stolen Time (ST) structures, one for each VCPU. There must be (64 *
> total number of VCPUs) bytes of memory available at this location.
> 
> The address is given in terms of the physical address visible to
> the guest and must be 64 byte aligned. The memory should be marked as
> reserved to the guest to stop it allocating it for other purposes.

Why? You seem to be allocating the memory from the kernel, so as far as
the guest is concerned, this isn't generally usable memory.

> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/include/asm/kvm_mmu.h  |   2 +
>  arch/arm64/include/uapi/asm/kvm.h |   6 +
>  arch/arm64/kvm/Makefile           |   1 +
>  include/uapi/linux/kvm.h          |   2 +
>  virt/kvm/arm/mmu.c                |  44 +++++++
>  virt/kvm/arm/pvtime.c             | 190 ++++++++++++++++++++++++++++++
>  6 files changed, 245 insertions(+)
>  create mode 100644 virt/kvm/arm/pvtime.c
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index befe37d4bc0e..88c8a4b2836f 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -157,6 +157,8 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm);
>  void kvm_free_stage2_pgd(struct kvm *kvm);
>  int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  			  phys_addr_t pa, unsigned long size, bool writable);
> +int kvm_phys_addr_memremap(struct kvm *kvm, phys_addr_t guest_ipa,
> +			  phys_addr_t pa, unsigned long size, bool writable);
>  
>  int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run);
>  
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 9a507716ae2f..95516a4198ea 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -367,6 +367,12 @@ struct kvm_vcpu_events {
>  #define KVM_PSCI_RET_INVAL		PSCI_RET_INVALID_PARAMS
>  #define KVM_PSCI_RET_DENIED		PSCI_RET_DENIED
>  
> +/* Device Control API: PV_TIME */
> +#define KVM_DEV_ARM_PV_TIME_PADDR	0
> +#define  KVM_DEV_ARM_PV_TIME_ST		0
> +#define KVM_DEV_ARM_PV_TIME_STATE_SIZE	1
> +#define KVM_DEV_ARM_PV_TIME_STATE	2
> +
>  #endif
>  
>  #endif /* __ARM_KVM_H__ */
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 73dce4d47d47..5ffbdc39e780 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -14,6 +14,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/e
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arm.o $(KVM)/arm/mmu.o $(KVM)/arm/mmio.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hypercalls.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/pvtime.o
>  
>  kvm-$(CONFIG_KVM_ARM_HOST) += inject_fault.o regmap.o va_layout.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index a7c19540ce21..04bffafa0708 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1222,6 +1222,8 @@ enum kvm_device_type {
>  #define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
>  	KVM_DEV_TYPE_XIVE,
>  #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
> +	KVM_DEV_TYPE_ARM_PV_TIME,
> +#define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
>  	KVM_DEV_TYPE_MAX,
>  };
>  
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 38b4c910b6c3..be28a4aee451 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1368,6 +1368,50 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  	return ret;
>  }
>  
> +/**
> + * kvm_phys_addr_memremap - map a memory range to guest IPA
> + *
> + * @kvm:	The KVM pointer
> + * @guest_ipa:	The IPA at which to insert the mapping
> + * @pa:		The physical address of the memory
> + * @size:	The size of the mapping
> + */
> +int kvm_phys_addr_memremap(struct kvm *kvm, phys_addr_t guest_ipa,
> +			  phys_addr_t pa, unsigned long size, bool writable)
> +{
> +	phys_addr_t addr, end;
> +	int ret = 0;
> +	unsigned long pfn;
> +	struct kvm_mmu_memory_cache cache = { 0, };
> +
> +	end = (guest_ipa + size + PAGE_SIZE - 1) & PAGE_MASK;
> +	pfn = __phys_to_pfn(pa);
> +
> +	for (addr = guest_ipa; addr < end; addr += PAGE_SIZE) {
> +		pte_t pte = pfn_pte(pfn, PAGE_S2);
> +
> +		if (writable)
> +			pte = kvm_s2pte_mkwrite(pte);
> +
> +		ret = mmu_topup_memory_cache(&cache,
> +					     kvm_mmu_cache_min_pages(kvm),
> +					     KVM_NR_MEM_OBJS);
> +		if (ret)
> +			goto out;
> +		spin_lock(&kvm->mmu_lock);
> +		ret = stage2_set_pte(kvm, &cache, addr, &pte, 0);
> +		spin_unlock(&kvm->mmu_lock);
> +		if (ret)
> +			goto out;
> +
> +		pfn++;
> +	}
> +
> +out:
> +	mmu_free_memory_cache(&cache);
> +	return ret;
> +}

This is an exact copy of kvm_phys_addr_ioremap(), with only the memory
attributes changing. Surely we can have a shared implementation that
takes the memory attribute as a parameter.

> +
>  static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
>  {
>  	kvm_pfn_t pfn = *pfnp;
> diff --git a/virt/kvm/arm/pvtime.c b/virt/kvm/arm/pvtime.c
> new file mode 100644
> index 000000000000..9051bc07eae1
> --- /dev/null
> +++ b/virt/kvm/arm/pvtime.c
> @@ -0,0 +1,190 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2019 Arm Ltd.
> +
> +#include <linux/kvm_host.h>
> +#include <asm/kvm_mmu.h>
> +
> +/* We currently only support PV time on ARM64 */
> +#ifdef CONFIG_ARM64

And we're only compiling it on arm64, so why the #ifdef?

> +
> +#include <asm/pvclock-abi.h>
> +
> +static int max_stolen_size(void)
> +{
> +	int size = KVM_MAX_VCPUS * sizeof(struct pvclock_vcpu_stolen_time_info);

So we're always allocating enough memory for 512 CPUs? That's an
additional 32kB of contiguous memory...

> +
> +	return ALIGN(size, PAGE_SIZE);
> +}
> +
> +static int kvm_arm_pvtime_create(struct kvm_device *dev, u32 type)
> +{
> +	struct kvm_arch_pvtime *pvtime = &dev->kvm->arch.pvtime;
> +
> +	pvtime->st = alloc_pages_exact(max_stolen_size(),
> +				       GFP_KERNEL | __GFP_ZERO);
> +	if (!pvtime->st)
> +		return -ENOMEM;

Is there any chance we could use a vmalloc allocation instead? This
would lift the requirement on having physically contiguous memory.

> +
> +	return 0;
> +}
> +
> +static void kvm_arm_pvtime_destroy(struct kvm_device *dev)
> +{
> +	struct kvm_arch_pvtime *pvtime = &dev->kvm->arch.pvtime;
> +
> +	pvtime->st_base = GPA_INVALID;
> +	free_pages_exact(pvtime->st, max_stolen_size());
> +	kfree(dev);
> +}
> +
> +static int pvtime_map_pages(struct kvm *kvm, gpa_t guest_paddr,
> +			    void *kaddr, int size)
> +{
> +	return kvm_phys_addr_memremap(kvm, guest_paddr,
> +			virt_to_phys(kaddr),
> +			size, false);
> +}
> +
> +static int pvtime_save_state(struct kvm *kvm, u64 type, void __user *user)
> +{
> +	void *source;
> +	size_t size;
> +
> +	switch (type) {
> +	case KVM_DEV_ARM_PV_TIME_ST:
> +		source = kvm->arch.pvtime.st;
> +		size = sizeof(struct pvclock_vcpu_stolen_time_info) *
> +			atomic_read(&kvm->online_vcpus);
> +		break;
> +	default:
> +		return -ENXIO;
> +	}
> +
> +	if (copy_to_user(user, source, size))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +static int pvtime_restore_state(struct kvm *kvm, u64 type, void __user *user)
> +{
> +	void *dest;
> +	size_t size;
> +
> +	switch (type) {
> +	case KVM_DEV_ARM_PV_TIME_ST:
> +		dest = kvm->arch.pvtime.st;
> +		size = sizeof(struct pvclock_vcpu_stolen_time_info) *
> +			atomic_read(&kvm->online_vcpus);
> +		break;
> +	default:
> +		return -ENXIO;
> +	}
> +
> +	if (copy_from_user(dest, user, size))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static int kvm_arm_pvtime_set_attr(struct kvm_device *dev,
> +				   struct kvm_device_attr *attr)
> +{
> +	struct kvm_arch_pvtime *pvtime = &dev->kvm->arch.pvtime;
> +	u64 __user *user = (u64 __user *)attr->addr;
> +	u64 paddr;
> +	int ret;
> +
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_PV_TIME_PADDR:
> +		if (get_user(paddr, user))
> +			return -EFAULT;
> +		if (paddr & 63)
> +			return -EINVAL;

You should check whether the device fits into the IPA space for this
guest, and whether it overlaps with anything else.

> +		switch (attr->attr) {
> +		case KVM_DEV_ARM_PV_TIME_ST:
> +			if (pvtime->st_base != GPA_INVALID)
> +				return -EEXIST;
> +			ret = pvtime_map_pages(dev->kvm, paddr, pvtime->st,
> +					max_stolen_size());

Consider moving the size directly into pvtime_map_pages(), and dropping
the pvtime->st parameter. All you need is kvm and paddr.

> +			if (ret)
> +				return ret;
> +			pvtime->st_base = paddr;
> +			return 0;
> +		}
> +		break;
> +	case KVM_DEV_ARM_PV_TIME_STATE_SIZE:
> +		return -EPERM;
> +	case KVM_DEV_ARM_PV_TIME_STATE:
> +		return pvtime_restore_state(dev->kvm, attr->attr, user);
> +	}
> +	return -ENXIO;
> +}
> +
> +static int kvm_arm_pvtime_get_attr(struct kvm_device *dev,
> +				   struct kvm_device_attr *attr)
> +{
> +	u64 __user *user = (u64 __user *)attr->addr;
> +	u32 size;
> +
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_PV_TIME_PADDR:
> +		switch (attr->attr) {
> +		case KVM_DEV_ARM_PV_TIME_ST:
> +			if (put_user(dev->kvm->arch.pvtime.st_base, user))
> +				return -EFAULT;
> +			return 0;
> +		}
> +		break;
> +	case KVM_DEV_ARM_PV_TIME_STATE_SIZE:
> +		switch (attr->attr) {
> +		case KVM_DEV_ARM_PV_TIME_ST:
> +			size = sizeof(struct pvclock_vcpu_stolen_time_info);
> +			size *= atomic_read(&dev->kvm->online_vcpus);
> +			break;
> +		default:
> +			return -ENXIO;
> +		}
> +		if (put_user(size, user))
> +			return -EFAULT;
> +		return 0;
> +	case KVM_DEV_ARM_PV_TIME_STATE:
> +		return pvtime_save_state(dev->kvm, attr->attr, user);
> +	}
> +	return -ENXIO;
> +}
> +
> +static int kvm_arm_pvtime_has_attr(struct kvm_device *dev,
> +				   struct kvm_device_attr *attr)
> +{
> +	switch (attr->group) {
> +	case KVM_DEV_ARM_PV_TIME_PADDR:
> +	case KVM_DEV_ARM_PV_TIME_STATE_SIZE:
> +	case KVM_DEV_ARM_PV_TIME_STATE:
> +		switch (attr->attr) {
> +		case KVM_DEV_ARM_PV_TIME_ST:
> +			return 0;
> +		}
> +		break;
> +	}
> +	return -ENXIO;
> +}
> +
> +static const struct kvm_device_ops pvtime_ops = {
> +	"Arm PV time",
> +	.create = kvm_arm_pvtime_create,
> +	.destroy = kvm_arm_pvtime_destroy,
> +	.set_attr = kvm_arm_pvtime_set_attr,
> +	.get_attr = kvm_arm_pvtime_get_attr,
> +	.has_attr = kvm_arm_pvtime_has_attr
> +};
> +
> +static int __init kvm_pvtime_init(void)
> +{
> +	kvm_register_device_ops(&pvtime_ops, KVM_DEV_TYPE_ARM_PV_TIME);
> +
> +	return 0;
> +}
> +
> +late_initcall(kvm_pvtime_init);
> +
> +#endif

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
