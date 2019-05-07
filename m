Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F1D16B1A
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 21:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfEGTSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 15:18:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:55702 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726503AbfEGTSJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 15:18:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 12:18:06 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 07 May 2019 12:18:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [PATCH 02/13] KVM: VMX: Add builder macros for shadowing controls
Date:   Tue,  7 May 2019 12:17:54 -0700
Message-Id: <20190507191805.9932-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507191805.9932-1-sean.j.christopherson@intel.com>
References: <20190507191805.9932-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

... to pave the way for shadowing all (five) major VMCS control fields
without massive amounts of error prone copy+paste+modify.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.h | 102 +++++++++++++++--------------------------
 1 file changed, 37 insertions(+), 65 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 181acd906c75..bdc0df871be9 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -85,6 +85,11 @@ struct pt_desc {
 	struct pt_ctx guest;
 };
 
+struct vmx_controls_shadow {
+	u32 vm_entry;
+	u32 vm_exit;
+};
+
 /*
  * The nested_vmx structure is part of vcpu_vmx, and holds information we need
  * for correct emulation of VMX (i.e., nested VMX) on this vcpu.
@@ -183,6 +188,9 @@ struct vcpu_vmx {
 	u32                   exit_intr_info;
 	u32                   idt_vectoring_info;
 	ulong                 rflags;
+
+	struct vmx_controls_shadow	controls_shadow;
+
 	struct shared_msr_entry *guest_msrs;
 	int                   nmsrs;
 	int                   save_nmsrs;
@@ -195,8 +203,6 @@ struct vcpu_vmx {
 
 	u64		      spec_ctrl;
 
-	u32 vm_entry_controls_shadow;
-	u32 vm_exit_controls_shadow;
 	u32 secondary_exec_control;
 
 	/*
@@ -375,69 +381,35 @@ static inline u8 vmx_get_rvi(void)
 	return vmcs_read16(GUEST_INTR_STATUS) & 0xff;
 }
 
-static inline void vm_entry_controls_reset_shadow(struct vcpu_vmx *vmx)
-{
-	vmx->vm_entry_controls_shadow = vmcs_read32(VM_ENTRY_CONTROLS);
-}
-
-static inline void vm_entry_controls_init(struct vcpu_vmx *vmx, u32 val)
-{
-	vmcs_write32(VM_ENTRY_CONTROLS, val);
-	vmx->vm_entry_controls_shadow = val;
-}
-
-static inline void vm_entry_controls_set(struct vcpu_vmx *vmx, u32 val)
-{
-	if (vmx->vm_entry_controls_shadow != val)
-		vm_entry_controls_init(vmx, val);
-}
-
-static inline u32 vm_entry_controls_get(struct vcpu_vmx *vmx)
-{
-	return vmx->vm_entry_controls_shadow;
-}
-
-static inline void vm_entry_controls_setbit(struct vcpu_vmx *vmx, u32 val)
-{
-	vm_entry_controls_set(vmx, vm_entry_controls_get(vmx) | val);
-}
-
-static inline void vm_entry_controls_clearbit(struct vcpu_vmx *vmx, u32 val)
-{
-	vm_entry_controls_set(vmx, vm_entry_controls_get(vmx) & ~val);
-}
-
-static inline void vm_exit_controls_reset_shadow(struct vcpu_vmx *vmx)
-{
-	vmx->vm_exit_controls_shadow = vmcs_read32(VM_EXIT_CONTROLS);
-}
-
-static inline void vm_exit_controls_init(struct vcpu_vmx *vmx, u32 val)
-{
-	vmcs_write32(VM_EXIT_CONTROLS, val);
-	vmx->vm_exit_controls_shadow = val;
-}
-
-static inline void vm_exit_controls_set(struct vcpu_vmx *vmx, u32 val)
-{
-	if (vmx->vm_exit_controls_shadow != val)
-		vm_exit_controls_init(vmx, val);
-}
-
-static inline u32 vm_exit_controls_get(struct vcpu_vmx *vmx)
-{
-	return vmx->vm_exit_controls_shadow;
-}
-
-static inline void vm_exit_controls_setbit(struct vcpu_vmx *vmx, u32 val)
-{
-	vm_exit_controls_set(vmx, vm_exit_controls_get(vmx) | val);
-}
-
-static inline void vm_exit_controls_clearbit(struct vcpu_vmx *vmx, u32 val)
-{
-	vm_exit_controls_set(vmx, vm_exit_controls_get(vmx) & ~val);
-}
+#define BUILD_CONTROLS_SHADOW(lname, uname)				    \
+static inline void lname##_controls_reset_shadow(struct vcpu_vmx *vmx)	    \
+{									    \
+	vmx->controls_shadow.lname = vmcs_read32(uname);		    \
+}									    \
+static inline void lname##_controls_init(struct vcpu_vmx *vmx, u32 val)	    \
+{									    \
+	vmcs_write32(uname, val);					    \
+	vmx->controls_shadow.lname = val;				    \
+}									    \
+static inline void lname##_controls_set(struct vcpu_vmx *vmx, u32 val)	    \
+{									    \
+	if (vmx->controls_shadow.lname != val)				    \
+		lname##_controls_init(vmx, val);			    \
+}									    \
+static inline u32 lname##_controls_get(struct vcpu_vmx *vmx)		    \
+{									    \
+	return vmx->controls_shadow.lname;				    \
+}									    \
+static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u32 val)   \
+{									    \
+	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);	    \
+}									    \
+static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u32 val) \
+{									    \
+	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);	    \
+}
+BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS)
+BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS)
 
 static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 {
-- 
2.21.0

