Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181832B4F66
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388448AbgKPS25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:28:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:48453 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388325AbgKPS2V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:21 -0500
IronPort-SDR: KvZU+V2usUvHeCkxcHIB3Vx7Von7iGxSIfbCTVrNk9Xh7Ne0Rlox4tWoF7aERCfLeXfDIUbeId
 SY1T4idZOFlg==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="157819210"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="157819210"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:21 -0800
IronPort-SDR: NikdYxL7VqlcIQ45AmL/S77+dt/pBzwYeGgoOlDCgtLmJb+8VgH7n52VsMTjrL0WxDMMpfD3SJ
 kK7BuhX/jg/A==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528372"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:21 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 61/67] KVM: VMX: Move .get_interrupt_shadow() implementation to common VMX code
Date:   Mon, 16 Nov 2020 10:26:46 -0800
Message-Id: <e02bda4c41445a8ba9adde7d49ee62587334ef08.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/common.h | 14 ++++++++++++++
 arch/x86/kvm/vmx/vmx.c    | 10 +---------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index ad106364c51f..8519423bfd88 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -122,6 +122,20 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
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
index 93b319eacdfa..9c15df71700d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1461,15 +1461,7 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 
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
2.17.1

