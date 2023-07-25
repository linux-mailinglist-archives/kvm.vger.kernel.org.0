Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727F7762682
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbjGYWYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbjGYWXF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:23:05 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18D8524E;
        Tue, 25 Jul 2023 15:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323495; x=1721859495;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hSGK2LlFv0TvHSe7F1KxzRM+dpHoN60qKGZl44FONDw=;
  b=P7yrNAqgSE+eetptqDO0fXb91Kl5jUBp54Jj1fycMt1F4MULH0QTvkij
   F1rgiutXLIy6iBdDybyrorAU/XSGFoXC5TFw8ZSefV3EqHtQfJBOJJtcZ
   PneIJckz6evwl42XIpkNCv6yjrwgFV9F9or7eNOBZSEC3Am6B7WbCyVR2
   eQ8129+DEf93FxYjyUCHIgttBdEnTcF0oJVuhpQYHxZSd7obIpOi7WDH7
   v28NcLLaNYt/p7dUQMJznJ9+JcE701q+vWCGtiKvWe6+7792zBemSDIfe
   VNThqiPHgrhv1uwsWEO3bNsSBvZXQwCjW7QicF2ZGTHCUZ4X/mCCJRRQg
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="367882696"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="367882696"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:16:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="840001893"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="840001893"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:16:02 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 091/115] KVM: TDX: Add KVM Exit for TDX TDG.VP.VMCALL
Date:   Tue, 25 Jul 2023 15:14:42 -0700
Message-Id: <9754513226ad834533c8e97039b50e5c0470caa4.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Some of TDG.VP.VMCALL require device model, for example, qemu, to handle
them on behalf of kvm kernel module. TDG_VP_VMCALL_REPORT_FATAL_ERROR,
TDG_VP_VMCALL_MAP_GPA, TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT, and
TDG_VP_VMCALL_GET_QUOTE requires user space VMM handling.

Introduce new kvm exit, KVM_EXIT_TDX, and functions to setup it.
TDG_VP_VMCALL_INVALID_OPERAND is set as default return value to avoid
random value.  Device model should update R10 if necessary.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v14 -> v15:
- updated struct kvm_tdx_exit with union
- export constants for reg bitmask

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c   | 84 +++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h | 87 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 169 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 19500a05f7b5..0e95e5c79337 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -917,6 +917,78 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_complete_vp_vmcall(struct kvm_vcpu *vcpu)
+{
+	struct kvm_tdx_vmcall *tdx_vmcall = &vcpu->run->tdx.u.vmcall;
+	__u64 reg_mask = kvm_rcx_read(vcpu);
+
+#define COPY_REG(MASK, REG)							\
+	do {									\
+		if (reg_mask & TDX_VMCALL_REG_MASK_ ## MASK)			\
+			kvm_## REG ## _write(vcpu, tdx_vmcall->out_ ## REG);	\
+	} while (0)
+
+
+	COPY_REG(R10, r10);
+	COPY_REG(R11, r11);
+	COPY_REG(R12, r12);
+	COPY_REG(R13, r13);
+	COPY_REG(R14, r14);
+	COPY_REG(R15, r15);
+	COPY_REG(RBX, rbx);
+	COPY_REG(RDI, rdi);
+	COPY_REG(RSI, rsi);
+	COPY_REG(R8, r8);
+	COPY_REG(R9, r9);
+	COPY_REG(RDX, rdx);
+
+#undef COPY_REG
+
+	return 1;
+}
+
+static int tdx_vp_vmcall_to_user(struct kvm_vcpu *vcpu)
+{
+	struct kvm_tdx_vmcall *tdx_vmcall = &vcpu->run->tdx.u.vmcall;
+	__u64 reg_mask;
+
+	vcpu->arch.complete_userspace_io = tdx_complete_vp_vmcall;
+	memset(tdx_vmcall, 0, sizeof(*tdx_vmcall));
+
+	vcpu->run->exit_reason = KVM_EXIT_TDX;
+	vcpu->run->tdx.type = KVM_EXIT_TDX_VMCALL;
+
+	reg_mask = kvm_rcx_read(vcpu);
+	tdx_vmcall->reg_mask = reg_mask;
+
+#define COPY_REG(MASK, REG)							\
+	do {									\
+		if (reg_mask & TDX_VMCALL_REG_MASK_ ## MASK) {			\
+			tdx_vmcall->in_ ## REG = kvm_ ## REG ## _read(vcpu);	\
+			tdx_vmcall->out_ ## REG = tdx_vmcall->in_ ## REG;	\
+		}								\
+	} while (0)
+
+
+	COPY_REG(R10, r10);
+	COPY_REG(R11, r11);
+	COPY_REG(R12, r12);
+	COPY_REG(R13, r13);
+	COPY_REG(R14, r14);
+	COPY_REG(R15, r15);
+	COPY_REG(RBX, rbx);
+	COPY_REG(RDI, rdi);
+	COPY_REG(RSI, rsi);
+	COPY_REG(R8, r8);
+	COPY_REG(R9, r9);
+	COPY_REG(RDX, rdx);
+
+#undef COPY_REG
+
+	/* notify userspace to handle the request */
+	return 0;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	if (tdvmcall_exit_type(vcpu))
@@ -927,8 +999,16 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		break;
 	}
 
-	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
-	return 1;
+	/*
+	 * Unknown VMCALL.  Toss the request to the user space VMM, e.g. qemu,
+	 * as it may know how to handle.
+	 *
+	 * Those VMCALLs require user space VMM:
+	 * TDG_VP_VMCALL_REPORT_FATAL_ERROR, TDG_VP_VMCALL_MAP_GPA,
+	 * TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT, and
+	 * TDG_VP_VMCALL_GET_QUOTE.
+	 */
+	return tdx_vp_vmcall_to_user(vcpu);
 }
 
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index eb900344a054..c46321c48c0f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -237,6 +237,90 @@ struct kvm_xen_exit {
 	} u;
 };
 
