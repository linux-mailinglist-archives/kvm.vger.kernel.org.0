Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9306D5A52DA
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 19:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiH2RLt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 13:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbiH2RLa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 13:11:30 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B394761DA2
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 10:11:06 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id m22-20020a6562d6000000b0042a7471b984so4299219pgv.4
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 10:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=KGXjgJgUkcc6oFwdaRe0n8FvD9Ghrnwp0D/dG+3dTWU=;
        b=cWB2hlteQpR8H0ijk/rvn+pRYWZkD+xTiwJm//ksuQiCz1oGclbd7uMrQ5LO2KDuaN
         uEMy5IFApjxfdcjug8ebf8GUdVBxnl8Z4lFBvkuXhTzmJdrlXev/rcDN5SgjY7fOWnDX
         /T89ONu4AXccoo4f8i/QW/kLKWyNYFU2Dt6JnDid0jd1N5DBwf7yOS92OMPCWmBAYc7f
         vmxTYI4xnW3Gij51yVrTvPrPQpdapMkkyfJhy8G6fOcFSwIOWHAfinrk34c7dFY8Xgdl
         ozQoOIALNqRy9IgXaLfOH/ZS1JHLZnAc+UYD+YjLYMyd5BcKw8kmPswwD2j9kG1/noWs
         zxuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=KGXjgJgUkcc6oFwdaRe0n8FvD9Ghrnwp0D/dG+3dTWU=;
        b=RJuRmXGkxXohhupcX0kOKDaNYUqB9HVqbuP05sg+q8/qCRunqG6tcVQApZe2vR7muk
         edc1qpb7q4x9dClTXIhH/Y5HUoTKvfBN1IvErATQdjzpBqXMaB7HWw958y0brKg6r1yu
         YbW0SuWx6cPR8jNGtgVSmnAhyvNwxfrxv/uaE4FK5jmBsfqlL93VXzpDUhjz99Ine582
         LbqoaJsiz13bcu4yyIqT6QyxP+QMb0bW6pITVsa+1yDIDmHQaLfbTxx1HhCIJ6PFcpc0
         CZOG8NHRvROeXqYgjkUdry3V74ojqbLQaE6pHmQFJYGcU82aDVT1/3MIKWsDTprCQ9mf
         q6sA==
X-Gm-Message-State: ACgBeo0giuNcRQPCH+BDzsyIJFmtL58AF4tSsgIzWvnY/A3ahQrLEd8t
        daBVQZU/8MuSXkXuRas8Kvpqry1R+pUqXeX8neXVKmIzC2WA5oTsoWNIwsXeiZJqU4imGacYu9y
        6ZKjMeqVt/WLzb6Y+YxDufpzhPh0+SrEmzqhd8z0Uu+kdF7ZKb/AlOpZm/g==
X-Google-Smtp-Source: AA6agR42GjaUT73++4/5+NtkGa3o94Fet2S/yBtZK0siFe9UPVScWYZSNnJ1nu+hClUYJizP6CZ86NdfTF8=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:cddb:77a7:c55e:a7a2])
 (user=pgonda job=sendgmr) by 2002:a17:90b:4c04:b0:1fb:2d28:bfb5 with SMTP id
 na4-20020a17090b4c0400b001fb2d28bfb5mr19086814pjb.42.1661793065115; Mon, 29
 Aug 2022 10:11:05 -0700 (PDT)
Date:   Mon, 29 Aug 2022 10:10:21 -0700
In-Reply-To: <20220829171021.701198-1-pgonda@google.com>
Message-Id: <20220829171021.701198-9-pgonda@google.com>
Mime-Version: 1.0
References: <20220829171021.701198-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Subject: [V4 8/8] KVM: selftests: Add simple sev vm testing
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, Peter Gonda <pgonda@google.com>
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

A very simple of booting SEV guests that checks related CPUID bits. This
is a stripped down version of "[PATCH v2 08/13] KVM: selftests: add SEV
boot tests" from Michael but much simpler.

Suggested-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/sev_all_boot_test.c  | 127 ++++++++++++++++++
 3 files changed, 129 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index d625a3f83780..ca57969a0923 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -33,6 +33,7 @@
 /x86_64/pmu_event_filter_test
 /x86_64/set_boot_cpu_id
 /x86_64/set_sregs_test
+/x86_64/sev_all_boot_test
 /x86_64/sev_migrate_tests
 /x86_64/smm_test
 /x86_64/state_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 0a70e50f0498..10a7ea09ea98 100644
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
index 000000000000..be8ed3720767
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c
@@ -0,0 +1,127 @@
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
+static void guest_sev_code(void)
+{
+	uint32_t eax, ebx, ecx, edx;
+	uint64_t sev_status;
+
+	GUEST_SYNC(1);
+
+	GUEST_ASSERT(this_cpu_has(X86_FEATURE_SEV));
+
+	sev_status = rdmsr(MSR_AMD64_SEV);
+	GUEST_ASSERT((sev_status & 0x1) == 1);
+
+	GUEST_DONE();
+}
+
+static struct sev_vm *setup_test_common(void *guest_code, uint64_t policy,
+					struct kvm_vcpu **vcpu)
+{
+	uint8_t measurement[512];
+	struct sev_vm *sev;
+	struct kvm_vm *vm;
+	int i;
+
+	sev = sev_vm_create(policy, TOTAL_PAGES);
+	TEST_ASSERT(sev, "sev_vm_create() failed to create VM\n");
+
+	vm = sev->vm;
+
+	/* Set up VCPU and initial guest kernel. */
+	*vcpu = vm_vcpu_add(vm, 0, guest_code);
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
2.37.2.672.g94769d06f0-goog

