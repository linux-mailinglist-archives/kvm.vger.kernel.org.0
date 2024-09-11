Return-Path: <kvm+bounces-26513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4051D9754A8
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:54:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA8291F278BC
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:54:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA7D81A3A85;
	Wed, 11 Sep 2024 13:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iT/RSc+z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0622C19E963;
	Wed, 11 Sep 2024 13:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062719; cv=none; b=FbJqf9PPn3kjRWWYOvCNl2nsBrrYqfCsxFxMAKV17rXZDjy1rAaqm9P3UTZ3g+CBucX2rL2wFYrYPhfDnzodKZbUNK72xQnIq4gcfGx2gHLqntJDJzsCXzLs1VZe/y3fcAn2Mf9dMQsbgkMtNdeP+XGMYTC1/xsZOPmmGY1TLiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062719; c=relaxed/simple;
	bh=vBcgrNUTs+DW/BFJA4olVE/S2NNia6ZOy16359zpk1I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HV4pIkV0A2PgzACm8dplVBG+vdlGgcc5lDZBUCLg209CPxRPmPAT2E6UCFQ25EZQIUbvqr4SB+XYia6u7DmzyUqP1Tk0gwxagzmc7halxaC1LIHN/Sf3Iu7PQ1QrFNB80znBbQghS4OsB6tA52rwLDXYSQakP4/H+yq0gDn2J1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iT/RSc+z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24E2C4CECF;
	Wed, 11 Sep 2024 13:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726062718;
	bh=vBcgrNUTs+DW/BFJA4olVE/S2NNia6ZOy16359zpk1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iT/RSc+zV1ejg1T37Mca4WH5kYBA/Hc7AQVAFsu64pWisBznUQ9VC/Sbvl49q/7K5
	 bxfJ1qg7gLqLzALErNNkO4Us0laVkFpDYeH4n4wCCbjLk1Z4bdRmOXQrrDnQlCopMw
	 m8ZM48W8XlHvfM/R5Du5MdQ3t925cpu1GE7HI2PSoXz8OaFUkrhA6O2AyCxq39VLOe
	 iLmOyzbQMhCr/NejUMNlC+JccF8i0fB3Cu7ZxTAf6ujIG0H+nLt2RVfoz1e0jRWoKO
	 y39+urZq15kS8w6QNCrQkVIs0dPGngsLG26lDaKeHNdNCULEgRn0FjjQHXGCCuShuL
	 eA4FNQKz0FG5Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1soNlF-00C7tL-2K;
	Wed, 11 Sep 2024 14:51:57 +0100
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
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 04/24] KVM: arm64: nv: Add missing EL2->EL1 mappings in get_el2_to_el1_mapping()
Date: Wed, 11 Sep 2024 14:51:31 +0100
Message-Id: <20240911135151.401193-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240911135151.401193-1-maz@kernel.org>
References: <20240911135151.401193-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As KVM has grown a bunch of new system register for NV, it appears
that we are missing them in the get_el2_to_el1_mapping() list.

Most of them are not crucial as they don't tend to be accessed via
vcpu_read_sys_reg() and vcpu_write_sys_reg().

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5ab0b27993936..46db7988d1b50 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -102,6 +102,14 @@ static bool get_el2_to_el1_mapping(unsigned int reg,
 		PURE_EL2_SYSREG(  RVBAR_EL2	);
 		PURE_EL2_SYSREG(  TPIDR_EL2	);
 		PURE_EL2_SYSREG(  HPFAR_EL2	);
+		PURE_EL2_SYSREG(  HCRX_EL2	);
+		PURE_EL2_SYSREG(  HFGRTR_EL2	);
+		PURE_EL2_SYSREG(  HFGWTR_EL2	);
+		PURE_EL2_SYSREG(  HFGITR_EL2	);
+		PURE_EL2_SYSREG(  HDFGRTR_EL2	);
+		PURE_EL2_SYSREG(  HDFGWTR_EL2	);
+		PURE_EL2_SYSREG(  HAFGRTR_EL2	);
+		PURE_EL2_SYSREG(  CNTVOFF_EL2	);
 		PURE_EL2_SYSREG(  CNTHCTL_EL2	);
 		MAPPED_EL2_SYSREG(SCTLR_EL2,   SCTLR_EL1,
 				  translate_sctlr_el2_to_sctlr_el1	     );
@@ -122,6 +130,7 @@ static bool get_el2_to_el1_mapping(unsigned int reg,
 		MAPPED_EL2_SYSREG(ELR_EL2,     ELR_EL1,	    NULL	     );
 		MAPPED_EL2_SYSREG(SPSR_EL2,    SPSR_EL1,    NULL	     );
 		MAPPED_EL2_SYSREG(ZCR_EL2,     ZCR_EL1,     NULL	     );
+		MAPPED_EL2_SYSREG(CONTEXTIDR_EL2, CONTEXTIDR_EL1, NULL	     );
 	default:
 		return false;
 	}
-- 
2.39.2


