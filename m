Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 166CE176907
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbgCCAB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 19:01:59 -0500
Received: from mga17.intel.com ([192.55.52.151]:37738 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727131AbgCBX5Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384758"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:23 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 45/66] KVM: x86: Fold CPUID 0x7 masking back into __do_cpuid_func()
Date:   Mon,  2 Mar 2020 15:56:48 -0800
Message-Id: <20200302235709.27467-46-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the CPUID 0x7 masking back into __do_cpuid_func() now that the
size of the code has been trimmed down significantly.

Tweak the WARN case, which is impossible to hit unless the CPU is
completely broken, to break the loop before creating the bogus entry.

Opportunustically reorder the cpuid_entry_set() calls and shorten the
comment about emulation to further reduce the footprint of CPUID 0x7.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c | 62 ++++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 1c361a65ee03..e3e5a7b83b5b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -464,44 +464,6 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
 	return 0;
 }
 
-static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
-{
-	switch (entry->index) {
-	case 0:
-		entry->eax = min(entry->eax, 1u);
-		cpuid_entry_mask(entry, CPUID_7_0_EBX);
-		/* TSC_ADJUST is emulated */
-		cpuid_entry_set(entry, X86_FEATURE_TSC_ADJUST);
-		cpuid_entry_mask(entry, CPUID_7_ECX);
-		cpuid_entry_mask(entry, CPUID_7_EDX);
-		if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
-			cpuid_entry_set(entry, X86_FEATURE_SPEC_CTRL);
-		if (boot_cpu_has(X86_FEATURE_STIBP))
-			cpuid_entry_set(entry, X86_FEATURE_INTEL_STIBP);
-		if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
-			cpuid_entry_set(entry, X86_FEATURE_SPEC_CTRL_SSBD);
-		/*
-		 * We emulate ARCH_CAPABILITIES in software even
-		 * if the host doesn't support it.
-		 */
-		cpuid_entry_set(entry, X86_FEATURE_ARCH_CAPABILITIES);
-		break;
-	case 1:
-		cpuid_entry_mask(entry, CPUID_7_1_EAX);
-		entry->ebx = 0;
-		entry->ecx = 0;
-		entry->edx = 0;
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		entry->eax = 0;
-		entry->ebx = 0;
-		entry->ecx = 0;
-		entry->edx = 0;
-		break;
-	}
-}
-
 static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 {
 	struct kvm_cpuid_entry2 *entry;
@@ -563,14 +525,34 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	/* function 7 has additional index. */
 	case 7:
-		do_cpuid_7_mask(entry);
+		entry->eax = min(entry->eax, 1u);
+		cpuid_entry_mask(entry, CPUID_7_0_EBX);
+		cpuid_entry_mask(entry, CPUID_7_ECX);
+		cpuid_entry_mask(entry, CPUID_7_EDX);
+
+		/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
+		cpuid_entry_set(entry, X86_FEATURE_TSC_ADJUST);
+		cpuid_entry_set(entry, X86_FEATURE_ARCH_CAPABILITIES);
+
+		if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
+			cpuid_entry_set(entry, X86_FEATURE_SPEC_CTRL);
+		if (boot_cpu_has(X86_FEATURE_STIBP))
+			cpuid_entry_set(entry, X86_FEATURE_INTEL_STIBP);
+		if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
+			cpuid_entry_set(entry, X86_FEATURE_SPEC_CTRL_SSBD);
 
 		for (i = 1, max_idx = entry->eax; i <= max_idx; i++) {
+			if (WARN_ON_ONCE(i > 1))
+				break;
+
 			entry = do_host_cpuid(array, function, i);
 			if (!entry)
 				goto out;
 
-			do_cpuid_7_mask(entry);
+			cpuid_entry_mask(entry, CPUID_7_1_EAX);
+			entry->ebx = 0;
+			entry->ecx = 0;
+			entry->edx = 0;
 		}
 		break;
 	case 9:
-- 
2.24.1

