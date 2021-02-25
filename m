Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D56E324B9E
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 09:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235342AbhBYH6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 02:58:30 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:2850 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233996AbhBYH62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 02:58:28 -0500
Received: from dggeme755-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4DmQ7G4vcrz13yKt;
        Thu, 25 Feb 2021 15:55:06 +0800 (CST)
Received: from [10.174.187.128] (10.174.187.128) by
 dggeme755-chm.china.huawei.com (10.3.19.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Thu, 25 Feb 2021 15:57:41 +0800
Subject: Re: [PATCH 04/15] KVM: selftests: Force stronger HVA alignment (1gb)
 for hugepages
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20210210230625.550939-1-seanjc@google.com>
 <20210210230625.550939-5-seanjc@google.com>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <9a870968-f381-3e0b-2840-62b7c2b2e032@huawei.com>
Date:   Thu, 25 Feb 2021 15:57:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210210230625.550939-5-seanjc@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme709-chm.china.huawei.com (10.1.199.105) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/2/11 7:06, Sean Christopherson wrote:
> Align the HVA for hugepage memslots to 1gb, as opposed to incorrectly
> assuming all architectures' hugepages are 512*page_size.
>
> For x86, multiplying by 512 is correct, but only for 2mb pages, e.g.
> systems that support 1gb pages will never be able to use them for mapping
> guest memory, and thus those flows will not be exercised.
>
> For arm64, powerpc, and s390 (and mips?), hardcoding the multiplier to
> 512 is either flat out wrong, or at best correct only in certain
> configurations.
>
> Hardcoding the _alignment_ to 1gb is a compromise between correctness and
> simplicity.  Due to the myriad flavors of hugepages across architectures,
> attempting to enumerate the exact hugepage size is difficult, and likely
> requires probing the kernel.
>
> But, there is no need for precision since a stronger alignment will not
> prevent creating a smaller hugepage.  For all but the most extreme cases,
> e.g. arm64's 16gb contiguous PMDs, aligning to 1gb is sufficient to allow
> KVM to back the guest with hugepages.
I have implemented a helper get_backing_src_pagesz() to get granularity 
of different
backing src types (anonymous/thp/hugetlb) which is suitable for 
different architectures.
See: 
https://lore.kernel.org/lkml/20210225055940.18748-6-wangyanan55@huawei.com/
if it looks fine for you, maybe we can use the accurate page sizes for 
GPA/HVA alignment:).

Thanks,

Yanan
> Add the new alignment in kvm_util.h so that it can be used by callers of
> vm_userspace_mem_region_add(), e.g. to also ensure GPAs are aligned.
>
> Cc: Ben Gardon <bgardon@google.com>
> Cc: Yanan Wang <wangyanan55@huawei.com>
> Cc: Andrew Jones <drjones@redhat.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Aaron Lewis <aaronlewis@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   tools/testing/selftests/kvm/include/kvm_util.h | 13 +++++++++++++
>   tools/testing/selftests/kvm/lib/kvm_util.c     |  4 +---
>   2 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 4b5d2362a68a..a7dbdf46aa51 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -68,6 +68,19 @@ enum vm_guest_mode {
>   #define MIN_PAGE_SIZE		(1U << MIN_PAGE_SHIFT)
>   #define PTES_PER_MIN_PAGE	ptes_per_page(MIN_PAGE_SIZE)
>   
> +/*
> + * KVM_UTIL_HUGEPAGE_ALIGNMENT is selftest's required alignment for both host
> + * and guest addresses when backing guest memory with hugepages.  This is not
> + * the exact size of hugepages, rather it's a size that should allow backing
> + * the guest with hugepages on all architectures.  Precisely tracking the exact
> + * sizes across all architectures is more pain than gain, e.g. x86 supports 2mb
> + * and 1gb hugepages, arm64 supports 2mb and 1gb hugepages when using 4kb pages
> + * and 512mb hugepages when using 64kb pages (ignoring contiguous TLB entries),
> + * powerpc radix supports 1gb hugepages when using 64kb pages, s390 supports 1mb
> + * hugepages, and so on and so forth.
> + */
> +#define KVM_UTIL_HUGEPAGE_ALIGNMENT	(1ULL << 30)
> +
>   #define vm_guest_mode_string(m) vm_guest_mode_string[m]
>   extern const char * const vm_guest_mode_string[];
>   
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index deaeb47b5a6d..2e497fbab6ae 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -18,7 +18,6 @@
>   #include <unistd.h>
>   #include <linux/kernel.h>
>   
> -#define KVM_UTIL_PGS_PER_HUGEPG 512
>   #define KVM_UTIL_MIN_PFN	2
>   
>   /*
> @@ -670,7 +669,6 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
>   {
>   	int ret;
>   	struct userspace_mem_region *region;
> -	size_t huge_page_size = KVM_UTIL_PGS_PER_HUGEPG * vm->page_size;
>   	size_t alignment;
>   
>   	TEST_ASSERT(vm_adjust_num_guest_pages(vm->mode, npages) == npages,
> @@ -733,7 +731,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
>   
>   	if (src_type == VM_MEM_SRC_ANONYMOUS_THP ||
>   	    src_type == VM_MEM_SRC_ANONYMOUS_HUGETLB)
> -		alignment = max(huge_page_size, alignment);
> +		alignment = max((size_t)KVM_UTIL_HUGEPAGE_ALIGNMENT, alignment);
>   	else
>   		ASSERT_EQ(src_type, VM_MEM_SRC_ANONYMOUS);
>   
