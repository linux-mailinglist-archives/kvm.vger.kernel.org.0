Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1A32F382A
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406431AbhALSNO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406317AbhALSMt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 13:12:49 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD8FC061388
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:12 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id 15so1840062pfu.6
        for <kvm@vger.kernel.org>; Tue, 12 Jan 2021 10:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=bnKGrgv+MMsFcrufi3H/brnDaJ6XjCIFU4yRf/m3uBE=;
        b=WYSs8lBa9V+nf1FbyXI1n6MSt3USDkeANRkGXZzTaMpDOA1u92XqZ6pwc1BVregNEg
         H8fdvqA5ZeTkYDT2izYx5Eo4lv1+jiWwGVkcGxkSujtgGr1PyVyDeeURSTpXkdrjX161
         2WpWmZPBffdkCIvWXqf1y/QLfGjFs8FSQouFxnSV95mE1w38DGcdBJYsbJ6KvbIXa/UN
         oHOvyH+mG/Ibo1xOfxJU8E60Wkf0AZj284cnWpfGJi4SdP43XvNOygIPSa7OM+gdUbI1
         XmABly4XJ+jjuJxaC/zdt4MZs7VDXTLErQiN4d3wEr/LQoT2QRDK/j92LO5qNdtQCkhc
         rj+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bnKGrgv+MMsFcrufi3H/brnDaJ6XjCIFU4yRf/m3uBE=;
        b=VWrQT+vk5/ZaiyI6H4U4lkB17f/jHKOgI5Y9S276OgpNoSVDHZaiuApLCRZ5mLzxmX
         jTHP6zLBD/hFC+KtyehtM8CWbTNhwHPcKjiijIz0rCHlRuEoVvScDMW+zJlVqbAtze3a
         ZhZSX48ksyP1JOpqJAdgcEQTvcCRVV2/87Ih7Srgtdac8izOGcK/7W0iscBY3y5N47ZG
         j/iqC/rcOKvLfqU/0c3jysn3xh05GeyAybf+fM9WbRIeyAUV2xqfSco4N0IFvZW/dW9I
         LY01RuKkZLlToKWza3wtG7iSOncePVEqLBvxXTES4VyFPBPPIh0ooCEHY3SqzfxP/2uG
         2ISg==
X-Gm-Message-State: AOAM532AFyvpRfw8DRi0vtfb+qbwcLsceldIZTVO4CQ+CQd1jqD2Ts5S
        TUnew9Rm4Hcb9/UVsRWBv9RQnH5wrvCX
X-Google-Smtp-Source: ABdhPJyr+exi/2YCCknuX2QZOplfqGjnQhLn1ubw2DdeqkA3PvtqccfKRMCjGVSsNx3SdyCCHuRoOW1y2Rhh
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a62:14d3:0:b029:19e:88c0:8c67 with SMTP id
 202-20020a6214d30000b029019e88c08c67mr435380pfu.69.1610475072351; Tue, 12 Jan
 2021 10:11:12 -0800 (PST)
Date:   Tue, 12 Jan 2021 10:10:32 -0800
In-Reply-To: <20210112181041.356734-1-bgardon@google.com>
Message-Id: <20210112181041.356734-16-bgardon@google.com>
Mime-Version: 1.0
References: <20210112181041.356734-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 15/24] kvm: mmu: Wrap mmu_lock cond_resched and needbreak
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wrap the MMU lock cond_reseched and needbreak operations in a function.
This will support a refactoring to move the lock into the struct
kvm_arch(s) so that x86 can change the spinlock to a rwlock without
affecting the performance of other archs.

No functional change intended.

Reviewed-by: Peter Feiner <pfeiner@google.com>

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/arm64/kvm/mmu.c       |  2 +-
 arch/x86/kvm/mmu/mmu.c     | 16 ++++++++--------
 arch/x86/kvm/mmu/tdp_mmu.c |  8 ++++----
 include/linux/kvm_host.h   |  2 ++
 virt/kvm/kvm_main.c        | 10 ++++++++++
 5 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 402b1642c944..57ef1ec23b56 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -58,7 +58,7 @@ static int stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
 			break;
 
 		if (resched && next != end)
