Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9AC69B7E9
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 04:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjBRDX3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 22:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjBRDX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 22:23:26 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FBE68E6D
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 19:23:25 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 75-20020a250b4e000000b0090f2c84a6a4so2318501ybl.13
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 19:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rbgzVORnpmf4LGOu3cnJ0X83jNhf+dzdrTmSVTaKZV8=;
        b=QU9GCG/O+l0wHwkEw7Ymi6rY8tvAR9gYzS+a0e7KHxTCwE9tCaLLE5yn4YuHRMW0a9
         AXNc+zYd7tK9t37xcq0XGoxCo0BpLW7Do1lzXdj7HGIK6PQ72G0TwBlkWlqcjV3fVe8c
         zMUUQzayZ+XPtkqC53KBFClAJXqeYZP2o7n2KpBf0wJT/JeqBO0UwzZyBhy6spQhkHpj
         xwfkP0MiRzQMqks27Pf26e7sJl/yM+LjQiE+i23JsqeKg8lmLkg7OpI854Rr56x67Les
         44QUWIKc4+tFbnyZdsOzy7rPgOP5nbICXn30c5Z7/00AmgzZhvQiTrrN2/K4ARKRCfnU
         IAYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rbgzVORnpmf4LGOu3cnJ0X83jNhf+dzdrTmSVTaKZV8=;
        b=nejcQzrmA2cAL1RpoCZjID7nbHllaNc1NS2oagoghAkTUtEvBIA4BTs5f1mewJSZYE
         QlopxGbpPnqHTzfQLxdiaAxHXROv8jgtQK+pZPI8/3FC03Y4v94GUX9jnb/VKR/cAoRk
         2AGEhEpfPkCdPD07k88BZKbRizXLEeKc4Ro0pd05lCeTW6TkZJeRxusE1Y3WuXEKOMRs
         6GnNz6ZvoW+blU+6hA9LLK3JIM7rjb8+cp/gdJlL+3yeMEodPhGRF0NjckGcwdd7V/ap
         d+ibWNscUU18pIwOfg0GiN0LAs4GKJY/mqyU79F0BAnD4zjUNfKqOenhcSUCqH9/QiWx
         OtNQ==
X-Gm-Message-State: AO0yUKW+qOZafuAU16dASCMbY5w1sE6SrAge5fUj/za+zf4qnYMv7iRy
        RTZba2OBHf8ZsJN4Td3xVVc9x2H6s8d5KA==
X-Google-Smtp-Source: AK7set8GJdorUdMgVoGdwXGY2XY+L5DQ5JduEeXIylQUvnCnu1ULOjCB0q94gwRBydtPqZgOcrFvDlc9CzCMjA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:97c2:0:b0:9a0:1d7b:707b with SMTP id
 j2-20020a2597c2000000b009a01d7b707bmr11456ybo.4.1676690604853; Fri, 17 Feb
 2023 19:23:24 -0800 (PST)
Date:   Sat, 18 Feb 2023 03:23:07 +0000
In-Reply-To: <20230218032314.635829-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230218032314.635829-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230218032314.635829-6-ricarkol@google.com>
Subject: [PATCH v4 05/12] KVM: arm64: Refactor kvm_arch_commit_memory_region()
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor kvm_arch_commit_memory_region() as a preparation for a future
commit to look cleaner and more understandable. Also, it looks more
like its x86 counterpart (in kvm_mmu_slot_apply_flags()).

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/mmu.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9bd3c2cfb476..d2c5e6992459 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1761,20 +1761,27 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
 		 * If we're with initial-all-set, we don't need to write
 		 * protect any pages because they're all reported as dirty.
 		 * Huge pages and normal pages will be write protect gradually.
 		 */
-		if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
-			kvm_mmu_wp_memory_region(kvm, new->id);
-		}
+		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+			return;
+
+		kvm_mmu_wp_memory_region(kvm, new->id);
 	}
 }
 
-- 
2.39.2.637.g21b0678d19-goog

