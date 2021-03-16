Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAB633D18D
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 11:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236577AbhCPKNw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 06:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236566AbhCPKNd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 06:13:33 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9731865020;
        Tue, 16 Mar 2021 10:13:32 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lM6he-001uep-QW; Tue, 16 Mar 2021 10:13:30 +0000
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
Subject: [PATCH 02/10] KVM: arm64: Use {read,write}_sysreg_el1 to access ZCR_EL1
Date:   Tue, 16 Mar 2021 10:13:04 +0000
Message-Id: <20210316101312.102925-3-maz@kernel.org>
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

Switch to the unified EL1 accessors for ZCR_EL1, which will make
things easier for nVHE support.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/fpsimd.c                 | 3 ++-
 arch/arm64/kvm/hyp/include/hyp/switch.h | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 3e081d556e81..b7e36a506d3d 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -11,6 +11,7 @@
 #include <linux/kvm_host.h>
 #include <asm/fpsimd.h>
 #include <asm/kvm_asm.h>
+#include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/sysreg.h>
 
@@ -112,7 +113,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 		fpsimd_save_and_flush_cpu_state();
 
 		if (guest_has_sve)
-			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_s(SYS_ZCR_EL12);
+			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
 	} else if (host_has_sve) {
 		/*
 		 * The FPSIMD/SVE state in the CPU has not been touched, and we
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 807bc4734828..d762d5bdc2d5 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -269,7 +269,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 		__sve_restore_state(vcpu_sve_pffr(vcpu),
 				    &vcpu->arch.ctxt.fp_regs.fpsr,
 				    sve_vq_from_vl(vcpu->arch.sve_max_vl) - 1);
-		write_sysreg_s(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR_EL12);
+		write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
 	} else {
 		__fpsimd_restore_state(&vcpu->arch.ctxt.fp_regs);
 	}
-- 
2.29.2

