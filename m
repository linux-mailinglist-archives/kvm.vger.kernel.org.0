Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4AE37040C
	for <lists+kvm@lfdr.de>; Sat,  1 May 2021 01:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhD3XZJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 19:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbhD3XZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 19:25:08 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AF6C06138C
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 16:24:19 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id m68-20020a6326470000b029020f37ad2901so4236418pgm.7
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 16:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CHatLD5Tl1lQJpmZw15smommPJOJbCh71D4e3ytfPPM=;
        b=LsaA1Zdru8LDIWkutXfR0M+1JQaI6nR3ERROJfusNV8jG9Jdnuyh6QBsHP66RxdymB
         2fDPdGwnAqkjHj8Q+auocilZp6lr226veLKd1NUGvM7JRaDxxhJLNE9gcPcv36I3Ir8S
         36b75n62rb+3mUfcsQJB2vpqocaWuXYG5JRr++evzEGUZ8lPCFkQRm0VGr/KHl0rjtFU
         SlWMNCfLIvVebiGreX1jVxCTrUTjruWxrq35v8huRCwmrOvhvwe5wU4+a5Hw5Nct8fXn
         KZHSNPO5GR9wAQ7geHhpeC5uVeVph03jNvLBGHGG9FL4hoizQh9McpNpsSmSpc7q5+Mh
         yj+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CHatLD5Tl1lQJpmZw15smommPJOJbCh71D4e3ytfPPM=;
        b=CMB2LyHbHdrymIgHUKMtawlCWAjfCBM4yCWVctepnI+LTP3IVcyI+gNtUAXikxcLDc
         67VxFC820fYTuTVqwuFLAfTtL2B8zgVF9jRklSHJ2LgqIwBK+Oc5NOmhAofyWYFi3ETQ
         KUXSmNl35s7JdivWbp3SL3VWg13XxUQP3Ve0XPy+YaFQvIW2q1EFpDy6DhEAQ668C3Qe
         kvfHB6tfBNVXplFIRWFAvpB4hm+Pa3HgMxfi9UmAcj7vuqI4+u2fzJEYF0J7XJ8+CmWF
         AXawkh0S+X8hmmrUJtk1qUnyq2r6AOKPqDWsqSNOnnFp9sgst9C2BW8B55F+RtGEWyd1
         exQA==
X-Gm-Message-State: AOAM530TvGpkQHevKTqIB8BtahBGp5MsGyGHri04085fRQ91QzRePxjw
        XEV6fKVpHnb7JwNdVSEP8svqnjkqn7NK25KzeCVgK9CzUvby4EbANq6IoEfgK/IrlrsziQksBK/
        y+JiiPS5EABuSCVyzPnFhna1QJyfxZ/9NTDAkWHli7wEa+CN9NqZAx2ZUuTY4FiQ=
X-Google-Smtp-Source: ABdhPJwfRBRfmVe1PvF+YWxvfmPKVAdRl4oeIaz0SUG/en2i/NpSYWQ93G2BtLw4SZ4+7TioAUGyhdCZvWeGrg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:aa7:908c:0:b029:250:b584:a406 with SMTP
 id i12-20020aa7908c0000b0290250b584a406mr7014636pfa.44.1619825058460; Fri, 30
 Apr 2021 16:24:18 -0700 (PDT)
Date:   Fri, 30 Apr 2021 16:24:07 -0700
In-Reply-To: <20210430232408.2707420-1-ricarkol@google.com>
Message-Id: <20210430232408.2707420-6-ricarkol@google.com>
Mime-Version: 1.0
References: <20210430232408.2707420-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v2 5/5] KVM: selftests: Add aarch64/debug-exceptions test
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, drjones@redhat.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Covers fundamental tests for debug exceptions. The guest installs and
handle its debug exceptions itself, without KVM_SET_GUEST_DEBUG.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/debug-exceptions.c  | 244 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |  14 +-
 4 files changed, 254 insertions(+), 6 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/debug-exceptions.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index e65d5572aefc..f09ed908422b 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
+/aarch64/debug-exceptions
 /aarch64/get-reg-list
 /aarch64/get-reg-list-sve
 /aarch64/vgic_init
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 618c5903f478..2f92442c0cc9 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -73,6 +73,7 @@ TEST_GEN_PROGS_x86_64 += memslot_modification_stress_test
 TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 
+TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list-sve
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
new file mode 100644
index 000000000000..87352ee09211
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -0,0 +1,244 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_util.h>
+#include <kvm_util.h>
+#include <processor.h>
+
+#define VCPU_ID 0
+
+#define MDSCR_KDE	(1 << 13)
+#define MDSCR_MDE	(1 << 15)
+#define MDSCR_SS	(1 << 0)
+
+#define DBGBCR_LEN8	(0xff << 5)
+#define DBGBCR_EXEC	(0x0 << 3)
+#define DBGBCR_EL1	(0x1 << 1)
+#define DBGBCR_E	(0x1 << 0)
+
+#define DBGWCR_LEN8	(0xff << 5)
+#define DBGWCR_RD	(0x1 << 3)
+#define DBGWCR_WR	(0x2 << 3)
+#define DBGWCR_EL1	(0x1 << 1)
+#define DBGWCR_E	(0x1 << 0)
+
+extern unsigned char sw_bp, hw_bp, bp_svc, bp_brk, hw_wp, ss_start;
+static volatile uint64_t sw_bp_addr, hw_bp_addr;
+static volatile uint64_t wp_addr, wp_data_addr;
+static volatile uint64_t svc_addr;
+static volatile uint64_t ss_addr[4], ss_idx;
+#define  PC(v)  ((uint64_t)&(v))
+
+static void reset_debug_state(void)
+{
+	asm volatile("msr daifset, #8");
+
+	write_sysreg(osdlr_el1, 0);
+	write_sysreg(oslar_el1, 0);
+	asm volatile("isb" : : : "memory");
+
+	write_sysreg(mdscr_el1, 0);
+	/* This test only uses the first bp and wp slot. */
+	write_sysreg(dbgbvr0_el1, 0);
+	write_sysreg(dbgbcr0_el1, 0);
+	write_sysreg(dbgwcr0_el1, 0);
+	write_sysreg(dbgwvr0_el1, 0);
+	asm volatile("isb" : : : "memory");
+}
+
+static void install_wp(uint64_t addr)
+{
+	uint32_t wcr;
+	uint32_t mdscr;
+
+	wcr = DBGWCR_LEN8 | DBGWCR_RD | DBGWCR_WR | DBGWCR_EL1 | DBGWCR_E;
+	write_sysreg(dbgwcr0_el1, wcr);
+	write_sysreg(dbgwvr0_el1, addr);
+	asm volatile("isb" : : : "memory");
+
+	asm volatile("msr daifclr, #8");
+
+	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
+	write_sysreg(mdscr_el1, mdscr);
+}
+
+static void install_hw_bp(uint64_t addr)
+{
+	uint32_t bcr;
+	uint32_t mdscr;
+
+	bcr = DBGBCR_LEN8 | DBGBCR_EXEC | DBGBCR_EL1 | DBGBCR_E;
+	write_sysreg(dbgbcr0_el1, bcr);
+	write_sysreg(dbgbvr0_el1, addr);
+	asm volatile("isb" : : : "memory");
+
+	asm volatile("msr daifclr, #8");
+
+	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_MDE;
+	write_sysreg(mdscr_el1, mdscr);
+}
+
+static void install_ss(void)
+{
+	uint32_t mdscr;
+
+	asm volatile("msr daifclr, #8");
+
+	mdscr = read_sysreg(mdscr_el1) | MDSCR_KDE | MDSCR_SS;
+	write_sysreg(mdscr_el1, mdscr);
+}
+
+static volatile char write_data;
+
+static void guest_code(void)
+{
+	GUEST_SYNC(0);
+
+	/* Software-breakpoint */
+	asm volatile("sw_bp: brk #0");
+	GUEST_ASSERT_EQ(sw_bp_addr, PC(sw_bp));
+
+	GUEST_SYNC(1);
+
+	/* Hardware-breakpoint */
+	reset_debug_state();
+	install_hw_bp(PC(hw_bp));
+	asm volatile("hw_bp: nop");
+	GUEST_ASSERT_EQ(hw_bp_addr, PC(hw_bp));
+
+	GUEST_SYNC(2);
+
+	/* Hardware-breakpoint + svc */
+	reset_debug_state();
+	install_hw_bp(PC(bp_svc));
+	asm volatile("bp_svc: svc #0");
+	GUEST_ASSERT_EQ(hw_bp_addr, PC(bp_svc));
+	GUEST_ASSERT_EQ(svc_addr, PC(bp_svc) + 4);
+
+	GUEST_SYNC(3);
+
+	/* Hardware-breakpoint + software-breakpoint */
+	reset_debug_state();
+	install_hw_bp(PC(bp_brk));
+	asm volatile("bp_brk: brk #0");
+	GUEST_ASSERT_EQ(sw_bp_addr, PC(bp_brk));
+	GUEST_ASSERT_EQ(hw_bp_addr, PC(bp_brk));
+
+	GUEST_SYNC(4);
+
+	/* Watchpoint */
+	reset_debug_state();
+	install_wp(PC(write_data));
+	write_data = 'x';
+	GUEST_ASSERT_EQ(write_data, 'x');
+	GUEST_ASSERT_EQ(wp_data_addr, PC(write_data));
+
+	GUEST_SYNC(5);
+
+	/* Single-step */
+	reset_debug_state();
+	install_ss();
+	ss_idx = 0;
+	asm volatile("ss_start:\n"
+		     "mrs x0, esr_el1\n"
+		     "add x0, x0, #1\n"
+		     "msr daifset, #8\n"
+		     : : : "x0");
+	GUEST_ASSERT_EQ(ss_addr[0], PC(ss_start));
+	GUEST_ASSERT_EQ(ss_addr[1], PC(ss_start) + 4);
+	GUEST_ASSERT_EQ(ss_addr[2], PC(ss_start) + 8);
+
+	GUEST_DONE();
+}
+
+static void guest_sw_bp_handler(struct ex_regs *regs)
+{
+	sw_bp_addr = regs->pc;
+	regs->pc += 4;
+}
+
+static void guest_hw_bp_handler(struct ex_regs *regs)
+{
+	hw_bp_addr = regs->pc;
+	regs->pstate |= SPSR_D;
+}
+
+static void guest_wp_handler(struct ex_regs *regs)
+{
+	wp_data_addr = read_sysreg(far_el1);
+	wp_addr = regs->pc;
+	regs->pstate |= SPSR_D;
+}
+
+static void guest_ss_handler(struct ex_regs *regs)
+{
+	GUEST_ASSERT_1(ss_idx < 4, ss_idx);
+	ss_addr[ss_idx++] = regs->pc;
+	regs->pstate |= SPSR_SS;
+}
+
+static void guest_svc_handler(struct ex_regs *regs)
+{
+	svc_addr = regs->pc;
+}
+
+static int debug_version(struct kvm_vm *vm)
+{
+	uint64_t id_aa64dfr0;
+
+	get_reg(vm, VCPU_ID, ARM64_SYS_REG(ID_AA64DFR0_EL1), &id_aa64dfr0);
+	return id_aa64dfr0 & 0xf;
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+	struct ucall uc;
+	int stage;
+
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	ucall_init(vm, NULL);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+
+	if (debug_version(vm) < 6) {
+		print_skip("Armv8 debug architecture not supported.");
+		kvm_vm_free(vm);
+		exit(KSFT_SKIP);
+	}
+
+	vm_install_exception_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_EC_BRK_INS, guest_sw_bp_handler);
+	vm_install_exception_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_EC_HW_BP_CURRENT, guest_hw_bp_handler);
+	vm_install_exception_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_EC_WP_CURRENT, guest_wp_handler);
+	vm_install_exception_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_EC_SSTEP_CURRENT, guest_ss_handler);
+	vm_install_exception_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_EC_SVC64, guest_svc_handler);
+
+	for (stage = 0; stage < 7; stage++) {
+		vcpu_run(vm, VCPU_ID);
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_SYNC:
+			TEST_ASSERT(uc.args[1] == stage,
+				"Stage %d: Unexpected sync ucall, got %lx",
+				stage, (ulong)uc.args[1]);
+			break;
+		case UCALL_ABORT:
+			TEST_FAIL("%s at %s:%ld\n\tvalues: %#lx, %#lx",
+				(const char *)uc.args[0],
+				__FILE__, uc.args[1], uc.args[2], uc.args[3]);
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	kvm_vm_free(vm);
+	return 0;
+}
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 40aae31b4afc..a3ebef8e88c7 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -14,12 +14,14 @@
 #define ARM64_CORE_REG(x) (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
 			   KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
 
-#define CPACR_EL1	3, 0,  1, 0, 2
-#define TCR_EL1		3, 0,  2, 0, 2
-#define MAIR_EL1	3, 0, 10, 2, 0
-#define TTBR0_EL1	3, 0,  2, 0, 0
-#define SCTLR_EL1	3, 0,  1, 0, 0
-#define VBAR_EL1	3, 0, 12, 0, 0
+#define CPACR_EL1               3, 0,  1, 0, 2
+#define TCR_EL1                 3, 0,  2, 0, 2
+#define MAIR_EL1                3, 0, 10, 2, 0
+#define TTBR0_EL1               3, 0,  2, 0, 0
+#define SCTLR_EL1               3, 0,  1, 0, 0
+#define VBAR_EL1                3, 0, 12, 0, 0
+
+#define ID_AA64DFR0_EL1         3, 0,  0, 5, 0
 
 /*
  * Default MAIR
-- 
2.31.1.527.g47e6f16901-goog

