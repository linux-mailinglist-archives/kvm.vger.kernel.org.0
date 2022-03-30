Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67FBB4ECB03
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 19:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349493AbiC3Rss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 13:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349646AbiC3Rs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 13:48:27 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D734EEA
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 10:46:41 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id t6-20020a6549c6000000b00398a43dbdf8so1817981pgs.10
        for <kvm@vger.kernel.org>; Wed, 30 Mar 2022 10:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VmPQQ5qQRDJuN908c46gqwAcHrIvR56W695qYYb4WZ0=;
        b=eZx1PTFQ157sGCuxD63cANe5vicE0qFLAPgD8Ad4kvelr8kcbHMCFwljdSp6Ya9b/1
         DbYdaUhlwowo2PI3X6rONBP46+ADfyculpJWVsHL3nEPftS188D8isVXiaamQGZ3gyHt
         r6BZQOGnLt80ixQktHvtRysdejx5xOQSxuThnCwhvWWJmB5fdv0UHn2JnOIcdG7dKEJQ
         Ip7BrhUzb/2+JnpZbWvU/buHYY5p9hiRGXVMLAnrG69l311h/fbV+PwpEpZ2IB4KJrS1
         gdoR6vSIsKU1Y+6kNl3BQJ92QCnKC3Gamw1yHaxj6lBwFz8/9gHB3L2tDa/ViOpaHvGi
         aUaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VmPQQ5qQRDJuN908c46gqwAcHrIvR56W695qYYb4WZ0=;
        b=WvMggL3EDnqCu0UrYpjpWij9gyA03+Yjl1wg/ZaizcFwXHPGIA87/GJfRmQVVrkHH5
         mwe+sCM2HlsEQ6nRPI63un5/3/pdK9RKT1kObzuKgYvJ60uQYcQWDzobXTddE9Zv8EdJ
         LKili0QvYoPwVqZIx/HrTPFHJ1gJDMhzvJ7IZfmYOcsNb69Cd5wLOaqcH76qERpdFeN0
         VOGsLeRAtIW21Cia8s4ilu+ouaKTtKuZeNOfKKYzowNSRSfJCi+FiHaUxVirjj79Fafb
         x5rL4OEQiLV+2NWYrNZ2aRJWbAXT0wupUcPbg0+lTl8b9bmML8El7JCLvodPy/55w9kH
         qXiQ==
X-Gm-Message-State: AOAM532Ya9YZtC0JfLrQ9ThTPFlOMm+TkuHd/Ijzh019eLJA9VR7FTwi
        1INjs+uQPyZqc768yt0cDF4HEJjEuFTF
X-Google-Smtp-Source: ABdhPJwkLd7//Mr/gFPfAdxB/1wpgBdgJZ+JRViex5/PmaODPC9an8QVWtSwKE47VgeT01+28r2KX3BSP4Gx
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:7c53:ec2f:bd26:b69c])
 (user=bgardon job=sendgmr) by 2002:a17:90a:858b:b0:1c6:5bc8:781a with SMTP id
 m11-20020a17090a858b00b001c65bc8781amr110185pjn.0.1648662401123; Wed, 30 Mar
 2022 10:46:41 -0700 (PDT)
Date:   Wed, 30 Mar 2022 10:46:18 -0700
In-Reply-To: <20220330174621.1567317-1-bgardon@google.com>
Message-Id: <20220330174621.1567317-9-bgardon@google.com>
Mime-Version: 1.0
References: <20220330174621.1567317-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v3 08/11] KVM: x86/MMU: Allow NX huge pages to be disabled on
 a per-vm basis
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
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
index b102ba7cf903..b40c3113b14b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7844,6 +7844,17 @@ At this time, KVM_PMU_CAP_DISABLE is the only capability.  Setting
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
index 676705ad1e23..dcff7709444d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1246,6 +1246,8 @@ struct kvm_arch {
 	hpa_t	hv_root_tdp;
 	spinlock_t hv_root_tdp_lock;
 #endif
+
+	bool disable_nx_huge_pages;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index e6cae6f22683..69cffc86b888 100644
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
index af428cb65b3f..eb7b935d3caa 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6202,7 +6202,7 @@ static void __set_nx_huge_pages(bool val)
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
index a2f9a34a0168..5d82a54924e6 100644
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
index 7a066cf92692..ea1d620b35df 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4268,6 +4268,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SYS_ATTRIBUTES:
 	case KVM_CAP_VAPIC:
 	case KVM_CAP_ENABLE_CAP:
+	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
@@ -6061,6 +6062,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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
index 8616af85dc5d..12399c969b42 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1145,6 +1145,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PMU_CAPABILITY 212
 #define KVM_CAP_DISABLE_QUIRKS2 213
 #define KVM_CAP_VM_TSC_CONTROL 214
+#define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 215
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.35.1.1021.g381101b075-goog

