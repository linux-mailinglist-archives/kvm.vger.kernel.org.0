Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBC567E383
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbjA0Ldr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbjA0LdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:33:15 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE6767C72A;
        Fri, 27 Jan 2023 03:31:34 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED163175A;
        Fri, 27 Jan 2023 03:31:35 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.16])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA7843F64C;
        Fri, 27 Jan 2023 03:30:51 -0800 (PST)
From:   Steven Price <steven.price@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
Subject: [RFC PATCH 28/28] HACK: Accept prototype RMI versions
Date:   Fri, 27 Jan 2023 11:29:32 +0000
Message-Id: <20230127112932.38045-29-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127112932.38045-1-steven.price@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The upstream RMM currently advertises the major version of an internal
prototype (v56.0) rather than the expected version from the RMM
architecture specification (v1.0).

Add a config option to enable support for the prototype RMI v56.0.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/rmi_smc.h | 7 +++++++
 arch/arm64/kvm/Kconfig           | 8 ++++++++
 arch/arm64/kvm/rme.c             | 8 ++++++++
 3 files changed, 23 insertions(+)

diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index 16ff65090f3a..d6bbd7d92b8f 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -6,6 +6,13 @@
 #ifndef __ASM_RME_SMC_H
 #define __ASM_RME_SMC_H
 
+#ifdef CONFIG_RME_USE_PROTOTYPE_HACKS
+
+// Allow the prototype RMI version
+#define PROTOTYPE_RMI_ABI_MAJOR_VERSION  56
+
+#endif /* CONFIG_RME_USE_PROTOTYPE_HACKS */
+
 #include <linux/arm-smccc.h>
 
 #define SMC_RxI_CALL(func)				\
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 05da3c8f7e88..13858a5047fd 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -58,6 +58,14 @@ config NVHE_EL2_DEBUG
 
 	  If unsure, say N.
 
+config RME_USE_PROTOTYPE_HACKS
+	bool "Allow RMM prototype version numbers"
+	default y
+	help
+	  For compatibility with the the current RMM code allow versions
+	  numbers from a prototype implementation as well as the expected
+	  version number from the RMM specification.
+
 config PROTECTED_NVHE_STACKTRACE
 	bool "Protected KVM hypervisor stacktraces"
 	depends on NVHE_EL2_DEBUG
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 1eb76cbee267..894060635226 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -67,6 +67,14 @@ static int rmi_check_version(void)
 	version_major = RMI_ABI_VERSION_GET_MAJOR(res.a0);
 	version_minor = RMI_ABI_VERSION_GET_MINOR(res.a0);
 
+#ifdef PROTOTYPE_RMI_ABI_MAJOR_VERSION
+	// Support the prototype
+	if (version_major == PROTOTYPE_RMI_ABI_MAJOR_VERSION) {
+		kvm_err("Using prototype RMM support (version %d.%d)\n",
+			version_major, version_minor);
+		return 0;
+	}
+#endif
 	if (version_major != RMI_ABI_MAJOR_VERSION) {
 		kvm_err("Unsupported RMI ABI (version %d.%d) we support %d\n",
 			version_major, version_minor,
-- 
2.34.1

