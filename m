Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBB1CB15A
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 23:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387490AbfJCVi6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 17:38:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:52651 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730739AbfJCVi6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 17:38:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2019 14:38:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,253,1566889200"; 
   d="scan'208";a="186051623"
Received: from linksys13920.jf.intel.com (HELO rpedgeco-DESK5.jf.intel.com) ([10.54.75.11])
  by orsmga008.jf.intel.com with ESMTP; 03 Oct 2019 14:38:57 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org, luto@kernel.org, peterz@infradead.org,
        dave.hansen@intel.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, keescook@chromium.org
Cc:     kristen@linux.intel.com, deneen.t.dock@intel.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [RFC PATCH 04/13] kvm, vmx: Add support for gva exit qualification
Date:   Thu,  3 Oct 2019 14:23:51 -0700
Message-Id: <20191003212400.31130-5-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMX supports providing the guest virtual address that caused and EPT
violation. Add support for this so it can be used by the KVM XO feature.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++++
 arch/x86/include/asm/vmx.h      | 1 +
 arch/x86/kvm/vmx/vmx.c          | 5 +++++
 arch/x86/kvm/x86.c              | 1 +
 4 files changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bdc16b0aa7c6..b363a7fc47b0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -781,6 +781,10 @@ struct kvm_vcpu_arch {
 	bool gpa_available;
 	gpa_t gpa_val;
 
+	/* GVA available */
+	bool gva_available;
+	gva_t gva_val;
+
 	/* be preempted when it's in kernel-mode(cpl=0) */
 	bool preempted_in_kernel;
 
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index a39136b0d509..67457f2d19e2 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -522,6 +522,7 @@ struct vmx_msr_entry {
 #define EPT_VIOLATION_READABLE_BIT	3
 #define EPT_VIOLATION_WRITABLE_BIT	4
 #define EPT_VIOLATION_EXECUTABLE_BIT	5
+#define EPT_VIOLATION_GVA_LINEAR_VALID	7
 #define EPT_VIOLATION_GVA_TRANSLATED_BIT 8
 #define EPT_VIOLATION_ACC_READ		(1 << EPT_VIOLATION_ACC_READ_BIT)
 #define EPT_VIOLATION_ACC_WRITE		(1 << EPT_VIOLATION_ACC_WRITE_BIT)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c030c96fc81a..a30dbab8a2d4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5116,6 +5116,11 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	error_code |= (exit_qualification & 0x100) != 0 ?
 	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 
+	if (exit_qualification | EPT_VIOLATION_GVA_LINEAR_VALID) {
+		vcpu->arch.gva_available = true;
+		vcpu->arch.gva_val = vmcs_readl(GUEST_LINEAR_ADDRESS);
+	}
+
 	vcpu->arch.exit_qualification = exit_qualification;
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 91602d310a3f..aa138d3a86c5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8092,6 +8092,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		kvm_lapic_sync_from_vapic(vcpu);
 
 	vcpu->arch.gpa_available = false;
+	vcpu->arch.gva_available = false;
 	r = kvm_x86_ops->handle_exit(vcpu);
 	return r;
 
-- 
2.17.1

