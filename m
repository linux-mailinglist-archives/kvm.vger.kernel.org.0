Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D57ACA00EC
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 13:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfH1LqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 07:46:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51344 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbfH1LqU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 07:46:20 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D2E79A53264;
        Wed, 28 Aug 2019 11:46:19 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E0A26012C;
        Wed, 28 Aug 2019 11:46:15 +0000 (UTC)
Date:   Wed, 28 Aug 2019 13:46:13 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 4/4] KVM: selftests: Remove duplicate guest mode handling
Message-ID: <20190828114613.a2rvpip45c3ywdnj@kamzik.brq.redhat.com>
References: <20190827131015.21691-1-peterx@redhat.com>
 <20190827131015.21691-5-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827131015.21691-5-peterx@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Wed, 28 Aug 2019 11:46:19 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 27, 2019 at 09:10:15PM +0800, Peter Xu wrote:
> Remove the duplication code in run_test() of dirty_log_test because
> after some reordering of functions now we can directly use the outcome
> of vm_create().
> 
> Meanwhile, with the new VM_MODE_PXXV48_4K, we can safely revert
> b442324b58 too where we stick the x86_64 PA width to 39 bits for
> dirty_log_test.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  tools/testing/selftests/kvm/dirty_log_test.c  | 52 ++-----------------
>  .../testing/selftests/kvm/include/kvm_util.h  |  4 ++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 17 ++++++
>  3 files changed, 26 insertions(+), 47 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
> index b2e07a3173b2..73f679bbf082 100644
> --- a/tools/testing/selftests/kvm/dirty_log_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
> @@ -268,10 +268,8 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
>  static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  		     unsigned long interval, uint64_t phys_offset)
>  {
> -	unsigned int guest_pa_bits, guest_page_shift;
>  	pthread_t vcpu_thread;
>  	struct kvm_vm *vm;
> -	uint64_t max_gfn;
>  	unsigned long *bmap;
>  
>  	/*
> @@ -286,54 +284,13 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  		       2ul << (DIRTY_MEM_BITS - PAGE_SHIFT_4K),
>  		       guest_code);
>  
> -	switch (mode) {
> -	case VM_MODE_P52V48_4K:
> -	case VM_MODE_PXXV48_4K:
> -		guest_pa_bits = 52;
> -		guest_page_shift = 12;
> -		break;
> -	case VM_MODE_P52V48_64K:
> -		guest_pa_bits = 52;
> -		guest_page_shift = 16;
> -		break;
> -	case VM_MODE_P48V48_4K:
> -		guest_pa_bits = 48;
> -		guest_page_shift = 12;
> -		break;
> -	case VM_MODE_P48V48_64K:
> -		guest_pa_bits = 48;
> -		guest_page_shift = 16;
> -		break;
> -	case VM_MODE_P40V48_4K:
> -		guest_pa_bits = 40;
> -		guest_page_shift = 12;
> -		break;
> -	case VM_MODE_P40V48_64K:
> -		guest_pa_bits = 40;
> -		guest_page_shift = 16;
> -		break;
> -	default:
> -		TEST_ASSERT(false, "Unknown guest mode, mode: 0x%x", mode);
> -	}
> -
> -	DEBUG("Testing guest mode: %s\n", vm_guest_mode_string(mode));
> -
> -#ifdef __x86_64__
> -	/*
> -	 * FIXME
> -	 * The x86_64 kvm selftests framework currently only supports a
> -	 * single PML4 which restricts the number of physical address
> -	 * bits we can change to 39.
> -	 */
> -	guest_pa_bits = 39;
> -#endif
> -	max_gfn = (1ul << (guest_pa_bits - guest_page_shift)) - 1;
> -	guest_page_size = (1ul << guest_page_shift);
> +	guest_page_size = vm_get_page_size(vm);
>  	/*
>  	 * A little more than 1G of guest page sized pages.  Cover the
>  	 * case where the size is not aligned to 64 pages.
>  	 */
> -	guest_num_pages = (1ul << (DIRTY_MEM_BITS - guest_page_shift)) + 16;
> +	guest_num_pages = (1ul << (DIRTY_MEM_BITS -
> +				   vm_get_page_shift(vm))) + 16;
>  #ifdef __s390x__
>  	/* Round up to multiple of 1M (segment size) */
>  	guest_num_pages = (guest_num_pages + 0xff) & ~0xffUL;
> @@ -343,7 +300,8 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
>  			 !!((guest_num_pages * guest_page_size) % host_page_size);
>  
>  	if (!phys_offset) {
> -		guest_test_phys_mem = (max_gfn - guest_num_pages) * guest_page_size;
> +		guest_test_phys_mem = (vm_get_max_gfn(vm) -
> +				       guest_num_pages) * guest_page_size;
>  		guest_test_phys_mem &= ~(host_page_size - 1);
>  	} else {
>  		guest_test_phys_mem = phys_offset;
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 1c700c6b31b5..0d65fc676182 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -155,6 +155,10 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code);
>  
>  bool vm_is_unrestricted_guest(struct kvm_vm *vm);
>  
> +unsigned int vm_get_page_size(struct kvm_vm *vm);
> +unsigned int vm_get_page_shift(struct kvm_vm *vm);
> +unsigned int vm_get_max_gfn(struct kvm_vm *vm);
> +
>  struct kvm_userspace_memory_region *
>  kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
>  				 uint64_t end);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 8c6f872a8793..cf39643ff2c7 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -137,6 +137,8 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
>  {
>  	struct kvm_vm *vm;
>  
> +	DEBUG("Testing guest mode: %s\n", vm_guest_mode_string(mode));
> +
>  	vm = calloc(1, sizeof(*vm));
>  	TEST_ASSERT(vm != NULL, "Insufficient Memory");
>  
> @@ -1662,3 +1664,18 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm)
>  
>  	return val == 'Y';
>  }
> +
> +unsigned int vm_get_page_size(struct kvm_vm *vm)
> +{
> +	return vm->page_size;
> +}
> +
> +unsigned int vm_get_page_shift(struct kvm_vm *vm)
> +{
> +	return vm->page_shift;
> +}

We could get by with just one of the above two, but whatever
> +
> +unsigned int vm_get_max_gfn(struct kvm_vm *vm)
> +{
> +	return vm->max_gfn;
> +}
> -- 
> 2.21.0
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
