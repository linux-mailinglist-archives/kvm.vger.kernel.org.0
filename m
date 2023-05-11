Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A4E6FEC8F
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 09:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237574AbjEKHPN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 03:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237217AbjEKHO2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 03:14:28 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540B17DAA;
        Thu, 11 May 2023 00:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683789243; x=1715325243;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W68GLsI7BGlcsv3VlSMXq+A0E1axs4XFaQILR6l9S10=;
  b=ZM6fhvhmtw6UJuoSdp6I6vmsZcNRSNRlJ1MiI/XpDINjzPtZ/vfJNnsW
   b1FvlloJi5dv1BckllXkCIu63ucY+vihdhcQpKQRZIInWhQKK9g0BikiA
   Pq6ZNEnQbuDuf7x52PM1tz7W8rx4J+BrPWOXicxDwmzxUIY3Oug1Bte2E
   af1REp8DCrzqjPJqjKFv1J3EwyYAuTYvRaKTdv3QGgMx3uQGOwAM3qiYq
   KwyKOjLKXQum3zfmF8ZokhBicMTREORNZn1UdSHkrHsMkCFkw9/e5lGQv
   EyhRbmJ7dz/LRJJjV5RLlkzHj1/CH6vcp2ggD34W+iiXXPUqKBSYsprXH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="334896682"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="334896682"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="1029512381"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="1029512381"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 00:13:25 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, weijiang.yang@intel.com,
        john.allen@amd.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v3 14/21] KVM:VMX: Add a synthetic MSR to allow userspace to access GUEST_SSP
Date:   Thu, 11 May 2023 00:08:50 -0400
Message-Id: <20230511040857.6094-15-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230511040857.6094-1-weijiang.yang@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
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

Introduce a host-only synthetic MSR, MSR_KVM_GUEST_SSP, so that the VMM
can read/write the guest's SSP, e.g. to migrate CET state.  Use a synthetic
MSR, e.g. as opposed to a VCPU_REG_, as GUEST_SSP is subject to the same
consistency checks as the PL*_SSP MSRs, i.e. can share code.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/uapi/asm/kvm_para.h |  1 +
 arch/x86/kvm/vmx/vmx.c               | 15 ++++++++++++---
 arch/x86/kvm/x86.c                   |  4 ++++
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 6e64b27b2c1e..7af465e4e0bd 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -58,6 +58,7 @@
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
 #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
+#define MSR_KVM_GUEST_SSP	0x4b564d09
 
 struct kvm_steal_time {
 	__u64 steal;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0ccaa467d7d3..72149156bbd3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2095,9 +2095,13 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_U_CET:
 	case MSR_IA32_PL3_SSP:
+	case MSR_KVM_GUEST_SSP:
 		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
 			return 1;
-		kvm_get_xsave_msr(msr_info);
+		if (msr_info->index == MSR_KVM_GUEST_SSP)
+			msr_info->data = vmcs_readl(GUEST_SSP);
+		else
+			kvm_get_xsave_msr(msr_info);
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
@@ -2413,15 +2417,20 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_U_CET:
 	case MSR_IA32_PL3_SSP:
+	case MSR_KVM_GUEST_SSP:
 		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
 			return 1;
 		if (is_noncanonical_address(data, vcpu))
 			return 1;
 		if (msr_index == MSR_IA32_U_CET && (data & GENMASK(9, 6)))
 			return 1;
-		if (msr_index == MSR_IA32_PL3_SSP && (data & GENMASK(2, 0)))
+		if ((msr_index == MSR_IA32_PL3_SSP ||
+		     msr_index == MSR_KVM_GUEST_SSP) && (data & GENMASK(2, 0)))
 			return 1;
-		kvm_set_xsave_msr(msr_info);
+		if (msr_index == MSR_KVM_GUEST_SSP)
+			vmcs_writel(GUEST_SSP, data);
+		else
+			kvm_set_xsave_msr(msr_info);
 		break;
 	case MSR_IA32_PERF_CAPABILITIES:
 		if (data && !vcpu_to_pmu(vcpu)->version)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2e3a39c9297c..baac6acebd40 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13642,6 +13642,10 @@ bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
 		return false;
 
+	/* The synthetic MSR is for userspace access only. */
+	if (msr->index == MSR_KVM_GUEST_SSP)
+		return false;
+
 	if (msr->index == MSR_IA32_PL3_SSP &&
 	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
 		return false;
-- 
2.27.0

