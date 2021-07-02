Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3D23BA5CC
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbhGBWKJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:10:09 -0400
Received: from mga17.intel.com ([192.55.52.151]:15277 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234065AbhGBWJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:09:03 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="189168425"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="189168425"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:33 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814904"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:32 -0700
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
        Yuan Yao <yuan.yao@intel.com>
Subject: [RFC PATCH v2 67/69] KVM: TDX: add trace point for TDVMCALL and SEPT operation
Date:   Fri,  2 Jul 2021 15:05:13 -0700
Message-Id: <0fc6ab7acf3ac2e764ada5abd76500ce8adb3d33.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Signed-off-by: Yuan Yao <yuan.yao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/trace.h        | 58 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.c      | 16 ++++++++++
 arch/x86/kvm/vmx/tdx_arch.h |  9 ++++++
 arch/x86/kvm/x86.c          |  2 ++
 4 files changed, 85 insertions(+)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index c3398d0de9a7..58631124f08d 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -739,6 +739,64 @@ TRACE_EVENT(kvm_tdx_seamcall_exit,
 		  __entry->r9, __entry->r10, __entry->r11)
 );
 
+/*
+ * Tracepoint for TDVMCALL from a TDX guest
+ */
+TRACE_EVENT(kvm_tdvmcall,
+	TP_PROTO(struct kvm_vcpu *vcpu, __u32 exit_reason,
+		 __u64 p1, __u64 p2, __u64 p3, __u64 p4),
+	TP_ARGS(vcpu, exit_reason, p1, p2, p3, p4),
+
+	TP_STRUCT__entry(
+		__field(	__u64,		rip		)
+		__field(	__u32,		exit_reason	)
+		__field(	__u64,		p1		)
+		__field(	__u64,		p2		)
+		__field(	__u64,		p3		)
+		__field(	__u64,		p4		)
+	),
+
+	TP_fast_assign(
+		__entry->rip			= kvm_rip_read(vcpu);
+		__entry->exit_reason		= exit_reason;
+		__entry->p1			= p1;
+		__entry->p2			= p2;
+		__entry->p3			= p3;
+		__entry->p4			= p4;
+	),
+
+	TP_printk("rip: %llx reason: %s p1: %llx p2: %llx p3: %llx p4: %llx",
+		  __entry->rip,
+		  __print_symbolic(__entry->exit_reason,
+				   TDG_VP_VMCALL_EXIT_REASONS),
+		  __entry->p1, __entry->p2, __entry->p3, __entry->p4)
+);
+
+/*
+ * Tracepoint for SEPT related SEAMCALLs.
+ */
+TRACE_EVENT(kvm_sept_seamcall,
+	TP_PROTO(__u64 op, __u64 gpa, __u64 hpa, int level),
+	TP_ARGS(op, gpa, hpa, level),
+
+	TP_STRUCT__entry(
+		__field(	__u64,		op	)
+		__field(	__u64,		gpa	)
+		__field(	__u64,		hpa	)
+		__field(	int,		level	)
+	),
+
+	TP_fast_assign(
+		__entry->op			= op;
+		__entry->gpa			= gpa;
+		__entry->hpa			= hpa;
+		__entry->level			= level;
+	),
+
+	TP_printk("op: %llu gpa: 0x%llx hpa: 0x%llx level: %u",
+		  __entry->op, __entry->gpa, __entry->hpa, __entry->level)
+);
+
 /*
  * Tracepoint for nested #vmexit because of interrupt pending
  */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 1aed4286ce0c..63130fb5a003 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -934,6 +934,10 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 
 	exit_reason = tdvmcall_exit_reason(vcpu);
 
