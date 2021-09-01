Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDAB43FE4BF
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 23:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344537AbhIAVQC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 17:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344792AbhIAVPr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 17:15:47 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B01C0612A3
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 14:14:44 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f64-20020a2538430000b0290593bfc4b046so868506yba.9
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 14:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Wxf2Q9G637jni9KHKd5rXQqnKCGDoBa52DRcml59SiU=;
        b=lhAbv7mGeUuGKLjRHWaoZNUDGxYIBgXA9y9avJS24NsHFEJdyXPu3RGaVr+fbBtqr0
         WR4c50H8VR3dEJFYx5FloUoaNu3+e4xUvjQJy0vHkakDKhXuWpjC5hGxwwYSHqny6LdP
         HfylVgb5hPKhpOCmnK3W/Sk5XCwLMuLsAOYlcHC8fuwTSaFkfeKL94ppIcuo8VSC09Lx
         T3lpSpmTzwNL+wT9hBhklY3UFK0EyyngOLV96Q7YwudnCQ9y/WIkZxAaNHKyrbmG3yjs
         8QvyYUEm/fnypj2E8o/Z76qy4+A9+STndgR7rSz7/SXpT7CrdA3Y35A9CJ8Dyglw67Qa
         heFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Wxf2Q9G637jni9KHKd5rXQqnKCGDoBa52DRcml59SiU=;
        b=J4EQOf4zHqnwElUOVyO9RzJVZjWQEwTPdYXlM+Aixe9DGbXw23DLc7Ya4cq7nGqUsR
         2QV40y/PN6ucX/Oj18Upz6C4uNOFJTZo6t0QfbzPGAefEa0MPh380RGZaDzF+sPB6kWm
         jt/WLQb/5JTE2oXBmjswr31v9QZ45FY39cgtrrsGnyKGCR9EJsJ2dPGEf4Li13XYjbCO
         xQV96qNTcqAPSpqi7T5I+w9pr4zcktehsvcCbt0l75GM41crfMizirx+HMj0EXHu1YcC
         R4vzDz2LZgfNWuBd4tKS3AxjGAmDNk22Ae+6UNj07QuD3QI5QfCH7yTPRHtHmywWO6yo
         uYJA==
X-Gm-Message-State: AOAM532rQSf472buf4Dzs4hZfui1OqE4HatjhIw8Q/fe/ZE7HpIvvP7A
        8gUG4VnTtue19BDmFv4jXpgvAwCLJjV8
X-Google-Smtp-Source: ABdhPJwHjSrW5jMuc543Z6g/BHvdlyhX5TEwY2mEfK1G/Ib27DMWkeFlybXzt0MSBsuOg1QGYuWx3Ouzvoug
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6902:704:: with SMTP id
 k4mr2061074ybt.419.1630530883870; Wed, 01 Sep 2021 14:14:43 -0700 (PDT)
Date:   Wed,  1 Sep 2021 21:14:10 +0000
In-Reply-To: <20210901211412.4171835-1-rananta@google.com>
Message-Id: <20210901211412.4171835-11-rananta@google.com>
Mime-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v3 10/12] KVM: arm64: selftests: Add host support for vGIC
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement a simple library to do perform vGIC-v3
setup from a host of view. This includes creating
a vGIC device, setting up distributor and redistributor
attributes, and mapping the guest physical addresses.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

---
 tools/testing/selftests/kvm/Makefile          |  2 +-
 .../selftests/kvm/include/aarch64/vgic.h      | 14 ++++
 .../testing/selftests/kvm/lib/aarch64/vgic.c  | 67 +++++++++++++++++++
 3 files changed, 82 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/vgic.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/vgic.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 5476a8ddef60..8342f65c1d96 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -35,7 +35,7 @@ endif
 
 LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
 LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
-LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c
+LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c lib/aarch64/vgic.c
 LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
 
 TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
new file mode 100644
index 000000000000..45bbf238147a
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ARM Generic Interrupt Controller (GIC) host specific defines
+ */
+
+#ifndef SELFTEST_KVM_VGIC_H
+#define SELFTEST_KVM_VGIC_H
+
+#include <linux/kvm.h>
+
+int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
+		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa, uint32_t slot);
+
+#endif /* SELFTEST_KVM_VGIC_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
new file mode 100644
index 000000000000..a0e4b986d335
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ARM Generic Interrupt Controller (GIC) v3 host support
+ */
+
+#include <linux/kvm.h>
+#include <linux/sizes.h>
+
+#include "kvm_util.h"
+
+#define VGIC_V3_GICD_SZ		(SZ_64K)
+#define VGIC_V3_GICR_SZ		(2 * SZ_64K)
+
+#define REDIST_REGION_ATTR_ADDR(count, base, flags, index) \
+	(((uint64_t)(count) << 52) | \
+	((uint64_t)((base) >> 16) << 16) | \
+	((uint64_t)(flags) << 12) | \
+	index)
+
+static void vgic_v3_map(struct kvm_vm *vm, uint64_t addr, unsigned int size)
+{
+	unsigned int n_pages = DIV_ROUND_UP(size, vm_get_page_size(vm));
+
+	virt_map(vm, addr, addr, n_pages);
+}
+
+/*
+ * vGIC-v3 default host setup
+ *
+ * Input args:
+ *	vm - KVM VM
+ *	nr_vcpus - Number of vCPUs for this VM
+ *	gicd_base_gpa - Guest Physical Address of the Distributor region
+ *	gicr_base_gpa - Guest Physical Address of the Redistributor region
+ *
+ * Output args: None
+ *
+ * Return: GIC file-descriptor or negative error code upon failure
+ *
+ * The function creates a vGIC-v3 device and maps the distributor and
+ * redistributor regions of the guest.
+ */
+int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
+		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
+{
+	uint64_t redist_attr;
+	int gic_fd;
+
+	TEST_ASSERT(nr_vcpus <= KVM_MAX_VCPUS,
+			"Invalid number of CPUs: %u\n", nr_vcpus);
+
+	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+
+	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd_base_gpa, true);
+	vgic_v3_map(vm, gicd_base_gpa, VGIC_V3_GICD_SZ);
+
+	redist_attr = REDIST_REGION_ATTR_ADDR(nr_vcpus, gicr_base_gpa, 0, 0);
+	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &redist_attr, true);
+	vgic_v3_map(vm, gicr_base_gpa, VGIC_V3_GICR_SZ * nr_vcpus);
+
+	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+
+	return gic_fd;
+}
-- 
2.33.0.153.gba50c8fa24-goog

