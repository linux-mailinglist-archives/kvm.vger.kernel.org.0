Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA54467E4EA
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 13:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbjA0MQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 07:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233975AbjA0MQT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 07:16:19 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3475A5C8;
        Fri, 27 Jan 2023 04:11:52 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 85B3D175A;
        Fri, 27 Jan 2023 03:41:33 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 068563F64C;
        Fri, 27 Jan 2023 03:40:48 -0800 (PST)
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
Subject: [RFC kvmtool 22/31] arm64: Activate realm before the first VCPU is run
Date:   Fri, 27 Jan 2023 11:39:23 +0000
Message-Id: <20230127113932.166089-23-suzuki.poulose@arm.com>
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

Before KVM can run a VCPU belong to a realm, the realm be activated.
Activating a realm prevents the adding of new object and seals the
cryptographic measurement of that realm. The VCPU state is part of the
measurement, which means that realm activation must be performed after
all VCPUs have been reset.

Current RMM implementation can only create RECs in the order of their
MPIDRs. VCPUs get assigned MPIDRs by KVM based on their VCPU id. Reset the
VCPUs in the order they were created from the main thread instead of doing
it from their own thread, which doesn't guarantee any ordering.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/aarch64/kvm-cpu.c             |  4 ++++
 arm/aarch64/realm.c               | 35 +++++++++++++++++++++++++++++++
 arm/include/arm-common/kvm-arch.h |  1 +
 3 files changed, 40 insertions(+)

diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index 24e570c4..32fa7609 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -187,6 +187,10 @@ void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu)
 	cpu_set_t *affinity;
 	int ret;
 
+	/* VCPU reset is done before activating the realm. */
+	if (kvm->arch.realm_is_active)
+		return;
+
 	affinity = kvm->arch.vcpu_affinity_cpuset;
 	if (affinity) {
 		ret = sched_setaffinity(0, sizeof(cpu_set_t), affinity);
diff --git a/arm/aarch64/realm.c b/arm/aarch64/realm.c
index eddccece..808d39c5 100644
--- a/arm/aarch64/realm.c
+++ b/arm/aarch64/realm.c
@@ -1,4 +1,5 @@
 #include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
 
 #include <linux/byteorder.h>
 #include <asm/image.h>
@@ -192,3 +193,37 @@ void kvm_arm_realm_populate_dtb(struct kvm *kvm)
 	if (end > start)
 		realm_populate(kvm, start, end - start);
 }
+
+static void kvm_arm_realm_activate_realm(struct kvm *kvm)
+{
+	struct kvm_enable_cap activate_realm = {
+		.cap = KVM_CAP_ARM_RME,
+		.args[0] = KVM_CAP_ARM_RME_ACTIVATE_REALM,
+	};
+
+	if (ioctl(kvm->vm_fd, KVM_ENABLE_CAP, &activate_realm) < 0)
+		die_perror("KVM_CAP_ARM_RME(KVM_CAP_ARM_RME_ACTIVATE_REALM)");
+
+	kvm->arch.realm_is_active = true;
+}
+
+static int kvm_arm_realm_finalize(struct kvm *kvm)
+{
+	int i;
+
+	if (!kvm->cfg.arch.is_realm)
+		return 0;
+
+	/*
+	 * VCPU reset must happen before the realm is activated, because their
+	 * state is part of the cryptographic measurement for the realm.
+	 */
+	for (i = 0; i < kvm->nrcpus; i++)
+		kvm_cpu__reset_vcpu(kvm->cpus[i]);
+
+	/* Activate and seal the measurement for the realm. */
+	kvm_arm_realm_activate_realm(kvm);
+
+	return 0;
+}
+last_init(kvm_arm_realm_finalize)
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index b5a4b851..6d48e13c 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -116,6 +116,7 @@ struct kvm_arch {
 	cpu_set_t *vcpu_affinity_cpuset;
 	u64	measurement_algo;
 	u64	sve_vq;
+	bool	realm_is_active;
 };
 
 #endif /* ARM_COMMON__KVM_ARCH_H */
-- 
2.34.1

