Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFC7647684
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiLHTj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:39:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiLHTjr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:39:47 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3331AA10
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:39:32 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id a4-20020a5b0004000000b006fdc6aaec4fso2546656ybp.20
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 11:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7lWdJkZrv9HoLXNU6i6MkXoxSJstT9R2oUrEFqSahss=;
        b=sg2xkDze7H4yV2lU/1/FpCU1cOSTt2gM7RO9hSQj+EGldzLsfkQyRpFJO1Dbgvo3W9
         PfOPbmNzoC3iMvnIaOngSfZ5LH9xb9dgFCEw9aEBhfSkfZa0p2LGFJNWmPsP0YUfDno9
         CQwSUJBX0kvzRAUmX2Me/KJgguCLZ+SfH2HWLEdPYDNzfjltbTnDARaVTFS5Gq443Bmi
         +QopmUV51BioUs/4b9KMy4gkmjkOujFVUjs6U8RTkqsv/HoGkTY5Ees6a9Iry1tmsH00
         Td9EkW5zbDJ4OlpNw/cjDC4i3Hi3OifKlsJcAx0502DGt1TlOCLOeHM0BRmhVJInz4qJ
         qvxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7lWdJkZrv9HoLXNU6i6MkXoxSJstT9R2oUrEFqSahss=;
        b=YlI4+iOungEoWrvjLnh2Pi1cpo3bctlPXz+iHwABXbatbaxXZZ1D3+VC35yTA5Q6uA
         OQhwQEP+EfzfNHkOxN5LYUz69EJxb9fgFIHYAPfvlpzgBeIdE7P8QHdcgrpNX3cqbNkX
         zF8exGkbehk4VDrUuFi5vadpVni3XTln0FmYysBpU8hXmySCU7yFfBgd5lLra9umOxaj
         fcxQ31phNz6WICEERlqpIpk2T3PDq/EmPzAMepkPUGLguRDChcBfVTKjKRgDbzOX9GYr
         KurTqePe34RBRKO/ApVPj9218dmT4DxYpJcIP82RGUxhMpS4N24x+GhOvncBHDbhZPZI
         O6yQ==
X-Gm-Message-State: ANoB5pk2E9ygbcr2WJCP/7UR866QDY58a6yQxF8fCX5lGYIv51wJ57gs
        Tzi5JnaVl2hCAQVFVTUCYNZ8g8/l3MaNsw==
X-Google-Smtp-Source: AA0mqf63KmdX+eJrD5nf7+2lHNPi/RXEFfkP5c0ill5ei/9dZE+wqXzEkU41M9xqISk+TkkYSOsMnafoSWus4A==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:1884:0:b0:6ef:c66f:e0fa with SMTP id
 126-20020a251884000000b006efc66fe0famr68123962yby.3.1670528371737; Thu, 08
 Dec 2022 11:39:31 -0800 (PST)
Date:   Thu,  8 Dec 2022 11:38:35 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-16-dmatlack@google.com>
Subject: [RFC PATCH 15/37] KVM: x86/mmu: Add a common API for
 inspecting/modifying TDP PTEs
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
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

Introduce an API for inspecting and modifying TDP PTEs from common code.
This will be used in future commits to move the TDP MMU to common code.

Specifically, introduce the following API that can be used in common
code:

  /* Inspection API */
  tdp_pte_is_present()
  tdp_pte_is_writable()
  tdp_pte_is_huge()
  tdp_pte_is_leaf()
  tdp_pte_is_accessed()
  tdp_pte_is_dirty()
  tdp_pte_is_mmio()
  tdp_pte_is_volatile()
  tdp_pte_to_pfn()
  tdp_pte_check_leaf_invariants()

  /* Modification API */
  tdp_pte_clear_writable()
  tdp_pte_clear_mmu_writable()
  tdp_pte_clear_dirty()
  tdp_pte_clear_accessed()

