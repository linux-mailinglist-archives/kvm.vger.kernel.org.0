Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0BA762A64
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 06:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjGZErG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 00:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbjGZErB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 00:47:01 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6ED19B4
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 21:46:59 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d0fff3cf2d7so3368063276.2
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 21:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690346819; x=1690951619;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bniQmOT6+pUxEBBH7wJ5coyJsGVM2Ob3pBVk8XP9Ing=;
        b=pU/MtIinmz5YpR7qjSN+EeVI9m3ci066UUqt+30GVagerObnPWcvMkVrSKXYd3eVAf
         0j6kAP1t9os/lbdcmey1rDtdSdnYKhysHLQwtt9+yic1BVkfeKFOnpZCVmSzkUfhg4O/
         X13NmdtiKzvmaJw4hAB5irCBCZPNRDkN8A1fpb8loSqEq7YazCr7CCIzK25VCVf8W06B
         riLtl6GQaW8lNhbn6QFIWB9cYlUL+g+q+A682spS7UyS0p2/tfmCC71Nd0Mq/DlSAlGw
         zn7l5fnsVv5H9HloUaymtN9tUp2d5WWD9hwQLssG3lbD8uY+06ZT3C0twu7O5enlpdKT
         MxCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690346819; x=1690951619;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bniQmOT6+pUxEBBH7wJ5coyJsGVM2Ob3pBVk8XP9Ing=;
        b=Nc6bUUBCdTDY1pES3g7cCzPGWvztRC14CWfVFvX8IkQeApwquRDmx9ZQxZFZILbL1a
         HOmGuM1i2Qd+uoKftxELJRZU+YJ8uzfer386h7sJZyWDabjoscCz/OlJKXei7IqFuUkH
         sI2funVbQuKMT7/HRnrmpbFIXi9hwORwJL/BYZP7Inrwew+sBWLZY7E9x8cDPZSg8Xmi
         Zimk0pzvp853Ws0UR6WH+EsuMt3GELFT/rdfk/8yQd8Fe2Su7np8iDKNzNd2yTBfFVKZ
         lqMEuvxigwyMMxDyk4z2zfaTxrjz4fAVUec9cYUmzRKRPI/7VUpMnDufAvMCgzi0DgyB
         3POQ==
X-Gm-Message-State: ABy/qLYkU23thCjd9aTfFGkP2YV9wvLwl9Z1DodF+69zsgNbWb3sA6iA
        Nk9KA3NNk7sM2ASjBx89zNivU2Y7rmEP+2OxO2dQkOiLMY4VGSL/dweBqvrpelQPQon3Q2xGeIq
        6q6yJ6HIKw0IF87lpjPAfJNabVp9up+VGN9SCTjNmMc7EOpHR6AnWHhuHOwGpCcMUAl1xliE=
X-Google-Smtp-Source: APBJJlG3QyxvhSKb5KAeeSDK40iDT7Pjl2iIu6hEPeWKa9UZTlJb/qPCsHMWEE/O/1TF//5Z3Ay7z+0QuKJGkc7WPA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:abaf:0:b0:cab:9746:ef0e with SMTP
 id v44-20020a25abaf000000b00cab9746ef0emr7489ybi.12.1690346818803; Tue, 25
 Jul 2023 21:46:58 -0700 (PDT)
Date:   Tue, 25 Jul 2023 21:46:51 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230726044652.2169513-1-jingzhangos@google.com>
Subject: [PATCH v1] KVM: arm64: selftests: Test pointer authentication support
 in KVM guest
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>
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

Add a selftest to verify the support for pointer authentication in KVM
guest.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/pauth_test.c        | 143 ++++++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h |   2 +
 3 files changed, 146 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/pauth_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c692cc86e7da..9bac5aecd66d 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -143,6 +143,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
 TEST_GEN_PROGS_aarch64 += aarch64/page_fault_test
+TEST_GEN_PROGS_aarch64 += aarch64/pauth_test
 TEST_GEN_PROGS_aarch64 += aarch64/psci_test
 TEST_GEN_PROGS_aarch64 += aarch64/smccc_filter
 TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
