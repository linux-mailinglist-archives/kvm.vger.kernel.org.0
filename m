Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC3514D3D6
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgA2XrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:47:13 -0500
Received: from mga06.intel.com ([134.134.136.31]:46690 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727218AbgA2Xqu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:46:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 15:46:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="309551759"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 29 Jan 2020 15:46:44 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 22/26] KVM: x86: Handle XSAVES CPUID adjustment in VMX code
Date:   Wed, 29 Jan 2020 15:46:36 -0800
Message-Id: <20200129234640.8147-23-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129234640.8147-1-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the clearing of the XSAVES CPUID bit into VMX, which has a separate
VMCS control to enable XSAVES in non-root, to to eliminate an instance of
the undesirable "unsigned f_* = *_supported ? F(*) : 0" pattern in the
common CPUID handling code.  Add a call to ->set_supported_cpuid() in
the leaf 0xD handling so that vendor code can update feature bits in the
index=1 sub-leaf (which contains the XSAVES bit) and teach
{svm,vmx}_set_supported_cpuid() how to handle non-zero indices.

Drop ->xsaves_supported() since CPUID adjustment was the only user.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/cpuid.c            | 6 ++++--
 arch/x86/kvm/svm.c              | 9 +++------
 arch/x86/kvm/vmx/vmx.c          | 9 ++++++++-
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3cd11257257c..ea076debe6f8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1163,7 +1163,6 @@ struct kvm_x86_ops {
 	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion *exit_fastpath);
 
-	bool (*xsaves_supported)(void);
 	bool (*umip_emulated)(void);
 	bool (*pt_supported)(void);
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ce7f6dfcf832..75971c254b4d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -410,7 +410,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	unsigned f_gbpages = 0;
 	unsigned f_lm = 0;
 #endif
-	unsigned f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;
 	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
 
 	/* cpuid 1.edx */
@@ -467,7 +466,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 
 	/* cpuid 0xD.1.eax */
 	const u32 kvm_cpuid_D_1_eax_x86_features =
-		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | f_xsaves;
+		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES);
 
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();
@@ -629,6 +628,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 				entry[i].eax &= kvm_cpuid_D_1_eax_x86_features;
 				cpuid_mask(&entry[i].eax, CPUID_D_1_EAX);
 				entry[i].ebx = 0;
+
+				kvm_x86_ops->set_supported_cpuid(&entry[i]);
+
 				if (entry[i].eax & (F(XSAVES)|F(XSAVEC)))
 					entry[i].ebx =
 						xstate_required_size(supported,
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2adc3a474b80..7d6f46399e5a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6054,6 +6054,9 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 
 static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 {
+	if (entry->index)
+		return;
+
 	switch (entry->function) {
 	case 0x1:
 		if (avic)
@@ -6096,11 +6099,6 @@ static int svm_get_lpage_level(void)
 	return PT_PDPE_LEVEL;
 }
 
-static bool svm_xsaves_supported(void)
-{
-	return boot_cpu_has(X86_FEATURE_XSAVES);
-}
-
 static bool svm_umip_emulated(void)
 {
 	return false;
@@ -7471,7 +7469,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.cpuid_update = svm_cpuid_update,
 
-	.xsaves_supported = svm_xsaves_supported,
 	.umip_emulated = svm_umip_emulated,
 	.pt_supported = svm_pt_supported,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f244b2356847..941ac7296735 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7131,6 +7131,14 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 
 static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 {
+	if (entry->index) {
+		if (WARN_ON_ONCE(entry->function != 0xd || entry->index != 1))
+			return;
+		if (!vmx_xsaves_supported())
+			cpuid_entry_clear(entry, X86_FEATURE_XSAVES);
+		return;
+	}
+
 	switch (entry->function) {
 	case 0x1:
 		if (nested)
@@ -7899,7 +7907,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
-	.xsaves_supported = vmx_xsaves_supported,
 	.umip_emulated = vmx_umip_emulated,
 	.pt_supported = vmx_pt_supported,
 
-- 
2.24.1

