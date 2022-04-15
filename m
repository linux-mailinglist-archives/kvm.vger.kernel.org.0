Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942AF5030E0
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356100AbiDOWBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 18:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356124AbiDOWBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 18:01:47 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80EA8396BF
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:17 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id v9-20020a5ed709000000b006530841a32cso1129582iom.21
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0g9zJiooWDeKugRAQw4FN5FN0/UzyXcPgqHvAqWzKag=;
        b=oLCH+GSdJvXkd0Gi9+H7vA79g6hjv3mWJ8f1Ky8MSz9VGrXihtRm2Q2mQk94XB6R1V
         rI0BdGd8LpAzMP3bNbGXHpcJwONP3gy5q638j75OkVYuPzBzMikI3B/GpnP4ZHi6WYgC
         1NnjFM6MAYPTaJtge/P7t3M0AOj4J/HW1tzhhrT32UjnHREO3sHO9Q6aRYB6eSSaw14y
         1XJYEXTFyIROlajcWQONhn8qbXtAQymvl+UmDZ5XpOcMbLVur2O69+FsbWoSTYPTr05p
         24KmSiJ75xiAF16xI5zuCM76equOlcpV45VjmXOI3Dw1o6nycZZCyMKAyu7F35txmRD/
         JODA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0g9zJiooWDeKugRAQw4FN5FN0/UzyXcPgqHvAqWzKag=;
        b=BdPO0T38oKl73SkxrY8/XWoxFpiGBy/ZQK0f4dbx3P3iTf5WDcnh5wjcT6fvPnnT6i
         edOGbuG8Q4kPblQth9qI4LWi8FuNp8Snb4ESTaS6n1R/WxZzd0cL/ORd0I52qYgm1Ol/
         O7y95edtXMjS+A9+WMeOZtgcs/U62F/13RzeoacbeY7J8hmVUWyUQUTrbBl4AlsDDTdQ
         2JEEjZr5d2Q4iDMqF3lFd5CApIDVoHDQY1oXth1fvLRQV6kE87dqZInPhSvN6tVifQzk
         tzZRX+fliwOgYuoez85dCZSEZE3xkgGZ9Z1i58pzdG3bWByDKy68KZjT7mwgGHJGtH4M
         SPgw==
X-Gm-Message-State: AOAM532HPWjVtxayUMxalu21BQdmzpc7gxZwkK5XPrpzittksQ6/GyXJ
        YAYq9D384GtXGLT0M0ctYagyywqg/4Q=
X-Google-Smtp-Source: ABdhPJy38Wy2JIODUbPjdCPdcAqin2kc7u187gx+PAUVY0P1F7nHnp3qVfiaCtdGLADk1YLKoWq+Y853FYQ=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:218a:b0:326:6ed7:c011 with SMTP id
 s10-20020a056638218a00b003266ed7c011mr473714jaj.242.1650059956892; Fri, 15
 Apr 2022 14:59:16 -0700 (PDT)
Date:   Fri, 15 Apr 2022 21:58:53 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-10-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 09/17] KVM: arm64: Tear down unlinked page tables in
 parallel walk
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Breaking a table pte is insufficient to guarantee ownership of an
unlinked subtree. Parallel software walkers could be traversing
substructures and changing their mappings.

Recurse through the unlinked subtree and lock all descendent ptes
to take ownership of the subtree. Since the ptes are actually being
evicted, return table ptes back to the table walker to ensure child
tables are also traversed. Note that this is done both in both the
pre-order and leaf visitors as the underlying pte remains volatile until
it is unlinked.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 56 +++++++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index ffdfd5ee9642..146fc44acf31 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -838,6 +838,54 @@ static void stage2_make_pte(kvm_pte_t *ptep, kvm_pte_t new, struct kvm_pgtable_m
 	}
 }
 
+static kvm_pte_t stage2_unlink_pte_shared(kvm_pte_t *ptep)
+{
+	kvm_pte_t old;
+
+	while (true) {
+		old = xchg(ptep, KVM_INVALID_PTE_LOCKED);
+		if (old != KVM_INVALID_PTE_LOCKED)
+			return old;
+
+		cpu_relax();
+	}
+}
+
+
+/**
+ * stage2_unlink_pte() - Tears down an unreachable pte, returning the next pte
+ *			 to visit (if any).
+ *
+ * @ptep: pointer to the pte to unlink
+ * @level: page table level of the pte
+ * @shared: true if the tables are shared by multiple software walkers
+ * @mm_ops: pointer to the mm ops table
+ *
+ * Return: a table pte if another level of recursion is necessary, 0 otherwise.
+ */
+static kvm_pte_t stage2_unlink_pte(kvm_pte_t *ptep, u32 level, bool shared,
+				   struct kvm_pgtable_mm_ops *mm_ops)
+{
+	kvm_pte_t old;
+
+	if (shared) {
+		old = stage2_unlink_pte_shared(ptep);
+	} else {
+		old = *ptep;
+		WRITE_ONCE(*ptep, KVM_INVALID_PTE_LOCKED);
+	}
+
+	WARN_ON(stage2_pte_is_locked(old));
+
+	if (kvm_pte_table(old, level))
+		return old;
+
+	if (stage2_pte_is_counted(old))
+		mm_ops->put_page(ptep);
+
+	return 0;
+}
+
 static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
 			   u32 level, struct kvm_pgtable_mm_ops *mm_ops)
 {
@@ -922,8 +970,10 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 				     struct stage2_map_data *data,
 				     bool shared)
 {
-	if (data->anchor)
+	if (data->anchor) {
+		*old = stage2_unlink_pte(ptep, level, shared, data->mm_ops);
 		return 0;
+	}
 
 	if (!stage2_leaf_mapping_allowed(addr, end, level, data))
 		return 0;
@@ -944,9 +994,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	int ret;
 
 	if (data->anchor) {
-		if (stage2_pte_is_counted(*old))
-			mm_ops->put_page(ptep);
-
+		*old = stage2_unlink_pte(ptep, level, shared, data->mm_ops);
 		return 0;
 	}
 
-- 
2.36.0.rc0.470.gd361397f0d-goog

