Return-Path: <kvm+bounces-48020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 49809AC840C
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 00:20:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 305777A825F
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 22:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C412524729F;
	Thu, 29 May 2025 22:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q0Z1uG23"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABAC230BC4
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 22:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748557194; cv=none; b=IOFHPnJuLI4f7KOwZGDTztweoRLJX1veI5BIxZZg6kVrZQtROiF+37OZ83hgfGSDQg6ZciNoA3MKuuMZB5Czvs1LJTlSLKUgDPqF5AAXkG1pi60e5O5VbBCd4mD0OtqQgqzKjaiFptuAUJdwEa/sfTwW2cjCPpH0fEoOIHh1UV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748557194; c=relaxed/simple;
	bh=mFlDg8wOG1PRZBUzQS0fkbB1ud//ZEmy7lh+SfMWkKU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O3OuH1qLHnWaE4KDlOAUcZkyX7xzzwMQNSQ3K236h/vcwQZ/I/yu3dT6s2JIKKVvOnwuVHuJVcHl+BJZR02cmzKxj1fxHZAr/rl3SA6eonFGvTKECjMWKwE8wgzEWCtXMH8XUXRd0vY/jS2dENXmpBeqnZw89A7c44vlhuYNWBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q0Z1uG23; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b26e120e300so1222984a12.1
        for <kvm@vger.kernel.org>; Thu, 29 May 2025 15:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748557192; x=1749161992; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ckYpwhp6Hm+pvfi+Cbdt++fTIeJjtPKhaMoLpXy5DIw=;
        b=Q0Z1uG23DnvTzRLZiLEgtgVwWN8oObbtmYNQv7XLiwXXfs95j8JSG1qYNPon3TBuNB
         /IBnNT92Qypm4Q8WDKQEr1NMVSyjEQ2hRWo6qkCx5z+WyoGXt6qF+PYRh3oWd6W3Okj0
         LBI48aFJoRL6xw2QqPS7neUxbN3jtrdi/br11kWWStZNNJkrP69XQK417xAFparlWpHX
         Ukaz1lO8ni0jWUDP1KirPL01d08YqdS9LDFx242EDDmyDyhB+7VBbr+lmQvtwIqnKima
         rscJ8v5DnWd4PXk+3VmW5QfqQ2egXUNYecXdzIsuKnE6OwzCybZ8A1yBA2snSBoSvN38
         G3Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748557192; x=1749161992;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ckYpwhp6Hm+pvfi+Cbdt++fTIeJjtPKhaMoLpXy5DIw=;
        b=w6xBGBMNZytq+ZXPBIl8uu/Y6q0ysB0ti5MRXzNjHsE+aiAA24LSn9Yo960rKoX1LO
         hbY0/Yger4VQi8GmQRFzOElfEtBqyzMZ4286pj1gEWQXvKIRFKWLuKeVF3UdWp780LEu
         7/N2wFCIo0eXgQLjFWKp3podFDpk6Hvbu4qx//s1RWggIlPuT7v2HcgRWi/cnkNo1Rfl
         IeUpoLol2Y1HFx87DJV+yQnSP14/sjj6mIA8PiaO3OPjqjhhRyP6tG0jDUfYzqGQadj7
         J6b6aYw+VSKl3/hoQZbG5z1FrUCsdd0yPfBKFi+zyisfnCCuwiWZSbO8gWuos9BhXSBG
         4gYA==
X-Forwarded-Encrypted: i=1; AJvYcCXfQJPJ4tF0lne/Um/EFlELg5c3j5erP1HhLIEB4c2JUTmVILIAEK1JfS4K6s69295Dmbs=@vger.kernel.org
X-Gm-Message-State: AOJu0YymrYppJW0CCYdsdD5mf90rrcpz874d1NQQj772oOcn/YoXruz8
	vgSd42bzzSt6bm9XdF2ocCxp9iLCb5Sy0QlroD4UJPRfS14uhErF4UR1DdP0ycXRO08AkjCAyB9
	MG1KP2g==
