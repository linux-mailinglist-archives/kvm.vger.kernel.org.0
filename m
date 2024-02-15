Return-Path: <kvm+bounces-8728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECBDC855A1E
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 06:27:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E4D1B291BA
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 05:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 983E4B67D;
	Thu, 15 Feb 2024 05:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qsDnFRPP"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C3CDDC5
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 05:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707974829; cv=none; b=YtIB4MLwtRLudcE6bECy9y1yX3vNQzWTxGInOkvM7X9n6/gvj/J0Mh1FDAui5fIC1jZ63oAUDaVlYHP6+TdCOYtIAI9KKLHDLE0vCVJZvk/nhMzSVuWmp40AGQMIOwtAekrZMynDnzuYCZY7uCJqTO6wwM62r1lRRDMfAnvXzpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707974829; c=relaxed/simple;
	bh=+XV6YA2a+keFs3p1GXfq6dFbI5Lo38vYiGNe1pFdGMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WuHMZ65cR01PY+JhP05dpFjKaTrSu+OfDfq1V3FUW2aDrCFalgsgF/CPC2SKf3CwiEVxN7wM08umFs/wAX+9BSqLibT1Ky08hoKuPw7EGndDKNcu6e08JRfawmdr78iyffDntzKLIrzgESudzNprWnE6iVqSjjvmxvpUwIDkI2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qsDnFRPP; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 15 Feb 2024 14:26:50 +0900
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707974823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FvPObSsaIok6oQHL9ZBe2c4DMn5WAmkQbL3JbetFFmY=;
	b=qsDnFRPP2HA35Ho3RYm177Y5yuT1mCcE9EuUD9cIhMuCqhMSO8pDUvnUxShIrB5LYoxify
	KR6bjMPZfeU4Y3POXtUOzFXp7+vDB0kr4msJpvPlCdq5cADj8cO2ZloTH9bs2u4Q4uOnyZ
	33wVcIyqd8Kb6+IWfCgeLcTopvVoXyI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Itaru Kitayama <itaru.kitayama@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Vishal Annapurve <vannapurve@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Peter Gonda <pgonda@google.com>
Subject: Re: [PATCH v8 04/10] KVM: selftests: Add support for
 allocating/managing protected guest memory
Message-ID: <Zc2gmlr2zgK690nu@vm3>
References: <20240203000917.376631-1-seanjc@google.com>
 <20240203000917.376631-5-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240203000917.376631-5-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 02, 2024 at 04:09:10PM -0800, Sean Christopherson wrote:
