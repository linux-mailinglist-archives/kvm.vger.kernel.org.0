Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4761528566D
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 03:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbgJGBo0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 21:44:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:7786 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbgJGBoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 21:44:23 -0400
IronPort-SDR: HzMPk2t4JepU2S2jR9wkSy3wSBn+qjAvekcaVdYviEie2FUM6UfuyvTbtBIs23lw8MJiDtwD2C
 vBIMzwkFjX9A==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="164914609"
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="164914609"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 18:44:19 -0700
IronPort-SDR: Zb3cF6oTEt81BZEh7UKANgZLoqTxNnGEgLWFiIPXl75nA+TInj4si1icwhjxnOPuyMyO8Xn43u
 DPqU6oq7ycDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="297410312"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga008.fm.intel.com with ESMTP; 06 Oct 2020 18:44:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stas Sergeev <stsp@users.sourceforge.net>
Subject: [PATCH 6/6] KVM: selftests: Verify supported CR4 bits can be set before KVM_SET_CPUID2
Date:   Tue,  6 Oct 2020 18:44:17 -0700
Message-Id: <20201007014417.29276-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007014417.29276-1-sean.j.christopherson@intel.com>
References: <20201007014417.29276-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend the KVM_SET_SREGS test to verify that all supported CR4 bits, as
enumerated by KVM, can be set before KVM_SET_CPUID2, i.e. without first
defining the vCPU model.  KVM is supposed to skip guest CPUID checks
when host userspace is stuffing guest state.

Check the inverse as well, i.e. that KVM rejects KVM_SET_REGS if CR4
has one or more unsupported bits set.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 17 ++++
 .../selftests/kvm/include/x86_64/vmx.h        |  4 -
 .../selftests/kvm/x86_64/set_sregs_test.c     | 92 ++++++++++++++++++-
 3 files changed, 108 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 82b7fe16a824..29f0bd7d8271 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -27,6 +27,7 @@
 #define X86_CR4_OSFXSR		(1ul << 9)
 #define X86_CR4_OSXMMEXCPT	(1ul << 10)
 #define X86_CR4_UMIP		(1ul << 11)
+#define X86_CR4_LA57		(1ul << 12)
 #define X86_CR4_VMXE		(1ul << 13)
 #define X86_CR4_SMXE		(1ul << 14)
 #define X86_CR4_FSGSBASE	(1ul << 16)
@@ -36,6 +37,22 @@
 #define X86_CR4_SMAP		(1ul << 21)
 #define X86_CR4_PKE		(1ul << 22)
 
