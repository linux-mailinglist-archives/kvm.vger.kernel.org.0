Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63D7613C46
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 18:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbiJaRis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 13:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbiJaRie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 13:38:34 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D9A13CFA
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 10:38:30 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 129-20020a250087000000b006ca5c621bacso10910573yba.3
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 10:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Evd5a8CRBvv77lAu62Ue9D6+dvJHXkM2aGaB7fGSBE=;
        b=KULdNN0+qWbIbkXlpv6Y7tyME3a6JSExPnq3RWF/BJxfnyT1kVfbUHzMsFZfQR7uHq
         I/R8xR31Syks/m9Z4aTIN1hiaS/uEJSJMBhqniQr+kte2gd+6XYHt14qD7bx0R45WlMd
         zvCg+QpamWHp2oW7weS5F5YLIPwdJ/21c5CPM6geLuaZJhjtgWMsdli6CFnYEeBIKBmb
         Jx6qmrX0Z1B3ixNTtzI4BxxbXdetxOZ0cMOfCUWc/oZ6hAinCt/5qzYxM7Cf9cuwm3Hh
         GfYFotJqMEGW0n040eaggLkZQcUuIlrqok4Keyg3nMReSYVx7BRbUOCLu6JlwnD+O8oe
         Jz6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Evd5a8CRBvv77lAu62Ue9D6+dvJHXkM2aGaB7fGSBE=;
        b=bQUuyW4xGXhr15OHOKBuwomSTZ3nf/mlzwRHVyNtubwjH763llv4Uvg3PGz/24xdwL
         VUu03NvSis8K/HH3vp8TAQsbkWZG21QwtBtrGt4aEuzQ1+Wssk81JCKhDxejc/AJfOQ5
         yI46jmquHp0Met4pT4oavh0smCqsDyKeocPbBybtc6/BXV8qX8pgVziOIUGE/EqD7OGM
         A//tkbeReIph5g+HpKU3GAtMIzhd4B+ZKMlyo1emFtANEZffFyYhe0coGspZopu3DuAh
         Ye03ZsAtH6mfcHPdYEfWQ8JfyQy9MxUOXUsuCudXqFbt/fHEv0ndM5v+sx8+PTuz1ACp
         Jukw==
X-Gm-Message-State: ACrzQf0CO5IQk4+C+TH42DYpeqA2/3z02f4figmk4Zjz4t9kfzENQtTP
        blMBxJhIkY7b+GjZrZ47k6cqSfgdJj59
X-Google-Smtp-Source: AMsMyM6GOTjwGRuKEpV1nQGiQo9Hor2jMO1CHX9couHv5Qq8ZV+2+zz9owvsVLnJhgwRmljFQtGNmcOoloCS
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a25:bec1:0:b0:6cc:57e2:6f2c with SMTP id
 k1-20020a25bec1000000b006cc57e26f2cmr10823139ybm.544.1667237910170; Mon, 31
 Oct 2022 10:38:30 -0700 (PDT)
Date:   Mon, 31 Oct 2022 10:38:18 -0700
In-Reply-To: <20221031173819.1035684-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221031173819.1035684-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221031173819.1035684-5-vipinsh@google.com>
Subject: [PATCH v7 4/5] KVM: selftests: Add atoi_positive() and
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
 .../selftests/kvm/aarch64/debug-exceptions.c  |  2 +-
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
 13 files changed, 47 insertions(+), 59 deletions(-)

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
diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 19fffdf19c9f..9650e8a9bac6 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -423,7 +423,7 @@ int main(int argc, char *argv[])
 	while ((opt = getopt(argc, argv, "i:")) != -1) {
 		switch (opt) {
 		case 'i':
-			ss_iteration = atoi_paranoid(optarg);
+			ss_iteration = atoi_positive(optarg);
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
2.38.1.273.g43a17bfeac-goog

