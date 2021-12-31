Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1B1482476
	for <lists+kvm@lfdr.de>; Fri, 31 Dec 2021 15:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhLaO7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Dec 2021 09:59:05 -0500
Received: from mga18.intel.com ([134.134.136.126]:29026 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhLaO7D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Dec 2021 09:59:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640962743; x=1672498743;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=OVSz8IsiD1AyzuC6JkviSS4vl4sM3klnHE+FMiHvbOo=;
  b=WnNkvYqa7wR3PxQj/SI8/YeG196h8Hh2MfDLjPJtqRioN6k7VBObzl8e
   1q7N6TFZ1qUT8PBbduYzAR3DEycTA207S3Owj6bwcWW/KfCuTXEQJtaAQ
   PAQtX0BJgsuY5zhAKIttL+hlbwqTS8yGKDQlOtN5hlIBvylbI+eVg01xb
   3c+Ps2bEhK0u99C+boHP2ndYjOT5olFbdkFZeyM7YLtMsWuS7fcf+wsrS
   h69Pg6L8NbvcKjMMcpL0sULm13hlRgOmM7H54WFbMmjd/Uu42pJYQXD69
   hKl4Fo0qNt4Fd+ZLwhthPdJG0x9Xp90J3pg/LyFa7TXBH3UuAd5i2tmKx
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10213"; a="228641845"
X-IronPort-AV: E=Sophos;i="5.88,251,1635231600"; 
   d="scan'208";a="228641845"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2021 06:59:03 -0800
X-IronPort-AV: E=Sophos;i="5.88,251,1635231600"; 
   d="scan'208";a="524758418"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2021 06:58:57 -0800
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
Subject: [PATCH v5 2/8] KVM: VMX: Extend BUILD_CONTROLS_SHADOW macro to support 64-bit variation
Date:   Fri, 31 Dec 2021 22:28:43 +0800
Message-Id: <20211231142849.611-3-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211231142849.611-1-guang.zeng@intel.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

The Tertiary VM-Exec Control, different from previous control fields, is 64
bit. So extend BUILD_CONTROLS_SHADOW() by adding a 'bit' parameter, to
support both 32 bit and 64 bit fields' auxiliary functions building.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/kvm/vmx/vmx.h | 59 ++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 4df2ac24ffc1..07e1753225bf 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -443,35 +443,38 @@ static inline u8 vmx_get_rvi(void)
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
 
 static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
 {
-- 
2.27.0