Note that this does not cover constructing PTEs from scratch (e.g.
during page fault handling). This will be added in a subsequent commit.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm/tdp_pgtable.h |  58 +++++++++
 arch/x86/kvm/Makefile                  |   2 +-
 arch/x86/kvm/mmu/spte.c                |   3 +-
 arch/x86/kvm/mmu/spte.h                |  22 ----
 arch/x86/kvm/mmu/tdp_iter.c            |   4 +-
 arch/x86/kvm/mmu/tdp_iter.h            |   5 +-
 arch/x86/kvm/mmu/tdp_mmu.c             | 171 +++++++++++--------------
 arch/x86/kvm/mmu/tdp_pgtable.c         |  72 +++++++++++
 include/kvm/tdp_pgtable.h              |  18 +++
 9 files changed, 231 insertions(+), 124 deletions(-)
 create mode 100644 arch/x86/include/asm/kvm/tdp_pgtable.h
 create mode 100644 arch/x86/kvm/mmu/tdp_pgtable.c

diff --git a/arch/x86/include/asm/kvm/tdp_pgtable.h b/arch/x86/include/asm/kvm/tdp_pgtable.h
new file mode 100644
index 000000000000..cebc4bc44b49
--- /dev/null
+++ b/arch/x86/include/asm/kvm/tdp_pgtable.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_KVM_TDP_PGTABLE_H
+#define __ASM_KVM_TDP_PGTABLE_H
+
+#include <linux/types.h>
+#include <linux/kvm_types.h>
+
+/*
+ * Use a semi-arbitrary value that doesn't set RWX bits, i.e. is not-present on
+ * both AMD and Intel CPUs, and doesn't set PFN bits, i.e. doesn't create a L1TF
+ * vulnerability.  Use only low bits to avoid 64-bit immediates.
+ */
+#define REMOVED_TDP_PTE		0x5a0ULL
+
+#define TDP_PTE_WRITABLE_MASK	BIT_ULL(1)
+#define TDP_PTE_HUGE_PAGE_MASK	BIT_ULL(7)
+#define TDP_PTE_PRESENT_MASK	BIT_ULL(11)
+
+static inline bool tdp_pte_is_writable(u64 pte)
+{
+	return pte & TDP_PTE_WRITABLE_MASK;
+}
+
+static inline bool tdp_pte_is_huge(u64 pte)
+{
+	return pte & TDP_PTE_HUGE_PAGE_MASK;
+}
+
+static inline bool tdp_pte_is_present(u64 pte)
+{
+	return pte & TDP_PTE_PRESENT_MASK;
+}
+
+bool tdp_pte_is_accessed(u64 pte);
+bool tdp_pte_is_dirty(u64 pte);
+bool tdp_pte_is_mmio(u64 pte);
+bool tdp_pte_is_volatile(u64 pte);
+
+static inline u64 tdp_pte_clear_writable(u64 pte)
+{
+	return pte & ~TDP_PTE_WRITABLE_MASK;
+}
+
+static inline u64 tdp_pte_clear_mmu_writable(u64 pte)
+{
+	extern u64 __read_mostly shadow_mmu_writable_mask;
+
+	return pte & ~(TDP_PTE_WRITABLE_MASK | shadow_mmu_writable_mask);
+}
+
+u64 tdp_pte_clear_dirty(u64 pte, bool force_wrprot);
+u64 tdp_pte_clear_accessed(u64 pte);
+
+kvm_pfn_t tdp_pte_to_pfn(u64 pte);
+
+void tdp_pte_check_leaf_invariants(u64 pte);
+
+#endif /* !__ASM_KVM_TDP_PGTABLE_H */
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 80e3fe184d17..c294ae51caba 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -18,7 +18,7 @@ ifdef CONFIG_HYPERV
 kvm-y			+= kvm_onhyperv.o
 endif
 
-kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
+kvm-$(CONFIG_X86_64) += mmu/tdp_pgtable.o mmu/tdp_iter.o mmu/tdp_mmu.o
 kvm-$(CONFIG_KVM_XEN)	+= xen.o
 kvm-$(CONFIG_KVM_SMM)	+= smm.o
 
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index fe4b626cb431..493e109f1105 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -10,6 +10,7 @@
 
 
 #include <linux/kvm_host.h>
