Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBE434165E
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 08:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234137AbhCSHW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 03:22:56 -0400
Received: from mga14.intel.com ([192.55.52.115]:59402 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234168AbhCSHWf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 03:22:35 -0400
IronPort-SDR: QD/x6QbE3d4QiXI3s5T2V8hw9nUYgmY1CDCPuGO6JMk8a+tmBJvoPWV/o5/OREYh3Xda1f7HF1
 t9YiweWugdZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="189222109"
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="189222109"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:22:35 -0700
IronPort-SDR: ed42vW7y4IWWkFm1KTmRfBEu3a4rTD9KmDRu7JHDeYOobOLmh2VNPJefR46n1qAo1SD2ddlQP7
 w2M4wUBjyimw==
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="413409177"
Received: from dlmeisen-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.165])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:22:30 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v3 01/25] x86/cpufeatures: Make SGX_LC feature bit depend on SGX bit
Date:   Fri, 19 Mar 2021 20:22:17 +1300
Message-Id: <5d4220fd0a39f52af024d3fa166231c1d498dd10.1616136308.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1616136307.git.kai.huang@intel.com>
References: <cover.1616136307.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move SGX_LC feature bit to CPUID dependency table to make clearing all
SGX feature bits easier. Also remove clear_sgx_caps() since it is just
a wrapper of setup_clear_cpu_cap(X86_FEATURE_SGX) now.

Suggested-by: Sean Christopherson <seanjc@google.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kernel/cpu/cpuid-deps.c |  1 +
 arch/x86/kernel/cpu/feat_ctl.c   | 12 +++---------
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index 42af31b64c2c..d40f8e0a54ce 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -72,6 +72,7 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_AVX512_FP16,		X86_FEATURE_AVX512BW  },
 	{ X86_FEATURE_ENQCMD,			X86_FEATURE_XSAVES    },
 	{ X86_FEATURE_PER_THREAD_MBA,		X86_FEATURE_MBA       },
+	{ X86_FEATURE_SGX_LC,			X86_FEATURE_SGX	      },
 	{}
 };
 
diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index 3b1b01f2b248..27533a6e04fa 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -93,15 +93,9 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
 }
 #endif /* CONFIG_X86_VMX_FEATURE_NAMES */
 
-static void clear_sgx_caps(void)
-{
-	setup_clear_cpu_cap(X86_FEATURE_SGX);
-	setup_clear_cpu_cap(X86_FEATURE_SGX_LC);
-}
-
 static int __init nosgx(char *str)
 {
-	clear_sgx_caps();
+	setup_clear_cpu_cap(X86_FEATURE_SGX);
 
 	return 0;
 }
@@ -116,7 +110,7 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 
 	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr)) {
 		clear_cpu_cap(c, X86_FEATURE_VMX);
-		clear_sgx_caps();
+		clear_cpu_cap(c, X86_FEATURE_SGX);
 		return;
 	}
 
@@ -177,6 +171,6 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 	    !(msr & FEAT_CTL_SGX_LC_ENABLED) || !enable_sgx) {
 		if (enable_sgx)
 			pr_err_once("SGX disabled by BIOS\n");
-		clear_sgx_caps();
+		clear_cpu_cap(c, X86_FEATURE_SGX);
 	}
 }
-- 
2.30.2

