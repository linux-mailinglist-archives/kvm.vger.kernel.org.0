Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6CCB19962C
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 14:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730797AbgCaMRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 08:17:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730780AbgCaMRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 08:17:20 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99D2D21473;
        Tue, 31 Mar 2020 12:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585657039;
        bh=pF5jIxK97ltdsCKXvkyp8u1t0qhyes9Mxr4id4nqWic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sC7NV47OGjr9KdjEnicTNouF55gGuNcFUtaG23ZR3MEcZ0cPVKrGmlo0ljSY8oArx
         i2UTyEPBf7BIbZH+omivfofAgGwxqBcNPrrdaeE/pHgROC4pdbKo7GIB7c0uB+MMrA
         vtZV9fj5OE/KeM5H9jl1MleuLQ7EPu13MtF79J6w=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jJFpV-00HBlI-Gt; Tue, 31 Mar 2020 13:17:17 +0100
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
Subject: [PATCH 09/15] KVM: arm64: GICv4.1: Let doorbells be auto-enabled
Date:   Tue, 31 Mar 2020 13:16:39 +0100
Message-Id: <20200331121645.388250-10-maz@kernel.org>
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

As GICv4.1 understands the life cycle of doorbells (instead of
just randomly firing them at the most inconvenient time), just
enable them at irq_request time, and be done with it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Link: https://lore.kernel.org/r/20200304203330.4967-18-maz@kernel.org
---
 virt/kvm/arm/vgic/vgic-v4.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index 1eb0f8c76219..c2fcde104ea2 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -141,6 +141,7 @@ int vgic_v4_init(struct kvm *kvm)
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		int irq = dist->its_vm.vpes[i]->irq;
+		unsigned long irq_flags = DB_IRQ_FLAGS;
 
 		/*
 		 * Don't automatically enable the doorbell, as we're
@@ -148,8 +149,14 @@ int vgic_v4_init(struct kvm *kvm)
 		 * blocked. Also disable the lazy disabling, as the
 		 * doorbell could kick us out of the guest too
 		 * early...
+		 *
+		 * On GICv4.1, the doorbell is managed in HW and must
+		 * be left enabled.
 		 */
-		irq_set_status_flags(irq, DB_IRQ_FLAGS);
+		if (kvm_vgic_global_state.has_gicv4_1)
+			irq_flags &= ~IRQ_NOAUTOEN;
+		irq_set_status_flags(irq, irq_flags);
+
 		ret = request_irq(irq, vgic_v4_doorbell_handler,
 				  0, "vcpu", vcpu);
 		if (ret) {
-- 
2.25.0

