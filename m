Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 086941768E9
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgCCABA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 19:01:00 -0500
Received: from mga03.intel.com ([134.134.136.65]:17173 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727388AbgCBX51 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:27 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384786"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:23 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 54/66] KVM: x86: Use KVM cpu caps to detect MSR_TSC_AUX virt support
Date:   Mon,  2 Mar 2020 15:56:57 -0800
Message-Id: <20200302235709.27467-55-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
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

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/svm.c              | 6 ------
 arch/x86/kvm/vmx/vmx.c          | 3 ---
 arch/x86/kvm/x86.c              | 2 +-
 4 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index eecc6afdd9a6..25d9a0d45cc6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1149,7 +1149,6 @@ struct kvm_x86_ops {
 	int (*get_tdp_level)(struct kvm_vcpu *vcpu);
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 	int (*get_lpage_level)(void);
-	bool (*rdtscp_supported)(void);
 
 	void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d351007eb7f9..692b8ffdbad3 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6070,11 +6070,6 @@ static int svm_get_lpage_level(void)
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
@@ -7439,7 +7434,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.cpuid_update = svm_cpuid_update,
 
-	.rdtscp_supported = svm_rdtscp_supported,
 	.pt_supported = svm_pt_supported,
 
 	.set_supported_cpuid = svm_set_supported_cpuid,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d5a5e8f987c8..f168da6f9b89 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7935,9 +7935,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.get_lpage_level = vmx_get_lpage_level,
 
 	.cpuid_update = vmx_cpuid_update,
-
-	.rdtscp_supported = vmx_rdtscp_supported,
-
 	.set_supported_cpuid = vmx_set_supported_cpuid,
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index df0c1b387400..e2c3f1b69e25 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5200,7 +5200,7 @@ static void kvm_init_msr_list(void)
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

