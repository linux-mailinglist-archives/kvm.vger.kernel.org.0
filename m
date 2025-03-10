Return-Path: <kvm+bounces-40619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 505E8A59437
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:25:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8872D3A9649
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 12:25:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 587E7227599;
	Mon, 10 Mar 2025 12:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PYm8l0UQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A26223714;
	Mon, 10 Mar 2025 12:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741609512; cv=none; b=P3i3dnk7wkW3vg35FdCx294asPxknEV4chklu+0fX4bdS8j9HPOF+Un/zbopsdUi7Ss9kLDotTHK9+f11CVBzDcBxLPr64ZZD9jS/XciWREkDJyu/1RjgYtzs8UBVskUQ8ya+2lDcOwUQlqOFPFKlkTLVYOJi50UJmnIyBGO6Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741609512; c=relaxed/simple;
	bh=mwzvC1hwjzZ73H1jse2BNgJhdi0FIYrJ/BY6AQtHATU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I6Ira+a3D7EjTdfcI5Zqdo7gQnP29ZUlG2minfWxQ6X7IZG6pPsgqiKY0gegCbPd1Dj8d87qmAQ6dDeriFvcKt+zzQUMB8ARettDy5N6SK5IZK/wEno+aBxJsQ7GvtKdvCCqUIZd9ano1vNpgLbstlLdpgJSUSAq63Zk5Me4yDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PYm8l0UQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066D4C4CEEA;
	Mon, 10 Mar 2025 12:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741609512;
	bh=mwzvC1hwjzZ73H1jse2BNgJhdi0FIYrJ/BY6AQtHATU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYm8l0UQRA6eCOQ/yFWvKZILvuW0HqxFUO/zFKpB5nRU81MMfQVS3GlSQLTQR+/EG
	 HHy+BWoiitNiG7xkqE1gHOb8BvHbRXh+6efw93kdCHvpi2FNlwXWtH70ONuIxPhMd4
	 0rvsXmXc84BHSDat9CHziPwu7i6Hn5NGT+AF+EUZgEAgJIS3nClEaFdqyTO6/Xudaz
	 Ju8TIXRllXhzGdD9sezImduJWBTLb8CInAhZY5Xigx9hk+u7Xr450xSgmORoB+nTzK
	 lhKwx67YMiow45H2qRAKCingJevdOi843+SMj5YLFog87CFaXbwDe5v+6d/IF3PntM
	 vtvJWuEntVN5Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1trcBy-00CAea-0b;
	Mon, 10 Mar 2025 12:25:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 01/23] arm64: sysreg: Add ID_AA64ISAR1_EL1.LS64 encoding for FEAT_LS64WB
Date: Mon, 10 Mar 2025 12:24:43 +0000
Message-Id: <20250310122505.2857610-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250310122505.2857610-1-maz@kernel.org>
References: <20250310122505.2857610-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The 2024 extensions are adding yet another variant of LS64
(aptly named FEAT_LS64WB) supporting LS64 accesses to write-back
memory, as well as 32 byte single-copy atomic accesses using pairs
of FP registers.

Add the relevant encoding to ID_AA64ISAR1_EL1.LS64.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 762ee084b37c5..8c4229b34840f 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1466,6 +1466,7 @@ UnsignedEnum	63:60	LS64
 	0b0001	LS64
 	0b0010	LS64_V
 	0b0011	LS64_ACCDATA
+	0b0100	LS64WB
 EndEnum
 UnsignedEnum	59:56	XS
 	0b0000	NI
-- 
2.39.2


