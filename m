Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C316B6EF948
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 19:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236195AbjDZRYG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 13:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236148AbjDZRX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 13:23:58 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CBF6A54
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 10:23:52 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-b9a1f3b283bso2829337276.1
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 10:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682529831; x=1685121831;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HI+oatUUv/hyWZVU9asMS8OgWec2vFlYNBnSZZ+827s=;
        b=E5HLyhsg4fh2rB7YS3IEvnXlYhe9NY8ZbQ3GtfZVmNqUwiadhxWogvENU2aWX0T8+J
         6bb6VHZZlF9V4h4Fpfag/sWQ16YjeK000UzmuNitWpVzU0+EOA63bEg86ntGy1Cr+o7c
         k/Tffx+4nZ9ZHxU9jnWTefJX5pbX4GwonrP30Jr08+uNeoj+LdTMBhW0++eQNaRQTAHf
         qVSOHR1Waon3yW9tGZv930mwJTQJ+aqu9qziRKO5mWy8bkLTAhRTSpy5lgC/QxBreaAD
         4OT9R7tZYDAbnc2T8FgyuT5jcS60nEag/NUZHrOd2vjbRTnxW8XSUrKMXfAyTZI/E7Ma
         ofRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682529831; x=1685121831;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HI+oatUUv/hyWZVU9asMS8OgWec2vFlYNBnSZZ+827s=;
        b=k/CUUOJ7GjkOUkR/b/cQuTfkyqkAYM1J/LwST88WXG+O3aqSaAJszcJoaQnm5rOmSn
         mhN8xqxQDHLFMos84MzhvA+ystu0b6+Xh8vukQqxwyWEFaUnI1g3LmEJmGeuso4SnPKZ
         ZlrcOMBeMRtUPPTbnnE3hHcNMOGCUxRzJPaiLGsOfY761/AxnichQeaF+XjhAmDl4Wji
         ptGyVOH7FxekGkqjnazI1PYiQdE0uSxy9kNZU7J3CioAxHbkFLJDuD3RzTRpccaolZUn
         EV2+jq/oNmHOLZbPgarCpvP0QJv2nZqfakjJBSjoDJsPghJbs75gsm6BLJdRHEntX9dx
         /tZg==
X-Gm-Message-State: AAQBX9fAimTCnzrI2eZUaAHnrDU656s0nwnYGoI86v4G5xxnoAvNHOdg
        +a+zbWgdllyRgWGajqGgcDKSEWuTKAsCiQ==
X-Google-Smtp-Source: AKy350aXoicyAxjftzI+FFzRq6Casq3GZjrNkpXiWTgnB23i+RxaEm45FQuhnswIDdXV8awskgaT4XlGiZA2Kw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:d013:0:b0:b99:4473:ed93 with SMTP id
 h19-20020a25d013000000b00b994473ed93mr6748483ybg.4.1682529831436; Wed, 26 Apr
 2023 10:23:51 -0700 (PDT)
Date:   Wed, 26 Apr 2023 17:23:28 +0000
In-Reply-To: <20230426172330.1439644-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230426172330.1439644-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230426172330.1439644-11-ricarkol@google.com>
Subject: [PATCH v8 10/12] KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the functionality of kvm_mmu_write_protect_pt_masked() into its
caller, kvm_arch_mmu_enable_log_dirty_pt_masked().  This will be used
in a subsequent commit in order to share some of the code in
kvm_arch_mmu_enable_log_dirty_pt_masked().

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/mmu.c | 42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4256c4a307531..835e4b8f4e5c3 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1059,28 +1059,6 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	kvm_flush_remote_tlbs(kvm);
 }
 
-/**
- * kvm_mmu_write_protect_pt_masked() - write protect dirty pages
- * @kvm:	The KVM pointer
- * @slot:	The memory slot associated with mask
- * @gfn_offset:	The gfn offset in memory slot
- * @mask:	The mask of dirty pages at offset 'gfn_offset' in this memory
- *		slot to be write protected
- *
- * Walks bits set in mask write protects the associated pte's. Caller must
- * acquire kvm_mmu_lock.
- */
-static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
-		struct kvm_memory_slot *slot,
-		gfn_t gfn_offset, unsigned long mask)
-{
-	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
-	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
-	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
-
-	stage2_wp_range(&kvm->arch.mmu, start, end);
-}
-
 /**
  * kvm_mmu_split_memory_region() - split the stage 2 blocks into PAGE_SIZE
  *				   pages for memory slot
@@ -1110,17 +1088,27 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
 }
 
 /*
- * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
- * dirty pages.
+ * kvm_arch_mmu_enable_log_dirty_pt_masked() - enable dirty logging for selected pages.
+ * @kvm:	The KVM pointer
+ * @slot:	The memory slot associated with mask
+ * @gfn_offset:	The gfn offset in memory slot
+ * @mask:	The mask of pages at offset 'gfn_offset' in this memory
+ *		slot to enable dirty logging on
  *
- * It calls kvm_mmu_write_protect_pt_masked to write protect selected pages to
- * enable dirty logging for them.
+ * Writes protect selected pages to enable dirty logging for them. Caller must
+ * acquire kvm->mmu_lock.
  */
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
 		gfn_t gfn_offset, unsigned long mask)
 {
-	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
+	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
+	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
+	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	stage2_wp_range(&kvm->arch.mmu, start, end);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
-- 
2.40.1.495.gc816e09b53d-goog

