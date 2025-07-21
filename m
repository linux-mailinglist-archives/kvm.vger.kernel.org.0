Return-Path: <kvm+bounces-52964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EC6DB0C12A
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 12:20:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 981794E376A
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 10:20:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF13628F523;
	Mon, 21 Jul 2025 10:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XnoFQNwh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49E728E581;
	Mon, 21 Jul 2025 10:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753093208; cv=none; b=gQqs4LfQojtMe6Vkr7CY1UxdgFW7VUvpB+uC9oFgaD1WT+2kN6G8ZMcjW2mMfClbKZVigVNjGdmRolTjQCgfycsxrEZnc66x03x8ooa8/x+2xsCh9DD64icYqAQck9QNy0UDoIEUdJXdeSHb2pm1CApieRHguyBXjBuE001MFFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753093208; c=relaxed/simple;
	bh=hpSa9Hytttj/ZwtZ6FrPhzLZMQJROeFl8J2vEUiLn7U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TQRtUM6GBXeEV0Dm39JW/pEmhjrKE7Zs9ljoiWTU3pDJe463XGubfwQ69GLCYfP6nl9fVqwBIIzk2YJSVhBMWBl+6Tg8mJpPkjGAOf8oFiDN/fwyeE2iQhzPLR8VapzCANHYuMnHSfkQgIBwsWTXdAQbkROFdLAPaI0XZHonRdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XnoFQNwh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843CAC4CEED;
	Mon, 21 Jul 2025 10:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753093208;
	bh=hpSa9Hytttj/ZwtZ6FrPhzLZMQJROeFl8J2vEUiLn7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XnoFQNwh2Fgz5KcR53GCy4ZmDpYmWnwB3lczuWDvMfRT6HQ7z8qJ660Qg8xhJYbsq
	 TFu7sW35VxlvGQpTD/VVS3m22yMPv1fmzPJmrRXvzeIGhOHRU7IevGOkkjqmcjc7Uu
	 tgE38WDqEaRklsURICOHIlJ6qVNbXzpNTugsHR+JOM1iH+yEK3Qr1vG1oFkmz2DRpQ
	 S7OlxOOXesq1jBQXYLxHWJOXSChXVXx+9LmMB5sjnGE4EI5jm8YD/j7OUiK8TU4JWr
	 Egpn4MEIE/+0NB6sdCTe/Ihm6X9nRanr2RFFBP86eKLX8jazGaVgSS2uK4E/EyNjxe
	 5SDzWwbcot9bA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1udncs-00HZDF-QJ;
	Mon, 21 Jul 2025 11:20:06 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 7/7] KVM: arm64: Make ID_AA64PFR0_EL1.RAS writable
Date: Mon, 21 Jul 2025 11:19:55 +0100
Message-Id: <20250721101955.535159-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250721101955.535159-1-maz@kernel.org>
References: <20250721101955.535159-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Make ID_AA64PFR0_EL1.RAS writable so that we can restore a VM from
a system without RAS to a RAS-equipped machine (or disable RAS
in the guest).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 549766d7abca8..64707c62f1cf9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2946,7 +2946,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		    ~(ID_AA64PFR0_EL1_AMU |
 		      ID_AA64PFR0_EL1_MPAM |
 		      ID_AA64PFR0_EL1_SVE |
-		      ID_AA64PFR0_EL1_RAS |
 		      ID_AA64PFR0_EL1_AdvSIMD |
 		      ID_AA64PFR0_EL1_FP)),
 	ID_FILTERED(ID_AA64PFR1_EL1, id_aa64pfr1_el1,
-- 
2.39.2


