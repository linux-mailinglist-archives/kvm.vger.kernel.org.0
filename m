Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C586869A4B9
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 05:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbjBQEMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 23:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjBQEMm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 23:12:42 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4CE5B756
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 20:12:39 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5340513aa39so19546657b3.17
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 20:12:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zOMC30Dt5jTWJdMwqPugeizmTtOBtAcC7CRKjtqAf8M=;
        b=bm43kjVqsx1c7qHOsFFVJ0+0xrXUHmX/V9lp20jfJ1X7N4zZd4d3vyNBymGX/me9gK
         nTebRJhW2oIy2yjncVC9wMVFjstG9iWFcB6e1y3NE5fXCSioxKMMujXyRRWA09QDaWuI
         5NHp8SGOOrBADfd/tJIWc3jugNV6pCNLo8yDtwEDkvM75+pJzBnfO9BcBe5GRXiC6M6C
         BsxIBG/O68HSI1OC0bY7F+eEOjy5Z383u8SWnJZPB3cOWNgoqbleGxYTNZYvv1mrxews
         ibrqxX3GI/du8KUrofan0Xz4K1l4wKn3rqZtCcgiQArjBpayUlYXpRK7dgISyESZns/1
         kB0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zOMC30Dt5jTWJdMwqPugeizmTtOBtAcC7CRKjtqAf8M=;
        b=ET3jPPG2xVyb8PJTCCdjWPyAmA2oYrLEFHfsq2C9GN9APPyRkXVAbroU2M6ID2nxvO
         zAH96Rh6h14+7smuUsT6h0Pta4m+ndW/ug5bC6T6JCcCA1OAtMvmj3AaY2XQ45vcKzSb
         XyAeXy2qWYyGYrGBza/AON6UNbkSlhdnKYOSvcANHFIuwxqKg/YM7waLFSy9igo3NyAu
         Wjei7BFhn58cpqFba2YT5RrbWTp721Mc4NeyrmfshE4u3uHdR6ggBOn8rJLNm+UPFcP1
         TATfXl/hWqkj/5mVmF4bzBdKQ3hao9xQM0YFQ0429KfqHApjNBN+leEDFpin8Oi6rEwj
         98/A==
X-Gm-Message-State: AO0yUKVGJ9gj8nNN78EN+ROUucaev8PtClrH15yXgiauYdB+ls5l04EK
        XMuQwltDtlJj+4T8BCoi/mnEz6nVtVE=
X-Google-Smtp-Source: AK7set9YiUb7IHS5x9zvQDFrhuacJgLt4KpkKYJiB428hgjDG7WBXSnP1azODlrvhkhiovQ/6TgBQWA2SqA=
X-Received: from yuzhao.bld.corp.google.com ([2620:15c:183:200:6fb3:61e:d31f:1ad3])
 (user=yuzhao job=sendgmr) by 2002:a5b:786:0:b0:92c:23ba:7adb with SMTP id
 b6-20020a5b0786000000b0092c23ba7adbmr836225ybq.545.1676607158852; Thu, 16 Feb
 2023 20:12:38 -0800 (PST)
Date:   Thu, 16 Feb 2023 21:12:27 -0700
In-Reply-To: <20230217041230.2417228-1-yuzhao@google.com>
Message-Id: <20230217041230.2417228-3-yuzhao@google.com>
Mime-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Subject: [PATCH mm-unstable v1 2/5] kvm/x86: add kvm_arch_test_clear_young()
From:   Yu Zhao <yuzhao@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Michael Larabel <michael@michaellarabel.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-mm@google.com, Yu Zhao <yuzhao@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds kvm_arch_test_clear_young() for the vast majority of
VMs that are not nested and run on hardware that sets the accessed bit
in TDP MMU page tables.

It relies on two techniques, RCU and cmpxchg, to safely test and clear
the accessed bit without taking the MMU lock. The former protects KVM
page tables from being freed while the latter clears the accessed bit
atomically against both the hardware and other software page table
walkers.

Signed-off-by: Yu Zhao <yuzhao@google.com>
---
 arch/x86/include/asm/kvm_host.h | 27 ++++++++++++++++++++++
 arch/x86/kvm/mmu/spte.h         | 12 ----------
 arch/x86/kvm/mmu/tdp_mmu.c      | 41 +++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6aaae18f1854..d2995c9e8f07 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1367,6 +1367,12 @@ struct kvm_arch {
 	 *	the MMU lock in read mode + the tdp_mmu_pages_lock or
 	 *	the MMU lock in write mode
 	 *
+	 * kvm_arch_test_clear_young() is a special case. It relies on two
+	 * techniques, RCU and cmpxchg, to safely test and clear the accessed
+	 * bit without taking the MMU lock. The former protects KVM page tables
+	 * from being freed while the latter clears the accessed bit atomically
+	 * against both the hardware and other software page table walkers.
+	 *
 	 * Roots will remain in the list until their tdp_mmu_root_count
 	 * drops to zero, at which point the thread that decremented the
 	 * count to zero should removed the root from the list and clean
@@ -2171,4 +2177,25 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
 	 KVM_X86_QUIRK_FIX_HYPERCALL_INSN |	\
 	 KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS)
 
