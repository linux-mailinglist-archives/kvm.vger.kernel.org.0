Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8FCF653883
	for <lists+kvm@lfdr.de>; Wed, 21 Dec 2022 23:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234964AbiLUWYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 17:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234948AbiLUWYb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 17:24:31 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578BB2715E
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:29 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id jc4-20020a17090325c400b00189ceee4049so152620plb.3
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 14:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yXovaXGmQ2hj+xhfXzlYPf6jy3g3M6Z97i9sJYKtL7o=;
        b=XUqeRrYpmjbz24aOUCRdZhU/hasfAHWkBLZ4lTvglulOiCrqV4g30TxCuKN75BwGCU
         4LXBLsZDthjsLf+2AAZudjXxcPvh/idm+4kfCCahPLRDtw4awMTHPJRM+3GLuCE2z2xW
         UXWY9noDLDSwD7MOFEHp549vimmJUdsZlZLlkat6N1yZkyca8ji4la9bIC+7aRA7MNjJ
         YtbFM6nqgK4y9kxkqqzX2AYDFPzZeTYjsNQEJ2emwoQuCWJEmRyoXNEcGGrMTsjlBGmI
         JZjMUvnzAPwUHXLd7BkZn8APBej2IkOxylMhK0+Z0QbMqCvFV2hi5iU8e6JCqA3ryxd/
         vIwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yXovaXGmQ2hj+xhfXzlYPf6jy3g3M6Z97i9sJYKtL7o=;
        b=S25hcHMGVzrIpcrgRM9zjR54QMNcTx5nKhcmd79tw2NElUsThtBgtBvRTUnEcUMMbP
         +wAQnOBn7SSXqXgVtioGl0l+BD8SfVPhhf/4qCAZ9ZwzYA4w6OTUoHWmAKijUgfUVvs1
         1gU2FSCTnVjhrhsaIsEyL4JkBry0REPTePzUmjfcvCt3OjMXtDigUs93VqcaoFhIrFNQ
         C7k/eCeb80mu++/ySRuxgd2/u1DNeoTTOKifJDhsB6OIr5zFpEMBGe40zbUey+JPKjiJ
         xJHRCnR7gv8ss1vNcseYt108LpqlvQ9MVZS3vFerUUIn1kRlPNQ6G8BJyzieko9dm0+e
         8MOQ==
X-Gm-Message-State: AFqh2kpSLN9s3FrHy7ouaceU6bla8r7T4jRnM6H2jkThLqDJ2PH3AdLJ
        SJxnTdZeMNI053yEWUff9ghnWOQlG6bD
X-Google-Smtp-Source: AMrXdXv8RdH6TwKdO23ZhAUnv4pAyWPuCeF7bltNA6yJNFTlLDH8JfMjr5eV9VokhVrwkrGyuruwOWr5Fb3F
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:90a:9913:b0:225:aa06:8fcb with SMTP id
 b19-20020a17090a991300b00225aa068fcbmr167806pjp.78.1671661468931; Wed, 21 Dec
 2022 14:24:28 -0800 (PST)
Date:   Wed, 21 Dec 2022 22:24:08 +0000
In-Reply-To: <20221221222418.3307832-1-bgardon@google.com>
Mime-Version: 1.0
References: <20221221222418.3307832-1-bgardon@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221221222418.3307832-5-bgardon@google.com>
Subject: [RFC 04/14] KVM: x86/MMU: Expose functions for paging_tmpl.h
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Nagareddy Reddy <nspreddy@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for moving paging_tmpl.h to shadow_mmu.c, expose various
functions it needs through mmu_internal.h. This includes modifying the
BUILD_MMU_ROLE_ACCESSOR macro so that it does not automatically include
the static label, since some but not all of the accessors are needed by
paging_tmpl.h.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 32 ++++++++++++++++----------------
 arch/x86/kvm/mmu/mmu_internal.h | 16 ++++++++++++++++
 2 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bf14e181eb12..a17e8a79e4df 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -153,18 +153,18 @@ BUILD_MMU_ROLE_REGS_ACCESSOR(efer, lma, EFER_LMA);
  * and the vCPU may be incorrect/irrelevant.
  */
 #define BUILD_MMU_ROLE_ACCESSOR(base_or_ext, reg, name)		\
