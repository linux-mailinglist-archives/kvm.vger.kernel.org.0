Return-Path: <kvm+bounces-18568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E5D428D6CCC
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 01:15:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 643F11F2396C
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 23:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57DFE134415;
	Fri, 31 May 2024 23:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fO8IQRVT"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761AA134414
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 23:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717197276; cv=none; b=hGZlGDIOaNzEC9aavJCvua75+UyfEHt5r8G6ZrvNVFDx4qp98Jzyr9eaXP5OPLWyF3xxZN2HNG72w/Z5w0xF4MYjphAFzkaIKc8PzkoONzjvy5CY9tlcfmsugbety7w0KA/LEYJ2rw8luE3KcOdX7KSbzQEM5vA3d+raDcy6mGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717197276; c=relaxed/simple;
	bh=xVzbcaMQmJjiovrIhxVtkqd8ciC0HYlyZIghHEFnsxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsWHenBBT2ijgYlXDQu10SDdwqqDA4Ot0emZfhwCsTiFMopIqjRnXl+wAHjSu5cicOLinizhs75c2Cu/m4D+8zc85qYbIzkl/VHdStiSr9iFPF2iPniirmEnsOZAb/YRgTvhNajmtH2y4G34ukEVseyqnNHEjchaP6jOfobpEqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fO8IQRVT; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1717197272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qAM10pWQ70u6GJPYmfygF5x6aknhjdYABForx6XgJMc=;
	b=fO8IQRVTBbverFD6IykNLabhX6eMQv7une10eTDkY6ajiHGmxUdVsjZAk1/918wIVueVFj
	Q/UgP3L+UKXnuUl4o7YbJTZdrvxg6b1zYjTTV2zDDTDOoq/X+BdmCvUh+ESw8joir5j7TT
	sNrn++U1VOyOu2uHCxk7MftDyP8R7G0=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 11/11] KVM: arm64: Allow the use of SVE+NV
Date: Fri, 31 May 2024 23:13:58 +0000
Message-ID: <20240531231358.1000039-12-oliver.upton@linux.dev>
In-Reply-To: <20240531231358.1000039-1-oliver.upton@linux.dev>
References: <20240531231358.1000039-1-oliver.upton@linux.dev>
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
2.45.1.288.g0e0cd299f1-goog


