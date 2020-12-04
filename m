Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2662CE4E7
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 02:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388296AbgLDBUK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 20:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388246AbgLDBUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 20:20:10 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE3CEC061A55
        for <kvm@vger.kernel.org>; Thu,  3 Dec 2020 17:18:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=/FB1RqEsEzd0khW+uj18CfdZqzSIx5z4siS9Sio+BQE=; b=RhWqaQ1KzZBIeF6HUyLYcQjFDU
        8Vvc0FuousQwSnY+vsnzWWkUPnd5TfWNweJe4TSP6aVTyYfQgEZ5seEyl2wQUTKgJRD5tMInBTTsf
        1P4Df+olR9xInVyJt+OFZZ9XP84rvbq1e/LKLN9g6oPGUFw7aPRlimBW07VMwQ/8kRywpl0qiF7/7
        eGMZYnkeZhmdgVBZP4ocwAxDkFoF6Hep6SEmt5s+Us0YqEzbq/8c/tM9mRLsbpa2gbanZwKT0vAT/
        yEjjyZH5GTlG+8Cud9Yfxjwh1KTL9b+OoJgvG7I5M1deWwt0iiUyVqrCTEzkqngEW28siqAJ0w8ur
        aa7SNjuQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkzkL-0002jy-AT; Fri, 04 Dec 2020 01:18:53 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kkzkK-00CS9q-84; Fri, 04 Dec 2020 01:18:52 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 03/15] KVM: x86/xen: intercept xen hypercalls if enabled
Date:   Fri,  4 Dec 2020 01:18:36 +0000
Message-Id: <20201204011848.2967588-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201204011848.2967588-1-dwmw2@infradead.org>
References: <20201204011848.2967588-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

Add a new exit reason for emulator to handle Xen hypercalls.

Since this means KVM owns the ABI, dispense with the facility for the
VMM to provide its own copy of the hypercall pages; just fill them in
directly using VMCALL/VMMCALL as we do for the Hyper-V hypercall page.

This behaviour is enabled by a new INTERCEPT_HCALL flag in the
KVM_XEN_HVM_CONFIG ioctl structure, and advertised by the same flag
being returned from the KVM_CAP_XEN_HVM check.

Add a test case and shift xen_hvm_config() to the nascent xen.c while
we're at it.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h               |   6 +
 arch/x86/kvm/Makefile                         |   2 +-
 arch/x86/kvm/trace.h                          |  36 +++++
 arch/x86/kvm/x86.c                            |  46 +++---
 arch/x86/kvm/xen.c                            | 140 ++++++++++++++++++
 arch/x86/kvm/xen.h                            |  21 +++
 include/uapi/linux/kvm.h                      |  19 +++
 tools/testing/selftests/kvm/Makefile          |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
 .../selftests/kvm/x86_64/xen_vmcall_test.c    | 123 +++++++++++++++
 10 files changed, 365 insertions(+), 30 deletions(-)
 create mode 100644 arch/x86/kvm/xen.c
 create mode 100644 arch/x86/kvm/xen.h
 create mode 100644 tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7e5f33a0d0e2..9de3229e91e1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -520,6 +520,11 @@ struct kvm_vcpu_hv {
 	cpumask_t tlb_flush;
 };
 
