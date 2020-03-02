Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2E8E1768AD
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 00:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbgCBX53 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:57:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:25521 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727447AbgCBX52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384695"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 24/66] KVM: x86: Drop explicit @func param from ->set_supported_cpuid()
Date:   Mon,  2 Mar 2020 15:56:27 -0800
Message-Id: <20200302235709.27467-25-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the explicit @func param from ->set_supported_cpuid() and instead
pull the CPUID function from the relevant entry.  This sets the stage
for hardening guest CPUID updates in future patches, e.g. allows adding
run-time assertions that the CPUID feature being changed is actually
a bit in the referenced CPUID entry.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/cpuid.c            | 2 +-
 arch/x86/kvm/svm.c              | 4 ++--
 arch/x86/kvm/vmx/vmx.c          | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9a4ae6ef0d7a..b0bd6bd3838a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1154,7 +1154,7 @@ struct kvm_x86_ops {
 
 	void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 
-	void (*set_supported_cpuid)(u32 func, struct kvm_cpuid_entry2 *entry);
+	void (*set_supported_cpuid)(struct kvm_cpuid_entry2 *entry);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c194e49622b9..ffcf647b8fb4 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -784,7 +784,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	}
 
-	kvm_x86_ops->set_supported_cpuid(function, entry);
+	kvm_x86_ops->set_supported_cpuid(entry);
 
 	r = 0;
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 16c4b7eb6312..0d7bdbb94643 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6029,9 +6029,9 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 
 #define F feature_bit
 
-static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
+static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 {
-	switch (func) {
+	switch (entry->function) {
 	case 0x1:
 		if (avic)
 			entry->ecx &= ~F(X2APIC);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 17dc4dc2a7f9..44724e8d0b88 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7124,9 +7124,9 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void vmx_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
+static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 {
-	if (func == 1 && nested)
+	if (entry->function == 1 && nested)
 		entry->ecx |= feature_bit(VMX);
 }
 
-- 
2.24.1