+	trace_kvm_tdvmcall(vcpu, exit_reason,
+			   tdvmcall_p1_read(vcpu), tdvmcall_p2_read(vcpu),
+			   tdvmcall_p3_read(vcpu), tdvmcall_p4_read(vcpu));
+
 	switch (exit_reason) {
 	case EXIT_REASON_CPUID:
 		return tdx_emulate_cpuid(vcpu);
@@ -1011,11 +1015,15 @@ static void tdx_sept_set_private_spte(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 	/* Build-time faults are induced and handled via TDH_MEM_PAGE_ADD. */
 	if (is_td_finalized(kvm_tdx)) {
+		trace_kvm_sept_seamcall(SEAMCALL_TDH_MEM_PAGE_AUG, gpa, hpa, level);
+
 		err = tdh_mem_page_aug(kvm_tdx->tdr.pa, gpa, hpa, &ex_ret);
 		SEPT_ERR(err, &ex_ret, TDH_MEM_PAGE_AUG, vcpu->kvm);
 		return;
 	}
 
+	trace_kvm_sept_seamcall(SEAMCALL_TDH_MEM_PAGE_ADD, gpa, hpa, level);
+
 	source_pa = kvm_tdx->source_pa & ~KVM_TDX_MEASURE_MEMORY_REGION;
 
 	err = tdh_mem_page_add(kvm_tdx->tdr.pa,  gpa, hpa, source_pa, &ex_ret);
@@ -1039,6 +1047,8 @@ static void tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn, int level,
 		return;
 
 	if (is_hkid_assigned(kvm_tdx)) {
+		trace_kvm_sept_seamcall(SEAMCALL_TDH_MEM_PAGE_REMOVE, gpa, hpa, level);
+
 		err = tdh_mem_page_remove(kvm_tdx->tdr.pa, gpa, level, &ex_ret);
 		if (SEPT_ERR(err, &ex_ret, TDH_MEM_PAGE_REMOVE, kvm))
 			return;
@@ -1063,6 +1073,8 @@ static int tdx_sept_link_private_sp(struct kvm_vcpu *vcpu, gfn_t gfn,
 	struct tdx_ex_ret ex_ret;
 	u64 err;
 
+	trace_kvm_sept_seamcall(SEAMCALL_TDH_MEM_SEPT_ADD, gpa, hpa, level);
+
 	err = tdh_mem_spet_add(kvm_tdx->tdr.pa, gpa, level, hpa, &ex_ret);
 	if (SEPT_ERR(err, &ex_ret, TDH_MEM_SEPT_ADD, vcpu->kvm))
 		return -EIO;
@@ -1077,6 +1089,8 @@ static void tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn, int level)
 	struct tdx_ex_ret ex_ret;
 	u64 err;
 
+	trace_kvm_sept_seamcall(SEAMCALL_TDH_MEM_RANGE_BLOCK, gpa, -1ull, level);
+
 	err = tdh_mem_range_block(kvm_tdx->tdr.pa, gpa, level, &ex_ret);
 	SEPT_ERR(err, &ex_ret, TDH_MEM_RANGE_BLOCK, kvm);
 }
@@ -1088,6 +1102,8 @@ static void tdx_sept_unzap_private_spte(struct kvm *kvm, gfn_t gfn, int level)
 	struct tdx_ex_ret ex_ret;
 	u64 err;
 
+	trace_kvm_sept_seamcall(SEAMCALL_TDH_MEM_RANGE_UNBLOCK, gpa, -1ull, level);
+
 	err = tdh_mem_range_unblock(kvm_tdx->tdr.pa, gpa, level, &ex_ret);
 	SEPT_ERR(err, &ex_ret, TDH_MEM_RANGE_UNBLOCK, kvm);
 }
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index 7258825b1e02..414b933a3b03 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -104,6 +104,15 @@
 #define TDG_VP_VMCALL_REPORT_FATAL_ERROR		0x10003
 #define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT	0x10004
 
+#define TDG_VP_VMCALL_EXIT_REASONS				\
+	{ TDG_VP_VMCALL_GET_TD_VM_CALL_INFO,			\
+			"GET_TD_VM_CALL_INFO" },		\
+	{ TDG_VP_VMCALL_MAP_GPA,	"MAP_GPA" },		\
+	{ TDG_VP_VMCALL_GET_QUOTE,	"GET_QUOTE" },		\
+	{ TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT,		\
+			"SETUP_EVENT_NOTIFY_INTERRUPT" },	\
+	VMX_EXIT_REASONS
+
 /* TDX control structure (TDR/TDCS/TDVPS) field access codes */
 #define TDX_CLASS_SHIFT		56
 #define TDX_FIELD_MASK		GENMASK_ULL(31, 0)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ba69abcc663a..ad619c1b2a88 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12104,6 +12104,8 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_tdvmcall);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_sept_seamcall);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmenter_failed);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
-- 
2.25.1