-			cond_resched_lock(&kvm->mmu_lock);
+			kvm_mmu_lock_cond_resched(kvm);
 	} while (addr = next, addr != end);
 
 	return ret;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5a4577830606..659ed0a2875f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2016,9 +2016,9 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
 			flush |= kvm_sync_page(vcpu, sp, &invalid_list);
 			mmu_pages_clear_parents(&parents);
 		}
-		if (need_resched() || spin_needbreak(&vcpu->kvm->mmu_lock)) {
+		if (need_resched() || kvm_mmu_lock_needbreak(vcpu->kvm)) {
 			kvm_mmu_flush_or_zap(vcpu, &invalid_list, false, flush);
-			cond_resched_lock(&vcpu->kvm->mmu_lock);
+			kvm_mmu_lock_cond_resched(vcpu->kvm);
 			flush = false;
 		}
 	}
@@ -5233,14 +5233,14 @@ slot_handle_level_range(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		if (iterator.rmap)
 			flush |= fn(kvm, iterator.rmap);
 
-		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+		if (need_resched() || kvm_mmu_lock_needbreak(kvm)) {
 			if (flush && lock_flush_tlb) {
 				kvm_flush_remote_tlbs_with_address(kvm,
 						start_gfn,
 						iterator.gfn - start_gfn + 1);
 				flush = false;
 			}
-			cond_resched_lock(&kvm->mmu_lock);
+			kvm_mmu_lock_cond_resched(kvm);
 		}
 	}
 
@@ -5390,7 +5390,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
 		 * be in active use by the guest.
 		 */
 		if (batch >= BATCH_ZAP_PAGES &&
-		    cond_resched_lock(&kvm->mmu_lock)) {
+		    kvm_mmu_lock_cond_resched(kvm)) {
 			batch = 0;
 			goto restart;
 		}
@@ -5688,7 +5688,7 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 			continue;
 		if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list, &ign))
 			goto restart;
-		if (cond_resched_lock(&kvm->mmu_lock))
+		if (kvm_mmu_lock_cond_resched(kvm))
 			goto restart;
 	}
 
@@ -6013,9 +6013,9 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 			WARN_ON_ONCE(sp->lpage_disallowed);
 		}
 
-		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+		if (need_resched() || kvm_mmu_lock_needbreak(kvm)) {
 			kvm_mmu_commit_zap_page(kvm, &invalid_list);
-			cond_resched_lock(&kvm->mmu_lock);
+			kvm_mmu_lock_cond_resched(kvm);
 		}
 	}
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 90807f2d928f..fb911ca428b2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -488,10 +488,10 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm,
 		struct tdp_iter *iter)
 {
-	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+	if (need_resched() || kvm_mmu_lock_needbreak(kvm)) {
 		kvm_flush_remote_tlbs(kvm);
 		rcu_read_unlock();
-		cond_resched_lock(&kvm->mmu_lock);
+		kvm_mmu_lock_cond_resched(kvm);
 		rcu_read_lock();
 		tdp_iter_refresh_walk(iter);
 		return true;
@@ -512,9 +512,9 @@ static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm,
  */
 static bool tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
 {
-	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+	if (need_resched() || kvm_mmu_lock_needbreak(kvm)) {
 		rcu_read_unlock();
-		cond_resched_lock(&kvm->mmu_lock);
+		kvm_mmu_lock_cond_resched(kvm);
 		rcu_read_lock();
 		tdp_iter_refresh_walk(iter);
 		return true;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 433d14fdae30..6e2773fc406c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1497,5 +1497,7 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 
 void kvm_mmu_lock(struct kvm *kvm);
 void kvm_mmu_unlock(struct kvm *kvm);
+int kvm_mmu_lock_needbreak(struct kvm *kvm);
+int kvm_mmu_lock_cond_resched(struct kvm *kvm);
 
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 32f97ed1188d..b4c49a7e0556 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -442,6 +442,16 @@ void kvm_mmu_unlock(struct kvm *kvm)
 	spin_unlock(&kvm->mmu_lock);
 }
 
+int kvm_mmu_lock_needbreak(struct kvm *kvm)
+{
+	return spin_needbreak(&kvm->mmu_lock);
+}
+
+int kvm_mmu_lock_cond_resched(struct kvm *kvm)
+{
+	return cond_resched_lock(&kvm->mmu_lock);
+}
+
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
 {
-- 
2.30.0.284.gd98b1dd5eaa7-goog

