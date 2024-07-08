Return-Path: <kvm+bounces-21104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3997A92A5FC
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 17:45:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B79ECB21C31
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 15:45:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D010146A71;
	Mon,  8 Jul 2024 15:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EU7PGTxV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99B2144D25;
	Mon,  8 Jul 2024 15:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720453495; cv=none; b=c6P5SRPZLUlK0qbucPn5HJGbRhLwH9/VaPGrML7R1V/BbatGpgRpExTywSOEo+pB8JhcRsd7cy82PvFjWRCn6wJWzF1VH8RI5iQa+QjrvR5VYBzkc9YPuOK5Gdnx7zlrl6xCfWOLw+FtxQh5lXBPQRUbXBhcUOn8GrS8Bsz1OlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720453495; c=relaxed/simple;
	bh=TgBIaQlXHfAb7OU3eNgvMSbHhAj0/iNzDpujav5PLFM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W8JKJzDFeW4x43HrWgfUDjtrfv8OwN+LPAC4+vRXkjB3kf8Av2w4A+6Quj6bYIFf6GX/hK3rOBrHRjaxWCC5pCCxcezPBvrU0/XWV6n/ipvmPW/Stox0IUUXTzlrKeJA6WPvWsoBAcbN7CfQEXx/jtiZhuRJeG5b0Eam2nRkX8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EU7PGTxV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C793C4AF10;
	Mon,  8 Jul 2024 15:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720453495;
	bh=TgBIaQlXHfAb7OU3eNgvMSbHhAj0/iNzDpujav5PLFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EU7PGTxV4EvkB6ybPZ4lWM71Lfk3cDNCFW/ciUREVCufJGnkCIcEabcbnZSAGOf6w
	 28eXcF8ALvNLlLtdP7YeCEBkPXVKPbg6sX/MMPPLv21UBRLfMAJXLTSC9+SMQ0zZlh
	 QoeMiLkm4DI6Cx/I4kNRHkiwBW+6Tmt0uiSCrYxQDClfPBOVapia7wVtWrKB061A2i
	 B9ItxYKN9Pn5hFMhIaaYuoqlAbgu3WwC97Tr+3fHH1jXV0AxKt/elo+GET/a+/Z6xD
	 2/SpW8FZ3/khoPjsd0D9TqUnHVFwdRqpuks0U0Jy9s8YjJKlGi3Tq7OxdBoW6RyJSv
	 KksgZZzbaRLDQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sQqXt-00Ae1P-Fk;
	Mon, 08 Jul 2024 16:44:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5/7] KVM: arm64: Expose ID_AA64FPFR0_EL1 as a writable ID reg
Date: Mon,  8 Jul 2024 16:44:36 +0100
Message-Id: <20240708154438.1218186-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240708154438.1218186-1-maz@kernel.org>
References: <20240708154438.1218186-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

ID_AA64FPFR0_EL1 contains all sort of bits that contain a description
of which FP8 subfeatures are implemented.

We don't really care about them, so let's just expose that register
and allow userspace to disable subfeatures at will.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 326262abc2ff4..1157c38568e22 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2386,7 +2386,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
 	ID_HIDDEN(ID_AA64SMFR0_EL1),
 	ID_UNALLOCATED(4,6),
-	ID_UNALLOCATED(4,7),
+	ID_WRITABLE(ID_AA64FPFR0_EL1, ~ID_AA64FPFR0_EL1_RES0),
 
 	/* CRm=5 */
 	{ SYS_DESC(SYS_ID_AA64DFR0_EL1),
-- 
2.39.2


