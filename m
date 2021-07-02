Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C4E3BA55C
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbhGBWH4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:07:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:51166 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232986AbhGBWHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:07:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="195951884"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="195951884"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:20 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814683"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:19 -0700
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Chao Gao <chao.gao@intel.com>
Subject: [RFC PATCH v2 05/69] KVM: TDX: Add architectural definitions for structures and values
Date:   Fri,  2 Jul 2021 15:04:11 -0700
Message-Id: <d29b2ac2090f20e8de96888742feb413f597f1dc.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add structures and values that are architecturally defined in
[1] chapter 18 ABI Reference: Data Types and in [1] 20.2.1 SEAMCALL
Instruction(Common) Table 20.4 SEAMCALL Instruction Leaf Numbers
Definition.

[1] TDX Module Spec
https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-guest-hypervisor-communication-interface.pdf

Co-developed-by: Kai Huang <kai.huang@linux.intel.com>
Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx_arch.h | 307 ++++++++++++++++++++++++++++++++++++
 1 file changed, 307 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx_arch.h

diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
new file mode 100644
index 000000000000..57e9ea4a7fad
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -0,0 +1,307 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_TDX_ARCH_H
+#define __KVM_X86_TDX_ARCH_H
+
+#include <linux/types.h>
+
+/*
+ * TDX SEAMCALL API function leaves
+ */
+#define SEAMCALL_TDH_VP_ENTER			0
+#define SEAMCALL_TDH_MNG_ADDCX			1
+#define SEAMCALL_TDH_MEM_PAGE_ADD		2
+#define SEAMCALL_TDH_MEM_SEPT_ADD		3
+#define SEAMCALL_TDH_VP_ADDCX			4
+#define SEAMCALL_TDH_MEM_PAGE_AUG		6
+#define SEAMCALL_TDH_MEM_RANGE_BLOCK		7
+#define SEAMCALL_TDH_MNG_KEY_CONFIG		8
+#define SEAMCALL_TDH_MNG_CREATE			9
+#define SEAMCALL_TDH_VP_CREATE			10
+#define SEAMCALL_TDH_MNG_RD			11
+#define SEAMCALL_TDH_PHYMEM_PAGE_RD		12
+#define SEAMCALL_TDH_MNG_WR			13
+#define SEAMCALL_TDH_PHYMEM_PAGE_WR		14
+#define SEAMCALL_TDH_MEM_PAGE_DEMOTE		15
+#define SEAMCALL_TDH_MR_EXTEND			16
+#define SEAMCALL_TDH_MR_FINALIZE		17
+#define SEAMCALL_TDH_VP_FLUSH			18
+#define SEAMCALL_TDH_MNG_VPFLUSHDONE		19
+#define SEAMCALL_TDH_MNG_KEY_FREEID		20
+#define SEAMCALL_TDH_MNG_INIT			21
+#define SEAMCALL_TDH_VP_INIT			22
+#define SEAMCALL_TDH_MEM_PAGE_PROMOTE		23
+#define SEAMCALL_TDH_PHYMEM_PAGE_RDMD		24
+#define SEAMCALL_TDH_MEM_SEPT_RD		25
+#define SEAMCALL_TDH_VP_RD			26
+#define SEAMCALL_TDH_MNG_KEY_RECLAIMID		27
+#define SEAMCALL_TDH_PHYMEM_PAGE_RECLAIM	28
+#define SEAMCALL_TDH_MEM_PAGE_REMOVE		29
+#define SEAMCALL_TDH_MEM_SEPT_REMOVE		30
+#define SEAMCALL_TDH_SYS_KEY_CONFIG		31
+#define SEAMCALL_TDH_SYS_INFO			32
+#define SEAMCALL_TDH_SYS_INIT			33
+#define SEAMCALL_TDH_SYS_LP_INIT		35
+#define SEAMCALL_TDH_SYS_TDMR_INIT		36
+#define SEAMCALL_TDH_MEM_TRACK			38
+#define SEAMCALL_TDH_MEM_RANGE_UNBLOCK		39
+#define SEAMCALL_TDH_PHYMEM_CACHE_WB		40
+#define SEAMCALL_TDH_PHYMEM_PAGE_WBINVD		41
+#define SEAMCALL_TDH_MEM_SEPT_WR		42
+#define SEAMCALL_TDH_VP_WR			43
+#define SEAMCALL_TDH_SYS_LP_SHUTDOWN		44
+#define SEAMCALL_TDH_SYS_CONFIG			45
+
+#define TDG_VP_VMCALL_GET_TD_VM_CALL_INFO		0x10000
+#define TDG_VP_VMCALL_MAP_GPA				0x10001
+#define TDG_VP_VMCALL_GET_QUOTE				0x10002
+#define TDG_VP_VMCALL_REPORT_FATAL_ERROR		0x10003
+#define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT	0x10004
+
+/* TDX control structure (TDR/TDCS/TDVPS) field access codes */
+#define TDX_CLASS_SHIFT		56
+#define TDX_FIELD_MASK		GENMASK_ULL(31, 0)
+
+#define BUILD_TDX_FIELD(class, field)	\
+	(((u64)(class) << TDX_CLASS_SHIFT) | ((u64)(field) & TDX_FIELD_MASK))
+
+/* @field is the VMCS field encoding */
+#define TDVPS_VMCS(field)	BUILD_TDX_FIELD(0, (field))
+
+/*
+ * @offset is the offset (in bytes) from the beginning of the architectural
+ * virtual APIC page.
+ */
+#define TDVPS_APIC(offset)	BUILD_TDX_FIELD(1, (offset))
+
+/* @gpr is the index of a general purpose register, e.g. eax=0 */
+#define TDVPS_GPR(gpr)		BUILD_TDX_FIELD(16, (gpr))
+
+#define TDVPS_DR(dr)		BUILD_TDX_FIELD(17, (0 + (dr)))
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
+#define TDVPS_STATE(field)	BUILD_TDX_FIELD(17, (field))
+
+/* @msr is the MSR index */
+#define TDVPS_MSR(msr)		BUILD_TDX_FIELD(19, (msr))
+
+/* Management class fields */
+enum tdx_guest_management {
+	TD_VCPU_PEND_NMI = 11,
+};
+
+/* @field is any of enum tdx_guest_management */
+#define TDVPS_MANAGEMENT(field)	BUILD_TDX_FIELD(32, (field))
+
+#define TDX1_NR_TDCX_PAGES		4
+#define TDX1_NR_TDVPX_PAGES		5
+
+#define TDX1_MAX_NR_CPUID_CONFIGS	6
+#define TDX1_MAX_NR_CMRS		32
+#define TDX1_MAX_NR_TDMRS		64
+#define TDX1_MAX_NR_RSVD_AREAS		16
+#define TDX1_PAMT_ENTRY_SIZE		16
+#define TDX1_EXTENDMR_CHUNKSIZE		256
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
+struct tdx_cpuid_value {
+	u32 eax;
+	u32 ebx;
+	u32 ecx;
+	u32 edx;
+} __packed;
+
+#define TDX1_TD_ATTRIBUTE_DEBUG		BIT_ULL(0)
+#define TDX1_TD_ATTRIBUTE_PKS		BIT_ULL(30)
+#define TDX1_TD_ATTRIBUTE_KL		BIT_ULL(31)
+#define TDX1_TD_ATTRIBUTE_PERFMON	BIT_ULL(63)
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
+#define TDX1_EXEC_CONTROL_MAX_GPAW      BIT_ULL(0)
+
+/*
+ * TDX1 requires the frequency to be defined in units of 25MHz, which is the
+ * frequency of the core crystal clock on TDX-capable platforms, i.e. TDX-SEAM
+ * can only program frequencies that are multiples of 25MHz.  The frequency
+ * must be between 1ghz and 10ghz (inclusive).
+ */
+#define TDX1_TSC_KHZ_TO_25MHZ(tsc_in_khz)	((tsc_in_khz) / (25 * 1000))
+#define TDX1_TSC_25MHZ_TO_KHZ(tsc_in_25mhz)	((tsc_in_25mhz) * (25 * 1000))
+#define TDX1_MIN_TSC_FREQUENCY_KHZ		(100 * 1000)
+#define TDX1_MAX_TSC_FREQUENCY_KHZ		(10 * 1000 * 1000)
+
+struct tdmr_reserved_area {
+	u64 offset;
+	u64 size;
+} __packed;
+
+#define TDX_TDMR_ADDR_ALIGNMENT	512
+#define TDX_TDMR_INFO_ALIGNMENT	512
+struct tdmr_info {
+	u64 base;
+	u64 size;
+	u64 pamt_1g_base;
+	u64 pamt_1g_size;
+	u64 pamt_2m_base;
+	u64 pamt_2m_size;
+	u64 pamt_4k_base;
+	u64 pamt_4k_size;
+	struct tdmr_reserved_area reserved_areas[TDX1_MAX_NR_RSVD_AREAS];
+} __packed __aligned(TDX_TDMR_INFO_ALIGNMENT);
+
+#define TDX_CMR_INFO_ARRAY_ALIGNMENT	512
+struct cmr_info {
+	u64 base;
+	u64 size;
+} __packed;
+
+#define TDX_TDSYSINFO_STRUCT_ALIGNEMNT	1024
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
+} __packed __aligned(TDX_TDSYSINFO_STRUCT_ALIGNEMNT);
+
+struct tdx_ex_ret {
+	union {
+		/* Used to retrieve values from hardware. */
+		struct {
+			u64 rcx;
+			u64 rdx;
+			u64 r8;
+			u64 r9;
+			u64 r10;
+			u64 r11;
+		};
+		/* Functions that walk SEPT */
+		struct {
+			u64 septe;
+			struct {
+				u64 level		:3;
+				u64 sept_reserved_0	:5;
+				u64 state		:8;
+				u64 sept_reserved_1	:48;
+			};
+		};
+		/* TD_MNG_{RD,WR} return the TDR, field code, and value. */
+		struct {
+			u64 tdr;
+			u64 field;
+			u64 field_val;
+		};
+		/* TD_MNG_{RD,WR}MEM return the address and its value. */
+		struct {
+			u64 addr;
+			u64 val;
+		};
+		/* TDH_PHYMEM_PAGE_RDMD and TDH_PHYMEM_PAGE_RECLAIM return page metadata. */
+		struct {
+			u64 page_type;
+			u64 owner;
+			u64 page_size;
+		};
+		/*
+		 * TDH_SYS_INFO returns the buffer address and its size, and the
+		 * CMR_INFO address and its number of entries.
+		 */
+		struct {
+			u64 buffer;
+			u64 nr_bytes;
+			u64 cmr_info;
+			u64 nr_cmr_entries;
+		};
+		/*
+		 * TDH_MNG_INIT and TDH_SYS_INIT return CPUID info on error.  Note, only
+		 * the leaf and subleaf are valid on TDH_MNG_INIT error.
+		 */
+		struct {
+			u32 leaf;
+			u32 subleaf;
+			u32 eax_mask;
+			u32 ebx_mask;
+			u32 ecx_mask;
+			u32 edx_mask;
+			u32 eax_val;
+			u32 ebx_val;
+			u32 ecx_val;
+			u32 edx_val;
+		};
+		/* TDH_SYS_TDMR_INIT returns the input PA and next PA. */
+		struct {
+			u64 prev;
+			u64 next;
+		};
+	};
+};
+
+#endif /* __KVM_X86_TDX_ARCH_H */
-- 
2.25.1

