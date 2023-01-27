Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD9B67E3B0
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjA0LlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbjA0LlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:41:10 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EA711196B1;
        Fri, 27 Jan 2023 03:40:42 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8928E169C;
        Fri, 27 Jan 2023 03:40:56 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0A2453F64C;
        Fri, 27 Jan 2023 03:40:11 -0800 (PST)
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
Subject: [RFC kvmtool 09/31] arm64: Add --realm command line option
Date:   Fri, 27 Jan 2023 11:39:10 +0000
Message-Id: <20230127113932.166089-10-suzuki.poulose@arm.com>
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

Add the --realm command line option which causes kvmtool to exit with an
error if specified, but which will be enabled once realms are fully
supported by kvmtool.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/aarch64/include/kvm/kvm-config-arch.h |  5 ++++-
 arm/aarch64/kvm.c                         | 20 ++++++++++++++++++--
 arm/include/arm-common/kvm-config-arch.h  |  1 +
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index b055fef4..d2df850a 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -21,7 +21,10 @@ int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset);
 	OPT_BOOLEAN('\0', "no-pvtime", &(cfg)->no_pvtime, "Disable"	\
 			" stolen time"),				\
 	OPT_BOOLEAN('\0', "disable-sve", &(cfg)->disable_sve,		\
-			"Disable SVE"),
+			"Disable SVE"),					\
+	OPT_BOOLEAN('\0', "realm", &(cfg)->is_realm,			\
+			"Create VM running in a realm using Arm RME"),
+
 #include "arm-common/kvm-config-arch.h"
 
 #endif /* KVM__KVM_CONFIG_ARCH_H */
diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 5a53badb..25be2f2d 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -38,9 +38,8 @@ int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset)
 	return 0;
 }
 
-void kvm__arch_validate_cfg(struct kvm *kvm)
+static void validate_mem_cfg(struct kvm *kvm)
 {
-
 	if (kvm->cfg.ram_addr < ARM_MEMORY_AREA) {
 		die("RAM address is below the I/O region ending at %luGB",
 		    ARM_MEMORY_AREA >> 30);
@@ -52,6 +51,23 @@ void kvm__arch_validate_cfg(struct kvm *kvm)
 	}
 }
 
+static void validate_realm_cfg(struct kvm *kvm)
+{
+	if (!kvm->cfg.arch.is_realm)
+		return;
+
+	if (kvm->cfg.arch.aarch32_guest)
+		die("Realms supported only for 64bit guests");
+
+	die("Realms not supported");
+}
+
+void kvm__arch_validate_cfg(struct kvm *kvm)
+{
+	validate_mem_cfg(kvm);
+	validate_realm_cfg(kvm);
+}
+
 u64 kvm__arch_default_ram_address(void)
 {
 	return ARM_MEMORY_AREA;
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 6599305b..5eb791da 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -11,6 +11,7 @@ struct kvm_config_arch {
 	bool		aarch32_guest;
 	bool		has_pmuv3;
 	bool		mte_disabled;
+	bool		is_realm;
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
 	u64		fw_addr;
-- 
2.34.1

