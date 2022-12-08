Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09093647658
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 20:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiLHTjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 14:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiLHTjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 14:39:15 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C163F87CAC
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 11:39:11 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-40306a5a42cso24914317b3.1
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 11:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KqovNnYNqiZvNY+3x4jGBZSOBKhorYQcOMdDmlAeVA0=;
        b=blsWKuOuU9nBfjbx2ZvfooJjVg/Tk7E29BOlxwM52Mh4m9Gy5w5cZYlxndBsSY4dqj
         e/snZkpg/KsxnZBVk09yrntro8xgrBBTRp5xNEMxknp2oiInXsh0BQib9Zuq2shGBlMv
         ofp5dMV6pJa5cUvPDQu4p/P+faSALpbfpnCxIGMXnkbnc7HQyL87OTHgk2gjRv+9DgR1
         zf4uWQPBfjDRAZz+kjct5rkcc6EWfXyC3sEt34sMJVMmqD20+jFh4bXPCHCtCQ4GAnOo
         vwg2XNZUbi9JTdc7rdOMCw99CjFWBWO6dpclFuZV2ap5LsvN1Gj8H3CGg4gY3kJabJ5+
         3Gnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KqovNnYNqiZvNY+3x4jGBZSOBKhorYQcOMdDmlAeVA0=;
        b=iEnGb0c3CZ22Qq7q7PtxQvbYQDXTIvfxi3N0Ugi6+qS0yirGYNoVIgYYhVVKyGGd+b
         aQaj4JXKJX4RY7AHabl/tsfuPco13C40g9yA+h2KZOxJHe9+sDGHHqtDFfV9uAFRWjmz
         /0ZKCKjOMZOvaCFfAMc+9X2fO1Pp3Lqbp4JylrJP0l9tWxpJ+JoNlsHgkNgD2yuVKV1S
         RZs3g9yAxQ187076Hcdi7zptGRYJH0C1ulJrD2k7+H91aoyVZcJzLP8P6mdMw/zE2yow
         THD2689y7i3SP4jQHHlnwnI+fB7DCI3ppmRwMXOUqI+ojKPJQVMZER7oh/4pNFxeWrYw
         xh1Q==
X-Gm-Message-State: ANoB5pkpE8avXVXEIOe+NEJMJ5QYxbkFt6hUDSCFr1opi9Nj+yyctdkA
        v5yLOS9y+I/FuVQPhIDG6k7JVsQvBoSR3w==
X-Google-Smtp-Source: AA0mqf40e1aWU3nMj030gXIfYJtDxcpJg/DK+IU9dwsqtYBiXfIBVm5+sqf++gOtXR+kPXfwZNzYqWMa6cBzLw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:e755:0:b0:6f1:2a94:40f2 with SMTP id
 e82-20020a25e755000000b006f12a9440f2mr65803947ybh.332.1670528350927; Thu, 08
 Dec 2022 11:39:10 -0800 (PST)
Date:   Thu,  8 Dec 2022 11:38:22 -0800
In-Reply-To: <20221208193857.4090582-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221208193857.4090582-3-dmatlack@google.com>
Subject: [RFC PATCH 02/37] KVM: MMU: Move struct kvm_mmu_page_role into common code
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

Move struct kvm_mmu_page_role into common code, and move all
x86-specific fields into a separate sub-struct within the role,
kvm_mmu_page_role_arch.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 MAINTAINERS                          |   4 +-
 arch/x86/include/asm/kvm/mmu_types.h |  56 ++++++++++
 arch/x86/include/asm/kvm_host.h      |  68 +-----------
 arch/x86/kvm/mmu/mmu.c               | 156 +++++++++++++--------------
 arch/x86/kvm/mmu/mmu_internal.h      |   4 +-
 arch/x86/kvm/mmu/mmutrace.h          |  12 +--
 arch/x86/kvm/mmu/paging_tmpl.h       |  20 ++--
 arch/x86/kvm/mmu/spte.c              |   4 +-
 arch/x86/kvm/mmu/spte.h              |   2 +-
 arch/x86/kvm/x86.c                   |   8 +-
 include/kvm/mmu_types.h              |  37 +++++++
 11 files changed, 202 insertions(+), 169 deletions(-)
 create mode 100644 arch/x86/include/asm/kvm/mmu_types.h
 create mode 100644 include/kvm/mmu_types.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 89672a59c0c3..7e586d7ba78c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11198,7 +11198,8 @@ W:	http://www.linux-kvm.org
 T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
 F:	Documentation/virt/kvm/
 F:	include/asm-generic/kvm*
-F:	include/kvm/iodev.h
+F:	include/kvm/
+X:	include/kvm/arm_*
 F:	include/linux/kvm*
 F:	include/trace/events/kvm.h
 F:	include/uapi/asm-generic/kvm*
@@ -11285,6 +11286,7 @@ L:	kvm@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
 F:	arch/x86/include/asm/kvm*
+F:	arch/x86/include/asm/kvm/
 F:	arch/x86/include/asm/svm.h
 F:	arch/x86/include/asm/vmx*.h
 F:	arch/x86/include/uapi/asm/kvm*
