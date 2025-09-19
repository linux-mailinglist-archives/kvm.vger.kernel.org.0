Return-Path: <kvm+bounces-58209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17916B8B653
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 23:48:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C27F1A03D6F
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 21:48:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45F1C2D9492;
	Fri, 19 Sep 2025 21:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OFp13PLE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAE12D73BC
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 21:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758318424; cv=none; b=fE8dFdboAjvmoAM+8qFtX21MB0dMA1fVNTbzA9KH5UK5oE4yLYcvv6niVnjA/OeuJbCeUW+oZC9wlZn5Sa4JWa9vJO5E7JEtGYkzvu3wf3qoYpCQ5D6A0vcA4eHzcaDpb9DxRIfoBAmGv5eyB4xr5UIcgEBhp31WJVkn2X+IS5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758318424; c=relaxed/simple;
	bh=yO3JEo1gYQ22V8DqNjbRfmd8m+LrLHhsM5TYNkemtf8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PbwtbKONaimsp5VeWPgDPdUuRiYvwCRFqiL8PHA3aopn3OfzrLZOjzOpvooH457D9VOhFO2CiKnB0riYqpc7zSZLvcZQcM63f48eDAajwq6SIsWtK5aRJz7FC/ur65kZXrOLz6I0eXAXtD3/+SC/dYZsTwDoVEaQffIpDXvTuSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OFp13PLE; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3306543e5abso2734861a91.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 14:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758318422; x=1758923222; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=aGJDmdH0XuW9VoBWZqHlk5s0b4rUO2PpVukglaa1uz4=;
        b=OFp13PLE7LyI5bcHTGv8xJ7tfWLkse5vz4K5ucB2uGxhSQ+g73URIbeQqsfF1GThuL
         DvvuAUCzeXhvv+h4G43VNzpgGiohp8fu8UTcYRxGx67oort+s/AIu80lQWMTJt44XYDK
         tWzAnraTJgHcWqPge46AT1PxP9uOF2IE8+P4NetAhzgpAM/GGo6sDGJLQcM+qvzgmZP1
         IV7RZ+8IYOS6aXKw2/f6WgEph8uWKqKfmhUtu+gV0dEeUTv+PfIQtNrHRJLVuiKY2bkR
         OYong+MvY1NyhpvwTON45YktkQjL6uI36hOaGZFrFB64Y9fOl0xLyzpfRobxzhXPC+eS
         dk8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758318422; x=1758923222;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aGJDmdH0XuW9VoBWZqHlk5s0b4rUO2PpVukglaa1uz4=;
        b=r2ldlyZgLCO92S3XI/NwH0VgScVcAGLfykRm2xkMepVMtayrTQ4RdiaSPStN6Vj0Mb
         ZqIh8439jQF6XvrnLipuS16VsrPZU91vCV6QOoXvY7LTNlTEJV0dB5a836sZ/Qa2UURm
         I/TQmqa1mAvcsI13wuzpD4lFdcIV30ZAKNMjlizYojXUY64EjgpcoJh9CMFjyohRGccx
         Z6PH2E4MT5NuzuT3tIj3Ja9FZqP2Vg2K1HzRp6Ml6/snGHRm5ctChTbm/F9CufbYpMAS
         o/IjJIyWnwIpH3oN3NKBTCwiQ6AznKTyxLG5vSkBITS+UNPCMOLdbhpKMYK5Xn29mrQY
         eVuQ==
X-Gm-Message-State: AOJu0Yxln2qmzVfVEbo/sjvGvBxPuhJWYEmVrg64UE7EUos9yegrEjpk
	QZ0mT7HRti1ouoJegGT7inIZJ/iccVZE0FC5UaiK/9jb3LtzsSwG4TeV1hfrn1RWoQj776exd6H
	DWOzWCA==
X-Google-Smtp-Source: AGHT+IFmOOJ5i2v0JR24srl71cUW7/V9SOM6YX9wBDcSuO9dLUxwTCC8CYl9EjGbxOY/GbrXUOKTCRB1e48=
X-Received: from pjbok3.prod.google.com ([2002:a17:90b:1d43:b0:328:116e:273])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1cc7:b0:32d:e309:8d76
 with SMTP id 98e67ed59e1d1-33093851ef6mr6424377a91.10.1758318422354; Fri, 19
 Sep 2025 14:47:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 14:46:47 -0700
