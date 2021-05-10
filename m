Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E87037957F
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 19:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbhEJR2X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 13:28:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232373AbhEJR2V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 13:28:21 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 556A56146E;
        Mon, 10 May 2021 17:27:15 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lg9Gq-000Uqg-HH; Mon, 10 May 2021 18:00:40 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v4 63/66] KVM: arm64: nv: Allocate VNCR page when required
Date:   Mon, 10 May 2021 17:59:17 +0100
Message-Id: <20210510165920.1913477-64-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210510165920.1913477-1-maz@kernel.org>
References: <20210510165920.1913477-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If running a NV guest on an ARMv8.4-NV capable system, let's
allocate an additional page that will be used by the hypervisor
to fulfill system register accesses.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 ++-
 arch/arm64/kvm/nested.c           | 10 ++++++++++
 arch/arm64/kvm/reset.c            |  1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3d4543b0c116..27397ecf9a23 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -554,7 +554,8 @@ struct kvm_vcpu_arch {
  */
 static inline u64 *__ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
 {
-	if (unlikely(r >= __VNCR_START__ && ctxt->vncr_array))
+	if (unlikely(cpus_have_final_cap(ARM64_HAS_ENHANCED_NESTED_VIRT) &&
+		     r >= __VNCR_START__ && ctxt->vncr_array))
 		return &ctxt->vncr_array[r - __VNCR_START__];
 
 	return (u64 *)&ctxt->sys_regs[r];
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index d48b37f034b8..4ffbc14d0245 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -47,6 +47,14 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 	if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
 		return -EINVAL;
 
+	if (cpus_have_final_cap(ARM64_HAS_ENHANCED_NESTED_VIRT)) {
+		if (!vcpu->arch.ctxt.vncr_array)
+			vcpu->arch.ctxt.vncr_array = (u64 *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
+
+		if (!vcpu->arch.ctxt.vncr_array)
+			return -ENOMEM;
+	}
+
 	mutex_lock(&kvm->lock);
 
 	/*
@@ -64,6 +72,8 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 		    kvm_init_stage2_mmu(kvm, &tmp[num_mmus - 2])) {
 			kvm_free_stage2_pgd(&tmp[num_mmus - 1]);
 			kvm_free_stage2_pgd(&tmp[num_mmus - 2]);
+			free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
+			vcpu->arch.ctxt.vncr_array = NULL;
 		} else {
 			kvm->arch.nested_mmus_size = num_mmus;
 			ret = 0;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 55863e8f4b0c..a18172b71829 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -146,6 +146,7 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
 void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	kfree(vcpu->arch.sve_state);
+	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
 }
 
 static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
-- 
2.29.2

