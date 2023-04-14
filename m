Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCB76E1CA7
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 08:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjDNG3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 02:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbjDNG3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 02:29:16 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F147D9F;
        Thu, 13 Apr 2023 23:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681453726; x=1712989726;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fp3CgO3/jO65jU0K8gCtkOou6E+ro/os950+MFb95wY=;
  b=GptJlH/rjgY3QtlwmBmuHq41lHdrl7TrltYKSivoOslu6wQ1tM98G7no
   hugFuoRpBJZNYaAE4LLfexmkefpyPbT9eydtpm8ilrWdxDKlWYxO+v7zB
   mTHt4seOShznju3nKasopPljCXpP5RAbHxZsoZuNkRSv/GtFqC2YtLIWt
   ERHxDCRWgR7sJcZXI93Wb2H2Uh5dWSptXBveoJlzPqwIX+FwVbXieyr7f
   8K33ivt03MfCRNUFP6jS94QfRjuhc9A6VmAJ2uTTxXkp3xJQhRmJeRpO6
   rCB24geOTtCjEqzm56gY0in50tqSmrZb2yyN/8JzEzrFCrNtJsDY+46YN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="341892860"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="341892860"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 23:26:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="935885965"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="935885965"
Received: from spr.sh.intel.com ([10.239.53.106])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 23:26:36 -0700
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jiaan Lu <jiaan.lu@intel.com>, Chao Gao <chao.gao@intel.com>,
        Zhang Chen <chen.zhang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 08/11] KVM: VMX: Advertise MITI_ENUM_RETPOLINE_S_SUPPORT
Date:   Fri, 14 Apr 2023 14:25:29 +0800
Message-Id: <20230414062545.270178-9-chao.gao@intel.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230414062545.270178-1-chao.gao@intel.com>
References: <20230414062545.270178-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow guest to query if the underying VMM understands Retpoline and
report the statue of Retpoline in suprevisor mode i.e. CPL < 3 via
MSR_VIRTUAL_MITIGATION_ENUM/CTRL.

Disable RRSBA behavior by setting RRSBA_DIS_S for guest if guest is
using retpoline and the processor has the behavior.

Signed-off-by: Zhang Chen <chen.zhang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Jiaan Lu <jiaan.lu@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 980498c4c30c..25afb4c3e55e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1944,8 +1944,8 @@ static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
 }
 
 #define VIRTUAL_ENUMERATION_VALID_BITS	VIRT_ENUM_MITIGATION_CTRL_SUPPORT
-#define MITI_ENUM_VALID_BITS		0ULL
-#define MITI_CTRL_VALID_BITS		0ULL
+#define MITI_ENUM_VALID_BITS		MITI_ENUM_RETPOLINE_S_SUPPORT
+#define MITI_CTRL_VALID_BITS		MITI_CTRL_RETPOLINE_S_USED
 
 static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 {
@@ -2173,7 +2173,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	struct vmx_uret_msr *msr;
 	int ret = 0;
 	u32 msr_index = msr_info->index;
-	u64 data = msr_info->data, spec_ctrl_mask;
+	u64 data = msr_info->data, arch_msr = 0, spec_ctrl_mask = 0;
 	u32 index;
 
 	switch (msr_index) {
@@ -2488,6 +2488,24 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (data & ~MITI_CTRL_VALID_BITS)
 			return 1;
 
+		if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
+			rdmsrl(MSR_IA32_ARCH_CAPABILITIES, arch_msr);
+
+		if (data & MITI_CTRL_RETPOLINE_S_USED &&
+		    kvm_cpu_cap_has(X86_FEATURE_RRSBA_CTRL) &&
+		    arch_msr & ARCH_CAP_RRSBA)
+			spec_ctrl_mask |= SPEC_CTRL_RRSBA_DIS_S;
+
+		/*
+		 * Intercept IA32_SPEC_CTRL to disallow guest from changing
+		 * certain bits.
+		 */
+		if (spec_ctrl_mask && !cpu_has_spec_ctrl_virt())
+			vmx_enable_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
+
+		vmx_set_spec_ctrl_mask(vmx, spec_ctrl_mask);
+		vmx_set_guest_spec_ctrl(vmx, vmx_get_guest_spec_ctrl(vmx));
+
 		vmx->msr_virtual_mitigation_ctrl = data;
 		break;
 	default:
-- 
2.40.0

