Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B68652F1C1
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 19:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352313AbiETRhH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 13:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352325AbiETRhE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 13:37:04 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D52939FD
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 10:37:01 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id g3-20020a17090a128300b001df6b8706e3so5008794pja.9
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 10:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JlkDy6zr1BhiWoo/HTRnV5a5QX+CIhKUQxFVb56phFo=;
        b=jh6wg3UAnq+/6GQqO9PI8T8UBmoc0dX5GqEFmFACOQqmBm4sQndx3DUx1SMazlzyZT
         S8sPKTt6m8KBh2SHIN8GJxu3Pm/TDOlXLJfJBZFiofui9QGucarnHmqXYOdrE+E51lgC
         dR4ZjHqD861q6mJeOGgd0/c4K/zgNaMZXgbN7FZVcawVlvF+9QFxXQBNQQwp+Hj0+Kcp
         DvMZQDdkAUDXQOGfXMMmQB7dr1isy01/9hkQhT2ZYWitaD6e5cF8LsSrZ63f91XNsTRp
         3PtKOWvEJAnMWPKZgCFG/hToe6om6Fw+1MSJvA4r318SV0sbQiaHYvFH7jfzpn1zthBI
         Enrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JlkDy6zr1BhiWoo/HTRnV5a5QX+CIhKUQxFVb56phFo=;
        b=S6aAGJwV9kiH5ha5o1LVtAfTYXDC90cg5Rwu0VAelOvXnyp/tfdrLW8qTBbot2ftQZ
         m+uZveOlLelAb2uRLxKDqfMeTNaJw3XnCz27+fuhhyXUxN3fqRtx2jqbItkdEwkz8Hkj
         +RO+DtpIrZBjFbe/45li979ML4dIetR95AZ0XaPyQuwzj3C+fuqwvH6fKEzXBvHDaD6i
         CuJ1Z8w70Kr+ly89R4S9vgfciTAN15KOBrFiqq2TWppJS+Tkc5sVqQ3SYCNbEibCxEuU
         VYBNX3ZeROmFsoRjXE3ohDgp7MIQg5buqNZ+nWYdBFOtQRniX/bblWSwteSV9X6jb2Z5
         oBRQ==
X-Gm-Message-State: AOAM532s+g63xNGyCDmTIm853Efkea5ZWQScekWVoab/oM64vDlvr0F0
        OUKeDpLbzM9+5e1ObPpGNwoCuS/B
X-Google-Smtp-Source: ABdhPJxP1Rk7Ndw8Y3O9qn2iAKuc6aQDrNbC4AYjpzPkhe1VO8M0cRjiWolEy9TTAQd4wtr4Dxt6mMrc
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:4c5:ddc5:8182:560f])
 (user=juew job=sendgmr) by 2002:a05:6a00:234f:b0:4f6:f0c0:ec68 with SMTP id
 j15-20020a056a00234f00b004f6f0c0ec68mr11160263pfj.14.1653068221318; Fri, 20
 May 2022 10:37:01 -0700 (PDT)
Date:   Fri, 20 May 2022 10:36:38 -0700
In-Reply-To: <20220520173638.94324-1-juew@google.com>
Message-Id: <20220520173638.94324-9-juew@google.com>
Mime-Version: 1.0
References: <20220520173638.94324-1-juew@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [RFC v4 8/8] KVM: selftests: Add a self test for UCNA injection.
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>
Cc:     Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Greg Thelen <gthelen@google.com>,
        Jiaqi Yan <jiaqiyan@google.com>, Jue Wang <juew@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch add a self test that verifies user space can inject
UnCorrectable No Action required (UCNA) memory errors to the guest.

Signed-off-by: Jue Wang <juew@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/apic.h       |   1 +
 .../selftests/kvm/include/x86_64/mce.h        |  25 ++
 .../selftests/kvm/include/x86_64/processor.h  |   1 +
 .../selftests/kvm/lib/x86_64/processor.c      |   2 +-
 .../kvm/x86_64/ucna_injection_test.c          | 287 ++++++++++++++++++
 7 files changed, 317 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/mce.h
 create mode 100644 tools/testing/selftests/kvm/x86_64/ucna_injection_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 0b0e4402bba6..a8eb9d3f082c 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -37,6 +37,7 @@
 /x86_64/tsc_scaling_sync
 /x86_64/sync_regs_test
 /x86_64/tsc_msrs_test
