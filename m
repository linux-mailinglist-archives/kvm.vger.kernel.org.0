Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B2829CB46
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 22:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374013AbgJ0VZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 17:25:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:56183 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373788AbgJ0VXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 17:23:53 -0400
IronPort-SDR: MjaxPnqVvhOpaDtIW0aApqqjEuV0epFKE2PYvksI6ZBKZCiChXCaXYwALV+z5Q5bNJXil0QdQS
 1xMSRS5/wwKw==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="155133705"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="155133705"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 14:23:51 -0700
IronPort-SDR: vzsC4nexef7kWrWq/Cq/SPRg1mTlt51mgSCCsWjdQwg7b9VzKuCA1CkcDGQtvCW03sUxJ8nJQ6
 X7YdROI+iKpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="524886389"
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
Subject: [PATCH v3 05/11] KVM: VMX: Do Hyper-V TLB flush iff vCPU's EPTP hasn't been flushed
Date:   Tue, 27 Oct 2020 14:23:40 -0700
Message-Id: <20201027212346.23409-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201027212346.23409-1-sean.j.christopherson@intel.com>
References: <20201027212346.23409-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Combine the for-loops for Hyper-V TLB EPTP checking and flushing, and in
doing so skip flushes for vCPUs whose EPTP matches the target EPTP.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f5e9e2f61e10..17b228c4ba19 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -505,33 +505,26 @@ static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
 
 	spin_lock(&kvm_vmx->ept_pointer_lock);
 
-	if (kvm_vmx->ept_pointers_match == EPT_POINTERS_CHECK) {
+	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
 		kvm_vmx->ept_pointers_match = EPT_POINTERS_MATCH;
 		kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
 
 		kvm_for_each_vcpu(i, vcpu, kvm) {
 			tmp_eptp = to_vmx(vcpu)->ept_pointer;
-			if (!VALID_PAGE(tmp_eptp))
+			if (!VALID_PAGE(tmp_eptp) ||
+			    tmp_eptp == kvm_vmx->hv_tlb_eptp)
 				continue;
 
-			if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
+			if (!VALID_PAGE(kvm_vmx->hv_tlb_eptp))
 				kvm_vmx->hv_tlb_eptp = tmp_eptp;
-			} else if (kvm_vmx->hv_tlb_eptp != tmp_eptp) {
-				kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
+			else
 				kvm_vmx->ept_pointers_match
 					= EPT_POINTERS_MISMATCH;
-				break;
-			}
-		}
-	}
 
-	if (kvm_vmx->ept_pointers_match != EPT_POINTERS_MATCH) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			/* If ept_pointer is invalid pointer, bypass flush request. */
-			if (VALID_PAGE(to_vmx(vcpu)->ept_pointer))
-				ret |= hv_remote_flush_eptp(to_vmx(vcpu)->ept_pointer,
-							    range);
+			ret |= hv_remote_flush_eptp(tmp_eptp, range);
 		}
+		if (kvm_vmx->ept_pointers_match == EPT_POINTERS_MISMATCH)
+			kvm_vmx->hv_tlb_eptp = INVALID_PAGE;
 	} else if (VALID_PAGE(kvm_vmx->hv_tlb_eptp)) {
 		ret = hv_remote_flush_eptp(kvm_vmx->hv_tlb_eptp, range);
 	}
-- 
2.28.0

