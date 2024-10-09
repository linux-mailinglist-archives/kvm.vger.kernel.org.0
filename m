Return-Path: <kvm+bounces-28321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A5AD99753D
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:02:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43B3E285B3C
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:02:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C69261E2859;
	Wed,  9 Oct 2024 19:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZEpnXUfT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995EF1E22E6;
	Wed,  9 Oct 2024 19:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500444; cv=none; b=deNtN+a1T3fmW12sn4qXZYxCsVJgApaFeVGfSr6/ic6d94G7wy8GApWoVygArAO+lZ7ggFVCdLVvhcNpv2MQv3QsYLtEogzKA0U5GMwS+pcOLb59KeeKkfaBh2eFHK6gm1VkwDQ6QmNqrosw7U1R4bDq5oYz12z25tVysCbvAqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500444; c=relaxed/simple;
	bh=+Mi+ChfY8Q2QN7X3Fm7RfJa/0ezUgsD5Bs2HZBlFNkU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tolm8U1ma5m0D6Kw0E+vB2XIu8EixrUbO4uLx9C5fG0WdisQUp+yEwFRJ+qZSyMevu1uHyBhB0Lp6/mokTZdP2JpCwHrttAaL/mA3It16kvI4LjwDBYZw/CHYr9cbDuKuaxn7tYihYi+f866vUfqC8ZxvJrtBIFGFcWLDiaRH4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZEpnXUfT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C71C4CED8;
	Wed,  9 Oct 2024 19:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500444;
	bh=+Mi+ChfY8Q2QN7X3Fm7RfJa/0ezUgsD5Bs2HZBlFNkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZEpnXUfTChPlMdbFRAbs3LgD6PiCZM3O2LRgYclEYZfoYrYK9ZOauv17Bk2uY2RjS
	 lEMtKIJ7a+cuNlZpqZ4OXGL3LlUgEM9bw8QWvhlHYRtGQFlXD8S7i3p+9x3P1Hk8vu
	 IUJ8xcOXHy/PM95n2k9ki8ta372Zpv0+kJxLpkXklVEj3b5z55I/UYlhQu5cqgoSpn
	 3S8btM47A2ImBznCQFDPijYIm4uV8vNemlf76L3ipI2npTxu4nzX4KfrZ1SmIoxnRD
	 Qnc7HORUOiWnHrKsRum07LAPq0yBnCM8diCEa1ETCBfpmhDlL+2RkYb5hbhpfqZsjn
	 oT/VjoyxVHBEg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvO-001wcY-LK;
	Wed, 09 Oct 2024 20:00:42 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 10/36] arm64: Define ID_AA64MMFR1_EL1.HAFDBS advertising FEAT_HAFT
Date: Wed,  9 Oct 2024 19:59:53 +0100
Message-Id: <20241009190019.3222687-11-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241009190019.3222687-1-maz@kernel.org>
References: <20241009190019.3222687-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

This definition is missing, and we are going to need it to sanitise
TCR2_ELx.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 3c812fd28eca2..8db4431093b26 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1688,6 +1688,7 @@ UnsignedEnum	3:0	HAFDBS
 	0b0000	NI
 	0b0001	AF
 	0b0010	DBM
+	0b0011	HAFT
 EndEnum
 EndSysreg
 
-- 
2.39.2


