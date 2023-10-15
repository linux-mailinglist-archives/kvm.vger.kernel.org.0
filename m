Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9D57C98BD
	for <lists+kvm@lfdr.de>; Sun, 15 Oct 2023 13:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjJOLBi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Oct 2023 07:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjJOLBf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Oct 2023 07:01:35 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC0FC5
        for <kvm@vger.kernel.org>; Sun, 15 Oct 2023 04:01:32 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9ad8a822508so561482066b.0
        for <kvm@vger.kernel.org>; Sun, 15 Oct 2023 04:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philjordan-eu.20230601.gappssmtp.com; s=20230601; t=1697367691; x=1697972491; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ffUh7fxz9W34ZnkP6ZwQMiELeYpWQPJqcHK/IvMSuk8=;
        b=OQOYrSZC3Mg5qlA+q0+Z+pGSVlvZ7y9dfpCIYQy4WsRjsB/uGU/l/hjwPdRy/6qzsm
         r1iJqh6rrfAuZA2Viodn09sFIik6JOp57j4v/Y6SpfylMjtE9VhJQHthzFTM3LKnBPOu
         LDlnAvfzbnL5YRw8CHIj5Gn19WJJyYjnVRvc8qGlLkfOCkA2/wAl9CDud8STwloMGizM
         evpFzwnWUMFFmho4DJcXmEYc5ahWXpTRBVoXje4ynCQb4GOn0Rx+xS7foZBL90OI5mSi
         fZR0i8XsDRYzjicMxgPaIcMWsOdylpzz1yR3m1Sw+Zkl1Rp98MZ2tBKbKHo6uNzUnT++
         QmbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697367691; x=1697972491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ffUh7fxz9W34ZnkP6ZwQMiELeYpWQPJqcHK/IvMSuk8=;
        b=L3x+8bLURLSbUFfBNIcBXkCU5H7KRHyizFnFfbFVincHZs1CfJi+XoH+Llcj6RrMQ4
         9Yg563IvUnOWgV0mnCU90smGR+xlkrtC0v3t1zS7xaZNbwyjN99e/iH/QfG8WcWeSx/d
         604Gdjql/QfXrQftFkPqrUlyF+pnE9PHOLFP05gNk53gzkxXbjXALxdwhU9Xjxomx1D9
         nYw/ObyeP1+x6JmMPA7OsuJMSvvZbm/lvn9u+oLeoUxql+L7NbMy7ucxKtvKrZJ3x06P
         /79YYZUXSpDgOP5iUkujf9AAnHc8YAPew5Y7YIqSVDCWKAq0s4yf44ZdSbpDkOsi6Lpa
         z64g==
X-Gm-Message-State: AOJu0YxZ5eeK+OAdso0SN5q4VSFDPNOJ+NdQzZWmhl0z8s+XDWmhchL1
        wNrebhEBzgCwLkGbTQXKQE5JtfOPSMJRmcOUC7Y=
X-Google-Smtp-Source: AGHT+IHHi650BgiDYj0iQyz1CWSruvApg11F1eKH3uFno2SVVNRJ0CHXqxZwEsRbnJok5gQTuMwYSg==
X-Received: by 2002:a17:907:7f0b:b0:9bf:5696:9153 with SMTP id qf11-20020a1709077f0b00b009bf56969153mr2409044ejc.57.1697367690899;
        Sun, 15 Oct 2023 04:01:30 -0700 (PDT)
Received: from localhost.localdomain (89-104-8-249.customer.bnet.at. [89.104.8.249])
        by smtp.gmail.com with ESMTPSA id l1-20020a170906078100b009928b4e3b9fsm2137412ejc.114.2023.10.15.04.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Oct 2023 04:01:30 -0700 (PDT)
From:   Phil Dennis-Jordan <phil@philjordan.eu>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, lists@philjordan.eu,
        phil@philjordan.eu
Subject: [kvm-unit-tests PATCH v2 1/1] x86/apic: test_pv_ipi checks cpuid before issuing KVM Hypercall
Date:   Sun, 15 Oct 2023 13:01:01 +0200
Message-Id: <20231015110101.24725-2-phil@philjordan.eu>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20231015110101.24725-1-phil@philjordan.eu>
References: <20231015110101.24725-1-phil@philjordan.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NEUTRAL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test for KVM PV IPIs previously was conditional on the
presence of the test device. This is an unreliable check and
will pass on non-KVM platforms as well, whereas issuing the
hypercall on such platforms will not have the intended effect.

