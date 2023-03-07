Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E90D6AD5DD
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 04:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjCGDqg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 22:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjCGDq2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 22:46:28 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A9E6B5FF
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 19:46:15 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536bbaa701aso122534277b3.3
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 19:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678160774;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pxHXXFOzzPtwBytDTC3DJkgO49OCnlzta01APx3XRoY=;
        b=nj/c+LEQmDR3kTSgRRFj/Gf2yKA5uMA9WHuiQKtfyl0Cgt1idBG16QiUDxM3VOKJLW
         2QgLWoN42UOUUF/XJAIxdB0g5996QWHSl1b2EYqzH/Uc39menAy95Ls6YVr5Q4d9+FiQ
         nlJ6wGmYGtNEMWyfgGB8fYaEHGBL+j0ftq+rnrsIUcUT0c3ltL1Nx9FURFUMBMUZt6q6
         DbrCE5qRjl70S4SigIUvM6wNYgCEnXDYpdnnQrT5GdO84Xkr/ycK17e/96iP13EE5JQC
         n3IwZWYckEoV9HQII0A29MCIOXPjx6WfFgdrGTZcUZ86MDkWrCvGYtGZKnVnYrwdu4sF
         4TYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678160774;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pxHXXFOzzPtwBytDTC3DJkgO49OCnlzta01APx3XRoY=;
        b=SPiN48Rc6Twvqt8VbtJ0L/971wlf4EMn8zs67ScnXSHEur8h0sTZ2l83GW3zn4Fj23
         oDzbEkwSGXnVw70KY/3lcTnimu+weMnmWe11PhMBZJ4jbysJVGmk/kntE45sjS95NmCU
         mutWnzW6GTcg1voZXnX9GgXr7OKf+tcnjqZE9xVpR4TuyKNvMtJDuBw0cDoiwzwtb4PH
         bcbSNlCeRBeWRsF4jvt2GAMiA6PlWy8mT+pa+pgfchX72fYgjNXjVAxOsqrLbTxq7qVQ
         6D3K2QBEOJwm+FkgX0YqNKuWjyou3I2XMO4BFib5/J49HzEuHRvduJ+szbyAE1yPfCHl
         Oh+A==
X-Gm-Message-State: AO0yUKUjb75o6e18uuNSyjPgtoE/JgFOrobWRMnKW0jlBziC67IBJqGF
        pA//a9FGJFxwO1a4n8uip+RpxXDXNN+eBQ==
X-Google-Smtp-Source: AK7set/QPG5XWbwT+rXjxMWSbAg7uofBayxdEsaP1/+8DML9BhxrSFvP0atmTt2hqDzmmsQ06l4NdFlLgMdgug==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6902:151:b0:afa:d8b5:8e82 with SMTP
 id p17-20020a056902015100b00afad8b58e82mr5595371ybh.6.1678160774501; Mon, 06
 Mar 2023 19:46:14 -0800 (PST)
Date:   Tue,  7 Mar 2023 03:45:53 +0000
In-Reply-To: <20230307034555.39733-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230307034555.39733-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307034555.39733-11-ricarkol@google.com>
Subject: [PATCH v6 10/12] KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
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

Move the functionality of kvm_mmu_write_protect_pt_masked() into its
caller, kvm_arch_mmu_enable_log_dirty_pt_masked().  This will be used
in a subsequent commit in order to share some of the code in
kvm_arch_mmu_enable_log_dirty_pt_masked().

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/mmu.c | 42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index b1b8da5f8b6c..910aea6bbd1e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1056,28 +1056,6 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
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
@@ -1104,17 +1082,27 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
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
2.40.0.rc0.216.gc4246ad0f0-goog

