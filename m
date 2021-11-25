Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1B445D190
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352739AbhKYAYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:24:16 -0500
Received: from mga18.intel.com ([134.134.136.126]:32610 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347567AbhKYAYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:11 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="222281264"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="222281264"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:00 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042080"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:20:59 -0800
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
        Kai Huang <kai.huang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v3 03/59] KVM: TDX: Define TDX architectural definitions
Date:   Wed, 24 Nov 2021 16:19:46 -0800
Message-Id: <5c4d620cee6b8179d9c14dfc3f83490e6f81f726.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Define architectural definitions for KVM to issue TDX SEAMCALLs.

Structures and values that are architecturally defined in the TDX module
specifications the chapter of ABI Reference

Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx_arch.h | 219 ++++++++++++++++++++++++++++++++++++
 1 file changed, 219 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx_arch.h

diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
new file mode 100644
index 000000000000..f57f9bfb7007
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -0,0 +1,219 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* architectural constants/data definitions for TDX SEAMCALLs */
+
+#ifndef __KVM_X86_TDX_ARCH_H
+#define __KVM_X86_TDX_ARCH_H
+
+#include <linux/types.h>
+
+/*
+ * TDX SEAMCALL API function leaves
+ */
+#define TDH_VP_ENTER			0
+#define TDH_MNG_ADDCX			1
+#define TDH_MEM_PAGE_ADD		2
+#define TDH_MEM_SEPT_ADD		3
+#define TDH_VP_ADDCX			4
+#define TDH_MEM_PAGE_AUG		6
+#define TDH_MEM_RANGE_BLOCK		7
+#define TDH_MNG_KEY_CONFIG		8
+#define TDH_MNG_CREATE			9
+#define TDH_VP_CREATE			10
+#define TDH_MNG_RD			11
+#define TDH_MEM_RD			12
+#define TDH_MNG_WR			13
+#define TDH_MEM_WR			14
+#define TDH_MEM_PAGE_DEMOTE		15
+#define TDH_MR_EXTEND			16
+#define TDH_MR_FINALIZE			17
+#define TDH_VP_FLUSH			18
+#define TDH_MNG_VPFLUSHDONE		19
+#define TDH_MNG_KEY_FREEID		20
+#define TDH_MNG_INIT			21
+#define TDH_VP_INIT			22
+#define TDH_MEM_PAGE_PROMOTE		23
+#define TDH_PHYMEM_PAGE_RDMD		24
+#define TDH_MEM_SEPT_RD			25
+#define TDH_VP_RD			26
+#define TDH_MNG_KEY_RECLAIMID		27
+#define TDH_PHYMEM_PAGE_RECLAIM		28
+#define TDH_MEM_PAGE_REMOVE		29
+#define TDH_MEM_SEPT_REMOVE		30
+#define TDH_MEM_TRACK			38
+#define TDH_MEM_RANGE_UNBLOCK		39
+#define TDH_PHYMEM_CACHE_WB		40
+#define TDH_PHYMEM_PAGE_WBINVD		41
+#define TDH_MEM_SEPT_WR			42
+#define TDH_VP_WR			43
+#define TDH_SYS_LP_SHUTDOWN		44
+
+#define TDG_VP_VMCALL_GET_TD_VM_CALL_INFO		0x10000
+#define TDG_VP_VMCALL_MAP_GPA				0x10001
+#define TDG_VP_VMCALL_GET_QUOTE				0x10002
+#define TDG_VP_VMCALL_REPORT_FATAL_ERROR		0x10003
+#define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT	0x10004
+
+/* TDX control structure (TDR/TDCS/TDVPS) field access codes */
+#define TDX_CLASS_SHIFT			56
+#define TDX_FIELD_MASK			GENMASK_ULL(31, 0)
+
+#define BUILD_TDX_FIELD(class, field)	\
+	(((u64)(class) << TDX_CLASS_SHIFT) | ((u64)(field) & TDX_FIELD_MASK))
+
+/* @field is the VMCS field encoding */
+#define TDVPS_VMCS(field)		BUILD_TDX_FIELD(0, (field))
+
+/*
+ * @offset is the offset (in bytes) from the beginning of the architectural
+ * virtual APIC page.
+ */
+#define TDVPS_APIC(offset)		BUILD_TDX_FIELD(1, (offset))
+
+/* @gpr is the index of a general purpose register, e.g. eax=0 */
+#define TDVPS_GPR(gpr)			BUILD_TDX_FIELD(16, (gpr))
+
+#define TDVPS_DR(dr)			BUILD_TDX_FIELD(17, (0 + (dr)))
+
+enum tdx_guest_other_state {
+	TD_VCPU_XCR0 = 32,
+	TD_VCPU_IWK_ENCKEY0 = 64,
+	TD_VCPU_IWK_ENCKEY1,
+	TD_VCPU_IWK_ENCKEY2,
+	TD_VCPU_IWK_ENCKEY3,
+	TD_VCPU_IWK_INTKEY0 = 68,
+	TD_VCPU_IWK_INTKEY1,
+	TD_VCPU_IWK_FLAGS = 70,
+};
+
+/* @field is any of enum tdx_guest_other_state */
+#define TDVPS_STATE(field)		BUILD_TDX_FIELD(17, (field))
+
+/* @msr is the MSR index */
+#define TDVPS_MSR(msr)			BUILD_TDX_FIELD(19, (msr))
+
+/* Management class fields */
+enum tdx_guest_management {
+	TD_VCPU_PEND_NMI = 11,
+};
+
+/* @field is any of enum tdx_guest_management */
+#define TDVPS_MANAGEMENT(field)		BUILD_TDX_FIELD(32, (field))
+
+enum tdx_tdcs_execution_control {
+	TD_TDCS_EXEC_TSC_OFFSET = 10,
+};
+
+/* @field is any of enum tdx_tdcs_execution_control */
+#define TDCS_EXEC(field)		BUILD_TDX_FIELD(17, (field))
+
+/*
+ * Hard code those values for simplicity and efficiency.  They are constant for
+ * the TDX 1.0.  TDH.SYS.INIT enumerates those values.  On kvm initialization,
+ * do sanity checks so that they are correct values.
+ *
+ * TODO: If they are bumped in future, increase those value.
+ *       (or make them full runtime values)
+ */
+#define TDX_NR_TDCX_PAGES		4
+#define TDX_NR_TDVPX_PAGES		5
+#define TDX_MAX_NR_CPUID_CONFIGS	6
+
+#define TDX_EXTENDMR_CHUNKSIZE		256
+
+struct tdx_cpuid_value {
+	u32 eax;
+	u32 ebx;
+	u32 ecx;
+	u32 edx;
+} __packed;
+
+struct tdx_cpuid_config {
+	u32 leaf;
+	u32 sub_leaf;
+	u32 eax;
+	u32 ebx;
+	u32 ecx;
+	u32 edx;
+} __packed;
+
+struct tdsysinfo_struct {
+	/* TDX-SEAM Module Info */
+	u32 attributes;
+	u32 vendor_id;
+	u32 build_date;
+	u16 build_num;
+	u16 minor_version;
+	u16 major_version;
+	u8 reserved0[14];
+	/* Memory Info */
+	u16 max_tdmrs;
+	u16 max_reserved_per_tdmr;
+	u16 pamt_entry_size;
+	u8 reserved1[10];
+	/* Control Struct Info */
+	u16 tdcs_base_size;
+	u8 reserved2[2];
+	u16 tdvps_base_size;
+	u8 tdvps_xfam_dependent_size;
+	u8 reserved3[9];
+	/* TD Capabilities */
+	u64 attributes_fixed0;
+	u64 attributes_fixed1;
+	u64 xfam_fixed0;
+	u64 xfam_fixed1;
+	u8 reserved4[32];
+	u32 num_cpuid_config;
+	union {
+		struct tdx_cpuid_config cpuid_configs[0];
+		u8 reserved5[892];
+	};
+} __packed __aligned(1024);
+
+#define TDX_TD_ATTRIBUTE_DEBUG		BIT_ULL(0)
+#define TDX_TD_ATTRIBUTE_PKS		BIT_ULL(30)
+#define TDX_TD_ATTRIBUTE_KL		BIT_ULL(31)
+#define TDX_TD_ATTRIBUTE_PERFMON	BIT_ULL(63)
+
+#define TDX_TD_XFAM_LBR			BIT_ULL(15)
+#define TDX_TD_XFAM_AMX			(BIT_ULL(17) | BIT_ULL(18))
+
+/*
+ * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
+ */
+struct td_params {
+	u64 attributes;
+	u64 xfam;
+	u32 max_vcpus;
+	u32 reserved0;
+
+	u64 eptp_controls;
+	u64 exec_controls;
+	u16 tsc_frequency;
+	u8  reserved1[38];
+
+	u64 mrconfigid[6];
+	u64 mrowner[6];
+	u64 mrownerconfig[6];
+	u64 reserved2[4];
+
+	union {
+		struct tdx_cpuid_value cpuid_values[0];
+		u8 reserved3[768];
+	};
+} __packed __aligned(1024);
+
+/* Guest uses MAX_PA for GPAW when set. */
+#define TDX_EXEC_CONTROL_MAX_GPAW      BIT_ULL(0)
+
+/*
+ * TDX requires the frequency to be defined in units of 25MHz, which is the
+ * frequency of the core crystal clock on TDX-capable platforms, i.e. TDX-SEAM
+ * can only program frequencies that are multiples of 25MHz.  The frequency
+ * must be between 1ghz and 10ghz (inclusive).
+ */
+#define TDX_TSC_KHZ_TO_25MHZ(tsc_in_khz)	((tsc_in_khz) / (25 * 1000))
+#define TDX_TSC_25MHZ_TO_KHZ(tsc_in_25mhz)	((tsc_in_25mhz) * (25 * 1000))
+#define TDX_MIN_TSC_FREQUENCY_KHZ		(100 * 1000)
+#define TDX_MAX_TSC_FREQUENCY_KHZ		(10 * 1000 * 1000)
+
+#endif /* __KVM_X86_TDX_ARCH_H */
-- 
2.25.1

