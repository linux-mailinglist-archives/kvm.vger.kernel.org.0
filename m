Return-Path: <kvm+bounces-35195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F28D7A0A009
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 02:26:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9D7757A4B02
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87B6A15575C;
	Sat, 11 Jan 2025 01:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YbfoWROv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F8980BEC
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 01:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736558702; cv=none; b=nryk3poybLSzekqc6D57+iiyEQWW4IgC4L75EqKdvgOCYpbXxvtsYOXC9zLVa0aZ7wksuYU01NyEn1YirjuGx8UJQHqmZx6ESsGNID3l5xM6uV6+RDiS+yqflXy2/wdp5ai3XwVwvKjU8LxDdQqo2HRsSXxxDJJGT2SARV869yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736558702; c=relaxed/simple;
	bh=Z8cG7o21aZj/wKnE6C162GYRcbSZevgDOGSsD/YNjgs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nSJKUp1CS+n4RrB6nV0PS0qQNQhE/g1z41vxkn8Vo/FU4LusYOjZouyPZdYDAfn0Ht3WmwENJnVnoXlHT7uGKZzRCFkFc66sPNZ6gyIdfaEuBbVmKe9nHiMnZ5yqHNnO7tfo2xy3LF8FZtbmDPSn2L2je6MhSUu68vR0byPi9I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YbfoWROv; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21648c8601cso42875205ad.2
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 17:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736558700; x=1737163500; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bnP9l4TBgZavFgl9ingoWbV7IQlMfBLutKO12YuuQSs=;
        b=YbfoWROvZAgguomIWPT2IOCf5HdG5fJN00gxks7X1N1E9Eyd0KuD0/1XnGFs2N3jl1
         Ys6CQW6D882WMqALqeCLW0Zauac+2LntVPgQtZhH3P6cptJQWtnudBQIiUMafNBuN4TV
         gz4Re5SqUWWze5TR/v1PE9PrNGhyOwNqFDCG+R/hnK6IPLXN6bUpT+EglR2hkdXFM8Fg
         XXxqL04WxKd5PGmq1WH8/jKCq4WiF3KMi3y2NLYuSoyDyGUoevrFU5TPHKvGB4O/L7A3
         tPlFsqNiyOQCguVLIQXgFskwZYsJvUbgxFXyCmx5/EMyiL8Zw8kbZVVPQRQUYXp0XcmG
         VJRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736558700; x=1737163500;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bnP9l4TBgZavFgl9ingoWbV7IQlMfBLutKO12YuuQSs=;
        b=mO9SQMhW6aZ+W9OfQNv+UjtcCKTxtoF/xUuBoqbYSFo3Qt5VpfGNtf+8PmuUonM60e
         VACYRSO++trt5nwfz++mOGArNF2XBcUlL6dsjkdUB4D/PYQkgL0+pw22XSP+DnTXVKPh
         5gLELrYfrkcp/YyPI798h83kmCNzUN8/U7Gfhu8fNEQiPVgyJMOCsqPQHJruHuMBGCa8
         +/5WLNEJgKPh0kCkg81iqK2pwYmgnksdf1SIRQRrVnyQkhdeIieiXcMK3pvyFROAy35E
         +0wL5c1/ats1wKd9y6VoS93KmaV92rjsJEc7q9mBSljC2Id/3opd+rCp9CygunM+BoEY
         gzqA==
X-Gm-Message-State: AOJu0YySm9XcRRh5j48sfH2nv5BaicUU/D0ZUiYnTmL0EMHqOAiMb5Yp
	16A+oa3JevzyMhnGKvD9UKD98sjPicPDFqyl1pGuZU4Lj4GGNUcxzDr4fXJa4kQF7RYq7OH4A4k
	L0A==
X-Google-Smtp-Source: AGHT+IH1NdERQE8OQLjVGWXsUxxFzmL931Ova+zIR4kc3ay4XMIaQ3TzbpO5jT/NYBJvXHUAPCJZD+fSckk=
X-Received: from pfbfh41.prod.google.com ([2002:a05:6a00:3929:b0:72a:bc54:8507])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:4393:b0:1e1:ca91:b0e3
 with SMTP id adf61e73a8af0-1e88d09e17fmr21120449637.36.1736558700525; Fri, 10
 Jan 2025 17:25:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Jan 2025 17:24:50 -0800