+extern u64 __read_mostly shadow_accessed_mask;
+
+/*
+ * Returns true if A/D bits are supported in hardware and are enabled by KVM.
+ * When enabled, KVM uses A/D bits for all non-nested MMUs.  Because L1 can
+ * disable A/D bits in EPTP12, SP and SPTE variants are needed to handle the
+ * scenario where KVM is using A/D bits for L1, but not L2.
+ */
+static inline bool kvm_ad_enabled(void)
+{
+	return shadow_accessed_mask;
+}
+
+/* see the comments on the generic kvm_arch_has_test_clear_young() */
+#define kvm_arch_has_test_clear_young kvm_arch_has_test_clear_young
+static inline bool kvm_arch_has_test_clear_young(void)
+{
+	return IS_ENABLED(CONFIG_KVM) && IS_ENABLED(CONFIG_X86_64) &&
+	       (!IS_REACHABLE(CONFIG_KVM) || (kvm_ad_enabled() && tdp_enabled));
+}
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 6f54dc9409c9..0dc7fed1f3fd 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -153,7 +153,6 @@ extern u64 __read_mostly shadow_mmu_writable_mask;
 extern u64 __read_mostly shadow_nx_mask;
 extern u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
 extern u64 __read_mostly shadow_user_mask;
-extern u64 __read_mostly shadow_accessed_mask;
 extern u64 __read_mostly shadow_dirty_mask;
 extern u64 __read_mostly shadow_mmio_value;
 extern u64 __read_mostly shadow_mmio_mask;
@@ -247,17 +246,6 @@ static inline bool is_shadow_present_pte(u64 pte)
 	return !!(pte & SPTE_MMU_PRESENT_MASK);
 }
 
-/*
- * Returns true if A/D bits are supported in hardware and are enabled by KVM.
- * When enabled, KVM uses A/D bits for all non-nested MMUs.  Because L1 can
- * disable A/D bits in EPTP12, SP and SPTE variants are needed to handle the
- * scenario where KVM is using A/D bits for L1, but not L2.
- */
-static inline bool kvm_ad_enabled(void)
-{
-	return !!shadow_accessed_mask;
-}
-
 static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
 {
 	return sp->role.ad_disabled;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d6df38d371a0..9028e09f1aab 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1309,6 +1309,47 @@ bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	return kvm_tdp_mmu_handle_gfn(kvm, range, age_gfn_range);
 }
 
+bool kvm_arch_test_clear_young(struct kvm *kvm, struct kvm_gfn_range *range,
+			       gfn_t lsb_gfn, unsigned long *bitmap)
+{
+	struct kvm_mmu_page *root;
+
+	if (WARN_ON_ONCE(!kvm_arch_has_test_clear_young()))
+		return false;
+
+	if (kvm_memslots_have_rmaps(kvm))
+		return false;
+
+	/* see the comments on kvm_arch->tdp_mmu_roots */
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(root, &kvm->arch.tdp_mmu_roots, link) {
+		struct tdp_iter iter;
+
+		if (kvm_mmu_page_as_id(root) != range->slot->as_id)
+			continue;
+
+		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end) {
+			u64 *sptep = rcu_dereference(iter.sptep);
+			u64 new_spte = iter.old_spte & ~shadow_accessed_mask;
+
+			VM_WARN_ON_ONCE(!page_count(virt_to_page(sptep)));
+			VM_WARN_ON_ONCE(iter.gfn < range->start || iter.gfn >= range->end);
+
+			if (new_spte == iter.old_spte)
+				continue;
+
+			/* see the comments on the generic kvm_arch_has_test_clear_young() */
+			if (__test_and_change_bit(lsb_gfn - iter.gfn, bitmap))
+				cmpxchg64(sptep, iter.old_spte, new_spte);
+		}
+	}
+
+	rcu_read_unlock();
+
+	return true;
+}
+
 static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter,
 			 struct kvm_gfn_range *range)
 {
-- 
2.39.2.637.g21b0678d19-goog

