Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671604328D9
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 23:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbhJRVOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 17:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231998AbhJRVOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 17:14:23 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 116806113E;
        Mon, 18 Oct 2021 21:12:12 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mcZvW-0004Sc-9u; Mon, 18 Oct 2021 22:12:10 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>, kernel-team@android.com
Subject: [PATCH v2 3/5] KVM: arm64: Restructure the point where has_run_once is advertised
Date:   Mon, 18 Oct 2021 22:11:56 +0100
Message-Id: <20211018211158.3050779-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211018211158.3050779-1-maz@kernel.org>
References: <20211018211158.3050779-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com, will@kernel.org, drjones@redhat.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restructure kvm_vcpu_first_run_init() to set the has_run_once
flag after having completed all the "run once" activities.

This includes moving the flip of the userspace irqchip static key
to a point where nothing can fail.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ccb59ac54976..42efca9853fb 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -599,8 +599,6 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	if (!kvm_arm_vcpu_is_finalized(vcpu))
 		return -EPERM;
 
-	vcpu->arch.has_run_once = true;
-
 	kvm_arm_vcpu_init_debug(vcpu);
 
 	if (likely(irqchip_in_kernel(kvm))) {
@@ -611,12 +609,6 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
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
@@ -624,6 +616,18 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
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