X-Google-Smtp-Source: AGHT+IHG+BQc7caU6eHEAk61KexpAoTaK0e3VVheD8QYsGdTSLRbNUsZ4bpQdlnwNDmTfVxJjIrhBb554GM=
X-Received: from pfwz39.prod.google.com ([2002:a05:6a00:1da7:b0:746:1eb5:7f3e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:2d8c:b0:20d:d31c:cd28
 with SMTP id adf61e73a8af0-21ad94e216amr2088378637.7.1748557192502; Thu, 29
 May 2025 15:19:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 29 May 2025 15:19:20 -0700
In-Reply-To: <20250529221929.3807680-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529221929.3807680-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250529221929.3807680-8-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 07/16] x86/pmu: Rename pmu_gp_counter_is_available()
 to pmu_arch_event_is_available()
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <andrew.jones@linux.dev>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, "=?UTF-8?q?Nico=20B=C3=B6hr?=" <nrb@linux.ibm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Rename pmu_gp_counter_is_available() to pmu_arch_event_is_available() to
reflect what the field and helper actually track.  The availablity of
architectural events has nothing to do with the GP counters themselves.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/pmu.c | 4 ++--
 lib/x86/pmu.h | 6 +++---
 x86/pmu.c     | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index d06e9455..599168ac 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -21,7 +21,7 @@ void pmu_init(void)
 		pmu.gp_counter_mask_length = (cpuid_10.a >> 24) & 0xff;
 
 		/* CPUID.0xA.EBX bit is '1' if a counter is NOT available. */
-		pmu.gp_counter_available = ~cpuid_10.b;
+		pmu.arch_event_available = ~cpuid_10.b;
 
 		if (this_cpu_has(X86_FEATURE_PDCM))
 			pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
@@ -51,7 +51,7 @@ void pmu_init(void)
 		}
 		pmu.gp_counter_width = PMC_DEFAULT_WIDTH;
 		pmu.gp_counter_mask_length = pmu.nr_gp_counters;
-		pmu.gp_counter_available = (1u << pmu.nr_gp_counters) - 1;
+		pmu.arch_event_available = (1u << pmu.nr_gp_counters) - 1;
 
 		if (this_cpu_has_perf_global_status()) {
 			pmu.msr_global_status = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS;
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index f07fbd93..d0ad280a 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -64,7 +64,7 @@ struct pmu_caps {
 	u8 nr_gp_counters;
 	u8 gp_counter_width;
 	u8 gp_counter_mask_length;
-	u32 gp_counter_available;
+	u32 arch_event_available;
 	u32 msr_gp_counter_base;
 	u32 msr_gp_event_select_base;
 
@@ -110,9 +110,9 @@ static inline bool this_cpu_has_perf_global_status(void)
 	return pmu.version > 1;
 }
 
-static inline bool pmu_gp_counter_is_available(int i)
+static inline bool pmu_arch_event_is_available(int i)
 {
-	return pmu.gp_counter_available & BIT(i);
+	return pmu.arch_event_available & BIT(i);
 }
 
 static inline u64 pmu_lbr_version(void)
diff --git a/x86/pmu.c b/x86/pmu.c
index 8cf26b12..0ce34433 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -436,7 +436,7 @@ static void check_gp_counters(void)
 	int i;
 
 	for (i = 0; i < gp_events_size; i++)
-		if (pmu_gp_counter_is_available(i))
+		if (pmu_arch_event_is_available(i))
 			check_gp_counter(&gp_events[i]);
 		else
 			printf("GP event '%s' is disabled\n",
@@ -463,7 +463,7 @@ static void check_counters_many(void)
 	int i, n;
 
 	for (i = 0, n = 0; n < pmu.nr_gp_counters; i++) {
-		if (!pmu_gp_counter_is_available(i))
+		if (!pmu_arch_event_is_available(i))
 			continue;
 
 		cnt[n].ctr = MSR_GP_COUNTERx(n);
@@ -902,7 +902,7 @@ static void set_ref_cycle_expectations(void)
 	uint64_t t0, t1, t2, t3;
 
 	/* Bit 2 enumerates the availability of reference cycles events. */
-	if (!pmu.nr_gp_counters || !pmu_gp_counter_is_available(2))
+	if (!pmu.nr_gp_counters || !pmu_arch_event_is_available(2))
 		return;
 
 	if (this_cpu_has_perf_global_ctrl())
-- 
2.49.0.1204.g71687c7c1d-goog


