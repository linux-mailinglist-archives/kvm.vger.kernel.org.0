Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20512A00AA
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 13:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfH1LYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 07:24:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43280 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbfH1LYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 07:24:04 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C5FE8301E136;
        Wed, 28 Aug 2019 11:24:03 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F9A21001B0B;
        Wed, 28 Aug 2019 11:23:59 +0000 (UTC)
Date:   Wed, 28 Aug 2019 13:23:57 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 1/4] KVM: selftests: Move vm type into _vm_create()
 internally
Message-ID: <20190828112357.auyhr3de5reie6hs@kamzik.brq.redhat.com>
References: <20190827131015.21691-1-peterx@redhat.com>
 <20190827131015.21691-2-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827131015.21691-2-peterx@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 28 Aug 2019 11:24:03 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 27, 2019 at 09:10:12PM +0800, Peter Xu wrote:
> Rather than passing the vm type from the top level to the end of vm
> creation, let's simply keep that as an internal of kvm_vm struct and
> decide the type in _vm_create().  Several reasons for doing this:
> 
> - The vm type is only decided by physical address width and currently
>   only used in aarch64, so we've got enough information as long as
>   we're passing vm_guest_mode into _vm_create(),
> 
> - This removes a loop dependency between the vm->type and creation of
>   vms.  That's why now we need to parse vm_guest_mode twice sometimes,
>   once in run_test() and then again in _vm_create().  The follow up
>   patches will move on to clean up that as well so we can have a
>   single place to decide guest machine types and so.
> 
> Note that this patch will slightly change the behavior of aarch64
> tests in that previously most vm_create() callers will directly pass
> in type==0 into _vm_create() but now the type will depend on
> vm_guest_mode, however it shouldn't affect any user because all
> vm_create() users of aarch64 will be using VM_MODE_DEFAULT guest
> mode (which is VM_MODE_P40V48_4K) so at last type will still be zero.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c  | 12 +++--------
>  .../testing/selftests/kvm/include/kvm_util.h  |  2 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 20 ++++++++++++-------
>  3 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index dc3346e090f5..424efcf8c734 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -249,14 +249,13 @@ static void vm_dirty_log_verify(unsigned long *bmap)
>  }
>  
>  static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
> -				uint64_t extra_mem_pages, void *guest_code,
> -				unsigned long type)
> +				uint64_t extra_mem_pages, void *guest_code)
>  {
>  	struct kvm_vm *vm;
>  	uint64_t extra_pg_pages = extra_mem_pages / 512 * 2;
>  
>  	vm = _vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages,
> -			O_RDWR, type);
> +			O_RDWR);

nit: after removing type can O_RDWR go up a line?

>  	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
>  #ifdef __x86_64__
>  	vm_create_irqchip(vm);
> @@ -273,7 +272,6 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  	struct kvm_vm *vm;
>  	uint64_t max_gfn;
>  	unsigned long *bmap;
> -	unsigned long type = 0;
>  
>  	switch (mode) {
>  	case VM_MODE_P52V48_4K:
> @@ -314,10 +312,6 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  	 * bits we can change to 39.
>  	 */
>  	guest_pa_bits = 39;
> -#endif
> -#ifdef __aarch64__
> -	if (guest_pa_bits != 40)
> -		type = KVM_VM_TYPE_ARM_IPA_SIZE(guest_pa_bits);
>  #endif
>  	max_gfn = (1ul << (guest_pa_bits - guest_page_shift)) - 1;
>  	guest_page_size = (1ul << guest_page_shift);
> @@ -351,7 +345,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  	bmap = bitmap_alloc(host_num_pages);
>  	host_bmap_track = bitmap_alloc(host_num_pages);
>  
> -	vm = create_vm(mode, VCPU_ID, guest_num_pages, guest_code, type);
> +	vm = create_vm(mode, VCPU_ID, guest_num_pages, guest_code);
>  
>  #ifdef USE_CLEAR_DIRTY_LOG
>  	struct kvm_enable_cap cap = {};
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 5463b7896a0a..cfc079f20815 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -61,7 +61,7 @@ int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
>  
>  struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm);
>  struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
> -			  int perm, unsigned long type);
> +			  int perm);

nit: can perm go up?

>  void kvm_vm_free(struct kvm_vm *vmp);
>  void kvm_vm_restart(struct kvm_vm *vmp, int perm);
>  void kvm_vm_release(struct kvm_vm *vmp);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 6e49bb039376..0c7c4368bc14 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -84,7 +84,7 @@ int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
>  	return ret;
>  }
>  
> -static void vm_open(struct kvm_vm *vm, int perm, unsigned long type)
> +static void vm_open(struct kvm_vm *vm, int perm)
>  {
>  	vm->kvm_fd = open(KVM_DEV_PATH, perm);
>  	if (vm->kvm_fd < 0)
> @@ -95,7 +95,7 @@ static void vm_open(struct kvm_vm *vm, int perm, unsigned long type)
>  		exit(KSFT_SKIP);
>  	}
>  
> -	vm->fd = ioctl(vm->kvm_fd, KVM_CREATE_VM, type);
> +	vm->fd = ioctl(vm->kvm_fd, KVM_CREATE_VM, vm->type);
>  	TEST_ASSERT(vm->fd >= 0, "KVM_CREATE_VM ioctl failed, "
>  		"rc: %i errno: %i", vm->fd, errno);
>  }
> @@ -131,7 +131,7 @@ _Static_assert(sizeof(vm_guest_mode_string)/sizeof(char *) == NUM_VM_MODES,
>   * given by perm (e.g. O_RDWR).
>   */
>  struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
> -			  int perm, unsigned long type)
> +			  int perm)

nit: can perm go up?

>  {
>  	struct kvm_vm *vm;
>  
> @@ -139,8 +139,7 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
>  	TEST_ASSERT(vm != NULL, "Insufficient Memory");
>  
>  	vm->mode = mode;
> -	vm->type = type;
> -	vm_open(vm, perm, type);
> +	vm->type = 0;
>  
>  	/* Setup mode specific traits. */
>  	switch (vm->mode) {
> @@ -190,6 +189,13 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
>  		TEST_ASSERT(false, "Unknown guest mode, mode: 0x%x", mode);
>  	}
>  
> +#ifdef __aarch64__
> +	if (vm->pa_bits != 40)
> +		vm->type = KVM_VM_TYPE_ARM_IPA_SIZE(guest_pa_bits);
                                                    ^^
                                                    should be vm->pa_bits

> +#endif
> +
> +	vm_open(vm, perm);
> +
>  	/* Limit to VA-bit canonical virtual addresses. */
>  	vm->vpages_valid = sparsebit_alloc();
>  	sparsebit_set_num(vm->vpages_valid,
> @@ -212,7 +218,7 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
>  
>  struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
>  {
> -	return _vm_create(mode, phy_pages, perm, 0);
> +	return _vm_create(mode, phy_pages, perm);
>  }
>  
>  /*
> @@ -232,7 +238,7 @@ void kvm_vm_restart(struct kvm_vm *vmp, int perm)
>  {
>  	struct userspace_mem_region *region;
>  
> -	vm_open(vmp, perm, vmp->type);
> +	vm_open(vmp, perm);
>  	if (vmp->has_irqchip)
>  		vm_create_irqchip(vmp);
>  
> -- 
> 2.21.0
> 

Thanks,
drew
