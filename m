Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3727F738DAE
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 19:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjFURu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 13:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbjFURuh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 13:50:37 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3C81FCE
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 10:50:25 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id ca18e2360f4ac-76c6c1b16d2so680908439f.1
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 10:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687369825; x=1689961825;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ztWgNOK7v5lnofLRY7X9WYYq0GAkm6RZjHrbLvfw42o=;
        b=sWoqHmfeLY6tnWxUG0IwhdrL+fj762X3tM56nJrP11HBbUnEqoQwbZ5ZpDAh822HJK
         HP0lTmDlo6XuinGit2v3WKzkusxyKJiy5JFgEYVQjCI+qRcZSOnDcDzLz6EtpX7Xy0nL
         o02g6No1w07ACOE6SQ5mrdBvJDju0Epw6lEDFnexL+GmmWzUuoA5LFD1LogF4MY4mGYs
         MMMpcdvlTEp9au4XWP3tS1UEK92t5G93PjNzjTyrEIBw/IOvSVkRoKLa5pKoqvvrAM7E
         cI0LI3KRII+V21EJOyKHWm2kOx3TQhjZTUVxblEwRl8gzGTNhWrK1356Z6i7tcoWWpBC
         ThhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687369825; x=1689961825;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ztWgNOK7v5lnofLRY7X9WYYq0GAkm6RZjHrbLvfw42o=;
        b=EF2sNFzLILxX+Qvo44r5n63N0YilCiT3bS8RJBxk1TiE9rYYBOe2gjRzMawrJKJPYC
         DeHWIN9zkJW4/oCGPU0IMXzySWnA9+j5lfgyWZCK1oioxo3vxOUrRuaTuuSi83saLtFB
         98uGr9JoCoJ7RTULadBRvwWgL409LjJ/iKOpmcpsVrH2ZA0gN/5MtqEDQGVHpyBrxzpp
         GcDNX/mEePx2rU9veHSWKlwIq0dXK0hm5bzfTO1UdqJgk/Y7ag5GeamC/MasAIILcyo0
         JjxAxk8jv5BvzZbxPlJCGtfMqWXyHKioLSeUiAoQUiyMcBWPen9DfvUqWtNoaOAA+q5f
         lJtA==
X-Gm-Message-State: AC+VfDz0Hg7vucVATuqHAtFUGvWxSsE2j9c82Z1AW6IaIVo7QY7hMBto
        jtM+X9OMdL9z9OqaWimcM5imrcBrWtlV
X-Google-Smtp-Source: ACHHUZ56hrw34YrnSchn/pE9EXcQ5pUHErzFlq5h9tirOYu/Yc7gt++2hbtJo1T9iGYQFdEcatuknOvOHcMs
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a5e:c012:0:b0:774:9732:324 with SMTP id
 u18-20020a5ec012000000b0077497320324mr6331365iol.2.1687369825026; Wed, 21 Jun
 2023 10:50:25 -0700 (PDT)
Date:   Wed, 21 Jun 2023 17:49:55 +0000
In-Reply-To: <20230621175002.2832640-1-rananta@google.com>
Mime-Version: 1.0
References: <20230621175002.2832640-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230621175002.2832640-5-rananta@google.com>
Subject: [RESEND PATCH v5 04/11] KVM: Move kvm_arch_flush_remote_tlbs_memslot()
 to common code
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
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

From: David Matlack <dmatlack@google.com>

Move kvm_arch_flush_remote_tlbs_memslot() to common code and drop
"arch_" from the name. kvm_arch_flush_remote_tlbs_memslot() is just a
range-based TLB invalidation where the range is defined by the memslot.
Now that kvm_flush_remote_tlbs_range() can be called from common code we
can just use that and drop a bunch of duplicate code from the arch
directories.

Note this adds a lockdep assertion for slots_lock being held when
calling kvm_flush_remote_tlbs_memslot(), which was previously only
asserted on x86. MIPS has calls to kvm_flush_remote_tlbs_memslot(),
but they all hold the slots_lock, so the lockdep assertion continues to
hold true.

Also drop the CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT ifdef gating
kvm_flush_remote_tlbs_memslot(), since it is no longer necessary.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/kvm/arm.c     |  6 ------
 arch/mips/kvm/mips.c     | 10 ++--------
 arch/riscv/kvm/mmu.c     |  6 ------
 arch/x86/kvm/mmu/mmu.c   | 16 +---------------
 arch/x86/kvm/x86.c       |  2 +-
 include/linux/kvm_host.h |  7 +++----
 virt/kvm/kvm_main.c      | 18 ++++++++++++++++--
 7 files changed, 23 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 14391826241c8..9a75c23351aca 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1459,12 +1459,6 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 
 }
 