diff --git a/arch/x86/include/asm/kvm/mmu_types.h b/arch/x86/include/asm/kvm/mmu_types.h
new file mode 100644
index 000000000000..35f893ebab5a
--- /dev/null
+++ b/arch/x86/include/asm/kvm/mmu_types.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_KVM_MMU_TYPES_H
+#define __ASM_KVM_MMU_TYPES_H
+
+#include <linux/types.h>
+
+/*
+ * This is a subset of the overall kvm_cpu_role to minimize the size of
+ * kvm_memory_slot.arch.gfn_track, i.e. allows allocating 2 bytes per gfn
+ * instead of 4 bytes per gfn.
+ *
+ * Upper-level shadow pages having gptes are tracked for write-protection via
+ * gfn_track.  As above, gfn_track is a 16 bit counter, so KVM must not create
+ * more than 2^16-1 upper-level shadow pages at a single gfn, otherwise
+ * gfn_track will overflow and explosions will ensure.
+ *
+ * A unique shadow page (SP) for a gfn is created if and only if an existing SP
+ * cannot be reused.  The ability to reuse a SP is tracked by its role, which
+ * incorporates various mode bits and properties of the SP.  Roughly speaking,
+ * the number of unique SPs that can theoretically be created is 2^n, where n
+ * is the number of bits that are used to compute the role.
+ *
+ * Note, not all combinations of modes and flags below are possible:
+ *
+ *   - invalid shadow pages are not accounted, so the bits are effectively 18
+ *
+ *   - quadrant will only be used if has_4_byte_gpte=1 (non-PAE paging);
+ *     execonly and ad_disabled are only used for nested EPT which has
+ *     has_4_byte_gpte=0.  Therefore, 2 bits are always unused.
+ *
+ *   - the 4 bits of level are effectively limited to the values 2/3/4/5,
+ *     as 4k SPs are not tracked (allowed to go unsync).  In addition non-PAE
+ *     paging has exactly one upper level, making level completely redundant
+ *     when has_4_byte_gpte=1.
+ *
+ *   - on top of this, smep_andnot_wp and smap_andnot_wp are only set if
+ *     cr0_wp=0, therefore these three bits only give rise to 5 possibilities.
+ *
+ * Therefore, the maximum number of possible upper-level shadow pages for a
+ * single gfn is a bit less than 2^13.
+ */
+struct kvm_mmu_page_role_arch {
+	u16 has_4_byte_gpte:1;
+	u16 quadrant:2;
+	u16 direct:1;
+	u16 access:3;
+	u16 efer_nx:1;
+	u16 cr0_wp:1;
+	u16 smep_andnot_wp:1;
+	u16 smap_andnot_wp:1;
+	u16 ad_disabled:1;
+	u16 guest_mode:1;
+	u16 passthrough:1;
+};
+
+#endif /* !__ASM_KVM_MMU_TYPES_H */
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0a819d40131a..ebcd7a0dabef 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -37,6 +37,8 @@
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/hyperv-tlfs.h>
 
+#include <kvm/mmu_types.h>
+
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
 #define KVM_MAX_VCPUS 1024
@@ -286,72 +288,6 @@ enum x86_intercept_stage;
 
 struct kvm_kernel_irq_routing_entry;
 
