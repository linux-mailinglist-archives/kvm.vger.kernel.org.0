Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71C2667B1B
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239533AbjALQjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbjALQhZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:25 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718F811C16;
        Thu, 12 Jan 2023 08:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541224; x=1705077224;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L0mmH8/hcNIMh4s5e2E/PePIadSN6Nd4l/42IbkalLQ=;
  b=heIOm4nW1ic9QJUkqby4gFXBO9hA/lqJOGckiNA6bQFzQfq9xaq7s/vM
   BroX/pmlq2/yQq48J9QdwoVeQMPpQ0V6pqohR8k2Nu55fXDkadl1wTRg8
   mvOWuK12Mt1/99MQmqjkLrFyncgbVoMOVaolqUhnooWECN1IztNRnqQjS
   DY13XVh+Me7wq8UUfTjoL9hrZFE5aOWD0MbUs+K19dTdNW98Dhd3GB5Zu
   kX0ZBr36VIIvuWBNxpD0rDkEznkNkaFDs2lW13owqIdUj6M1z5uZe+iCb
   Xxcit4sjki9iGyowCWcapXjIf64t6nGIskIkXgMluhyczAWJvI6KeIUyH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="386089715"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="386089715"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:36 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="726372552"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="726372552"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:35 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 091/113] KVM: TDX: Add KVM Exit for TDX TDG.VP.VMCALL
Date:   Thu, 12 Jan 2023 08:32:39 -0800
Message-Id: <3f5f1bf45207d6f7901cdfe0efc8033aa77a9b51.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Some of TDG.VP.VMCALL require device model, for example, qemu, to handle
them on behalf of kvm kernel module.

Introduce new kvm exit, KVM_EXIT_TDX, and functions to setup it.
TDG_VP_VMCALL_INVALID_OPERAND is set as default return value to avoid
random value.  Device model should update R10 if necessary.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c   | 93 +++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h | 57 ++++++++++++++++++++++++
 2 files changed, 148 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 120825310611..89693405892d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -101,6 +101,18 @@ BUILD_TDVMCALL_ACCESSORS(a1, r13);
 BUILD_TDVMCALL_ACCESSORS(a2, r14);
 BUILD_TDVMCALL_ACCESSORS(a3, r15);
 
