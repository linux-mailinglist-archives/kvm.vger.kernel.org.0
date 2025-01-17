Return-Path: <kvm+bounces-35890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E6C8A15A14
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:43:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F978161D71
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 23:43:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E19D1DEFE9;
	Fri, 17 Jan 2025 23:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bjs9ww2y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46B31DED69
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 23:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737157331; cv=none; b=hH/J2/fmR9r8BojMHTLOqKI/vSXhZYxxKefmx81aen+QSizpDEln8WP7CIcK/bLNTr788IDBkNxe6IfK0FI4fjPPKfcYxch7K39yXBE2hb7094hzeUB/jLsDO41+XcILaGXRmNLhyp+lLc2hxFCw0QaIIQ/LrjIctugLB8DWI0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737157331; c=relaxed/simple;
	bh=oG+UNPon4gkSzKdzs76TaMgdm7fkMHtHqq0XNrKfbac=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OhUXlBQZEauuJEK8gAkIc4ySVHpj1gUTCyM1LprZmocfpzzL5q8LryzJbvl/eJ11sxxYEHDJPm7DkRVGP8D/aFAlOzRawQDuh6SlCpe2GUQbvoWSnLbM5XAf86C4G8KGdNiZBHDrMaViKNa7Kny4SFahTSpKAC22NBTWtbm91V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bjs9ww2y; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9e4c5343so7336861a91.0
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 15:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737157329; x=1737762129; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qd1PnZJsvM1FzfBG7zwCaXko40uxMjzFk7maIYC2yc0=;
        b=bjs9ww2ydi8/jh0zu4aifgdlP1gNWRTmCTFSVBIq9zdLIAPLtPm/SnxKBbURgI+YM0
         5PvlYyXqudXlkLm+fIfOmCMyvbd4Q11G14YZvixLnuancvRypWR/rXCbDpfZuDY0vksG
         p9DENB7pfqmmK08vU/cj1InwVu0SOJTu235EGDW7O4dk7kBJzbxBerodd41s/moHw4XI
         2nq0bza8WlEOLayH/TDhRbXXesN4HKxCdKCVxLtcZbNZfj2xG3snh6BXGeNMs5Y+aKrn
         UGyvi/sax2KZoncoZo440SMzbPQnXVdBg7pm1e8gefu8HiCI5CHHnQz86e7xmsR76gBM
         m5GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737157329; x=1737762129;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qd1PnZJsvM1FzfBG7zwCaXko40uxMjzFk7maIYC2yc0=;
        b=kpIoxfKbPd4pPMX/DEhKJafvPOgRkbReJQ2Dk+8qpE1GUF0FjqKtfYLGmMw/BbDorC
         /C5xcnw27zQFyQrWpyVoFdu6LzpYcsm6iFae1SG4k+UzIETMPpIXKXckjpTUdQaB11wd
         b3RgF5NB7RYRSTsY/SKZQ9t87GxNm2v9Ra6WOsU4s8Qi8MP5VlTP1ZTrPRQEuslKALdl
         2PQ2w6eXuxWVpW5PLgBNKCVMgwYSFvKcljhASL1bNLYglEmYsBXVexM5+C0aV54+Mslf
         qfHFJPvaYK8UheqwCiSXBS+gcDO6x12DTtUJ6YzfhfwIizTDdQ6+nq2zs06i5GsY7ZVL
         ilcQ==
X-Gm-Message-State: AOJu0YzUMK6ZTGpWJLZCE05jBHJGrUnM1aeG5ZLui+BOzsZLc3xKPe1f
	Jh5hxdtNTaisTfduu40ikixzPbTo3f11vh7EmqLUPFmTqJ9bX9g9yvC1UN/E9AxGBqBQtS9Lz+f
	k0A==
