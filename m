Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2115445D1C7
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346650AbhKYAZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:25:49 -0500
Received: from mga12.intel.com ([192.55.52.136]:16273 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352851AbhKYAYh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:37 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="215432261"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="215432261"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:26 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042394"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:26 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v3 52/59] KVM: VMX: Move .get_interrupt_shadow() implementation to common VMX code
Date:   Wed, 24 Nov 2021 16:20:35 -0800
Message-Id: <fc5fec456f87e8f815813e65f85055fe38e44d10.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/common.h | 14 ++++++++++++++
 arch/x86/kvm/vmx/vmx.c    | 10 +---------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index e45d2d222168..684cd3add46b 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -120,6 +120,20 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
 
+static inline u32 __vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu)
+{
+	u32 interruptibility;
+	int ret = 0;
+
+	interruptibility = vmread32(vcpu, GUEST_INTERRUPTIBILITY_INFO);
+	if (interruptibility & GUEST_INTR_STATE_STI)
+		ret |= KVM_X86_SHADOW_INT_STI;
+	if (interruptibility & GUEST_INTR_STATE_MOV_SS)
+		ret |= KVM_X86_SHADOW_INT_MOV_SS;
+
+	return ret;
+}
+
 static inline u32 vmx_encode_ar_bytes(struct kvm_segment *var)
 {
 	u32 ar;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a644b9627f9d..6f38e0d2e1b6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1365,15 +1365,7 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 
 u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu)
 {
-	u32 interruptibility = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
-	int ret = 0;
-
-	if (interruptibility & GUEST_INTR_STATE_STI)
-		ret |= KVM_X86_SHADOW_INT_STI;
-	if (interruptibility & GUEST_INTR_STATE_MOV_SS)
-		ret |= KVM_X86_SHADOW_INT_MOV_SS;
-
-	return ret;
+	return __vmx_get_interrupt_shadow(vcpu);
 }
 
 void vmx_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
-- 
2.25.1

