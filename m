Return-Path: <kvm+bounces-1739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FD8B7EBD85
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:17:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9BFAB20DC9
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83F2ABA4B;
	Wed, 15 Nov 2023 07:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DQlkLRk5"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC124BA2E
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:17:00 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8FAD1
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032619; x=1731568619;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PFsNAUZ9Gvavp3zd3c68FPhJaJobivZisBodfLKEFmk=;
  b=DQlkLRk5OSFZfD5LhtcHV/sxXRjfP42zuxPs0eQArDmYteMewdkd8Aie
   wIaXBdhI5WP4qXM1RNpZSp3XWOjU+vqEx4DWvPYsBpH9eZkWxZ3oVNDxR
   8GXmb6EkhnWfDrB3YXLy0r+U49Q/jzGq4p9D7Q1cB/lBFMVrycGjU/vzx
   cPU5TcYMQpownRONCl5o5bV0FL3mTiI/z8t1eNRTV1zlMUNO7IohhSE5G
   vVuMdoHDOZjuTG+uh9CPgD+GuzdHBvxIIcuArn9JJkb82orKvOSYt6hBo
   icoqp/r+4xV89hs6wiZVokDpjHS2uICZ6g3ZqkVkabxIhO1UU7S/0Dile
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390622311"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390622311"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:16:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714797433"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714797433"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:16:53 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v3 12/70] *** HACK *** linux-headers: Update headers to pull in TDX API changes
Date: Wed, 15 Nov 2023 02:14:21 -0500
Message-Id: <20231115071519.2864957-13-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pull in recent TDX updates, which are not backwards compatible.

It's just to make this series runnable. It will be updated by script

	scripts/update-linux-headers.sh

once TDX support is upstreamed in linux kernel

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 linux-headers/asm-x86/kvm.h | 91 +++++++++++++++++++++++++++++++++++++
 linux-headers/linux/kvm.h   | 89 ++++++++++++++++++++++++++++++++++++
 2 files changed, 180 insertions(+)

diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 003fb745347c..cf708ea9472e 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -562,5 +562,96 @@ struct kvm_pmu_event_filter {
 
 #define KVM_X86_DEFAULT_VM	0
 #define KVM_X86_SW_PROTECTED_VM	1
+#define KVM_X86_TDX_VM		2
+#define KVM_X86_SNP_VM		3
+
+/* Trust Domain eXtension sub-ioctl() commands. */
+enum kvm_tdx_cmd_id {
+	KVM_TDX_CAPABILITIES = 0,
+	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
+	KVM_TDX_INIT_MEM_REGION,
+	KVM_TDX_FINALIZE_VM,
+	KVM_TDX_RELEASE_VM,
+
+	KVM_TDX_CMD_NR_MAX,
+};
+
+struct kvm_tdx_cmd {
+	/* enum kvm_tdx_cmd_id */
+	__u32 id;
+	/* flags for sub-commend. If sub-command doesn't use this, set zero. */
+	__u32 flags;
+	/*
+	 * data for each sub-command. An immediate or a pointer to the actual
+	 * data in process virtual address.  If sub-command doesn't use it,
+	 * set zero.
+	 */
+	__u64 data;
+	/*
+	 * Auxiliary error code.  The sub-command may return TDX SEAMCALL
+	 * status code in addition to -Exxx.
+	 * Defined for consistency with struct kvm_sev_cmd.
+	 */
+	__u64 error;
+};
+
+struct kvm_tdx_cpuid_config {
+	__u32 leaf;
+	__u32 sub_leaf;
+	__u32 eax;
+	__u32 ebx;
+	__u32 ecx;
+	__u32 edx;
+};
+
+struct kvm_tdx_capabilities {
+	__u64 attrs_fixed0;
+	__u64 attrs_fixed1;
+	__u64 xfam_fixed0;
+	__u64 xfam_fixed1;
+#define TDX_CAP_GPAW_48	(1 << 0)
+#define TDX_CAP_GPAW_52	(1 << 1)
+	__u32 supported_gpaw;
+	__u32 padding;
+	__u64 reserved[251];
+
+	__u32 nr_cpuid_configs;
+	struct kvm_tdx_cpuid_config cpuid_configs[];
+};
+
+struct kvm_tdx_init_vm {
+	__u64 attributes;
+	__u64 mrconfigid[6];	/* sha384 digest */
+	__u64 mrowner[6];	/* sha384 digest */
+	__u64 mrownerconfig[6];	/* sha348 digest */
+	/*
+	 * For future extensibility to make sizeof(struct kvm_tdx_init_vm) = 8KB.
+	 * This should be enough given sizeof(TD_PARAMS) = 1024.
+	 * 8KB was chosen given because
+	 * sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES(=256) = 8KB.
+	 */
+	__u64 reserved[1004];
+
+	/*
+	 * Call KVM_TDX_INIT_VM before vcpu creation, thus before
+	 * KVM_SET_CPUID2.
+	 * This configuration supersedes KVM_SET_CPUID2s for VCPUs because the
+	 * TDX module directly virtualizes those CPUIDs without VMM.  The user
+	 * space VMM, e.g. qemu, should make KVM_SET_CPUID2 consistent with
+	 * those values.  If it doesn't, KVM may have wrong idea of vCPUIDs of
+	 * the guest, and KVM may wrongly emulate CPUIDs or MSRs that the TDX
+	 * module doesn't virtualize.
+	 */
+	struct kvm_cpuid2 cpuid;
+};
+
+#define KVM_TDX_MEASURE_MEMORY_REGION	(1UL << 0)
+
+struct kvm_tdx_init_mem_region {
+	__u64 source_addr;
+	__u64 gpa;
+	__u64 nr_pages;
+};
 
 #endif /* _ASM_X86_KVM_H */
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 3fc87a845ee3..9ecd6336ba1c 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -237,6 +237,92 @@ struct kvm_xen_exit {
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
 
@@ -279,6 +365,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_MEMORY_FAULT     39
+#define KVM_EXIT_TDX              40
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -528,6 +615,8 @@ struct kvm_run {
 			__u64 gpa;
 			__u64 size;
 		} memory_fault;
+		/* KVM_EXIT_TDX_VMCALL */
+		struct kvm_tdx_exit tdx;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.34.1


