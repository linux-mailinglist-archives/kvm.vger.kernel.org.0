Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBAF3AC0A2
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 03:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbhFRByt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 21:54:49 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5030 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbhFRBys (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 21:54:48 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G5hd256cNzXh6G;
        Fri, 18 Jun 2021 09:47:34 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 09:52:38 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 09:52:37 +0800
Subject: Re: [PATCH v7 1/4] KVM: arm64: Introduce two cache maintenance
 callbacks
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
CC:     Quentin Perret <qperret@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>, <wanghaibin.wang@huawei.com>,
        <zhukeqian1@huawei.com>, <yuzenghui@huawei.com>
References: <20210617105824.31752-1-wangyanan55@huawei.com>
 <20210617105824.31752-2-wangyanan55@huawei.com>
 <20210617123837.GA24457@willie-the-truck> <87eed0d13p.wl-maz@kernel.org>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <2c1b9376-3997-aa7b-d5f3-b04da985c260@huawei.com>
Date:   Fri, 18 Jun 2021 09:52:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <87eed0d13p.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/6/17 22:20, Marc Zyngier wrote:
> On Thu, 17 Jun 2021 13:38:37 +0100,
> Will Deacon <will@kernel.org> wrote:
>> On Thu, Jun 17, 2021 at 06:58:21PM +0800, Yanan Wang wrote:
>>> To prepare for performing CMOs for guest stage-2 in the fault handlers
>>> in pgtable.c, here introduce two cache maintenance callbacks in struct
>>> kvm_pgtable_mm_ops. We also adjust the comment alignment for the
>>> existing part but make no real content change at all.
>>>
>>> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
>>> ---
>>>   arch/arm64/include/asm/kvm_pgtable.h | 42 +++++++++++++++++-----------
>>>   1 file changed, 25 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
>>> index c3674c47d48c..b6ce34aa44bb 100644
>>> --- a/arch/arm64/include/asm/kvm_pgtable.h
>>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>>> @@ -27,23 +27,29 @@ typedef u64 kvm_pte_t;
>>>   
>>>   /**
>>>    * struct kvm_pgtable_mm_ops - Memory management callbacks.
>>> - * @zalloc_page:	Allocate a single zeroed memory page. The @arg parameter
>>> - *			can be used by the walker to pass a memcache. The
>>> - *			initial refcount of the page is 1.
>>> - * @zalloc_pages_exact:	Allocate an exact number of zeroed memory pages. The
>>> - *			@size parameter is in bytes, and is rounded-up to the
>>> - *			next page boundary. The resulting allocation is
>>> - *			physically contiguous.
>>> - * @free_pages_exact:	Free an exact number of memory pages previously
>>> - *			allocated by zalloc_pages_exact.
>>> - * @get_page:		Increment the refcount on a page.
>>> - * @put_page:		Decrement the refcount on a page. When the refcount
>>> - *			reaches 0 the page is automatically freed.
>>> - * @page_count:		Return the refcount of a page.
>>> - * @phys_to_virt:	Convert a physical address into a virtual address mapped
>>> - *			in the current context.
>>> - * @virt_to_phys:	Convert a virtual address mapped in the current context
>>> - *			into a physical address.
>>> + * @zalloc_page:		Allocate a single zeroed memory page.
>>> + *				The @arg parameter can be used by the walker
>>> + *				to pass a memcache. The initial refcount of
>>> + *				the page is 1.
>>> + * @zalloc_pages_exact:		Allocate an exact number of zeroed memory pages.
>>> + *				The @size parameter is in bytes, and is rounded
>>> + *				up to the next page boundary. The resulting
>>> + *				allocation is physically contiguous.
>>> + * @free_pages_exact:		Free an exact number of memory pages previously
>>> + *				allocated by zalloc_pages_exact.
>>> + * @get_page:			Increment the refcount on a page.
>>> + * @put_page:			Decrement the refcount on a page. When the
>>> + *				refcount reaches 0 the page is automatically
>>> + *				freed.
>>> + * @page_count:			Return the refcount of a page.
>>> + * @phys_to_virt:		Convert a physical address into a virtual address
>>> + *				mapped in the current context.
>>> + * @virt_to_phys:		Convert a virtual address mapped in the current
>>> + *				context into a physical address.
>>> + * @clean_invalidate_dcache:	Clean and invalidate the data cache for the
>>> + *				specified memory address range.
>> This should probably be explicit about whether this to the PoU/PoC/PoP.
> Indeed. I can fix that locally if there is nothing else that requires
> adjusting.
Will be grateful !

Thanks,
Yanan
.
>
> 	M.
>