+/x86_64/ucna_injection_test
 /x86_64/userspace_io_test
 /x86_64/userspace_msr_exit_test
 /x86_64/vmx_apic_access_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 681b173aa87c..8d9858b54b98 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -66,6 +66,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_preemption_timer_test
 TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/svm_int_ctl_test
 TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
+TEST_GEN_PROGS_x86_64 += x86_64/ucna_injection_test
 TEST_GEN_PROGS_x86_64 += x86_64/userspace_io_test
 TEST_GEN_PROGS_x86_64 += x86_64/userspace_msr_exit_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_apic_access_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/apic.h b/tools/testing/selftests/kvm/include/x86_64/apic.h
index ac88557dcc9a..bed316fdecd5 100644
--- a/tools/testing/selftests/kvm/include/x86_64/apic.h
+++ b/tools/testing/selftests/kvm/include/x86_64/apic.h
@@ -35,6 +35,7 @@
 #define		APIC_SPIV_APIC_ENABLED		(1 << 8)
 #define APIC_IRR	0x200
 #define	APIC_ICR	0x300
+#define	APIC_LVTCMCI	0x2f0
 #define		APIC_DEST_SELF		0x40000
 #define		APIC_DEST_ALLINC	0x80000
 #define		APIC_DEST_ALLBUT	0xC0000
diff --git a/tools/testing/selftests/kvm/include/x86_64/mce.h b/tools/testing/selftests/kvm/include/x86_64/mce.h
new file mode 100644
index 000000000000..6119321f3f5d
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86_64/mce.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * tools/testing/selftests/kvm/include/x86_64/mce.h
+ *
+ * Copyright (C) 2022, Google LLC.
+ */
+
+#ifndef SELFTEST_KVM_MCE_H
+#define SELFTEST_KVM_MCE_H
+
+#define MCG_CTL_P		BIT_ULL(8)   /* MCG_CTL register available */
+#define MCG_SER_P		BIT_ULL(24)  /* MCA recovery/new status bits */
+#define MCG_LMCE_P		BIT_ULL(27)  /* Local machine check supported */
+#define MCG_CMCI_P		BIT_ULL(10)  /* CMCI supported */
+#define KVM_MAX_MCE_BANKS 32
+#define MCG_CAP_BANKS_MASK 0xff       /* Bit 0-7 of the MCG_CAP register are #banks */
+#define MCI_STATUS_VAL (1ULL << 63)   /* valid error */
+#define MCI_STATUS_UC (1ULL << 61)    /* uncorrected error */
+#define MCI_STATUS_EN (1ULL << 60)    /* error enabled */
+#define MCI_STATUS_MISCV (1ULL << 59) /* misc error reg. valid */
+#define MCI_STATUS_ADDRV (1ULL << 58) /* addr reg. valid */
+#define MCM_ADDR_PHYS 2    /* physical address */
+#define MCI_CTL2_CMCI_EN		BIT_ULL(30)
+
+#endif /* SELFTEST_KVM_MCE_H */
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index d0d51adec76e..fa316c3b7725 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -481,6 +481,7 @@ struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void);
 void vcpu_set_hv_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
 struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
 void vm_xsave_req_perm(int bit);
+void vcpu_setup(struct kvm_vm *vm, int vcpuid);
 
 enum x86_page_size {
 	X86_PAGE_SIZE_4K = 0,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 33ea5e9955d9..bb1ef665cd10 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -580,7 +580,7 @@ static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
 	kvm_seg_fill_gdt_64bit(vm, segp);
 }
 
