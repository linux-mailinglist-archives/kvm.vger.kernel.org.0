Return-Path: <kvm+bounces-63958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D7663C75B96
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:37:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 34D17365744
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AED03AA1B0;
	Thu, 20 Nov 2025 17:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jrV82tA4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179F936C0D6;
	Thu, 20 Nov 2025 17:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659567; cv=none; b=Epgb+8XbeGM91hiz13IrJhXtOqiTZGX7pWPzVVMwo6y4TFatXsOY+WltBQbnnO58gQdb0Jd4YWPHl6PceuERVHHj5cNsOT+gRVt0dBPflPMqHAyPHNCDsBY4OMnT2q+pp2ZK94AnrL789SEANK2n1GrGBUD04Lv6MAYbwy+W40U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659567; c=relaxed/simple;
	bh=zyiuKsX0B5115ZMKFeZ/41Mad50/Irl/nrXEi1lLsNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwByhN1hBn4H9k1EAiO4jS7SqhCVJqQlaE+VIhtlb9vFYsbrT/toBw8OM5Gl91PQeC1ExgpoW9Wg3t8zq9wwxQ1j0/oWxen+3j8Pm3JYiJicjY48TnOjktYTZr+298XCqGxi7kvn10kxfzBhufRTqyKH9hp2HdhPwQSTG8ybVMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jrV82tA4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A4CC16AAE;
	Thu, 20 Nov 2025 17:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659566;
	bh=zyiuKsX0B5115ZMKFeZ/41Mad50/Irl/nrXEi1lLsNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrV82tA4ypohoESETfkh78HNWHFpDfHQGfJ87pxkdtoXq4jaIsWAaX0KTi7NLPXM6
	 jHD00WJpBKHSAl0GfzFAOP45iXQ6taJQqZFSzoS9fdyFffF2S4u0RSgdb4NotKlEt4
	 QsTzq3+7gTcqWc3KFMclbuLdJDCRMSwYLnQIEggNKMemkNur37uzkn7eOht1gmHO0Y
	 Es06VPYa9BHlFEF3W3Gpd4KmKyzKUhsYZSoTpfhi4v8io0RM6L5uf2Qsv7j4HzexuZ
	 s0UmSEXfkLHDsdX6unvUW+zIHTC/RpFgrH1oYtgKWhIyeY3k+UlFwsMIDcodmw7dDO
	 QYZ7P91L+c4KQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Q0-00000006y6g-3Y8o;
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
Subject: [PATCH v4 43/49] KVM: arm64: selftests: vgic_irq: Change configuration before enabling interrupt
Date: Thu, 20 Nov 2025 17:25:33 +0000
Message-ID: <20251120172540.2267180-44-maz@kernel.org>
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

The architecture is pretty clear that changing the configuration of
an enable interrupt is not OK. It doesn't really matter here, but
doing the right thing is not more expensive.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/arm64/vgic_irq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_irq.c b/tools/testing/selftests/kvm/arm64/vgic_irq.c
index a77562b2976ae..a8919ef3cea2e 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_irq.c
@@ -473,12 +473,12 @@ static void guest_code(struct test_args *args)
 
 	gic_init(GIC_V3, 1);
 
-	for (i = 0; i < nr_irqs; i++)
-		gic_irq_enable(i);
-
 	for (i = MIN_SPI; i < nr_irqs; i++)
 		gic_irq_set_config(i, !level_sensitive);
 
+	for (i = 0; i < nr_irqs; i++)
+		gic_irq_enable(i);
+
 	gic_set_eoi_split(args->eoi_split);
 
 	reset_priorities(args);
-- 
2.47.3


