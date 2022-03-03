Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610E74CB59C
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 04:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiCCD5J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 22:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiCCD5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 22:57:08 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B7214EF47
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 19:56:23 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id b9-20020a17090aa58900b001b8b14b4aabso2300495pjq.9
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 19:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NckzY4aHIyiZXsaClAwfWp/pDb1JmWqk+qjn0+sOUoI=;
        b=VW1g/aLap7Cx412U6MVCmQ3huTTCGQIsKF+5EhVu8PSpIXmzOtImfHebUE3SNnu1mG
         fKzBzvc/D5fFVMAQZC5cJwDANguFabZD9m0VZn3nDb3SkhFQRx3ywQkbS1D49Q9Y/Wm+
         QI1Src4SiGKfxBcOUtZZUpuLnXUrE5WKonM52u9TyvUpWItBv2gaj3Kc84R6gm7REmku
         JqYjYvATpVM5MiRVbj1op9a141FocnG4UbL3XIZFhAptEjKTeEOlMQJb9j0GTlgQQ4VT
         aISjFD4PKqsSwepPxKw17QTGDpaq1pna70ZldBznas6RSZcJK12P6lyhkNDoD9+Z/MyB
         R3ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NckzY4aHIyiZXsaClAwfWp/pDb1JmWqk+qjn0+sOUoI=;
        b=5K5igdXqWpMMQhRIMCozLuUEUmmVbJ4fPOwqF5iC0Pyu07SanUkq8jJ5eutZ8z1rJc
         oB1rM7SA3lWkYBi0SV36AqIMfj5tFvAlesGuM+nIHdGIZpSOmUeyCP66QQuK/mqwUX3D
         /Y69v5UgVdKSq5VA7FVkZd3jjuGwOzxH8jwxk4rAHBif3pFyKJN8V7nzoWIanvXrZ03D
         bzgo4IA0TlAI3PbZ0M+yc39fhiFeoT4iK+yG/AEbIsZtz1qYLjWQHvefXUPhOvUpxHeF
         Q9WlX/3w4ECAXwolf7TeryBiKo8Y5nREgKkVOndDtSxwfI3mFNdOq1Ny3pvT98YO689q
         MkOA==
X-Gm-Message-State: AOAM531xypvD3lSFiDpSbgWAhUhQZmHrsjx7bPlp/CleRz5BuFhTwmPD
        XFU1au0HjQC094ycjh6XbpRm4O626V0=
X-Google-Smtp-Source: ABdhPJwGkqx1HAK+FV7iAAHRTN1diZQ3YkCi5pD9Jjog5yTbQqCGb2a6Lajv7Zk8gguxjYp3GH6tcJVztQw=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:1d8a:b0:4e1:559d:2f62 with SMTP id
 z10-20020a056a001d8a00b004e1559d2f62mr36600999pfw.26.1646279783056; Wed, 02
 Mar 2022 19:56:23 -0800 (PST)
Date:   Wed,  2 Mar 2022 19:54:08 -0800
In-Reply-To: <20220303035408.3708241-1-reijiw@google.com>
Message-Id: <20220303035408.3708241-3-reijiw@google.com>
Mime-Version: 1.0
References: <20220303035408.3708241-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 3/3] KVM: arm64: selftests: Introduce vcpu_width_config
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a test for aarch64 that ensures non-mixed-width vCPUs
(all 64bit vCPUs or all 32bit vcPUs) can be configured, and
mixed-width vCPUs cannot be configured.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/vcpu_width_config.c | 125 ++++++++++++++++++
 3 files changed, 127 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vcpu_width_config.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index dce7de7755e6..4e884e29b2a8 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -3,6 +3,7 @@
 /aarch64/debug-exceptions
 /aarch64/get-reg-list
 /aarch64/psci_cpu_on_test
+/aarch64/vcpu_width_config
 /aarch64/vgic_init
 /aarch64/vgic_irq
 /s390x/memop
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 17c3f0749f05..3482586c6e33 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -103,6 +103,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
+TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
 TEST_GEN_PROGS_aarch64 += demand_paging_test
