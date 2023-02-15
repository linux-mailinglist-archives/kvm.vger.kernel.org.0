Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8235698263
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjBORlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjBORlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:41:00 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476A939BB5
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:40:59 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-52ecbe73389so192006807b3.0
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=M+kDNgoMDtvFvURb+a81Y7HPZ850UMfDMsGSfIPtSEw=;
        b=hJ9vl3m71GYNnf3TgzGMxykAT00VnMYT5gHKuaJsMZ8KbemR75oOEt0WuweEox0XJp
         /aJ7TjIvNwG30kMr6RFAkVMCb22BBtNlhiURvCwfQcgyJrtqiX1FCOzDnboyu6XQnph6
         mgIhCyOWuWDj9+GP7S29WXup+oyRW1Msf6nxH+plJxuqMn5xSTqAhN26TGWUJIqDCna+
         MHBlMhYMLcmS41tdUEOzpEME9EuPXSZadpttlRV0/2wt3WYEej+vhlDjRFph7ZDTgGUO
         v3UNs4Npavu675RBlyPO46U16Fq+Ic7Kda2TL/OBNyufLZjx7N4VrYNttbbE3zE6yaGJ
         aOKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M+kDNgoMDtvFvURb+a81Y7HPZ850UMfDMsGSfIPtSEw=;
        b=KIcEM74Y2+RumbU4/7HaHjHqDP0+fpIw31yM7jDSkdpuODhHD5V2+0mK3mYCJIvpUh
         y58qskTocfyX8zNAKEZY5esWgDJWYBuzGVSRT/XI0MFFU4lF36OCSLO1fNGtYl6MgDTm
         0Tat66b4vvzPd7B38LF7JDcMU2S7h/ZEVL+QJbIU4/4sIikJyD8TIH3Ur6F4NSHmr87w
         N9ucMn37MBTYKBYRGBPfUW6EYMuTkxvHZN7WiHI1MrDrZBC/A94MMA14zYpplsMBdERm
         4GHZgrvIaO7kWO0AYxepbpexrhllAoJdKyeGWmRLoJJzvWcMQ1VlYx5YP+GdWcItcNl1
         I57Q==
X-Gm-Message-State: AO0yUKV6RP5I5++fxmklRPXnUQbfgS8NiDlfR7fxPceRyJshQE9tJsGo
        BgOEZoB9UQFObVyEIw9ZfSW2xvNdpCqRpw==
X-Google-Smtp-Source: AK7set8UK9Lwh5Z8Md4clrULGO4vd49cXttUTNvL3kcNkt7nFP4UQCaVRVWZIq+TySiyPYPI+8vfBLFgSpLT/w==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a5b:8c:0:b0:80b:a1c7:e81a with SMTP id
 b12-20020a5b008c000000b0080ba1c7e81amr347590ybp.253.1676482858484; Wed, 15
 Feb 2023 09:40:58 -0800 (PST)
Date:   Wed, 15 Feb 2023 17:40:39 +0000
In-Reply-To: <20230215174046.2201432-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230215174046.2201432-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.637.g21b0678d19-goog
Message-ID: <20230215174046.2201432-6-ricarkol@google.com>
Subject: [PATCH v3 05/12] KVM: arm64: Refactor kvm_arch_commit_memory_region()
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
2.39.1.637.g21b0678d19-goog

