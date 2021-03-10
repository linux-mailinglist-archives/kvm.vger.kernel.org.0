Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27160333910
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 10:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhCJJoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 04:44:09 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13902 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbhCJJnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 04:43:37 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DwRtg075xzkX1n;
        Wed, 10 Mar 2021 17:42:03 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Wed, 10 Mar 2021 17:43:21 +0800
From:   Yanan Wang <wangyanan55@huawei.com>
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        "Julien Thierry" <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>,
        Quentin Perret <qperret@google.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <wanghaibin.wang@huawei.com>, <zhukeqian1@huawei.com>,
        <yuzenghui@huawei.com>, Yanan Wang <wangyanan55@huawei.com>
Subject: [RFC PATCH v2 0/3] KVM: arm64: Improve efficiency of stage2 page table
Date:   Wed, 10 Mar 2021 17:43:16 +0800
Message-ID: <20210310094319.18760-1-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.128]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
This v2 series makes some efficiency improvement of stage2 page table code,
and there are some test results to quantify the benefit of each patch.

Changelogs:
v1->v2:
- rebased on top of mainline v5.12-rc2
- also move CMOs of I-cache to the fault handlers
- merge patch 2 and patch 3 together
- retest this v2 series based on v5.12-rc2
- v1: https://lore.kernel.org/lkml/20210208112250.163568-1-wangyanan55@huawei.com/

About patch 1:
We currently uniformly perform CMOs of D-cache and I-cache in user_mem_abort()
before calling the fault handlers. If we get concurrent translation faults on
the same IPA (page or block), CMOs for the first time is necessary while the
others later are not.

By moving CMOs to the fault handlers, we can easily identify conditions where
they are really needed and avoid the unnecessary ones. As it's a time consuming
process to perform CMOs especially when flushing a block range, so this solution
reduces much load of kvm and improve efficiency of the stage2 page table code.

So let's move both clean of D-cache and invalidation of I-cache to the map path
and move only invalidation of I-cache to the permission path. Since the original
APIs for CMOs in mmu.c are only called in function user_mem_abort(), we now also
move them to pgtable.c.

The following results represent the benefit of patch 1 alone, and they were
tested by [1](kvm/selftest) that I have posted recently.
[1] https://lore.kernel.org/lkml/20210302125751.19080-1-wangyanan55@huawei.com/

When there are muitiple vcpus concurrently accessing the same memory region,
we can test the execution time of KVM creating new mappings, updating the
permissions of old mappings from RO to RW, and rebuilding the blocks after
they have been split.

hardware platform: HiSilicon Kunpeng920 Server
host kernel: Linux mainline v5.12-rc2

cmdline: ./kvm_page_table_test -m 4 -s anonymous -b 1G -v 80
           (80 vcpus, 1G memory, page mappings(normal 4K))
KVM_CREATE_MAPPINGS: before 104.63s -> after  97.30s  +7.00%
KVM_UPDATE_MAPPINGS: before  78.47s -> after  77.18s  +1.64%

cmdline: ./kvm_page_table_test -m 4 -s anonymous_thp -b 20G -v 40
	   (40 vcpus, 20G memory, block mappings(THP 2M))
KVM_CREATE_MAPPINGS: before  15.70s -> after   7.36s  +53.12%
KVM_UPDATE_MAPPINGS: before 161.00s -> after 135.03s  +16.13%
KVM_REBUILD_BLOCKS:  before 170.49s -> after 145.46s  +14.68%

cmdline: ./kvm_page_table_test -m 4 -s anonymous_hugetlb_1gb -b 20G -v 40
	   (40 vcpus, 20G memory, block mappings(HUGETLB 1G))
KVM_CREATE_MAPPINGS: before 104.55s -> after   3.69s  +96.47%
KVM_UPDATE_MAPPINGS: before 160.67s -> after 130.65s  +18.68%
KVM_REBUILD_BLOCKS:  before 103.95s -> after   2.96s  +97.15%

About patch 2:
If KVM needs to coalesce the existing normal page mappings into a block mapping,
we currently follow the following steps successively:
1) invalidate the table entry in the PMD/PUD table
2) flush TLB by VMID
3) unmap the old sub-level tables
4) install the new block entry to the PMD/PUD table

It will cost a long time to unmap the numerous old page mappings in step 3,
which means there will be a long period when the PMD/PUD table entry could be
found invalid (step 1, 2, 3). So the other vcpus have a really big chance to
trigger unnecessary translations if they access any page within the block and
find the table entry invalid.

So let's quickly install the block entry at first to ensure uninterrupted memory
access of the other vcpus, and then unmap the page mappings after installation.
This will reduce most of the time when the table entry is invalid, and avoid most
of the unnecessary translation faults.

After this patch the steps can be like:
1) invalidate the table entry in the PMD/PUD table
2) flush TLB by VMID
3) install the new block entry to the PMD/PUD table
4) unmap the old sub-level tables

As this patch only affects the rebuilding of block mappings, so we can test the
execution time of KVM rebuilding the blocks after they have been split.

hardware platform: HiSilicon Kunpeng920 Server
host kernel: Linux mainline v5.12-rc2

cmdline: ./kvm_page_table_test -m 4 -s anonymous_thp -b 20G -v 20
	   (20 vcpus, 20G memory, block mappings(THP 2M))
KVM_REBUILD_BLOCKS: before 73.64s -> after 57.75s  +21.58%

cmdline: ./kvm_page_table_test -m 4 -s anonymous_thp -b 20G -v 40
           (40 vcpus, 20G memory, block mappings(THP 2M))
KVM_REBUILD_BLOCKS: before 145.4s -> after 130.8s  +10.62%

cmdline: ./kvm_page_table_test -m 4 -s anonymous_hugetlb_1gb -b 1G -v 80
           (80 vcpus, 1G memory, block mappings(HUGETLB 1G))
KVM_REBUILD_BLOCKS: before 0.166s -> after 0.035s  +78.92%

cmdline: ./kvm_page_table_test -m 4 -s anonymous_hugetlb_1gb -b 20G -v 20
	   (20 vcpus, 20G memory, block mappings(HUGETLB 1G))
KVM_REBUILD_BLOCKS: before 2.875s -> after 0.282s  +90.20%

cmdline: ./kvm_page_table_test -m 4 -s anonymous_hugetlb_1gb -b 20G -v 40
	   (40 vcpus, 20G memory, block mappings(HUGETLB 1G))
KVM_REBUILD_BLOCKS: before 2.965s -> after 0.359s  +87.55%

About patch 3:
A new method to distinguish cases of memcache allocations is introduced.
By comparing fault_granule and vma_pagesize, cases that require allocations
from memcache and cases that don't can be distinguished completely.

---

Yanan Wang (3):
  KVM: arm64: Move CMOs from user_mem_abort to the fault handlers
  KVM: arm64: Install the block entry before unmapping the page mappings
  KVM: arm64: Distinguish cases of memcache allocations completely

 arch/arm64/include/asm/kvm_mmu.h |  31 ---------
 arch/arm64/kvm/hyp/pgtable.c     | 112 +++++++++++++++++++++++--------
 arch/arm64/kvm/mmu.c             |  48 +++++--------
 3 files changed, 99 insertions(+), 92 deletions(-)

-- 
2.19.1

