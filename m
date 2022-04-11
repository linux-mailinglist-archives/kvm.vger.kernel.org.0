Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5354FC65E
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 23:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350080AbiDKVNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 17:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350079AbiDKVNK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 17:13:10 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C842AE3E
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 14:10:50 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id y15-20020a17090a154f00b001cb4f2196e1so255415pja.3
        for <kvm@vger.kernel.org>; Mon, 11 Apr 2022 14:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=G74YOGd+KW6PfFvdswhoDzYcIuStPXuwuhYirfhXwiM=;
        b=EYkBSxlkjezsOn0WSYft+MgmzUxZWXclsjEeb8M/F9g+FhFQUQCNX4yPI8d8FBgRmV
         pRxUsb4RnLzRHBRa9K054kS4ljLd0ltg4jkjSpodRquXfeW1fovrPRPAB4tlvZfvsIx/
         t5NgnCB2ihQ2YSphonkw7EGj3j9juXOLQVBuyX5D9fFEaCQQrigWOQRamSSAg/tfQ+eq
         RwTIHCCFQDWG5J3Ik0hRJ0BxQ05f1IdoxltA0imoc/HUFgxqxairkXSOYoJBU42hTPfC
         rpHCTFgLIGceYiqQncQjCJX9vcgtaOuzqrIhLe7EkE7Ulroo+PZg1foCPQBl3+RgRLyy
         iDCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=G74YOGd+KW6PfFvdswhoDzYcIuStPXuwuhYirfhXwiM=;
        b=2j/SHVrRe2txkjD8+2uHWf3pf5L6muIwL/MA9unwonyU2Sg576N7PVABGBuWCpEbD6
         d9bDY/1UNp6JvOhavby0DRm/vhfGkAeHQYzyPSuzS8dSDenkH3jHtsYRx5WEWVKag/X+
         uFx3DszDZPcF55e/yx2VFgRzVaUkqbZwiFhTrycALo0bULOJqqaCRYqbquCarpUjJili
         PwYzQ/u23+z0kvTqtGE0wmtOVLytvpC9IZMK2QSTzNebKDZ9h1LsUsiEnRvxlgrgSBmg
         39GDNoX3Kf41Ugt3sjiw4qp+MnI0jplk/DNvZeObdjOudqArOZQ+D+RxEzgAwu/9Q9uR
         FYyQ==
X-Gm-Message-State: AOAM533HV/0TEHVy56B6bybPqFKfiiJvBADscBj6AXix7JrAFVY3xrBB
        Pe5fS49zYEYkiF+HHyEEd2IdKhFG6GRF
X-Google-Smtp-Source: ABdhPJwbnxlqSVC8vvWdQE7kZzWG12dhBh7iFh7S+OO+ZoQ6+KRaSZGgMcswktkOPo+eA2A2fTdo/1M58Umh
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:a2d0:faec:7d8b:2e0b])
 (user=bgardon job=sendgmr) by 2002:a17:90a:ba13:b0:1cb:6296:ce41 with SMTP id
 s19-20020a17090aba1300b001cb6296ce41mr1224016pjr.104.1649711449422; Mon, 11
 Apr 2022 14:10:49 -0700 (PDT)
Date:   Mon, 11 Apr 2022 14:10:12 -0700
In-Reply-To: <20220411211015.3091615-1-bgardon@google.com>
Message-Id: <20220411211015.3091615-8-bgardon@google.com>
Mime-Version: 1.0
References: <20220411211015.3091615-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v4 07/10] KVM: x86/MMU: Allow NX huge pages to be disabled on
 a per-vm basis
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Ben Gardon <bgardon@google.com>
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

In some cases, the NX hugepage mitigation for iTLB multihit is not
needed for all guests on a host. Allow disabling the mitigation on a
per-VM basis to avoid the performance hit of NX hugepages on trusted
workloads.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 Documentation/virt/kvm/api.rst  | 11 +++++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu.h              | 10 ++++++----
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/mmu/spte.c         |  7 ++++---
 arch/x86/kvm/mmu/spte.h         |  3 ++-
 arch/x86/kvm/mmu/tdp_mmu.c      |  3 ++-
 arch/x86/kvm/x86.c              |  6 ++++++
 include/uapi/linux/kvm.h        |  1 +
 9 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 72183ae628f7..31fb002632bb 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7855,6 +7855,17 @@ At this time, KVM_PMU_CAP_DISABLE is the only capability.  Setting
 this capability will disable PMU virtualization for that VM.  Usermode
 should adjust CPUID leaf 0xA to reflect that the PMU is disabled.
 
