Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAC5260CC6
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 09:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbgIHH7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 03:59:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729789AbgIHH6r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Sep 2020 03:58:47 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9D2621D20;
        Tue,  8 Sep 2020 07:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599551926;
        bh=GKYC3lnr2B5+Pi4HQdR597nzMM3piNOBy6vkNYjbNZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/wbdKwWHILxtSRcdpsLzQbagirznr6+MU/yeYC9mWUovnKXXBpcT/np2wX5uEb6p
         C9JW0dDQsOUW9ca0Yay/22VuXhjX1jhx1V77+HCy1eHaDTIERnaXTkSr+MeOBmU4kM
         qyj4u8jvAM0d/92Ywa/CEqusZ9Mw1AojqFsli8sU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kFYWb-009zhy-6b; Tue, 08 Sep 2020 08:58:45 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Eric Auger <eric.auger@redhat.com>, graf@amazon.com,
        kernel-team@android.com
Subject: [PATCH v3 1/5] KVM: arm64: Refactor PMU attribute error handling
Date:   Tue,  8 Sep 2020 08:58:26 +0100
Message-Id: <20200908075830.1161921-2-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908075830.1161921-1-maz@kernel.org>
References: <20200908075830.1161921-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, robin.murphy@arm.com, mark.rutland@arm.com, eric.auger@redhat.com, graf@amazon.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PMU emulation error handling is pretty messy when dealing with
attributes. Let's refactor it so that we have less duplication,
and that it is easy to extend later on.

A functional change is that kvm_arm_pmu_v3_init() used to return
-ENXIO when the PMU feature wasn't set. The error is now reported
as -ENODEV, matching the documentation. -ENXIO is still returned
when the interrupt isn't properly configured.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index f0d0312c0a55..93d797df42c6 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -735,15 +735,6 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 
 static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 {
-	if (!kvm_arm_support_pmu_v3())
-		return -ENODEV;
-
-	if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
-		return -ENXIO;
-
-	if (vcpu->arch.pmu.created)
-		return -EBUSY;
-
 	if (irqchip_in_kernel(vcpu->kvm)) {
 		int ret;
 
@@ -796,6 +787,15 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 
 int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
+	if (!kvm_arm_support_pmu_v3())
+		return -ENODEV;
+
+	if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
+		return -ENODEV;
+
+	if (vcpu->arch.pmu.created)
+		return -EBUSY;
+
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_PMU_V3_IRQ: {
 		int __user *uaddr = (int __user *)(long)attr->addr;
@@ -804,9 +804,6 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		if (!irqchip_in_kernel(vcpu->kvm))
 			return -EINVAL;
 
-		if (!test_bit(KVM_ARM_VCPU_PMU_V3, vcpu->arch.features))
-			return -ENODEV;
-
 		if (get_user(irq, uaddr))
 			return -EFAULT;
 
-- 
2.28.0