+/* CPUID.1.ECX */
+#define CPUID_VMX		(1ul << 5)
+#define CPUID_SMX		(1ul << 6)
+#define CPUID_PCID		(1ul << 17)
+#define CPUID_XSAVE		(1ul << 26)
+
+/* CPUID.7.EBX */
+#define CPUID_FSGSBASE		(1ul << 0)
+#define CPUID_SMEP		(1ul << 7)
+#define CPUID_SMAP		(1ul << 20)
+
+/* CPUID.7.ECX */
+#define CPUID_UMIP		(1ul << 2)
+#define CPUID_PKU		(1ul << 3)
+#define CPUID_LA57		(1ul << 16)
+
 /* General Registers in 64-Bit Mode */
 struct gpr64_regs {
 	u64 rax;
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 54d624dd6c10..e4da3e784f90 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -11,10 +11,6 @@
 #include <stdint.h>
 #include "processor.h"
 
-#define CPUID_VMX_BIT				5
-
-#define CPUID_VMX				(1 << 5)
-
 /*
  * Definitions of Primary Processor-Based VM-Execution Controls.
  */
diff --git a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
index 9f7656184f31..318be0bf77ab 100644
--- a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
@@ -24,16 +24,106 @@
 
 #define VCPU_ID                  5
 
+static void test_cr4_feature_bit(struct kvm_vm *vm, struct kvm_sregs *orig,
+				 uint64_t feature_bit)
+{
+	struct kvm_sregs sregs;
+	int rc;
+
+	/* Skip the sub-test, the feature is supported. */
+	if (orig->cr4 & feature_bit)
+		return;
+
+	memcpy(&sregs, orig, sizeof(sregs));
+	sregs.cr4 |= feature_bit;
+
+	rc = _vcpu_sregs_set(vm, VCPU_ID, &sregs);
+	TEST_ASSERT(rc, "KVM allowed unsupported CR4 bit (0x%lx)", feature_bit);
+
+	/* Sanity check that KVM didn't change anything. */
+	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	TEST_ASSERT(!memcmp(&sregs, orig, sizeof(sregs)), "KVM modified sregs");
+}
+
+static uint64_t calc_cr4_feature_bits(struct kvm_vm *vm)
+{
+	struct kvm_cpuid_entry2 *cpuid_1, *cpuid_7;
+	uint64_t cr4;
+
+	cpuid_1 = kvm_get_supported_cpuid_entry(1);
+	cpuid_7 = kvm_get_supported_cpuid_entry(7);
+
+	cr4 = X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD | X86_CR4_DE |
+	      X86_CR4_PSE | X86_CR4_PAE | X86_CR4_MCE | X86_CR4_PGE |
+	      X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_OSXMMEXCPT;
+	if (cpuid_7->ecx & CPUID_UMIP)
+		cr4 |= X86_CR4_UMIP;
+	if (cpuid_7->ecx & CPUID_LA57)
+		cr4 |= X86_CR4_LA57;
+	if (cpuid_1->ecx & CPUID_VMX)
+		cr4 |= X86_CR4_VMXE;
+	if (cpuid_1->ecx & CPUID_SMX)
+		cr4 |= X86_CR4_SMXE;
+	if (cpuid_7->ebx & CPUID_FSGSBASE)
+		cr4 |= X86_CR4_FSGSBASE;
+	if (cpuid_1->ecx & CPUID_PCID)
+		cr4 |= X86_CR4_PCIDE;
+	if (cpuid_1->ecx & CPUID_XSAVE)
+		cr4 |= X86_CR4_OSXSAVE;
+	if (cpuid_7->ebx & CPUID_SMEP)
+		cr4 |= X86_CR4_SMEP;
+	if (cpuid_7->ebx & CPUID_SMAP)
+		cr4 |= X86_CR4_SMAP;
+	if (cpuid_7->ecx & CPUID_PKU)
+		cr4 |= X86_CR4_PKE;
+
+	return cr4;
+}
+
 int main(int argc, char *argv[])
 {
 	struct kvm_sregs sregs;
 	struct kvm_vm *vm;
+	uint64_t cr4;
 	int rc;
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	/* Create VM */
+	/*
+	 * Create a dummy VM, specifically to avoid doing KVM_SET_CPUID2, and
+	 * use it to verify all supported CR4 bits can be set prior to defining
+	 * the vCPU model, i.e. without doing KVM_SET_CPUID2.
+	 */
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+	vm_vcpu_add(vm, VCPU_ID);
+
+	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+
+	sregs.cr4 |= calc_cr4_feature_bits(vm);
+	cr4 = sregs.cr4;
+
+	rc = _vcpu_sregs_set(vm, VCPU_ID, &sregs);
+	TEST_ASSERT(!rc, "Failed to set supported CR4 bits (0x%lx)", cr4);
+
+	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	TEST_ASSERT(sregs.cr4 == cr4, "sregs.CR4 (0x%llx) != CR4 (0x%lx)",
+		    sregs.cr4, cr4);
+
+	/* Verify all unsupported features are rejected by KVM. */
+	test_cr4_feature_bit(vm, &sregs, X86_CR4_UMIP);
+	test_cr4_feature_bit(vm, &sregs, X86_CR4_LA57);
+	test_cr4_feature_bit(vm, &sregs, X86_CR4_VMXE);
+	test_cr4_feature_bit(vm, &sregs, X86_CR4_SMXE);
+	test_cr4_feature_bit(vm, &sregs, X86_CR4_FSGSBASE);
+	test_cr4_feature_bit(vm, &sregs, X86_CR4_PCIDE);
+	test_cr4_feature_bit(vm, &sregs, X86_CR4_OSXSAVE);
+	test_cr4_feature_bit(vm, &sregs, X86_CR4_SMEP);
+	test_cr4_feature_bit(vm, &sregs, X86_CR4_SMAP);
+	test_cr4_feature_bit(vm, &sregs, X86_CR4_PKE);
+	kvm_vm_free(vm);
+
+	/* Create a "real" VM and verify APIC_BASE can be set. */
 	vm = vm_create_default(VCPU_ID, 0, NULL);
 
 	vcpu_sregs_get(vm, VCPU_ID, &sregs);
-- 
2.28.0

