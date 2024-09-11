Return-Path: <kvm+bounces-26514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D70559754A9
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:54:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 162501C22F31
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:54:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA8C51A3A87;
	Wed, 11 Sep 2024 13:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hjhrCuSD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FA01A264B;
	Wed, 11 Sep 2024 13:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062719; cv=none; b=UCPnR4J8TZG9UWuIeRidIdpeVx2so0r9QqcOn0qjUk2tvxy5P/+JwCRjonNLEGSIy5MRA3uH4UOF9oDCO+SXqt7p//Hqg4askt+R7lNCwRHbaTdqGLkp1fsIdUmJFlS5pcMMGMZpd9haHgVjB8LPoBD9p8EZaIjdae4LxK9MCEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062719; c=relaxed/simple;
	bh=k8KPgOAvxgo0liwV0NdHjTyRjPyRBrre7BS0OvWG+lc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qXReHyA5ht/QQtSIsWxhOdrzL9nfMQ0/0ovfByRY0ixPtns/zC2gPx9uNXfnmb3yhqhTIQldjeCroJDpJmHDFnRcsbHnFYV9ainYO90mGREV3lH8fUIN6iOvvtf0Yaj6rnowMeLV1zsOTghYEhJauefLSZyje26TffZyQBA/GZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hjhrCuSD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79F8C4CED0;
	Wed, 11 Sep 2024 13:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726062718;
	bh=k8KPgOAvxgo0liwV0NdHjTyRjPyRBrre7BS0OvWG+lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjhrCuSD5I7X3LZHAO1HxT7vE41ZpAePOc9VUImQ526ozS0FgAszWC5iHz0/pEBOY
	 1CO7/VEDZTOj8hqxbcpN3wMZfof/LrthN+iYybyYLFdQ41IyHVIE4dSJK0Nfn4COZV
	 ZZt0XaHzN42BF6eqklstvIL7uik9O94IWPIdNCj4D6NDFThJZWXeJCliiKamEE2Dbp
	 5tc/JC8gl1yW0n1MesgT3X+0CIznARHKklyHY3WmHAx+jUEM7mvcu/HmwnyyOiR00H
	 bUEhAqaYq8okExRw99DKL3rDY60QwFuTE3Ff0vbCHlmU/lyA9adiGhQ26+aY8DdyzD
	 Txo29g7OZppSg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1soNlE-00C7tL-SE;
	Wed, 11 Sep 2024 14:51:56 +0100
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
Subject: [PATCH v3 03/24] arm64: Add encoding for PIRE0_EL2
Date: Wed, 11 Sep 2024 14:51:30 +0100
Message-Id: <20240911135151.401193-4-maz@kernel.org>
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

PIRE0_EL2 is the equivalent of PIRE0_EL1 for the EL2&0 translation
regime, and it is sorely missing from the sysreg file.

Add the sucker.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 27c71fe3952f1..d80859565547e 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2852,6 +2852,10 @@ Sysreg	PIRE0_EL12	3	5	10	2	2
 Fields	PIRx_ELx
 EndSysreg
 
+Sysreg	PIRE0_EL2	3	4	10	2	2
+Fields	PIRx_ELx
+EndSysreg
+
 Sysreg	PIR_EL1		3	0	10	2	3
 Fields	PIRx_ELx
 EndSysreg
-- 
2.39.2


