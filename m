Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A693BA5C0
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbhGBWJr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:09:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:51168 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232997AbhGBWHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:07:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="195951888"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="195951888"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:20 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814693"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:20 -0700
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
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [RFC PATCH v2 08/69] KVM: TDX: add trace point before/after TDX SEAMCALLs
Date:   Fri,  2 Jul 2021 15:04:14 -0700
Message-Id: <28a0ae6b767260fcb410c6ddff7de84f4e13062c.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/trace.h         | 80 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/seamcall.h  | 22 ++++++++-
 arch/x86/kvm/vmx/tdx_arch.h  | 47 ++++++++++++++++++
 arch/x86/kvm/vmx/tdx_errno.h | 96 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c           |  2 +
 5 files changed, 246 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 4f839148948b..c3398d0de9a7 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -8,6 +8,9 @@
 #include <asm/clocksource.h>
 #include <asm/pvclock-abi.h>
 
+#include "vmx/tdx_arch.h"
+#include "vmx/tdx_errno.h"
+
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvm
 
@@ -659,6 +662,83 @@ TRACE_EVENT(kvm_nested_vmexit_inject,
 		  __entry->exit_int_info, __entry->exit_int_info_err)
 );
 
+/*
+ * Tracepoint for the start of TDX SEAMCALLs.
+ */
+TRACE_EVENT(kvm_tdx_seamcall_enter,
+	TP_PROTO(int cpuid, __u64 op, __u64 rcx, __u64 rdx, __u64 r8,
+		 __u64 r9, __u64 r10),
+	TP_ARGS(cpuid, op, rcx, rdx, r8, r9, r10),
+
+	TP_STRUCT__entry(
+		__field(	int,		cpuid	)
+		__field(	__u64,		op	)
+		__field(	__u64,		rcx	)
+		__field(	__u64,		rdx	)
+		__field(	__u64,		r8	)
+		__field(	__u64,		r9	)
+		__field(	__u64,		r10	)
+	),
+
+	TP_fast_assign(
+		__entry->cpuid			= cpuid;
+		__entry->op			= op;
+		__entry->rcx			= rcx;
+		__entry->rdx			= rdx;
+		__entry->r8			= r8;
+		__entry->r9			= r9;
+		__entry->r10			= r10;
+	),
+
+	TP_printk("cpu: %d op: %s rcx: 0x%llx rdx: 0x%llx r8: 0x%llx r9: 0x%llx r10: 0x%llx",
+		  __entry->cpuid,
+		  __print_symbolic(__entry->op, TDX_SEAMCALL_OP_CODES),
+		  __entry->rcx, __entry->rdx, __entry->r8,
+		  __entry->r9, __entry->r10)
+);
+
+/*
+ * Tracepoint for the end of TDX SEAMCALLs.
+ */
+TRACE_EVENT(kvm_tdx_seamcall_exit,
+	TP_PROTO(int cpuid, __u64 op, __u64 err, __u64 rcx, __u64 rdx, __u64 r8,
+		 __u64 r9, __u64 r10, __u64 r11),
+	TP_ARGS(cpuid, op, err, rcx, rdx, r8, r9, r10, r11),
+
+	TP_STRUCT__entry(
+		__field(	int,		cpuid	)
+		__field(	__u64,		op	)
+		__field(	__u64,		err	)
+		__field(	__u64,		rcx	)
+		__field(	__u64,		rdx	)
+		__field(	__u64,		r8	)
+		__field(	__u64,		r9	)
+		__field(	__u64,		r10	)
+		__field(	__u64,		r11	)
+	),
+
+	TP_fast_assign(
+		__entry->cpuid			= cpuid;
+		__entry->op			= op;
+		__entry->err			= err;
+		__entry->rcx			= rcx;
+		__entry->rdx			= rdx;
+		__entry->r8			= r8;
+		__entry->r9			= r9;
+		__entry->r10			= r10;
+		__entry->r11			= r11;
+	),
+
+	TP_printk("cpu: %d op: %s err %s 0x%llx rcx: 0x%llx rdx: 0x%llx r8: 0x%llx r9: 0x%llx r10: 0x%llx r11: 0x%llx",
+		  __entry->cpuid,
+		  __print_symbolic(__entry->op, TDX_SEAMCALL_OP_CODES),
+		  __print_symbolic(__entry->err & TDX_SEAMCALL_STATUS_MASK,
+				   TDX_SEAMCALL_STATUS_CODES),
+		  __entry->err,
+		  __entry->rcx, __entry->rdx, __entry->r8,
+		  __entry->r9, __entry->r10, __entry->r11)
+);
+
 /*
  * Tracepoint for nested #vmexit because of interrupt pending
  */
