Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148313BA5AF
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbhGBWJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:09:20 -0400
Received: from mga17.intel.com ([192.55.52.151]:15306 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233986AbhGBWIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:08:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="189168412"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="189168412"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:31 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814890"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:31 -0700
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
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 63/69] KVM: VMX: Move .get_interrupt_shadow() implementation to common VMX code
Date:   Fri,  2 Jul 2021 15:05:09 -0700
Message-Id: <11a3389da6184785b238b0d5a7f60279aa0a93b1.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
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
index 755aaec85199..817ff3e74933 100644
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
index d69d4dc7c071..d31cace67907 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1467,15 +1467,7 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 
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

