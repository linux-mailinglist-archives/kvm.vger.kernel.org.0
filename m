Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F056529C08F
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 18:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818028AbgJ0RQ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 13:16:58 -0400
Received: from foss.arm.com ([217.140.110.172]:47486 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1818013AbgJ0RQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 13:16:53 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61DA2139F;
        Tue, 27 Oct 2020 10:16:51 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 797C13F719;
        Tue, 27 Oct 2020 10:16:48 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [RFC PATCH kvmtool v3 1/3] update_headers: Sync kvm UAPI headers with linux 5.10-rc1
Date:   Tue, 27 Oct 2020 17:17:33 +0000
Message-Id: <20201027171735.13638-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027171735.13638-1-alexandru.elisei@arm.com>
References: <20201027171735.13638-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

The local copies of the kvm user API headers are getting stale.  In
preparation for some arch-specific updated, this patch reflects a re-run of
util/update_headers.sh to pull in upstream updates from linux v5.10-rc1.

[ Alexandru E: Updated headers to Linux tag v5.10-rc1 ]

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch64/include/asm/kvm.h |  53 +++++++++++++--
 include/linux/kvm.h           | 117 ++++++++++++++++++++++++++++++++--
 powerpc/include/asm/kvm.h     |   8 +++
 x86/include/asm/kvm.h         |  42 +++++++++++-
 4 files changed, 209 insertions(+), 11 deletions(-)

diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index 9a507716ae2f..8876e564ba56 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -106,6 +106,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
 #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
 #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
+#define KVM_ARM_VCPU_SPE		7 /* Enable SPE for this CPU */
 
 struct kvm_vcpu_init {
 	__u32 target;
@@ -159,13 +160,29 @@ struct kvm_sync_regs {
 struct kvm_arch_memory_slot {
 };
 
+/*
+ * PMU filter structure. Describe a range of events with a particular
+ * action. To be used with KVM_ARM_VCPU_PMU_V3_FILTER.
+ */
+struct kvm_pmu_event_filter {
+	__u16	base_event;
+	__u16	nevents;
+
+#define KVM_PMU_EVENT_ALLOW	0
+#define KVM_PMU_EVENT_DENY	1
+
+	__u8	action;
+	__u8	pad[3];
+};
+
 /* for KVM_GET/SET_VCPU_EVENTS */
 struct kvm_vcpu_events {
 	struct {
 		__u8 serror_pending;
 		__u8 serror_has_esr;
+		__u8 ext_dabt_pending;
 		/* Align it to 8 bytes */
-		__u8 pad[6];
+		__u8 pad[5];
 		__u64 serror_esr;
 	} exception;
 	__u32 reserved[12];
@@ -219,10 +236,18 @@ struct kvm_vcpu_events {
 #define KVM_REG_ARM_PTIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 2, 2)
 #define KVM_REG_ARM_PTIMER_CNT		ARM64_SYS_REG(3, 3, 14, 0, 1)
 
-/* EL0 Virtual Timer Registers */
+/*
+ * EL0 Virtual Timer Registers
+ *
+ * WARNING:
+ *      KVM_REG_ARM_TIMER_CVAL and KVM_REG_ARM_TIMER_CNT are not defined
+ *      with the appropriate register encodings.  Their values have been
+ *      accidentally swapped.  As this is set API, the definitions here
+ *      must be used, rather than ones derived from the encodings.
+ */
 #define KVM_REG_ARM_TIMER_CTL		ARM64_SYS_REG(3, 3, 14, 3, 1)
-#define KVM_REG_ARM_TIMER_CNT		ARM64_SYS_REG(3, 3, 14, 3, 2)
 #define KVM_REG_ARM_TIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 0, 2)
+#define KVM_REG_ARM_TIMER_CNT		ARM64_SYS_REG(3, 3, 14, 3, 2)
 
 /* KVM-as-firmware specific pseudo-registers */
 #define KVM_REG_ARM_FW			(0x0014 << KVM_REG_ARM_COPROC_SHIFT)
@@ -233,6 +258,15 @@ struct kvm_vcpu_events {
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL		0
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL		1
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_REQUIRED	2
+
+/*
+ * Only two states can be presented by the host kernel:
+ * - NOT_REQUIRED: the guest doesn't need to do anything
+ * - NOT_AVAIL: the guest isn't mitigated (it can still use SSBS if available)
+ *
+ * All the other values are deprecated. The host still accepts all
+ * values (they are ABI), but will narrow them to the above two.
+ */
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2	KVM_REG_ARM_FW_REG(2)
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL		0
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN		1
@@ -316,17 +350,28 @@ struct kvm_vcpu_events {
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
 
+#define KVM_ARM_VM_SPE_CTRL		0
+#define   KVM_ARM_VM_SPE_FINALIZE	0
+
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
 #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
 #define   KVM_ARM_VCPU_PMU_V3_INIT	1
+#define   KVM_ARM_VCPU_PMU_V3_FILTER	2
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
+#define KVM_ARM_VCPU_PVTIME_CTRL	2
+#define   KVM_ARM_VCPU_PVTIME_IPA	0
+#define KVM_ARM_VCPU_SPE_CTRL		3
+#define   KVM_ARM_VCPU_SPE_IRQ		0
+#define   KVM_ARM_VCPU_SPE_INIT		1
 
 /* KVM_IRQ_LINE irq field index values */
+#define KVM_ARM_IRQ_VCPU2_SHIFT		28
+#define KVM_ARM_IRQ_VCPU2_MASK		0xf
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
-#define KVM_ARM_IRQ_TYPE_MASK		0xff
+#define KVM_ARM_IRQ_TYPE_MASK		0xf
 #define KVM_ARM_IRQ_VCPU_SHIFT		16
 #define KVM_ARM_IRQ_VCPU_MASK		0xff
 #define KVM_ARM_IRQ_NUM_SHIFT		0
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 5e3f12d5359e..96228b823711 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -116,7 +116,7 @@ struct kvm_irq_level {
 	 * ACPI gsi notion of irq.
 	 * For IA-64 (APIC model) IOAPIC0: irq 0-23; IOAPIC1: irq 24-47..
 	 * For X86 (standard AT mode) PIC0/1: irq 0-15. IOAPIC0: 0-23..
-	 * For ARM: See Documentation/virt/kvm/api.txt
+	 * For ARM: See Documentation/virt/kvm/api.rst
 	 */
 	union {
 		__u32 irq;
@@ -188,10 +188,13 @@ struct kvm_s390_cmma_log {
 struct kvm_hyperv_exit {
 #define KVM_EXIT_HYPERV_SYNIC          1
 #define KVM_EXIT_HYPERV_HCALL          2
+#define KVM_EXIT_HYPERV_SYNDBG         3
 	__u32 type;
+	__u32 pad1;
 	union {
 		struct {
 			__u32 msr;
+			__u32 pad2;
 			__u64 control;
 			__u64 evt_page;
 			__u64 msg_page;
@@ -201,6 +204,15 @@ struct kvm_hyperv_exit {
 			__u64 result;
 			__u64 params[2];
 		} hcall;
+		struct {
+			__u32 msr;
+			__u32 pad2;
+			__u64 control;
+			__u64 status;
+			__u64 send_page;
+			__u64 recv_page;
+			__u64 pending_page;
+		} syndbg;
 	} u;
 };
 
@@ -235,6 +247,9 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_S390_STSI        25
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
+#define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_X86_RDMSR        29
+#define KVM_EXIT_X86_WRMSR        30
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -243,6 +258,8 @@ struct kvm_hyperv_exit {
 #define KVM_INTERNAL_ERROR_SIMUL_EX	2
 /* Encounter unexpected vm-exit due to delivery event. */
 #define KVM_INTERNAL_ERROR_DELIVERY_EV	3
+/* Encounter unexpected vm-exit reason */
+#define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
 
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
@@ -274,6 +291,7 @@ struct kvm_run {
 		/* KVM_EXIT_FAIL_ENTRY */
 		struct {
 			__u64 hardware_entry_failure_reason;
+			__u32 cpu;
 		} fail_entry;
 		/* KVM_EXIT_EXCEPTION */
 		struct {
@@ -392,6 +410,22 @@ struct kvm_run {
 		} eoi;
 		/* KVM_EXIT_HYPERV */
 		struct kvm_hyperv_exit hyperv;
+		/* KVM_EXIT_ARM_NISV */
+		struct {
+			__u64 esr_iss;
+			__u64 fault_ipa;
+		} arm_nisv;
+		/* KVM_EXIT_X86_RDMSR / KVM_EXIT_X86_WRMSR */
+		struct {
+			__u8 error; /* user -> kernel */
+			__u8 pad[7];
+#define KVM_MSR_EXIT_REASON_INVAL	(1 << 0)
+#define KVM_MSR_EXIT_REASON_UNKNOWN	(1 << 1)
+#define KVM_MSR_EXIT_REASON_FILTER	(1 << 2)
+			__u32 reason; /* kernel -> user */
+			__u32 index; /* kernel -> user */
+			__u64 data; /* kernel <-> user */
+		} msr;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -466,12 +500,17 @@ struct kvm_s390_mem_op {
 	__u32 size;		/* amount of bytes */
 	__u32 op;		/* type of operation */
 	__u64 buf;		/* buffer in userspace */
-	__u8 ar;		/* the access register number */
-	__u8 reserved[31];	/* should be set to 0 */
+	union {
+		__u8 ar;	/* the access register number */
+		__u32 sida_offset; /* offset into the sida */
+		__u8 reserved[32]; /* should be set to 0 */
+	};
 };
 /* types for kvm_s390_mem_op->op */
 #define KVM_S390_MEMOP_LOGICAL_READ	0
 #define KVM_S390_MEMOP_LOGICAL_WRITE	1
+#define KVM_S390_MEMOP_SIDA_READ	2
+#define KVM_S390_MEMOP_SIDA_WRITE	3
 /* flags for kvm_s390_mem_op->flags */
 #define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
 #define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
@@ -764,9 +803,10 @@ struct kvm_ppc_resize_hpt {
 #define KVM_VM_PPC_HV 1
 #define KVM_VM_PPC_PR 2
 
-/* on MIPS, 0 forces trap & emulate, 1 forces VZ ASE */
-#define KVM_VM_MIPS_TE		0
+/* on MIPS, 0 indicates auto, 1 forces VZ ASE, 2 forces trap & emulate */
+#define KVM_VM_MIPS_AUTO	0
 #define KVM_VM_MIPS_VZ		1
+#define KVM_VM_MIPS_TE		2
 
 #define KVM_S390_SIE_PAGE_OFFSET 1
 
@@ -996,6 +1036,24 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
 #define KVM_CAP_PMU_EVENT_FILTER 173
+#define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
+#define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 175
+#define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
+#define KVM_CAP_ARM_NISV_TO_USER 177
+#define KVM_CAP_ARM_INJECT_EXT_DABT 178
+#define KVM_CAP_S390_VCPU_RESETS 179
+#define KVM_CAP_S390_PROTECTED 180
+#define KVM_CAP_PPC_SECURE_GUEST 181
+#define KVM_CAP_HALT_POLL 182
+#define KVM_CAP_ASYNC_PF_INT 183
+#define KVM_CAP_LAST_CPU 184
+#define KVM_CAP_SMALLER_MAXPHYADDR 185
+#define KVM_CAP_S390_DIAG318 186
+#define KVM_CAP_STEAL_TIME 187
+#define KVM_CAP_X86_USER_SPACE_MSR 188
+#define KVM_CAP_X86_MSR_FILTER 189
+#define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
+#define KVM_CAP_ARM_SPE 191
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1086,7 +1144,7 @@ struct kvm_xen_hvm_config {
  *
  * KVM_IRQFD_FLAG_RESAMPLE indicates resamplefd is valid and specifies
  * the irqfd to operate in resampling mode for level triggered interrupt
- * emulation.  See Documentation/virt/kvm/api.txt.
+ * emulation.  See Documentation/virt/kvm/api.rst.
  */
 #define KVM_IRQFD_FLAG_RESAMPLE (1 << 1)
 
@@ -1142,6 +1200,7 @@ struct kvm_dirty_tlb {
 #define KVM_REG_S390		0x5000000000000000ULL
 #define KVM_REG_ARM64		0x6000000000000000ULL
 #define KVM_REG_MIPS		0x7000000000000000ULL
+#define KVM_REG_RISCV		0x8000000000000000ULL
 
 #define KVM_REG_SIZE_SHIFT	52
 #define KVM_REG_SIZE_MASK	0x00f0000000000000ULL
@@ -1222,6 +1281,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
 	KVM_DEV_TYPE_XIVE,
 #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
+	KVM_DEV_TYPE_ARM_PV_TIME,
+#define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
 	KVM_DEV_TYPE_MAX,
 };
 
@@ -1332,6 +1393,7 @@ struct kvm_s390_ucas_mapping {
 #define KVM_PPC_GET_CPU_CHAR	  _IOR(KVMIO,  0xb1, struct kvm_ppc_cpu_char)
 /* Available with KVM_CAP_PMU_EVENT_FILTER */
 #define KVM_SET_PMU_EVENT_FILTER  _IOW(KVMIO,  0xb2, struct kvm_pmu_event_filter)
+#define KVM_PPC_SVM_OFF		  _IO(KVMIO,  0xb3)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
@@ -1456,6 +1518,46 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_ARM_SVE */
 #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
 
+/* Available with  KVM_CAP_S390_VCPU_RESETS */
+#define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
+#define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
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
+enum pv_cmd_id {
+	KVM_PV_ENABLE,
+	KVM_PV_DISABLE,
+	KVM_PV_SET_SEC_PARMS,
+	KVM_PV_UNPACK,
+	KVM_PV_VERIFY,
+	KVM_PV_PREP_RESET,
+	KVM_PV_UNSHARE_ALL,
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
+/* Available with KVM_CAP_S390_PROTECTED */
+#define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
+
+/* Available with KVM_CAP_X86_MSR_FILTER */
+#define KVM_X86_SET_MSR_FILTER	_IOW(KVMIO,  0xc6, struct kvm_msr_filter)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
@@ -1606,4 +1708,7 @@ struct kvm_hyperv_eventfd {
 #define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
 #define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
 
+#define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
+#define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
+
 #endif /* __LINUX_KVM_H */
diff --git a/powerpc/include/asm/kvm.h b/powerpc/include/asm/kvm.h
index b0f72dea8b11..c3af3f324c5a 100644
--- a/powerpc/include/asm/kvm.h
+++ b/powerpc/include/asm/kvm.h
@@ -640,6 +640,11 @@ struct kvm_ppc_cpu_char {
 #define KVM_REG_PPC_ONLINE	(KVM_REG_PPC | KVM_REG_SIZE_U32 | 0xbf)
 #define KVM_REG_PPC_PTCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc0)
 
+/* POWER10 registers */
+#define KVM_REG_PPC_MMCR3	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc1)
+#define KVM_REG_PPC_SIER2	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc2)
+#define KVM_REG_PPC_SIER3	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc3)
+
 /* Transactional Memory checkpointed state:
  * This is all GPRs, all VSX regs and a subset of SPRs
  */
@@ -667,6 +672,8 @@ struct kvm_ppc_cpu_char {
 
 /* PPC64 eXternal Interrupt Controller Specification */
 #define KVM_DEV_XICS_GRP_SOURCES	1	/* 64-bit source attributes */
+#define KVM_DEV_XICS_GRP_CTRL		2
+#define   KVM_DEV_XICS_NR_SERVERS	1
 
 /* Layout of 64-bit source attribute values */
 #define  KVM_XICS_DESTINATION_SHIFT	0
@@ -683,6 +690,7 @@ struct kvm_ppc_cpu_char {
 #define KVM_DEV_XIVE_GRP_CTRL		1
 #define   KVM_DEV_XIVE_RESET		1
 #define   KVM_DEV_XIVE_EQ_SYNC		2
+#define   KVM_DEV_XIVE_NR_SERVERS	3
 #define KVM_DEV_XIVE_GRP_SOURCE		2	/* 64-bit source identifier */
 #define KVM_DEV_XIVE_GRP_SOURCE_CONFIG	3	/* 64-bit source identifier */
 #define KVM_DEV_XIVE_GRP_EQ_CONFIG	4	/* 64-bit EQ identifier */
diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
index 503d3f42da16..89e5f3d1bba8 100644
--- a/x86/include/asm/kvm.h
+++ b/x86/include/asm/kvm.h
@@ -192,6 +192,26 @@ struct kvm_msr_list {
 	__u32 indices[0];
 };
 
+/* Maximum size of any access bitmap in bytes */
+#define KVM_MSR_FILTER_MAX_BITMAP_SIZE 0x600
+
+/* for KVM_X86_SET_MSR_FILTER */
+struct kvm_msr_filter_range {
+#define KVM_MSR_FILTER_READ  (1 << 0)
+#define KVM_MSR_FILTER_WRITE (1 << 1)
+	__u32 flags;
+	__u32 nmsrs; /* number of msrs in bitmap */
+	__u32 base;  /* MSR index the bitmap starts at */
+	__u8 *bitmap; /* a 1 bit allows the operations in flags, 0 denies */
+};
+
+#define KVM_MSR_FILTER_MAX_RANGES 16
+struct kvm_msr_filter {
+#define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
+#define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
+	__u32 flags;
+	struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
+};
 
 struct kvm_cpuid_entry {
 	__u32 function;
@@ -385,17 +405,23 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT (1 << 4)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
-#define KVM_STATE_NESTED_FORMAT_SVM	1	/* unused */
+#define KVM_STATE_NESTED_FORMAT_SVM	1
 
 #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
 #define KVM_STATE_NESTED_EVMCS		0x00000004
+#define KVM_STATE_NESTED_MTF_PENDING	0x00000008
+#define KVM_STATE_NESTED_GIF_SET	0x00000100
 
 #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
 
 #define KVM_STATE_NESTED_VMX_VMCS_SIZE	0x1000
 
+#define KVM_STATE_NESTED_SVM_VMCB_SIZE	0x1000
+
+#define KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE	0x00000001
+
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
 	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
@@ -408,6 +434,18 @@ struct kvm_vmx_nested_state_hdr {
 	struct {
 		__u16 flags;
 	} smm;
+
+	__u32 flags;
+	__u64 preemption_timer_deadline;
+};
+
+struct kvm_svm_nested_state_data {
+	/* Save area only used if KVM_STATE_NESTED_RUN_PENDING.  */
+	__u8 vmcb12[KVM_STATE_NESTED_SVM_VMCB_SIZE];
+};
+
+struct kvm_svm_nested_state_hdr {
+	__u64 vmcb_pa;
 };
 
 /* for KVM_CAP_NESTED_STATE */
@@ -418,6 +456,7 @@ struct kvm_nested_state {
 
 	union {
 		struct kvm_vmx_nested_state_hdr vmx;
+		struct kvm_svm_nested_state_hdr svm;
 
 		/* Pad the header to 128 bytes.  */
 		__u8 pad[120];
@@ -430,6 +469,7 @@ struct kvm_nested_state {
 	 */
 	union {
 		struct kvm_vmx_nested_state_data vmx[0];
+		struct kvm_svm_nested_state_data svm[0];
 	} data;
 };
 
-- 
2.29.1

