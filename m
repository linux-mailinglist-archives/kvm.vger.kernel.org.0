Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7967275B2
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 05:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbjFHDZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 23:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234120AbjFHDZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 23:25:01 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7B8210A
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 20:24:59 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1b02497f4cfso170705ad.3
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 20:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686194698; x=1688786698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SKaHgr+HL1117S3Jb0aiH5upNruURl+KhWKkgZPggeU=;
        b=RXSSoF6/UG7yQ3r8E8hAePxnc2Sm1OYVC6HZJwNG7h/9pNEy0g4rhTDZORYspmc4j+
         JlKG7R/MRd5qsIXjy4XTgvLjLo+4nMBz72TXeGkeEJuf2mV4SxpotNfga70I7vBkzKgE
         Ok15EbcgRrzT/XsJ+gCoL7oYSsrqq5iMth45B+y2RzHIvvBtPNS/tKMizfol39chJ7F5
         2EoUTqjGPnOPBpCxnBwphX9kxwKf8xIPi3rtK6ycBGa0+Bk4DmMAdmeHzVDc9kuHBfFL
         SO/uX2LZkKld7RViInfEeHW4Sk8M5ldvrPOhWkVBSWg55tH4//wbFJPKquxzs2UjPTu4
         C1tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686194698; x=1688786698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SKaHgr+HL1117S3Jb0aiH5upNruURl+KhWKkgZPggeU=;
        b=Aaz105unVguzX23BS9H2jEVBmMg3NTHcHU+cjiEWDDC4MIGVN9JFN3+4qFC94Oxb8L
         wWs901LMUU+XCXYRWnPrY2utV8xadjKXjZZXn/mhAQ/tdnwyEbIC38S3D7y3/2NGpa5S
         2reXOlPCWMtmZFG0LF/jCXk63C2xB1RRtKLszwd8KshVYwYbldSexFbylQJfArjiEuuj
         hlDJXenXqHShPIHekTlYaUJCwt3IMctNNfIKhwU2xsW7R4c/0BZmh4bqEXUvh0PRwLHQ
         +oTk0D1WbH8zdVKXxtL0zy/gye3i9k7/BnydCpUhP+sDgD71YAufBX/p6DHvWty5C90S
         kbWQ==
X-Gm-Message-State: AC+VfDztxGZ8qpKswcdDXc6pYOrhydxEnwuPqg8iUw6njnnHY+pK+PgA
        bUrUW+Q1a4agV11nhGVfegDUaYwzb5w=
X-Google-Smtp-Source: ACHHUZ7I51jMXcRhU4L0iRuO4wTdv5VNRALpAastt2XMOL+tebny1cqSEqZmj7MsagjiwC9XLtJeEg==
X-Received: by 2002:a17:90a:1901:b0:259:e75a:bdc9 with SMTP id 1-20020a17090a190100b00259e75abdc9mr827229pjg.27.1686194698170;
        Wed, 07 Jun 2023 20:24:58 -0700 (PDT)
Received: from wheely.local0.net (58-6-224-112.tpgi.com.au. [58.6.224.112])
        by smtp.gmail.com with ESMTPSA id s12-20020a17090a5d0c00b0025930e50e28sm2015629pji.41.2023.06.07.20.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 20:24:57 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v3 6/6] KVM: PPC: selftests: Add interrupt performance tester
Date:   Thu,  8 Jun 2023 13:24:25 +1000
Message-Id: <20230608032425.59796-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608032425.59796-1-npiggin@gmail.com>
References: <20230608032425.59796-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a little perf tester for interrupts that go to guest, host, and
userspace.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/powerpc/interrupt_perf.c    | 199 ++++++++++++++++++
 2 files changed, 200 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/powerpc/interrupt_perf.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index aa3a8ca676c2..834f98971b0c 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -184,6 +184,7 @@ TEST_GEN_PROGS_riscv += kvm_page_table_test
 TEST_GEN_PROGS_riscv += set_memory_region_test
 TEST_GEN_PROGS_riscv += kvm_binary_stats_test
 
+TEST_GEN_PROGS_powerpc += powerpc/interrupt_perf
 TEST_GEN_PROGS_powerpc += powerpc/null_test
 TEST_GEN_PROGS_powerpc += powerpc/rtas_hcall
 TEST_GEN_PROGS_powerpc += powerpc/tlbiel_test
