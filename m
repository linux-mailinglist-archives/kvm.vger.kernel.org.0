Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D8C56C596
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 03:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiGIBEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 21:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiGIBD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 21:03:58 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C443DBEB
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 18:03:54 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id d66-20020a636845000000b0040a88edd9c1so194002pgc.13
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 18:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=49Ym7CaX9CWENnrdzXk1/3hcO8z4dbjqI2033WPdHh0=;
        b=sWnkemiKHaNsvDJWn7nbGHnXyOuxtcuyJeY8jX4iBakxKun9+mOpcv/Xh+ggwxMgP0
         hIT3pfJGX8xFdUviDpQeTk0IZIBGsKQRUMHK1urwLCtClyQbAHvtCmVROK9gM+kIBlpO
         hiwby23CaU/xie86AAG9cMpsd1/+GX58rgSG3784c2OfgedbKmbAY1Ee0KuhkVyt03gn
         O9QW+sSxF0lvSxxbB8jdbeR856qQ5ni2YV/rtxmy5GoMdpK3dEki45V4DMJM4TJ+/kcL
         x2ZjnAI6yV2hH93eg6yLNSB3CbL/Tivw+3orXht+nosc8e5Yeh1c+zLsU1m+HYXagyHG
         G7Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=49Ym7CaX9CWENnrdzXk1/3hcO8z4dbjqI2033WPdHh0=;
        b=3v5sbUnBlam9M7gCgLkdr0tP9AMZzNiC7tn/P7vA0UIU6sFGXDogKIcaBLIRI39NSP
         lf+X1SYQCXYoegJeD6yJy2I8rrzoZpu1i/Pk8bVkO+dvOAbc1REXXMOnwOte0Qm3aoua
         JICJqo6IMtrDdQTWapjZF0Y9ZcLPrUVMav7L9P+usbhFJkZCHSX9nQgl/TqBHD3HwmGW
         Mok+CZ3wqzkqm3wybFjtzEowfnKKYmjWvpucJvlKipFOVGXt2xKNbdHG0wI2kglLlYve
         wqmURwyMzTLXwkhkkaTXQIWWqN4PQjnbh9CUAC28HV5NOuvnLcQFafEU8apB2wgxHRfB
         Xa2g==
X-Gm-Message-State: AJIora9AUdHa+aFGrZC9rmPab4vPsblVxZ0OeQzqAa8wBbcydh6FYOml
        yiVT/mJwuhj+KIs/AWtsG2yiSkjP0O/+CZDPl9jdcHp6UWgpd4RNT5UjzLC4Gd8UjdptJNb8GUf
        CbgpRpys9dU51qZgBXDnmi8KuQEeTS3/ynrdl1S1ORz6MR9Ms+d5Ffzz76Taii6sEW8ex
X-Google-Smtp-Source: AGRyM1sQhOdjoi5jmRU8xRy+7QJcXoOFBbOc3bRr5PCdvw/Thifgesb0a/XlSzmhG8rN0OAQeOevioFgcM6/qrrS
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:778e:b0:16b:c4a7:7e8d with SMTP
 id o14-20020a170902778e00b0016bc4a77e8dmr6381701pll.86.1657328634222; Fri, 08
 Jul 2022 18:03:54 -0700 (PDT)
Date:   Sat,  9 Jul 2022 01:02:52 +0000
Message-Id: <20220709010250.1001326-4-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [PATCH v3 3/5] selftests: kvm/x86: Add testing for masked events
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add testing for the pmu event filter's masked events.  These tests run
through different ways of finding an event the guest is attempting to
program in an event list.  For any given eventsel, there may be
multiple instances of it in an event list.  These tests try different
ways of looking up a match to force the matching algorithm to walk the
relevant eventsel's and ensure it is able to a) find a match, b) stays
within its bounds.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 99 +++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 4bff4c71ac45..29abe9c88f4f 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -18,8 +18,12 @@
 /*
  * In lieu of copying perf_event.h into tools...
  */
+#define ARCH_PERFMON_EVENTSEL_EVENT			0x000000FFULL
 #define ARCH_PERFMON_EVENTSEL_OS			(1ULL << 17)
 #define ARCH_PERFMON_EVENTSEL_ENABLE			(1ULL << 22)
