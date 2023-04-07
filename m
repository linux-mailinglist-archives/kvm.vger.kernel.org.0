Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A4D6DB72C
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 01:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbjDGXdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 19:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjDGXdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 19:33:00 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EB2A27B
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 16:32:59 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1a52677bd54so33645ad.3
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 16:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680910379;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tX6CHwqi/+vmAQd+dDGZvcYGjpDNB6U9rI2y1SgCLzw=;
        b=RLzZoZSEkChrmMCPyzSpJD0n7OXG3YTfsqfzcbpwWeuBNjcXghAd1GPxNF2dBSM95T
         MZVmw2W5OIhJkicZCCx9GyxPygEc5yjfPd53kEqF8EZ8fAVF2dMpv2T+/TOGe1MLlE4f
         8+nTWr7oZLD1NvwZ2MtMeQmLByizaUHQEv/PYwM8wQJZ4HgKMATa2iR2KJikY6EPkz/l
         7qXw1fH6XUkewjscrAfl1tqyedbr8Xhji+gWZxZt4E5NgUOd//MTwZrOuAn5oBfoUIoi
         YioelxJ9i1FChJ4Ra7nSiubcpLS4Kf2w8anZe2xsByMn6PHmdK8nmXRoZBRXWJOSsHbG
         yyDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680910379;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tX6CHwqi/+vmAQd+dDGZvcYGjpDNB6U9rI2y1SgCLzw=;
        b=k0V9Sf9wQbHSsId8iemVmKsk+/qCkiW0ykbgNdaxUc/9eILkoDROZFOmqe1/czRsHJ
         ow0OyUqj5/ODxWN/Zfrm6V+y6H0awyY5B7djFDsS6xOZ0gnQT+9MLPskLH8eTVLwWnhG
         NdPCZM7o5OXlhgFAmHCdykH2UUnsR0vt17gU6G12QKcIY/Q4PEZtYe0encJ3sT8eSMMA
         f286hTpFenpXAIPRFshkpylOe3DzXfoHSpqSfCV0YWlyUt5Tt+ve2gByhJGIq8066C4H
         mE6h7fToxaYqsxXvlY+EIoW8+bNNaRxMwuECJIkjdx/Mg3EiEK1CSTf0gZmb9nCNN66v
         D91Q==
X-Gm-Message-State: AAQBX9c8gee6C+2LBTQF4p9hqbBNxYNRJhPvJ4pkeR4E4kwJFk9yuy3i
        2FMX/yE8tEz0mxQenZXHWTTmuG2RsRM=
X-Google-Smtp-Source: AKy350ZGq+TQ7AlXgBYJyAMCF0BuViAvumLgn7XWPmozlegCdHMqWepTb3jR1sXsT7XitimErc5F4qNdd6g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1354:b0:62d:e8f1:edbf with SMTP id
 k20-20020a056a00135400b0062de8f1edbfmr1967544pfu.5.1680910379429; Fri, 07 Apr
 2023 16:32:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  7 Apr 2023 16:32:49 -0700
In-Reply-To: <20230407233254.957013-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230407233254.957013-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230407233254.957013-2-seanjc@google.com>
Subject: [PATCH v4 1/6] KVM: selftests: Add a common helper for the PMU event
 filter guest code
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Aaron Lewis <aaronlewis@google.com>

Split out the common parts of the Intel and AMD guest code in the PMU
event filter test into a helper function.  This is in preparation for
adding additional counters to the test.

No functional changes intended.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 29 ++++++++++++-------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 1f60dfae69e0..a00a9d6ea41e 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -100,6 +100,15 @@ static void check_msr(uint32_t msr, uint64_t bits_to_flip)
 		GUEST_SYNC(0);
 }
 
+static uint64_t run_and_measure_loop(uint32_t msr_base)
+{
+	uint64_t branches_retired = rdmsr(msr_base + 0);
+
+	__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+
+	return rdmsr(msr_base + 0) - branches_retired;
+}
+
 static void intel_guest_code(void)
 {
 	check_msr(MSR_CORE_PERF_GLOBAL_CTRL, 1);
@@ -108,16 +117,15 @@ static void intel_guest_code(void)
 	GUEST_SYNC(1);
 
 	for (;;) {
-		uint64_t br0, br1;
+		uint64_t count;
 
 		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0);
 		wrmsr(MSR_P6_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ENABLE |
 		      ARCH_PERFMON_EVENTSEL_OS | INTEL_BR_RETIRED);
-		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 1);
-		br0 = rdmsr(MSR_IA32_PMC0);
-		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
-		br1 = rdmsr(MSR_IA32_PMC0);
-		GUEST_SYNC(br1 - br0);
+		wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, 0x1);
+
+		count = run_and_measure_loop(MSR_IA32_PMC0);
+		GUEST_SYNC(count);
 	}
 }
 
@@ -133,15 +141,14 @@ static void amd_guest_code(void)
 	GUEST_SYNC(1);
 
 	for (;;) {
-		uint64_t br0, br1;
+		uint64_t count;
 
 		wrmsr(MSR_K7_EVNTSEL0, 0);
 		wrmsr(MSR_K7_EVNTSEL0, ARCH_PERFMON_EVENTSEL_ENABLE |
 		      ARCH_PERFMON_EVENTSEL_OS | AMD_ZEN_BR_RETIRED);
-		br0 = rdmsr(MSR_K7_PERFCTR0);
-		__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
-		br1 = rdmsr(MSR_K7_PERFCTR0);
-		GUEST_SYNC(br1 - br0);
+
+		count = run_and_measure_loop(MSR_K7_PERFCTR0);
+		GUEST_SYNC(count);
 	}
 }
 
-- 
2.40.0.577.gac1e443424-goog

