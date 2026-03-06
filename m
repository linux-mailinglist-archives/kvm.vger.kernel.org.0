Return-Path: <kvm+bounces-73114-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +GMFCCwMq2k/ZgEAu9opvQ
	(envelope-from <kvm+bounces-73114-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:17:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 87845225CE0
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:17:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D9EB93198632
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:11:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33616425CF0;
	Fri,  6 Mar 2026 17:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fSrKxZ1m"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6355C423175;
	Fri,  6 Mar 2026 17:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772817018; cv=none; b=dRX3GVemHX46QfqZdiqeVOMOjhylxvkarwR7csUaoc8xYzu5qUWpkavXHc6aullWYuU0ShaeP7D0oWYMNeb7tLE1uU9hDcLogS4VZSUsoyqGu6ycSmhP7xTsQ2Gyjgtiv02om150QOf5zUpV6Ovm6dMj8zUbLPJhlXaRNl7ikWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772817018; c=relaxed/simple;
	bh=SitDXA7jb0eoqcSylSxaCT4VSP66th+kAnfyQu7Nc1I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Cefi0OxiaKbdUa5i/xdlHJPIVTgv+jMFLtXCzrVulf1mbP4cz6YVNrC2GVS6qig2Uv7EwqP5xydjbtbWS10f1c4/ya1DxiDws8+AIgN3Tnd3MJU6dXFgu4Y1ikpZyyYtAlwQ2uRS3RvlgHLMBD6t/FZGTAtxQNmBTiNx+oT3zZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fSrKxZ1m; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4396EC2BCB4;
	Fri,  6 Mar 2026 17:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817018;
	bh=SitDXA7jb0eoqcSylSxaCT4VSP66th+kAnfyQu7Nc1I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fSrKxZ1mn4TB92F4Z8i2TjQDAatmhXKaGzMsk10XHve+BT9Gc7pWwH6zjGaZjBJww
	 43yDwO0yAVKXa3jNyuKCXl/VFWAkVrIo6NvnRIxWwgyXsyfT+HhJB2DrYt8XGGNq1N
	 1lpw2HrdsBYxaUMSOSXEWPgd2mGuj6K/4chXuE/R4usQRpNeDXAF3fi9ZkQ5LtRtci
	 CfLH7iL6jwEROuKO6qt4rprIgYKOe2+vSEy6oU+wzz8m9qMDOwmiO4PfjITY/KjwqM
	 jJ/12ylm0toV/nHPoYj/Lhnq+eXUZROTKeEny8gTR5rGgfQXr9ONxHrSmXrQhPMOR5
	 6EgTziWKj5pLQ==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 06 Mar 2026 17:01:04 +0000
Subject: [PATCH v10 12/30] KVM: arm64: Factor SVE code out of
 fpsimd_lazy_switch_to_host()
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kvm-arm64-sme-v10-12-43f7683a0fb7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2820; i=broonie@kernel.org;
 h=from:subject:message-id; bh=SitDXA7jb0eoqcSylSxaCT4VSP66th+kAnfyQu7Nc1I=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpqwoxdwx4Vs/wp9I109pAepIICp+QdG104WOgX
 gOWCAZyCpKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaasKMQAKCRAk1otyXVSH
 0FTMB/9uU5zLItDNiBtK37m3TP/Yc+l7e1bbazjTwvbRJ6dAx2Z2GlrdJBP5i7GzM38ITDX6AxZ
 8134rzDXSHwdwOX8vJhzS4bIPix2W6p/r8UUaGuPSemYfxfV2ldLLXY0VF+J2lT0c8fPQb6fPu7
 Rht8Qdn1wN0vYofqvlIxC0yBZb7xtpOPTsENy+1ihB+xGhRglmF22fjIbfXkmCZl0/qa6Jj0sIB
 kLj58WvCeJX4kgBs9huxif4FY9sJpP/zQs16gUMuZnwfMhB4YN+d3KivkQAXkwYw9Qll9mycSXF
 YfeQIA9FmEsIJcliJxS/PjvyiFvSdjss6sUi/IY+fziQ/3JD
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: 87845225CE0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73114-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[broonie@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.907];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Since the function will grow as a result of adding SME support move the
SVE code out of fpsimd_lazy_switch_to_host(). No functional change, just
code motion.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 46 +++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 4e38610be19a..5b99aa479c59 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -483,11 +483,11 @@ static inline void fpsimd_lazy_switch_to_guest(struct kvm_vcpu *vcpu)
 	}
 }
 
-static inline void fpsimd_lazy_switch_to_host(struct kvm_vcpu *vcpu)
+static inline void sve_lazy_switch_to_host(struct kvm_vcpu *vcpu)
 {
 	u64 zcr_el1, zcr_el2;
 
-	if (!guest_owns_fp_regs())
+	if (!vcpu_has_sve(vcpu))
 		return;
 
 	/*
@@ -498,29 +498,35 @@ static inline void fpsimd_lazy_switch_to_host(struct kvm_vcpu *vcpu)
 	 * synchronization event, we don't need an ISB here to avoid taking
 	 * traps for anything that was exposed to the guest.
 	 */
-	if (vcpu_has_sve(vcpu)) {
-		zcr_el1 = read_sysreg_el1(SYS_ZCR);
-		__vcpu_assign_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu), zcr_el1);
+	zcr_el1 = read_sysreg_el1(SYS_ZCR);
+	__vcpu_assign_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu), zcr_el1);
 
-		/*
-		 * The guest's state is always saved using the guest's max VL.
-		 * Ensure that the host has the guest's max VL active such that
-		 * the host can save the guest's state lazily, but don't
-		 * artificially restrict the host to the guest's max VL.
-		 */
-		if (has_vhe()) {
-			zcr_el2 = vcpu_sve_max_vq(vcpu) - 1;
-			write_sysreg_el2(zcr_el2, SYS_ZCR);
-		} else {
-			zcr_el2 = sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SVE]) - 1;
-			write_sysreg_el2(zcr_el2, SYS_ZCR);
+	/*
+	 * The guest's state is always saved using the guest's max VL.
+	 * Ensure that the host has the guest's max VL active such
+	 * that the host can save the guest's state lazily, but don't
+	 * artificially restrict the host to the guest's max VL.
+	 */
+	if (has_vhe()) {
+		zcr_el2 = vcpu_sve_max_vq(vcpu) - 1;
+		write_sysreg_el2(zcr_el2, SYS_ZCR);
+	} else {
+		zcr_el2 = sve_vq_from_vl(kvm_host_max_vl[ARM64_VEC_SVE]) - 1;
+		write_sysreg_el2(zcr_el2, SYS_ZCR);
 
-			zcr_el1 = vcpu_sve_max_vq(vcpu) - 1;
-			write_sysreg_el1(zcr_el1, SYS_ZCR);
-		}
+		zcr_el1 = vcpu_sve_max_vq(vcpu) - 1;
+		write_sysreg_el1(zcr_el1, SYS_ZCR);
 	}
 }
 
+static inline void fpsimd_lazy_switch_to_host(struct kvm_vcpu *vcpu)
+{
+	if (!guest_owns_fp_regs())
+		return;
+
+	sve_lazy_switch_to_host(vcpu);
+}
+
 static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
 {
 	/*

-- 
2.47.3


