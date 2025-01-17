Return-Path: <kvm+bounces-35892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ADF72A15A1B
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:44:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 329317A466A
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 23:43:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F2B1DF740;
	Fri, 17 Jan 2025 23:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0QUH+eUl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9A71DEFD0
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 23:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737157335; cv=none; b=bRKQpHIZZs638+kDOcxWOzokUMsQYql0nxsdvLfYksTG5ZVYlP+rF/Z+pUKL7znVElKGsZooP2/SDyvHcHeBQfP9U6VMY9QHoeKqUOKc3JVqWINXLccQfhisCHunqYTx0SQQoZFFn5mZJlDSdNBlR/voDPJEPkgfgm5JbMzYS+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737157335; c=relaxed/simple;
	bh=ZOZoGCVVjfxwPE63Fb+anUDkEumJG2NT8k4n4QFHs9A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jYYSLfDys2lwMNVbKXUxrvbO6eNxLDcHHHVeuWgnLbosD8tmN3BuTQs3gQuyGopo+SeMTko0WhtUjWvYgxrJdr0N1/MG0SnCPi6Wlxo7kxlfduQnWj/lOGiedBmz7niBtYwTbqhYoliy5S92jY+7E+8JCFI36RtRIsFrlb/rvVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0QUH+eUl; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2165433e229so54687595ad.1
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 15:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737157332; x=1737762132; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UJQf1vg2Z73BDDDgXp9DDB+nVYcRI9guP/ajlKCHN4g=;
        b=0QUH+eUlWNblb9wLmi7wRjDMcnGuyvQ5X+6Ow5xJvRGjPSd522/NY3V45u1dVZqoft
         N0r2Y86MTmr/PcXqduqhJSWGCHobg+b+06zADV+Qc+Leugaao/UG/tdJHkK+HgcVjw8W
         V43ci0F8ZymPvrJtFdCI/qr6gO8KC58JqNsIG6LCT4byvqTPUw9lq5sRGqD2m2bBHHfk
         hhAjBgBOC+U2Za7WIiz+BrMPltjM00ncRczg/pwqG4EPYr/ymknlz+b1LErfvPOg8kbQ
         dLVUl2a3S/uM/NeiTV2+zL/Cv3MqwNe5S3DE6deqqy7Y1P3rZlOuvos08GoT2yq8IrYO
         nAkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737157332; x=1737762132;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UJQf1vg2Z73BDDDgXp9DDB+nVYcRI9guP/ajlKCHN4g=;
        b=EMjz/PYDEr8DQvwIJ89/so4jwAGdQY5bNK5zs4pfYdE58V2uYQOhL6BmavCbaLRIcU
         Fqz6Iz2wEUhlKhAt2Et2p/T5HOi6Uaj1ZPbbV3ub5lb8w4CxUVYk4mBhNEvpu6vL4vtq
         FuRbVzx26xD5fb6x8fk5POytlcUyIlrspue4XAQErCdWgdgE21ByFFhA6SAIjcZAxUUP
         Kdet8IGjuPHPyPBqgzeZF4OABhC+ky59L8mF/M6LveH8MmeExf+uxUU6ct9+k13TXNPJ
         d6ScUY/E85J4p+zABSjN/IY1iQi4E1EX9CP6FBwmVhxSvO54c46VV+IZwAdNw+79faej
         n6ow==
X-Gm-Message-State: AOJu0YyDrqlRdr7iiOPpHzyZFoSNtuHx63WTPNZN/kXMe+9qypy4Iu0F
	2aO/1P+g8CojX7pbITi+mQKrCgUVlY9EvV0a5J/mOdgJXLqFLzahkzYYdrAzIs8bQhnv7g5tQgq
	54A==
X-Google-Smtp-Source: AGHT+IHAZZuFQSpQ2KtVwY8a38VsEnuTS+M1mZ9T6GgAxDV6x3yWEr1YlzfIlLku3fU1H6bhMmu72cUeHNs=
X-Received: from pllq16.prod.google.com ([2002:a17:902:7890:b0:212:5134:8485])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:947:b0:216:5b64:90f6
 with SMTP id d9443c01a7336-21c355fa2eamr68609215ad.45.1737157332542; Fri, 17
 Jan 2025 15:42:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 Jan 2025 15:42:02 -0800
