Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB52E1A8415
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 18:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391248AbgDNQD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 12:03:56 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41725 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391236AbgDNQDr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 12:03:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586880225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1C0MbSheP25BH92S0Hrrm5kLw3sogvwWfQWz+qUQ1cA=;
        b=Q15QCaKAf+FYeqz/9MEUNCBPW3JSlGDaazUAgyQSO1/EuKUiNkYyp89rCcz2/RwmfmhUoi
        1q9PthukJZzjyrBV70O4pEbPRWWjrnaxzryhfzeVz3R/JPIuPGvyd1ot9TJzMvvzUbdrYo
        r3C5vOIKA4eTdyaUts8WRfEvkHcJ384=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-n7ymWc-eM-67jNGK4FThFA-1; Tue, 14 Apr 2020 12:03:42 -0400
X-MC-Unique: n7ymWc-eM-67jNGK4FThFA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27D9F13FB;
        Tue, 14 Apr 2020 16:03:41 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A3FAA1147CD;
        Tue, 14 Apr 2020 16:03:24 +0000 (UTC)
Date:   Tue, 14 Apr 2020 18:03:21 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
Subject: Re: [PATCH 02/10] KVM: selftests: Use kernel's list instead of
 homebrewed replacement
Message-ID: <20200414160321.3sq33f24fhh7r5ju@kamzik.brq.redhat.com>
References: <20200410231707.7128-1-sean.j.christopherson@intel.com>
 <20200410231707.7128-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410231707.7128-3-sean.j.christopherson@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 10, 2020 at 04:16:59PM -0700, Sean Christopherson wrote:
