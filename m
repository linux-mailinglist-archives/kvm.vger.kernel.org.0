Return-Path: <kvm+bounces-73120-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MPjNMccLq2k/ZgEAu9opvQ
	(envelope-from <kvm+bounces-73120-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:15:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 86C2A225C87
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:15:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 427D83075CD5
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A7B0421A10;
	Fri,  6 Mar 2026 17:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SjLF03+h"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C9941325C;
	Fri,  6 Mar 2026 17:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772817045; cv=none; b=AHM/cOcvIZcL7nzOhylZLc5ekfdmeNDI0vIMRezxiHYHondPaJ1ftKjt2ZfDdRYkPWNcAKNmVY7tU//8imTbZE+UzQitPvbHgzomqmcw4ggJSx4b0y9QMkkLSaw9BpX+nEBKzTtAswek3OKGG+DLufut7acRizWVdN9/b1P7fCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772817045; c=relaxed/simple;
	bh=F41Vx/sjHMfSg6KECj89bZ4Pk/E+IG43GonQ3lL1rlk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LAOozjUW6KG5X8cKJ3ZeHQxqL2DJY7Aq9ofVq1SJ2+0SIInbA9gvY1G13jgY+pOuSgU1Si4RG0gsICacP/67PPnvE1McrvBcY6iH/IpF7Ap0ZRIXI0rCDJ1jln4wI1PI40bdfOgOr0H/nRd+E7aylqJ1HjBPbVu7N/FYiEBA8dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SjLF03+h; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EADC4CEF7;
	Fri,  6 Mar 2026 17:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817044;
	bh=F41Vx/sjHMfSg6KECj89bZ4Pk/E+IG43GonQ3lL1rlk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=SjLF03+hwhb3Y+iHviJq1+2m4RF0v5FE8U/woN0UuSs6L1mIe3lXVeHOAA7238bRZ
	 LWMImTBghVM1t7dffIrS2dsmttWzxQkJepWemDcSZf9HfFtwewtJD/Zx9Xw7BAiGR0
	 10A7sHXUpDq0KVF3r7DABSh7fqTZyeBYPjNh/pO0pIVw6NRCxgXIki2e2qveX57vYK
	 V7EKKHaOHHvJ6sNUNuqy7fGYMT0veHSNoxXrzjetKot7D2crOvqMI3qrbF2j1zreYq
	 HwwXQt2VeBqu6KdFX0MCFj9TMAp6paAC/1smaomulYR1qfYJ7oUls9a/z5T5pOUGGS
	 wenl5pxcT2Sdw==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 06 Mar 2026 17:01:10 +0000
Subject: [PATCH v10 18/30] KVM: arm64: Support SME priority registers
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kvm-arm64-sme-v10-18-43f7683a0fb7@kernel.org>
References: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
In-Reply-To: <20260306-kvm-arm64-sme-v10-0-43f7683a0fb7@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.15-dev-6ac23
X-Developer-Signature: v=1; a=openpgp-sha256; l=5564; i=broonie@kernel.org;
 h=from:subject:message-id; bh=F41Vx/sjHMfSg6KECj89bZ4Pk/E+IG43GonQ3lL1rlk=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpqwo23yH252jb6sF4Wijm1Cyl2gq68NvuYW+AJ
 4kio7pfisiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaasKNgAKCRAk1otyXVSH
 0L19B/9uwW0IjXWgxWd7m/3k3jZlVD1n4SPRTQSe5q1iLZ3jliJ8O48Zr6g9Xj1FUqtm8tXeYE2
 rO51hrABG7lI9/tKZqsU8ZmANlLDAiCAyvQsgkEbFuydewmw5XaJpuDXmvg47D1Vwmcsz/UIDkS
 R8Rz6NOeSeIJIUPCxFOAMVPp10Xd8YFG7Mfq1qW9TOd0ggILCZQgwyyEI8ZLwdrFzdvyLfc9+4L
 Q/ynBfRmqWnkWB37enLOt+QqZ8wgUiUUKkQ1oL2ZMCYNOu0USVwCY5K2hv+er2/JH+ZbmyF8Jnu
 0HUuGQU7zCLzFnzEkvDu2tJLeeFReS3qBxd8XUeZjGEfrMZm
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: 86C2A225C87
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73120-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[broonie@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.918];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

SME has optional support for configuring the relative priorities of PEs
in systems where they share a single SME hardware block, known as a
SMCU. Currently we do not have any support for this in Linux and will
also hide it from KVM guests, pending experience with practical
implementations. The interface for configuring priority support is via
two new system registers, these registers are always defined when SME is
available.

The register SMPRI_EL1 allows control of SME execution priorities. Since
we disable SME priority support for guests this register is RES0, define
it as such and enable fine grained traps for SMPRI_EL1 to ensure that
guests can't write to it even if the hardware supports priorities.  Since
the register should be readable with fixed contents we only trap writes,
not reads. Since there is no host support for using priorities the
register currently left with a value of 0 by the host so we do not need
to update the value for guests.

There is also an EL2 register SMPRIMAP_EL2 for virtualisation of
priorities, this is RES0 when priority configuration is not supported
but has no specific traps available.  When saving state from a nested
guest we overwrite any value the guest stored.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h     |  1 +
 arch/arm64/include/asm/vncr_mapping.h |  1 +
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c    |  7 +++++++
 arch/arm64/kvm/sys_regs.c             | 30 +++++++++++++++++++++++++++++-
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b8f9ab8fadd4..094cbf8e7022 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -543,6 +543,7 @@ enum vcpu_sysreg {
 	VNCR(CPACR_EL1),/* Coprocessor Access Control */
 	VNCR(ZCR_EL1),	/* SVE Control */
 	VNCR(SMCR_EL1),	/* SME Control */
+	VNCR(SMPRIMAP_EL2),	/* Streaming Mode Priority Mapping Register */
 	VNCR(TTBR0_EL1),/* Translation Table Base Register 0 */
 	VNCR(TTBR1_EL1),/* Translation Table Base Register 1 */
 	VNCR(TCR_EL1),	/* Translation Control Register */
diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm/vncr_mapping.h
index 44b12565321b..ac2f5db0ee9c 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -45,6 +45,7 @@
 #define VNCR_ZCR_EL1            0x1E0
 #define VNCR_HAFGRTR_EL2	0x1E8
 #define VNCR_SMCR_EL1		0x1F0
+#define VNCR_SMPRIMAP_EL2	0x1F8
 #define VNCR_TTBR0_EL1          0x200
 #define VNCR_TTBR1_EL1          0x210
 #define VNCR_FAR_EL1            0x220
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index b254d442e54e..d814e7fb12ba 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -80,6 +80,13 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
 
 	if (ctxt_has_sctlr2(&vcpu->arch.ctxt))
 		__vcpu_assign_sys_reg(vcpu, SCTLR2_EL2, read_sysreg_el1(SYS_SCTLR2));
+
+	/*
+	 * We block SME priorities so SMPRIMAP_EL2 is RES0, however we
+	 * do not have traps to block access so the guest might have
+	 * updated the state, overwrite anything there.
+	 */
+	__vcpu_assign_sys_reg(vcpu, SMPRIMAP_EL2, 0);
 }
 
 static void __sysreg_restore_vel2_state(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 15854947de61..0ddb89723819 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -691,6 +691,15 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 		return read_zero(vcpu, p);
 }
 
+static int set_res0(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+		    u64 val)
+{
+	if (val)
+		return -EINVAL;
+
+	return 0;
+}
+
 /*
  * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
  * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
@@ -1979,6 +1988,15 @@ static unsigned int fp8_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static unsigned int sme_raz_visibility(const struct kvm_vcpu *vcpu,
+				       const struct sys_reg_desc *rd)
+{
+	if (vcpu_has_sme(vcpu))
+		return REG_RAZ;
+
+	return REG_HIDDEN;
+}
+
 static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 {
 	if (!vcpu_has_sve(vcpu))
@@ -3371,7 +3389,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	{ SYS_DESC(SYS_ZCR_EL1), NULL, reset_val, ZCR_EL1, 0, .visibility = sve_visibility },
 	{ SYS_DESC(SYS_TRFCR_EL1), undef_access },
-	{ SYS_DESC(SYS_SMPRI_EL1), undef_access },
+
+	/*
+	 * SMPRI_EL1 is UNDEF when SME is disabled, the UNDEF is
+	 * handled via FGU which is handled without consulting this
+	 * table.
+	 */
+	{ SYS_DESC(SYS_SMPRI_EL1), trap_raz_wi, .visibility = sme_raz_visibility },
+
 	{ SYS_DESC(SYS_SMCR_EL1), NULL, reset_val, SMCR_EL1, 0, .visibility = sme_visibility },
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
 	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
@@ -3742,6 +3767,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	EL2_REG_VNCR(HCRX_EL2, reset_val, 0),
 
+	{ SYS_DESC(SYS_SMPRIMAP_EL2), .reg = SMPRIMAP_EL2,
+	  .access = trap_raz_wi, .set_user = set_res0, .reset = reset_val,
+	  .val = 0, .visibility = sme_el2_visibility },
 	EL2_REG_FILTERED(SMCR_EL2, access_smcr_el2, reset_val, 0,
 			 sme_el2_visibility),
 

-- 
2.47.3


