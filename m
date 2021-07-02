Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C2A3BA594
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhGBWHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:07:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:51168 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231792AbhGBWHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:07:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="195951883"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="195951883"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:19 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814679"
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
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v2 04/69] KVM: TDX: Add TDX "architectural" error codes
Date:   Fri,  2 Jul 2021 15:04:10 -0700
Message-Id: <0140779ee76feb8433aeb3b01c691278420bc856.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add TDX completion status codes for SEAMCALL and TDG_VP_VMCALL.

TDX-SEAM uses bits 31:0 to return more information, so these error codes
for SEAMCALL will only exactly match RAX[63:32]. [1] Section 17.1 Interface
Function Completion Status Codes
Completion status codes for TDG.VP.VMCALL is defined in
[2] Chapter 3 TDG.VP.VMCALL Interface.

[1] Intel TDX Module Spec
https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-module-1eas-v0.85.039.pdf

[2] TDX Guest-Host Communication interface for Intel Trust Domain Extensions
https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-guest-hypervisor-communication-interface.pdf

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx_errno.h | 106 +++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx_errno.h

diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
new file mode 100644
index 000000000000..675acea412c9
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -0,0 +1,106 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_TDX_ERRNO_H
+#define __KVM_X86_TDX_ERRNO_H
+
+/*
+ * TDX SEAMCALL Status Codes (returned in RAX)
+ */
+#define TDX_SUCCESS				0x0000000000000000
+#define TDX_NON_RECOVERABLE_VCPU		0x4000000100000000
+#define TDX_NON_RECOVERABLE_TD			0x4000000200000000
+#define TDX_INTERRUPTED_RESUMABLE		0x8000000300000000
+#define TDX_INTERRUPTED_RESTARTABLE		0x8000000400000000
+#define TDX_NON_RECOVERABLE_TD_FATAL		0x4000000500000000
+#define TDX_INVALID_RESUMPTION			0xC000000600000000
+#define TDX_NON_RECOVERABLE_TD_NO_APIC		0xC000000700000000
+#define TDX_OPERAND_INVALID			0xC000010000000000
+#define TDX_OPERAND_ADDR_RANGE_ERROR		0xC000010100000000
+#define TDX_OPERAND_BUSY			0x8000020000000000
+#define TDX_PREVIOUS_TLB_EPOCH_BUSY		0x8000020100000000
+#define TDX_SYS_BUSY				0x8000020200000000
+#define TDX_PAGE_METADATA_INCORRECT		0xC000030000000000
+#define TDX_PAGE_ALREADY_FREE			0x0000030100000000
+#define TDX_PAGE_NOT_OWNED_BY_TD		0xC000030200000000
+#define TDX_PAGE_NOT_FREE			0xC000030300000000
+#define TDX_TD_ASSOCIATED_PAGES_EXIST		0xC000040000000000
+#define TDX_SYSINIT_NOT_PENDING			0xC000050000000000
+#define TDX_SYSINIT_NOT_DONE			0xC000050100000000
+#define TDX_SYSINITLP_NOT_DONE			0xC000050200000000
+#define TDX_SYSINITLP_DONE			0xC000050300000000
+#define TDX_SYS_NOT_READY			0xC000050500000000
+#define TDX_SYS_SHUTDOWN			0xC000050600000000
+#define TDX_SYSCONFIG_NOT_DONE			0xC000050700000000
+#define TDX_TD_NOT_INITIALIZED			0xC000060000000000
+#define TDX_TD_INITIALIZED			0xC000060100000000
+#define TDX_TD_NOT_FINALIZED			0xC000060200000000
+#define TDX_TD_FINALIZED			0xC000060300000000
+#define TDX_TD_FATAL				0xC000060400000000
+#define TDX_TD_NON_DEBUG			0xC000060500000000
+#define TDX_TDCX_NUM_INCORRECT			0xC000061000000000
+#define TDX_VCPU_STATE_INCORRECT		0xC000070000000000
+#define TDX_VCPU_ASSOCIATED			0x8000070100000000
+#define TDX_VCPU_NOT_ASSOCIATED			0x8000070200000000
+#define TDX_TDVPX_NUM_INCORRECT			0xC000070300000000
+#define TDX_NO_VALID_VE_INFO			0xC000070400000000
+#define TDX_MAX_VCPUS_EXCEEDED			0xC000070500000000
+#define TDX_TSC_ROLLBACK			0xC000070600000000
+#define TDX_FIELD_NOT_WRITABLE			0xC000072000000000
+#define TDX_FIELD_NOT_READABLE			0xC000072100000000
+#define TDX_TD_VMCS_FIELD_NOT_INITIALIZED	0xC000073000000000
+#define TDX_KEY_GENERATION_FAILED		0x8000080000000000
+#define TDX_TD_KEYS_NOT_CONFIGURED		0x8000081000000000
+#define TDX_KEY_STATE_INCORRECT			0xC000081100000000
+#define TDX_KEY_CONFIGURED			0x0000081500000000
+#define TDX_WBCACHE_NOT_COMPLETE		0x8000081700000000
+#define TDX_HKID_NOT_FREE			0xC000082000000000
+#define TDX_NO_HKID_READY_TO_WBCACHE		0x0000082100000000
+#define TDX_WBCACHE_RESUME_ERROR		0xC000082300000000
+#define TDX_FLUSHVP_NOT_DONE			0x8000082400000000
+#define TDX_NUM_ACTIVATED_HKIDS_NOT_SUPPORTED	0xC000082500000000
+#define TDX_INCORRECT_CPUID_VALUE		0xC000090000000000
+#define TDX_BOOT_NT4_SET			0xC000090100000000
+#define TDX_INCONSISTENT_CPUID_FIELD		0xC000090200000000
+#define TDX_CPUID_LEAF_1F_FORMAT_UNRECOGNIZED	0xC000090400000000
+#define TDX_INVALID_WBINVD_SCOPE		0xC000090500000000
+#define TDX_INVALID_PKG_ID			0xC000090600000000
+#define TDX_CPUID_LEAF_NOT_SUPPORTED		0xC000090800000000
+#define TDX_SMRR_NOT_LOCKED			0xC000091000000000
+#define TDX_INVALID_SMRR_CONFIGURATION		0xC000091100000000
+#define TDX_SMRR_OVERLAPS_CMR			0xC000091200000000
+#define TDX_SMRR_LOCK_NOT_SUPPORTED		0xC000091300000000
+#define TDX_SMRR_NOT_SUPPORTED			0xC000091400000000
+#define TDX_INCONSISTENT_MSR			0xC000092000000000
+#define TDX_INCORRECT_MSR_VALUE			0xC000092100000000
+#define TDX_SEAMREPORT_NOT_AVAILABLE		0xC000093000000000
+#define TDX_PERF_COUNTERS_ARE_PEBS_ENABLED	0x8000094000000000
+#define TDX_INVALID_TDMR			0xC0000A0000000000
+#define TDX_NON_ORDERED_TDMR			0xC0000A0100000000
+#define TDX_TDMR_OUTSIDE_CMRS			0xC0000A0200000000
+#define TDX_TDMR_ALREADY_INITIALIZED		0x00000A0300000000
+#define TDX_INVALID_PAMT			0xC0000A1000000000
+#define TDX_PAMT_OUTSIDE_CMRS			0xC0000A1100000000
+#define TDX_PAMT_OVERLAP			0xC0000A1200000000
+#define TDX_INVALID_RESERVED_IN_TDMR		0xC0000A2000000000
+#define TDX_NON_ORDERED_RESERVED_IN_TDMR	0xC0000A2100000000
+#define TDX_CMR_LIST_INVALID			0xC0000A2200000000
+#define TDX_EPT_WALK_FAILED			0xC0000B0000000000
+#define TDX_EPT_ENTRY_FREE			0xC0000B0100000000
+#define TDX_EPT_ENTRY_NOT_FREE			0xC0000B0200000000
+#define TDX_EPT_ENTRY_NOT_PRESENT		0xC0000B0300000000
+#define TDX_EPT_ENTRY_NOT_LEAF			0xC0000B0400000000
+#define TDX_EPT_ENTRY_LEAF			0xC0000B0500000000
+#define TDX_GPA_RANGE_NOT_BLOCKED		0xC0000B0600000000
+#define TDX_GPA_RANGE_ALREADY_BLOCKED		0x00000B0700000000
+#define TDX_TLB_TRACKING_NOT_DONE		0xC0000B0800000000
+#define TDX_EPT_INVALID_PROMOTE_CONDITIONS	0xC0000B0900000000
+#define TDX_PAGE_ALREADY_ACCEPTED		0x00000B0A00000000
+#define TDX_PAGE_SIZE_MISMATCH			0xC0000B0B00000000
+
+/*
+ * TDG.VP.VMCALL Status Codes (returned in R10)
+ */
+#define TDG_VP_VMCALL_SUCCESS			0x0000000000000000
+#define TDG_VP_VMCALL_INVALID_OPERAND		0x8000000000000000
+#define TDG_VP_VMCALL_TDREPORT_FAILED		0x8000000000000001
+
+#endif /* __KVM_X86_TDX_ERRNO_H */
-- 
2.25.1