+#define AMD64_EVENTSEL_EVENT	\
+	(ARCH_PERFMON_EVENTSEL_EVENT | (0x0FULL << 32))
+
 
 union cpuid10_eax {
 	struct {
@@ -445,6 +449,99 @@ static bool use_amd_pmu(void)
 		 is_zen3(entry->eax));
 }
 
+#define ENCODE_MASKED_EVENT(select, mask, match, invert) \
+		KVM_PMU_EVENT_ENCODE_MASKED_EVENT(select, mask, match, invert)
+
+static void expect_success(uint64_t count)
+{
+	if (count != NUM_BRANCHES)
+		pr_info("masked filter: Branch instructions retired = %lu (expected %u)\n",
+			count, NUM_BRANCHES);
+	TEST_ASSERT(count, "Allowed PMU event is not counting");
+}
+
+static void expect_failure(uint64_t count)
+{
+	if (count)
+		pr_info("masked filter: Branch instructions retired = %lu (expected 0)\n",
+			count);
+	TEST_ASSERT(!count, "Disallowed PMU Event is counting");
+}
+
+static void run_masked_events_test(struct kvm_vm *vm, uint64_t masked_events[],
+				   const int nmasked_events, uint64_t event,
+				   uint32_t action,
+				   void (*expected_func)(uint64_t))
+{
+	struct kvm_pmu_event_filter *f;
+	uint64_t old_event;
+	uint64_t count;
+	int i;
+
+	for (i = 0; i < nmasked_events; i++) {
+		if ((masked_events[i] & AMD64_EVENTSEL_EVENT) != EVENT(event, 0))
+			continue;
+
+		old_event = masked_events[i];
+
+		masked_events[i] =
+			ENCODE_MASKED_EVENT(event, ~0x00, 0x00, 0);
+
+		f = create_pmu_event_filter(masked_events, nmasked_events, action,
+				   KVM_PMU_EVENT_FLAG_MASKED_EVENTS);
+
+		count = test_with_filter(vm, f);
+		free(f);
+
+		expected_func(count);
+
+		masked_events[i] = old_event;
+	}
+}
+
+static void run_masked_events_tests(struct kvm_vm *vm, uint64_t masked_events[],
+				    const int nmasked_events, uint64_t event)
+{
+	run_masked_events_test(vm, masked_events, nmasked_events, event,
+			       KVM_PMU_EVENT_ALLOW, expect_success);
+	run_masked_events_test(vm, masked_events, nmasked_events, event,
+			       KVM_PMU_EVENT_DENY, expect_failure);
+}
+
+static void test_masked_events(struct kvm_vm *vm)
+{
+	uint64_t masked_events[11];
+	const int nmasked_events = ARRAY_SIZE(masked_events);
+	uint64_t prev_event, event, next_event;
+	int i;
+
+	if (use_intel_pmu()) {
+		/* Instructions retired */
+		prev_event = 0xc0;
+		event = INTEL_BR_RETIRED;
+		/* Branch misses retired */
+		next_event = 0xc5;
+	} else {
+		TEST_ASSERT(use_amd_pmu(), "Unknown platform");
+		/* Retired instructions */
+		prev_event = 0xc0;
+		event = AMD_ZEN_BR_RETIRED;
+		/* Retired branch instructions mispredicted */
+		next_event = 0xc3;
+	}
+
+	for (i = 0; i < nmasked_events; i++)
+		masked_events[i] =
+			ENCODE_MASKED_EVENT(event, ~0x00, i+1, 0);
+
+	run_masked_events_tests(vm, masked_events, nmasked_events, event);
+
+	masked_events[0] = ENCODE_MASKED_EVENT(prev_event, ~0x00, 0, 0);
+	masked_events[1] = ENCODE_MASKED_EVENT(next_event, ~0x00, 0, 0);
+
+	run_masked_events_tests(vm, masked_events, nmasked_events, event);
+}
+
 int main(int argc, char *argv[])
 {
 	void (*guest_code)(void) = NULL;
@@ -489,6 +586,8 @@ int main(int argc, char *argv[])
 	test_not_member_deny_list(vm);
 	test_not_member_allow_list(vm);
 
+	test_masked_events(vm);
+
 	kvm_vm_free(vm);
 
 	test_pmu_config_disable(guest_code);
-- 
2.37.0.144.g8ac04bfd2-goog

