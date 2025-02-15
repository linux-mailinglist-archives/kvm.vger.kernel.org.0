Return-Path: <kvm+bounces-38287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D05C2A36EF2
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 16:03:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F8F4189478C
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 15:03:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62A0A1EEA5A;
	Sat, 15 Feb 2025 15:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O4FtqBhj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8200C1DE4D6;
	Sat, 15 Feb 2025 15:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739631723; cv=none; b=u9NoVt9Ps40TFRpHuTp44FiQ1iJoLnZaC56GgzwkqE84+LahgbNY/d2Yk/ZEz3+a7O30xtIcVe04oHLyr9Iu/MTg8+UgDbMuW7t6X9jC1x54kvvmUO5Q2iCMFaZoM6OadalpZxXHbZhwKVkzchQJY7LgCn8cvGdby8kl+L5HbMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739631723; c=relaxed/simple;
	bh=DZqWgyeVUqaZBKtUHoe9HapFKZfsw/9ajICg4MC0T0Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tAG47P4p59HpJsM4N2xHQrd54Uyh90VJFKpexeoX6Y5CMxVxJrUCthr/rEZ/qA/JtSDoTzRz7vn9AM3cbE30YtJcDlupDTunaqRq8kRiR9gKiQEh0sfduv0sMGPfruphBr4Ud40GvH0gmmAe6hmt8g6aV2Q4iQNwYMe73Rog8IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O4FtqBhj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25564C4CEE8;
	Sat, 15 Feb 2025 15:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739631723;
	bh=DZqWgyeVUqaZBKtUHoe9HapFKZfsw/9ajICg4MC0T0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4FtqBhj0JS/ProY5LuKkzSoMfEa+jFZR9jxIKjGcsFWssgAKB1SEQw3uJTOrrz1b
	 FUavgPXFzXTFC7UYsPQsqwD6KW41EmtNi8jYix6qh0mUtqHKb2TUPkmJcy2pP6T+dR
	 L892Y43ZIKzWhlH21Q/0aw73Jm+wCnxEtyq7itapSUpfzZte/fgNUP03KHjMe8ncLz
	 wiCXw7n+yclZJjRnig7oqvmkDKNVdv/KMSu/O9O1i6UrKM6ynzsfcvpx3H2jXn19uW
	 HWYewjztBS8m0+bth/hvyJsvfmgq13YZ8n61lnX5CIYv8qgWWE9gYxnfKvFq2VEeIl
	 Uw1a2JFtwr52g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjJg9-004Nz6-4W;
	Sat, 15 Feb 2025 15:02:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 05/14] KVM: arm64: nv: Move TLBI range decoding to a helper
Date: Sat, 15 Feb 2025 15:01:25 +0000
Message-Id: <20250215150134.3765791-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215150134.3765791-1-maz@kernel.org>
References: <20250215150134.3765791-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As we are about to expand out TLB invalidation capabilities to support
recursive virtualisation, move the decoding of a TLBI by range into
a helper that returns the base, the range and the ASID.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 32 +++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 24 ++--------------------
 2 files changed, 34 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 2bd315a59f283..cc1302cb7929f 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -230,6 +230,38 @@ static inline u64 kvm_encode_nested_level(struct kvm_s2_trans *trans)
 		shift;							\
 	})
 
+static inline u64 decode_range_tlbi(u64 val, u64 *range, u16 *asid)
+{
+	u64 base, tg, num, scale;
+	int shift;
+
+	tg	= FIELD_GET(GENMASK(47, 46), val);
+
+	switch(tg) {
+	case 1:
+		shift = 12;
+		break;
+	case 2:
+		shift = 14;
+		break;
+	case 3:
+	default:		/* IMPDEF: handle tg==0 as 64k */
+		shift = 16;
+		break;
+	}
+
+	base	= (val & GENMASK(36, 0)) << shift;
+
+	if (asid)
+		*asid = FIELD_GET(TLBIR_ASID_MASK, val);
+
+	scale	= FIELD_GET(GENMASK(45, 44), val);
+	num	= FIELD_GET(GENMASK(43, 39), val);
+	*range	= __TLBI_RANGE_PAGES(num, scale) << shift;
+
+	return base;
+}
+
 static inline unsigned int ps_to_output_size(unsigned int ps)
 {
 	switch (ps) {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 82430c1e1dd02..24eaff9379e75 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3304,8 +3304,7 @@ static bool handle_ripas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
 	u64 vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
-	u64 base, range, tg, num, scale;
-	int shift;
+	u64 base, range;
 
 	if (!kvm_supported_tlbi_ipas2_op(vcpu, sys_encoding))
 		return undef_access(vcpu, p, r);
@@ -3315,26 +3314,7 @@ static bool handle_ripas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	 * of the guest's S2 (different base granule size, for example), we
 	 * decide to ignore TTL and only use the described range.
 	 */
-	tg	= FIELD_GET(GENMASK(47, 46), p->regval);
-	scale	= FIELD_GET(GENMASK(45, 44), p->regval);
-	num	= FIELD_GET(GENMASK(43, 39), p->regval);
-	base	= p->regval & GENMASK(36, 0);
-
-	switch(tg) {
-	case 1:
-		shift = 12;
-		break;
-	case 2:
-		shift = 14;
-		break;
-	case 3:
-	default:		/* IMPDEF: handle tg==0 as 64k */
-		shift = 16;
-		break;
-	}
-
-	base <<= shift;
-	range = __TLBI_RANGE_PAGES(num, scale) << shift;
+	base = decode_range_tlbi(p->regval, &range, NULL);
 
 	kvm_s2_mmu_iterate_by_vmid(vcpu->kvm, get_vmid(vttbr),
 				   &(union tlbi_info) {
-- 
2.39.2


