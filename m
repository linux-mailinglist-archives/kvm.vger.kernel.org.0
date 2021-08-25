Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633E53F7A47
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 18:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241976AbhHYQUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 12:20:22 -0400
Received: from foss.arm.com ([217.140.110.172]:55032 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242161AbhHYQTf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 12:19:35 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E288A101E;
        Wed, 25 Aug 2021 09:18:48 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B7AB73F66F;
        Wed, 25 Aug 2021 09:18:47 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH v4 kvmtool 1/5] update_headers: Sync KVM UAPI headers with KVM SPE implementation
Date:   Wed, 25 Aug 2021 17:19:54 +0100
Message-Id: <20210825161958.266411-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210825161958.266411-1-alexandru.elisei@arm.com>
References: <20210825161958.266411-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for KVM SPE support, update headers to match the current KVM
SPE prototype based on Linux v5.14-rc5.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch64/include/asm/kvm.h |  67 +++++-
 include/linux/kvm.h           | 425 +++++++++++++++++++++++++++++++++-
 powerpc/include/asm/kvm.h     |  10 +
 x86/include/asm/kvm.h         |  59 ++++-
 4 files changed, 548 insertions(+), 13 deletions(-)

diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index 9a507716ae2f..63599ee39a7b 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -106,6 +106,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
 #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
 #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
