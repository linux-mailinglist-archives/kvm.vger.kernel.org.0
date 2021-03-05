Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDEB32F344
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 19:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhCESx2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 13:53:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:58316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229646AbhCESxE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 13:53:04 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19794650A6;
        Fri,  5 Mar 2021 18:53:04 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lIFZO-00HYFA-D6; Fri, 05 Mar 2021 18:53:02 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Howard Zhang <Howard.Zhang@arm.com>,
        Jia He <justin.he@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Quentin Perret <qperret@google.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: [PATCH 5/8] KVM: arm64: Don't access PMSELR_EL0/PMUSERENR_EL0 when no PMU is available
Date:   Fri,  5 Mar 2021 18:52:51 +0000
Message-Id: <20210305185254.3730990-6-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210305185254.3730990-1-maz@kernel.org>
References: <87eegtzbch.wl-maz@kernel.org>
 <20210305185254.3730990-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, andre.przywara@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, Howard.Zhang@arm.com, justin.he@arm.com, mark.rutland@arm.com, qperret@google.com, shameerali.kolothum.thodi@huawei.com, suzuki.poulose@arm.com, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, kernel-team@android.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running under a nesting hypervisor, it isn't guaranteed that
the virtual HW will include a PMU. In which case, let's not try
to access the PMU registers in the world switch, as that'd be
deadly.

Reported-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Link: https://lore.kernel.org/r/20210209114844.3278746-3-maz@kernel.org
---
 arch/arm64/kernel/image-vars.h          | 3 +++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 9 ++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 23f1a557bd9f..5aa9ed1e9ec6 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -101,6 +101,9 @@ KVM_NVHE_ALIAS(__stop___kvm_ex_table);
 /* Array containing bases of nVHE per-CPU memory regions. */
 KVM_NVHE_ALIAS(kvm_arm_hyp_percpu_base);
 
+/* PMU available static key */
+KVM_NVHE_ALIAS(kvm_arm_pmu_available);
+
 #endif /* CONFIG_KVM */
 
 #endif /* __ARM64_KERNEL_IMAGE_VARS_H */
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 54f4860cd87c..6c1f51f25eb3 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -90,15 +90,18 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	 * counter, which could make a PMXEVCNTR_EL0 access UNDEF at
 	 * EL1 instead of being trapped to EL2.
 	 */
-	write_sysreg(0, pmselr_el0);
-	write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
+	if (kvm_arm_support_pmu_v3()) {
+		write_sysreg(0, pmselr_el0);
+		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
+	}
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 }
 
 static inline void __deactivate_traps_common(void)
 {
 	write_sysreg(0, hstr_el2);
-	write_sysreg(0, pmuserenr_el0);
+	if (kvm_arm_support_pmu_v3())
+		write_sysreg(0, pmuserenr_el0);
 }
 
 static inline void ___activate_traps(struct kvm_vcpu *vcpu)
-- 
2.29.2

