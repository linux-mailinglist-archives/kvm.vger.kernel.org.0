Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F4867E3BE
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbjA0LmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbjA0Ll2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:41:28 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E971C78ACD;
        Fri, 27 Jan 2023 03:41:05 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6EDC71763;
        Fri, 27 Jan 2023 03:41:16 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E5B2D3F64C;
        Fri, 27 Jan 2023 03:40:31 -0800 (PST)
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
Subject: [RFC kvmtool 16/31] arm64: Add support for specifying the SVE vector length for Realm
Date:   Fri, 27 Jan 2023 11:39:17 +0000
Message-Id: <20230127113932.166089-17-suzuki.poulose@arm.com>
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

Add option to specify SVE vector length for realms.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/aarch64/include/kvm/kvm-config-arch.h |  6 ++++--
 arm/aarch64/kvm.c                         | 23 +++++++++++++++++++++++
 arm/aarch64/realm.c                       | 21 +++++++++++++++++++++
 arm/include/arm-common/kvm-arch.h         |  1 +
 arm/include/arm-common/kvm-config-arch.h  |  1 +
 5 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index f2e659ad..0f42c2c2 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -29,8 +29,10 @@ int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset);
 			 "Realm Measurement algorithm, default: sha256"),\
 	OPT_STRING('\0', "realm-pv", &(cfg)->realm_pv,			\
 			"personalisation value",			\
-			"Personalisation Value (only) for Realm VMs"),
-
+			"Personalisation Value (only) for Realm VMs"),	\
+	OPT_U64('\0', "sve-vl", &(cfg)->sve_vl,				\
+			"SVE Vector Length the VM"			\
+			"(only supported for Realms)"),
 
 #include "arm-common/kvm-config-arch.h"
 
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 4798e359..fca1410b 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -51,13 +51,19 @@ static void validate_mem_cfg(struct kvm *kvm)
 	}
 }
 
+#define SVE_VL_ALIGN	128
+
 static void validate_realm_cfg(struct kvm *kvm)
 {
+	u32 sve_vl;
+
 	if (!kvm->cfg.arch.is_realm) {
 		if (kvm->cfg.arch.measurement_algo)
 			die("--measurement-algo valid only with --realm");
 		if (kvm->cfg.arch.realm_pv)
 			die("--realm-pv valid only with --realm");
+		if (kvm->cfg.arch.sve_vl)
+			die("--sve-vl valid only with --realm");
 		return;
 	}
 
@@ -76,6 +82,23 @@ static void validate_realm_cfg(struct kvm *kvm)
 		kvm->arch.measurement_algo = KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA256;
 	}
 
+	sve_vl = kvm->cfg.arch.sve_vl;
+	if (sve_vl) {
+		if (kvm->cfg.arch.disable_sve)
+			die("SVE VL requested when SVE is disabled");
+		if (!IS_ALIGNED(sve_vl, SVE_VL_ALIGN))
+			die("SVE VL is not aligned to %dbit\n", SVE_VL_ALIGN);
+		kvm->arch.sve_vq = (sve_vl / SVE_VL_ALIGN) - 1;
+	} else {
+		/*
+		 * Disable SVE for Realms, if a VL is not requested.
+		 * The SVE VL will be measured as part of the parameter
+		 * and we do not want to add an unknown entity to the
+		 * measurement.
+		 */
+		kvm->cfg.arch.disable_sve = true;
+	}
+
 	if (kvm->cfg.arch.realm_pv) {
 		if (strlen(kvm->cfg.arch.realm_pv) > KVM_CAP_ARM_RME_RPV_SIZE)
 			die("Invalid size for Realm Personalization Value\n");
diff --git a/arm/aarch64/realm.c b/arm/aarch64/realm.c
index 2e0be982..fc7f8d6a 100644
--- a/arm/aarch64/realm.c
+++ b/arm/aarch64/realm.c
@@ -42,10 +42,31 @@ static void realm_configure_rpv(struct kvm *kvm)
 		die_perror("KVM_CAP_RME(KVM_CAP_ARM_RME_CONFIG_REALM) RPV");
 }
 
+static void realm_configure_sve(struct kvm *kvm)
+{
+	struct kvm_cap_arm_rme_config_item sve_cfg = {
+		.cfg	= KVM_CAP_ARM_RME_CFG_SVE,
+		.sve_vq = kvm->arch.sve_vq,
+	};
+
+	struct kvm_enable_cap rme_config = {
+		.cap = KVM_CAP_ARM_RME,
+		.args[0] = KVM_CAP_ARM_RME_CONFIG_REALM,
+		.args[1] = (u64)&sve_cfg,
+	};
+
+	if (kvm->cfg.arch.disable_sve)
+		return;
+
+	if (ioctl(kvm->vm_fd, KVM_ENABLE_CAP, &rme_config) < 0)
+		die_perror("KVM_CAP_RME(KVM_CAP_ARM_RME_CONFIG_REALM) SVE");
+}
+
 static void realm_configure_parameters(struct kvm *kvm)
 {
 	realm_configure_hash_algo(kvm);
 	realm_configure_rpv(kvm);
+	realm_configure_sve(kvm);
 }
 
 void kvm_arm_realm_create_realm_descriptor(struct kvm *kvm)
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index 68224b1c..41b31f11 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -114,6 +114,7 @@ struct kvm_arch {
 
 	cpu_set_t *vcpu_affinity_cpuset;
 	u64	measurement_algo;
+	u64	sve_vq;
 };
 
 #endif /* ARM_COMMON__KVM_ARCH_H */
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 80a3b18e..d923fd9e 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -19,6 +19,7 @@ struct kvm_config_arch {
 	u64		fw_addr;
 	bool no_pvtime;
 	bool		disable_sve;
+	u64		sve_vl;
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);
-- 
2.34.1

