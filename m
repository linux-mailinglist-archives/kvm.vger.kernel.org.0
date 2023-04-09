Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D9F6DBEDE
	for <lists+kvm@lfdr.de>; Sun,  9 Apr 2023 08:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjDIGaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Apr 2023 02:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDIGaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Apr 2023 02:30:08 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D46059ED
        for <kvm@vger.kernel.org>; Sat,  8 Apr 2023 23:30:07 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id x189-20020a6386c6000000b004fc1c14c9daso1081531pgd.23
        for <kvm@vger.kernel.org>; Sat, 08 Apr 2023 23:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681021807; x=1683613807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W/9TrLiFh0g6i4CFqkD+8PkRd+TfJMu2Z2yB0plZBwo=;
        b=OKme6zdcLHlLnQV+0WVds+nJndYTKtQG6clVmxCrMGqN+i9aiXDmV/i+QYrKZPYVNo
         UHDSeXvov0SHBxbbiVkXLosyLPavrs0Z1WVMrBEs1yDd8d+/d57hFHkKeCMYaRSU7TVZ
         woNAauRkvBMkeCUSQtaQkBNqNItxgm67ifIwgm+h9dlp6N+JtErbUG84vS4o9mXBc4+8
         ev5VPudAMXCxz2h6Akctc3nmTqN0AE+8GQUhwyUHQ4z+l266a//kvLxl/0k8OaNQ+w7J
         pnVWdEIJ6ojApjdCyeQ/2NOV4e5fKRQ36asYyOyDOkm4j74ATF+xTTuA8KRh7sf0Rwcw
         BYBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681021807; x=1683613807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W/9TrLiFh0g6i4CFqkD+8PkRd+TfJMu2Z2yB0plZBwo=;
        b=KsTiUcHCwVq4iJGC9OHg0M8Mv0XAh7Xgwx1o4KfRN2m5eDblQNU6MwRb7zLOh2PmLD
         WFlo444XLXFQrAa7ZVXpuNNdecaDdWRFcylEVUDMLRb/QgiG/tb7TQd26745/vcbFlFG
         hpwMy65JOCLsXDlHqFFYOWc+1w+JeRogGjlZNv7eOzpeY+w0vTbM4AFyOv+R7KUPVJNA
         azMPDnBmrzdSBQvCHkIJGW/DzoffUABvjn/4En0xz1ITQQKAknJczXA+WftujCvF4TMV
         c5az+XZq+boOY5Ia8KYQjIXysqwPj/t8NiIqlq/u71IEmtjNQxJkwQjufgJsfrMYoev7
         Kyqw==
X-Gm-Message-State: AAQBX9cvYyf4yoqtpPKqJIBPqwgUEBgfUKiMAz/8c9unAa6XOuN17mIs
        I/6nnSCjtXjeV1eOnX2p2SKKKWkfioDfOQ==
X-Google-Smtp-Source: AKy350Z2WQwB5EMyLbrcj2e9/j7PUbO/8LTAEI6k3DdYFkDybadjKLoY/rTeCg4eYVz+ZWnt2lWiichG8LM6iQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:902:cecb:b0:19a:82a2:fcf9 with SMTP
 id d11-20020a170902cecb00b0019a82a2fcf9mr1088678plg.2.1681021806971; Sat, 08
 Apr 2023 23:30:06 -0700 (PDT)
Date:   Sun,  9 Apr 2023 06:29:49 +0000
In-Reply-To: <20230409063000.3559991-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230409063000.3559991-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230409063000.3559991-3-ricarkol@google.com>
Subject: [PATCH v7 02/12] KVM: arm64: Add KVM_PGTABLE_WALK ctx->flags for
 skipping BBM and CMO
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add two flags to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_SKIP_BBM and
KVM_PGTABLE_WALK_SKIP_CMO, to indicate that the walk should not
perform break-before-make (BBM) nor cache maintenance operations
(CMO). This will be used by a future commit to create unlinked tables
not accessible to the HW page-table walker.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  8 ++++++
 arch/arm64/kvm/hyp/pgtable.c         | 37 +++++++++++++++++++---------
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 26a4293726c14..3f2d43ba2b628 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -195,6 +195,12 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
  *					with other software walkers.
  * @KVM_PGTABLE_WALK_HANDLE_FAULT:	Indicates the page-table walk was
  *					invoked from a fault handler.
+ * @KVM_PGTABLE_WALK_SKIP_BBM_TLBI:	Visit and update table entries
+ *					without Break-before-make's
+ *					TLB invalidation.
+ * @KVM_PGTABLE_WALK_SKIP_CMO:		Visit and update table entries
+ *					without Cache maintenance
+ *					operations required.
  */
 enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_LEAF			= BIT(0),
@@ -202,6 +208,8 @@ enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
 	KVM_PGTABLE_WALK_SHARED			= BIT(3),
 	KVM_PGTABLE_WALK_HANDLE_FAULT		= BIT(4),
+	KVM_PGTABLE_WALK_SKIP_BBM_TLBI		= BIT(5),
+	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(6),
 };
 
 struct kvm_pgtable_visit_ctx {
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index a3246d6cddec7..633679ee3c49a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -62,6 +62,16 @@ struct kvm_pgtable_walk_data {
 	u64				end;
 };
 
+static bool kvm_pgtable_walk_skip_bbm_tlbi(const struct kvm_pgtable_visit_ctx *ctx)
+{
+	return unlikely(ctx->flags & KVM_PGTABLE_WALK_SKIP_BBM_TLBI);
+}
+
+static bool kvm_pgtable_walk_skip_cmo(const struct kvm_pgtable_visit_ctx *ctx)
+{
+	return unlikely(ctx->flags & KVM_PGTABLE_WALK_SKIP_CMO);
+}
+
 static bool kvm_phys_is_valid(u64 phys)
 {
 	return phys < BIT(id_aa64mmfr0_parange_to_phys_shift(ID_AA64MMFR0_EL1_PARANGE_MAX));
@@ -741,14 +751,17 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 	if (!stage2_try_set_pte(ctx, KVM_INVALID_PTE_LOCKED))
 		return false;
 
-	/*
-	 * Perform the appropriate TLB invalidation based on the evicted pte
-	 * value (if any).
-	 */
-	if (kvm_pte_table(ctx->old, ctx->level))
-		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
-	else if (kvm_pte_valid(ctx->old))
-		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
+	if (!kvm_pgtable_walk_skip_bbm_tlbi(ctx)) {
+		/*
+		 * Perform the appropriate TLB invalidation based on the
+		 * evicted pte value (if any).
+		 */
+		if (kvm_pte_table(ctx->old, ctx->level))
+			kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
+		else if (kvm_pte_valid(ctx->old))
+			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
+				     ctx->addr, ctx->level);
+	}
 
 	if (stage2_pte_is_counted(ctx->old))
 		mm_ops->put_page(ctx->ptep);
@@ -832,11 +845,13 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 		return -EAGAIN;
 
 	/* Perform CMOs before installation of the guest stage-2 PTE */
-	if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
+	if (!kvm_pgtable_walk_skip_cmo(ctx) && mm_ops->dcache_clean_inval_poc &&
+	    stage2_pte_cacheable(pgt, new))
 		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new, mm_ops),
-						granule);
+					       granule);
 
-	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
+	if (!kvm_pgtable_walk_skip_cmo(ctx) && mm_ops->icache_inval_pou &&
+	    stage2_pte_executable(new))
 		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
 
 	stage2_make_pte(ctx, new);
-- 
2.40.0.577.gac1e443424-goog

