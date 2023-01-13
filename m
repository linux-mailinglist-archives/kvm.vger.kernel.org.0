Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE2E668A6D
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 04:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbjAMDuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 22:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234658AbjAMDuQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 22:50:16 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4981F2719E
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:50:14 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-46658ec0cfcso215555887b3.19
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p+sSgvrkkZpJDxwlY/ZTApHr3MYP7u1zHpbjO+TJRms=;
        b=qmCt49Z9xLx8+zo81eq6M0PqPAvthNQXAFrnCnGUMNTHju3lF74tpwAsMU8O/lanM0
         CO22Eyn2zHvq6NOnuKQI7Wm4oWbuh2mcszoEuTt//Ca9YFcnHK8qxKtMuCwqP6Ra7Yx0
         U37LRPpdtFh6Fu/vUUihiLfApJ4FJ5fjBtlnE58L+DkuLReB/Ws4nL08MVYJjOCPYhhW
         rQMiVdPONO8BLonW0RmdttxPBBkstP2V6MIQ2xs1IO6LGjMyKpWiWYVzjnhSBPGl0Erg
         C2ufCE2b4X/3aFuxFYjIyTbF/SX6KA7Uqy0lyiG02ZjVIosGSCaw0YFKjSHoc60pJ4uD
         VCEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p+sSgvrkkZpJDxwlY/ZTApHr3MYP7u1zHpbjO+TJRms=;
        b=PbEVMLg6yrRtwFPiTd2v47Mj0VCZURxPdHM4CWci85eOyS0Uhn8XVoroaKQQOLMLuj
         luIf6j6AADyfGBP1gLnfBuevI7UT8z6ZIiaKRyF4fXe8/7TECcrekfJMwwCRzhBMY2rG
         e+jUbkIVQwZfAUMKLmh2VR+Mlxexpnt99O/joBP+0RKHWtTM+7Hg5JXZRNhQwQL+U6iw
         DeQH+VGI+cRIBy+3KbYtkQriyettDqCERpCi0AR6aQD8RU+Q3dT/3bD5uK0CXyQMfmaT
         r+nUd5YJ3kFqT+HFe1D6qZce5sTGVp2OkBXuYjUdRJzRO08ovua04jvwcQ5MTNVSSNey
         UTiw==
X-Gm-Message-State: AFqh2kqI2a3aoPi6XalGxFxbxM+wwoxRoYjT18gHpycxpbMZFlP0BBhT
        YZc500tH2QrAy/ers7ycW8QtWHgULMmiRQ==
X-Google-Smtp-Source: AMrXdXuC/KVbLSGIMwQ2ptv5Lv1P18un3U+GBECCaw+jcTKBsYHjMPMeo4iku7CoqDNfts9qfl0pquZ6AEnfyQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:d657:0:b0:47b:772:83bc with SMTP id
 y84-20020a0dd657000000b0047b077283bcmr1487026ywd.311.1673581813622; Thu, 12
 Jan 2023 19:50:13 -0800 (PST)
Date:   Fri, 13 Jan 2023 03:49:58 +0000
In-Reply-To: <20230113035000.480021-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230113035000.480021-8-ricarkol@google.com>
Subject: [PATCH 7/9] KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
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
index 41ee330edae3..009468822bca 100644
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
2.39.0.314.g84b9a713c41-goog

