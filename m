Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA5D688669
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbjBBS3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbjBBS2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:28:45 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA6978AE6
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:28:26 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id a20-20020a17090ad81400b0022c3185ebbeso1338503pjv.3
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8tan31zdS6PKUwJVzyLN2c6lLyefV39OjyNzpOIJzl0=;
        b=ISqEcv5gcdG1vlSJqzcQZNb8goQIJ7GJymvAuPaRAAGzFmj7/6ioDcfJmKq8OkerTl
         Y35IYK48Z16XX1h/1FO4UtdDMCdajAYrethvBjoFGMSRM3UiRZRv093nrn1DHq5FGdbw
         9l+di1c2Ijrief9oI3G0pT64Y9m1Pzzs69/OE2PeXU7It3P6LuoDX1vTriZtsbPH6RA1
         joFvu87bobMayqIYx/m5W7ZmRSXHDJyw9kCxX9OOnN1AmAqUWgxDAhmuLg79rlArv5kc
         WG4NLXMSDHA+xZW7NTnUfLCoGEIoXvO2y7H8CF5SlvCMUkwQBCQerBt+iBGwo6MzfZ1j
         7CpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8tan31zdS6PKUwJVzyLN2c6lLyefV39OjyNzpOIJzl0=;
        b=XLM/NPUMmy2iJJuHdWfK7MTTeKfRGJea5rLibayZku2Hs9Nv9etG9czje8SAHoSu2M
         YOvyHTUtvftPYna0mZ/iucYKPaw0/JvkBO4mxWo4Sh7x/pEKEfLGd4O76w5TR1sVg3LH
         6kU3q0e45IOG3cQvXUkPFInXq/BXmSVSxixk0Tuyvd57AbeG/YdBvQRYdpZXbF8BQ7L/
         o79iFtMOjafOg2miq/BedqSClPASuA1wdr/eI6tB33osYepM5EOZz+LcSKdGX1imbCne
         CdO5k0mkJNTdvBeIj/K7JZoKGSvqFN5j0OKuMNpbDXvwp2nVzQ9E9c6MiByWCcAjMIyy
         kOcA==
X-Gm-Message-State: AO0yUKWzMbkuw6zPu77nBdQ3DSv4GpYTUHW39X2T2MyCRITbfMT0UDVw
        m+lZceDJbdWAoYY7k/tIwj4LWmDdKxj1
X-Google-Smtp-Source: AK7set9+pwIHjUmTzegfYqJtFYn4WPGCr8+F8UytIIsEIUtLVGJJqFThSJnKjIIm/t+eJf1Eguz4Y1BA7na7
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:90a:be0e:b0:22c:305a:4da3 with SMTP id
 a14-20020a17090abe0e00b0022c305a4da3mr809032pjs.74.1675362504523; Thu, 02 Feb
 2023 10:28:24 -0800 (PST)
Date:   Thu,  2 Feb 2023 18:27:56 +0000
In-Reply-To: <20230202182809.1929122-1-bgardon@google.com>
Mime-Version: 1.0
References: <20230202182809.1929122-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202182809.1929122-9-bgardon@google.com>
Subject: [PATCH 08/21] KVM: x86/MMU: Expose functions for paging_tmpl.h
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Ben Gardon <bgardon@google.com>
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

In preparation for moving paging_tmpl.h to shadow_mmu.c, expose various
functions it needs through mmu_internal.h. This includes moving all the
BUILD_MMU_ROLE_*() macros. Not all of those macros are strictly needed
by paging_tmpl.h, but it is cleaner to keep them together.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 68 +++++----------------------------
 arch/x86/kvm/mmu/mmu_internal.h | 59 ++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 59 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2162dfda9601f..da290bfca0137 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -123,57 +123,9 @@ struct kmem_cache *pte_list_desc_cache;
 struct kmem_cache *mmu_page_header_cache;
 struct percpu_counter kvm_total_used_mmu_pages;
 
-struct kvm_mmu_role_regs {
-	const unsigned long cr0;
-	const unsigned long cr4;
-	const u64 efer;
-};
-
 #define CREATE_TRACE_POINTS
 #include "mmutrace.h"
 
-/*
- * Yes, lot's of underscores.  They're a hint that you probably shouldn't be
- * reading from the role_regs.  Once the root_role is constructed, it becomes
- * the single source of truth for the MMU's state.
- */
-#define BUILD_MMU_ROLE_REGS_ACCESSOR(reg, name, flag)			\
-static inline bool __maybe_unused					\
-____is_##reg##_##name(const struct kvm_mmu_role_regs *regs)		\
-{									\
-	return !!(regs->reg & flag);					\
-}
-BUILD_MMU_ROLE_REGS_ACCESSOR(cr0, pg, X86_CR0_PG);
-BUILD_MMU_ROLE_REGS_ACCESSOR(cr0, wp, X86_CR0_WP);
-BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, pse, X86_CR4_PSE);
-BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, pae, X86_CR4_PAE);
-BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, smep, X86_CR4_SMEP);
-BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, smap, X86_CR4_SMAP);
-BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, pke, X86_CR4_PKE);
-BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, la57, X86_CR4_LA57);
-BUILD_MMU_ROLE_REGS_ACCESSOR(efer, nx, EFER_NX);
-BUILD_MMU_ROLE_REGS_ACCESSOR(efer, lma, EFER_LMA);
-
-/*
- * The MMU itself (with a valid role) is the single source of truth for the
- * MMU.  Do not use the regs used to build the MMU/role, nor the vCPU.  The
- * regs don't account for dependencies, e.g. clearing CR4 bits if CR0.PG=1,
- * and the vCPU may be incorrect/irrelevant.
- */
-#define BUILD_MMU_ROLE_ACCESSOR(base_or_ext, reg, name)		\
-static inline bool __maybe_unused is_##reg##_##name(struct kvm_mmu *mmu)	\
-{								\
-	return !!(mmu->cpu_role. base_or_ext . reg##_##name);	\
-}
-BUILD_MMU_ROLE_ACCESSOR(base, cr0, wp);
-BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pse);
-BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smep);
-BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smap);
-BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pke);
-BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, la57);
-BUILD_MMU_ROLE_ACCESSOR(base, efer, nx);
-BUILD_MMU_ROLE_ACCESSOR(ext,  efer, lma);
-
 static inline bool is_cr0_pg(struct kvm_mmu *mmu)
 {
         return mmu->cpu_role.base.level > 0;
@@ -218,7 +170,7 @@ void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 	kvm_flush_remote_tlbs_with_range(kvm, &range);
 }
 
