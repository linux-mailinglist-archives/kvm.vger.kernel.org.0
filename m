Return-Path: <kvm+bounces-35891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93DC2A15A17
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:43:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D9ADB188AFD6
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 23:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 231B51DEFEA;
	Fri, 17 Jan 2025 23:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QTQIc0kt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC2B1DEFCD
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 23:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737157333; cv=none; b=Wf1B7z4UpIvUMRwNNJ2pRt9PSgaPhY4QneGe8K7PcG8YOMHJpNhei6PoUXgVtOSDuH0lYinR11LcHl6eO452E9T3NNZtWov52CKkfnRyz7qQD414LxVyRLWbleHo5s/m7fB92d6ITu7KPl0a2tTOrEk8eLq3u4XFrT+wFBp80N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737157333; c=relaxed/simple;
	bh=UgNzJe2HpFIZOmF+tKSnwRW92d2shs8YrcRwvXNVrKA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DfMOeUq/mQEla863l8bWl+xW6Mbfc8krFOJ/Gc7rSdUU2ortwoh4LYO33nXcor6uFKNzzoDtcas7wGTYSVcdGUANMrMIAbMPeGyJX71qkiE+3l/8OWcptRkorO/8Iqu8tnoFrN4NMLfo3xUMq95LGPUhJZixl3I3bS5MEfJ6UUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QTQIc0kt; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-216430a88b0so54146755ad.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 15:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737157331; x=1737762131; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=F2492f7FPUKL3RQM1y5e+QPeaYBUqrrlq2XUG+1uNeI=;
        b=QTQIc0ktWy/K/nbmTD2o7Wm9lruGxnLybuSVz6V6GVLsZWOGtFHeWUmKH99HR3rOJx
         xkJ4WzEiBazESX58cCe9HTKMO6/mvtGF271pbq9SCzYKaPImXrkSa0RqdWQI4hRS+skZ
         QM+14ha1XE9hvkeJuuStgfC6KXTPoBqC01Wd69lTzYlYpUafMptgAeaYOgFhTUGrQQYs
         HZxLvbmbAkyEEmdvtTtoRY0SxeXQyk0FsWp89b8NNJC39a3rmDJbym7TjS+AKQTAzNY+
         IsFBHjYXYTTn2M67Cx7hsDPSbOrzE8tEy+UWyPP57kkDuZrMQskgInORO0Llj9BxnfnB
         YX9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737157331; x=1737762131;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F2492f7FPUKL3RQM1y5e+QPeaYBUqrrlq2XUG+1uNeI=;
        b=tsaTLYG1YwBHZv5JI39QmpaF0yLEOMun8ki+6sg50FhvTx073uP0FqgJM+JjVM4nze
         DD62A59a8Y8trz9nzyuZSVviuoCcvnqU/3T8piRbXIyEhWgnFJBcfb/unWtuol9h6Rru
         xm4841QYdL4MB0S+TqTl4BZeCuen/W8n0yheH+B2zh/wTmUyjV8hB5HtQDF9UK78teoH
         pjoGZbsrF55cTobPXequwZrWDhPyhL/3gdyeHC3ETx5hlV3wMYgjonp5uW4/mMolwIdm
         uuJRUnEjNsXIsGLxMwKl9iFk9nG8FRDudpPQlDuZyMUnYEPi4k2GkQr9QhIVEPAEB5L3
         M2/Q==
X-Gm-Message-State: AOJu0Yyzo9FMD9EEcK839SGeMlBgcW3O0hWKLrJ7ew6FJ2CnfWMk5zNj
	7UGepC5UZyZ4we2yfDJC0lps0+4jvVLtZHwdCj/1YQUTAknSo3G2P4BdimAKP2mhzXNU3OLMCNK
	3Zg==