> From: Peter Gonda <pgonda@google.com>
> 
> Add support for differentiating between protected (a.k.a. private, a.k.a.
> encrypted) memory and normal (a.k.a. shared) memory for VMs that support
> protected guest memory, e.g. x86's SEV.  Provide and manage a common
> bitmap for tracking whether a given physical page resides in protected
> memory, as support for protected memory isn't x86 specific, i.e. adding a
> arch hook would be a net negative now, and in the future.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vishal Annapurve <vannapurve@google.com>
> Cc: Ackerley Tng <ackerleytng@google.com>
> cc: Andrew Jones <andrew.jones@linux.dev>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Michael Roth <michael.roth@amd.com>
> Originally-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     | 25 +++++++++++++++++--
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 22 +++++++++++++---
>  2 files changed, 41 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index d9dc31af2f96..a82149305349 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -46,6 +46,7 @@ typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
>  struct userspace_mem_region {
>  	struct kvm_userspace_memory_region2 region;
>  	struct sparsebit *unused_phy_pages;
> +	struct sparsebit *protected_phy_pages;
>  	int fd;
>  	off_t offset;
>  	enum vm_mem_backing_src_type backing_src_type;
> @@ -573,6 +574,13 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>  		uint64_t guest_paddr, uint32_t slot, uint64_t npages,
>  		uint32_t flags, int guest_memfd_fd, uint64_t guest_memfd_offset);
>  
> +#ifndef vm_arch_has_protected_memory
> +static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
> +{
> +	return false;
> +}
> +#endif
> +
>  void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
>  void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
>  void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
> @@ -836,10 +844,23 @@ const char *exit_reason_str(unsigned int exit_reason);
>  
>  vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
>  			     uint32_t memslot);
> -vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
> -			      vm_paddr_t paddr_min, uint32_t memslot);
> +vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
> +				vm_paddr_t paddr_min, uint32_t memslot,
> +				bool protected);
>  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
>  
> +static inline vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
> +					    vm_paddr_t paddr_min, uint32_t memslot)
> +{
> +	/*
> +	 * By default, allocate memory as protected for VMs that support
> +	 * protected memory, as the majority of memory for such VMs is
> +	 * protected, i.e. using shared memory is effectively opt-in.
> +	 */
> +	return __vm_phy_pages_alloc(vm, num, paddr_min, memslot,
> +				    vm_arch_has_protected_memory(vm));
> +}
> +
>  /*
>   * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
>   * loads the test binary into guest memory and creates an IRQ chip (x86 only).
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index a53caf81eb87..ea677aa019ef 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -717,6 +717,7 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
>  	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
>  
>  	sparsebit_free(&region->unused_phy_pages);
> +	sparsebit_free(&region->protected_phy_pages);
>  	ret = munmap(region->mmap_start, region->mmap_size);
>  	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
>  	if (region->fd >= 0) {
> @@ -1098,6 +1099,8 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
>  	}
>  
>  	region->unused_phy_pages = sparsebit_alloc();
> +	if (vm_arch_has_protected_memory(vm))
> +		region->protected_phy_pages = sparsebit_alloc();
>  	sparsebit_set_num(region->unused_phy_pages,
>  		guest_paddr >> vm->page_shift, npages);
>  	region->region.slot = slot;
> @@ -1924,6 +1927,10 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
>  			region->host_mem);
>  		fprintf(stream, "%*sunused_phy_pages: ", indent + 2, "");
>  		sparsebit_dump(stream, region->unused_phy_pages, 0);
> +		if (region->protected_phy_pages) {
> +			fprintf(stream, "%*sprotected_phy_pages: ", indent + 2, "");
> +			sparsebit_dump(stream, region->protected_phy_pages, 0);
> +		}
>  	}
>  	fprintf(stream, "%*sMapped Virtual Pages:\n", indent, "");
>  	sparsebit_dump(stream, vm->vpages_mapped, indent + 2);
> @@ -2025,6 +2032,7 @@ const char *exit_reason_str(unsigned int exit_reason)
>   *   num - number of pages
>   *   paddr_min - Physical address minimum
>   *   memslot - Memory region to allocate page from
> + *   protected - True if the pages will be used as protected/private memory
>   *
>   * Output Args: None
>   *
> @@ -2036,8 +2044,9 @@ const char *exit_reason_str(unsigned int exit_reason)
>   * and their base address is returned. A TEST_ASSERT failure occurs if
>   * not enough pages are available at or above paddr_min.
>   */
> -vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
> -			      vm_paddr_t paddr_min, uint32_t memslot)
> +vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
> +				vm_paddr_t paddr_min, uint32_t memslot,
> +				bool protected)
>  {
>  	struct userspace_mem_region *region;
>  	sparsebit_idx_t pg, base;
> @@ -2050,8 +2059,10 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
>  		paddr_min, vm->page_size);
>  
>  	region = memslot2region(vm, memslot);
> +	TEST_ASSERT(!protected || region->protected_phy_pages,
> +		    "Region doesn't support protected memory");
> +
>  	base = pg = paddr_min >> vm->page_shift;
> -
>  	do {
>  		for (; pg < base + num; ++pg) {
>  			if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
> @@ -2070,8 +2081,11 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
>  		abort();
>  	}
>  
> -	for (pg = base; pg < base + num; ++pg)
> +	for (pg = base; pg < base + num; ++pg) {
>  		sparsebit_clear(region->unused_phy_pages, pg);
> +		if (protected)
> +			sparsebit_set(region->protected_phy_pages, pg);
> +	}
>  
>  	return base * vm->page_size;
>  }

Reviewed-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>

> -- 
> 2.43.0.594.gd9cf4e227d-goog
> 

