Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD9458EF58
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 17:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbiHJPVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 11:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbiHJPVN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 11:21:13 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD949792CC
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 08:20:58 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id y20-20020a170903011400b0016f06421a83so9973039plc.12
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 08:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=7Cb3xK7C8A3dKOEhtON3+5DVL3Y0hKSgmYKmNcGLqP0=;
        b=b8Fn3IpLxI54p6QHEIARrG3UnZQqAKm07QEdu8urKrTa5fP/KEzJBSUa7E2yWrBCJP
         gBVZlmfDEHznQbBR9XsMhGvmvGqfH0l5rKqOPlS0gO1jeuVyVT4X7B8X+KeXWdJh9zOH
         cvGmFTL7oXm/9lh4/8uF13jSVSDg5scSLdwp4EAOGJZ71fYOwx4jOy4X1ZXHinPwUizb
         Sicb9txiHTH8pFnncE/APbSI5oPHswOeLHfaQXY1AOBSmwzlYkbXAbCtOzjx7qfBoEqc
         vB5E3P6V9QGfvQd35rvMNiiaFPYnIecYZD+YR/25Q+8QA8pOJA+iDtAkmoTqCG6n1Qsx
         odpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=7Cb3xK7C8A3dKOEhtON3+5DVL3Y0hKSgmYKmNcGLqP0=;
        b=l5mPYAz3FrCEsu9HGjlGQrsCDmYuU+MUFV/UIpSXm5NOzjj96hs/AQpGzm/+bb973h
         ponhyniFXVsK45MmgeoO+ObE86m2kLCjwOm1Oky4vUYXy029Fn5F0XQtuCPUiGGBYKDY
         AfjFCXnhxsIm6Ip3Oc3QsSZmPVLoV3rv1LEhItiilCRuJrHuAEu26m03ckG3J57Vqwza
         EHL4QiPdRt6HRM3imUIfK9Ze/gvVSKBWj/dsm8WLSgt3uA8/i11FA6HO+JyTR1KR6NSy
         S07opPKjPAm94oi7lXio4ZhQS/Kx+EWMaq5mcIO/ST9Rj8gbIrqnbkOXHIxlbvEWpSc+
         wLnw==
X-Gm-Message-State: ACgBeo0Ev40mu8KMBzNmN6qlqylyIFwcxH4Ftrvmw9nTvQ2rn0YQxino
        YXhjKYAWUA7uP8J6hrqGDslvOQS/PwPo4SS1WCxSD5UMAUJukfOoud6+Fij+jXZpfsVkwzSMxbj
        JTgWXseAEtpnyyEmYeB1nIxjZq9yrw1k4rvVXZ+Aw+VP5Cma53tCl79WN0g==
X-Google-Smtp-Source: AA6agR4np9E2GdxSrWaYSbcobydcrRmlzA1Z3m/LeqPX//hxxwNp1p23D8O/po1r4EyzClYY0r1+JOxAAys=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:b185:1827:5b23:bbe2])
 (user=pgonda job=sendgmr) by 2002:a05:6a00:22c6:b0:52f:4d67:b370 with SMTP id
 f6-20020a056a0022c600b0052f4d67b370mr14395559pfj.58.1660144857469; Wed, 10
 Aug 2022 08:20:57 -0700 (PDT)
Date:   Wed, 10 Aug 2022 08:20:33 -0700
In-Reply-To: <20220810152033.946942-1-pgonda@google.com>
Message-Id: <20220810152033.946942-12-pgonda@google.com>
Mime-Version: 1.0
References: <20220810152033.946942-1-pgonda@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [V3 11/11] KVM: selftests: Add simple sev vm testing
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, vannapurve@google.com,
        Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A very simple of booting SEV guests that checks related CPUID bits. This
is a stripped down version of "[PATCH v2 08/13] KVM: selftests: add SEV
boot tests" from Michael but much simpler.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/sev.h        |   3 +
 tools/testing/selftests/kvm/lib/x86_64/sev.c  |   2 -
 .../selftests/kvm/x86_64/sev_all_boot_test.c  | 131 ++++++++++++++++++
 5 files changed, 136 insertions(+), 2 deletions(-)
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
index b247c4b595af..73b083f93b46 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -122,6 +122,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_caps_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
+TEST_GEN_PROGS_x86_64 += x86_64/sev_all_boot_test
 TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
 TEST_GEN_PROGS_x86_64 += x86_64/amx_test
 TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/sev.h b/tools/testing/selftests/kvm/include/x86_64/sev.h
index 2f7f7c741b12..b6552ea1c716 100644
--- a/tools/testing/selftests/kvm/include/x86_64/sev.h
+++ b/tools/testing/selftests/kvm/include/x86_64/sev.h
@@ -22,6 +22,9 @@
 #define SEV_POLICY_NO_DBG	(1UL << 0)
 #define SEV_POLICY_ES		(1UL << 2)
 
+#define CPUID_MEM_ENC_LEAF 0x8000001f
+#define CPUID_EBX_CBIT_MASK 0x3f
+
 enum {
 	SEV_GSTATE_UNINIT = 0,
 	SEV_GSTATE_LUPDATE,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/sev.c b/tools/testing/selftests/kvm/lib/x86_64/sev.c
index 3abcf50c0b5d..8f9f55c685a7 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/sev.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/sev.c
@@ -13,8 +13,6 @@
 #include "sev.h"
 
 #define PAGE_SHIFT		12
-#define CPUID_MEM_ENC_LEAF 0x8000001f
-#define CPUID_EBX_CBIT_MASK 0x3f
 
 struct sev_vm {
 	struct kvm_vm *vm;
diff --git a/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c b/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c
new file mode 100644
index 000000000000..b319d18bdb60
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/sev_all_boot_test.c
@@ -0,0 +1,131 @@
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
+static void __attribute__((__flatten__)) guest_sev_code(void)
+{
+	uint32_t eax, ebx, ecx, edx;
+	uint64_t sev_status;
+
+	GUEST_SYNC(1);
+
+	cpuid(CPUID_MEM_ENC_LEAF, &eax, &ebx, &ecx, &edx);
+	GUEST_ASSERT(eax & (1 << 1));
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
2.37.1.559.g78731f0fdb-goog

