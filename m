Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1C2B151CCC
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 16:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgBDPBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 10:01:07 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33426 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727305AbgBDPBG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 10:01:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580828465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BWoGPmHhMJa8SezhaB2vrGyvHBTGMEcvPmfDjyXjET4=;
        b=Jv//VIMw80wTSPa6oXE3wzpMkKqh9TrXibhlOaVXHGVhM/GcrJlT3EohudDNJmwg+7o3/o
        8kPtXlwwEApIsDx6VxrjiFC+THMJl5Mz66exgYvhVhGWrOGGVK+JqmnoCZ1tAjuzM4NbfZ
        HnRIhzGScRlWRT+MSbjTR4YCs0/B+TE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-TjAcIu5ePHW5UpUiq1iqrw-1; Tue, 04 Feb 2020 10:01:00 -0500
X-MC-Unique: TjAcIu5ePHW5UpUiq1iqrw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA9B9A0CDC;
        Tue,  4 Feb 2020 15:00:59 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABA0C7FB79;
        Tue,  4 Feb 2020 15:00:55 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com
Subject: [PATCH v3 2/3] selftests: KVM: AMD Nested test infrastructure
Date:   Tue,  4 Feb 2020 16:00:39 +0100
Message-Id: <20200204150040.2465-3-eric.auger@redhat.com>
In-Reply-To: <20200204150040.2465-1-eric.auger@redhat.com>
References: <20200204150040.2465-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the basic infrastructure needed to test AMD nested SVM.
This is largely copied from the KVM unit test infrastructure.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v2 -> v3:
- s/regs/gp_regs64
- Split the header into 2 parts: svm.h is a copy of
  arch/x86/include/asm/svm.h whereas svm_util.h contains
  testing add-ons
- use get_gdt/dt() and remove sgdt/sidt
- use get_es/ss/ds/cs
- fix clobber for dr6 & dr7
- use u64 instead of ulong
---
 tools/testing/selftests/kvm/Makefile          |   2 +-
 .../selftests/kvm/include/x86_64/processor.h  |  20 ++
 .../selftests/kvm/include/x86_64/svm.h        | 297 ++++++++++++++++++
 .../selftests/kvm/include/x86_64/svm_util.h   |  36 +++
 tools/testing/selftests/kvm/lib/x86_64/svm.c  | 159 ++++++++++
 5 files changed, 513 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/svm.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/svm_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/svm.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftes=
ts/kvm/Makefile
index 608fa835c764..2e770f554cae 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -8,7 +8,7 @@ KSFT_KHDR_INSTALL :=3D 1
 UNAME_M :=3D $(shell uname -m)
=20
 LIBKVM =3D lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/sparsebit.=
c
-LIBKVM_x86_64 =3D lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/uca=
ll.c
+LIBKVM_x86_64 =3D lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm=
.c lib/x86_64/ucall.c
 LIBKVM_aarch64 =3D lib/aarch64/processor.c lib/aarch64/ucall.c
 LIBKVM_s390x =3D lib/s390x/processor.c lib/s390x/ucall.c
=20
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/too=
ls/testing/selftests/kvm/include/x86_64/processor.h
index 6f7fffaea2e8..d707354c315c 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -56,6 +56,26 @@ enum x86_register {
 	R15,
 };
