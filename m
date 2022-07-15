Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83904576773
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 21:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiGOTbb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 15:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbiGOTbI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 15:31:08 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCC77AB3B
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 12:30:32 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l16-20020a170902f69000b0016bf6a77effso2480300plg.2
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 12:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kD3cN2eYPx1hQzZPSpXzB0RRo1/KfV2Nfxd7Euk7Vec=;
        b=dcUOCy6GITc6WOkFigRp6EzkCpSL5Wka5Yk25WkygHmlQOwYw29mlycrtTgPYTOD2d
         jXBxvJYMEDPy3k+gqHPjsjWQPNNY7Gx2/lHU09ouIHG9zRgUCZlV5jpBBAhd4y4ztnaL
         JrESV7bxVR1b/EB46JE7ZelrY+oSnYm7x65R/pKtxO1EQEnefGZuuf5UJWXtzA4DFc4M
         xsbNlr0Sy9joYwwtN/nZz7hE+Ns9/I1rWYW+us5vbb6n98wpAEXwlnqNgsge5Pb86I6y
         jxDZKnbRDAuOY4y+wA77N+2gtW616XCakNhW9c6L9K4NcqRpjN7+XQKW3r5eQwjhzfqT
         q+vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kD3cN2eYPx1hQzZPSpXzB0RRo1/KfV2Nfxd7Euk7Vec=;
        b=PTi3aq0wphQo8UN92NAkjLd9U5YMx5oCS0DQUqYE5CKcQ9ETnuVZvGV/epO5iBnpMr
         rLrtRBchEv24a3XU4TBa0WrYQ0m9NgMJB8ObjPCo31d+/CwpZVN2hT0mEaf1rBEjvLPU
         IQwXWfoa9K0CTlmWWepdK8gJoOjRJBasd0Tx82WQHpMZj72ERk7uNt/qN/P8yFwaMDIv
         NNKSpWe+1iMq9r0XuSwhHmsXjsFxeTo4Pm3gffBWyQOl6l9Kt8oIFuhTiLYBly4MTRLv
         myrZElOCw/qVEfYNJHcZV5bZfVl3IR3QTOs990fdjRg9RvtNy0PEP3xwcEQucXAovA4j
         92Gg==
X-Gm-Message-State: AJIora/ugEqmkAO5n4yi65BKWJfeS0WuRZ/wb1hPTASIa+DhbFy8ADyw
        ceOy2es59n3NNC0Bj7RfwRIfj7DlCo7PHEyloURz/JStkxuK2dVBESNBcZliSwak04Ifd2vfmlZ
        q0YfhfTLgih8YIbN9Rd4RWRA8PLUwGhXBP4pXtJ6pRD4HEbvui9jAoGkOFg==
X-Google-Smtp-Source: AGRyM1vbIEF6fwL/9XXNLUlwNtvb3MAHzJ7BMwrcLgCSeZqcjyjEQVgjkdh3ev4KI5kSuJwJzVswyWbEC7k=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:bd4e:b81d:4780:497d])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:3498:b0:52a:f8f4:ca7c with SMTP id
 cp24-20020a056a00349800b0052af8f4ca7cmr15610136pfb.5.1657913426164; Fri, 15
 Jul 2022 12:30:26 -0700 (PDT)
Date:   Fri, 15 Jul 2022 12:29:56 -0700
In-Reply-To: <20220715192956.1873315-1-pgonda@google.com>
Message-Id: <20220715192956.1873315-12-pgonda@google.com>
Mime-Version: 1.0
References: <20220715192956.1873315-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [RFC V1 10/10] KVM: selftests: Add simple sev vm testing
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Roth <michael.roth@amd.com>

A very simple of booting SEV guests that checks related CPUID bits. This
is a stripped down version of "[PATCH v2 08/13] KVM: selftests: add SEV
boot tests" from Michael but much simpler.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>

---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/sev_all_boot_test.c  | 134 ++++++++++++++++++
 3 files changed, 136 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index f44ebf401310..ec084a61a819 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -34,6 +34,7 @@
 /x86_64/pmu_event_filter_test
 /x86_64/set_boot_cpu_id
 /x86_64/set_sregs_test
+/x86_64/sev_all_boot_test
 /x86_64/sev_migrate_tests
 /x86_64/smm_test
 /x86_64/state_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index f3f29a64e4b2..2b89e6bcb5b0 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -123,6 +123,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_caps_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
