Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E64546215B
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 21:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351709AbhK2UHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 15:07:35 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49408 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbhK2UFe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 15:05:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 430BBCE1410
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB656C53FD0;
        Mon, 29 Nov 2021 20:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216132;
        bh=Ed7J/sCVqzfVqnfSwWqX/Wg6aMUVnxL/QI6OOMqQYig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EcWzGCn0x2yR8t0aRP3ltIdtwS1Qastp0wJ3oIUUlfJLqKfcDPwU7vcEFQ+wYGrx2
         8Hj2n1hWr18/BLbX/Beo8laQNlh98CivMbqIuh9ffy6+V1a2yeWHJqWWpcaK+nN9iF
         Fo098ZDmKpaot+GXROiXWIU8ioOKn5IbREGevI+tdQ00GJIlcCpY/1/inTe2owxfjj
         aPerEt6wTZr22PvngJrKpnosLV5kgRxmg+N8RAPPkT6uryiSdk3mpVB4u3tZj+0xSm
         wrd8LdQB972LR3iegQTTrT8zPU92gubSbdMx2NEdPjXQOnKASGBE8hG4KX/BlmZxwB
         1HVIVWoW1kipw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmqp-008gvR-1Q; Mon, 29 Nov 2021 20:02:11 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v5 06/69] arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
Date:   Mon, 29 Nov 2021 20:00:47 +0000
Message-Id: <20211129200150.351436-7-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jintack Lim <jintack.lim@linaro.org>

Add a new ARM64_HAS_NESTED_VIRT feature to indicate that the
CPU has the ARMv8.3 nested virtualization capability, together
with the 'kvm-arm.mode=nested' command line option.

This will be used to support nested virtualization in KVM.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
[maz: moved the command-line option to kvm-arm.mode]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  7 +++++-
 arch/arm64/include/asm/kvm_host.h             |  5 ++++
 arch/arm64/kernel/cpufeature.c                | 24 +++++++++++++++++++
 arch/arm64/kvm/arm.c                          |  5 ++++
 arch/arm64/tools/cpucaps                      |  1 +
 5 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 9725c546a0d4..008d567b042f 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2380,9 +2380,14 @@
 				   state is kept private from the host.
 				   Not valid if the kernel is running in EL2.
 
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
index 2a5f7f38006f..20d7cb450ef3 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -58,9 +58,14 @@
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
index 6f3e677d88f1..4d57e98cdde5 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1761,6 +1761,20 @@ static void cpu_copy_el2regs(const struct arm64_cpu_capabilities *__unused)
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
 static void cpu_has_fwb(const struct arm64_cpu_capabilities *__unused)
 {
 	u64 val = read_sysreg_s(SYS_CLIDR_EL1);
@@ -1994,6 +2008,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
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
+		.field_pos = ID_AA64MMFR2_NV_SHIFT,
+		.min_field_value = 1,
+	},
 	{
 		.capability = ARM64_HAS_32BIT_EL0_DO_NOT_USE,
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2f03cbfefe67..68da54d58cd0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2174,6 +2174,11 @@ static int __init early_kvm_mode_cfg(char *arg)
 		return 0;
 	}
 
+	if (strcmp(arg, "nested") == 0 && !WARN_ON(!is_kernel_in_hyp_mode())) {
+		kvm_mode = KVM_MODE_NV;
+		return 0;
+	}
+
 	if (strcmp(arg, "none") == 0) {
 		kvm_mode = KVM_MODE_NONE;
 		return 0;
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 870c39537dd0..a49864b56a07 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -26,6 +26,7 @@ HAS_GENERIC_AUTH_IMP_DEF
 HAS_IRQ_PRIO_MASKING
 HAS_LDAPR
 HAS_LSE_ATOMICS
+HAS_NESTED_VIRT
 HAS_NO_FPSIMD
 HAS_NO_HW_PREFETCH
 HAS_PAN
-- 
2.30.2

