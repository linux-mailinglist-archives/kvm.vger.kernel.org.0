Return-Path: <kvm+bounces-32502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CD08A9D94D8
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 10:47:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5DB3BB314BF
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 09:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CE621CBE8B;
	Tue, 26 Nov 2024 09:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="IHe+nIb8"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05007186E58;
	Tue, 26 Nov 2024 09:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732614326; cv=none; b=QzZBU0e6vrL3VQI9lPW4z3V9mdN30X9SA88KOZ/1jjryvQf20rSpNAqVjNCw8IYtMoNV6CPwGLPvZyHi+o3SbXeVCqo74iFZ5fd5l+e4UGHjW5gUhcAmiyln28UF39rD6oY3+PbTjHlw1tGug+aC966gzYEY6KRaKgAu3cCMBzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732614326; c=relaxed/simple;
	bh=xEcFfEwlHETqMCT0U9nYdj/pwyvujxBhGVnrL0lLQI0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iZfgjilCvd2hk9dmt/ZP87LYJJqF8KKMrq/D7iDYVJ4wwiehclrBUtW8SLyH79XXrpkcn6UVB7hf6bQCrTa1rJYRXgvLPF//dPj1dwZjKSWoqLtEWSRMmMOfkKtX5amXvcn00vrW+wmhG983UHK8F9ysgpMQlY7u5P2szrRphgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=IHe+nIb8; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:b1cb:0:640:2a1e:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 38A7D60AED;
	Tue, 26 Nov 2024 12:45:15 +0300 (MSK)
Received: from davydov-max-lin.yandex.net (unknown [2a02:6bf:8011:701:66e1:20a5:ba04:640b])
	by mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 0jUcd53IW8c0-yC1qNN5G;
	Tue, 26 Nov 2024 12:45:14 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1732614314;
	bh=KyoTCXQu71t5rLmoRN0LSwqdxR+y7JCS25Le3GwuqDk=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=IHe+nIb81/VVQj7BBugHT3zXLmZKKoHFPK0qViClJaKMvAcu3aEbQSDKxQJB6YvO7
	 4RVo6tbixS3AFoYaN1h5VuMpQWZpXl0ccoEPlC8MOxTVLVyrUhVrEApag5BVd/oeJS
	 zKa4OnURJCsdCKLWWGkci0N7QQqr2DzeqtCfbn1I=
Authentication-Results: mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Maksim Davydov <davydov-max@yandex-team.ru>
To: kvm@vger.kernel.org
Cc: davydov-max@yandex-team.ru,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	babu.moger@amd.com,
	seanjc@google.com,
	mingo@redhat.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	jmattson@google.com,
	pbonzini@redhat.com
Subject: [PATCH v2 2/2] x86: KVM: Advertise AMD's speculation control features
Date: Tue, 26 Nov 2024 12:44:24 +0300
Message-Id: <20241126094424.943192-3-davydov-max@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241126094424.943192-1-davydov-max@yandex-team.ru>
References: <20241126094424.943192-1-davydov-max@yandex-team.ru>
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
index f6be4fd2ead0..ba371d364c58 100644
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


