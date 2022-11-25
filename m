Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D8F638AA4
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 13:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiKYM6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 07:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiKYM6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 07:58:43 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DC227DF7;
        Fri, 25 Nov 2022 04:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669381122; x=1700917122;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q5uru/FJg753cngn4X04rdHO32+oaebGg6gCaJzWBcU=;
  b=BkzJ2uiD9EKbYtRXxHpve8wq4lfvvfe55mpiJ4gRbh1jWk8JV+MlGsbi
   4vzd1SKrfvN2O7DwYnDzBS67x8oeQuqVozo/0cO2c61thQ+h1EWgDXTPP
   EJWwpC6TW/acPoWjRRq+F19Kiu6u41Cl6JNcLd7rFRC3yIV9pxD/qqZL7
   0iM0PDsMfuprV4pe7X71BYa2ugYtEJSH/ybcHOO04mKCbbf120goxq9ca
   vYgNbkKlAD0vFvq1JGSDGWNGyAfbkvl3+qVJIFu4PjqnAxqFtcIUt36Oy
   3PlnioqajmTo59xAgIdIYngdwgxtfWFPg1DEH4pc/oosXiQurrmI8dZIe
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="314513176"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="314513176"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 04:58:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="706061216"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="706061216"
Received: from jiaxichen-precision-3650-tower.sh.intel.com ([10.239.159.75])
  by fmsmga008.fm.intel.com with ESMTP; 25 Nov 2022 04:58:37 -0800
From:   Jiaxi Chen <jiaxi.chen@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/8] KVM: x86: Add BUILD_BUG_ON() to detect bad usage of "scattered" flags
Date:   Fri, 25 Nov 2022 20:58:38 +0800
Message-Id: <20221125125845.1182922-2-jiaxi.chen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221125125845.1182922-1-jiaxi.chen@linux.intel.com>
References: <20221125125845.1182922-1-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Add a compile-time assert in the SF() macro to detect improper usage,
i.e. to detect passing in an X86_FEATURE_* flag that isn't actually
scattered by the kernel.  Upcoming feature flags will be 100% KVM-only
and will have X86_FEATURE_* macros that point at a kvm_only_cpuid_leafs
word, not a kernel-defined word.  Using SF() and thus boot_cpu_has() for
such feature flags would access memory beyond x86_capability[NCAPINTS]
and at best incorrectly hide a feature, and at worst leak kernel state to
userspace.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 62bc7a01cecc..65b103874139 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -65,7 +65,13 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
 #define KVM_X86_FEATURE_PSFD		(13*32+28) /* Predictive Store Forwarding Disable */
 
 #define F feature_bit
-#define SF(name) (boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0)
+
+/* Scattered Flag - For features that are scattered by cpufeatures.h. */
+#define SF(name)						\
+({								\
+	BUILD_BUG_ON(X86_FEATURE_##name >= MAX_CPU_FEATURES);	\
+	(boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0);	\
+})
 
 /*
  * Magic value used by KVM when querying userspace-provided CPUID entries and
-- 
2.27.0

