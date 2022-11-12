Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40F8962681A
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 09:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbiKLIRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Nov 2022 03:17:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234846AbiKLIRh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Nov 2022 03:17:37 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC7E5CD0A
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 00:17:35 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id 36-20020a17090a0fa700b00213d5296e13so3696288pjz.6
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 00:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0zGg5qpt/N/L+7x9jBKqpcMeXFwv5fWMYVI5N+PjKgU=;
        b=F/QDe6+1BvTXnyFLOg8gmQXYeT1rQN+sOHZw5/jn/OIBg/ksieVuSU4RzXZqbOs6hn
         aNj63YtnreOXtjSpmZLavBBDWoKmI03HxKlfoMz3hB9W602bO1TYehJR+fIsGRF2s/zZ
         kx9eXb8+bZHkcyoh3xmjRsCjZJC8lYCvIdEXGhaFPLUysIDdId6lqbqIa6Zgm85IFCSZ
         rApV/opjPoYkVYAQjpoVccRv/EF5McPBadihotqfKUFYIuStVJxwmOk8b2kA3I/gnIYT
         O1Y+ZrnCEx6xISo+PAodbia8LsljVtUpxMEZUQLiK+M7/xgL1P5nctTNvIAmgDM2yXjf
         Ttdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0zGg5qpt/N/L+7x9jBKqpcMeXFwv5fWMYVI5N+PjKgU=;
        b=waj+sdwJ4hYuT0bPdYVRa1rgM6e8uaPfeQFfMMyQI7I7lhEdM+va50iTcrQ/kX6ijw
         W/8ko9C9vGQBIG7HABDOx6uX7YLt5oJgpNJBibK1faza3+sW+TO4lViCGpqX6s0a9GQE
         X2dAqUihG5BdYhM6+TyvjIWAZXJoU7IOqLb5dRfIYv81WunA/zeBLVHTlkNoluI0Zl4C
         SCtLHV8dd0l4ROTTPk1gCLMewoChk8ts5a88jLGAnv1dW2/4ehYFMgO2UEeDCBl5zDd/
         svooGNWsGb0aI0mpsSVJvvxgIlnkY4iHdmQxAmfifyX9dEbQBEhU+qRzZbe9OmRqCDHw
         yPfA==
X-Gm-Message-State: ANoB5pkGOmm1EoW2DjUFaoL4sow/c3LQfaiHTKOEmEAPWB8CjhDrZTaL
        psRYlD4DEads44UrknX1skI06PCA3ERQCg==
X-Google-Smtp-Source: AA0mqf4lNmUCe4aprIz7lgD/9R+sooPtJqmagrCa4wPvpU7RVYrs0Whp+W9dnK4MbP2UeTGIJf0U7NvtOtUO4g==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:aa7:8dcd:0:b0:56c:674a:16f0 with SMTP id
 j13-20020aa78dcd000000b0056c674a16f0mr6285637pfr.10.1668241054624; Sat, 12
 Nov 2022 00:17:34 -0800 (PST)
Date:   Sat, 12 Nov 2022 08:17:12 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-11-ricarkol@google.com>
Subject: [RFC PATCH 10/12] KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, ricarkol@gmail.com,
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

Move the functionality of kvm_mmu_write_protect_pt_masked() into its
caller, kvm_arch_mmu_enable_log_dirty_pt_masked().  This will be used in a
subsequent commit in order to share some of the code in
kvm_arch_mmu_enable_log_dirty_pt_masked().

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/mmu.c | 42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f2753d9deb19..7881df411643 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1045,28 +1045,6 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
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
@@ -1091,17 +1069,27 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
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
2.38.1.431.g37b22c650d-goog

