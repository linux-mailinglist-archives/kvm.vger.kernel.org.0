Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05216170F9
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbiKBWwe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbiKBWwJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:52:09 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7D5DF77
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:52:01 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b14-20020a056902030e00b006a827d81fd8so269096ybs.17
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=e4mlXl0E8yyixJoTmq/osLccAxenVj7q523We2HIVL0=;
        b=NE5ponGfPvHr3N9sdQC2BUeKXhpsf6Yrj4JjfXOSJVVk/gSufmhD2SekFy7r7iaw8C
         u7JHxkQ23Pq2+W0fIejZ9EtqnYRX7kuIHmtdXR4Fb9hwbSUlJcI8QEh6mQDfsMerUtOP
         X3nDAHqaZ3PsorAnZtQXHMnlWgMAxSPGC02VXggrb9bII5YMe2zJL7Q9oQijrk7qE7+T
         ++8oElF46J2XR63DENtaNEVjVhCzwBkzDIqsdZQyuXG8EV4zHb0tYtQMjlGT9SEsoWXk
         6tXWnV6ggwEIdp466Dp/eNQNSebom37lYDB3RPQliEVvfqz7vhruLJR7vj4rS17N7/ZK
         A2jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e4mlXl0E8yyixJoTmq/osLccAxenVj7q523We2HIVL0=;
        b=ogOiy5eucsIUbi9sMpJDUZ3QyGQ2ciSmBUuxvWyIatIiC3Bv+U/+t7+f8J7P7PQZKG
         1HvD3kOvrgHf6/skogTyhNjGjJo50q9Rr4KwyqhWbbdTmWVxbYVVybjvvvspTJ0S21CQ
         vdiGPEDreqDAZrRAOfhrlDbNnhooVmzNA3Qkem3pURMGLTzi/Q5vzCexLCiBHT2omHYp
         PuhUPb49qGdbcSmmCPw0G8owEpxCDa5ZiH+s1+d8iZHbyhMr0B7sAaHxLvUOUSB69unN
         dOpFuj9FrZ72I24OdGY1yWSGPlBleJhJCtFusqDbYsCF740X+jbPKWunbJIuvGpAda62
         mcdQ==
X-Gm-Message-State: ACrzQf2Wvc0YPaMjqFEaoo/8lqayX8u8Bciye5cpOFRGfC0dqhIzAWpn
        7cJnYH/vPOFxU/kwpyWoehG33F8y10k=
X-Google-Smtp-Source: AMsMyM50xR3XLj1/8zeuEz/uIcBHsJKfVd3mLYvVBNYOJII9qTnJ/PmDVKsfAvoQ5WPTYudEA6QQdb3L4RI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:54d5:0:b0:368:d1eb:3a0c with SMTP id
 i204-20020a8154d5000000b00368d1eb3a0cmr190623ywb.369.1667429519826; Wed, 02
 Nov 2022 15:51:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:51:10 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-28-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 27/27] x86/pmu: Add AMD Guest PerfMonV2 testcases
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Updated test cases to cover KVM enabling code for AMD Guest PerfMonV2.

The Intel-specific PMU helpers were added to check for AMD cpuid, and
some of the same semantics of MSRs were assigned during the initialization
phase. The vast majority of pmu test cases are reused seamlessly.

On some x86 machines (AMD only), even with retired events, the same
workload is measured repeatedly and the number of events collected is
erratic, which essentially reflects the details of hardware implementation,
and from a software perspective, the type of event is an unprecise event,
which brings a tolerance check in the counter overflow testcases.

Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/msr.h       |  5 +++++
 lib/x86/pmu.c       | 14 +++++++++++++-
 lib/x86/processor.h |  2 +-
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 6cf8f336..c9869be5 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -426,6 +426,11 @@
 #define MSR_CORE_PERF_GLOBAL_CTRL	0x0000038f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x00000390
 
+/* AMD Performance Counter Global Status and Control MSRs */
+#define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS	0xc0000300
+#define MSR_AMD64_PERF_CNTR_GLOBAL_CTL		0xc0000301
+#define MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR	0xc0000302
+
 /* Geode defined MSRs */
 #define MSR_GEODE_BUSCONT_CONF0		0x00001900
 
diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index 090e1115..af68f3a8 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -39,9 +39,15 @@ void pmu_init(void)
 			pmu.msr_global_status_clr = MSR_CORE_PERF_GLOBAL_OVF_CTRL;
 		}
 	} else {
+		/* Performance Monitoring Version 2 Supported */
+		if (this_cpu_has(X86_FEATURE_AMD_PMU_V2))
+			pmu.version = 2;
+
 		pmu.msr_gp_counter_base = MSR_F15H_PERF_CTR0;
 		pmu.msr_gp_event_select_base = MSR_F15H_PERF_CTL0;
-		if (!this_cpu_has(X86_FEATURE_PERFCTR_CORE))
+		if (this_cpu_has(X86_FEATURE_AMD_PMU_V2))
+			pmu.nr_gp_counters = cpuid(0x80000022).b & 0xf;
+		else if (!this_cpu_has(X86_FEATURE_PERFCTR_CORE))
 			pmu.nr_gp_counters = AMD64_NUM_COUNTERS;
 		else
 			pmu.nr_gp_counters = AMD64_NUM_COUNTERS_CORE;
@@ -49,6 +55,12 @@ void pmu_init(void)
 		pmu.gp_counter_width = PMC_DEFAULT_WIDTH;
 		pmu.gp_counter_mask_length = pmu.nr_gp_counters;
 		pmu.gp_counter_available = (1u << pmu.nr_gp_counters) - 1;
+
+		if (this_cpu_has_perf_global_status()) {
+			pmu.msr_global_status = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS;
+			pmu.msr_global_ctl = MSR_AMD64_PERF_CNTR_GLOBAL_CTL;
+			pmu.msr_global_status_clr = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR;
+		}
 	}
 
 	pmu_reset_all_counters();
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 681e1675..72bdc833 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -266,7 +266,7 @@ static inline bool is_intel(void)
 #define X86_FEATURE_PAUSEFILTER		(CPUID(0x8000000A, 0, EDX, 10))
 #define X86_FEATURE_PFTHRESHOLD		(CPUID(0x8000000A, 0, EDX, 12))
 #define	X86_FEATURE_VGIF		(CPUID(0x8000000A, 0, EDX, 16))
-
+#define	X86_FEATURE_AMD_PMU_V2		(CPUID(0x80000022, 0, EAX, 0))
 
 static inline bool this_cpu_has(u64 feature)
 {
-- 
2.38.1.431.g37b22c650d-goog