+struct kvm_tdx_exit {
+#define KVM_EXIT_TDX_VMCALL	1
+	__u32 type;
+	__u32 pad;
+
+	union {
+		struct kvm_tdx_vmcall {
+			/*
+			 * RAX(bit 0), RCX(bit 1) and RSP(bit 4) are reserved.
+			 * RAX(bit 0): TDG.VP.VMCALL status code.
+			 * RCX(bit 1): bitmap for used registers.
+			 * RSP(bit 4): the caller stack.
+			 */
+#define TDX_VMCALL_REG_MASK_RBX	BIT_ULL(2)
+#define TDX_VMCALL_REG_MASK_RDX	BIT_ULL(3)
+#define TDX_VMCALL_REG_MASK_RSI	BIT_ULL(6)
+#define TDX_VMCALL_REG_MASK_RDI	BIT_ULL(7)
+#define TDX_VMCALL_REG_MASK_R8	BIT_ULL(8)
+#define TDX_VMCALL_REG_MASK_R9	BIT_ULL(9)
+#define TDX_VMCALL_REG_MASK_R10	BIT_ULL(10)
+#define TDX_VMCALL_REG_MASK_R11	BIT_ULL(11)
+#define TDX_VMCALL_REG_MASK_R12	BIT_ULL(12)
+#define TDX_VMCALL_REG_MASK_R13	BIT_ULL(13)
+#define TDX_VMCALL_REG_MASK_R14	BIT_ULL(14)
+#define TDX_VMCALL_REG_MASK_R15	BIT_ULL(15)
+			union {
+				__u64 in_rcx;
+				__u64 reg_mask;
+			};
+
+			/*
+			 * Guest-Host-Communication Interface for TDX spec
+			 * defines the ABI for TDG.VP.VMCALL.
+			 */
+			/* Input parameters: guest -> VMM */
+			union {
+				__u64 in_r10;
+				__u64 type;
+			};
+			union {
+				__u64 in_r11;
+				__u64 subfunction;
+			};
+			/*
+			 * Subfunction specific.
+			 * Registers are used in this order to pass input
+			 * arguments.  r12=arg0, r13=arg1, etc.
+			 */
+			__u64 in_r12;
+			__u64 in_r13;
+			__u64 in_r14;
+			__u64 in_r15;
+			__u64 in_rbx;
+			__u64 in_rdi;
+			__u64 in_rsi;
+			__u64 in_r8;
+			__u64 in_r9;
+			__u64 in_rdx;
+
+			/* Output parameters: VMM -> guest */
+			union {
+				__u64 out_r10;
+				__u64 status_code;
+			};
+			/*
+			 * Subfunction specific.
+			 * Registers are used in this order to output return
+			 * values.  r11=ret0, r12=ret1, etc.
+			 */
+			__u64 out_r11;
+			__u64 out_r12;
+			__u64 out_r13;
+			__u64 out_r14;
+			__u64 out_r15;
+			__u64 out_rbx;
+			__u64 out_rdi;
+			__u64 out_rsi;
+			__u64 out_r8;
+			__u64 out_r9;
+			__u64 out_rdx;
+		} vmcall;
+	} u;
+};
+
 #define KVM_S390_GET_SKEYS_NONE   1
 #define KVM_S390_SKEYS_MAX        1048576
 
@@ -279,6 +363,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_MEMORY_FAULT     38
+#define KVM_EXIT_TDX              39
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -532,6 +617,8 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory;
+		/* KVM_EXIT_TDX_VMCALL */
+		struct kvm_tdx_exit tdx;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.25.1

