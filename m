Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D432D69EB40
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 00:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjBUX2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 18:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjBUX2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 18:28:09 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6504FEB50
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 15:28:08 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id a137-20020a25ca8f000000b0091b90b20cd9so6732901ybg.6
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 15:28:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DpYR6uQaRor0ltYafXsEUBLlWxFdhNckfx85wr+rhQU=;
        b=Ar8YyY3DwXqezv8PDP3Y22S3atBWKn91EytJwy8M9XqBL/SkQsY3dwrfvBwGKnM5Yh
         qVgfJRVO4VsfmohhBiPtsAjvjfwoWtgkbk0gYUkCTBSEB0Qi5JMam3c4RD5Zdgx9uCDK
         /KX0C0L1gBbzeBrht67Eqv4sNevCcQpRxS986dF1XKFPZbLIeyAmG2sLvViSta7d5e9j
         GRmOoDoEWkOgQaBhaBoeBH8DNmA4+jrMYbO15QnxXc+tAeus+2k2m0ywf8qxKw/bG50T
         Y6qmWDeTNXcB7vpqBFG6DwQ/J4JE4DT3ly+V6YL+AKGbpOHACMlcKfPFu4s8HEy+HyzZ
         nzxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DpYR6uQaRor0ltYafXsEUBLlWxFdhNckfx85wr+rhQU=;
        b=rYkcdWVg+3sBelEyJ+g3BLvHq9efm12mJSfa6rNMdEkPKO58tRbn0sonKc/hE9eUvo
         OGtbXSO85kBqH+L6ZowIkfVFnKJd69h6PFhvNpsMniW/aczxDuBM4Mv1faVWTc/hMJLy
         IWsDwC8zVH/kP0PwCqym4rhvqCjhwR0wu86tgPNWmCBqJ4uhm5YCVDYBhyF0eJb2yZIk
         GvShOdaDa2UbgXxM2ERwDP4CZX4nlD6dsW7MS0kpH3kYdGkfy/H1zMplKD+AZ4e/rNKb
         061ZSMGhS+V33iBJWF4V/j1R6EVEBtc+zDkVapYWXcnW0zWcxqtC8d5c3KBCoCTNXRTz
         n7/A==
X-Gm-Message-State: AO0yUKXWmTKdMFSy9t4PQHBw/7cclzf/48FarccV1LeR+BGrw+by86Bn
        D46PEEoYj7k4vZvt9SSv+cjwRWqmmeGK3KHj+w==
X-Google-Smtp-Source: AK7set8d2DQXFyyRA+QpTt+au8/wg3sgyZLSZ6GSbMT/kFdoY6BZZXDUUTQDhZ1zbN75NY43ebozNoHH9udLWXKXUw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a81:8602:0:b0:534:3b2e:aa23 with SMTP
 id w2-20020a818602000000b005343b2eaa23mr107114ywf.567.1677022087633; Tue, 21
 Feb 2023 15:28:07 -0800 (PST)
Date:   Tue, 21 Feb 2023 23:27:40 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230221232740.387978-1-coltonlewis@google.com>
Subject: [PATCH] KVM: selftests: Provide generic way to read system counter
From:   Colton Lewis <coltonlewis@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        David Matlack <dmatlack@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Oliver Upton <oliver.upton@linux.dev>,
        Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
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

Provide a generic function to read the system counter from the guest
for timing purposes. An increasingly common and important way to
measure guest performance is to measure the amount of time different
actions take in the guest. Provide also a mathematical conversion from
cycles to nanoseconds and a macro for timing individual statements.

Substitute the previous custom implementation of a similar function in
system_counter_offset_test with this new implementation.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---

These functions were originally part of my patch to introduce latency
measurements into dirty_log_perf_test. [1] Sean Christopherson
suggested lifting these functions into their own patch in generic code
so they can be used by any test. [2] Ricardo Koller suggested the
addition of the MEASURE macro to more easily time individual
statements. [3]

[1] https://lore.kernel.org/kvm/20221115173258.2530923-1-coltonlewis@google.com/
[2] https://lore.kernel.org/kvm/Y8gfOP5CMXK60AtH@google.com/
[3] https://lore.kernel.org/kvm/Y8cIdxp5k8HivVAe@google.com/

 .../testing/selftests/kvm/include/test_util.h |  3 ++
 tools/testing/selftests/kvm/lib/test_util.c   | 37 +++++++++++++++++++
 .../kvm/system_counter_offset_test.c          | 10 +----
 3 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 80d6416f3012..290653b99035 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -84,6 +84,9 @@ struct guest_random_state {
 struct guest_random_state new_guest_random_state(uint32_t seed);
 uint32_t guest_random_u32(struct guest_random_state *state);

+uint64_t guest_cycles_read(void);
+double guest_cycles_to_ns(double cycles);
+
 enum vm_mem_backing_src_type {
 	VM_MEM_SRC_ANONYMOUS,
 	VM_MEM_SRC_ANONYMOUS_THP,
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 5c22fa4c2825..6d88132a0131 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -15,6 +15,11 @@
 #include <linux/mman.h>
 #include "linux/kernel.h"

+#if defined(__aarch64__)
+#include "aarch64/arch_timer.h"
+#elif defined(__x86_64__)
+#include "x86_64/processor.h"
+#endif
 #include "test_util.h"

 /*
@@ -34,6 +39,38 @@ uint32_t guest_random_u32(struct guest_random_state *state)
 	return state->seed;
 }

+uint64_t guest_cycles_read(void)
+{
+#if defined(__aarch64__)
+	return timer_get_cntct(VIRTUAL);
+#elif defined(__x86_64__)
+	return rdtsc();
+#else
+#warn __func__ " is not implemented for this architecture, will return 0"
+	return 0;
+#endif
+}
+
+double guest_cycles_to_ns(double cycles)
+{
+#if defined(__aarch64__)
+	return cycles * (1e9 / timer_get_cntfrq());
+#elif defined(__x86_64__)
+	return cycles * (1e9 / (KVM_GET_TSC_KHZ * 1000));
+#else
+#warn __func__ " is not implemented for this architecture, will return 0"
+	return 0.0;
+#endif
+}
+
+#define MEASURE_CYCLES(x)			\
+	({					\
+		uint64_t start;			\
+		start = guest_cycles_read();	\
+		x;				\
+		guest_cycles_read() - start;	\
+	})
+
 /*
  * Parses "[0-9]+[kmgt]?".
  */
diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
index 7f5b330b6a1b..39b1249c7404 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -39,14 +39,9 @@ static void setup_system_counter(struct kvm_vcpu *vcpu, struct test_case *test)
 			     &test->tsc_offset);
 }

-static uint64_t guest_read_system_counter(struct test_case *test)
-{
-	return rdtsc();
-}
-
 static uint64_t host_read_guest_system_counter(struct test_case *test)
 {
-	return rdtsc() + test->tsc_offset;
+	return guest_cycles_read() + test->tsc_offset;
 }

 #else /* __x86_64__ */
@@ -63,9 +58,8 @@ static void guest_main(void)
 	int i;

 	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
-		struct test_case *test = &test_cases[i];

-		GUEST_SYNC_CLOCK(i, guest_read_system_counter(test));
+		GUEST_SYNC_CLOCK(i, guest_cycles_read());
 	}
 }

--
2.39.2.637.g21b0678d19-goog