-/*
- * kvm_mmu_page_role tracks the properties of a shadow page (where shadow page
- * also includes TDP pages) to determine whether or not a page can be used in
- * the given MMU context.  This is a subset of the overall kvm_cpu_role to
- * minimize the size of kvm_memory_slot.arch.gfn_track, i.e. allows allocating
- * 2 bytes per gfn instead of 4 bytes per gfn.
- *
- * Upper-level shadow pages having gptes are tracked for write-protection via
- * gfn_track.  As above, gfn_track is a 16 bit counter, so KVM must not create
- * more than 2^16-1 upper-level shadow pages at a single gfn, otherwise
- * gfn_track will overflow and explosions will ensure.
- *
- * A unique shadow page (SP) for a gfn is created if and only if an existing SP
- * cannot be reused.  The ability to reuse a SP is tracked by its role, which
- * incorporates various mode bits and properties of the SP.  Roughly speaking,
- * the number of unique SPs that can theoretically be created is 2^n, where n
- * is the number of bits that are used to compute the role.
- *
- * But, even though there are 19 bits in the mask below, not all combinations
- * of modes and flags are possible:
- *
- *   - invalid shadow pages are not accounted, so the bits are effectively 18
- *
- *   - quadrant will only be used if has_4_byte_gpte=1 (non-PAE paging);
- *     execonly and ad_disabled are only used for nested EPT which has
- *     has_4_byte_gpte=0.  Therefore, 2 bits are always unused.
- *
- *   - the 4 bits of level are effectively limited to the values 2/3/4/5,
- *     as 4k SPs are not tracked (allowed to go unsync).  In addition non-PAE
- *     paging has exactly one upper level, making level completely redundant
- *     when has_4_byte_gpte=1.
- *
- *   - on top of this, smep_andnot_wp and smap_andnot_wp are only set if
- *     cr0_wp=0, therefore these three bits only give rise to 5 possibilities.
- *
- * Therefore, the maximum number of possible upper-level shadow pages for a
- * single gfn is a bit less than 2^13.
- */
-union kvm_mmu_page_role {
-	u32 word;
-	struct {
-		unsigned level:4;
-		unsigned has_4_byte_gpte:1;
-		unsigned quadrant:2;
-		unsigned direct:1;
-		unsigned access:3;
-		unsigned invalid:1;
-		unsigned efer_nx:1;
-		unsigned cr0_wp:1;
-		unsigned smep_andnot_wp:1;
-		unsigned smap_andnot_wp:1;
-		unsigned ad_disabled:1;
-		unsigned guest_mode:1;
-		unsigned passthrough:1;
-		unsigned :5;
-
-		/*
-		 * This is left at the top of the word so that
-		 * kvm_memslots_for_spte_role can extract it with a
-		 * simple shift.  While there is room, give it a whole
-		 * byte so it is also faster to load it from memory.
-		 */
-		unsigned as_id:8;
-	};
-};
-
 /*
  * kvm_mmu_extended_role complements kvm_mmu_page_role, tracking properties
  * relevant to the current MMU configuration.   When loading CR0, CR4, or EFER,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f375b719f565..355548603960 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -210,13 +210,13 @@ static inline bool __maybe_unused is_##reg##_##name(struct kvm_mmu *mmu)	\
 {								\
 	return !!(mmu->cpu_role. base_or_ext . reg##_##name);	\
 }
-BUILD_MMU_ROLE_ACCESSOR(base, cr0, wp);
+BUILD_MMU_ROLE_ACCESSOR(base.arch, cr0, wp);
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pse);
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smep);
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smap);
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pke);
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, la57);
-BUILD_MMU_ROLE_ACCESSOR(base, efer, nx);
+BUILD_MMU_ROLE_ACCESSOR(base.arch, efer, nx);
 BUILD_MMU_ROLE_ACCESSOR(ext,  efer, lma);
 
 static inline bool is_cr0_pg(struct kvm_mmu *mmu)
@@ -226,7 +226,7 @@ static inline bool is_cr0_pg(struct kvm_mmu *mmu)
 
 static inline bool is_cr4_pae(struct kvm_mmu *mmu)
 {
-        return !mmu->cpu_role.base.has_4_byte_gpte;
+	return !mmu->cpu_role.base.arch.has_4_byte_gpte;
 }
 
 static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
@@ -618,7 +618,7 @@ static bool mmu_spte_age(u64 *sptep)
 
 static inline bool is_tdp_mmu_active(struct kvm_vcpu *vcpu)
 {
-	return tdp_mmu_enabled && vcpu->arch.mmu->root_role.direct;
+	return tdp_mmu_enabled && vcpu->arch.mmu->root_role.arch.direct;
 }
 
 static void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu)
@@ -695,10 +695,10 @@ static bool sp_has_gptes(struct kvm_mmu_page *sp);
 
 static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 {
-	if (sp->role.passthrough)
+	if (sp->role.arch.passthrough)
 		return sp->gfn;
 
-	if (!sp->role.direct)
+	if (!sp->role.arch.direct)
 		return sp->shadowed_translation[index] >> PAGE_SHIFT;
 
 	return sp->gfn + (index << ((sp->role.level - 1) * SPTE_LEVEL_BITS));
@@ -727,7 +727,7 @@ static u32 kvm_mmu_page_get_access(struct kvm_mmu_page *sp, int index)
 	 *
 	 * In both cases, sp->role.access contains the correct access bits.
 	 */
