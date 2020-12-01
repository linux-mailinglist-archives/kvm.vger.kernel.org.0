Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78AA52C9E53
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 10:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391054AbgLAJtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 04:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391044AbgLAJtn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 04:49:43 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFFAC0613CF;
        Tue,  1 Dec 2020 01:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MWkNSoZ3D07G192OOADegav63gGyGdDp8F2F38XjV+M=; b=jMEzvUza8lZSDq/lXnEJw3jhrO
        U1FpFuF6MzQxmj/FOKppiNJy4XcgbU8LGLf7MG4284ruWb6p2j3bGZsjj7o/1RNeWNxhoO6w+rAFX
        IhWm+hF+4oznI8QHOhHUBJ5Lu2+L+aZ6wPMou8gxWLFzCMgB1ZB/kU7I/LDo7fzFnJRaZQDBE1bNF
        /TWUftx8jdVlfck9ygp9QhqMgtpCJjc3B6kwJnKGPRXbkGq8YGDJV3LVQVH1QidSh+Nt55O2d1aj/
        gCKnahUOVRT0oMcK7ZMsoUNM29pYW9M1hC0Pv+j0UVlM0E1wRQLN2ts+mJbazF4ZtCGvjA7lPuzxe
        IP/PKOlA==;
Received: from dyn-227.woodhou.se ([90.155.92.227] helo=u3832b3a9db3152.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kk2HK-0000mv-D6; Tue, 01 Dec 2020 09:48:58 +0000
Message-ID: <b56f763e6bf29a65a11b7a36c4d7bfa79b2ec1b2.camel@infradead.org>
Subject: Re: [PATCH RFC 02/39] KVM: x86/xen: intercept xen hypercalls if
 enabled
From:   David Woodhouse <dwmw2@infradead.org>
To:     Joao Martins <joao.m.martins@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Date:   Tue, 01 Dec 2020 09:48:56 +0000
In-Reply-To: <20190220201609.28290-3-joao.m.martins@oracle.com>
References: <20190220201609.28290-1-joao.m.martins@oracle.com>
         <20190220201609.28290-3-joao.m.martins@oracle.com>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-8CJS0TjsYLv+JTyOHTwh"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-8CJS0TjsYLv+JTyOHTwh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-02-20 at 20:15 +0000, Joao Martins wrote:
> Add a new exit reason for emulator to handle Xen hypercalls.
> Albeit these are injected only if guest has initialized the Xen
> hypercall page=20

I've reworked this a little.

I didn't like the inconsistency of allowing userspace to provide the
hypercall pages even though the ABI is now defined by the kernel and it
*has* to be VMCALL/VMMCALL.

So I switched it to generate the hypercall page directly from the
kernel, just like we do for the Hyper-V hypercall page.

I introduced a new flag in the xen_hvm_config struct to enable this
behaviour, and advertised it in the KVM_CAP_XEN_HVM return value.

I also added the cpl and support for 6-argument hypercalls, and made it
check the guest RIP when completing the call as discussed (although I
still think that probably ought to be a generic thing).

I adjusted the test case from my version of the patch, and added
support for actually testing the hypercall page MSR.

https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/xenpv

I'll go through and rebase your patch series at least up to patch 16
and collect them in that tree, then probably post them for real once
I've got everything working locally.


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=46rom c037c329c8867b219afe2100e383c62e9db7b06d Mon Sep 17 00:00:00 2001
From: Joao Martins <joao.m.martins@oracle.com>
Date: Wed, 13 Jun 2018 09:55:44 -0400
Subject: [PATCH] KVM: x86/xen: intercept xen hypercalls if enabled

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

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 7e5f33a0d0e2..9de3229e91e1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -520,6 +520,11 @@ struct kvm_vcpu_hv {
 	cpumask_t tlb_flush;
 };
=20
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
=20
 	struct kvm_vcpu_hv hyperv;
+	struct kvm_vcpu_xen xen;
=20
 	cpumask_var_t wbinvd_dirty_mask;
=20
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index b804444e16d4..8bee4afc1fec 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -13,7 +13,7 @@ kvm-y			+=3D $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
 				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+=3D $(KVM)/async_pf.o
=20
-kvm-y			+=3D x86.o emulate.o i8259.o irq.o lapic.o \
+kvm-y			+=3D x86.o emulate.o i8259.o irq.o lapic.o xen.o \
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
=20
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
+		__entry->nr =3D nr;
+		__entry->a0 =3D a0;
+		__entry->a1 =3D a1;
+		__entry->a2 =3D a2;
+		__entry->a3 =3D a3;
+		__entry->a4 =3D a4;
+		__entry->a4 =3D a5;
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
index 0836023963ec..adf04e8cc64a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -29,6 +29,7 @@
 #include "pmu.h"
 #include "hyperv.h"
 #include "lapic.h"
+#include "xen.h"
=20
 #include <linux/clocksource.h>
 #include <linux/interrupt.h>
@@ -2842,32 +2843,6 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct=
 msr_data *msr_info)
 	return 0;
 }
