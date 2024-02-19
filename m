Return-Path: <kvm+bounces-9064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BA1B859F89
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 10:21:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CAE31C20C80
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A35ED28DBC;
	Mon, 19 Feb 2024 09:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JITNI7nT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0E725577;
	Mon, 19 Feb 2024 09:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708334425; cv=none; b=CKUCuuL+8YqPZO4yx/gWnZ/ls+8ePfcCxCvouI0w0WS52SHctR8irKdl4NZ1US+9oT1DNScSeV+PjPDEzy9lOXvpTcLTcjKzBwyaZf0kgP5hfvfxUK6bOnYkjxi19szA86fWRmziWHPkZqos1eBMmfhBAem9FwFHa6AMO9xeIzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708334425; c=relaxed/simple;
	bh=vqA6TJBDRvY50fGHqcQfGVUDuzRuFzAfHui2TaG7QnU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J/kiUh2wqtw/y0s2S1oLRTbgVlf78AjFJkVcZ1B9uABG73d5UTUA8w/b6Yl8ynqPBldJQaf8iisKHej9Slrb6WIDXjGqr3bZFVWoAyGUw2xleBPfgHYlKDqwSUoIpgs8ipJTVD7KJGppPZrx0/2q1rw3e+EPY7Ajz5zwd7iIJIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JITNI7nT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E67C433F1;
	Mon, 19 Feb 2024 09:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708334425;
	bh=vqA6TJBDRvY50fGHqcQfGVUDuzRuFzAfHui2TaG7QnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JITNI7nToZ36zcDFmHdeJ/RSjkban3qSQ6zMKFUVhWemwfwSekomFisA3qyyfzY4D
	 V9s9nbNVbqMQR9cwURhdzQar9WMNWIXLh5VxnDhzGk8a/mTrPK5h6zze9cVwph3e1D
	 cS0sGixwb8QXvYAV4S59XMaQaCCKKjj+OatArSXjy1fgxtUZmL64omaEKbc2D66Cnl
	 oD9T3JwzLf+kfgAbeLCY7m3EeneIDKOpvgAgzFvGEO0dMFzNEOxSecdEuIqCxbrqtZ
	 Qky+q9Cf4uiVCncv/IZgqKezctHZVLNnX4KHeE82A+7RcqYS75gDdNPGxcXK1yRTlq
	 efvRWJxDbYoHA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rbzp1-004WBZ-UH;
	Mon, 19 Feb 2024 09:20:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 13/13] KVM: arm64: nv: Advertise support for PAuth
Date: Mon, 19 Feb 2024 09:20:14 +0000
Message-Id: <20240219092014.783809-14-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219092014.783809-1-maz@kernel.org>
References: <20240219092014.783809-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we (hopefully) correctly handle ERETAx, drop the masking
of the PAuth feature (something that was not even complete, as
APA3 and AGA3 were still exposed).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index ced30c90521a..6813c7c7f00a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -35,13 +35,9 @@ static u64 limit_nv_id_reg(u32 id, u64 val)
 		break;
 
 	case SYS_ID_AA64ISAR1_EL1:
-		/* Support everything but PtrAuth and Spec Invalidation */
+		/* Support everything but Spec Invalidation */
 		val &= ~(GENMASK_ULL(63, 56)	|
-			 NV_FTR(ISAR1, SPECRES)	|
-			 NV_FTR(ISAR1, GPI)	|
-			 NV_FTR(ISAR1, GPA)	|
-			 NV_FTR(ISAR1, API)	|
-			 NV_FTR(ISAR1, APA));
+			 NV_FTR(ISAR1, SPECRES));
 		break;
 
 	case SYS_ID_AA64PFR0_EL1:
-- 
2.39.2


