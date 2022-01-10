Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34AB488FD9
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 06:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238814AbiAJFlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 00:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238757AbiAJFlY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 00:41:24 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12287C06173F
        for <kvm@vger.kernel.org>; Sun,  9 Jan 2022 21:41:23 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id z20-20020aa791d4000000b004bd024eaf19so4895850pfa.16
        for <kvm@vger.kernel.org>; Sun, 09 Jan 2022 21:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=L1XwvF1r7y5PRO+boTaNuTeg5JcDFRKy/7kUcvyJgIk=;
        b=ivaWcDCKMptpC+2Gyz5PlEwTB+lkFt+sRkpm+fW1bkvDlT+L9lDNkcJdnWvU4IMZuf
         dqtVGmSHGvrcKIpwLw1EmGOsZwO465d/qr4cHs1b8IBS1ZQ8GxSL4zPSEwhaykw+fbqG
         4/np2DQw0fT0l3gq+9HEHPpKRx/ktew8h91goRu2gHdrm9uydrLoq3HGkNvgieQ8zo3G
         n62q0Ay3xTB3tE9syeSBlz9f/Ls6BJDFksyj6BU/Mdk001MlXTA1rOUaaxqmok52btZD
         c8URc2M1wYdWTEh2MasMSg9PnPtfOUtNe6X81+bZZg1PZ8K2jv96qwoXiWFECx2GZBLs
         UIrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=L1XwvF1r7y5PRO+boTaNuTeg5JcDFRKy/7kUcvyJgIk=;
        b=QLIOVWH8mgiiuCNBV8ceTjPdxNUYdOXCY3TAwUXpc17iDWdg2p0VvzFwMOrUq6H5w2
         ccpX98wLaehMNl+PWfVsgRxsghKUW0gWC2Cu3vkZ+qUzvYWq0qAQZU8+j80zZFIe7r24
         v7Lji/NP52B3ok5xfYKTFFwkR0MSvKKhQiWm5g7HHFiX7OScc8bWhL7ytbM7u/YHd4Yi
         8R1AkezW1VVs0G8NtHJqk2UB53tMy/xbO3WxlHiBHjIAvjbBRD8sY1XO5rnbL1QKtv2+
         jCCTiy8lDEGE0U48YXgth5PvrAPfGbmrxth84uWUyggof+Oxgn22B93qjTrZD8NKMcjv
         wB2Q==
X-Gm-Message-State: AOAM532t1jm23RKtRUp+w4stMoAquWYcD9u7N3+FIQ8SdxnN8KroUlmT
        JjPMSxBS9tFd4cmnifbpM1p83XZ/cAc=
X-Google-Smtp-Source: ABdhPJyRAA/U0THLj1vGaXUkmPPljZhPPSiC6fN42d565nCC83OCtbo6QtygcQw9pke/raOzEGb0XEURibI=
X-Received: from reiji-vws-sp.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:410a:: with SMTP id
 u10mr641815pjf.1.1641793283018; Sun, 09 Jan 2022 21:41:23 -0800 (PST)
Date:   Sun,  9 Jan 2022 21:40:42 -0800
In-Reply-To: <20220110054042.1079932-1-reijiw@google.com>
Message-Id: <20220110054042.1079932-2-reijiw@google.com>
Mime-Version: 1.0
References: <20220110054042.1079932-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [PATCH 2/2] KVM: arm64: selftests: Introduce vcpu_width_config
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a test for aarch64 that ensures non-mixed-width vCPUs
(all 64bit vCPUs or all 32bit vcPUs) can be configured, and
mixed-width vCPUs cannot be configured.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/vcpu_width_config.c | 125 ++++++++++++++++++
 3 files changed, 127 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vcpu_width_config.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 3cb5ac5da087..8795a83cc382 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -3,6 +3,7 @@
 /aarch64/debug-exceptions
 /aarch64/get-reg-list
 /aarch64/psci_cpu_on_test
+/aarch64/vcpu_width_config
 /aarch64/vgic_init
 /s390x/memop
 /s390x/resets
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 17342b575e85..259e01d0735a 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -95,6 +95,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
+TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
new file mode 100644
index 000000000000..cd238e068236
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
+int add_init_2vcpus(struct kvm_vcpu_init *init1,
+			 struct kvm_vcpu_init *init2)
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
+int add_2vcpus_init_2vcpus(struct kvm_vcpu_init *init1,
+				struct kvm_vcpu_init *init2)
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
2.34.1.575.g55b058a8bb-goog