With this change, the test case now checks that:

 * The test is running on KVM by checking the CPUID signature.
 * The host advertises the PV IPI hypercall CPUID feature bit.

The test is skipped if either check fails.

The KVM signature and feature bit constants are imported verbatim
via Linux's kvm_para.h, which further requires some Linux-
specific sized integer types to be defined in <linux/types.h>.
A minimal version of that file is added for non-Linux platforms,
and the real thing is used when building on Linux itself.

Finally, the +kvm-pv-ipi CPU feature flag is added to the Qemu
command lines for the APIC test suites, so the feature flag is
indeed advertised on KVM hosts. (Non-KVM hosts silently drop it.)

Co-authored-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Phil Dennis-Jordan <phil@philjordan.eu>
---
 lib/linux/kvm_para.h       |  39 ++++++++++
 lib/linux/types.h          |  15 ++++
 lib/asm-generic/kvm_para.h |   4 +
 lib/x86/asm/kvm_para.h     | 153 +++++++++++++++++++++++++++++++++++++
 lib/x86/processor.h        |  40 ++++++++++
 x86/apic.c                 |   4 +-
 x86/unittests.cfg          |   6 +-
 7 files changed, 257 insertions(+), 4 deletions(-)
 create mode 100644 lib/linux/kvm_para.h
 create mode 100644 lib/linux/types.h
 create mode 100644 lib/asm-generic/kvm_para.h
 create mode 100644 lib/x86/asm/kvm_para.h

