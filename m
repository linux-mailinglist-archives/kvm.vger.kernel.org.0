Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA73A14D3E9
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbgA2XsP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:48:15 -0500
Received: from mga06.intel.com ([134.134.136.31]:46690 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbgA2Xqr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:46:47 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 15:46:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="309551727"
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
Subject: [PATCH 12/26] KVM: x86: Drop explicit @func param from ->set_supported_cpuid()
Date:   Wed, 29 Jan 2020 15:46:26 -0800
Message-Id: <20200129234640.8147-13-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129234640.8147-1-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com>
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
index e5de3b9b5e88..39ee83f42935 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1149,7 +1149,7 @@ struct kvm_x86_ops {
 
 	void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 
-	void (*set_supported_cpuid)(u32 func, struct kvm_cpuid_entry2 *entry);
+	void (*set_supported_cpuid)(struct kvm_cpuid_entry2 *entry);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e9e63faf0157..c12cd8218f47 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -789,7 +789,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		break;
 	}
 
-	kvm_x86_ops->set_supported_cpuid(function, entry);
+	kvm_x86_ops->set_supported_cpuid(entry);
 
 	r = 0;
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a773b937e970..199f491a3055 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6052,9 +6052,9 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 
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
index 05cc1c980b27..d21b2eccf3fe 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7134,9 +7134,9 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
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

