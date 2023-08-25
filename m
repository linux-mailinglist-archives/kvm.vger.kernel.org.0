Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B577883D9
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 11:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243902AbjHYJg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 05:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244409AbjHYJgT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 05:36:19 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134341FD4
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 02:36:17 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RXF8G5PVbz6K64n;
        Fri, 25 Aug 2023 17:31:42 +0800 (CST)
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 25 Aug 2023 10:36:07 +0100
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <maz@kernel.org>,
        <will@kernel.org>, <catalin.marinas@arm.com>,
        <oliver.upton@linux.dev>
CC:     <james.morse@arm.com>, <suzuki.poulose@arm.com>,
        <yuzenghui@huawei.com>, <zhukeqian1@huawei.com>,
        <jonathan.cameron@huawei.com>, <linuxarm@huawei.com>
Subject: [RFC PATCH v2 0/8] KVM: arm64: Implement SW/HW combined dirty log
Date:   Fri, 25 Aug 2023 10:35:20 +0100
Message-ID: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.202.227.178]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=1.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This is to revive the RFC series[1], which makes use of hardware dirty
bit modifier(DBM) feature(FEAT_HAFDBS) for dirty page tracking, sent
out by Zhu Keqian sometime back.

One of the main drawbacks in using the hardware DBM feature for dirty
page tracking is the additional overhead in scanning the PTEs for dirty
pages[2]. Also there are no vCPU page faults when we set the DBM bit,
which may result in higher convergence time during guest migration. 

This series tries to reduce these overheads by not setting the
DBM for all the writeable pages during migration and instead uses a
combined software(current page fault mechanism) and hardware approach
(set DBM) for dirty page tracking.

As noted in RFC v1[1],
"The core idea is that we do not enable hardware dirty at start (do not
add DBM bit). When an arbitrary PT occurs fault, we execute soft tracking
for this PT and enable hardware tracking for its *nearby* PTs (e.g. Add
DBM bit for nearby 64PTs). Then when sync dirty log, we have known all
PTs with hardware dirty enabled, so we do not need to scan all PTs."

Major changes from the RFC v1 are:

1. Rebased to 6.5-rc5 + FEAT_TLBIRANGE series[3].
   The original RFC v1 was based on 5.11 and there are multiple changes
   in KVM/arm64 that fundamentally changed the way the page tables are
   updated. I am not 100% sure that I got all the locking mechanisms
   right during page table traversal here. But haven't seen any
   regressions or mem corruptions so far in my test setup.

2. Use of ctx->flags for handling DBM updates(patch#2)

3. During migration, we can only set DBM for pages that are already
   writeable. But the CLEAR_LOG path will set all the pages as write
   protected. There isn't any easy way to distinguish previous read-only
   pages from this write protected pages. Hence, made use of 
   "Reserved for Software use" bits in the page descriptor to mark
   "writeable-clean" pages. See patch #4.

4. Introduced KVM_CAP_ARM_HW_DBM for enabling this feature from userspace.

Testing
----------
Hardware: HiSilicon ARM64 platform(without FEAT_TLBIRANGE)
Kernel: 6.5-rc5 based with eager page split explicitly
        enabled(chunksize=2MB)

Tests with dirty_log_perf_test with anonymous THP pages shows significant
improvement in "dirty memory time" as expected but with a hit on
"get dirty time" .

./dirty_log_perf_test -b 512MB -v 96 -i 5 -m 2 -s anonymous_thp

+---------------------------+----------------+------------------+
|                           |   6.5-rc5      | 6.5-rc5 + series |
|                           |     (s)        |       (s)        |
+---------------------------+----------------+------------------+
|    dirty memory time      |    4.22        |          0.41    |
|    get dirty log time     |    0.00047     |          3.25    |
|    clear dirty log time   |    0.48        |          0.98    |
+---------------------------------------------------------------+
       
In order to get some idea on actual live migration performance,
I created a VM (96vCPUs, 1GB), ran a redis-benchmark test and
while the test was in progress initiated live migration(local).

redis-benchmark -t set -c 900 -n 5000000 --threads 96

Average of 5 runs shows that benchmark finishes ~10% faster with
a ~8% increase in "total time" for migration.

+---------------------------+----------------+------------------+
|                           |   6.5-rc5      | 6.5-rc5 + series |
|                           |     (s)        |    (s)           |
+---------------------------+----------------+------------------+
| [redis]5000000 requests in|    79.428      |      71.49       |
| [info migrate]total time  |    8438        |      9097        |
+---------------------------------------------------------------+
       
Also ran extensive VM migrations with a Qemu with md5 checksum
calculated for RAM. No regressions or memory corruption observed
so far.

It looks like this series will benefit VMs with write intensive
workloads to improve the Guest uptime during migration.

Please take a look and let me know your feedback. Any help with further
tests and verification is really appreciated.

Thanks,
Shameer

1. https://lore.kernel.org/linux-arm-kernel/20210126124444.27136-1-zhukeqian1@huawei.com/
2. https://lore.kernel.org/linux-arm-kernel/20200525112406.28224-1-zhukeqian1@huawei.com/
3. https://lore.kernel.org/kvm/20230811045127.3308641-1-rananta@google.com/


Keqian Zhu (5):
  arm64: cpufeature: Add API to report system support of HWDBM
  KVM: arm64: Add some HW_DBM related pgtable interfaces
  KVM: arm64: Add some HW_DBM related mmu interfaces
  KVM: arm64: Only write protect selected PTE
  KVM: arm64: Start up SW/HW combined dirty log

Shameer Kolothum (3):
  KVM: arm64: Add KVM_PGTABLE_WALK_HW_DBM for HW DBM support
  KVM: arm64: Set DBM for writeable-clean pages
  KVM: arm64: Add KVM_CAP_ARM_HW_DBM

 arch/arm64/include/asm/cpufeature.h  |  15 +++
 arch/arm64/include/asm/kvm_host.h    |   8 ++
 arch/arm64/include/asm/kvm_mmu.h     |   7 ++
 arch/arm64/include/asm/kvm_pgtable.h |  53 ++++++++++
 arch/arm64/kernel/image-vars.h       |   2 +
 arch/arm64/kvm/arm.c                 | 138 ++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 139 +++++++++++++++++++++++++--
 arch/arm64/kvm/mmu.c                 |  50 +++++++++-
 include/uapi/linux/kvm.h             |   1 +
 9 files changed, 403 insertions(+), 10 deletions(-)

-- 
2.34.1