-static gfn_t get_mmio_spte_gfn(u64 spte)
+gfn_t get_mmio_spte_gfn(u64 spte)
 {
 	u64 gpa = spte & shadow_nonpresent_or_rsvd_lower_gfn_mask;
 
@@ -287,7 +239,7 @@ void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	}
 }
 
-static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
+int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 {
 	int r;
 
@@ -828,9 +780,8 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 	return -EFAULT;
 }
 
-static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
-				   struct kvm_page_fault *fault,
-				   unsigned int access)
+int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+			    unsigned int access)
 {
 	gva_t gva = fault->is_tdp ? 0 : fault->addr;
 
@@ -1284,8 +1235,8 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 	return RET_PF_RETRY;
 }
 
-static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
-					 struct kvm_page_fault *fault)
+bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
+				  struct kvm_page_fault *fault)
 {
 	if (unlikely(fault->rsvd))
 		return false;
@@ -1408,8 +1359,8 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	return RET_PF_CONTINUE;
 }
 
-static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
-			   unsigned int access)
+int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+		    unsigned int access)
 {
 	int ret;
 
@@ -1433,8 +1384,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
  * Returns true if the page fault is stale and needs to be retried, i.e. if the
  * root was invalidated by a memslot update or a relevant mmu_notifier fired.
  */
-static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
-				struct kvm_page_fault *fault)
+bool is_page_fault_stale(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root.hpa);
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 9c1399762496b..349d4a300ad34 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -347,6 +347,65 @@ bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu);
 void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu);
 
+int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect);
 bool need_topup_split_caches_or_resched(struct kvm *kvm);
 int topup_split_caches(struct kvm *kvm);
+
+bool is_page_fault_stale(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
+bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
+				  struct kvm_page_fault *fault);
+int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+		    unsigned int access);
+int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+			    unsigned int access);
+
+gfn_t get_mmio_spte_gfn(u64 spte);
+
+struct kvm_mmu_role_regs {
+	const unsigned long cr0;
+	const unsigned long cr4;
+	const u64 efer;
+};
+
+/*
+ * Yes, lot's of underscores.  They're a hint that you probably shouldn't be
+ * reading from the role_regs.  Once the root_role is constructed, it becomes
+ * the single source of truth for the MMU's state.
+ */
+#define BUILD_MMU_ROLE_REGS_ACCESSOR(reg, name, flag)			\
+static inline bool __maybe_unused					\
+____is_##reg##_##name(const struct kvm_mmu_role_regs *regs)		\
+{									\
+	return !!(regs->reg & flag);					\
+}
+BUILD_MMU_ROLE_REGS_ACCESSOR(cr0, pg, X86_CR0_PG);
+BUILD_MMU_ROLE_REGS_ACCESSOR(cr0, wp, X86_CR0_WP);
+BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, pse, X86_CR4_PSE);
+BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, pae, X86_CR4_PAE);
+BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, smep, X86_CR4_SMEP);
+BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, smap, X86_CR4_SMAP);
+BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, pke, X86_CR4_PKE);
+BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, la57, X86_CR4_LA57);
+BUILD_MMU_ROLE_REGS_ACCESSOR(efer, nx, EFER_NX);
+BUILD_MMU_ROLE_REGS_ACCESSOR(efer, lma, EFER_LMA);
+
+/*
+ * The MMU itself (with a valid role) is the single source of truth for the
+ * MMU.  Do not use the regs used to build the MMU/role, nor the vCPU.  The
+ * regs don't account for dependencies, e.g. clearing CR4 bits if CR0.PG=1,
+ * and the vCPU may be incorrect/irrelevant.
+ */
+#define BUILD_MMU_ROLE_ACCESSOR(base_or_ext, reg, name)		\
+static inline bool __maybe_unused is_##reg##_##name(struct kvm_mmu *mmu)	\
+{								\
+	return !!(mmu->cpu_role. base_or_ext . reg##_##name);	\
+}
+BUILD_MMU_ROLE_ACCESSOR(base, cr0, wp);
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pse);
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smep);
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smap);
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pke);
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, la57);
+BUILD_MMU_ROLE_ACCESSOR(base, efer, nx);
+BUILD_MMU_ROLE_ACCESSOR(ext,  efer, lma);
 #endif /* __KVM_X86_MMU_INTERNAL_H */
-- 
2.39.1.519.gcb327c4b5f-goog

