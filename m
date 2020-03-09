Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 810EC17E064
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 13:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgCIMis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 08:38:48 -0400
Received: from foss.arm.com ([217.140.110.172]:51762 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbgCIMis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 08:38:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1292930E;
        Mon,  9 Mar 2020 05:38:47 -0700 (PDT)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1A5CE3F6CF;
        Mon,  9 Mar 2020 05:38:45 -0700 (PDT)
Subject: Re: [PATCH v2 kvmtool 22/30] vfio: Destroy memslot when unmapping the
 associated VAs
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
 <20200123134805.1993-23-alexandru.elisei@arm.com>
 <20200205170129.6681e14b@donnerap.cambridge.arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <b48f3b29-38cc-3ae9-c118-9f8d9b3528f7@arm.com>
Date:   Mon, 9 Mar 2020 12:38:44 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200205170129.6681e14b@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/5/20 5:01 PM, Andre Przywara wrote:
> On Thu, 23 Jan 2020 13:47:57 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi,
>
>> When we want to map a device region into the guest address space, first
>> we perform an mmap on the device fd. The resulting VMA is a mapping
>> between host userspace addresses and physical addresses associated with
>> the device. Next, we create a memslot, which populates the stage 2 table
>> with the mappings between guest physical addresses and the device
>> physical adresses.
>>
>> However, when we want to unmap the device from the guest address space,
>> we only call munmap, which destroys the VMA and the stage 2 mappings,
>> but doesn't destroy the memslot and kvmtool's internal mem_bank
>> structure associated with the memslot.
>>
>> This has been perfectly fine so far, because we only unmap a device
>> region when we exit kvmtool. This is will change when we add support for
>> reassignable BARs, and we will have to unmap vfio regions as the guest
>> kernel writes new addresses in the BARs. This can lead to two possible
>> problems:
>>
>> - We refuse to create a valid BAR mapping because of a stale mem_bank
>>   structure which belonged to a previously unmapped region.
>>
>> - It is possible that the mmap in vfio_map_region returns the same
>>   address that was used to create a memslot, but was unmapped by
>>   vfio_unmap_region. Guest accesses to the device memory will fault
>>   because the stage 2 mappings are missing, and this can lead to
>>   performance degradation.
>>
>> Let's do the right thing and destroy the memslot and the mem_bank struct
>> associated with it when we unmap a vfio region. Set host_addr to NULL
>> after the munmap call so we won't try to unmap an address which is
>> currently used if vfio_unmap_region gets called twice.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  include/kvm/kvm.h |  2 ++
>>  kvm.c             | 65 ++++++++++++++++++++++++++++++++++++++++++++---
>>  vfio/core.c       |  6 +++++
>>  3 files changed, 69 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
>> index 50119a8672eb..c7e57b890cdd 100644
>> --- a/include/kvm/kvm.h
>> +++ b/include/kvm/kvm.h
>> @@ -56,6 +56,7 @@ struct kvm_mem_bank {
>>  	void			*host_addr;
>>  	u64			size;
>>  	enum kvm_mem_type	type;
>> +	u32			slot;
>>  };
>>  
>>  struct kvm {
>> @@ -106,6 +107,7 @@ void kvm__irq_line(struct kvm *kvm, int irq, int level);
>>  void kvm__irq_trigger(struct kvm *kvm, int irq);
>>  bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction, int size, u32 count);
>>  bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u8 is_write);
>> +int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr);
>>  int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr,
>>  		      enum kvm_mem_type type);
>>  static inline int kvm__register_ram(struct kvm *kvm, u64 guest_phys, u64 size,
>> diff --git a/kvm.c b/kvm.c
>> index 57c4ff98ec4c..afcf55c7bf45 100644
>> --- a/kvm.c
>> +++ b/kvm.c
>> @@ -183,20 +183,75 @@ int kvm__exit(struct kvm *kvm)
>>  }
>>  core_exit(kvm__exit);
>>  
>> +int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size,
>> +		     void *userspace_addr)
>> +{
>> +	struct kvm_userspace_memory_region mem;
>> +	struct kvm_mem_bank *bank;
>> +	int ret;
>> +
>> +	list_for_each_entry(bank, &kvm->mem_banks, list)
>> +		if (bank->guest_phys_addr == guest_phys &&
>> +		    bank->size == size && bank->host_addr == userspace_addr)
>> +			break;
> Shouldn't we protect the list with some lock? I am actually not sure we have this problem already, but at least now a guest could reassign BARs concurrently on different VCPUs, in which case multiple kvm__destroy_mem() and kvm__register_dev_mem() calls might race against each other.
> I think so far we got away with it because of the currently static nature of the memslot assignment.

And the fact that I haven't tested PCI passthrough with more than one device :)
I'll protect changes to the memory banks with a lock.

>
>> +
>> +	if (&bank->list == &kvm->mem_banks) {
>> +		pr_err("Region [%llx-%llx] not found", guest_phys,
>> +		       guest_phys + size - 1);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (bank->type == KVM_MEM_TYPE_RESERVED) {
>> +		pr_err("Cannot delete reserved region [%llx-%llx]",
>> +		       guest_phys, guest_phys + size - 1);
>> +		return -EINVAL;
>> +	}
>> +
>> +	mem = (struct kvm_userspace_memory_region) {
>> +		.slot			= bank->slot,
>> +		.guest_phys_addr	= guest_phys,
>> +		.memory_size		= 0,
>> +		.userspace_addr		= (unsigned long)userspace_addr,
>> +	};
>> +
>> +	ret = ioctl(kvm->vm_fd, KVM_SET_USER_MEMORY_REGION, &mem);
>> +	if (ret < 0)
>> +		return -errno;
>> +
>> +	list_del(&bank->list);
>> +	free(bank);
>> +	kvm->mem_slots--;
>> +
>> +	return 0;
>> +}
>> +
>>  int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
>>  		      void *userspace_addr, enum kvm_mem_type type)
>>  {
>>  	struct kvm_userspace_memory_region mem;
>>  	struct kvm_mem_bank *merged = NULL;
>>  	struct kvm_mem_bank *bank;
>> +	struct list_head *prev_entry;
>> +	u32 slot;
>>  	int ret;
>>  
>> -	/* Check for overlap */
>> +	/* Check for overlap and find first empty slot. */
>> +	slot = 0;
>> +	prev_entry = &kvm->mem_banks;
>>  	list_for_each_entry(bank, &kvm->mem_banks, list) {
>>  		u64 bank_end = bank->guest_phys_addr + bank->size - 1;
>>  		u64 end = guest_phys + size - 1;
>> -		if (guest_phys > bank_end || end < bank->guest_phys_addr)
>> +		if (guest_phys > bank_end || end < bank->guest_phys_addr) {
>> +			/*
>> +			 * Keep the banks sorted ascending by slot, so it's
>> +			 * easier for us to find a free slot.
>> +			 */
>> +			if (bank->slot == slot) {
>> +				slot++;
>> +				prev_entry = &bank->list;
>> +			}
>>  			continue;
>> +		}
>>  
>>  		/* Merge overlapping reserved regions */
>>  		if (bank->type == KVM_MEM_TYPE_RESERVED &&
>> @@ -241,10 +296,11 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
>>  	bank->host_addr			= userspace_addr;
>>  	bank->size			= size;
>>  	bank->type			= type;
>> +	bank->slot			= slot;
>>  
>>  	if (type != KVM_MEM_TYPE_RESERVED) {
>>  		mem = (struct kvm_userspace_memory_region) {
>> -			.slot			= kvm->mem_slots++,
>> +			.slot			= slot,
>>  			.guest_phys_addr	= guest_phys,
>>  			.memory_size		= size,
>>  			.userspace_addr		= (unsigned long)userspace_addr,
>> @@ -255,7 +311,8 @@ int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
>>  			return -errno;
>>  	}
>>  
>> -	list_add(&bank->list, &kvm->mem_banks);
>> +	list_add(&bank->list, prev_entry);
>> +	kvm->mem_slots++;
>>  
>>  	return 0;
>>  }
>> diff --git a/vfio/core.c b/vfio/core.c
>> index 0ed1e6fee6bf..73fdac8be675 100644
>> --- a/vfio/core.c
>> +++ b/vfio/core.c
>> @@ -256,8 +256,14 @@ int vfio_map_region(struct kvm *kvm, struct vfio_device *vdev,
>>  
>>  void vfio_unmap_region(struct kvm *kvm, struct vfio_region *region)
>>  {
>> +	u64 map_size;
>> +
>>  	if (region->host_addr) {
>> +		map_size = ALIGN(region->info.size, PAGE_SIZE);
>>  		munmap(region->host_addr, region->info.size);
>> +		kvm__destroy_mem(kvm, region->guest_phys_addr, map_size,
>> +				 region->host_addr);
> Shouldn't we destroy the memslot first, then unmap? Because in the current version we are giving a no longer valid userland address to the ioctl. I actually wonder how that passes the access_ok() check in the kernel's KVM_SET_USER_MEMORY_REGION handler.

Yes, you're right. From Documentation/virt/kvm/api.txt, section 4.35
KVM_SET_USER_MEMORY_REGION:

"[..] Memory for the region is taken starting at the address denoted by the field
userspace_addr, which must point at user addressable memory for the entire memory
slot size."

I'll put the munmap after the ioctl.

Thanks,
Alex
>
> Cheers,
> Andre
>
>> +		region->host_addr = NULL;
>>  	} else if (region->is_ioport) {
>>  		ioport__unregister(kvm, region->port_base);
>>  	} else {
