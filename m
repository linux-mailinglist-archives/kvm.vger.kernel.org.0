Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770F62B4F6B
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388471AbgKPS3M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:29:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:48453 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388312AbgKPS2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:20 -0500
IronPort-SDR: wudqxWdr7QCrVtMNB94Lsv2ChEL2GZKRvpWS1fN1GXTYndes6LgpYOZKY5VpscLEoU6cqlYNyp
 MB4f9EayHM0g==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="157819193"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="157819193"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:19 -0800
IronPort-SDR: RfjYix6oNY12ACehnzgokwmrMWxMQV9LWXIvpT7Juoyg0j8kM5jeTkBwA18Q+BNkgLYroELfRX
 5h5vbnJNsPjw==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528329"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:18 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 57/67] KVM: TDX: Stub in tdx.h with structs, accessors, and VMCS helpers
Date:   Mon, 16 Nov 2020 10:26:42 -0800
Message-Id: <b5e3e95fd149c5be20284622fd4d607a4c9a2933.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Stub in kvm_tdx, vcpu_tdx, their various accessors, and VMCS helpers.
The VMCS helpers, which rely on the stubs, will be used by preparatory
patches to move VMX functions for accessing VMCS state to common code.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/tdx.h | 167 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 167 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx.h

diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
new file mode 100644
index 000000000000..b55108a8e484
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -0,0 +1,167 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_TDX_H
+#define __KVM_X86_TDX_H
+
+#include <linux/list.h>
+#include <linux/kvm_host.h>
+
+#include "tdx_arch.h"
+#include "tdx_errno.h"
+#include "tdx_ops.h"
+
+#ifdef CONFIG_KVM_INTEL_TDX
+
+struct tdx_td_page {
+	unsigned long va;
+	hpa_t pa;
+	bool added;
+};
+
+struct kvm_tdx {
+	struct kvm kvm;
+
+	struct tdx_td_page tdr;
+	struct tdx_td_page tdcs[TDX1_NR_TDCX_PAGES];
+};
+
+struct vcpu_tdx {
+	struct kvm_vcpu	vcpu;
+
+	struct tdx_td_page tdvpr;
+	struct tdx_td_page tdvpx[TDX1_NR_TDVPX_PAGES];
+};
+
+static inline bool is_td(struct kvm *kvm)
+{
+	return kvm->arch.vm_type == KVM_X86_TDX_VM;
+}
+
+static inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
+{
+	return is_td(vcpu->kvm);
+}
+
+static inline bool is_debug_td(struct kvm_vcpu *vcpu)
+{
+	return !vcpu->kvm->arch.guest_state_protected;
+}
+
+static inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm)
+{
+	return container_of(kvm, struct kvm_tdx, kvm);
+}
+
+static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
+{
+	return container_of(vcpu, struct vcpu_tdx, vcpu);
+}
+
+static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
+{
+	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && (field) & 0x1,
+			 "Read/Write to TD VMCS *_HIGH fields not supported");
+
+	BUILD_BUG_ON(bits != 16 && bits != 32 && bits != 64);
+
+	BUILD_BUG_ON_MSG(bits != 64 && __builtin_constant_p(field) &&
+			 (((field) & 0x6000) == 0x2000 ||
+			  ((field) & 0x6000) == 0x6000),
+			 "Invalid TD VMCS access for 64-bit field");
+	BUILD_BUG_ON_MSG(bits != 32 && __builtin_constant_p(field) &&
+			 ((field) & 0x6000) == 0x4000,
+			 "Invalid TD VMCS access for 32-bit field");
+	BUILD_BUG_ON_MSG(bits != 16 && __builtin_constant_p(field) &&
+			 ((field) & 0x6000) == 0x0000,
+			 "Invalid TD VMCS access for 16-bit field");
+}
+
+static __always_inline void tdvps_gpr_check(u64 field, u8 bits)
+{
+	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && (field) >= NR_VCPU_REGS,
+			 "Invalid TD guest GPR index");
+}
+
+static __always_inline void tdvps_apic_check(u64 field, u8 bits) {}
+static __always_inline void tdvps_dr_check(u64 field, u8 bits) {}
+static __always_inline void tdvps_state_check(u64 field, u8 bits) {}
+static __always_inline void tdvps_msr_check(u64 field, u8 bits) {}
+static __always_inline void tdvps_management_check(u64 field, u8 bits) {}
+
+#define TDX_BUILD_TDVPS_ACCESSORS(bits, uclass, lclass)			       \
+static __always_inline u##bits td_##lclass##_read##bits(struct vcpu_tdx *tdx,  \
+							u32 field)	       \
+{									       \
+	struct tdx_ex_ret ex_ret;					       \
+	u64 err;							       \
+									       \
+	tdvps_##lclass##_check(field, bits);				       \
+	err = tdrdvps(tdx->tdvpr.pa, TDVPS_##uclass(field), &ex_ret);	       \
+	if (unlikely(err)) {						       \
+		pr_err("TDRDVPS["#uclass".0x%x] failed: 0x%llx\n", field, err);\
+		return 0;						       \
+	}								       \
+	return (u##bits)ex_ret.r8;					       \
+}									       \
+static __always_inline void td_##lclass##_write##bits(struct vcpu_tdx *tdx,    \
+						      u32 field, u##bits val)  \
+{									       \
+	struct tdx_ex_ret ex_ret;					       \
+	u64 err;							       \
+									       \
+	tdvps_##lclass##_check(field, bits);				       \
+	err = tdwrvps(tdx->tdvpr.pa, TDVPS_##uclass(field), val,	       \
+		      GENMASK_ULL(bits - 1, 0), &ex_ret);		       \
+	if (unlikely(err))						       \
+		pr_err("TDWRVPS["#uclass".0x%x] = 0x%llx failed: 0x%llx\n",    \
+		       field, (u64)val, err);				       \
+}									       \
+static __always_inline void td_##lclass##_setbit##bits(struct vcpu_tdx *tdx,   \
+						       u32 field, u64 bit)     \
+{									       \
+	struct tdx_ex_ret ex_ret;					       \
+	u64 err;							       \
+									       \
+	tdvps_##lclass##_check(field, bits);				       \
+	err = tdwrvps(tdx->tdvpr.pa, TDVPS_##uclass(field), bit, bit, &ex_ret);\
+	if (unlikely(err))						       \
+		pr_err("TDWRVPS["#uclass".0x%x] |= 0x%llx failed: 0x%llx\n",   \
+		       field, bit, err);				       \
+}									       \
+static __always_inline void td_##lclass##_clearbit##bits(struct vcpu_tdx *tdx, \
+						         u32 field, u64 bit)   \
+{									       \
+	struct tdx_ex_ret ex_ret;					       \
+	u64 err;							       \
+									       \
+	tdvps_##lclass##_check(field, bits);				       \
+	err = tdwrvps(tdx->tdvpr.pa, TDVPS_##uclass(field), 0, bit, &ex_ret);  \
+	if (unlikely(err))						       \
+		pr_err("TDWRVPS["#uclass".0x%x] &= ~0x%llx failed: 0x%llx\n",  \
+		       field, bit, err);				       \
+}
+
+TDX_BUILD_TDVPS_ACCESSORS(16, VMCS, vmcs);
+TDX_BUILD_TDVPS_ACCESSORS(32, VMCS, vmcs);
+TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
+
+TDX_BUILD_TDVPS_ACCESSORS(64, APIC, apic);
+TDX_BUILD_TDVPS_ACCESSORS(64, GPR, gpr);
+TDX_BUILD_TDVPS_ACCESSORS(64, DR, dr);
+TDX_BUILD_TDVPS_ACCESSORS(64, STATE, state);
+TDX_BUILD_TDVPS_ACCESSORS(64, MSR, msr);
+TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
+
+#else
+
+struct kvm_tdx;
+struct vcpu_tdx;
+
+static inline bool is_td(struct kvm *kvm) { return false; }
+static inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
+static inline bool is_debug_td(struct kvm_vcpu *vcpu) { return false; }
+static inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm) { return NULL; }
+static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu) { return NULL; }
+
+#endif /* CONFIG_KVM_INTEL_TDX */
+
+#endif /* __KVM_X86_TDX_H */
-- 
2.17.1

