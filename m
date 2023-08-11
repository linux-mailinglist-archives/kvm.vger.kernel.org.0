Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0B27786B1
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 06:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjHKEvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 00:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbjHKEvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 00:51:44 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE952D41
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 21:51:42 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-589ac93bc6eso17881407b3.0
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 21:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691729501; x=1692334301;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5cEKwCCkl0Wuj7mvrmbqadCjnsVGY9rMTSQflZ1Y/nU=;
        b=1aHZmZAhLdckQslyujv1CXJJIEugGYcQ2KETwtnv+YT5CvsZJB5BSQN33PTF72qeoH
         SL+23x92jRlBiUagVt9sdA5Qn5tOJ2fBSDDSYdqk8Q+tm+gkVxMLnZURI4sobZVvyMvT
         6R1+O+dCpkAIBWS3QeEddiSouZUlmBvPenpSGWMKZFsVx+KtCbLAaWDCIHl+ScCot/6a
         hrNE+Vmo4lDE1y5xWbNDYzCxtAf2/2uSb/Y9nOWE2HxM0M+rJbwBrpzqpF2xOsL14tLW
         vgxUO8+MVtYvplVOcpRyS0MJ3r0eYcyvD64GVKYVtRBBqUHI2bS1Cy8mGJ8d8l090tz1
         zSDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691729501; x=1692334301;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5cEKwCCkl0Wuj7mvrmbqadCjnsVGY9rMTSQflZ1Y/nU=;
        b=dL+eb2IQD7XmwHs3Nk+/6JrBZPU/DVo1AX5ODGeXysRrezSz3beILMiVIlXL2QzhLG
         TjNTvgX87B6b0iCDUbkNO0o6f3ZVKFOPQPEnNBvlbxW22mULi1VsRc89KFmKi+iR+/v3
         AycUGmNK+zBTvw0kcxeTJRvuF7BJCbpH6MynVP7ja8EvTCeIG8v9jY2tz8u6bsdTMfb6
         sZqE1eOy/zXzuriyrswWpGEtKdJlzp8qzqSNoaT6B8p0U/2oPWhqDzb3Od9Ir7zDlnbc
         H1s3PriPO5y5gyIOuZeTlzKcLd3LdI7865VC/fzHCoH5iXxECl3IxFDVQ5wY+iWlwl47
         97qQ==
X-Gm-Message-State: AOJu0YwGbivMXe1bM0uGbp4ihDsdU4gej68TxOFRiT6+XK883JukdkSo
        q5OOQkLt2ZNOMaFVLV4Eo81ix/Y6OW7W
X-Google-Smtp-Source: AGHT+IG05B59OseX5uumX7BQ1X0OpRdGwq/cwn2uehx61Q3ZHuSAhOD7tVQrEf9SK4EW3LH1nI3ERCEMkLuu
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a81:ac21:0:b0:577:d5b:7ce3 with SMTP id
 k33-20020a81ac21000000b005770d5b7ce3mr13408ywh.9.1691729501524; Thu, 10 Aug
 2023 21:51:41 -0700 (PDT)
Date:   Fri, 11 Aug 2023 04:51:19 +0000
In-Reply-To: <20230811045127.3308641-1-rananta@google.com>
Mime-Version: 1.0
References: <20230811045127.3308641-1-rananta@google.com>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
Message-ID: <20230811045127.3308641-7-rananta@google.com>
Subject: [PATCH v9 06/14] KVM: Move kvm_arch_flush_remote_tlbs_memslot() to
 common code
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
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        David Matlack <dmatlack@google.com>,
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
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
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Acked-by: Anup Patel <anup@brainfault.org>
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
index c2c14059f6a8c..ed7bef4d970b9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1525,12 +1525,6 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 
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
index 4b7bc39a41736..231ac052b506b 100644
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
index 00f7bda9202f2..43314ca606e2f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6668,7 +6668,7 @@ static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
 	 */
 	if (walk_slot_rmaps(kvm, slot, kvm_mmu_zap_collapsible_spte,
 			    PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1, true))
-		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+		kvm_flush_remote_tlbs_memslot(kvm, slot);
 }
 
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
@@ -6687,20 +6687,6 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
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
index a6b9bea62fb8a..faeb2e307b36a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12751,7 +12751,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 		 * See is_writable_pte() for more details (the case involving
 		 * access-tracked SPTEs is particularly relevant).
 		 */
-		kvm_arch_flush_remote_tlbs_memslot(kvm, new);
+		kvm_flush_remote_tlbs_memslot(kvm, new);
 	}
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 89d2614e4b7a6..394db2ce11e2e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1360,6 +1360,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool yield_to_kernel_mode);
 
 void kvm_flush_remote_tlbs(struct kvm *kvm);
 void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages);
+void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
+				   const struct kvm_memory_slot *memslot);
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
@@ -1388,10 +1390,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
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
index 26e91000f579d..5d4d2e051aa09 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -379,6 +379,20 @@ void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages)
 	kvm_flush_remote_tlbs(kvm);
 }
 
+void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
+				   const struct kvm_memory_slot *memslot)
+{
+	/*
+	 * All current use cases for flushing the TLBs for a specific memslot
+	 * are related to dirty logging, and many do the TLB flush out of
+	 * mmu_lock. The interaction between the various operations on memslot
+	 * must be serialized by slots_locks to ensure the TLB flush from one
+	 * operation is observed by any other operation on the same memslot.
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
2.41.0.640.ga95def55d0-goog

