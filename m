Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECB115DAAD
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 16:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387628AbgBNPVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 10:21:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387616AbgBNPVT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 10:21:19 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A949C2465D;
        Fri, 14 Feb 2020 15:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581693678;
        bh=wS1K8188VxBjcTndjH/k8atrTcAkoLq+yq/N9rfV7ZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R5RLAbi7PAzgNDqij0/ISqfH0lTk7Zmn4WcajWT0bFnFpD1HYbrSIUjlExbonGxe0
         /w85aOWDVaIxGrgp0otmdXMQh/rYPVZFO4rsBfI8hUO3BE2M1APtdDy0UhjM90uHMq
         bYW8bGWMC4miv1g485cmGuO4DnWf29iXfs5+JfPk=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j2cPo-0057sw-UD; Fri, 14 Feb 2020 14:58:01 +0000
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
Subject: [PATCH v4 18/20] KVM: arm64: GICv4.1: Reload VLPI configuration on distributor enable/disable
Date:   Fri, 14 Feb 2020 14:57:34 +0000
Message-Id: <20200214145736.18550-19-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214145736.18550-1-maz@kernel.org>
References: <20200214145736.18550-1-maz@kernel.org>
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
index c3314b286a61..7104babef15a 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -39,6 +39,7 @@
 #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
 #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
 #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
+#define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d87aa609d2b6..90b86f349ceb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -44,6 +44,7 @@
 #define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
 #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
 #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
+#define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index d65a0faa46d8..d21e17b7af45 100644
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

