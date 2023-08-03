Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAC076E1C2
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 09:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbjHCHhX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 03:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbjHCHgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 03:36:09 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F3B49DE;
        Thu,  3 Aug 2023 00:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691047940; x=1722583940;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=93vLErl8ccSchrRyHq0bfKsXuDt7NS/Y/g+1+b739Vw=;
  b=SbsvmerdnnchPRroZiZO4kOEuyUj1IDhI+BbMM4eQ1HWgWaG/Stz3UI0
   3qKhlGrN7HzJ6MeDZuWn8imp8YHhi1f8gOUmq9zJAl1LvZxYjx09eTQV2
   PFM0CnXyqdP+IVoHsfZbSRjpcW7ZTkZO7BLlK/6VGtShg+5VJN/GKpSNw
   m9CejDpKbk9Qg1LBFjBVXRPtTlsW3pQYmGx+kUTEzYCjkeyKK3EzvOcCL
   b5sFeaNEStwIDwuk4kLG2zYcASvBsBlXmhoHCxZNfiHmA0ii+HHeDzw74
   Mopod1w0snP9aLrPopNe8lnxw+yno87GzEUQVocgZMdZ/YE6Pub/0UqE0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="354708150"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="354708150"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="794888508"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="794888508"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:32:17 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, weijiang.yang@intel.com
Subject: [PATCH v5 13/19] KVM:VMX: Set up interception for CET MSRs
Date:   Thu,  3 Aug 2023 00:27:26 -0400
Message-Id: <20230803042732.88515-14-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230803042732.88515-1-weijiang.yang@intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass through CET MSRs when the associated feature is enabled.
Shadow Stack feature requires all the CET MSRs to make it
architectural support in guest. IBT feature only depends on
MSR_IA32_U_CET and MSR_IA32_S_CET to enable both user and
supervisor IBT. Note, This MSR design introduced an architectual
limitation of SHSTK and IBT control for guest, i.e., when SHSTK
is exposed, IBT is also available to guest from architectual level
since IBT relies on subset of SHSTK relevant MSRs.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ccf750e79608..6779b8a63789 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -709,6 +709,10 @@ static bool is_valid_passthrough_msr(u32 msr)
 	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
 		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
 		return true;
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
+		return true;
 	}
 
 	r = possible_passthrough_msr_slot(msr) != -ENOENT;
@@ -7747,6 +7751,41 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
+static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
+{
+	bool incpt;
+
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+		incpt = !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
+
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
+					  MSR_TYPE_RW, incpt);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
+					  MSR_TYPE_RW, incpt);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
+					  MSR_TYPE_RW, incpt);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
+					  MSR_TYPE_RW, incpt);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
+					  MSR_TYPE_RW, incpt);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP,
+					  MSR_TYPE_RW, incpt);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
+					  MSR_TYPE_RW, incpt);
+		if (!incpt)
+			return;
+	}
+
+	if (kvm_cpu_cap_has(X86_FEATURE_IBT)) {
+		incpt = !guest_can_use(vcpu, X86_FEATURE_IBT);
+
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET,
+					  MSR_TYPE_RW, incpt);
+		vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET,
+					  MSR_TYPE_RW, incpt);
+	}
+}
+
 static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7814,6 +7853,8 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
+
+	vmx_update_intercept_for_cet_msr(vcpu);
 }
 
 static u64 vmx_get_perf_capabilities(void)
-- 
2.27.0

