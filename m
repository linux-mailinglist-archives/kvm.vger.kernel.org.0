Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB60942ED3E
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 11:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236982AbhJOJMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 05:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236886AbhJOJMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 05:12:21 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2338C611C2;
        Fri, 15 Oct 2021 09:10:15 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mbJED-00GvHX-CD; Fri, 15 Oct 2021 10:10:13 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, kernel-team@android.com
Subject: [PATCH 4/5] KVM: arm64: Restructure the point where has_run_once is advertised
Date:   Fri, 15 Oct 2021 10:08:21 +0100
Message-Id: <20211015090822.2994920-5-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211015090822.2994920-1-maz@kernel.org>
References: <20211015090822.2994920-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com, will@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restructure kvm_arch_vcpu_run_pid_change() to set the has_run_once
flag after having completed all the "run once" activities.

This includes moving the flip of the userspace irqchip static key
to a point where nothing can fail (the current code could end-up
in a bizarre state in a few error cases).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 30692497c4ea..5bcdf8073854 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -603,8 +603,6 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (likely(vcpu->arch.has_run_once))
 		return 0;
 
-	vcpu->arch.has_run_once = true;
-
 	kvm_arm_vcpu_init_debug(vcpu);
 
 	if (likely(irqchip_in_kernel(kvm))) {
@@ -615,12 +613,6 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 		ret = kvm_vgic_map_resources(kvm);
 		if (ret)
 			return ret;
-	} else {
-		/*
-		 * Tell the rest of the code that there are userspace irqchip
-		 * VMs in the wild.
-		 */
-		static_branch_inc(&userspace_irqchip_in_use);
 	}
 
 	ret = kvm_timer_enable(vcpu);
@@ -628,6 +620,18 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 		return ret;
 
 	ret = kvm_arm_pmu_v3_enable(vcpu);
+	if (ret)
+		return ret;
+
+	if (!irqchip_in_kernel(kvm)) {
+		/*
+		 * Tell the rest of the code that there are userspace irqchip
+		 * VMs in the wild.
+		 */
+		static_branch_inc(&userspace_irqchip_in_use);
+	}
+
+	vcpu->arch.has_run_once = true;
 
 	return ret;
 }
-- 
2.30.2

