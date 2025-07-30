Return-Path: <kvm+bounces-53726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 78F39B15A69
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 10:21:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4F957AB669
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 08:19:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2167B256C70;
	Wed, 30 Jul 2025 08:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TptkLNIX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EBA255F2F;
	Wed, 30 Jul 2025 08:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753863656; cv=none; b=o4pKJtsw69AgJ8I8dgiFZc3hx4E4nUFYAkztlBh2N84DbRaGhZbKW7sFjVlTlYhDReC4YSbP1V/pvxT4KCM8qmEYw8TGEb+PZUDYaIKgQwYk38KHfZJRQo1jFQ2hK3YzeM20585LYP2/DQ0cUuiq9EqMMNqdqhsHbb1rwebSML4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753863656; c=relaxed/simple;
	bh=sMpVGob/1Mg4p+/qdsiXIOdlRZ53nvSriy4F/sWaKfA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aZKEshNz5IcdOb1lPVHYhbHvVnenL0LZA1noLcB17dW9RAYIh42S6W3B3V1uEXuCdcaba6bM5CrTZ2xyzeyfiRg4+7R5yiqSXThaI7TGHxzfWSQjbaTi2BZj9yaAMqfNUa3SiZcSFVwxwHdRbwyLIWNfobNJkbvyQWXZ7gvgNdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TptkLNIX; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753863653; x=1785399653;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sMpVGob/1Mg4p+/qdsiXIOdlRZ53nvSriy4F/sWaKfA=;
  b=TptkLNIXH7jpBg1/dx2GQLg3DGSHWhis2zaJfrasjo/ISah+Tc+WRGjq
   ZJ13PgYF6zOjLfqFEhdFwE7KosxojDOHPBSTlDPVOWFtXua259+VqySEX
   GEN1PSuhMHNV1NBzJGS98ud8ckeuJ8kaGACXIEn18oxVxEyvqQeS1Ykc8
   5s9j7iBvfBIKP78uk1JVThPgqjm0zFKEb6yp5mLMtIgCsMZvXGOvYlKeA
   hIKxR+KIL7KjIFbaAuNQ6mx/g+UT+qjZFkaSpu0H1YXLiVqTBQBN7lnfk
   UPW/hSqWsFwMCaEel8ViFCv4MlVRV4rrWHCt7A3NZkgO+lN8FX/VqNth9
   g==;
X-CSE-ConnectionGUID: AL4UQFVxQvqeERUTxwpkZA==
X-CSE-MsgGUID: jMFGK+BERpyDJYy5TkGpig==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="43760837"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="43760837"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 01:20:53 -0700
X-CSE-ConnectionGUID: Ek445IxjTgK8rLEtsHGYDg==
X-CSE-MsgGUID: m2qrEWuSTVaeqSuq+gdBEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="168338717"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 01:20:48 -0700
Message-ID: <42d840e5-d063-4a84-9028-e17a69fc7c91@intel.com>
Date: Wed, 30 Jul 2025 16:20:45 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 24/24] KVM: selftests: Add guest_memfd testcase to
 fault-in on !mmap()'d memory
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>,
 Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>,
 David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>,
 Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>,
 James Houghton <jthoughton@google.com>
References: <20250729225455.670324-1-seanjc@google.com>
 <20250729225455.670324-25-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250729225455.670324-25-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/2025 6:54 AM, Sean Christopherson wrote:
> Add a guest_memfd testcase to verify that a vCPU can fault-in guest_memfd
> memory that supports mmap(), but that is not currently mapped into host
> userspace and/or has a userspace address (in the memslot) that points at
> something other than the target guest_memfd range.  Mapping guest_memfd
> memory into the guest is supposed to operate completely independently from
> any userspace mappings.

Based on above, I suppose the userspace_address is not NULL but some 
other separate userspace mapped memory.

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   .../testing/selftests/kvm/guest_memfd_test.c  | 64 +++++++++++++++++++
>   1 file changed, 64 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> index 088053d5f0f5..b86bf89a71e0 100644
> --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> @@ -13,6 +13,7 @@
>   
>   #include <linux/bitmap.h>
>   #include <linux/falloc.h>
> +#include <linux/sizes.h>
>   #include <setjmp.h>
>   #include <signal.h>
>   #include <sys/mman.h>
> @@ -21,6 +22,7 @@
>   
>   #include "kvm_util.h"
>   #include "test_util.h"
> +#include "ucall_common.h"
>   
>   static void test_file_read_write(int fd)
>   {
> @@ -298,6 +300,66 @@ static void test_guest_memfd(unsigned long vm_type)
>   	kvm_vm_free(vm);
>   }
>   
> +static void guest_code(uint8_t *mem, uint64_t size)
> +{
> +	size_t i;
> +
> +	for (i = 0; i < size; i++)
> +		__GUEST_ASSERT(mem[i] == 0xaa,
> +			       "Guest expected 0xaa at offset %lu, got 0x%x", i, mem[i]);
> +
> +	memset(mem, 0xff, size);
> +	GUEST_DONE();
> +}
> +
> +static void test_guest_memfd_guest(void)
> +{
> +	/*
> +	 * Skip the first 4gb and slot0.  slot0 maps <1gb and is used to back
> +	 * the guest's code, stack, and page tables, and low memory contains
> +	 * the PCI hole and other MMIO regions that need to be avoided.
> +	 */
> +	const uint64_t gpa = SZ_4G;
> +	const int slot = 1;
> +
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	uint8_t *mem;
> +	size_t size;
> +	int fd, i;
> +
> +	if (!kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
> +		return;
> +
> +	vm = __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1, guest_code);
> +
> +	TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP),
> +		    "Default VM type should always support guest_memfd mmap()");
> +
> +	size = vm->page_size;
> +	fd = vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP);
> +	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NULL, fd, 0);
> +
> +	mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> +	TEST_ASSERT(mem != MAP_FAILED, "mmap() on guest_memfd failed");
> +	memset(mem, 0xaa, size);
> +	munmap(mem, size);
> +
> +	virt_pg_map(vm, gpa, gpa);
> +	vcpu_args_set(vcpu, 2, gpa, size);
> +	vcpu_run(vcpu);
> +
> +	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
> +
> +	mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> +	TEST_ASSERT(mem != MAP_FAILED, "mmap() on guest_memfd failed");
> +	for (i = 0; i < size; i++)
> +		TEST_ASSERT_EQ(mem[i], 0xff);
> +
> +	close(fd);
> +	kvm_vm_free(vm);
> +}
> +
>   int main(int argc, char *argv[])
>   {
>   	unsigned long vm_types, vm_type;
> @@ -314,4 +376,6 @@ int main(int argc, char *argv[])
>   
>   	for_each_set_bit(vm_type, &vm_types, BITS_PER_TYPE(vm_types))
>   		test_guest_memfd(vm_type);
> +
> +	test_guest_memfd_guest();

First glance at the name, it leads me to think about something of nested.

>   }


