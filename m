Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46CF46239B
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 22:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhK2Vr6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 16:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbhK2Vpw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 16:45:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180BAC08EB38
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 12:06:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D466EB815EB
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F66C53FC7;
        Mon, 29 Nov 2021 20:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216384;
        bh=hQjYY7dIibxjv8EfQGlPyiMMiLP5soaWxDM3zMZFfu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l0bJ9mYp6fYzJKROrE4sSorG38/awt0U0m6AbwzlhTWJtCUU2Rfk5FChhFUdjbXk7
         avdT1DPfCz7WUEvDfxesmId9WC14pE786gCVfiYJAIFYPBO4zRvyAgWV8s00rk6ZsI
         DIpT9EYHSpoWCg55W9kSVmZAj5qUgQSoZuuJ9tXkQHNtc5Kgdg/XfL82V4JpsV598z
         omT0GzedG9Woibkdebcz3WNGbpXX2RZjyceGhOKk9/m8/i8ka/+cNu4mln5JqyunAc
         EY8FcdY2qOCrzs7GLZDmRT78CCXDjVSuStcZvJyu7RsFNL9r7PpTsUPom2GfBZioeg
         zTDOAcxzL3W+g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmrB-008gvR-FG; Mon, 29 Nov 2021 20:02:33 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v5 53/69] KVM: arm64: nv: vgic: Emulate the HW bit in software
Date:   Mon, 29 Nov 2021 20:01:34 +0000
Message-Id: <20211129200150.351436-54-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@arm.com>

Should the guest hypervisor use the HW bit in the LRs, we need to
emulate the deactivation from the L2 guest into the L1 distributor
emulation, which is handled by L0.

It's all good fun.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h     |  2 ++
 arch/arm64/kvm/hyp/vgic-v3-sr.c      |  2 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 32 ++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c           |  6 ++++--
 include/kvm/arm_vgic.h               |  1 +
 5 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 5afd14ab15b9..0d1bd78c2179 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -57,6 +57,8 @@ DECLARE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
+u64 __gic_v3_get_lr(unsigned int lr);
+
 void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if);
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 20db2f281cf2..0601d73de11b 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -18,7 +18,7 @@
 #define vtr_to_nr_pre_bits(v)		((((u32)(v) >> 26) & 7) + 1)
 #define vtr_to_nr_apr_regs(v)		(1 << (vtr_to_nr_pre_bits(v) - 5))
 
-static u64 __gic_v3_get_lr(unsigned int lr)
+u64 __gic_v3_get_lr(unsigned int lr)
 {
 	switch (lr & 0xf) {
 	case 0:
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index bfe0ccde514f..3ee3438b5e22 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -138,6 +138,38 @@ static void vgic_v3_fixup_shadow_lr_state(struct kvm_vcpu *vcpu)
 	}
 }
 
+void vgic_v3_sync_nested(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpu_if = vcpu_nested_if(vcpu);
+	struct vgic_v3_cpu_if *s_cpu_if = vcpu_shadow_if(vcpu);
+	struct vgic_irq *irq;
+	int i;
+
+	for (i = 0; i < s_cpu_if->used_lrs; i++) {
+		u64 lr = cpu_if->vgic_lr[i];
+		int l1_irq;
+
+		if (!(lr & ICH_LR_HW) || !(lr & ICH_LR_STATE))
+			continue;
+
+		/*
+		 * If we had a HW lr programmed by the guest hypervisor, we
+		 * need to emulate the HW effect between the guest hypervisor
+		 * and the nested guest.
+		 */
+		l1_irq = (lr & ICH_LR_PHYS_ID_MASK) >> ICH_LR_PHYS_ID_SHIFT;
+		irq = vgic_get_irq(vcpu->kvm, vcpu, l1_irq);
+		if (!irq)
+			continue; /* oh well, the guest hyp is broken */
+
+		lr = __gic_v3_get_lr(i);
+		if (!(lr & ICH_LR_STATE))
+			irq->active = false;
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+}
+
 void vgic_v3_load_nested(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 6503aa208c9f..afe415b5f8a0 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -876,9 +876,11 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	int used_lrs;
 
-	/* If nesting, this is a load/put affair, not flush/sync. */
-	if (vgic_state_is_nested(vcpu))
+	/* If nesting, emulate the HW effect from L0 to L1 */
+	if (vgic_state_is_nested(vcpu)) {
+		vgic_v3_sync_nested(vcpu);
 		return;
+	}
 
 	/* An empty ap_list_head implies used_lrs == 0 */
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index a0db49e6c781..a3fc08988a5b 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -391,6 +391,7 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu);
 void kvm_vgic_put(struct kvm_vcpu *vcpu);
 void kvm_vgic_vmcr_sync(struct kvm_vcpu *vcpu);
 
+void vgic_v3_sync_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_load_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_put_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu);
-- 
2.30.2

