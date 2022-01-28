Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B2649F9F5
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348692AbiA1Muf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:50:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52576 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348695AbiA1Muf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:50:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1BEC61C50
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FE8C340E0;
        Fri, 28 Jan 2022 12:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643374234;
        bh=HWcQhFoIBoacHwfRc3fiKLglciHOId7M3fhyIeZUV6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qhrWypptAtI1m1XyInVd/chk4Gms/841dYf6t6GTjQoC7km39nZnLp55GKo/FVw4t
         gc6ajKfnMIz4rGkJMeU3OK4Pf/K7wPnacEpQ7ETGCPUfJObK6ZWzLnfHpu2iw8rmiy
         2V6F0fr9Gm+eyHqqdh8ztMcxAkdZNuW6uSp+Sv3BGgxP3nqcGKls8z8iNOrboQoeVV
         NJi8SyQ6J+VDyNbBwJM0yRknueUh/AxW9jfFfIzikQQ0s/BbOdfTiD0Y62oV9TXRLy
         aytzJJaiw2t+a9vD/IpBqqBx1o3SxmiKfoYe+QyvhJPLf0JtjT9D2QirUOLeeObePZ
         4zuj2IcQ6D5dQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQET-003njR-Is; Fri, 28 Jan 2022 12:20:01 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: [PATCH v6 47/64] KVM: arm64: nv: Don't load the GICv4 context on entering a nested guest
Date:   Fri, 28 Jan 2022 12:18:55 +0000
Message-Id: <20220128121912.509006-48-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220128121912.509006-1-maz@kernel.org>
References: <20220128121912.509006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When entering a nested guest (vgic_state_is_nested() == true),
special care must be taken *not* to make the vPE resident, as
these are interrupts targetting the L1 guest, and not any
nested guest.

By not making the vPE resident, we guarantee that the delivery
of an vLPI will result in a doorbell, forcing an exit from the
nested guest and a switch to the L1 guest to handle the interrupt.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 6bfca28ecced..39e5c68087ea 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -736,8 +736,8 @@ void vgic_v3_load(struct kvm_vcpu *vcpu)
 
 	if (vgic_state_is_nested(vcpu))
 		vgic_v3_load_nested(vcpu);
-
-	WARN_ON(vgic_v4_load(vcpu));
+	else
+		WARN_ON(vgic_v4_load(vcpu));
 }
 
 void vgic_v3_vmcr_sync(struct kvm_vcpu *vcpu)
@@ -755,6 +755,12 @@ void vgic_v3_put(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
 
+	/*
+	 * vgic_v4_put will do nothing if we were not resident. This
+	 * covers both the cases where we've blocked (we already have
+	 * done a vgic_v4_put) and when running a nested guest (the
+	 * vPE was never resident in order to generate a doorbell).
+	 */
 	WARN_ON(vgic_v4_put(vcpu, false));
 
 	vgic_v3_vmcr_sync(vcpu);
-- 
2.30.2

