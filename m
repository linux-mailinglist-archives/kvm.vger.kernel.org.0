Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF429303E5A
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391777AbhAZNP2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:15:28 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11502 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391790AbhAZMp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 07:45:58 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DQ5yR2C4WzjDdv;
        Tue, 26 Jan 2021 20:43:59 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 20:45:01 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>,
        <xiexiangyou@huawei.com>, <zhengchuan@huawei.com>,
        <yubihong@huawei.com>
Subject: [RFC PATCH 0/7] kvm: arm64: Implement SW/HW combined dirty log
Date:   Tue, 26 Jan 2021 20:44:37 +0800
Message-ID: <20210126124444.27136-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The intention:

On arm64 platform, we tracking dirty log of vCPU through guest memory abort.
KVM occupys some vCPU time of guest to change stage2 mapping and mark dirty.
This leads to heavy side effect on VM, especially when multi vCPU race and
some of them block on kvm mmu_lock.

DBM is a HW auxiliary approach to log dirty. MMU chages PTE to be writable if
its DBM bit is set. Then KVM doesn't occupy vCPU time to log dirty.

About this patch series:

The biggest problem of apply DBM for stage2 is that software must scan PTs to
collect dirty state, which may cost much time and affect downtime of migration.

This series realize a SW/HW combined dirty log that can effectively solve this
problem (The smmu side can also use this approach to solve dma dirty log tracking).

The core idea is that we do not enable hardware dirty at start (do not add DBM bit).
When a arbitrary PT occurs fault, we execute soft tracking for this PT and enable
hardware tracking for its *nearby* PTs (e.g. Add DBM bit for nearby 16PTs). Then when
sync dirty log, we have known all PTs with hardware dirty enabled, so we do not need
to scan all PTs.

        mem abort point             mem abort point
              ↓                            ↓
---------------------------------------------------------------
        |********|        |        |********|        |        |
---------------------------------------------------------------
             ↑                            ↑
        set DBM bit of               set DBM bit of
     this PT section (64PTEs)      this PT section (64PTEs)

We may worry that when dirty rate is over-high we still need to scan too much PTs.
We mainly concern the VM stop time. With Qemu dirty rate throttling, the dirty memory
is closing to the VM stop threshold, so there is a little PTs to scan after VM stop.

It has the advantages of hardware tracking that minimizes side effect on vCPU,
and also has the advantages of software tracking that controls vCPU dirty rate.
Moreover, software tracking helps us to scan PTs at some fixed points, which
greatly reduces scanning time. And the biggest benefit is that we can apply this
solution for dma dirty tracking.

Test:

Host: Kunpeng 920 with 128 CPU 512G RAM. Disable Transparent Hugepage (Ensure test result
      is not effected by dissolve of block page table at the early stage of migration).
VM:   16 CPU 16GB RAM. Run 4 pair of (redis_benchmark+redis_server).

Each run 5 times for software dirty log and SW/HW conbined dirty log. 

Test result:

Gain 5%~7% improvement of redis QPS during VM migration.
VM downtime is not affected fundamentally.
About 56.7% of DBM is effectively used.

Keqian Zhu (7):
  arm64: cpufeature: Add API to report system support of HWDBM
  kvm: arm64: Use atomic operation when update PTE
  kvm: arm64: Add level_apply parameter for stage2_attr_walker
  kvm: arm64: Add some HW_DBM related pgtable interfaces
  kvm: arm64: Add some HW_DBM related mmu interfaces
  kvm: arm64: Only write protect selected PTE
  kvm: arm64: Start up SW/HW combined dirty log

 arch/arm64/include/asm/cpufeature.h  |  12 +++
 arch/arm64/include/asm/kvm_host.h    |   6 ++
 arch/arm64/include/asm/kvm_mmu.h     |   7 ++
 arch/arm64/include/asm/kvm_pgtable.h |  45 ++++++++++
 arch/arm64/kvm/arm.c                 | 125 ++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 130 ++++++++++++++++++++++-----
 arch/arm64/kvm/mmu.c                 |  47 +++++++++-
 arch/arm64/kvm/reset.c               |   8 +-
 8 files changed, 351 insertions(+), 29 deletions(-)

-- 
2.19.1

