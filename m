Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D694396F6A
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 10:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbhFAIuK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 04:50:10 -0400
Received: from mga07.intel.com ([134.134.136.100]:45129 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233848AbhFAIt5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 04:49:57 -0400
IronPort-SDR: G6AyyxSgF3qS/qwSjf1aBSVX+SwnzWfNV7nizSajaoRwrmtFIFU8teUdLd0+cOzB12YT0HbrJp
 vOUJZIRSndWg==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="267381344"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="267381344"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 01:48:12 -0700
IronPort-SDR: Jn5COYwlkes7pkXWBE9cgprqyUGeO6ucrN5Hxp6vjaTalHC/Ge5cjiucrJf23XXOBYCkpeGbGo
 +qYcsFIrZ2iA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="437967783"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga007.jf.intel.com with ESMTP; 01 Jun 2021 01:48:09 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, robert.hu@intel.com,
        robert.hu@linux.intel.com
Subject: [PATCH 05/15] kvm/vmx: Extend BUILD_CONTROLS_SHADOW macro to support 64-bit variation
Date:   Tue,  1 Jun 2021 16:47:44 +0800
Message-Id: <1622537274-146420-6-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
References: <1622537274-146420-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Tertiary VM-Exec Control, different from previous control fields, is 64
bit. So extend BUILD_CONTROLS_SHADOW() by adding a 'bit' parameter, to
support both 32 bit and 64 bit fields' auxiliary functions building.
Also, define the auxiliary functions for Tertiary control field here, using
the new BUILD_CONTROLS_SHADOW().

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/vmx/vmx.h | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 008cb87..e0ade10 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -412,31 +412,32 @@ static inline u8 vmx_get_rvi(void)
 	return vmcs_read16(GUEST_INTR_STATUS) & 0xff;
 }
 
-#define BUILD_CONTROLS_SHADOW(lname, uname)				    \
-static inline void lname##_controls_set(struct vcpu_vmx *vmx, u32 val)	    \
+#define BUILD_CONTROLS_SHADOW(lname, uname, bits)				    \
+static inline void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)	    \
 {									    \
 	if (vmx->loaded_vmcs->controls_shadow.lname != val) {		    \
-		vmcs_write32(uname, val);				    \
+		vmcs_write##bits(uname, val);				    \
 		vmx->loaded_vmcs->controls_shadow.lname = val;		    \
 	}								    \
 }									    \
-static inline u32 lname##_controls_get(struct vcpu_vmx *vmx)		    \
+static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)		    \
 {									    \
 	return vmx->loaded_vmcs->controls_shadow.lname;			    \
 }									    \
-static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u32 val)   \
+static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)   \
 {									    \
 	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);	    \
 }									    \
-static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u32 val) \
+static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val) \
 {									    \
 	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);	    \
 }
-BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS)
-BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS)
-BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL)
-BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL)
-BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL)
+BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS, 32)
+BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS, 32)
+BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL, 32)
+BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL, 32)
+BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL, 32)
+BUILD_CONTROLS_SHADOW(tertiary_exec, TERTIARY_VM_EXEC_CONTROL, 64)
 
 static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
 {
-- 
1.8.3.1