=20
+struct gp_regs64 {
+	u64 rax;
+	u64 rbx;
+	u64 rcx;
+	u64 rdx;
+	u64 cr2;
+	u64 rbp;
+	u64 rsi;
+	u64 rdi;
+	u64 r8;
+	u64 r9;
+	u64 r10;
+	u64 r11;
+	u64 r12;
+	u64 r13;
+	u64 r14;
+	u64 r15;
+	u64 rflags;
+};
+
 struct desc64 {
 	uint16_t limit0;
 	uint16_t base0;
diff --git a/tools/testing/selftests/kvm/include/x86_64/svm.h b/tools/tes=
ting/selftests/kvm/include/x86_64/svm.h
new file mode 100644
index 000000000000..f4ea2355dbc2
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86_64/svm.h
@@ -0,0 +1,297 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * tools/testing/selftests/kvm/include/x86_64/svm.h
+ * This is a copy of arch/x86/include/asm/svm.h
+ *
+ */
+
+#ifndef SELFTEST_KVM_SVM_H
+#define SELFTEST_KVM_SVM_H
+
+enum {
+	INTERCEPT_INTR,
+	INTERCEPT_NMI,
+	INTERCEPT_SMI,
+	INTERCEPT_INIT,
+	INTERCEPT_VINTR,
+	INTERCEPT_SELECTIVE_CR0,
+	INTERCEPT_STORE_IDTR,
+	INTERCEPT_STORE_GDTR,
+	INTERCEPT_STORE_LDTR,
+	INTERCEPT_STORE_TR,
+	INTERCEPT_LOAD_IDTR,
+	INTERCEPT_LOAD_GDTR,
+	INTERCEPT_LOAD_LDTR,
+	INTERCEPT_LOAD_TR,
+	INTERCEPT_RDTSC,
+	INTERCEPT_RDPMC,
+	INTERCEPT_PUSHF,
+	INTERCEPT_POPF,
+	INTERCEPT_CPUID,
+	INTERCEPT_RSM,
+	INTERCEPT_IRET,
+	INTERCEPT_INTn,
+	INTERCEPT_INVD,
+	INTERCEPT_PAUSE,
+	INTERCEPT_HLT,
+	INTERCEPT_INVLPG,
+	INTERCEPT_INVLPGA,
+	INTERCEPT_IOIO_PROT,
+	INTERCEPT_MSR_PROT,
+	INTERCEPT_TASK_SWITCH,
+	INTERCEPT_FERR_FREEZE,
+	INTERCEPT_SHUTDOWN,
+	INTERCEPT_VMRUN,
+	INTERCEPT_VMMCALL,
+	INTERCEPT_VMLOAD,
+	INTERCEPT_VMSAVE,
+	INTERCEPT_STGI,
+	INTERCEPT_CLGI,
+	INTERCEPT_SKINIT,
+	INTERCEPT_RDTSCP,
+	INTERCEPT_ICEBP,
+	INTERCEPT_WBINVD,
+	INTERCEPT_MONITOR,
+	INTERCEPT_MWAIT,
+	INTERCEPT_MWAIT_COND,
+	INTERCEPT_XSETBV,
+	INTERCEPT_RDPRU,
+};
+
+
+struct __attribute__ ((__packed__)) vmcb_control_area {
+	u32 intercept_cr;
+	u32 intercept_dr;
+	u32 intercept_exceptions;
+	u64 intercept;
+	u8 reserved_1[40];
+	u16 pause_filter_thresh;
+	u16 pause_filter_count;
+	u64 iopm_base_pa;
+	u64 msrpm_base_pa;
+	u64 tsc_offset;
+	u32 asid;
+	u8 tlb_ctl;
+	u8 reserved_2[3];
+	u32 int_ctl;
+	u32 int_vector;
+	u32 int_state;
+	u8 reserved_3[4];
+	u32 exit_code;
+	u32 exit_code_hi;
+	u64 exit_info_1;
+	u64 exit_info_2;
+	u32 exit_int_info;
+	u32 exit_int_info_err;
+	u64 nested_ctl;
+	u64 avic_vapic_bar;
+	u8 reserved_4[8];
+	u32 event_inj;
+	u32 event_inj_err;
+	u64 nested_cr3;
+	u64 virt_ext;
+	u32 clean;
+	u32 reserved_5;
+	u64 next_rip;
+	u8 insn_len;
+	u8 insn_bytes[15];
+	u64 avic_backing_page;	/* Offset 0xe0 */
+	u8 reserved_6[8];	/* Offset 0xe8 */
+	u64 avic_logical_id;	/* Offset 0xf0 */
+	u64 avic_physical_id;	/* Offset 0xf8 */
+	u8 reserved_7[768];
+};
+
+
+#define TLB_CONTROL_DO_NOTHING 0
+#define TLB_CONTROL_FLUSH_ALL_ASID 1
+#define TLB_CONTROL_FLUSH_ASID 3
+#define TLB_CONTROL_FLUSH_ASID_LOCAL 7
+
+#define V_TPR_MASK 0x0f
+
+#define V_IRQ_SHIFT 8
+#define V_IRQ_MASK (1 << V_IRQ_SHIFT)
+
+#define V_GIF_SHIFT 9
+#define V_GIF_MASK (1 << V_GIF_SHIFT)
+
+#define V_INTR_PRIO_SHIFT 16
+#define V_INTR_PRIO_MASK (0x0f << V_INTR_PRIO_SHIFT)
+
+#define V_IGN_TPR_SHIFT 20
+#define V_IGN_TPR_MASK (1 << V_IGN_TPR_SHIFT)
+
+#define V_INTR_MASKING_SHIFT 24
+#define V_INTR_MASKING_MASK (1 << V_INTR_MASKING_SHIFT)
+
+#define V_GIF_ENABLE_SHIFT 25
+#define V_GIF_ENABLE_MASK (1 << V_GIF_ENABLE_SHIFT)
+
+#define AVIC_ENABLE_SHIFT 31
+#define AVIC_ENABLE_MASK (1 << AVIC_ENABLE_SHIFT)
+
+#define LBR_CTL_ENABLE_MASK BIT_ULL(0)
+#define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
+
+#define SVM_INTERRUPT_SHADOW_MASK 1
+
+#define SVM_IOIO_STR_SHIFT 2
+#define SVM_IOIO_REP_SHIFT 3
+#define SVM_IOIO_SIZE_SHIFT 4
+#define SVM_IOIO_ASIZE_SHIFT 7
+
+#define SVM_IOIO_TYPE_MASK 1
+#define SVM_IOIO_STR_MASK (1 << SVM_IOIO_STR_SHIFT)
+#define SVM_IOIO_REP_MASK (1 << SVM_IOIO_REP_SHIFT)
+#define SVM_IOIO_SIZE_MASK (7 << SVM_IOIO_SIZE_SHIFT)
+#define SVM_IOIO_ASIZE_MASK (7 << SVM_IOIO_ASIZE_SHIFT)
+
+#define SVM_VM_CR_VALID_MASK	0x001fULL
+#define SVM_VM_CR_SVM_LOCK_MASK 0x0008ULL
+#define SVM_VM_CR_SVM_DIS_MASK  0x0010ULL
+
+#define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
+#define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
+
+struct __attribute__ ((__packed__)) vmcb_seg {
+	u16 selector;
+	u16 attrib;
+	u32 limit;
+	u64 base;
+};
+
+struct __attribute__ ((__packed__)) vmcb_save_area {
+	struct vmcb_seg es;
+	struct vmcb_seg cs;
+	struct vmcb_seg ss;
+	struct vmcb_seg ds;
+	struct vmcb_seg fs;
+	struct vmcb_seg gs;
+	struct vmcb_seg gdtr;
+	struct vmcb_seg ldtr;
+	struct vmcb_seg idtr;
+	struct vmcb_seg tr;
+	u8 reserved_1[43];
+	u8 cpl;
+	u8 reserved_2[4];
+	u64 efer;
+	u8 reserved_3[112];
+	u64 cr4;
+	u64 cr3;
+	u64 cr0;
+	u64 dr7;
+	u64 dr6;
+	u64 rflags;
+	u64 rip;
+	u8 reserved_4[88];
+	u64 rsp;
+	u8 reserved_5[24];
+	u64 rax;
+	u64 star;
+	u64 lstar;
+	u64 cstar;
+	u64 sfmask;
+	u64 kernel_gs_base;
+	u64 sysenter_cs;
+	u64 sysenter_esp;
+	u64 sysenter_eip;
+	u64 cr2;
+	u8 reserved_6[32];
+	u64 g_pat;
+	u64 dbgctl;
+	u64 br_from;
+	u64 br_to;
+	u64 last_excp_from;
+	u64 last_excp_to;
+};
+
+struct __attribute__ ((__packed__)) vmcb {
+	struct vmcb_control_area control;
+	struct vmcb_save_area save;
+};
+
+#define SVM_CPUID_FUNC 0x8000000a
+
+#define SVM_VM_CR_SVM_DISABLE 4
+
+#define SVM_SELECTOR_S_SHIFT 4
+#define SVM_SELECTOR_DPL_SHIFT 5
+#define SVM_SELECTOR_P_SHIFT 7
+#define SVM_SELECTOR_AVL_SHIFT 8
+#define SVM_SELECTOR_L_SHIFT 9
+#define SVM_SELECTOR_DB_SHIFT 10
+#define SVM_SELECTOR_G_SHIFT 11
+
+#define SVM_SELECTOR_TYPE_MASK (0xf)
+#define SVM_SELECTOR_S_MASK (1 << SVM_SELECTOR_S_SHIFT)
+#define SVM_SELECTOR_DPL_MASK (3 << SVM_SELECTOR_DPL_SHIFT)
+#define SVM_SELECTOR_P_MASK (1 << SVM_SELECTOR_P_SHIFT)
+#define SVM_SELECTOR_AVL_MASK (1 << SVM_SELECTOR_AVL_SHIFT)
+#define SVM_SELECTOR_L_MASK (1 << SVM_SELECTOR_L_SHIFT)
+#define SVM_SELECTOR_DB_MASK (1 << SVM_SELECTOR_DB_SHIFT)
+#define SVM_SELECTOR_G_MASK (1 << SVM_SELECTOR_G_SHIFT)
+
+#define SVM_SELECTOR_WRITE_MASK (1 << 1)
+#define SVM_SELECTOR_READ_MASK SVM_SELECTOR_WRITE_MASK
+#define SVM_SELECTOR_CODE_MASK (1 << 3)
+
+#define INTERCEPT_CR0_READ	0
+#define INTERCEPT_CR3_READ	3
+#define INTERCEPT_CR4_READ	4
+#define INTERCEPT_CR8_READ	8
+#define INTERCEPT_CR0_WRITE	(16 + 0)
+#define INTERCEPT_CR3_WRITE	(16 + 3)
+#define INTERCEPT_CR4_WRITE	(16 + 4)
+#define INTERCEPT_CR8_WRITE	(16 + 8)
+
+#define INTERCEPT_DR0_READ	0
+#define INTERCEPT_DR1_READ	1
+#define INTERCEPT_DR2_READ	2
+#define INTERCEPT_DR3_READ	3
+#define INTERCEPT_DR4_READ	4
+#define INTERCEPT_DR5_READ	5
+#define INTERCEPT_DR6_READ	6
+#define INTERCEPT_DR7_READ	7
+#define INTERCEPT_DR0_WRITE	(16 + 0)
+#define INTERCEPT_DR1_WRITE	(16 + 1)
+#define INTERCEPT_DR2_WRITE	(16 + 2)
+#define INTERCEPT_DR3_WRITE	(16 + 3)
+#define INTERCEPT_DR4_WRITE	(16 + 4)
+#define INTERCEPT_DR5_WRITE	(16 + 5)
+#define INTERCEPT_DR6_WRITE	(16 + 6)
+#define INTERCEPT_DR7_WRITE	(16 + 7)
+
+#define SVM_EVTINJ_VEC_MASK 0xff
+
+#define SVM_EVTINJ_TYPE_SHIFT 8
+#define SVM_EVTINJ_TYPE_MASK (7 << SVM_EVTINJ_TYPE_SHIFT)
+
+#define SVM_EVTINJ_TYPE_INTR (0 << SVM_EVTINJ_TYPE_SHIFT)
+#define SVM_EVTINJ_TYPE_NMI (2 << SVM_EVTINJ_TYPE_SHIFT)
+#define SVM_EVTINJ_TYPE_EXEPT (3 << SVM_EVTINJ_TYPE_SHIFT)
+#define SVM_EVTINJ_TYPE_SOFT (4 << SVM_EVTINJ_TYPE_SHIFT)
+
+#define SVM_EVTINJ_VALID (1 << 31)
+#define SVM_EVTINJ_VALID_ERR (1 << 11)
+
+#define SVM_EXITINTINFO_VEC_MASK SVM_EVTINJ_VEC_MASK
+#define SVM_EXITINTINFO_TYPE_MASK SVM_EVTINJ_TYPE_MASK
+
+#define	SVM_EXITINTINFO_TYPE_INTR SVM_EVTINJ_TYPE_INTR
+#define	SVM_EXITINTINFO_TYPE_NMI SVM_EVTINJ_TYPE_NMI
+#define	SVM_EXITINTINFO_TYPE_EXEPT SVM_EVTINJ_TYPE_EXEPT
+#define	SVM_EXITINTINFO_TYPE_SOFT SVM_EVTINJ_TYPE_SOFT
+
+#define SVM_EXITINTINFO_VALID SVM_EVTINJ_VALID
+#define SVM_EXITINTINFO_VALID_ERR SVM_EVTINJ_VALID_ERR
+
+#define SVM_EXITINFOSHIFT_TS_REASON_IRET 36
+#define SVM_EXITINFOSHIFT_TS_REASON_JMP 38
+#define SVM_EXITINFOSHIFT_TS_HAS_ERROR_CODE 44
+
+#define SVM_EXITINFO_REG_MASK 0x0F
+
+#define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
+
+#endif /* SELFTEST_KVM_SVM_H */
diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tool=
s/testing/selftests/kvm/include/x86_64/svm_util.h
new file mode 100644
index 000000000000..6a67a89c5d06
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * tools/testing/selftests/kvm/include/x86_64/svm_utils.h
+ * Header for nested SVM testing
+ *
+ * Copyright (C) 2020, Red Hat, Inc.
+ */
+
+#ifndef SELFTEST_KVM_SVM_UTILS_H
+#define SELFTEST_KVM_SVM_UTILS_H
+
+#include <stdint.h>
+#include "svm.h"
+#include "processor.h"
+
+#define CPUID_SVM_BIT		2
+#define CPUID_SVM		BIT_ULL(CPUID_SVM_BIT)
+
+#define SVM_EXIT_VMMCALL	0x081
+
+struct svm_test_data {
+	void *vmcb_hva;
+	uint64_t vmcb_gpa;
+	struct vmcb *vmcb;
+
+	void *save_area_hva;
+	uint64_t save_area_gpa;
+	struct vmcb_save_area *save_area;
+};
+
+struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_sv=
m_gva);
+void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void =
*guest_rsp);
+void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa);
+void nested_svm_check_supported(void);
+
+#endif /* SELFTEST_KVM_SVM_UTILS_H */
diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing=
/selftests/kvm/lib/x86_64/svm.c
new file mode 100644
index 000000000000..cf4c3ee7e3ea
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
@@ -0,0 +1,159 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * tools/testing/selftests/kvm/lib/x86_64/svm.c
+ * Helpers used for nested SVM testing
+ * Largely inspired from KVM unit test svm.c
+ *
+ * Copyright (C) 2020, Red Hat, Inc.
+ */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "../kvm_util_internal.h"
+#include "processor.h"
+#include "svm_util.h"
+
+struct gp_regs64 gp_regs64;
+
+/* Allocate memory regions for nested SVM tests.
+ *
+ * Input Args:
+ *   vm - The VM to allocate guest-virtual addresses in.
+ *
+ * Output Args:
+ *   p_svm_gva - The guest virtual address for the struct svm_test_data.
+ *
+ * Return:
+ *   Pointer to structure with the addresses of the SVM areas.
+ */
+struct svm_test_data *
+vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva)
+{
+	vm_vaddr_t svm_gva =3D vm_vaddr_alloc(vm, getpagesize(),
+					    0x10000, 0, 0);
+	struct svm_test_data *svm =3D addr_gva2hva(vm, svm_gva);
+
+	svm->vmcb =3D (void *)vm_vaddr_alloc(vm, getpagesize(),
+					   0x10000, 0, 0);
+	svm->vmcb_hva =3D addr_gva2hva(vm, (uintptr_t)svm->vmcb);
+	svm->vmcb_gpa =3D addr_gva2gpa(vm, (uintptr_t)svm->vmcb);
+
+	svm->save_area =3D (void *)vm_vaddr_alloc(vm, getpagesize(),
+						0x10000, 0, 0);
+	svm->save_area_hva =3D addr_gva2hva(vm, (uintptr_t)svm->save_area);
+	svm->save_area_gpa =3D addr_gva2gpa(vm, (uintptr_t)svm->save_area);
+
+	*p_svm_gva =3D svm_gva;
+	return svm;
+}
+
+static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
+			 u64 base, u32 limit, u32 attr)
+{
+	seg->selector =3D selector;
+	seg->attrib =3D attr;
+	seg->limit =3D limit;
+	seg->base =3D base;
+}
+
+void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void =
*guest_rsp)
+{
+	struct vmcb *vmcb =3D svm->vmcb;
+	uint64_t vmcb_gpa =3D svm->vmcb_gpa;
+	struct vmcb_save_area *save =3D &vmcb->save;
+	struct vmcb_control_area *ctrl =3D &vmcb->control;
+	u32 data_seg_attr =3D 3 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
+	      | SVM_SELECTOR_DB_MASK | SVM_SELECTOR_G_MASK;
+	u32 code_seg_attr =3D 9 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
+		| SVM_SELECTOR_L_MASK | SVM_SELECTOR_G_MASK;
+	uint64_t efer;
+
+	efer =3D rdmsr(MSR_EFER);
+	wrmsr(MSR_EFER, efer | EFER_SVME);
+	wrmsr(MSR_VM_HSAVE_PA, svm->save_area_gpa);
+
+	memset(vmcb, 0, sizeof(*vmcb));
+	asm volatile ("vmsave %0" : : "a" (vmcb_gpa) : "memory");
+	vmcb_set_seg(&save->es, get_es(), 0, -1U, data_seg_attr);
+	vmcb_set_seg(&save->cs, get_cs(), 0, -1U, code_seg_attr);
+	vmcb_set_seg(&save->ss, get_ss(), 0, -1U, data_seg_attr);
+	vmcb_set_seg(&save->ds, get_ds(), 0, -1U, data_seg_attr);
+	vmcb_set_seg(&save->gdtr, 0, get_gdt().address, get_gdt().size, 0);
+	vmcb_set_seg(&save->idtr, 0, get_idt().address, get_idt().size, 0);
+
+	ctrl->asid =3D 1;
+	save->cpl =3D 0;
+	save->efer =3D rdmsr(MSR_EFER);
+	asm volatile ("mov %%cr4, %0" : "=3Dr"(save->cr4) : : "memory");
+	asm volatile ("mov %%cr3, %0" : "=3Dr"(save->cr3) : : "memory");
+	asm volatile ("mov %%cr0, %0" : "=3Dr"(save->cr0) : : "memory");
+	asm volatile ("mov %%dr7, %0" : "=3Dr"(save->dr7) : : "memory");
+	asm volatile ("mov %%dr6, %0" : "=3Dr"(save->dr6) : : "memory");
+	asm volatile ("mov %%cr2, %0" : "=3Dr"(save->cr2) : : "memory");
+	save->g_pat =3D rdmsr(MSR_IA32_CR_PAT);
+	save->dbgctl =3D rdmsr(MSR_IA32_DEBUGCTLMSR);
+	ctrl->intercept =3D (1ULL << INTERCEPT_VMRUN) |
+				(1ULL << INTERCEPT_VMMCALL);
+
+	vmcb->save.rip =3D (u64)guest_rip;
+	vmcb->save.rsp =3D (u64)guest_rsp;
+	gp_regs64.rdi =3D (u64)svm;
+}
+
+#define SAVE_GPR_C				\
+	"xchg %%rbx, gp_regs64+0x8\n\t"		\
+	"xchg %%rcx, gp_regs64+0x10\n\t"	\
+	"xchg %%rdx, gp_regs64+0x18\n\t"	\
+	"xchg %%rbp, gp_regs64+0x28\n\t"	\
+	"xchg %%rsi, gp_regs64+0x30\n\t"	\
+	"xchg %%rdi, gp_regs64+0x38\n\t"	\
+	"xchg %%r8,  gp_regs64+0x40\n\t"	\
+	"xchg %%r9,  gp_regs64+0x48\n\t"	\
+	"xchg %%r10, gp_regs64+0x50\n\t"	\
+	"xchg %%r11, gp_regs64+0x58\n\t"	\
+	"xchg %%r12, gp_regs64+0x60\n\t"	\
+	"xchg %%r13, gp_regs64+0x68\n\t"	\
+	"xchg %%r14, gp_regs64+0x70\n\t"	\
+	"xchg %%r15, gp_regs64+0x78\n\t"
+
+#define LOAD_GPR_C      SAVE_GPR_C
+
+/*
+ * selftests do not use interrupts so we dropped clgi/sti/cli/stgi
+ * for now
+ */
+void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa)
+{
+	asm volatile (
+		"vmload\n\t"
+		"vmload %[vmcb_gpa]\n\t"
+		"mov gp_regs64+0x80, %%r15\n\t"  // rflags
+		"mov %%r15, 0x170(%[vmcb])\n\t"
+		"mov gp_regs64, %%r15\n\t"       // rax
+		"mov %%r15, 0x1f8(%[vmcb])\n\t"
+		LOAD_GPR_C
+		"vmrun %[vmcb_gpa]\n\t"
+		SAVE_GPR_C
+		"mov 0x170(%[vmcb]), %%r15\n\t"  // rflags
+		"mov %%r15, gp_regs64+0x80\n\t"
+		"mov 0x1f8(%[vmcb]), %%r15\n\t"  // rax
+		"mov %%r15,gp_regs64\n\t"
+		"vmsave %[vmcb_gpa]\n\t"
+		: : [vmcb] "r" (vmcb), [vmcb_gpa] "a" (vmcb_gpa)
+		: "rbx", "rcx", "rdx", "rsi",
+		  "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15",
+		  "memory");
+
+}
+
+void nested_svm_check_supported(void)
+{
+	struct kvm_cpuid_entry2 *entry =3D
+		kvm_get_supported_cpuid_entry(0x80000001);
+
+	if (!(entry->ecx & CPUID_SVM)) {
+		fprintf(stderr, "nested SVM not enabled, skipping test\n");
+		exit(KSFT_SKIP);
+	}
+}
+
--=20
2.20.1

