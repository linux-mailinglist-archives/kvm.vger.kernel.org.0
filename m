Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2023314F9BC
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbgBASyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:54:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:11279 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727244AbgBASwd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075576"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2020 10:52:26 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 49/61] KVM: x86: Override host CPUID results with kvm_cpu_caps
Date:   Sat,  1 Feb 2020 10:52:06 -0800
Message-Id: <20200201185218.24473-50-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Override CPUID entries with kvm_cpu_caps during KVM_GET_SUPPORTED_CPUID
instead of masking the host CPUID result, which is redundant now that
the host CPUID is incorporated into kvm_cpu_caps at runtime.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 4416f2422321..871c0bd04e19 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -261,13 +261,13 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
 	return r;
 }
 
-static __always_inline void cpuid_entry_mask(struct kvm_cpuid_entry2 *entry,
-					     enum cpuid_leafs leaf)
+static __always_inline void cpuid_entry_override(struct kvm_cpuid_entry2 *entry,
+						 enum cpuid_leafs leaf)
 {
 	u32 *reg = cpuid_entry_get_reg(entry, leaf * 32);
 
 	BUILD_BUG_ON(leaf > ARRAY_SIZE(kvm_cpu_caps));
-	*reg &= kvm_cpu_caps[leaf];
+	*reg = kvm_cpu_caps[leaf];
 }
 
 static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
@@ -488,8 +488,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->eax = min(entry->eax, 0x1fU);
 		break;
 	case 1:
-		cpuid_entry_mask(entry, CPUID_1_EDX);
-		cpuid_entry_mask(entry, CPUID_1_ECX);
+		cpuid_entry_override(entry, CPUID_1_EDX);
+		cpuid_entry_override(entry, CPUID_1_ECX);
 		/* we support x2apic emulation even if host does not support
 		 * it since we emulate x2apic in software */
 		cpuid_entry_set(entry, X86_FEATURE_X2APIC);
@@ -543,9 +543,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	/* function 7 has additional index. */
 	case 7:
 		entry->eax = min(entry->eax, 1u);
-		cpuid_entry_mask(entry, CPUID_7_0_EBX);
-		cpuid_entry_mask(entry, CPUID_7_ECX);
-		cpuid_entry_mask(entry, CPUID_7_EDX);
+		cpuid_entry_override(entry, CPUID_7_0_EBX);
+		cpuid_entry_override(entry, CPUID_7_ECX);
+		cpuid_entry_override(entry, CPUID_7_EDX);
 
 		/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
 		cpuid_entry_set(entry, X86_FEATURE_TSC_ADJUST);
@@ -564,7 +564,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			if (!entry)
 				goto out;
 
-			cpuid_entry_mask(entry, CPUID_7_1_EAX);
+			cpuid_entry_override(entry, CPUID_7_1_EAX);
 			entry->ebx = 0;
 			entry->ecx = 0;
 			entry->edx = 0;
@@ -630,7 +630,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		if (!entry)
 			goto out;
 
-		cpuid_entry_mask(entry, CPUID_D_1_EAX);
+		cpuid_entry_override(entry, CPUID_D_1_EAX);
 		if (entry->eax & (F(XSAVES)|F(XSAVEC)))
 			entry->ebx = xstate_required_size(supported_xcr0, true);
 		else
@@ -709,8 +709,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->eax = min(entry->eax, 0x8000001f);
 		break;
 	case 0x80000001:
-		cpuid_entry_mask(entry, CPUID_8000_0001_EDX);
-		cpuid_entry_mask(entry, CPUID_8000_0001_ECX);
+		cpuid_entry_override(entry, CPUID_8000_0001_EDX);
+		cpuid_entry_override(entry, CPUID_8000_0001_ECX);
 		break;
 	case 0x80000007: /* Advanced power management */
 		/* invariant TSC is CPUID.80000007H:EDX[8] */
@@ -728,7 +728,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			g_phys_as = phys_as;
 		entry->eax = g_phys_as | (virt_as << 8);
 		entry->edx = 0;
-		cpuid_entry_mask(entry, CPUID_8000_0008_EBX);
+		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
 		/*
 		 * AMD has separate bits for each SPEC_CTRL bit.
 		 * arch/x86/kernel/cpu/bugs.c is kind enough to
@@ -770,7 +770,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->eax = min(entry->eax, 0xC0000004);
 		break;
 	case 0xC0000001:
-		cpuid_entry_mask(entry, CPUID_C000_0001_EDX);
+		cpuid_entry_override(entry, CPUID_C000_0001_EDX);
 		break;
 	case 3: /* Processor serial number */
 	case 5: /* MONITOR/MWAIT */
-- 
2.24.1

