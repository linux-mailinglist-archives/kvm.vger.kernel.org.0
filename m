Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480CC303F44
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404890AbhAZNto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:49:44 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:11445 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404850AbhAZNmy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 08:42:54 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DQ7DT5ZtPzjCXP;
        Tue, 26 Jan 2021 21:41:13 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 21:42:04 +0800
From:   Yanan Wang <wangyanan55@huawei.com>
To:     <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
CC:     Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, <yezengruan@huawei.com>,
        <zhukeqian1@huawei.com>, <yuzenghui@huawei.com>,
        Yanan Wang <wangyanan55@huawei.com>
Subject: [RFC PATCH v1 0/5] Enable CPU TTRem feature for stage-2
Date:   Tue, 26 Jan 2021 21:41:57 +0800
Message-ID: <20210126134202.381996-1-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.128]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,
This series enable CPU TTRem feature for stage-2 page table and a RFC is sent
for some comments, thanks.

The ARMv8.4 TTRem feature offers 3 levels of support when changing block
size without changing any other parameters that are listed as requiring use
of break-before-make. And I found that maybe we can use this feature to make
some improvement for stage-2 page table and the following explains what
TTRem exactly does for the improvement.

If migration of a VM with hugepages is canceled midway, KVM will adjust the
stage-2 table mappings back to block mappings. We currently use BBM to replace
the table entry with a block entry. Take adjustment of 1G block mapping as an
example, with BBM procedures, we have to invalidate the old table entry first,
flush TLB and unmap the old table mappings, right before installing the new
block entry.

So there will be a bit long period when the old table entry is invalid before
installation of the new block entry, if other vCPUs access any guest page within
the 1G range during this period and find the table entry invalid, they will all
exit from guest with a translation fault. Actually, these translation faults
are not necessary, because the block mapping will be built later. Besides, KVM
will still try to build 1G block mappings for these spurious translation faults,
and will perform cache maintenance operations, page table walk, etc.

In summary, the spurious faults are caused by invalidation in BBM procedures.
Approaches of TTRem level 1,2 ensure that there will not be a moment when the
old table entry is invalid before installation of the new block entry. However,
level-2 method will possibly lead to a TLB conflict which is bothering, so we
use nT both at level-1 and level-2 case to avoid handling TLB conflict aborts.

For an implementation which meets level 1 or level 2, the CPU has two responses
to choose when accessing a block table entry with nT bit set: Firstly, CPU will
generate a translation fault, the effect of this response is simier to BBM.
Secondly, CPU can use the block entry for translation. So with the second kind
of implementation, the above described spurious translations can be prevented.

Yanan Wang (5):
  KVM: arm64: Detect the ARMv8.4 TTRem feature
  KVM: arm64: Add an API to get level of TTRem supported by hardware
  KVM: arm64: Support usage of TTRem in guest stage-2 translation
  KVM: arm64: Add handling of coalescing tables into a block mapping
  KVM: arm64: Adapt page-table code to new handling of coalescing tables

 arch/arm64/include/asm/cpucaps.h    |  3 +-
 arch/arm64/include/asm/cpufeature.h | 13 ++++++
 arch/arm64/kernel/cpufeature.c      | 10 +++++
 arch/arm64/kvm/hyp/pgtable.c        | 62 +++++++++++++++++++++++------
 4 files changed, 74 insertions(+), 14 deletions(-)

-- 
2.19.1

