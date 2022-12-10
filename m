Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA759648FC0
	for <lists+kvm@lfdr.de>; Sat, 10 Dec 2022 17:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiLJQUF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Dec 2022 11:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiLJQTb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Dec 2022 11:19:31 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F6C1AA06;
        Sat, 10 Dec 2022 08:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670689154; x=1702225154;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OX7uFn6N9uY8SXcXm88RgI0VqH58t7OqQqhqDApVw/w=;
  b=mAsC1GMmfJSP7Reqs0bkUS83fbDDPpHcCcxGNVxbAjsWYlq7UlBV70Qk
   fZP9RLsFGSZfXDuwYuhB3AIlp1USc17Q8jIHMxyhaT0yGO14U91ZOP/G+
   NPPSgJP3G31GuhPCiQ8+dNI3ShzjmdD9zAHpmls1EsfeRHtNqfgIcV6P3
   Jq+IEzBFp+BHuigIH2+XzwuGddMnHEE1Zgn/ONPMcldFBRl9hu/fjX6LT
   kPTOOwHO7rHSNG/NEzveae9Rqt2TzfJkU9e1pPmiM9+OQkoqHaRDKstCI
   wkoguwTWytSs6+oGq+9mSRrxSZ6/Vj1OTaPxrw4cDB2AjS+ZJG2e7idfL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10557"; a="318780507"
X-IronPort-AV: E=Sophos;i="5.96,234,1665471600"; 
   d="scan'208";a="318780507"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2022 08:19:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10557"; a="711208706"
X-IronPort-AV: E=Sophos;i="5.96,234,1665471600"; 
   d="scan'208";a="711208706"
Received: from unknown (HELO localhost.localdomain) ([10.239.161.133])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2022 08:19:10 -0800
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
Subject: [RFC PATCH 8/9] x86/kvm/vmx: Initialize SPEC_CTRL MASK for RRSBA
Date:   Sun, 11 Dec 2022 00:00:45 +0800
Message-Id: <20221210160046.2608762-9-chen.zhang@intel.com>
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

VMMs can address mitigations issues in migration pool by applying
the needed controls whenever the guest is operating on a newer
processor. If a guest is using retpoline to mitigate intra-mode BTI
in CPL0, the VMM can set RRSBA_DIS_S when the guest runs on hardware
which enumerates RRSBA.

Signed-off-by: Zhang Chen <chen.zhang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 57 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6ed6b743be0e..fb0f3b1639b9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2007,6 +2007,20 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		msr_info->data = vmx->msr_virtual_enumeration;
 		break;
+	case MSR_VIRTUAL_MITIGATION_ENUM:
+		if (!msr_info->host_initiated &&
+		    !(vmx->msr_virtual_enumeration &
+		    VIRT_ENUM_MITIGATION_CTRL_SUPPORT))
+			return 1;
+		msr_info->data = vmx->msr_virtual_mitigation_enum;
+		break;
+	case MSR_VIRTUAL_MITIGATION_CTRL:
+		if (!msr_info->host_initiated &&
+		    !(vmx->msr_virtual_enumeration &
+		    VIRT_ENUM_MITIGATION_CTRL_SUPPORT))
+			return 1;
+		msr_info->data = vmx->msr_virtual_mitigation_ctrl;
+		break;
 	default:
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_info->index);
@@ -2056,7 +2070,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	struct vmx_uret_msr *msr;
 	int ret = 0;
 	u32 msr_index = msr_info->index;
-	u64 data = msr_info->data;
+	u64 data = msr_info->data, arch_msr;
 	u32 index;
 
 	switch (msr_index) {
@@ -2390,6 +2404,46 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vmx->msr_virtual_enumeration = data &
 						VIRT_ENUM_MITIGATION_CTRL_SUPPORT;
 		break;
+	case MSR_VIRTUAL_MITIGATION_ENUM:
+		if (msr_info->host_initiated &&
+		    !(vmx->msr_virtual_enumeration &
+		    VIRT_ENUM_MITIGATION_CTRL_SUPPORT))
+			return 1;
+		if (data & ~MITI_ENUM_SUPPORTED)
+			return 1;
+		vmx->msr_virtual_mitigation_enum = data;
+		break;
+	case MSR_VIRTUAL_MITIGATION_CTRL:
+		if (!msr_info->host_initiated &&
+		    !(vmx->msr_virtual_enumeration &
+		    VIRT_ENUM_MITIGATION_CTRL_SUPPORT))
+			return 1;
+		if (data & ~MITI_CTRL_USED)
+			return 1;
+
+		if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
+			rdmsrl(MSR_IA32_ARCH_CAPABILITIES, arch_msr);
+
+		if (data & MITI_CTRL_RETPOLINE_S_USED &&
+		    boot_cpu_has(X86_FEATURE_RRSBA_CTRL) &&
+		    arch_msr & ARCH_CAP_RRSBA)
+			vmx->spec_ctrl_mask |= SPEC_CTRL_RRSBA_DIS_S;
+		else
+			vmx->spec_ctrl_mask &= ~SPEC_CTRL_RRSBA_DIS_S;
+
+		if (cpu_has_virt_spec_ctrl()) {
+			vmcs_write64(IA32_SPEC_CTRL_MASK, vmx->spec_ctrl_mask);
+		} else if (vmx->spec_ctrl_mask) {
+			pr_err_once("Virtual spec ctrl is missing. Cannot keep "
+					"bits in %llx always set\n",
+					vmx->spec_ctrl_mask);
+			vmx->spec_ctrl_mask = 0;
+		}
+
+		vmx->spec_ctrl = vmx->spec_ctrl | vmx->spec_ctrl_mask;
+
+		vmx->msr_virtual_mitigation_ctrl = data;
+		break;
 
 	default:
 	find_uret_msr:
@@ -4774,6 +4828,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vmx->rmode.vm86_active = 0;
 
+	vmx->msr_virtual_mitigation_ctrl = 0;
 	if (cpu_has_virt_spec_ctrl()) {
 		vmx->spec_ctrl_mask = 0;
 		vmcs_write64(IA32_SPEC_CTRL_MASK, vmx->spec_ctrl_mask);
-- 
2.25.1

