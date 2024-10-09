Return-Path: <kvm+bounces-28317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6112A997539
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:01:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 175DF1F24D71
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:01:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 795661E282E;
	Wed,  9 Oct 2024 19:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ETtFdMKT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D122C1E1A30;
	Wed,  9 Oct 2024 19:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500443; cv=none; b=Y0ZFgYhChpcgAZABRYJ1Q5TwpE65b5aRUOYIFAwAaCCbXL4eQPPciGWKhuiF+fAgQfc6Z37Jz5srIjGsgO/jQAVKnvugAF2osAc+XBLPa9StMbEkHQrY8Yt5gqNn5JlP1QXOxGanXzQdXVUnGubV5lg/jS+SURKprLQsYoQdPMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500443; c=relaxed/simple;
	bh=EpMdlmm/jnve6UFHeWosHwxnjKpz/BqO3pApXnWcWx0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G5f1zfDeelnbVbk1b8pLWwRTWC0u6cxpwiBM70YSb3V5lKI3m/jHbCdGvDzuyP65AFH8bSFMpZMkLcEIcJTrI4OW0fg+qfTGAfb02J9lLFyfbkrYRDD0MCCRDaCjg9Z9W7pAOLWUWdk9qqHR3DNBrLehzNq+QD0hHTEIItXpnmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ETtFdMKT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7207AC4CED7;
	Wed,  9 Oct 2024 19:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500443;
	bh=EpMdlmm/jnve6UFHeWosHwxnjKpz/BqO3pApXnWcWx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ETtFdMKTLKFG9KGExmAz7X2P95shkh6moXPpPcSLghfNOqK7s5Mlb08gBlr+Fjyot
	 mGAdoruBYC0uCwfy46RlF1wNPdjGFgAcgtDbGuJWF3XSksvsp8Cyxw/N/ceynQZcuE
	 WMf9vcmjfNIP4RpCkF1Xg3QtFXF6lGCQrVrw594JSoD7Ga+LlWPz2euskgYnQ3osKP
	 N39KU9iq2VHA6cSk0GhnBU7gwjMIU8cXuF1WMSe5qYYR/f0IyE1qKo95sZSZqJTm0w
	 6VI1xpx20naGwO+mG4ltAra0XCQ3xV5UyHfMbqE6IDqdvuiNDsWWUymnIQwjSYEfGK
	 zNp67HXpc9/9w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvN-001wcY-JZ;
	Wed, 09 Oct 2024 20:00:41 +0100
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
Subject: [PATCH v4 05/36] KVM: arm64: nv: Add missing EL2->EL1 mappings in get_el2_to_el1_mapping()
Date: Wed,  9 Oct 2024 19:59:48 +0100
Message-Id: <20241009190019.3222687-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241009190019.3222687-1-maz@kernel.org>
References: <20241009190019.3222687-1-maz@kernel.org>
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

As KVM has grown a bunch of new system register for NV, it appears
that we are missing them in the get_el2_to_el1_mapping() list.

Most of them are not crucial as they don't tend to be accessed via
vcpu_read_sys_reg() and vcpu_write_sys_reg().

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dad88e31f9537..3cd54656a8e2f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -110,6 +110,14 @@ static bool get_el2_to_el1_mapping(unsigned int reg,
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
@@ -130,6 +138,7 @@ static bool get_el2_to_el1_mapping(unsigned int reg,
 		MAPPED_EL2_SYSREG(ELR_EL2,     ELR_EL1,	    NULL	     );
 		MAPPED_EL2_SYSREG(SPSR_EL2,    SPSR_EL1,    NULL	     );
 		MAPPED_EL2_SYSREG(ZCR_EL2,     ZCR_EL1,     NULL	     );
+		MAPPED_EL2_SYSREG(CONTEXTIDR_EL2, CONTEXTIDR_EL1, NULL	     );
 	default:
 		return false;
 	}
-- 
2.39.2


