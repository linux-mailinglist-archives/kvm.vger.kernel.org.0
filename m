Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85F0667F09
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 20:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240294AbjALT0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 14:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240346AbjALT0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 14:26:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D325F50
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 11:19:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3FB460A47
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631AFC433EF;
        Thu, 12 Jan 2023 19:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673551179;
        bh=HTvHunvcZd7C2QCCQh0G9KdOVeGbweXaEKjlvMnzm2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ikPx7Ceqe8vyV2bzslmTpzrODvulwa1eejjpZZU6N68vC45dWwqY0SRu+yYBTJeMv
         uK6zhSrsBvNiyUEJTc9l0HeZqiGYMIertC5jI0qrGQOOWZLdbUl2N1/gI5+AQYrsRj
         DeFglqELLRtGlKg/Q1JQeoJk3PLBg8RWRqkD5WVc4IqQflF2CGziyigZDM0GsHws+m
         G+sG9cYkEeKWq/0jxF43JlYu5gdMb3sfOra8W2qhkYsi5uERdgdY1mJJcqHet4pe0K
         qM7pSMZjYSqUjJERs7lru4mfa++z/8cWZaDBgpYH+naYPrvwgPXK3e9U4RvTrgU1+x
         TWjJoGK1ueC0w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pG36v-001IWu-BC;
        Thu, 12 Jan 2023 19:19:37 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v7 01/68] arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
Date:   Thu, 12 Jan 2023 19:18:20 +0000
Message-Id: <20230112191927.1814989-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112191927.1814989-1-maz@kernel.org>
References: <20230112191927.1814989-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jintack Lim <jintack.lim@linaro.org>

Add a new ARM64_HAS_NESTED_VIRT feature to indicate that the
CPU has the ARMv8.3 nested virtualization capability, together
with the 'kvm-arm.mode=nested' command line option.

This will be used to support nested virtualization in KVM.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
[maz: moved the command-line option to kvm-arm.mode]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  7 +++++-
 arch/arm64/include/asm/kvm_host.h             |  5 ++++
 arch/arm64/kernel/cpufeature.c                | 25 +++++++++++++++++++
 arch/arm64/kvm/arm.c                          |  5 ++++
 arch/arm64/tools/cpucaps                      |  1 +
 5 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6cfa6e3996cf..b7b0704e360e 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2553,9 +2553,14 @@
 			protected: nVHE-based mode with support for guests whose
 				   state is kept private from the host.
 
+			nested: VHE-based mode with support for nested
+				virtualization. Requires at least ARMv8.3
+				hardware.
+
 			Defaults to VHE/nVHE based on hardware support. Setting
 			mode to "protected" will disable kexec and hibernation
-			for the host.
+			for the host. "nested" is experimental and should be
+			used with extreme caution.
 
 	kvm-arm.vgic_v3_group0_trap=
 			[KVM,ARM] Trap guest accesses to GICv3 group-0
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 35a159d131b5..8919e971abdf 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -60,9 +60,14 @@
 enum kvm_mode {
 	KVM_MODE_DEFAULT,
 	KVM_MODE_PROTECTED,
+	KVM_MODE_NV,
 	KVM_MODE_NONE,
 };
+#ifdef CONFIG_KVM
 enum kvm_mode kvm_get_mode(void);
+#else
+static inline enum kvm_mode kvm_get_mode(void) { return KVM_MODE_NONE; };
+#endif
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index a77315b338e6..3fc14ee86239 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1956,6 +1956,20 @@ static void cpu_copy_el2regs(const struct arm64_cpu_capabilities *__unused)
 		write_sysreg(read_sysreg(tpidr_el1), tpidr_el2);
 }
 
+static bool has_nested_virt_support(const struct arm64_cpu_capabilities *cap,
+				    int scope)
+{
+	if (kvm_get_mode() != KVM_MODE_NV)
+		return false;
+
+	if (!has_cpuid_feature(cap, scope)) {
+		pr_warn("unavailable: %s\n", cap->desc);
+		return false;
+	}
+
+	return true;
+}
+
 #ifdef CONFIG_ARM64_PAN
 static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
 {
@@ -2215,6 +2229,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = runs_at_el2,
 		.cpu_enable = cpu_copy_el2regs,
 	},
+	{
+		.desc = "Nested Virtualization Support",
+		.capability = ARM64_HAS_NESTED_VIRT,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_nested_virt_support,
+		.sys_reg = SYS_ID_AA64MMFR2_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR2_EL1_NV_SHIFT,
+		.field_width = 4,
+		.min_field_value = ID_AA64MMFR2_EL1_NV_IMP,
+	},
 	{
 		.capability = ARM64_HAS_32BIT_EL0_DO_NOT_USE,
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9c5573bc4614..3fd8f37830f2 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2310,6 +2310,11 @@ static int __init early_kvm_mode_cfg(char *arg)
 		return 0;
 	}
 
+	if (strcmp(arg, "nested") == 0 && !WARN_ON(!is_kernel_in_hyp_mode())) {
+		kvm_mode = KVM_MODE_NV;
+		return 0;
+	}
+
 	return -EINVAL;
 }
 early_param("kvm-arm.mode", early_kvm_mode_cfg);
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index a86ee376920a..19813aef60bf 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -31,6 +31,7 @@ HAS_GENERIC_AUTH_IMP_DEF
 HAS_IRQ_PRIO_MASKING
 HAS_LDAPR
 HAS_LSE_ATOMICS
+HAS_NESTED_VIRT
 HAS_NO_FPSIMD
 HAS_NO_HW_PREFETCH
 HAS_PAN
-- 
2.34.1

