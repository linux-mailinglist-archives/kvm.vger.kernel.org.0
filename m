Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D193ACBD9
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 15:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbhFRNQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 09:16:26 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:11070 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhFRNQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 09:16:25 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G5zns4TKSzZgHJ;
        Fri, 18 Jun 2021 21:11:13 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 21:14:10 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 21:14:09 +0800
Subject: Re: [PATCH v7 3/4] KVM: arm64: Tweak parameters of guest cache
 maintenance functions
To:     Marc Zyngier <maz@kernel.org>, Fuad Tabba <tabba@google.com>
CC:     Will Deacon <will@kernel.org>, Quentin Perret <qperret@google.com>,
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
 <20210617105824.31752-4-wangyanan55@huawei.com>
 <87czsjcsv8.wl-maz@kernel.org>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <83887c42-4dbe-b25b-6f5f-cf1766198bdf@huawei.com>
Date:   Fri, 18 Jun 2021 21:14:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <87czsjcsv8.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggeme705-chm.china.huawei.com (10.1.199.101) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/6/18 19:30, Marc Zyngier wrote:
> On Thu, 17 Jun 2021 11:58:23 +0100,
> Yanan Wang <wangyanan55@huawei.com> wrote:
>> Adjust the parameter "kvm_pfn_t pfn" of __clean_dcache_guest_page
>> and __invalidate_icache_guest_page to "void *va", which paves the
>> way for converting these two guest CMO functions into callbacks in
>> structure kvm_pgtable_mm_ops. No functional change.
>>
>> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
>> ---
>>   arch/arm64/include/asm/kvm_mmu.h |  9 ++-------
>>   arch/arm64/kvm/mmu.c             | 28 +++++++++++++++-------------
>>   2 files changed, 17 insertions(+), 20 deletions(-)
>>
> [...]
>
>> @@ -1219,7 +1221,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
>>   	 * We've moved a page around, probably through CoW, so let's treat it
>>   	 * just like a translation fault and clean the cache to the PoC.
>>   	 */
>> -	clean_dcache_guest_page(pfn, PAGE_SIZE);
>> +	clean_dcache_guest_page(page_address(pfn_to_page(pfn), PAGE_SIZE);
> This obviously doesn't compile. I have fixed it locally, but in the
> future please make sure that patch series can be bisected correctly.
Ah, yes, I figure out what I have missed by mistake now, and this should
have never happened... Much thanks for the local fixes for this series.
Also thank Fuad for the naming reference and review.

Regards,
Yanan
.
> Thanks,
>
> 	M.
>