+#include <kvm/tdp_pgtable.h>
 #include "mmu.h"
 #include "mmu_internal.h"
 #include "x86.h"
@@ -401,7 +402,7 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
 	 * not set any RWX bits.
 	 */
 	if (WARN_ON((mmio_value & mmio_mask) != mmio_value) ||
-	    WARN_ON(mmio_value && (REMOVED_SPTE & mmio_mask) == mmio_value))
+	    WARN_ON(mmio_value && (REMOVED_TDP_PTE & mmio_mask) == mmio_value))
 		mmio_value = 0;
 
 	if (!mmio_value)
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 4c5d518e3ac6..a1b7d7730583 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -183,28 +183,6 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
  */
 #define SHADOW_NONPRESENT_OR_RSVD_MASK_LEN 5
 
-/*
- * If a thread running without exclusive control of the MMU lock must perform a
- * multi-part operation on an SPTE, it can set the SPTE to REMOVED_SPTE as a
- * non-present intermediate value. Other threads which encounter this value
- * should not modify the SPTE.
- *
- * Use a semi-arbitrary value that doesn't set RWX bits, i.e. is not-present on
- * both AMD and Intel CPUs, and doesn't set PFN bits, i.e. doesn't create a L1TF
- * vulnerability.  Use only low bits to avoid 64-bit immediates.
- *
- * Only used by the TDP MMU.
- */
-#define REMOVED_SPTE	0x5a0ULL
-
-/* Removed SPTEs must not be misconstrued as shadow present PTEs. */
-static_assert(!(REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
-
-static inline bool is_removed_spte(u64 spte)
-{
-	return spte == REMOVED_SPTE;
-}
-
 /* Get an SPTE's index into its parent's page table (and the spt array). */
 static inline int spte_index(u64 *sptep)
 {
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index d6328dac9cd3..d5f024b7f6e4 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -69,10 +69,10 @@ tdp_ptep_t spte_to_child_pt(u64 spte, int level)
 	 * There's no child entry if this entry isn't present or is a
 	 * last-level entry.
 	 */
-	if (!is_shadow_present_pte(spte) || is_last_spte(spte, level))
+	if (!tdp_pte_is_present(spte) || tdp_pte_is_leaf(spte, level))
 		return NULL;
 
-	return (tdp_ptep_t)__va(spte_to_pfn(spte) << PAGE_SHIFT);
+	return (tdp_ptep_t)__va(tdp_pte_to_pfn(spte) << PAGE_SHIFT);
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index bfac83ab52db..6e3c38532d1d 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -45,8 +45,9 @@ static inline u64 kvm_tdp_mmu_write_spte(tdp_ptep_t sptep, u64 old_spte,
 	 * logic needs to be reassessed if KVM were to use non-leaf Accessed
 	 * bits, e.g. to skip stepping down into child SPTEs when aging SPTEs.
 	 */
-	if (is_shadow_present_pte(old_spte) && is_last_spte(old_spte, level) &&
-	    spte_has_volatile_bits(old_spte))
+	if (tdp_pte_is_present(old_spte) &&
+	    tdp_pte_is_leaf(old_spte, level) &&
+	    tdp_pte_is_volatile(old_spte))
 		return kvm_tdp_mmu_write_spte_atomic(sptep, new_spte);
 
 	__kvm_tdp_mmu_write_spte(sptep, new_spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a6d6e393c009..fea42bbac984 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -334,13 +334,13 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 
 static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
 {
-	if (!is_shadow_present_pte(old_spte) || !is_last_spte(old_spte, level))
+	if (!tdp_pte_is_present(old_spte) || !tdp_pte_is_leaf(old_spte, level))
 		return;
 
-	if (is_accessed_spte(old_spte) &&
-	    (!is_shadow_present_pte(new_spte) || !is_accessed_spte(new_spte) ||
-	     spte_to_pfn(old_spte) != spte_to_pfn(new_spte)))
-		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
+	if (tdp_pte_is_accessed(old_spte) &&
+	    (!tdp_pte_is_present(new_spte) || !tdp_pte_is_accessed(new_spte) ||
+	     tdp_pte_to_pfn(old_spte) != tdp_pte_to_pfn(new_spte)))
+		kvm_set_pfn_accessed(tdp_pte_to_pfn(old_spte));
 }
 
 static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
@@ -352,10 +352,10 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 	if (level > PG_LEVEL_PTE)
 		return;
 
-	pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
+	pfn_changed = tdp_pte_to_pfn(old_spte) != tdp_pte_to_pfn(new_spte);
 
-	if ((!is_writable_pte(old_spte) || pfn_changed) &&
-	    is_writable_pte(new_spte)) {
+	if ((!tdp_pte_is_writable(old_spte) || pfn_changed) &&
+	    tdp_pte_is_writable(new_spte)) {
 		slot = __gfn_to_memslot(__kvm_memslots(kvm, as_id), gfn);
 		mark_page_dirty_in_slot(kvm, slot, gfn);
 	}
@@ -445,8 +445,8 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 			 * value to the removed SPTE value.
 			 */
 			for (;;) {
-				old_spte = kvm_tdp_mmu_write_spte_atomic(sptep, REMOVED_SPTE);
-				if (!is_removed_spte(old_spte))
+				old_spte = kvm_tdp_mmu_write_spte_atomic(sptep, REMOVED_TDP_PTE);
+				if (!tdp_pte_is_removed(old_spte))
 					break;
 				cpu_relax();
 			}
@@ -461,7 +461,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 			 * unreachable.
 			 */
 			old_spte = kvm_tdp_mmu_read_spte(sptep);
-			if (!is_shadow_present_pte(old_spte))
+			if (!tdp_pte_is_present(old_spte))
 				continue;
 
 			/*
@@ -481,7 +481,8 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 			 * strictly necessary for the same reason, but using
 			 * the remove SPTE value keeps the shared/exclusive
 			 * paths consistent and allows the handle_changed_spte()
-			 * call below to hardcode the new value to REMOVED_SPTE.
+			 * call below to hardcode the new value to
+			 * REMOVED_TDP_PTE.
 			 *
 			 * Note, even though dropping a Dirty bit is the only
 			 * scenario where a non-atomic update could result in a
@@ -493,10 +494,11 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 			 * it here.
 			 */
 			old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte,
-							  REMOVED_SPTE, level);
+							  REMOVED_TDP_PTE,
+							  level);
 		}
 		handle_changed_spte(kvm, sp->role.as_id, gfn, old_spte,
-				    REMOVED_SPTE, level, shared);
+				    REMOVED_TDP_PTE, level, shared);
 	}
 
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
@@ -521,11 +523,11 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				  u64 old_spte, u64 new_spte, int level,
 				  bool shared)
 {
-	bool was_present = is_shadow_present_pte(old_spte);
-	bool is_present = is_shadow_present_pte(new_spte);
-	bool was_leaf = was_present && is_last_spte(old_spte, level);
-	bool is_leaf = is_present && is_last_spte(new_spte, level);
-	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
+	bool was_present = tdp_pte_is_present(old_spte);
+	bool is_present = tdp_pte_is_present(new_spte);
+	bool was_leaf = was_present && tdp_pte_is_leaf(old_spte, level);
+	bool is_leaf = is_present && tdp_pte_is_leaf(new_spte, level);
+	bool pfn_changed = tdp_pte_to_pfn(old_spte) != tdp_pte_to_pfn(new_spte);
 
 	WARN_ON(level > TDP_ROOT_MAX_LEVEL);
 	WARN_ON(level < PG_LEVEL_PTE);
@@ -560,7 +562,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	trace_kvm_tdp_mmu_spte_changed(as_id, gfn, level, old_spte, new_spte);
 
 	if (is_leaf)
-		check_spte_writable_invariants(new_spte);
+		tdp_pte_check_leaf_invariants(new_spte);
 
 	/*
 	 * The only times a SPTE should be changed from a non-present to
@@ -574,9 +576,9 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 		 * impact the guest since both the former and current SPTEs
 		 * are nonpresent.
 		 */
-		if (WARN_ON(!is_mmio_spte(old_spte) &&
-			    !is_mmio_spte(new_spte) &&
-			    !is_removed_spte(new_spte)))
+		if (WARN_ON(!tdp_pte_is_mmio(old_spte) &&
+			    !tdp_pte_is_mmio(new_spte) &&
+			    !tdp_pte_is_removed(new_spte)))
 			pr_err("Unexpected SPTE change! Nonpresent SPTEs\n"
 			       "should not be replaced with another,\n"
 			       "different nonpresent SPTE, unless one or both\n"
@@ -590,9 +592,9 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	if (is_leaf != was_leaf)
 		kvm_update_page_stats(kvm, level, is_leaf ? 1 : -1);
 
-	if (was_leaf && is_dirty_spte(old_spte) &&
-	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
-		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
+	if (was_leaf && tdp_pte_is_dirty(old_spte) &&
+	    (!is_present || !tdp_pte_is_dirty(new_spte) || pfn_changed))
+		kvm_set_pfn_dirty(tdp_pte_to_pfn(old_spte));
 
 	/*
 	 * Recursively handle child PTs if the change removed a subtree from
@@ -645,7 +647,7 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	 * and pre-checking before inserting a new SPTE is advantageous as it
 	 * avoids unnecessary work.
 	 */
-	WARN_ON_ONCE(iter->yielded || is_removed_spte(iter->old_spte));
+	WARN_ON_ONCE(iter->yielded || tdp_pte_is_removed(iter->old_spte));
 
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
@@ -674,7 +676,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 * immediately installing a present entry in its place
 	 * before the TLBs are flushed.
 	 */
-	ret = tdp_mmu_set_spte_atomic(kvm, iter, REMOVED_SPTE);
+	ret = tdp_mmu_set_spte_atomic(kvm, iter, REMOVED_TDP_PTE);
 	if (ret)
 		return ret;
 
@@ -730,7 +732,7 @@ static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 	 * should be used. If operating under the MMU lock in write mode, the
 	 * use of the removed SPTE should not be necessary.
 	 */
-	WARN_ON(is_removed_spte(old_spte) || is_removed_spte(new_spte));
+	WARN_ON(tdp_pte_is_removed(old_spte) || tdp_pte_is_removed(new_spte));
 
 	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
 
@@ -781,8 +783,8 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 
 #define tdp_root_for_each_leaf_pte(_iter, _root, _start, _end)	\
 	tdp_root_for_each_pte(_iter, _root, _start, _end)		\
-		if (!is_shadow_present_pte(_iter.old_spte) ||		\
-		    !is_last_spte(_iter.old_spte, _iter.level))		\
+		if (!tdp_pte_is_present(_iter.old_spte) ||		\
+		    !tdp_pte_is_leaf(_iter.old_spte, _iter.level))		\
 			continue;					\
 		else
 
@@ -858,7 +860,7 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
 
-		if (!is_shadow_present_pte(iter.old_spte))
+		if (!tdp_pte_is_present(iter.old_spte))
 			continue;
 
 		if (iter.level > zap_level)
@@ -919,7 +921,7 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 		return false;
 
 	old_spte = kvm_tdp_mmu_read_spte(sp->ptep);
-	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte)))
+	if (WARN_ON_ONCE(!tdp_pte_is_present(old_spte)))
 		return false;
 
 	__tdp_mmu_set_spte(kvm, sp->role.as_id, sp->ptep, old_spte, 0,
@@ -953,8 +955,8 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 			continue;
 		}
 
