Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D226A75EF
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 22:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCAVJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 16:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjCAVJz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 16:09:55 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11148521D5
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 13:09:51 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id w192-20020a25dfc9000000b009fe14931caaso1682188ybg.7
        for <kvm@vger.kernel.org>; Wed, 01 Mar 2023 13:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=up44/HkkefZu4QAfnYtnSO5Fn3N4tuvaF5fFvsNlgKM=;
        b=KFenBJBQhiq+VeTpG0WQ5D5BMqeQ83fiQPGB2GuyTbjtiPjPFsEeRFay06D0Lvq0HP
         ZCc0kl63EyzK9iVJ52X8sj1AhxNdohfE4hDa9FJERr0ZsCWsy3fnX82Fl5hhwi7utvNh
         udzc/kKUimEhzg91Wsi6uFNsVnvm/dkcVNsLq5hLNSUJPb5bAut5HDtrFquk0Z8BcdPb
         yrU8jr2g6sATFELofrP5wcL0mVchbIaZJjFqmCylXqJpEz05t6mCxRvoNJ9aAc0AKgyg
         Z4gqHveP4IBhCfwUsqimkoSYGdnkpgsJo+nXQCJFx5TUUK4TYf/XP8ngI1uczubwBiQ1
         lrjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=up44/HkkefZu4QAfnYtnSO5Fn3N4tuvaF5fFvsNlgKM=;
        b=RUL+QTv294/60m2PNRC4F1mAmvAw4bV5nY10InLAdvlfcnNZ5uTtEELOaU3h7buZsN
         UcCjoeMB+WB8VviIYUxlnigPK59vgOz18wLX1pNbgnS4M4unN26hqn5WxGs2RsqiUtYu
         4bJivGKmYrgqkZYWwxNGKZNIXJEoiGXqxHoDLlYwzqCO9IjDGA9WtDOeESFBWGQh7kWQ
         ytNZrwMRdwnhn95F1p8Xb7D6KsETjeYW8+QrZKN5PP4aDq2nR0HzebNjbYPquShZZuzS
         EOWw5KYzYYg51DIj01cNKJ48bTCKh9gvXbHRuppO0X2Attd7AwdHZAqJ+JUUdk50ftx7
         tT7g==
X-Gm-Message-State: AO0yUKU3q4Z/fmQwf16JKbEQv+NnaOGAX+aBB2CruOQNM1RKUBbKQror
        xauLrFpNd0Ofo8sBC7VCcK3MF8YQkaovIw==
X-Google-Smtp-Source: AK7set/SXs7DUT4Vm7RzbvFXUYh/VdGpjsd0hoffUyZ7jELuggCBuptbg0X4Vx/OTPO10kIGaafwlpr70rjBNQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:af5c:0:b0:534:515:e472 with SMTP id
 x28-20020a81af5c000000b005340515e472mr4667794ywj.4.1677704990794; Wed, 01 Mar
 2023 13:09:50 -0800 (PST)
Date:   Wed,  1 Mar 2023 21:09:27 +0000
In-Reply-To: <20230301210928.565562-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230301210928.565562-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230301210928.565562-12-ricarkol@google.com>
Subject: [PATCH v5 11/12] KVM: arm64: Split huge pages during KVM_CLEAR_DIRTY_LOG
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

This is the arm64 counterpart of commit cb00a70bd4b7 ("KVM: x86/mmu:
Split huge pages mapped by the TDP MMU during KVM_CLEAR_DIRTY_LOG"),
which has the benefit of splitting the cost of splitting a memslot
across multiple ioctls.

Split huge pages on the range specified using KVM_CLEAR_DIRTY_LOG.
And do not split when enabling dirty logging if
KVM_DIRTY_LOG_INITIALLY_SET is set.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/mmu.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8e9d612dda00..5dae0e6a697f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1089,8 +1089,8 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
  * @mask:	The mask of pages at offset 'gfn_offset' in this memory
  *		slot to enable dirty logging on
  *
- * Writes protect selected pages to enable dirty logging for them. Caller must
- * acquire kvm->mmu_lock.
+ * Splits selected pages to PAGE_SIZE and then writes protect them to enable
+ * dirty logging for them. Caller must acquire kvm->mmu_lock.
  */
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 		struct kvm_memory_slot *slot,
@@ -1103,6 +1103,13 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	stage2_wp_range(&kvm->arch.mmu, start, end);
+
+	/*
+	 * If initially-all-set mode is not set, then huge-pages were already
+	 * split when enabling dirty logging: no need to do it again.
+	 */
+	if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+		kvm_mmu_split_huge_pages(kvm, start, end);
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
@@ -1889,7 +1896,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 		 * this when deleting, moving, disabling dirty logging, or
 		 * creating the memslot (a nop). Doing it for deletes makes
 		 * sure we don't leak memory, and there's no need to keep the
-		 * cache around for any of the other cases.
+		 * cache around for any of the other cases. Keeping the cache
+		 * is useful for successive KVM_CLEAR_DIRTY_LOG calls, which is
+		 * not handled in this function.
 		 */
 		kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
 	}
-- 
2.39.2.722.g9855ee24e9-goog

