Return-Path: <kvm+bounces-37051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 76463A2469A
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 03:19:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E71271889612
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:19:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26A9335977;
	Sat,  1 Feb 2025 02:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eTadbpQK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EC6148310
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 02:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738376258; cv=none; b=L8ZJXJJX+mWoIzmIjNTzEgWRjhQKBMVLnf9JFVLM5mfZVirwW4uGOkyFlHktMBDbqrqqQhzNp7wrIpkJf/l5oUptRwTJdwMhcP3Rf6/qIq8fecMqPA3gOeAYZPANc6MqRZcuX7mCDSWwdWHQJNF0DPYrK/vOeej3D39a06ueAUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738376258; c=relaxed/simple;
	bh=0aeg6fmcALkQCcWUWMu3ttM1q1g3Byn2iNg3RXSwUWU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EhQb5JVfO9FVSBMznau3Nj0Ur4veUct0D6jm7RuVrV8e8krUOznIQApw2ZNIVtoloWC1JgNyrQlXTi3jfxSZ6QZWHK25pSDwiVv93Bwa0m+HYWclyyR3WaamwXU9RpfY39xJAume85WkouYee/yTQXcaMBxDgb4kHvG6tQ456p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eTadbpQK; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef79403c5eso7332318a91.0
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 18:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738376256; x=1738981056; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Jjc0FDt1SDUJCzq8fzQuxH7Yk0FUL+T40LhhOPtkSdY=;
        b=eTadbpQK5e4nyjwAylxGFM6pa3E/SzIUhokZGI/v/ncORphfsvy27/SlNAbRH9UexZ
         AB9FDjV6Ki4upJpqrut+PSokrmU0BW47bVdDZMfK+YjPbgMv8m9CHR7WvdKplqlw6WkW
         FzElUSDmePGf0+IHoDAw5fBgpUn38BfS1isjdcm8/dkUo537lzyWtBdvyq2wVF5OVaDq
         oz0Vb3FAMRemfryAHiVY/gK4rMBfUtnhgcF9Yi96QTOmTZvR1SBjxphsBS7gUWgvhW5x
         eLVvg6v3N/S4wdegNjIhxanagDKo47OTcD0fp2OVn2YsRhHvw4iOgnjLapPSnsfrbT51
         VEaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738376256; x=1738981056;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jjc0FDt1SDUJCzq8fzQuxH7Yk0FUL+T40LhhOPtkSdY=;
        b=cZJg+JeNwXbnbR3FfzKr93xF6Invg7drep6J1d0j3xW66K+BiDvJPVla36r2BmoecI
         71PSJp0QJF+cLwvnw2GcPeGLAJ943qT4JBoLNrVP6zcan6KHhvUKzupR5eq3+DNL23Y7
         l4edPG55uDvgW0liYTL/1KxWYmXczFNe1qHumMXEj0yLdwXaTQHU1m0F+8oYwD+efCoh
         idIh0hyXsKoJ/qwNG1Cw0Ta6QL4DxItNtjrPlyUOZ4PxLLa+Cy6NLgK3b1Ib2XwCto3B
         +Rqtf5tBUmE5wHNdVLQ7scTVpOW4qjJVmkwWa+6qm6Vm5PARaKsx8iDmLn5E13q8d6bz
         thKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKNQQnuytgDona8DP4B1Q7NpupFuLUdcgTT3t/3iLKvUnLjOjyfbmD2icGsyy1NaIe9Zw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/10CfuaH4N/oJ1EECZxNz6+riK6F2ExHzNU2fhtOQD1CiJWl3
	zUU6Ly+ALjuCPR7GqPkDj+oJTSry1cAXmgq9+uvChmvWs31lpFb4lYqhBNbya+79ogEXDBKUcKf
	rnQ==
X-Google-Smtp-Source: AGHT+IHNY7VvQQRT0KSmjAH4FP26r3GzVfaLj1GKx7+F1yhKWmFMaX6hkP/CltwMml7T2BlNCnyUm1qLLO4=
X-Received: from pjbsv5.prod.google.com ([2002:a17:90b:5385:b0:2f4:3ea1:9033])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c03:b0:2ee:d18c:7d84
 with SMTP id 98e67ed59e1d1-2f83ac17ebemr18755620a91.20.1738376255998; Fri, 31
 Jan 2025 18:17:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 18:17:07 -0800
In-Reply-To: <20250201021718.699411-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201021718.699411-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201021718.699411-6-seanjc@google.com>
Subject: [PATCH 05/16] x86/sev: Move check for SNP Secure TSC support to tsc_early_init()
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Juergen Gross <jgross@suse.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Alexey Makhalov <alexey.amakhalov@broadcom.com>, Jan Kiszka <jan.kiszka@siemens.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	virtualization@lists.linux.dev, linux-hyperv@vger.kernel.org, 
	jailhouse-dev@googlegroups.com, kvm@vger.kernel.org, 
	xen-devel@lists.xenproject.org, Sean Christopherson <seanjc@google.com>, 
	Nikunj A Dadhania <nikunj@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"

Move the check on having a Secure TSC to the common tsc_early_init() so
that it's obvious that having a Secure TSC is conditional, and to prepare
for adding TDX to the mix (blindly initializing *both* SNP and TDX TSC
logic looks especially weird).

No functional change intended.

Cc: Nikunj A Dadhania <nikunj@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/coco/sev/core.c | 3 ---
 arch/x86/kernel/tsc.c    | 3 ++-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index e6ce4ca72465..dab386f782ce 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -3284,9 +3284,6 @@ void __init snp_secure_tsc_init(void)
 {
 	unsigned long long tsc_freq_mhz;
 
-	if (!cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
-		return;
-
 	setup_force_cpu_cap(X86_FEATURE_TSC_KNOWN_FREQ);
 	setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
 
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 5a16271b7a5c..09ca0cbd4f31 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1514,7 +1514,8 @@ void __init tsc_early_init(void)
 	if (is_early_uv_system())
 		return;
 
-	snp_secure_tsc_init();
+	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
+		snp_secure_tsc_init();
 
 	if (!determine_cpu_tsc_frequencies(true))
 		return;
-- 
2.48.1.362.g079036d154-goog


