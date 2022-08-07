Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E408A58BD12
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbiHGWDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbiHGWCf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:02:35 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63B264F7;
        Sun,  7 Aug 2022 15:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909754; x=1691445754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hCnMuBz/aWLrv0xY1KyhBL7QqdXE6/57a1wmJVcYfBw=;
  b=hWtLSOyhfDSioreGG409bvq1HNxvBBLWbwGSF2UkfdrekCCbnzwnfeij
   AFtNyRLMtug5lU9PzeXoo9y79Giqg62OaYiKi7dsShbs6DBv7WRtiy5wS
   aR/45xMt+/Ph8gGoshWshUAkvI+nBakA4tnU6Lpz4Qrb4UFe5IeTg8Zsi
   MvQtR3wIZ5J+F1oQBSw3ELw/kMIK9K1b41HUx1ht+/AwEYyq4z/S/+1o5
   oWRX0nq2BUgnRsWBvlwq/I4YUfEZPBFxzKvtOrvMk7YpFXTUo3/4fig3S
   hhpFk5UimuhIRIWoBCOMWwBloU4FN4+fs52xQECvpVKPsT0Quq9ny1teQ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224065"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224065"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:30 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682476"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:30 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 013/103] KVM: TDX: Define TDX architectural definitions
Date:   Sun,  7 Aug 2022 15:00:58 -0700
Message-Id: <f6bbcf4fb65a3de2ee7d4b2baa2965e24b0ede90.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Define architectural definitions for KVM to issue the TDX SEAMCALLs.

Structures and values that are architecturally defined in the TDX module
specifications the chapter of ABI Reference.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx_arch.h | 157 ++++++++++++++++++++++++++++++++++++
 1 file changed, 157 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx_arch.h

diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
new file mode 100644
index 000000000000..94258056d742
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -0,0 +1,157 @@
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
+/* @field is the VMCS field encoding */
+#define TDVPS_VMCS(field)		BUILD_TDX_FIELD(0, (field))
+
+enum tdx_guest_other_state {
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
+#define TDVPS_STATE(field)		BUILD_TDX_FIELD(17, (field))
+#define TDVPS_STATE_NON_ARCH(field)	BUILD_TDX_FIELD_NON_ARCH(17, (field))
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
+#define TDX_TD_ATTRIBUTE_PKS		BIT_ULL(30)
+#define TDX_TD_ATTRIBUTE_KL		BIT_ULL(31)
+#define TDX_TD_ATTRIBUTE_PERFMON	BIT_ULL(63)
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
+#endif /* __KVM_X86_TDX_ARCH_H */
-- 
2.25.1

