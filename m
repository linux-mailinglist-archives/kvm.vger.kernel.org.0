Return-Path: <kvm+bounces-38271-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4A03A36B28
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:39:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 314553B2B99
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:38:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0544C154C0B;
	Sat, 15 Feb 2025 01:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="plx82uNO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC47515198A
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739583429; cv=none; b=JyfdRik1FEPgR3x/QLvEG/yG09PIgBAwgOGzGszX2EQndD4XpdGrEVmwQkdI3sciExBSh39FZjbdlvYGmgsscaH+6JmLtq0ZfXvFn1SZz7OqdID1Lujrtw9D7uZk1qFGVgNDQJKSWLkNc8mBG/e0Z5SIDMBb+ISOPNqF7JG+cSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739583429; c=relaxed/simple;
	bh=yV21+UlmQ7UDbT9in9Agt0vTzuQCaRp5lcZFz8rXKLI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pGr6pV/VrKftO9hGE7Z52m+EkXvZJ62cHUCIA9kFZ210aUjkFZKvkxUYInMYqaB3NtNzrtzPr/PDsXcId26euA4YjHhIVr5iUTRqKkRiTiKYiwfAI2j/5MHC0dbCcz9OrS0ciXv11HfhxZ2tHSsY4pNvSBzstWWlQ3qipBlOwPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=plx82uNO; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-220fb031245so18258375ad.3
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739583427; x=1740188227; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=V93ykzqiikeTr8r+s5UQGS9+j4AL9I0HytSE8Ra9jwM=;
        b=plx82uNOhIiSx00aUsxzxW2T1QNQ8m8L/XTg64qbv+O3YunyunrNupPwn7DdgLcFeo
         o6ltm6oLxaaUAz2+1Z/s1hiiBEtXDDlU/0GzFt0TfhVaO20QJtAg8kX+xXUDnjXnh6Ek
         SiWJFUq5/XhSHuuKaeHmIoPwDups9YSeAZ0xNpWdfFWSz84Yn4/X2zbhsawL7Rnw6q00
         fiHJBwafrNJzpG+xZLaa6IMqABfoFvo0VpvejUb+7khjQ0SXTP3AsTgl9ilLwUyEEo5E
         DgVSUlAcorBXkdwfD0a6WtYylsl91xQ7G77V1yQHKXXrzvy8NNdgAL4DSzvJzVc2fB3F
         5rKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739583427; x=1740188227;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V93ykzqiikeTr8r+s5UQGS9+j4AL9I0HytSE8Ra9jwM=;
        b=Tky8mxUDpJqUCJhtWzTEaIprJNGQsqD1GGLdF7ju2buI+oNpgkEJl0QHdNm///b7Qy
         UFZesKMDHqQm20hZ6bm1x5ZFcTSGEEN+H/3laqaPP148p4QWV7ZpiBj6utVblcw/SpK6
         W+IYyHqlTVjEA2U7r8UbFUkACSV4sp6lA0wHEXi+30S5kltYOzugoBfyOkwYAsqQa7D8
         4aEgHxB++crvS3Qh7JLradz5PCWnVOs6bb7FT2TEE3+AIYpytt30PN8Fgnodvi7hfOIz
         jjr+KePhAhEyTbw+JByob5GvfD6mSvw833D61bHaeS5SzzvqnQwkMgtxyVmto3qG1PWj
         uO9Q==
X-Gm-Message-State: AOJu0Yx5BNphEMCQz74P+pl3vL4A/7OqwwJsyjSBcqbsM3RPLE3GsVMU
	k6kmkDPHZdJ4kQTmHCAu8w0vyboedy8OvRh9paJzoJYyn7XUG9sA2Px6hRr8/51MaeezsZ5oSI9
	3gQ==
X-Google-Smtp-Source: AGHT+IHIdLY+N8Lf15kBVxcD91GUKsK1qjH559wIZUs29yVzrT92145NA20CJf9aHaeekBnf7B18BxuYDa8=
X-Received: from pjbqc17.prod.google.com ([2002:a17:90b:2891:b0:2e9:ee22:8881])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3a8d:b0:21f:3e2d:7d2e
 with SMTP id d9443c01a7336-22104057f00mr18939625ad.27.1739583427067; Fri, 14
 Feb 2025 17:37:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:36:34 -0800
