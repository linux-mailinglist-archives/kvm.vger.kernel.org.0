Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0076D714A
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 02:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbjDEAbr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 20:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236595AbjDEAbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 20:31:40 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED36144A2
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 17:31:38 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id e5-20020a17090301c500b001a1aa687e4bso20160072plh.17
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 17:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680654698;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/gPBL0l5v9wIVeXYa3qg3U83BOdRbqodER9mbhJVPk0=;
        b=nJVurvW323NT4SWBxHv530JErfbP3mT9QYdyaXNoy+hy0eOjruZt9ZC0H56i6aplJo
         sB972VEVAu4g59VFuYJFiDXDBl6+yDx4s0GPgavlKCE8Vi8qJU1pjUpfHYGIG/hi7bjM
         25wJaF56PnhL9ABNlS/BnwMqjff6N3tT2Uc6LsZ1R4IGCFWDDGLRU1JXPoYm3rmUamLO
         SF08ch4LomH26pNZBcQ3J15+5S9a500FbnEwrODy+cZUZw2AXYfa1oeanC1oh8VxxJEp
         k0tlOCYqa3WZzWf/ovSCN6+BIZWIaWTOY+QL6K3jRY7l+Fwg7mMNZk3FkI3rQpMYMBk2
         SK4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680654698;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/gPBL0l5v9wIVeXYa3qg3U83BOdRbqodER9mbhJVPk0=;
        b=ayhAsVTDiez7EWQH2qmskj9JOBHEABunpHbPvhxK5Ef01q2eBYy99E0Thf5KIiT4+W
         6zy9FPEqi06JMyjMb5DzU52ze8NVOeC9bplyd8F7lnyaYTzJgVc9HhJTdRuy7GxxzT+7
         ZpKBSC3la1aIIgyIxLPwhR9a3EtzbTuinctVla+m2buK9qUsIhL/Z8MRr5M+qOhFYaZY
         nDIztGPYXSejnKk8zhJKJR6nke4gGi/bJkuHLSrUpqVsBxaVADCKkWAS9SLyARNgvnGK
         60pYc8VyaJ32cMOcLFP1cSTLhghwZXLvBH5q9PCz7c6oqSAdTWXQtps5cLdxtnlysQXn
         OBTg==
X-Gm-Message-State: AAQBX9euSP/fkamiAA6Zx2HsDcQUfbyphhZFQsIcopqkKg21DQtytfUu
        NS1V4mdiMbJYugiBr4av0osZT74tRBY=
X-Google-Smtp-Source: AKy350YUioXL5G2SVImQLggkpj5oK5ffcr32DZG5LDEbmZsV9ZGIqApEa6TM0PiI8S0KPBneRHFwWML1S5Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:4206:0:b0:514:2040:24ba with SMTP id
 p6-20020a634206000000b00514204024bamr1024394pga.9.1680654698523; Tue, 04 Apr
 2023 17:31:38 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 17:31:32 -0700
In-Reply-To: <20230405003133.419177-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230405003133.419177-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405003133.419177-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: x86: Rename Hyper-V remote TLB hooks to match
 established scheme
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename the Hyper-V hooks for TLB flushing to match the naming scheme used
by all the other TLB flushing hooks, e.g. in kvm_x86_ops, vendor code,
arch hooks from common code, etc.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  4 ++--
 arch/x86/include/asm/kvm_host.h    | 10 +++++-----
 arch/x86/kvm/kvm_onhyperv.c        | 13 ++++++-------
 arch/x86/kvm/kvm_onhyperv.h        |  5 ++---
 arch/x86/kvm/mmu/mmu.c             | 12 ++++++------
 arch/x86/kvm/svm/svm_onhyperv.h    |  5 ++---
 arch/x86/kvm/vmx/vmx.c             |  5 ++---
 7 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 8dc345cc6318..430ca22170e0 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -54,8 +54,8 @@ KVM_X86_OP(set_rflags)
 KVM_X86_OP(get_if_flag)
 KVM_X86_OP(flush_tlb_all)
 KVM_X86_OP(flush_tlb_current)