diff --git a/tools/testing/selftests/kvm/aarch64/pauth_test.c b/tools/testing/selftests/kvm/aarch64/pauth_test.c
new file mode 100644
index 000000000000..d5f982da8891
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/pauth_test.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * pauth_test - Test for KVM guest pointer authentication.
+ *
+ * Copyright (c) 2023 Google LLC.
+ *
+ */
+
+#define _GNU_SOURCE
+
+#include <sched.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+
+enum uc_args {
+	WAIT_MIGRATION,
+	PASS,
+	FAIL,
+	FAIL_KVM,
+	FAIL_INSTR,
+};
+
+static noinline void pac_corruptor(void)
+{
+	__asm__ __volatile__(
+		"paciasp\n"
+		"eor lr, lr, #1 << 53\n"
+	);
+
+	/* Migrate guest to another physical CPU before authentication */
+	GUEST_SYNC(WAIT_MIGRATION);
+	__asm__ __volatile__("autiasp\n");
+}
+
+static void guest_code(void)
+{
+	uint64_t sctlr = read_sysreg(sctlr_el1);
+
+	/* Enable PAuth */
+	sctlr |= SCTLR_ELx_ENIA | SCTLR_ELx_ENIB | SCTLR_ELx_ENDA | SCTLR_ELx_ENDB;
+	write_sysreg(sctlr, sctlr_el1);
+	isb();
+
+	pac_corruptor();
+
+	/* Shouldn't be here unless the pac_corruptor didn't do its work */
+	GUEST_SYNC(FAIL);
+	GUEST_DONE();
+}
+
+/* Guest will get an unknown exception if KVM doesn't support guest PAuth */
+static void guest_unknown_handler(struct ex_regs *regs)
+{
+	GUEST_SYNC(FAIL_KVM);
+	GUEST_DONE();
+}
+
+/* Guest will get a FPAC exception if KVM support guest PAuth */
+static void guest_fpac_handler(struct ex_regs *regs)
+{
+	GUEST_SYNC(PASS);
+	GUEST_DONE();
+}
+
+/* Guest will get an instruction abort exception if the PAuth instructions have
+ * no effect (or PAuth not enabled in guest), which would cause guest to fetch
+ * an invalid instruction due to the corrupted LR.
+ */
+static void guest_iabt_handler(struct ex_regs *regs)
+{
+	GUEST_SYNC(FAIL_INSTR);
+	GUEST_DONE();
+}
+
+int main(void)
+{
+	struct kvm_vcpu_init init;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	cpu_set_t cpu_mask;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PTRAUTH_ADDRESS));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_PTRAUTH_GENERIC));
+
+	vm = vm_create(1);
+
+	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
+	init.features[0] |= ((1 << KVM_ARM_VCPU_PTRAUTH_ADDRESS) |
+			     (1 << KVM_ARM_VCPU_PTRAUTH_GENERIC));
+
+	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu);
+
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_EC_UNKNOWN, guest_unknown_handler);
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_EC_FPAC, guest_fpac_handler);
+	vm_install_sync_handler(vm, VECTOR_SYNC_CURRENT,
+				ESR_EC_IABT, guest_iabt_handler);
+
+	while (1) {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_SYNC:
+			switch (uc.args[1]) {
+			case PASS:
+				/* KVM guest PAuth works! */
+				break;
+			case WAIT_MIGRATION:
+				sched_getaffinity(0, sizeof(cpu_mask), &cpu_mask);
+				CPU_CLR(sched_getcpu(), &cpu_mask);
+				sched_setaffinity(0, sizeof(cpu_mask), &cpu_mask);
+				break;
+			case FAIL:
+				TEST_FAIL("Guest corruptor code doesn't work!\n");
+				break;
+			case FAIL_KVM:
+				TEST_FAIL("KVM doesn't support guest PAuth!\n");
+				break;
+			case FAIL_INSTR:
+				TEST_FAIL("Guest PAuth instructions don't work!\n");
+				break;
+			}
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
+		}
+	}
+
+done:
+	kvm_vm_free(vm);
+}
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index cb537253a6b9..f8d541af9c06 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -104,7 +104,9 @@ enum {
 #define ESR_EC_SHIFT		26
 #define ESR_EC_MASK		(ESR_EC_NUM - 1)
 
+#define ESR_EC_UNKNOWN		0x00
 #define ESR_EC_SVC64		0x15
+#define ESR_EC_FPAC		0x1c
 #define ESR_EC_IABT		0x21
 #define ESR_EC_DABT		0x25
 #define ESR_EC_HW_BP_CURRENT	0x31

base-commit: 6eaae198076080886b9e7d57f4ae06fa782f90ef
-- 
2.41.0.487.g6d72f3e995-goog

