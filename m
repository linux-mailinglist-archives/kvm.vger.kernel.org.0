Return-Path: <kvm+bounces-24613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 123139584C9
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:39:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C416028959C
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 222E118F2C9;
	Tue, 20 Aug 2024 10:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iB0cfh3J"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E6A18E76F;
	Tue, 20 Aug 2024 10:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724150288; cv=none; b=tma8QRWO5DonQe7ltS7vc0T43pwTW5AyANbeJK3ngc0NDPC/MSAX6/HVpAY+zIA4z1N597l6BMAoZB3Kawojd/ZlTAErikY93rFK4/CKgVtbN1exY2axjBm8AS9yD09iEpUZBzhWa3fGlowRjJctbtTcOGLYSDR+gCFRD+s7Qjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724150288; c=relaxed/simple;
	bh=vSHhjuKzB4XiKT8IC31iaRepSYA94uoZc8/lCfNk+mU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cvxV06mmEjrOvIEWlq7sKde9yEW3inyYKr8QgHRmKuTfQaySTQtnrPxpECWdtlRYZqjhN7kvdSUkLvCxFleo/3w9E9WRg1NFxBhRvw64hce529hm+xyMKBLfiufcmEPC6pHgEJ1UlNlJSQIETB98QPawWd7DojK4aqES7LVKL+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iB0cfh3J; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7174C4AF11;
	Tue, 20 Aug 2024 10:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724150287;
	bh=vSHhjuKzB4XiKT8IC31iaRepSYA94uoZc8/lCfNk+mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iB0cfh3JCFY6Qlllu5n5j8+hJNrMNtSV3DjOseZctCDpfmOIzN+t+kxBDv4Cv3yg2
	 SoApPrIsWtCLmdukFhFLxcYvqm/x6Oi2JkdBBgrER4oNamnYXCk65ZifnooGQlRmIO
	 gliX/CxlvBDmKUknRfMJqSZJTU3f5TxR8XDL3Uq3sX/QSOteguUks8mmH2sl5c2Lsn
	 H6rkoth67/y+KxfjjpYRcQrauet4Li9lCtdf0/PidfTxsvppsOL6lqd/jFU4Mryrp8
	 hvf+oo1CT/EhTRgtyYXINwlbq1Pn7aiEc89/Bo+tQ2Wq6/2Bz8GdfRyRoI2PQTUxci
	 4RMflB4qQQGKw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgMFa-005Ea3-25;
	Tue, 20 Aug 2024 11:38:06 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v4 10/18] KVM: arm64: nv: Add basic emulation of AT S1E1{R,W}P
Date: Tue, 20 Aug 2024 11:37:48 +0100
Message-Id: <20240820103756.3545976-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820103756.3545976-1-maz@kernel.org>
References: <20240820103756.3545976-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Building on top of our primitive AT S1E{0,1}{R,W} emulation,
add minimal support for the FEAT_PAN2 instructions, momentary
context-switching PSTATE.PAN so that it takes effect in the
context of the guest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index da378ad834cd..92df948350e1 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -49,6 +49,28 @@ static void __mmu_config_restore(struct mmu_config *config)
 	write_sysreg(config->vtcr,	vtcr_el2);
 }
 
+static bool at_s1e1p_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+{
+	u64 host_pan;
+	bool fail;
+
+	host_pan = read_sysreg_s(SYS_PSTATE_PAN);
+	write_sysreg_s(*vcpu_cpsr(vcpu) & PSTATE_PAN, SYS_PSTATE_PAN);
+
+	switch (op) {
+	case OP_AT_S1E1RP:
+		fail = __kvm_at(OP_AT_S1E1RP, vaddr);
+		break;
+	case OP_AT_S1E1WP:
+		fail = __kvm_at(OP_AT_S1E1WP, vaddr);
+		break;
+	}
+
+	write_sysreg_s(host_pan, SYS_PSTATE_PAN);
+
+	return fail;
+}
+
 /*
  * Return the PAR_EL1 value as the result of a valid translation.
  *
@@ -105,6 +127,10 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	isb();
 
 	switch (op) {
+	case OP_AT_S1E1RP:
+	case OP_AT_S1E1WP:
+		fail = at_s1e1p_fast(vcpu, op, vaddr);
+		break;
 	case OP_AT_S1E1R:
 		fail = __kvm_at(OP_AT_S1E1R, vaddr);
 		break;
-- 
2.39.2


