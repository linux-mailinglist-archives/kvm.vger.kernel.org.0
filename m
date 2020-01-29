Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE8ED14D3D3
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbgA2XrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:47:12 -0500
Received: from mga06.intel.com ([134.134.136.31]:46688 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727224AbgA2Xqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:46:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 15:46:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="309551767"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 29 Jan 2020 15:46:44 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 25/26] KVM: x86: Handle main Intel PT CPUID leaf in vendor code
Date:   Wed, 29 Jan 2020 15:46:39 -0800
Message-Id: <20200129234640.8147-26-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129234640.8147-1-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the clearing of the Intel PT CPUID leaf into vendor code to
eliminate a call to ->pt_supported().  To handle clearing CPUID 0x14's
index>0 sub-leafs, introduce the pattern of adding feature-dependent
sub-leafs (index>0 sub-leafs whose existence is enumerated by index=0)
after calling ->set_supported_cpuid().  The dependent sub-leafs pattern
can be reused for future (Intel) features such as SGX to allow vendor
code to disable the feature, e.g. via module param, without having to
add a feature specific kvm_x86_ops hook.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c   | 32 ++++++++++++++++----------------
 arch/x86/kvm/svm.c     |  3 +++
 arch/x86/kvm/vmx/vmx.c |  4 ++++
 3 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index d06fb54c9c0d..ca766c460318 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -409,7 +409,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	unsigned f_gbpages = 0;
 	unsigned f_lm = 0;
 #endif
-	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
 
 	/* cpuid 1.edx */
 	const u32 kvm_cpuid_1_edx_x86_features =
@@ -648,22 +647,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		break;
 	}
 	/* Intel PT */
-	case 0x14: {
-		int t, times = entry->eax;
-
-		if (!f_intel_pt) {
-			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
-			break;
-		}
-
-		for (t = 1; t <= times; ++t) {
-			if (*nent >= maxnent)
-				goto out;
-			do_host_cpuid(&entry[t], function, t);
-			++*nent;
-		}
+	case 0x14:
 		break;
-	}
 	case KVM_CPUID_SIGNATURE: {
 		static const char signature[12] = "KVMKVMKVM\0\0";
 		const u32 *sigptr = (const u32 *)signature;
@@ -778,6 +763,21 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 
 	kvm_x86_ops->set_supported_cpuid(entry);
 
+	/*
+	 * Add feature-dependent sub-leafs after ->set_supported_cpuid() to
+	 * properly handle the feature being disabled by SVM/VMX.
+	 */
+	if (function == 0x14) {
+		int t, times = entry->eax;
+
+		for (t = 1; t <= times; ++t) {
+			if (*nent >= maxnent)
+				goto out;
+			do_host_cpuid(&entry[t], function, t);
+			++*nent;
+		}
+	}
+
 	r = 0;
 
 out:
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 350cdf91a576..a08ee7b2dddb 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6068,6 +6068,9 @@ static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 		cpuid_entry_clear(entry, X86_FEATURE_INVPCID);
 		cpuid_entry_clear(entry, X86_FEATURE_INTEL_PT);
 		break;
+	case 0x14:
+		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+		break;
 	case 0x80000001:
 		if (nested)
 			cpuid_entry_set(entry, X86_FEATURE_SVM);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 35134dbed2f0..10c31aa40730 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7155,6 +7155,10 @@ static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 		if (vmx_umip_emulated())
 			cpuid_entry_set(entry, X86_FEATURE_UMIP);
 		break;
+	case 0x14:
+		if (!vmx_pt_mode_is_host_guest())
+			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+		break;
 	case 0x80000001:
 		if (!cpu_has_vmx_rdtscp())
 			cpuid_entry_clear(entry, X86_FEATURE_RDTSCP);
-- 
2.24.1

