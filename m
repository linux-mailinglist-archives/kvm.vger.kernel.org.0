Return-Path: <kvm+bounces-19632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18E18907D62
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 22:20:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 90181B29250
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 20:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDA946EB5B;
	Thu, 13 Jun 2024 20:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jR/JQoYd"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117C614B091
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 20:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718309944; cv=none; b=MaOpsc9NpUbUmQMee1PZeL6bMrwvvLHoRVp6veinxowHBLg2RnYWVlSfbFlxvY72ImZhhleEJq4rqJUL2gNGiAGH3djlZlZZruEwbSkyQR7oDU8ZQ8Oa0UtKGC+Zfgf7R8elGlaMXPTOpElnltFPIKcRSOEQYtVd9+NTVQZfzrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718309944; c=relaxed/simple;
	bh=8EVw4Patq8tqLuKmLiBggCmUM/SMzQpxdFoZhJvK7U0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OeQM0NFclCWeUmezyAS4X3+KdDVxptx9cVVyameRRPor2mobpoozOV6TwNumYZS3nexkRhE7TSnY17l6led0H82CAR488EF4m9ov2ncxHWnG+uRDkboGtTLWmjIo7GguKy92vaN25Bsp+rT467PbnLmaPUCkqMEUMLaO2BZp/F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jR/JQoYd; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718309937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QrdCJhG75DjFmIYu1xxn9evIUFTScRdvab9ZbjCGheY=;
	b=jR/JQoYdU/XGIV8u891uIugRhjOGiHHcjrc+YPWXaG7qiKefXKMjquwUzd0m2fxbdDI2Xz
	IuskMSQYn+Zn5r06bN8XRaoMDnguIf+g7Ls/vtV8HmOujoeaa8yRqlIwylir3pbNfH7+e/
	PYI9VJcmZfyh+ghor/kmvTkmzl10rsk=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: tabba@google.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 15/15] KVM: arm64: Allow the use of SVE+NV
Date: Thu, 13 Jun 2024 20:17:56 +0000
Message-ID: <20240613201756.3258227-16-oliver.upton@linux.dev>
In-Reply-To: <20240613201756.3258227-1-oliver.upton@linux.dev>
References: <20240613201756.3258227-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Allow SVE and NV to mix now that everything is in place to handle it
correctly.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/arm.c    | 5 -----
 arch/arm64/kvm/nested.c | 3 +--
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9996a989b52e..e2c934728f73 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1419,11 +1419,6 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, &features))
 		return -EINVAL;
 
-	/* Disallow NV+SVE for the time being */
-	if (test_bit(KVM_ARM_VCPU_HAS_EL2, &features) &&
-	    test_bit(KVM_ARM_VCPU_SVE, &features))
-		return -EINVAL;
-
 	if (!test_bit(KVM_ARM_VCPU_EL1_32BIT, &features))
 		return 0;
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 6813c7c7f00a..0aefc3e1b9a7 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -41,13 +41,12 @@ static u64 limit_nv_id_reg(u32 id, u64 val)
 		break;
 
 	case SYS_ID_AA64PFR0_EL1:
-		/* No AMU, MPAM, S-EL2, RAS or SVE */
+		/* No AMU, MPAM, S-EL2, or RAS */
 		val &= ~(GENMASK_ULL(55, 52)	|
 			 NV_FTR(PFR0, AMU)	|
 			 NV_FTR(PFR0, MPAM)	|
 			 NV_FTR(PFR0, SEL2)	|
 			 NV_FTR(PFR0, RAS)	|
-			 NV_FTR(PFR0, SVE)	|
 			 NV_FTR(PFR0, EL3)	|
 			 NV_FTR(PFR0, EL2)	|
 			 NV_FTR(PFR0, EL1));
-- 
2.45.2.627.g7a2c4fd464-goog


