Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44052A0BD5
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 17:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgJ3Qz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 12:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgJ3Qz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 12:55:28 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DF5E20739;
        Fri, 30 Oct 2020 16:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604076927;
        bh=JyALdb61G3Cl7X1PV46qFM5fXr9Uhdmqy9TeXDs/0OQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXZUb65DF1oHDl8vChHppLz4A7WTrot3lDC8YiZ+GsCEenGz7Nb5xPKkIBWXvR3fK
         J+anhzo+8IKNO3YxrGcEaZBz0z/mYl+DDohKIWSI6PIzk9o/8zydEh6OOi9xHJm6CC
         IzFPcXtf6J7qOMtkmtGHJ0yAQwedyIy//ABnpG/8=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kYXS3-005noK-Dz; Fri, 30 Oct 2020 16:40:31 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Brazdil <dbrazdil@google.com>, Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Quentin Perret <qperret@google.com>,
        Santosh Shukla <sashukla@nvidia.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 11/12] arm64: cpufeature: upgrade hyp caps to final
Date:   Fri, 30 Oct 2020 16:40:16 +0000
Message-Id: <20201030164017.244287-12-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201030164017.244287-1-maz@kernel.org>
References: <20201030164017.244287-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, dbrazdil@google.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, qais.yousef@arm.com, qperret@google.com, sashukla@nvidia.com, vladimir.murzin@arm.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

We finalize caps before initializing kvm hyp code, and any use of
cpus_have_const_cap() in kvm hyp code generates redundant and
potentially unsound code to read the cpu_hwcaps array.

A number of helper functions used in both hyp context and regular kernel
context use cpus_have_const_cap(), as some regular kernel code runs
before the capabilities are finalized. It's tedious and error-prone to
write separate copies of these for hyp and non-hyp code.

So that we can avoid the redundant code, let's automatically upgrade
cpus_have_const_cap() to cpus_have_final_cap() when used in hyp context.
With this change, there's never a reason to access to cpu_hwcaps array
from hyp code, and we don't need to create an NVHE alias for this.

This should have no effect on non-hyp code.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Cc: David Brazdil <dbrazdil@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20201026134931.28246-4-mark.rutland@arm.com
---
 arch/arm64/include/asm/cpufeature.h | 26 ++++++++++++++++++++++++--
 arch/arm64/include/asm/virt.h       | 12 ------------
 arch/arm64/kernel/image-vars.h      |  1 -
 3 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 9f671aa0419b..79d6a0371c78 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -375,6 +375,23 @@ cpucap_multi_entry_cap_matches(const struct arm64_cpu_capabilities *entry,
 	return false;
 }
 
+static __always_inline bool is_vhe_hyp_code(void)
+{
+	/* Only defined for code run in VHE hyp context */
+	return __is_defined(__KVM_VHE_HYPERVISOR__);
+}
+
+static __always_inline bool is_nvhe_hyp_code(void)
+{
+	/* Only defined for code run in NVHE hyp context */
+	return __is_defined(__KVM_NVHE_HYPERVISOR__);
+}
+
+static __always_inline bool is_hyp_code(void)
+{
+	return is_vhe_hyp_code() || is_nvhe_hyp_code();
+}
+
 extern DECLARE_BITMAP(cpu_hwcaps, ARM64_NCAPS);
 extern struct static_key_false cpu_hwcap_keys[ARM64_NCAPS];
 extern struct static_key_false arm64_const_caps_ready;
@@ -444,8 +461,11 @@ static __always_inline bool cpus_have_final_cap(int num)
 }
 
 /*
- * Test for a capability, possibly with a runtime check.
+ * Test for a capability, possibly with a runtime check for non-hyp code.
  *
+ * For hyp code, this behaves the same as cpus_have_final_cap().
+ *
+ * For non-hyp code:
  * Before capabilities are finalized, this behaves as cpus_have_cap().
  * After capabilities are finalized, this is patched to avoid a runtime check.
  *
@@ -453,7 +473,9 @@ static __always_inline bool cpus_have_final_cap(int num)
  */
 static __always_inline bool cpus_have_const_cap(int num)
 {
-	if (system_capabilities_finalized())
+	if (is_hyp_code())
+		return cpus_have_final_cap(num);
+	else if (system_capabilities_finalized())
 		return __cpus_have_const_cap(num);
 	else
 		return cpus_have_cap(num);
diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 300be14ba77b..6069be50baf9 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -83,18 +83,6 @@ static inline bool is_kernel_in_hyp_mode(void)
 	return read_sysreg(CurrentEL) == CurrentEL_EL2;
 }
 
-static __always_inline bool is_vhe_hyp_code(void)
-{
-	/* Only defined for code run in VHE hyp context */
-	return __is_defined(__KVM_VHE_HYPERVISOR__);
-}
-
-static __always_inline bool is_nvhe_hyp_code(void)
-{
-	/* Only defined for code run in NVHE hyp context */
-	return __is_defined(__KVM_NVHE_HYPERVISOR__);
-}
-
 static __always_inline bool has_vhe(void)
 {
 	/*
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index fbd4b6b1fde5..ad8432251733 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -87,7 +87,6 @@ KVM_NVHE_ALIAS(__icache_flags);
 /* Kernel symbols needed for cpus_have_final/const_caps checks. */
 KVM_NVHE_ALIAS(arm64_const_caps_ready);
 KVM_NVHE_ALIAS(cpu_hwcap_keys);
-KVM_NVHE_ALIAS(cpu_hwcaps);
 
 /* Static keys which are set if a vGIC trap should be handled in hyp. */
 KVM_NVHE_ALIAS(vgic_v2_cpuif_trap);
-- 
2.28.0

