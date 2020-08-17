Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9593B246527
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 13:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgHQLIL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 07:08:11 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9747 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726403AbgHQLIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 07:08:06 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E80D389EC9CBD5A5F5F1;
        Mon, 17 Aug 2020 19:08:00 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 17 Aug 2020 19:07:51 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>,
        "Andrew Jones" <drjones@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Will Deacon" <will@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH v2 2/2] KVM: arm64: Use kvm_write_guest_lock when init stolen time
Date:   Mon, 17 Aug 2020 19:07:28 +0800
Message-ID: <20200817110728.12196-3-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20200817110728.12196-1-zhukeqian1@huawei.com>
References: <20200817110728.12196-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is a lock version kvm_write_guest. Use it to simplify code.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/pvtime.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
index f7b52ce..2b24e7f 100644
--- a/arch/arm64/kvm/pvtime.c
+++ b/arch/arm64/kvm/pvtime.c
@@ -55,7 +55,6 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
 	struct pvclock_vcpu_stolen_time init_values = {};
 	struct kvm *kvm = vcpu->kvm;
 	u64 base = vcpu->arch.steal.base;
-	int idx;
 
 	if (base == GPA_INVALID)
 		return base;
@@ -66,10 +65,7 @@ gpa_t kvm_init_stolen_time(struct kvm_vcpu *vcpu)
 	 */
 	vcpu->arch.steal.steal = 0;
 	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
-
-	idx = srcu_read_lock(&kvm->srcu);
-	kvm_write_guest(kvm, base, &init_values, sizeof(init_values));
-	srcu_read_unlock(&kvm->srcu, idx);
+	kvm_write_guest_lock(kvm, base, &init_values, sizeof(init_values));
 
 	return base;
 }
-- 
1.8.3.1

