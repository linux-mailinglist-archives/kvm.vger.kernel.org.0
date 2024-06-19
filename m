Return-Path: <kvm+bounces-20012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BCEFB90F55B
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 19:41:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD6601C22397
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 17:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E888156C5B;
	Wed, 19 Jun 2024 17:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TtwsZTr4"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04574157E84
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 17:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718818871; cv=none; b=tazoHJbbZL43Wz0y/qzlDFq8ZNbsYr7rimvHBD36uyOPP59doipxf0aBEwhhcYvaA6axrbD45MHXpAjkCNSbOZ/eoQxGEd5T7OXk6Pzwm6hFaYc073gwciC76UHaTjPtOffgDYy9w8EqVRnO8GnIymT12M+furteT0Ve/wSDke8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718818871; c=relaxed/simple;
	bh=qEE62H2HxrwyCPCdSlCshlrRlfwxiypo/Fr5nmHt2uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1/S6TMT76Tmd+bM5cAbOPu2zpN590H8+pxG4dSmfFsbBzN7dKsKpjuVaiUScmme/HxOgAWwMGMurs+NpMydEdnnXEbDNlpdOE3BC4YfdlKVjcTj1e/teeoF/vloq72ORjwSsHwlPD5nMRoytkc03EwdO2TuAgW4GvlsLiLynd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TtwsZTr4; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718818868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sX8qpen1KxCpCteXFkrqjE8myujo22x82+dwXsifNig=;
	b=TtwsZTr4W4Sf7knpQ7JW8ftiej1Sg4qtEJCruMiXkCuCzJQGi1DzSR3grBDdcBY39QqSnE
	xdRWFwYnckphzCtlZJYxkD933Vme1s25Cehk+t5g6NMMVVFXJ85cUWkulVfiTxezK+Fv1Q
	aUNAaFbfGj00D9YJJwnII7U3DHO1hMw=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: sebott@redhat.com
X-Envelope-To: shahuang@redhat.com
X-Envelope-To: eric.auger@redhat.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Sebastian Ott <sebott@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v5 09/10] KVM: arm64: rename functions for invariant sys regs
Date: Wed, 19 Jun 2024 17:40:35 +0000
Message-ID: <20240619174036.483943-10-oliver.upton@linux.dev>
In-Reply-To: <20240619174036.483943-1-oliver.upton@linux.dev>
References: <20240619174036.483943-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Sebastian Ott <sebott@redhat.com>

Invariant system id registers are populated with host values
at initialization time using their .reset function cb.

These are currently called get_* which is usually used by
the functions implementing the .get_user callback.

Change their function names to reset_* to reflect what they
are used for.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/sys_regs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d8d2a7880576..71a4ed58f94b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3720,8 +3720,8 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
  */
 
 #define FUNCTION_INVARIANT(reg)						\
-	static u64 get_##reg(struct kvm_vcpu *v,			\
-			      const struct sys_reg_desc *r)		\
+	static u64 reset_##reg(struct kvm_vcpu *v,			\
+			       const struct sys_reg_desc *r)		\
 	{								\
 		((struct sys_reg_desc *)r)->val = read_sysreg(reg);	\
 		return ((struct sys_reg_desc *)r)->val;			\
@@ -3733,9 +3733,9 @@ FUNCTION_INVARIANT(aidr_el1)
 
 /* ->val is filled in by kvm_sys_reg_table_init() */
 static struct sys_reg_desc invariant_sys_regs[] __ro_after_init = {
-	{ SYS_DESC(SYS_MIDR_EL1), NULL, get_midr_el1 },
-	{ SYS_DESC(SYS_REVIDR_EL1), NULL, get_revidr_el1 },
-	{ SYS_DESC(SYS_AIDR_EL1), NULL, get_aidr_el1 },
+	{ SYS_DESC(SYS_MIDR_EL1), NULL, reset_midr_el1 },
+	{ SYS_DESC(SYS_REVIDR_EL1), NULL, reset_revidr_el1 },
+	{ SYS_DESC(SYS_AIDR_EL1), NULL, reset_aidr_el1 },
 };
 
 static int get_invariant_sys_reg(u64 id, u64 __user *uaddr)
-- 
2.45.2.627.g7a2c4fd464-goog


