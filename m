Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A5916B16
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 21:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfEGTSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 15:18:08 -0400
Received: from mga06.intel.com ([134.134.136.31]:55700 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbfEGTSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 15:18:07 -0400
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
Subject: [PATCH 06/13] KVM: nVMX: Shadow VMCS controls on a per-VMCS basis
Date:   Tue,  7 May 2019 12:17:58 -0700
Message-Id: <20190507191805.9932-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507191805.9932-1-sean.j.christopherson@intel.com>
References: <20190507191805.9932-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

... to pave the way for not preserving the shadow copies across switches
between vmcs01 and vmcs02, and eventually to avoid VMWRITEs to vmcs02
when the desired value is unchanged across nested VM-Enters.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmcs.h |  9 +++++++++
 arch/x86/kvm/vmx/vmx.h  | 22 +++++++---------------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index cb6079f8a227..c09ae69155a8 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -42,6 +42,14 @@ struct vmcs_host_state {
 #endif
 };
 
+struct vmcs_controls_shadow {
+	u32 vm_entry;
+	u32 vm_exit;
+	u32 pin;
+	u32 exec;
+	u32 sec_exec;
+};
+
 /*
  * Track a VMCS that may be loaded on a certain CPU. If it is (cpu!=-1), also
  * remember whether it was VMLAUNCHed, and maintain a linked list of all VMCSs
@@ -61,6 +69,7 @@ struct loaded_vmcs {
 	unsigned long *msr_bitmap;
 	struct list_head loaded_vmcss_on_cpu_link;
 	struct vmcs_host_state host_state;
+	struct vmcs_controls_shadow controls_shadow;
 };
 
 static inline bool is_exception_n(u32 intr_info, u8 vector)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 7655ed28f12c..2c367011df98 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -85,14 +85,6 @@ struct pt_desc {
 	struct pt_ctx guest;
 };
 
-struct vmx_controls_shadow {
-	u32 vm_entry;
-	u32 vm_exit;
-	u32 pin;
-	u32 exec;
-	u32 sec_exec;
-};
-
 /*
  * The nested_vmx structure is part of vcpu_vmx, and holds information we need
  * for correct emulation of VMX (i.e., nested VMX) on this vcpu.
@@ -192,8 +184,6 @@ struct vcpu_vmx {
 	u32                   idt_vectoring_info;
 	ulong                 rflags;
 
-	struct vmx_controls_shadow	controls_shadow;
-
 	struct shared_msr_entry *guest_msrs;
 	int                   nmsrs;
 	int                   save_nmsrs;
@@ -387,21 +377,23 @@ static inline u8 vmx_get_rvi(void)
 #define BUILD_CONTROLS_SHADOW(lname, uname)				    \
 static inline void lname##_controls_reset_shadow(struct vcpu_vmx *vmx)	    \
 {									    \
-	vmx->controls_shadow.lname = vmcs_read32(uname);		    \
+	vmx->loaded_vmcs->controls_shadow.lname = vmcs_read32(uname);	    \
 }									    \
 static inline void lname##_controls_init(struct vcpu_vmx *vmx, u32 val)	    \
 {									    \
 	vmcs_write32(uname, val);					    \
-	vmx->controls_shadow.lname = val;				    \
+	vmx->loaded_vmcs->controls_shadow.lname = val;			    \
 }									    \
 static inline void lname##_controls_set(struct vcpu_vmx *vmx, u32 val)	    \
 {									    \
-	if (vmx->controls_shadow.lname != val)				    \
-		lname##_controls_init(vmx, val);			    \
+	if (vmx->loaded_vmcs->controls_shadow.lname != val) {		    \
+		vmcs_write32(uname, val);				    \
+		vmx->loaded_vmcs->controls_shadow.lname = val;		    \
+	}								    \
 }									    \
 static inline u32 lname##_controls_get(struct vcpu_vmx *vmx)		    \
 {									    \
-	return vmx->controls_shadow.lname;				    \
+	return vmx->loaded_vmcs->controls_shadow.lname;			    \
 }									    \
 static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u32 val)   \
 {									    \
-- 
2.21.0

