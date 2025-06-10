Return-Path: <kvm+bounces-48872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D993CAD4351
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:55:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C94F017664E
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB989266563;
	Tue, 10 Jun 2025 19:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tgV1foPH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65292265CBD
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749585270; cv=none; b=Otr2CL3EJ2UiYoEKh8P1xBhUbPXWIL2NdHRqvyKluUbRndoEAByud9mcz8n5FXdrwIPJI3PlkCD/PbMtM0aurCb/yxETXAK6fjO97rL5oF1gzJT8wx01+64CXKapPMPbVG8dYD2vn5LimNf7maPIVEaKqL3t/oL9I3PUgEFf6Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749585270; c=relaxed/simple;
	bh=tDzI0a6PFfkEFbD1zp1KxUfASXQKAPu+CrGTErPbzoY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UTPu8GB+emYWI4qLVhbLLmNkfQ1804HN9CMyMWLeHl+L5T1yyJRbDxaUq7Pn+e/YBvJbJBsp9GbC05Bi7yVmizROPXu++jEj4sifH0gJYcsEuLkT1R2fantnDXAfiv5rkBcYbR2VKYNaL8XS/UALId4ux8IqHJrxl88lIJqHlGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tgV1foPH; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31202bbaafaso5138892a91.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749585269; x=1750190069; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XsVUMywXjPStvcdrIGAWAyA5AqwnvkdV8p8ovAl4eN0=;
        b=tgV1foPH6IK3pwRi74EXahHQqw6W8N6h5io/oeRYdOq5a2eQehPgOByiS9U1De4tGS
         u5yDDcCqALrXF37YajRvbG4DO0b64nuHtB+QfwhLqx+tTIW+pKMuisbZ87Vj5BDDx7zY
         WgWSdqtZCMIxEYeurva1t6mNMeGxwUneUlZH0EGfgFhncQyD1l45P5QGhpkrr6dYgMpx
         gWTR4kdJ4/rq9yNlWw50dkFTKWiFU7xgbawmV9zrXbIF9DLPcKHEUGP6oFU++FeZMouz
         dPH34TG8eNSibugrKiF61O+Wtn32paql3RkoMzIJXhCLIbOfCYygv0oK9/0zDB5etKEj
         urdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749585269; x=1750190069;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XsVUMywXjPStvcdrIGAWAyA5AqwnvkdV8p8ovAl4eN0=;
        b=xQGXwaZ6Yrok4HoP6xeRO6gl36Oai6uDGkLwqC4eNU0wU3sCbHN/nQwwz5tCRn1BCS
         0Dyc/QMGH99d3iDL77oD/9IT2h7vphMfJ9Uck/FXt4nOus5pczqr9vaCnSu7zxVKIe3+
         gcpnvAxY13xGsYQ+Q99lZtU2+BTQ9QBjd0IS9aZtB34r7m0EiHGGR961sHK325hDgyPO
         0Fd4v1B1C0baMDTYIMgVvGRPPT4sGqBGnG1qNMLRDVz3QCZLJWGLOiydQO7bhg/XfAFS
         bVnsWiGUZtpSr7rPV3ddN3eCst1zOq4RZcvIhgbz6MZRXZwb6GN7InxBkyige/iSfJkr
         AHtw==
X-Gm-Message-State: AOJu0YzOeCRBUQNQ7CGqZQqZdhji6XMM9pjXPLIB/o4Anc8jWCkdOkGc
	1SGKnhE97V1wsBK1DL9neW7LB/EXtAXo/njjqgoebRj+AbOvwZcyGT44ZUTV1ne0lhfirGAlKWw
	mSNR/Gg==
X-Google-Smtp-Source: AGHT+IGXUvueBtaMTTDHzR+RddVhbm31bRNS+NqkdQnhunf7lm2j7pr/pvuCG90K0t2TktGKa+7YfoofJvc=
X-Received: from pjbee14.prod.google.com ([2002:a17:90a:fc4e:b0:311:ba99:22e6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ec87:b0:311:ea13:2e61
 with SMTP id 98e67ed59e1d1-313af26807fmr723501a91.34.1749585268735; Tue, 10
 Jun 2025 12:54:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 12:54:07 -0700
In-Reply-To: <20250610195415.115404-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610195415.115404-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610195415.115404-7-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v2 06/14] x86/pmu: Mark all arch events as
 available on AMD, and rename fields
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>, Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"

Mark all arch events as available on AMD, as AMD PMUs don't provide the
"not available" CPUID field, and the number of GP counters has nothing to
do with which architectural events are available/supported.

Rename gp_counter_mask_length to arch_event_mask_length, and
pmu_gp_counter_is_available() to pmu_arch_event_is_available(), to
reflect what the field and helper actually track.

Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
Fixes: b883751a ("x86/pmu: Update testcases to cover AMD PMU")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/pmu.c | 10 +++++-----
 lib/x86/pmu.h |  8 ++++----
 x86/pmu.c     |  8 ++++----
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index d06e9455..d37c874c 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -18,10 +18,10 @@ void pmu_init(void)
 
 		pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
 		pmu.gp_counter_width = (cpuid_10.a >> 16) & 0xff;
-		pmu.gp_counter_mask_length = (cpuid_10.a >> 24) & 0xff;
+		pmu.arch_event_mask_length = (cpuid_10.a >> 24) & 0xff;
 
-		/* CPUID.0xA.EBX bit is '1' if a counter is NOT available. */
-		pmu.gp_counter_available = ~cpuid_10.b;
+		/* CPUID.0xA.EBX bit is '1' if an arch event is NOT available. */
+		pmu.arch_event_available = ~cpuid_10.b;
 
 		if (this_cpu_has(X86_FEATURE_PDCM))
 			pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
@@ -50,8 +50,8 @@ void pmu_init(void)
 			pmu.msr_gp_event_select_base = MSR_K7_EVNTSEL0;
 		}
 		pmu.gp_counter_width = PMC_DEFAULT_WIDTH;
-		pmu.gp_counter_mask_length = pmu.nr_gp_counters;
-		pmu.gp_counter_available = (1u << pmu.nr_gp_counters) - 1;
+		pmu.arch_event_mask_length = 32;
+		pmu.arch_event_available = -1u;
 
 		if (this_cpu_has_perf_global_status()) {
 			pmu.msr_global_status = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS;
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index f07fbd93..c7dc68c1 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -63,8 +63,8 @@ struct pmu_caps {
 	u8 fixed_counter_width;
 	u8 nr_gp_counters;
 	u8 gp_counter_width;
-	u8 gp_counter_mask_length;
-	u32 gp_counter_available;
+	u8 arch_event_mask_length;
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
index 45c6db3c..e79122ed 100644
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
 
 	t0 = fenced_rdtsc();
@@ -992,7 +992,7 @@ int main(int ac, char **av)
 	printf("PMU version:         %d\n", pmu.version);
 	printf("GP counters:         %d\n", pmu.nr_gp_counters);
 	printf("GP counter width:    %d\n", pmu.gp_counter_width);
-	printf("Mask length:         %d\n", pmu.gp_counter_mask_length);
+	printf("Event Mask length:   %d\n", pmu.arch_event_mask_length);
 	printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
 	printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
 
-- 
2.50.0.rc0.642.g800a2b2222-goog


