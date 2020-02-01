Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E89D14F9B1
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbgBASwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:52:31 -0500
Received: from mga05.intel.com ([192.55.52.43]:37520 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727100AbgBASw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075562"
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
Subject: [PATCH 44/61] KVM: x86: Use KVM cpu caps to track UMIP emulation
Date:   Sat,  1 Feb 2020 10:52:01 -0800
Message-Id: <20200201185218.24473-45-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set UMIP in kvm_cpu_caps when it is emulated by VMX, even though the
bit will be effectively be dropped by do_host_cpuid().  This allows
checking for UMIP emulation via kvm_cpu_caps instead of a dedicated
kvm_x86_ops callback.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/svm.c              | 6 ------
 arch/x86/kvm/vmx/vmx.c          | 8 +++++++-
 arch/x86/kvm/x86.c              | 2 +-
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dd690fb5ceca..113b138a0347 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1163,7 +1163,6 @@ struct kvm_x86_ops {
 	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion *exit_fastpath);
 
-	bool (*umip_emulated)(void);
 	bool (*pt_supported)(void);
 
 	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index defb2c0dbf8a..e1ed5726964c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6079,11 +6079,6 @@ static bool svm_rdtscp_supported(void)
 	return boot_cpu_has(X86_FEATURE_RDTSCP);
 }
 
-static bool svm_umip_emulated(void)
-{
-	return false;
-}
-
 static bool svm_pt_supported(void)
 {
 	return false;
@@ -7449,7 +7444,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpuid_update = svm_cpuid_update,
 
 	.rdtscp_supported = svm_rdtscp_supported,
-	.umip_emulated = svm_umip_emulated,
 	.pt_supported = svm_pt_supported,
 
 	.set_supported_cpuid = svm_set_supported_cpuid,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cecf59225136..cd5a624610c9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7103,6 +7103,10 @@ static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 {
 	switch (entry->function) {
 	case 0x7:
+		/*
+		 * UMIP needs to be manually set even though vmx_set_cpu_caps()
+		 * also sets UMIP since do_host_cpuid() will drop it.
+		 */
 		if (vmx_umip_emulated())
 			cpuid_entry_set(entry, X86_FEATURE_UMIP);
 		break;
@@ -7129,6 +7133,9 @@ static __init void vmx_set_cpu_caps(void)
 	if (enable_ept && boot_cpu_has(X86_FEATURE_OSPKE))
 		kvm_cpu_cap_check_and_set(X86_FEATURE_PKU);
 
+	if (vmx_umip_emulated())
+		kvm_cpu_cap_set(X86_FEATURE_UMIP);
+
 	/* CPUID 0xD.1 */
 	if (!vmx_xsaves_supported())
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
@@ -7888,7 +7895,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
-	.umip_emulated = vmx_umip_emulated,
 	.pt_supported = vmx_pt_supported,
 
 	.request_immediate_exit = vmx_request_immediate_exit,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cb40737187a1..a6d5f22c7ef6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -915,7 +915,7 @@ static u64 kvm_host_cr4_reserved_bits(struct cpuinfo_x86 *c)
 	if (kvm_cpu_cap_has(X86_FEATURE_LA57))
 		reserved_bits &= ~X86_CR4_LA57;
 
-	if (kvm_x86_ops->umip_emulated())
+	if (kvm_cpu_cap_has(X86_FEATURE_UMIP))
 		reserved_bits &= ~X86_CR4_UMIP;
 
 	return reserved_bits;
-- 
2.24.1

