Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C69212573
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 15:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgGBN5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 09:57:17 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7354 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729263AbgGBN5K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 09:57:10 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 913E96BE24CEBCEA50BE;
        Thu,  2 Jul 2020 21:56:10 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Thu, 2 Jul 2020 21:56:00 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Steven Price <steven.price@arm.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <liangpeng10@huawei.com>, <zhengxiang9@huawei.com>,
        <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH v2 0/8] KVM: arm64: Support HW dirty log based on DBM
Date:   Thu, 2 Jul 2020 21:55:48 +0800
Message-ID: <20200702135556.36896-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series add support for dirty log based on HW DBM.

It works well under some migration test cases, including VM with 4K
pages or 2M THP. I checked the SHA256 hash digest of all memory and
they keep same for source VM and destination VM, which means no dirty
pages is missed under hardware DBM.

Some key points:

1. Only support hardware updates of dirty status for PTEs. PMDs and PUDs
   are not involved for now.

2. About *performance*: In RFC patch, I have mentioned that for every 64GB
   memory, KVM consumes about 40ms to scan all PTEs to collect dirty log.
   This patch solves this problem through two ways: HW/SW dynamic switch
   and Multi-core offload.

   HW/SW dynamic switch: Give userspace right to enable/disable hw dirty
   log. This adds a new KVM cap named KVM_CAP_ARM_HW_DIRTY_LOG. We can
   achieve this by change the kvm->arch.vtcr value and kick vCPUs out to
   reload this value to VCTR_EL2. Then userspace can enable hw dirty log
   at the begining and disable it when dirty pages is little and about to
   stop VM, so VM downtime is not affected.

   Multi-core offload: Offload the PT scanning workload to multi-core can
   greatly reduce scanning time. To promise we can complete in time, I use
   smp_call_fuction to realize this policy, which utilize IPI to dispatch
   workload to other CPUs. Under 128U Kunpeng 920 platform, it just takes
   about 5ms to scan PTs of 256 RAM (use mempress and almost all PTs have
   been established). And We dispatch workload iterately (every CPU just
   scan PTs of 512M RAM for each iteration), so it won't affect physical
   CPUs seriously.

3. About correctness: Only add DBM bit when PTE is already writable, so
   we still have readonly PTE and some mechanisms which rely on readonly
   PTs are not broken.

4. About PTs modification races: There are two kinds of PTs modification.
   
   The first is adding or clearing specific bit, such as AF or RW. All
   these operations have been converted to be atomic, avoid covering
   dirty status set by hardware.
   
   The second is replacement, such as PTEs unmapping or changement. All
   these operations will invoke kvm_set_pte finally. kvm_set_pte have
   been converted to be atomic and we save the dirty status to underlying
   bitmap if dirty status is coverred.

Change log:

v2:
 - Address Steven's comments.
 - Add support of parallel dirty log sync.
 - Simplify and merge patches of v1.

v1:
 - Address Catalin's comments.

Keqian Zhu (8):
  KVM: arm64: Set DBM bit for writable PTEs
  KVM: arm64: Scan PTEs to sync dirty log
  KVM: arm64: Modify stage2 young mechanism to support hw DBM
  KVM: arm64: Save stage2 PTE dirty status if it is covered
  KVM: arm64: Steply write protect page table by mask bit
  KVM: arm64: Add KVM_CAP_ARM_HW_DIRTY_LOG capability
  KVM: arm64: Sync dirty log parallel
  KVM: Omit dirty log sync in log clear if initially all set

 arch/arm64/include/asm/kvm_host.h |   5 +
 arch/arm64/include/asm/kvm_mmu.h  |  43 ++++-
 arch/arm64/kvm/arm.c              |  45 ++++-
 arch/arm64/kvm/mmu.c              | 307 ++++++++++++++++++++++++++++--
 arch/arm64/kvm/reset.c            |   5 +
 include/uapi/linux/kvm.h          |   1 +
 tools/include/uapi/linux/kvm.h    |   1 +
 virt/kvm/kvm_main.c               |   3 +-
 8 files changed, 389 insertions(+), 21 deletions(-)

-- 
2.19.1

