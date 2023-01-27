Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB2C67E3B5
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbjA0Lla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbjA0LlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:41:12 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F27722A29;
        Fri, 27 Jan 2023 03:40:44 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14FA01692;
        Fri, 27 Jan 2023 03:41:05 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8C0393F64C;
        Fri, 27 Jan 2023 03:40:20 -0800 (PST)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     suzuki.poulose@arm.com,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, linux-coco@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RFC kvmtool 12/31] arm64: Create Realm Descriptor
Date:   Fri, 27 Jan 2023 11:39:13 +0000
Message-Id: <20230127113932.166089-13-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127113932.166089-1-suzuki.poulose@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127113932.166089-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

Create the Realm Descriptor using the measurement algorithm set
with --measurement-algo.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 Makefile                        |  1 +
 arm/aarch32/include/asm/realm.h | 10 ++++++++++
 arm/aarch64/include/asm/realm.h | 10 ++++++++++
 arm/aarch64/realm.c             | 14 ++++++++++++++
 arm/kvm.c                       |  3 +++
 5 files changed, 38 insertions(+)
 create mode 100644 arm/aarch32/include/asm/realm.h
 create mode 100644 arm/aarch64/include/asm/realm.h
 create mode 100644 arm/aarch64/realm.c

diff --git a/Makefile b/Makefile
index ed2414bd..88cdf6d2 100644
--- a/Makefile
+++ b/Makefile
@@ -192,6 +192,7 @@ ifeq ($(ARCH), arm64)
 	OBJS		+= arm/aarch64/kvm.o
 	OBJS		+= arm/aarch64/pvtime.o
 	OBJS		+= arm/aarch64/pmu.o
+	OBJS		+= arm/aarch64/realm.o
 	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
 	ARCH_INCLUDE	+= -Iarm/aarch64/include
 
diff --git a/arm/aarch32/include/asm/realm.h b/arm/aarch32/include/asm/realm.h
new file mode 100644
index 00000000..5aca6cca
--- /dev/null
+++ b/arm/aarch32/include/asm/realm.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __ASM_REALM_H
+#define __ASM_REALM_H
+
+#include "kvm/kvm.h"
+
+static inline void kvm_arm_realm_create_realm_descriptor(struct kvm *kvm) {}
+
+#endif /* ! __ASM_REALM_H */
diff --git a/arm/aarch64/include/asm/realm.h b/arm/aarch64/include/asm/realm.h
new file mode 100644
index 00000000..e176f15f
--- /dev/null
+++ b/arm/aarch64/include/asm/realm.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __ASM_REALM_H
+#define __ASM_REALM_H
+
+#include "kvm/kvm.h"
+
+void kvm_arm_realm_create_realm_descriptor(struct kvm *kvm);
+
+#endif /* ! __ASM_REALM_H */
diff --git a/arm/aarch64/realm.c b/arm/aarch64/realm.c
new file mode 100644
index 00000000..3a4adb66
--- /dev/null
+++ b/arm/aarch64/realm.c
@@ -0,0 +1,14 @@
+#include "kvm/kvm.h"
+
+#include <asm/realm.h>
+
+void kvm_arm_realm_create_realm_descriptor(struct kvm *kvm)
+{
+	struct kvm_enable_cap rme_create_rd = {
+		.cap = KVM_CAP_ARM_RME,
+		.args[0] = KVM_CAP_ARM_RME_CREATE_RD,
+	};
+
+	if (ioctl(kvm->vm_fd, KVM_ENABLE_CAP, &rme_create_rd) < 0)
+		die_perror("KVM_CAP_RME(KVM_CAP_ARM_RME_CREATE_RD)");
+}
diff --git a/arm/kvm.c b/arm/kvm.c
index 0e40b753..2510a322 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -127,6 +127,9 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
 
 void kvm__arch_init(struct kvm *kvm)
 {
+	if (kvm->cfg.arch.is_realm)
+		kvm_arm_realm_create_realm_descriptor(kvm);
+
 	/* Create the virtual GIC. */
 	if (gic__create(kvm, kvm->cfg.arch.irqchip))
 		die("Failed to create virtual GIC");
-- 
2.34.1

