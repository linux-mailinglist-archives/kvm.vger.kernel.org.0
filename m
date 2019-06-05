Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 321F2357A5
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 09:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbfFEH0d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 03:26:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54622 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbfFEH0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 03:26:33 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 889A26EF
        for <kvm@vger.kernel.org>; Wed,  5 Jun 2019 07:26:32 +0000 (UTC)
Received: from xz-x1 (dhcp-15-205.nay.redhat.com [10.66.15.205])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 70D2E61984;
        Wed,  5 Jun 2019 07:26:29 +0000 (UTC)
Date:   Wed, 5 Jun 2019 15:26:26 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, thuth@redhat.com
Subject: Re: [PATCH v2 0/4] kvm: selftests: aarch64: use struct kvm_vcpu_init
Message-ID: <20190605072626.GI15459@xz-x1>
References: <20190527143141.13883-1-drjones@redhat.com>
 <ab872d9d-acb2-09cf-3cd2-c5340bcc2387@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ab872d9d-acb2-09cf-3cd2-c5340bcc2387@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 05 Jun 2019 07:26:32 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 04, 2019 at 07:16:34PM +0200, Paolo Bonzini wrote:
> On 27/05/19 16:31, Andrew Jones wrote:
> > aarch64 vcpu setup requires a vcpu init step that takes a kvm_vcpu_init
> > struct. So far we've just hard coded that to be one that requests no
> > features and always uses KVM_ARM_TARGET_GENERIC_V8 for the target. We
> > should have used the preferred target from the beginning, so we do that
> > now, and we also provide an API to unit tests to select a target of their
> > choosing and/or cpu features.
> > 
> > Switching to the preferred target fixes running on platforms that don't
> > like KVM_ARM_TARGET_GENERIC_V8. The new API will be made use of with
> > some coming unit tests.
> 
> The following can replace patches 1 and 2 and simplify the API, so
> that aarch64 and x86_64 are more similar:
> 
> ---------------- 8< -------------------
> From: Paolo Bonzini <pbonzini@redhat.com>
> Subject: [PATCH 1/1] kvm: selftests: hide vcpu_setup in x86_64 code
> 
> This removes the processor-dependent arguments from vm_vcpu_add.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h            | 3 +--
>  tools/testing/selftests/kvm/lib/aarch64/processor.c       | 2 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c                | 9 +++------
>  tools/testing/selftests/kvm/lib/kvm_util_internal.h       | 2 --
>  tools/testing/selftests/kvm/lib/x86_64/processor.c        | 5 +++--
>  tools/testing/selftests/kvm/x86_64/evmcs_test.c           | 2 +-
>  tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c | 2 +-
>  tools/testing/selftests/kvm/x86_64/smm_test.c             | 2 +-
>  tools/testing/selftests/kvm/x86_64/state_test.c           | 2 +-
>  9 files changed, 12 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index a5a4b28f14d8..55de43a7bd54 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -88,8 +88,7 @@ int _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
>  		void *arg);
>  void vm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
>  void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
> -void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot,
> -		 int gdt_memslot);
> +void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
>  vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
>  			  uint32_t data_memslot, uint32_t pgd_memslot);
>  void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 19e667911496..16cba9480ad6 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -243,7 +243,7 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
>  	uint64_t stack_vaddr = vm_vaddr_alloc(vm, stack_size,
>  					DEFAULT_ARM64_GUEST_STACK_VADDR_MIN, 0, 0);
>  
> -	vm_vcpu_add(vm, vcpuid, 0, 0);
> +	vm_vcpu_add(vm, vcpuid);

Do we need a vcpu_setup() here?

There're functional changes below too but they seem all good but I'm
not sure about this one.  I noticed that in kvm/queue patch 4 added
this with the new function by Drew so at last it should be fine, but
it might affect bisection a bit on ARM.

