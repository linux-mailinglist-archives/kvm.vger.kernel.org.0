Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E783C29CB28
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 22:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373831AbgJ0VX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 17:23:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:56185 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373792AbgJ0VXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 17:23:53 -0400
IronPort-SDR: vnGtHuTiKOTaRfF1oby53cCR6VXxmRFkT8DT/aNx2IsmM4cDtZq+pUWmedacisMQIq1sRPYtPo
 6G34VpxmAk8g==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="155133707"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="155133707"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 14:23:51 -0700
IronPort-SDR: sXAJxwM1RQOb5fQjqzpMnWsLfJwVufp+PmFoQC3eCUClLlnNU9cXiTe/7HFdiBL3j4mngwS0BX
 lfzdk1RKVxvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="524886393"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga006.fm.intel.com with ESMTP; 27 Oct 2020 14:23:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 06/11] KVM: VMX: Invalidate hv_tlb_eptp to denote an EPTP mismatch
Date:   Tue, 27 Oct 2020 14:23:41 -0700
Message-Id: <20201027212346.23409-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201027212346.23409-1-sean.j.christopherson@intel.com>
References: <20201027212346.23409-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the dedicated 'ept_pointers_match' field in favor of stuffing
'hv_tlb_eptp' with INVALID_PAGE to mark it as invalid, i.e. to denote
that there is at least one EPTP mismatch.  Use a local variable to
track whether or not a mismatch is detected so that hv_tlb_eptp can be
used to skip redundant flushes.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 35 +++++++++++++++++++++++------------
 arch/x86/kvm/vmx/vmx.h |  7 -------
 2 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 17b228c4ba19..25a714cda662 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -500,32 +500,44 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 {
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 	struct kvm_vcpu *vcpu;
-	int ret = 0, i;
+	int ret = 0, i, nr_unique_valid_eptps;
 	u64 tmp_eptp;
 
 	spin_lock(&kvm_vmx->ept_pointer_lock);
 
-	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
-		kvm_vmx->ept_pointers_match = EPT_POINTERS_MATCH;
-		kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
+	if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
+		nr_unique_valid_eptps = 0;
 
+		/*
+		 * Flush all valid EPTPs, and see if all vCPUs have converged
+		 * on a common EPTP, in which case future flushes can skip the
+		 * loop and flush the common EPTP.
+		 */
 		kvm_for_each_vcpu(i, vcpu, kvm) {
 			tmp_eptp = to_vmx(vcpu)->ept_pointer;
 			if (!VALID_PAGE(tmp_eptp) ||
 			    tmp_eptp == kvm_vmx->hv_tlb_eptp)
 				continue;
 
-			if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp))
+			/*
+			 * Set the tracked EPTP to the first valid EPTP.  Keep
+			 * this EPTP for the entirety of the loop even if more
+			 * EPTPs are encountered as a low effort optimization
+			 * to avoid flushing the same (first) EPTP again.
+			 */
+			if (++nr_unique_valid_eptps == 1)
 				kvm_vmx->hv_tlb_eptp = tmp_eptp;
-			else
-				kvm_vmx->ept_pointers_match
-					= EPT_POINTERS_MISMATCH;
 
 			ret |= hv_remote_flush_eptp(tmp_eptp, range);
 		}
-		if (kvm_vmx->ept_pointers_match == EPT_POINTERS_MISMATCH)
+
+		/*
+		 * The optimized flush of a single EPTP can't be used if there
+		 * are multiple valid EPTPs (obviously).
+		 */
+		if (nr_unique_valid_eptps > 1)
 			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
-	} else if (VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
+	} else {
 		ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
 	}
 
@@ -3060,8 +3072,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 		if (kvm_x86_ops.tlb_remote_flush) {
 			spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
 			to_vmx(vcpu)->ept_pointer = eptp;
-			to_kvm_vmx(kvm)->ept_pointers_match
-				= EPT_POINTERS_CHECK;
+			to_kvm_vmx(kvm)->hv_tlb_eptp = INVALID_PAGE;
 			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
 		}
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9a25e83f8b96..cecc2a641e19 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -288,12 +288,6 @@ struct vcpu_vmx {
 	} shadow_msr_intercept;
 };
 
-enum ept_pointers_status {
-	EPT_POINTERS_CHECK = 0,
-	EPT_POINTERS_MATCH = 1,
-	EPT_POINTERS_MISMATCH = 2
-};
-
 struct kvm_vmx {
 	struct kvm kvm;
 
@@ -302,7 +296,6 @@ struct kvm_vmx {
 	gpa_t ept_identity_map_addr;
 
 	hpa_t hv_tlb_eptp;
-	enum ept_pointers_status ept_pointers_match;
 	spinlock_t ept_pointer_lock;
 };
 
-- 
2.28.0