-		if (!is_shadow_present_pte(iter.old_spte) ||
-		    !is_last_spte(iter.old_spte, iter.level))
+		if (!tdp_pte_is_present(iter.old_spte) ||
+		    !tdp_pte_is_leaf(iter.old_spte, iter.level))
 			continue;
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
@@ -1074,8 +1076,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 		ret = RET_PF_SPURIOUS;
 	else if (tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
 		return RET_PF_RETRY;
-	else if (is_shadow_present_pte(iter->old_spte) &&
-		 !is_last_spte(iter->old_spte, iter->level))
+	else if (tdp_pte_is_present(iter->old_spte) &&
+		 !tdp_pte_is_leaf(iter->old_spte, iter->level))
 		kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
 						   TDP_PAGES_PER_LEVEL(iter->level + 1));
 
@@ -1090,7 +1092,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	}
 
 	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
-	if (unlikely(is_mmio_spte(new_spte))) {
+	if (unlikely(tdp_pte_is_mmio(new_spte))) {
 		vcpu->stat.pf_mmio_spte_created++;
 		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
 				     new_spte);
@@ -1168,12 +1170,12 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * If SPTE has been frozen by another thread, just give up and
 		 * retry, avoiding unnecessary page table allocation and free.
 		 */
-		if (is_removed_spte(iter.old_spte))
+		if (tdp_pte_is_removed(iter.old_spte))
 			goto retry;
 
 		/* Step down into the lower level page table if it exists. */
-		if (is_shadow_present_pte(iter.old_spte) &&
-		    !is_large_pte(iter.old_spte))
+		if (tdp_pte_is_present(iter.old_spte) &&
+		    !tdp_pte_is_huge(iter.old_spte))
 			continue;
 
 		/*
@@ -1185,7 +1187,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 		sp->arch.nx_huge_page_disallowed = fault->arch.huge_page_disallowed;
 
-		if (is_shadow_present_pte(iter.old_spte))
+		if (tdp_pte_is_present(iter.old_spte))
 			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
 		else
 			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
@@ -1207,6 +1209,15 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 	}
 
+	/*
+	 * Force the guest to retry the access if the upper level SPTEs aren't
+	 * in place, or if the target leaf SPTE is frozen by another CPU.
+	 */
+	if (iter.level != fault->goal_level || tdp_pte_is_removed(iter.old_spte)) {
+		rcu_read_unlock();
+		return RET_PF_RETRY;
+	}
+
 	ret = tdp_mmu_map_handle_target_level(vcpu, fault, &iter);
 
 retry:
@@ -1255,27 +1266,13 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 			  struct kvm_gfn_range *range)
 {
-	u64 new_spte = 0;
+	u64 new_spte;
 
 	/* If we have a non-accessed entry we don't need to change the pte. */
-	if (!is_accessed_spte(iter->old_spte))
+	if (!tdp_pte_is_accessed(iter->old_spte))
 		return false;
 
-	new_spte = iter->old_spte;
-
-	if (spte_ad_enabled(new_spte)) {
-		new_spte &= ~shadow_accessed_mask;
-	} else {
-		/*
-		 * Capture the dirty status of the page, so that it doesn't get
-		 * lost when the SPTE is marked for access tracking.
-		 */
-		if (is_writable_pte(new_spte))
-			kvm_set_pfn_dirty(spte_to_pfn(new_spte));
-
-		new_spte = mark_spte_for_access_track(new_spte);
-	}
-
+	new_spte = tdp_pte_clear_accessed(iter->old_spte);
 	tdp_mmu_set_spte_no_acc_track(kvm, iter, new_spte);
 
 	return true;
@@ -1289,7 +1286,7 @@ bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter,
 			 struct kvm_gfn_range *range)
 {
-	return is_accessed_spte(iter->old_spte);
+	return tdp_pte_is_accessed(iter->old_spte);
 }
 
 bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -1306,7 +1303,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
 	WARN_ON(pte_huge(range->pte) || range->start + 1 != range->end);
 
 	if (iter->level != PG_LEVEL_PTE ||
-	    !is_shadow_present_pte(iter->old_spte))
+	    !tdp_pte_is_present(iter->old_spte))
 		return false;
 
 	/*
@@ -1364,12 +1361,12 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
-		if (!is_shadow_present_pte(iter.old_spte) ||
-		    !is_last_spte(iter.old_spte, iter.level) ||
-		    !(iter.old_spte & PT_WRITABLE_MASK))
+		if (!tdp_pte_is_present(iter.old_spte) ||
+		    !tdp_pte_is_leaf(iter.old_spte, iter.level) ||
+		    !tdp_pte_is_writable(iter.old_spte))
 			continue;
 
-		new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
+		new_spte = tdp_pte_clear_writable(iter.old_spte);
 
 		if (tdp_mmu_set_spte_atomic(kvm, &iter, new_spte))
 			goto retry;
@@ -1525,7 +1522,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
 
-		if (!is_shadow_present_pte(iter.old_spte) || !is_large_pte(iter.old_spte))
+		if (!tdp_pte_is_present(iter.old_spte) || !tdp_pte_is_huge(iter.old_spte))
 			continue;
 
 		if (!sp) {
@@ -1607,20 +1604,12 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
-		if (!is_shadow_present_pte(iter.old_spte))
+		if (!tdp_pte_is_present(iter.old_spte))
 			continue;
 
-		if (spte_ad_need_write_protect(iter.old_spte)) {
-			if (is_writable_pte(iter.old_spte))
-				new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
-			else
-				continue;
-		} else {
-			if (iter.old_spte & shadow_dirty_mask)
-				new_spte = iter.old_spte & ~shadow_dirty_mask;
-			else
-				continue;
-		}
+		new_spte = tdp_pte_clear_dirty(iter.old_spte, false);
+		if (new_spte == iter.old_spte)
+			continue;
 
 		if (tdp_mmu_set_spte_atomic(kvm, &iter, new_spte))
 			goto retry;
@@ -1680,17 +1669,9 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		mask &= ~(1UL << (iter.gfn - gfn));
 
-		if (wrprot || spte_ad_need_write_protect(iter.old_spte)) {
-			if (is_writable_pte(iter.old_spte))
-				new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
-			else
-				continue;
-		} else {
-			if (iter.old_spte & shadow_dirty_mask)
-				new_spte = iter.old_spte & ~shadow_dirty_mask;
-			else
-				continue;
-		}
+		new_spte = tdp_pte_clear_dirty(iter.old_spte, wrprot);
+		if (new_spte == iter.old_spte)
+			continue;
 
 		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
 	}
@@ -1734,7 +1715,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 			continue;
 
 		if (iter.level > TDP_MAX_HUGEPAGE_LEVEL ||
-		    !is_shadow_present_pte(iter.old_spte))
+		    !tdp_pte_is_present(iter.old_spte))
 			continue;
 
 		/*
@@ -1742,7 +1723,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 		 * a large page size, then its parent would have been zapped
 		 * instead of stepping down.
 		 */
