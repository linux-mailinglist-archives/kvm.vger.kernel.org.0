Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BCC45D1CC
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345058AbhKYA0D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:26:03 -0500
Received: from mga12.intel.com ([192.55.52.136]:16273 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352733AbhKYAYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:36 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="215432254"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="215432254"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:25 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042383"
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
Subject: [RFC PATCH v3 50/59] KVM: VMX: Move AR_BYTES encoder/decoder helpers to common.h
Date:   Wed, 24 Nov 2021 16:20:33 -0800
Message-Id: <e71be4cab99b8ce962755afc60e089699b3a5e59.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Move the AR_BYTES helpers to common.h so that future patches can reuse
them to decode/encode AR for TDX.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/common.h | 41 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c    | 47 ++++-----------------------------------
 2 files changed, 45 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index d37ef4dd9d90..e45d2d222168 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -4,6 +4,7 @@
 
 #include <linux/kvm_host.h>
 
+#include <asm/kvm.h>
 #include <asm/traps.h>
 #include <asm/vmx.h>
 
@@ -119,4 +120,44 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
 
+static inline u32 vmx_encode_ar_bytes(struct kvm_segment *var)
+{
+	u32 ar;
+
+	if (var->unusable || !var->present)
+		ar = 1 << 16;
+	else {
+		ar = var->type & 15;
+		ar |= (var->s & 1) << 4;
+		ar |= (var->dpl & 3) << 5;
+		ar |= (var->present & 1) << 7;
+		ar |= (var->avl & 1) << 12;
+		ar |= (var->l & 1) << 13;
+		ar |= (var->db & 1) << 14;
+		ar |= (var->g & 1) << 15;
+	}
+
+	return ar;
+}
+
+static inline void vmx_decode_ar_bytes(u32 ar, struct kvm_segment *var)
+{
+	var->unusable = (ar >> 16) & 1;
+	var->type = ar & 15;
+	var->s = (ar >> 4) & 1;
+	var->dpl = (ar >> 5) & 3;
+	/*
+	 * Some userspaces do not preserve unusable property. Since usable
+	 * segment has to be present according to VMX spec we can use present
+	 * property to amend userspace bug by making unusable segment always
+	 * nonpresent. vmx_encode_ar_bytes() already marks nonpresent
+	 * segment as unusable.
+	 */
+	var->present = !var->unusable;
+	var->avl = (ar >> 12) & 1;
+	var->l = (ar >> 13) & 1;
+	var->db = (ar >> 14) & 1;
+	var->g = (ar >> 15) & 1;
+}
+
 #endif /* __KVM_X86_VMX_COMMON_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 98710b578b28..6f98d1b2a498 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -365,8 +365,6 @@ static const struct kernel_param_ops vmentry_l1d_flush_ops = {
 };
 module_param_cb(vmentry_l1d_flush, &vmentry_l1d_flush_ops, NULL, 0644);
 
-static u32 vmx_segment_access_rights(struct kvm_segment *var);
-
 void vmx_vmexit(void);
 
 #define vmx_insn_failed(fmt...)		\
@@ -2730,7 +2728,7 @@ static void fix_rmode_seg(int seg, struct kvm_segment *save)
 	vmcs_write16(sf->selector, var.selector);
 	vmcs_writel(sf->base, var.base);
 	vmcs_write32(sf->limit, var.limit);
-	vmcs_write32(sf->ar_bytes, vmx_segment_access_rights(&var));
+	vmcs_write32(sf->ar_bytes, vmx_encode_ar_bytes(&var));
 }
 
 static void enter_rmode(struct kvm_vcpu *vcpu)
@@ -3138,7 +3136,6 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 ar;
 
 	if (vmx->rmode.vm86_active && seg != VCPU_SREG_LDTR) {
 		*var = vmx->rmode.segs[seg];
@@ -3152,23 +3149,7 @@ void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 	var->base = vmx_read_guest_seg_base(vmx, seg);
 	var->limit = vmx_read_guest_seg_limit(vmx, seg);
 	var->selector = vmx_read_guest_seg_selector(vmx, seg);
-	ar = vmx_read_guest_seg_ar(vmx, seg);
-	var->unusable = (ar >> 16) & 1;
-	var->type = ar & 15;
-	var->s = (ar >> 4) & 1;
-	var->dpl = (ar >> 5) & 3;
-	/*
-	 * Some userspaces do not preserve unusable property. Since usable
-	 * segment has to be present according to VMX spec we can use present
-	 * property to amend userspace bug by making unusable segment always
-	 * nonpresent. vmx_segment_access_rights() already marks nonpresent
-	 * segment as unusable.
-	 */
-	var->present = !var->unusable;
-	var->avl = (ar >> 12) & 1;
-	var->l = (ar >> 13) & 1;
-	var->db = (ar >> 14) & 1;
-	var->g = (ar >> 15) & 1;
+	vmx_decode_ar_bytes(vmx_read_guest_seg_ar(vmx, seg), var);
 }
 
 u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
@@ -3194,26 +3175,6 @@ int vmx_get_cpl(struct kvm_vcpu *vcpu)
 	}
 }
 
-static u32 vmx_segment_access_rights(struct kvm_segment *var)
-{
-	u32 ar;
-
-	if (var->unusable || !var->present)
-		ar = 1 << 16;
-	else {
-		ar = var->type & 15;
-		ar |= (var->s & 1) << 4;
-		ar |= (var->dpl & 3) << 5;
-		ar |= (var->present & 1) << 7;
-		ar |= (var->avl & 1) << 12;
-		ar |= (var->l & 1) << 13;
-		ar |= (var->db & 1) << 14;
-		ar |= (var->g & 1) << 15;
-	}
-
-	return ar;
-}
-
 void __vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -3248,7 +3209,7 @@ void __vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 	if (is_unrestricted_guest(vcpu) && (seg != VCPU_SREG_LDTR))
 		var->type |= 0x1; /* Accessed */
 
-	vmcs_write32(sf->ar_bytes, vmx_segment_access_rights(var));
+	vmcs_write32(sf->ar_bytes, vmx_encode_ar_bytes(var));
 }
 
 void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
@@ -3299,7 +3260,7 @@ static bool rmode_segment_valid(struct kvm_vcpu *vcpu, int seg)
 	var.dpl = 0x3;
 	if (seg == VCPU_SREG_CS)
 		var.type = 0x3;
-	ar = vmx_segment_access_rights(&var);
+	ar = vmx_encode_ar_bytes(&var);
 
 	if (var.base != (var.selector << 4))
 		return false;
-- 
2.25.1

