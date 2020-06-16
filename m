Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F0C1FACA2
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 11:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgFPJgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 05:36:17 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6335 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728243AbgFPJgQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 05:36:16 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9F912D563F9CEB625A78;
        Tue, 16 Jun 2020 17:36:13 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.173.221.230) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Tue, 16 Jun 2020 17:36:06 +0800
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
Subject: [PATCH 03/12] KVM: arm64: Report hardware dirty status of stage2 PTE if coverred
Date:   Tue, 16 Jun 2020 17:35:44 +0800
Message-ID: <20200616093553.27512-4-zhukeqian1@huawei.com>
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

kvm_set_pte is called to replace a target PTE with a desired one.
We always do this without changing the desired one, but if dirty
status set by hardware is coverred, let caller know it.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/kvm/mmu.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5ad87bce23c0..27407153121b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -194,11 +194,45 @@ static void clear_stage2_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr
 	put_page(virt_to_page(pmd));
 }
 
-static inline void kvm_set_pte(pte_t *ptep, pte_t new_pte)
+#ifdef CONFIG_ARM64_HW_AFDBM
+/**
+ * @ret: true if dirty status set by hardware is coverred.
+ */
+static bool kvm_set_pte(pte_t *ptep, pte_t new_pte)
+{
+	pteval_t old_pteval, new_pteval, pteval;
+	bool old_logging, new_no_write;
+
+	old_logging = kvm_hw_dbm_enabled() && !pte_none(*ptep) &&
+		      kvm_s2pte_dbm(ptep);
+	new_no_write = pte_none(new_pte) || kvm_s2pte_readonly(&new_pte);
+
+	if (!old_logging || !new_no_write) {
+		WRITE_ONCE(*ptep, new_pte);
+		dsb(ishst);
+		return false;
+	}
+
+	new_pteval = pte_val(new_pte);
+	pteval = READ_ONCE(pte_val(*ptep));
+	do {
+		old_pteval = pteval;
+		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, new_pteval);
+	} while (pteval != old_pteval);
+
+	return !kvm_s2pte_readonly(&__pte(pteval));
+}
+#else
+/**
+ * @ret: true if dirty status set by hardware is coverred.
+ */
+static inline bool kvm_set_pte(pte_t *ptep, pte_t new_pte)
 {
 	WRITE_ONCE(*ptep, new_pte);
 	dsb(ishst);
+	return false;
 }
+#endif /* CONFIG_ARM64_HW_AFDBM */
 
 static inline void kvm_set_pmd(pmd_t *pmdp, pmd_t new_pmd)
 {
-- 
2.19.1

