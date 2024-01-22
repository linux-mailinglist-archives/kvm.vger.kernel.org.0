Return-Path: <kvm+bounces-6667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 709E6837850
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:13:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9567F1C25797
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10727745C2;
	Mon, 22 Jan 2024 23:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SMrtg2o3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890DF6A32F;
	Mon, 22 Jan 2024 23:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967762; cv=none; b=JOMr0zXTBmpdahBvqK/jXrMqT3eJLzZbTz9P5uCkzNkbrhj+ByoeaOEFAT4EbXkUtGCfwfjQud2nXScCGQSfVPuz5hnaNBP0c+OK3A901zHweUdY2V9y9nukDpOLkX+aLBB2ojiHpYiuuHVuZt3qz3XJMNP7uYbgwqqwbA5vQIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967762; c=relaxed/simple;
	bh=/2cJxNvusE/3zgxZMVpeLxjUmoTXoYYWyne2kQS1Phg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AADGEq6TBnxCpI3baeq3fK4RWgguEmgm1A0+wwT5LAYGnL0oUqxUpG/wh1l5y4WLLPQAR20e9P1s1GPvXEizxoWuTZx5ZJ8K5wh3lqABiynJs29Wu3fMl97t2OnaB4IkFhuUt3Twa5eBEBQ2EqrZ+BsUI+bZfEHkJS/hX5VG5G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SMrtg2o3; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967759; x=1737503759;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/2cJxNvusE/3zgxZMVpeLxjUmoTXoYYWyne2kQS1Phg=;
  b=SMrtg2o3gQ/1uJQ1WNUcLsESxaTqJfm8cBPyz4ZjgU7vcuxCwQQDgdu5
   bn2NuYn9yXyIvnz9ogbM98IBWm+pVIs3MH6BtR6bsTapOLG6c8YMpChej
   yUiiFdfwe7Y3EO1bJczqp83BNtv5LOkWjrcsmmDDuoiHSvSIf/UgGkEiu
   KiPslCb2g6ebVRMSS4Euc+PApKtdu64OP1meB6axGJoF9WNFElfegakgd
   Jx+5Usd2YyGkFQXGw63Es/yZPIID1M43HKv/W8So364RzDjstQ6DxMsoo
   rqu5nKagx8Za42EWq3qNjlQXTPnyD2h0BsHB3R32IwCKcRNxFG7xUQcqG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217850"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217850"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27817969"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:50 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v18 095/121] KVM: TDX: Add KVM Exit for TDX TDG.VP.VMCALL
Date: Mon, 22 Jan 2024 15:54:11 -0800
Message-Id: <576e3c6ca9fa4db50185ee0258546039d290f8ab.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 arch/x86/kvm/vmx/tdx.c   | 84 ++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h | 89 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 171 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d922e3786163..c504c5d9debf 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1088,6 +1088,78 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
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
@@ -1098,8 +1170,16 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
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
index c3308536482b..8426c506ac04 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -167,6 +167,92 @@ struct kvm_xen_exit {
 	} u;
 };
 
+/* masks for reg_mask to indicate which registers are passed. */
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
+
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
 
@@ -210,6 +296,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_TDX              40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -470,6 +557,8 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		/* KVM_EXIT_TDX_VMCALL */
+		struct kvm_tdx_exit tdx;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.25.1


