Return-Path: <kvm+bounces-8560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 67483851749
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 15:48:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13CFE283102
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 14:48:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F63A3C067;
	Mon, 12 Feb 2024 14:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JbtkfR5C"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF763BB46;
	Mon, 12 Feb 2024 14:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707749274; cv=none; b=IE7/nEMx8ViNth6oXQ6cZOAq6x0k7G5mZFeqbfNJ64y3EV5veTrrOOCgaykASulZONaLgJ29RoluBLB1sDPZVXz7vKi44CJm3WtsZ2Rsov35fvOuceTEgTUWofjxjptDIMl3wTCjBJZyaVoorOcWC1aKeN5H/nVBjEi46lNLtSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707749274; c=relaxed/simple;
	bh=e2C7pn2jEG5y+mAGuphlZridsZxMj3//yLEbi5gFAnY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lG/8YL7veUes20zF9pKjeCtx7djOUsnLThwcXAWCaxGD47llII9rktJ5SCRkxldY409cyUk92ex8iWmAzIVhn8ttggGkkxSee3IGUHvwzyb1mEVOEoHLQV3nMlMF+QFW1wpezGXhAZlApV1x/ZnS3g5zzW7tPerBZtheGLjYlqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JbtkfR5C; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E6AC43399;
	Mon, 12 Feb 2024 14:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707749272;
	bh=e2C7pn2jEG5y+mAGuphlZridsZxMj3//yLEbi5gFAnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JbtkfR5CeQ4t6M7uN+V3IeG/JQPymb4VhfrnKlHy6Pyk5RE8xJsasB6Csp7BOwfaO
	 WXDhFLUO0MTDS/W1+efQq6tNeq3QvSUPhIlc20y6PPevgqxvBxfdXV44aG2qgGEYnt
	 q8x0s674ORBQ25NYVIk363iSvp5ERnYAhN1N+nlkoGZhNXsDUJc9Wh+nyInBalnPPJ
	 Lqm+zSGUdeINdUfTFGRvktow0BYqLyDL8k7r+anEhJyDjkyedZ3jwQcRAqmgOWxjYi
	 15fg5C9a5mfLW7YWGpwY6vC4oRZOL1oupsfDblyduP1jR+l4npZ1LVEiRWrMkcfq4A
	 HdBqmmWG3QyBw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rZXb4-002SFp-K9;
	Mon, 12 Feb 2024 14:47:50 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 2/2] arm64: cpufeatures: Only check for NV1 if NV is present
Date: Mon, 12 Feb 2024 14:47:36 +0000
Message-Id: <20240212144736.1933112-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240212144736.1933112-1-maz@kernel.org>
References: <20240212144736.1933112-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, m.szyprowski@samsung.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We handle ID_AA64MMFR4_EL1.E2H0 being 0 as NV1 being present.
However, this is only true if FEAT_NV is implemented.

Add the required check to has_nv1(), avoiding spuriously advertising
NV1 on HW that doesn't have NV at all.

Fixes: da9af5071b25 ("arm64: cpufeature: Detect HCR_EL2.NV1 being RES0")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 2f8958f27e9e..3421b684d340 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1812,8 +1812,9 @@ static bool has_nv1(const struct arm64_cpu_capabilities *entry, int scope)
 		{}
 	};
 
-	return !(has_cpuid_feature(entry, scope) ||
-		 is_midr_in_range_list(read_cpuid_id(), nv1_ni_list));
+	return (this_cpu_has_cap(ARM64_HAS_NESTED_VIRT) &&
+		!(has_cpuid_feature(entry, scope) ||
+		  is_midr_in_range_list(read_cpuid_id(), nv1_ni_list)));
 }
 
 #if defined(ID_AA64MMFR0_EL1_TGRAN_LPA2) && defined(ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_LPA2)
-- 
2.39.2


