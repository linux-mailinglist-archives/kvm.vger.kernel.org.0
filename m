Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFF9F179A31
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 21:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388603AbgCDUg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 15:36:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:37258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388554AbgCDUgz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 15:36:55 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D3502146E;
        Wed,  4 Mar 2020 20:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583354214;
        bh=nT8qpDoXiO2V4s77MJN3BMvs3CrPkyEcY5K0iiRMty0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iHpNeEznFkQBorN6FyeIUYuT3JEc6KZPoJi7d9d9wajThqBVzPdUtsHFvuPbTE7Qd
         BRsAHqOFJFEwU3wpZZ2pG6EAbsDVn3uFCyUSY05BaDzAR6CRBMx7HEzGNqcp6s07mm
         RgD8FYdKc4R4awffxIc7vb8L0+Qe/xX0R52+M6No=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j9ajH-00A59R-5S; Wed, 04 Mar 2020 20:34:55 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v5 21/23] KVM: arm64: GICv4.1: Reload VLPI configuration on distributor enable/disable
Date:   Wed,  4 Mar 2020 20:33:28 +0000
Message-Id: <20200304203330.4967-22-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200304203330.4967-1-maz@kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, rrichter@marvell.com, tglx@linutronix.de, yuzenghui@huawei.com, eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Each time a Group-enable bit gets flipped, the state of these bits
needs to be forwarded to the hardware. This is a pretty heavy
handed operation, requiring all vcpus to reload their GICv4
configuration. It is thus implemented as a new request type.

Of course, we only support Group-1 for now...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm/include/asm/kvm_host.h   | 1 +
 arch/arm64/include/asm/kvm_host.h | 1 +
 virt/kvm/arm/arm.c                | 8 ++++++++
 virt/kvm/arm/vgic/vgic-mmio-v3.c  | 5 ++++-
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index a827b4d60d38..3da57e863df6 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -39,6 +39,7 @@
 #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
 #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
 #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
+#define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 57fd46acd058..32c8a675e5a4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -44,6 +44,7 @@
 #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
 #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
 #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
+#define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index eda7b624eab8..4d864f857ac8 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -625,6 +625,14 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_RECORD_STEAL, vcpu))
 			kvm_update_stolen_time(vcpu);
+
+		if (kvm_check_request(KVM_REQ_RELOAD_GICv4, vcpu)) {
+			/* The distributor enable bits were changed */
+			preempt_disable();
+			vgic_v4_put(vcpu, false);
+			vgic_v4_load(vcpu);
+			preempt_enable();
+		}
 	}
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 442f3b8c2559..48fd9fc229a2 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -132,7 +132,10 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 		if (is_hwsgi != dist->nassgireq)
 			vgic_v4_configure_vsgis(vcpu->kvm);
 
-		if (!was_enabled && dist->enabled)
+		if (kvm_vgic_global_state.has_gicv4_1 &&
+		    was_enabled != dist->enabled)
+			kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_RELOAD_GICv4);
+		else if (!was_enabled && dist->enabled)
 			vgic_kick_vcpus(vcpu->kvm);
 
 		mutex_unlock(&vcpu->kvm->lock);
-- 
2.20.1

