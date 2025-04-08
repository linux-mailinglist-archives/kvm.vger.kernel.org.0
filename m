Return-Path: <kvm+bounces-42905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FFFEA7FD63
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 13:02:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07C2E424E04
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 10:56:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0DF426F445;
	Tue,  8 Apr 2025 10:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="prWNdZwG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1916D26983B;
	Tue,  8 Apr 2025 10:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109560; cv=none; b=jN0t2JVxE8BrdCklgaHDNiLGZSnOMuMPIL5mwPJZpTX3m0O8mg90ZR8O0KV26iKdE7MrVoV7XmNzuJMm01Xa5Qyq4aXvqlofIluwXtxy/2fXV9gWIFW40C7WpA/BOqZjFOrC9J+KdNKwk5oAQ2705W07FZPbUDq5O4YcalulvtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109560; c=relaxed/simple;
	bh=8+XdFyrg3jdFCFbcepfTStu3SnK+HZn4Io5Q3v/8QsQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UZ6sKhB2rOW1DxycUri5nEni5KumZ3TBB4WzcRv+JTgTIEFLHk4bV/lB/P7WG9ZnC4k7ZVEBh5jKSYSxw4VcOAMDV8oaJh3+5VwCsA8ghTdujC0e3Em4ntOp9DQxN7yXyZrbm/IXXrg5b/SQHKCp5cyM3wphOeZTQmDptzK1gTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=prWNdZwG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F77C4CEEE;
	Tue,  8 Apr 2025 10:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744109559;
	bh=8+XdFyrg3jdFCFbcepfTStu3SnK+HZn4Io5Q3v/8QsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prWNdZwGLMmLoaEiVn3nCmRUDVoQH2jUYhlgxpkx/pNHurzvqlCdOHgSHrTNvuyCj
	 qbqjUtz6WTO/+xZOcR6P0Zor83uDJdVR9GAZ17dOHKAaYNEbM4fKJgB0f8ve8dumrA
	 b51T9n7HpYXcNQEysPoBLvx6ulhBkEtCCn34VJdr0uFkt4V9biYfXA52EFcFfrw5Rb
	 49i9Pkjc+BDCt8DhAdE+oHBjkxZxYFofyQ2UJ+UmJoBT8uu7AjYuEQxq9By+yaxn2U
	 gk+LpHdw80PLpxVeUlx5o6ThirvBvIdJao0qs9Hpjj8b07+thJNPGvqfggOI7Sr2e6
	 YFkfuk+esB3AQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u26ZK-003QX2-0c;
	Tue, 08 Apr 2025 11:52:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 05/17] KVM: arm64: nv: Move TLBI range decoding to a helper
Date: Tue,  8 Apr 2025 11:52:13 +0100
Message-Id: <20250408105225.4002637-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250408105225.4002637-1-maz@kernel.org>
References: <20250408105225.4002637-1-maz@kernel.org>
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