X-Google-Smtp-Source: AGHT+IGCq4VoYgzT8eHzKMuymfKx5/9tPYD6kuhsV64xxrafdgTzhG03udUQ7XcpETuQac3CcCLzzoXi8Es=
X-Received: from pjtd5.prod.google.com ([2002:a17:90b:45:b0:2ee:53fe:d0fc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5146:b0:2ea:a25d:3baa
 with SMTP id 98e67ed59e1d1-2f782c6639dmr6107387a91.5.1737157329063; Fri, 17
 Jan 2025 15:42:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 15:42:00 -0800
In-Reply-To: <20250117234204.2600624-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117234204.2600624-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250117234204.2600624-3-seanjc@google.com>
Subject: [PATCH 2/5] KVM: selftests: Only validate counts for
 hardware-supported arch events
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"

In the Intel PMU counters test, only validate the counts for architectural
events that are supported in hardware.  If an arch event isn't supported,
the event selector may enable a completely different event, and thus the
logic for the expected count is bogus.

This fixes test failures on pre-Icelake systems due to the encoding for
the architectural Top-Down Slots event corresponding to something else
(at least on the Skylake family of CPUs).

Note, validation relies on *hardware* support, not KVM support and not
guest support.  Architectural events are all about enumerating the event
selector encoding; lack of enumeration for an architectural event doesn't
mean the event itself is unsupported, i.e. the event should still count as
expected even if KVM and/or guest CPUID doesn't enumerate the event as
being "architectural".

Note #2, it's desirable to _program_ the architectural event encoding even
if hardware doesn't support the event.  The count can't be validated when
the event is fully enabled, but KVM should still let the guest program the
event selector, and the PMC shouldn't count if the event is disabled.

Fixes: 4f1bd6b16074 ("KVM: selftests: Test Intel PMU architectural events on gp counters")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202501141009.30c629b4-lkp@intel.com
Debugged-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86/pmu_counters_test.c     | 25 +++++++++++++------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
index fe7d72fc8a75..8159615ad492 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -29,6 +29,8 @@
 /* Total number of instructions retired within the measured section. */
 #define NUM_INSNS_RETIRED		(NUM_LOOPS * NUM_INSNS_PER_LOOP + NUM_EXTRA_INSNS)
 
+/* Track which architectural events are supported by hardware. */
+static uint32_t hardware_pmu_arch_events;
 
 static uint8_t kvm_pmu_version;
 static bool kvm_has_perf_caps;
@@ -89,6 +91,7 @@ static struct kvm_vm *pmu_vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 
 	vm = vm_create_with_one_vcpu(vcpu, guest_code);
 	sync_global_to_guest(vm, kvm_pmu_version);
+	sync_global_to_guest(vm, hardware_pmu_arch_events);
 
 	/*
 	 * Set PERF_CAPABILITIES before PMU version as KVM disallows enabling
@@ -152,7 +155,7 @@ static void guest_assert_event_count(uint8_t idx,
 	uint64_t count;
 
 	count = _rdpmc(pmc);
-	if (!this_pmu_has(event))
+	if (!(hardware_pmu_arch_events & BIT(idx)))
 		goto sanity_checks;
 
 	switch (idx) {
@@ -560,7 +563,7 @@ static void test_fixed_counters(uint8_t pmu_version, uint64_t perf_capabilities,
 
 static void test_intel_counters(void)
 {
-	uint8_t nr_arch_events = kvm_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
+	uint8_t nr_arch_events = this_cpu_property(X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH);
 	uint8_t nr_fixed_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_FIXED_COUNTERS);
 	uint8_t nr_gp_counters = kvm_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
 	uint8_t pmu_version = kvm_cpu_property(X86_PROPERTY_PMU_VERSION);
@@ -582,18 +585,26 @@ static void test_intel_counters(void)
 
 	/*
 	 * Detect the existence of events that aren't supported by selftests.
-	 * This will (obviously) fail any time the kernel adds support for a
-	 * new event, but it's worth paying that price to keep the test fresh.
+	 * This will (obviously) fail any time hardware adds support for a new
+	 * event, but it's worth paying that price to keep the test fresh.
 	 */
 	TEST_ASSERT(nr_arch_events <= NR_INTEL_ARCH_EVENTS,
 		    "New architectural event(s) detected; please update this test (length = %u, mask = %x)",
-		    nr_arch_events, kvm_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK));
+		    nr_arch_events, this_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK));
 
 	/*
-	 * Force iterating over known arch events regardless of whether or not
-	 * KVM/hardware supports a given event.
+	 * Iterate over known arch events irrespective of KVM/hardware support
+	 * to verify that KVM doesn't reject programming of events just because
+	 * the *architectural* encoding is unsupported.  Track which events are
+	 * supported in hardware; the guest side will validate supported events
+	 * count correctly, even if *enumeration* of the event is unsupported
+	 * by KVM and/or isn't exposed to the guest.
 	 */
 	nr_arch_events = max_t(typeof(nr_arch_events), nr_arch_events, NR_INTEL_ARCH_EVENTS);
+	for (i = 0; i < nr_arch_events; i++) {
+		if (this_pmu_has(intel_event_to_feature(i).gp_event))
+			hardware_pmu_arch_events |= BIT(i);
+	}
 
 	for (v = 0; v <= max_pmu_version; v++) {
 		for (i = 0; i < ARRAY_SIZE(perf_caps); i++) {
-- 
2.48.0.rc2.279.g1de40edade-goog