In-Reply-To: <20250919214648.1585683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919214648.1585683-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919214648.1585683-5-seanjc@google.com>
Subject: [PATCH v4 4/5] KVM: selftests: Validate more arch-events in pmu_counters_test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Yi Lai <yi1.lai@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Add support for 5 new architectural events (4 topdown level 1 metrics
events and LBR inserts event) that will first show up in Intel's
Clearwater Forest CPUs.  Detailed info about the new events can be found
in SDM section 21.2.7 "Pre-defined Architectural  Performance Events".

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
[sean: drop "unavailable_mask" changes]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86/pmu.h       | 10 ++++++++++
 tools/testing/selftests/kvm/include/x86/processor.h |  7 ++++++-
 tools/testing/selftests/kvm/lib/x86/pmu.c           |  5 +++++
 tools/testing/selftests/kvm/x86/pmu_counters_test.c |  8 ++++++++
 4 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86/pmu.h b/tools/testing/selftests/kvm/include/x86/pmu.h
index 3c10c4dc0ae8..2aabda2da002 100644
--- a/tools/testing/selftests/kvm/include/x86/pmu.h
+++ b/tools/testing/selftests/kvm/include/x86/pmu.h
@@ -61,6 +61,11 @@
 #define	INTEL_ARCH_BRANCHES_RETIRED		RAW_EVENT(0xc4, 0x00)
 #define	INTEL_ARCH_BRANCHES_MISPREDICTED	RAW_EVENT(0xc5, 0x00)
 #define	INTEL_ARCH_TOPDOWN_SLOTS		RAW_EVENT(0xa4, 0x01)
+#define	INTEL_ARCH_TOPDOWN_BE_BOUND		RAW_EVENT(0xa4, 0x02)
+#define	INTEL_ARCH_TOPDOWN_BAD_SPEC		RAW_EVENT(0x73, 0x00)
+#define	INTEL_ARCH_TOPDOWN_FE_BOUND		RAW_EVENT(0x9c, 0x01)
+#define	INTEL_ARCH_TOPDOWN_RETIRING		RAW_EVENT(0xc2, 0x02)
+#define	INTEL_ARCH_LBR_INSERTS			RAW_EVENT(0xe4, 0x01)
 
 #define	AMD_ZEN_CORE_CYCLES			RAW_EVENT(0x76, 0x00)
 #define	AMD_ZEN_INSTRUCTIONS_RETIRED		RAW_EVENT(0xc0, 0x00)
