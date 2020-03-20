Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2013218DA38
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgCTV3s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:29:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:37248 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727492AbgCTV3B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:29:01 -0400
IronPort-SDR: 9EMUsBBIFRRW3dVB/K8vGhrPleyW84+NCwCGmCb5JIRNv8PmeOGSNDAytvz4TnoVhHyskJhQGc
 2zjUY8msQosA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:29:00 -0700
IronPort-SDR: nSTbFh2QCe7SN9bMGsGet+uQhBbW8o1DBEFP7McjA6RgvXcYtPw1v7+x/RA801Ifj5zrumS0me
 W97jD6CQfOOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224529"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:29:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v3 35/37] KVM: nVMX: Free only the affected contexts when emulating INVEPT
Date:   Fri, 20 Mar 2020 14:28:31 -0700
Message-Id: <20200320212833.3507-36-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add logic to handle_invept() to free only those roots that match the
target EPT context when emulating a single-context INVEPT.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 92aab4166498..72e69d841531 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5185,12 +5185,14 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 vmx_instruction_info, types;
-	unsigned long type;
+	unsigned long type, roots_to_free;
+	struct kvm_mmu *mmu;
 	gva_t gva;
 	struct x86_exception e;
 	struct {
 		u64 eptp, gpa;
 	} operand;
+	int i;
 
 	if (!(vmx->nested.msrs.secondary_ctls_high &
 	      SECONDARY_EXEC_ENABLE_EPT) ||
@@ -5222,23 +5224,37 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
+	mmu = &vcpu->arch.guest_mmu;
+
 	switch (type) {
 	case VMX_EPT_EXTENT_CONTEXT:
 		if (!nested_vmx_check_eptp(vcpu, operand.eptp))
 			return nested_vmx_failValid(vcpu,
 				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
 
-		/* TODO: sync only the target EPTP context. */
-		fallthrough;
+		roots_to_free = 0;
+		if (nested_ept_root_matches(mmu->root_hpa, mmu->root_cr3,
+					    operand.eptp))
+			roots_to_free |= KVM_MMU_ROOT_CURRENT;
+
+		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
+			if (nested_ept_root_matches(mmu->prev_roots[i].hpa,
+						    mmu->prev_roots[i].cr3,
+						    operand.eptp))
+				roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
+		}
+		break;
 	case VMX_EPT_EXTENT_GLOBAL:
-		kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu,
-				   KVM_MMU_ROOTS_ALL);
+		roots_to_free = KVM_MMU_ROOTS_ALL;
 		break;
 	default:
 		BUG_ON(1);
 		break;
 	}
 
+	if (roots_to_free)
+		kvm_mmu_free_roots(vcpu, mmu, roots_to_free);
+
 	return nested_vmx_succeed(vcpu);
 }
 
-- 
2.24.1

