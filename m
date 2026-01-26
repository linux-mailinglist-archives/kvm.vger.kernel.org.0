Return-Path: <kvm+bounces-69129-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qNFdHn9bd2maeQEAu9opvQ
	(envelope-from <kvm+bounces-69129-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:18:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ED5E6881A9
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:18:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DD5D9301E7E2
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40DD5337B81;
	Mon, 26 Jan 2026 12:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fa5J6m9p"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F971336EC9;
	Mon, 26 Jan 2026 12:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769429855; cv=none; b=ZSOmlY8e/9t40PhMu07HikD19IYJmsK7Pkt1giU9JNjJhM2z2woZPPP2kEECdw7wFCcq6o2AEPddHF+WzyZsSPHUa2s+fDF6LXl7XBotcpDHZMVGKAaLZtuUpGVkqV3XgeFlVOcbAGpiFK3TL4GUBQh43MrBvJ5fu6HLkOvTi5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769429855; c=relaxed/simple;
	bh=EHbYIfAX/AaecDmPp7DQIoSfrWZDbSrWEFdMI2Cgg6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVGlSTBkojJG2DpmJY+70/2E7M/bqQtppL/gEmPFoNUH42eZMbrHK7CnerqZ90E0H2OGcrEsgtoGRVHAkLkN4ozLaB8pU41yJIHcOeb7M40YduLzgn1LIN7hN6yoDgVqr5QCq3u8igPUGsVJCB1GK383dBYPPgW87ncvQYzYJcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fa5J6m9p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E798DC19425;
	Mon, 26 Jan 2026 12:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769429855;
	bh=EHbYIfAX/AaecDmPp7DQIoSfrWZDbSrWEFdMI2Cgg6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fa5J6m9pZxBan6agmM1EwLNX0adQteWrHkWqyvg9XelbNOjizRQ9fztC9eClXZ4ry
	 Gvf5V3nvNLTTMTt3ZCj1exc55HuBu29a/2rZof+DeIfAiAtCgl+zU7Yfv86ChWu5cM
	 UByja+Us/QfJXQKhSoKm7Nvm1eIjASh73tnbeI1vq+BcHzOGc6yrIpj2x5sc1lBAo2
	 Ojt0xOj9CAoF7x5ADTaw+nNJ5/qN2MN8wY9rzCTBfoK6a71sHmz5stKjC8BO145VQu
	 kG+GFcbNFlq9zwkw8KkP7NzPT6c6G2W3LMXn14J4h9kSARKwXmlEK3hjwxb1XseWgW
	 Qqw7ocgtkBUNw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vkLXA-00000005hx6-3ILP;
	Mon, 26 Jan 2026 12:17:32 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 05/20] KVM: arm64: Extend unified RESx handling to runtime sanitisation
Date: Mon, 26 Jan 2026 12:16:39 +0000
Message-ID: <20260126121655.1641736-6-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260126121655.1641736-1-maz@kernel.org>
References: <20260126121655.1641736-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69129-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: ED5E6881A9
X-Rspamd-Action: no action

Add a new helper to retrieve the RESx values for a given system
register, and use it for the runtime sanitisation.

This results in slightly better code generation for a fairly hot
path in the hypervisor.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 13 +++++++++++++
 arch/arm64/kvm/emulate-nested.c   | 10 +---------
 arch/arm64/kvm/nested.c           | 13 ++++---------
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a7e4cd8ebf56f..9dca94e4361f0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -635,6 +635,19 @@ struct kvm_sysreg_masks {
 	struct resx mask[NR_SYS_REGS - __SANITISED_REG_START__];
 };
 
+#define kvm_get_sysreg_resx(k, sr)					\
+	({                                                              \
+		struct kvm_sysreg_masks *__masks;			\
+		struct resx __resx = {};				\
+									\
+		__masks = (k)->arch.sysreg_masks;			\
+		if (likely(__masks &&					\
+			   sr >= __SANITISED_REG_START__ &&		\
+			   sr < NR_SYS_REGS))				\
+			__resx = __masks->mask[sr - __SANITISED_REG_START__]; \
+		__resx;							\
+	})
+
 #define kvm_set_sysreg_resx(k, sr, resx)		\
 	do {						\
 		(k)->arch.sysreg_masks->mask[sr - __SANITISED_REG_START__] = resx; \
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 774cfbf5b43ba..43334cd2db9e5 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2427,15 +2427,7 @@ static enum trap_behaviour compute_trap_behaviour(struct kvm_vcpu *vcpu,
 
 static u64 kvm_get_sysreg_res0(struct kvm *kvm, enum vcpu_sysreg sr)
 {
-	struct kvm_sysreg_masks *masks;
-
-	/* Only handle the VNCR-backed regs for now */
-	if (sr < __VNCR_START__)
-		return 0;
-
-	masks = kvm->arch.sysreg_masks;
-
-	return masks->mask[sr - __SANITISED_REG_START__].res0;
+	return kvm_get_sysreg_resx(kvm, sr).res0;
 }
 
 static bool check_fgt_bit(struct kvm_vcpu *vcpu, enum vcpu_sysreg sr,
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index c5a45bc62153e..75a23f1c56d13 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1669,16 +1669,11 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 val)
 u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *vcpu,
 			     enum vcpu_sysreg sr, u64 v)
 {
-	struct kvm_sysreg_masks *masks;
-
-	masks = vcpu->kvm->arch.sysreg_masks;
-
-	if (masks) {
-		sr -= __SANITISED_REG_START__;
+	struct resx resx;
 
-		v &= ~masks->mask[sr].res0;
-		v |= masks->mask[sr].res1;
-	}
+	resx = kvm_get_sysreg_resx(vcpu->kvm, sr);
+	v &= ~resx.res0;
+	v |= resx.res1;
 
 	return v;
 }
-- 
2.47.3


