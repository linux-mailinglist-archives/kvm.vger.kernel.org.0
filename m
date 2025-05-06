Return-Path: <kvm+bounces-45620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A13B3AACB46
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:44:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B6DC67AC72C
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D085A2857FD;
	Tue,  6 May 2025 16:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hI34H/Oz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35DB2853FC;
	Tue,  6 May 2025 16:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549849; cv=none; b=Kcl9oBZZH7/HAwSbBEJReLr/LykQuMo1Xs2xPfo2GFoQVoPqNXH9vdb3xPle1hE4mzugqXy3jMWGeEhRuTLlS+kP8dYY0PfYbNXZZ7VR1jV0pjRRYElog84u050vp2z9AURxG5zeJXhS2AXv9BQAuvfETD/1wdDpSGacKfkodvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549849; c=relaxed/simple;
	bh=DLdRGSDVjuu7YR3c64XHblWDklv45C0aSRJf6NI0fX4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qhZtkqjpJ0iSfBAP/TkdKydUNG47b+ecewSZw2GTM2GSmMo86cl9hUWp8yDe7bzhE2w2f3Tq1Ad4HUSvrZz1uutQAC4KyT/gMuXeMZoOec7AhR/NmK8/TqcTXOdX+qtsIviZV6RNsw13CDZhg64XmASkF+4PQh3ifPWvHjEP5tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hI34H/Oz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD8CC4CEF6;
	Tue,  6 May 2025 16:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549849;
	bh=DLdRGSDVjuu7YR3c64XHblWDklv45C0aSRJf6NI0fX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hI34H/Ozjz+y4aCAsC5QuH9H5TghVoz3ZTkJQcLV5Z8iYFmUXKhIGHaABkxqxIfzx
	 h8UpWdaoPqfs48eeu7GXuRloPsbnMWelXgoc6HP8X6l9UBYvPHGnlDPeI/CWNaRktl
	 zH1B3JP8ox1S9dclBMMFqjlynQ/reSXRIvq1ctwHcCKNl7m46ARTAL3cIohYPJOrbY
	 67jRq8Q20Hwba67YqVvBPO4BIv6V3BtIEdir2GzEbGRqXnJhUypZk8VUFKVUqVl1hw
	 gPotTaVL/FIx67G2vyOtc7fR5pLPkaTMBepQfKgcnmn35i8kAoHfVHcObKXWCAnn5V
	 w8cEEH24bFK9Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOp-00CJkN-Hw;
	Tue, 06 May 2025 17:44:07 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v4 07/43] arm64: sysreg: Update TRBIDR_EL1 description
Date: Tue,  6 May 2025 17:43:12 +0100
Message-Id: <20250506164348.346001-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506164348.346001-1-maz@kernel.org>
References: <20250506164348.346001-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the missing MPAM field.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index dbb96e15198aa..10052d2eacdf7 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3688,7 +3688,12 @@ Field	31:0	TRG
 EndSysreg
 
 Sysreg	TRBIDR_EL1	3	0	9	11	7
-Res0	63:12
+Res0	63:16
+UnsignedEnum	15:12	MPAM
+	0b0000	NI
+	0b0001	DEFAULT
+	0b0010	IMP
+EndEnum
 Enum	11:8	EA
 	0b0000	NON_DESC
 	0b0001	IGNORE
-- 
2.39.2