-	return sp->role.access;
+	return sp->role.arch.access;
 }
 
 static void kvm_mmu_page_set_translation(struct kvm_mmu_page *sp, int index,
@@ -739,14 +739,14 @@ static void kvm_mmu_page_set_translation(struct kvm_mmu_page *sp, int index,
 	}
 
 	WARN_ONCE(access != kvm_mmu_page_get_access(sp, index),
-	          "access mismatch under %s page %llx (expected %u, got %u)\n",
-	          sp->role.passthrough ? "passthrough" : "direct",
-	          sp->gfn, kvm_mmu_page_get_access(sp, index), access);
+		  "access mismatch under %s page %llx (expected %u, got %u)\n",
+		  sp->role.arch.passthrough ? "passthrough" : "direct",
+		  sp->gfn, kvm_mmu_page_get_access(sp, index), access);
 
 	WARN_ONCE(gfn != kvm_mmu_page_get_gfn(sp, index),
-	          "gfn mismatch under %s page %llx (expected %llx, got %llx)\n",
-	          sp->role.passthrough ? "passthrough" : "direct",
-	          sp->gfn, kvm_mmu_page_get_gfn(sp, index), gfn);
+		  "gfn mismatch under %s page %llx (expected %llx, got %llx)\n",
+		  sp->role.arch.passthrough ? "passthrough" : "direct",
+		  sp->gfn, kvm_mmu_page_get_gfn(sp, index), gfn);
 }
 
 static void kvm_mmu_page_set_access(struct kvm_mmu_page *sp, int index,
@@ -1723,7 +1723,7 @@ static void kvm_mmu_free_shadow_page(struct kvm_mmu_page *sp)
 	hlist_del(&sp->hash_link);
 	list_del(&sp->link);
 	free_page((unsigned long)sp->spt);
-	if (!sp->role.direct)
+	if (!sp->role.arch.direct)
 		free_page((unsigned long)sp->shadowed_translation);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
@@ -1884,10 +1884,10 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 static bool sp_has_gptes(struct kvm_mmu_page *sp)
 {
-	if (sp->role.direct)
+	if (sp->role.arch.direct)
 		return false;
 
-	if (sp->role.passthrough)
+	if (sp->role.arch.passthrough)
 		return false;
 
 	return true;
@@ -2065,7 +2065,7 @@ static void clear_sp_write_flooding_count(u64 *spte)
  * The vCPU is required when finding indirect shadow pages; the shadow
  * page may already exist and syncing it needs the vCPU pointer in
  * order to read guest page tables.  Direct shadow pages are never
- * unsync, thus @vcpu can be NULL if @role.direct is true.
+ * unsync, thus @vcpu can be NULL if @role.arch.direct is true.
  */
 static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 						     struct kvm_vcpu *vcpu,
@@ -2101,7 +2101,7 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 		}
 
 		/* unsync and write-flooding only apply to indirect SPs. */
-		if (sp->role.direct)
+		if (sp->role.arch.direct)
 			goto out;
 
 		if (sp->unsync) {
@@ -2162,7 +2162,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 
 	sp = kvm_mmu_memory_cache_alloc(caches->page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(caches->shadow_page_cache);
-	if (!role.direct)
+	if (!role.arch.direct)
 		sp->shadowed_translation = kvm_mmu_memory_cache_alloc(caches->shadowed_info_cache);
 
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
@@ -2187,7 +2187,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 	return sp;
 }
 
-/* Note, @vcpu may be NULL if @role.direct is true; see kvm_mmu_find_shadow_page. */
+/* Note, @vcpu may be NULL if @role.arch.direct is true; see kvm_mmu_find_shadow_page. */
 static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
 						      struct kvm_vcpu *vcpu,
 						      struct shadow_page_caches *caches,
@@ -2231,9 +2231,9 @@ static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct,
 
 	role = parent_sp->role;
 	role.level--;
-	role.access = access;
-	role.direct = direct;
-	role.passthrough = 0;
+	role.arch.access = access;
+	role.arch.direct = direct;
+	role.arch.passthrough = 0;
 
 	/*
 	 * If the guest has 4-byte PTEs then that means it's using 32-bit,
@@ -2261,9 +2261,9 @@ static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct,
 	 * covers bit 21 (see above), thus the quadrant is calculated from the
 	 * _least_ significant bit of the PDE index.
 	 */
-	if (role.has_4_byte_gpte) {
+	if (role.arch.has_4_byte_gpte) {
 		WARN_ON_ONCE(role.level != PG_LEVEL_4K);
-		role.quadrant = spte_index(sptep) & 1;
+		role.arch.quadrant = spte_index(sptep) & 1;
 	}
 
 	return role;
@@ -2292,7 +2292,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 
 	if (iterator->level >= PT64_ROOT_4LEVEL &&
 	    vcpu->arch.mmu->cpu_role.base.level < PT64_ROOT_4LEVEL &&
-	    !vcpu->arch.mmu->root_role.direct)
+	    !vcpu->arch.mmu->root_role.arch.direct)
 		iterator->level = PT32E_ROOT_LEVEL;
 
 	if (iterator->level == PT32E_ROOT_LEVEL) {
@@ -2391,7 +2391,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 * a new sp with the correct access.
 		 */
 		child = spte_to_child_sp(*sptep);
-		if (child->role.access == direct_access)
+		if (child->role.arch.access == direct_access)
 			return;
 
 		drop_parent_pte(child, sptep);
@@ -2420,7 +2420,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			 * avoids retaining a large number of stale nested SPs.
 			 */
 			if (tdp_enabled && invalid_list &&
-			    child->role.guest_mode && !child->parent_ptes.val)
+			    child->role.arch.guest_mode && !child->parent_ptes.val)
 				return kvm_mmu_prepare_zap_page(kvm, child,
 								invalid_list);
 		}
@@ -2689,7 +2689,7 @@ static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 	gpa_t gpa;
 	int r;
 
-	if (vcpu->arch.mmu->root_role.direct)
+	if (vcpu->arch.mmu->root_role.arch.direct)
 		return 0;
 
 	gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, NULL);
@@ -2900,7 +2900,7 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 {
 	struct page *pages[PTE_PREFETCH_NUM];
 	struct kvm_memory_slot *slot;
-	unsigned int access = sp->role.access;
+	unsigned int access = sp->role.arch.access;
 	int i, ret;
 	gfn_t gfn;
 
@@ -2928,7 +2928,7 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
 	u64 *spte, *start = NULL;
 	int i;
 
-	WARN_ON(!sp->role.direct);
+	WARN_ON(!sp->role.arch.direct);
 
 	i = spte_index(sptep) & ~(PTE_PREFETCH_NUM - 1);
 	spte = sp->spt + i;
@@ -3549,7 +3549,7 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
 	 * This should not be called while L2 is active, L2 can't invalidate
 	 * _only_ its own roots, e.g. INVVPID unconditionally exits.
 	 */
-	WARN_ON_ONCE(mmu->root_role.guest_mode);
+	WARN_ON_ONCE(mmu->root_role.arch.guest_mode);
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		root_hpa = mmu->prev_roots[i].hpa;
@@ -3557,7 +3557,7 @@ void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu)
 			continue;
 
 		if (!to_shadow_page(root_hpa) ||
-			to_shadow_page(root_hpa)->role.guest_mode)
+			to_shadow_page(root_hpa)->role.arch.guest_mode)
 			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
 	}
 
@@ -3585,10 +3585,10 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
 	struct kvm_mmu_page *sp;
 
 	role.level = level;
-	role.quadrant = quadrant;
+	role.arch.quadrant = quadrant;
 
