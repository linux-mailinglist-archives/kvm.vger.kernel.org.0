Return-Path: <kvm+bounces-3347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 762888036FB
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 15:36:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E1A11F211EE
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 14:36:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 165F429432;
	Mon,  4 Dec 2023 14:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="unoRh9Sn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E0128E20;
	Mon,  4 Dec 2023 14:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7444EC43391;
	Mon,  4 Dec 2023 14:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701700579;
	bh=P94BNra/R+KkfsC6Uy2bCTh9to9t5Uz2jcj94+O/JVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=unoRh9SnxFhd1DD6kQIAsiW9TF44hi4FvRCJ3ib/+qwSC/vUH9Ch/RwCGBMh+EpY9
	 dAoG04ccv+DOSBaJo7aT3e0rXDi8jYy5BP5VNOkV/RY5UPuUptRCrBWmGcrQEBU5EH
	 lF9ghvrmZgyyhu3Loo/Zjj4dc3vgBBqQFefD6BAw110UHZk0y4bPH1+7mx66YPlUFf
	 SIFTT1tewEEOsNPgmSvQqJyIVI91UGrX2pNZIOJj2QKwSZDUuDKbnbGvIs8gaS1hHJ
	 VRXtwy6R8rw0He0e6hq3KhUU8eBdAjIrpl5TQSEorpnzGF1usVoVCwqz+MjVr4I76j
	 3z7ErzIeIGeTQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rAA3V-001GN2-A9;
	Mon, 04 Dec 2023 14:36:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 2/3] arm64: Kill detection of VPIPT i-cache policy
Date: Mon,  4 Dec 2023 14:36:05 +0000
Message-Id: <20231204143606.1806432-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231204143606.1806432-1-maz@kernel.org>
References: <20231204143606.1806432-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, ardb@kernel.org, anshuman.khandual@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Since the kernel will never run on a system with the VPIPT i-cache
policy, drop the detection code altogether.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
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