@@ -80,6 +85,11 @@ enum intel_pmu_architectural_events {
 	INTEL_ARCH_BRANCHES_RETIRED_INDEX,
 	INTEL_ARCH_BRANCHES_MISPREDICTED_INDEX,
 	INTEL_ARCH_TOPDOWN_SLOTS_INDEX,
+	INTEL_ARCH_TOPDOWN_BE_BOUND_INDEX,
+	INTEL_ARCH_TOPDOWN_BAD_SPEC_INDEX,
+	INTEL_ARCH_TOPDOWN_FE_BOUND_INDEX,
+	INTEL_ARCH_TOPDOWN_RETIRING_INDEX,
+	INTEL_ARCH_LBR_INSERTS_INDEX,
 	NR_INTEL_ARCH_EVENTS,
 };
 
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index efcc4b1de523..e8bad89fbb7f 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -265,7 +265,7 @@ struct kvm_x86_cpu_property {
 #define X86_PROPERTY_PMU_NR_GP_COUNTERS		KVM_X86_CPU_PROPERTY(0xa, 0, EAX, 8, 15)
 #define X86_PROPERTY_PMU_GP_COUNTERS_BIT_WIDTH	KVM_X86_CPU_PROPERTY(0xa, 0, EAX, 16, 23)
 #define X86_PROPERTY_PMU_EBX_BIT_VECTOR_LENGTH	KVM_X86_CPU_PROPERTY(0xa, 0, EAX, 24, 31)
-#define X86_PROPERTY_PMU_EVENTS_MASK		KVM_X86_CPU_PROPERTY(0xa, 0, EBX, 0, 7)
+#define X86_PROPERTY_PMU_EVENTS_MASK		KVM_X86_CPU_PROPERTY(0xa, 0, EBX, 0, 12)
 #define X86_PROPERTY_PMU_FIXED_COUNTERS_BITMASK	KVM_X86_CPU_PROPERTY(0xa, 0, ECX, 0, 31)
 #define X86_PROPERTY_PMU_NR_FIXED_COUNTERS	KVM_X86_CPU_PROPERTY(0xa, 0, EDX, 0, 4)
 #define X86_PROPERTY_PMU_FIXED_COUNTERS_BIT_WIDTH	KVM_X86_CPU_PROPERTY(0xa, 0, EDX, 5, 12)
@@ -332,6 +332,11 @@ struct kvm_x86_pmu_feature {
 #define X86_PMU_FEATURE_BRANCH_INSNS_RETIRED		KVM_X86_PMU_FEATURE(EBX, 5)
 #define X86_PMU_FEATURE_BRANCHES_MISPREDICTED		KVM_X86_PMU_FEATURE(EBX, 6)
 #define X86_PMU_FEATURE_TOPDOWN_SLOTS			KVM_X86_PMU_FEATURE(EBX, 7)
+#define X86_PMU_FEATURE_TOPDOWN_BE_BOUND		KVM_X86_PMU_FEATURE(EBX, 8)
+#define X86_PMU_FEATURE_TOPDOWN_BAD_SPEC		KVM_X86_PMU_FEATURE(EBX, 9)
+#define X86_PMU_FEATURE_TOPDOWN_FE_BOUND		KVM_X86_PMU_FEATURE(EBX, 10)
+#define X86_PMU_FEATURE_TOPDOWN_RETIRING		KVM_X86_PMU_FEATURE(EBX, 11)
+#define X86_PMU_FEATURE_LBR_INSERTS			KVM_X86_PMU_FEATURE(EBX, 12)
 
 #define X86_PMU_FEATURE_INSNS_RETIRED_FIXED		KVM_X86_PMU_FEATURE(ECX, 0)
 #define X86_PMU_FEATURE_CPU_CYCLES_FIXED		KVM_X86_PMU_FEATURE(ECX, 1)
diff --git a/tools/testing/selftests/kvm/lib/x86/pmu.c b/tools/testing/selftests/kvm/lib/x86/pmu.c
index f31f0427c17c..5ab44bf54773 100644
--- a/tools/testing/selftests/kvm/lib/x86/pmu.c
+++ b/tools/testing/selftests/kvm/lib/x86/pmu.c
@@ -19,6 +19,11 @@ const uint64_t intel_pmu_arch_events[] = {
 	INTEL_ARCH_BRANCHES_RETIRED,
 	INTEL_ARCH_BRANCHES_MISPREDICTED,
 	INTEL_ARCH_TOPDOWN_SLOTS,
+	INTEL_ARCH_TOPDOWN_BE_BOUND,
+	INTEL_ARCH_TOPDOWN_BAD_SPEC,
+	INTEL_ARCH_TOPDOWN_FE_BOUND,
+	INTEL_ARCH_TOPDOWN_RETIRING,
+	INTEL_ARCH_LBR_INSERTS,
 };
 kvm_static_assert(ARRAY_SIZE(intel_pmu_arch_events) == NR_INTEL_ARCH_EVENTS);
 
diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
index c6987a9b65bf..24599d98f898 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -75,6 +75,11 @@ static struct kvm_intel_pmu_event intel_event_to_feature(uint8_t idx)
 		[INTEL_ARCH_BRANCHES_RETIRED_INDEX]	 = { X86_PMU_FEATURE_BRANCH_INSNS_RETIRED, X86_PMU_FEATURE_NULL },
 		[INTEL_ARCH_BRANCHES_MISPREDICTED_INDEX] = { X86_PMU_FEATURE_BRANCHES_MISPREDICTED, X86_PMU_FEATURE_NULL },
 		[INTEL_ARCH_TOPDOWN_SLOTS_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_SLOTS, X86_PMU_FEATURE_TOPDOWN_SLOTS_FIXED },
+		[INTEL_ARCH_TOPDOWN_BE_BOUND_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_BE_BOUND, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_TOPDOWN_BAD_SPEC_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_BAD_SPEC, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_TOPDOWN_FE_BOUND_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_FE_BOUND, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_TOPDOWN_RETIRING_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_RETIRING, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_LBR_INSERTS_INDEX]		 = { X86_PMU_FEATURE_LBR_INSERTS, X86_PMU_FEATURE_NULL },
 	};
 
 	kvm_static_assert(ARRAY_SIZE(__intel_event_to_feature) == NR_INTEL_ARCH_EVENTS);
@@ -171,9 +176,12 @@ static void guest_assert_event_count(uint8_t idx, uint32_t pmc, uint32_t pmc_msr
 		fallthrough;
 	case INTEL_ARCH_CPU_CYCLES_INDEX:
 	case INTEL_ARCH_REFERENCE_CYCLES_INDEX:
+	case INTEL_ARCH_TOPDOWN_BE_BOUND_INDEX:
+	case INTEL_ARCH_TOPDOWN_FE_BOUND_INDEX:
 		GUEST_ASSERT_NE(count, 0);
 		break;
 	case INTEL_ARCH_TOPDOWN_SLOTS_INDEX:
+	case INTEL_ARCH_TOPDOWN_RETIRING_INDEX:
 		__GUEST_ASSERT(count >= NUM_INSNS_RETIRED,
 			       "Expected top-down slots >= %u, got count = %lu",
 			       NUM_INSNS_RETIRED, count);
-- 
2.51.0.470.ga7dc726c21-goog


