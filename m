Return-Path: <kvm+bounces-35243-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ADDBA0AB26
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 18:10:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1422F3A7034
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 17:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 166221C460A;
	Sun, 12 Jan 2025 17:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K1zqq1Qc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C0F1BEF90;
	Sun, 12 Jan 2025 17:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736701733; cv=none; b=XlLNDQT7QxILGIdCnPJAAcALhgOXVgSCYSmwiXGrgCZxAjlQc8ESKqtbzSD1cSTXXpe7NqzNvQ0VHYsD7XZxymx4UzMuQSP2xvet4QYgJKmryvxBntMx7aSnMRQTTUMgFj2nuAB/btQHuPHAGb/I9K6cZM9PJMGG9C/ySSfv87I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736701733; c=relaxed/simple;
	bh=EOwDeEEdCnSnldPYlWdcwYEt+LLvBfkCBZw1/S5dYx4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LdKYsdv9TucEBKvz+woJFAseDDc8aVvIa5E0LsfF7BcJEOfzekTEsJ/xwRSKhUfG21SyoyCUOqz+1QsfAwRXQUG8l0DoxDN4hcd6Xffpl3nT1CL7pRwXubfnsQ07CWVDmuPDq0VE2plHYsXPdKB5DTxuiFMWPx/VItcnChWpAaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K1zqq1Qc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F64C4CEEC;
	Sun, 12 Jan 2025 17:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736701732;
	bh=EOwDeEEdCnSnldPYlWdcwYEt+LLvBfkCBZw1/S5dYx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K1zqq1Qc8+09kK6+nDip+9Og7/hLyhqr25S/ROixWGaHHt58nSWuhv83Z/CcLLtZN
	 sqmrmq8RaysnUezUq43WZcGDnQrBOwMk5d5nxrgy24LFyv1ox51cWOLLFm0Oz8pBmb
	 fXiAlaSSMwJjOPwy3m5ZixHIHuAMwtjcQJMZrT6OFiYORHrMXh/YAQyMNpIk12VRUb
	 96StjW3p+pJnYWzBh5LnxFzdcoFgqCtNiygChwbgtZuduTcS3/5iF1CzwI3KjL4EhW
	 kLsOwAGLYvCoopu0+aCq50Lw9cJoT1AUHKsnoRq3v7Red6dscy7sGtKYtpVK8gzCP+
	 hyH1SMv5cZzbQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tX1SE-00BNxR-VV;
	Sun, 12 Jan 2025 17:08:51 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 10/17] KVM: arm64: nv: Handle L2->L1 transition on interrupt injection
Date: Sun, 12 Jan 2025 17:08:38 +0000
Message-Id: <20250112170845.1181891-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250112170845.1181891-1-maz@kernel.org>
References: <20250112170845.1181891-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andre.przywara@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

An interrupt being delivered to L1 while running L2 must result
in the correct exception being delivered to L1.

This means that if, on entry to L2, we found ourselves with pending
interrupts in the L1 distributor, we need to take immediate action.
This is done by posting a request which will prevent the entry in
L2, and deliver an IRQ exception to L1, forcing the switch.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 17 +++++++++--------
 arch/arm64/kvm/arm.c              |  5 +++++
 arch/arm64/kvm/nested.c           |  3 +++
 arch/arm64/kvm/vgic/vgic.c        | 23 +++++++++++++++++++++++
 4 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 218047cd0296d..cb969c096d7bd 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -44,14 +44,15 @@
 
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
-#define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
-#define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
-#define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
-#define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
-#define KVM_REQ_SUSPEND		KVM_ARCH_REQ(6)
-#define KVM_REQ_RESYNC_PMU_EL0	KVM_ARCH_REQ(7)
-#define KVM_REQ_NESTED_S2_UNMAP	KVM_ARCH_REQ(8)
+#define KVM_REQ_IRQ_PENDING		KVM_ARCH_REQ(1)
+#define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(2)
+#define KVM_REQ_RECORD_STEAL		KVM_ARCH_REQ(3)
+#define KVM_REQ_RELOAD_GICv4		KVM_ARCH_REQ(4)
+#define KVM_REQ_RELOAD_PMU		KVM_ARCH_REQ(5)
+#define KVM_REQ_SUSPEND			KVM_ARCH_REQ(6)
+#define KVM_REQ_RESYNC_PMU_EL0		KVM_ARCH_REQ(7)
+#define KVM_REQ_NESTED_S2_UNMAP		KVM_ARCH_REQ(8)
+#define KVM_REQ_GUEST_HYP_IRQ_PENDING	KVM_ARCH_REQ(9)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3115c44ed4042..5e353b2c225b4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1153,6 +1153,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * preserved on VMID roll-over if the task was preempted,
 		 * making a thread's VMID inactive. So we need to call
 		 * kvm_arm_vmid_update() in non-premptible context.
+		 *
+		 * Note that this must happen after the check_vcpu_request()
+		 * call to pick the correct s2_mmu structure, as a pending
+		 * nested exception (IRQ, for example) can trigger a change
+		 * in translation regime.
 		 */
 		if (kvm_arm_vmid_update(&vcpu->arch.hw_mmu->vmid) &&
 		    has_vhe())
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 37f7ef2f44bd8..2b511d30939b3 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1295,4 +1295,7 @@ void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
 		}
 		write_unlock(&vcpu->kvm->mmu_lock);
 	}
+
+	if (kvm_check_request(KVM_REQ_GUEST_HYP_IRQ_PENDING, vcpu))
+		kvm_inject_nested_irq(vcpu);
 }
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 324c547e1b4d8..9734a71b85611 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -906,6 +906,29 @@ static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
 /* Flush our emulation state into the GIC hardware before entering the guest. */
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * If in a nested state, we must return early. Two possibilities:
+	 *
+	 * - If we have any pending IRQ for the guest and the guest
+	 *   expects IRQs to be handled in its virtual EL2 mode (the
+	 *   virtual IMO bit is set) and it is not already running in
+	 *   virtual EL2 mode, then we have to emulate an IRQ
+	 *   exception to virtual EL2.
+	 *
+	 *   We do that by placing a request to ourselves which will
+	 *   abort the entry procedure and inject the exception at the
+	 *   beginning of the run loop.
+	 *
+	 * - Otherwise, do exactly *NOTHING*. The guest state is
+	 *   already loaded, and we can carry on with running it.
+	 */
+	if (vgic_state_is_nested(vcpu)) {
+		if (kvm_vgic_vcpu_pending_irq(vcpu))
+			kvm_make_request(KVM_REQ_GUEST_HYP_IRQ_PENDING, vcpu);
+
+		return;
+	}
+
 	/*
 	 * If there are no virtual interrupts active or pending for this
 	 * VCPU, then there is no work to do and we can bail out without
-- 
2.39.2