diff --git a/arch/x86/kvm/vmx/seamcall.h b/arch/x86/kvm/vmx/seamcall.h
index a318940f62ed..2c83ab46eeac 100644
--- a/arch/x86/kvm/vmx/seamcall.h
+++ b/arch/x86/kvm/vmx/seamcall.h
@@ -9,12 +9,32 @@
 #else
 
 #ifndef seamcall
+#include "trace.h"
+
 struct tdx_ex_ret;
 asmlinkage u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9, u64 r10,
 			  struct tdx_ex_ret *ex);
 
+static inline u64 _seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9, u64 r10,
+			    struct tdx_ex_ret *ex)
+{
+	u64 err;
+
+	trace_kvm_tdx_seamcall_enter(smp_processor_id(), op,
+				     rcx, rdx, r8, r9, r10);
+	err = __seamcall(op, rcx, rdx, r8, r9, r10, ex);
+	if (ex)
+		trace_kvm_tdx_seamcall_exit(smp_processor_id(), op, err, ex->rcx,
+					    ex->rdx, ex->r8, ex->r9, ex->r10,
+					    ex->r11);
+	else
+		trace_kvm_tdx_seamcall_exit(smp_processor_id(), op, err,
+					    0, 0, 0, 0, 0, 0);
+	return err;
+}
+
 #define seamcall(op, rcx, rdx, r8, r9, r10, ex)				\
