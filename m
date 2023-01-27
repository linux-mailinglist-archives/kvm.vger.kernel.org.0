Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 641E867E3B7
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbjA0Llc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233878AbjA0LlM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:41:12 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 66D6C22A39;
        Fri, 27 Jan 2023 03:40:45 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E28C316F8;
        Fri, 27 Jan 2023 03:41:07 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6552D3F64C;
        Fri, 27 Jan 2023 03:40:23 -0800 (PST)
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
Subject: [RFC kvmtool 13/31] arm64: Add --measurement-algo command line option for a realm
Date:   Fri, 27 Jan 2023 11:39:14 +0000
Message-Id: <20230127113932.166089-14-suzuki.poulose@arm.com>
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

From: Christoffer Dall <christoffer.dall@arm.com>

Add the command line option to specify the algorithm that will be used
to create the cryptographic measurement of the realm. Valid options are
"sha256" and "sha512". The final measurement will be a hash using the
selected algorithm

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/aarch64/include/kvm/kvm-config-arch.h |  5 ++++-
 arm/aarch64/kvm.c                         | 17 ++++++++++++++++-
 arm/include/arm-common/kvm-arch.h         |  1 +
 arm/include/arm-common/kvm-config-arch.h  |  1 +
 4 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index d2df850a..b93999b6 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -23,7 +23,10 @@ int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset);
 	OPT_BOOLEAN('\0', "disable-sve", &(cfg)->disable_sve,		\
 			"Disable SVE"),					\
 	OPT_BOOLEAN('\0', "realm", &(cfg)->is_realm,			\
-			"Create VM running in a realm using Arm RME"),
+			"Create VM running in a realm using Arm RME"),	\
+	OPT_STRING('\0', "measurement-algo", &(cfg)->measurement_algo,	\
+			 "sha256, sha512",				\
+			 "Realm Measurement algorithm, default: sha256"),
 
 #include "arm-common/kvm-config-arch.h"
 
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 5db4c572..a5a98b2e 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -53,12 +53,27 @@ static void validate_mem_cfg(struct kvm *kvm)
 
 static void validate_realm_cfg(struct kvm *kvm)
 {
-	if (!kvm->cfg.arch.is_realm)
+	if (!kvm->cfg.arch.is_realm) {
+		if (kvm->cfg.arch.measurement_algo)
+			die("--measurement-algo valid only with --realm");
 		return;
+	}
 
 	if (kvm->cfg.arch.aarch32_guest)
 		die("Realms supported only for 64bit guests");
 
+	if (kvm->cfg.arch.measurement_algo) {
+		if (strcmp(kvm->cfg.arch.measurement_algo, "sha256") == 0)
+			kvm->arch.measurement_algo = KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA256;
+		else if (strcmp(kvm->cfg.arch.measurement_algo, "sha512") == 0)
+			kvm->arch.measurement_algo = KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA512;
+		else
+			die("unknown realm measurement algorithm");
+	} else {
+		pr_debug("Realm Hash algorithm: Using default SHA256\n");
+		kvm->arch.measurement_algo = KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA256;
+	}
+
 	die("Realms not supported");
 }
 
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index b2ae373c..68224b1c 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -113,6 +113,7 @@ struct kvm_arch {
 	u64	dtb_guest_start;
 
 	cpu_set_t *vcpu_affinity_cpuset;
+	u64	measurement_algo;
 };
 
 #endif /* ARM_COMMON__KVM_ARCH_H */
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 5eb791da..a2faa3af 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -6,6 +6,7 @@
 struct kvm_config_arch {
 	const char	*dump_dtb_filename;
 	const char	*vcpu_affinity;
+	const char	*measurement_algo;
 	unsigned int	force_cntfrq;
 	bool		virtio_trans_pci;
 	bool		aarch32_guest;
-- 
2.34.1

