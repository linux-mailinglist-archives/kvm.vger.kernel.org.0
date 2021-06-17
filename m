Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9C43AB1BA
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 12:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbhFQLAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 07:00:37 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:8256 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbhFQLAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 07:00:37 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G5JnK2bvcz1BNRZ;
        Thu, 17 Jun 2021 18:53:25 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 18:58:27 +0800
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 18:58:26 +0800
From:   Yanan Wang <wangyanan55@huawei.com>
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
        <zhukeqian1@huawei.com>, <yuzenghui@huawei.com>,
        Yanan Wang <wangyanan55@huawei.com>
Subject: [PATCH v7 0/4] KVM: arm64: Improve efficiency of stage2 page table
Date:   Thu, 17 Jun 2021 18:58:20 +0800
Message-ID: <20210617105824.31752-1-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,
This series makes some efficiency improvement of guest stage-2 page
table code, and there are some test results to quantify the benefit.

Description for this series:
We currently uniformly permorm CMOs of D-cache and I-cache in function
user_mem_abort before calling the fault handlers. If we get concurrent
guest faults(e.g. translation faults, permission faults) or some really
unnecessary guest faults caused by BBM, CMOs for the first vcpu are
necessary while the others later are not.

By moving CMOs to the fault handlers, we can easily identify conditions
where they are really needed and avoid the unnecessary ones. As it's a
time consuming process to perform CMOs especially when flushing a block
range, so this solution reduces much load of kvm and improve efficiency
of the stage-2 page table code.

We can imagine two specific scenarios which will gain much benefit:
1) In a normal VM startup, this solution will improve the efficiency of
handling guest page faults incurred by vCPUs, when initially populating
stage-2 page tables.
2) After live migration, the heavy workload will be resumed on the
destination VM, however all the stage-2 page tables need to be rebuilt
at the moment. So this solution will ease the performance drop during
resuming stage.

The following are test results originally from v3 [1] to represent how
much benefit was introduced by movement of CMOs. We can use KVM selftest
to simulate a scenario of concurrent guest memory access and test the
execution time that KVM uses to create new stage-2 mappings, update the
existing mappings, split/rebuild huge mappings during/after dirty logging.

hardware platform: HiSilicon Kunpeng920 Server
host kernel: Linux mainline v5.12-rc2
test tools: KVM selftest [2]
[1] https://lore.kernel.org/lkml/20210326031654.3716-1-wangyanan55@huawei.com/
[2] https://lore.kernel.org/lkml/20210302125751.19080-1-wangyanan55@huawei.com/

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

---

Changelogs:
v6->v7:
- refine the new callback names and the related comments (Marc)
- refine the patch subject and commit messages
- v6: https://lore.kernel.org/lkml/20210616095200.38008-1-wangyanan55@huawei.com/

v5->v6:
- convert the guest CMO functions into callbacks in kvm_pgtable_mm_ops (Marc)
- drop patch #6 in v5 since we are stuffing topup into mmu_lock section (Quentin)
- rebased on latest kvmarm/tree
- v5: https://lore.kernel.org/lkml/20210415115032.35760-1-wangyanan55@huawei.com/

v4->v5:
- rebased on the latest kvmarm/tree to adapt to the new stage-2 page-table code
- v4: https://lore.kernel.org/lkml/20210409033652.28316-1-wangyanan55@huawei.com

---

Yanan Wang (4):
  KVM: arm64: Introduce two cache maintenance callbacks
  KVM: arm64: Introduce mm_ops member for structure stage2_attr_data
  KVM: arm64: Tweak parameters of guest cache maintenance functions
  KVM: arm64: Move guest CMOs to the fault handlers

 arch/arm64/include/asm/kvm_mmu.h     |  9 +----
 arch/arm64/include/asm/kvm_pgtable.h | 42 ++++++++++++---------
 arch/arm64/kvm/hyp/pgtable.c         | 48 ++++++++++++++++++------
 arch/arm64/kvm/mmu.c                 | 55 +++++++++++++---------------
 4 files changed, 89 insertions(+), 65 deletions(-)

-- 
2.23.0

