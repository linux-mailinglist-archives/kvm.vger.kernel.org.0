Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42801A8424
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 18:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391304AbgDNQFM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 12:05:12 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44889 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391294AbgDNQFI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 12:05:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586880307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hZ2ZtNnGXnyUgL1WENewzG8fdgRXTiQCFKmqoVMaPAQ=;
        b=XdzuMuJK1jKJuXP8dg8mvq22iCxURdVHENZzZF7DejPw7TBuj3x3wb64Ov6BoUbFH1svuo
        bG3WRpKvBcR0gxW4EVFgVR9JeGsLXXqSI2D87BiAy+224csztppScp0L2h6X7I3lGAcf63
        ZYjBNqDJio5+VE1O++1hTeDAQWfkP0k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-ugqth5v9OAOHZ9ntkLmB5Q-1; Tue, 14 Apr 2020 12:05:05 -0400
X-MC-Unique: ugqth5v9OAOHZ9ntkLmB5Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25EE18017F6;
        Tue, 14 Apr 2020 16:05:04 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F33DC1036D2F;
        Tue, 14 Apr 2020 16:04:41 +0000 (UTC)
Date:   Tue, 14 Apr 2020 18:04:39 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
Subject: Re: [PATCH 03/10] KVM: selftests: Add util to delete memory region
Message-ID: <20200414160439.ca52vt5jgri7jcxw@kamzik.brq.redhat.com>
References: <20200410231707.7128-1-sean.j.christopherson@intel.com>
 <20200410231707.7128-4-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410231707.7128-4-sean.j.christopherson@intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 10, 2020 at 04:17:00PM -0700, Sean Christopherson wrote:
> Add a utility to delete a memory region, it will be used by x86's
> set_memory_region_test.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  |  1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 56 +++++++++++++------
>  2 files changed, 40 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 2f329e785c58..d4c3e4d9cd92 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -114,6 +114,7 @@ int _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
>  void vm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
>  void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
>  void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
> +void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
>  void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
>  vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
>  			  uint32_t data_memslot, uint32_t pgd_memslot);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 105ee9bc09f0..ab5b7ea60f4b 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -433,34 +433,38 @@ void kvm_vm_release(struct kvm_vm *vmp)
>  		"  vmp->kvm_fd: %i rc: %i errno: %i", vmp->kvm_fd, ret, errno);
>  }
>  
> +static void __vm_mem_region_delete(struct kvm_vm *vm,
> +				   struct userspace_mem_region *region)
> +{
> +	int ret;
> +
> +	list_del(&region->list);
> +
> +	region->region.memory_size = 0;
> +	ret = ioctl(vm->fd, KVM_SET_USER_MEMORY_REGION, &region->region);
> +	TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed, "
> +		    "rc: %i errno: %i", ret, errno);
> +
> +	sparsebit_free(&region->unused_phy_pages);
> +	ret = munmap(region->mmap_start, region->mmap_size);
> +	TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
> +
> +	free(region);
> +}
> +
>  /*
>   * Destroys and frees the VM pointed to by vmp.
>   */
>  void kvm_vm_free(struct kvm_vm *vmp)
>  {
>  	struct userspace_mem_region *region, *tmp;
> -	int ret;
>  
>  	if (vmp == NULL)
>  		return;
>  
>  	/* Free userspace_mem_regions. */
> -	list_for_each_entry_safe(region, tmp, &vmp->userspace_mem_regions, list) {
> -		list_del(&region->list);
> -
> -		region->region.memory_size = 0;
> -		ret = ioctl(vmp->fd, KVM_SET_USER_MEMORY_REGION,
> -			&region->region);
> -		TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed, "
> -			"rc: %i errno: %i", ret, errno);
> -
> -		sparsebit_free(&region->unused_phy_pages);
> -		ret = munmap(region->mmap_start, region->mmap_size);
> -		TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i",
> -			    ret, errno);
> -
> -		free(region);
> -	}
> +	list_for_each_entry_safe(region, tmp, &vmp->userspace_mem_regions, list)
> +		__vm_mem_region_delete(vmp, region);
>  
>  	/* Free sparsebit arrays. */
>  	sparsebit_free(&vmp->vpages_valid);
> @@ -775,6 +779,24 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa)
>  		    ret, errno, slot, new_gpa);
>  }
>  
> +/*
> + * VM Memory Region Delete
> + *
> + * Input Args:
> + *   vm - Virtual Machine
> + *   slot - Slot of the memory region to delete
> + *
> + * Output Args: None
> + *
> + * Return: None
> + *
> + * Delete a memory region.
> + */
> +void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot)
> +{
> +	__vm_mem_region_delete(vm, memslot2region(vm, slot));
> +}
> +
>  /*
>   * VCPU mmap Size
>   *
> -- 
> 2.26.0
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

