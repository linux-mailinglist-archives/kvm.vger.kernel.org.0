Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C517719BDA2
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 10:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387545AbgDBIed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 04:34:33 -0400
Received: from foss.arm.com ([217.140.110.172]:39752 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387493AbgDBIec (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 04:34:32 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C611D31B;
        Thu,  2 Apr 2020 01:34:31 -0700 (PDT)
Received: from [192.168.3.111] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD1FA3F68F;
        Thu,  2 Apr 2020 01:34:30 -0700 (PDT)
Subject: Re: [PATCH v3 kvmtool 22/32] vfio: Destroy memslot when unmapping the
 associated VAs
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        sami.mujawar@arm.com, lorenzo.pieralisi@arm.com
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
 <20200326152438.6218-23-alexandru.elisei@arm.com>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Organization: ARM Ltd.
Message-ID: <2c194786-0baf-3b38-3f68-dfb7e09a93ca@arm.com>
Date:   Thu, 2 Apr 2020 09:33:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326152438.6218-23-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/03/2020 15:24, Alexandru Elisei wrote:
> When we want to map a device region into the guest address space, first we
> perform an mmap on the device fd. The resulting VMA is a mapping between
> host userspace addresses and physical addresses associated with the device.
> Next, we create a memslot, which populates the stage 2 table with the
> mappings between guest physical addresses and the device physical adresses.
> 
> However, when we want to unmap the device from the guest address space, we
> only call munmap, which destroys the VMA and the stage 2 mappings, but
> doesn't destroy the memslot and kvmtool's internal mem_bank structure
> associated with the memslot.
> 
> This has been perfectly fine so far, because we only unmap a device region
> when we exit kvmtool. This is will change when we add support for
> reassignable BARs, and we will have to unmap vfio regions as the guest
> kernel writes new addresses in the BARs. This can lead to two possible
> problems:
> 
> - We refuse to create a valid BAR mapping because of a stale mem_bank
>   structure which belonged to a previously unmapped region.
> 
> - It is possible that the mmap in vfio_map_region returns the same address
>   that was used to create a memslot, but was unmapped by vfio_unmap_region.
>   Guest accesses to the device memory will fault because the stage 2
>   mappings are missing, and this can lead to performance degradation.
> 
> Let's do the right thing and destroy the memslot and the mem_bank struct
> associated with it when we unmap a vfio region. Set host_addr to NULL after
> the munmap call so we won't try to unmap an address which is currently used
> by the process for something else if vfio_unmap_region gets called twice.
> 

Thanks for adding the locking here, looks alright now.

> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  include/kvm/kvm.h |   4 ++
>  kvm.c             | 101 ++++++++++++++++++++++++++++++++++++++++------
>  vfio/core.c       |   6 +++
>  3 files changed, 99 insertions(+), 12 deletions(-)
> 
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index 50119a8672eb..9428f57a1c0c 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -1,6 +1,7 @@
>  #ifndef KVM__KVM_H
>  #define KVM__KVM_H
>  
> +#include "kvm/mutex.h"
>  #include "kvm/kvm-arch.h"
>  #include "kvm/kvm-config.h"
>  #include "kvm/util-init.h"
> @@ -56,6 +57,7 @@ struct kvm_mem_bank {
>  	void			*host_addr;
>  	u64			size;
>  	enum kvm_mem_type	type;
> +	u32			slot;
>  };
>  
>  struct kvm {
> @@ -72,6 +74,7 @@ struct kvm {
>  	u64			ram_size;
>  	void			*ram_start;
>  	u64			ram_pagesize;
> +	struct mutex		mem_banks_lock;
>  	struct list_head	mem_banks;
>  
>  	bool			nmi_disabled;
> @@ -106,6 +109,7 @@ void kvm__irq_line(struct kvm *kvm, int irq, int level);
>  void kvm__irq_trigger(struct kvm *kvm, int irq);
>  bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction, int size, u32 count);
>  bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u8 is_write);
> +int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr);
>  int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr,
>  		      enum kvm_mem_type type);
>  static inline int kvm__register_ram(struct kvm *kvm, u64 guest_phys, u64 size,
> diff --git a/kvm.c b/kvm.c
> index 57c4ff98ec4c..26f6b9bc58a3 100644
> --- a/kvm.c
> +++ b/kvm.c
> @@ -157,6 +157,7 @@ struct kvm *kvm__new(void)
>  	if (!kvm)
>  		return ERR_PTR(-ENOMEM);
>  
> +	mutex_init(&kvm->mem_banks_lock);
>  	kvm->sys_fd = -1;
>  	kvm->vm_fd = -1;
>  
> @@ -183,20 +184,84 @@ int kvm__exit(struct kvm *kvm)
>  }
>  core_exit(kvm__exit);
>  
> +int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size,
> +		     void *userspace_addr)
> +{
> +	struct kvm_userspace_memory_region mem;
> +	struct kvm_mem_bank *bank;
> +	int ret;
> +
> +	mutex_lock(&kvm->mem_banks_lock);
> +	list_for_each_entry(bank, &kvm->mem_banks, list)
> +		if (bank->guest_phys_addr == guest_phys &&
> +		    bank->size == size && bank->host_addr == userspace_addr)
> +			break;
> +
> +	if (&bank->list == &kvm->mem_banks) {
> +		pr_err("Region [%llx-%llx] not found", guest_phys,
> +		       guest_phys + size - 1);
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (bank->type == KVM_MEM_TYPE_RESERVED) {
> +		pr_err("Cannot delete reserved region [%llx-%llx]",
> +		       guest_phys, guest_phys + size - 1);
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	mem = (struct kvm_userspace_memory_region) {
> +		.slot			= bank->slot,
> +		.guest_phys_addr	= guest_phys,
> +		.memory_size		= 0,
> +		.userspace_addr		= (unsigned long)userspace_addr,
> +	};
> +
> +	ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
> +	if (ret < 0) {
> +		ret = -errno;
> +		goto out;
> +	}
> +
> +	list_del(&bank->list);
> +	free(bank);
> +	kvm->mem_slots--;
> +	ret = 0;
> +
> +out:
> +	mutex_unlock(&kvm->mem_banks_lock);
> +	return ret;
> +}
> +
>  int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
>  		      void *userspace_addr, enum kvm_mem_type type)
>  {
>  	struct kvm_userspace_memory_region mem;
>  	struct kvm_mem_bank *merged = NULL;
>  	struct kvm_mem_bank *bank;
> +	struct list_head *prev_entry;
> +	u32 slot;
>  	int ret;
>  
> -	/* Check for overlap */
> +	mutex_lock(&kvm->mem_banks_lock);
> +	/* Check for overlap and find first empty slot. */
> +	slot = 0;
> +	prev_entry = &kvm->mem_banks;
>  	list_for_each_entry(bank, &kvm->mem_banks, list) {
>  		u64 bank_end = bank->guest_phys_addr + bank->size - 1;
>  		u64 end = guest_phys + size - 1;
> -		if (guest_phys > bank_end || end < bank->guest_phys_addr)
> +		if (guest_phys > bank_end || end < bank->guest_phys_addr) {
> +			/*
> +			 * Keep the banks sorted ascending by slot, so it's
> +			 * easier for us to find a free slot.
> +			 */
> +			if (bank->slot == slot) {
> +				slot++;
> +				prev_entry = &bank->list;
> +			}
>  			continue;
> +		}
>  
>  		/* Merge overlapping reserved regions */
>  		if (bank->type == KVM_MEM_TYPE_RESERVED &&
> @@ -226,38 +291,50 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
>  		       kvm_mem_type_to_string(bank->type), bank->guest_phys_addr,
>  		       bank->guest_phys_addr + bank->size - 1);
>  
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto out;
>  	}
>  
> -	if (merged)
> -		return 0;
> +	if (merged) {
> +		ret = 0;
> +		goto out;
> +	}
>  
>  	bank = malloc(sizeof(*bank));
> -	if (!bank)
> -		return -ENOMEM;
> +	if (!bank) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
>  
>  	INIT_LIST_HEAD(&bank->list);
>  	bank->guest_phys_addr		= guest_phys;
>  	bank->host_addr			= userspace_addr;
>  	bank->size			= size;
>  	bank->type			= type;
> +	bank->slot			= slot;
>  
>  	if (type != KVM_MEM_TYPE_RESERVED) {
>  		mem = (struct kvm_userspace_memory_region) {
> -			.slot			= kvm->mem_slots++,
> +			.slot			= slot,
>  			.guest_phys_addr	= guest_phys,
>  			.memory_size		= size,
>  			.userspace_addr		= (unsigned long)userspace_addr,
>  		};
>  
>  		ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
> -		if (ret < 0)
> -			return -errno;
> +		if (ret < 0) {
> +			ret = -errno;
> +			goto out;
> +		}
>  	}
>  
> -	list_add(&bank->list, &kvm->mem_banks);
> +	list_add(&bank->list, prev_entry);
> +	kvm->mem_slots++;
> +	ret = 0;
>  
> -	return 0;
> +out:
> +	mutex_unlock(&kvm->mem_banks_lock);
> +	return ret;
>  }
>  
>  void *guest_flat_to_host(struct kvm *kvm, u64 offset)
> diff --git a/vfio/core.c b/vfio/core.c
> index 0ed1e6fee6bf..b80ebf3bb913 100644
> --- a/vfio/core.c
> +++ b/vfio/core.c
> @@ -256,8 +256,14 @@ int vfio_map_region(struct kvm *kvm, struct vfio_device *vdev,
>  
>  void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region)
>  {
> +	u64 map_size;
> +
>  	if (region->host_addr) {
> +		map_size = ALIGN(region->info.size, PAGE_SIZE);
> +		kvm__destroy_mem(kvm, region->guest_phys_addr, map_size,
> +				 region->host_addr);
>  		munmap(region->host_addr, region->info.size);
> +		region->host_addr = NULL;
>  	} else if (region->is_ioport) {
>  		ioport__unregister(kvm, region->port_base);
>  	} else {
> 

