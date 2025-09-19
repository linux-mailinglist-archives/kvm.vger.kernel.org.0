Return-Path: <kvm+bounces-58091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 09225B87878
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 02:46:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2FD2C7BCA99
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 00:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29D242580E2;
	Fri, 19 Sep 2025 00:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a9sUMLYD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98941255F22
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758242723; cv=none; b=j2lR5iEZQuDX/DmqAOQ9Os1Wbh4qpVOkVxMZi69x3w0K20beHgc7VljQcts4AuZyXGxNcBPctdw42Bi5eu8ijAfpWxgpQHBgloL6qVi1vQYBo0jufA7H8gLo66ailF7kXMpIJaMdw7zRzq36fFaIZGOFdyp1SLtn5jtZqgRoFjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758242723; c=relaxed/simple;
	bh=G6eMhQa9bWNC+XplAop1XK+Xh9jgbUrMu5W7u7341tE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bmEbbJ01xKVn2Ex0zCgSjU4tWDkRwCtBvj2Wi3x+ZSVw1CttWNh627ZrSEKefi2BaspofrhMsnO9tPwApOPuWCNfJjFwMHG4AZV+8qdLVJEbN8bQa3KNBus9FWP70BmdqqcI3x2fqylKEOy5FP9QhRvDnvvY1C6jtWUve/t6Hgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a9sUMLYD; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2681623f927so15881195ad.0
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 17:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758242720; x=1758847520; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vXIBv0GQwub5RA4uH8L4E8fQo/KxZfvrFKX34u31kBs=;
        b=a9sUMLYDx+78mOE2FcKlLpy4gjpX1fu9Gxwi0jp/nJMQqf2mnWabqaM9MViPJc/63k
         6rZZnG+8FOcWMMe6S4SlZ92JeQ4LLO83U2JN+33RWw+D0bC0tVrD5+qeOCr1QkpIKr9b
         qPk1eJpHspO4i15kmQS6EFuWzhxmAO2/bHemtFLG7YriZUZHWk5hNd4K243PSvQoMXeQ
         m7GPu7C+VGvKVYgoSOn3Hrb+iQjlQsyssYEyVXxkiBXZaTSq7P/Z/XXpRucfEMy9TbnF
         0A63Knh8O3KkQp8nWpPiU6zZN8kSd/wxlRlUd41WFc4UVQDW+8uGYJdqSk8iEi3DUgoI
         mkaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758242720; x=1758847520;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vXIBv0GQwub5RA4uH8L4E8fQo/KxZfvrFKX34u31kBs=;
        b=lKt5mJiNmVBSZAqjBwOKGhXX4k3z6QsgBpoOK7J12sJHZw1X5BijwDl+pjK4J6d5PJ
         EDvCWZr+y1ccfPiPqADMLcAvdt+qM++qBARuQWFofDcpK64nNAnUNyZMmThKHim5YKBz
         yKkoonS9hLnE1OsDySaf3CBUEMYBciu7cgtjpxg6aJvbsOE1lh0I2OAku/GP4uTU9zzp
         FWkQ/WcSonOyOXxecLDN0ph4j3JcGQuKr+Mii5qj8VhVYenmFLrZXvsBni4iKV0FPd5x
         KgfeZBQtmCJBqvmUvY0dMS3Tf+YRWK54DkvXLPTvt53iW9MeMbW8bmOOdFE7FfFlpjVJ
         Be7g==
X-Gm-Message-State: AOJu0YzhsU04oJH8fdkrwBV83TfxPu4pKp5LMdacBWVkTPQ8HL8mv23E
	76qlV/zLPaj2INGawyxe5kOyxk1S8OlSdSc8Jc11buNrZE7buqqFngAv3gbz2kvPFWduJhhAH04
	frqsgcA==
