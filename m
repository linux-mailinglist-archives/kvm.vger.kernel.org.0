Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3116825C550
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 17:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgICP0i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 11:26:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728497AbgICP03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 11:26:29 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C39A1208C7;
        Thu,  3 Sep 2020 15:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599146786;
        bh=wXj+MzUSlzqCPZ4DfFe3HKrFKIE2+Uir+iEwtYqABWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PppcZONE5Vx7PAKAOs9M++PS6byf3UAu4kuczVkm12sfMttWmEF+WwI3AURD2PDw3
         Vh1Pt1Znsfd/EAoq4n48JW9t5fdLqlHN6gDgbwZ/0Pi8cnrbcYEIkj8GzrdfDDnriD
         fdKznP5LBg07MzxTX5aqX7jAuNgOP0AKnVLj1KIg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kDr85-008vT9-67; Thu, 03 Sep 2020 16:26:25 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     kernel-team@android.com,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 07/23] KVM: arm64: Add irqchip callback structure to kvm_arch
Date:   Thu,  3 Sep 2020 16:25:54 +0100
Message-Id: <20200903152610.1078827-8-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200903152610.1078827-1-maz@kernel.org>
References: <20200903152610.1078827-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kernel-team@android.com, Christoffer.Dall@arm.com, lorenzo.pieralisi@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we are about to abstract part of the vgic implementation in
order to make it more modular, let's start by adding a data
structure that will eventually contain interrupt controller
specific callbacks, as well as helpers to call them (or
gracefully skip them if they aren't implemented.

It is empty so far, so no functional changes are anticipated.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/include/asm/kvm_irq.h  | 29 +++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-init.c   |  5 +++++
 3 files changed, 35 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f0e30e12b523..52b502f3076f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -100,6 +100,7 @@ struct kvm_arch {
 
 	/* Interrupt controller */
 	enum kvm_irqchip_type	irqchip_type;
+	struct kvm_irqchip_flow	irqchip_flow;
 	struct vgic_dist	vgic;
 
 	/* Mandated version of PSCI */
diff --git a/arch/arm64/include/asm/kvm_irq.h b/arch/arm64/include/asm/kvm_irq.h
index 46bffb6026f8..7a70bb803560 100644
--- a/arch/arm64/include/asm/kvm_irq.h
+++ b/arch/arm64/include/asm/kvm_irq.h
@@ -17,4 +17,33 @@ enum kvm_irqchip_type {
 #define irqchip_is_gic_v2(k)	((k)->arch.irqchip_type == IRQCHIP_GICv2)
 #define irqchip_is_gic_v3(k)	((k)->arch.irqchip_type == IRQCHIP_GICv3)
 
+struct kvm_irqchip_flow {
+};
+
+/*
+ * Macro galore. At the point this is included, the various types are
+ * not defined yet. Yes, this is terminally ugly.
+ */
+#define __kvm_irqchip_action(k, x, ...)					\
+	do {								\
+		if (likely((k)->arch.irqchip_flow.irqchip_##x))		\
+			(k)->arch.irqchip_flow.irqchip_##x(__VA_ARGS__); \
+	} while (0)
+
+#define __kvm_irqchip_action_ret(k, x, ...)				\
+	({								\
+		typeof ((k)->arch.irqchip_flow.irqchip_##x(__VA_ARGS__)) ret; \
+		ret = (likely((k)->arch.irqchip_flow.irqchip_##x) ?	\
+		       (k)->arch.irqchip_flow.irqchip_##x(__VA_ARGS__) : \
+		       0);						\
+									\
+		ret;							\
+	 })
+
+#define __vcpu_irqchip_action(v, ...)			\
+	__kvm_irqchip_action((v)->kvm, __VA_ARGS__)
+
+#define __vcpu_irqchip_action_ret(v, ...)		\
+	__kvm_irqchip_action_ret((v)->kvm, __VA_ARGS__)
+
 #endif
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 76cce0db63a7..6b8f0518c074 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -12,6 +12,9 @@
 #include <asm/kvm_mmu.h>
 #include "vgic.h"
 
+static struct kvm_irqchip_flow vgic_irqchip_flow = {
+};
+
 /*
  * Initialization rules: there are multiple stages to the vgic
  * initialization, both for the distributor and the CPU interfaces.  The basic
@@ -98,6 +101,8 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	else
 		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 
+	kvm->arch.irqchip_flow = vgic_irqchip_flow;
+
 	INIT_LIST_HEAD(&dist->lpi_list_head);
 	INIT_LIST_HEAD(&dist->lpi_translation_cache);
 	raw_spin_lock_init(&dist->lpi_list_lock);
-- 
2.27.0

