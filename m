Return-Path: <kvm+bounces-62461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B01BC44443
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:21:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 526403B76D8
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:19:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EB3F311944;
	Sun,  9 Nov 2025 17:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JYTp1I1+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FB93101C4;
	Sun,  9 Nov 2025 17:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708599; cv=none; b=OHYSeFI1JRY4NC2yr7Xh290eZh9frtiadeRANCo9UU3tyd4Sjy41c9l2sD2yA34a6Ty+UEsmy8GjPcSYYaDSaL2GFoktUw0QZ5mksyYyk/YyvQj6Ie6dR7/q9VHcEv2BPpl/Be4t9O9yOGlbzS8KOqUhGaQrvrPHPl0WZ1eNYpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708599; c=relaxed/simple;
	bh=iGc9naSe/W6LWnKd6eu1yOG495ylzvyawIHdCwK7HB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttleFduM7UMlTAskfxNssKkb8eSWQ43VVYXrzeHJKN2F5PxkI+zb/FWbwkHxgMKzxOdqjNh3HVtNw4lZHIzMdqi/ypnLyATtTcnUSHxuH1hfxggp79kbTBhxY3bwZrHjun0WRZYhLIYZwV7qGYvq86y6W/LNr/Mm9qcAuL/btho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JYTp1I1+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D57AC4CEF8;
	Sun,  9 Nov 2025 17:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708599;
	bh=iGc9naSe/W6LWnKd6eu1yOG495ylzvyawIHdCwK7HB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYTp1I1+qCYFHPefGoYgIQcTanJlSvxbN+tL3OzL26Q/eUBQ2NZbBLhJRb9q7ndwQ
	 aPwkizyTInqDVoWID2Za1cr9Zz7vEyIK5I9Mxre+IL0oi90k318uijwf6uf2cLzrsn
	 d3TqNAA24+5jOOpLF7K2hyV73lariLFwVrBhBrmxH43WoGo+TYCfh8Nx3t/IKzmhO0
	 s3pi46NsvrlyAqZ06X/rj5L9NpKlFqH+abSCmLBgs4OM3QAHRvWqiyWB6TFO+dtB+u
	 xqBmCSC+9J+U2nc7WCWKMWtKyqXysyeSc2vL57X54yVq68irf409KaK9jROeccLuoW
	 ULup9dhwxpgHw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91p-00000003exw-1Pl1;
	Sun, 09 Nov 2025 17:16:37 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v2 38/45] KVM: arm64: selftests: vgic_irq: Fix GUEST_ASSERT_IAR_EMPTY() helper
Date: Sun,  9 Nov 2025 17:16:12 +0000
Message-ID: <20251109171619.1507205-39-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251109171619.1507205-1-maz@kernel.org>
References: <20251109171619.1507205-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

No, 0 is not a spurious INTID. Never been, never was.

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