diff --git a/lib/linux/kvm_para.h b/lib/linux/kvm_para.h
new file mode 100644
index 00000000..960c7e93
--- /dev/null
+++ b/lib/linux/kvm_para.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI__LINUX_KVM_PARA_H
+#define _UAPI__LINUX_KVM_PARA_H
+
+/*
+ * This header file provides a method for making a hypercall to the host
+ * Architectures should define:
+ * - kvm_hypercall0, kvm_hypercall1...
+ * - kvm_arch_para_features
+ * - kvm_para_available
+ */
+
+/* Return values for hypercalls */
+#define KVM_ENOSYS		1000
+#define KVM_EFAULT		EFAULT
+#define KVM_EINVAL		EINVAL
+#define KVM_E2BIG		E2BIG
+#define KVM_EPERM		EPERM
+#define KVM_EOPNOTSUPP		95
+
+#define KVM_HC_VAPIC_POLL_IRQ		1
+#define KVM_HC_MMU_OP			2
+#define KVM_HC_FEATURES			3
+#define KVM_HC_PPC_MAP_MAGIC_PAGE	4
+#define KVM_HC_KICK_CPU			5
+#define KVM_HC_MIPS_GET_CLOCK_FREQ	6
+#define KVM_HC_MIPS_EXIT_VM		7
+#define KVM_HC_MIPS_CONSOLE_OUTPUT	8
+#define KVM_HC_CLOCK_PAIRING		9
+#define KVM_HC_SEND_IPI		10
+#define KVM_HC_SCHED_YIELD		11
+#define KVM_HC_MAP_GPA_RANGE		12
+
+/*
+ * hypercalls use architecture specific
+ */
+#include <asm/kvm_para.h>
+
+#endif /* _UAPI__LINUX_KVM_PARA_H */
diff --git a/lib/linux/types.h b/lib/linux/types.h
new file mode 100644
index 00000000..67d14ca2
--- /dev/null
+++ b/lib/linux/types.h
@@ -0,0 +1,15 @@
+#ifndef _LIB_LINUX_TYPES_H_
+
+#ifdef __linux__
+/* On Linux, use the real thing */
+#include_next <linux/types.h>
+#else /* !defined(__linux__) */
+/* This is *just* enough for the headers we've pulled in from Linux to compile */
+#include <libcflat.h>
+typedef u8  __u8;
+typedef u32 __u32;
+typedef u64 __u64;
+typedef s64 __s64;
+#endif
+
+#endif
diff --git a/lib/asm-generic/kvm_para.h b/lib/asm-generic/kvm_para.h
new file mode 100644
index 00000000..486f0af7
--- /dev/null
+++ b/lib/asm-generic/kvm_para.h
@@ -0,0 +1,4 @@
+/*
+ * There isn't anything here, but the file must not be empty or patch
+ * will delete it.
+ */
diff --git a/lib/x86/asm/kvm_para.h b/lib/x86/asm/kvm_para.h
new file mode 100644
index 00000000..6e64b27b
--- /dev/null
+++ b/lib/x86/asm/kvm_para.h
@@ -0,0 +1,153 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_ASM_X86_KVM_PARA_H
+#define _UAPI_ASM_X86_KVM_PARA_H
+
+#include <linux/types.h>
+
+/* This CPUID returns the signature 'KVMKVMKVM' in ebx, ecx, and edx.  It
+ * should be used to determine that a VM is running under KVM.
+ */
+#define KVM_CPUID_SIGNATURE	0x40000000
+#define KVM_SIGNATURE "KVMKVMKVM\0\0\0"
+
+/* This CPUID returns two feature bitmaps in eax, edx. Before enabling
+ * a particular paravirtualization, the appropriate feature bit should
+ * be checked in eax. The performance hint feature bit should be checked
+ * in edx.
+ */
+#define KVM_CPUID_FEATURES	0x40000001
+#define KVM_FEATURE_CLOCKSOURCE		0
+#define KVM_FEATURE_NOP_IO_DELAY	1
+#define KVM_FEATURE_MMU_OP		2
+/* This indicates that the new set of kvmclock msrs
+ * are available. The use of 0x11 and 0x12 is deprecated
+ */
+#define KVM_FEATURE_CLOCKSOURCE2        3
+#define KVM_FEATURE_ASYNC_PF		4
+#define KVM_FEATURE_STEAL_TIME		5
+#define KVM_FEATURE_PV_EOI		6
+#define KVM_FEATURE_PV_UNHALT		7
+#define KVM_FEATURE_PV_TLB_FLUSH	9
+#define KVM_FEATURE_ASYNC_PF_VMEXIT	10
+#define KVM_FEATURE_PV_SEND_IPI	11
+#define KVM_FEATURE_POLL_CONTROL	12
+#define KVM_FEATURE_PV_SCHED_YIELD	13
+#define KVM_FEATURE_ASYNC_PF_INT	14
+#define KVM_FEATURE_MSI_EXT_DEST_ID	15
+#define KVM_FEATURE_HC_MAP_GPA_RANGE	16
+#define KVM_FEATURE_MIGRATION_CONTROL	17
+
+#define KVM_HINTS_REALTIME      0
+
+/* The last 8 bits are used to indicate how to interpret the flags field
+ * in pvclock structure. If no bits are set, all flags are ignored.
+ */
+#define KVM_FEATURE_CLOCKSOURCE_STABLE_BIT	24
+
+#define MSR_KVM_WALL_CLOCK  0x11
+#define MSR_KVM_SYSTEM_TIME 0x12
+
+#define KVM_MSR_ENABLED 1
+/* Custom MSRs falls in the range 0x4b564d00-0x4b564dff */
+#define MSR_KVM_WALL_CLOCK_NEW  0x4b564d00
+#define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
+#define MSR_KVM_ASYNC_PF_EN 0x4b564d02
+#define MSR_KVM_STEAL_TIME  0x4b564d03
+#define MSR_KVM_PV_EOI_EN      0x4b564d04
+#define MSR_KVM_POLL_CONTROL	0x4b564d05
+#define MSR_KVM_ASYNC_PF_INT	0x4b564d06
+#define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
+#define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
+
+struct kvm_steal_time {
+	__u64 steal;
+	__u32 version;
+	__u32 flags;
+	__u8  preempted;
+	__u8  u8_pad[3];
+	__u32 pad[11];
+};
+
+#define KVM_VCPU_PREEMPTED          (1 << 0)
+#define KVM_VCPU_FLUSH_TLB          (1 << 1)
+
+#define KVM_CLOCK_PAIRING_WALLCLOCK 0
+struct kvm_clock_pairing {
+	__s64 sec;
+	__s64 nsec;
+	__u64 tsc;
+	__u32 flags;
+	__u32 pad[9];
+};
+
+#define KVM_STEAL_ALIGNMENT_BITS 5
+#define KVM_STEAL_VALID_BITS ((-1ULL << (KVM_STEAL_ALIGNMENT_BITS + 1)))
+#define KVM_STEAL_RESERVED_MASK (((1 << KVM_STEAL_ALIGNMENT_BITS) - 1 ) << 1)
+
+#define KVM_MAX_MMU_OP_BATCH           32
+
+#define KVM_ASYNC_PF_ENABLED			(1 << 0)
+#define KVM_ASYNC_PF_SEND_ALWAYS		(1 << 1)
+#define KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT	(1 << 2)
+#define KVM_ASYNC_PF_DELIVERY_AS_INT		(1 << 3)
+
+/* MSR_KVM_ASYNC_PF_INT */
+#define KVM_ASYNC_PF_VEC_MASK			GENMASK(7, 0)
+
+/* MSR_KVM_MIGRATION_CONTROL */
+#define KVM_MIGRATION_READY		(1 << 0)
+
+/* KVM_HC_MAP_GPA_RANGE */
+#define KVM_MAP_GPA_RANGE_PAGE_SZ_4K	0
+#define KVM_MAP_GPA_RANGE_PAGE_SZ_2M	(1 << 0)
+#define KVM_MAP_GPA_RANGE_PAGE_SZ_1G	(1 << 1)
+#define KVM_MAP_GPA_RANGE_ENC_STAT(n)	(n << 4)
+#define KVM_MAP_GPA_RANGE_ENCRYPTED	KVM_MAP_GPA_RANGE_ENC_STAT(1)
+#define KVM_MAP_GPA_RANGE_DECRYPTED	KVM_MAP_GPA_RANGE_ENC_STAT(0)
+
+/* Operations for KVM_HC_MMU_OP */
+#define KVM_MMU_OP_WRITE_PTE            1
+#define KVM_MMU_OP_FLUSH_TLB	        2
+#define KVM_MMU_OP_RELEASE_PT	        3
+
+/* Payload for KVM_HC_MMU_OP */
+struct kvm_mmu_op_header {
+	__u32 op;
+	__u32 pad;
+};
+
+struct kvm_mmu_op_write_pte {
+	struct kvm_mmu_op_header header;
+	__u64 pte_phys;
+	__u64 pte_val;
+};
+
+struct kvm_mmu_op_flush_tlb {
+	struct kvm_mmu_op_header header;
+};
+
+struct kvm_mmu_op_release_pt {
+	struct kvm_mmu_op_header header;
+	__u64 pt_phys;
+};
+
+#define KVM_PV_REASON_PAGE_NOT_PRESENT 1
+#define KVM_PV_REASON_PAGE_READY 2
+
+struct kvm_vcpu_pv_apf_data {
+	/* Used for 'page not present' events delivered via #PF */
+	__u32 flags;
+
+	/* Used for 'page ready' events delivered via interrupt notification */
+	__u32 token;
+
+	__u8 pad[56];
+	__u32 enabled;
+};
+
+#define KVM_PV_EOI_BIT 0
+#define KVM_PV_EOI_MASK (0x1 << KVM_PV_EOI_BIT)
+#define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
+#define KVM_PV_EOI_DISABLED 0x0
+
+#endif /* _UAPI_ASM_X86_KVM_PARA_H */
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 44f4fd1e..3d3930c8 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -7,6 +7,8 @@
 #include <bitops.h>
 #include <stdint.h>
 
