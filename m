Return-Path: <kvm+bounces-12418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CC39885CB8
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 16:55:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D04AE1F23508
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 15:55:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1261112C7E8;
	Thu, 21 Mar 2024 15:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cdPLGZXc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EB212BF38;
	Thu, 21 Mar 2024 15:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711036474; cv=none; b=nfE8E7sWkgGRcH/llw9ulcC9hz47gz8MiY/tqh8+ElHay6c6IxHPi69s4M7W0yic6Ve3KOT73ObcHJG+lx/S21LGVYO5kv0xiRnwhsVKtks1urjPx0Rlm0NkZMgOiKAKc//25SWNg5hyuqI4Ap1KshSRbLw9bC1I6eDDx15qzYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711036474; c=relaxed/simple;
	bh=fPLc3qnVR/fPZ7T4iKNF6Hx6H3w34KByeZbhDFUklq8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L35H+XUfC3aKO4lSd8T26pENE7OwZ70W4vJgHB+fDssRRBlMV5iioa3K3jRnz1Jq9gkjuhnJxanMMdSGQeMqDFyOUOUXjpBff8Ks05QZfMz/JiylmfCY2aC9JhfocDMPux7kXwo2Ue5fuJhl0Kr31ymjh4EIglEonpVAIBgKxag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cdPLGZXc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A06C43142;
	Thu, 21 Mar 2024 15:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711036474;
	bh=fPLc3qnVR/fPZ7T4iKNF6Hx6H3w34KByeZbhDFUklq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cdPLGZXco82fadKjnQ0Ntp/pShthBsnCSQpPKJEV6YONMCEJmiJ8erkNxfwMpreuN
	 m2LPDd4RT7RDqDagxhfsL0VfZWK373cwH8JrU2eP8BdChKWcMpSCofAyDE+4m0GC4O
	 PPkoFDdLpTZt5jixT77o7kLmqu6e5c77OXXMOFgMF4+NIDI0rvJy7/Xvyl/XQF860b
	 2scQSn1ApI+Vh9qeQDz9AiZjgKURFng2axs7bw1nB51dACZ5iwcx8Y9HkwxqIdgYBG
	 wLWb5rD6wQqRymolyhnUQ+nrSjda+QV6IVK792fcN6yhPseJAbGL1cT2fO6nAE+DAu
	 NaBSo+1fgL70w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rnKkS-00EEqz-B4;
	Thu, 21 Mar 2024 15:54:32 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 14/15] KVM: arm64: nv: Advertise support for PAuth
Date: Thu, 21 Mar 2024 15:53:55 +0000
Message-Id: <20240321155356.3236459-15-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240321155356.3236459-1-maz@kernel.org>
References: <20240321155356.3236459-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we (hopefully) correctly handle ERETAx, drop the masking
of the PAuth feature (something that was not even complete, as
APA3 and AGA3 were still exposed).

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
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


