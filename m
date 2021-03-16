Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59C733D18B
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 11:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236563AbhCPKNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 06:13:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236565AbhCPKNc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 06:13:32 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E74E26501D;
        Tue, 16 Mar 2021 10:13:31 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lM6he-001uep-65; Tue, 16 Mar 2021 10:13:30 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     dave.martin@arm.com, daniel.kiss@arm.com,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        broonie@kernel.org, kernel-team@android.com
Subject: [PATCH 01/10] KVM: arm64: Provide KVM's own save/restore SVE primitives
Date:   Tue, 16 Mar 2021 10:13:03 +0000
Message-Id: <20210316101312.102925-2-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210316101312.102925-1-maz@kernel.org>
References: <20210316101312.102925-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com, will@kernel.org, catalin.marinas@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, broonie@kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

as we are about to change the way KVM deals with SVE, provide
KVM with its own save/restore SVE primitives.

No functional change intended.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/fpsimdmacros.h   |  2 ++
 arch/arm64/include/asm/kvm_hyp.h        |  2 ++
 arch/arm64/kvm/hyp/fpsimd.S             | 10 ++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 10 +++++-----
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimdmacros.h b/arch/arm64/include/asm/fpsimdmacros.h
index af43367534c7..e9b72d35b867 100644
--- a/arch/arm64/include/asm/fpsimdmacros.h
+++ b/arch/arm64/include/asm/fpsimdmacros.h
@@ -6,6 +6,8 @@
  * Author: Catalin Marinas <catalin.marinas@arm.com>
  */
 
+#include <asm/assembler.h>
+
 .macro fpsimd_save state, tmpnr
 	stp	q0, q1, [\state, #16 * 0]
 	stp	q2, q3, [\state, #16 * 2]
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index c0450828378b..e8b0f7fcd86b 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -85,6 +85,8 @@ void __debug_switch_to_host(struct kvm_vcpu *vcpu);
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
+void __sve_save_state(void *sve_pffr, u32 *fpsr);
+void __sve_restore_state(void *sve_pffr, u32 *fpsr, unsigned int vqminus1);
 
 #ifndef __KVM_NVHE_HYPERVISOR__
 void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/fpsimd.S b/arch/arm64/kvm/hyp/fpsimd.S
index 01f114aa47b0..e4010d1acb79 100644
--- a/arch/arm64/kvm/hyp/fpsimd.S
+++ b/arch/arm64/kvm/hyp/fpsimd.S
@@ -19,3 +19,13 @@ SYM_FUNC_START(__fpsimd_restore_state)
 	fpsimd_restore	x0, 1
 	ret
 SYM_FUNC_END(__fpsimd_restore_state)
+
+SYM_FUNC_START(__sve_restore_state)
+	sve_load 0, x1, x2, 3, x4
+	ret
+SYM_FUNC_END(__sve_restore_state)
+
+SYM_FUNC_START(__sve_save_state)
+	sve_save 0, x1, 2
+	ret
+SYM_FUNC_END(__sve_restore_state)
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 54f4860cd87c..807bc4734828 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -256,8 +256,8 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 				vcpu->arch.host_fpsimd_state,
 				struct thread_struct, uw.fpsimd_state);
 
-			sve_save_state(sve_pffr(thread),
-				       &vcpu->arch.host_fpsimd_state->fpsr);
+			__sve_save_state(sve_pffr(thread),
+					 &vcpu->arch.host_fpsimd_state->fpsr);
 		} else {
 			__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
 		}
@@ -266,9 +266,9 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 	}
 
 	if (sve_guest) {
-		sve_load_state(vcpu_sve_pffr(vcpu),
-			       &vcpu->arch.ctxt.fp_regs.fpsr,
-			       sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1);
+		__sve_restore_state(vcpu_sve_pffr(vcpu),
+				    &vcpu->arch.ctxt.fp_regs.fpsr,
+				    sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1);
 		write_sysreg_s(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR_EL12);
 	} else {
 		__fpsimd_restore_state(&vcpu->arch.ctxt.fp_regs);
-- 
2.29.2

