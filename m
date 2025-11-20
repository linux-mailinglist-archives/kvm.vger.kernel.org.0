Return-Path: <kvm+bounces-63957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AD94FC75BC9
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:39:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EB49E4E828E
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0446D3AA1AC;
	Thu, 20 Nov 2025 17:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H13RLatv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25A43A9C05;
	Thu, 20 Nov 2025 17:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659566; cv=none; b=sIpRBuCqNoacZbdPpH++oWM0s+VB5s/8c2B7jeO00MzqWts8WTeLni8494hWjS6UfpLxOSTOYPSTpJSNOPgxeUpA0Wxpy/seCQEmZ01VNBdp46E92Qo+VPfjltOc2TKgC/1uMaZ6r9j+yvgyFJCoQvbHHSNG3bGqS9PTTd4ch14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659566; c=relaxed/simple;
	bh=I9ccNvnN5tYXZEamHv0x3EQ8Z2CyyHc1QdPzU7e5cnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AL5g2imDpaqgquHyUJFbxG07ewO2O3umG0BrD2elJ+ku2h2UCFVZjnLn8EfN9KUaCksogiIq8GIxnyd7Lz2uA/lyys5c7tydY2Mwryi0NSz1KCf3YrEkQiecNQj4WQgLL7JPp9bz2xQsNE/WI+bYpnQByyyESyLAfImf1s7nAuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H13RLatv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C336C116C6;
	Thu, 20 Nov 2025 17:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659566;
	bh=I9ccNvnN5tYXZEamHv0x3EQ8Z2CyyHc1QdPzU7e5cnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H13RLatvl4ppCYaoGGLVZJf1mrpCf6fRJrwTemH7l7RFusqiWyANCV2Kq9ZFdvZXZ
	 NLH4CdG4dqRfoLdSyksgsZu7nxjJgjgGjMRVMKHWtYGEun7exyKFv3pfLAfIH7JQyF
	 /+kLo4XPPzUGY5lqQr+Tl8Izdl9m5ieOszLl/S/Z/6SLy3xceWol86YmeFzeqISp/b
	 UZBtk3HhScbEo2A2xk4bAuLFYULAtn91Cwho/FENa5g6txDY8DJ7ejzGnE3Bkiu5e4
	 /gdlPnM1aHKJfYU+LrXGyQvh15FNQdBSc6jn0TG0HODrG0Zo4Ql1nEOrBGybLvmEQi
	 JCooQJCyCni5A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Q0-00000006y6g-2Iu4;
	Thu, 20 Nov 2025 17:26:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 42/49] KVM: arm64: selftests: vgic_irq: Fix GUEST_ASSERT_IAR_EMPTY() helper
Date: Thu, 20 Nov 2025 17:25:32 +0000
Message-ID: <20251120172540.2267180-43-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120172540.2267180-1-maz@kernel.org>
References: <20251120172540.2267180-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, tabba@google.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

No, 0 is not a spurious INTID. Never been, never was.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/arm64/vgic_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index 6338f5bbdb705..a77562b2976ae 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -205,7 +205,7 @@ static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t first_intid,
 do { 										\
 	uint32_t _intid;							\
 	_intid = gic_get_and_ack_irq();						\
-	GUEST_ASSERT(_intid == 0 || _intid == IAR_SPURIOUS);			\
+	GUEST_ASSERT(_intid == IAR_SPURIOUS);					\
 } while (0)
 
 #define CAT_HELPER(a, b) a ## b
-- 
2.47.3


