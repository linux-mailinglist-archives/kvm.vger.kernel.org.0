Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089AA35B93F
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 06:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhDLEWV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 00:22:21 -0400
Received: from mga07.intel.com ([134.134.136.100]:53377 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230005AbhDLEWV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 00:22:21 -0400
IronPort-SDR: dR4wXyWBHJYw+yRXZBsaN58t+MK41P+3tDN8h0LtTlCQY4swUIwlHwwuRBUERIQCEvikN7ZEmR
 P9Dg3TxRHJ/A==
X-IronPort-AV: E=McAfee;i="6000,8403,9951"; a="258083760"
X-IronPort-AV: E=Sophos;i="5.82,214,1613462400"; 
   d="scan'208";a="258083760"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2021 21:22:04 -0700
IronPort-SDR: 2TCkWLCVvkxtEWQ78oi+ZlUyamcUadflPBMPhqD6X9hfXwtrUd1JypyRslRvmMMIq2mlAexfX8
 wrwuMDBCPYCg==
X-IronPort-AV: E=Sophos;i="5.82,214,1613462400"; 
   d="scan'208";a="521030371"
Received: from rutujajo-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.194.203])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2021 21:22:01 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, bp@alien8.de,
        jarkko@kernel.org, dave.hansen@intel.com, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v5 04/11] KVM: x86: Add reverse-CPUID lookup support for scattered SGX features
Date:   Mon, 12 Apr 2021 16:21:36 +1200
Message-Id: <e797c533f4c71ae89265bbb15a02aef86b67cbec.1618196135.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1618196135.git.kai.huang@intel.com>
References: <cover.1618196135.git.kai.huang@intel.com>
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
index 315fa45eb7c8..40aec1443430 100644
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

