Return-Path: <kvm+bounces-903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2725C7E4248
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:58:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3CD3EB210AE
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 14:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B659E328B6;
	Tue,  7 Nov 2023 14:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hNOS3BtC"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD95315B8
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:57:50 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4547D6E;
	Tue,  7 Nov 2023 06:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369068; x=1730905068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nh49D6hLNN+JZUAaBtmoiIfZAlLv2YwWhduvNsmP43g=;
  b=hNOS3BtCKK47kMkZOYU2hgS/T2DuTHKpAGCenC5QKy8OAtYZbsPc8h9u
   pf5rHKISGudAEClKuWeN13LxOZ/P0E35bsLJUSbcRqdjpNJwh5kVAlkw3
   ntAOlcUGL8v74K9EoBm9PTSZVOPhyX6VBdk3N70zKkMICzg2++zwVgLVI
   K+KHvVAQ4jl4d/NGXd78YA1t2H2j73vRMbV0E1oYDPy40uRBFPudmZa9L
   WzU729PClJvR30ckc/BhkEw1Z6a4Y/2Wih1wgsNUWiv6Gr6GFo7M4QoIG
   dLnqKtN3MPmNchsw7HNE8BJvJM6y7+FVVB93bDrufm1FR4qjB4qrQ9gy3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="374555700"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="374555700"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:57:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10443970"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:57:44 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v17 009/116] KVM: TDX: Define TDX architectural definitions
Date: Tue,  7 Nov 2023 06:55:35 -0800
Message-Id: <6ad67cabbd5a87e8264d2bb877d4c1e42b3bf56b.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Define architectural definitions for KVM to issue the TDX SEAMCALLs.

Structures and values that are architecturally defined in the TDX module
specifications the chapter of ABI Reference.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx_arch.h | 213 ++++++++++++++++++++++++++++++++++++
 1 file changed, 213 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx_arch.h

diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
new file mode 100644
index 000000000000..845b6ef9f787
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -0,0 +1,213 @@
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
+#define TDH_MEM_PAGE_RELOCATE		5
+#define TDH_MEM_PAGE_AUG		6
+#define TDH_MEM_RANGE_BLOCK		7
+#define TDH_MNG_KEY_CONFIG		8
+#define TDH_MNG_CREATE			9
+#define TDH_VP_CREATE			10
+#define TDH_MNG_RD			11
+#define TDH_MR_EXTEND			16
+#define TDH_MR_FINALIZE			17
+#define TDH_VP_FLUSH			18
+#define TDH_MNG_VPFLUSHDONE		19
+#define TDH_MNG_KEY_FREEID		20
+#define TDH_MNG_INIT			21
+#define TDH_VP_INIT			22
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
+#define TDX_NON_ARCH			BIT_ULL(63)
+#define TDX_CLASS_SHIFT			56
+#define TDX_FIELD_MASK			GENMASK_ULL(31, 0)
+
+#define __BUILD_TDX_FIELD(non_arch, class, field)	\
+	(((non_arch) ? TDX_NON_ARCH : 0) |		\
+	 ((u64)(class) << TDX_CLASS_SHIFT) |		\
+	 ((u64)(field) & TDX_FIELD_MASK))
+
+#define BUILD_TDX_FIELD(class, field)			\
+	__BUILD_TDX_FIELD(false, (class), (field))
+
+#define BUILD_TDX_FIELD_NON_ARCH(class, field)		\
+	__BUILD_TDX_FIELD(true, (class), (field))
+
+
+/* Class code for TD */
+#define TD_CLASS_EXECUTION_CONTROLS	17ULL
+
+/* Class code for TDVPS */
+#define TDVPS_CLASS_VMCS		0ULL
+#define TDVPS_CLASS_GUEST_GPR		16ULL
+#define TDVPS_CLASS_OTHER_GUEST		17ULL
+#define TDVPS_CLASS_MANAGEMENT		32ULL
+
+enum tdx_tdcs_execution_control {
+	TD_TDCS_EXEC_TSC_OFFSET = 10,
+};
+
+/* @field is any of enum tdx_tdcs_execution_control */
+#define TDCS_EXEC(field)		BUILD_TDX_FIELD(TD_CLASS_EXECUTION_CONTROLS, (field))
+
+/* @field is the VMCS field encoding */
+#define TDVPS_VMCS(field)		BUILD_TDX_FIELD(TDVPS_CLASS_VMCS, (field))
+
+enum tdx_vcpu_guest_other_state {
+	TD_VCPU_STATE_DETAILS_NON_ARCH = 0x100,
+};
+
+union tdx_vcpu_state_details {
+	struct {
+		u64 vmxip	: 1;
+		u64 reserved	: 63;
+	};
+	u64 full;
+};
+
+/* @field is any of enum tdx_guest_other_state */
+#define TDVPS_STATE(field)		BUILD_TDX_FIELD(TDVPS_CLASS_OTHER_GUEST, (field))
+#define TDVPS_STATE_NON_ARCH(field)	BUILD_TDX_FIELD_NON_ARCH(TDVPS_CLASS_OTHER_GUEST, (field))
+
+/* Management class fields */
+enum tdx_vcpu_guest_management {
+	TD_VCPU_PEND_NMI = 11,
+};
+
+/* @field is any of enum tdx_vcpu_guest_management */
+#define TDVPS_MANAGEMENT(field)		BUILD_TDX_FIELD(TDVPS_CLASS_MANAGEMENT, (field))
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
+#define TDX_TD_ATTRIBUTE_DEBUG		BIT_ULL(0)
+#define TDX_TD_ATTR_SEPT_VE_DISABLE	BIT_ULL(28)
+#define TDX_TD_ATTRIBUTE_PKS		BIT_ULL(30)
+#define TDX_TD_ATTRIBUTE_KL		BIT_ULL(31)
+#define TDX_TD_ATTRIBUTE_PERFMON	BIT_ULL(63)
+
+/*
+ * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
+ */
+#define TDX_MAX_VCPUS	(~(u16)0)
+
+struct td_params {
+	u64 attributes;
+	u64 xfam;
+	u16 max_vcpus;
+	u8 reserved0[6];
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
+		DECLARE_FLEX_ARRAY(struct tdx_cpuid_value, cpuid_values);
+		u8 reserved3[768];
+	};
+} __packed __aligned(1024);
+
+/*
+ * Guest uses MAX_PA for GPAW when set.
+ * 0: GPA.SHARED bit is GPA[47]
+ * 1: GPA.SHARED bit is GPA[51]
+ */
+#define TDX_EXEC_CONTROL_MAX_GPAW      BIT_ULL(0)
+
+/*
+ * TDX requires the frequency to be defined in units of 25MHz, which is the
+ * frequency of the core crystal clock on TDX-capable platforms, i.e. the TDX
+ * module can only program frequencies that are multiples of 25MHz.  The
+ * frequency must be between 100mhz and 10ghz (inclusive).
+ */
+#define TDX_TSC_KHZ_TO_25MHZ(tsc_in_khz)	((tsc_in_khz) / (25 * 1000))
+#define TDX_TSC_25MHZ_TO_KHZ(tsc_in_25mhz)	((tsc_in_25mhz) * (25 * 1000))
+#define TDX_MIN_TSC_FREQUENCY_KHZ		(100 * 1000)
+#define TDX_MAX_TSC_FREQUENCY_KHZ		(10 * 1000 * 1000)
+
+union tdx_sept_entry {
+	struct {
+		u64 r		:  1;
+		u64 w		:  1;
+		u64 x		:  1;
+		u64 mt		:  3;
+		u64 ipat	:  1;
+		u64 leaf	:  1;
+		u64 a		:  1;
+		u64 d		:  1;
+		u64 xu		:  1;
+		u64 ignored0	:  1;
+		u64 pfn		: 40;
+		u64 reserved	:  5;
+		u64 vgp		:  1;
+		u64 pwa		:  1;
+		u64 ignored1	:  1;
+		u64 sss		:  1;
+		u64 spp		:  1;
+		u64 ignored2	:  1;
+		u64 sve		:  1;
+	};
+	u64 raw;
+};
+
+enum tdx_sept_entry_state {
+	TDX_SEPT_FREE = 0,
+	TDX_SEPT_BLOCKED = 1,
+	TDX_SEPT_PENDING = 2,
+	TDX_SEPT_PENDING_BLOCKED = 3,
+	TDX_SEPT_PRESENT = 4,
+};
+
+union tdx_sept_level_state {
+	struct {
+		u64 level	:  3;
+		u64 reserved0	:  5;
+		u64 state	:  8;
+		u64 reserved1	: 48;
+	};
+	u64 raw;
+};
+
+#endif /* __KVM_X86_TDX_ARCH_H */
-- 
2.25.1