X-Google-Smtp-Source: AGHT+IEutRKWetWajOjuPthgKFxwMopyW+ltQmCIIbAd9AjyS3fmj4hN5vvPtxTp1Msub1a8TFENrUJtLiI=
X-Received: from pgbcm6.prod.google.com ([2002:a05:6a02:a06:b0:801:d783:5f1e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:32a3:b0:1e8:bd15:6801
 with SMTP id adf61e73a8af0-1eb2158bd23mr7439870637.29.1737157330717; Fri, 17
 Jan 2025 15:42:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 15:42:01 -0800
In-Reply-To: <20250117234204.2600624-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117234204.2600624-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250117234204.2600624-4-seanjc@google.com>
Subject: [PATCH 3/5] KVM: selftests: Remove dead code in Intel PMU counters test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Drop the local "nr_arch_events" in the Intel PMU counters test as the test
asserts that "nr_arch_events <= NR_INTEL_ARCH_EVENTS", and then sets
nr_arch_events to the max of the two.  I.e. nr_arch_events is guaranteed
to be NR_INTEL_ARCH_EVENTS for the meat of the test, just use
NR_INTEL_ARCH_EVENTS directly.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86/pmu_counters_test.c       | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
index 8159615ad492..5d6a5b9c17b3 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -563,7 +563,6 @@ static void test_fixed_counters(uint8_t pmu_version, uint64_t perf_capabilities,
 
 static void test_intel_counters(void)
 {
-	uint8_t nr_arch_events = this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
 	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
 	uint8_t nr_gp_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
 	uint8_t pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
@@ -588,9 +587,10 @@ static void test_intel_counters(void)
 	 * This will (obviously) fail any time hardware adds support for a new
 	 * event, but it's worth paying that price to keep the test fresh.
 	 */
-	TEST_ASSERT(nr_arch_events <= NR_INTEL_ARCH_EVENTS,
+	TEST_ASSERT(this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH) <= NR_INTEL_ARCH_EVENTS,
 		    "New architectural event(s) detected; please update this test (length = %u, mask = %x)",
-		    nr_arch_events, this_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK));
+		    this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH),
+		    this_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK));
 
 	/*
 	 * Iterate over known arch events irrespective of KVM/hardware support
@@ -600,8 +600,7 @@ static void test_intel_counters(void)
 	 * count correctly, even if *enumeration* of the event is unsupported
 	 * by KVM and/or isn't exposed to the guest.
 	 */
-	nr_arch_events = max_t(typeof(nr_arch_events), nr_arch_events, NR_INTEL_ARCH_EVENTS);
-	for (i = 0; i < nr_arch_events; i++) {
+	for (i = 0; i < NR_INTEL_ARCH_EVENTS; i++) {
 		if (this_pmu_has(intel_event_to_feature(i).gp_event))
 			hardware_pmu_arch_events |= BIT(i);
 	}
@@ -620,8 +619,8 @@ static void test_intel_counters(void)
 			 * vector length.
 			 */
 			if (v == pmu_version) {
-				for (k = 1; k < (BIT(nr_arch_events) - 1); k++)
-					test_arch_events(v, perf_caps[i], nr_arch_events, k);
+				for (k = 1; k < (BIT(NR_INTEL_ARCH_EVENTS) - 1); k++)
+					test_arch_events(v, perf_caps[i], NR_INTEL_ARCH_EVENTS, k);
 			}
 			/*
 			 * Test single bits for all PMU version and lengths up
@@ -630,11 +629,11 @@ static void test_intel_counters(void)
 			 * host length).  Explicitly test a mask of '0' and all
 			 * ones i.e. all events being available and unavailable.
 			 */
-			for (j = 0; j <= nr_arch_events + 1; j++) {
+			for (j = 0; j <= NR_INTEL_ARCH_EVENTS + 1; j++) {
 				test_arch_events(v, perf_caps[i], j, 0);
 				test_arch_events(v, perf_caps[i], j, 0xff);
 
-				for (k = 0; k < nr_arch_events; k++)
+				for (k = 0; k < NR_INTEL_ARCH_EVENTS; k++)
 					test_arch_events(v, perf_caps[i], j, BIT(k));
 			}
 
-- 
2.48.0.rc2.279.g1de40edade-goog


