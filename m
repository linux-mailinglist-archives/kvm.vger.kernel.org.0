Return-Path: <kvm+bounces-2519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0719F7FA7EA
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 18:27:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B63B628178A
	for <lists+kvm@lfdr.de>; Mon, 27 Nov 2023 17:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 732473A278;
	Mon, 27 Nov 2023 17:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eVXkvtb6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D92374D9;
	Mon, 27 Nov 2023 17:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7CEC433CB;
	Mon, 27 Nov 2023 17:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701106003;
	bh=dnLFWdSGt6DPtfFa+UBesH0k30arIBI2NvoTcHkbVZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eVXkvtb62lLFqD1uNDnv/DyaCb/naX6iKCzb0hd4IlcSNMgcIHkIKR31s0rM1tHzc
	 C4dkQPPWC3+LchlqARo8LurDkAA2u1mkaZJw15Hrsk7PnJ44NL70O4N86q+LApWKqh
	 Ks6QDAmJk/BpdUrAutFIqSwFF4jFIseJR3JBQ1mMRuCA5+o3vPicJT+0LMukPltzGJ
	 cRQcUKHKqoXH1zZP0eTGoscrNdmQ4CfN2O8Df70RA3nqZ2H7NlVdIVIDz/2JLPIOp7
	 5//iINNKMRbjsOx/UJSPgMQLfYBDKgiePqS8tDN4eGwMic7J8JKWe3gzJeHV9kDPUB
	 cF3sM4uXHneZQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r7fNZ-00GsGj-Ng;
	Mon, 27 Nov 2023 17:26:41 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 2/3] arm64: Kill detection of VPIPT i-cache policy
Date: Mon, 27 Nov 2023 17:26:12 +0000
Message-Id: <20231127172613.1490283-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231127172613.1490283-1-maz@kernel.org>
References: <20231127172613.1490283-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, ardb@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Since the kernel will never run on a system with the VPIPT i-cache
policy, drop the detection code altogether.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/cache.h | 6 ------
 arch/arm64/kernel/cpuinfo.c    | 5 -----
 2 files changed, 11 deletions(-)

diff --git a/arch/arm64/include/asm/cache.h b/arch/arm64/include/asm/cache.h
index ceb368d33bf4..06a4670bdb0b 100644
--- a/arch/arm64/include/asm/cache.h
+++ b/arch/arm64/include/asm/cache.h
@@ -58,7 +58,6 @@ static inline unsigned int arch_slab_minalign(void)
 #define CTR_L1IP(ctr)		SYS_FIELD_GET(CTR_EL0, L1Ip, ctr)
 
 #define ICACHEF_ALIASING	0
-#define ICACHEF_VPIPT		1
 extern unsigned long __icache_flags;
 
 /*
@@ -70,11 +69,6 @@ static inline int icache_is_aliasing(void)
 	return test_bit(ICACHEF_ALIASING, &__icache_flags);
 }
 
-static __always_inline int icache_is_vpipt(void)
-{
-	return test_bit(ICACHEF_VPIPT, &__icache_flags);
-}
-
 static inline u32 cache_type_cwg(void)
 {
 	return SYS_FIELD_GET(CTR_EL0, CWG, read_cpuid_cachetype());
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index a257da7b56fe..47043c0d95ec 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -36,8 +36,6 @@ static struct cpuinfo_arm64 boot_cpu_data;
 static inline const char *icache_policy_str(int l1ip)
 {
 	switch (l1ip) {
-	case CTR_EL0_L1Ip_VPIPT:
-		return "VPIPT";
 	case CTR_EL0_L1Ip_VIPT:
 		return "VIPT";
 	case CTR_EL0_L1Ip_PIPT:
@@ -388,9 +386,6 @@ static void cpuinfo_detect_icache_policy(struct cpuinfo_arm64 *info)
 	switch (l1ip) {
 	case CTR_EL0_L1Ip_PIPT:
 		break;
-	case CTR_EL0_L1Ip_VPIPT:
-		set_bit(ICACHEF_VPIPT, &__icache_flags);
-		break;
 	case CTR_EL0_L1Ip_VIPT:
 	default:
 		/* Assume aliasing */
-- 
2.39.2