+#include <linux/kvm_para.h>
+
 #define NONCANONICAL	0xaaaaaaaaaaaaaaaaull
 
 #ifdef __x86_64__
@@ -238,6 +240,7 @@ static inline bool is_intel(void)
 #define	X86_FEATURE_XSAVE		(CPUID(0x1, 0, ECX, 26))
 #define	X86_FEATURE_OSXSAVE		(CPUID(0x1, 0, ECX, 27))
 #define	X86_FEATURE_RDRAND		(CPUID(0x1, 0, ECX, 30))
+#define	X86_FEATURE_HYPERVISOR		(CPUID(0x1, 0, ECX, 31))
 #define	X86_FEATURE_MCE			(CPUID(0x1, 0, EDX, 7))
 #define	X86_FEATURE_APIC		(CPUID(0x1, 0, EDX, 9))
 #define	X86_FEATURE_CLFLUSH		(CPUID(0x1, 0, EDX, 19))
@@ -284,6 +287,9 @@ static inline bool is_intel(void)
 #define X86_FEATURE_VNMI		(CPUID(0x8000000A, 0, EDX, 25))
 #define	X86_FEATURE_AMD_PMU_V2		(CPUID(0x80000022, 0, EAX, 0))
 
+#define X86_FEATURE_KVM_PV_SEND_IPI \
+	(CPUID(KVM_CPUID_FEATURES, 0, EAX, KVM_FEATURE_PV_SEND_IPI))
+
 static inline bool this_cpu_has(u64 feature)
 {
 	u32 input_eax = feature >> 32;
@@ -299,6 +305,40 @@ static inline bool this_cpu_has(u64 feature)
 	return ((*(tmp + (output_reg % 32))) & (1 << bit));
 }
 
