Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B723BA5A3
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhGBWJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:09:08 -0400
Received: from mga17.intel.com ([192.55.52.151]:15277 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233843AbhGBWIi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:08:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="189168406"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="189168406"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:31 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814883"
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
Subject: [RFC PATCH v2 61/69] KVM: VMX: Move AR_BYTES encoder/decoder helpers to common.h
Date:   Fri,  2 Jul 2021 15:05:07 -0700
Message-Id: <847069aafe640a360007a4c531930e34945e6417.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
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
index aa6a569b87d1..755aaec85199 100644
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
index 3c3bfc80d2bb..40843ca2fb33 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -365,8 +365,6 @@ static const struct kernel_param_ops vmentry_l1d_flush_ops = {
 };
 module_param_cb(vmentry_l1d_flush, &vmentry_l1d_flush_ops, NULL, 0644);
 
-static u32 vmx_segment_access_rights(struct kvm_segment *var);
-
 void vmx_vmexit(void);
 
 #define vmx_insn_failed(fmt...)		\
@@ -2826,7 +2824,7 @@ static void fix_rmode_seg(int seg, struct kvm_segment *save)
 	vmcs_write16(sf->selector, var.selector);
 	vmcs_writel(sf->base, var.base);
 	vmcs_write32(sf->limit, var.limit);
-	vmcs_write32(sf->ar_bytes, vmx_segment_access_rights(&var));
+	vmcs_write32(sf->ar_bytes, vmx_encode_ar_bytes(&var));
 }
 
 static void enter_rmode(struct kvm_vcpu *vcpu)
@@ -3217,7 +3215,6 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u32 ar;
 
 	if (vmx->rmode.vm86_active && seg != VCPU_SREG_LDTR) {
 		*var = vmx->rmode.segs[seg];
@@ -3231,23 +3228,7 @@ void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
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
 
 static u64 vmx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
@@ -3273,26 +3254,6 @@ int vmx_get_cpl(struct kvm_vcpu *vcpu)
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
 void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -3327,7 +3288,7 @@ void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 	if (is_unrestricted_guest(vcpu) && (seg != VCPU_SREG_LDTR))
 		var->type |= 0x1; /* Accessed */
 
-	vmcs_write32(sf->ar_bytes, vmx_segment_access_rights(var));
+	vmcs_write32(sf->ar_bytes, vmx_encode_ar_bytes(var));
 
 out:
 	vmx->emulation_required = emulation_required(vcpu);
@@ -3374,7 +3335,7 @@ static bool rmode_segment_valid(struct kvm_vcpu *vcpu, int seg)
 	var.dpl = 0x3;
 	if (seg == VCPU_SREG_CS)
 		var.type = 0x3;
-	ar = vmx_segment_access_rights(&var);
+	ar = vmx_encode_ar_bytes(&var);
 
 	if (var.base != (var.selector << 4))
 		return false;
-- 
2.25.1

