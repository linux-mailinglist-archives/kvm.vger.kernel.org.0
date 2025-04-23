Return-Path: <kvm+bounces-43954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EA530A9914E
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 17:29:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A925920830
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 15:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE40D298CA3;
	Wed, 23 Apr 2025 15:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jLwKtmmp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BCE28F927;
	Wed, 23 Apr 2025 15:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421316; cv=none; b=VukbO1ugGlk6A37rldKs9nu//XNDtDeck9+wclfORW309UvJl1CyHJATDHern6FFpgEAzu2LfrxzshQNLzg8RjueEcn6Q01/IADwHOiX3OtFetT/PwfFx/ETnrsEERpPPsTOEAanDuq2TuAVODePcIQk/Wt0Yd1chy6i9chz5yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421316; c=relaxed/simple;
	bh=8+XdFyrg3jdFCFbcepfTStu3SnK+HZn4Io5Q3v/8QsQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mrM93ZifmC/J+oELEwHz83MG5CSSxqaOxy9VUQI6YwsZe1cIDzmSl03LIHkjcdgVPKVPqgIrb/QWwU0QNmXrqsZn9M1wnP+OA0Fck+GRhv9+np5b7gga46LND2hyn9Q50szu3OreuiWGfIsQgV85+goqLHxlsqXlPg2Ji5Emc10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jLwKtmmp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D79C4CEE2;
	Wed, 23 Apr 2025 15:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745421316;
	bh=8+XdFyrg3jdFCFbcepfTStu3SnK+HZn4Io5Q3v/8QsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLwKtmmp4ggPPexk1Ug4MAmBeHG3cg6dnLDPVF0iRVXf9k+r8f4Ax/kHWD9GswRwL
	 l09Pfmku8byFg0FvYbTuNGqfDr5rHQxXgyvxjYlBK/eGGU+2EzVIXHBV9kTL8mksXM
	 WjZU2RPAdd6UFnYtdfQxGzH5i1AYivqdZH2e/Py/yPhBVV57W7dgV4ES79bGzu/LlP
	 f2PHJv1s90Lgi+9JOYwVDJ7EYVsP0ZnkPQ0sY0cx6b4/WSOEDy7a4hsfcxtBidTi1A
	 xgrWKYZcrG7AkECYBC+/s4nAFnp2zcdpYW3dK2SshyUsLpEsF3ouPOx/QYmSoSozpV
	 BEJf+Dp8qdT8A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u7bog-0082xr-9Q;
	Wed, 23 Apr 2025 16:15:14 +0100
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
Subject: [PATCH v3 05/17] KVM: arm64: nv: Move TLBI range decoding to a helper
Date: Wed, 23 Apr 2025 16:14:56 +0100
Message-Id: <20250423151508.2961768-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250423151508.2961768-1-maz@kernel.org>
References: <20250423151508.2961768-1-maz@kernel.org>
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