+/* Xen HVM per vcpu emulation context */
+struct kvm_vcpu_xen {
+	u64 hypercall_rip;
+};
+
 struct kvm_vcpu_arch {
 	/*
 	 * rip and regs accesses must go through
@@ -717,6 +722,7 @@ struct kvm_vcpu_arch {
 	unsigned long singlestep_rip;
 
 	struct kvm_vcpu_hv hyperv;
+	struct kvm_vcpu_xen xen;
 
 	cpumask_var_t wbinvd_dirty_mask;
 
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index b804444e16d4..8bee4afc1fec 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -13,7 +13,7 @@ kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
 				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 
-kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
+kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o xen.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
 			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
 			   mmu/spte.o mmu/tdp_iter.o mmu/tdp_mmu.o
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index aef960f90f26..d28ecb37b62c 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -92,6 +92,42 @@ TRACE_EVENT(kvm_hv_hypercall,
 		  __entry->outgpa)
 );
 
+/*
+ * Tracepoint for Xen hypercall.
+ */
+TRACE_EVENT(kvm_xen_hypercall,
+	TP_PROTO(unsigned long nr, unsigned long a0, unsigned long a1,
+		 unsigned long a2, unsigned long a3, unsigned long a4,
+		 unsigned long a5),
+	    TP_ARGS(nr, a0, a1, a2, a3, a4, a5),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, nr)
+		__field(unsigned long, a0)
+		__field(unsigned long, a1)
+		__field(unsigned long, a2)
+		__field(unsigned long, a3)
+		__field(unsigned long, a4)
+		__field(unsigned long, a5)
+	),
+
+	TP_fast_assign(
+		__entry->nr = nr;
+		__entry->a0 = a0;
+		__entry->a1 = a1;
+		__entry->a2 = a2;
+		__entry->a3 = a3;
+		__entry->a4 = a4;
+		__entry->a4 = a5;
+	),
+
+	TP_printk("nr 0x%lx a0 0x%lx a1 0x%lx a2 0x%lx a3 0x%lx a4 0x%lx a5 %lx",
+		  __entry->nr, __entry->a0, __entry->a1,  __entry->a2,
+		  __entry->a3, __entry->a4, __entry->a5)
+);
+
+
+
 /*
  * Tracepoint for PIO.
  */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 13ba4a64f748..1a7f016afb21 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -29,6 +29,7 @@
 #include "pmu.h"
 #include "hyperv.h"
 #include "lapic.h"
+#include "xen.h"
 
 #include <linux/clocksource.h>
 #include <linux/interrupt.h>
@@ -2842,32 +2843,6 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 0;
 }
 
