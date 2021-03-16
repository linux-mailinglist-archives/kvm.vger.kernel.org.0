Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B9933DB51
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 18:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239324AbhCPRrG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 13:47:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239225AbhCPRqm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 13:46:42 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 545396512A;
        Tue, 16 Mar 2021 17:46:42 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lMDmC-0021ao-EX; Tue, 16 Mar 2021 17:46:40 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Mark Rutland <mark.rutland@arm.com>, kernel-team@android.com
Subject: [PATCH 03/11] KVM: arm64: vgic: Be tolerant to the lack of maintenance interrupt
Date:   Tue, 16 Mar 2021 17:46:08 +0000
Message-Id: <20210316174617.173033-4-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210316174617.173033-1-maz@kernel.org>
References: <20210316174617.173033-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, eric.auger@redhat.com, marcan@marcan.st, mark.rutland@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As it turns out, not all the interrupt controllers are able to
expose a vGIC maintenance interrupt as a distrete signal.
And to be fair, it doesn't really matter as all we require is
for *something* to kick us out of guest mode out way or another.

On systems that do not expose a maintenance interrupt as such,
there are two outcomes:

- either the virtual CPUIF does generate an interrupt, and
  by the time we are back to the host the interrupt will have long
  been disabled (as we set ICH_HCR_EL2.EN to 0 on exit). In this case,
  interrupt latency is as good as it gets.

- or some other event (physical timer) will take us out of the guest
  anyway, and the only drawback is a bad interrupt latency.

So let's be tolerant to the lack of maintenance interrupt, and just let
the user know that their mileage may vary...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-init.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 9b491263f5f7..00c75495fd0c 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -521,11 +521,6 @@ int kvm_vgic_hyp_init(void)
 	if (!gic_kvm_info)
 		return -ENODEV;
 
-	if (!gic_kvm_info->maint_irq) {
-		kvm_err("No vgic maintenance irq\n");
-		return -ENXIO;
-	}
-
 	switch (gic_kvm_info->type) {
 	case GIC_V2:
 		ret = vgic_v2_probe(gic_kvm_info);
@@ -549,6 +544,11 @@ int kvm_vgic_hyp_init(void)
 	if (ret)
 		return ret;
 
+	if (!kvm_vgic_global_state.maint_irq) {
+		kvm_err("No maintenance interrupt available, fingers crossed...\n");
+		return 0;
+	}
+
 	ret = request_percpu_irq(kvm_vgic_global_state.maint_irq,
 				 vgic_maintenance_handler,
 				 "vgic", kvm_get_running_vcpus());
-- 
2.29.2

