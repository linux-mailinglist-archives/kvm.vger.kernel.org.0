Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEA32B23AC
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 19:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgKMS0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 13:26:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:59728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbgKMS0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 13:26:18 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFB9D206F9;
        Fri, 13 Nov 2020 18:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605291977;
        bh=9em7zCAFy/zAPxoJ9DJ79psVVW688qygNNSSZqu5SPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x9i4kYUkJo2L9Aa+G1xFE/2x1IQcKTmHpOuzrQv1JHLPjXoOs3zl3tQkz/gvpsg4K
         DdTYOK4aFva0nA/L9jHOoEEBrBJCuJCt++FxmAVs2ftQOp+pUSvP8bzcArq4qPok8J
         ++4KLthb3M7HggB25v7ygKXaWm9KTuuCeFp8CFNg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kddm3-00APrY-Vo; Fri, 13 Nov 2020 18:26:16 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
Subject: [PATCH 1/8] KVM: arm64: Add kvm_vcpu_has_pmu() helper
Date:   Fri, 13 Nov 2020 18:25:55 +0000
Message-Id: <20201113182602.471776-2-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113182602.471776-1-maz@kernel.org>
References: <20201113182602.471776-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, eric.auger@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are a number of places where we check for the KVM_ARM_VCPU_PMU_V3
feature. Wrap this check into a new kvm_vcpu_has_pmu(), and use
it at the existing locations.

No functional change.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 3 +++
 arch/arm64/kvm/pmu-emul.c         | 8 +++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 709f892f7a14..8c681d621a82 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -731,4 +731,7 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 #define kvm_arm_vcpu_sve_finalized(vcpu) \
 	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
 
+#define kvm_vcpu_has_pmu(vcpu)					\
+	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 2ed5ef8f274b..e7e3b4629864 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -913,8 +913,7 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 
 int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
-	if (!kvm_arm_support_pmu_v3() ||
-	    !test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
+	if (!kvm_arm_support_pmu_v3() || !kvm_vcpu_has_pmu(vcpu))
 		return -ENODEV;
 
 	if (vcpu->arch.pmu.created)
@@ -1015,7 +1014,7 @@ int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		if (!irqchip_in_kernel(vcpu->kvm))
 			return -EINVAL;
 
-		if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
+		if (!kvm_vcpu_has_pmu(vcpu))
 			return -ENODEV;
 
 		if (!kvm_arm_pmu_irq_initialized(vcpu))
@@ -1035,8 +1034,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	case KVM_ARM_VCPU_PMU_V3_IRQ:
 	case KVM_ARM_VCPU_PMU_V3_INIT:
 	case KVM_ARM_VCPU_PMU_V3_FILTER:
-		if (kvm_arm_support_pmu_v3() &&
-		    test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
+		if (kvm_arm_support_pmu_v3() && kvm_vcpu_has_pmu(vcpu))
 			return 0;
 	}
 
-- 
2.28.0

