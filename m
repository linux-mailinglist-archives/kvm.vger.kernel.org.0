Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F6D3D3431
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 07:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbhGWFAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 01:00:47 -0400
Received: from mga17.intel.com ([192.55.52.151]:23861 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233812AbhGWFAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jul 2021 01:00:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10053"; a="192086807"
X-IronPort-AV: E=Sophos;i="5.84,263,1620716400"; 
   d="scan'208";a="192086807"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2021 22:41:20 -0700
X-IronPort-AV: E=Sophos;i="5.84,263,1620716400"; 
   d="scan'208";a="502383479"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.1])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2021 22:41:15 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v2 2/6] KVM: VMX: Extend BUILD_CONTROLS_SHADOW macro to support 64-bit variation
Date:   Fri, 23 Jul 2021 13:16:22 +0800
Message-Id: <20210723051626.18364-3-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210723051626.18364-1-guang.zeng@intel.com>
References: <20210723051626.18364-1-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

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
index 3979a947933a..945c6639ce24 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -413,31 +413,32 @@ static inline u8 vmx_get_rvi(void)
 	return vmcs_read16(GUEST_INTR_STATUS) & 0xff;
 }
 
-#define BUILD_CONTROLS_SHADOW(lname, uname)				    \
-static inline void lname##_controls_set(struct vcpu_vmx *vmx, u32 val)	    \
+#define BUILD_CONTROLS_SHADOW(lname, uname, bits)			    \
+static inline void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val) \
 {									    \
 	if (vmx->loaded_vmcs->controls_shadow.lname != val) {		    \
-		vmcs_write32(uname, val);				    \
+		vmcs_write##bits(uname, val);				    \
 		vmx->loaded_vmcs->controls_shadow.lname = val;		    \
 	}								    \
 }									    \
-static inline u32 lname##_controls_get(struct vcpu_vmx *vmx)		    \
+static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)	    \
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
2.25.1

