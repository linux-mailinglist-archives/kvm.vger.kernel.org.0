Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B26404307
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 03:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350388AbhIIBmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 21:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350093AbhIIBlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 21:41:11 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFC8C0617AD
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 18:38:58 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id g192-20020a25dbc9000000b0059bd2958c8aso427719ybf.5
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 18:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dIO3bJcCcsJgj6H+C/RQ54N/wYHZAN3qawTcM2QNEMU=;
        b=WtlxqIExWluJ+gz3G6WEWAJzwZNCrMqhj5uBzg+xL/0WIZa269+Ew1WjzrCRnky+VI
         l2fHKBclWRDqYu1p9iZ9x90cpra2Cxsqf2uJ8DF+QDwgjr49JF87QoRS79Xm5b7d8r/G
         jxdZJLYeyEAFvDE2cXVgoG1gzo48wFTY5bo5OjeZ428FWDEk5b4Dlh4sA9OGeafsBrO5
         mtBws12nX15l8HW/5vnVYsxSk1msKZLZP2POGVnXE7bm5MS/fPerK+jPhYug8xUe4550
         hBr3NgA+jQ9uCAfH1tuYjzsKTAon8Y7Ou4hFOAQ9UVOZqqgxFp3gU2wNjKuYz3mIHK1q
         vHvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dIO3bJcCcsJgj6H+C/RQ54N/wYHZAN3qawTcM2QNEMU=;
        b=Bnj/ySOIhTN4FE/uQ0/5XcYmXswLEc7yLyE8fN1Xl0Zw3Fdoeeiq7CBMSTezRUyKEX
         xlgJUW9fD5bhUP/SqESSbiS3x7O5htkhR78+gBdJHpalGkHG9l8PZdQAs6TlxWLCQxat
         ubhIJM0cqT1j8AxYHQoSP5Z5DsunBpilOaAMCq8nGIVTljarCiRGeo8mM237s5l500mE
         1wUe4qTWyTRrNeuqts5jpSFiiULeIwp0ep6mHact8Pk315zakIGe5ShKJWFZvHLjGdgE
         fSygsbLzA3wnxlyGdEjGImVlyJyDDbgUIuORO89WwRkdWp1as63wyBrfZf+YKpNmXKOd
         ui5w==
X-Gm-Message-State: AOAM531cENBebwF5qu7wZPZPM1+htbKz3xaUtnPf0rxnqw4V5UbbuLqM
        oPthy4iIv+NhyaZt0jQnQrI6uESxkvq3
X-Google-Smtp-Source: ABdhPJw3lyrZigZ0lyqnRcsV8MPIT9rXCF3qEygV0fl3otkVWKB+0GuwV1S2Fc90Bg6qc71tsxnR6E+M/WtZ
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:c0c1:: with SMTP id
 c184mr542320ybf.382.1631151538010; Wed, 08 Sep 2021 18:38:58 -0700 (PDT)
Date:   Thu,  9 Sep 2021 01:38:14 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-15-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 14/18] KVM: arm64: selftests: Add host support for vGIC
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
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

Implement a simple library to perform vGIC-v3 setup
from a host point of view. This includes creating a
vGIC device, setting up distributor and redistributor
attributes, and mapping the guest physical addresses.

The definition of REDIST_REGION_ATTR_ADDR is taken
from aarch64/vgic_init test.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  2 +-
 .../selftests/kvm/include/aarch64/vgic.h      | 20 +++++++
 .../testing/selftests/kvm/lib/aarch64/vgic.c  | 60 +++++++++++++++++++
 3 files changed, 81 insertions(+), 1 deletion(-)
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
index 000000000000..3a776af958a0
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
@@ -0,0 +1,20 @@
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
+#define REDIST_REGION_ATTR_ADDR(count, base, flags, index) \
+	(((uint64_t)(count) << 52) | \
+	((uint64_t)((base) >> 16) << 16) | \
+	((uint64_t)(flags) << 12) | \
+	index)
+
+int vgic_v3_setup(struct kvm_vm *vm,
+				uint64_t gicd_base_gpa, uint64_t gicr_base_gpa);
+
+#endif /* SELFTEST_KVM_VGIC_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
new file mode 100644
index 000000000000..2318912ab134
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ARM Generic Interrupt Controller (GIC) v3 host support
+ */
+
+#include <linux/kvm.h>
+#include <linux/sizes.h>
+
+#include "kvm_util.h"
+#include "vgic.h"
+
+#define VGIC_V3_GICD_SZ		(SZ_64K)
+#define VGIC_V3_GICR_SZ		(2 * SZ_64K)
+
+/*
+ * vGIC-v3 default host setup
+ *
+ * Input args:
+ *	vm - KVM VM
+ *	gicd_base_gpa - Guest Physical Address of the Distributor region
+ *	gicr_base_gpa - Guest Physical Address of the Redistributor region
+ *
+ * Output args: None
+ *
+ * Return: GIC file-descriptor or negative error code upon failure
+ *
+ * The function creates a vGIC-v3 device and maps the distributor and
+ * redistributor regions of the guest. Since it depends on the number of
+ * vCPUs for the VM, it must be called after all the vCPUs have been created.
+ */
+int vgic_v3_setup(struct kvm_vm *vm,
+		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
+{
+	uint64_t redist_attr;
+	int gic_fd, nr_vcpus;
+	unsigned int nr_gic_pages;
+
+	nr_vcpus = vm_get_nr_vcpus(vm);
+	TEST_ASSERT(nr_vcpus > 0, "Invalid number of CPUs: %u\n", nr_vcpus);
+
+	/* Distributor setup */
+	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd_base_gpa, true);
+	nr_gic_pages = vm_calc_num_guest_pages(vm_get_mode(vm), VGIC_V3_GICD_SZ);
+	virt_map(vm, gicd_base_gpa, gicd_base_gpa,  nr_gic_pages);
+
+	/* Redistributor setup */
+	redist_attr = REDIST_REGION_ATTR_ADDR(nr_vcpus, gicr_base_gpa, 0, 0);
+	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &redist_attr, true);
+	nr_gic_pages = vm_calc_num_guest_pages(vm_get_mode(vm),
+						VGIC_V3_GICR_SZ * nr_vcpus);
+	virt_map(vm, gicr_base_gpa, gicr_base_gpa,  nr_gic_pages);
+
+	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+
+	return gic_fd;
+}
-- 
2.33.0.153.gba50c8fa24-goog

