Return-Path: <kvm+bounces-46479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 11A17AB68E4
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 12:35:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A0F8463BC7
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 10:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DCB52749F1;
	Wed, 14 May 2025 10:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PSUlOqbi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B05270ED0;
	Wed, 14 May 2025 10:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747218907; cv=none; b=R0RqFwfNRYOuZ1OaVGiZJI8DKD++Mfy4iO8Kyogjx8do3BvtxXiAryYxLup1hdCMKPaWmOAXsYIf54eraU8le66ElxiYibak9KcazYA0hJJvqM+s7CsQBfbfyMz0fqMypwG5DTuNRBYIy9a/dzIzxXs9bG+fj/0YOW5a/u8k+xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747218907; c=relaxed/simple;
	bh=8+XdFyrg3jdFCFbcepfTStu3SnK+HZn4Io5Q3v/8QsQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hmIYt43d7tcrLG5iGklQjIOUqlpqJRsTVS0nE2XtGMz/a3EbxJessukbRiNVyEYIN18hvx9Z5bAofaaiZ0YPnIFzX5/60uJvodaSlShZU0sHYukNM9ELqE7dnL4SBbuaOvlk6ARn2vebEJ5+aFVX/eY9KXG40ETH0ziYHokZ1wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PSUlOqbi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2683BC4CEEB;
	Wed, 14 May 2025 10:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747218907;
	bh=8+XdFyrg3jdFCFbcepfTStu3SnK+HZn4Io5Q3v/8QsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PSUlOqbiRYNnnCFYmNXjiu3F/ll4FtCCSyn2ETfbHw9f9fT1CLtxunlZeJHqh4BCE
	 jaDQWipdj0adHgp9AzJv5TExolMiGrQhn1cOKGKLLoVHKNClXkqHTSeKEo5aasMxdm
	 UDTtshRsYbGKjQUvGyhZN6dpjyuNAcLNRJ48WU/mRM9oG+3/6+vz8gKIYiTAp2H6Ky
	 bccUPfhIYxfA6cjMc3lTkD5KWQKYAkw7HPwqtIhESbOlUnfL7TZHhffcsouPdfnTwO
	 KLbbn9MCjF4F85dYX8DymtcAiIMXLiSWvn1TsfS07IQe32WEpKQEn9mfgKPOxHVJrG
	 ipZQMOgfYx68A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uF9S5-00Eos3-7J;
	Wed, 14 May 2025 11:35:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v4 05/17] KVM: arm64: nv: Move TLBI range decoding to a helper
Date: Wed, 14 May 2025 11:34:48 +0100
Message-Id: <20250514103501.2225951-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250514103501.2225951-1-maz@kernel.org>
References: <20250514103501.2225951-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, gankulkarni@os.amperecomputing.com
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
index 4ba3780cb7806..9d56fd946e5ef 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -231,6 +231,38 @@ static inline u64 kvm_encode_nested_level(struct kvm_s2_trans *trans)
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
index 005ad28f73068..26e02e1723911 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3546,8 +3546,7 @@ static bool handle_ripas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 {
 	u32 sys_encoding = sys_insn(p->Op0, p->Op1, p->CRn, p->CRm, p->Op2);
 	u64 vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
-	u64 base, range, tg, num, scale;
-	int shift;
+	u64 base, range;
 
 	if (!kvm_supported_tlbi_ipas2_op(vcpu, sys_encoding))
 		return undef_access(vcpu, p, r);
@@ -3557,26 +3556,7 @@ static bool handle_ripas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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


