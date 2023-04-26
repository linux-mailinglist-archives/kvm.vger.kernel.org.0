Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297036EF945
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 19:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236172AbjDZRYB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 13:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235349AbjDZRXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 13:23:54 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA53F7A9D
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 10:23:46 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-51b67183546so4491271a12.0
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 10:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682529826; x=1685121826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+eiBogFDbJ7/PpjU5DTdjZ5VwrrLAvstoq84EX5RGOU=;
        b=qIGeiokt1nAg4zwnz5OaInuRBMHYly9IwuF0pq9C26gAiDVU3UYIhR3l1L6xR78asd
         1QXuIVrkRf2D/EgxWnv8QDPmwelefKIM+jjYZ2djKdi4m18MWOQ1Xo+X89aABga+UBNu
         duHNdg+RUjom9o6azIXPg/7oLpYK+J1Rkljaxq3r+GNhRH8OhzVuqSYHI2k0eIoNN6MI
         lBolXE4PmsQmynm2b1hmhRFXR5r8nR82jKUgsNOZWiIuPvlLj/lZslPAdJSdczmokKOr
         fUOASxRB6ZbOVnNJakDzfQVxpYlS9BmsdzZC9ryOHKGCebfx8wriuLE6Sl4U8drucT29
         xVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682529826; x=1685121826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+eiBogFDbJ7/PpjU5DTdjZ5VwrrLAvstoq84EX5RGOU=;
        b=BBuebATki4Jf0tq62sblzi9zmyy6vjw6MKdZwsCjMX6hrCAW+heMLS2fJ7XtUHFFKm
         jb3LRnbm3DNPO5+DhR+hFzC6ameMDcLvJBvm3AXxr1TmQIhqj+CP2ZVUkzZCBWb1moy/
         MV5a/bcZj7Ww3mJ/++RAACaXQFXy2rQR6FrvIFY13gWjHyQPlVavctpV0LwpNqFJ7zWy
         /zC8h5uqMkL3PLV+MJktb9SiGL1yVyr7Bj5jI9S5sJgt3rLuN/Y5EoruX07YLiqOCvTR
         eDMXgwZZgo7NSY5arrToWcYp5jJ5AYVva/4RKo7e0HiGYvJ6PYSaKZVJjl9bsaVuZuGK
         Z2WA==
X-Gm-Message-State: AAQBX9fD3tjs/dfIGmQkkOFV/gYbxaNF3F+Arx7zQvflbDhuBjfXE98l
        ZRlOKP3ZIFGHgltirzAdbXSvZejgS7ViDw==
X-Google-Smtp-Source: AKy350bD9vkjTCoe3Me0GqM4NOKEnVHhSJLlNYhCveEZhDvtTq/ZROfRwuSK090OuHnA/fkTX4VH1xRZaIdWuQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:4d50:0:b0:513:290b:7516 with SMTP id
 n16-20020a634d50000000b00513290b7516mr4939122pgl.3.1682529826235; Wed, 26 Apr
 2023 10:23:46 -0700 (PDT)
Date:   Wed, 26 Apr 2023 17:23:25 +0000
In-Reply-To: <20230426172330.1439644-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230426172330.1439644-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230426172330.1439644-8-ricarkol@google.com>
Subject: [PATCH v8 07/12] KVM: arm64: Refactor kvm_arch_commit_memory_region()
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
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor kvm_arch_commit_memory_region() as a preparation for a future
commit to look cleaner and more understandable. Also, it looks more
like its x86 counterpart (in kvm_mmu_slot_apply_flags()).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/mmu.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7e1cb38d0fc97..92f8872550f26 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1765,20 +1765,32 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
+	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
+
 	/*
 	 * At this point memslot has been committed and there is an
 	 * allocated dirty_bitmap[], dirty pages will be tracked while the
 	 * memory slot is write protected.
 	 */
-	if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+	if (log_dirty_pages) {
+
+		if (change == KVM_MR_DELETE)
+			return;
+
 		/*
-		 * If we're with initial-all-set, we don't need to write
-		 * protect any pages because they're all reported as dirty.
-		 * Huge pages and normal pages will be write protect gradually.
+		 * Pages are write-protected on either of these two
+		 * cases:
+		 *
+		 * 1. with initial-all-set: gradually with CLEAR ioctls,
 		 */
-		if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
-			kvm_mmu_wp_memory_region(kvm, new->id);
-		}
+		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+			return;
+		/*
+		 * or
+		 * 2. without initial-all-set: all in one shot when
+		 *    enabling dirty logging.
+		 */
+		kvm_mmu_wp_memory_region(kvm, new->id);
 	}
 }
 
-- 
2.40.1.495.gc816e09b53d-goog