+#define KVM_ARM_VCPU_SPE		7 /* enable SPE for this CPU */
 
 struct kvm_vcpu_init {
 	__u32 target;
@@ -156,7 +157,19 @@ struct kvm_sync_regs {
 	__u64 device_irq_level;
 };
 
-struct kvm_arch_memory_slot {
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
 };
 
 /* for KVM_GET/SET_VCPU_EVENTS */
@@ -164,13 +177,25 @@ struct kvm_vcpu_events {
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
 };
 
+struct kvm_arm_copy_mte_tags {
+	__u64 guest_ipa;
+	__u64 length;
+	void __user *addr;
+	__u64 flags;
+	__u64 reserved[2];
+};
+
+#define KVM_ARM_TAGS_TO_GUEST		0
+#define KVM_ARM_TAGS_FROM_GUEST		1
+
 /* If you need to interpret the index values, here is the key: */
 #define KVM_REG_ARM_COPROC_MASK		0x000000000FFF0000
 #define KVM_REG_ARM_COPROC_SHIFT	16
@@ -219,10 +244,18 @@ struct kvm_vcpu_events {
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
@@ -233,6 +266,15 @@ struct kvm_vcpu_events {
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
@@ -320,13 +362,28 @@ struct kvm_vcpu_events {
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
+#define   KVM_ARM_VCPU_SPE_STOP		2
+#define     KVM_ARM_VCPU_SPE_STOP_TRAP		(1 << 0)
+#define     KVM_ARM_VCPU_SPE_STOP_EXIT		(1 << 1)
+#define     KVM_ARM_VCPU_SPE_RESUME		(1 << 2)
+
+/* run->fail_entry.hardware_entry_failure_reason codes. */
+#define KVM_EXIT_FAIL_ENTRY_SPE		(1 << 0)
 
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
index 5e3f12d5359e..930ef91f7916 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -8,6 +8,7 @@
  * Note: you must update KVM_API_VERSION if you change this interface.
  */
 
+#include <linux/const.h>
 #include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/ioctl.h>
@@ -116,7 +117,7 @@ struct kvm_irq_level {
 	 * ACPI gsi notion of irq.
 	 * For IA-64 (APIC model) IOAPIC0: irq 0-23; IOAPIC1: irq 24-47..
 	 * For X86 (standard AT mode) PIC0/1: irq 0-15. IOAPIC0: 0-23..
-	 * For ARM: See Documentation/virt/kvm/api.txt
+	 * For ARM: See Documentation/virt/kvm/api.rst
 	 */
 	union {
 		__u32 irq;
@@ -188,10 +189,13 @@ struct kvm_s390_cmma_log {
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
@@ -201,6 +205,29 @@ struct kvm_hyperv_exit {
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
+	} u;
+};
+
+struct kvm_xen_exit {
+#define KVM_EXIT_XEN_HCALL          1
+	__u32 type;
+	union {
+		struct {
+			__u32 longmode;
+			__u32 cpl;
+			__u64 input;
+			__u64 result;
+			__u64 params[6];
+		} hcall;
 	} u;
 };
 
@@ -235,6 +262,13 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_S390_STSI        25
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
+#define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_X86_RDMSR        29
+#define KVM_EXIT_X86_WRMSR        30
+#define KVM_EXIT_DIRTY_RING_FULL  31
+#define KVM_EXIT_AP_RESET_HOLD    32
+#define KVM_EXIT_X86_BUS_LOCK     33
+#define KVM_EXIT_XEN              34
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -243,6 +277,11 @@ struct kvm_hyperv_exit {
 #define KVM_INTERNAL_ERROR_SIMUL_EX	2
 /* Encounter unexpected vm-exit due to delivery event. */
 #define KVM_INTERNAL_ERROR_DELIVERY_EV	3
+/* Encounter unexpected vm-exit reason */
+#define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
+
+/* Flags that describe what fields in emulation_failure hold valid data. */
+#define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
 
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
@@ -274,6 +313,7 @@ struct kvm_run {
 		/* KVM_EXIT_FAIL_ENTRY */
 		struct {
 			__u64 hardware_entry_failure_reason;
+			__u32 cpu;
 		} fail_entry;
 		/* KVM_EXIT_EXCEPTION */
 		struct {
@@ -346,6 +386,25 @@ struct kvm_run {
 			__u32 ndata;
 			__u64 data[16];
 		} internal;
+		/*
+		 * KVM_INTERNAL_ERROR_EMULATION
+		 *
+		 * "struct emulation_failure" is an overlay of "struct internal"
+		 * that is used for the KVM_INTERNAL_ERROR_EMULATION sub-type of
+		 * KVM_EXIT_INTERNAL_ERROR.  Note, unlike other internal error
+		 * sub-types, this struct is ABI!  It also needs to be backwards
+		 * compatible with "struct internal".  Take special care that
+		 * "ndata" is correct, that new fields are enumerated in "flags",
+		 * and that each flag enumerates fields that are 64-bit aligned
+		 * and sized (so that ndata+internal.data[] is valid/accurate).
+		 */
+		struct {
+			__u32 suberror;
+			__u32 ndata;
+			__u64 flags;
+			__u8  insn_size;
+			__u8  insn_bytes[15];
+		} emulation_failure;
 		/* KVM_EXIT_OSI */
 		struct {
 			__u64 gprs[32];
@@ -392,6 +451,24 @@ struct kvm_run {
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
+		/* KVM_EXIT_XEN */
+		struct kvm_xen_exit xen;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -466,12 +543,17 @@ struct kvm_s390_mem_op {
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
@@ -533,6 +615,7 @@ struct kvm_vapic_addr {
 #define KVM_MP_STATE_CHECK_STOP        6
 #define KVM_MP_STATE_OPERATING         7
 #define KVM_MP_STATE_LOAD              8
+#define KVM_MP_STATE_AP_RESET_HOLD     9
 
 struct kvm_mp_state {
 	__u32 mp_state;
@@ -764,9 +847,10 @@ struct kvm_ppc_resize_hpt {
 #define KVM_VM_PPC_HV 1
 #define KVM_VM_PPC_PR 2
 
-/* on MIPS, 0 forces trap & emulate, 1 forces VZ ASE */
-#define KVM_VM_MIPS_TE		0
+/* on MIPS, 0 indicates auto, 1 forces VZ ASE, 2 forces trap & emulate */
+#define KVM_VM_MIPS_AUTO	0
 #define KVM_VM_MIPS_VZ		1
+#define KVM_VM_MIPS_TE		2
 
 #define KVM_S390_SIE_PAGE_OFFSET 1
 
@@ -996,6 +1080,41 @@ struct kvm_ppc_resize_hpt {
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
+#define KVM_CAP_SYS_HYPERV_CPUID 191
+#define KVM_CAP_DIRTY_LOG_RING 192
+#define KVM_CAP_X86_BUS_LOCK_EXIT 193
+#define KVM_CAP_PPC_DAWR1 194
+#define KVM_CAP_SET_GUEST_DEBUG2 195
+#define KVM_CAP_SGX_ATTRIBUTE 196
+#define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 197
+#define KVM_CAP_PTP_KVM 198
+#define KVM_CAP_HYPERV_ENFORCE_CPUID 199
+#define KVM_CAP_SREGS2 200
+#define KVM_CAP_EXIT_HYPERCALL 201
+#define KVM_CAP_PPC_RPT_INVALIDATE 202
+#define KVM_CAP_BINARY_STATS_FD 203
+#define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
+#define KVM_CAP_ARM_MTE 205
+#define KVM_CAP_ARM_LOCK_USER_MEMORY_REGION 206
+#define KVM_CAP_ARM_VCPU_SUPPORTED_CPUS 207
+#define KVM_CAP_ARM_SPE 208
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1069,6 +1188,11 @@ struct kvm_x86_mce {
 #endif
 
 #ifdef KVM_CAP_XEN_HVM
+#define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
+#define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
+#define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
+#define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
+
 struct kvm_xen_hvm_config {
 	__u32 flags;
 	__u32 msr;
@@ -1086,7 +1210,7 @@ struct kvm_xen_hvm_config {
  *
  * KVM_IRQFD_FLAG_RESAMPLE indicates resamplefd is valid and specifies
  * the irqfd to operate in resampling mode for level triggered interrupt
- * emulation.  See Documentation/virt/kvm/api.txt.
+ * emulation.  See Documentation/virt/kvm/api.rst.
  */
 #define KVM_IRQFD_FLAG_RESAMPLE (1 << 1)
 
@@ -1142,6 +1266,7 @@ struct kvm_dirty_tlb {
 #define KVM_REG_S390		0x5000000000000000ULL
 #define KVM_REG_ARM64		0x6000000000000000ULL
 #define KVM_REG_MIPS		0x7000000000000000ULL
+#define KVM_REG_RISCV		0x8000000000000000ULL
 
 #define KVM_REG_SIZE_SHIFT	52
 #define KVM_REG_SIZE_MASK	0x00f0000000000000ULL
@@ -1222,6 +1347,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
 	KVM_DEV_TYPE_XIVE,
 #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
+	KVM_DEV_TYPE_ARM_PV_TIME,
+#define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
 	KVM_DEV_TYPE_MAX,
 };
 
@@ -1332,6 +1459,15 @@ struct kvm_s390_ucas_mapping {
 #define KVM_PPC_GET_CPU_CHAR	  _IOR(KVMIO,  0xb1, struct kvm_ppc_cpu_char)
 /* Available with KVM_CAP_PMU_EVENT_FILTER */
 #define KVM_SET_PMU_EVENT_FILTER  _IOW(KVMIO,  0xb2, struct kvm_pmu_event_filter)
+#define KVM_PPC_SVM_OFF		  _IO(KVMIO,  0xb3)
+#define KVM_ARM_MTE_COPY_TAGS	  _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
+
+/* Used by KVM_CAP_ARM_LOCK_USER_MEMORY_REGION */
+#define KVM_ARM_LOCK_USER_MEMORY_REGION_FLAGS_LOCK	(1 << 0)
+#define   KVM_ARM_LOCK_MEM_READ				(1 << 0)
+#define   KVM_ARM_LOCK_MEM_WRITE			(1 << 1)
+#define KVM_ARM_LOCK_USER_MEMORY_REGION_FLAGS_UNLOCK	(1 << 1)
+#define   KVM_ARM_UNLOCK_MEM_ALL			(1 << 0)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
@@ -1450,12 +1586,112 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_MANUAL_DIRTY_LOG_PROTECT_2 */
 #define KVM_CLEAR_DIRTY_LOG          _IOWR(KVMIO, 0xc0, struct kvm_clear_dirty_log)
 
-/* Available with KVM_CAP_HYPERV_CPUID */
+/* Available with KVM_CAP_HYPERV_CPUID (vcpu) / KVM_CAP_SYS_HYPERV_CPUID (system) */
 #define KVM_GET_SUPPORTED_HV_CPUID _IOWR(KVMIO, 0xc1, struct kvm_cpuid2)
 
 /* Available with KVM_CAP_ARM_SVE */
 #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
 
+/* Available with  KVM_CAP_S390_VCPU_RESETS */
+#define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
+#define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
+
+/* Available with KVM_CAP_ARM_VCPU_SUPPORTED_CPUS */
+#define KVM_ARM_VCPU_SUPPORTED_CPUS    _IOW(KVMIO, 0xc5, const char *)
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
+/* Available with KVM_CAP_DIRTY_LOG_RING */
+#define KVM_RESET_DIRTY_RINGS		_IO(KVMIO, 0xc7)
+
+/* Per-VM Xen attributes */
+#define KVM_XEN_HVM_GET_ATTR	_IOWR(KVMIO, 0xc8, struct kvm_xen_hvm_attr)
+#define KVM_XEN_HVM_SET_ATTR	_IOW(KVMIO,  0xc9, struct kvm_xen_hvm_attr)
+
+struct kvm_xen_hvm_attr {
+	__u16 type;
+	__u16 pad[3];
+	union {
+		__u8 long_mode;
+		__u8 vector;
+		struct {
+			__u64 gfn;
+		} shared_info;
+		__u64 pad[8];
+	} u;
+};
+
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
+#define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
+#define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
+#define KVM_XEN_ATTR_TYPE_UPCALL_VECTOR		0x2
+
+/* Per-vCPU Xen attributes */
+#define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
+#define KVM_XEN_VCPU_SET_ATTR	_IOW(KVMIO,  0xcb, struct kvm_xen_vcpu_attr)
+
+#define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
+#define KVM_SET_SREGS2             _IOW(KVMIO,  0xcd, struct kvm_sregs2)
+
+struct kvm_xen_vcpu_attr {
+	__u16 type;
+	__u16 pad[3];
+	union {
+		__u64 gpa;
+		__u64 pad[8];
+		struct {
+			__u64 state;
+			__u64 state_entry_time;
+			__u64 time_running;
+			__u64 time_runnable;
+			__u64 time_blocked;
+			__u64 time_offline;
+		} runstate;
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
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
@@ -1484,6 +1720,10 @@ enum sev_cmd_id {
 	KVM_SEV_DBG_ENCRYPT,
 	/* Guest certificates commands */
 	KVM_SEV_CERT_EXPORT,
+	/* Attestation report */
+	KVM_SEV_GET_ATTESTATION_REPORT,
+	/* Guest Migration Extension */
+	KVM_SEV_SEND_CANCEL,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1536,6 +1776,51 @@ struct kvm_sev_dbg {
 	__u32 len;
 };
 
+struct kvm_sev_attestation_report {
+	__u8 mnonce[16];
+	__u64 uaddr;
+	__u32 len;
+};
+
+struct kvm_sev_send_start {
+	__u32 policy;
+	__u64 pdh_cert_uaddr;
+	__u32 pdh_cert_len;
+	__u64 plat_certs_uaddr;
+	__u32 plat_certs_len;
+	__u64 amd_certs_uaddr;
+	__u32 amd_certs_len;
+	__u64 session_uaddr;
+	__u32 session_len;
+};
+
+struct kvm_sev_send_update_data {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+};
+
+struct kvm_sev_receive_start {
+	__u32 handle;
+	__u32 policy;
+	__u64 pdh_uaddr;
+	__u32 pdh_len;
+	__u64 session_uaddr;
+	__u32 session_len;
+};
+
+struct kvm_sev_receive_update_data {
+	__u64 hdr_uaddr;
+	__u32 hdr_len;
+	__u64 guest_uaddr;
+	__u32 guest_len;
+	__u64 trans_uaddr;
+	__u32 trans_len;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
@@ -1606,4 +1891,130 @@ struct kvm_hyperv_eventfd {
 #define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
 #define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
 
+#define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
+#define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
+
+/*
+ * Arch needs to define the macro after implementing the dirty ring
+ * feature.  KVM_DIRTY_LOG_PAGE_OFFSET should be defined as the
+ * starting page offset of the dirty ring structures.
+ */
+#ifndef KVM_DIRTY_LOG_PAGE_OFFSET
+#define KVM_DIRTY_LOG_PAGE_OFFSET 0
+#endif
+
+/*
+ * KVM dirty GFN flags, defined as:
+ *
+ * |---------------+---------------+--------------|
+ * | bit 1 (reset) | bit 0 (dirty) | Status       |
+ * |---------------+---------------+--------------|
+ * |             0 |             0 | Invalid GFN  |
+ * |             0 |             1 | Dirty GFN    |
+ * |             1 |             X | GFN to reset |
+ * |---------------+---------------+--------------|
+ *
+ * Lifecycle of a dirty GFN goes like:
+ *
+ *      dirtied         harvested        reset
+ * 00 -----------> 01 -------------> 1X -------+
+ *  ^                                          |
+ *  |                                          |
+ *  +------------------------------------------+
+ *
+ * The userspace program is only responsible for the 01->1X state
+ * conversion after harvesting an entry.  Also, it must not skip any
+ * dirty bits, so that dirty bits are always harvested in sequence.
+ */
+#define KVM_DIRTY_GFN_F_DIRTY           _BITUL(0)
+#define KVM_DIRTY_GFN_F_RESET           _BITUL(1)
+#define KVM_DIRTY_GFN_F_MASK            0x3
+
+/*
+ * KVM dirty rings should be mapped at KVM_DIRTY_LOG_PAGE_OFFSET of
+ * per-vcpu mmaped regions as an array of struct kvm_dirty_gfn.  The
+ * size of the gfn buffer is decided by the first argument when
+ * enabling KVM_CAP_DIRTY_LOG_RING.
+ */
+struct kvm_dirty_gfn {
+	__u32 flags;
+	__u32 slot;
+	__u64 offset;
+};
+
+#define KVM_BUS_LOCK_DETECTION_OFF             (1 << 0)
+#define KVM_BUS_LOCK_DETECTION_EXIT            (1 << 1)
+
+/**
+ * struct kvm_stats_header - Header of per vm/vcpu binary statistics data.
+ * @flags: Some extra information for header, always 0 for now.
+ * @name_size: The size in bytes of the memory which contains statistics
+ *             name string including trailing '\0'. The memory is allocated
+ *             at the send of statistics descriptor.
+ * @num_desc: The number of statistics the vm or vcpu has.
+ * @id_offset: The offset of the vm/vcpu stats' id string in the file pointed
+ *             by vm/vcpu stats fd.
+ * @desc_offset: The offset of the vm/vcpu stats' descriptor block in the file
+ *               pointd by vm/vcpu stats fd.
+ * @data_offset: The offset of the vm/vcpu stats' data block in the file
+ *               pointed by vm/vcpu stats fd.
+ *
+ * This is the header userspace needs to read from stats fd before any other
+ * readings. It is used by userspace to discover all the information about the
+ * vm/vcpu's binary statistics.
+ * Userspace reads this header from the start of the vm/vcpu's stats fd.
+ */
+struct kvm_stats_header {
+	__u32 flags;
+	__u32 name_size;
+	__u32 num_desc;
+	__u32 id_offset;
+	__u32 desc_offset;
+	__u32 data_offset;
+};
+
+#define KVM_STATS_TYPE_SHIFT		0
+#define KVM_STATS_TYPE_MASK		(0xF << KVM_STATS_TYPE_SHIFT)
+#define KVM_STATS_TYPE_CUMULATIVE	(0x0 << KVM_STATS_TYPE_SHIFT)
+#define KVM_STATS_TYPE_INSTANT		(0x1 << KVM_STATS_TYPE_SHIFT)
+#define KVM_STATS_TYPE_PEAK		(0x2 << KVM_STATS_TYPE_SHIFT)
+#define KVM_STATS_TYPE_MAX		KVM_STATS_TYPE_PEAK
+
+#define KVM_STATS_UNIT_SHIFT		4
+#define KVM_STATS_UNIT_MASK		(0xF << KVM_STATS_UNIT_SHIFT)
+#define KVM_STATS_UNIT_NONE		(0x0 << KVM_STATS_UNIT_SHIFT)
+#define KVM_STATS_UNIT_BYTES		(0x1 << KVM_STATS_UNIT_SHIFT)
+#define KVM_STATS_UNIT_SECONDS		(0x2 << KVM_STATS_UNIT_SHIFT)
+#define KVM_STATS_UNIT_CYCLES		(0x3 << KVM_STATS_UNIT_SHIFT)
+#define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_CYCLES
+
+#define KVM_STATS_BASE_SHIFT		8
+#define KVM_STATS_BASE_MASK		(0xF << KVM_STATS_BASE_SHIFT)
+#define KVM_STATS_BASE_POW10		(0x0 << KVM_STATS_BASE_SHIFT)
+#define KVM_STATS_BASE_POW2		(0x1 << KVM_STATS_BASE_SHIFT)
+#define KVM_STATS_BASE_MAX		KVM_STATS_BASE_POW2
+
+/**
+ * struct kvm_stats_desc - Descriptor of a KVM statistics.
+ * @flags: Annotations of the stats, like type, unit, etc.
+ * @exponent: Used together with @flags to determine the unit.
+ * @size: The number of data items for this stats.
+ *        Every data item is of type __u64.
+ * @offset: The offset of the stats to the start of stat structure in
+ *          struture kvm or kvm_vcpu.
+ * @unused: Unused field for future usage. Always 0 for now.
+ * @name: The name string for the stats. Its size is indicated by the
+ *        &kvm_stats_header->name_size.
+ */
+struct kvm_stats_desc {
+	__u32 flags;
+	__s16 exponent;
+	__u16 size;
+	__u32 offset;
+	__u32 unused;
+	char name[];
+};
+
+#define KVM_GET_STATS_FD  _IO(KVMIO,  0xce)
+
 #endif /* __LINUX_KVM_H */
diff --git a/powerpc/include/asm/kvm.h b/powerpc/include/asm/kvm.h
index b0f72dea8b11..9f18fa090f1f 100644
--- a/powerpc/include/asm/kvm.h
+++ b/powerpc/include/asm/kvm.h
@@ -640,6 +640,13 @@ struct kvm_ppc_cpu_char {
 #define KVM_REG_PPC_ONLINE	(KVM_REG_PPC | KVM_REG_SIZE_U32 | 0xbf)
 #define KVM_REG_PPC_PTCR	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc0)
 
+/* POWER10 registers */
+#define KVM_REG_PPC_MMCR3	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc1)
+#define KVM_REG_PPC_SIER2	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc2)
+#define KVM_REG_PPC_SIER3	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc3)
+#define KVM_REG_PPC_DAWR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc4)
+#define KVM_REG_PPC_DAWRX1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0xc5)
+
 /* Transactional Memory checkpointed state:
  * This is all GPRs, all VSX regs and a subset of SPRs
  */
@@ -667,6 +674,8 @@ struct kvm_ppc_cpu_char {
 
 /* PPC64 eXternal Interrupt Controller Specification */
 #define KVM_DEV_XICS_GRP_SOURCES	1	/* 64-bit source attributes */
+#define KVM_DEV_XICS_GRP_CTRL		2
+#define   KVM_DEV_XICS_NR_SERVERS	1
 
 /* Layout of 64-bit source attribute values */
 #define  KVM_XICS_DESTINATION_SHIFT	0
@@ -683,6 +692,7 @@ struct kvm_ppc_cpu_char {
 #define KVM_DEV_XIVE_GRP_CTRL		1
 #define   KVM_DEV_XIVE_RESET		1
 #define   KVM_DEV_XIVE_EQ_SYNC		2
+#define   KVM_DEV_XIVE_NR_SERVERS	3
 #define KVM_DEV_XIVE_GRP_SOURCE		2	/* 64-bit source identifier */
 #define KVM_DEV_XIVE_GRP_SOURCE_CONFIG	3	/* 64-bit source identifier */
 #define KVM_DEV_XIVE_GRP_EQ_CONFIG	4	/* 64-bit EQ identifier */
diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
index 503d3f42da16..a6c327f8ad9e 100644
--- a/x86/include/asm/kvm.h
+++ b/x86/include/asm/kvm.h
@@ -12,6 +12,7 @@
 
 #define KVM_PIO_PAGE_OFFSET 1
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 2
+#define KVM_DIRTY_LOG_PAGE_OFFSET 64
 
 #define DE_VECTOR 0
 #define DB_VECTOR 1
@@ -111,6 +112,7 @@ struct kvm_ioapic_state {
 #define KVM_NR_IRQCHIPS          3
 
 #define KVM_RUN_X86_SMM		 (1 << 0)
+#define KVM_RUN_X86_BUS_LOCK     (1 << 1)
 
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
@@ -157,6 +159,19 @@ struct kvm_sregs {
 	__u64 interrupt_bitmap[(KVM_NR_INTERRUPTS + 63) / 64];
 };
 
+struct kvm_sregs2 {
+	/* out (KVM_GET_SREGS2) / in (KVM_SET_SREGS2) */
+	struct kvm_segment cs, ds, es, fs, gs, ss;
+	struct kvm_segment tr, ldt;
+	struct kvm_dtable gdt, idt;
+	__u64 cr0, cr2, cr3, cr4, cr8;
+	__u64 efer;
+	__u64 apic_base;
+	__u64 flags;
+	__u64 pdptrs[4];
+};
+#define KVM_SREGS2_FLAGS_PDPTRS_VALID 1
+
 /* for KVM_GET_FPU and KVM_SET_FPU */
 struct kvm_fpu {
 	__u8  fpr[8][16];
@@ -192,6 +207,26 @@ struct kvm_msr_list {
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
@@ -385,17 +420,23 @@ struct kvm_sync_regs {
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
@@ -408,6 +449,20 @@ struct kvm_vmx_nested_state_hdr {
 	struct {
 		__u16 flags;
 	} smm;
+
+	__u16 pad;
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
@@ -418,6 +473,7 @@ struct kvm_nested_state {
 
 	union {
 		struct kvm_vmx_nested_state_hdr vmx;
+		struct kvm_svm_nested_state_hdr svm;
 
 		/* Pad the header to 128 bytes.  */
 		__u8 pad[120];
@@ -430,6 +486,7 @@ struct kvm_nested_state {
 	 */
 	union {
 		struct kvm_vmx_nested_state_data vmx[0];
+		struct kvm_svm_nested_state_data svm[0];
 	} data;
 };
 
-- 
2.33.0

