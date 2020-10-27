Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05ADE29CB2B
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 22:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373878AbgJ0VYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 17:24:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:56183 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373808AbgJ0VXz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 17:23:55 -0400
IronPort-SDR: DvEckXsFhCbfikHG4B4pqZnRUQxS4imJXbgIvE8kYUMt5CCC1HgC0zR8QXOfSqd1CO88pyiCzq
 4DY2BkCTnlOw==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="155133714"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="155133714"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 14:23:52 -0700
IronPort-SDR: iVnCIQz6QolkkiKUCdSmfio/AcZTyn9hi6zYsZZ3zl8vLa9YBJx9BeBXhDOiOl49vfLTXJqCMW
 7P9Zq2TKiuQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="524886411"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga006.fm.intel.com with ESMTP; 27 Oct 2020 14:23:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 11/11] KVM: VMX: Track root HPA instead of EPTP for paravirt Hyper-V TLB flush
Date:   Tue, 27 Oct 2020 14:23:46 -0700
Message-Id: <20201027212346.23409-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201027212346.23409-1-sean.j.christopherson@intel.com>
References: <20201027212346.23409-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track the address of the top-level EPT struct, a.k.a. the root HPA,
instead of the EPTP itself for Hyper-V's paravirt TLB flush.  The
paravirt API takes only the address, not the full EPTP, and in theory
tracking the EPTP could lead to false negatives, e.g. if the HPA matched
but the attributes in the EPTP do not.  In practice, such a mismatch is
extremely unlikely, if not flat out impossible, given how KVM generates
the EPTP.

Opportunsitically rename the related fields to use the 'root'
nomenclature, and to prefix them with 'hv_' to connect them to Hyper-V's
paravirt TLB flushing.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 83 ++++++++++++++++++++----------------------
 arch/x86/kvm/vmx/vmx.h |  6 +--
 2 files changed, 42 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 40a67dd45c8c..330d42ac5e02 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -481,18 +481,14 @@ static int kvm_fill_hv_flush_list_func(struct hv_guest_mapping_flush_list *flush
 			range->pages);
 }
 