+TEST_GEN_PROGS_x86_64 += x86_64/sev_all_boot_test
 TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
 TEST_GEN_PROGS_x86_64 += x86_64/amx_test
 TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
diff --git a/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c b/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c
new file mode 100644
index 000000000000..222ce41d6f68
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c
@@ -0,0 +1,134 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Basic SEV boot tests.
+ *
+ * Copyright (C) 2021 Advanced Micro Devices
+ */
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "svm_util.h"
+#include "linux/psp-sev.h"
+#include "sev.h"
+
+#define VCPU_ID			2
+#define PAGE_STRIDE		32
+
+#define SHARED_PAGES		8192
+#define SHARED_VADDR_MIN	0x1000000
+
+#define PRIVATE_PAGES		2048
+#define PRIVATE_VADDR_MIN	(SHARED_VADDR_MIN + SHARED_PAGES * PAGE_SIZE)
+
+#define TOTAL_PAGES		(512 + SHARED_PAGES + PRIVATE_PAGES)
+
+#define NR_SYNCS 1
+
+static void guest_run_loop(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+	int i;
+
+	for (i = 0; i <= NR_SYNCS; ++i) {
+		vcpu_run(vcpu);
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			continue;
+		case UCALL_DONE:
+			return;
+		case UCALL_ABORT:
+			TEST_ASSERT(false, "%s at %s:%ld\n\tvalues: %#lx, %#lx",
+				    (const char *)uc.args[0], __FILE__,
+				    uc.args[1], uc.args[2], uc.args[3]);
+		default:
+			TEST_ASSERT(
+				false, "Unexpected exit: %s",
+				exit_reason_str(vcpu->run->exit_reason));
+		}
+	}
+}
+
+static void __attribute__((__flatten__))
+guest_sev_code(void)
+{
+	uint32_t eax, ebx, ecx, edx;
+	uint64_t sev_status;
+
+	GUEST_SYNC(1);
+
+	eax = 0x8000001f;
+	ecx = 0;
+	cpuid(&eax, &ebx, &ecx, &edx);
+	GUEST_ASSERT(eax & (1 << 1));
+
+	sev_status = rdmsr(MSR_AMD64_SEV);
+	GUEST_ASSERT((sev_status & 0x1) == 1);
+
+	GUEST_DONE();
+}
+
+static struct sev_vm *
+setup_test_common(void *guest_code, uint64_t policy, struct kvm_vcpu **vcpu)
+{
+	uint8_t measurement[512];
+	struct sev_vm *sev;
+	struct kvm_vm *vm;
+	int i;
+
+	sev = sev_vm_create(policy, TOTAL_PAGES);
+	if (!sev)
+		return NULL;
+	vm = sev_get_vm(sev);
+
+	/* Set up VCPU and initial guest kernel. */
+	*vcpu = vm_vcpu_add(vm, VCPU_ID, guest_code);
+	kvm_vm_elf_load(vm, program_invocation_name);
+
+	/* Allocations/setup done. Encrypt initial guest payload. */
+	sev_vm_launch(sev);
+
+	/* Dump the initial measurement. A test to actually verify it would be nice. */
+	sev_vm_launch_measure(sev, measurement);
+	pr_info("guest measurement: ");
+	for (i = 0; i < 32; ++i)
+		pr_info("%02x", measurement[i]);
+	pr_info("\n");
+
+	sev_vm_launch_finish(sev);
+
+	return sev;
+}
+
+static void test_sev(void *guest_code, uint64_t policy)
+{
+	struct sev_vm *sev;
+	struct kvm_vcpu *vcpu;
+
+	sev = setup_test_common(guest_code, policy, &vcpu);
+	if (!sev)
+		return;
+
+	/* Guest is ready to run. Do the tests. */
+	guest_run_loop(vcpu);
+
+	pr_info("guest ran successfully\n");
+
+	sev_vm_free(sev);
+}
+
+int main(int argc, char *argv[])
+{
+	/* SEV tests */
+	test_sev(guest_sev_code, SEV_POLICY_NO_DBG);
+	test_sev(guest_sev_code, 0);
+
+	return 0;
+}
-- 
2.37.0.170.g444d1eabd0-goog

