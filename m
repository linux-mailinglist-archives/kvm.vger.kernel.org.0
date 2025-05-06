Return-Path: <kvm+bounces-45619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18769AACB45
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:44:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39AFD3BD2C9
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:44:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D53432857FF;
	Tue,  6 May 2025 16:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTFwxWv0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43752853F1;
	Tue,  6 May 2025 16:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549849; cv=none; b=AILoE/1d++5GjYhZvJW79ibm5XKoL7Tnouv+YwIGJmNFjhJpdRiSEOOtjCoeQp6F1fpD/4AkfoqO+By3J9Cx9JfqdFQSzkBKXFjrvDxm1w2BbrQd1Nssab2UzgCqYs8/vPfWsSxUOfYnEQA0r8hhKpGWYCjBq/uywFHKHul1xGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549849; c=relaxed/simple;
	bh=jJkIDne2hoOcyn91XOfMc176KV1oYdB63I9cuKD1rVA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oD+W784huskU+5CZFdHu08trpJ4W81BLO6rdw07N1ovGXLjicTznLZQtN9YnJIa2dDfk8lw92DjTrgmGsxm1LclfLYfVZLj3WS6KZmzwEq/o2q5it42d0Jw1X77ymUkzRyajs0J4ybPNmiVPzb76sURaT/aM9YQbLU9lfTclKU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bTFwxWv0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494D1C4CEF3;
	Tue,  6 May 2025 16:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549849;
	bh=jJkIDne2hoOcyn91XOfMc176KV1oYdB63I9cuKD1rVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTFwxWv0B2E+RPBVdqgncmqMCp93NF/Xbl9jtyZtptrQQVn2QI/l7A6higB6p+9/K
	 TRI8QR0FTtRO8Z4iwghRwx7eTRK8FYgQgqTYosSVR59iDPhEJcep80DMpacF99+MKY
	 oxy7pP4KLU2H1wz1hGi71fKoB3udW3+TbPB0p+7Tdu2xx7dU0a+FAcMj7FwScla425
	 fBy5W+73LjaywMBUqUIY42gZ8Y6owU57Q6N3f6bqvcIpFN6WX3wGiy+/cvPiyxRwTW
	 Y10owDuIEVhsRVjoejWjimV6A6AfFTxskJZwmbUK+JqmkA8tkLuYwInMC2JZbELzuy
	 eakochRwYEhRQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOp-00CJkN-3n;
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
Subject: [PATCH v4 05/43] arm64: sysreg: Update ID_AA64PFR0_EL1 description
Date: Tue,  6 May 2025 17:43:10 +0100
Message-Id: <20250506164348.346001-6-maz@kernel.org>
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

Add the missing RASv2 description.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 4c51d9a67b14d..6c64fd7d84951 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -907,6 +907,7 @@ UnsignedEnum	31:28	RAS
 	0b0000	NI
 	0b0001	IMP
 	0b0010	V1P1
+	0b0011	V2
 EndEnum
 UnsignedEnum	27:24	GIC
 	0b0000	NI
-- 
2.39.2