-	WARN_ON_ONCE(quadrant && !role.has_4_byte_gpte);
-	WARN_ON_ONCE(role.direct && role.has_4_byte_gpte);
+	WARN_ON_ONCE(quadrant && !role.arch.has_4_byte_gpte);
+	WARN_ON_ONCE(role.arch.direct && role.arch.has_4_byte_gpte);
 
 	sp = kvm_mmu_get_shadow_page(vcpu, gfn, role);
 	++sp->root_count;
@@ -3834,7 +3834,7 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	 * equivalent level in the guest's NPT to shadow.  Allocate the tables
 	 * on demand, as running a 32-bit L1 VMM on 64-bit KVM is very rare.
 	 */
-	if (mmu->root_role.direct ||
+	if (mmu->root_role.arch.direct ||
 	    mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL ||
 	    mmu->root_role.level < PT64_ROOT_4LEVEL)
 		return 0;
@@ -3932,7 +3932,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 	int i;
 	struct kvm_mmu_page *sp;
 
-	if (vcpu->arch.mmu->root_role.direct)
+	if (vcpu->arch.mmu->root_role.arch.direct)
 		return;
 
 	if (!VALID_PAGE(vcpu->arch.mmu->root.hpa))
@@ -4161,7 +4161,7 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 	arch.token = alloc_apf_token(vcpu);
 	arch.gfn = gfn;
-	arch.direct_map = vcpu->arch.mmu->root_role.direct;
+	arch.direct_map = vcpu->arch.mmu->root_role.arch.direct;
 	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
 
 	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
@@ -4172,7 +4172,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 {
 	int r;
 
-	if ((vcpu->arch.mmu->root_role.direct != work->arch.direct_map) ||
+	if ((vcpu->arch.mmu->root_role.arch.direct != work->arch.direct_map) ||
 	      work->wakeup_all)
 		return;
 
@@ -4180,7 +4180,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	if (unlikely(r))
 		return;
 
-	if (!vcpu->arch.mmu->root_role.direct &&
+	if (!vcpu->arch.mmu->root_role.arch.direct &&
 	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
 		return;
 
@@ -4456,7 +4456,7 @@ static void nonpaging_init_context(struct kvm_mmu *context)
 static inline bool is_root_usable(struct kvm_mmu_root_info *root, gpa_t pgd,
 				  union kvm_mmu_page_role role)
 {
-	return (role.direct || pgd == root->pgd) &&
+	return (role.arch.direct || pgd == root->pgd) &&
 	       VALID_PAGE(root->hpa) &&
 	       role.word == to_shadow_page(root->hpa)->role.word;
 }
@@ -4576,7 +4576,7 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 	 * If this is a direct root page, it doesn't have a write flooding
 	 * count. Otherwise, clear the write flooding count.
 	 */
-	if (!new_role.direct)
+	if (!new_role.arch.direct)
 		__clear_sp_write_flooding_count(
 				to_shadow_page(vcpu->arch.mmu->root.hpa));
 }
@@ -4803,7 +4803,7 @@ static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 	shadow_zero_check = &context->shadow_zero_check;
 	__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
 				context->root_role.level,
-				context->root_role.efer_nx,
+				context->root_role.arch.efer_nx,
 				guest_can_use_gbpages(vcpu), is_pse, is_amd);
 
 	if (!shadow_me_mask)
@@ -5055,21 +5055,21 @@ kvm_calc_cpu_role(struct kvm_vcpu *vcpu, const struct kvm_mmu_role_regs *regs)
 {
 	union kvm_cpu_role role = {0};
 
-	role.base.access = ACC_ALL;
 	role.base.as_id = is_smm(vcpu);
-	role.base.guest_mode = is_guest_mode(vcpu);
+	role.base.arch.access = ACC_ALL;
+	role.base.arch.guest_mode = is_guest_mode(vcpu);
 	role.ext.valid = 1;
 
 	if (!____is_cr0_pg(regs)) {
-		role.base.direct = 1;
+		role.base.arch.direct = 1;
 		return role;
 	}
 
-	role.base.efer_nx = ____is_efer_nx(regs);
-	role.base.cr0_wp = ____is_cr0_wp(regs);
-	role.base.smep_andnot_wp = ____is_cr4_smep(regs) && !____is_cr0_wp(regs);
-	role.base.smap_andnot_wp = ____is_cr4_smap(regs) && !____is_cr0_wp(regs);
-	role.base.has_4_byte_gpte = !____is_cr4_pae(regs);
+	role.base.arch.efer_nx = ____is_efer_nx(regs);
+	role.base.arch.cr0_wp = ____is_cr0_wp(regs);
+	role.base.arch.smep_andnot_wp = ____is_cr4_smep(regs) && !____is_cr0_wp(regs);
+	role.base.arch.smap_andnot_wp = ____is_cr4_smap(regs) && !____is_cr0_wp(regs);
+	role.base.arch.has_4_byte_gpte = !____is_cr4_pae(regs);
 
 	if (____is_efer_lma(regs))
 		role.base.level = ____is_cr4_la57(regs) ? PT64_ROOT_5LEVEL
@@ -5109,15 +5109,15 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 {
 	union kvm_mmu_page_role role = {0};
 
-	role.access = ACC_ALL;
-	role.cr0_wp = true;
-	role.efer_nx = true;
 	role.as_id = cpu_role.base.as_id;
-	role.guest_mode = cpu_role.base.guest_mode;
-	role.ad_disabled = !kvm_ad_enabled();
 	role.level = kvm_mmu_get_tdp_level(vcpu);
-	role.direct = true;
-	role.has_4_byte_gpte = false;
+	role.arch.access = ACC_ALL;
+	role.arch.cr0_wp = true;
+	role.arch.efer_nx = true;
+	role.arch.guest_mode = cpu_role.base.arch.guest_mode;
+	role.arch.ad_disabled = !kvm_ad_enabled();
+	role.arch.direct = true;
+	role.arch.has_4_byte_gpte = false;
 
 	return role;
 }
@@ -5194,7 +5194,7 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 	 * NX can be used by any non-nested shadow MMU to avoid having to reset
 	 * MMU contexts.
 	 */
-	root_role.efer_nx = true;
+	root_role.arch.efer_nx = true;
 
 	shadow_mmu_init_context(vcpu, context, cpu_role, root_role);
 }
@@ -5212,13 +5212,13 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 	union kvm_mmu_page_role root_role;
 
 	/* NPT requires CR0.PG=1. */
-	WARN_ON_ONCE(cpu_role.base.direct);
+	WARN_ON_ONCE(cpu_role.base.arch.direct);
 
 	root_role = cpu_role.base;
 	root_role.level = kvm_mmu_get_tdp_level(vcpu);
 	if (root_role.level == PT64_ROOT_5LEVEL &&
 	    cpu_role.base.level == PT64_ROOT_4LEVEL)
-		root_role.passthrough = 1;
+		root_role.arch.passthrough = 1;
 
 	shadow_mmu_init_context(vcpu, context, cpu_role, root_role);
 	kvm_mmu_new_pgd(vcpu, nested_cr3);
@@ -5237,11 +5237,11 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 	 */
 	WARN_ON_ONCE(is_smm(vcpu));
 	role.base.level = level;
-	role.base.has_4_byte_gpte = false;
-	role.base.direct = false;
-	role.base.ad_disabled = !accessed_dirty;
-	role.base.guest_mode = true;
-	role.base.access = ACC_ALL;
+	role.base.arch.has_4_byte_gpte = false;
+	role.base.arch.direct = false;
+	role.base.arch.ad_disabled = !accessed_dirty;
+	role.base.arch.guest_mode = true;
+	role.base.arch.access = ACC_ALL;
 
 	role.ext.word = 0;
 	role.ext.execonly = execonly;
@@ -5385,13 +5385,13 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 {
 	int r;
 
-	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->root_role.direct);
+	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->root_role.arch.direct);
 	if (r)
 		goto out;
 	r = mmu_alloc_special_roots(vcpu);
 	if (r)
 		goto out;
-	if (vcpu->arch.mmu->root_role.direct)
+	if (vcpu->arch.mmu->root_role.arch.direct)
 		r = mmu_alloc_direct_roots(vcpu);
 	else
 		r = mmu_alloc_shadow_roots(vcpu);
@@ -5526,7 +5526,7 @@ static bool detect_write_misaligned(struct kvm_mmu_page *sp, gpa_t gpa,
 		 gpa, bytes, sp->role.word);
 
 	offset = offset_in_page(gpa);
-	pte_size = sp->role.has_4_byte_gpte ? 4 : 8;
+	pte_size = sp->role.arch.has_4_byte_gpte ? 4 : 8;
 
 	/*
 	 * Sometimes, the OS only writes the last one bytes to update status
@@ -5550,7 +5550,7 @@ static u64 *get_written_sptes(struct kvm_mmu_page *sp, gpa_t gpa, int *nspte)
 	page_offset = offset_in_page(gpa);
 	level = sp->role.level;
 	*nspte = 1;
-	if (sp->role.has_4_byte_gpte) {
+	if (sp->role.arch.has_4_byte_gpte) {
 		page_offset <<= 1;	/* 32->64 */
 		/*
 		 * A 32-bit pde maps 4MB while the shadow pdes map
@@ -5564,7 +5564,7 @@ static u64 *get_written_sptes(struct kvm_mmu_page *sp, gpa_t gpa, int *nspte)
 		}
 		quadrant = page_offset >> PAGE_SHIFT;
 		page_offset &= ~PAGE_MASK;
-		if (quadrant != sp->role.quadrant)
+		if (quadrant != sp->role.arch.quadrant)
 			return NULL;
 	}
 
@@ -5628,7 +5628,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 		       void *insn, int insn_len)
 {
 	int r, emulation_type = EMULTYPE_PF;
-	bool direct = vcpu->arch.mmu->root_role.direct;
+	bool direct = vcpu->arch.mmu->root_role.arch.direct;
 
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
 		return RET_PF_RETRY;
@@ -5659,7 +5659,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	 * paging in both guests. If true, we simply unprotect the page
 	 * and resume the guest.
 	 */
-	if (vcpu->arch.mmu->root_role.direct &&
+	if (vcpu->arch.mmu->root_role.arch.direct &&
 	    (error_code & PFERR_NESTED_GUEST_PAGE) == PFERR_NESTED_GUEST_PAGE) {
 		kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(cr2_or_gpa));
 		return 1;
@@ -6321,7 +6321,7 @@ static void shadow_mmu_split_huge_page(struct kvm *kvm,
 
 		spte = make_huge_page_split_spte(kvm, huge_spte, sp->role, index);
 		mmu_spte_set(sptep, spte);
-		__rmap_add(kvm, cache, slot, sptep, gfn, sp->role.access);
+		__rmap_add(kvm, cache, slot, sptep, gfn, sp->role.arch.access);
 	}
 
 	__link_shadow_page(kvm, cache, huge_sptep, sp, flush);
@@ -6380,7 +6380,7 @@ static bool shadow_mmu_try_split_huge_pages(struct kvm *kvm,
 		sp = sptep_to_sp(huge_sptep);
 
 		/* TDP MMU is enabled, so rmap only contains nested MMU SPs. */
-		if (WARN_ON_ONCE(!sp->role.guest_mode))
+		if (WARN_ON_ONCE(!sp->role.arch.guest_mode))
 			continue;
 
 		/* The rmaps should never contain non-leaf SPTEs. */
@@ -6502,7 +6502,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		 * the guest, and the guest page table is using 4K page size
 		 * mapping if the indirect sp has level = 1.
 		 */
-		if (sp->role.direct &&
+		if (sp->role.arch.direct &&
 		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn,
 							       PG_LEVEL_NUM)) {
 			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
@@ -6942,7 +6942,7 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 				      struct kvm_mmu_page,
 				      possible_nx_huge_page_link);
 		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
-		WARN_ON_ONCE(!sp->role.direct);
+		WARN_ON_ONCE(!sp->role.arch.direct);
 
 		/*
 		 * Unaccount and do not attempt to recover any NX Huge Pages
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 5427f65117b4..c19a80fdeb8d 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -143,7 +143,7 @@ static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 	 * being enabled is mandatory as the bits used to denote WP-only SPTEs
 	 * are reserved for PAE paging (32-bit KVM).
 	 */
-	return kvm_x86_ops.cpu_dirty_log_size && sp->role.guest_mode;
+	return kvm_x86_ops.cpu_dirty_log_size && sp->role.arch.guest_mode;
 }
 
 int mmu_try_to_unsync_pages(struct kvm *kvm, const struct kvm_memory_slot *slot,
@@ -270,7 +270,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	};
 	int r;
 
-	if (vcpu->arch.mmu->root_role.direct) {
+	if (vcpu->arch.mmu->root_role.arch.direct) {
 		fault.gfn = fault.addr >> PAGE_SHIFT;
 		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
 	}
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index ae86820cef69..6a4a43b90780 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -35,13 +35,13 @@
 			 " %snxe %sad root %u %s%c",			\
 			 __entry->mmu_valid_gen,			\
 			 __entry->gfn, role.level,			\
-			 role.has_4_byte_gpte ? 4 : 8,			\
-			 role.quadrant,					\
-			 role.direct ? " direct" : "",			\
-			 access_str[role.access],			\
+			 role.arch.has_4_byte_gpte ? 4 : 8,			\
+			 role.arch.quadrant,					\
+			 role.arch.direct ? " direct" : "",			\
+			 access_str[role.arch.access],			\
 			 role.invalid ? " invalid" : "",		\
-			 role.efer_nx ? "" : "!",			\
-			 role.ad_disabled ? "!" : "",			\
+			 role.arch.efer_nx ? "" : "!",			\
+			 role.arch.ad_disabled ? "!" : "",			\
 			 __entry->root_count,				\
 			 __entry->unsync ? "unsync" : "sync", 0);	\
 	saved_ptr;							\
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index e5662dbd519c..e15ec1c473da 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -55,7 +55,7 @@
 	#define PT_LEVEL_BITS 9
 	#define PT_GUEST_DIRTY_SHIFT 9
 	#define PT_GUEST_ACCESSED_SHIFT 8
-	#define PT_HAVE_ACCESSED_DIRTY(mmu) (!(mmu)->cpu_role.base.ad_disabled)
+	#define PT_HAVE_ACCESSED_DIRTY(mmu) (!(mmu)->cpu_role.base.arch.ad_disabled)
 	#define PT_MAX_FULL_LEVELS PT64_ROOT_MAX_LEVEL
 #else
 	#error Invalid PTTYPE value
@@ -532,7 +532,7 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
 
 	gfn = gpte_to_gfn(gpte);
-	pte_access = sp->role.access & FNAME(gpte_access)(gpte);
+	pte_access = sp->role.arch.access & FNAME(gpte_access)(gpte);
 	FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
 
 	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn,
@@ -592,7 +592,7 @@ static void FNAME(pte_prefetch)(struct kvm_vcpu *vcpu, struct guest_walker *gw,
 	if (unlikely(vcpu->kvm->mmu_invalidate_in_progress))
 		return;
 
-	if (sp->role.direct)
+	if (sp->role.arch.direct)
 		return __direct_pte_prefetch(vcpu, sp, sptep);
 
 	i = spte_index(sptep) & ~(PTE_PREFETCH_NUM - 1);
@@ -884,7 +884,7 @@ static gpa_t FNAME(get_level1_sp_gpa)(struct kvm_mmu_page *sp)
 	WARN_ON(sp->role.level != PG_LEVEL_4K);
 
 	if (PTTYPE == 32)
-		offset = sp->role.quadrant << SPTE_LEVEL_BITS;
+		offset = sp->role.arch.quadrant << SPTE_LEVEL_BITS;
 
 	return gfn_to_gpa(sp->gfn) + offset * sizeof(pt_element_t);
 }
@@ -1003,9 +1003,11 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	 */
 	const union kvm_mmu_page_role sync_role_ign = {
 		.level = 0xf,
-		.access = 0x7,
-		.quadrant = 0x3,
-		.passthrough = 0x1,
+		.arch = {
+			.access = 0x7,
+			.quadrant = 0x3,
+			.passthrough = 0x1,
+		},
 	};
 
 	/*
@@ -1014,7 +1016,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	 * differs then the memslot lookup (SMM vs. non-SMM) will be bogus, the
 	 * reserved bits checks will be wrong, etc...
 	 */
-	if (WARN_ON_ONCE(sp->role.direct ||
+	if (WARN_ON_ONCE(sp->role.arch.direct ||
 			 (sp->role.word ^ root_role.word) & ~sync_role_ign.word))
 		return -1;
 
@@ -1043,7 +1045,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		}
 
 		gfn = gpte_to_gfn(gpte);
-		pte_access = sp->role.access;
+		pte_access = sp->role.arch.access;
 		pte_access &= FNAME(gpte_access)(gpte);
 		FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
 
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index c0fd7e049b4e..fe4b626cb431 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -146,7 +146,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 
 	WARN_ON_ONCE(!pte_access && !shadow_present_mask);
 
-	if (sp->role.ad_disabled)
+	if (sp->role.arch.ad_disabled)
 		spte |= SPTE_TDP_AD_DISABLED_MASK;
 	else if (kvm_mmu_page_ad_need_write_protect(sp))
 		spte |= SPTE_TDP_AD_WRPROT_ONLY_MASK;
@@ -301,7 +301,7 @@ u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte, union kvm_mmu_page
 		 * the page executable as the NX hugepage mitigation no longer
 		 * applies.
 		 */
-		if ((role.access & ACC_EXEC_MASK) && is_nx_huge_page_enabled(kvm))
+		if ((role.arch.access & ACC_EXEC_MASK) && is_nx_huge_page_enabled(kvm))
 			child_spte = make_spte_executable(child_spte);
 	}
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 1f03701b943a..ad84c549fe96 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -260,7 +260,7 @@ static inline bool kvm_ad_enabled(void)
 
 static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
 {
-	return sp->role.ad_disabled;
+	return sp->role.arch.ad_disabled;
 }
 
 static inline bool spte_ad_enabled(u64 spte)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b2da8c8f30a..2bfe060768fc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8442,7 +8442,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	    WARN_ON_ONCE(!(emulation_type & EMULTYPE_PF)))
 		return false;
 
-	if (!vcpu->arch.mmu->root_role.direct) {
+	if (!vcpu->arch.mmu->root_role.arch.direct) {
 		/*
 		 * Write permission should be allowed since only
 		 * write access need to be emulated.
@@ -8475,7 +8475,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	kvm_release_pfn_clean(pfn);
 
 	/* The instructions are well-emulated on direct mmu. */
-	if (vcpu->arch.mmu->root_role.direct) {
+	if (vcpu->arch.mmu->root_role.arch.direct) {
 		unsigned int indirect_shadow_pages;
 
 		write_lock(&vcpu->kvm->mmu_lock);
@@ -8543,7 +8543,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
 	vcpu->arch.last_retry_eip = ctxt->eip;
 	vcpu->arch.last_retry_addr = cr2_or_gpa;
 
-	if (!vcpu->arch.mmu->root_role.direct)
+	if (!vcpu->arch.mmu->root_role.arch.direct)
 		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
 
 	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
@@ -8846,7 +8846,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		ctxt->exception.address = cr2_or_gpa;
 
 		/* With shadow page tables, cr2 contains a GVA or nGPA. */
-		if (vcpu->arch.mmu->root_role.direct) {
+		if (vcpu->arch.mmu->root_role.arch.direct) {
 			ctxt->gpa_available = true;
 			ctxt->gpa_val = cr2_or_gpa;
 		}
diff --git a/include/kvm/mmu_types.h b/include/kvm/mmu_types.h
new file mode 100644
index 000000000000..3f35a924e031
--- /dev/null
+++ b/include/kvm/mmu_types.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_MMU_TYPES_H
+#define __KVM_MMU_TYPES_H
+
+#include <linux/bug.h>
+#include <linux/types.h>
+#include <linux/stddef.h>
+
+#include <asm/kvm/mmu_types.h>
+
+/*
+ * kvm_mmu_page_role tracks the properties of a shadow page (where shadow page
+ * also includes TDP pages) to determine whether or not a page can be used in
+ * the given MMU context.
+ */
+union kvm_mmu_page_role {
+	u32 word;
+	struct {
+		struct {
+			/* The address space ID mapped by the page. */
+			u16 as_id:8;
+
+			/* The level of the page in the page table hierarchy. */
+			u16 level:4;
+
+			/* Whether the page is invalid, i.e. pending destruction. */
+			u16 invalid:1;
+		};
+
+		/* Architecture-specific properties. */
+		struct kvm_mmu_page_role_arch arch;
+	};
+};
+
+static_assert(sizeof(union kvm_mmu_page_role) == sizeof_field(union kvm_mmu_page_role, word));
+
+#endif /* !__KVM_MMU_TYPES_H */
-- 
2.39.0.rc1.256.g54fd8350bd-goog

