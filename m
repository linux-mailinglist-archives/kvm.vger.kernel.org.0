Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3325031AC
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356188AbiDOWBx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 18:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355788AbiDOWBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 18:01:45 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936BC396BF
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:16 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i5-20020a258b05000000b006347131d40bso7580147ybl.17
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=B6406tYui+5lJgRvZIHJ2dZYS6AUdUd0eyrsU1t7VRI=;
        b=RzttCkqDWkMAl2afGr2S9DJJm5Ry89zm9fK8vSWXxjh+Br5xy5GQOart2FDuwkrzu8
         +3Iq4y2goOAEc/FMm6DlVztE2ytFr3oiz9PTrVTxIm5m3Agm5OTfDy0Zs4ZMjS6SjcTP
         Zb1tTD9KujpWLSKkx4Mqs5RJ6LI4Z/u/gq513Flk/dllCKb2U4eZ8URwcntAGL1GuOmq
         ufWltbnns/Dj/9u47iW81VO53GtXf0bBfExXn11hVKS6QGf6GMMShHapP0dxeuiycC4J
         XphrZoAoqeoctTsXEHQSr5ZLlJzNIHeMt45VK8ODHWJivQe27pVAh1K+W85kwYhJyLS2
         rKpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=B6406tYui+5lJgRvZIHJ2dZYS6AUdUd0eyrsU1t7VRI=;
        b=UPa/hTV0Ihms7NJLIBHvg/RtWlxpY4RS+6cD9eamNB6B8BhwpZsxRRzFYKi6lW+7+U
         YTmdaNXdKefW5CARI/73PC54Tw8MKaGIVAkx70jLeoL+JTu8F+HW1lg2N6hZF/vhELoo
         iA7k0igPvoFuEdXLQzUCsvfzn544J2aLChR61mNAirxzWlBKC8wGs6NzUMNNlwqFT18C
         b9tRkwzjf0hnCrAixmyGuCZf0T9JXn7RI6tGxPG4WbIHkss6zqh7/Bxaqn1XAuYYVorB
         RT7WOfuliTz8SZBvTgwqmTidG2UidtJkPO1zhEMPGafEhQLdQfNIOgXgyW99X+m/HSgf
         XxFQ==
X-Gm-Message-State: AOAM532D7/sCqsYh8cErC0akcgNn4qltz9YWKrGa1tWVBG19AgFeQGyc
        vFXscqIb0FuWWiGTQAk+Spejf6O5vxI=
X-Google-Smtp-Source: ABdhPJyC6al0eeORHQcVaP84DLwWwiUHL9eCDBoXdDwFa7r/iAh2U4p6UOyrCV4QCls9mT6W0yMv3xIYId8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a81:4989:0:b0:2f1:47b9:8ac2 with SMTP id
 w131-20020a814989000000b002f147b98ac2mr935486ywa.346.1650059955713; Fri, 15
 Apr 2022 14:59:15 -0700 (PDT)
Date:   Fri, 15 Apr 2022 21:58:52 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-9-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 08/17] KVM: arm64: Spin off helper for initializing table pte
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

With parallel table walks there is no guarantee that KVM reads back the
same pte that was written. Spin off a helper that creates a pte value,
thereby allowing the visitor callback to return the next table without
reading the ptep again.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index ff6f14755d0c..ffdfd5ee9642 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -167,14 +167,23 @@ static void kvm_clear_pte(kvm_pte_t *ptep)
 	WRITE_ONCE(*ptep, 0);
 }
 
-static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
-			      struct kvm_pgtable_mm_ops *mm_ops)
+static kvm_pte_t kvm_init_table_pte(kvm_pte_t *childp, struct kvm_pgtable_mm_ops *mm_ops)
 {
-	kvm_pte_t old = *ptep, pte = kvm_phys_to_pte(mm_ops->virt_to_phys(childp));
+	kvm_pte_t pte = kvm_phys_to_pte(mm_ops->virt_to_phys(childp));
 
 	pte |= FIELD_PREP(KVM_PTE_TYPE, KVM_PTE_TYPE_TABLE);
 	pte |= KVM_PTE_VALID;
 
+	return pte;
+}
+
+static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
+			      struct kvm_pgtable_mm_ops *mm_ops)
+{
+	kvm_pte_t pte, old = *ptep;
+
+	pte = kvm_init_table_pte(childp, mm_ops);
+
 	WARN_ON(kvm_pte_valid(old));
 	smp_store_release(ptep, pte);
 }
@@ -931,7 +940,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 				kvm_pte_t *old, struct stage2_map_data *data, bool shared)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
-	kvm_pte_t *childp;
+	kvm_pte_t *childp, pte;
 	int ret;
 
 	if (data->anchor) {
@@ -969,9 +978,9 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	 * a table. Accesses beyond 'end' that fall within the new table
 	 * will be mapped lazily.
 	 */
-	kvm_set_table_pte(ptep, childp, mm_ops);
-	mm_ops->get_page(ptep);
-	*old = *ptep;
+	pte = kvm_init_table_pte(childp, mm_ops);
+	stage2_make_pte(ptep, pte, data->mm_ops);
+	*old = pte;
 	return 0;
 }
 
-- 
2.36.0.rc0.470.gd361397f0d-goog

