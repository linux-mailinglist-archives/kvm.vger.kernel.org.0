Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B4B23CF05
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgHETML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729137AbgHES1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:27:38 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4D0222D0A;
        Wed,  5 Aug 2020 18:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596651980;
        bh=hIf32nYEb75AQyrxNZncxzQMZ9doTtf3FvOFwnJh+Fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8QdIoTyGk3yakVsrnTCc4yyX2LQIJgUYf2euBQoXfSt6tGdPEqCoWq7FcSHRy22o
         IC6xJI8Ft5k0ONMqSOZ/9EbP0fLGZxBpKSWXmewQlQaYBf6LKQhFyrq4qFu3lchHAR
         DCCZKby1m5pQtAR7g+BnzQEkiP1LRBLHtXxH0Nwc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3Nfs-0004w9-2H; Wed, 05 Aug 2020 18:58:00 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 42/56] KVM: arm64: Move ELR_EL1 to the system register array
Date:   Wed,  5 Aug 2020 18:56:46 +0100
Message-Id: <20200805175700.62775-43-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com, alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, richard.peng@oppo.com, qperret@google.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As ELR-EL1 is a VNCR-capable register with ARMv8.4-NV, let's move it to
the sys_regs array and repaint the accessors. While we're at it, let's
kill the now useless accessors used only on the fault injection path.

Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h       | 21 ---------------------
 arch/arm64/include/asm/kvm_host.h          |  3 ++-
 arch/arm64/kvm/guest.c                     |  2 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  4 ++--
 arch/arm64/kvm/inject_fault.c              |  2 +-
 arch/arm64/kvm/sys_regs.c                  |  2 ++
 6 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index cd607999abc2..a12b5dc5db0d 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -127,27 +127,6 @@ static __always_inline unsigned long *vcpu_pc(const struct kvm_vcpu *vcpu)
 	return (unsigned long *)&vcpu_gp_regs(vcpu)->pc;
 }
 
-static inline unsigned long *__vcpu_elr_el1(const struct kvm_vcpu *vcpu)
-{
-	return (unsigned long *)&vcpu->arch.ctxt.elr_el1;
-}
-
-static inline unsigned long vcpu_read_elr_el1(const struct kvm_vcpu *vcpu)
-{
-	if (vcpu->arch.sysregs_loaded_on_cpu)
-		return read_sysreg_el1(SYS_ELR);
-	else
-		return *__vcpu_elr_el1(vcpu);
-}
-
-static inline void vcpu_write_elr_el1(const struct kvm_vcpu *vcpu, unsigned long v)
-{
-	if (vcpu->arch.sysregs_loaded_on_cpu)
-		write_sysreg_el1(v, SYS_ELR);
-	else
-		*__vcpu_elr_el1(vcpu) = v;
-}
-
 static __always_inline unsigned long *vcpu_cpsr(const struct kvm_vcpu *vcpu)
 {
 	return (unsigned long *)&vcpu_gp_regs(vcpu)->pstate;
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bc1e91573d00..f255507dd916 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -185,6 +185,8 @@ enum vcpu_sysreg {
 	APGAKEYLO_EL1,
 	APGAKEYHI_EL1,
 
+	ELR_EL1,
+
 	/* 32bit specific registers. Keep them at the end of the range */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
@@ -239,7 +241,6 @@ struct kvm_cpu_context {
 	struct user_pt_regs regs;	/* sp = sp_el0 */
 
 	u64	sp_el1;
-	u64	elr_el1;
 
 	u64	spsr[KVM_NR_SPSR];
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 9dd5bbeefae6..99ff09ad24e8 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -132,7 +132,7 @@ static void *core_reg_addr(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		return &vcpu->arch.ctxt.sp_el1;
 
 	case KVM_REG_ARM_CORE_REG(elr_el1):
-		return &vcpu->arch.ctxt.elr_el1;
+		return __ctxt_sys_reg(&vcpu->arch.ctxt, ELR_EL1);
 
 	case KVM_REG_ARM_CORE_REG(spsr[0]) ...
 	     KVM_REG_ARM_CORE_REG(spsr[KVM_NR_SPSR - 1]):
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 50938093cc5d..9ebbd626d4ab 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -47,7 +47,7 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 	ctxt_sys_reg(ctxt, TPIDR_EL1)	= read_sysreg(tpidr_el1);
 
 	ctxt->sp_el1			= read_sysreg(sp_el1);
-	ctxt->elr_el1			= read_sysreg_el1(SYS_ELR);
+	ctxt_sys_reg(ctxt, ELR_EL1)	= read_sysreg_el1(SYS_ELR);
 	ctxt->spsr[KVM_SPSR_EL1]	= read_sysreg_el1(SYS_SPSR);
 }
 
@@ -126,7 +126,7 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt)
 	}
 
 	write_sysreg(ctxt->sp_el1,			sp_el1);
-	write_sysreg_el1(ctxt->elr_el1,			SYS_ELR);
+	write_sysreg_el1(ctxt_sys_reg(ctxt, ELR_EL1),	SYS_ELR);
 	write_sysreg_el1(ctxt->spsr[KVM_SPSR_EL1],	SYS_SPSR);
 }
 
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index e21fdd93027a..ebfdfc27b2bd 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -64,7 +64,7 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 	case PSR_MODE_EL1h:
 		vbar = vcpu_read_sys_reg(vcpu, VBAR_EL1);
 		sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
-		vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
+		vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
 		break;
 	default:
 		/* Don't do that */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index baf5ce9225ce..6657b83c0647 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -94,6 +94,7 @@ static bool __vcpu_read_sys_reg_from_cpu(int reg, u64 *val)
 	case TPIDR_EL1:		*val = read_sysreg_s(SYS_TPIDR_EL1);	break;
 	case AMAIR_EL1:		*val = read_sysreg_s(SYS_AMAIR_EL12);	break;
 	case CNTKCTL_EL1:	*val = read_sysreg_s(SYS_CNTKCTL_EL12);	break;
+	case ELR_EL1:		*val = read_sysreg_s(SYS_ELR_EL12);	break;
 	case PAR_EL1:		*val = read_sysreg_s(SYS_PAR_EL1);	break;
 	case DACR32_EL2:	*val = read_sysreg_s(SYS_DACR32_EL2);	break;
 	case IFSR32_EL2:	*val = read_sysreg_s(SYS_IFSR32_EL2);	break;
@@ -133,6 +134,7 @@ static bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 	case TPIDR_EL1:		write_sysreg_s(val, SYS_TPIDR_EL1);	break;
 	case AMAIR_EL1:		write_sysreg_s(val, SYS_AMAIR_EL12);	break;
 	case CNTKCTL_EL1:	write_sysreg_s(val, SYS_CNTKCTL_EL12);	break;
+	case ELR_EL1:		write_sysreg_s(val, SYS_ELR_EL12);	break;
 	case PAR_EL1:		write_sysreg_s(val, SYS_PAR_EL1);	break;
 	case DACR32_EL2:	write_sysreg_s(val, SYS_DACR32_EL2);	break;
 	case IFSR32_EL2:	write_sysreg_s(val, SYS_IFSR32_EL2);	break;
-- 
2.27.0

