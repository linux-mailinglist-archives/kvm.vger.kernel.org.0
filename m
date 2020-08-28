Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946602556EE
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 10:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbgH1Iy2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 04:54:28 -0400
Received: from mga17.intel.com ([192.55.52.151]:49198 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728774AbgH1IyX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 04:54:23 -0400
IronPort-SDR: lc/i28o/6A0YZv1Wg/P4diajzsWCa6WLh+pwpT2Gip4rpDgKYhLpbmE150oMJEyXzOCYn91jDp
 3WXBPQIZz/6g==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="136697520"
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="136697520"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 01:54:22 -0700
IronPort-SDR: gBGqHdoPb/WXQ5nTVOewezRZAeaOinBm8VEmrRq3VGHK3k0vuHNdatIZj7eaDXSNF0gWW4yPhf
 hZAMJJfL8hZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="332483515"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by fmsmga002.fm.intel.com with ESMTP; 28 Aug 2020 01:54:20 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] KVM: nVMX: Update VMX controls MSR according to guest CPUID after setting VMX MSRs
Date:   Fri, 28 Aug 2020 16:56:20 +0800
Message-Id: <20200828085622.8365-4-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200828085622.8365-1-chenyi.qiang@intel.com>
References: <20200828085622.8365-1-chenyi.qiang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the fields (i.e. VM_{ENTRY_LOAD, EXIT_CLEAR}_BNDCFGS and
VM_{ENTRY, EXIT}_LOAD_IA32_PERF_GLOBAL_CTRL) in
nested MSR_IA32_VMX_TRUE_{ENTRY, EXIT}_CTLS according to guest CPUID
when user space initializes the features MSRs. Regardless of the order
of SET_CPUID and SET_MSRS from the user space, do the update to avoid
MSR values overriding.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 819c185adf09..f9664ccc003b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -345,6 +345,7 @@ static bool guest_state_valid(struct kvm_vcpu *vcpu);
 static u32 vmx_segment_access_rights(struct kvm_segment *var);
 static __always_inline void vmx_disable_intercept_for_msr(unsigned long *msr_bitmap,
 							  u32 msr, int type);
+static void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
 
 void vmx_vmexit(void);
 
@@ -2161,7 +2162,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1; /* they are read-only */
 		if (!nested_vmx_allowed(vcpu))
 			return 1;
-		return vmx_set_vmx_msr(vcpu, msr_index, data);
+		ret = vmx_set_vmx_msr(vcpu, msr_index, data);
+		nested_vmx_pmu_entry_exit_ctls_update(vcpu);
+		nested_vmx_entry_exit_ctls_update(vcpu);
+		break;
 	case MSR_IA32_RTIT_CTL:
 		if (!vmx_pt_mode_is_host_guest() ||
 			vmx_rtit_ctl_check(vcpu, data) ||
-- 
2.17.1

