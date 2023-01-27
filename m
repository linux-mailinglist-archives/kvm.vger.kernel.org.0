Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08BA867E4F8
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 13:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbjA0MUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 07:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbjA0MT3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 07:19:29 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 349088324C;
        Fri, 27 Jan 2023 04:16:08 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 95E9C175D;
        Fri, 27 Jan 2023 03:41:13 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 186843F64C;
        Fri, 27 Jan 2023 03:40:28 -0800 (PST)
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
Subject: [RFC kvmtool 15/31] arm64: Add support for Realm Personalisation Value
Date:   Fri, 27 Jan 2023 11:39:16 +0000
Message-Id: <20230127113932.166089-16-suzuki.poulose@arm.com>
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

Add option to specify Realm personalisation value

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/aarch64/include/kvm/kvm-config-arch.h |  6 +++++-
 arm/aarch64/kvm.c                         |  7 +++++++
 arm/aarch64/realm.c                       | 23 +++++++++++++++++++++++
 arm/include/arm-common/kvm-config-arch.h  |  1 +
 4 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index b93999b6..f2e659ad 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -26,7 +26,11 @@ int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset);
 			"Create VM running in a realm using Arm RME"),	\
 	OPT_STRING('\0', "measurement-algo", &(cfg)->measurement_algo,	\
 			 "sha256, sha512",				\
-			 "Realm Measurement algorithm, default: sha256"),
+			 "Realm Measurement algorithm, default: sha256"),\
+	OPT_STRING('\0', "realm-pv", &(cfg)->realm_pv,			\
+			"personalisation value",			\
+			"Personalisation Value (only) for Realm VMs"),
+
 
 #include "arm-common/kvm-config-arch.h"
 
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index a5a98b2e..4798e359 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -56,6 +56,8 @@ static void validate_realm_cfg(struct kvm *kvm)
 	if (!kvm->cfg.arch.is_realm) {
 		if (kvm->cfg.arch.measurement_algo)
 			die("--measurement-algo valid only with --realm");
+		if (kvm->cfg.arch.realm_pv)
+			die("--realm-pv valid only with --realm");
 		return;
 	}
 
@@ -74,6 +76,11 @@ static void validate_realm_cfg(struct kvm *kvm)
 		kvm->arch.measurement_algo = KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA256;
 	}
 
+	if (kvm->cfg.arch.realm_pv) {
+		if (strlen(kvm->cfg.arch.realm_pv) > KVM_CAP_ARM_RME_RPV_SIZE)
+			die("Invalid size for Realm Personalization Value\n");
+	}
+
 	die("Realms not supported");
 }
 
diff --git a/arm/aarch64/realm.c b/arm/aarch64/realm.c
index 31543e55..2e0be982 100644
--- a/arm/aarch64/realm.c
+++ b/arm/aarch64/realm.c
@@ -20,9 +20,32 @@ static void realm_configure_hash_algo(struct kvm *kvm)
 		die_perror("KVM_CAP_RME(KVM_CAP_ARM_RME_CONFIG_REALM) hash_algo");
 }
 
+static void realm_configure_rpv(struct kvm *kvm)
+{
+	struct kvm_cap_arm_rme_config_item rpv_cfg  = {
+		.cfg	= KVM_CAP_ARM_RME_CFG_RPV,
+	};
+
+	struct kvm_enable_cap rme_config = {
+		.cap = KVM_CAP_ARM_RME,
+		.args[0] = KVM_CAP_ARM_RME_CONFIG_REALM,
+		.args[1] = (u64)&rpv_cfg,
+	};
+
+	if (!kvm->cfg.arch.realm_pv)
+		return;
+
+	memset(&rpv_cfg.rpv, 0, sizeof(rpv_cfg.rpv));
+	memcpy(&rpv_cfg.rpv, kvm->cfg.arch.realm_pv, strlen(kvm->cfg.arch.realm_pv));
+
+	if (ioctl(kvm->vm_fd, KVM_ENABLE_CAP, &rme_config) < 0)
+		die_perror("KVM_CAP_RME(KVM_CAP_ARM_RME_CONFIG_REALM) RPV");
+}
+
 static void realm_configure_parameters(struct kvm *kvm)
 {
 	realm_configure_hash_algo(kvm);
+	realm_configure_rpv(kvm);
 }
 
 void kvm_arm_realm_create_realm_descriptor(struct kvm *kvm)
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index a2faa3af..80a3b18e 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -7,6 +7,7 @@ struct kvm_config_arch {
 	const char	*dump_dtb_filename;
 	const char	*vcpu_affinity;
 	const char	*measurement_algo;
+	const char	*realm_pv;
 	unsigned int	force_cntfrq;
 	bool		virtio_trans_pci;
 	bool		aarch32_guest;
-- 
2.34.1