In-Reply-To: <20250111012450.1262638-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111012450.1262638-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20250111012450.1262638-6-seanjc@google.com>
Subject: [PATCH 5/5] KVM: selftests: Rely on KVM_RUN_NEEDS_COMPLETION to
 complete userspace exits
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Michael Ellerman <mpe@ellerman.id.au>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add selftests coverage for KVM_RUN_NEEDS_COMPLETION by redoing KVM_RUN if
and only if KVM states that completion is required.

Opportunistically rename the helper to replace "io" with "exit", as exits
that require completion are no longer limited to I/O.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h            | 8 ++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c                | 4 ++++
 tools/testing/selftests/kvm/lib/ucall_common.c            | 2 +-
 tools/testing/selftests/kvm/lib/x86/processor.c           | 8 +-------
 tools/testing/selftests/kvm/x86/triple_fault_event_test.c | 3 +--
 5 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 78fd597c1b60..86e1850e4e49 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -29,6 +29,8 @@
 
 #define NSEC_PER_SEC 1000000000L
 
+extern bool kvm_has_needs_completion;
+
 struct userspace_mem_region {
 	struct kvm_userspace_memory_region2 region;
 	struct sparsebit *unused_phy_pages;
@@ -634,9 +636,11 @@ static inline int __vcpu_run(struct kvm_vcpu *vcpu)
 
 void vcpu_run_immediate_exit(struct kvm_vcpu *vcpu);
 
-static inline void vcpu_run_complete_io(struct kvm_vcpu *vcpu)
+static inline void vcpu_run_complete_exit(struct kvm_vcpu *vcpu)
 {
-	vcpu_run_immediate_exit(vcpu);
+	if (!kvm_has_needs_completion ||
+	    (vcpu->run->flags & KVM_RUN_NEEDS_COMPLETION))
+		vcpu_run_immediate_exit(vcpu);
 }
 
 struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vcpu *vcpu);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index c9a33766f673..95ac9b981049 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -19,6 +19,8 @@
 
 #define KVM_UTIL_MIN_PFN	2
 
+bool kvm_has_needs_completion;
+
 uint32_t guest_random_seed;
 struct guest_random_state guest_rng;
 static uint32_t last_guest_seed;
@@ -2253,6 +2255,8 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	/* Tell stdout not to buffer its content. */
 	setbuf(stdout, NULL);
 
+	kvm_has_needs_completion = kvm_check_cap(KVM_CAP_NEEDS_COMPLETION);
+
 	guest_random_seed = last_guest_seed = random();
 	pr_info("Random seed: 0x%x\n", guest_random_seed);
 
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 42151e571953..125584a94ba8 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -154,7 +154,7 @@ uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc)
 			    "Guest failed to allocate ucall struct");
 
 		memcpy(uc, addr, sizeof(*uc));
-		vcpu_run_complete_io(vcpu);
+		vcpu_run_complete_exit(vcpu);
 	} else {
 		memset(uc, 0, sizeof(*uc));
 	}
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index bd5a802fa7a5..1db4764e413b 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -1077,13 +1077,7 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vcpu *vcpu)
 			    nested_size, sizeof(state->nested_));
 	}
 
-	/*
-	 * When KVM exits to userspace with KVM_EXIT_IO, KVM guarantees
-	 * guest state is consistent only after userspace re-enters the
-	 * kernel with KVM_RUN.  Complete IO prior to migrating state
-	 * to a new VM.
-	 */
-	vcpu_run_complete_io(vcpu);
+	vcpu_run_complete_exit(vcpu);
 
 	state = malloc(sizeof(*state) + msr_list->nmsrs * sizeof(state->msrs.entries[0]));
 	TEST_ASSERT(state, "-ENOMEM when allocating kvm state");
diff --git a/tools/testing/selftests/kvm/x86/triple_fault_event_test.c b/tools/testing/selftests/kvm/x86/triple_fault_event_test.c
index 56306a19144a..82d732788bc1 100644
--- a/tools/testing/selftests/kvm/x86/triple_fault_event_test.c
+++ b/tools/testing/selftests/kvm/x86/triple_fault_event_test.c
@@ -97,8 +97,7 @@ int main(void)
 	events.flags |= KVM_VCPUEVENT_VALID_TRIPLE_FAULT;
 	events.triple_fault.pending = true;
 	vcpu_events_set(vcpu, &events);
-	run->immediate_exit = true;
-	vcpu_run_complete_io(vcpu);
+	vcpu_run_complete_exit(vcpu);
 
 	vcpu_events_get(vcpu, &events);
 	TEST_ASSERT(events.flags & KVM_VCPUEVENT_VALID_TRIPLE_FAULT,
-- 
2.47.1.613.gc27f4b7a9f-goog


