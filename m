Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F72648FB2
	for <lists+kvm@lfdr.de>; Sat, 10 Dec 2022 17:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiLJQTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Dec 2022 11:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiLJQS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Dec 2022 11:18:58 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54041903C;
        Sat, 10 Dec 2022 08:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670689135; x=1702225135;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jJywodcOgHQB5TBBvwp4cOqodYErhHuV9OjQHIcmq+8=;
  b=kD8bJerWlYZ84OWcjdj+cNsMLrho4toNcJf9C2/Tlw0qX6YpnLAllWSo
   +v+QDkLr+4J7PXi3xd1x9jnpgvCxS9Kb9a3aZWaVD70NMRnpzVo8uzBCX
   fT+wfVOVJZGqx9HTHZqAsSsWpVvgpczAbyRcakkp82K46fjoVlmXxNJ7S
   dnWnBt43w9n+aOs890fSzZYpmpgB/m4w6jffotBglmFDO8nzww8o2rby3
   nNgbFK4sn1gY4ehUvKBMNLSfbPbxrYRx6A9QZMp7hYfP8Xfb5pu1xdCyd
   8ygFunGZYZ9d39qc+Yrimq6eUMWeX11GpZB7lFX9o3Efv+SYQbeqKTFBh
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10557"; a="318780434"
X-IronPort-AV: E=Sophos;i="5.96,234,1665471600"; 
   d="scan'208";a="318780434"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2022 08:18:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10557"; a="711208627"
X-IronPort-AV: E=Sophos;i="5.96,234,1665471600"; 
   d="scan'208";a="711208627"
Received: from unknown (HELO localhost.localdomain) ([10.239.161.133])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2022 08:18:52 -0800
From:   Zhang Chen <chen.zhang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Zhang Chen <chen.zhang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 2/9] KVM: x86: Add a kvm-only leaf for RRSBA_CTRL
Date:   Sun, 11 Dec 2022 00:00:39 +0800
Message-Id: <20221210160046.2608762-3-chen.zhang@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221210160046.2608762-1-chen.zhang@intel.com>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM needs to check if guests can see RRSBA_CTRL. If a guest is using
retpoline and cannot see RRSBA_CTRL and the host enumerates RRSBA,
KVM is responsible for setting RRSBA_DIS_S for the guest.

This allows VM migration from parts doesn't enumerates RRSBA to those
that enumerate RRSBA.

Signed-off-by: Zhang Chen <chen.zhang@intel.com>
---
 arch/x86/kvm/cpuid.c         | 4 ++++
 arch/x86/kvm/reverse_cpuid.h | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 62bc7a01cecc..8d45bc0b4b7c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -668,6 +668,10 @@ void kvm_set_cpu_caps(void)
 		SF(SGX1) | SF(SGX2)
 	);
 
+	kvm_cpu_cap_init_scattered(CPUID_7_2_EDX,
+		SF(RRSBA_CTRL)
+	);
+
 	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
 		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
 		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index a19d473d0184..4c38ed61c505 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -13,6 +13,7 @@
  */
 enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
+	CPUID_7_2_EDX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -24,6 +25,9 @@ enum kvm_only_cpuid_leafs {
 #define KVM_X86_FEATURE_SGX1		KVM_X86_FEATURE(CPUID_12_EAX, 0)
 #define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
 
+/* Intel-defined sub-features, CPUID level 0x00000007:2 (EDX)*/
+#define KVM_X86_FEATURE_RRSBA_CTRL	KVM_X86_FEATURE(CPUID_7_2_EDX, 2)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -46,6 +50,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
 	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
+	[CPUID_7_2_EDX]       = {         7, 2, CPUID_EDX},
 	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
 	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
 };
@@ -78,6 +83,8 @@ static __always_inline u32 __feature_translate(int x86_feature)
 		return KVM_X86_FEATURE_SGX1;
 	else if (x86_feature == X86_FEATURE_SGX2)
 		return KVM_X86_FEATURE_SGX2;
+	else if (x86_feature == X86_FEATURE_RRSBA_CTRL)
+		return KVM_X86_FEATURE_RRSBA_CTRL;
 
 	return x86_feature;
 }
-- 
2.25.1

