Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89505507288
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 18:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354434AbiDSQH6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 12:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354393AbiDSQHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 12:07:53 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1A017A8A;
        Tue, 19 Apr 2022 09:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650384306; x=1681920306;
  h=from:to:cc:subject:date:message-id;
  bh=wTaXARG76bTc7Xk8fzK/DUZQvwtaVFIYOuxxY4pKMbc=;
  b=J+d6qLmYx+tgG0jjdDIHFVYedZIDSFDbnRv8ilsm2NJikbICvT7sSH23
   5iJsdAvFCcvTsoLSME33MdyuJbj/S+1pPsK8hN9cOHaDs3hNTc+W/HUUF
   T8Fj5TT4p4W+Bb7QM5xUXcKeboR7f0I/ayNvDcbOFDAIqPnccWRREqvYn
   RdYnYH0wDzsn73AzWo6fCekjgl1ql6LCPyjZebL5eKEMjhy6cRoOx9cwH
   KWKaPNwvuSJBjtVMY/ixlc7JlCzBfGf7JKbyaTfY5dd6zDFlM5H7al1Y7
   xLJUAh7LeBhOk1fgP4wFo3OhuQyC2wZPLszui+rutXB1BrgwILbon+2OR
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="245694441"
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="245694441"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:05:05 -0700
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="529369855"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:04:59 -0700
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
Subject: [PATCH v9 2/9] KVM: VMX: Extend BUILD_CONTROLS_SHADOW macro to support 64-bit variation
Date:   Tue, 19 Apr 2022 23:33:18 +0800
Message-Id: <20220419153318.11595-1-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/kvm/vmx/vmx.h | 56 +++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9c6bfcd84008..122fdbf85a02 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -455,35 +455,35 @@ static inline u8 vmx_get_rvi(void)
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
+#define BUILD_CONTROLS_SHADOW(lname, uname, bits)				\
+static inline void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)	\
+{										\
+	if (vmx->loaded_vmcs->controls_shadow.lname != val) {			\
+		vmcs_write##bits(uname, val);					\
+		vmx->loaded_vmcs->controls_shadow.lname = val;			\
+	}									\
+}										\
+static inline u##bits __##lname##_controls_get(struct loaded_vmcs *vmcs)	\
+{										\
+	return vmcs->controls_shadow.lname;					\
+}										\
+static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)		\
+{										\
+	return __##lname##_controls_get(vmx->loaded_vmcs);			\
+}										\
+static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)	\
+{										\
+	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);		\
+}										\
+static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val)	\
+{										\
+	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);		\
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

