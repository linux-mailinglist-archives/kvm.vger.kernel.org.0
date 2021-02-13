Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADDC31A90B
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 01:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbhBMAxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 19:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbhBMAwX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 19:52:23 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D2DC0611C1
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:52 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id p20so1298538qtn.23
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=iY4gwnK7J48jZMcuGf9v6sNJyAAi1bPowIi7TdXtMyw=;
        b=H4WA+PJ9Fq4cpg1iosv8ji5OuoQUgpxkxqxHNFPQaq8e+qlNU0GVOWeOEA9/9dbj2O
         d8kcqOJbPAHYHCFu6btXnCfeg0vv9SV0YDgm69ig2j6LbOueFb1cpJ5TU272r+loQ0z+
         CBWAYcVt3HPw7sQYzd8PIjgT/Kzm6Mct5wGEInUEpQ5vKPdOgzIPhgkpFPol28va4F26
         8+bHm2yF9pWkV55xWL2fV8uSNO3EJlNvMYEAIXEcd1TWizNxjM8TNvhb0FlUXB4CKnva
         UN6mgfA2m+9XBts/tww2psDUZmKwjj+dfb+E3tTQQI7PmetqtccMDbS6ThEit3xhwON/
         duvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=iY4gwnK7J48jZMcuGf9v6sNJyAAi1bPowIi7TdXtMyw=;
        b=ZOh70s0ckPxrmZ2yBIxnK/aDEqaeShuKAvnGkmFTr060AHQgxmJ26CBwA4fX7PMgj6
         tXxGUY8/N805lHNQc3d9oURjiWtXav+Si81LHD2FYhl3dHPEjeLoeoeiBC185JOB/s8g
         Zd49UGDiyStkQKCj8tt6Ermja6Fa/t5VpuS0whkrxkSHcW7USih4W4qDbovblIrBJZUm
         OJu08h6V0u7nxHoAKWwep2FaDFyaARQMdtt1vjM6z0UTqpe3rN+MSxDPJJqbyqqFCIO7
         kZ+zYEAxZ1N7v6hj/1ubMCGiI9jWPN/ywfg4tqxpQhJhgjYsnPxXTx+fAzYEkwyKO3oM
         TcqA==
X-Gm-Message-State: AOAM533NvzDNyVVXhFeuMgKaXAXOlD0EGAtU8gfHaqofy0KggkyKPRlZ
        m9NxNKsFIIEQ1LBMNSd4bmd/JCFuLac=
X-Google-Smtp-Source: ABdhPJzt5cZeVVu5oJFqAzLPuL/5SxpbmnCGTACPKpZBlgHirSFx1mmjdE3vTqILZOSyBX4Yp8GQzUAkcNw=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b407:1780:13d2:b27])
 (user=seanjc job=sendgmr) by 2002:a05:6214:b11:: with SMTP id
 u17mr1060498qvj.50.1613177451984; Fri, 12 Feb 2021 16:50:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 Feb 2021 16:50:14 -0800
In-Reply-To: <20210213005015.1651772-1-seanjc@google.com>
Message-Id: <20210213005015.1651772-14-seanjc@google.com>
Mime-Version: 1.0
References: <20210213005015.1651772-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 13/14] KVM: x86: Fold "write-protect large" use case into
 generic write-protect
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop kvm_mmu_slot_largepage_remove_write_access() and refactor its sole
caller to use kvm_mmu_slot_remove_write_access().  Remove the now-unused
slot_handle_large_level() and slot_handle_all_level() helpers.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 32 --------------------------------
 arch/x86/kvm/x86.c     | 32 +++++++++++++++++---------------
 2 files changed, 17 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 44ee55b26c3d..6ad0fb1913c6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5204,22 +5204,6 @@ slot_handle_level(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			lock_flush_tlb);
 }
 
-static __always_inline bool
-slot_handle_all_level(struct kvm *kvm, struct kvm_memory_slot *memslot,
-		      slot_level_handler fn, bool lock_flush_tlb)
-{
-	return slot_handle_level(kvm, memslot, fn, PG_LEVEL_4K,
-				 KVM_MAX_HUGEPAGE_LEVEL, lock_flush_tlb);
-}
-
-static __always_inline bool
-slot_handle_large_level(struct kvm *kvm, struct kvm_memory_slot *memslot,
-			slot_level_handler fn, bool lock_flush_tlb)
-{
-	return slot_handle_level(kvm, memslot, fn, PG_LEVEL_4K + 1,
-				 KVM_MAX_HUGEPAGE_LEVEL, lock_flush_tlb);
-}
-
 static __always_inline bool
 slot_handle_leaf(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		 slot_level_handler fn, bool lock_flush_tlb)
@@ -5584,22 +5568,6 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
-void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
-					struct kvm_memory_slot *memslot)
-{
-	bool flush;
-
-	write_lock(&kvm->mmu_lock);
-	flush = slot_handle_large_level(kvm, memslot, slot_rmap_write_protect,
-					false);
-	if (is_tdp_mmu_enabled(kvm))
-		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_2M);
-	write_unlock(&kvm->mmu_lock);
-
-	if (flush)
-		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
-}
-
 void kvm_mmu_zap_all(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dca2c3333ef2..1d2bc89431a2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10829,24 +10829,25 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 		 */
 		kvm_mmu_zap_collapsible_sptes(kvm, new);
 	} else {
-		/*
-		 * Large sptes are write-protected so they can be split on first
-		 * write. New large sptes cannot be created for this slot until
-		 * the end of the logging. See the comments in fast_page_fault().
-		 *
-		 * For small sptes, nothing is done if the dirty log is in the
-		 * initial-all-set state.  Otherwise, depending on whether pml
-		 * is enabled the D-bit or the W-bit will be cleared.
-		 */
+		/* By default, write-protect everything to log writes. */
+		int level = PG_LEVEL_4K;
+
 		if (kvm_x86_ops.cpu_dirty_log_size) {
+			/*
+			 * Clear all dirty bits, unless pages are treated as
+			 * dirty from the get-go.
+			 */
 			if (!kvm_dirty_log_manual_protect_and_init_set(kvm))
 				kvm_mmu_slot_leaf_clear_dirty(kvm, new);
-			kvm_mmu_slot_largepage_remove_write_access(kvm, new);
-		} else {
-			int level =
-				kvm_dirty_log_manual_protect_and_init_set(kvm) ?
-				PG_LEVEL_2M : PG_LEVEL_4K;
 
+			/*
+			 * Write-protect large pages on write so that dirty
+			 * logging happens at 4k granularity.  No need to
+			 * write-protect small SPTEs since write accesses are
+			 * logged by the CPU via dirty bits.
+			 */
+			level = PG_LEVEL_2M;
+		} else if (kvm_dirty_log_manual_protect_and_init_set(kvm)) {
 			/*
 			 * If we're with initial-all-set, we don't need
 			 * to write protect any small page because
@@ -10855,8 +10856,9 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 			 * so that the page split can happen lazily on
 			 * the first write to the huge page.
 			 */
-			kvm_mmu_slot_remove_write_access(kvm, new, level);
+			level = PG_LEVEL_2M;
 		}
+		kvm_mmu_slot_remove_write_access(kvm, new, level);
 	}
 }
 
-- 
2.30.0.478.g8a0d178c01-goog