-	__seamcall(SEAMCALL_##op, (rcx), (rdx), (r8), (r9), (r10), (ex))
+	_seamcall(SEAMCALL_##op, (rcx), (rdx), (r8), (r9), (r10), (ex))
 #endif
 
 static inline void __pr_seamcall_error(u64 op, const char *op_str,
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index 57e9ea4a7fad..559a63290c4d 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -51,6 +51,53 @@
 #define SEAMCALL_TDH_SYS_LP_SHUTDOWN		44
 #define SEAMCALL_TDH_SYS_CONFIG			45
 
+#define TDX_BUILD_OP_CODE(name)	{ SEAMCALL_ ## name, #name }
+
+#define TDX_SEAMCALL_OP_CODES				\
+	TDX_BUILD_OP_CODE(TDH_VP_ENTER),		\
+	TDX_BUILD_OP_CODE(TDH_MNG_ADDCX),		\
+	TDX_BUILD_OP_CODE(TDH_MEM_PAGE_ADD),		\
+	TDX_BUILD_OP_CODE(TDH_MEM_SEPT_ADD),		\
+	TDX_BUILD_OP_CODE(TDH_VP_ADDCX),		\
+	TDX_BUILD_OP_CODE(TDH_MEM_PAGE_AUG),		\
+	TDX_BUILD_OP_CODE(TDH_MEM_RANGE_BLOCK),		\
+	TDX_BUILD_OP_CODE(TDH_MNG_KEY_CONFIG),		\
+	TDX_BUILD_OP_CODE(TDH_MNG_CREATE),		\
+	TDX_BUILD_OP_CODE(TDH_VP_CREATE),		\
+	TDX_BUILD_OP_CODE(TDH_MNG_RD),			\
+	TDX_BUILD_OP_CODE(TDH_PHYMEM_PAGE_RD),		\
+	TDX_BUILD_OP_CODE(TDH_MNG_WR),			\
+	TDX_BUILD_OP_CODE(TDH_PHYMEM_PAGE_WR),		\
+	TDX_BUILD_OP_CODE(TDH_MEM_PAGE_DEMOTE),		\
+	TDX_BUILD_OP_CODE(TDH_MR_EXTEND),		\
+	TDX_BUILD_OP_CODE(TDH_MR_FINALIZE),		\
+	TDX_BUILD_OP_CODE(TDH_VP_FLUSH),		\
+	TDX_BUILD_OP_CODE(TDH_MNG_VPFLUSHDONE),		\
+	TDX_BUILD_OP_CODE(TDH_MNG_KEY_FREEID),		\
+	TDX_BUILD_OP_CODE(TDH_MNG_INIT),		\
+	TDX_BUILD_OP_CODE(TDH_VP_INIT),			\
+	TDX_BUILD_OP_CODE(TDH_MEM_PAGE_PROMOTE),	\
+	TDX_BUILD_OP_CODE(TDH_PHYMEM_PAGE_RDMD),	\
+	TDX_BUILD_OP_CODE(TDH_MEM_SEPT_RD),		\
+	TDX_BUILD_OP_CODE(TDH_VP_RD),			\
+	TDX_BUILD_OP_CODE(TDH_MNG_KEY_RECLAIMID),	\
+	TDX_BUILD_OP_CODE(TDH_PHYMEM_PAGE_RECLAIM),	\
+	TDX_BUILD_OP_CODE(TDH_MEM_PAGE_REMOVE),		\
+	TDX_BUILD_OP_CODE(TDH_MEM_SEPT_REMOVE),		\
+	TDX_BUILD_OP_CODE(TDH_SYS_KEY_CONFIG),		\
+	TDX_BUILD_OP_CODE(TDH_SYS_INFO),		\
+	TDX_BUILD_OP_CODE(TDH_SYS_INIT),		\
+	TDX_BUILD_OP_CODE(TDH_SYS_LP_INIT),		\
+	TDX_BUILD_OP_CODE(TDH_SYS_TDMR_INIT),		\
+	TDX_BUILD_OP_CODE(TDH_MEM_TRACK),		\
+	TDX_BUILD_OP_CODE(TDH_MEM_RANGE_UNBLOCK),	\
+	TDX_BUILD_OP_CODE(TDH_PHYMEM_CACHE_WB),		\
+	TDX_BUILD_OP_CODE(TDH_PHYMEM_PAGE_WBINVD),	\
+	TDX_BUILD_OP_CODE(TDH_MEM_SEPT_WR),		\
+	TDX_BUILD_OP_CODE(TDH_VP_WR),			\
+	TDX_BUILD_OP_CODE(TDH_SYS_LP_SHUTDOWN),		\
+	TDX_BUILD_OP_CODE(TDH_SYS_CONFIG)
+
 #define TDG_VP_VMCALL_GET_TD_VM_CALL_INFO		0x10000
 #define TDG_VP_VMCALL_MAP_GPA				0x10001
 #define TDG_VP_VMCALL_GET_QUOTE				0x10002
diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
index 675acea412c9..90ee2b5364d6 100644
--- a/arch/x86/kvm/vmx/tdx_errno.h
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -2,6 +2,8 @@
 #ifndef __KVM_X86_TDX_ERRNO_H
 #define __KVM_X86_TDX_ERRNO_H
 
+#define TDX_SEAMCALL_STATUS_MASK		0xFFFFFFFF00000000
+
 /*
  * TDX SEAMCALL Status Codes (returned in RAX)
  */
@@ -96,6 +98,100 @@
 #define TDX_PAGE_ALREADY_ACCEPTED		0x00000B0A00000000
 #define TDX_PAGE_SIZE_MISMATCH			0xC0000B0B00000000
 
+#define TDX_BUILD_STATUS_CODE(name)	{ name, #name }
+
+#define TDX_SEAMCALL_STATUS_CODES					\
+	TDX_BUILD_STATUS_CODE(TDX_SUCCESS),				\
+	TDX_BUILD_STATUS_CODE(TDX_NON_RECOVERABLE_VCPU),		\
+	TDX_BUILD_STATUS_CODE(TDX_NON_RECOVERABLE_TD),			\
+	TDX_BUILD_STATUS_CODE(TDX_INTERRUPTED_RESUMABLE),		\
+	TDX_BUILD_STATUS_CODE(TDX_INTERRUPTED_RESTARTABLE),		\
+	TDX_BUILD_STATUS_CODE(TDX_NON_RECOVERABLE_TD_FATAL),		\
+	TDX_BUILD_STATUS_CODE(TDX_INVALID_RESUMPTION),			\
+	TDX_BUILD_STATUS_CODE(TDX_NON_RECOVERABLE_TD_NO_APIC),		\
+	TDX_BUILD_STATUS_CODE(TDX_OPERAND_INVALID),			\
+	TDX_BUILD_STATUS_CODE(TDX_OPERAND_ADDR_RANGE_ERROR),		\
+	TDX_BUILD_STATUS_CODE(TDX_OPERAND_BUSY),			\
+	TDX_BUILD_STATUS_CODE(TDX_PREVIOUS_TLB_EPOCH_BUSY),		\
+	TDX_BUILD_STATUS_CODE(TDX_SYS_BUSY),				\
+	TDX_BUILD_STATUS_CODE(TDX_PAGE_METADATA_INCORRECT),		\
+	TDX_BUILD_STATUS_CODE(TDX_PAGE_ALREADY_FREE),			\
+	TDX_BUILD_STATUS_CODE(TDX_PAGE_NOT_OWNED_BY_TD),		\
+	TDX_BUILD_STATUS_CODE(TDX_PAGE_NOT_FREE),			\
+	TDX_BUILD_STATUS_CODE(TDX_TD_ASSOCIATED_PAGES_EXIST),		\
+	TDX_BUILD_STATUS_CODE(TDX_SYSINIT_NOT_PENDING),			\
+	TDX_BUILD_STATUS_CODE(TDX_SYSINIT_NOT_DONE),			\
+	TDX_BUILD_STATUS_CODE(TDX_SYSINITLP_NOT_DONE),			\
+	TDX_BUILD_STATUS_CODE(TDX_SYSINITLP_DONE),			\
+	TDX_BUILD_STATUS_CODE(TDX_SYS_NOT_READY),			\
+	TDX_BUILD_STATUS_CODE(TDX_SYS_SHUTDOWN),			\
+	TDX_BUILD_STATUS_CODE(TDX_SYSCONFIG_NOT_DONE),			\
+	TDX_BUILD_STATUS_CODE(TDX_TD_NOT_INITIALIZED),			\
+	TDX_BUILD_STATUS_CODE(TDX_TD_INITIALIZED),			\
+	TDX_BUILD_STATUS_CODE(TDX_TD_NOT_FINALIZED),			\
+	TDX_BUILD_STATUS_CODE(TDX_TD_FINALIZED),			\
+	TDX_BUILD_STATUS_CODE(TDX_TD_FATAL),				\
+	TDX_BUILD_STATUS_CODE(TDX_TD_NON_DEBUG),			\
+	TDX_BUILD_STATUS_CODE(TDX_TDCX_NUM_INCORRECT),			\
+	TDX_BUILD_STATUS_CODE(TDX_VCPU_STATE_INCORRECT),		\
+	TDX_BUILD_STATUS_CODE(TDX_VCPU_ASSOCIATED),			\
+	TDX_BUILD_STATUS_CODE(TDX_VCPU_NOT_ASSOCIATED),			\
+	TDX_BUILD_STATUS_CODE(TDX_TDVPX_NUM_INCORRECT),			\
+	TDX_BUILD_STATUS_CODE(TDX_NO_VALID_VE_INFO),			\
+	TDX_BUILD_STATUS_CODE(TDX_MAX_VCPUS_EXCEEDED),			\
+	TDX_BUILD_STATUS_CODE(TDX_TSC_ROLLBACK),			\
+	TDX_BUILD_STATUS_CODE(TDX_FIELD_NOT_WRITABLE),			\
+	TDX_BUILD_STATUS_CODE(TDX_FIELD_NOT_READABLE),			\
+	TDX_BUILD_STATUS_CODE(TDX_TD_VMCS_FIELD_NOT_INITIALIZED),	\
+	TDX_BUILD_STATUS_CODE(TDX_KEY_GENERATION_FAILED),		\
+	TDX_BUILD_STATUS_CODE(TDX_TD_KEYS_NOT_CONFIGURED),		\
+	TDX_BUILD_STATUS_CODE(TDX_KEY_STATE_INCORRECT),			\
+	TDX_BUILD_STATUS_CODE(TDX_KEY_CONFIGURED),			\
+	TDX_BUILD_STATUS_CODE(TDX_WBCACHE_NOT_COMPLETE),		\
+	TDX_BUILD_STATUS_CODE(TDX_HKID_NOT_FREE),			\
+	TDX_BUILD_STATUS_CODE(TDX_NO_HKID_READY_TO_WBCACHE),		\
+	TDX_BUILD_STATUS_CODE(TDX_WBCACHE_RESUME_ERROR),		\
+	TDX_BUILD_STATUS_CODE(TDX_FLUSHVP_NOT_DONE),			\
+	TDX_BUILD_STATUS_CODE(TDX_NUM_ACTIVATED_HKIDS_NOT_SUPPORTED),	\
+	TDX_BUILD_STATUS_CODE(TDX_INCORRECT_CPUID_VALUE),		\
+	TDX_BUILD_STATUS_CODE(TDX_BOOT_NT4_SET),			\
+	TDX_BUILD_STATUS_CODE(TDX_INCONSISTENT_CPUID_FIELD),		\
+	TDX_BUILD_STATUS_CODE(TDX_CPUID_LEAF_1F_FORMAT_UNRECOGNIZED),	\
+	TDX_BUILD_STATUS_CODE(TDX_INVALID_WBINVD_SCOPE),		\
+	TDX_BUILD_STATUS_CODE(TDX_INVALID_PKG_ID),			\
+	TDX_BUILD_STATUS_CODE(TDX_CPUID_LEAF_NOT_SUPPORTED),		\
+	TDX_BUILD_STATUS_CODE(TDX_SMRR_NOT_LOCKED),			\
+	TDX_BUILD_STATUS_CODE(TDX_INVALID_SMRR_CONFIGURATION),		\
+	TDX_BUILD_STATUS_CODE(TDX_SMRR_OVERLAPS_CMR),			\
+	TDX_BUILD_STATUS_CODE(TDX_SMRR_LOCK_NOT_SUPPORTED),		\
+	TDX_BUILD_STATUS_CODE(TDX_SMRR_NOT_SUPPORTED),			\
+	TDX_BUILD_STATUS_CODE(TDX_INCONSISTENT_MSR),			\
+	TDX_BUILD_STATUS_CODE(TDX_INCORRECT_MSR_VALUE),			\
+	TDX_BUILD_STATUS_CODE(TDX_SEAMREPORT_NOT_AVAILABLE),		\
+	TDX_BUILD_STATUS_CODE(TDX_PERF_COUNTERS_ARE_PEBS_ENABLED),	\
+	TDX_BUILD_STATUS_CODE(TDX_INVALID_TDMR),			\
+	TDX_BUILD_STATUS_CODE(TDX_NON_ORDERED_TDMR),			\
+	TDX_BUILD_STATUS_CODE(TDX_TDMR_OUTSIDE_CMRS),			\
+	TDX_BUILD_STATUS_CODE(TDX_TDMR_ALREADY_INITIALIZED),		\
+	TDX_BUILD_STATUS_CODE(TDX_INVALID_PAMT),			\
+	TDX_BUILD_STATUS_CODE(TDX_PAMT_OUTSIDE_CMRS),			\
+	TDX_BUILD_STATUS_CODE(TDX_PAMT_OVERLAP),			\
+	TDX_BUILD_STATUS_CODE(TDX_INVALID_RESERVED_IN_TDMR),		\
+	TDX_BUILD_STATUS_CODE(TDX_NON_ORDERED_RESERVED_IN_TDMR),	\
+	TDX_BUILD_STATUS_CODE(TDX_CMR_LIST_INVALID),			\
+	TDX_BUILD_STATUS_CODE(TDX_EPT_WALK_FAILED),			\
+	TDX_BUILD_STATUS_CODE(TDX_EPT_ENTRY_FREE),			\
+	TDX_BUILD_STATUS_CODE(TDX_EPT_ENTRY_NOT_FREE),			\
+	TDX_BUILD_STATUS_CODE(TDX_EPT_ENTRY_NOT_PRESENT),		\
+	TDX_BUILD_STATUS_CODE(TDX_EPT_ENTRY_NOT_LEAF),			\
+	TDX_BUILD_STATUS_CODE(TDX_EPT_ENTRY_LEAF),			\
+	TDX_BUILD_STATUS_CODE(TDX_GPA_RANGE_NOT_BLOCKED),		\
+	TDX_BUILD_STATUS_CODE(TDX_GPA_RANGE_ALREADY_BLOCKED),		\
+	TDX_BUILD_STATUS_CODE(TDX_TLB_TRACKING_NOT_DONE),		\
+	TDX_BUILD_STATUS_CODE(TDX_EPT_INVALID_PROMOTE_CONDITIONS),	\
+	TDX_BUILD_STATUS_CODE(TDX_PAGE_ALREADY_ACCEPTED),		\
+	TDX_BUILD_STATUS_CODE(TDX_PAGE_SIZE_MISMATCH)
+
 /*
  * TDG.VP.VMCALL Status Codes (returned in R10)
  */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e0f4a46649d7..d11cf87674f3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11970,6 +11970,8 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_update_request);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_tdx_seamcall_enter);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_tdx_seamcall_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_enter);
-- 
2.25.1

