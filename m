Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E549E23CF08
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgHETMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728918AbgHES1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:27:21 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D72F22D04;
        Wed,  5 Aug 2020 18:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596651967;
        bh=B/jPCLQ/xBA20yQ0kQHCyvDom/Z2WtI15fihJ9w0l20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nS9sEKoycrPqJyLTvjfjAHO2VpVE03KGBalunyjpUIG1BMGYwNIOMb/SbOoN1iSn6
         jn7tEE52oQWe6shKPN9lsTd7O1NQsPFARYBBDKcnAM0vV8bwa8MSv32gRYtuK8VHPo
         j0vpTWm8yTCG9Np5oVUVjrOtqs2LCEXMeIfn6xu0=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3Nfz-0004w9-Ay; Wed, 05 Aug 2020 18:58:07 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 50/56] KVM: arm64: Substitute RANDOMIZE_BASE for HARDEN_EL2_VECTORS
Date:   Wed,  5 Aug 2020 18:56:54 +0100
Message-Id: <20200805175700.62775-51-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com, alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, richard.peng@oppo.com, qperret@google.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Brazdil <dbrazdil@google.com>

The HARDEN_EL2_VECTORS config maps vectors at a fixed location on cores which
are susceptible to Spector variant 3a (A57, A72) to prevent defeating hyp
layout randomization by leaking the value of VBAR_EL2.

Since this feature is only applicable when EL2 layout randomization is enabled,
unify both behind the same RANDOMIZE_BASE Kconfig. Majority of code remains
conditional on a capability selected for the affected cores.

Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20200721094445.82184-3-dbrazdil@google.com
---
 arch/arm64/Kconfig             | 16 ----------------
 arch/arm64/include/asm/mmu.h   |  6 ++----
 arch/arm64/kernel/cpu_errata.c |  4 ++--
 arch/arm64/kvm/Kconfig         |  2 +-
 4 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 31380da53689..152deef3277e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1182,22 +1182,6 @@ config HARDEN_BRANCH_PREDICTOR
 
 	  If unsure, say Y.
 
-config HARDEN_EL2_VECTORS
-	bool "Harden EL2 vector mapping against system register leak" if EXPERT
-	default y
-	help
-	  Speculation attacks against some high-performance processors can
-	  be used to leak privileged information such as the vector base
-	  register, resulting in a potential defeat of the EL2 layout
-	  randomization.
-
-	  This config option will map the vectors to a fixed location,
-	  independent of the EL2 code mapping, so that revealing VBAR_EL2
-	  to an attacker does not give away any extra information. This
-	  only gets enabled on affected CPUs.
-
-	  If unsure, say Y.
-
 config ARM64_SSBD
 	bool "Speculative Store Bypass Disable" if EXPERT
 	default y
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 68140fdd89d6..bd12011eb560 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -42,12 +42,10 @@ struct bp_hardening_data {
 	bp_hardening_cb_t	fn;
 };
 
-#if (defined(CONFIG_HARDEN_BRANCH_PREDICTOR) ||	\
-     defined(CONFIG_HARDEN_EL2_VECTORS))
-
+#ifdef CONFIG_KVM_INDIRECT_VECTORS
 extern char __bp_harden_hyp_vecs[];
 extern atomic_t arm64_el2_vector_last_slot;
-#endif  /* CONFIG_HARDEN_BRANCH_PREDICTOR || CONFIG_HARDEN_EL2_VECTORS */
+#endif
 
 #ifdef CONFIG_HARDEN_BRANCH_PREDICTOR
 DECLARE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index ad06d6802d2e..a524142e55d0 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -635,7 +635,7 @@ has_neoverse_n1_erratum_1542419(const struct arm64_cpu_capabilities *entry,
 	return is_midr_in_range(midr, &range) && has_dic;
 }
 
-#if defined(CONFIG_HARDEN_EL2_VECTORS)
+#ifdef CONFIG_RANDOMIZE_BASE
 
 static const struct midr_range ca57_a72[] = {
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A57),
@@ -880,7 +880,7 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = check_branch_predictor,
 	},
-#ifdef CONFIG_HARDEN_EL2_VECTORS
+#ifdef CONFIG_RANDOMIZE_BASE
 	{
 		.desc = "EL2 vector hardening",
 		.capability = ARM64_HARDEN_EL2_VECTORS,
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 13489aff4440..318c8f2df245 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -58,7 +58,7 @@ config KVM_ARM_PMU
 	  virtual machines.
 
 config KVM_INDIRECT_VECTORS
-	def_bool HARDEN_BRANCH_PREDICTOR || HARDEN_EL2_VECTORS
+	def_bool HARDEN_BRANCH_PREDICTOR || RANDOMIZE_BASE
 
 endif # KVM
 
-- 
2.27.0