In-Reply-To: <20250215013636.1214612-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250215013636.1214612-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215013636.1214612-18-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v7 17/18] x86: pmu: Adjust lower boundary of
 branch-misses event
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Since the IBPB command is added to force to trigger a branch miss at
least, the lower boundary of branch misses event is increased to 1 by
default. For these CPUs without IBPB support, adjust dynamically the
lower boundary to 0 to avoid false positive.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 63156ea8..3133abed 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -90,12 +90,12 @@ struct pmu_event {
 	{"llc references", 0x4f2e, 1, 2*N},
 	{"llc misses", 0x412e, 1, 1*N},
 	{"branches", 0x00c4, 1*N, 1.1*N},
-	{"branch misses", 0x00c5, 0, 0.1*N},
+	{"branch misses", 0x00c5, 1, 0.1*N},
 }, amd_gp_events[] = {
 	{"core cycles", 0x0076, 1*N, 50*N},
 	{"instructions", 0x00c0, 10*N, 10.2*N},
 	{"branches", 0x00c2, 1*N, 1.1*N},
-	{"branch misses", 0x00c3, 0, 0.1*N},
+	{"branch misses", 0x00c3, 1, 0.1*N},
 }, fixed_events[] = {
 	{"fixed 0", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
 	{"fixed 1", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 30*N},
@@ -111,6 +111,7 @@ enum {
 	INTEL_REF_CYCLES_IDX	= 2,
 	INTEL_LLC_MISSES_IDX	= 4,
 	INTEL_BRANCHES_IDX	= 5,
+	INTEL_BRANCH_MISS_IDX	= 6,
 };
 
 /*
@@ -120,6 +121,7 @@ enum {
 enum {
 	AMD_INSTRUCTIONS_IDX    = 1,
 	AMD_BRANCHES_IDX	= 2,
+	AMD_BRANCH_MISS_IDX	= 3,
 };
 
 char *buf;
@@ -184,7 +186,8 @@ static inline void loop(u64 cntrs)
 }
 
 static void adjust_events_range(struct pmu_event *gp_events,
-				int instruction_idx, int branch_idx)
+				int instruction_idx, int branch_idx,
+				int branch_miss_idx)
 {
 	/*
 	 * If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are
@@ -202,6 +205,15 @@ static void adjust_events_range(struct pmu_event *gp_events,
 		gp_events[branch_idx].min = LOOP_BRANCHES;
 		gp_events[branch_idx].max = LOOP_BRANCHES;
 	}
+
+	/*
+	 * For CPUs without IBPB support, no way to force to trigger a branch
+	 * miss and the measured branch misses is possible to be 0.  Thus
+	 * overwrite the lower boundary of branch misses event to 0 to avoid
+	 * false positive.
+	 */
+	if (!has_ibpb())
+		gp_events[branch_miss_idx].min = 0;
 }
 
 volatile uint64_t irq_received;
@@ -916,6 +928,7 @@ int main(int ac, char **av)
 {
 	int instruction_idx;
 	int branch_idx;
+	int branch_miss_idx;
 
 	setup_vm();
 	handle_irq(PMI_VECTOR, cnt_overflow);
@@ -932,6 +945,7 @@ int main(int ac, char **av)
 		gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
 		instruction_idx = INTEL_INSTRUCTIONS_IDX;
 		branch_idx = INTEL_BRANCHES_IDX;
+		branch_miss_idx = INTEL_BRANCH_MISS_IDX;
 
 		/*
 		 * For legacy Intel CPUS without clflush/clflushopt support,
@@ -948,9 +962,10 @@ int main(int ac, char **av)
 		gp_events = (struct pmu_event *)amd_gp_events;
 		instruction_idx = AMD_INSTRUCTIONS_IDX;
 		branch_idx = AMD_BRANCHES_IDX;
+		branch_miss_idx = AMD_BRANCH_MISS_IDX;
 		report_prefix_push("AMD");
 	}
-	adjust_events_range(gp_events, instruction_idx, branch_idx);
+	adjust_events_range(gp_events, instruction_idx, branch_idx, branch_miss_idx);
 
 	printf("PMU version:         %d\n", pmu.version);
 	printf("GP counters:         %d\n", pmu.nr_gp_counters);
-- 
2.48.1.601.g30ceb7b040-goog