X-Google-Smtp-Source: AGHT+IH4P8o7YsHg2AvqNf6MyeD4mOg5GT4mfEZFfwOPrDg+yC4Lmup3ALcz80Gr9PLAOz55sh2XicSWDG0=
X-Received: from pjc6.prod.google.com ([2002:a17:90b:2f46:b0:329:d461:9889])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2ac7:b0:264:4e4a:904d
 with SMTP id d9443c01a7336-269ba431f33mr17669575ad.15.1758242719892; Thu, 18
 Sep 2025 17:45:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 18 Sep 2025 17:45:10 -0700
In-Reply-To: <20250919004512.1359828-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919004512.1359828-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919004512.1359828-4-seanjc@google.com>
Subject: [PATCH v3 3/5] KVM: selftests: Reduce number of "unavailable PMU
 events" combos tested
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Yi Lai <yi1.lai@intel.com>, 
	dongsheng <dongsheng.x.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Reduce the number of combinations of unavailable PMU events masks that are
testing by the PMU counters test.  In reality, testing every possible
combination isn't all that interesting, and certainly not worth the tens
of seconds (or worse, minutes) of runtime.  Fully testing the N^2 space
will be especially problematic in the near future, as 5! new arch events
are on their way.

Use alternating bit patterns (and 0 and -1u) in the hopes that _if_ there
is ever a KVM bug, it's not something horribly convoluted that shows up
only with a super specific pattern/value.

Reported-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86/pmu_counters_test.c     | 38 +++++++++++--------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
index cfeed0103341..e805882bc306 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -577,6 +577,26 @@ static void test_intel_counters(void)
 		PMU_CAP_FW_WRITES,
 	};
 
+	/*
+	 * To keep the total runtime reasonable, test only a handful of select,
+	 * semi-arbitrary values for the mask of unavailable PMU events.  Test
+	 * 0 (all events available) and all ones (no events available) as well
+	 * as alternating bit sequencues, e.g. to detect if KVM is checking the
+	 * wrong bit(s).
+	 */
+	const uint32_t unavailable_masks[] = {
+		0x0,
+		0xffffffffu,
+		0xaaaaaaaau,
+		0x55555555u,
+		0xf0f0f0f0u,
+		0x0f0f0f0fu,
+		0xa0a0a0a0u,
+		0x0a0a0a0au,
+		0x50505050u,
+		0x05050505u,
+	};
+
 	/*
 	 * Test up to PMU v5, which is the current maximum version defined by
 	 * Intel, i.e. is the last version that is guaranteed to be backwards
@@ -614,16 +634,7 @@ static void test_intel_counters(void)
 
 			pr_info("Testing arch events, PMU version %u, perf_caps = %lx\n",
 				v, perf_caps[i]);
-			/*
-			 * To keep the total runtime reasonable, test every
-			 * possible non-zero, non-reserved bitmap combination
-			 * only with the native PMU version and the full bit
-			 * vector length.
-			 */
-			if (v == pmu_version) {
-				for (k = 1; k < (BIT(NR_INTEL_ARCH_EVENTS) - 1); k++)
-					test_arch_events(v, perf_caps[i], NR_INTEL_ARCH_EVENTS, k);
-			}
+
 			/*
 			 * Test single bits for all PMU version and lengths up
 			 * the number of events +1 (to verify KVM doesn't do
@@ -632,11 +643,8 @@ static void test_intel_counters(void)
 			 * ones i.e. all events being available and unavailable.
 			 */
 			for (j = 0; j <= NR_INTEL_ARCH_EVENTS + 1; j++) {
-				test_arch_events(v, perf_caps[i], j, 0);
-				test_arch_events(v, perf_caps[i], j, -1u);
-
-				for (k = 0; k < NR_INTEL_ARCH_EVENTS; k++)
-					test_arch_events(v, perf_caps[i], j, BIT(k));
+				for (k = 1; k < ARRAY_SIZE(unavailable_masks); k++)
+					test_arch_events(v, perf_caps[i], j, unavailable_masks[k]);
 			}
 
 			pr_info("Testing GP counters, PMU version %u, perf_caps = %lx\n",
-- 
2.51.0.470.ga7dc726c21-goog