-static int xen_hvm_config(struct kvm_vcpu *vcpu, u64 data)
-{
-	struct kvm *kvm = vcpu->kvm;
-	int lm = is_long_mode(vcpu);
-	u8 *blob_addr = lm ? (u8 *)(long)kvm->arch.xen_hvm_config.blob_addr_64
-		: (u8 *)(long)kvm->arch.xen_hvm_config.blob_addr_32;
-	u8 blob_size = lm ? kvm->arch.xen_hvm_config.blob_size_64
-		: kvm->arch.xen_hvm_config.blob_size_32;
-	u32 page_num = data & ~PAGE_MASK;
-	u64 page_addr = data & PAGE_MASK;
-	u8 *page;
-
-	if (page_num >= blob_size)
-		return 1;
-
-	page = memdup_user(blob_addr + (page_num * PAGE_SIZE), PAGE_SIZE);
-	if (IS_ERR(page))
-		return PTR_ERR(page);
-
-	if (kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE)) {
-		kfree(page);
-		return 1;
-	}
-	return 0;
-}
-
 static inline bool kvm_pv_async_pf_enabled(struct kvm_vcpu *vcpu)
 {
 	u64 mask = KVM_ASYNC_PF_ENABLED | KVM_ASYNC_PF_DELIVERY_AS_INT;
@@ -3002,7 +2977,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	u64 data = msr_info->data;
 
 	if (msr && (msr == vcpu->kvm->arch.xen_hvm_config.msr))
-		return xen_hvm_config(vcpu, data);
+		return kvm_xen_hvm_config(vcpu, data);
 
 	switch (msr) {
 	case MSR_AMD64_NB_CFG:
@@ -3703,7 +3678,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_PIT2:
 	case KVM_CAP_PIT_STATE2:
 	case KVM_CAP_SET_IDENTITY_MAP_ADDR:
-	case KVM_CAP_XEN_HVM:
 	case KVM_CAP_VCPU_EVENTS:
 	case KVM_CAP_HYPERV:
 	case KVM_CAP_HYPERV_VAPIC:
@@ -3742,6 +3716,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
 		r = 1;
 		break;
+	case KVM_CAP_XEN_HVM:
+		r = 1 | KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL;
+		break;
 	case KVM_CAP_SYNC_REGS:
 		r = KVM_SYNC_X86_VALID_FIELDS;
 		break;
@@ -5603,7 +5580,15 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		if (copy_from_user(&xhc, argp, sizeof(xhc)))
 			goto out;
 		r = -EINVAL;
-		if (xhc.flags)
+		if (xhc.flags & ~KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL)
+			goto out;
+		/*
+		 * With hypercall interception the kernel generates its own
+		 * hypercall page so it must not be provided.
+		 */
+		if ((xhc.flags & KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL) &&
+		    (xhc.blob_addr_32 || xhc.blob_addr_64 ||
+		     xhc.blob_size_32 || xhc.blob_size_64))
 			goto out;
 		memcpy(&kvm->arch.xen_hvm_config, &xhc, sizeof(xhc));
 		r = 0;
@@ -8066,6 +8051,9 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	unsigned long nr, a0, a1, a2, a3, ret;
 	int op_64_bit;
 
+	if (kvm_xen_hypercall_enabled(vcpu->kvm))
+		return kvm_xen_hypercall(vcpu);
+
 	if (kvm_hv_hypercall_enabled(vcpu->kvm))
 		return kvm_hv_hypercall(vcpu);
 
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
new file mode 100644
index 000000000000..b76d121a86c0
--- /dev/null
+++ b/arch/x86/kvm/xen.c
@@ -0,0 +1,140 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright © 2019 Oracle and/or its affiliates. All rights reserved.
+ * Copyright © 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ *
+ * KVM Xen emulation
+ */
+
+#include "x86.h"
+#include "xen.h"
+
+#include <linux/kvm_host.h>
+
+#include <trace/events/kvm.h>
+
+#include "trace.h"
+
+int kvm_xen_hvm_config(struct kvm_vcpu *vcpu, u64 data)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u32 page_num = data & ~PAGE_MASK;
+	u64 page_addr = data & PAGE_MASK;
+
+	/*
+	 * If Xen hypercall intercept is enabled, fill the hypercall
+	 * page with VMCALL/VMMCALL instructions since that's what
+	 * we catch. Else the VMM has provided the hypercall pages
+	 * with instructions of its own choosing, so use those.
+	 */
+	if (kvm_xen_hypercall_enabled(kvm)) {
+		u8 instructions[32];
+		int i;
+
+		if (page_num)
+			return 1;
+
+		/* mov imm32, %eax */
+		instructions[0] = 0xb8;
+
+		/* vmcall / vmmcall */
+		kvm_x86_ops.patch_hypercall(vcpu, instructions + 5);
+
+		/* ret */
+		instructions[8] = 0xc3;
+
+		/* int3 to pad */
+		memset(instructions + 9, 0xcc, sizeof(instructions) - 9);
+
+		for (i = 0; i < PAGE_SIZE / sizeof(instructions); i++) {
+			*(u32 *)&instructions[1] = i;
+			if (kvm_vcpu_write_guest(vcpu,
+						 page_addr + (i * sizeof(instructions)),
+						 instructions, sizeof(instructions)))
+				return 1;
+		}
+	} else {
+		int lm = is_long_mode(vcpu);
+		u8 *blob_addr = lm ? (u8 *)(long)kvm->arch.xen_hvm_config.blob_addr_64
+				   : (u8 *)(long)kvm->arch.xen_hvm_config.blob_addr_32;
+		u8 blob_size = lm ? kvm->arch.xen_hvm_config.blob_size_64
+				  : kvm->arch.xen_hvm_config.blob_size_32;
+		u8 *page;
+
+		if (page_num >= blob_size)
+			return 1;
+
+		page = memdup_user(blob_addr + (page_num * PAGE_SIZE), PAGE_SIZE);
+		if (IS_ERR(page))
+			return PTR_ERR(page);
+
+		if (kvm_vcpu_write_guest(vcpu, page_addr, page, PAGE_SIZE)) {
+			kfree(page);
+			return 1;
+		}
+	}
+	return 0;
+}
+
+static int kvm_xen_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
+{
+	kvm_rax_write(vcpu, result);
+	return kvm_skip_emulated_instruction(vcpu);
+}
+
+static int kvm_xen_hypercall_complete_userspace(struct kvm_vcpu *vcpu)
+{
+	struct kvm_run *run = vcpu->run;
+
+	if (unlikely(!kvm_is_linear_rip(vcpu, vcpu->arch.xen.hypercall_rip)))
+		return 1;
+
+	return kvm_xen_hypercall_set_result(vcpu, run->xen.u.hcall.result);
+}
+
+int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
+{
+	bool longmode;
+	u64 input, params[6];
+
+	input = (u64)kvm_register_read(vcpu, VCPU_REGS_RAX);
+
+	longmode = is_64_bit_mode(vcpu);
+	if (!longmode) {
+		params[0] = (u32)kvm_rbx_read(vcpu);
+		params[1] = (u32)kvm_rcx_read(vcpu);
+		params[2] = (u32)kvm_rdx_read(vcpu);
+		params[3] = (u32)kvm_rsi_read(vcpu);
+		params[4] = (u32)kvm_rdi_read(vcpu);
+		params[5] = (u32)kvm_rbp_read(vcpu);
+	}
+#ifdef CONFIG_X86_64
+	else {
+		params[0] = (u64)kvm_rdi_read(vcpu);
+		params[1] = (u64)kvm_rsi_read(vcpu);
+		params[2] = (u64)kvm_rdx_read(vcpu);
+		params[3] = (u64)kvm_r10_read(vcpu);
+		params[4] = (u64)kvm_r8_read(vcpu);
+		params[5] = (u64)kvm_r9_read(vcpu);
+	}
+#endif
+	trace_kvm_xen_hypercall(input, params[0], params[1], params[2],
+				params[3], params[4], params[5]);
+
+	vcpu->run->exit_reason = KVM_EXIT_XEN;
+	vcpu->run->xen.type = KVM_EXIT_XEN_HCALL;
+	vcpu->run->xen.u.hcall.longmode = longmode;
+	vcpu->run->xen.u.hcall.cpl = kvm_x86_ops.get_cpl(vcpu);
+	vcpu->run->xen.u.hcall.input = input;
+	vcpu->run->xen.u.hcall.params[0] = params[0];
+	vcpu->run->xen.u.hcall.params[1] = params[1];
+	vcpu->run->xen.u.hcall.params[2] = params[2];
+	vcpu->run->xen.u.hcall.params[3] = params[3];
+	vcpu->run->xen.u.hcall.params[4] = params[4];
+	vcpu->run->xen.u.hcall.params[5] = params[5];
+	vcpu->arch.xen.hypercall_rip = kvm_get_linear_rip(vcpu);
+	vcpu->arch.complete_userspace_io =
+		kvm_xen_hypercall_complete_userspace;
+
+	return 0;
+}
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
new file mode 100644
index 000000000000..81e12f716d2e
--- /dev/null
+++ b/arch/x86/kvm/xen.h
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright © 2019 Oracle and/or its affiliates. All rights reserved.
+ * Copyright © 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ *
+ * KVM Xen emulation
+ */
+
+#ifndef __ARCH_X86_KVM_XEN_H__
+#define __ARCH_X86_KVM_XEN_H__
+
+int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
+int kvm_xen_hvm_config(struct kvm_vcpu *vcpu, u64 data);
+
+static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
+{
+	return kvm->arch.xen_hvm_config.flags &
+		KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL;
+}
+
+#endif /* __ARCH_X86_KVM_XEN_H__ */
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ca41220b40b8..00221fe56994 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -216,6 +216,20 @@ struct kvm_hyperv_exit {
 	} u;
 };
 
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
+	} u;
+};
+
 #define KVM_S390_GET_SKEYS_NONE   1
 #define KVM_S390_SKEYS_MAX        1048576
 
