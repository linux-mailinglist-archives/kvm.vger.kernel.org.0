Return-Path: <kvm+bounces-39152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CFA75A4484E
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 18:35:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 387B17A236A
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 17:34:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3502421577D;
	Tue, 25 Feb 2025 17:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qljzcvIE"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E013620E317;
	Tue, 25 Feb 2025 17:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740504588; cv=none; b=c/xTilzl7pg5sASEHPab3ohJDf95mLAme3UOHNt33pOzXloc4LMhN+zdljdDPVhfHY7pddTEFifdoS5PBzlIu7WKwfsNlUAbytdMVA7F0MAyhkzk99bkIgnXCBvn5ENjaIL8FvlwIhaIdoaKJOQEGtwuY9eIr0iCPeJlH8exRVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740504588; c=relaxed/simple;
	bh=X1ouQwIM1LuKv3rYNR+JevvdRSlVzOdYhPiP43piFsc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ua2uF9t+P9EcO4p6dCzyLyfNATIbcJkUxA7PAUBKi2k1NNbxUL25yHpxPQE8ThJcumbBJCP4gUaAWS1HVYGd5BEomPFCOYOoZcglcjrok7NNDP91ejEK/mstRzfIHdWhYBuYJ6Oo/nKOQgXoAGBG3IIPvnplkvO8Bo2Vf5w0heE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qljzcvIE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3246C4CEE7;
	Tue, 25 Feb 2025 17:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740504587;
	bh=X1ouQwIM1LuKv3rYNR+JevvdRSlVzOdYhPiP43piFsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qljzcvIEYj9E+SQzDIl6zyMMKnGiBs21m9RFBbrHZ4C2GBJacRvK0lf+ErvcuRtxL
	 zqMMT3Hse408k1pIqQNbtrxhP5JP+hI49JYlDuKEs7NvxveSZRHW9mBNe+cTBBIwaH
	 5lNRehd9Q33QTL6/fHHxGVcrVRNHOFC24qg4jzFnenokYUKfuZiviIhSsncFECu8Xp
	 zudL5O1k+7J9JNzu6EiGXy3eQrfCOhPZ+STNf0QGCqoS2yngYssOehlxWBSsvfLUPf
	 SRpRcuweIwA5N1kbzWEUM/enz6w59JE3vCWe5zY+7NLnsS2m+2Xqbzo6mteBQckEfI
	 e91utl4/s/1bQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tmykc-007rKs-3s;
	Tue, 25 Feb 2025 17:29:46 +0000
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
Subject: [PATCH v4 12/16] KVM: arm64: nv: Request vPE doorbell upon nested ERET to L2
Date: Tue, 25 Feb 2025 17:29:26 +0000
Message-Id: <20250225172930.1850838-13-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250225172930.1850838-1-maz@kernel.org>
References: <20250225172930.1850838-1-maz@kernel.org>
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
index 86519a73971ed..74be23236aaca 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -946,6 +946,8 @@ struct kvm_vcpu_arch {
 #define PMUSERENR_ON_CPU	__vcpu_single_flag(sflags, BIT(5))
 /* WFI instruction trapped */
 #define IN_WFI			__vcpu_single_flag(sflags, BIT(6))
+/* KVM is currently emulating a nested ERET */
+#define IN_NESTED_ERET		__vcpu_single_flag(sflags, BIT(7))
 
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 9986bb88c2597..834c587500699 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2503,6 +2503,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	}
 
 	preempt_disable();
+	vcpu_set_flag(vcpu, IN_NESTED_ERET);
 	kvm_arch_vcpu_put(vcpu);
 
 	if (!esr_iss_is_eretax(esr))
@@ -2514,6 +2515,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
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