=20
-static int xen_hvm_config(struct kvm_vcpu *vcpu, u64 data)
-{
-	struct kvm *kvm =3D vcpu->kvm;
-	int lm =3D is_long_mode(vcpu);
-	u8 *blob_addr =3D lm ? (u8 *)(long)kvm->arch.xen_hvm_config.blob_addr_64
-		: (u8 *)(long)kvm->arch.xen_hvm_config.blob_addr_32;
-	u8 blob_size =3D lm ? kvm->arch.xen_hvm_config.blob_size_64
-		: kvm->arch.xen_hvm_config.blob_size_32;
-	u32 page_num =3D data & ~PAGE_MASK;
-	u64 page_addr =3D data & PAGE_MASK;
-	u8 *page;
-
-	if (page_num >=3D blob_size)
-		return 1;
-
-	page =3D memdup_user(blob_addr + (page_num * PAGE_SIZE), PAGE_SIZE);
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
 	u64 mask =3D KVM_ASYNC_PF_ENABLED | KVM_ASYNC_PF_DELIVERY_AS_INT;
@@ -3002,7 +2977,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct =
msr_data *msr_info)
 	u64 data =3D msr_info->data;
=20
 	if (msr && (msr =3D=3D vcpu->kvm->arch.xen_hvm_config.msr))
-		return xen_hvm_config(vcpu, data);
+		return kvm_xen_hvm_config(vcpu, data);
=20
 	switch (msr) {
 	case MSR_AMD64_NB_CFG:
@@ -3703,7 +3678,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lon=
g ext)
 	case KVM_CAP_PIT2:
 	case KVM_CAP_PIT_STATE2:
 	case KVM_CAP_SET_IDENTITY_MAP_ADDR:
-	case KVM_CAP_XEN_HVM:
 	case KVM_CAP_VCPU_EVENTS:
 	case KVM_CAP_HYPERV:
 	case KVM_CAP_HYPERV_VAPIC:
@@ -3742,6 +3716,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, lon=
g ext)
 	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
 		r =3D 1;
 		break;
+	case KVM_CAP_XEN_HVM:
+		r =3D 1 | KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL;
+		break;
 	case KVM_CAP_SYNC_REGS:
 		r =3D KVM_SYNC_X86_VALID_FIELDS;
 		break;
@@ -5603,7 +5580,15 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		if (copy_from_user(&xhc, argp, sizeof(xhc)))
 			goto out;
 		r =3D -EINVAL;
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
 		r =3D 0;
@@ -8066,6 +8051,9 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 	unsigned long nr, a0, a1, a2, a3, ret;
 	int op_64_bit;
=20
+	if (kvm_xen_hypercall_enabled(vcpu->kvm))
+		return kvm_xen_hypercall(vcpu);
+
 	if (kvm_hv_hypercall_enabled(vcpu->kvm))
 		return kvm_hv_hypercall(vcpu);
