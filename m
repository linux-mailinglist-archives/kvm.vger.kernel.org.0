Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A6A6EAFAC
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 18:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbjDUQvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 12:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbjDUQvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 12:51:05 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDC815468;
        Fri, 21 Apr 2023 09:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682095852; x=1713631852;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mCyLn2dPPOSZGk1Xcubyk/irHLv8dzLxbkgWPygxPU0=;
  b=Eth6nn5wT1wgyrpcwyih10CIDvjNcGjo5louxzC8OyLshv/oDG1mU4Me
   rWQCyLMng0C3eQyMBJM4Oz8k+SXiYKm3SJ3xdqITu59Ld1nMpxE9tQH4n
   rL3P/jHydsYx7bx4rm93qaY7bWMoNgVgwEj3e4dmLbUipbd5UYzlwHQkr
   IVq7dW1Do4YUTwWDLRVTtg9QvNLOUWmIWu54V/rclq/gu68MX7TJ12qT9
   N2kiD4Ptr2gT7A4UswfbPrvqFhsl7Lu6AjvdCAg6EcoVs0VYU31DsG4mt
   LrMwvb9LTEoYvNwkcYtcbqjO7endcyeNxhkVhP8iimN0i/u3OipQllanu
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="344787055"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="344787055"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="722817414"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="722817414"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:44 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        Zhang Yi Z <yi.z.zhang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2 17/21] KVM:VMX: Pass through user CET MSRs to the guest
Date:   Fri, 21 Apr 2023 09:46:11 -0400
Message-Id: <20230421134615.62539-18-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230421134615.62539-1-weijiang.yang@intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass through CET user mode MSRs when the associated CET component
is enabled to improve guest performance. All CET MSRs are context
switched, either via dedicated VMCS fields or XSAVES.

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 42211ae40650..1ec7835c3060 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -709,6 +709,9 @@ static bool is_valid_passthrough_msr(u32 msr)
 	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
 		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
 		return true;
+	case MSR_IA32_U_CET:
+	case MSR_IA32_PL3_SSP:
+		return true;
 	}
 
 	r = possible_passthrough_msr_slot(msr) != -ENOENT;
@@ -7726,6 +7729,23 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
 }
 
+static bool is_cet_state_supported(struct kvm_vcpu *vcpu, u32 xss_state)
+{
+	return (kvm_caps.supported_xss & xss_state) &&
+	       (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_IBT));
+}
+
+static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
+{
+	bool incpt = !is_cet_state_supported(vcpu, XFEATURE_MASK_CET_USER);
+
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_U_CET, MSR_TYPE_RW, incpt);
+
+	incpt |= !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, incpt);
+}
+
 static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -7793,6 +7813,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
+
+	if (kvm_cet_user_supported())
+		vmx_update_intercept_for_cet_msr(vcpu);
 }
 
 static u64 vmx_get_perf_capabilities(void)
-- 
2.27.0

