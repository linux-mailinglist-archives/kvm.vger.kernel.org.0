Return-Path: <kvm+bounces-39492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10FB3A4722B
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 03:20:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B23AB7A3948
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 404311B87E2;
	Thu, 27 Feb 2025 02:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ncjvrqUj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB83190497
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 02:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740622752; cv=none; b=nz9agBSUH74rqYDGxj6sUVeuIHQRdnoxb/q23kGwUq3JlpLcSvn4TAerLvs3j1zD3lIdf5RtgXPL12pjmp92WmyEd1rbkKXirMhZ6oBmhba0i2VSq5l8VKmovir6rloqQhLrFgXqRyHiWFc72df1uOEGrZ7SuX4YZy8MJbQQchc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740622752; c=relaxed/simple;
	bh=cbbEYbCk5kmrOnFY4+pyu6dZHx8scVaupy5RtKUOy+Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lFynxlUWw0N+OegXqPba1EtfO2WUp+LZC7bAE1Hbh2iBhVEYTF3JKc6LUDO0RLWtmnLJ/mSh5BxrUTUGc6OecxfVug1/5qVG7jcv40oxOPcrgl+lkPacBUdQSmkwsib/2TyhKXeTD6D5kmuzlWRM/c/XsK1l973jTEgEGvTXqFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ncjvrqUj; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fe8c5dbdb0so1061019a91.3
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 18:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740622750; x=1741227550; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HbJ/1jLoPDWkVBe7cDWaMugTDenciqtu5nrTgQ9Zvm0=;
        b=ncjvrqUjmwekXY/o6eo006FvZWNuLjcP7sMTBFtsvpzy+wYAIYQmiUVOGEesPBXkgk
         qi8lChh/EZIbByPRtylkt5u29R8AVGqX3i65f/Oe79ryIK1SY4GA82w14jZFUp3IbDDQ
         8FMOcu35hbdaLFWwFdVarqPuOHJY/s6oIGMvgBAoaUWcOFpD/xONrY2JWODhMmKBGGfY
         IlBDfDsysZ88OeBO1xK4XmvE8gUYGdBPunuO+cYQNY9cuIo32nmNdCnhzYDIyXGryHzk
         qIMgsmmfDJB68KhtxLWgHSkwsaZ8VdWlfyjFUU/gzDJDzJxrO0NSDuLzetvZDnhl9jeD
         9LWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740622750; x=1741227550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HbJ/1jLoPDWkVBe7cDWaMugTDenciqtu5nrTgQ9Zvm0=;
        b=L8ZuJsI4DvGdkq/pId0HHkST8TcB4dCQAxWJAheZjzSSdKjtQoN2dukYKOeJ2CzN2B
         5l1kUzSsXkz7/YWm6FqCKZKEVzMAdfr5+dcPwaQvWhfZ/n6Uyia/CgWFjNgzUnYs23kv
         TLDvK0omDm7WZzyW56Skjqcm5rDNXdZWZKzzAeY4cU15xI0F+K1GIUML2Kk/y72nhGTq
         VNA+GK/PGaEQCe+SHX31EzxKYFGK5lP6kJvFUNhlZ9DarogjDXkdJGGxNhCKdmhW6pW7
         BMkpir6Ktxz1vt/uEXzEQsLhbq+7JrXLTb1k7KAEnbUWUXRiEK2xFU+KT2Rf0xbiESf0
         HszA==
X-Forwarded-Encrypted: i=1; AJvYcCUS94eRnMuUqnQ31q+75HmC6B5Iw6peQYibRvRW9n24ODAIPCYTfzxC6TvqoFnF/TGRmN0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+gfT4YmyZ7wzW+TTUzSSNOCv9okq3r5IfsREf4cdtN3ivOhDZ
	GZitfjhSZGtFEpqqQeO/KCRQAaFFrHfTLsNPX7142z4KPalDapaLiXpyCw8tydS9GQKzfa87EuL
	Utw==
X-Google-Smtp-Source: AGHT+IFmgEsUJJ1z3bRk5Nf8mtm9mdRWiQdO+4qbvCwBd/hyjI3jP5eNnlt+3d6bfd4x/QDsZrTqSfxiFQY=
X-Received: from pjbsw3.prod.google.com ([2002:a17:90b:2c83:b0:2fa:15aa:4d2b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:56cc:b0:2f1:2fa5:1924
 with SMTP id 98e67ed59e1d1-2fe7e39f2afmr7133368a91.26.1740622749803; Wed, 26
 Feb 2025 18:19:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 18:18:20 -0800
In-Reply-To: <20250227021855.3257188-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227021855.3257188-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227021855.3257188-5-seanjc@google.com>
Subject: [PATCH v2 04/38] x86/sev: Mark TSC as reliable when configuring
 Secure TSC
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Juergen Gross <jgross@suse.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, 
	John Stultz <jstultz@google.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	linux-hyperv@vger.kernel.org, xen-devel@lists.xenproject.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Nikunj A Dadhania <nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"

Move the code to mark the TSC as reliable from sme_early_init() to
snp_secure_tsc_init().  The only reader of TSC_RELIABLE is the aptly
named check_system_tsc_reliable(), which runs in tsc_init(), i.e.
after snp_secure_tsc_init().

This will allow consolidating the handling of TSC_KNOWN_FREQ and
TSC_RELIABLE when overriding the TSC calibration routine.

Cc: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/coco/sev/core.c      | 2 ++
 arch/x86/mm/mem_encrypt_amd.c | 3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 684cef70edc1..e6ce4ca72465 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -3288,6 +3288,8 @@ void __init snp_secure_tsc_init(void)
 		return;
 
 	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
+	setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
+
 	rdmsrl(MSR_AMD64_GUEST_TSC_FREQ, tsc_freq_mhz);
 	snp_tsc_freq_khz = (unsigned long)(tsc_freq_mhz * 1000);
 
diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index b56c5c073003..774f9677458f 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -541,9 +541,6 @@ void __init sme_early_init(void)
 	 * kernel mapped.
 	 */
 	snp_update_svsm_ca();
-
-	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
-		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
 }
 
 void __init mem_encrypt_free_decrypted_mem(void)
-- 
2.48.1.711.g2feabab25a-goog


