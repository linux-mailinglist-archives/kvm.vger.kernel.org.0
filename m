Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3F5BFD16
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 04:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbfI0CRO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 22:17:14 -0400
Received: from mga17.intel.com ([192.55.52.151]:25572 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728453AbfI0CRN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 22:17:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 19:17:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,553,1559545200"; 
   d="scan'208";a="193020656"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga003.jf.intel.com with ESMTP; 26 Sep 2019 19:17:11 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v7 2/7] kvm: vmx: Define CET VMCS fields and CPUID flags
Date:   Fri, 27 Sep 2019 10:19:22 +0800
Message-Id: <20190927021927.23057-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190927021927.23057-1-weijiang.yang@intel.com>
References: <20190927021927.23057-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET(Control-flow Enforcement Technology) is an upcoming Intel(R)
processor feature that blocks Return/Jump-Oriented Programming(ROP)
attacks. It provides the following capabilities to defend
against ROP/JOP style control-flow subversion attacks:

Shadow Stack (SHSTK):
  A second stack for program which is used exclusively for
  control transfer operations.

Indirect Branch Tracking (IBT):
  Code branching protection to defend against jump/call oriented
  programming.

Several new CET MSRs are defined in kernel to support CET:
  MSR_IA32_{U,S}_CET: Controls the CET settings for user
                      mode and suervisor mode respectively.

  MSR_IA32_PL{0,1,2,3}_SSP: Stores shadow stack pointers for
                            CPL-0,1,2,3 level respectively.

  MSR_IA32_INT_SSP_TAB: Stores base address of shadow stack
                        pointer table.

Two XSAVES state bits are introduced for CET:
  IA32_XSS:[bit 11]: For saving/restoring user mode CET states
  IA32_XSS:[bit 12]: For saving/restoring supervisor mode CET states.

Six VMCS fields are introduced for CET:
  {HOST,GUEST}_S_CET: Stores CET settings for supervisor mode.
  {HOST,GUEST}_SSP: Stores shadow stack pointer for supervisor mode.
  {HOST,GUEST}_INTR_SSP_TABLE: Stores base address of shadow stack pointer
                               table.

If VM_EXIT_LOAD_HOST_CET_STATE = 1, the host's CET MSRs are restored
from below VMCS fields at VM-Exit:
  HOST_S_CET
  HOST_SSP
  HOST_INTR_SSP_TABLE

If VM_ENTRY_LOAD_GUEST_CET_STATE = 1, the guest's CET MSRs are loaded
from below VMCS fields at VM-Entry:
  GUEST_S_CET
  GUEST_SSP
  GUEST_INTR_SSP_TABLE

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/vmx.h | 8 ++++++++
 arch/x86/kvm/cpuid.c       | 4 ++--
 arch/x86/kvm/x86.h         | 3 ++-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index a39136b0d509..68bca290a203 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -90,6 +90,7 @@
 #define VM_EXIT_CLEAR_BNDCFGS                   0x00800000
 #define VM_EXIT_PT_CONCEAL_PIP			0x01000000
 #define VM_EXIT_CLEAR_IA32_RTIT_CTL		0x02000000
+#define VM_EXIT_LOAD_HOST_CET_STATE             0x10000000
 
 #define VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR	0x00036dff
 
@@ -103,6 +104,7 @@
 #define VM_ENTRY_LOAD_BNDCFGS                   0x00010000
 #define VM_ENTRY_PT_CONCEAL_PIP			0x00020000
 #define VM_ENTRY_LOAD_IA32_RTIT_CTL		0x00040000
+#define VM_ENTRY_LOAD_GUEST_CET_STATE           0x00100000
 
 #define VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR	0x000011ff
 
@@ -321,6 +323,9 @@ enum vmcs_field {
 	GUEST_PENDING_DBG_EXCEPTIONS    = 0x00006822,
 	GUEST_SYSENTER_ESP              = 0x00006824,
 	GUEST_SYSENTER_EIP              = 0x00006826,
+	GUEST_S_CET                     = 0x00006828,
+	GUEST_SSP                       = 0x0000682a,
+	GUEST_INTR_SSP_TABLE            = 0x0000682c,
 	HOST_CR0                        = 0x00006c00,
 	HOST_CR3                        = 0x00006c02,
 	HOST_CR4                        = 0x00006c04,
@@ -333,6 +338,9 @@ enum vmcs_field {
 	HOST_IA32_SYSENTER_EIP          = 0x00006c12,
 	HOST_RSP                        = 0x00006c14,
 	HOST_RIP                        = 0x00006c16,
+	HOST_S_CET                      = 0x00006c18,
+	HOST_SSP                        = 0x00006c1a,
+	HOST_INTR_SSP_TABLE             = 0x00006c1c
 };
 
 /*
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 9d282fec0a62..1aa86b87b6ab 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -365,13 +365,13 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
 		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
-		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B);
+		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | F(SHSTK);
 
 	/* cpuid 7.0.edx*/
 	const u32 kvm_cpuid_7_0_edx_x86_features =
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
-		F(MD_CLEAR);
+		F(MD_CLEAR) | F(IBT);
 
 	/* cpuid 7.1.eax */
 	const u32 kvm_cpuid_7_1_eax_x86_features =
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index fbffabad0370..a85800b23e6e 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -298,7 +298,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, unsigned long cr2,
  * Right now, no XSS states are used on x86 platform,
  * expand the macro for new features.
  */
-#define KVM_SUPPORTED_XSS	(0)
+#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER \
+				| XFEATURE_MASK_CET_KERNEL)
 
 extern u64 host_xcr0;
 
-- 
2.17.2

