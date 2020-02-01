Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C74114F9D9
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727538AbgBASzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:55:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:11283 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727165AbgBASwa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075501"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2020 10:52:25 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 24/61] KVM: x86: Drop explicit @func param from ->set_supported_cpuid()
Date:   Sat,  1 Feb 2020 10:51:41 -0800
Message-Id: <20200201185218.24473-25-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
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

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/cpuid.c            | 2 +-
 arch/x86/kvm/svm.c              | 4 ++--
 arch/x86/kvm/vmx/vmx.c          | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 85f0d96cfeb2..a61928d5435b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1148,7 +1148,7 @@ struct kvm_x86_ops {
 
 	void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 
-	void (*set_supported_cpuid)(u32 func, struct kvm_cpuid_entry2 *entry);
+	void (*set_supported_cpuid)(struct kvm_cpuid_entry2 *entry);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 056faf27b14b..e3026fe638aa 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -784,7 +784,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	}
 
-	kvm_x86_ops->set_supported_cpuid(function, entry);
+	kvm_x86_ops->set_supported_cpuid(entry);
 
 	r = 0;
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3c7ddaff405d..535eb746fb0f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6032,9 +6032,9 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 
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
index 98fd651f7f7e..3ff830e2258e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7104,9 +7104,9 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
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

