Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72E34CD039
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 09:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234587AbiCDIj4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 03:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234212AbiCDIja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 03:39:30 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2234119DE9A;
        Fri,  4 Mar 2022 00:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646383098; x=1677919098;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=deXF0w/g3GEKCFYlAA26gSaxEU6JgT+SfaAaWeFPzgM=;
  b=Fvnn/mbXZYKfWrFqo8E2d+tgdittAilRJ3WOiPwOKfrLzKlITtaqeGo2
   7PEcbR5Z5IeViT/Yf8YppeaXWN2pCrXingU7wRC2VTrNIfEe0i+GtZdRU
   u+H+Pai3hBZ/eHAWAYHz6r6BRTOIvjboolwJfKsGFEAJLLDDHI0ZKydRY
   I1XK5LmSmFyOeg+kpQpQunMBD6n0xPllh28Gg7aYSNW5pv/IE9qPMGHza
   8Cmm5TSn8sneuB3E+6b8XkYEaXXuMh3i80Uikl/+g+aIWDC9AYomSsGYh
   CHLOJHSUHvGje4e4v1/EtZ6LSmjcoLx2VPz5nnP1+mKbjSMDJ8NbVwMZg
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="233889281"
X-IronPort-AV: E=Sophos;i="5.90,154,1643702400"; 
   d="scan'208";a="233889281"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 00:38:17 -0800
X-IronPort-AV: E=Sophos;i="5.90,154,1643702400"; 
   d="scan'208";a="552141448"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 00:38:11 -0800
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
Subject: [PATCH v7 2/8] KVM: VMX: Extend BUILD_CONTROLS_SHADOW macro to support 64-bit variation
Date:   Fri,  4 Mar 2022 16:07:19 +0800
Message-Id: <20220304080725.18135-3-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220304080725.18135-1-guang.zeng@intel.com>
References: <20220304080725.18135-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

The Tertiary VM-Exec Control, different from previous control fields, is 64
bit. So extend BUILD_CONTROLS_SHADOW() by adding a 'bit' parameter, to
support both 32 bit and 64 bit fields' auxiliary functions building.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/kvm/vmx/vmx.h | 59 ++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 7f2c82e7f38f..e07c76974fb0 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -456,35 +456,38 @@ static inline u8 vmx_get_rvi(void)
 	return vmcs_read16(GUEST_INTR_STATUS) & 0xff;
 }
 
-#define BUILD_CONTROLS_SHADOW(lname, uname)				    \
-static inline void lname##_controls_set(struct vcpu_vmx *vmx, u32 val)	    \
-{									    \
-	if (vmx->loaded_vmcs->controls_shadow.lname != val) {		    \
-		vmcs_write32(uname, val);				    \
-		vmx->loaded_vmcs->controls_shadow.lname = val;		    \
-	}								    \
-}									    \
-static inline u32 __##lname##_controls_get(struct loaded_vmcs *vmcs)	    \
-{									    \
-	return vmcs->controls_shadow.lname;				    \
-}									    \
-static inline u32 lname##_controls_get(struct vcpu_vmx *vmx)		    \
-{									    \
-	return __##lname##_controls_get(vmx->loaded_vmcs);		    \
-}									    \
-static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u32 val)   \
-{									    \
-	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);	    \
-}									    \
-static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u32 val) \
-{									    \
-	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);	    \
+#define BUILD_CONTROLS_SHADOW(lname, uname, bits)			\
+static inline								\
+void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)		\
+{									\
+	if (vmx->loaded_vmcs->controls_shadow.lname != val) {		\
+		vmcs_write##bits(uname, val);				\
+		vmx->loaded_vmcs->controls_shadow.lname = val;		\
+	}								\
+}									\
+static inline u##bits __##lname##_controls_get(struct loaded_vmcs *vmcs)\
+{									\
+	return vmcs->controls_shadow.lname;				\
+}									\
+static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)	\
+{									\
+	return __##lname##_controls_get(vmx->loaded_vmcs);		\
+}									\
+static inline								\
+void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)		\
+{									\
+	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);	\
+}									\
+static inline								\
+void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val)	\
+{									\
+	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);	\
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
 
 /*
  * VMX_REGS_LAZY_LOAD_SET - The set of registers that will be updated in the
-- 
2.27.0