-static void vcpu_setup(struct kvm_vm *vm, int vcpuid)
+void vcpu_setup(struct kvm_vm *vm, int vcpuid)
 {
 	struct kvm_sregs sregs;
 
diff --git a/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c b/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
new file mode 100644
index 000000000000..104a9f116b23
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
@@ -0,0 +1,287 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ucna_injection_test
+ *
+ * Copyright (C) 2022, Google LLC.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ *
+ * Test that user space can inject UnCorrectable No Action required (UCNA)
+ * memory errors to the guest.
+ *
+ * The test starts one vCPU with the MCG_CMCI_P enabled. It verifies that
+ * proper UCNA errors can be injected to a vCPU with MCG_CMCI_P and
+ * corresponding per-bank control register (MCI_CTL2) bit enabled.
+ * The test also checks that the UCNA errors get recorded in the
+ * Machine Check bank registers no matter the error signal interrupts get
+ * delivered into the guest or not.
+ *
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <pthread.h>
+#include <inttypes.h>
+#include <string.h>
+#include <time.h>
+
+#include "kvm_util_base.h"
+#include "kvm_util.h"
+#include "mce.h"
+#include "processor.h"
+#include "test_util.h"
+#include "apic.h"
+
+#define UCNA_VCPU_ID 0
+#define SYNC_FIRST_UCNA 9
+#define SYNC_SECOND_UCNA 10
+#define FIRST_UCNA_ADDR 0xdeadbeef
+#define SECOND_UCNA_ADDR 0xcafeb0ba
+
+/*
+ * Vector for the CMCI interrupt.
+ * Value is arbitrary. Any value in 0x20-0xFF should work:
+ * https://wiki.osdev.org/Interrupt_Vector_Table
+ */
+#define CMCI_VECTOR  0xa9
+
+#define UCNA_BANK  0x7	// IMC0 bank
+
+/*
+ * Record states about the injected UCNA.
+ * The variables started with the 'i_' prefixes are recorded in interrupt
+ * handler. Variables without the 'i_' prefixes are recorded in guest main
+ * execution thread.
+ */
+static volatile uint64_t i_ucna_rcvd;
+static volatile uint64_t i_ucna_addr;
+static volatile uint64_t ucna_addr;
+static volatile uint64_t ucna_addr2;
+
+struct thread_params {
+	struct kvm_vm *vm;
+	uint32_t vcpu_id;
+};
+
+static void verify_apic_base_addr(void)
+{
+	uint64_t msr = rdmsr(MSR_IA32_APICBASE);
+	uint64_t base = GET_APIC_BASE(msr);
+
+	GUEST_ASSERT(base == APIC_DEFAULT_GPA);
+}
+
+static void guest_code(void)
+{
+	uint64_t ctl2;
+	verify_apic_base_addr();
+	xapic_enable();
+
+	/* Sets up the interrupt vector and enables per-bank CMCI sigaling. */
+	xapic_write_reg(APIC_LVTCMCI, CMCI_VECTOR | APIC_DM_FIXED);
+	ctl2 = rdmsr(MSR_IA32_MCx_CTL2(UCNA_BANK));
+	wrmsr(MSR_IA32_MCx_CTL2(UCNA_BANK), ctl2 | MCI_CTL2_CMCI_EN);
+
+	/* Enables interrupt in guest. */
+	asm volatile("sti");
+
+	/* Let user space inject the first UCNA */
+	GUEST_SYNC(SYNC_FIRST_UCNA);
+
+	ucna_addr = rdmsr(MSR_IA32_MCx_ADDR(UCNA_BANK));
+
+	/* Disables the per-bank CMCI signaling. */
+	ctl2 = rdmsr(MSR_IA32_MCx_CTL2(UCNA_BANK));
+	wrmsr(MSR_IA32_MCx_CTL2(UCNA_BANK), ctl2 & ~MCI_CTL2_CMCI_EN);
+
+	/* Let the user space inject the second UCNA */
+	GUEST_SYNC(SYNC_SECOND_UCNA);
+
+	ucna_addr2 = rdmsr(MSR_IA32_MCx_ADDR(UCNA_BANK));
+	GUEST_DONE();
+}
+
+static void guest_cmci_handler(struct ex_regs *regs)
+{
+	i_ucna_rcvd++;
+	i_ucna_addr = rdmsr(MSR_IA32_MCx_ADDR(UCNA_BANK));
+	xapic_write_reg(APIC_EOI, 0);
+}
+
+static void inject_ucna(struct kvm_vm *vm, uint32_t vcpu_id, uint64_t addr) {
+	/*
+	 * A UCNA error is indicated with VAL=1, UC=1, PCC=0, S=0 and AR=0 in
+	 * the IA32_MCi_STATUS register.
+	 * MSCOD=1 (BIT[16] - MscodDataRdErr).
+	 * MCACOD=0x0090 (Memory controller error format, channel 0)
+	 */
+	uint64_t status = MCI_STATUS_VAL | MCI_STATUS_UC | MCI_STATUS_EN |
+		          MCI_STATUS_MISCV | MCI_STATUS_ADDRV | 0x10090;
+	struct kvm_x86_mce mce = {};
+	mce.status = status;
+	mce.mcg_status = 0;
+	/*
+	 * MCM_ADDR_PHYS indicates the reported address is a physical address.
+	 * Lowest 6 bits is the recoverable address LSB, i.e., the injected MCE
+	 * is at 4KB granularity.
+	 */
+	mce.misc = (MCM_ADDR_PHYS << 6) | 0xc;
+	mce.addr = addr;
+	mce.bank = UCNA_BANK;
+
+	TEST_ASSERT(_vcpu_ioctl(vm, vcpu_id, KVM_X86_SET_MCE, &mce) != -1,
+			"Inject UCNA");
+}
+
+static void *vcpu_thread(void *arg)
+{
+	struct thread_params *params = (struct thread_params *)arg;
+	struct ucall uc;
+	int old;
+	int r;
+	unsigned int exit_reason;
+
+	r = pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);
+	TEST_ASSERT(r == 0,
+		    "pthread_setcanceltype failed on vcpu_id=%u with errno=%d",
+		    params->vcpu_id, r);
+
+	fprintf(stderr, "vCPU thread running vCPU %u\n", params->vcpu_id);
+	vcpu_run(params->vm, params->vcpu_id);
+
+	exit_reason = vcpu_state(params->vm, params->vcpu_id)->exit_reason;
+	TEST_ASSERT(exit_reason == KVM_EXIT_IO,
+		    "vCPU %u exited with unexpected exit reason %u-%s, expected KVM_EXIT_IO",
+		    params->vcpu_id, exit_reason, exit_reason_str(exit_reason));
+	TEST_ASSERT(get_ucall(params->vm, params->vcpu_id, &uc) == UCALL_SYNC,
+		    "Expect UCALL_SYNC\n");
+	TEST_ASSERT(uc.args[1] == SYNC_FIRST_UCNA, "Injecting first UCNA.");
+
+	fprintf(stderr, "Injecting first UCNA at %#x.\n", FIRST_UCNA_ADDR);
+
+	inject_ucna(params->vm, params->vcpu_id, FIRST_UCNA_ADDR);
+	vcpu_run(params->vm, params->vcpu_id);
+
+	exit_reason = vcpu_state(params->vm, params->vcpu_id)->exit_reason;
+	TEST_ASSERT(exit_reason == KVM_EXIT_IO,
+		    "vCPU %u exited with unexpected exit reason %u-%s, expected KVM_EXIT_IO",
+		    params->vcpu_id, exit_reason, exit_reason_str(exit_reason));
+	TEST_ASSERT(get_ucall(params->vm, params->vcpu_id, &uc) == UCALL_SYNC,
+		    "Expect UCALL_SYNC\n");
+	TEST_ASSERT(uc.args[1] == SYNC_SECOND_UCNA, "Injecting second UCNA.");
+
+	fprintf(stderr, "Injecting second UCNA at %#x.\n", SECOND_UCNA_ADDR);
+
+	inject_ucna(params->vm, params->vcpu_id, SECOND_UCNA_ADDR);
+	vcpu_run(params->vm, params->vcpu_id);
+
+	exit_reason = vcpu_state(params->vm, params->vcpu_id)->exit_reason;
+	TEST_ASSERT(exit_reason == KVM_EXIT_IO,
+		    "vCPU %u exited with unexpected exit reason %u-%s, expected KVM_EXIT_IO",
+		    params->vcpu_id, exit_reason, exit_reason_str(exit_reason));
+	if (get_ucall(params->vm, params->vcpu_id, &uc) == UCALL_ABORT) {
+		TEST_ASSERT(false,
+			    "vCPU %u exited with error: %s.\n",
+			    params->vcpu_id, (const char *)uc.args[0]);
+	}
+
+	return NULL;
+}
+
+static void setup_mce_cap(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	uint64_t supported_mcg_caps = 0;
+	uint64_t mcg_caps = MCG_CMCI_P | MCG_CTL_P | MCG_SER_P | MCG_LMCE_P
+		| KVM_MAX_MCE_BANKS;
+
+	TEST_ASSERT(_kvm_ioctl(vm, KVM_X86_GET_MCE_CAP_SUPPORTED,
+			       &supported_mcg_caps) != -1,
+		    "KVM_GET_MCE_CAP_SUPPORTED");
+	fprintf(stderr, "KVM supported MCG_CAP: %#lx\n", supported_mcg_caps);
+
+	TEST_ASSERT(supported_mcg_caps & MCG_CMCI_P, "MCG_CMCI_P is not supported");
+
+	mcg_caps &= supported_mcg_caps | MCG_CAP_BANKS_MASK;
+	TEST_ASSERT(_vcpu_ioctl(vm, vcpuid, KVM_X86_SETUP_MCE, &mcg_caps) != -1,
+		    "KVM_X86_SETUP_MCE");
+}
+
+static void create_vcpu_with_mce_cap(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
+{
+	struct kvm_mp_state mp_state;
+	struct kvm_regs regs;
+	vm_vaddr_t stack_vaddr;
+	stack_vaddr = vm_vaddr_alloc(vm, DEFAULT_STACK_PGS * getpagesize(),
+				     DEFAULT_GUEST_STACK_VADDR_MIN);
+
+	vm_vcpu_add(vm, vcpuid);
+	setup_mce_cap(vm, vcpuid);
+
+	vcpu_set_cpuid(vm, vcpuid, kvm_get_supported_cpuid());
+	vcpu_setup(vm, vcpuid);
+
+	/* Setup guest general purpose registers */
+	vcpu_regs_get(vm, vcpuid, &regs);
+	regs.rflags = regs.rflags | 0x2;
+	regs.rsp = stack_vaddr + (DEFAULT_STACK_PGS * getpagesize());
+	regs.rip = (unsigned long) guest_code;
+	vcpu_regs_set(vm, vcpuid, &regs);
+
+	/* Setup the MP state */
+	mp_state.mp_state = 0;
+	vcpu_set_mp_state(vm, vcpuid, &mp_state);
+}
+
+int main(int argc, char *argv[])
+{
+	int r;
+	void *retval;
+	int run_secs = 3;
+	pthread_t threads[2];
+	struct thread_params params[2];
+	struct kvm_vm *vm;
+	uint64_t *p_i_ucna_rcvd, *p_i_ucna_addr;
+	uint64_t *p_ucna_addr, *p_ucna_addr2;
+
+	kvm_check_cap(KVM_CAP_MCE);
+
+	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
+
+	create_vcpu_with_mce_cap(vm, UCNA_VCPU_ID, guest_code);
+
+	params[0].vm = vm;
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, UCNA_VCPU_ID);
+	vm_install_exception_handler(vm, CMCI_VECTOR, guest_cmci_handler);
+
+	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
+
+	p_i_ucna_rcvd = (uint64_t *)addr_gva2hva(vm, (uint64_t)&i_ucna_rcvd);
+	p_i_ucna_addr = (uint64_t *)addr_gva2hva(vm, (uint64_t)&i_ucna_addr);
+	p_ucna_addr = (uint64_t *)addr_gva2hva(vm, (uint64_t)&ucna_addr);
+	p_ucna_addr2 = (uint64_t *)addr_gva2hva(vm, (uint64_t)&ucna_addr2);
+
+	/* Start vCPU thread and wait for it to execute first HLT. */
+	params[0].vcpu_id = UCNA_VCPU_ID;
+	r = pthread_create(&threads[0], NULL, vcpu_thread, &params[0]);
+	TEST_ASSERT(r == 0,
+		    "pthread_create vcpu thread failed errno=%d", errno);
+	fprintf(stderr, "vCPU thread started\n");
+
+	sleep(run_secs);
+
+	r = pthread_join(threads[0], &retval);
+	TEST_ASSERT(r == 0,
+		    "pthread_join on vcpu_id=%d failed with errno=%d",
+		    UCNA_VCPU_ID, r);
+
+	fprintf(stderr,
+		"Test successful after running for %d seconds.\n"
+		"UCNA CMCI interrupts received: %ld\n"
+		"Last UCNA address received via CMCI: %lx\n"
+		"First UCNA address in vCPU thread: %lx\n"
+		"Second UCNA address in vCPU thread: %lx\n",
+		run_secs, *p_i_ucna_rcvd, *p_i_ucna_addr, *p_ucna_addr, *p_ucna_addr2);
+
+	kvm_vm_free(vm);
+}
-- 
2.36.1.124.g0e6072fb45-goog

