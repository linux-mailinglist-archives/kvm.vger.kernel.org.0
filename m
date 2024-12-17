Return-Path: <kvm+bounces-33971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FCB79F4F1C
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 16:16:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ABEEA7A4B83
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 15:16:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE901F8AFE;
	Tue, 17 Dec 2024 15:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tjH7UI2A"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F911F8902;
	Tue, 17 Dec 2024 15:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734448447; cv=none; b=Lv+H7l0LPJiAHOzG+DWwltFX8ms0fE5XJDXTQGDSpoI3Srnh8HUC9UYPVN25aL9JWfXb3tREWQnMG5lOnnYi/WDO4RjCi/4tHDXsInGZVGDTwQfG9XMQeIl5+0K+OfuzMo/jVK+/PeLtHf3BJwQAQI9glSM3r4QbyTXvjEYxnMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734448447; c=relaxed/simple;
	bh=F1t9F1EyfT3+kVUo54s3ABaZEho31ZRJoD7SNJfBbXA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dqf3hfdqa4gkNHq86vl5CYinCrL7iJWieGz3SxpQnjmJNq06wkNWy4qKFvLnCiXo+7NxHCRoAlOwIp9gwxo8A3gfRiFpqnKXPT/MFg1/jY4Ov+0A5PkAkPPDuO6caTnKlLdV93PrqWRZY2678klWx0VhfusieOnAVI8L95zOoss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tjH7UI2A; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A4FC4CEDD;
	Tue, 17 Dec 2024 15:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734448447;
	bh=F1t9F1EyfT3+kVUo54s3ABaZEho31ZRJoD7SNJfBbXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tjH7UI2ATjsw1dp0on4KkYeIFUNKrKWVcZFU9IrgfdNL+t5mNzFirfe7lHng89vAl
	 4uaqBxCcPPw0D3dF98l8N+oWqoODcxMJfSsGwRDmOqkoa+gXoc0C49ZB20q1kIlmhG
	 +hxOol1BZZENVKQPcwKcHudhSnbExJN4LgBKNidtVBq9VnG5Eh09LxCs195FbMBi4g
	 BavJ31p5knGI+XqKzm/NUpxgw5ZuB0e/Vsohbk1z0pAO5td2snTllEYDkWybjEL47l
	 7hZ0YCq9f7XVzCtyMm6Q0eODlpCuY3gpLmD8x/xGpcraa6hSas9BtCaOIs2pGydB63
	 6mp3qfjVy0Ryw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tNZGv-004bWV-4A;
	Tue, 17 Dec 2024 15:14:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eauger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH 13/16] KVM: arm64: nv: Request vPE doorbell upon nested ERET to L2
Date: Tue, 17 Dec 2024 15:13:28 +0000
Message-Id: <20241217151331.934077-14-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241217151331.934077-1-maz@kernel.org>
References: <20241217151331.934077-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andre.przywara@arm.com, eauger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Oliver Upton <oliver.upton@linux.dev>

Running an L2 guest with GICv4 enabled goes absolutely nowhere, and gets
into a vicious cycle of nested ERET followed by nested exception entry
into the L1.

When KVM does a put on a runnable vCPU, it marks the vPE as nonresident
but does not request a doorbell IRQ. Behind the scenes in the ITS
driver's view of the vCPU, its_vpe::pending_last gets set to true to
indicate that context is still runnable.

This comes to a head when doing the nested ERET into L2. The vPE doesn't
get scheduled on the redistributor as it is exclusively part of the L1's
VGIC context. kvm_vgic_vcpu_pending_irq() returns true because the vPE
appears runnable, and KVM does a nested exception entry into the L1
before L2 ever gets off the ground.

This issue can be papered over by requesting a doorbell IRQ when
descheduling a vPE as part of a nested ERET. KVM needs this anyway to
kick the vCPU out of the L2 when an IRQ becomes pending for the L1.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20240823212703.3576061-4-oliver.upton@linux.dev
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/emulate-nested.c   |  2 ++
 arch/arm64/kvm/vgic/vgic-v4.c     | 18 +++++++++++++++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index cb969c096d7bd..18d9166761972 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -958,6 +958,8 @@ struct kvm_vcpu_arch {
 #define PMUSERENR_ON_CPU	__vcpu_single_flag(sflags, BIT(4))
 /* WFI instruction trapped */
 #define IN_WFI			__vcpu_single_flag(sflags, BIT(5))
+/* KVM is currently emulating a nested ERET */
+#define IN_NESTED_ERET		__vcpu_single_flag(sflags, BIT(6))
 
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index c460b8403aec5..69233dcc81a46 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2434,6 +2434,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	}
 
 	preempt_disable();
+	vcpu_set_flag(vcpu, IN_NESTED_ERET);
 	kvm_arch_vcpu_put(vcpu);
 
 	if (!esr_iss_is_eretax(esr))
@@ -2445,6 +2446,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	*vcpu_cpsr(vcpu) = spsr;
 
 	kvm_arch_vcpu_load(vcpu, smp_processor_id());
+	vcpu_clear_flag(vcpu, IN_NESTED_ERET);
 	preempt_enable();
 
 	kvm_pmu_nested_transition(vcpu);
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index eedecbbbcf31b..0d9fb235c0180 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -336,6 +336,22 @@ void vgic_v4_teardown(struct kvm *kvm)
 	its_vm->vpes = NULL;
 }
 
+static inline bool vgic_v4_want_doorbell(struct kvm_vcpu *vcpu)
+{
+	if (vcpu_get_flag(vcpu, IN_WFI))
+		return true;
+
+	if (likely(!vcpu_has_nv(vcpu)))
+		return false;
+
+	/*
+	 * GICv4 hardware is only ever used for the L1. Mark the vPE (i.e. the
+	 * L1 context) nonresident and request a doorbell to kick us out of the
+	 * L2 when an IRQ becomes pending.
+	 */
+	return vcpu_get_flag(vcpu, IN_NESTED_ERET);
+}
+
 int vgic_v4_put(struct kvm_vcpu *vcpu)
 {
 	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
@@ -343,7 +359,7 @@ int vgic_v4_put(struct kvm_vcpu *vcpu)
 	if (!vgic_supports_direct_msis(vcpu->kvm) || !vpe->resident)
 		return 0;
 
-	return its_make_vpe_non_resident(vpe, !!vcpu_get_flag(vcpu, IN_WFI));
+	return its_make_vpe_non_resident(vpe, vgic_v4_want_doorbell(vcpu));
 }
 
 int vgic_v4_load(struct kvm_vcpu *vcpu)
-- 
2.39.2