=20
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
new file mode 100644
index 000000000000..6400a4bc8480
--- /dev/null
+++ b/arch/x86/kvm/xen.c
@@ -0,0 +1,140 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright =C2=A9 2019 Oracle and/or its affiliates. All rights reserved=
.
+ * Copyright =C2=A9 2020 Amazon.com, Inc. or its affiliates. All Rights Re=
served.
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
+	{
+	struct kvm *kvm =3D vcpu->kvm;
+	u32 page_num =3D data & ~PAGE_MASK;
+	u64 page_addr =3D data & PAGE_MASK;
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
+		instructions[0] =3D 0xb8;
+
+		/* vmcall / vmmcall */
+		kvm_x86_ops.patch_hypercall(vcpu, instructions + 5);
+
+		/* ret */
+		instructions[8] =3D 0xc3;
+
+		/* int3 to pad */
+		memset(instructions + 9, 0xcc, sizeof(instructions) - 9);
+
+		for (i =3D 0; i < PAGE_SIZE / sizeof(instructions); i++) {
+			*(u32 *)&instructions[1] =3D i;
+			if (kvm_vcpu_write_guest(vcpu,
+						 page_addr + (i * sizeof(instructions)),
+						 instructions, sizeof(instructions)))
+				return 1;
+		}
+	} else {
+		int lm =3D is_long_mode(vcpu);
+		u8 *blob_addr =3D lm ? (u8 *)(long)kvm->arch.xen_hvm_config.blob_addr_64
+				   : (u8 *)(long)kvm->arch.xen_hvm_config.blob_addr_32;
+		u8 blob_size =3D lm ? kvm->arch.xen_hvm_config.blob_size_64
+				  : kvm->arch.xen_hvm_config.blob_size_32;
+		u8 *page;
+
+		if (page_num >=3D blob_size)
+			return 1;
+
+		page =3D memdup_user(blob_addr + (page_num * PAGE_SIZE), PAGE_SIZE);
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
+	struct kvm_run *run =3D vcpu->run;
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
+	input =3D (u64)kvm_register_read(vcpu, VCPU_REGS_RAX);
+
+	longmode =3D is_64_bit_mode(vcpu);
+	if (!longmode) {
+		params[0] =3D (u32)kvm_rbx_read(vcpu);
+		params[1] =3D (u32)kvm_rcx_read(vcpu);
+		params[2] =3D (u32)kvm_rdx_read(vcpu);
+		params[3] =3D (u32)kvm_rsi_read(vcpu);
+		params[4] =3D (u32)kvm_rdi_read(vcpu);
+		params[5] =3D (u32)kvm_rbp_read(vcpu);
+	}
+#ifdef CONFIG_X86_64
+	else {
+		params[0] =3D (u64)kvm_rdi_read(vcpu);
+		params[1] =3D (u64)kvm_rsi_read(vcpu);
+		params[2] =3D (u64)kvm_rdx_read(vcpu);
+		params[3] =3D (u64)kvm_r10_read(vcpu);
+		params[4] =3D (u64)kvm_r8_read(vcpu);
+		params[5] =3D (u64)kvm_r9_read(vcpu);
+	}
+#endif
+	trace_kvm_xen_hypercall(input, params[0], params[1], params[2],
+				params[3], params[4], params[5]);
+
+	vcpu->run->exit_reason =3D KVM_EXIT_XEN;
+	vcpu->run->xen.type =3D KVM_EXIT_XEN_HCALL;
+	vcpu->run->xen.u.hcall.longmode =3D longmode;
+	vcpu->run->xen.u.hcall.cpl =3D kvm_x86_ops.get_cpl(vcpu);
+	vcpu->run->xen.u.hcall.input =3D input;
+	vcpu->run->xen.u.hcall.params[0] =3D params[0];
+	vcpu->run->xen.u.hcall.params[1] =3D params[1];
+	vcpu->run->xen.u.hcall.params[2] =3D params[2];
+	vcpu->run->xen.u.hcall.params[3] =3D params[3];
+	vcpu->run->xen.u.hcall.params[4] =3D params[4];
+	vcpu->run->xen.u.hcall.params[5] =3D params[5];
+	vcpu->arch.xen.hypercall_rip =3D kvm_get_linear_rip(vcpu);
+	vcpu->arch.complete_userspace_io =3D
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
+ * Copyright =C2=A9 2019 Oracle and/or its affiliates. All rights reserved=
.
+ * Copyright =C2=A9 2020 Amazon.com, Inc. or its affiliates. All Rights Re=
served.
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
=20
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
=20
@@ -250,6 +264,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_ARM_NISV         28
 #define KVM_EXIT_X86_RDMSR        29
 #define KVM_EXIT_X86_WRMSR        30
+#define KVM_EXIT_XEN              31
=20
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
=20
 #ifdef KVM_CAP_XEN_HVM
+#define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
+
 struct kvm_xen_hvm_config {
 	__u32 flags;
 	__u32 msr;
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests=
/kvm/Makefile
index 3d14ef77755e..d94abec627e6 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -59,6 +59,7 @@ TEST_GEN_PROGS_x86_64 +=3D x86_64/xss_msr_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/debug_regs
 TEST_GEN_PROGS_x86_64 +=3D x86_64/tsc_msrs_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/user_msr_test
+TEST_GEN_PROGS_x86_64 +=3D x86_64/xen_vmcall_test
 TEST_GEN_PROGS_x86_64 +=3D demand_paging_test
 TEST_GEN_PROGS_x86_64 +=3D dirty_log_test
 TEST_GEN_PROGS_x86_64 +=3D dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/sel=
ftests/kvm/lib/kvm_util.c
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
diff --git a/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c b/tools/t=
esting/selftests/kvm/x86_64/xen_vmcall_test.c
new file mode 100644
index 000000000000..3f1dd93626e5
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/xen_vmcall_test.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * svm_vmcall_test
+ *
+ * Copyright =C2=A9 2020 Amazon.com, Inc. or its affiliates.
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
+	unsigned long rax =3D INPUTVALUE;
+	unsigned long rdi =3D ARGVALUE(1);
+	unsigned long rsi =3D ARGVALUE(2);
+	unsigned long rdx =3D ARGVALUE(3);
+	register unsigned long r10 __asm__("r10") =3D ARGVALUE(4);
+	register unsigned long r8 __asm__("r8") =3D ARGVALUE(5);
+	register unsigned long r9 __asm__("r9") =3D ARGVALUE(6);
+
+	/* First a direct invocation of 'vmcall' */
+	__asm__ __volatile__("vmcall" :
+			     "=3Da"(rax) :
+			     "a"(rax), "D"(rdi), "S"(rsi), "d"(rdx),
+			     "r"(r10), "r"(r8), "r"(r9));
+	GUEST_ASSERT(rax =3D=3D RETVALUE);
+
+	/* Now fill in the hypercall page */
+	__asm__ __volatile__("wrmsr" : : "c" (XEN_HYPERCALL_MSR),
+			     "a" (HCALL_REGION_GPA & 0xffffffff),
+			     "d" (HCALL_REGION_GPA >> 32));
+
+	/* And invoke the same hypercall that way */
+	__asm__ __volatile__("call *%1" : "=3Da"(rax) :
+			     "r"(HCALL_REGION_GPA + INPUTVALUE * 32),
+			     "a"(rax), "D"(rdi), "S"(rsi), "d"(rdx),
+			     "r"(r10), "r"(r8), "r"(r9));
+	GUEST_ASSERT(rax =3D=3D RETVALUE);
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
+	vm =3D vm_create_default(VCPU_ID, 0, (void *) guest_code);
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+
+	struct kvm_xen_hvm_config hvmc =3D {
+		.flags =3D KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL,
+		.msr =3D XEN_HYPERCALL_MSR,
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
+		volatile struct kvm_run *run =3D vcpu_state(vm, VCPU_ID);
+		struct ucall uc;
+
+		vcpu_run(vm, VCPU_ID);
+
+		if (run->exit_reason =3D=3D KVM_EXIT_XEN) {
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
+			run->xen.u.hcall.result =3D RETVALUE;
+			continue;
+		}
+
+		TEST_ASSERT(run->exit_reason =3D=3D KVM_EXIT_IO,
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
--=20
2.17.1


--=-8CJS0TjsYLv+JTyOHTwh
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCECow
ggUcMIIEBKADAgECAhEA4rtJSHkq7AnpxKUY8ZlYZjANBgkqhkiG9w0BAQsFADCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMTkwMTAyMDAwMDAwWhcNMjIwMTAxMjM1
OTU5WjAkMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZyYWRlYWQub3JnMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAsv3wObLTCbUA7GJqKj9vHGf+Fa+tpkO+ZRVve9EpNsMsfXhvFpb8
RgL8vD+L133wK6csYoDU7zKiAo92FMUWaY1Hy6HqvVr9oevfTV3xhB5rQO1RHJoAfkvhy+wpjo7Q
cXuzkOpibq2YurVStHAiGqAOMGMXhcVGqPuGhcVcVzVUjsvEzAV9Po9K2rpZ52FE4rDkpDK1pBK+
uOAyOkgIg/cD8Kugav5tyapydeWMZRJQH1vMQ6OVT24CyAn2yXm2NgTQMS1mpzStP2ioPtTnszIQ
Ih7ASVzhV6csHb8Yrkx8mgllOyrt9Y2kWRRJFm/FPRNEurOeNV6lnYAXOymVJwIDAQABo4IB0zCC
Ac8wHwYDVR0jBBgwFoAUgq9sjPjF/pZhfOgfPStxSF7Ei8AwHQYDVR0OBBYEFLfuNf820LvaT4AK
xrGK3EKx1DE7MA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUF
BwMEBggrBgEFBQcDAjBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDBTArMCkGCCsGAQUFBwIBFh1o
dHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3Js
LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWls
Q0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuY29tb2RvY2Eu
Y29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAeBgNVHREEFzAVgRNkd213MkBpbmZy
YWRlYWQub3JnMA0GCSqGSIb3DQEBCwUAA4IBAQALbSykFusvvVkSIWttcEeifOGGKs7Wx2f5f45b
nv2ghcxK5URjUvCnJhg+soxOMoQLG6+nbhzzb2rLTdRVGbvjZH0fOOzq0LShq0EXsqnJbbuwJhK+
PnBtqX5O23PMHutP1l88AtVN+Rb72oSvnD+dK6708JqqUx2MAFLMevrhJRXLjKb2Mm+/8XBpEw+B
7DisN4TMlLB/d55WnT9UPNHmQ+3KFL7QrTO8hYExkU849g58Dn3Nw3oCbMUgny81ocrLlB2Z5fFG
Qu1AdNiBA+kg/UxzyJZpFbKfCITd5yX49bOriL692aMVDyqUvh8fP+T99PqorH4cIJP6OxSTdxKM
MIIFHDCCBASgAwIBAgIRAOK7SUh5KuwJ6cSlGPGZWGYwDQYJKoZIhvcNAQELBQAwgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTE5MDEwMjAwMDAwMFoXDTIyMDEwMTIz
NTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBALL98Dmy0wm1AOxiaio/bxxn/hWvraZDvmUVb3vRKTbDLH14bxaW
/EYC/Lw/i9d98CunLGKA1O8yogKPdhTFFmmNR8uh6r1a/aHr301d8YQea0DtURyaAH5L4cvsKY6O
0HF7s5DqYm6tmLq1UrRwIhqgDjBjF4XFRqj7hoXFXFc1VI7LxMwFfT6PStq6WedhROKw5KQytaQS
vrjgMjpICIP3A/CroGr+bcmqcnXljGUSUB9bzEOjlU9uAsgJ9sl5tjYE0DEtZqc0rT9oqD7U57My
ECIewElc4VenLB2/GK5MfJoJZTsq7fWNpFkUSRZvxT0TRLqznjVepZ2AFzsplScCAwEAAaOCAdMw
ggHPMB8GA1UdIwQYMBaAFIKvbIz4xf6WYXzoHz0rcUhexIvAMB0GA1UdDgQWBBS37jX/NtC72k+A
CsaxitxCsdQxOzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggrBgEF
BQcDBAYIKwYBBQUHAwIwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwUwKzApBggrBgEFBQcCARYd
aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2Ny
bC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFp
bENBLmNybDCBiwYIKwYBBQUHAQEEfzB9MFUGCCsGAQUFBzAChklodHRwOi8vY3J0LmNvbW9kb2Nh
LmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3J0MCQG
CCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAC20spBbrL71ZEiFrbXBHonzhhirO1sdn+X+O
W579oIXMSuVEY1LwpyYYPrKMTjKECxuvp24c829qy03UVRm742R9Hzjs6tC0oatBF7KpyW27sCYS
vj5wbal+TttzzB7rT9ZfPALVTfkW+9qEr5w/nSuu9PCaqlMdjABSzHr64SUVy4ym9jJvv/FwaRMP
gew4rDeEzJSwf3eeVp0/VDzR5kPtyhS+0K0zvIWBMZFPOPYOfA59zcN6AmzFIJ8vNaHKy5QdmeXx
RkLtQHTYgQPpIP1Mc8iWaRWynwiE3ecl+PWzq4i+vdmjFQ8qlL4fHz/k/fT6qKx+HCCT+jsUk3cS
jDCCBeYwggPOoAMCAQICEGqb4Tg7/ytrnwHV2binUlYwDQYJKoZIhvcNAQEMBQAwgYUxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRp
b24gQXV0aG9yaXR5MB4XDTEzMDExMDAwMDAwMFoXDTI4MDEwOTIzNTk1OVowgZcxCzAJBgNVBAYT
AkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNV
BAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAvrOeV6wodnVAFsc4A5jTxhh2IVDzJXkLTLWg0X06WD6cpzEup/Y0dtmEatrQPTRI5Or1u6zf
+bGBSyD9aH95dDSmeny1nxdlYCeXIoymMv6pQHJGNcIDpFDIMypVpVSRsivlJTRENf+RKwrB6vcf
WlP8dSsE3Rfywq09N0ZfxcBa39V0wsGtkGWC+eQKiz4pBZYKjrc5NOpG9qrxpZxyb4o4yNNwTqza
aPpGRqXB7IMjtf7tTmU2jqPMLxFNe1VXj9XB1rHvbRikw8lBoNoSWY66nJN/VCJv5ym6Q0mdCbDK
CMPybTjoNCQuelc0IAaO4nLUXk0BOSxSxt8kCvsUtQIDAQABo4IBPDCCATgwHwYDVR0jBBgwFoAU
u69+Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYEFIKvbIz4xf6WYXzoHz0rcUhexIvAMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8E
RTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9u
QXV0aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29t
b2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
cC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIBAHhcsoEoNE887l9Wzp+XVuyPomsX9vP2
SQgG1NgvNc3fQP7TcePo7EIMERoh42awGGsma65u/ITse2hKZHzT0CBxhuhb6txM1n/y78e/4ZOs
0j8CGpfb+SJA3GaBQ+394k+z3ZByWPQedXLL1OdK8aRINTsjk/H5Ns77zwbjOKkDamxlpZ4TKSDM
KVmU/PUWNMKSTvtlenlxBhh7ETrN543j/Q6qqgCWgWuMAXijnRglp9fyadqGOncjZjaaSOGTTFB+
E2pvOUtY+hPebuPtTbq7vODqzCM6ryEhNhzf+enm0zlpXK7q332nXttNtjv7VFNYG+I31gnMrwfH
M5tdhYF/8v5UY5g2xANPECTQdu9vWPoqNSGDt87b3gXb1AiGGaI06vzgkejL580ul+9hz9D0S0U4
jkhJiA7EuTecP/CFtR72uYRBcunwwH3fciPjviDDAI9SnC/2aPY8ydehzuZutLbZdRJ5PDEJM/1t
yZR2niOYihZ+FCbtf3D9mB12D4ln9icgc7CwaxpNSCPt8i/GqK2HsOgkL3VYnwtx7cJUmpvVdZ4o
gnzgXtgtdk3ShrtOS1iAN2ZBXFiRmjVzmehoMof06r1xub+85hFQzVxZx5/bRaTKTlL8YXLI8nAb
R9HWdFqzcOoB/hxfEyIQpx9/s81rgzdEZOofSlZHynoSMYIDyjCCA8YCAQEwga0wgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA4rtJSHkq7AnpxKUY8ZlYZjANBglghkgB
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAx
MjAxMDk0ODU2WjAvBgkqhkiG9w0BCQQxIgQgVi7ufE/v4C9ItLE61nqMoflI2UvTcrPSLEqW1dw2
e2Ewgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBAKrfXf/2MPB+hMHfKF7MAb4MMjUFf+cOzdROX4NfGzr6ZzeQmLe8/3aGI7E5qYym
FWWSObFRFQJSMSJNwoeS1GGEhdzqtSdaDpwgi7os5jSaaMd4Tz6d/jsbOcXGDlAig6gxOkj9ZPlD
MNv+fg7Pw63OmDB5DwKUFlsARjDlrrrnDga4l+Ebb3L5cvMFrjxMXUefhePQq0NuyT6K1jfJ5v92
gLVNd0mBzWzD5wTvHk3VVUj6yCfHGSdXvhhnqFTymP3gWcVyh9/0WFtwT/2Uyq9e70K5EGp4j+J0
GG6URWpzdezkreZPaq8kgBBh0LByfITFc8nXK/GUCtom6LVmZ7AAAAAAAAA=


--=-8CJS0TjsYLv+JTyOHTwh--