@@ -250,6 +264,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_ARM_NISV         28
 #define KVM_EXIT_X86_RDMSR        29
 #define KVM_EXIT_X86_WRMSR        30
+#define KVM_EXIT_XEN              31
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -426,6 +441,8 @@ struct kvm_run {
 			__u32 index; /* kernel -> user */
 			__u64 data; /* kernel <-> user */
 		} msr;
+		/* KVM_EXIT_XEN */
+		struct kvm_xen_exit xen;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -1126,6 +1143,8 @@ struct kvm_x86_mce {
 #endif
 
 #ifdef KVM_CAP_XEN_HVM
+#define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
+
 struct kvm_xen_hvm_config {
 	__u32 flags;
 	__u32 msr;
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 3d14ef77755e..d94abec627e6 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -59,6 +59,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
 TEST_GEN_PROGS_x86_64 += x86_64/debug_regs
 TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/user_msr_test
+TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 126c6727a6b0..6e96ae47d28c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1654,6 +1654,7 @@ static struct exit_reason {
 	{KVM_EXIT_INTERNAL_ERROR, "INTERNAL_ERROR"},
 	{KVM_EXIT_OSI, "OSI"},
 	{KVM_EXIT_PAPR_HCALL, "PAPR_HCALL"},
+	{KVM_EXIT_XEN, "XEN"},
 #ifdef KVM_EXIT_MEMORY_NOT_PRESENT
 	{KVM_EXIT_MEMORY_NOT_PRESENT, "MEMORY_NOT_PRESENT"},
 #endif
diff --git a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
new file mode 100644
index 000000000000..3f1dd93626e5
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * svm_vmcall_test
+ *
+ * Copyright © 2020 Amazon.com, Inc. or its affiliates.
+ *
+ * Userspace hypercall testing
+ */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+#define VCPU_ID		5
+
+#define HCALL_REGION_GPA	0xc0000000ULL
+#define HCALL_REGION_SLOT	10
+
+static struct kvm_vm *vm;
+
+#define INPUTVALUE 17
+#define ARGVALUE(x) (0xdeadbeef5a5a0000UL + x)
+#define RETVALUE 0xcafef00dfbfbffffUL
+
+#define XEN_HYPERCALL_MSR 0x40000000
+
+static void guest_code(void)
+{
+	unsigned long rax = INPUTVALUE;
+	unsigned long rdi = ARGVALUE(1);
+	unsigned long rsi = ARGVALUE(2);
+	unsigned long rdx = ARGVALUE(3);
+	register unsigned long r10 __asm__("r10") = ARGVALUE(4);
+	register unsigned long r8 __asm__("r8") = ARGVALUE(5);
+	register unsigned long r9 __asm__("r9") = ARGVALUE(6);
+
+	/* First a direct invocation of 'vmcall' */
+	__asm__ __volatile__("vmcall" :
+			     "=a"(rax) :
+			     "a"(rax), "D"(rdi), "S"(rsi), "d"(rdx),
+			     "r"(r10), "r"(r8), "r"(r9));
+	GUEST_ASSERT(rax == RETVALUE);
+
+	/* Now fill in the hypercall page */
+	__asm__ __volatile__("wrmsr" : : "c" (XEN_HYPERCALL_MSR),
+			     "a" (HCALL_REGION_GPA & 0xffffffff),
+			     "d" (HCALL_REGION_GPA >> 32));
+
+	/* And invoke the same hypercall that way */
+	__asm__ __volatile__("call *%1" : "=a"(rax) :
+			     "r"(HCALL_REGION_GPA + INPUTVALUE * 32),
+			     "a"(rax), "D"(rdi), "S"(rsi), "d"(rdx),
+			     "r"(r10), "r"(r8), "r"(r9));
+	GUEST_ASSERT(rax == RETVALUE);
+
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	if (!(kvm_check_cap(KVM_CAP_XEN_HVM) &
+	      KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL) ) {
+		print_skip("KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL not available");
+		exit(KSFT_SKIP);
+	}
+
+	vm = vm_create_default(VCPU_ID, 0, (void *) guest_code);
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+
+	struct kvm_xen_hvm_config hvmc = {
+		.flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL,
+		.msr = XEN_HYPERCALL_MSR,
+	};
+	vm_ioctl(vm, KVM_XEN_HVM_CONFIG, &hvmc);
+
+	/* Map a region for the hypercall page */
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+                                    HCALL_REGION_GPA, HCALL_REGION_SLOT,
+				    getpagesize(), 0);
+	virt_map(vm, HCALL_REGION_GPA, HCALL_REGION_GPA, 1, 0);
+
+	for (;;) {
+		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+		struct ucall uc;
+
+		vcpu_run(vm, VCPU_ID);
+
+		if (run->exit_reason == KVM_EXIT_XEN) {
+			ASSERT_EQ(run->xen.type, KVM_EXIT_XEN_HCALL);
+			ASSERT_EQ(run->xen.u.hcall.cpl, 0);
+			ASSERT_EQ(run->xen.u.hcall.longmode, 1);
+			ASSERT_EQ(run->xen.u.hcall.input, INPUTVALUE);
+			ASSERT_EQ(run->xen.u.hcall.params[0], ARGVALUE(1));
+			ASSERT_EQ(run->xen.u.hcall.params[1], ARGVALUE(2));
+			ASSERT_EQ(run->xen.u.hcall.params[2], ARGVALUE(3));
+			ASSERT_EQ(run->xen.u.hcall.params[3], ARGVALUE(4));
+			ASSERT_EQ(run->xen.u.hcall.params[4], ARGVALUE(5));
+			ASSERT_EQ(run->xen.u.hcall.params[5], ARGVALUE(6));
+			run->xen.u.hcall.result = RETVALUE;
+			continue;
+		}
+
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
+			    run->exit_reason,
+			    exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_ABORT:
+			TEST_FAIL("%s", (const char *)uc.args[0]);
+			/* NOT REACHED */
+		case UCALL_SYNC:
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall 0x%lx.", uc.cmd);
+		}
+	}
+done:
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.26.2