+8.36 KVM_CAP_VM_DISABLE_NX_HUGE_PAGES
+---------------------------
+
+:Capability KVM_CAP_PMU_CAPABILITY
+:Architectures: x86
+:Type: vm
+
+This capability disables the NX huge pages mitigation for iTLB MULTIHIT.
+
+The capability has no effect if the nx_huge_pages module parameter is not set.
+
 9. Known KVM API problems
 =========================
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c20f715f009..b8ab4fa7d4b2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1240,6 +1240,8 @@ struct kvm_arch {
 	hpa_t	hv_root_tdp;
 	spinlock_t hv_root_tdp_lock;
 #endif
+
+	bool disable_nx_huge_pages;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 671cfeccf04e..20d12e5b0040 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -173,10 +173,12 @@ struct kvm_page_fault {
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
 extern int nx_huge_pages;
-static inline bool is_nx_huge_page_enabled(void)
+static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
 {
-	return READ_ONCE(nx_huge_pages);
+	return READ_ONCE(nx_huge_pages) &&
+	       !kvm->arch.disable_nx_huge_pages;
 }
+void kvm_update_nx_huge_pages(struct kvm *kvm);
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 					u32 err, bool prefetch)
@@ -191,8 +193,8 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.user = err & PFERR_USER_MASK,
 		.prefetch = prefetch,
 		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
-		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(),
-
+		.nx_huge_page_workaround_enabled =
+			is_nx_huge_page_enabled(vcpu->kvm),
 		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index caaa610b7878..149f353105f4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6144,7 +6144,7 @@ static void __set_nx_huge_pages(bool val)
 	nx_huge_pages = itlb_multihit_kvm_mitigation = val;
 }
 
-static void kvm_update_nx_huge_pages(struct kvm *kvm)
+void kvm_update_nx_huge_pages(struct kvm *kvm)
 {
 	mutex_lock(&kvm->slots_lock);
 	kvm_mmu_zap_all_fast(kvm);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4739b53c9734..877ad30bc7ad 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -116,7 +116,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		spte |= spte_shadow_accessed_mask(spte);
 
 	if (level > PG_LEVEL_4K && (pte_access & ACC_EXEC_MASK) &&
-	    is_nx_huge_page_enabled()) {
+	    is_nx_huge_page_enabled(vcpu->kvm)) {
 		pte_access &= ~ACC_EXEC_MASK;
 	}
 
@@ -215,7 +215,8 @@ static u64 make_spte_executable(u64 spte)
  * This is used during huge page splitting to build the SPTEs that make up the
  * new page table.
  */
-u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
+u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte, int huge_level,
+			      int index)
 {
 	u64 child_spte;
 	int child_level;
@@ -243,7 +244,7 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
 		 * When splitting to a 4K page, mark the page executable as the
 		 * NX hugepage mitigation no longer applies.
 		 */
-		if (is_nx_huge_page_enabled())
+		if (is_nx_huge_page_enabled(kvm))
 			child_spte = make_spte_executable(child_spte);
 	}
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 73f12615416f..e4142caff4b1 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -415,7 +415,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
-u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index);
+u64 make_huge_page_split_spte(struct kvm *kvm, u64 huge_spte, int huge_level,
+			      int index);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 566548a3efa7..03aa1e0f60e2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1469,7 +1469,8 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * not been linked in yet and thus is not reachable from any other CPU.
 	 */
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
-		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
+		sp->spt[i] = make_huge_page_split_spte(kvm, huge_spte,
+						       level, i);
 
 	/*
 	 * Replace the huge spte with a pointer to the populated lower level
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ab336f7c82e4..b810ea45f965 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4286,6 +4286,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SYS_ATTRIBUTES:
 	case KVM_CAP_VAPIC:
 	case KVM_CAP_ENABLE_CAP:
+	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
@@ -6079,6 +6080,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
+		kvm->arch.disable_nx_huge_pages = true;
+		kvm_update_nx_huge_pages(kvm);
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dd1d8167e71f..7155488164bd 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1148,6 +1148,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PMU_CAPABILITY 212
 #define KVM_CAP_DISABLE_QUIRKS2 213
 #define KVM_CAP_VM_TSC_CONTROL 214
+#define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 215
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.35.1.1178.g4f1659d476-goog