diff --git a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
new file mode 100644
index 000000000000..6e6e6a9f69e3
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * vcpu_width_config - Test KVM_ARM_VCPU_INIT() with KVM_ARM_VCPU_EL1_32BIT.
+ *
+ * Copyright (c) 2022 Google LLC.
+ *
+ * This is a test that ensures that non-mixed-width vCPUs (all 64bit vCPUs
+ * or all 32bit vcPUs) can be configured and mixed-width vCPUs cannot be
+ * configured.
+ */
+
+#define _GNU_SOURCE
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+
+
+/*
+ * Add a vCPU, run KVM_ARM_VCPU_INIT with @init1, and then
+ * add another vCPU, and run KVM_ARM_VCPU_INIT with @init2.
+ */
+static int add_init_2vcpus(struct kvm_vcpu_init *init1,
+			   struct kvm_vcpu_init *init2)
+{
+	struct kvm_vm *vm;
+	int ret;
+
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+
+	vm_vcpu_add(vm, 0);
+	ret = _vcpu_ioctl(vm, 0, KVM_ARM_VCPU_INIT, init1);
+	if (ret)
+		goto free_exit;
+
+	vm_vcpu_add(vm, 1);
+	ret = _vcpu_ioctl(vm, 1, KVM_ARM_VCPU_INIT, init2);
+
+free_exit:
+	kvm_vm_free(vm);
+	return ret;
+}
+
+/*
+ * Add two vCPUs, then run KVM_ARM_VCPU_INIT for one vCPU with @init1,
+ * and run KVM_ARM_VCPU_INIT for another vCPU with @init2.
+ */
+static int add_2vcpus_init_2vcpus(struct kvm_vcpu_init *init1,
+				  struct kvm_vcpu_init *init2)
+{
+	struct kvm_vm *vm;
+	int ret;
+
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+
+	vm_vcpu_add(vm, 0);
+	vm_vcpu_add(vm, 1);
+
+	ret = _vcpu_ioctl(vm, 0, KVM_ARM_VCPU_INIT, init1);
+	if (ret)
+		goto free_exit;
+
+	ret = _vcpu_ioctl(vm, 1, KVM_ARM_VCPU_INIT, init2);
+
+free_exit:
+	kvm_vm_free(vm);
+	return ret;
+}
+
+/*
+ * Tests that two 64bit vCPUs can be configured, two 32bit vCPUs can be
+ * configured, and two mixed-witgh vCPUs cannot be configured.
+ * Each of those three cases, configure vCPUs in two different orders.
+ * The one is running KVM_CREATE_VCPU for 2 vCPUs, and then running
+ * KVM_ARM_VCPU_INIT for them.
+ * The other is running KVM_CREATE_VCPU and KVM_ARM_VCPU_INIT for a vCPU,
+ * and then run those commands for another vCPU.
+ */
+int main(void)
+{
+	struct kvm_vcpu_init init1, init2;
+	struct kvm_vm *vm;
+	int ret;
+
+	if (kvm_check_cap(KVM_CAP_ARM_EL1_32BIT) <= 0) {
+		print_skip("KVM_CAP_ARM_EL1_32BIT is not supported");
+		exit(KSFT_SKIP);
+	}
+
+	/* Get the preferred target type and copy that to init2 */
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init1);
+	kvm_vm_free(vm);
+	memcpy(&init2, &init1, sizeof(init2));
+
+	/* Test with 64bit vCPUs */
+	ret = add_init_2vcpus(&init1, &init2);
+	TEST_ASSERT(ret == 0,
+		    "Configuring 64bit EL1 vCPUs failed unexpectedly");
+	ret = add_2vcpus_init_2vcpus(&init1, &init2);
+	TEST_ASSERT(ret == 0,
+		    "Configuring 64bit EL1 vCPUs failed unexpectedly");
+
+	/* Test with 32bit vCPUs */
+	init1.features[0] = (1 << KVM_ARM_VCPU_EL1_32BIT);
+	init2.features[0] = (1 << KVM_ARM_VCPU_EL1_32BIT);
+	ret = add_init_2vcpus(&init1, &init2);
+	TEST_ASSERT(ret == 0,
+		    "Configuring 32bit EL1 vCPUs failed unexpectedly");
+	ret = add_2vcpus_init_2vcpus(&init1, &init2);
+	TEST_ASSERT(ret == 0,
+		    "Configuring 32bit EL1 vCPUs failed unexpectedly");
+
+	/* Test with mixed-width vCPUs  */
+	init1.features[0] = 0;
+	init2.features[0] = (1 << KVM_ARM_VCPU_EL1_32BIT);
+	ret = add_init_2vcpus(&init1, &init2);
+	TEST_ASSERT(ret != 0,
+		    "Configuring mixed-width vCPUs worked unexpectedly");
+	ret = add_2vcpus_init_2vcpus(&init1, &init2);
+	TEST_ASSERT(ret != 0,
+		    "Configuring mixed-width vCPUs worked unexpectedly");
+
+	return 0;
+}
-- 
2.35.1.574.g5d30c73bfb-goog

