Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1C333D1BF
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 11:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236666AbhCPKYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 06:24:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236663AbhCPKXi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 06:23:38 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D41B64FC7;
        Tue, 16 Mar 2021 10:23:38 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lM6hj-001uep-Kt; Tue, 16 Mar 2021 10:13:35 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     dave.martin@arm.com, daniel.kiss@arm.com,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        broonie@kernel.org, kernel-team@android.com
Subject: [PATCH 10/10] KVM: arm64: Enable SVE support for nVHE
Date:   Tue, 16 Mar 2021 10:13:12 +0000
Message-Id: <20210316101312.102925-11-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210316101312.102925-1-maz@kernel.org>
References: <20210316101312.102925-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com, will@kernel.org, catalin.marinas@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, broonie@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Daniel Kiss <daniel.kiss@arm.com>

Now that KVM is equipped to deal with SVE on nVHE, remove the code
preventing it from being used as well as the bits of documentation
that were mentioning the incompatibility.

Signed-off-by: Daniel Kiss <daniel.kiss@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/Kconfig                |  7 -------
 arch/arm64/include/asm/kvm_host.h | 13 -------------
 arch/arm64/kvm/arm.c              |  5 -----
 arch/arm64/kvm/reset.c            |  4 ----
 4 files changed, 29 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1f212b47a48a..2690543799fb 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1686,7 +1686,6 @@ endmenu
 config ARM64_SVE
 	bool "ARM Scalable Vector Extension support"
 	default y
-	depends on !KVM || ARM64_VHE
 	help
 	  The Scalable Vector Extension (SVE) is an extension to the AArch64
 	  execution state which complements and extends the SIMD functionality
@@ -1715,12 +1714,6 @@ config ARM64_SVE
 	  booting the kernel.  If unsure and you are not observing these
 	  symptoms, you should assume that it is safe to say Y.
 
-	  CPUs that support SVE are architecturally required to support the
-	  Virtualization Host Extensions (VHE), so the kernel makes no
-	  provision for supporting SVE alongside KVM without VHE enabled.
-	  Thus, you will need to enable CONFIG_ARM64_VHE if you want to support
-	  KVM in the same kernel image.
-
 config ARM64_MODULE_PLTS
 	bool "Use PLTs to allow module memory to spill over into vmalloc area"
 	depends on MODULES
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9108ccc80653..62a5f14dde36 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -696,19 +696,6 @@ static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
 	ctxt_sys_reg(cpu_ctxt, MPIDR_EL1) = read_cpuid_mpidr();
 }
 
-static inline bool kvm_arch_requires_vhe(void)
-{
-	/*
-	 * The Arm architecture specifies that implementation of SVE
-	 * requires VHE also to be implemented.  The KVM code for arm64
-	 * relies on this when SVE is present:
-	 */
-	if (system_supports_sve())
-		return true;
-
-	return false;
-}
-
 void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
 
 static inline void kvm_arch_hardware_unsetup(void) {}
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fc4c95dd2d26..ef92b7d32ebd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1889,11 +1889,6 @@ int kvm_arch_init(void *opaque)
 
 	in_hyp_mode = is_kernel_in_hyp_mode();
 
-	if (!in_hyp_mode && kvm_arch_requires_vhe()) {
-		kvm_pr_unimpl("CPU unsupported in non-VHE mode, not initializing\n");
-		return -ENODEV;
-	}
-
 	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
 	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
 		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 47f3f035f3ea..f08b1e7ebf68 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -74,10 +74,6 @@ static int kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
 	if (!system_supports_sve())
 		return -EINVAL;
 
-	/* Verify that KVM startup enforced this when SVE was detected: */
-	if (WARN_ON(!has_vhe()))
-		return -EINVAL;
-
 	vcpu->arch.sve_max_vl = kvm_sve_max_vl;
 
 	/*
-- 
2.29.2

