Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938931FACB6
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 11:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgFPJg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 05:36:28 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6268 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728384AbgFPJgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 05:36:25 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B9B15896D93109BC2DD5;
        Tue, 16 Jun 2020 17:36:23 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.173.221.230) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Tue, 16 Jun 2020 17:36:13 +0800
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
        <liangpeng10@huawei.com>, <zhengxiang9@huawei.com>,
        <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH 11/12] KVM: arm64: Support disable hw dirty log after enable
Date:   Tue, 16 Jun 2020 17:35:52 +0800
Message-ID: <20200616093553.27512-12-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20200616093553.27512-1-zhukeqian1@huawei.com>
References: <20200616093553.27512-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.221.230]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We should clear DBM bit of all PTEs and flush TLB, then sync dirty log,
which promise we won't miss any dirty status set by hardware.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/kvm/arm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 92f0b40a30fa..76cab4c0b5a6 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -93,6 +93,12 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			r = -EINVAL;
 		} else {
 			r = 0;
+			if (kvm->arch.hw_dirty_log && !cap->args[0]) {
+				mutex_lock(&kvm->slots_lock);
+				kvm_mmu_clear_dbm_all(kvm);
+				kvm_mmu_sync_dirty_log_all(kvm);
+				mutex_unlock(&kvm->slots_lock);
+			}
 			kvm->arch.hw_dirty_log = cap->args[0];
 		}
 		break;
-- 
2.19.1

