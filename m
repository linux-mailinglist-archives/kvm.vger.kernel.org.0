Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4CE368BCB
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 06:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhDWEEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 00:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhDWEEj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 00:04:39 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CACC06138B
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 21:04:04 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id e20-20020ad442b40000b029019aa511c767so17431347qvr.18
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 21:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4m81bHDjNSYt8zyq7LAtxG+mCmVoRicU2Z2tDQr+ANM=;
        b=ttEE2LvX/oBOTyaItyie2MpN9k35zMGBT9kYzRLn6/yhgUNmTRWR0aFHCpI6fHgd3F
         08zo2151/XNwSlluoE0oBdiD7Y8/+z6cAQ18Yo9y8f46D5gYvbU80nwGr9vLQkR6qO0j
         Iinlq9sxx/EhDKRrLXACBUGFuKA6Ht3b+m5U8LTpoZ4eTJL9/c09Qo1Oohntq/2RZwpy
         CS4e4S2/sRo5BUf4+EhY1uxEwjZA2f1043bXJ+8/uUp/WrMiY3hMquIL87SUGvkvg3jA
         FRBVYo43I5e9JjbLNbX1xiQaRypGoYZ+2a/Z8uSuikiabbpCChm2j9AHtmSCG2WtQxPb
         6r2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4m81bHDjNSYt8zyq7LAtxG+mCmVoRicU2Z2tDQr+ANM=;
        b=oci+3Wr4GNSsh7JOsGHwBTmUjNObXYGaIf+VXc1bL4TJJqI2L1otw5m+QWuEmJU8/a
         U+Ieh9fBISdL2UeyIIvMYyC0vsRELFgkt+dmn+yuiGxTYH9xmQcVPVwjTutC7zcdgvJr
         Fm8LqM/1O0Af1rlVbltPnUXWj4r462GP4lwraBKUbmykxAv2Q+gJPJy26xrdqU5tMstk
         9cRs4j+arhRDpncjfGpvOUCsa4m9qLvDAE1qs+LH0dVQaOKPFAoNGk5lwJHApeA2xz1e
         mxySenDgZT63sf81dyCSpRR10uoUrA8XYvB++fHbNNwdN7sQNsI+HmgE3vDtaAjFWq+0
         N2CQ==
X-Gm-Message-State: AOAM531l/KSM4Hd+Fwz0XAnTWNHfPVKbyJTgXMMElNLUQo4Y4YrATSm8
        j8Kx6NG3yeAzLvaq3YUeeD28kvvI52m0XBM03TZtfEomJfgrPKJZwZP1zxe920xP3h/qdXm7rZX
        KLmDxSnnI1WdUAsSKayUcr9VpCN+y/8T25usXPiI0lwv3LxTAW2Z1JMoxrKwzqR8=
X-Google-Smtp-Source: ABdhPJy0W1d+0aHxqXIC8gNvLBk4iBpruGH9i2h9ef6ZmM2tZEAUMtw2hDW8UkCZZy4LMWcL2OYUZDnC2zXQwg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6214:849:: with SMTP id
 dg9mr2286252qvb.30.1619150642934; Thu, 22 Apr 2021 21:04:02 -0700 (PDT)
