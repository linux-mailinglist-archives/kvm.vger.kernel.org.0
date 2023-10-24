Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40EA47D4400
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 02:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbjJXA1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 20:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbjJXA1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 20:27:33 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E27C110
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:27:01 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a839b31a0dso75529797b3.0
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 17:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698107219; x=1698712019; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=14wArEVnBNhNrbZ4s3cIhEfuNUwYxvC64ZUFQ1mIX8Y=;
        b=nTIWCNrVOi4oWDJcxrd7dX3VpfEMFgMw8vyCBc5tB6ggMhlwXYvOVBzyw+AvzF5wob
         gIDwhJIR7mXT/3UhsK4+N4PepcSIAcF6ceRhc7vg27nO09eSrVvpNF2Yr7fiAwSpMUBs
         fNuITbfgNemreJ7n4sHVWJHGr9uuhAOZLOrPjG9yQoR5MX6kqxBAGHRErUjdg7N+Btpw
         7VBnYJ2jAVz2PKA9Ul013LZogOOTXE+Lpd6t3n5/KSGcNXWh3ig4b24fcdTWd8rwa5+0
         nCtvEEqRCFPKJazlIL7DcnQbqA/N0saxzc71dxG7pCZhJCcME+RrsL//Xc3aB1BEbXpR
         f2Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698107219; x=1698712019;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=14wArEVnBNhNrbZ4s3cIhEfuNUwYxvC64ZUFQ1mIX8Y=;
        b=NtW4ekbySGqLRzNsU5nP10zoXW9v4Kq/ypy75EW8pB/DUUGbODjNDD7+ZqRwYzYvqI
         U7r9u2pANjDcOPpuoWT4nG+5a1cuUhqip/R5lilrGsIUxYksOEeAn1PgBU3LW4OWSaXA
         yadcWDRobRPnuXlHm5FnsuqdEklHGY+5Lv3gMaPpDq7GVTqSxNUSl8ozCTk06U1pdch3
         XVXTHzPdhHZ/ffSqCZ1KUzlu9qTtuFR3ejnyI3MxbvS98AqCo1x8n4gRM+C8Kx+fs/YK
         1EANcKq9rXpRbA+wLg5R+eNn5ZHwqfPmR+ehDPSEWYZAfT1V9RHU6+iP6ijlykfg+vsp
         op3A==
X-Gm-Message-State: AOJu0YwJGSCywuRErsDqh7/Ooq7L+4XASjvD/kSu6O0I2UpY1mTWMXe6
        WG0QXf4fnLTxLWalg/aXraVo0J9E+iA=
X-Google-Smtp-Source: AGHT+IG2LW9PGB9cXobco7ikpUCA0s3PI34T5IQvsTCHhMRo8sFby8GDriPs96/3MflKnfZN+sOTJMSSRpM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ccd4:0:b0:58c:b45f:3e94 with SMTP id
 o203-20020a0dccd4000000b0058cb45f3e94mr209290ywd.8.1698107218929; Mon, 23 Oct
 2023 17:26:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 23 Oct 2023 17:26:32 -0700
In-Reply-To: <20231024002633.2540714-1-seanjc@google.com>
Mime-Version: 1.0
References: <20231024002633.2540714-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
Message-ID: <20231024002633.2540714-13-seanjc@google.com>
Subject: [PATCH v5 12/13] KVM: selftests: Add functional test for Intel's
 fixed PMU counters
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinrong Liang <cloudliang@tencent.com>,
        Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

Extend the fixed counters test to verify that supported counters can
actually be enabled in the control MSRs, that unsupported counters cannot,
and that enabled counters actually count.

Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
[sean: fold into the rd/wr access test, massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 29 ++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index f1d9cdd69a17..1c392ad156f4 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -266,7 +266,6 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
 		vector = wrmsr_safe(msr, 0);
 		GUEST_ASSERT_PMC_MSR_ACCESS(WRMSR, msr, expect_gp, vector);
 	}
-	GUEST_DONE();
 }
 
 static void guest_test_gp_counters(void)
@@ -280,6 +279,7 @@ static void guest_test_gp_counters(void)
 		base_msr = MSR_IA32_PERFCTR0;
 
 	guest_rd_wr_counters(base_msr, MAX_NR_GP_COUNTERS, nr_gp_counters, 0);
+	GUEST_DONE();
 }
 
 static void test_gp_counters(uint8_t nr_gp_counters, uint64_t perf_cap)
@@ -302,6 +302,7 @@ static void guest_test_fixed_counters(void)
 {
 	uint64_t supported_bitmask = 0;
 	uint8_t nr_fixed_counters = 0;
+	uint8_t i;
 
 	/* KVM provides fixed counters iff the vPMU version is 2+. */
 	if (this_cpu_property(X86_PROPERTY_PMU_VERSION) >= 2)
@@ -316,6 +317,32 @@ static void guest_test_fixed_counters(void)
 
 	guest_rd_wr_counters(MSR_CORE_PERF_FIXED_CTR0, MAX_NR_FIXED_COUNTERS,
 			     nr_fixed_counters, supported_bitmask);
+
+	for (i = 0; i < MAX_NR_FIXED_COUNTERS; i++) {
+		uint8_t vector;
+		uint64_t val;
+
+		if (i >= nr_fixed_counters && !(supported_bitmask & BIT_ULL(i))) {
+			vector = wrmsr_safe(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * i));
+			__GUEST_ASSERT(vector == GP_VECTOR,
+				       "Expected #GP for counter %u in FIXED_CTRL_CTRL", i);
+
+			vector = wrmsr_safe(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(PMC_IDX_FIXED + i));
+			__GUEST_ASSERT(vector == GP_VECTOR,
+				       "Expected #GP for counter %u in PERF_GLOBAL_CTRL", i);
+			continue;
+		}
+
+		wrmsr(MSR_CORE_PERF_FIXED_CTR0 + i, 0);
+		wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, BIT_ULL(4 * i));
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, BIT_ULL(PMC_IDX_FIXED + i));
+		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
+		val = rdmsr(MSR_CORE_PERF_FIXED_CTR0 + i);
+
+		GUEST_ASSERT_NE(val, 0);
+	}
+	GUEST_DONE();
 }
 
 static void test_fixed_counters(uint8_t nr_fixed_counters,
-- 
2.42.0.758.gaed0368e0e-goog

