Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A45F03B1666
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 11:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhFWJFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 05:05:47 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:8313 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbhFWJFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 05:05:46 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G8xyw54PYz71gv;
        Wed, 23 Jun 2021 16:59:20 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 23 Jun 2021 17:03:27 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 23 Jun 2021 17:03:26 +0800
Subject: Re: [PATCH] KVM: selftests: Speed up set_memory_region_test
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        kernel test robot <oliver.sang@intel.com>,
        <linux-kernel@vger.kernel.org>, <wanghaibin.wang@huawei.com>
References: <20210426130121.758229-1-vkuznets@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <91a2d145-fd3c-6e8d-6478-60f62dff07fe@huawei.com>
Date:   Wed, 23 Jun 2021 17:03:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210426130121.758229-1-vkuznets@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/4/26 21:01, Vitaly Kuznetsov wrote:
> After commit 4fc096a99e01 ("KVM: Raise the maximum number of user memslots")
> set_memory_region_test may take too long, reports are that the default
> timeout value we have (120s) may not be enough even on a physical host.
> 
> Speed things up a bit by throwing away vm_userspace_mem_region_add() usage
> from test_add_max_memory_regions(), we don't really need to do the majority
> of the stuff it does for the sake of this test.
> 
> On my AMD EPYC 7401P, # time ./set_memory_region_test
> pre-patch:
>  Testing KVM_RUN with zero added memory regions
>  Allowed number of memory slots: 32764
>  Adding slots 0..32763, each memory region with 2048K size
>  Testing MOVE of in-use region, 10 loops
>  Testing DELETE of in-use region, 10 loops
> 
>  real	0m44.917s
>  user	0m7.416s
>  sys	0m34.601s
> 
> post-patch:
>  Testing KVM_RUN with zero added memory regions
>  Allowed number of memory slots: 32764
>  Adding slots 0..32763, each memory region with 2048K size
>  Testing MOVE of in-use region, 10 loops
>  Testing DELETE of in-use region, 10 loops
> 
>  real	0m20.714s
>  user	0m0.109s
>  sys	0m18.359s
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

I've seen the failure on my arm64 server, # ./set_memory_region_test

Allowed number of memory slots: 32767
Adding slots 0..32766, each memory region with 2048K size
==== Test Assertion Failure ====
   set_memory_region_test.c:391: ret == 0
   pid=42696 tid=42696 errno=22 - Invalid argument
      1	0x00000000004015a7: test_add_max_memory_regions at 
set_memory_region_test.c:389
      2	 (inlined by) main at set_memory_region_test.c:426
      3	0x0000ffffb7c63bdf: ?? ??:0
      4	0x00000000004016db: _start at :?
   KVM_SET_USER_MEMORY_REGION IOCTL failed,
   rc: -1 errno: 22 slot: 2624

> +	mem = mmap(NULL, MEM_REGION_SIZE * max_mem_slots + alignment,

The problem is that max_mem_slots is declared as uint32_t, the result
of (MEM_REGION_SIZE * max_mem_slots) is unexpectedly truncated to be
0xffe00000.

> +		   PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	TEST_ASSERT(mem != MAP_FAILED, "Failed to mmap() host");
> +	mem_aligned = (void *)(((size_t) mem + alignment - 1) & ~(alignment - 1));
> +
>  	for (slot = 0; slot < max_mem_slots; slot++) {
> -		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> -					    guest_addr, slot, mem_reg_npages,
> -					    0);
> -		guest_addr += MEM_REGION_SIZE;
> +		ret = test_memory_region_add(vm, mem_aligned +
> +					     ((uint64_t)slot * MEM_REGION_SIZE),

These unmapped VAs got caught by access_ok() checker in
__kvm_set_memory_region() as they happen to go beyond the task's
address space on arm64. Casting max_mem_slots to size_t in both
mmap() and munmap() fixes the issue for me.

Thanks,
Zenghui