+static inline u32 get_hypervisor_cpuid_base(const char *sig)
+{
+	u32 base;
+	struct cpuid signature;
+
+	if (!this_cpu_has(X86_FEATURE_HYPERVISOR))
+		return 0;
+
+	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
+		signature = cpuid(base);
+
+		if (!memcmp(sig, &signature.b, 12))
+			return base;
+	}
+
+	return 0;
+}
+
+static inline bool is_hypervisor_kvm(void)
+{
+	u32 base = get_hypervisor_cpuid_base(KVM_SIGNATURE);
+
+	if (!base)
+		return false;
+
+	/*
+	 * Require that KVM be placed at its default base so that macros can be
+	 * used to query individual KVM feature bits.
+	 */
+	assert_msg(base == KVM_CPUID_SIGNATURE,
+		   "Expect KVM at its default cpuid base (now at: 0x%x)", base);
+	return true;
+}
+
 struct far_pointer32 {
 	u32 offset;
 	u16 selector;
diff --git a/x86/apic.c b/x86/apic.c
index dd7e7834..783fb740 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -658,8 +658,10 @@ static void test_pv_ipi(void)
 	int ret;
 	unsigned long a0 = 0xFFFFFFFF, a1 = 0, a2 = 0xFFFFFFFF, a3 = 0x0;
 
-	if (!test_device_enabled())
+	if (!is_hypervisor_kvm() || !this_cpu_has(X86_FEATURE_KVM_PV_SEND_IPI)) {
+		report_skip("PV IPIs testing");
 		return;
+	}
 
 	asm volatile("vmcall" : "=a"(ret) :"a"(KVM_HC_SEND_IPI), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
 	report(!ret, "PV IPIs testing");
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 3fe59449..95bd5232 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -28,7 +28,7 @@
 [apic-split]
 file = apic.flat
 smp = 2
-extra_params = -cpu qemu64,+x2apic,+tsc-deadline -machine kernel_irqchip=split
+extra_params = -cpu qemu64,+x2apic,+tsc-deadline,+kvm-pv-ipi -machine kernel_irqchip=split
 arch = x86_64
 groups = apic
 
@@ -41,7 +41,7 @@ groups = apic
 [x2apic]
 file = apic.flat
 smp = 2
-extra_params = -cpu qemu64,+x2apic,+tsc-deadline
+extra_params = -cpu qemu64,+x2apic,+tsc-deadline,+kvm-pv-ipi
 arch = x86_64
 timeout = 30
 groups = apic
@@ -51,7 +51,7 @@ groups = apic
 [xapic]
 file = apic.flat
 smp = 2
-extra_params = -cpu qemu64,-x2apic,+tsc-deadline -machine pit=off
+extra_params = -cpu qemu64,-x2apic,+tsc-deadline,+kvm-pv-ipi -machine pit=off
 arch = x86_64
 timeout = 60
 groups = apic
-- 
2.36.1