diff --git a/tools/testing/selftests/kvm/powerpc/interrupt_perf.c b/tools/testing/selftests/kvm/powerpc/interrupt_perf.c
new file mode 100644
index 000000000000..50d078899e22
--- /dev/null
+++ b/tools/testing/selftests/kvm/powerpc/interrupt_perf.c
@@ -0,0 +1,199 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test basic guest interrupt/exit performance.
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sched.h>
+#include <sys/ioctl.h>
+#include <sys/time.h>
+#include <sys/sysinfo.h>
+#include <signal.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "kselftest.h"
+#include "processor.h"
+#include "helpers.h"
+#include "hcall.h"
+
+static bool timeout;
+static unsigned long count;
+static struct kvm_vm *kvm_vm;
+
+static void set_timer(int sec)
+{
+	struct itimerval timer;
+
+	timeout = false;
+
+	timer.it_value.tv_sec  = sec;
+	timer.it_value.tv_usec = 0;
+	timer.it_interval = timer.it_value;
+	TEST_ASSERT(setitimer(ITIMER_REAL, &timer, NULL) == 0,
+			"setitimer failed %s", strerror(errno));
+}
+
+static void sigalrm_handler(int sig)
+{
+	timeout = true;
+	sync_global_to_guest(kvm_vm, timeout);
+}
+
+static void init_timers(void)
+{
+	TEST_ASSERT(signal(SIGALRM, sigalrm_handler) != SIG_ERR,
+		    "Failed to register SIGALRM handler, errno = %d (%s)",
+		    errno, strerror(errno));
+}
+
+static void program_interrupt_handler(struct ex_regs *regs)
+{
+	regs->nia += 4;
+}
+
+static void program_interrupt_guest_code(void)
+{
+	unsigned long nr = 0;
+
+	while (!timeout) {
+		asm volatile("trap");
+		nr++;
+		barrier();
+	}
+	count = nr;
+
+	GUEST_DONE();
+}
+
+static void program_interrupt_test(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	/* Create VM */
+	vm = vm_create_with_one_vcpu(&vcpu, program_interrupt_guest_code);
+	kvm_vm = vm;
+	vm_install_exception_handler(vm, 0x700, program_interrupt_handler);
+
+	set_timer(1);
+
+	while (!timeout) {
+		vcpu_run(vcpu);
+		barrier();
+	}
+
+	sync_global_from_guest(vm, count);
+
+	kvm_vm = NULL;
+	vm_install_exception_handler(vm, 0x700, NULL);
+
+	kvm_vm_free(vm);
+
+	printf("%lu guest interrupts per second\n", count);
+	count = 0;
+}
+
+static void heai_guest_code(void)
+{
+	unsigned long nr = 0;
+
+	while (!timeout) {
+		asm volatile(".long 0");
+		nr++;
+		barrier();
+	}
+	count = nr;
+
+	GUEST_DONE();
+}
+
+static void heai_test(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	/* Create VM */
+	vm = vm_create_with_one_vcpu(&vcpu, heai_guest_code);
+	kvm_vm = vm;
+	vm_install_exception_handler(vm, 0x700, program_interrupt_handler);
+
+	set_timer(1);
+
+	while (!timeout) {
+		vcpu_run(vcpu);
+		barrier();
+	}
+
+	sync_global_from_guest(vm, count);
+
+	kvm_vm = NULL;
+	vm_install_exception_handler(vm, 0x700, NULL);
+
+	kvm_vm_free(vm);
+
+	printf("%lu guest exits per second\n", count);
+	count = 0;
+}
+
+static void hcall_guest_code(void)
+{
+	for (;;)
+		hcall0(H_RTAS);
+}
+
+static void hcall_test(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	/* Create VM */
+	vm = vm_create_with_one_vcpu(&vcpu, hcall_guest_code);
+	kvm_vm = vm;
+
+	set_timer(1);
+
+	while (!timeout) {
+		vcpu_run(vcpu);
+		count++;
+		barrier();
+	}
+
+	kvm_vm = NULL;
+
+	kvm_vm_free(vm);
+
+	printf("%lu KVM exits per second\n", count);
+	count = 0;
+}
+
+struct testdef {
+	const char *name;
+	void (*test)(void);
+} testlist[] = {
+	{ "guest interrupt test", program_interrupt_test},
+	{ "guest exit test", heai_test},
+	{ "KVM exit test", hcall_test},
+};
+
+int main(int argc, char *argv[])
+{
+	int idx;
+
+	ksft_print_header();
+
+	ksft_set_plan(ARRAY_SIZE(testlist));
+
+	init_timers();
+
+	for (idx = 0; idx < ARRAY_SIZE(testlist); idx++) {
+		testlist[idx].test();
+		ksft_test_result_pass("%s\n", testlist[idx].name);
+	}
+
+	ksft_finished();	/* Print results and exit() accordingly */
+}
-- 
2.40.1

