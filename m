Return-Path: <kvm+bounces-32500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F4C19D94E8
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 10:54:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0D236B2269B
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 09:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29CFC1C878E;
	Tue, 26 Nov 2024 09:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="D50F3dH6"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6F71474DA;
	Tue, 26 Nov 2024 09:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732614326; cv=none; b=b+Oy8HYFyANPl2zDA5I25G2K1xTdTmTURMz7GLhEsrutD/9kdHWzHcwAARhsuzaX53CVxNRIJJ74Y6D2Qbi90VojNnZWh52FEI5HkjbEVqfJSxkIhVqC4sdKpywRGXkoEOuCPGydRnRRMJWttRSuyr/qo608yaGdo17XjFYBRns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732614326; c=relaxed/simple;
	bh=6gMYP/H78xRVz8JW7jCXSOLjYMogacpXnWFOFUQacJE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=efznbN+5SWXRocWYVvZHt0D+BCMx2DcQovtYT97anToP0TTvbN/mNYfZo6pYEeeEvAsOQOrHnOvoiLP/2BKYogdBwDdGhac52Renzto7BRKL67gH9SkyouTgbfyKBzIghwrDheV4Ozh2G4Ud4xLQuuJNYkPzcDlG2HacFhD9XOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=D50F3dH6; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:b1cb:0:640:2a1e:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 6838A60AD9;
	Tue, 26 Nov 2024 12:45:14 +0300 (MSK)
Received: from davydov-max-lin.yandex.net (unknown [2a02:6bf:8011:701:66e1:20a5:ba04:640b])
	by mail-nwsmtp-smtp-corp-main-56.klg.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 0jUcd53IW8c0-bHUutonQ;
	Tue, 26 Nov 2024 12:45:13 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1732614313;
	bh=NTXgQwwpcjQyc7RCVu6vHpXtivPRWHKO5Eb+WJKhvJ4=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=D50F3dH68Ho5Ils/ouMJglwlY0zDR0O4yrg4kPiF1M+GUpNHI02yCuni30AUXKoYR
	 rrn7Apn7iyUgGdEVCjn9sbi+zXVLdTiXQyxz5m9osder/cTNyrW+xQdSlam6SzkMQy
	 oOKMnTMKfFP/z9MJCA6iugufIVz6yw8569CS8yDc=
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
Subject: [PATCH v2 1/2] x86: KVM: Advertise FSRS and FSRC on AMD to userspace
Date: Tue, 26 Nov 2024 12:44:23 +0300
Message-Id: <20241126094424.943192-2-davydov-max@yandex-team.ru>
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
index ea33439a5d00..f6be4fd2ead0 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -457,6 +457,8 @@
 #define X86_FEATURE_NULL_SEL_CLR_BASE	(20*32+ 6) /* Null Selector Clears Base */
 #define X86_FEATURE_AUTOIBRS		(20*32+ 8) /* Automatic IBRS */
 #define X86_FEATURE_NO_SMM_CTL_MSR	(20*32+ 9) /* SMM_CTL MSR is not present */
+#define X86_FEATURE_AMD_FSRS	        (20*32+10) /* AMD Fast short REP STOSB supported */
+#define X86_FEATURE_AMD_FSRC		(20*32+11) /* AMD Fast short REP CMPSB supported */
 
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


