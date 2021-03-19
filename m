Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47A334167D
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 08:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbhCSHYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 03:24:35 -0400
Received: from mga12.intel.com ([192.55.52.136]:44045 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234382AbhCSHYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 03:24:13 -0400
IronPort-SDR: 2xmhUxlRCqKoksnmk+bupg3WKGlUjmWRxncW2jIVNvbKOPWyLxdg6oa7Ex8csBmWLM2XYuZtFX
 tG86WVUs/59Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="169143704"
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="169143704"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:24:13 -0700
IronPort-SDR: QtNkeu9Ff9cNjH13TlUXNXN//Ua0jSfEV4N5rtH6s+0VvsSxNeKYf2P7ZOeYX6MJztjAMZY+9o
 msijlGqfGIdg==
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="413409907"
Received: from dlmeisen-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.165])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:24:09 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, Kai Huang <kai.huang@intel.com>
Subject: [PATCH v3 18/25] KVM: x86: Add reverse-CPUID lookup support for scattered SGX features
Date:   Fri, 19 Mar 2021 20:23:42 +1300
Message-Id: <9e32f012a9248cae634c83861c5c5ef67c6e2f43.1616136308.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1616136307.git.kai.huang@intel.com>
References: <cover.1616136307.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Define a new KVM-only feature word for advertising and querying SGX
sub-features in CPUID.0x12.0x0.EAX.  Because SGX1 and SGX2 are scattered
in the kernel's feature word, they need to be translated so that the
bit numbers match those of hardware.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/cpuid.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 8925a929186c..a175ff75bbbe 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -13,13 +13,18 @@
  * "bug" caps, but KVM doesn't use those.
  */
 enum kvm_only_cpuid_leafs {
-	NR_KVM_CPU_CAPS = NCAPINTS,
+	CPUID_12_EAX	 = NCAPINTS,
+	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
 };
 
 #define X86_KVM_FEATURE(w, f)		((w)*32 + (f))
 
+/* Intel-defined SGX sub-features, CPUID level 0x12 (EAX). */
+#define __X86_FEATURE_SGX1		X86_KVM_FEATURE(CPUID_12_EAX, 0)
+#define __X86_FEATURE_SGX2		X86_KVM_FEATURE(CPUID_12_EAX, 1)
+
 extern u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
 void kvm_set_cpu_caps(void);
 
@@ -93,6 +98,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
 	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
+	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
 };
 
 /*
@@ -119,6 +125,11 @@ static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
  */
 static __always_inline u32 __feature_translate(int x86_feature)
 {
+	if (x86_feature == X86_FEATURE_SGX1)
+		return __X86_FEATURE_SGX1;
+	else if (x86_feature == X86_FEATURE_SGX2)
+		return __X86_FEATURE_SGX2;
+
 	return x86_feature;
 }
 
-- 
2.30.2

