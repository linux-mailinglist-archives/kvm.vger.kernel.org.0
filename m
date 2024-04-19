Return-Path: <kvm+bounces-15240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DCF38AACDC
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:31:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF4281C21321
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 10:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDDE181ABA;
	Fri, 19 Apr 2024 10:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ebYp/sJG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13C980028;
	Fri, 19 Apr 2024 10:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713522594; cv=none; b=QBVguNdh1oyR2kDOhpR16m3GX1F3BCLKKM1+jx777Ugd38ZFJvp+hXkvrW9ZukCccUA8od9WmJvQ0PA2ip8UVjq1b4s92xw6rcoNx87DdJ/2XyuXYeXvE2pwv3SYiFuV5iAW9up84gURBd3s2+tQO6j4mvPvwwDsHs62MzxnMMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713522594; c=relaxed/simple;
	bh=fPLc3qnVR/fPZ7T4iKNF6Hx6H3w34KByeZbhDFUklq8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ogdV1Z+tgcAgBGd+Ij6Ari2KL4qtiYl6Q5JLxbhbZfA4wnZaM/+sqhkY+5aQTVIbxkOw42LeSDCB0Qw+vLznI6Mg8dhDNAijRjEXeigWRHTfJB4niPhHnbxcWJ6hv/BFSPLYLmhkkfsHCSWVxKyWMAULvCaZUjltc2YBym/F6yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ebYp/sJG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03F7C2BD10;
	Fri, 19 Apr 2024 10:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713522593;
	bh=fPLc3qnVR/fPZ7T4iKNF6Hx6H3w34KByeZbhDFUklq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebYp/sJG/Z5LQzPUd0RTiBK4UBUNHzokxAQq+7BWqofpMylN+zKlnUoeOam8+OD/S
	 RczkYsGsDiXx1xge6RVRPcTfjMFOn9hMl00sWXGrVDH12+UeGq0eVFqg32sC1WGrw0
	 oCpTT9MS8D9G8g21iUX6aBX5EoAJaqZl75zxWayNymV1mskS8IOT/94lkzdzwMRf98
	 xQDOvFq88NhOPI53Z0khU/sK/Q2GcZOy4fHjHmW363dIMvyTCfcpvpYeGBJB0usNkP
	 JAWjh8Ymcwm0p4o0YympCI971kqc4qyBQWT4voSPwNUqeZ8gLQG5aTk35e21mcUwsH
	 ej0+Y5D9IxcEw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rxlVA-00636W-3b;
	Fri, 19 Apr 2024 11:29:52 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v4 14/15] KVM: arm64: nv: Advertise support for PAuth
Date: Fri, 19 Apr 2024 11:29:34 +0100
Message-Id: <20240419102935.1935571-15-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240419102935.1935571-1-maz@kernel.org>
References: <20240419102935.1935571-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, tabba@google.com, smostafa@google.com, will@kernel.org, catalin.marinas@arm.com
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


