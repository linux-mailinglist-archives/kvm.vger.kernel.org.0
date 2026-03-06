Return-Path: <kvm+bounces-73132-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eHtgLhYOq2nmZgEAu9opvQ
	(envelope-from <kvm+bounces-73132-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:25:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 13BDD22614C
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 18:25:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id F2EF23097921
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 17:14:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCF2048097C;
	Fri,  6 Mar 2026 17:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pkYVXB8H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081464218BE;
	Fri,  6 Mar 2026 17:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772817098; cv=none; b=mXl2QPA0uEa6LdVuGdpequZYFCC/fEgTmqCpn1IP+nEDODxefsaYiTRvPpC97byiOGRvlNHhGKAo3mlMDls3zbb+PRca32MkAXuFNEJ2iGVp7CkvnILcsqCeHp3xO37p1fIPppJhIXRdIzq2DQhGUVM7NXo/H42aMxYsnqISn3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772817098; c=relaxed/simple;
	bh=NZIFgTqhh8EXiLLs/nxGZ8SnCnhPPbRnuUWQ0HANKVQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=emdUhYUlyxQqTv+0pWpa56wlDsTD6cJtTBvece6LR9APyRDcPFfk0PiX7rey8sY057bn4Ix8RFLMQ7S7QeMvZCt97p91wiKglzMlh0/IaTCY+bQo758p4FZZBGiqzNihY8kMRi4kMSaGT1DNzxw09o9XbKXrUW+dG3/WrHpMdO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pkYVXB8H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDFDC19425;
	Fri,  6 Mar 2026 17:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817097;
	bh=NZIFgTqhh8EXiLLs/nxGZ8SnCnhPPbRnuUWQ0HANKVQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pkYVXB8H7vKkPXZgZCgjPpnjMqxBKbjFIMuRJTGiM3BUto0m1fiQYC25++c4eJM17
	 oJqfV9pYBzTYXjU1zqbJhPBjEdHUTALKi3cU3lhLHBm4tOom7isS2/Ic9hkO5Sqx6o
	 kqRdqZZGyKzwpdpGWcu4k57LympBFNwhusj+bhQKjH/2j5JhFTQaIKbHcfASRJSAeq
	 Hz9zs88t2F9ocLtbPVFKc6Cqk/D3b23MaSjA31Kqq3xDBNnJ2SqZYCZrKM37SzvJ+3
	 z84LQBq2wY8fSSsHnsxDgrlDyu5D5r9El6Y+5ft1ZlR029CD081PO05YP6sLnoiqdM
	 GK0vy12EpfhUg==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 06 Mar 2026 17:01:22 +0000
Subject: [PATCH v10 30/30] KVM: arm64: selftests: Add SME to set_id_regs
 test
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kvm-arm64-sme-v10-30-43f7683a0fb7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3538; i=broonie@kernel.org;
 h=from:subject:message-id; bh=NZIFgTqhh8EXiLLs/nxGZ8SnCnhPPbRnuUWQ0HANKVQ=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBpqwpAv2zOEHkFm+GcJUqJtudd25zDjFhwHvj1S
 uW+4xwJ6NOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCaasKQAAKCRAk1otyXVSH
 0Ni7B/0T3XlbJIMnbMh8OG9XDj/dYjlfpsSNvzZ+HLVd+tbRo7mKD0KbCYe7XgRKmDz7DMpZKre
 0XR0UtnEAYMps41HkT4Iu8Rinj+UjHHeRTeDL066+LWleOkQrCrWzEjsepMaZJVoxsS1jWiFpue
 tuW5vhiKv8bRuWc3y67+T5oe/kCIr3VaUm1GK1q5KRWOktz1qK61RwqP5BVIkCYSmV3MyfGuqmM
 pETU5l8Osql5i7d7hFZLXtmgqhhosg83Bx5HpBWigsMMbmg/3SKX8zRPP0kMw+Eyz8kkjAnoEBD
 zUH8q6rNnIJ4aRHIFRa6fXrm1zNom8U7TMSSAn28D/FoK2Ea
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
X-Rspamd-Queue-Id: 13BDD22614C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73132-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[broonie@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.927];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

Add coverage of the SME ID registers to set_id_regs, ID_AA64PFR1_EL1.SME
becomes writable and we add ID_AA64SMFR0_EL1 and it's subfields.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 tools/testing/selftests/kvm/arm64/set_id_regs.c | 30 +++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 928e7d9e5ab7..042a7496ec83 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -145,6 +145,7 @@ static const struct reg_ftr_bits ftr_id_aa64pfr0_el1[] = {
 static const struct reg_ftr_bits ftr_id_aa64pfr1_el1[] = {
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, DF2, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, CSV2_frac, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, SME, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, SSBS, ID_AA64PFR1_EL1_SSBS_NI),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64PFR1_EL1, BT, 0),
 	REG_FTR_END,
@@ -202,6 +203,33 @@ static const struct reg_ftr_bits ftr_id_aa64mmfr3_el1[] = {
 	REG_FTR_END,
 };
 
+static const struct reg_ftr_bits ftr_id_aa64smfr0_el1[] = {
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, FA64, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, LUTv2, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, SMEver, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, I16I64, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, F64F64, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, I16I32, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, B16B16, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, F16F16, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, F8F16, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, F8F32, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, I8I32, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, F16F32, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, B16F32, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, BI32I32, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, F32F32, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, SF8FMA, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, SF8DP4, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, SF8DP2, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, SBitPerm, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, AES, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, SFEXPA, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, STMOP, 0),
+	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64SMFR0_EL1, SMOP4, 0),
+	REG_FTR_END,
+};
+
 static const struct reg_ftr_bits ftr_id_aa64zfr0_el1[] = {
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ZFR0_EL1, F64MM, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ZFR0_EL1, F32MM, 0),
@@ -234,6 +262,7 @@ static struct test_feature_reg test_regs[] = {
 	TEST_REG(SYS_ID_AA64MMFR1_EL1, ftr_id_aa64mmfr1_el1),
 	TEST_REG(SYS_ID_AA64MMFR2_EL1, ftr_id_aa64mmfr2_el1),
 	TEST_REG(SYS_ID_AA64MMFR3_EL1, ftr_id_aa64mmfr3_el1),
+	TEST_REG(SYS_ID_AA64SMFR0_EL1, ftr_id_aa64smfr0_el1),
 	TEST_REG(SYS_ID_AA64ZFR0_EL1, ftr_id_aa64zfr0_el1),
 };
 
@@ -253,6 +282,7 @@ static void guest_code(void)
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR1_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR2_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR3_EL1);
+	GUEST_REG_SYNC(SYS_ID_AA64SMFR0_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64ZFR0_EL1);
 	GUEST_REG_SYNC(SYS_MPIDR_EL1);
 	GUEST_REG_SYNC(SYS_CLIDR_EL1);

-- 
2.47.3


