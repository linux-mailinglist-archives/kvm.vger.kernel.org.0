Return-Path: <kvm+bounces-45618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CD8DAACB47
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:44:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 455F91C073F1
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9582286401;
	Tue,  6 May 2025 16:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OxdX5f4k"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D932853FA;
	Tue,  6 May 2025 16:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549849; cv=none; b=tddjG/CZaEHAX0hdZyLYW96joVw/zPiXMvGPk9zZeZEFoIJNT7IL6SGh+niMQdtma9R4VUlx6CQw15HUyAhjuaj7Ce8cqtzjsgnLXeQflqc0aQy/MYGWvZz1drzLkwdcbxWHccoVYQvNxymbmzJHsgTJgPGEmICuowf1RngbYB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549849; c=relaxed/simple;
	bh=IC/sbdjlRxGlbPcYnZe6UUMLYD3r/rULHfthHQdque4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Fw/ztxan0wsQwYjN9eLx6mhLTk04DZNi50kr75x0rkOMjZfc/RybY9gUfMIm+fIA/QnlDrnlynLeTbMraikVgGinZrTvfeU+vNj/wjgiD0JQqw4oKb0N8Kci+IxASFNIRUQ1Z3DEfX2zHSa0dchFDBGGOgxgpWxxyJIhqaNPRzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OxdX5f4k; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A738CC4CEEB;
	Tue,  6 May 2025 16:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549849;
	bh=IC/sbdjlRxGlbPcYnZe6UUMLYD3r/rULHfthHQdque4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxdX5f4ky8jWFlVOBTx7zzZvzqYiNzKPZ48XKtdIggTLpA5CsWXJobe3WHOL3Y8r2
	 6/csPA5DvaqYa75pQ3mUy4BB5Be097i3OYf/4WHbmzCmWR3p+HqDtP+RdWJHSg6SFT
	 NAAn3DqoJjdm6X3el+gIwkl98CrbN55W0/KBoNNiTWSXeWZgFy7xFjfacvsKWkjZwM
	 6Ymd6kwE1NbTnjjDWWN7uwohSzcWjblPwWhxQt2kBcwpoH86THij0Uz8o4q+IViKus
	 ZMKILXY1hCS9q3JsI5T9oEv0oRVgaoUYVl096d15NoAV61ycjAqViF4Pnkynwz5MRx
	 MzBCBvDlXELsA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOp-00CJkN-QO;
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
Subject: [PATCH v4 08/43] arm64: sysreg: Update CPACR_EL1 description
Date: Tue,  6 May 2025 17:43:13 +0100
Message-Id: <20250506164348.346001-9-maz@kernel.org>
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

Add the couple of fields introduced with FEAT_NV2p1.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 10052d2eacdf7..bb92464fc9abf 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2069,7 +2069,9 @@ Field	0	M
 EndSysreg
 
 Sysreg	CPACR_EL1	3	0	1	0	2
-Res0	63:30
+Res0	63:32
+Field	31	TCPAC
+Field	30	TAM
 Field	29	E0POE
 Field	28	TTA
 Res0	27:26
-- 
2.39.2


