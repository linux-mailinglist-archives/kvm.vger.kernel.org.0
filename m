Return-Path: <kvm+bounces-3212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F0588018A6
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 01:07:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF1201F210F5
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16BC7BE60;
	Sat,  2 Dec 2023 00:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WkRoMeuk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC59173B
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 16:05:15 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-db539c987e0so1538752276.3
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 16:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701475515; x=1702080315; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xw+c5GCsB2b8QDdbiEI/AG23aqiIRhU7uRpXc8eyon4=;
        b=WkRoMeuko5UfiH3J/18cIfBk1gCbDo1soCgiSVD2hd56Qv4TnX8smp4Ygii8l5KeAI
         QGHhHNLZqoatieppkT8MzCt7nKGhv4evi9+Kt6QLyDJUw/s+hdSC+FqhnKa3QO4FKnJY
         bQxvCdX2yh3fBwDcJjyv4VQr7q5rez9QtWpLRR3wh7JjBL5NMRGbX3YXtT/3OFRPKXl7
         4vx7JSEz7vWGXpGshQQTbtJwpkQbshhLXFHV2Y3LB7mBrrmqb1M1E47nOKJ2GSblCRWN
         KHEhQDfIBHdZNZNiqfumbY//7oHTMSDVChc49nDJ8GaLJNRj6YsmQxDR1UhY73Oo9UGV
         LjAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701475515; x=1702080315;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xw+c5GCsB2b8QDdbiEI/AG23aqiIRhU7uRpXc8eyon4=;
        b=p8FShGBwoIUnWMOAVqrAk+Z+76N47cWSmYzWrZayqUQxKdxDlh9Sf0/x4bmGuktMXg
         j1Tv5m44eBhy9nRALSGSvs4/5T+Q08J9PTh58DZq821NQflTkl5183umNwPu81vW6Gpe
         QvrYpPSx38q+POVLY5zcW7ZSnB8aVSMQ6pMWTJxm3FIEtS6Kib6UhNrp5kUsA1VDSkz8
         cFP7tPHPITiN33pC3sH7M2tbwU7tgtrd09JSfc0POhG5ayCkFQa3Eweh3pL160V53Xnd
         DWxtf2UV8LAOOM5dMvrNgoStT9zvoD0iVEpSwJNoUvMwf4wSKseDWEYhV7qypbeIjCgc
         F6rA==
X-Gm-Message-State: AOJu0YxoQFhivYP6LARfj5/oZGJ8uVSnO/XgcVKut258c+s/glJPN6kL
	DchJOrFYYcf94zsneLHmr86XtxuhUCw=
X-Google-Smtp-Source: AGHT+IGhkJP5g/XYfw/UjHT//gHh8kp5x/HRzqm+5MPT1PYzribzU2fOgOj6KCB2Mi95jvctFRT8RUus6/0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3f87:0:b0:d9a:36cd:482e with SMTP id
 m129-20020a253f87000000b00d9a36cd482emr838388yba.13.1701475515032; Fri, 01
 Dec 2023 16:05:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Dec 2023 16:04:17 -0800
In-Reply-To: <20231202000417.922113-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231202000417.922113-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231202000417.922113-29-seanjc@google.com>
Subject: [PATCH v9 28/28] KVM: selftests: Extend PMU counters test to validate
 RDPMC after WRMSR
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Extend the read/write PMU counters subtest to verify that RDPMC also reads
back the written value.  Opportunsitically verify that attempting to use
the "fast" mode of RDPMC fails, as the "fast" flag is only supported by
non-architectural PMUs, which KVM doesn't virtualize.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 41 +++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index cb808ac827ba..ae5f6042f1e8 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -325,9 +325,30 @@ __GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
 		       "Expected " #insn "(0x%x) to yield 0x%lx, got 0x%lx",	\
 		       msr, expected_val, val);
 
+static void guest_test_rdpmc(uint32_t rdpmc_idx, bool expect_success,
+			     uint64_t expected_val)
+{
+	uint8_t vector;
+	uint64_t val;
+
+	vector = rdpmc_safe(rdpmc_idx, &val);
+	GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, !expect_success, vector);
+	if (expect_success)
+		GUEST_ASSERT_PMC_VALUE(RDPMC, rdpmc_idx, val, expected_val);
+
+	if (!is_forced_emulation_enabled)
+		return;
+
+	vector = rdpmc_safe_fep(rdpmc_idx, &val);
+	GUEST_ASSERT_PMC_MSR_ACCESS(RDPMC, rdpmc_idx, !expect_success, vector);
+	if (expect_success)
+		GUEST_ASSERT_PMC_VALUE(RDPMC, rdpmc_idx, val, expected_val);
+}
+
 static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters,
 				 uint8_t nr_counters, uint32_t or_mask)
 {
+	const bool pmu_has_fast_mode = !guest_get_pmu_version();
 	uint8_t i;
 
 	for (i = 0; i < nr_possible_counters; i++) {
@@ -352,6 +373,7 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		const uint64_t expected_val = expect_success ? test_val : 0;
 		const bool expect_gp = !expect_success && msr != MSR_P6_PERFCTR0 &&
 				       msr != MSR_P6_PERFCTR1;
+		uint32_t rdpmc_idx;
 		uint8_t vector;
 		uint64_t val;
 
@@ -365,6 +387,25 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		if (!expect_gp)
 			GUEST_ASSERT_PMC_VALUE(RDMSR, msr, val, expected_val);
 
+		/*
+		 * Redo the read tests with RDPMC, which has different indexing
+		 * semantics and additional capabilities.
+		 */
+		rdpmc_idx = i;
+		if (base_msr == MSR_CORE_PERF_FIXED_CTR0)
+			rdpmc_idx |= INTEL_RDPMC_FIXED;
+
+		guest_test_rdpmc(rdpmc_idx, expect_success, expected_val);
+
+		/*
+		 * KVM doesn't support non-architectural PMUs, i.e. it should
+		 * impossible to have fast mode RDPMC.  Verify that attempting
+		 * to use fast RDPMC always #GPs.
+		 */
+		GUEST_ASSERT(!expect_success || !pmu_has_fast_mode);
+		rdpmc_idx |= INTEL_RDPMC_FAST;
+		guest_test_rdpmc(rdpmc_idx, false, -1ull);
+
 		vector = wrmsr_safe(msr, 0);
 		GUEST_ASSERT_PMC_MSR_ACCESS(WRMSR, msr, expect_gp, vector);
 	}
-- 
2.43.0.rc2.451.g8631bc7472-goog


