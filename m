Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032082944C7
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 23:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438849AbgJTV4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 17:56:20 -0400
Received: from mga12.intel.com ([192.55.52.136]:61052 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438824AbgJTV4R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 17:56:17 -0400
IronPort-SDR: m1pwwiwuFP8pf40EaZDAWRBkHr64VWva6ebVdXxzJXQcBJcLHvvJVerwfqRLo/AcF+QLlB6NFS
 C0y6nopyOHfw==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="146576328"
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="146576328"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 14:56:16 -0700
IronPort-SDR: uJzPh5WPII/Cn1CseZFrZXN5T7+iUBREMjq8DT2exYhRR4s9rbt8j1ncQD9ARAMH0gGQq4dSei
 4fD7mo1UnmEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="301827741"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga008.fm.intel.com with ESMTP; 20 Oct 2020 14:56:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/10] KVM: VMX: Invalidate hv_tlb_eptp to denote an EPTP mismatch
Date:   Tue, 20 Oct 2020 14:56:08 -0700
Message-Id: <20201020215613.8972-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201020215613.8972-1-sean.j.christopherson@intel.com>
References: <20201020215613.8972-1-sean.j.christopherson@intel.com>
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
 arch/x86/kvm/vmx/vmx.c | 16 ++++++++--------
 arch/x86/kvm/vmx/vmx.h |  7 -------
 2 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 52cb9eec1db3..4dfde8b64750 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -498,13 +498,13 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
 	struct kvm_vcpu *vcpu;
 	int ret = 0, i;
+	bool mismatch;
 	u64 tmp_eptp;
 
 	spin_lock(&kvm_vmx->ept_pointer_lock);
 
-	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
-		kvm_vmx->ept_pointers_match = EPT_POINTERS_MATCH;
-		kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
+	if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
+		mismatch = false;
 
 		kvm_for_each_vcpu(i, vcpu, kvm) {
 			tmp_eptp = to_vmx(vcpu)->ept_pointer;
@@ -515,12 +515,13 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 			if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp))
 				kvm_vmx->hv_tlb_eptp = tmp_eptp;
 			else
-				kvm_vmx->ept_pointers_match
-					= EPT_POINTERS_MISMATCH;
+				mismatch = true;
 
 			ret |= hv_remote_flush_eptp(tmp_eptp, range);
 		}
-	} else if (VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
+		if (mismatch)
+			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
+	} else {
 		ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
 	}
 
@@ -3042,8 +3043,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
 		if (kvm_x86_ops.tlb_remote_flush) {
 			spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
 			to_vmx(vcpu)->ept_pointer = eptp;
-			to_kvm_vmx(kvm)->ept_pointers_match
-				= EPT_POINTERS_CHECK;
+			to_kvm_vmx(kvm)->hv_tlb_eptp = INVALID_PAGE;
 			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
 		}
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 3d557a065c01..e8d7d07b2020 100644
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

