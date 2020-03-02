Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EACDC17689F
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 00:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbgCBX6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:58:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:25524 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727511AbgCBX5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384755"
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
Subject: [PATCH v2 44/66] KVM: x86: Use KVM cpu caps to track UMIP emulation
Date:   Mon,  2 Mar 2020 15:56:47 -0800
Message-Id: <20200302235709.27467-45-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set UMIP in kvm_cpu_caps when it is emulated by VMX, even though the
bit will effectively be dropped by do_host_cpuid().  This allows
checking for UMIP emulation via kvm_cpu_caps instead of a dedicated
kvm_x86_ops callback.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/svm.c              | 6 ------
 arch/x86/kvm/vmx/vmx.c          | 8 +++++++-
 arch/x86/kvm/x86.c              | 2 +-
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f5b49fa6f066..eecc6afdd9a6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1169,7 +1169,6 @@ struct kvm_x86_ops {
 	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion *exit_fastpath);
 
-	bool (*umip_emulated)(void);
 	bool (*pt_supported)(void);
 
 	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d2516283f7db..964331106e9a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6083,11 +6083,6 @@ static bool svm_rdtscp_supported(void)
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
@@ -7453,7 +7448,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpuid_update = svm_cpuid_update,
 
 	.rdtscp_supported = svm_rdtscp_supported,
-	.umip_emulated = svm_umip_emulated,
 	.pt_supported = svm_pt_supported,
 
 	.set_supported_cpuid = svm_set_supported_cpuid,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a65b977f30d3..be2aecda733b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7128,6 +7128,10 @@ static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
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
@@ -7154,6 +7158,9 @@ static __init void vmx_set_cpu_caps(void)
 	if (enable_ept && boot_cpu_has(X86_FEATURE_OSPKE))
 		kvm_cpu_cap_check_and_set(X86_FEATURE_PKU);
 
+	if (vmx_umip_emulated())
+		kvm_cpu_cap_set(X86_FEATURE_UMIP);
+
 	/* CPUID 0xD.1 */
 	if (!vmx_xsaves_supported())
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
@@ -7958,7 +7965,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
-	.umip_emulated = vmx_umip_emulated,
 	.pt_supported = vmx_pt_supported,
 
 	.request_immediate_exit = vmx_request_immediate_exit,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 400d65125e91..df0c1b387400 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -913,7 +913,7 @@ static u64 kvm_host_cr4_reserved_bits(struct cpuinfo_x86 *c)
 	if (kvm_cpu_cap_has(X86_FEATURE_LA57))
 		reserved_bits &= ~X86_CR4_LA57;
 
-	if (kvm_x86_ops->umip_emulated())
+	if (kvm_cpu_cap_has(X86_FEATURE_UMIP))
 		reserved_bits &= ~X86_CR4_UMIP;
 
 	return reserved_bits;
-- 
2.24.1

