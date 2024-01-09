Return-Path: <kvm+bounces-5920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE0C2829069
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:03:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 807E5288A83
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:03:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D2623E49F;
	Tue,  9 Jan 2024 23:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2MU+ORTS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8B73E472
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 23:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5f53b4554b6so49582797b3.3
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 15:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704841375; x=1705446175; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tXsV5Mg+VvJOgGB933IW2BaWsp1tYo1T/RC8C6lgjm8=;
        b=2MU+ORTSm2htKkCH8uXfKpPUyBU45YIGXNm7BFlwd3eiy3L6U+R7kAomhfyZ00qfZG
         mEsV25h+IyQOTL8T3W3DpovOZJfRL+vRrMTRvCZpAP9+MKjQF7Zn+eFLXfS0mPC4XTkZ
         A/6XCkn2ly0jRRrS09eBxEV2K0S/m77q3Nq0ZxwNqk3SXCse6mFc7QuVJ8PhSYr6RiX/
         as0oO3O556TQUVuFn6VU37o+BeQQa4wxT7Heax5gk49Ri1o0btEHaBa8hp05c+Bgp6hd
         kCaUIv3ibY5wmedHijLHDPmQjOw4e5A+ff7aXrc/nnCE4vF5BSPz3Lkrd+sn2rGjwzsQ
         sj2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704841375; x=1705446175;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tXsV5Mg+VvJOgGB933IW2BaWsp1tYo1T/RC8C6lgjm8=;
        b=kLdt87VZ0O6kBmr6TRoGili6cHovbCfovn0QovdnGFzoBXZf9Wxd3DNQIKsL1z1wAT
         1zz+iYGGu22MkfRo0iu59WOUfCQkb2Hyv+QOtCBxS1ABO7rUUPpXVO2814Hofnrhwr0q
         xLugKXNp3Nverae1uJPbcyKp5EOiPyKzQS8w3QzBX99khnYyg5tT4hmKWT6Pityc0k08
         MCIDtrpRHwZbpxcvkSD4ThPX9Cxe4WPQNUzMnKPqAHltTMA71ygc9Ox13mXjDTAmg/Fu
         ZegOwTf7D80gyeuZxmkvd5yeaeySuecjwhnLZw9EWme0O1x5qSEPN+eNcM+QAw/iQjTy
         FYQw==
X-Gm-Message-State: AOJu0YykAcMW6PD226oxeEPf2zPZrQ/L+1t8TrKJ2FKy0iYFgIOgvwrC
	s9TWo8lGNn3In8qT73pmJ48Ioi8F1bLALDJjLA==
X-Google-Smtp-Source: AGHT+IHLyDG4Y+yA6YSmcp0NuC3vLgus5tCcAOHj2QDp3cAqMJFNLZ1YxcUGjpmNXT2wYTkfJoaOBoVsZL8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:c16:b0:5ee:2b5:7d75 with SMTP id
 cl22-20020a05690c0c1600b005ee02b57d75mr83986ywb.8.1704841374981; Tue, 09 Jan
 2024 15:02:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 15:02:21 -0800
In-Reply-To: <20240109230250.424295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109230250.424295-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109230250.424295-2-seanjc@google.com>
Subject: [PATCH v10 01/29] KVM: x86/pmu: Always treat Fixed counters as
 available when supported
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Treat fixed counters as available when they are supported, i.e. don't
silently ignore an enabled fixed counter just because guest CPUID says the
associated general purpose architectural event is unavailable.

KVM originally treated fixed counters as always available, but that got
changed as part of a fix to avoid confusing REF_CPU_CYCLES, which does NOT
map to an architectural event, with the actual architectural event used
associated with bit 7, TOPDOWN_SLOTS.

The commit justified the change with:

    If the event is marked as unavailable in the Intel guest CPUID
    0AH.EBX leaf, we need to avoid any perf_event creation, whether
    it's a gp or fixed counter.

but that justification doesn't mesh with reality.  The Intel SDM uses
"architectural events" to refer to both general purpose events (the ones
with the reverse polarity mask in CPUID.0xA.EBX) and the events for fixed
counters, e.g. the SDM makes statements like:

  Each of the fixed-function PMC can count only one architectural
  performance event.

but the fact that fixed counter 2 (TSC reference cycles) doesn't have an
associated general purpose architectural makes trying to apply the mask
from CPUID.0xA.EBX impossible.

Furthermore, the lack of enumeration for an architectural event in CPUID
only means the CPU doesn't officially support the architectural encoding,
i.e. it doesn't mean using the architectural encoding _won't_ work, it
sipmly means there are no guarantees that it will work as expected.  E.g.
if KVM is running in a VM that advertises a fixed counters but not the
corresponding architectural event encoding, and perf decides to use a
general purpose counter instead of a fixed counter, odds are very good
that the underlying hardware actually does support the architectrual
encoding, and that programming the encoding will count the right thing.

In other words, asking perf to count the event will probably work, whereas
intentionally doing nothing is obviously guaranteed to fail.

Note, at the time of the change, KVM didn't enforce hardware support, i.e.
didn't prevent userspace from enumerating support in guest CPUID.0xA.EBX
for architectural events that aren't supported in hardware.  I.e. silently
dropping the fixed counter didn't somehow protection against counting the
wrong event, it just enforced guest CPUID.  And practically speaking, this
issue is almost certainly limited to running KVM on a funky virtual CPU
model.  No known real hardware has an asymmetric PMU where a fixed counter
is supported but the associated architectural event is not.

Fixes: a21864486f7e ("KVM: x86/pmu: Fix available_event_types check for REF_CPU_CYCLES event")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index a6216c874729..8207f8c03585 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -108,11 +108,24 @@ static bool intel_hw_event_available(struct kvm_pmc *pmc)
 	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
 	int i;
 
+	/*
+	 * Fixed counters are always available if KVM reaches this point.  If a
+	 * fixed counter is unsupported in hardware or guest CPUID, KVM doesn't
+	 * allow the counter's corresponding MSR to be written.  KVM does use
+	 * architectural events to program fixed counters, as the interface to
+	 * perf doesn't allow requesting a specific fixed counter, e.g. perf
+	 * may (sadly) back a guest fixed PMC with a general purposed counter.
+	 * But if _hardware_ doesn't support the associated event, KVM simply
+	 * doesn't enumerate support for the fixed counter.
+	 */
+	if (pmc_is_fixed(pmc))
+		return true;
+
 	BUILD_BUG_ON(ARRAY_SIZE(intel_arch_events) != NR_INTEL_ARCH_EVENTS);
 
 	/*
 	 * Disallow events reported as unavailable in guest CPUID.  Note, this
-	 * doesn't apply to pseudo-architectural events.
+	 * doesn't apply to pseudo-architectural events (see above).
 	 */
 	for (i = 0; i < NR_REAL_INTEL_ARCH_EVENTS; i++) {
 		if (intel_arch_events[i].eventsel != event_select ||
-- 
2.43.0.472.g3155946c3a-goog


