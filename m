Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360DE312FE8
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 11:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbhBHK7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 05:59:11 -0500
Received: from mga12.intel.com ([192.55.52.136]:12406 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhBHKzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 05:55:17 -0500
IronPort-SDR: J0bpbQlWSWxl/VDO8hhQt1qHbz/258o6W5t3ue5fUvBRg7HSxKAmEFrrmACdpgs6jEBsEqdlmI
 rC8gdEM/h6Jw==
X-IronPort-AV: E=McAfee;i="6000,8403,9888"; a="160848436"
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="160848436"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 02:54:26 -0800
IronPort-SDR: orGDpGs+hGtjow9s1rUhvWUjBnI+3rAOYL5ZrOH1AIEcI7FSywQoKSB3RU8xEr2sAaNqS2921+
 DLR9WESVnuYA==
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="374450953"
Received: from jaeminha-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.11.62])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 02:54:23 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v4 01/26] x86/cpufeatures: Make SGX_LC feature bit depend on SGX bit
Date:   Mon,  8 Feb 2021 23:54:05 +1300
Message-Id: <8e6a1963b3666215223c247193e5a3e09a8c3698.1612777752.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1612777752.git.kai.huang@intel.com>
References: <cover.1612777752.git.kai.huang@intel.com>
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
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

Hi Jarkko, Dave,

I had your Acked-by in v3. Jarkko said this patch should be before the patch
which introduced SGX1/SGX2 bit, since it is improvement of existing code, so I
switched the order. I assumed I can still have your Acked-by because code change
was just due to patch re-ordering.

v3->v4:

 - Changed patch order with the patch that introduced new SGX1/SGX2 bits, since
   it is improvement of existing code, per Jarkko.
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
2.29.2

