Return-Path: <kvm+bounces-31752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E9249C712C
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 14:45:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 213F9B25ECE
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 13:34:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DE2B20010A;
	Wed, 13 Nov 2024 13:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="IHJY2ks1"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A4D1E0DBB;
	Wed, 13 Nov 2024 13:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731504819; cv=none; b=JT8KFfABy0+cjRPKLEw+Yk9YCyHHUirFhdqbemgj96q88b0QvP7j366RVdFoAlcZn2DQ3Rv8d/xz+C1CvyQaXYb0P1GKbl15o+kx+rywwisgrWJQQJQND/KalJfdCXZnGHLuH/x99aL0C+QxaMvGHrVup0z/9zZ5JcqXx2tbqEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731504819; c=relaxed/simple;
	bh=Wag3mMTIo4Nc/K0756CRwsUAFZx53cCoN3SI1+tUcDQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CRZnlai5+wmc1M1JpKnezlT+ARWy09fUjWrqQsV/ZiSnZQdi+KyqlhFBH1q6ZqcXouwvJOQLKCMfVa+OS/p95j7DGYHDysWYT2EDMLf1T97fMah96MGvnYKT0Lc7NNG4QyY+J2sYKim9ilyXA1oPkkm3T34+y9k45tC8LKveN6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=IHJY2ks1; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c15:2711:0:640:16b3:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 5350460DB0;
	Wed, 13 Nov 2024 16:31:33 +0300 (MSK)
Received: from davydov-max-lin.yandex.net (unknown [2a02:6bf:8011:701:66e1:20a5:ba04:640b])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id JVLWaO4DTW20-booabw5w;
	Wed, 13 Nov 2024 16:31:32 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1731504692;
	bh=6v8J8HX7EWPrAqETK1uJMQZCwV2nmbB8BAZQKVmsgJg=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=IHJY2ks17YKPA/zGnH4Ipg3y8kzszuOiKLoAYaxYKaljJqiVtrARdXcjb8GTghLpK
	 VeCIogCDbz6PTqC0iOOQuHRzMKgu167oFJ54T8nG5BVq6OGsaguBMaiTeUG5qIEdzJ
	 fOxWH6Fq2flgKYKenKD4gP/y8/BqhJi6rFmR3ogo=
Authentication-Results: mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Maksim Davydov <davydov-max@yandex-team.ru>
To: kvm@vger.kernel.org
Cc: davydov-max@yandex-team.ru,
	linux-kernel@vger.kernel.org,
	babu.moger@amd.com,
	x86@kernel.org,
	seanjc@google.com,
	sandipan.das@amd.com,
	bp@alien8.de,
	mingo@redhat.com,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	pbonzini@redhat.com
Subject: [PATCH 1/2] x86: KVM: Advertise FSRS and FSRC on AMD to userspace
Date: Wed, 13 Nov 2024 16:30:41 +0300
Message-Id: <20241113133042.702340-2-davydov-max@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241113133042.702340-1-davydov-max@yandex-team.ru>
References: <20241113133042.702340-1-davydov-max@yandex-team.ru>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fast short REP STOSB and fast short CMPSB support on AMD processors are
provided in other CPUID function in comparison with Intel processors:
* FSRS: 10 bit in 0x80000021_EAX
* FSRC: 11 bit in 0x80000021_EAX

AMD bit numbers differ from existing definition of FSRC and
FSRS. So, the new appropriate values have to be added with new names.

It's safe to advertise these features to userspace because they are a part
of CPU model definition and they can't be disabled (as existing Intel
features).

Fixes: 2a4209d6a9cb ("KVM: x86: Advertise fast REP string features inherent to the CPU")
Signed-off-by: Maksim Davydov <davydov-max@yandex-team.ru>
---
 arch/x86/include/asm/cpufeatures.h | 2 ++
 arch/x86/kvm/cpuid.c               | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 913fd3a7bac6..2f8a858325a4 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -457,6 +457,8 @@
 #define X86_FEATURE_NULL_SEL_CLR_BASE	(20*32+ 6) /* Null Selector Clears Base */
 #define X86_FEATURE_AUTOIBRS		(20*32+ 8) /* Automatic IBRS */
 #define X86_FEATURE_NO_SMM_CTL_MSR	(20*32+ 9) /* SMM_CTL MSR is not present */
+#define X86_FEATURE_AMD_FSRS	        (20*32+10) /* AMD Fast short REP STOSB supported */
+#define X86_FEATURE_AMD_FSRC		(20*30+11) /* AMD Fast short REP CMPSB supported */
 
 #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barrier */
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 41786b834b16..30ce1bcfc47f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -793,8 +793,8 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
 		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
-		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */ |
-		F(WRMSR_XX_BASE_NS)
+		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | F(AMD_FSRS) |
+		F(AMD_FSRC) | 0 /* PrefetchCtlMsr */ | F(WRMSR_XX_BASE_NS)
 	);
 
 	kvm_cpu_cap_check_and_set(X86_FEATURE_SBPB);
-- 
2.34.1


