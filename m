Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74773130CA
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 12:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbhBHL05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 06:26:57 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:12898 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233039AbhBHLXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 06:23:43 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DZ3Wk0320zjK2N;
        Mon,  8 Feb 2021 19:21:54 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Feb 2021 19:22:52 +0800
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
Subject: [RFC PATCH 0/4] KVM: arm64: Improve efficiency of stage2 page table
Date:   Mon, 8 Feb 2021 19:22:46 +0800
Message-ID: <20210208112250.163568-1-wangyanan55@huawei.com>
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
and there are some test results to present the performance changes, which
were tested by a kvm selftest [1] that I have post:
[1] https://lore.kernel.org/lkml/20210208090841.333724-1-wangyanan55@huawei.com/ 

About patch 1:
We currently uniformly clean dcache in user_mem_abort() before calling the
fault handlers, if we take a translation fault and the pfn is cacheable.
But if there are concurrent translation faults on the same page or block,
clean of dcache for the first time is necessary while the others are not.

By moving clean of dcache to the map handler, we can easily identify the
conditions where CMOs are really needed and avoid the unnecessary ones.
As it's a time consuming process to perform CMOs especially when flushing
a block range, so this solution reduces much load of kvm and improve the
efficiency of creating mappings.

Test results:
(1) when 20 vCPUs concurrently access 20G ram (all 1G hugepages):
KVM create block mappings time: 52.83s -> 3.70s
KVM recover block mappings time(after dirty-logging): 52.0s -> 2.87s

(2) when 40 vCPUs concurrently access 20G ram (all 1G hugepages):
KVM creating block mappings time: 104.56s -> 3.70s
KVM recover block mappings time(after dirty-logging): 103.93s -> 2.96s

About patch 2, 3:
When KVM needs to coalesce the normal page mappings into a block mapping,
we currently invalidate the old table entry first followed by invalidation
of TLB, then unmap the page mappings, and install the block entry at last.

It will cost a lot of time to unmap the numerous page mappings, which means
the table entry will be left invalid for a long time before installation of
the block entry, and this will cause many spurious translation faults.

So let's quickly install the block entry at first to ensure uninterrupted
memory access of the other vCPUs, and then unmap the page mappings after
installation. This will reduce most of the time when the table entry is
invalid, and avoid most of the unnecessary translation faults.

Test results based on patch 1:
(1) when 20 vCPUs concurrently access 20G ram (all 1G hugepages):
KVM recover block mappings time(after dirty-logging): 2.87s -> 0.30s

(2) when 40 vCPUs concurrently access 20G ram (all 1G hugepages):
KVM recover block mappings time(after dirty-logging): 2.96s -> 0.35s

So combined with patch 1, it makes a big difference of KVM creating mappings
and recovering block mappings with not much code change.

About patch 4:
A new method to distinguish cases of memcache allocations is introduced.
By comparing fault_granule and vma_pagesize, cases that require allocations
from memcache and cases that don't can be distinguished completely.

---

Details of test results
platform: HiSilicon Kunpeng920 (FWB not supported)
host kernel: Linux mainline (v5.11-rc6)

(1) performance change of patch 1
cmdline: ./kvm_page_table_test -m 4 -t 2 -g 1G -s 20G -v 20
	   (20 vcpus, 20G memory, block mappings(granule 1G))
Before patch: KVM_CREATE_MAPPINGS: 52.8338s 52.8327s 52.8336s 52.8255s 52.8303s
After  patch: KVM_CREATE_MAPPINGS:  3.7022s  3.7031s  3.7028s  3.7012s  3.7024s

Before patch: KVM_ADJUST_MAPPINGS: 52.0466s 52.0473s 52.0550s 52.0518s 52.0467s
After  patch: KVM_ADJUST_MAPPINGS:  2.8787s  2.8781s  2.8785s  2.8742s  2.8759s

cmdline: ./kvm_page_table_test -m 4 -t 2 -g 1G -s 20G -v 40
	   (40 vcpus, 20G memory, block mappings(granule 1G))
Before patch: KVM_CREATE_MAPPINGS: 104.560s 104.556s 104.554s 104.556s 104.550s
After  patch: KVM_CREATE_MAPPINGS:  3.7011s  3.7103s  3.7005s  3.7024s  3.7106s

Before patch: KVM_ADJUST_MAPPINGS: 103.931s 103.936s 103.927s 103.942s 103.927s
After  patch: KVM_ADJUST_MAPPINGS:  2.9621s  2.9648s  2.9474s  2.9587s  2.9603s

(2) performance change of patch 2, 3(based on patch 1)
cmdline: ./kvm_page_table_test -m 4 -t 2 -g 1G -s 20G -v 1
	   (1 vcpu, 20G memory, block mappings(granule 1G))
Before patch: KVM_ADJUST_MAPPINGS: 2.8241s 2.8234s 2.8245s 2.8230s 2.8652s
After  patch: KVM_ADJUST_MAPPINGS: 0.2444s 0.2442s 0.2423s 0.2441s 0.2429s

cmdline: ./kvm_page_table_test -m 4 -t 2 -g 1G -s 20G -v 20
	   (20 vcpus, 20G memory, block mappings(granule 1G))
Before patch: KVM_ADJUST_MAPPINGS: 2.8787s 2.8781s 2.8785s 2.8742s 2.8759s
After  patch: KVM_ADJUST_MAPPINGS: 0.3008s 0.3004s 0.2974s 0.2917s 0.2900s

cmdline: ./kvm_page_table_test -m 4 -t 2 -g 1G -s 20G -v 40
	   (40 vcpus, 20G memory, block mappings(granule 1G))
Before patch: KVM_ADJUST_MAPPINGS: 2.9621s 2.9648s 2.9474s 2.9587s 2.9603s
After  patch: KVM_ADJUST_MAPPINGS: 0.3541s 0.3694s 0.3656s 0.3693s 0.3687s

---

Yanan Wang (4):
  KVM: arm64: Move the clean of dcache to the map handler
  KVM: arm64: Add an independent API for coalescing tables
  KVM: arm64: Install the block entry before unmapping the page mappings
  KVM: arm64: Distinguish cases of memcache allocations completely

 arch/arm64/include/asm/kvm_mmu.h | 16 -------
 arch/arm64/kvm/hyp/pgtable.c     | 82 +++++++++++++++++++++-----------
 arch/arm64/kvm/mmu.c             | 39 ++++++---------
 3 files changed, 69 insertions(+), 68 deletions(-)

-- 
2.23.0

