Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CE62944D2
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 23:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438865AbgJTV4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 17:56:40 -0400
Received: from mga12.intel.com ([192.55.52.136]:61055 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438840AbgJTV4T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 17:56:19 -0400
IronPort-SDR: Lc7BWW8YtSVgcrgC5uK8cW8zJF6NAOe+pZ7IetIvYPqzQYysRAaO5pQF5x44v2ryD5DtlFnct0
 yiqRwRZvbLKQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="146576334"
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="146576334"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 14:56:17 -0700
IronPort-SDR: 1TIZV8BOJVbsQzZODv96b8HrIpMMIQAcnQqLPdRjW8l2XIR/iq6vYH8BReydnrfwJZcpciGXYX
 OpZXP9Csi1ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="301827761"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga008.fm.intel.com with ESMTP; 20 Oct 2020 14:56:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 10/10] KVM: VMX: Track PGD instead of EPTP for paravirt Hyper-V TLB flush
Date:   Tue, 20 Oct 2020 14:56:13 -0700
Message-Id: <20201020215613.8972-11-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201020215613.8972-1-sean.j.christopherson@intel.com>
References: <20201020215613.8972-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track the address of the top-level EPT struct, a.k.a. the PGD, instead
of the EPTP itself for Hyper-V's paravirt TLB flush.  The paravirt API
takes the PGD, not the EPTP, and in theory tracking the EPTP could lead
to false negatives, e.g. if the PGD matched but the attributes in the
EPTP do not.  In practice, such a mismatch is extremely unlikely, if not
flat out impossible, given how KVM generates the EPTP.

Opportunistically rename the related fields to use the 'pgd'
nomenclature, and to prefix them with 'hv_tlb' to connect them to
Hyper-V's paravirt TLB flushing.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 53 +++++++++++++++++++-----------------------
 arch/x86/kvm/vmx/vmx.h |  6 ++---
 2 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e0fea09a6e42..89019e6476b3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -478,18 +478,13 @@ static int kvm_fill_hv_flush_list_func(struct hv_guest_mapping_flush_list *flush
 			range->pages);
 }
 
-static inline int hv_remote_flush_eptp(u64 eptp, struct kvm_tlb_range *range)
+static inline int hv_remote_flush_pgd(u64 pgd, struct kvm_tlb_range *range)
 {
-	/*
-	 * FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE hypercall needs address
-	 * of the base of EPT PML4 table, strip off EPT configuration
-	 * information.
-	 */
 	if (range)
-		return hyperv_flush_guest_mapping_range(eptp & PAGE_MASK,
+		return hyperv_flush_guest_mapping_range(pgd,
 				kvm_fill_hv_flush_list_func, (void *)range);
 	else
-		return hyperv_flush_guest_mapping(eptp & PAGE_MASK);
+		return hyperv_flush_guest_mapping(pgd);
 }
 
 static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
@@ -499,37 +494,37 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 	struct kvm_vcpu *vcpu;
 	int ret = 0, i;
 	bool mismatch;
-	u64 tmp_eptp;
+	u64 tmp_pgd;
 
-	spin_lock(&kvm_vmx->ept_pointer_lock);
+	spin_lock(&kvm_vmx->hv_tlb_pgd_lock);
 
-	if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
+	if (!VALID_PAGE(kvm_vmx->hv_tlb_pgd)) {
 		mismatch = false;
 
 		kvm_for_each_vcpu(i, vcpu, kvm) {
-			tmp_eptp = to_vmx(vcpu)->ept_pointer;
-			if (!VALID_PAGE(tmp_eptp) ||
-			    tmp_eptp == kvm_vmx->hv_tlb_eptp)
+			tmp_pgd = to_vmx(vcpu)->hv_tlb_pgd;
+			if (!VALID_PAGE(tmp_pgd) ||
+			    tmp_pgd == kvm_vmx->hv_tlb_pgd)
 				continue;
 
-			if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp))
-				kvm_vmx->hv_tlb_eptp = tmp_eptp;
+			if (!VALID_PAGE(kvm_vmx->hv_tlb_pgd))
+				kvm_vmx->hv_tlb_pgd = tmp_pgd;
 			else
 				mismatch = true;
 
 			if (!ret)
-				ret = hv_remote_flush_eptp(tmp_eptp, range);
+				ret = hv_remote_flush_pgd(tmp_pgd, range);
 
 			if (ret && mismatch)
 				break;
 		}
 		if (mismatch)
