Return-Path: <kvm+bounces-9730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FDD1866D77
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:03:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 030DE1F24E3A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEFFE129A9B;
	Mon, 26 Feb 2024 08:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KwChySHP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7E8128379;
	Mon, 26 Feb 2024 08:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936146; cv=none; b=qKaAqZGzCD3KAJYSJ+v6n02nMmnHYkCMaTKD7yzEQET6PW/KOeko+wJctoJ6fuOHdvOhBsUbNfZLjiseex7hr8KyL0hzDhiaLkKKzqs7IBSaizs1JMiB5jt130qlwDIlPlxhIN+X+MYkKQ4PADs5LsMZ+Q99iCJuPOqAqhoK6yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936146; c=relaxed/simple;
	bh=gMBjeQic0/mGScZZUcKmn0/6xULcS4yuQddjIJvT7Rg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fR9rryjhrsR/e3JjBm0los0mKTmgID8CH8eagw5WODsQr/5pOj1RHwkMb5zxze+VyanJZFbrRD7YHJo2XYeudcJskojuyfXcG4ATVdO9tWfVOakxGnNxbG5uExrUSd/4k7gdjm1Q01wMp8cjKjpEVl6YlOyb6OikbIWRJYkMrMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KwChySHP; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936145; x=1740472145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gMBjeQic0/mGScZZUcKmn0/6xULcS4yuQddjIJvT7Rg=;
  b=KwChySHPgguaOQDp9/L5zv/yIz+LM1IA9IyGa1QlXXPqHmPKc8UDHXFO
   jRgJhezDafNDdn/KQpioJ9BUpwu1JvIcWC9GO/HXXLQ778thdd3s59PD8
   PFKi3ZW/zKpNYmjr2EWJ6t1FEU3ef0Tl4/CPUVIG6hZVVNOGIhYvMgjLr
   /Fy+S1euZXHXNgtlQnN0TgrcSinG7cVvWvb5avNjnBjkR1UsnF7M4acz9
   HkTLJrig7LvHCbHq4IKKUDovzeVcuVuEIelO/RzeMG1YxXHaS2P4II3o/
   xPDt45I/nksGbJM2wHCm5h54mV8t3ZGJnqwyNKBtvXjvUv3kKoqeZQc7q
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="20751320"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="20751320"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6735058"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:03 -0800
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
Subject: [PATCH v19 106/130] KVM: TDX: Add KVM Exit for TDX TDG.VP.VMCALL
Date: Mon, 26 Feb 2024 00:26:48 -0800
Message-Id: <b9fbb0844fc6505f8fb1e9a783615b299a5a5bb3.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Some of TDG.VP.VMCALL require device model, for example, qemu, to handle
them on behalf of kvm kernel module. TDVMCALL_REPORT_FATAL_ERROR,
TDVMCALL_MAP_GPA, TDVMCALL_SETUP_EVENT_NOTIFY_INTERRUPT, and
TDVMCALL_GET_QUOTE requires user space VMM handling.

Introduce new kvm exit, KVM_EXIT_TDX, and functions to setup it. Device
model should update R10 if necessary as return value.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v14 -> v15:
- updated struct kvm_tdx_exit with union
- export constants for reg bitmask

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c   | 83 ++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h | 89 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 170 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c8eb47591105..72dbe2ff9062 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1038,6 +1038,78 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
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
@@ -1048,8 +1120,15 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		break;
 	}
 
-	tdvmcall_set_return_code(vcpu, TDVMCALL_INVALID_OPERAND);
-	return 1;
+	/*
+	 * Unknown VMCALL.  Toss the request to the user space VMM, e.g. qemu,
+	 * as it may know how to handle.
+	 *
+	 * Those VMCALLs require user space VMM:
+	 * TDVMCALL_REPORT_FATAL_ERROR, TDVMCALL_MAP_GPA,
+	 * TDVMCALL_SETUP_EVENT_NOTIFY_INTERRUPT, and TDVMCALL_GET_QUOTE.
+	 */
+	return tdx_vp_vmcall_to_user(vcpu);
 }
 
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 5e2b28934aa9..a7aa804ef021 100644
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


