Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39621303438
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 06:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731899AbhAZFTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:19:44 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11494 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729304AbhAYOLy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 09:11:54 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DPWvr3VkzzjD03;
        Mon, 25 Jan 2021 22:09:44 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Mon, 25 Jan 2021 22:10:46 +0800
From:   Yanan Wang <wangyanan55@huawei.com>
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        "Julien Thierry" <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        Yanan Wang <wangyanan55@huawei.com>
Subject: [PATCH 0/2] Performance improvement about cache flush
Date:   Mon, 25 Jan 2021 22:10:42 +0800
Message-ID: <20210125141044.380156-1-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.128]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
This two patches are posted to introduce a new method that can distinguish cases
of allocating memcache more precisely, and to elide some unnecessary cache flush.

For patch-1:
With a guest translation fault, we don't really need the memcache pages when
only installing a new entry to the existing page table or replacing the table
entry with a block entry. And with a guest permission fault, we also don't need
the memcache pages for a write_fault in dirty-logging time if VMs are not
configured with huge mappings. So a new method is introduced to distinguish cases
of allocating memcache more precisely.

For patch-2:
If migration of a VM with hugepages is canceled midway, KVM will adjust the
stage-2 table mappings back to block mappings. With multiple vCPUs accessing
guest pages within the same 1G range, there could be numbers of translation
faults to handle, and KVM will uniformly flush data cache for 1G range before
handling the faults. As it will cost a long time to flush the data cache for
1G range of memory(130ms on Kunpeng 920 servers, for example), the consequent
cache flush for each translation fault will finally lead to vCPU stuck for
seconds or even a soft lockup. I have met both the stuck and soft lockup on
Kunpeng servers with FWB not supported.

When KVM need to recover the table mappings back to block mappings, as we only
replace the existing page tables with a block entry and the cacheability has not
been changed, the cache maintenance opreations can be skipped.

Yanan Wang (2):
  KVM: arm64: Distinguish cases of allocating memcache more precisely
  KVM: arm64: Skip the cache flush when coalescing tables into a block

 arch/arm64/kvm/mmu.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

-- 
2.19.1

