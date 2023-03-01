Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC2C6A75EE
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 22:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjCAVJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 16:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjCAVJx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 16:09:53 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC214C6C9
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 13:09:49 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id j125-20020a25d283000000b008f257b16d71so1677530ybg.15
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 13:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3PeO1BbXZoKnKTqikGOhua/uQ/4m0gR3AAlD74X8P8s=;
        b=A4lJPfSQKRYCnc/9amFiPPf7+Bjeka6AhKG66HJhpw94GfrOuYOKqQV9yQu/j60gVu
         VjS3ACS1WbmzP6AZ6BoI1nnf/7IbPY1UAv9vTxYRcjhNTfs6VUlwbBrVFunEoNgOQhD3
         g8bLbR4d30xvSiEudDHlT4qdpvXTpbCN9tU42JHwEwW19HPKsYDYXnT5wGE3mNFoqkuS
         Z7B2i5Npz5xZFdajfQ1Y/LRd5YwvFI9sBhA5SIEREIw6O770ukE47IlsJ8AilnaDV9fg
         BlACSnxqtrQkpP8EltNz1I0jZeXjRdtow6c+aaLGW1Yv+YBl+A52NMBqk57t4JyXMF8m
         sHrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3PeO1BbXZoKnKTqikGOhua/uQ/4m0gR3AAlD74X8P8s=;
        b=vcKHeQjwnjKO3XlbuD6l8yTxv8F7g2BYGCCnAR8B5SVXB0uvp20Tiw6ZDCEZWEYWmQ
         uLmLKPvOA5zYDJPhCMIMY9H1fZ9Q+OXOLOwZo14chKJ9mvU7lp5nUb9GS2Ahnt93RIm6
         N+CxizePMC4/za4qm2IKswwceviNHQ1x9Spee8f+0X8pbTLNrRl7WPLkT+bagVH3tbZG
         aIYCJO40iYSF7VAmnhmmS//xQ6rVgNAm4+OZ2/nETyW8qz0g+H2KWJzlRWBzQlPvetug
         FMaaJIKzdiw5Gb+PRandf+/KiAhi8Rv9vRJqNzFLb1tpXTmzz2KvIj8w1OkaL2uWotz7
         wJjA==
X-Gm-Message-State: AO0yUKW5uZ9qYoWl96XUP+j6zJOP5ep3fcFbWLxLoYKKAXmzOt/Xjorx
        fHDct96pVbTu5pRzeZu6UngwJWsqiaNspw==
X-Google-Smtp-Source: AK7set8JGzUU9TcO158ugv/5oUa4xXqtNymTEf1o1Wa7afCjiaOVkQdrKBvIE7MHjEBH7Kug5DMgAIdmTaWuSg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:7442:0:b0:533:9ba2:2661 with SMTP id
 p63-20020a817442000000b005339ba22661mr14ywc.41.1677704988874; Wed, 01 Mar
 2023 13:09:48 -0800 (PST)
Date:   Wed,  1 Mar 2023 21:09:26 +0000
In-Reply-To: <20230301210928.565562-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230301210928.565562-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230301210928.565562-11-ricarkol@google.com>
Subject: [PATCH v5 10/12] KVM: arm64: Open-code kvm_mmu_write_protect_pt_masked()
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
index 20458251c85e..8e9d612dda00 100644
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
2.39.2.722.g9855ee24e9-goog