-static inline bool __maybe_unused is_##reg##_##name(struct kvm_mmu *mmu)	\
+inline bool __maybe_unused is_##reg##_##name(struct kvm_mmu *mmu)	\
 {								\
 	return !!(mmu->cpu_role. base_or_ext . reg##_##name);	\
 }
 BUILD_MMU_ROLE_ACCESSOR(base, cr0, wp);
-BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pse);
+static BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pse);
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smep);
-BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smap);
-BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pke);
-BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, la57);
+static BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smap);
+static BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pke);
+static BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, la57);
 BUILD_MMU_ROLE_ACCESSOR(base, efer, nx);
-BUILD_MMU_ROLE_ACCESSOR(ext,  efer, lma);
+static BUILD_MMU_ROLE_ACCESSOR(ext,  efer, lma);
 
 static inline bool is_cr0_pg(struct kvm_mmu *mmu)
 {
@@ -210,7 +210,7 @@ void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 	kvm_flush_remote_tlbs_with_range(kvm, &range);
 }
 
-static gfn_t get_mmio_spte_gfn(u64 spte)
+gfn_t get_mmio_spte_gfn(u64 spte)
 {
 	u64 gpa = spte & shadow_nonpresent_or_rsvd_lower_gfn_mask;
 
@@ -240,7 +240,7 @@ static bool check_mmio_spte(struct kvm_vcpu *vcpu, u64 spte)
 	return likely(kvm_gen == spte_gen);
 }
 
-static int is_cpuid_PSE36(void)
+int is_cpuid_PSE36(void)
 {
 	return 1;
 }
@@ -279,7 +279,7 @@ void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	}
 }
 
-static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
+int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 {
 	int r;
 
@@ -818,8 +818,8 @@ static int kvm_handle_error_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
 	return -EFAULT;
 }
 
-static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
-			       unsigned int access)
+int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+			unsigned int access)
 {
 	/* The pfn is invalid, report the error! */
 	if (unlikely(is_error_pfn(fault->pfn)))
@@ -1275,8 +1275,8 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 	return RET_PF_RETRY;
 }
 
-static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
-					 struct kvm_page_fault *fault)
+bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
+				  struct kvm_page_fault *fault)
 {
 	if (unlikely(fault->rsvd))
 		return false;
@@ -1338,7 +1338,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
 }
 
-static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
+int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
 	bool async;
@@ -1403,8 +1403,8 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
  * Returns true if the page fault is stale and needs to be retried, i.e. if the
  * root was invalidated by a memslot update or a relevant mmu_notifier fired.
  */
-static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
-				struct kvm_page_fault *fault, int mmu_seq)
+bool is_page_fault_stale(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+			 int mmu_seq)
 {
 	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root.hpa);
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 74a99b67f09e..957376fcb333 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -341,6 +341,22 @@ bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu);
 void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu);
 
+int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect);
 bool need_topup_split_caches_or_resched(struct kvm *kvm);
 int topup_split_caches(struct kvm *kvm);
+
+bool is_page_fault_stale(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+			 int mmu_seq);
+bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
+				  struct kvm_page_fault *fault);
+int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
+int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
+			unsigned int access);
+
+gfn_t get_mmio_spte_gfn(u64 spte);
+
+bool is_efer_nx(struct kvm_mmu *mmu);
+bool is_cr4_smep(struct kvm_mmu *mmu);
+bool is_cr0_wp(struct kvm_mmu *mmu);
+int is_cpuid_PSE36(void);
 #endif /* __KVM_X86_MMU_INTERNAL_H */
-- 
2.39.0.314.g84b9a713c41-goog