-static inline int hv_remote_flush_eptp(u64 eptp, struct kvm_tlb_range *range)
+static inline int hv_remote_flush_root_ept(hpa_t root_ept,
+					   struct kvm_tlb_range *range)
 {
-	/*
-	 * FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE hypercall needs address
-	 * of the base of EPT PML4 table, strip off EPT configuration
-	 * information.
-	 */
 	if (range)
-		return hyperv_flush_guest_mapping_range(eptp & PAGE_MASK,
+		return hyperv_flush_guest_mapping_range(root_ept,
 				kvm_fill_hv_flush_list_func, (void *)range);
 	else
-		return hyperv_flush_guest_mapping(eptp & PAGE_MASK);
+		return hyperv_flush_guest_mapping(root_ept);
 }
 
 static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
@@ -500,56 +496,55 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 {
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 	struct kvm_vcpu *vcpu;
-	int ret = 0, i, nr_unique_valid_eptps;
-	u64 tmp_eptp;
+	int ret = 0, i, nr_unique_valid_roots;
+	hpa_t root;
 
-	spin_lock(&kvm_vmx->ept_pointer_lock);
+	spin_lock(&kvm_vmx->hv_root_ept_lock);
 
-	if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
-		nr_unique_valid_eptps = 0;
+	if (!VALID_PAGE(kvm_vmx->hv_root_ept)) {
+		nr_unique_valid_roots = 0;
 
 		/*
-		 * Flush all valid EPTPs, and see if all vCPUs have converged
-		 * on a common EPTP, in which case future flushes can skip the
-		 * loop and flush the common EPTP.
+		 * Flush all valid roots, and see if all vCPUs have converged
+		 * on a common root, in which case future flushes can skip the
+		 * loop and flush the common root.
 		 */
 		kvm_for_each_vcpu(i, vcpu, kvm) {
-			tmp_eptp = to_vmx(vcpu)->ept_pointer;
-			if (!VALID_PAGE(tmp_eptp) ||
-			    tmp_eptp == kvm_vmx->hv_tlb_eptp)
+			root = to_vmx(vcpu)->hv_root_ept;
+			if (!VALID_PAGE(root) || root == kvm_vmx->hv_root_ept)
 				continue;
 
 			/*
-			 * Set the tracked EPTP to the first valid EPTP.  Keep
-			 * this EPTP for the entirety of the loop even if more
-			 * EPTPs are encountered as a low effort optimization
-			 * to avoid flushing the same (first) EPTP again.
+			 * Set the tracked root to the first valid root.  Keep
+			 * this root for the entirety of the loop even if more
+			 * roots are encountered as a low effort optimization
+			 * to avoid flushing the same (first) root again.
 			 */
-			if (++nr_unique_valid_eptps == 1)
-				kvm_vmx->hv_tlb_eptp = tmp_eptp;
+			if (++nr_unique_valid_roots == 1)
+				kvm_vmx->hv_root_ept = root;
 
 			if (!ret)
-				ret = hv_remote_flush_eptp(tmp_eptp, range);
+				ret = hv_remote_flush_root_ept(root, range);
 
 			/*
-			 * Stop processing EPTPs if a failure occurred and
-			 * there is already a detected EPTP mismatch.
+			 * Stop processing roots if a failure occurred and
+			 * multiple valid roots have already been detected.
 			 */
-			if (ret && nr_unique_valid_eptps > 1)
+			if (ret && nr_unique_valid_roots > 1)
 				break;
 		}
 
 		/*
-		 * The optimized flush of a single EPTP can't be used if there
-		 * are multiple valid EPTPs (obviously).
+		 * The optimized flush of a single root can't be used if there
+		 * are multiple valid roots (obviously).
 		 */
-		if (nr_unique_valid_eptps > 1)
-			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
+		if (nr_unique_valid_roots > 1)
+			kvm_vmx->hv_root_ept = INVALID_PAGE;
 	} else {
-		ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
+		ret = hv_remote_flush_root_ept(kvm_vmx->hv_root_ept, range);
 	}
 
-	spin_unlock(&kvm_vmx->ept_pointer_lock);
+	spin_unlock(&kvm_vmx->hv_root_ept_lock);
 	return ret;
 }
 static int hv_remote_flush_tlb(struct kvm *kvm)
@@ -584,17 +579,17 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
 
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
-static void hv_load_mmu_eptp(struct kvm_vcpu *vcpu, u64 eptp)
+static void hv_track_root_ept(struct kvm_vcpu *vcpu, hpa_t root_ept)
 {
 #if IS_ENABLED(CONFIG_HYPERV)
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
 
 	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb) {
-		spin_lock(&kvm_vmx->ept_pointer_lock);
-		to_vmx(vcpu)->ept_pointer = eptp;
-		if (eptp != kvm_vmx->hv_tlb_eptp)
-			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
-		spin_unlock(&kvm_vmx->ept_pointer_lock);
+		spin_lock(&kvm_vmx->hv_root_ept_lock);
+		to_vmx(vcpu)->hv_root_ept = root_ept;
+		if (root_ept != kvm_vmx->hv_root_ept)
+			kvm_vmx->hv_root_ept = INVALID_PAGE;
+		spin_unlock(&kvm_vmx->hv_root_ept_lock);
 	}
 #endif
 }
@@ -3092,7 +3087,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 		eptp = construct_eptp(vcpu, root_hpa, root_level);
 		vmcs_write64(EPT_POINTER, eptp);
 
-		hv_load_mmu_eptp(vcpu, eptp);
+		hv_track_root_ept(vcpu, root_hpa);
 
 		if (!enable_unrestricted_guest && !is_paging(vcpu))
 			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
@@ -6964,7 +6959,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	vmx->pi_desc.sn = 1;
 
 #if IS_ENABLED(CONFIG_HYPERV)
-	vmx->ept_pointer = INVALID_PAGE;
+	vmx->hv_root_ept = INVALID_PAGE;
 #endif
 	return 0;
 
@@ -6983,7 +6978,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 static int vmx_vm_init(struct kvm *kvm)
 {
 #if IS_ENABLED(CONFIG_HYPERV)
-	spin_lock_init(&to_kvm_vmx(kvm)->ept_pointer_lock);
+	spin_lock_init(&to_kvm_vmx(kvm)->hv_root_ept_lock);
 #endif
 
 	if (!ple_gap)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 2bd86d8b2f4b..5c98d16a0c6f 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -277,7 +277,7 @@ struct vcpu_vmx {
 	u64 msr_ia32_feature_control;
 	u64 msr_ia32_feature_control_valid_bits;
 #if IS_ENABLED(CONFIG_HYPERV)
-	u64 ept_pointer;
+	u64 hv_root_ept;
 #endif
 
 	struct pt_desc pt_desc;
@@ -298,8 +298,8 @@ struct kvm_vmx {
 	gpa_t ept_identity_map_addr;
 
 #if IS_ENABLED(CONFIG_HYPERV)
-	hpa_t hv_tlb_eptp;
-	spinlock_t ept_pointer_lock;
+	hpa_t hv_root_ept;
+	spinlock_t hv_root_ept_lock;
 #endif
 };
 
-- 
2.28.0

