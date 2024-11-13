Return-Path: <kvm+bounces-31751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E9569C70F2
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 14:40:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F26D0B2CE89
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 13:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 612831DF24A;
	Wed, 13 Nov 2024 13:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="ik+T+NJr"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019F81E04B3;
	Wed, 13 Nov 2024 13:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731504818; cv=none; b=QWmQTnaY5VjFO6JiEa8Vhm/NhJcOHNeB7uIg//liWWSkki/eqB3IOJJoIOgG873D/UKupIlc2VPNV5jKOwV4Yn/wIVpYjAlq5W+DVMdNVEilWvkOLakCkoN+4DZKKwjelvIU4rH2DI68oTSCgXuNZ+11osfyULK/gV98c8AYKvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731504818; c=relaxed/simple;
	bh=xiuS+j5eMWadGnb1/z+irPWVgAnB1JxnxIODrhUOtqE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WI/lV0Ccl3JPsRmm2ERiMQWYiJI6uryOSWQ7lqG4KxYcH7PQpY/0O6nwTeHrI9rwPI9e2BuXhyLsLHEUOaX+LWO+SI+5EP5EQREJq15wwZzghvNKJAyAiYz9+8TG7GAOAgtZp/3dObOjBC+AeptAzZg2JR9pOb3lV9DmOUhsKs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=ik+T+NJr; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c15:2711:0:640:16b3:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id E556760DB1;
	Wed, 13 Nov 2024 16:31:33 +0300 (MSK)
Received: from davydov-max-lin.yandex.net (unknown [2a02:6bf:8011:701:66e1:20a5:ba04:640b])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id JVLWaO4DTW20-YJTdkvX7;
	Wed, 13 Nov 2024 16:31:33 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1731504693;
	bh=YD4+JNPVMB32j2yZlbzJ+qpKxke+1ubaUgFSfM+HOic=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=ik+T+NJrIKj8u+KnkoqOwx08jU6piLf+EsbwzhFUZ5VQ04WJ/FUUDCrDwFwaXNw3v
	 ACxDFKDB7j/5e38lzuk869Rz+tGfLmeckC+V1LPf3yfZR9g9J7PURjB7Ao/ZRp0qe9
	 cqT2GbIN5UFo8HymjQznph3Jx8inl0scjKm1cP7I=
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
Subject: [PATCH 2/2] x86: KVM: Advertise AMD's speculation control features
Date: Wed, 13 Nov 2024 16:30:42 +0300
Message-Id: <20241113133042.702340-3-davydov-max@yandex-team.ru>
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

It seems helpful to expose to userspace some speculation control features
from 0x80000008_EBX function:
* 16 bit. IBRS always on. Indicates whether processor prefers that
  IBRS is always on. It simplifies speculation managing.
* 18 bit. IBRS is preferred over software solution. Indicates that
  software mitigations can be replaced with more performant IBRS.
* 19 bit. IBRS provides Same Mode Protection. Indicates that when IBRS
  is set indirect branch predictions are not influenced by any prior
  indirect branches.
* 29 bit. BTC_NO. Indicates that processor isn't affected by branch type
  confusion. It's used during mitigations setting up.
* 30 bit. IBPB clears return address predictor. It's used during
  mitigations setting up.

Signed-off-by: Maksim Davydov <davydov-max@yandex-team.ru>
---
 arch/x86/include/asm/cpufeatures.h | 3 +++
 arch/x86/kvm/cpuid.c               | 5 +++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 2f8a858325a4..f5491bba75fc 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -340,7 +340,10 @@
 #define X86_FEATURE_AMD_IBPB		(13*32+12) /* Indirect Branch Prediction Barrier */
 #define X86_FEATURE_AMD_IBRS		(13*32+14) /* Indirect Branch Restricted Speculation */
 #define X86_FEATURE_AMD_STIBP		(13*32+15) /* Single Thread Indirect Branch Predictors */
+#define X86_FEATURE_AMD_IBRS_ALWAYS_ON	(13*32+16) /* Indirect Branch Restricted Speculation always-on preferred */
 #define X86_FEATURE_AMD_STIBP_ALWAYS_ON	(13*32+17) /* Single Thread Indirect Branch Predictors always-on preferred */
+#define X86_FEATURE_AMD_IBRS_PREFERRED	(13*32+18) /* Indirect Branch Restricted Speculation is preferred over SW solution */
+#define X86_FEATURE_AMD_IBRS_SMP	(13*32+19) /* Indirect Branch Restricted Speculation provides Same Mode Protection */
 #define X86_FEATURE_AMD_PPIN		(13*32+23) /* "amd_ppin" Protected Processor Inventory Number */
 #define X86_FEATURE_AMD_SSBD		(13*32+24) /* Speculative Store Bypass Disable */
 #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* "virt_ssbd" Virtualized Speculative Store Bypass Disable */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 30ce1bcfc47f..5b2d52913b18 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -754,8 +754,9 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
 		F(CLZERO) | F(XSAVEERPTR) |
 		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
-		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
-		F(AMD_PSFD)
+		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_IBRS_ALWAYS_ON) |
+		F(AMD_STIBP_ALWAYS_ON) | F(AMD_IBRS_PREFERRED) |
+		F(AMD_IBRS_SMP) | F(AMD_PSFD) | F(BTC_NO) | F(AMD_IBPB_RET)
 	);
 
 	/*
-- 
2.34.1


