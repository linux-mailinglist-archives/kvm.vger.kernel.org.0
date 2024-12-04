Return-Path: <kvm+bounces-33037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 43BAA9E3B9A
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 14:46:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC3C4163EB9
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 13:46:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E6BF1F4731;
	Wed,  4 Dec 2024 13:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="jtf9h0dt"
X-Original-To: kvm@vger.kernel.org
Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF36D19066D;
	Wed,  4 Dec 2024 13:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733319954; cv=none; b=dEbZ/OyL/Lq3PkwQ6VJOeIagNwR0BFfpeBOhPyQSlVZ2nfBZzAAsjd6TR83oLTiKEABJxKbYoDnDrMFiFn6cw+2zDloJ5VfexnnlgB9lKuQ2Qr5FfmgiNsnlaL9ZYcvzA9V911pG5BPqsD3wFlVMBmUIQX0uEFIEqRQwq8qtkgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733319954; c=relaxed/simple;
	bh=5YpnpZX6+B/CaNZO2PnDnrq7wylzwB/oBrQSk0G1nak=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DwTouCrIJFMeJBbYYuqRe0azIsjpHm2HjXBbSDIn8lQlyQsup7yePpeEVyqyWT+x5C1xsnXK0NU7fcg1EVTo5YPDcFUO4HijPfOs9KqynvtwhYqlB2JxImVS/TOQhiV5NyGoknwOermRttIGwabP0hhh/zHlCKM4Y394NZFCn3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=jtf9h0dt; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Received: from mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:2e8b:0:640:9795:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 03F6060A04;
	Wed,  4 Dec 2024 16:43:59 +0300 (MSK)
Received: from davydov-max-lin.yandex.net (unknown [2a02:6bf:8011:701:66e1:20a5:ba04:640b])
	by mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id lhgH281Ia8c0-h0MAt36K;
	Wed, 04 Dec 2024 16:43:58 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1733319838;
	bh=MpDdZsTqATrxa4+VhA+RLANc8RM32ST6TjcRp3gw5c4=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=jtf9h0dt64HLhZQ6MKEdXQI3W62UV8/FFAhIqInW5nYW1DhZZzwmz8xfzi/SkjVKT
	 lTE4xwzm27bJZnfbQAZYbkEGkccXs6ZtvKa+YCl4qcJi1zEXJSekobvlFZLj2M4jWl
	 5YxCrly6vC98QzKLRfcHRT0gKnb9r7ejzO9qSn9M=
Authentication-Results: mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
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
Subject: [PATCH v3 1/2] x86: KVM: Advertise FSRS and FSRC on AMD to userspace
Date: Wed,  4 Dec 2024 16:43:44 +0300
Message-Id: <20241204134345.189041-2-davydov-max@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241204134345.189041-1-davydov-max@yandex-team.ru>
References: <20241204134345.189041-1-davydov-max@yandex-team.ru>
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
index 17b6590748c0..45f87a026bba 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -460,6 +460,8 @@
 #define X86_FEATURE_NULL_SEL_CLR_BASE	(20*32+ 6) /* Null Selector Clears Base */
 #define X86_FEATURE_AUTOIBRS		(20*32+ 8) /* Automatic IBRS */
 #define X86_FEATURE_NO_SMM_CTL_MSR	(20*32+ 9) /* SMM_CTL MSR is not present */
+#define X86_FEATURE_AMD_FSRS	        (20*32+10) /* AMD Fast short REP STOSB supported */
+#define X86_FEATURE_AMD_FSRC		(20*32+11) /* AMD Fast short REP CMPSB supported */
 
 #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barrier */
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 097bdc022d0f..7bc095add8ee 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -799,8 +799,8 @@ void kvm_set_cpu_caps(void)
 
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


