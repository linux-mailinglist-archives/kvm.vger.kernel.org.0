Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF5CBFD1A
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 04:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbfI0CR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 22:17:28 -0400
Received: from mga17.intel.com ([192.55.52.151]:25572 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728960AbfI0CRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 22:17:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 19:17:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,553,1559545200"; 
   d="scan'208";a="193020711"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga003.jf.intel.com with ESMTP; 26 Sep 2019 19:17:21 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v7 7/7] KVM: x86: Add user-space access interface for CET MSRs
Date:   Fri, 27 Sep 2019 10:19:27 +0800
Message-Id: <20190927021927.23057-8-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190927021927.23057-1-weijiang.yang@intel.com>
References: <20190927021927.23057-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There're two different places storing Guest CET states, the states
managed with XSAVES/XRSTORS, as restored/saved
in previous patch, can be read/write directly from/to the MSRs.
For those stored in VMCS fields, they're access via vmcs_read/
vmcs_write.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 83 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44913e4ab558..5265db7cd2af 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1671,6 +1671,49 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 	return 0;
 }
 
+static int check_cet_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	u64 kvm_xss = kvm_supported_xss();
+
+	switch (msr_info->index) {
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL2_SSP:
+		if (!(kvm_xss | XFEATURE_MASK_CET_KERNEL))
+			return 1;
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
+			return 1;
+		break;
+	case MSR_IA32_PL3_SSP:
+		if (!(kvm_xss | XFEATURE_MASK_CET_USER))
+			return 1;
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
+			return 1;
+		break;
+	case MSR_IA32_U_CET:
+		if (!(kvm_xss | XFEATURE_MASK_CET_USER))
+			return 1;
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
+			return 1;
+		break;
+	case MSR_IA32_S_CET:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
+			return 1;
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
+			return 1;
+		break;
+	default:
+		return 1;
+	}
+	return 0;
+}
 /*
  * Reads an msr value (of 'msr_index') into 'pdata'.
  * Returns 0 on success, non-0 otherwise.
@@ -1788,6 +1831,26 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
 		break;
+	case MSR_IA32_S_CET:
+		if (check_cet_msr(vcpu, msr_info))
+			return 1;
+		msr_info->data = vmcs_readl(GUEST_S_CET);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		if (check_cet_msr(vcpu, msr_info))
+			return 1;
+		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
+		break;
+	case MSR_IA32_U_CET:
+		if (check_cet_msr(vcpu, msr_info))
+			return 1;
+		rdmsrl(MSR_IA32_U_CET, msr_info->data);
+		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (check_cet_msr(vcpu, msr_info))
+			return 1;
+		rdmsrl(msr_info->index, msr_info->data);
+		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
@@ -2039,6 +2102,26 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
+	case MSR_IA32_S_CET:
+		if (check_cet_msr(vcpu, msr_info))
+			return 1;
+		vmcs_writel(GUEST_S_CET, data);
+		break;
+	case MSR_IA32_INT_SSP_TAB:
+		if (check_cet_msr(vcpu, msr_info))
+			return 1;
+		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
+		break;
+	case MSR_IA32_U_CET:
+		if (check_cet_msr(vcpu, msr_info))
+			return 1;
+		wrmsrl(MSR_IA32_U_CET, data);
+		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		if (check_cet_msr(vcpu, msr_info))
+			return 1;
+		wrmsrl(msr_info->index, data);
+		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
-- 
2.17.2

