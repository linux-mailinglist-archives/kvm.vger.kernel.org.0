Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7467F45D1CA
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243067AbhKYA0B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:26:01 -0500
Received: from mga12.intel.com ([192.55.52.136]:16272 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352785AbhKYAYh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:37 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="215432256"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="215432256"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:26 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042388"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:25 -0800
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
Subject: [RFC PATCH v3 51/59] KVM: VMX: MOVE GDT and IDT accessors to common code
Date:   Wed, 24 Nov 2021 16:20:34 -0800
Message-Id: <a83e5fb3ef9fbffd3968895bab6f42bf780dbacd.1637799475.git.isaku.yamahata@intel.com>
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
 arch/x86/kvm/vmx/main.c    |  7 +++++--
 arch/x86/kvm/vmx/vmx.c     | 12 ------------
 arch/x86/kvm/vmx/x86_ops.h |  2 --
 3 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index a0a8cc2fd600..4d6bf1f56641 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -3,6 +3,7 @@
 
 #include "x86_ops.h"
 #include "vmx.h"
+#include "common.h"
 #include "nested.h"
 #include "mmu.h"
 #include "pmu.h"
@@ -311,7 +312,8 @@ static int vt_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 
 static void vt_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
-	vmx_get_idt(vcpu, dt);
+	dt->size = vmread32(vcpu, GUEST_IDTR_LIMIT);
+	dt->address = vmreadl(vcpu, GUEST_IDTR_BASE);
 }
 
 static void vt_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
@@ -321,7 +323,8 @@ static void vt_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 
 static void vt_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
-	vmx_get_gdt(vcpu, dt);
+	dt->size = vmread32(vcpu, GUEST_GDTR_LIMIT);
+	dt->address = vmreadl(vcpu, GUEST_GDTR_BASE);
 }
 
 static void vt_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6f98d1b2a498..a644b9627f9d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3227,24 +3227,12 @@ void vmx_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
 	*l = (ar >> 13) & 1;
 }
 
-void vmx_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
-{
-	dt->size = vmcs_read32(GUEST_IDTR_LIMIT);
-	dt->address = vmcs_readl(GUEST_IDTR_BASE);
-}
-
 void vmx_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
 	vmcs_write32(GUEST_IDTR_LIMIT, dt->size);
 	vmcs_writel(GUEST_IDTR_BASE, dt->address);
 }
 
-void vmx_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
-{
-	dt->size = vmcs_read32(GUEST_GDTR_LIMIT);
-	dt->address = vmcs_readl(GUEST_GDTR_BASE);
-}
-
 void vmx_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
 	vmcs_write32(GUEST_GDTR_LIMIT, dt->size);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index c49d6f9f36fd..fec22bef05b7 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -66,9 +66,7 @@ void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 bool vmx_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 int vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer);
-void vmx_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 void vmx_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
-void vmx_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 void vmx_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val);
 void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu);
-- 
2.25.1

