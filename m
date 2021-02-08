Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCC0313017
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 12:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbhBHLGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 06:06:05 -0500
Received: from mga03.intel.com ([134.134.136.65]:50171 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232313AbhBHK7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 05:59:01 -0500
IronPort-SDR: uUHAg1/swLms2t64q0WWYTFrPeHrVUK50BmC4eKeepFyXzlnSCIdjSoPpYBbHPKlXceSRZ/EdN
 OghUuZOB9Zig==
X-IronPort-AV: E=McAfee;i="6000,8403,9888"; a="181758547"
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="181758547"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 02:56:08 -0800
IronPort-SDR: IrTH/Dm7ltdauHXyg7O4gqEFESTvmglOGoceLM5/UtpkUDGRM5FoWRalXTnShZEZAOOmgrMwtX
 pR0d6f85S0ww==
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="374451258"
Received: from jaeminha-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.11.62])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 02:56:04 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v4 19/26] KVM: x86: Add reverse-CPUID lookup support for scattered SGX features
Date:   Mon,  8 Feb 2021 23:55:29 +1300
Message-Id: <7bbd2c06c8fc21f5b7e44254e693285be1c2cdaa.1612777752.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1612777752.git.kai.huang@intel.com>
References: <cover.1612777752.git.kai.huang@intel.com>
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
index 2041e2f07347..f55701ef58fc 100644
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
 
@@ -76,6 +81,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
 	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
+	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
 };
 
 /*
@@ -102,6 +108,11 @@ static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
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
2.29.2