-KVM_X86_OP_OPTIONAL(tlb_remote_flush)
-KVM_X86_OP_OPTIONAL(tlb_remote_flush_with_range)
+KVM_X86_OP_OPTIONAL(flush_remote_tlbs)
+KVM_X86_OP_OPTIONAL(flush_remote_tlbs_range)
 KVM_X86_OP(flush_tlb_gva)
 KVM_X86_OP(flush_tlb_guest)
 KVM_X86_OP(vcpu_pre_run)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 991296a2f807..ec22101410ee 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1588,9 +1588,9 @@ struct kvm_x86_ops {
 
 	void (*flush_tlb_all)(struct kvm_vcpu *vcpu);
 	void (*flush_tlb_current)(struct kvm_vcpu *vcpu);
-	int  (*tlb_remote_flush)(struct kvm *kvm);
-	int  (*tlb_remote_flush_with_range)(struct kvm *kvm,
-			struct kvm_tlb_range *range);
+	int  (*flush_remote_tlbs)(struct kvm *kvm);
+	int  (*flush_remote_tlbs_range)(struct kvm *kvm,
+					struct kvm_tlb_range *range);
 
 	/*
 	 * Flush any TLB entries associated with the given GVA.
@@ -1794,8 +1794,8 @@ void kvm_arch_free_vm(struct kvm *kvm);
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
 static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
 {
-	if (kvm_x86_ops.tlb_remote_flush &&
-	    !static_call(kvm_x86_tlb_remote_flush)(kvm))
+	if (kvm_x86_ops.flush_remote_tlbs &&
+	    !static_call(kvm_x86_flush_remote_tlbs)(kvm))
 		return 0;
 	else
 		return -ENOTSUPP;
diff --git a/arch/x86/kvm/kvm_onhyperv.c b/arch/x86/kvm/kvm_onhyperv.c
index 482d6639ef88..2e2d08da8a3f 100644
--- a/arch/x86/kvm/kvm_onhyperv.c
+++ b/arch/x86/kvm/kvm_onhyperv.c
@@ -29,8 +29,7 @@ static inline int hv_remote_flush_root_tdp(hpa_t root_tdp,
 		return hyperv_flush_guest_mapping(root_tdp);
 }
 
-int hv_remote_flush_tlb_with_range(struct kvm *kvm,
-		struct kvm_tlb_range *range)
+int hv_flush_remote_tlbs_range(struct kvm *kvm, struct kvm_tlb_range *range)
 {
 	struct kvm_arch *kvm_arch = &kvm->arch;
 	struct kvm_vcpu *vcpu;
@@ -86,19 +85,19 @@ int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 	spin_unlock(&kvm_arch->hv_root_tdp_lock);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(hv_remote_flush_tlb_with_range);
+EXPORT_SYMBOL_GPL(hv_flush_remote_tlbs_range);
 
-int hv_remote_flush_tlb(struct kvm *kvm)
+int hv_flush_remote_tlbs(struct kvm *kvm)
 {
-	return hv_remote_flush_tlb_with_range(kvm, NULL);
+	return hv_flush_remote_tlbs_range(kvm, NULL);
 }
-EXPORT_SYMBOL_GPL(hv_remote_flush_tlb);
+EXPORT_SYMBOL_GPL(hv_flush_remote_tlbs);
 
 void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
 {
 	struct kvm_arch *kvm_arch = &vcpu->kvm->arch;
 
-	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb) {
+	if (kvm_x86_ops.flush_remote_tlbs == hv_flush_remote_tlbs) {
 		spin_lock(&kvm_arch->hv_root_tdp_lock);
 		vcpu->arch.hv_root_tdp = root_tdp;
 		if (root_tdp != kvm_arch->hv_root_tdp)
diff --git a/arch/x86/kvm/kvm_onhyperv.h b/arch/x86/kvm/kvm_onhyperv.h
index 287e98ef9df3..55d7fcb84cc1 100644
--- a/arch/x86/kvm/kvm_onhyperv.h
+++ b/arch/x86/kvm/kvm_onhyperv.h
@@ -7,9 +7,8 @@
 #define __ARCH_X86_KVM_KVM_ONHYPERV_H__
 
 #if IS_ENABLED(CONFIG_HYPERV)
-int hv_remote_flush_tlb_with_range(struct kvm *kvm,
-		struct kvm_tlb_range *range);
-int hv_remote_flush_tlb(struct kvm *kvm);
+int hv_flush_remote_tlbs_range(struct kvm *kvm, struct kvm_tlb_range *range);
+int hv_flush_remote_tlbs(struct kvm *kvm);
 void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp);
 #else /* !CONFIG_HYPERV */
 static inline void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4c874d4ec68f..7654be48ff69 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -270,9 +270,9 @@ static inline unsigned long kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu,
 	return mmu->get_guest_pgd(vcpu);
 }
 