-		if (is_last_spte(iter.old_spte, iter.level))
+		if (tdp_pte_is_leaf(iter.old_spte, iter.level))
 			continue;
 
 		/*
@@ -1800,13 +1781,11 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 	rcu_read_lock();
 
 	for_each_tdp_pte_min_level(iter, root, min_level, gfn, gfn + 1) {
-		if (!is_shadow_present_pte(iter.old_spte) ||
-		    !is_last_spte(iter.old_spte, iter.level))
+		if (!tdp_pte_is_present(iter.old_spte) ||
+		    !tdp_pte_is_leaf(iter.old_spte, iter.level))
 			continue;
 
-		new_spte = iter.old_spte &
-			~(PT_WRITABLE_MASK | shadow_mmu_writable_mask);
-
+		new_spte = tdp_pte_clear_mmu_writable(iter.old_spte);
 		if (new_spte == iter.old_spte)
 			break;
 
diff --git a/arch/x86/kvm/mmu/tdp_pgtable.c b/arch/x86/kvm/mmu/tdp_pgtable.c
new file mode 100644
index 000000000000..cf3b692d8e21
--- /dev/null
+++ b/arch/x86/kvm/mmu/tdp_pgtable.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/kvm_types.h>
+#include <kvm/tdp_pgtable.h>
+
+#include "mmu.h"
+#include "spte.h"
+
+/* Removed SPTEs must not be misconstrued as shadow present PTEs. */
+static_assert(!(REMOVED_TDP_PTE & SPTE_MMU_PRESENT_MASK));
+
+static_assert(TDP_PTE_WRITABLE_MASK == PT_WRITABLE_MASK);
+static_assert(TDP_PTE_HUGE_PAGE_MASK == PT_PAGE_SIZE_MASK);
+static_assert(TDP_PTE_PRESENT_MASK == SPTE_MMU_PRESENT_MASK);
+
+bool tdp_pte_is_accessed(u64 pte)
+{
+	return is_accessed_spte(pte);
+}
+
+bool tdp_pte_is_dirty(u64 pte)
+{
+	return is_dirty_spte(pte);
+}
+
+bool tdp_pte_is_mmio(u64 pte)
+{
+	return is_mmio_spte(pte);
+}
+
+bool tdp_pte_is_volatile(u64 pte)
+{
+	return spte_has_volatile_bits(pte);
+}
+
+u64 tdp_pte_clear_dirty(u64 pte, bool force_wrprot)
+{
+	if (force_wrprot || spte_ad_need_write_protect(pte)) {
+		if (tdp_pte_is_writable(pte))
+			pte &= ~PT_WRITABLE_MASK;
+	} else if (pte & shadow_dirty_mask) {
+		pte &= ~shadow_dirty_mask;
+	}
+
+	return pte;
+}
+
+u64 tdp_pte_clear_accessed(u64 old_spte)
+{
+	if (spte_ad_enabled(old_spte))
+		return old_spte & ~shadow_accessed_mask;
+
+	/*
+	 * Capture the dirty status of the page, so that it doesn't get lost
+	 * when the SPTE is marked for access tracking.
+	 */
+	if (tdp_pte_is_writable(old_spte))
+		kvm_set_pfn_dirty(tdp_pte_to_pfn(old_spte));
+
+	return mark_spte_for_access_track(old_spte);
+}
+
+kvm_pfn_t tdp_pte_to_pfn(u64 pte)
+{
+	return spte_to_pfn(pte);
+}
+
+void tdp_pte_check_leaf_invariants(u64 pte)
+{
+	check_spte_writable_invariants(pte);
+}
+
diff --git a/include/kvm/tdp_pgtable.h b/include/kvm/tdp_pgtable.h
index 968be8d92350..a24c45ac7765 100644
--- a/include/kvm/tdp_pgtable.h
+++ b/include/kvm/tdp_pgtable.h
@@ -5,6 +5,8 @@
 #include <linux/log2.h>
 #include <linux/mm_types.h>
 
+#include <asm/kvm/tdp_pgtable.h>
+
 #define TDP_ROOT_MAX_LEVEL	5
 #define TDP_MAX_HUGEPAGE_LEVEL	PG_LEVEL_PUD
 #define TDP_PTES_PER_PAGE	(PAGE_SIZE / sizeof(u64))
@@ -18,4 +20,20 @@
 #define TDP_PTE_INDEX(gfn, level) \
 	(((gfn) >> TDP_LEVEL_SHIFT(level)) & TDP_LEVEL_MASK)
 
+/*
+ * If a thread running without exclusive control of the MMU lock must perform a
+ * multi-part operation on a PTE, it can set the PTE to REMOVED_TDP_PTE as a
+ * non-present intermediate value. Other threads which encounter this value
+ * should not modify the PTE.
+ */
+static inline bool tdp_pte_is_removed(u64 pte)
+{
+	return pte == REMOVED_TDP_PTE;
+}
+
+static inline bool tdp_pte_is_leaf(u64 pte, int level)
+{
+	return tdp_pte_is_huge(pte) || level == PG_LEVEL_PTE;
+}
+
 #endif /* !__KVM_TDP_PGTABLE_H */
-- 
2.39.0.rc1.256.g54fd8350bd-goog