+#define TDX_VMCALL_REG_MASK_RBX	BIT_ULL(2)
+#define TDX_VMCALL_REG_MASK_RDX	BIT_ULL(3)
+#define TDX_VMCALL_REG_MASK_RBP	BIT_ULL(5)
+#define TDX_VMCALL_REG_MASK_RSI	BIT_ULL(6)
+#define TDX_VMCALL_REG_MASK_RDI	BIT_ULL(7)
+#define TDX_VMCALL_REG_MASK_R8	BIT_ULL(8)
+#define TDX_VMCALL_REG_MASK_R9	BIT_ULL(9)
+#define TDX_VMCALL_REG_MASK_R12	BIT_ULL(12)
+#define TDX_VMCALL_REG_MASK_R13	BIT_ULL(13)
+#define TDX_VMCALL_REG_MASK_R14	BIT_ULL(14)
+#define TDX_VMCALL_REG_MASK_R15	BIT_ULL(15)
+
 static __always_inline unsigned long tdvmcall_exit_type(struct kvm_vcpu *vcpu)
 {
 	return kvm_r10_read(vcpu);
@@ -837,6 +849,80 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_complete_vp_vmcall(struct kvm_vcpu *vcpu)
+{
+	struct kvm_tdx_vmcall *tdx_vmcall = &vcpu->run->tdx.u.vmcall;
+	__u64 reg_mask;
+
+	tdvmcall_set_return_code(vcpu, tdx_vmcall->status_code);
+	tdvmcall_set_return_val(vcpu, tdx_vmcall->out_r11);
+
+	reg_mask = kvm_rcx_read(vcpu);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R12)
+		kvm_r12_write(vcpu, tdx_vmcall->out_r12);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R13)
+		kvm_r13_write(vcpu, tdx_vmcall->out_r13);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R14)
+		kvm_r14_write(vcpu, tdx_vmcall->out_r14);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R15)
+		kvm_r15_write(vcpu, tdx_vmcall->out_r15);
+	if (reg_mask & TDX_VMCALL_REG_MASK_RBX)
+		kvm_rbx_write(vcpu, tdx_vmcall->out_rbx);
+	if (reg_mask & TDX_VMCALL_REG_MASK_RDI)
+		kvm_rdi_write(vcpu, tdx_vmcall->out_rdi);
+	if (reg_mask & TDX_VMCALL_REG_MASK_RSI)
+		kvm_rsi_write(vcpu, tdx_vmcall->out_rsi);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R8)
+		kvm_r8_write(vcpu, tdx_vmcall->out_r8);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R9)
+		kvm_r9_write(vcpu, tdx_vmcall->out_r9);
+	if (reg_mask & TDX_VMCALL_REG_MASK_RDX)
+		kvm_rdx_write(vcpu, tdx_vmcall->out_rdx);
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
+	tdx_vmcall->type = tdvmcall_exit_type(vcpu);
+	tdx_vmcall->subfunction = tdvmcall_leaf(vcpu);
+	tdx_vmcall->status_code = TDG_VP_VMCALL_INVALID_OPERAND;
+
+	reg_mask = kvm_rcx_read(vcpu);
+	tdx_vmcall->reg_mask = reg_mask;
+	if (reg_mask & TDX_VMCALL_REG_MASK_R12)
+		tdx_vmcall->in_r12 = kvm_r12_read(vcpu);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R13)
+		tdx_vmcall->in_r13 = kvm_r13_read(vcpu);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R14)
+		tdx_vmcall->in_r14 = kvm_r14_read(vcpu);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R15)
+		tdx_vmcall->in_r15 = kvm_r15_read(vcpu);
+	if (reg_mask & TDX_VMCALL_REG_MASK_RBX)
+		tdx_vmcall->in_rbx = kvm_rbx_read(vcpu);
+	if (reg_mask & TDX_VMCALL_REG_MASK_RDI)
+		tdx_vmcall->in_rdi = kvm_rdi_read(vcpu);
+	if (reg_mask & TDX_VMCALL_REG_MASK_RSI)
+		tdx_vmcall->in_rsi = kvm_rsi_read(vcpu);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R8)
+		tdx_vmcall->in_r8 = kvm_r8_read(vcpu);
+	if (reg_mask & TDX_VMCALL_REG_MASK_R9)
+		tdx_vmcall->in_r9 = kvm_r9_read(vcpu);
+	if (reg_mask & TDX_VMCALL_REG_MASK_RDX)
+		tdx_vmcall->in_rdx = kvm_rdx_read(vcpu);
+
+	/* notify userspace to handle the request */
+	return 0;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	if (tdvmcall_exit_type(vcpu))
@@ -847,8 +933,11 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		break;
 	}
 
-	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
-	return 1;
+	/*
+	 * Unknown VMCALL.  Toss the request to the user space as it may know
+	 * how to handle.
+	 */
+	return tdx_vp_vmcall_to_user(vcpu);
 }
 
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2a47fd0e51fd..24d899f66242 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -251,6 +251,60 @@ struct kvm_xen_exit {
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
+			 * Guest-Host-Communication Interface for TDX spec
+			 * defines the ABI for TDG.VP.VMCALL.
+			 */
+
+			/* Input parameters: guest -> VMM */
+			__u64 type;		/* r10 */
+			__u64 subfunction;	/* r11 */
+			__u64 reg_mask;		/* rcx */
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
+			__u64 status_code;	/* r10 */
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
 
@@ -293,6 +347,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_MEMORY_FAULT     38
+#define KVM_EXIT_TDX              39
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -541,6 +596,8 @@ struct kvm_run {
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

