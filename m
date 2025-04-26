Return-Path: <kvm+bounces-44419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F872A9DA94
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:29:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BEA15A4AAA
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:29:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 359E7241674;
	Sat, 26 Apr 2025 12:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pbRoryHK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2320B235347;
	Sat, 26 Apr 2025 12:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670532; cv=none; b=sl9uhXBFIIcqsgDNv4xMKSMREt0UsNtMeefcI3+DxM7EML5ShSUf08WlPtiHoXe6RlAVFzp3xPDstt0uTDrvXyUgtbGhdYdCw07pTRA9HJyI1/kkGpE9aHRsbXsIn0XOB93yKDdKMVLbvyIUTLxJMx3VM3P7h+kwjExKpVQE9kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670532; c=relaxed/simple;
	bh=EKkCWRGnSA74kksAFbA/CeMyR+M2fij+QTBGezXyg3s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j7b9YRtXY1w9LBIL6HPRo0Lhle2jGO33adRfphFil2FkBeh6dfBsBrLNq4hZHOVXFrtV0FYDqjSe+HuCpQJIPXABq5BuChVCQu3YJBacQKPWN61syTdT+YLVd8XIDPGopkegChpgYrTnAXg9X7z0fyddmUH9YJ3dLQ1MGvTlgfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pbRoryHK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDE8C4CEED;
	Sat, 26 Apr 2025 12:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670531;
	bh=EKkCWRGnSA74kksAFbA/CeMyR+M2fij+QTBGezXyg3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pbRoryHKVJlX4wLKFrBiBpeVSOdH5nDKj4OT4yG76HDhoKF4kZc+pl6aiR02CrfuQ
	 WHL87rE5kklsK1qmcLucJ4vorwMtS5UdVLN3PWQ96QslALUKBYcO6BVjswxSvsmoxW
	 nSo+hMSVfo63lCeXz+LNrfeOtHm9mPFWfyS50I9e27pTOU+5FxIStgz9IBlmK1+CX0
	 R1KS8my+3san2loCUe1pR9MyO4zxCPYA0JBk+xeNBoJoZ1XZmd/oURHsMFVZP+bSZV
	 aygdqnG19PC/rxyi4D9sSsY8sRWSCn609kg/Euio1kac7UPUBrO6uL+4u8fxFAL5YI
	 Gr/tRxF0fzcog==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeH-0092VH-FP;
	Sat, 26 Apr 2025 13:28:49 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 05/42] arm64: sysreg: Update ID_AA64PFR0_EL1 description
Date: Sat, 26 Apr 2025 13:27:59 +0100
Message-Id: <20250426122836.3341523-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the missing RASv2 description.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/tools/sysreg | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index e21e881314a33..bdfc02bd1eb10 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -907,6 +907,7 @@ UnsignedEnum	31:28	RAS
 	0b0000	NI
 	0b0001	IMP
 	0b0010	V1P1
+	0b0011	V2
 EndEnum
 UnsignedEnum	27:24	GIC
 	0b0000	NI
-- 
2.39.2


