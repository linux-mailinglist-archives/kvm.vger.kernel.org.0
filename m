Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2BDE14F9B7
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbgBASyI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:54:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:11294 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727252AbgBASwd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075586"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2020 10:52:26 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 52/61] KVM: x86: Use KVM cpu caps to detect MSR_TSC_AUX virt support
Date:   Sat,  1 Feb 2020 10:52:09 -0800
Message-Id: <20200201185218.24473-53-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check for MSR_TSC_AUX virtualization via kvm_cpu_cap_has() and drop
->rdtscp_supported().

Note, vmx_rdtscp_supported() needs to hang around a tiny bit longer due
other usage in VMX code.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/svm.c              | 6 ------
 arch/x86/kvm/vmx/vmx.c          | 3 ---
 arch/x86/kvm/x86.c              | 2 +-
 4 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 113b138a0347..1dd5ac8a2136 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1143,7 +1143,6 @@ struct kvm_x86_ops {
 	int (*get_tdp_level)(struct kvm_vcpu *vcpu);
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 	int (*get_lpage_level)(void);
-	bool (*rdtscp_supported)(void);
 
 	void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f4434816dcdf..6dd9c810c0dc 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6074,11 +6074,6 @@ static int svm_get_lpage_level(void)
 	return PT_PDPE_LEVEL;
 }
 
-static bool svm_rdtscp_supported(void)
-{
-	return boot_cpu_has(X86_FEATURE_RDTSCP);
-}
-
 static bool svm_pt_supported(void)
 {
 	return false;
@@ -7443,7 +7438,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.cpuid_update = svm_cpuid_update,
 
-	.rdtscp_supported = svm_rdtscp_supported,
 	.pt_supported = svm_pt_supported,
 
 	.set_supported_cpuid = svm_set_supported_cpuid,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2a1df1b714db..c3577f11f538 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7870,9 +7870,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.get_lpage_level = vmx_get_lpage_level,
 
 	.cpuid_update = vmx_cpuid_update,
-
-	.rdtscp_supported = vmx_rdtscp_supported,
-
 	.set_supported_cpuid = vmx_set_supported_cpuid,
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6d5f22c7ef6..e4353c03269c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5246,7 +5246,7 @@ static void kvm_init_msr_list(void)
 				continue;
 			break;
 		case MSR_TSC_AUX:
-			if (!kvm_x86_ops->rdtscp_supported())
+			if (!kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
 				continue;
 			break;
 		case MSR_IA32_RTIT_CTL:
-- 
2.24.1

