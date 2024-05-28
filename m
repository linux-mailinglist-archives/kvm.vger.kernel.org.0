Return-Path: <kvm+bounces-18202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0D258D181C
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 12:07:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75EE01F22856
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 10:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 536D816A39B;
	Tue, 28 May 2024 10:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t+FfRFRl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CC2155C95;
	Tue, 28 May 2024 10:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716890809; cv=none; b=dt6ed95goU9pi1GF0y9/yBIzimg/hFrTsbqh+1BZfHi+OlSqRxPodPX+F4mo8WfE+CxwSlUBgjpMSIcMhy8bm2Y9J7X6V2kzUQh6qp5PAM3Mld1856DwzcrljP92tZMCnxOJKZpdGM0IGq1C0tx8PKf61vwO3StrxsOtnrWMkIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716890809; c=relaxed/simple;
	bh=yLKxPsfVUrnjvhtPXA7gFp6zdgd0T66pRYoAQcmZlfY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UTwoKH2yFK3eUNfAFstlI3WN/ZCQSq564zyC/tZ6vqAsrBeW5RPxeZrHo702iN3b1aag+JhMKYvbl10Kf3kyvIRgJya/RUm5Ci06Tfn1kjgEJhX49fC80rPnNHSOT4ca0lip4WLzAPohnHx/IfC9BaLjyrULbkiooSDhBNvwhS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t+FfRFRl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F59C32781;
	Tue, 28 May 2024 10:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716890809;
	bh=yLKxPsfVUrnjvhtPXA7gFp6zdgd0T66pRYoAQcmZlfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+FfRFRlmYNX3hiRUF2bFhYz9CLruH8MMvqdFJiTAxKxUz2pv0/6GcaBzGatxsOJ8
	 PQTeoEoqZZr9w0bJYNbOReZIOVwQOdfPQPM6oiZhdzbSkWY5HlrOHjoL/bgomblZRp
	 NPUZP6o3KNQeKSssWxUBr5KSJcplwIYLs8o2oWrt7/bgA1R4BGMWMVZx0L6mrPiwsg
	 RYkn6CaWY1j2IPuwkScUVMGN4P94U5IJcFTevsi8WiH5C9gJD7b92DqVws9IK1gSrZ
	 XK8ElbzrrmPboh+gUyBHQt4QZCvke6JM2BSewNK/Ji5Dzy++U+Iw1obQyo1gJoe2O5
	 eJq5GaT0fiuWw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sBtjD-00GFdz-7C;
	Tue, 28 May 2024 11:06:47 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 2/2] KVM: arm64: nv: Expose BTI and CSV_frac to a guest hypervisor
Date: Tue, 28 May 2024 11:06:32 +0100
Message-Id: <20240528100632.1831995-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240528100632.1831995-1-maz@kernel.org>
References: <20240528100632.1831995-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we expose PAC to NV guests, we can also expose BTI (as
the two as joined at the hip, due to some of the PAC instructions
being landing pads).

While we're at it, also propagate CSV_frac, which requires no
particular emulation.

Fixes: f4f6a95bac49 ("KVM: arm64: nv: Advertise support for PAuth")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 6813c7c7f00a..bae8536cbf00 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -58,8 +58,10 @@ static u64 limit_nv_id_reg(u32 id, u64 val)
 		break;
 
 	case SYS_ID_AA64PFR1_EL1:
-		/* Only support SSBS */
-		val &= NV_FTR(PFR1, SSBS);
+		/* Only support BTI, SSBS, CSV2_frac */
+		val &= (NV_FTR(PFR1, BT)	|
+			NV_FTR(PFR1, SSBS)	|
+			NV_FTR(PFR1, CSV2_frac));
 		break;
 
 	case SYS_ID_AA64MMFR0_EL1:
-- 
2.39.2


