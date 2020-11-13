Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E152B23B8
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 19:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgKMS0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 13:26:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:59954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726544AbgKMS0V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 13:26:21 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B273B20759;
        Fri, 13 Nov 2020 18:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605291980;
        bh=gY/VRsiPzRuoQjrUpaFkSuVWs50kFr+mHGg8iLcn3xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qyKSf+moAYGtWWDjfKeEo01OP2lMgRMqd2zIk6o456bvQfCX/WSbUERqz+SMN47/D
         RlSSOh0yn1eghW3QeAKqezJufFDz3k8jBmmkRUBJHLj5hMi1Binku54KLIXI+P4mmB
         2Fp56zja5vdZ7cduoj88ICsT8ignDc3S1F//WnEM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kddm6-00APrY-Uk; Fri, 13 Nov 2020 18:26:19 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kernel-team@android.com
Subject: [PATCH 7/8] KVM: arm64: Gate kvm_pmu_update_state() on the PMU feature
Date:   Fri, 13 Nov 2020 18:26:01 +0000
Message-Id: <20201113182602.471776-8-maz@kernel.org>
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

We currently gate the update of the PMU state on the PMU being "ready".
The "ready" state is only set to true when the first vcpu run is
successful, and if it isn't, we never reach the update code.

So the "ready" state is never the right thing to check for, and it
should instead be the presence of the PMU feature, which makes
a bit more sense.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/pmu-emul.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 200f2a0d8d17..8806fdc85e8a 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -384,7 +384,7 @@ static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	bool overflow;
 
-	if (!kvm_arm_pmu_v3_ready(vcpu))
+	if (!kvm_vcpu_has_pmu(vcpu))
 		return;
 
 	overflow = !!kvm_pmu_overflow_status(vcpu);
-- 
2.28.0

