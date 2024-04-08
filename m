Return-Path: <kvm+bounces-13913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AC5289CC07
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 20:56:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71B681F2227A
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 18:56:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD5591465A9;
	Mon,  8 Apr 2024 18:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WXLfGFes"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7148145B0C;
	Mon,  8 Apr 2024 18:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712602523; cv=none; b=UUla73wVzcSfO/XiC1qWDwG1VDNyKBASn39NhEvrZRt3CI6xyYvSl8iwZQQYN3xnlDAZyq3fBzga9iOVaB6z9LNhgRLRTa0s6fGJQZ8KOa5g8A+7XeCiSTLur9OlFWOlNqm85LwaQR5o1Gunz+yGdk7CcfUo3URsBA0LMXrgE+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712602523; c=relaxed/simple;
	bh=1+8c7f8WJQ5fFnvyZ5KtZF+4P0squ0PWXbvIe1zBr6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+1aNgs9cv5dx7dnxoB6WOsY/cQ/tg1V4J/P7gVxFwDCRkUhzwSjk2ojjGDdzHov/2aSZRPuWY65+7H5vYshS6wTd+Sh8PCp67B/EfUTQWL5v/c5chZnNcC1ZpZbhB2kcCIiIaSdaAYT3bcv5S0kZGLVwX9zZogDka2HlM0q9XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WXLfGFes; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC08C4166C;
	Mon,  8 Apr 2024 18:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712602523;
	bh=1+8c7f8WJQ5fFnvyZ5KtZF+4P0squ0PWXbvIe1zBr6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WXLfGFes6wj9ZESSsb117NkpQtkI11STuLRySKYJ6VyFLWcYf/b+cuZ5aHdtUqLUa
	 XAXIW4/f0jgg3OaLaKISs0YSvp2jIYuDNJp0hirbP7TSqa13dtEWgn7EHCj2SalEbE
	 b7IgR1dqSz392+BgHmleTZubiKNssBcT+9YtTfrtt4onpscW72NajbF5PZbTI82xnJ
	 W5ianMxcFxVb1yfcqo2opgC10eVdBXSQjZEyWp290JIu8x6vBU3KT94gS4QOTsMwcE
	 BjSb77/rbnc+syyLUOmD81QvkxOf3kGuEQ9h+N4PM48tbx3KPNrgcFdglnKtXvTjsU
	 tiC9Dr2N50VDQ==
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Kan Liang <kan.liang@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-perf-users@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH 3/9] tools/include: Sync uapi/linux/kvm.h and asm/kvm.h with the kernel sources
Date: Mon,  8 Apr 2024 11:55:14 -0700
Message-ID: <20240408185520.1550865-4-namhyung@kernel.org>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
In-Reply-To: <20240408185520.1550865-1-namhyung@kernel.org>
References: <20240408185520.1550865-1-namhyung@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To pick up the changes from:

  6bda055d6258 ("KVM: define __KVM_HAVE_GUEST_DEBUG unconditionally")
  5d9cb71642db ("KVM: arm64: move ARM-specific defines to uapi/asm/kvm.h")
  71cd774ad2f9 ("KVM: s390: move s390-specific structs to uapi/asm/kvm.h")
  d750951c9ed7 ("KVM: powerpc: move powerpc-specific structs to uapi/asm/kvm.h")
  bcac0477277e ("KVM: x86: move x86-specific structs to uapi/asm/kvm.h")
  c0a411904e15 ("KVM: remove more traces of device assignment UAPI")
  f3c80061c0d3 ("KVM: SEV: fix compat ABI for KVM_MEMORY_ENCRYPT_OP")

That should be used to beautify the KVM arguments and it addresses these
tools/perf build warnings:

  Warning: Kernel ABI header differences:
    diff -u tools/include/uapi/linux/kvm.h include/uapi/linux/kvm.h
    diff -u tools/arch/x86/include/uapi/asm/kvm.h arch/x86/include/uapi/asm/kvm.h
    diff -u tools/arch/powerpc/include/uapi/asm/kvm.h arch/powerpc/include/uapi/asm/kvm.h
    diff -u tools/arch/s390/include/uapi/asm/kvm.h arch/s390/include/uapi/asm/kvm.h
    diff -u tools/arch/arm64/include/uapi/asm/kvm.h arch/arm64/include/uapi/asm/kvm.h

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/arch/arm64/include/uapi/asm/kvm.h   |  15 +-
 tools/arch/powerpc/include/uapi/asm/kvm.h |  45 +-
 tools/arch/s390/include/uapi/asm/kvm.h    | 315 +++++++++-
 tools/arch/x86/include/uapi/asm/kvm.h     | 308 +++++++++-
 tools/include/uapi/linux/kvm.h            | 689 +---------------------
 5 files changed, 672 insertions(+), 700 deletions(-)

diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
index 89d2fc872d9f..964df31da975 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -37,9 +37,7 @@
 #include <asm/ptrace.h>
 #include <asm/sve_context.h>
 
-#define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_IRQ_LINE
-#define __KVM_HAVE_READONLY_MEM
 #define __KVM_HAVE_VCPU_EVENTS
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
@@ -76,11 +74,11 @@ struct kvm_regs {
 
 /* KVM_ARM_SET_DEVICE_ADDR ioctl id encoding */
 #define KVM_ARM_DEVICE_TYPE_SHIFT	0
-#define KVM_ARM_DEVICE_TYPE_MASK	GENMASK(KVM_ARM_DEVICE_TYPE_SHIFT + 15, \
-						KVM_ARM_DEVICE_TYPE_SHIFT)
+#define KVM_ARM_DEVICE_TYPE_MASK	__GENMASK(KVM_ARM_DEVICE_TYPE_SHIFT + 15, \
+						  KVM_ARM_DEVICE_TYPE_SHIFT)
 #define KVM_ARM_DEVICE_ID_SHIFT		16
-#define KVM_ARM_DEVICE_ID_MASK		GENMASK(KVM_ARM_DEVICE_ID_SHIFT + 15, \
-						KVM_ARM_DEVICE_ID_SHIFT)
+#define KVM_ARM_DEVICE_ID_MASK		__GENMASK(KVM_ARM_DEVICE_ID_SHIFT + 15, \
+						  KVM_ARM_DEVICE_ID_SHIFT)
 
 /* Supported device IDs */
 #define KVM_ARM_DEVICE_VGIC_V2		0
@@ -162,6 +160,11 @@ struct kvm_sync_regs {
 	__u64 device_irq_level;
 };
 
