Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A197E6AE226
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 15:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjCGOXU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 09:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjCGOWn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 09:22:43 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF024C6C6
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 06:18:10 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id q30-20020a631f5e000000b0050760997f4dso625855pgm.6
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 06:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678198633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mXsWRR21xlX1AxqGU85OySF1oOucpc8+al/VZkv3gHk=;
        b=DwdKhil9E9tXdvVRvFMC8+IOUqu5GaK0P5LObu+ne70/qDHiHRwHmw566kqXo+fisp
         WXd5uzHTZ2gOI4IVfVeHggI6mWfGnkzmeF2s5KBafTrx/mm31T6YSi/LvVkQf5w5JNJD
         nYE5Z2TbgI73SqAZdjURPVw1qutLDBcQslIhF0s6/OCkwlvAimUTrGmonX7C9r6jOlum
         10KjJ76QKN89Dq1+qKkBCRzOisMj0ND7GchpqfbUbCOCIQZQ68Gr8Di5DrE20jST2M0J
         YDOzNH7/1y4+eT0HghgttGWaCwuxtupFdv7L34WUE/laM6nJV8aCx54qXc/WhLimSrbl
         Qe7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678198633;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mXsWRR21xlX1AxqGU85OySF1oOucpc8+al/VZkv3gHk=;
        b=qNaf6QSmGTFN2ptJEU9dfiK1ktRej7bU7DAqdhzS0xQf0leoNyCeltrrSpdu1nHhtx
         j6jlorC3fnOOfEaKicJHBwn6vBvFII0FXZYHobh2WsL04LJfm0jFgWIUQlhevnwCH0M0
         COkTZuH4l49RQv3WA/Y6brNROs27U9j+/OjIvxSjhDXPcBQS0sDrQGm7FmOywGYayuBl
         6swMpGj0HyEU3uDv3w5pzs8LH1mKLDKVveE3az41cmYWvg1+/xIyaBvgrMJXSSqt0t2G
         6MTwO+IXs17DGFMbTYtNcoE41kXkw6MwjdLQdqX0pgZN6XYPeMi86yJVFr/p0bJL7oYD
         hbGg==
X-Gm-Message-State: AO0yUKVs/L5TaXXwjLttJUhw4826M7d75+kGDTNQK/o/jVwgB4V6m3Gs
        B5jVUSdYI6f14fUDG4VNitDlY1q9ie7vhKYyuVbECrSwrlJnFtBoYlfV7bZBI5hUlLKs/BR6txk
        GEHDPl0Ag7cuZoOoQnxsPOA8VX0eulNFmfphPUIe7A+IzJOq33ZCfFm+K7/K+8uf/hQvC
X-Google-Smtp-Source: AK7set8qSg4V1yG+pDhO/eJpJ9+wv4mnyDjoX4eHHM3OH0LDlBZR1zwxOjYA4/Bu3B+FHkrh2dZ/2dSk9zBDvf+5
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:903:2c1:b0:199:1aba:b1d7 with SMTP
 id s1-20020a17090302c100b001991abab1d7mr5977475plk.5.1678198632730; Tue, 07
 Mar 2023 06:17:12 -0800 (PST)
Date:   Tue,  7 Mar 2023 14:13:57 +0000
In-Reply-To: <20230307141400.1486314-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230307141400.1486314-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307141400.1486314-3-aaronlewis@google.com>
Subject: [PATCH v3 2/5] KVM: selftests: Add a common helper to the guest
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, Aaron Lewis <aaronlewis@google.com>
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

Split out the common parts of the Intel and AMD guest code into a
helper function.  This is in preparation for adding
additional counters to the test.

No functional changes intended.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 31 ++++++++++++-------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index bad7ef8c5b92..f33079fc552b 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -100,6 +100,17 @@ static void check_msr(uint32_t msr, uint64_t bits_to_flip)
 		GUEST_SYNC(0);
 }
 
+static uint64_t test_guest(uint32_t msr_base)
+{
+	uint64_t br0, br1;
+
+	br0 = rdmsr(msr_base + 0);
+	__asm__ __volatile__("loop ." : "+c"((int){NUM_BRANCHES}));
+	br1 = rdmsr(msr_base + 0);
+
+	return br1 - br0;
+}
+
 static void intel_guest_code(void)
 {
 	check_msr(MSR_CORE_PERF_GLOBAL_CTRL, 1);
@@ -108,16 +119,15 @@ static void intel_guest_code(void)
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
+		count = test_guest(MSR_IA32_PMC0);
+		GUEST_SYNC(count);
 	}
 }
 
@@ -133,15 +143,14 @@ static void amd_guest_code(void)
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
+		count = test_guest(MSR_K7_PERFCTR0);
+		GUEST_SYNC(count);
 	}
 }
 
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