-static inline bool kvm_available_flush_tlb_with_range(void)
+static inline bool kvm_available_flush_remote_tlbs_range(void)
 {
-	return kvm_x86_ops.tlb_remote_flush_with_range;
+	return kvm_x86_ops.flush_remote_tlbs_range;
 }
 
 void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
@@ -284,8 +284,8 @@ void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
 	range.start_gfn = start_gfn;
 	range.pages = nr_pages;
 
-	if (kvm_x86_ops.tlb_remote_flush_with_range)
-		ret = static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, &range);
+	if (kvm_x86_ops.flush_remote_tlbs_range)
+		ret = static_call(kvm_x86_flush_remote_tlbs_range)(kvm, &range);
 
 	if (ret)
 		kvm_flush_remote_tlbs(kvm);
@@ -1498,7 +1498,7 @@ static bool kvm_set_pte_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 		}
 	}
 
-	if (need_flush && kvm_available_flush_tlb_with_range()) {
+	if (need_flush && kvm_available_flush_remote_tlbs_range()) {
 		kvm_flush_remote_tlbs_gfn(kvm, gfn, level);
 		return false;
 	}
@@ -6623,7 +6623,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 							       PG_LEVEL_NUM)) {
 			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
 
-			if (kvm_available_flush_tlb_with_range())
+			if (kvm_available_flush_remote_tlbs_range())
 				kvm_flush_remote_tlbs_sptep(kvm, sptep);
 			else
 				need_tlb_flush = 1;
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index cff838f15db5..823001033539 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -35,9 +35,8 @@ static inline __init void svm_hv_hardware_setup(void)
 	if (npt_enabled &&
 	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB) {
 		pr_info(KBUILD_MODNAME ": Hyper-V enlightened NPT TLB flush enabled\n");
-		svm_x86_ops.tlb_remote_flush = hv_remote_flush_tlb;
-		svm_x86_ops.tlb_remote_flush_with_range =
-				hv_remote_flush_tlb_with_range;
+		svm_x86_ops.flush_remote_tlbs = hv_flush_remote_tlbs;
+		svm_x86_ops.flush_remote_tlbs_range = hv_flush_remote_tlbs_range;
 	}
 
 	if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d7bf14abdba1..8031bded75cc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8432,9 +8432,8 @@ static __init int hardware_setup(void)
 #if IS_ENABLED(CONFIG_HYPERV)
 	if (ms_hyperv.nested_features & HV_X64_NESTED_GUEST_MAPPING_FLUSH
 	    && enable_ept) {
-		vmx_x86_ops.tlb_remote_flush = hv_remote_flush_tlb;
-		vmx_x86_ops.tlb_remote_flush_with_range =
-				hv_remote_flush_tlb_with_range;
+		vmx_x86_ops.flush_remote_tlbs = hv_flush_remote_tlbs;
+		vmx_x86_ops.flush_remote_tlbs_range = hv_flush_remote_tlbs_range;
 	}
 #endif
 
-- 
2.40.0.348.gf938b09366-goog

