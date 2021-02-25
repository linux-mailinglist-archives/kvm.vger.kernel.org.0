Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0D8324B72
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 08:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbhBYHny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 02:43:54 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:2849 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234222AbhBYHni (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 02:43:38 -0500
Received: from dggeme761-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4DmPlV3NLSz13yLv;
        Thu, 25 Feb 2021 15:37:58 +0800 (CST)
Received: from [10.174.187.128] (10.174.187.128) by
 dggeme761-chm.china.huawei.com (10.3.19.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Thu, 25 Feb 2021 15:40:33 +0800
Subject: Re: [PATCH 03/15] KVM: selftests: Align HVA for HugeTLB-backed
 memslots
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
References: <20210210230625.550939-1-seanjc@google.com>
 <20210210230625.550939-4-seanjc@google.com>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <eac3f8b1-0e5b-395f-7fd7-75409554bffc@huawei.com>
Date:   Thu, 25 Feb 2021 15:40:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210210230625.550939-4-seanjc@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme701-chm.china.huawei.com (10.1.199.97) To
 dggeme761-chm.china.huawei.com (10.3.19.107)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 2021/2/11 7:06, Sean Christopherson wrote:
> Align the HVA for HugeTLB memslots, not just THP memslots.  Add an
> assert so any future backing types are forced to assess whether or not
> they need to be aligned.
>
> Cc: Ben Gardon <bgardon@google.com>
> Cc: Yanan Wang <wangyanan55@huawei.com>
> Cc: Andrew Jones <drjones@redhat.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Aaron Lewis <aaronlewis@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   tools/testing/selftests/kvm/lib/kvm_util.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 584167c6dbc7..deaeb47b5a6d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -731,8 +731,11 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
>   	alignment = 1;
>   #endif
>   
> -	if (src_type == VM_MEM_SRC_ANONYMOUS_THP)
> +	if (src_type == VM_MEM_SRC_ANONYMOUS_THP ||
> +	    src_type == VM_MEM_SRC_ANONYMOUS_HUGETLB)
Sorry for the late reply, I just returned from vacation.
I am not sure HVA alignment is really necessary here for hugetlb pages. 
Different from hugetlb pages,
the THP pages are dynamically allocated by later madvise(), so the value 
of HVA returned from mmap()
is host page size aligned but not THP page size aligned, so we indeed 
have to perform alignment.
But hugetlb pages are pre-allocated on systems. The following test 
results also indicate that,
with MAP_HUGETLB flag, the HVA returned from mmap() is already aligned 
to the corresponding
hugetlb page size. So maybe HVAs of each hugetlb pages are aligned 
during allocation of them
or in mmap() ? If so, I think we better not do this again here, because 
the later *region->mmap_size += alignment*
will cause one more hugetlb page mapped but will not be used.

cmdline: ./kvm_page_table_test -m 4 -b 1G -s anonymous_hugetlb_1gb
some outputs:
Host  virtual  test memory offset: 0xffff40000000
Host  virtual  test memory offset: 0xffff00000000
Host  virtual  test memory offset: 0x400000000000

cmdline: ./kvm_page_table_test -m 4 -b 1G -s anonymous_hugetlb_2mb
some outputs:
Host  virtual  test memory offset: 0xffff48000000
Host  virtual  test memory offset: 0xffff65400000
Host  virtual  test memory offset: 0xffff6ba00000

cmdline: ./kvm_page_table_test -m 4 -b 1G -s anonymous_hugetlb_32mb
some outputs:
Host  virtual  test memory offset: 0xffff70000000
Host  virtual  test memory offset: 0xffff4c000000
Host  virtual  test memory offset: 0xffff72000000

cmdline: ./kvm_page_table_test -m 4 -b 1G -s anonymous_hugetlb_64kb
some outputs:
Host  virtual  test memory offset: 0xffff58230000
Host  virtual  test memory offset: 0xffff6ef00000
Host  virtual  test memory offset: 0xffff7c150000

Thanks,
Yanan
>   		alignment = max(huge_page_size, alignment);
> +	else
> +		ASSERT_EQ(src_type, VM_MEM_SRC_ANONYMOUS);
>   
>   	/* Add enough memory to align up if necessary */
>   	if (alignment > 1)