In-Reply-To: <20250117234204.2600624-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117234204.2600624-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250117234204.2600624-5-seanjc@google.com>
Subject: [PATCH 4/5] KVM: selftests: Drop the "feature event" param from guest
 test helpers
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Now that validation of event count is tied to hardware support for event,
and not to guest support for an event, drop the unused "event" parameter
from the various helpers.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86/pmu_counters_test.c     | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
index 5d6a5b9c17b3..ea1485a08c78 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -148,9 +148,7 @@ static uint8_t guest_get_pmu_version(void)
  * Sanity check that in all cases, the event doesn't count when it's disabled,
  * and that KVM correctly emulates the write of an arbitrary value.
  */
-static void guest_assert_event_count(uint8_t idx,
-				     struct kvm_x86_pmu_feature event,
-				     uint32_t pmc, uint32_t pmc_msr)
+static void guest_assert_event_count(uint8_t idx, uint32_t pmc, uint32_t pmc_msr)
 {
 	uint64_t count;
 
@@ -223,7 +221,7 @@ do {										\
 	);									\
 } while (0)
 
-#define GUEST_TEST_EVENT(_idx, _event, _pmc, _pmc_msr, _ctrl_msr, _value, FEP)	\
+#define GUEST_TEST_EVENT(_idx, _pmc, _pmc_msr, _ctrl_msr, _value, FEP)		\
 do {										\
 	wrmsr(_pmc_msr, 0);							\
 										\
@@ -234,17 +232,16 @@ do {										\
 	else									\
 		GUEST_MEASURE_EVENT(_ctrl_msr, _value, "nop", FEP);		\
 										\
-	guest_assert_event_count(_idx, _event, _pmc, _pmc_msr);			\
+	guest_assert_event_count(_idx, _pmc, _pmc_msr);				\
 } while (0)
 
-static void __guest_test_arch_event(uint8_t idx, struct kvm_x86_pmu_feature event,
-				    uint32_t pmc, uint32_t pmc_msr,
+static void __guest_test_arch_event(uint8_t idx, uint32_t pmc, uint32_t pmc_msr,
 				    uint32_t ctrl_msr, uint64_t ctrl_msr_value)
 {
-	GUEST_TEST_EVENT(idx, event, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, "");
+	GUEST_TEST_EVENT(idx, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, "");
 
 	if (is_forced_emulation_enabled)
-		GUEST_TEST_EVENT(idx, event, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, KVM_FEP);
+		GUEST_TEST_EVENT(idx, pmc, pmc_msr, ctrl_msr, ctrl_msr_value, KVM_FEP);
 }
 
 static void guest_test_arch_event(uint8_t idx)
@@ -280,7 +277,7 @@ static void guest_test_arch_event(uint8_t idx)
 		if (guest_has_perf_global_ctrl)
 			wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(i));
 
-		__guest_test_arch_event(idx, gp_event, i, base_pmc_msr + i,
+		__guest_test_arch_event(idx, i, base_pmc_msr + i,
 					MSR_P6_EVNTSEL0 + i, eventsel);
 	}
 
@@ -295,7 +292,7 @@ static void guest_test_arch_event(uint8_t idx)
 
 	wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, FIXED_PMC_CTRL(i, FIXED_PMC_KERNEL));
 
-	__guest_test_arch_event(idx, fixed_event, i | INTEL_RDPMC_FIXED,
+	__guest_test_arch_event(idx, i | INTEL_RDPMC_FIXED,
 				MSR_CORE_PERF_FIXED_CTR0 + i,
 				MSR_CORE_PERF_GLOBAL_CTRL,
 				FIXED_PMC_GLOBAL_CTRL_ENABLE(i));
-- 
2.48.0.rc2.279.g1de40edade-goog