> Replace the KVM selftests' homebrewed linked lists for vCPUs and memory
> regions with the kernel's 'struct list_head'.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  |  1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 94 ++++++++-----------
>  .../selftests/kvm/lib/kvm_util_internal.h     |  8 +-
>  .../selftests/kvm/lib/s390x/processor.c       |  5 +-
>  4 files changed, 48 insertions(+), 60 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index a99b875f50d2..2f329e785c58 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -10,6 +10,7 @@
>  #include "test_util.h"
>  
>  #include "asm/kvm.h"
> +#include "linux/list.h"
>  #include "linux/kvm.h"
>  #include <sys/ioctl.h>
>  
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 9a783c20dd26..105ee9bc09f0 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -161,6 +161,9 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
>  	vm = calloc(1, sizeof(*vm));
>  	TEST_ASSERT(vm != NULL, "Insufficient Memory");
>  
> +	INIT_LIST_HEAD(&vm->vcpus);
> +	INIT_LIST_HEAD(&vm->userspace_mem_regions);
> +
>  	vm->mode = mode;
>  	vm->type = 0;
>  
> @@ -258,8 +261,7 @@ void kvm_vm_restart(struct kvm_vm *vmp, int perm)
>  	if (vmp->has_irqchip)
>  		vm_create_irqchip(vmp);
>  
> -	for (region = vmp->userspace_mem_region_head; region;
> -		region = region->next) {
> +	list_for_each_entry(region, &vmp->userspace_mem_regions, list) {
>  		int ret = ioctl(vmp->fd, KVM_SET_USER_MEMORY_REGION, &region->region);
>  		TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed,\n"
>  			    "  rc: %i errno: %i\n"
> @@ -319,8 +321,7 @@ userspace_mem_region_find(struct kvm_vm *vm, uint64_t start, uint64_t end)
>  {
>  	struct userspace_mem_region *region;
>  
> -	for (region = vm->userspace_mem_region_head; region;
> -		region = region->next) {
> +	list_for_each_entry(region, &vm->userspace_mem_regions, list) {
>  		uint64_t existing_start = region->region.guest_phys_addr;
>  		uint64_t existing_end = region->region.guest_phys_addr
>  			+ region->region.memory_size - 1;
> @@ -378,11 +379,11 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
>   */
>  struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
>  {
> -	struct vcpu *vcpup;
> +	struct vcpu *vcpu;
>  
> -	for (vcpup = vm->vcpu_head; vcpup; vcpup = vcpup->next) {
> -		if (vcpup->id == vcpuid)
> -			return vcpup;
> +	list_for_each_entry(vcpu, &vm->vcpus, list) {
> +		if (vcpu->id == vcpuid)
> +			return vcpu;
>  	}
>  
>  	return NULL;
> @@ -392,16 +393,15 @@ struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
>   * VM VCPU Remove
>   *
>   * Input Args:
> - *   vm - Virtual Machine
>   *   vcpu - VCPU to remove
>   *
>   * Output Args: None
>   *
>   * Return: None, TEST_ASSERT failures for all error conditions
>   *
> - * Within the VM specified by vm, removes the VCPU given by vcpuid.
> + * Removes a vCPU from a VM and frees its resources.
>   */
> -static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
> +static void vm_vcpu_rm(struct vcpu *vcpu)
>  {
>  	int ret;
>  
> @@ -412,21 +412,17 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
>  	TEST_ASSERT(ret == 0, "Close of VCPU fd failed, rc: %i "
>  		"errno: %i", ret, errno);
>  
> -	if (vcpu->next)
> -		vcpu->next->prev = vcpu->prev;
> -	if (vcpu->prev)
> -		vcpu->prev->next = vcpu->next;
> -	else
> -		vm->vcpu_head = vcpu->next;
> +	list_del(&vcpu->list);
>  	free(vcpu);
>  }
>  
>  void kvm_vm_release(struct kvm_vm *vmp)
>  {
> +	struct vcpu *vcpu, *tmp;
>  	int ret;
>  
> -	while (vmp->vcpu_head)
> -		vm_vcpu_rm(vmp, vmp->vcpu_head);
> +	list_for_each_entry_safe(vcpu, tmp, &vmp->vcpus, list)
> +		vm_vcpu_rm(vcpu);
>  
>  	ret = close(vmp->fd);
>  	TEST_ASSERT(ret == 0, "Close of vm fd failed,\n"
> @@ -442,15 +438,15 @@ void kvm_vm_release(struct kvm_vm *vmp)
>   */
>  void kvm_vm_free(struct kvm_vm *vmp)
>  {
> +	struct userspace_mem_region *region, *tmp;
>  	int ret;
>  
>  	if (vmp == NULL)
>  		return;
>  
>  	/* Free userspace_mem_regions. */
> -	while (vmp->userspace_mem_region_head) {
> -		struct userspace_mem_region *region
> -			= vmp->userspace_mem_region_head;
> +	list_for_each_entry_safe(region, tmp, &vmp->userspace_mem_regions, list) {
> +		list_del(&region->list);
>  
>  		region->region.memory_size = 0;
>  		ret = ioctl(vmp->fd, KVM_SET_USER_MEMORY_REGION,
> @@ -458,7 +454,6 @@ void kvm_vm_free(struct kvm_vm *vmp)
>  		TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed, "
>  			"rc: %i errno: %i", ret, errno);
>  
> -		vmp->userspace_mem_region_head = region->next;
>  		sparsebit_free(&region->unused_phy_pages);
>  		ret = munmap(region->mmap_start, region->mmap_size);
>  		TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i",
> @@ -611,12 +606,10 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
>  			(uint64_t) region->region.memory_size);
>  
>  	/* Confirm no region with the requested slot already exists. */
> -	for (region = vm->userspace_mem_region_head; region;
> -		region = region->next) {
> -		if (region->region.slot == slot)
> -			break;
> -	}
> -	if (region != NULL)
> +	list_for_each_entry(region, &vm->userspace_mem_regions, list) {
> +		if (region->region.slot != slot)
> +			continue;
> +
>  		TEST_FAIL("A mem region with the requested slot "
>  			"already exists.\n"
>  			"  requested slot: %u paddr: 0x%lx npages: 0x%lx\n"
> @@ -625,6 +618,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
>  			region->region.slot,
>  			(uint64_t) region->region.guest_phys_addr,
>  			(uint64_t) region->region.memory_size);
> +	}
>  
>  	/* Allocate and initialize new mem region structure. */
>  	region = calloc(1, sizeof(*region));
> @@ -685,10 +679,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
>  		guest_paddr, (uint64_t) region->region.memory_size);
>  
>  	/* Add to linked-list of memory regions. */
> -	if (vm->userspace_mem_region_head)
> -		vm->userspace_mem_region_head->prev = region;
> -	region->next = vm->userspace_mem_region_head;
> -	vm->userspace_mem_region_head = region;
> +	list_add(&region->list, &vm->userspace_mem_regions);
>  }
>  
>  /*
> @@ -711,20 +702,17 @@ memslot2region(struct kvm_vm *vm, uint32_t memslot)
>  {
>  	struct userspace_mem_region *region;
>  
> -	for (region = vm->userspace_mem_region_head; region;
> -		region = region->next) {
> +	list_for_each_entry(region, &vm->userspace_mem_regions, list) {
>  		if (region->region.slot == memslot)
> -			break;
> -	}
> -	if (region == NULL) {
> -		fprintf(stderr, "No mem region with the requested slot found,\n"
> -			"  requested slot: %u\n", memslot);
> -		fputs("---- vm dump ----\n", stderr);
> -		vm_dump(stderr, vm, 2);
> -		TEST_FAIL("Mem region not found");
> +			return region;
>  	}
>  
> -	return region;
> +	fprintf(stderr, "No mem region with the requested slot found,\n"
> +		"  requested slot: %u\n", memslot);
> +	fputs("---- vm dump ----\n", stderr);
> +	vm_dump(stderr, vm, 2);
> +	TEST_FAIL("Mem region not found");
> +	return NULL;
>  }
>  
>  /*
> @@ -862,10 +850,7 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
>  		"vcpu id: %u errno: %i", vcpuid, errno);
>  
>  	/* Add to linked-list of VCPUs. */
> -	if (vm->vcpu_head)
> -		vm->vcpu_head->prev = vcpu;
> -	vcpu->next = vm->vcpu_head;
> -	vm->vcpu_head = vcpu;
> +	list_add(&vcpu->list, &vm->vcpus);
>  }
>  
>  /*
> @@ -1058,8 +1043,8 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
>  void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
>  {
>  	struct userspace_mem_region *region;
> -	for (region = vm->userspace_mem_region_head; region;
> -	     region = region->next) {
> +
> +	list_for_each_entry(region, &vm->userspace_mem_regions, list) {
>  		if ((gpa >= region->region.guest_phys_addr)
>  			&& (gpa <= (region->region.guest_phys_addr
>  				+ region->region.memory_size - 1)))
> @@ -1091,8 +1076,8 @@ void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
>  vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva)
>  {
>  	struct userspace_mem_region *region;
> -	for (region = vm->userspace_mem_region_head; region;
> -	     region = region->next) {
> +
> +	list_for_each_entry(region, &vm->userspace_mem_regions, list) {
>  		if ((hva >= region->host_mem)
>  			&& (hva <= (region->host_mem
>  				+ region->region.memory_size - 1)))
> @@ -1519,8 +1504,7 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
>  	fprintf(stream, "%*sfd: %i\n", indent, "", vm->fd);
>  	fprintf(stream, "%*spage_size: 0x%x\n", indent, "", vm->page_size);
>  	fprintf(stream, "%*sMem Regions:\n", indent, "");
> -	for (region = vm->userspace_mem_region_head; region;
> -		region = region->next) {
> +	list_for_each_entry(region, &vm->userspace_mem_regions, list) {
>  		fprintf(stream, "%*sguest_phys: 0x%lx size: 0x%lx "
>  			"host_virt: %p\n", indent + 2, "",
>  			(uint64_t) region->region.guest_phys_addr,
> @@ -1539,7 +1523,7 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
>  		virt_dump(stream, vm, indent + 4);
>  	}
>  	fprintf(stream, "%*sVCPUs:\n", indent, "");
> -	for (vcpu = vm->vcpu_head; vcpu; vcpu = vcpu->next)
> +	list_for_each_entry(vcpu, &vm->vcpus, list)
>  		vcpu_dump(stream, vm, vcpu->id, indent + 2);
>  }
>  
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
> index ca56a0133127..2ef446520748 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
> +++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
> @@ -13,7 +13,6 @@
>  #define KVM_DEV_PATH		"/dev/kvm"
>  
>  struct userspace_mem_region {
> -	struct userspace_mem_region *next, *prev;
>  	struct kvm_userspace_memory_region region;
>  	struct sparsebit *unused_phy_pages;
>  	int fd;
> @@ -21,10 +20,11 @@ struct userspace_mem_region {
>  	void *host_mem;
>  	void *mmap_start;
>  	size_t mmap_size;
> +	struct list_head list;
>  };
>  
>  struct vcpu {
> -	struct vcpu *next, *prev;
> +	struct list_head list;
>  	uint32_t id;
>  	int fd;
>  	struct kvm_run *state;
> @@ -41,8 +41,8 @@ struct kvm_vm {
>  	unsigned int pa_bits;
>  	unsigned int va_bits;
>  	uint64_t max_gfn;
> -	struct vcpu *vcpu_head;
> -	struct userspace_mem_region *userspace_mem_region_head;
> +	struct list_head vcpus;
> +	struct list_head userspace_mem_regions;
>  	struct sparsebit *vpages_valid;
>  	struct sparsebit *vpages_mapped;
>  	bool has_irqchip;
> diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
> index 8d94961bd046..a88c5d665725 100644
> --- a/tools/testing/selftests/kvm/lib/s390x/processor.c
> +++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
> @@ -233,7 +233,10 @@ void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
>  
>  void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
>  {
> -	struct vcpu *vcpu = vm->vcpu_head;
> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> +
> +	if (!vcpu)
> +		return;
>  
>  	fprintf(stream, "%*spstate: psw: 0x%.16llx:0x%.16llx\n",
>  		indent, "", vcpu->state->psw_mask, vcpu->state->psw_addr);
> -- 
> 2.26.0
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

