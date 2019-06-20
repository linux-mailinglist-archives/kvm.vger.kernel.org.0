Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 804724C67B
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 07:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfFTFFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 01:05:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:13844 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725857AbfFTFFi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 01:05:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 22:05:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,395,1557212400"; 
   d="scan'208";a="182953999"
Received: from tao-optiplex-7060.sh.intel.com ([10.239.13.104])
  by fmsmga004.fm.intel.com with ESMTP; 19 Jun 2019 22:05:35 -0700
From:   Tao Xu <tao3.xu@intel.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiaoyao.li@linux.intel.com, tao3.xu@intel.com
Subject: [PATCH] KVM: vmx: Fix the broken usage of vmx_xsaves_supported
Date:   Thu, 20 Jun 2019 13:03:01 +0800
Message-Id: <20190620050301.1149-1-tao3.xu@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The helper vmx_xsaves_supported() returns the bit value of
SECONDARY_EXEC_XSAVES in vmcs_config.cpu_based_2nd_exec_ctrl, which
remains unchanged true if vmcs supports 1-setting of this bit after
setup_vmcs_config(). It should check the guest's cpuid not this
unchanged value when get/set msr.

Besides, vmx_compute_secondary_exec_control() adjusts
SECONDARY_EXEC_XSAVES bit based on guest cpuid's X86_FEATURE_XSAVE
and X86_FEATURE_XSAVES, it should use updated value to decide whether
set XSS_EXIT_BITMAP.

Co-developed-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
Signed-off-by: Tao Xu <tao3.xu@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b93e36ddee5e..935cf72439a9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1721,7 +1721,8 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		return vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
 				       &msr_info->data);
 	case MSR_IA32_XSS:
-		if (!vmx_xsaves_supported())
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) ||
+			!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
 			return 1;
 		msr_info->data = vcpu->arch.ia32_xss;
 		break;
@@ -1935,7 +1936,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		return vmx_set_vmx_msr(vcpu, msr_index, data);
 	case MSR_IA32_XSS:
-		if (!vmx_xsaves_supported())
+		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) ||
+			!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
 			return 1;
 		/*
 		 * The only supported bit as of Skylake is bit 8, but
@@ -4094,7 +4096,7 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
 
 	set_cr4_guest_host_mask(vmx);
 
-	if (vmx_xsaves_supported())
+	if (vmx->secondary_exec_control & SECONDARY_EXEC_XSAVES)
 		vmcs_write64(XSS_EXIT_BITMAP, VMX_XSS_EXIT_BITMAP);
 
 	if (enable_pml) {
-- 
2.20.1

