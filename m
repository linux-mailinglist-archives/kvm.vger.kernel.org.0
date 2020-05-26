Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4556219964C
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 14:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbgCaMVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 08:21:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730784AbgCaMVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 08:21:11 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB36720838;
        Tue, 31 Mar 2020 12:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585657270;
        bh=wnzV/F6mCAYcCSGb/Jfjo81v1JTkv7dKNhV/AjLXAic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0Cn0VwrWJjLC93mUNa98Lc45aFiYd886oVhPfInz4MKO5b7Howj1mgZB2UIqoaNC
         aeq12ZiebJgPmmLmfelfBxlmkeNxLGNTgp2282wIhfkC/hbUbeJ2yMjs8ilxFY6Nz1
         wpiG0uNTNs1VnUnvoXUvGRdECq1AI2BWkm/PHsRU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jJFpc-00HBlI-2I; Tue, 31 Mar 2020 13:17:24 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH 15/15] KVM: arm64: GICv4.1: Expose HW-based SGIs in debugfs
Date:   Tue, 31 Mar 2020 13:16:45 +0100
Message-Id: <20200331121645.388250-16-maz@kernel.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200331121645.388250-1-maz@kernel.org>
References: <20200331121645.388250-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, arnd@arndb.de, catalin.marinas@arm.com, christoffer.dall@arm.com, eric.auger@redhat.com, karahmed@amazon.de, linus.walleij@linaro.org, olof@lixom.net, vladimir.murzin@arm.com, will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vgic-state debugfs file could do with showing the pending state
of the HW-backed SGIs. Plug it into the low-level code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20200304203330.4967-24-maz@kernel.org
---
 virt/kvm/arm/vgic/vgic-debug.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-debug.c b/virt/kvm/arm/vgic/vgic-debug.c
index cc12fe9b2df3..b13a9e3f99dd 100644
--- a/virt/kvm/arm/vgic/vgic-debug.c
+++ b/virt/kvm/arm/vgic/vgic-debug.c
@@ -178,6 +178,8 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
 			    struct kvm_vcpu *vcpu)
 {
 	char *type;
+	bool pending;
+
 	if (irq->intid < VGIC_NR_SGIS)
 		type = "SGI";
 	else if (irq->intid < VGIC_NR_PRIVATE_IRQS)
@@ -190,6 +192,16 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
 	if (irq->intid ==0 || irq->intid == VGIC_NR_PRIVATE_IRQS)
 		print_header(s, irq, vcpu);
 
+	pending = irq->pending_latch;
+	if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
+		int err;
+
+		err = irq_get_irqchip_state(irq->host_irq,
+					    IRQCHIP_STATE_PENDING,
+					    &pending);
+		WARN_ON_ONCE(err);
+	}
+
 	seq_printf(s, "       %s %4d "
 		      "    %2d "
 		      "%d%d%d%d%d%d%d "
@@ -201,7 +213,7 @@ static void print_irq_state(struct seq_file *s, struct vgic_irq *irq,
 		      "\n",
 			type, irq->intid,
 			(irq->target_vcpu) ? irq->target_vcpu->vcpu_id : -1,
-			irq->pending_latch,
+			pending,
 			irq->line_level,
 			irq->active,
 			irq->enabled,
-- 
2.25.0

