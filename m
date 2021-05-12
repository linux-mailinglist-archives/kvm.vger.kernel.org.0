Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF9E37BD7C
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 14:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbhELM5S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 08:57:18 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2365 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbhELMz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 08:55:58 -0400
Received: from dggeml711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FgF621Fldz5vvL;
        Wed, 12 May 2021 20:51:22 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggeml711-chm.china.huawei.com (10.3.17.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 12 May 2021 20:54:44 +0800
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 12 May 2021 20:54:43 +0800
Subject: Re: [PATCH v5 0/6] KVM: arm64: Improve efficiency of stage2 page
 table
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "Quentin Perret" <qperret@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>, <wanghaibin.wang@huawei.com>,
        <zhukeqian1@huawei.com>, <yuzenghui@huawei.com>
References: <20210415115032.35760-1-wangyanan55@huawei.com>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <e0a51638-e337-edb9-3b50-4d7c02ba0426@huawei.com>
Date:   Wed, 12 May 2021 20:54:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210415115032.35760-1-wangyanan55@huawei.com>
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

A really gentle ping ...

Sincerely,
Yanan


On 2021/4/15 19:50, Yanan Wang wrote:
> Hi,
>
> This series makes some efficiency improvement of guest stage-2 page
> table code, and there are some test results to quantify the benefit.
> The code has been re-arranged based on the latest kvmarm/next tree.
>
> Descriptions:
> We currently uniformly permorm CMOs of D-cache and I-cache in function
> user_mem_abort before calling the fault handlers. If we get concurrent
> guest faults(e.g. translation faults, permission faults) or some really
> unnecessary guest faults caused by BBM, CMOs for the first vcpu are
> necessary while the others later are not.
>
> By moving CMOs to the fault handlers, we can easily identify conditions
> where they are really needed and avoid the unnecessary ones. As it's a
> time consuming process to perform CMOs especially when flushing a block
> range, so this solution reduces much load of kvm and improve efficiency
> of the stage-2 page table code.
>
> In this series, patch #1, #3, #4 make preparation for place movement
> of CMOs (adapt to the latest stage-2 page table framework). And patch
> #2, #5 move CMOs of D-cache and I-cache to the fault handlers. Patch
> #6 introduces a new way to distinguish cases of memcache allocations.
>
> The following are results in v3 to represent the benefit introduced
> by movement of CMOs, and they were tested by [1] (kvm/selftest) that
> I have posted recently.
> [1] https://lore.kernel.org/lkml/20210302125751.19080-1-wangyanan55@huawei.com/
>
> When there are muitiple vcpus concurrently accessing the same memory
> region, we can test the execution time of KVM creating new mappings,
> updating the permissions of old mappings from RO to RW, and the time
> of re-creating the blocks after they have been split.
>
> hardware platform: HiSilicon Kunpeng920 Server
> host kernel: Linux mainline v5.12-rc2
>
> cmdline: ./kvm_page_table_test -m 4 -s anonymous -b 1G -v 80
>             (80 vcpus, 1G memory, page mappings(normal 4K))
> KVM_CREATE_MAPPINGS: before 104.35s -> after  90.42s  +13.35%
> KVM_UPDATE_MAPPINGS: before  78.64s -> after  75.45s  + 4.06%
>
> cmdline: ./kvm_page_table_test -m 4 -s anonymous_thp -b 20G -v 40
>             (40 vcpus, 20G memory, block mappings(THP 2M))
> KVM_CREATE_MAPPINGS: before  15.66s -> after   6.92s  +55.80%
> KVM_UPDATE_MAPPINGS: before 178.80s -> after 123.35s  +31.00%
> KVM_REBUILD_BLOCKS:  before 187.34s -> after 131.76s  +30.65%
>
> cmdline: ./kvm_page_table_test -m 4 -s anonymous_hugetlb_1gb -b 20G -v 40
>             (40 vcpus, 20G memory, block mappings(HUGETLB 1G))
> KVM_CREATE_MAPPINGS: before 104.54s -> after   3.70s  +96.46%
> KVM_UPDATE_MAPPINGS: before 174.20s -> after 115.94s  +33.44%
> KVM_REBUILD_BLOCKS:  before 103.95s -> after   2.96s  +97.15%
>
> ---
>
> Changelogs:
> v4->v5:
> - rebased on the latest kvmarm/tree to adapt to the new stage-2 page-table code
> - v4: https://lore.kernel.org/lkml/20210409033652.28316-1-wangyanan55@huawei.com/
>
> v3->v4:
> - perform D-cache flush if we are not mapping device memory
> - rebased on top of mainline v5.12-rc6
> - v3: https://lore.kernel.org/lkml/20210326031654.3716-1-wangyanan55@huawei.com/
>
> v2->v3:
> - drop patch #3 in v2
> - retest v3 based on v5.12-rc2
> - v2: https://lore.kernel.org/lkml/20210310094319.18760-1-wangyanan55@huawei.com/
>
> v1->v2:
> - rebased on top of mainline v5.12-rc2
> - also move CMOs of I-cache to the fault handlers
> - retest v2 based on v5.12-rc2
> - v1: https://lore.kernel.org/lkml/20210208112250.163568-1-wangyanan55@huawei.com/
>
> ---
>
> Yanan Wang (6):
>    KVM: arm64: Introduce KVM_PGTABLE_S2_GUEST stage-2 flag
>    KVM: arm64: Move D-cache flush to the fault handlers
>    KVM: arm64: Add mm_ops member for structure stage2_attr_data
>    KVM: arm64: Provide invalidate_icache_range at non-VHE EL2
>    KVM: arm64: Move I-cache flush to the fault handlers
>    KVM: arm64: Distinguish cases of memcache allocations completely
>
>   arch/arm64/include/asm/kvm_mmu.h     | 31 -------------
>   arch/arm64/include/asm/kvm_pgtable.h | 38 ++++++++++------
>   arch/arm64/kvm/hyp/nvhe/cache.S      | 11 +++++
>   arch/arm64/kvm/hyp/pgtable.c         | 65 +++++++++++++++++++++++-----
>   arch/arm64/kvm/mmu.c                 | 51 ++++++++--------------
>   5 files changed, 107 insertions(+), 89 deletions(-)
>
