Return-Path: <kvm+bounces-29550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F6ED9ACDFA
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:04:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 93CACB22B9E
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2186A209684;
	Wed, 23 Oct 2024 14:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jxSBUsKh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C01920721E;
	Wed, 23 Oct 2024 14:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695237; cv=none; b=QicS6SbaGnUzJez+evCpA8K5GWw2PUxIrLqcFe04GHntHxfyQzyku310cQpp+czsdFv/Mq7v/DyZf48kckQvsHW2swvGawtLg0GzU0TI5XqejmL8cNQ4qRbbiRTEcQrXP0hIgPFZ6wZizJxk1IGiTiwssQdj7xcqjXEQOZfspSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695237; c=relaxed/simple;
	bh=WLG6aiuNN/mgMCljFrWmlIWIhDcWjA7d1uKxmA7beSk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NAT+n3eow1M3sLJ3XGavkegdBs9rnD+5td2gJ3ghj7Bzfgve1qDPZMMO8hw+rLtFAAddi0Dkh6itaiIcRtsE2RprUSJ+f6/wZvZ/ri3qnQVup4HZrreQqShb3i/xAKxfYzTiuPrGbdytKcRDqHA8EdhmiblTM3teu8fCU47WVNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jxSBUsKh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19687C4CECD;
	Wed, 23 Oct 2024 14:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695237;
	bh=WLG6aiuNN/mgMCljFrWmlIWIhDcWjA7d1uKxmA7beSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jxSBUsKh7hQVSFN64yE9/XErRIOD7J8rX8fQpHiQcTIfzofjYLphnHiHIqFUZkaBK
	 5teXi/vyU0SNqJYTUh3MTsMhzy0Yxijzt1qU81NDzUvBt0KgUQu4Vh879e9Pj9IldJ
	 53pxMLK/2uRzAGzINlLJpOX0HohmzkRZAyK8AqC8HM5THbNtXnnGyPLNYLtgg0eDnP
	 MD4P1cAb88DPyG/lA4Avu0xq7M78m2fnCPAy470YO3WyeLRTY9fnvdoR/wnN7UDdLD
	 7ek5r+q4xQBODox1Z8nCP+Q8XVkW/8gPpbD3O05+6K7WVWIqK32KJpVt6IT6deQBwg
	 fUpdVAS3g6bNw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckF-0068vz-AJ;
	Wed, 23 Oct 2024 15:53:55 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v5 28/37] KVM: arm64: Drop bogus CPTR_EL2.E0POE trap routing
Date: Wed, 23 Oct 2024 15:53:36 +0100
Message-Id: <20241023145345.1613824-29-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241023145345.1613824-1-maz@kernel.org>
References: <20241023145345.1613824-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It took me some time to realise it, but CPTR_EL2.E0POE does not
apply to a guest, only to EL0 when InHost(). And when InHost(),
CPCR_EL2 is mapped to CPACR_EL1, maning that the E0POE bit naturally
takes effect without any trap.

To sum it up, this trap bit is better left ignored, we will never
have to hanedle it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 05b6435d02a97..ddcbaa983de36 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -79,7 +79,6 @@ enum cgt_group_id {
 	CGT_MDCR_E2TB,
 	CGT_MDCR_TDCC,
 
-	CGT_CPACR_E0POE,
 	CGT_CPTR_TAM,
 	CGT_CPTR_TCPAC,
 
@@ -362,12 +361,6 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.mask		= MDCR_EL2_TDCC,
 		.behaviour	= BEHAVE_FORWARD_ANY,
 	},
-	[CGT_CPACR_E0POE] = {
-		.index		= CPTR_EL2,
-		.value		= CPACR_ELx_E0POE,
-		.mask		= CPACR_ELx_E0POE,
-		.behaviour	= BEHAVE_FORWARD_ANY,
-	},
 	[CGT_CPTR_TAM] = {
 		.index		= CPTR_EL2,
 		.value		= CPTR_EL2_TAM,
@@ -1141,7 +1134,6 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_AMEVTYPER1_EL0(13),	CGT_CPTR_TAM),
 	SR_TRAP(SYS_AMEVTYPER1_EL0(14),	CGT_CPTR_TAM),
 	SR_TRAP(SYS_AMEVTYPER1_EL0(15),	CGT_CPTR_TAM),
-	SR_TRAP(SYS_POR_EL0,		CGT_CPACR_E0POE),
 	/* op0=2, op1=1, and CRn<0b1000 */
 	SR_RANGE_TRAP(sys_reg(2, 1, 0, 0, 0),
 		      sys_reg(2, 1, 7, 15, 7), CGT_CPTR_TTA),
-- 
2.39.2