-void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
-					const struct kvm_memory_slot *memslot)
-{
-	kvm_flush_remote_tlbs(kvm);
-}
-
 static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
 					struct kvm_arm_device_addr *dev_addr)
 {
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 6e34bbe244462..614cb7322b6d5 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -199,7 +199,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	/* Flush slot from GPA */
 	kvm_mips_flush_gpa_pt(kvm, slot->base_gfn,
 			      slot->base_gfn + slot->npages - 1);
-	kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+	kvm_flush_remote_tlbs_memslot(kvm, slot);
 	spin_unlock(&kvm->mmu_lock);
 }
 
@@ -235,7 +235,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 		needs_flush = kvm_mips_mkclean_gpa_pt(kvm, new->base_gfn,
 					new->base_gfn + new->npages - 1);
 		if (needs_flush)
-			kvm_arch_flush_remote_tlbs_memslot(kvm, new);
+			kvm_flush_remote_tlbs_memslot(kvm, new);
 		spin_unlock(&kvm->mmu_lock);
 	}
 }
@@ -987,12 +987,6 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
 	return 1;
 }
 
-void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
-					const struct kvm_memory_slot *memslot)
-{
-	kvm_flush_remote_tlbs(kvm);
-}
-
 int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 {
 	int r;
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index f2eb47925806b..97e129620686c 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -406,12 +406,6 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 }
 
-void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
-					const struct kvm_memory_slot *memslot)
-{
-	kvm_flush_remote_tlbs(kvm);
-}
-
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free)
 {
 }
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 32f7fb1b66c8d..d8cfad72f2b1f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6654,7 +6654,7 @@ static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 	 */
 	if (walk_slot_rmaps(kvm, slot, kvm_mmu_zap_collapsible_spte,
 			    PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1, true))
-		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+		kvm_flush_remote_tlbs_memslot(kvm, slot);
 }
 
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
@@ -6673,20 +6673,6 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 	}
 }
 
-void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
-					const struct kvm_memory_slot *memslot)
-{
-	/*
-	 * All current use cases for flushing the TLBs for a specific memslot
-	 * related to dirty logging, and many do the TLB flush out of mmu_lock.
-	 * The interaction between the various operations on memslot must be
-	 * serialized by slots_locks to ensure the TLB flush from one operation
-	 * is observed by any other operation on the same memslot.
-	 */
-	lockdep_assert_held(&kvm->slots_lock);
-	kvm_flush_remote_tlbs_range(kvm, memslot->base_gfn, memslot->npages);
-}
-
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ceb7c5e9cf9e9..2ea17b51037af 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12745,7 +12745,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 		 * See is_writable_pte() for more details (the case involving
 		 * access-tracked SPTEs is particularly relevant).
 		 */
-		kvm_arch_flush_remote_tlbs_memslot(kvm, new);
+		kvm_flush_remote_tlbs_memslot(kvm, new);
 	}
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a054f48498a8f..1eec1119cc4c9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1358,6 +1358,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool yield_to_kernel_mode);
 
 void kvm_flush_remote_tlbs(struct kvm *kvm);
 void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 pages);
+void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
+				   const struct kvm_memory_slot *memslot);
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
@@ -1386,10 +1388,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 					unsigned long mask);
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot);
 
-#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
-void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
-					const struct kvm_memory_slot *memslot);
-#else /* !CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
+#ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
 int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log);
 int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
 		      int *is_dirty, struct kvm_memory_slot **memslot);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fc4ee20d33cc0..92218edfc6b84 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -384,6 +384,20 @@ void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 pages)
 	kvm_flush_remote_tlbs(kvm);
 }
 
+void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
+				   const struct kvm_memory_slot *memslot)
+{
+	/*
+	 * All current use cases for flushing the TLBs for a specific memslot
+	 * related to dirty logging, and many do the TLB flush out of mmu_lock.
+	 * The interaction between the various operations on memslot must be
+	 * serialized by slots_locks to ensure the TLB flush from one operation
+	 * is observed by any other operation on the same memslot.
+	 */
+	lockdep_assert_held(&kvm->slots_lock);
+	kvm_flush_remote_tlbs_range(kvm, memslot->base_gfn, memslot->npages);
+}
+
 static void kvm_flush_shadow_all(struct kvm *kvm)
 {
 	kvm_arch_flush_shadow_all(kvm);
@@ -2191,7 +2205,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 	}
 
 	if (flush)
-		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
+		kvm_flush_remote_tlbs_memslot(kvm, memslot);
 
 	if (copy_to_user(log->dirty_bitmap, dirty_bitmap_buffer, n))
 		return -EFAULT;
@@ -2308,7 +2322,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	KVM_MMU_UNLOCK(kvm);
 
 	if (flush)
-		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
+		kvm_flush_remote_tlbs_memslot(kvm, memslot);
 
 	return 0;
 }
-- 
2.41.0.162.gfafddb0af9-goog

