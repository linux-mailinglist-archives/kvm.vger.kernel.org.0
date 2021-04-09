Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA14E359322
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 05:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbhDIDiO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 23:38:14 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:16854 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbhDIDiL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 23:38:11 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FGkK515WQz9xgL;
        Fri,  9 Apr 2021 11:34:49 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Fri, 9 Apr 2021 11:36:54 +0800
From:   Yanan Wang <wangyanan55@huawei.com>
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "Alexandru Elisei" <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>,
        Quentin Perret <qperret@google.com>,
        <wanghaibin.wang@huawei.com>, <zhukeqian1@huawei.com>,
        <yuzenghui@huawei.com>, Yanan Wang <wangyanan55@huawei.com>
Subject: [PATCH v4 0/2] KVM: arm64: Improve efficiency of stage2 page table
Date:   Fri, 9 Apr 2021 11:36:50 +0800
Message-ID: <20210409033652.28316-1-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.128]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This series makes some efficiency improvement of stage2 page table code,
and there are some test results to quantify the benefit of each patch.

Changelogs:
v3->v4:
- perform D-cache flush if we are not mapping device memory
- rebased on top of mainline v5.12-rc6
- v3: https://lore.kernel.org/lkml/20210326031654.3716-1-wangyanan55@huawei.com/

v2->v3:
- drop patch #3 in v2
- retest v3 based on v5.12-rc2
- v2: https://lore.kernel.org/lkml/20210310094319.18760-1-wangyanan55@huawei.com/

v1->v2:
- rebased on top of mainline v5.12-rc2
- also move CMOs of I-cache to the fault handlers
- retest v2 based on v5.12-rc2
- v1: https://lore.kernel.org/lkml/20210208112250.163568-1-wangyanan55@huawei.com/

About this v4 series:
Patch #1:
We currently uniformly permorm CMOs of D-cache and I-cache in function
user_mem_abort before calling the fault handlers. If we get concurrent
guest faults(e.g. translation faults, permission faults) or some really
unnecessary guest faults caused by BBM, CMOs for the first vcpu are
necessary while the others later are not.

By moving CMOs to the fault handlers, we can easily identify conditions
where they are really needed and avoid the unnecessary ones. As it's a
time consuming process to perform CMOs especially when flushing a block
range, so this solution reduces much load of kvm and improve efficiency
of the page table code.

So let's move both clean of D-cache and invalidation of I-cache to the
map path and move only invalidation of I-cache to the permission path.
Since the original APIs for CMOs in mmu.c are only called in function
user_mem_abort, we now also move them to pgtable.c.

After this patch, in function stage2_map_walker_try_leaf (map path),
we flush D-cache if we are not mapping device memory and invalidate
I-cache if we are adding executable permission. And in the function
stage2_attr_walker (permission path), we invalidate I-cache if we are
adding executable permission. The logic is consistent with current
code in user_mem_abort (without this patch).

The following results represent the benefit of patch #1 alone, and they
were tested by [1] (kvm/selftest) that I have posted recently.
[1] https://lore.kernel.org/lkml/20210302125751.19080-1-wangyanan55@huawei.com/

When there are muitiple vcpus concurrently accessing the same memory region,
we can test the execution time of KVM creating new mappings, updating the
permissions of old mappings from RO to RW, and rebuilding the blocks after
they have been split.

hardware platform: HiSilicon Kunpeng920 Server
host kernel: Linux mainline v5.12-rc2

cmdline: ./kvm_page_table_test -m 4 -s anonymous -b 1G -v 80
           (80 vcpus, 1G memory, page mappings(normal 4K))
KVM_CREATE_MAPPINGS: before 104.35s -> after  90.42s  +13.35%
KVM_UPDATE_MAPPINGS: before  78.64s -> after  75.45s  + 4.06%

cmdline: ./kvm_page_table_test -m 4 -s anonymous_thp -b 20G -v 40
           (40 vcpus, 20G memory, block mappings(THP 2M))
KVM_CREATE_MAPPINGS: before  15.66s -> after   6.92s  +55.80%
KVM_UPDATE_MAPPINGS: before 178.80s -> after 123.35s  +31.00%
KVM_REBUILD_BLOCKS:  before 187.34s -> after 131.76s  +30.65%

cmdline: ./kvm_page_table_test -m 4 -s anonymous_hugetlb_1gb -b 20G -v 40
           (40 vcpus, 20G memory, block mappings(HUGETLB 1G))
KVM_CREATE_MAPPINGS: before 104.54s -> after   3.70s  +96.46%
KVM_UPDATE_MAPPINGS: before 174.20s -> after 115.94s  +33.44%
KVM_REBUILD_BLOCKS:  before 103.95s -> after   2.96s  +97.15%

Patch #2:
A new method to distinguish cases of memcache allocations is introduced.
By comparing fault_granule and vma_pagesize, cases that require allocations
from memcache and cases that don't can be distinguished completely.

Yanan Wang (2):
  KVM: arm64: Move CMOs from user_mem_abort to the fault handlers
  KVM: arm64: Distinguish cases of memcache allocations completely

 arch/arm64/include/asm/kvm_mmu.h | 31 ---------------
 arch/arm64/kvm/hyp/pgtable.c     | 68 +++++++++++++++++++++++++-------
 arch/arm64/kvm/mmu.c             | 48 ++++++++--------------
 3 files changed, 69 insertions(+), 78 deletions(-)

-- 
2.19.1

