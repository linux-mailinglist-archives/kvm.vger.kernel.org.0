Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 589D36080AF
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 23:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbiJUVTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 17:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbiJUVS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 17:18:57 -0400
Received: from mail-ot1-x349.google.com (mail-ot1-x349.google.com [IPv6:2607:f8b0:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825302A6841
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 14:18:43 -0700 (PDT)
Received: by mail-ot1-x349.google.com with SMTP id bx1-20020a056830600100b006618cd93358so2301415otb.23
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 14:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N/3+UYD1iUfTuL1WJoe+LwMhCBr0Vrvp2n9eDEXYU1Y=;
        b=CWZh/ieQaLQbrhUPf7VOcTmvYjLRxfMK92pQymM/lfPuAnJMGuIRVd9hy7Hy8djO8W
         siUbUPnL4FG4rmvuEmw6fO7TK8Legy5PKSRuUgVamKKfuxYYkrBrfz4uylNVSkqpCyIi
         Y/8gSYpNecBKAaLrY617Aab0EVdkORQGe8b4CnYfhZkxfFdoUIOjt9HcSVIpKD1eaNNR
         kX3Qn3wf3vKOnhfp6RT3Zjfw4PHJKJfqA6xr2q/3hW9F6XlYvv3TUB63uFon45sQWesC
         3hTi8NBSqLyODe32wOdyRohxKBL+hB9Y/9BKPOFzrjlFm6H6j8f1HmR3uRJVEljTRtpK
         e5Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N/3+UYD1iUfTuL1WJoe+LwMhCBr0Vrvp2n9eDEXYU1Y=;
        b=p9N4qj8M0oIazFObEE4CnpeiSQtqBWMNi0XuKy5QaORDUr5sW5ZF0qsnYYIGUicffG
         +41HJfV/1hG8KmLpF+4V/0+358YXDwErztaATN6H3DeZFfgxI4THM8cIFrrlouyX8ApA
         dLVbAurJruD0F/n66wJe2TaXnE2v8EHKwmibSo1vA8YM18AwXadA7aiLsbepOHsM1T2u
         3pGVLjb786HdV7JayvaTtH/i5p7L28ck9h5zD0rT2JmGxzVjTbRAQIG5dYx0OuwAF2cn
         1pOqZdZYvmMtBmwiuh1NzKYKke4iDTL5UUvnMZpRWcmjOdEw0Jcvrvr9FBMgVR/x2IKx
         +DnQ==
X-Gm-Message-State: ACrzQf2qjR47YtpZQmY670tABqXT6ziAkrC8fd0L5PSJBAvZFhfFw6NJ
        wf0ziNmVkFNZ0OvDLZ5wBBWY35h7zveC
X-Google-Smtp-Source: AMsMyM4gKcnQrDPPWrIOA4PypNv1umNw8Ydq/3fkrMPWlry5UjjzKGRmKJGf2tsQJ3PPpkjXIFuzUO7tegH+
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90b:3507:b0:20a:9d07:1656 with SMTP id
 ls7-20020a17090b350700b0020a9d071656mr24208245pjb.188.1666387111948; Fri, 21
 Oct 2022 14:18:31 -0700 (PDT)
Date:   Fri, 21 Oct 2022 14:18:15 -0700
In-Reply-To: <20221021211816.1525201-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221021211816.1525201-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221021211816.1525201-5-vipinsh@google.com>
Subject: [PATCH v6 4/5] KVM: selftests: Add atoi_positive() and
 atoi_non_negative() for input validation
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc:     andrew.jones@linux.dev, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
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

Many KVM selftests take command line arguments which are supposed to be
positive (>0) or non-negative (>=0). Some tests do these validation and
some missed adding the check.

Add atoi_positive() and atoi_non_negative() to validate inputs in
selftests before proceeding to use those values.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../selftests/kvm/aarch64/arch_timer.c        | 25 ++++---------------
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |  2 +-
 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/demand_paging_test.c        |  4 +--
 .../selftests/kvm/dirty_log_perf_test.c       | 12 ++++-----
 .../testing/selftests/kvm/include/test_util.h |  2 ++
 .../selftests/kvm/kvm_page_table_test.c       |  4 +--
 tools/testing/selftests/kvm/lib/test_util.c   | 16 ++++++++++++
 .../selftests/kvm/max_guest_memory_test.c     |  7 +++---
 .../kvm/memslot_modification_stress_test.c    |  6 ++---
 .../testing/selftests/kvm/memslot_perf_test.c | 22 ++++------------
 .../selftests/kvm/set_memory_region_test.c    |  2 +-
 12 files changed, 46 insertions(+), 58 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 251e7ff04883..24dffcaf7a9f 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -414,36 +414,21 @@ static bool parse_args(int argc, char *argv[])
 	while ((opt = getopt(argc, argv, "hn:i:p:m:")) != -1) {
 		switch (opt) {
 		case 'n':
-			test_args.nr_vcpus = atoi_paranoid(optarg);
-			if (test_args.nr_vcpus <= 0) {
-				pr_info("Positive value needed for -n\n");
-				goto err;
-			} else if (test_args.nr_vcpus > KVM_MAX_VCPUS) {
+			test_args.nr_vcpus = atoi_positive(optarg);
+			if (test_args.nr_vcpus > KVM_MAX_VCPUS) {
 				pr_info("Max allowed vCPUs: %u\n",
 					KVM_MAX_VCPUS);
 				goto err;
 			}
 			break;
 		case 'i':
-			test_args.nr_iter = atoi_paranoid(optarg);
-			if (test_args.nr_iter <= 0) {
-				pr_info("Positive value needed for -i\n");
-				goto err;
-			}
+			test_args.nr_iter = atoi_positive(optarg);
 			break;
 		case 'p':
-			test_args.timer_period_ms = atoi_paranoid(optarg);
-			if (test_args.timer_period_ms <= 0) {
-				pr_info("Positive value needed for -p\n");
-				goto err;
-			}
+			test_args.timer_period_ms = atoi_positive(optarg);
 			break;
 		case 'm':
-			test_args.migration_freq_ms = atoi_paranoid(optarg);
-			if (test_args.migration_freq_ms < 0) {
-				pr_info("0 or positive value needed for -m\n");
-				goto err;
-			}
+			test_args.migration_freq_ms = atoi_non_negative(optarg);
 			break;
 		case 'h':
 		default:
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index ae90b718070a..d7da5f24db35 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -824,7 +824,7 @@ int main(int argc, char **argv)
 	while ((opt = getopt(argc, argv, "hn:e:l:")) != -1) {
 		switch (opt) {
 		case 'n':
-			nr_irqs = atoi_paranoid(optarg);
+			nr_irqs = atoi_non_negative(optarg);
 			if (nr_irqs > 1024 || nr_irqs % 32)
 				help(argv[0]);
 			break;
diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index c6bcc5301e2c..b30500cc197e 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -368,7 +368,7 @@ int main(int argc, char *argv[])
 			params.vcpu_memory_bytes = parse_size(optarg);
 			break;
 		case 'v':
-			params.nr_vcpus = atoi_paranoid(optarg);
+			params.nr_vcpus = atoi_positive(optarg);
 			break;
 		case 'o':
 			overlap_memory_access = true;
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 82597fb04146..dcdb6964b1dc 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -427,8 +427,8 @@ int main(int argc, char *argv[])
 			p.src_type = parse_backing_src_type(optarg);
 			break;
 		case 'v':
-			nr_vcpus = atoi_paranoid(optarg);
-			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
+			nr_vcpus = atoi_positive(optarg);
+			TEST_ASSERT(nr_vcpus <= max_vcpus,
 				    "Invalid number of vcpus, must be between 1 and %d", max_vcpus);
 			break;
 		case 'o':
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index ecda802b78ff..618598ddd993 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -416,9 +416,7 @@ int main(int argc, char *argv[])
 			run_vcpus_while_disabling_dirty_logging = true;
 			break;
 		case 'f':
-			p.wr_fract = atoi_paranoid(optarg);
-			TEST_ASSERT(p.wr_fract >= 1,
-				    "Write fraction cannot be less than one");
+			p.wr_fract = atoi_positive(optarg);
 			break;
 		case 'g':
 			dirty_log_manual_caps = 0;
@@ -427,7 +425,7 @@ int main(int argc, char *argv[])
 			help(argv[0]);
 			break;
 		case 'i':
-			p.iterations = atoi_paranoid(optarg);
+			p.iterations = atoi_positive(optarg);
 			break;
 		case 'm':
 			guest_modes_cmdline(optarg);
@@ -445,12 +443,12 @@ int main(int argc, char *argv[])
 			p.backing_src = parse_backing_src_type(optarg);
 			break;
 		case 'v':
-			nr_vcpus = atoi_paranoid(optarg);
-			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
+			nr_vcpus = atoi_positive(optarg);
+			TEST_ASSERT(nr_vcpus <= max_vcpus,
 				    "Invalid number of vcpus, must be between 1 and %d", max_vcpus);
 			break;
 		case 'x':
-			p.slots = atoi_paranoid(optarg);
+			p.slots = atoi_positive(optarg);
 			break;
 		default:
 			help(argv[0]);
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index feae42863759..9c7b2c186a48 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -153,5 +153,7 @@ static inline void *align_ptr_up(void *x, size_t size)
 }
 
 int atoi_paranoid(const char *num_str);
+uint32_t atoi_positive(const char *num_str);
+uint32_t atoi_non_negative(const char *num_str);
 
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index ea7feb69bb88..2f62e19976fd 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -461,8 +461,8 @@ int main(int argc, char *argv[])
 			p.test_mem_size = parse_size(optarg);
 			break;
 		case 'v':
-			nr_vcpus = atoi_paranoid(optarg);
-			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
+			nr_vcpus = atoi_positive(optarg);
+			TEST_ASSERT(nr_vcpus <= max_vcpus,
 				    "Invalid number of vcpus, must be between 1 and %d", max_vcpus);
 			break;
 		case 's':
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index ec0f070a6f21..210e98a49a83 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -353,3 +353,19 @@ int atoi_paranoid(const char *num_str)
 
 	return num;
 }
+
+uint32_t atoi_positive(const char *num_str)
+{
+	int num = atoi_paranoid(num_str);
+
+	TEST_ASSERT(num > 0, "%s is not a positive integer.\n", num_str);
+	return num;
+}
+
+uint32_t atoi_non_negative(const char *num_str)
+{
+	int num = atoi_paranoid(num_str);
+
+	TEST_ASSERT(num >= 0, "%s is not a non-negative integer.\n", num_str);
+	return num;
+}
diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
index 1595b73dc09a..20015de3b91c 100644
--- a/tools/testing/selftests/kvm/max_guest_memory_test.c
+++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
@@ -193,15 +193,14 @@ int main(int argc, char *argv[])
 	while ((opt = getopt(argc, argv, "c:h:m:s:H")) != -1) {
 		switch (opt) {
 		case 'c':
-			nr_vcpus = atoi_paranoid(optarg);
-			TEST_ASSERT(nr_vcpus > 0, "number of vcpus must be >0");
+			nr_vcpus = atoi_positive(optarg);
 			break;
 		case 'm':
-			max_mem = atoi_paranoid(optarg) * size_1gb;
+			max_mem = atoi_positive(optarg) * size_1gb;
 			TEST_ASSERT(max_mem > 0, "memory size must be >0");
 			break;
 		case 's':
-			slot_size = atoi_paranoid(optarg) * size_1gb;
+			slot_size = atoi_positive(optarg) * size_1gb;
 			TEST_ASSERT(slot_size > 0, "slot size must be >0");
 			break;
 		case 'H':
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 865276993ffb..7539ee7b6e95 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -166,8 +166,8 @@ int main(int argc, char *argv[])
 			guest_percpu_mem_size = parse_size(optarg);
 			break;
 		case 'v':
-			nr_vcpus = atoi_paranoid(optarg);
-			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
+			nr_vcpus = atoi_positive(optarg);
+			TEST_ASSERT(nr_vcpus <= max_vcpus,
 				    "Invalid number of vcpus, must be between 1 and %d",
 				    max_vcpus);
 			break;
@@ -175,7 +175,7 @@ int main(int argc, char *argv[])
 			p.partition_vcpu_memory_access = false;
 			break;
 		case 'i':
-			p.nr_memslot_modifications = atoi_paranoid(optarg);
+			p.nr_memslot_modifications = atoi_positive(optarg);
 			break;
 		case 'h':
 		default:
diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 4bae9e3f5ca1..8e6e2d44d002 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -892,33 +892,21 @@ static bool parse_args(int argc, char *argv[],
 			}
 			break;
 		case 'f':
-			targs->tfirst = atoi_paranoid(optarg);
-			if (targs->tfirst < 0) {
-				pr_info("First test to run has to be non-negative\n");
-				return false;
-			}
+			targs->tfirst = atoi_non_negative(optarg);
 			break;
 		case 'e':
-			targs->tlast = atoi_paranoid(optarg);
-			if (targs->tlast < 0 || targs->tlast >= NTESTS) {
+			targs->tlast = atoi_non_negative(optarg);
+			if (targs->tlast >= NTESTS) {
 				pr_info("Last test to run has to be non-negative and less than %zu\n",
 					NTESTS);
 				return false;
 			}
 			break;
 		case 'l':
-			targs->seconds = atoi_paranoid(optarg);
-			if (targs->seconds < 0) {
-				pr_info("Test length in seconds has to be non-negative\n");
-				return false;
-			}
+			targs->seconds = atoi_non_negative(optarg);
 			break;
 		case 'r':
-			targs->runs = atoi_paranoid(optarg);
-			if (targs->runs <= 0) {
-				pr_info("Runs per test has to be positive\n");
-				return false;
-			}
+			targs->runs = atoi_positive(optarg);
 			break;
 		}
 	}
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index c366949c8362..e09092110121 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -407,7 +407,7 @@ int main(int argc, char *argv[])
 
 #ifdef __x86_64__
 	if (argc > 1)
-		loops = atoi_paranoid(argv[1]);
+		loops = atoi_positive(argv[1]);
 	else
 		loops = 10;
 
-- 
2.38.0.135.g90850a2211-goog

