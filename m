Return-Path: <kvm+bounces-62462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 08888C4441C
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:20:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8DFDC4E9A58
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30DF9311C3B;
	Sun,  9 Nov 2025 17:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GEuyR9z+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455133112C2;
	Sun,  9 Nov 2025 17:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708600; cv=none; b=HqYTd4x/JpJU7XA0voHNCeDDozJPepg3TyG0B4S15IhKsNlsFQzr+0jryJP4afxVSIi75zuwelCnvPS9Xm+HrIi4KPNDjuq+u/KAu/XIRunDKo04gao3PeFRN6n5T6Kjj5DMTRdE05vK9N41TT0lVihUeg5KX0Xmb41eA3lEN6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708600; c=relaxed/simple;
	bh=oSBIMloc8H591LJEnbKibdMezp20+CUZWrhZ4NkCxts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ha3hv/BfGhV8YJiqjgHRyCRL12yzWC09ZqFvB3cxLakMiIYXc5zvxfWV7NNT3I4HpbDVvRY8b0ZE1hBFYpGH1RSqQj+IySiaGFRfGRH01te1oXpwZJ8S92AE8ZwxOpsGFvpm4HrMFhgvDdDTSVUrLm+NxCeLYqFe0aa5K5vphyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GEuyR9z+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C287EC4CEF8;
	Sun,  9 Nov 2025 17:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708599;
	bh=oSBIMloc8H591LJEnbKibdMezp20+CUZWrhZ4NkCxts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEuyR9z+W0YvXdcXwiJTeMwta3kMTLi/LmOa9JeF7AI6tHlcIjwXcqAd8MBVmtPPh
	 q3Lohw/KQflxCkuRgMp8bhDIxNEWT31Kcha0cUYkr91pKjtYf/YvOa24OZOgUoxSjO
	 IuaHjXP8lJdtlYPcRQSS/iwoptXxkOltL9FNzy7R5qYUo+HigVGfUNLE8eb2NJIgxB
	 0UbgNPFCT4DO1L31hFBDkKGHilNQmoig2CJrWx5SPM0qbLCXndRL1DrFDimpVZKFWS
	 YrYDKXWagwd2vExf1gVgPp6dzDMb/hpWLxRdmXKEE2yWKvGIC339knPgq2DneFG7fq
	 reb9Rtm+TMuXg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91p-00000003exw-3oXS;
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
Subject: [PATCH v2 39/45] KVM: arm64: selftests: vgic_irq: Change configuration before enabling interrupt
Date: Sun,  9 Nov 2025 17:16:13 +0000
Message-ID: <20251109171619.1507205-40-maz@kernel.org>
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

The architecture is pretty clear that changing the configuration of
an enable interrupt is not OK. It doesn't really matter here, but
doing the right thing is not more expensive.

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


