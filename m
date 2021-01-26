Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F0F303E57
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391739AbhAZNPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:15:23 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11503 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391789AbhAZMp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 07:45:58 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DQ5yR1JhfzjDdq;
        Tue, 26 Jan 2021 20:43:59 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 20:45:03 +0800
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
Subject: [RFC PATCH 2/7] kvm: arm64: Use atomic operation when update PTE
Date:   Tue, 26 Jan 2021 20:44:39 +0800
Message-ID: <20210126124444.27136-3-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210126124444.27136-1-zhukeqian1@huawei.com>
References: <20210126124444.27136-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We are about to add HW_DBM support for stage2 dirty log, so software
updating PTE may race with the MMU trying to set the access flag or
dirty state.

Use atomic oparations to avoid reverting these bits set by MMU.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 41 ++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index bdf8e55ed308..4915ba35f93b 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -153,10 +153,34 @@ static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte)
 	return __va(kvm_pte_to_phys(pte));
 }
 
+/*
+ * We may race with the MMU trying to set the access flag or dirty state,
+ * use atomic oparations to avoid reverting these bits.
+ *
+ * Return original PTE.
+ */
+static kvm_pte_t kvm_update_pte(kvm_pte_t *ptep, kvm_pte_t bit_set,
+				kvm_pte_t bit_clr)
+{
+	kvm_pte_t old_pte, pte = *ptep;
+
+	do {
+		old_pte = pte;
+		pte &= ~bit_clr;
+		pte |= bit_set;
+
+		if (old_pte == pte)
+			break;
+
+		pte = cmpxchg_relaxed(ptep, old_pte, pte);
+	} while (pte != old_pte);
+
+	return old_pte;
+}
+
 static void kvm_set_invalid_pte(kvm_pte_t *ptep)
 {
-	kvm_pte_t pte = *ptep;
-	WRITE_ONCE(*ptep, pte & ~KVM_PTE_VALID);
+	kvm_update_pte(ptep, 0, KVM_PTE_VALID);
 }
 
 static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp)
@@ -723,18 +747,7 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		return 0;
 
 	data->level = level;
-	data->pte = pte;
-	pte &= ~data->attr_clr;
-	pte |= data->attr_set;
-
-	/*
-	 * We may race with the CPU trying to set the access flag here,
-	 * but worst-case the access flag update gets lost and will be
-	 * set on the next access instead.
-	 */
-	if (data->pte != pte)
-		WRITE_ONCE(*ptep, pte);
-
+	data->pte = kvm_update_pte(ptep, data->attr_set, data->attr_clr);
 	return 0;
 }
 
-- 
2.19.1

