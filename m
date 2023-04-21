Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399C76EAF96
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 18:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbjDUQva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 12:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233338AbjDUQvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 12:51:09 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BDD1446C;
        Fri, 21 Apr 2023 09:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682095854; x=1713631854;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=78zDRIkxntx7XpSCBd+PlWB7x/igZ56S5f6aXY9OngU=;
  b=b4KhRgSjLaq9EB7Jc6Rd+eWcjJkbDIDYVnqECD7gcqxpOUzttk0xDa4u
   iZCh0b2n92iAPZuOlIVqPH4G05eg9TM/4ktHlBCEWojPBDVfBhWHivWjC
   /OIKu6W09dzHa943L1NHXcycCp5JrxDmC1ZvjobfxUGPUCABtEXsrO5yF
   xnTz7caamvg6MhgFdFyg8UmvfrAmWQaO+ropRcFcjTY3J+KcGUeQ+aoBN
   iSPNfla7LEGLYztE8CcMzlkPnDhhor8DHfy3okFKgVDV+9sQ+iIv6EzUN
   cnH0nFzb7RCqwdKqUKQK4nOOeBcFeUUh7iz43S3IHNKzswi//3VBDnOt3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="344787068"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="344787068"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="722817425"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="722817425"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 09:50:44 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, weijiang.yang@intel.com
Subject: [PATCH v2 20/21] KVM:x86: Enable supervisor IBT support for guest
Date:   Fri, 21 Apr 2023 09:46:14 -0400
Message-Id: <20230421134615.62539-21-weijiang.yang@intel.com>
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

Add support for MSR_IA32_S_CET and GUEST_S_CET access.

Mainline Linux kernel now supports supervisor IBT for kernel code,
to make s-IBT work in guest(nested guest), pass through MSR_IA32_S_CET
to guest(nested guest) if host kernel and KVM enabled IBT.

Note, s-IBT can work independent to host xsaves support because guest
MSR_IA32_S_CET is {stored|loaded} from VMCS GUEST_S_CET field.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  3 +++
 arch/x86/kvm/vmx/vmx.c    | 21 ++++++++++++++++++---
 arch/x86/kvm/x86.c        |  1 +
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 522ac27d2534..bf690827bfee 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -664,6 +664,9 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_U_CET, MSR_TYPE_RW);
 
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_S_CET, MSR_TYPE_RW);
+
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_PL3_SSP, MSR_TYPE_RW);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index db4aacbcba7f..6eab3e452bbb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -711,6 +711,7 @@ static bool is_valid_passthrough_msr(u32 msr)
 		return true;
 	case MSR_IA32_U_CET:
 	case MSR_IA32_PL3_SSP:
+	case MSR_IA32_S_CET:
 		return true;
 	}
 
@@ -1961,7 +1962,8 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 static bool cet_is_msr_accessible(struct kvm_vcpu *vcpu,
 				  struct msr_data *msr)
 {
-	if (!kvm_cet_user_supported())
+	if (!kvm_cet_user_supported() &&
+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
 		return false;
 
 	if (msr->host_initiated)
@@ -1971,6 +1973,9 @@ static bool cet_is_msr_accessible(struct kvm_vcpu *vcpu,
 	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
 		return false;
 
+	if (msr->index == MSR_IA32_S_CET)
+		return guest_cpuid_has(vcpu, X86_FEATURE_IBT);
+
 	if ((msr->index == MSR_IA32_PL3_SSP ||
 	     msr->index == MSR_KVM_GUEST_SSP) &&
 	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
@@ -2120,10 +2125,13 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_U_CET:
 	case MSR_IA32_PL3_SSP:
 	case MSR_KVM_GUEST_SSP:
+	case MSR_IA32_S_CET:
 		if (!cet_is_msr_accessible(vcpu, msr_info))
 			return 1;
 		if (msr_info->index == MSR_KVM_GUEST_SSP)
 			msr_info->data = vmcs_readl(GUEST_SSP);
+		else if (msr_info->index == MSR_IA32_S_CET)
+			msr_info->data = vmcs_readl(GUEST_S_CET);
 		else
 			kvm_get_xsave_msr(msr_info);
 		break;
@@ -2440,12 +2448,16 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
 	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
 		if (!cet_is_msr_accessible(vcpu, msr_info))
 			return 1;
 		if ((data & GENMASK(9, 6)) ||
 		    is_noncanonical_address(data, vcpu))
 			return 1;
-		kvm_set_xsave_msr(msr_info);
+		if (msr_index == MSR_IA32_S_CET)
+			vmcs_writel(GUEST_S_CET, data);
+		else
+			kvm_set_xsave_msr(msr_info);
 		break;
 	case MSR_IA32_PL3_SSP:
 	case MSR_KVM_GUEST_SSP:
@@ -7759,6 +7771,9 @@ static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
 
 	incpt |= !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
 	vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL3_SSP, MSR_TYPE_RW, incpt);
+
+	incpt |= !guest_cpuid_has(vcpu, X86_FEATURE_IBT);
+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_S_CET, MSR_TYPE_RW, incpt);
 }
 
 static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
@@ -7829,7 +7844,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	/* Refresh #PF interception to account for MAXPHYADDR changes. */
 	vmx_update_exception_bitmap(vcpu);
 
-	if (kvm_cet_user_supported())
+	if (kvm_cet_user_supported() || kvm_cpu_cap_has(X86_FEATURE_IBT))
 		vmx_update_intercept_for_cet_msr(vcpu);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ba82b102600d..51fccbd2d3e7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1471,6 +1471,7 @@ static const u32 msrs_to_save_base[] = {
 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
 	MSR_IA32_XSS,
 	MSR_IA32_U_CET, MSR_IA32_PL3_SSP, MSR_KVM_GUEST_SSP,
+	MSR_IA32_S_CET,
 };
 
 static const u32 msrs_to_save_pmu[] = {
-- 
2.27.0

