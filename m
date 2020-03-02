Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 199F71768BA
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 00:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgCBX6v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:58:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:25520 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727471AbgCBX53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384710"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 29/66] KVM: x86: Refactor cpuid_mask() to auto-retrieve the register
Date:   Mon,  2 Mar 2020 15:56:32 -0800
Message-Id: <20200302235709.27467-30-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the recently introduced cpuid_entry_get_reg() to automatically get
the appropriate register when masking a CPUID entry.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 14b5fb24c6be..04343c54a419 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -254,10 +254,12 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
 	return r;
 }
 
-static __always_inline void cpuid_mask(u32 *word, int wordnum)
+static __always_inline void cpuid_entry_mask(struct kvm_cpuid_entry2 *entry,
+					     enum cpuid_leafs leaf)
 {
-	reverse_cpuid_check(wordnum);
-	*word &= boot_cpu_data.x86_capability[wordnum];
+	u32 *reg = cpuid_entry_get_reg(entry, leaf * 32);
+
+	*reg &= boot_cpu_data.x86_capability[leaf];
 }
 
 struct kvm_cpuid_array {
@@ -373,13 +375,13 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
 	case 0:
 		entry->eax = min(entry->eax, 1u);
 		entry->ebx &= kvm_cpuid_7_0_ebx_x86_features;
-		cpuid_mask(&entry->ebx, CPUID_7_0_EBX);
+		cpuid_entry_mask(entry, CPUID_7_0_EBX);
 		/* TSC_ADJUST is emulated */
 		cpuid_entry_set(entry, X86_FEATURE_TSC_ADJUST);
 
 		entry->ecx &= kvm_cpuid_7_0_ecx_x86_features;
 		f_la57 = cpuid_entry_get(entry, X86_FEATURE_LA57);
-		cpuid_mask(&entry->ecx, CPUID_7_ECX);
+		cpuid_entry_mask(entry, CPUID_7_ECX);
 		/* Set LA57 based on hardware capability. */
 		entry->ecx |= f_la57;
 		entry->ecx |= f_umip;
@@ -389,7 +391,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
 			cpuid_entry_clear(entry, X86_FEATURE_PKU);
 
 		entry->edx &= kvm_cpuid_7_0_edx_x86_features;
-		cpuid_mask(&entry->edx, CPUID_7_EDX);
+		cpuid_entry_mask(entry, CPUID_7_EDX);
 		if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
 			cpuid_entry_set(entry, X86_FEATURE_SPEC_CTRL);
 		if (boot_cpu_has(X86_FEATURE_STIBP))
@@ -507,9 +509,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	case 1:
 		entry->edx &= kvm_cpuid_1_edx_x86_features;
-		cpuid_mask(&entry->edx, CPUID_1_EDX);
+		cpuid_entry_mask(entry, CPUID_1_EDX);
 		entry->ecx &= kvm_cpuid_1_ecx_x86_features;
-		cpuid_mask(&entry->ecx, CPUID_1_ECX);
+		cpuid_entry_mask(entry, CPUID_1_ECX);
 		/* we support x2apic emulation even if host does not support
 		 * it since we emulate x2apic in software */
 		cpuid_entry_set(entry, X86_FEATURE_X2APIC);
@@ -619,7 +621,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			goto out;
 
 		entry->eax &= kvm_cpuid_D_1_eax_x86_features;
-		cpuid_mask(&entry->eax, CPUID_D_1_EAX);
+		cpuid_entry_mask(entry, CPUID_D_1_EAX);
 		if (entry->eax & (F(XSAVES)|F(XSAVEC)))
 			entry->ebx = xstate_required_size(supported_xcr0, true);
 		else
@@ -699,9 +701,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	case 0x80000001:
 		entry->edx &= kvm_cpuid_8000_0001_edx_x86_features;
-		cpuid_mask(&entry->edx, CPUID_8000_0001_EDX);
+		cpuid_entry_mask(entry, CPUID_8000_0001_EDX);
 		entry->ecx &= kvm_cpuid_8000_0001_ecx_x86_features;
-		cpuid_mask(&entry->ecx, CPUID_8000_0001_ECX);
+		cpuid_entry_mask(entry, CPUID_8000_0001_ECX);
 		break;
 	case 0x80000007: /* Advanced power management */
 		/* invariant TSC is CPUID.80000007H:EDX[8] */
@@ -720,7 +722,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->eax = g_phys_as | (virt_as << 8);
 		entry->edx = 0;
 		entry->ebx &= kvm_cpuid_8000_0008_ebx_x86_features;
-		cpuid_mask(&entry->ebx, CPUID_8000_0008_EBX);
+		cpuid_entry_mask(entry, CPUID_8000_0008_EBX);
 		/*
 		 * AMD has separate bits for each SPEC_CTRL bit.
 		 * arch/x86/kernel/cpu/bugs.c is kind enough to
@@ -763,7 +765,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	case 0xC0000001:
 		entry->edx &= kvm_cpuid_C000_0001_edx_x86_features;
-		cpuid_mask(&entry->edx, CPUID_C000_0001_EDX);
+		cpuid_entry_mask(entry, CPUID_C000_0001_EDX);
 		break;
 	case 3: /* Processor serial number */
 	case 5: /* MONITOR/MWAIT */
-- 
2.24.1