Date:   Thu, 22 Apr 2021 21:03:50 -0700
In-Reply-To: <20210423040351.1132218-1-ricarkol@google.com>
Message-Id: <20210423040351.1132218-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20210423040351.1132218-1-ricarkol@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 2/3] KVM: selftests: Add aarch64/debug-exceptions test
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
 .../selftests/kvm/aarch64/debug-exceptions.c  | 250 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |  17 ++
 4 files changed, 269 insertions(+)
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
index 000000000000..18e8de2711d3
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -0,0 +1,250 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <fcntl.h>
+#include <pthread.h>
+#include <sched.h>
+#include <semaphore.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <asm/barrier.h>
+
+#include <linux/compiler.h>
+
+#include <test_util.h>
+#include <kvm_util.h>
+#include <processor.h>
+
+#define VCPU_ID 0
+
+extern unsigned char sw_bp, hw_bp, bp_svc, bp_brk, hw_wp, ss_start;
+static volatile uint64_t sw_bp_addr, hw_bp_addr;
+static volatile uint64_t wp_addr, wp_data_addr;
+static volatile uint64_t svc_addr;
+static volatile uint64_t ss_addr[4], ss_idx;
+#define  CAST_TO_PC(v)  ((uint64_t)&(v))
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
+#define GUEST_ASSERT_EQ(arg1, arg2) \
+	GUEST_ASSERT_2((arg1) == (arg2), (arg1), (arg2))
+
+static void guest_code(void)
+{
+	GUEST_SYNC(0);
+
+	/* Software-breakpoint */
+	asm volatile("sw_bp: brk #0");
+	GUEST_ASSERT_EQ(sw_bp_addr, CAST_TO_PC(sw_bp));
+
+	GUEST_SYNC(1);
+
+	/* Hardware-breakpoint */
+	reset_debug_state();
+	install_hw_bp(CAST_TO_PC(hw_bp));
+	asm volatile("hw_bp: nop");
+	GUEST_ASSERT_EQ(hw_bp_addr, CAST_TO_PC(hw_bp));
+
+	GUEST_SYNC(2);
+
+	/* Hardware-breakpoint + svc */
+	reset_debug_state();
+	install_hw_bp(CAST_TO_PC(bp_svc));
+	asm volatile("bp_svc: svc #0");
+	GUEST_ASSERT_EQ(hw_bp_addr, CAST_TO_PC(bp_svc));
+	GUEST_ASSERT_EQ(svc_addr, CAST_TO_PC(bp_svc) + 4);
+
+	GUEST_SYNC(3);
+
+	/* Hardware-breakpoint + software-breakpoint */
+	reset_debug_state();
+	install_hw_bp(CAST_TO_PC(bp_brk));
+	asm volatile("bp_brk: brk #0");
+	GUEST_ASSERT_EQ(sw_bp_addr, CAST_TO_PC(bp_brk));
+	GUEST_ASSERT_EQ(hw_bp_addr, CAST_TO_PC(bp_brk));
+
+	GUEST_SYNC(4);
+
+	/* Watchpoint */
+	reset_debug_state();
+	install_wp(CAST_TO_PC(write_data));
+	write_data = 'x';
+	GUEST_ASSERT_EQ(write_data, 'x');
+	GUEST_ASSERT_EQ(wp_data_addr, CAST_TO_PC(write_data));
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
+	GUEST_ASSERT_EQ(ss_addr[0], CAST_TO_PC(ss_start));
+	GUEST_ASSERT_EQ(ss_addr[1], CAST_TO_PC(ss_start) + 4);
+	GUEST_ASSERT_EQ(ss_addr[2], CAST_TO_PC(ss_start) + 8);
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
+	int ret;
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
+	vm_handle_exception(vm, VECTOR_SYNC_EL1,
+			ESR_EC_BRK_INS, guest_sw_bp_handler);
+	vm_handle_exception(vm, VECTOR_SYNC_EL1,
+			ESR_EC_HW_BP_EL1, guest_hw_bp_handler);
+	vm_handle_exception(vm, VECTOR_SYNC_EL1,
+			ESR_EC_WP_EL1, guest_wp_handler);
+	vm_handle_exception(vm, VECTOR_SYNC_EL1,
+			ESR_EC_SSTEP_EL1, guest_ss_handler);
+	vm_handle_exception(vm, VECTOR_SYNC_EL1,
+			ESR_EC_SVC64, guest_svc_handler);
+
+	for (stage = 0; stage < 7; stage++) {
+		ret = _vcpu_run(vm, VCPU_ID);
+
+		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_SYNC:
+			TEST_ASSERT(uc.args[1] == stage,
+				"Stage %d: Unexpected sync ucall, got %lx",
+				stage, (ulong)uc.args[1]);
+
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
index 5c902ad95c35..eee69b92e01e 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -21,6 +21,8 @@
 #define SCTLR_EL1	3, 0,  1, 0, 0
 #define VBAR_EL1	3, 0, 12, 0, 0
 
+#define ID_AA64DFR0_EL1	3, 0,  0, 5, 0
+
 /*
  * Default MAIR
  *                  index   attribute
@@ -125,4 +127,19 @@ void vm_handle_exception(struct kvm_vm *vm, int vector, int ec,
 	val;								  \
 })
 
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
 #endif /* SELFTEST_KVM_PROCESSOR_H */
-- 
2.31.1.498.g6c1eba8ee3d-goog

