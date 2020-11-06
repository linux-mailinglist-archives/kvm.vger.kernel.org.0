Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116B12A8BE8
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 02:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730895AbgKFBHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 20:07:04 -0500
Received: from mga18.intel.com ([134.134.136.126]:38191 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733170AbgKFBGb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 20:06:31 -0500
IronPort-SDR: oSQ9i817q+zr6wLTDS3yb5K8TPur5XPlcV4Ms2Zdz1oK4Luee9BhonEIxTvakfbCidg4uubSXb
 5w0yYvHygX0w==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="157264703"
X-IronPort-AV: E=Sophos;i="5.77,454,1596524400"; 
   d="scan'208";a="157264703"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 17:06:30 -0800
IronPort-SDR: CZAhIzJEVwQhOlWEoWIlHUhCB8mv7hmduS/uifpTFDSqLzvjIwrI3OQXiYEuknpq/PFE9wxhLi
 oyGIqDE4qwDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,454,1596524400"; 
   d="scan'208";a="471874514"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.156])
  by orsmga004.jf.intel.com with ESMTP; 05 Nov 2020 17:06:28 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v14 08/13] KVM: VMX: Add a synthetic MSR to allow userspace VMM to access GUEST_SSP
Date:   Fri,  6 Nov 2020 09:16:32 +0800
Message-Id: <20201106011637.14289-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20201106011637.14289-1-weijiang.yang@intel.com>
References: <20201106011637.14289-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a host-only synthetic MSR, MSR_KVM_GUEST_SSP so that the VMM
can read/write the guest's SSP, e.g. to migrate CET state.  Use a
synthetic MSR, e.g. as opposed to a VCPU_REG_, as GUEST_SSP is subject
to the same consistency checks as the PL*_SSP MSRs, i.e. can share code.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/uapi/asm/kvm_para.h |  1 +
 arch/x86/kvm/vmx/vmx.c               | 14 ++++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 812e9b4c1114..5203dc084125 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -53,6 +53,7 @@
 #define MSR_KVM_POLL_CONTROL	0x4b564d05
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
+#define MSR_KVM_GUEST_SSP	0x4b564d08
 
 struct kvm_steal_time {
 	__u64 steal;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dd78d3a79e79..28ba8414a7a3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1817,7 +1817,8 @@ static bool cet_is_ssp_msr_accessible(struct kvm_vcpu *vcpu,
 	if (msr->host_initiated)
 		return true;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
+	    msr->index == MSR_KVM_GUEST_SSP)
 		return false;
 
 	if (msr->index == MSR_IA32_INT_SSP_TAB)
@@ -1995,6 +1996,11 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
 		break;
+	case MSR_KVM_GUEST_SSP:
+		if (!cet_is_ssp_msr_accessible(vcpu, msr_info))
+			return 1;
+		msr_info->data = vmcs_readl(GUEST_SSP);
+		break;
 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
 		if (!cet_is_ssp_msr_accessible(vcpu, msr_info))
 			return 1;
@@ -2287,12 +2293,16 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
 		break;
+	case MSR_KVM_GUEST_SSP:
 	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
 		if (!cet_is_ssp_msr_accessible(vcpu, msr_info))
 			return 1;
 		if ((data & GENMASK(2, 0)) || is_noncanonical_address(data, vcpu))
 			return 1;
-		vmx_set_xsave_msr(msr_info);
+		if (msr_index == MSR_KVM_GUEST_SSP)
+			vmcs_writel(GUEST_SSP, data);
+		else
+			vmx_set_xsave_msr(msr_info);
 		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
-- 
2.17.2