-			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
+			kvm_vmx->hv_tlb_pgd = INVALID_PAGE;
 	} else {
-		ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
+		ret = hv_remote_flush_pgd(kvm_vmx->hv_tlb_pgd, range);
 	}
 
-	spin_unlock(&kvm_vmx->ept_pointer_lock);
+	spin_unlock(&kvm_vmx->hv_tlb_pgd_lock);
 	return ret;
 }
 static int hv_remote_flush_tlb(struct kvm *kvm)
@@ -564,17 +559,17 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
 
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
-static void hv_load_mmu_eptp(struct kvm_vcpu *vcpu, u64 eptp)
+static void hv_load_mmu_pgd(struct kvm_vcpu *vcpu, u64 pgd)
 {
 #if IS_ENABLED(CONFIG_HYPERV)
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
 
 	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb) {
-		spin_lock(&kvm_vmx->ept_pointer_lock);
-		to_vmx(vcpu)->ept_pointer = eptp;
-		if (eptp != kvm_vmx->hv_tlb_eptp)
-			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
-		spin_unlock(&kvm_vmx->ept_pointer_lock);
+		spin_lock(&kvm_vmx->hv_tlb_pgd_lock);
+		to_vmx(vcpu)->hv_tlb_pgd = pgd;
+		if (pgd != kvm_vmx->hv_tlb_pgd)
+			kvm_vmx->hv_tlb_pgd = INVALID_PAGE;
+		spin_unlock(&kvm_vmx->hv_tlb_pgd_lock);
 	}
 #endif
 }
@@ -3059,7 +3054,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
 		eptp = construct_eptp(vcpu, pgd, pgd_level);
 		vmcs_write64(EPT_POINTER, eptp);
 
-		hv_load_mmu_eptp(vcpu, eptp);
+		hv_load_mmu_pgd(vcpu, pgd);
 
 		if (!enable_unrestricted_guest && !is_paging(vcpu))
 			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
@@ -6938,7 +6933,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	vmx->pi_desc.sn = 1;
 
 #if IS_ENABLED(CONFIG_HYPERV)
-	vmx->ept_pointer = INVALID_PAGE;
+	vmx->hv_tlb_pgd = INVALID_PAGE;
 #endif
 	return 0;
 
@@ -6957,7 +6952,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 static int vmx_vm_init(struct kvm *kvm)
 {
 #if IS_ENABLED(CONFIG_HYPERV)
-	spin_lock_init(&to_kvm_vmx(kvm)->ept_pointer_lock);
+	spin_lock_init(&to_kvm_vmx(kvm)->hv_tlb_pgd_lock);
 #endif
 
 	if (!ple_gap)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 1b8c08e483cd..4d61fb8e8d9d 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -277,7 +277,7 @@ struct vcpu_vmx {
 	u64 msr_ia32_feature_control;
 	u64 msr_ia32_feature_control_valid_bits;
 #if IS_ENABLED(CONFIG_HYPERV)
-	u64 ept_pointer;
+	u64 hv_tlb_pgd;
 #endif
 
 	struct pt_desc pt_desc;
@@ -298,8 +298,8 @@ struct kvm_vmx {
 	gpa_t ept_identity_map_addr;
 
 #if IS_ENABLED(CONFIG_HYPERV)
-	hpa_t hv_tlb_eptp;
-	spinlock_t ept_pointer_lock;
+	hpa_t hv_tlb_pgd;
+	spinlock_t hv_tlb_pgd_lock;
 #endif
 };
 
-- 
2.28.0