>  
>  	set_reg(vm, vcpuid, ARM64_CORE_REG(sp_el1), stack_vaddr + stack_size);
>  	set_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 633b22df46a4..6634adc4052d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -764,11 +764,10 @@ static int vcpu_mmap_sz(void)
>   *
>   * Return: None
>   *
> - * Creates and adds to the VM specified by vm and virtual CPU with
> - * the ID given by vcpuid.
> + * Adds a virtual CPU to the VM specified by vm with the ID given by vcpuid.
> + * No additional VCPU setup is done.
>   */
> -void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot,
> -		 int gdt_memslot)
> +void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
>  {
>  	struct vcpu *vcpu;
>  
> @@ -802,8 +801,6 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot,
>  		vm->vcpu_head->prev = vcpu;
>  	vcpu->next = vm->vcpu_head;
>  	vm->vcpu_head = vcpu;
> -
> -	vcpu_setup(vm, vcpuid, pgd_memslot, gdt_memslot);
>  }
>  
>  /*
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
> index 4595e42c6e29..6171c92561f4 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
> +++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
> @@ -65,8 +65,6 @@ struct kvm_vm {
>  };
>  
>  struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid);
> -void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot,
> -		int gdt_memslot);
>  void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
>  void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent);
>  void sregs_dump(FILE *stream, struct kvm_sregs *sregs, uint8_t indent);
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index 21f3040d90cb..11f22c562380 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -610,7 +610,7 @@ static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
>  	kvm_seg_fill_gdt_64bit(vm, segp);
>  }
>  
> -void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_memslot)
> +static void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_memslot)
>  {
>  	struct kvm_sregs sregs;
>  
> @@ -656,7 +656,8 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
>  				     DEFAULT_GUEST_STACK_VADDR_MIN, 0, 0);
>  
>  	/* Create VCPU */
> -	vm_vcpu_add(vm, vcpuid, 0, 0);
> +	vm_vcpu_add(vm, vcpuid);
> +	vcpu_setup(vm, vcpuid, 0, 0);
>  
>  	/* Setup guest general purpose registers */
>  	vcpu_regs_get(vm, vcpuid, &regs);
> diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> index b38260e29775..dbf82658f2ef 100644
> --- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
> @@ -144,7 +144,7 @@ int main(int argc, char *argv[])
>  
>  		/* Restore state in a new VM.  */
>  		kvm_vm_restart(vm, O_RDWR);
> -		vm_vcpu_add(vm, VCPU_ID, 0, 0);
> +		vm_vcpu_add(vm, VCPU_ID);
>  		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
>  		vcpu_load_state(vm, VCPU_ID, state);
>  		run = vcpu_state(vm, VCPU_ID);
> diff --git a/tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c
> index 50e92996f918..e5d980547896 100644
> --- a/tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c
> +++ b/tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c
> @@ -34,7 +34,7 @@ void test_vcpu_creation(int first_vcpu_id, int num_vcpus)
>  		int vcpu_id = first_vcpu_id + i;
>  
>  		/* This asserts that the vCPU was created. */
> -		vm_vcpu_add(vm, vcpu_id, 0, 0);
> +		vm_vcpu_add(vm, vcpu_id);
>  	}
>  
>  	kvm_vm_free(vm);
> diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
> index 4daf520bada1..8c063646f2a0 100644
> --- a/tools/testing/selftests/kvm/x86_64/smm_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
> @@ -144,7 +144,7 @@ int main(int argc, char *argv[])
>  		state = vcpu_save_state(vm, VCPU_ID);
>  		kvm_vm_release(vm);
>  		kvm_vm_restart(vm, O_RDWR);
> -		vm_vcpu_add(vm, VCPU_ID, 0, 0);
> +		vm_vcpu_add(vm, VCPU_ID);
>  		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
>  		vcpu_load_state(vm, VCPU_ID, state);
>  		run = vcpu_state(vm, VCPU_ID);
> diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
> index 2a4121f4de01..13545df46d8b 100644
> --- a/tools/testing/selftests/kvm/x86_64/state_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/state_test.c
> @@ -177,7 +177,7 @@ int main(int argc, char *argv[])
>  
>  		/* Restore state in a new VM.  */
>  		kvm_vm_restart(vm, O_RDWR);
> -		vm_vcpu_add(vm, VCPU_ID, 0, 0);
> +		vm_vcpu_add(vm, VCPU_ID);
>  		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
>  		vcpu_load_state(vm, VCPU_ID, state);
>  		run = vcpu_state(vm, VCPU_ID);
> -- 
> 1.8.3.1
> 

Regards,

-- 
Peter Xu
