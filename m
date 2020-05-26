Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3CF1E0CC5
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 13:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390143AbgEYLZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 07:25:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5279 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389897AbgEYLZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 07:25:08 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5A106A0EB3F34B6CB6FB;
        Mon, 25 May 2020 19:25:04 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.173.221.230) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Mon, 25 May 2020 19:24:54 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <zhengxiang9@huawei.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: [RFC PATCH 0/7] kvm: arm64: Support stage2 hardware DBM
Date:   Mon, 25 May 2020 19:23:59 +0800
Message-ID: <20200525112406.28224-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series add support for stage2 hardware DBM, and it is only
used for dirty log for now.

It works well under some migration test cases, including VM with 4K
pages or 2M THP. I checked the SHA256 hash digest of all memory and
they keep same for source VM and destination VM, which means no dirty
pages is missed under hardware DBM.

However, there are some known issues not solved.

1. Some mechanisms that rely on "write permission fault" become invalid,
   such as kvm_set_pfn_dirty and "mmap page sharing".

   kvm_set_pfn_dirty is called in user_mem_abort when guest issues write
   fault. This guarantees physical page will not be dropped directly when
   host kernel recycle memory. After using hardware dirty management, we
   have no chance to call kvm_set_pfn_dirty.

   For "mmap page sharing" mechanism, host kernel will allocate a new
   physical page when guest writes a page that is shared with other page
   table entries. After using hardware dirty management, we have no chance
   to do this too.

   I need to do some survey on how stage1 hardware DBM solve these problems.
   It helps if anyone can figure it out.

2. Page Table Modification Races: Though I have found and solved some data
   races when kernel changes page table entries, I still doubt that there
   are data races I am not aware of. It's great if anyone can figure them out.

3. Performance: Under Kunpeng 920 platform, for every 64GB memory, KVM
   consumes about 40ms to traverse all PTEs to collect dirty log. It will
   cause unbearable downtime for migration if memory size is too big. I will
   try to solve this problem in Patch v1.

Keqian Zhu (7):
  KVM: arm64: Add some basic functions for hw DBM
  KVM: arm64: Set DBM bit of PTEs if hw DBM enabled
  KVM: arm64: Traverse page table entries when sync dirty log
  KVM: arm64: Steply write protect page table by mask bit
  kvm: arm64: Modify stage2 young mechanism to support hw DBM
  kvm: arm64: Save stage2 PTE dirty info if it is coverred
  KVM: arm64: Enable stage2 hardware DBM

 arch/arm64/include/asm/kvm_host.h     |   1 +
 arch/arm64/include/asm/kvm_mmu.h      |  44 +++++-
 arch/arm64/include/asm/pgtable-prot.h |   1 +
 arch/arm64/include/asm/sysreg.h       |   2 +
 arch/arm64/kvm/reset.c                |   9 +-
 virt/kvm/arm/arm.c                    |   6 +-
 virt/kvm/arm/mmu.c                    | 202 ++++++++++++++++++++++++--
 7 files changed, 246 insertions(+), 19 deletions(-)

-- 
2.19.1

