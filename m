Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22FF690FB5
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 18:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjBIR64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 12:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjBIR6w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 12:58:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D3F60BB4
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 09:58:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44AE8B82282
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 17:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A63C4339B;
        Thu,  9 Feb 2023 17:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675965527;
        bh=RZMIS1gWp+105YhVM/qcEDBwXsDYL2EyKON2lk0Ivkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPACkFXQwf3Bw5W70rsHpqpRc26SlO3qX9vN2zv/bz4GZhAGxUr/dIU2o6BBDeIna
         SHv7PDtIH75wvkVsrnvFT3zL+0y36zaQYCp+DRx39WJAY4rghE9dOUGBlUtji+DNys
         p3Jc+Qof3uHGUcps/Rfb/ET5uRRvs+Kzri7Kqk/MtRoIuU1MOFztiW6fKRdMWrI4As
         aG2ZmhAlqQpNPwWYi/pVBl1MJvvQDlNXL8p1xeUP4ASeVRzL0+b0eilj3rdRWZAzQU
         jg+d83uVIGgC39RLHxM2tqdAfDZz45bY33UkZz1WC55Py93n5ZEGiBqRl69NWyuZiD
         vtfyLqOgIlEzQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pQBC1-0093r7-Q3;
        Thu, 09 Feb 2023 17:58:45 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 01/18] arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
Date:   Thu,  9 Feb 2023 17:58:03 +0000
Message-Id: <20230209175820.1939006-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209175820.1939006-1-maz@kernel.org>
References: <20230209175820.1939006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, catalin.marinas@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
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
index dfeb2c51e257..1af77a3657f7 100644
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