+/* Bits for run->s.regs.device_irq_level */
+#define KVM_ARM_DEV_EL1_VTIMER		(1 << 0)
+#define KVM_ARM_DEV_EL1_PTIMER		(1 << 1)
+#define KVM_ARM_DEV_PMU			(1 << 2)
+
 /*
  * PMU filter structure. Describe a range of events with a particular
  * action. To be used with KVM_ARM_VCPU_PMU_V3_FILTER.
diff --git a/tools/arch/powerpc/include/uapi/asm/kvm.h b/tools/arch/powerpc/include/uapi/asm/kvm.h
index 9f18fa090f1f..1691297a766a 100644
--- a/tools/arch/powerpc/include/uapi/asm/kvm.h
+++ b/tools/arch/powerpc/include/uapi/asm/kvm.h
@@ -28,7 +28,6 @@
 #define __KVM_HAVE_PPC_SMT
 #define __KVM_HAVE_IRQCHIP
 #define __KVM_HAVE_IRQ_LINE
-#define __KVM_HAVE_GUEST_DEBUG
 
 /* Not always available, but if it is, this is the correct offset.  */
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
@@ -733,4 +732,48 @@ struct kvm_ppc_xive_eq {
 #define KVM_XIVE_TIMA_PAGE_OFFSET	0
 #define KVM_XIVE_ESB_PAGE_OFFSET	4
 
+/* for KVM_PPC_GET_PVINFO */
+
+#define KVM_PPC_PVINFO_FLAGS_EV_IDLE   (1<<0)
+
+struct kvm_ppc_pvinfo {
+	/* out */
+	__u32 flags;
+	__u32 hcall[4];
+	__u8  pad[108];
+};
+
+/* for KVM_PPC_GET_SMMU_INFO */
+#define KVM_PPC_PAGE_SIZES_MAX_SZ	8
+
+struct kvm_ppc_one_page_size {
+	__u32 page_shift;	/* Page shift (or 0) */
+	__u32 pte_enc;		/* Encoding in the HPTE (>>12) */
+};
+
+struct kvm_ppc_one_seg_page_size {
+	__u32 page_shift;	/* Base page shift of segment (or 0) */
+	__u32 slb_enc;		/* SLB encoding for BookS */
+	struct kvm_ppc_one_page_size enc[KVM_PPC_PAGE_SIZES_MAX_SZ];
+};
+
+#define KVM_PPC_PAGE_SIZES_REAL		0x00000001
+#define KVM_PPC_1T_SEGMENTS		0x00000002
+#define KVM_PPC_NO_HASH			0x00000004
+
+struct kvm_ppc_smmu_info {
+	__u64 flags;
+	__u32 slb_size;
+	__u16 data_keys;	/* # storage keys supported for data */
+	__u16 instr_keys;	/* # storage keys supported for instructions */
+	struct kvm_ppc_one_seg_page_size sps[KVM_PPC_PAGE_SIZES_MAX_SZ];
+};
+
+/* for KVM_PPC_RESIZE_HPT_{PREPARE,COMMIT} */
+struct kvm_ppc_resize_hpt {
+	__u64 flags;
+	__u32 shift;
+	__u32 pad;
+};
+
 #endif /* __LINUX_KVM_POWERPC_H */
diff --git a/tools/arch/s390/include/uapi/asm/kvm.h b/tools/arch/s390/include/uapi/asm/kvm.h
index abe926d43cbe..05eaf6db3ad4 100644
--- a/tools/arch/s390/include/uapi/asm/kvm.h
+++ b/tools/arch/s390/include/uapi/asm/kvm.h
@@ -12,7 +12,320 @@
 #include <linux/types.h>
 
 #define __KVM_S390
-#define __KVM_HAVE_GUEST_DEBUG
+
+struct kvm_s390_skeys {
+	__u64 start_gfn;
+	__u64 count;
+	__u64 skeydata_addr;
+	__u32 flags;
+	__u32 reserved[9];
+};
+
+#define KVM_S390_CMMA_PEEK (1 << 0)
+
+/**
+ * kvm_s390_cmma_log - Used for CMMA migration.
+ *
+ * Used both for input and output.
+ *
+ * @start_gfn: Guest page number to start from.
+ * @count: Size of the result buffer.
+ * @flags: Control operation mode via KVM_S390_CMMA_* flags
+ * @remaining: Used with KVM_S390_GET_CMMA_BITS. Indicates how many dirty
+ *             pages are still remaining.
+ * @mask: Used with KVM_S390_SET_CMMA_BITS. Bitmap of bits to actually set
+ *        in the PGSTE.
+ * @values: Pointer to the values buffer.
+ *
+ * Used in KVM_S390_{G,S}ET_CMMA_BITS ioctls.
+ */
+struct kvm_s390_cmma_log {
+	__u64 start_gfn;
+	__u32 count;
+	__u32 flags;
+	union {
+		__u64 remaining;
+		__u64 mask;
+	};
+	__u64 values;
+};
+
+#define KVM_S390_RESET_POR       1
+#define KVM_S390_RESET_CLEAR     2
+#define KVM_S390_RESET_SUBSYSTEM 4
+#define KVM_S390_RESET_CPU_INIT  8
+#define KVM_S390_RESET_IPL       16
+
+/* for KVM_S390_MEM_OP */
+struct kvm_s390_mem_op {
+	/* in */
+	__u64 gaddr;		/* the guest address */
+	__u64 flags;		/* flags */
+	__u32 size;		/* amount of bytes */
+	__u32 op;		/* type of operation */
+	__u64 buf;		/* buffer in userspace */
+	union {
+		struct {
+			__u8 ar;	/* the access register number */
+			__u8 key;	/* access key, ignored if flag unset */
+			__u8 pad1[6];	/* ignored */
+			__u64 old_addr;	/* ignored if cmpxchg flag unset */
+		};
+		__u32 sida_offset; /* offset into the sida */
+		__u8 reserved[32]; /* ignored */
+	};
+};
+/* types for kvm_s390_mem_op->op */
+#define KVM_S390_MEMOP_LOGICAL_READ	0
+#define KVM_S390_MEMOP_LOGICAL_WRITE	1
+#define KVM_S390_MEMOP_SIDA_READ	2
+#define KVM_S390_MEMOP_SIDA_WRITE	3
+#define KVM_S390_MEMOP_ABSOLUTE_READ	4
+#define KVM_S390_MEMOP_ABSOLUTE_WRITE	5
+#define KVM_S390_MEMOP_ABSOLUTE_CMPXCHG	6
+
+/* flags for kvm_s390_mem_op->flags */
+#define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
+#define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
+#define KVM_S390_MEMOP_F_SKEY_PROTECTION	(1ULL << 2)
+
+/* flags specifying extension support via KVM_CAP_S390_MEM_OP_EXTENSION */
+#define KVM_S390_MEMOP_EXTENSION_CAP_BASE	(1 << 0)
+#define KVM_S390_MEMOP_EXTENSION_CAP_CMPXCHG	(1 << 1)
+
+struct kvm_s390_psw {
+	__u64 mask;
+	__u64 addr;
+};
+
+/* valid values for type in kvm_s390_interrupt */
+#define KVM_S390_SIGP_STOP		0xfffe0000u
+#define KVM_S390_PROGRAM_INT		0xfffe0001u
+#define KVM_S390_SIGP_SET_PREFIX	0xfffe0002u
+#define KVM_S390_RESTART		0xfffe0003u
+#define KVM_S390_INT_PFAULT_INIT	0xfffe0004u
+#define KVM_S390_INT_PFAULT_DONE	0xfffe0005u
+#define KVM_S390_MCHK			0xfffe1000u
+#define KVM_S390_INT_CLOCK_COMP		0xffff1004u
+#define KVM_S390_INT_CPU_TIMER		0xffff1005u
+#define KVM_S390_INT_VIRTIO		0xffff2603u
+#define KVM_S390_INT_SERVICE		0xffff2401u
+#define KVM_S390_INT_EMERGENCY		0xffff1201u
+#define KVM_S390_INT_EXTERNAL_CALL	0xffff1202u
+/* Anything below 0xfffe0000u is taken by INT_IO */
+#define KVM_S390_INT_IO(ai,cssid,ssid,schid)   \
+	(((schid)) |			       \
+	 ((ssid) << 16) |		       \
+	 ((cssid) << 18) |		       \
+	 ((ai) << 26))
+#define KVM_S390_INT_IO_MIN		0x00000000u
+#define KVM_S390_INT_IO_MAX		0xfffdffffu
+#define KVM_S390_INT_IO_AI_MASK		0x04000000u
+
+
+struct kvm_s390_interrupt {
+	__u32 type;
+	__u32 parm;
+	__u64 parm64;
+};
+
+struct kvm_s390_io_info {
+	__u16 subchannel_id;
+	__u16 subchannel_nr;
+	__u32 io_int_parm;
+	__u32 io_int_word;
+};
+
+struct kvm_s390_ext_info {
+	__u32 ext_params;
+	__u32 pad;
+	__u64 ext_params2;
+};
+
+struct kvm_s390_pgm_info {
+	__u64 trans_exc_code;
+	__u64 mon_code;
+	__u64 per_address;
+	__u32 data_exc_code;
+	__u16 code;
+	__u16 mon_class_nr;
+	__u8 per_code;
+	__u8 per_atmid;
+	__u8 exc_access_id;
+	__u8 per_access_id;
+	__u8 op_access_id;
+#define KVM_S390_PGM_FLAGS_ILC_VALID	0x01
+#define KVM_S390_PGM_FLAGS_ILC_0	0x02
+#define KVM_S390_PGM_FLAGS_ILC_1	0x04
+#define KVM_S390_PGM_FLAGS_ILC_MASK	0x06
+#define KVM_S390_PGM_FLAGS_NO_REWIND	0x08
+	__u8 flags;
+	__u8 pad[2];
+};
+
+struct kvm_s390_prefix_info {
+	__u32 address;
+};
+
+struct kvm_s390_extcall_info {
+	__u16 code;
+};
+
+struct kvm_s390_emerg_info {
+	__u16 code;
+};
+
+#define KVM_S390_STOP_FLAG_STORE_STATUS	0x01
+struct kvm_s390_stop_info {
+	__u32 flags;
+};
+
+struct kvm_s390_mchk_info {
+	__u64 cr14;
+	__u64 mcic;
+	__u64 failing_storage_address;
+	__u32 ext_damage_code;
+	__u32 pad;
+	__u8 fixed_logout[16];
+};
+
+struct kvm_s390_irq {
+	__u64 type;
+	union {
+		struct kvm_s390_io_info io;
+		struct kvm_s390_ext_info ext;
+		struct kvm_s390_pgm_info pgm;
+		struct kvm_s390_emerg_info emerg;
+		struct kvm_s390_extcall_info extcall;
+		struct kvm_s390_prefix_info prefix;
+		struct kvm_s390_stop_info stop;
+		struct kvm_s390_mchk_info mchk;
+		char reserved[64];
+	} u;
+};
+
+struct kvm_s390_irq_state {
+	__u64 buf;
+	__u32 flags;        /* will stay unused for compatibility reasons */
+	__u32 len;
+	__u32 reserved[4];  /* will stay unused for compatibility reasons */
+};
+
+struct kvm_s390_ucas_mapping {
+	__u64 user_addr;
+	__u64 vcpu_addr;
+	__u64 length;
+};
+
+struct kvm_s390_pv_sec_parm {
+	__u64 origin;
+	__u64 length;
+};
+
+struct kvm_s390_pv_unp {
+	__u64 addr;
+	__u64 size;
+	__u64 tweak;
+};
+
+enum pv_cmd_dmp_id {
+	KVM_PV_DUMP_INIT,
+	KVM_PV_DUMP_CONFIG_STOR_STATE,
+	KVM_PV_DUMP_COMPLETE,
+	KVM_PV_DUMP_CPU,
+};
+
+struct kvm_s390_pv_dmp {
+	__u64 subcmd;
+	__u64 buff_addr;
+	__u64 buff_len;
+	__u64 gaddr;		/* For dump storage state */
+	__u64 reserved[4];
+};
+
+enum pv_cmd_info_id {
+	KVM_PV_INFO_VM,
+	KVM_PV_INFO_DUMP,
+};
+
+struct kvm_s390_pv_info_dump {
+	__u64 dump_cpu_buffer_len;
+	__u64 dump_config_mem_buffer_per_1m;
+	__u64 dump_config_finalize_len;
+};
+
+struct kvm_s390_pv_info_vm {
+	__u64 inst_calls_list[4];
+	__u64 max_cpus;
+	__u64 max_guests;
+	__u64 max_guest_addr;
+	__u64 feature_indication;
+};
+
+struct kvm_s390_pv_info_header {
+	__u32 id;
+	__u32 len_max;
+	__u32 len_written;
+	__u32 reserved;
+};
+
+struct kvm_s390_pv_info {
+	struct kvm_s390_pv_info_header header;
+	union {
+		struct kvm_s390_pv_info_dump dump;
+		struct kvm_s390_pv_info_vm vm;
+	};
+};
+
+enum pv_cmd_id {
+	KVM_PV_ENABLE,
+	KVM_PV_DISABLE,
+	KVM_PV_SET_SEC_PARMS,
+	KVM_PV_UNPACK,
+	KVM_PV_VERIFY,
+	KVM_PV_PREP_RESET,
+	KVM_PV_UNSHARE_ALL,
+	KVM_PV_INFO,
+	KVM_PV_DUMP,
+	KVM_PV_ASYNC_CLEANUP_PREPARE,
+	KVM_PV_ASYNC_CLEANUP_PERFORM,
+};
+
+struct kvm_pv_cmd {
+	__u32 cmd;	/* Command to be executed */
+	__u16 rc;	/* Ultravisor return code */
+	__u16 rrc;	/* Ultravisor return reason code */
+	__u64 data;	/* Data or address */
+	__u32 flags;    /* flags for future extensions. Must be 0 for now */
+	__u32 reserved[3];
+};
+
+struct kvm_s390_zpci_op {
+	/* in */
+	__u32 fh;               /* target device */
+	__u8  op;               /* operation to perform */
+	__u8  pad[3];
+	union {
+		/* for KVM_S390_ZPCIOP_REG_AEN */
+		struct {
+			__u64 ibv;      /* Guest addr of interrupt bit vector */
+			__u64 sb;       /* Guest addr of summary bit */
+			__u32 flags;
+			__u32 noi;      /* Number of interrupts */
+			__u8 isc;       /* Guest interrupt subclass */
+			__u8 sbo;       /* Offset of guest summary bit vector */
+			__u16 pad;
+		} reg_aen;
+		__u64 reserved[8];
+	} u;
+};
+
+/* types for kvm_s390_zpci_op->op */
+#define KVM_S390_ZPCIOP_REG_AEN                0
+#define KVM_S390_ZPCIOP_DEREG_AEN      1
+
+/* flags for kvm_s390_zpci_op->u.reg_aen.flags */
+#define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
 
 /* Device control API: s390-specific devices */
 #define KVM_DEV_FLIC_GET_ALL_IRQS	1
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index a448d0964fc0..ef11aa4cab42 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -7,6 +7,8 @@
  *
  */
 
+#include <linux/const.h>
+#include <linux/bits.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/stddef.h>
@@ -40,7 +42,6 @@
 #define __KVM_HAVE_IRQ_LINE
 #define __KVM_HAVE_MSI
 #define __KVM_HAVE_USER_NMI
-#define __KVM_HAVE_GUEST_DEBUG
 #define __KVM_HAVE_MSIX
 #define __KVM_HAVE_MCE
 #define __KVM_HAVE_PIT_STATE2
@@ -49,7 +50,6 @@
 #define __KVM_HAVE_DEBUGREGS
 #define __KVM_HAVE_XSAVE
 #define __KVM_HAVE_XCRS
-#define __KVM_HAVE_READONLY_MEM
 
 /* Architectural interrupt line count. */
 #define KVM_NR_INTERRUPTS 256
@@ -526,9 +526,301 @@ struct kvm_pmu_event_filter {
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
-#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS BIT(0)
+#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS _BITUL(0)
 #define KVM_PMU_EVENT_FLAGS_VALID_MASK (KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
 
+/* for KVM_CAP_MCE */
+struct kvm_x86_mce {
+	__u64 status;
+	__u64 addr;
+	__u64 misc;
+	__u64 mcg_status;
+	__u8 bank;
+	__u8 pad1[7];
+	__u64 pad2[3];
+};
+
+/* for KVM_CAP_XEN_HVM */
+#define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
+#define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
+#define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
+#define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
+#define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
+#define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
+#define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
+#define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
+#define KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA	(1 << 8)
+
+struct kvm_xen_hvm_config {
+	__u32 flags;
+	__u32 msr;
+	__u64 blob_addr_32;
+	__u64 blob_addr_64;
+	__u8 blob_size_32;
+	__u8 blob_size_64;
+	__u8 pad2[30];
+};
+
+struct kvm_xen_hvm_attr {
+	__u16 type;
+	__u16 pad[3];
+	union {
+		__u8 long_mode;
+		__u8 vector;
+		__u8 runstate_update_flag;
+		union {
+			__u64 gfn;
+#define KVM_XEN_INVALID_GFN ((__u64)-1)
+			__u64 hva;
+		} shared_info;
+		struct {
+			__u32 send_port;
+			__u32 type; /* EVTCHNSTAT_ipi / EVTCHNSTAT_interdomain */
+			__u32 flags;
+#define KVM_XEN_EVTCHN_DEASSIGN		(1 << 0)
+#define KVM_XEN_EVTCHN_UPDATE		(1 << 1)
+#define KVM_XEN_EVTCHN_RESET		(1 << 2)
+			/*
+			 * Events sent by the guest are either looped back to
+			 * the guest itself (potentially on a different port#)
+			 * or signalled via an eventfd.
+			 */
+			union {
+				struct {
+					__u32 port;
+					__u32 vcpu;
+					__u32 priority;
+				} port;
+				struct {
+					__u32 port; /* Zero for eventfd */
+					__s32 fd;
+				} eventfd;
+				__u32 padding[4];
+			} deliver;
+		} evtchn;
+		__u32 xen_version;
+		__u64 pad[8];
+	} u;
+};
+
+
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
+#define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
+#define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
+#define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x2
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
+#define KVM_XEN_ATTR_TYPE_EVTCHN		0x3
+#define KVM_XEN_ATTR_TYPE_XEN_VERSION		0x4
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG */
+#define KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG	0x5
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA */
+#define KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA	0x6
+
+struct kvm_xen_vcpu_attr {
+	__u16 type;
+	__u16 pad[3];
+	union {
+		__u64 gpa;
+#define KVM_XEN_INVALID_GPA ((__u64)-1)
+		__u64 hva;
+		__u64 pad[8];
+		struct {
+			__u64 state;
+			__u64 state_entry_time;
+			__u64 time_running;
+			__u64 time_runnable;
+			__u64 time_blocked;
+			__u64 time_offline;
+		} runstate;
+		__u32 vcpu_id;
+		struct {
+			__u32 port;
+			__u32 priority;
+			__u64 expires_ns;
+		} timer;
+		__u8 vector;
+	} u;
+};
+
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO	0x0
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO	0x1
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR	0x2
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT	0x3
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA	0x4
+#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST	0x5
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID		0x6
+#define KVM_XEN_VCPU_ATTR_TYPE_TIMER		0x7
+#define KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR	0x8
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO_HVA */
+#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO_HVA	0x9
+
+/* Secure Encrypted Virtualization command */
+enum sev_cmd_id {
+	/* Guest initialization commands */
+	KVM_SEV_INIT = 0,
+	KVM_SEV_ES_INIT,
+	/* Guest launch commands */
+	KVM_SEV_LAUNCH_START,
+	KVM_SEV_LAUNCH_UPDATE_DATA,
+	KVM_SEV_LAUNCH_UPDATE_VMSA,
+	KVM_SEV_LAUNCH_SECRET,
+	KVM_SEV_LAUNCH_MEASURE,
+	KVM_SEV_LAUNCH_FINISH,
+	/* Guest migration commands (outgoing) */
+	KVM_SEV_SEND_START,
+	KVM_SEV_SEND_UPDATE_DATA,
+	KVM_SEV_SEND_UPDATE_VMSA,
+	KVM_SEV_SEND_FINISH,
+	/* Guest migration commands (incoming) */
+	KVM_SEV_RECEIVE_START,
+	KVM_SEV_RECEIVE_UPDATE_DATA,
+	KVM_SEV_RECEIVE_UPDATE_VMSA,
+	KVM_SEV_RECEIVE_FINISH,
+	/* Guest status and debug commands */
+	KVM_SEV_GUEST_STATUS,
+	KVM_SEV_DBG_DECRYPT,
+	KVM_SEV_DBG_ENCRYPT,
+	/* Guest certificates commands */
+	KVM_SEV_CERT_EXPORT,
+	/* Attestation report */
+	KVM_SEV_GET_ATTESTATION_REPORT,
+	/* Guest Migration Extension */
+	KVM_SEV_SEND_CANCEL,
+
+	KVM_SEV_NR_MAX,
+};
+
+struct kvm_sev_cmd {
+	__u32 id;
+	__u32 pad0;
+	__u64 data;
+	__u32 error;
+	__u32 sev_fd;
+};
+
+struct kvm_sev_launch_start {
+	__u32 handle;
+	__u32 policy;
+	__u64 dh_uaddr;
+	__u32 dh_len;
+	__u32 pad0;
+	__u64 session_uaddr;
+	__u32 session_len;
+	__u32 pad1;
+};
+
+struct kvm_sev_launch_update_data {
+	__u64 uaddr;
+	__u32 len;
+	__u32 pad0;
+};
+
+
+struct kvm_sev_launch_secret {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u32 pad0;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u32 pad1;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+	__u32 pad2;
+};
+
+struct kvm_sev_launch_measure {
+	__u64 uaddr;
+	__u32 len;
+	__u32 pad0;
+};
+
+struct kvm_sev_guest_status {
+	__u32 handle;
+	__u32 policy;
+	__u32 state;
+};
+
+struct kvm_sev_dbg {
+	__u64 src_uaddr;
+	__u64 dst_uaddr;
+	__u32 len;
+	__u32 pad0;
+};
+
+struct kvm_sev_attestation_report {
+	__u8 mnonce[16];
+	__u64 uaddr;
+	__u32 len;
+	__u32 pad0;
+};
+
+struct kvm_sev_send_start {
+	__u32 policy;
+	__u32 pad0;
+	__u64 pdh_cert_uaddr;
+	__u32 pdh_cert_len;
+	__u32 pad1;
+	__u64 plat_certs_uaddr;
+	__u32 plat_certs_len;
+	__u32 pad2;
+	__u64 amd_certs_uaddr;
+	__u32 amd_certs_len;
+	__u32 pad3;
+	__u64 session_uaddr;
+	__u32 session_len;
+	__u32 pad4;
+};
+
+struct kvm_sev_send_update_data {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u32 pad0;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u32 pad1;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+	__u32 pad2;
+};
+
+struct kvm_sev_receive_start {
+	__u32 handle;
+	__u32 policy;
+	__u64 pdh_uaddr;
+	__u32 pdh_len;
+	__u32 pad0;
+	__u64 session_uaddr;
+	__u32 session_len;
+	__u32 pad1;
+};
+
+struct kvm_sev_receive_update_data {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u32 pad0;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u32 pad1;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+	__u32 pad2;
+};
+
+#define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
+#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
+
+struct kvm_hyperv_eventfd {
+	__u32 conn_id;
+	__s32 fd;
+	__u32 flags;
+	__u32 padding[3];
+};
+
+#define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
+#define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
+
 /*
  * Masked event layout.
  * Bits   Description
@@ -549,10 +841,10 @@ struct kvm_pmu_event_filter {
 	((__u64)(!!(exclude)) << 55))
 
 #define KVM_PMU_MASKED_ENTRY_EVENT_SELECT \
-	(GENMASK_ULL(7, 0) | GENMASK_ULL(35, 32))
-#define KVM_PMU_MASKED_ENTRY_UMASK_MASK		(GENMASK_ULL(63, 56))
-#define KVM_PMU_MASKED_ENTRY_UMASK_MATCH	(GENMASK_ULL(15, 8))
-#define KVM_PMU_MASKED_ENTRY_EXCLUDE		(BIT_ULL(55))
+	(__GENMASK_ULL(7, 0) | __GENMASK_ULL(35, 32))
+#define KVM_PMU_MASKED_ENTRY_UMASK_MASK		(__GENMASK_ULL(63, 56))
+#define KVM_PMU_MASKED_ENTRY_UMASK_MATCH	(__GENMASK_ULL(15, 8))
+#define KVM_PMU_MASKED_ENTRY_EXCLUDE		(_BITULL(55))
 #define KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT	(56)
 
 /* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
@@ -560,7 +852,7 @@ struct kvm_pmu_event_filter {
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
 
 /* x86-specific KVM_EXIT_HYPERCALL flags. */
-#define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
+#define KVM_EXIT_HYPERCALL_LONG_MODE	_BITULL(0)
 
 #define KVM_X86_DEFAULT_VM	0
 #define KVM_X86_SW_PROTECTED_VM	1
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index c3308536482b..2190adbe3002 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -16,6 +16,11 @@
 
 #define KVM_API_VERSION 12
 
+/*
+ * Backwards-compatible definitions.
+ */
+#define __KVM_HAVE_GUEST_DEBUG
+
 /* for KVM_SET_USER_MEMORY_REGION */
 struct kvm_userspace_memory_region {
 	__u32 slot;
@@ -85,43 +90,6 @@ struct kvm_pit_config {
 
 #define KVM_PIT_SPEAKER_DUMMY     1
 
-struct kvm_s390_skeys {
-	__u64 start_gfn;
-	__u64 count;
-	__u64 skeydata_addr;
-	__u32 flags;
-	__u32 reserved[9];
-};
-
-#define KVM_S390_CMMA_PEEK (1 << 0)
-
-/**
- * kvm_s390_cmma_log - Used for CMMA migration.
- *
- * Used both for input and output.
- *
- * @start_gfn: Guest page number to start from.
- * @count: Size of the result buffer.
- * @flags: Control operation mode via KVM_S390_CMMA_* flags
- * @remaining: Used with KVM_S390_GET_CMMA_BITS. Indicates how many dirty
- *             pages are still remaining.
- * @mask: Used with KVM_S390_SET_CMMA_BITS. Bitmap of bits to actually set
- *        in the PGSTE.
- * @values: Pointer to the values buffer.
- *
- * Used in KVM_S390_{G,S}ET_CMMA_BITS ioctls.
- */
-struct kvm_s390_cmma_log {
-	__u64 start_gfn;
-	__u32 count;
-	__u32 flags;
-	union {
-		__u64 remaining;
-		__u64 mask;
-	};
-	__u64 values;
-};
-
 struct kvm_hyperv_exit {
 #define KVM_EXIT_HYPERV_SYNIC          1
 #define KVM_EXIT_HYPERV_HCALL          2
@@ -315,11 +283,6 @@ struct kvm_run {
 			__u32 ipb;
 		} s390_sieic;
 		/* KVM_EXIT_S390_RESET */
-#define KVM_S390_RESET_POR       1
-#define KVM_S390_RESET_CLEAR     2
-#define KVM_S390_RESET_SUBSYSTEM 4
-#define KVM_S390_RESET_CPU_INIT  8
-#define KVM_S390_RESET_IPL       16
 		__u64 s390_reset_flags;
 		/* KVM_EXIT_S390_UCONTROL */
 		struct {
@@ -536,43 +499,6 @@ struct kvm_translation {
 	__u8  pad[5];
 };
 
-/* for KVM_S390_MEM_OP */
-struct kvm_s390_mem_op {
-	/* in */
-	__u64 gaddr;		/* the guest address */
-	__u64 flags;		/* flags */
-	__u32 size;		/* amount of bytes */
-	__u32 op;		/* type of operation */
-	__u64 buf;		/* buffer in userspace */
-	union {
-		struct {
-			__u8 ar;	/* the access register number */
-			__u8 key;	/* access key, ignored if flag unset */
-			__u8 pad1[6];	/* ignored */
-			__u64 old_addr;	/* ignored if cmpxchg flag unset */
-		};
-		__u32 sida_offset; /* offset into the sida */
-		__u8 reserved[32]; /* ignored */
-	};
-};
-/* types for kvm_s390_mem_op->op */
-#define KVM_S390_MEMOP_LOGICAL_READ	0
-#define KVM_S390_MEMOP_LOGICAL_WRITE	1
-#define KVM_S390_MEMOP_SIDA_READ	2
-#define KVM_S390_MEMOP_SIDA_WRITE	3
-#define KVM_S390_MEMOP_ABSOLUTE_READ	4
-#define KVM_S390_MEMOP_ABSOLUTE_WRITE	5
-#define KVM_S390_MEMOP_ABSOLUTE_CMPXCHG	6
-
-/* flags for kvm_s390_mem_op->flags */
-#define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
-#define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
-#define KVM_S390_MEMOP_F_SKEY_PROTECTION	(1ULL << 2)
-
-/* flags specifying extension support via KVM_CAP_S390_MEM_OP_EXTENSION */
-#define KVM_S390_MEMOP_EXTENSION_CAP_BASE	(1 << 0)
-#define KVM_S390_MEMOP_EXTENSION_CAP_CMPXCHG	(1 << 1)
-
 /* for KVM_INTERRUPT */
 struct kvm_interrupt {
 	/* in */
@@ -637,124 +563,6 @@ struct kvm_mp_state {
 	__u32 mp_state;
 };
 
-struct kvm_s390_psw {
-	__u64 mask;
-	__u64 addr;
-};
-
-/* valid values for type in kvm_s390_interrupt */
-#define KVM_S390_SIGP_STOP		0xfffe0000u
-#define KVM_S390_PROGRAM_INT		0xfffe0001u
-#define KVM_S390_SIGP_SET_PREFIX	0xfffe0002u
-#define KVM_S390_RESTART		0xfffe0003u
-#define KVM_S390_INT_PFAULT_INIT	0xfffe0004u
-#define KVM_S390_INT_PFAULT_DONE	0xfffe0005u
-#define KVM_S390_MCHK			0xfffe1000u
-#define KVM_S390_INT_CLOCK_COMP		0xffff1004u
-#define KVM_S390_INT_CPU_TIMER		0xffff1005u
-#define KVM_S390_INT_VIRTIO		0xffff2603u
-#define KVM_S390_INT_SERVICE		0xffff2401u
-#define KVM_S390_INT_EMERGENCY		0xffff1201u
-#define KVM_S390_INT_EXTERNAL_CALL	0xffff1202u
-/* Anything below 0xfffe0000u is taken by INT_IO */
-#define KVM_S390_INT_IO(ai,cssid,ssid,schid)   \
-	(((schid)) |			       \
-	 ((ssid) << 16) |		       \
-	 ((cssid) << 18) |		       \
-	 ((ai) << 26))
-#define KVM_S390_INT_IO_MIN		0x00000000u
-#define KVM_S390_INT_IO_MAX		0xfffdffffu
-#define KVM_S390_INT_IO_AI_MASK		0x04000000u
-
-
-struct kvm_s390_interrupt {
-	__u32 type;
-	__u32 parm;
-	__u64 parm64;
-};
-
-struct kvm_s390_io_info {
-	__u16 subchannel_id;
-	__u16 subchannel_nr;
-	__u32 io_int_parm;
-	__u32 io_int_word;
-};
-
-struct kvm_s390_ext_info {
-	__u32 ext_params;
-	__u32 pad;
-	__u64 ext_params2;
-};
-
-struct kvm_s390_pgm_info {
-	__u64 trans_exc_code;
-	__u64 mon_code;
-	__u64 per_address;
-	__u32 data_exc_code;
-	__u16 code;
-	__u16 mon_class_nr;
-	__u8 per_code;
-	__u8 per_atmid;
-	__u8 exc_access_id;
-	__u8 per_access_id;
-	__u8 op_access_id;
-#define KVM_S390_PGM_FLAGS_ILC_VALID	0x01
-#define KVM_S390_PGM_FLAGS_ILC_0	0x02
-#define KVM_S390_PGM_FLAGS_ILC_1	0x04
-#define KVM_S390_PGM_FLAGS_ILC_MASK	0x06
-#define KVM_S390_PGM_FLAGS_NO_REWIND	0x08
-	__u8 flags;
-	__u8 pad[2];
-};
-
-struct kvm_s390_prefix_info {
-	__u32 address;
-};
-
-struct kvm_s390_extcall_info {
-	__u16 code;
-};
-
-struct kvm_s390_emerg_info {
-	__u16 code;
-};
-
-#define KVM_S390_STOP_FLAG_STORE_STATUS	0x01
-struct kvm_s390_stop_info {
-	__u32 flags;
-};
-
-struct kvm_s390_mchk_info {
-	__u64 cr14;
-	__u64 mcic;
-	__u64 failing_storage_address;
-	__u32 ext_damage_code;
-	__u32 pad;
-	__u8 fixed_logout[16];
-};
-
-struct kvm_s390_irq {
-	__u64 type;
-	union {
-		struct kvm_s390_io_info io;
-		struct kvm_s390_ext_info ext;
-		struct kvm_s390_pgm_info pgm;
-		struct kvm_s390_emerg_info emerg;
-		struct kvm_s390_extcall_info extcall;
-		struct kvm_s390_prefix_info prefix;
-		struct kvm_s390_stop_info stop;
-		struct kvm_s390_mchk_info mchk;
-		char reserved[64];
-	} u;
-};
-
-struct kvm_s390_irq_state {
-	__u64 buf;
-	__u32 flags;        /* will stay unused for compatibility reasons */
-	__u32 len;
-	__u32 reserved[4];  /* will stay unused for compatibility reasons */
-};
-
 /* for KVM_SET_GUEST_DEBUG */
 
 #define KVM_GUESTDBG_ENABLE		0x00000001
@@ -810,50 +618,6 @@ struct kvm_enable_cap {
 	__u8  pad[64];
 };
 
-/* for KVM_PPC_GET_PVINFO */
-
-#define KVM_PPC_PVINFO_FLAGS_EV_IDLE   (1<<0)
-
-struct kvm_ppc_pvinfo {
-	/* out */
-	__u32 flags;
-	__u32 hcall[4];
-	__u8  pad[108];
-};
-
-/* for KVM_PPC_GET_SMMU_INFO */
-#define KVM_PPC_PAGE_SIZES_MAX_SZ	8
-
-struct kvm_ppc_one_page_size {
-	__u32 page_shift;	/* Page shift (or 0) */
-	__u32 pte_enc;		/* Encoding in the HPTE (>>12) */
-};
-
-struct kvm_ppc_one_seg_page_size {
-	__u32 page_shift;	/* Base page shift of segment (or 0) */
-	__u32 slb_enc;		/* SLB encoding for BookS */
-	struct kvm_ppc_one_page_size enc[KVM_PPC_PAGE_SIZES_MAX_SZ];
-};
-
-#define KVM_PPC_PAGE_SIZES_REAL		0x00000001
-#define KVM_PPC_1T_SEGMENTS		0x00000002
-#define KVM_PPC_NO_HASH			0x00000004
-
-struct kvm_ppc_smmu_info {
-	__u64 flags;
-	__u32 slb_size;
-	__u16 data_keys;	/* # storage keys supported for data */
-	__u16 instr_keys;	/* # storage keys supported for instructions */
-	struct kvm_ppc_one_seg_page_size sps[KVM_PPC_PAGE_SIZES_MAX_SZ];
-};
-
-/* for KVM_PPC_RESIZE_HPT_{PREPARE,COMMIT} */
-struct kvm_ppc_resize_hpt {
-	__u64 flags;
-	__u32 shift;
-	__u32 pad;
-};
-
 #define KVMIO 0xAE
 
 /* machine type bits, to be used as argument to KVM_CREATE_VM */
@@ -923,9 +687,7 @@ struct kvm_ppc_resize_hpt {
 /* Bug in KVM_SET_USER_MEMORY_REGION fixed: */
 #define KVM_CAP_DESTROY_MEMORY_REGION_WORKS 21
 #define KVM_CAP_USER_NMI 22
-#ifdef __KVM_HAVE_GUEST_DEBUG
 #define KVM_CAP_SET_GUEST_DEBUG 23
-#endif
 #ifdef __KVM_HAVE_PIT
 #define KVM_CAP_REINJECT_CONTROL 24
 #endif
@@ -1156,8 +918,6 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
 
-#ifdef KVM_CAP_IRQ_ROUTING
-
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
 	__u32 pin;
@@ -1222,42 +982,6 @@ struct kvm_irq_routing {
 	struct kvm_irq_routing_entry entries[];
 };
 
-#endif
-
-#ifdef KVM_CAP_MCE
-/* x86 MCE */
-struct kvm_x86_mce {
-	__u64 status;
-	__u64 addr;
-	__u64 misc;
-	__u64 mcg_status;
-	__u8 bank;
-	__u8 pad1[7];
-	__u64 pad2[3];
-};
-#endif
-
-#ifdef KVM_CAP_XEN_HVM
-#define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
-#define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
-#define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
-#define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
-#define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
-#define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
-#define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
-#define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
-
-struct kvm_xen_hvm_config {
-	__u32 flags;
-	__u32 msr;
-	__u64 blob_addr_32;
-	__u64 blob_addr_64;
-	__u8 blob_size_32;
-	__u8 blob_size_64;
-	__u8 pad2[30];
-};
-#endif
-
 #define KVM_IRQFD_FLAG_DEASSIGN (1 << 0)
 /*
  * Available with KVM_CAP_IRQFD_RESAMPLE
@@ -1442,11 +1166,6 @@ struct kvm_vfio_spapr_tce {
 					 struct kvm_userspace_memory_region2)
 
 /* enable ucontrol for s390 */
-struct kvm_s390_ucas_mapping {
-	__u64 user_addr;
-	__u64 vcpu_addr;
-	__u64 length;
-};
 #define KVM_S390_UCAS_MAP        _IOW(KVMIO, 0x50, struct kvm_s390_ucas_mapping)
 #define KVM_S390_UCAS_UNMAP      _IOW(KVMIO, 0x51, struct kvm_s390_ucas_mapping)
 #define KVM_S390_VCPU_FAULT	 _IOW(KVMIO, 0x52, unsigned long)
@@ -1641,89 +1360,6 @@ struct kvm_enc_region {
 #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
 #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
 
-struct kvm_s390_pv_sec_parm {
-	__u64 origin;
-	__u64 length;
-};
-
-struct kvm_s390_pv_unp {
-	__u64 addr;
-	__u64 size;
-	__u64 tweak;
-};
-
-enum pv_cmd_dmp_id {
-	KVM_PV_DUMP_INIT,
-	KVM_PV_DUMP_CONFIG_STOR_STATE,
-	KVM_PV_DUMP_COMPLETE,
-	KVM_PV_DUMP_CPU,
-};
-
-struct kvm_s390_pv_dmp {
-	__u64 subcmd;
-	__u64 buff_addr;
-	__u64 buff_len;
-	__u64 gaddr;		/* For dump storage state */
-	__u64 reserved[4];
-};
-
-enum pv_cmd_info_id {
-	KVM_PV_INFO_VM,
-	KVM_PV_INFO_DUMP,
-};
-
-struct kvm_s390_pv_info_dump {
-	__u64 dump_cpu_buffer_len;
-	__u64 dump_config_mem_buffer_per_1m;
-	__u64 dump_config_finalize_len;
-};
-
-struct kvm_s390_pv_info_vm {
-	__u64 inst_calls_list[4];
-	__u64 max_cpus;
-	__u64 max_guests;
-	__u64 max_guest_addr;
-	__u64 feature_indication;
-};
-
-struct kvm_s390_pv_info_header {
-	__u32 id;
-	__u32 len_max;
-	__u32 len_written;
-	__u32 reserved;
-};
-
-struct kvm_s390_pv_info {
-	struct kvm_s390_pv_info_header header;
-	union {
-		struct kvm_s390_pv_info_dump dump;
-		struct kvm_s390_pv_info_vm vm;
-	};
-};
-
-enum pv_cmd_id {
-	KVM_PV_ENABLE,
-	KVM_PV_DISABLE,
-	KVM_PV_SET_SEC_PARMS,
-	KVM_PV_UNPACK,
-	KVM_PV_VERIFY,
-	KVM_PV_PREP_RESET,
-	KVM_PV_UNSHARE_ALL,
-	KVM_PV_INFO,
-	KVM_PV_DUMP,
-	KVM_PV_ASYNC_CLEANUP_PREPARE,
-	KVM_PV_ASYNC_CLEANUP_PERFORM,
-};
-
-struct kvm_pv_cmd {
-	__u32 cmd;	/* Command to be executed */
-	__u16 rc;	/* Ultravisor return code */
-	__u16 rrc;	/* Ultravisor return reason code */
-	__u64 data;	/* Data or address */
-	__u32 flags;    /* flags for future extensions. Must be 0 for now */
-	__u32 reserved[3];
-};
-
 /* Available with KVM_CAP_S390_PROTECTED */
 #define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
 
@@ -1737,58 +1373,6 @@ struct kvm_pv_cmd {
 #define KVM_XEN_HVM_GET_ATTR	_IOWR(KVMIO, 0xc8, struct kvm_xen_hvm_attr)
 #define KVM_XEN_HVM_SET_ATTR	_IOW(KVMIO,  0xc9, struct kvm_xen_hvm_attr)
 
-struct kvm_xen_hvm_attr {
-	__u16 type;
-	__u16 pad[3];
-	union {
-		__u8 long_mode;
-		__u8 vector;
-		__u8 runstate_update_flag;
-		struct {
-			__u64 gfn;
-#define KVM_XEN_INVALID_GFN ((__u64)-1)
-		} shared_info;
-		struct {
-			__u32 send_port;
-			__u32 type; /* EVTCHNSTAT_ipi / EVTCHNSTAT_interdomain */
-			__u32 flags;
-#define KVM_XEN_EVTCHN_DEASSIGN		(1 << 0)
-#define KVM_XEN_EVTCHN_UPDATE		(1 << 1)
-#define KVM_XEN_EVTCHN_RESET		(1 << 2)
-			/*
-			 * Events sent by the guest are either looped back to
-			 * the guest itself (potentially on a different port#)
-			 * or signalled via an eventfd.
-			 */
-			union {
-				struct {
-					__u32 port;
-					__u32 vcpu;
-					__u32 priority;
-				} port;
-				struct {
-					__u32 port; /* Zero for eventfd */
-					__s32 fd;
-				} eventfd;
-				__u32 padding[4];
-			} deliver;
-		} evtchn;
-		__u32 xen_version;
-		__u64 pad[8];
-	} u;
-};
-
-
-/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
-#define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
-#define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
-#define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x2
-/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
-#define KVM_XEN_ATTR_TYPE_EVTCHN		0x3
-#define KVM_XEN_ATTR_TYPE_XEN_VERSION		0x4
-/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG */
-#define KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG	0x5
-
 /* Per-vCPU Xen attributes */
 #define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
 #define KVM_XEN_VCPU_SET_ATTR	_IOW(KVMIO,  0xcb, struct kvm_xen_vcpu_attr)
@@ -1799,242 +1383,6 @@ struct kvm_xen_hvm_attr {
 #define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
 #define KVM_SET_SREGS2             _IOW(KVMIO,  0xcd, struct kvm_sregs2)
 
-struct kvm_xen_vcpu_attr {
-	__u16 type;
-	__u16 pad[3];
-	union {
-		__u64 gpa;
-#define KVM_XEN_INVALID_GPA ((__u64)-1)
-		__u64 pad[8];
-		struct {
-			__u64 state;
-			__u64 state_entry_time;
-			__u64 time_running;
-			__u64 time_runnable;
-			__u64 time_blocked;
-			__u64 time_offline;
-		} runstate;
-		__u32 vcpu_id;
-		struct {
-			__u32 port;
-			__u32 priority;
-			__u64 expires_ns;
-		} timer;
-		__u8 vector;
-	} u;
-};
-
-/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
-#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO	0x0
-#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO	0x1
-#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR	0x2
-#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT	0x3
-#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA	0x4
-#define KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST	0x5
-/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
-#define KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID		0x6
-#define KVM_XEN_VCPU_ATTR_TYPE_TIMER		0x7
-#define KVM_XEN_VCPU_ATTR_TYPE_UPCALL_VECTOR	0x8
-
-/* Secure Encrypted Virtualization command */
-enum sev_cmd_id {
-	/* Guest initialization commands */
-	KVM_SEV_INIT = 0,
-	KVM_SEV_ES_INIT,
-	/* Guest launch commands */
-	KVM_SEV_LAUNCH_START,
-	KVM_SEV_LAUNCH_UPDATE_DATA,
-	KVM_SEV_LAUNCH_UPDATE_VMSA,
-	KVM_SEV_LAUNCH_SECRET,
-	KVM_SEV_LAUNCH_MEASURE,
-	KVM_SEV_LAUNCH_FINISH,
-	/* Guest migration commands (outgoing) */
-	KVM_SEV_SEND_START,
-	KVM_SEV_SEND_UPDATE_DATA,
-	KVM_SEV_SEND_UPDATE_VMSA,
-	KVM_SEV_SEND_FINISH,
-	/* Guest migration commands (incoming) */
-	KVM_SEV_RECEIVE_START,
-	KVM_SEV_RECEIVE_UPDATE_DATA,
-	KVM_SEV_RECEIVE_UPDATE_VMSA,
-	KVM_SEV_RECEIVE_FINISH,
-	/* Guest status and debug commands */
-	KVM_SEV_GUEST_STATUS,
-	KVM_SEV_DBG_DECRYPT,
-	KVM_SEV_DBG_ENCRYPT,
-	/* Guest certificates commands */
-	KVM_SEV_CERT_EXPORT,
-	/* Attestation report */
-	KVM_SEV_GET_ATTESTATION_REPORT,
-	/* Guest Migration Extension */
-	KVM_SEV_SEND_CANCEL,
-
-	KVM_SEV_NR_MAX,
-};
-
-struct kvm_sev_cmd {
-	__u32 id;
-	__u64 data;
-	__u32 error;
-	__u32 sev_fd;
-};
-
-struct kvm_sev_launch_start {
-	__u32 handle;
-	__u32 policy;
-	__u64 dh_uaddr;
-	__u32 dh_len;
-	__u64 session_uaddr;
-	__u32 session_len;
-};
-
-struct kvm_sev_launch_update_data {
-	__u64 uaddr;
-	__u32 len;
-};
-
-
-struct kvm_sev_launch_secret {
-	__u64 hdr_uaddr;
-	__u32 hdr_len;
-	__u64 guest_uaddr;
-	__u32 guest_len;
-	__u64 trans_uaddr;
-	__u32 trans_len;
-};
-
-struct kvm_sev_launch_measure {
-	__u64 uaddr;
-	__u32 len;
-};
-
-struct kvm_sev_guest_status {
-	__u32 handle;
-	__u32 policy;
-	__u32 state;
-};
-
-struct kvm_sev_dbg {
-	__u64 src_uaddr;
-	__u64 dst_uaddr;
-	__u32 len;
-};
-
-struct kvm_sev_attestation_report {
-	__u8 mnonce[16];
-	__u64 uaddr;
-	__u32 len;
-};
-
-struct kvm_sev_send_start {
-	__u32 policy;
-	__u64 pdh_cert_uaddr;
-	__u32 pdh_cert_len;
-	__u64 plat_certs_uaddr;
-	__u32 plat_certs_len;
-	__u64 amd_certs_uaddr;
-	__u32 amd_certs_len;
-	__u64 session_uaddr;
-	__u32 session_len;
-};
-
-struct kvm_sev_send_update_data {
-	__u64 hdr_uaddr;
-	__u32 hdr_len;
-	__u64 guest_uaddr;
-	__u32 guest_len;
-	__u64 trans_uaddr;
-	__u32 trans_len;
-};
-
-struct kvm_sev_receive_start {
-	__u32 handle;
-	__u32 policy;
-	__u64 pdh_uaddr;
-	__u32 pdh_len;
-	__u64 session_uaddr;
-	__u32 session_len;
-};
-
-struct kvm_sev_receive_update_data {
-	__u64 hdr_uaddr;
-	__u32 hdr_len;
-	__u64 guest_uaddr;
-	__u32 guest_len;
-	__u64 trans_uaddr;
-	__u32 trans_len;
-};
-
-#define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
-#define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
-#define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-
-struct kvm_assigned_pci_dev {
-	__u32 assigned_dev_id;
-	__u32 busnr;
-	__u32 devfn;
-	__u32 flags;
-	__u32 segnr;
-	union {
-		__u32 reserved[11];
-	};
-};
-
-#define KVM_DEV_IRQ_HOST_INTX    (1 << 0)
-#define KVM_DEV_IRQ_HOST_MSI     (1 << 1)
-#define KVM_DEV_IRQ_HOST_MSIX    (1 << 2)
-
-#define KVM_DEV_IRQ_GUEST_INTX   (1 << 8)
-#define KVM_DEV_IRQ_GUEST_MSI    (1 << 9)
-#define KVM_DEV_IRQ_GUEST_MSIX   (1 << 10)
-
-#define KVM_DEV_IRQ_HOST_MASK	 0x00ff
-#define KVM_DEV_IRQ_GUEST_MASK   0xff00
-
-struct kvm_assigned_irq {
-	__u32 assigned_dev_id;
-	__u32 host_irq; /* ignored (legacy field) */
-	__u32 guest_irq;
-	__u32 flags;
-	union {
-		__u32 reserved[12];
-	};
-};
-
-struct kvm_assigned_msix_nr {
-	__u32 assigned_dev_id;
-	__u16 entry_nr;
-	__u16 padding;
-};
-
-#define KVM_MAX_MSIX_PER_DEV		256
-struct kvm_assigned_msix_entry {
-	__u32 assigned_dev_id;
-	__u32 gsi;
-	__u16 entry; /* The index of entry in the MSI-X table */
-	__u16 padding[3];
-};
-
-#define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
-#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
-
-/* Available with KVM_CAP_ARM_USER_IRQ */
-
-/* Bits for run->s.regs.device_irq_level */
-#define KVM_ARM_DEV_EL1_VTIMER		(1 << 0)
-#define KVM_ARM_DEV_EL1_PTIMER		(1 << 1)
-#define KVM_ARM_DEV_PMU			(1 << 2)
-
-struct kvm_hyperv_eventfd {
-	__u32 conn_id;
-	__s32 fd;
-	__u32 flags;
-	__u32 padding[3];
-};
-
-#define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
-#define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
-
 #define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
 #define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
 
@@ -2180,33 +1528,6 @@ struct kvm_stats_desc {
 /* Available with KVM_CAP_S390_ZPCI_OP */
 #define KVM_S390_ZPCI_OP         _IOW(KVMIO,  0xd1, struct kvm_s390_zpci_op)
 
-struct kvm_s390_zpci_op {
-	/* in */
-	__u32 fh;               /* target device */
-	__u8  op;               /* operation to perform */
-	__u8  pad[3];
-	union {
-		/* for KVM_S390_ZPCIOP_REG_AEN */
-		struct {
-			__u64 ibv;      /* Guest addr of interrupt bit vector */
-			__u64 sb;       /* Guest addr of summary bit */
-			__u32 flags;
-			__u32 noi;      /* Number of interrupts */
-			__u8 isc;       /* Guest interrupt subclass */
-			__u8 sbo;       /* Offset of guest summary bit vector */
-			__u16 pad;
-		} reg_aen;
-		__u64 reserved[8];
-	} u;
-};
-
-/* types for kvm_s390_zpci_op->op */
-#define KVM_S390_ZPCIOP_REG_AEN                0
-#define KVM_S390_ZPCIOP_DEREG_AEN      1
-
-/* flags for kvm_s390_zpci_op->u.reg_aen.flags */
-#define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
-
 /* Available with KVM_CAP_MEMORY_ATTRIBUTES */
 #define KVM_SET_MEMORY_ATTRIBUTES              _IOW(KVMIO,  0xd2, struct kvm_memory_attributes)
 
-- 
2.44.0.478.gd926399ef9-goog


