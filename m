Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37AF17883EB
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 11:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244369AbjHYJhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 05:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241111AbjHYJgy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 05:36:54 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667CD1FD4
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 02:36:52 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RXF9L1k6cz688KN;
        Fri, 25 Aug 2023 17:32:38 +0800 (CST)
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 25 Aug 2023 10:36:43 +0100
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <maz@kernel.org>,
        <will@kernel.org>, <catalin.marinas@arm.com>,
        <oliver.upton@linux.dev>
CC:     <james.morse@arm.com>, <suzuki.poulose@arm.com>,
        <yuzenghui@huawei.com>, <zhukeqian1@huawei.com>,
        <jonathan.cameron@huawei.com>, <linuxarm@huawei.com>
Subject: [RFC PATCH v2 4/8] KVM: arm64: Set DBM for previously writeable pages
Date:   Fri, 25 Aug 2023 10:35:24 +0100
Message-ID: <20230825093528.1637-5-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.202.227.178]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We only set DBM if the page is writeable (S2AP[1] == 1). But once migration
starts, CLEAR_LOG path will write protect the pages (S2AP[1] = 0) and there
isn't an easy way to differentiate the writeable pages that gets write
protected from read-only pages as we only have S2AP[1] bit to check.

Introduced a ctx->flag KVM_PGTABLE_WALK_WC_HINT to identify the dirty page
tracking related write-protect page table walk and used one of the "Reserved
for software use" bit in page descriptor to mark a page as "writeable-clean". 

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  5 +++++
 arch/arm64/kvm/hyp/pgtable.c         | 25 ++++++++++++++++++++++---
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index a12add002b89..67bcbc5984f9 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -190,6 +190,8 @@ enum kvm_pgtable_prot {
 #define KVM_PGTABLE_PROT_RW	(KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W)
 #define KVM_PGTABLE_PROT_RWX	(KVM_PGTABLE_PROT_RW | KVM_PGTABLE_PROT_X)
 
+#define KVM_PGTABLE_PROT_WC	KVM_PGTABLE_PROT_SW0  /*write-clean*/
+
 #define PKVM_HOST_MEM_PROT	KVM_PGTABLE_PROT_RWX
 #define PKVM_HOST_MMIO_PROT	KVM_PGTABLE_PROT_RW
 
@@ -221,6 +223,8 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
  *					operations required.
  * @KVM_PGTABLE_WALK_HW_DBM:		Indicates that the attribute update is
  *					HW DBM related.
+ * @KVM_PGTABLE_WALK_WC_HINT:		Update the page as writeable-clean(software attribute)
+ *					if we are write protecting a writeable page.
  */
 enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_LEAF			= BIT(0),
@@ -231,6 +235,7 @@ enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_SKIP_BBM_TLBI		= BIT(5),
 	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(6),
 	KVM_PGTABLE_WALK_HW_DBM			= BIT(7),
+	KVM_PGTABLE_WALK_WC_HINT		= BIT(8),
 };
 
 struct kvm_pgtable_visit_ctx {
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index d7a46a00a7f6..4552bfb1f274 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -69,6 +69,11 @@ struct kvm_pgtable_walk_data {
 	const u64			end;
 };
 
+static bool kvm_pgtable_walk_wc_hint(const struct kvm_pgtable_visit_ctx *ctx)
+{
+	return ctx->flags & KVM_PGTABLE_WALK_WC_HINT;
+}
+
 static bool kvm_pgtable_walk_hw_dbm(const struct kvm_pgtable_visit_ctx *ctx)
 {
 	return ctx->flags & KVM_PGTABLE_WALK_HW_DBM;
@@ -771,13 +776,24 @@ static bool stage2_pte_writeable(kvm_pte_t pte)
 	return pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
 }
 
+static bool stage2_pte_is_write_clean(kvm_pte_t pte)
+{
+	return kvm_pte_valid(pte) && (pte & KVM_PGTABLE_PROT_WC);
+}
+
+static bool stage2_pte_can_be_write_clean(const struct kvm_pgtable_visit_ctx *ctx,
+					  kvm_pte_t new)
+{
+	return (stage2_pte_writeable(ctx->old) && !stage2_pte_writeable(new));
+}
+
 static void kvm_update_hw_dbm(const struct kvm_pgtable_visit_ctx *ctx,
 			      kvm_pte_t new)
 {
 	kvm_pte_t old_pte, pte = ctx->old;
 
-	/* Only set DBM if page is writeable */
-	if ((new & KVM_PTE_LEAF_ATTR_HI_S2_DBM) && !stage2_pte_writeable(pte))
+	/* Only set DBM if page is writeable-clean */
+	if ((new & KVM_PTE_LEAF_ATTR_HI_S2_DBM) && !stage2_pte_is_write_clean(pte))
 		return;
 
 	/* Clear DBM walk is not shared, update */
@@ -805,6 +821,9 @@ static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_
 	}
 
 	if (!kvm_pgtable_walk_shared(ctx)) {
+		if (kvm_pgtable_walk_wc_hint(ctx) &&
+		    stage2_pte_can_be_write_clean(ctx, new))
+			new |= KVM_PGTABLE_PROT_WC;
 		WRITE_ONCE(*ctx->ptep, new);
 		return true;
 	}
@@ -1306,7 +1325,7 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	return stage2_update_leaf_attrs(pgt, addr, size, 0,
 					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
-					NULL, NULL, 0);
+					NULL, NULL, KVM_PGTABLE_WALK_WC_HINT);
 }
 
 kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
-- 
2.34.1

