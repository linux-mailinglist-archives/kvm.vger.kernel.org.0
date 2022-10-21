Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3696080AB
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 23:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiJUVSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 17:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiJUVSp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 17:18:45 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDAD2A4E0D
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 14:18:31 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id lx11-20020a17090b4b0b00b0020d7c0b426dso4757727pjb.6
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 14:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rMws9ezkK6n1R9JTRBXWTh4yY8uZLjcEb1w7BIkwhN4=;
        b=K3FzZtqFuHALXau+Q7a2QLf8984i87r/M+XQTxHJmdNdaE4UgR1bCiRCZcrhArP2CA
         nW+GIRRgNc5itOdavMVVlDljWwbIgph0Qhri/Ccn3JZIwumAFENWrW0/+gHwalER/BTF
         Dp2YWqIQ6E1iA3KAe/hatBKimCGTuHq404Tvip57C0tY5LdIkPzcDPNZvMfQ5UAwkBd0
         BT6d5caMLL956Q3JufvTe7DtGiOXYQOTCoiduvy+v9KyByD5CbEtDjbaFrnUhIMNXtVh
         +icdBVVlUrFb6nrp/Vdl/qkSdkULbeVsl0C9IM6EueV2z1/W5OZPQlqJTT0lgjXEXKuD
         qSKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rMws9ezkK6n1R9JTRBXWTh4yY8uZLjcEb1w7BIkwhN4=;
        b=DmfNiXcDf2BnUsYE3aKcEdZWECNE1AXTv9HlXjt5ND25KIVkNTgRUpHDUepvQNlwul
         7Y8X85RaJPVNH/e0ych15kv8jQ3tvD6q317RzwoEN3/Tfx13DU4lO5GvvoMhAc4sOXMe
         H3RLPf33krevqJubot1wSuJhTZb7k4XYBII9fn30muJdL/gSLRr/X0vhvS7ZNSd0NaEy
         P1Tufjwr/ter+vH4Q+gUA7T8WwQaKKPM9IxcAGZU+fm0uCwviVqVwgnMYbglAFwjM+JM
         2AqMPfUBSlG+Kldnr/qVr8P/O2QP7i+5d8hDJRL3LzEzYaBbeELxQPRrlJCDOIZkjqu/
         uGjw==
X-Gm-Message-State: ACrzQf1yw7GEUdIxSBTIL0O+80E3UsuNgCmn914zAbbmKuRRCWwwU/LC
        T2/Ymyc3NDP0qZwOPFFbng+0VOMAq8M+
X-Google-Smtp-Source: AMsMyM5RAN69dwyDC1ixzW1deJLYnGMhTCYEb8QcefXvb5ZrHf4tCXNo7PXi0w5Qlt6gT4hlje2NS7ZQA1hU
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90b:2243:b0:20b:42a:4c0d with SMTP id
 hk3-20020a17090b224300b0020b042a4c0dmr58105348pjb.123.1666387109925; Fri, 21
 Oct 2022 14:18:29 -0700 (PDT)
Date:   Fri, 21 Oct 2022 14:18:14 -0700
In-Reply-To: <20221021211816.1525201-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221021211816.1525201-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221021211816.1525201-4-vipinsh@google.com>
Subject: [PATCH v6 3/5] KVM: selftests: Add atoi_paranoid() to catch errors
 missed by atoi()
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

atoi() doesn't detect errors. There is no way to know that a 0 return
is correct conversion or due to an error.

Introduce atoi_paranoid() to detect errors and provide correct
conversion. Replace all atoi() calls with atoi_paranoid().

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Suggested-by: David Matlack <dmatlack@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>

---
 .../selftests/kvm/aarch64/arch_timer.c        |  8 ++++----
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |  6 +++---
 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/demand_paging_test.c        |  2 +-
 .../selftests/kvm/dirty_log_perf_test.c       |  8 ++++----
 .../testing/selftests/kvm/include/test_util.h |  2 ++
 .../selftests/kvm/kvm_page_table_test.c       |  2 +-
 tools/testing/selftests/kvm/lib/test_util.c   | 19 +++++++++++++++++++
 .../selftests/kvm/max_guest_memory_test.c     |  6 +++---
 .../kvm/memslot_modification_stress_test.c    |  4 ++--
 .../testing/selftests/kvm/memslot_perf_test.c | 10 +++++-----
 .../selftests/kvm/set_memory_region_test.c    |  2 +-
 .../selftests/kvm/x86_64/nx_huge_pages_test.c |  4 ++--
 13 files changed, 48 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 574eb73f0e90..251e7ff04883 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -414,7 +414,7 @@ static bool parse_args(int argc, char *argv[])
 	while ((opt = getopt(argc, argv, "hn:i:p:m:")) != -1) {
 		switch (opt) {
 		case 'n':
-			test_args.nr_vcpus = atoi(optarg);
+			test_args.nr_vcpus = atoi_paranoid(optarg);
 			if (test_args.nr_vcpus <= 0) {
 				pr_info("Positive value needed for -n\n");
 				goto err;
@@ -425,21 +425,21 @@ static bool parse_args(int argc, char *argv[])
 			}
 			break;
 		case 'i':
-			test_args.nr_iter = atoi(optarg);
+			test_args.nr_iter = atoi_paranoid(optarg);
 			if (test_args.nr_iter <= 0) {
 				pr_info("Positive value needed for -i\n");
 				goto err;
 			}
 			break;
 		case 'p':
-			test_args.timer_period_ms = atoi(optarg);
+			test_args.timer_period_ms = atoi_paranoid(optarg);
 			if (test_args.timer_period_ms <= 0) {
 				pr_info("Positive value needed for -p\n");
 				goto err;
 			}
 			break;
 		case 'm':
-			test_args.migration_freq_ms = atoi(optarg);
+			test_args.migration_freq_ms = atoi_paranoid(optarg);
 			if (test_args.migration_freq_ms < 0) {
 				pr_info("0 or positive value needed for -m\n");
 				goto err;
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 17417220a083..ae90b718070a 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -824,16 +824,16 @@ int main(int argc, char **argv)
 	while ((opt = getopt(argc, argv, "hn:e:l:")) != -1) {
 		switch (opt) {
 		case 'n':
-			nr_irqs = atoi(optarg);
+			nr_irqs = atoi_paranoid(optarg);
 			if (nr_irqs > 1024 || nr_irqs % 32)
 				help(argv[0]);
 			break;
 		case 'e':
-			eoi_split = (bool)atoi(optarg);
+			eoi_split = (bool)atoi_paranoid(optarg);
 			default_args = false;
 			break;
 		case 'l':
-			level_sensitive = (bool)atoi(optarg);
+			level_sensitive = (bool)atoi_paranoid(optarg);
 			default_args = false;
 			break;
 		case 'h':
diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 76c583a07ea2..c6bcc5301e2c 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -368,7 +368,7 @@ int main(int argc, char *argv[])
 			params.vcpu_memory_bytes = parse_size(optarg);
 			break;
 		case 'v':
-			params.nr_vcpus = atoi(optarg);
+			params.nr_vcpus = atoi_paranoid(optarg);
 			break;
 		case 'o':
 			overlap_memory_access = true;
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 779ae54f89c4..82597fb04146 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -427,7 +427,7 @@ int main(int argc, char *argv[])
 			p.src_type = parse_backing_src_type(optarg);
 			break;
 		case 'v':
-			nr_vcpus = atoi(optarg);
+			nr_vcpus = atoi_paranoid(optarg);
 			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
 				    "Invalid number of vcpus, must be between 1 and %d", max_vcpus);
 			break;
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 5bb6954b2358..ecda802b78ff 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -416,7 +416,7 @@ int main(int argc, char *argv[])
 			run_vcpus_while_disabling_dirty_logging = true;
 			break;
 		case 'f':
-			p.wr_fract = atoi(optarg);
+			p.wr_fract = atoi_paranoid(optarg);
 			TEST_ASSERT(p.wr_fract >= 1,
 				    "Write fraction cannot be less than one");
 			break;
@@ -427,7 +427,7 @@ int main(int argc, char *argv[])
 			help(argv[0]);
 			break;
 		case 'i':
-			p.iterations = atoi(optarg);
+			p.iterations = atoi_paranoid(optarg);
 			break;
 		case 'm':
 			guest_modes_cmdline(optarg);
@@ -445,12 +445,12 @@ int main(int argc, char *argv[])
 			p.backing_src = parse_backing_src_type(optarg);
 			break;
 		case 'v':
-			nr_vcpus = atoi(optarg);
+			nr_vcpus = atoi_paranoid(optarg);
 			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
 				    "Invalid number of vcpus, must be between 1 and %d", max_vcpus);
 			break;
 		case 'x':
-			p.slots = atoi(optarg);
+			p.slots = atoi_paranoid(optarg);
 			break;
 		default:
 			help(argv[0]);
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index befc754ce9b3..feae42863759 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -152,4 +152,6 @@ static inline void *align_ptr_up(void *x, size_t size)
 	return (void *)align_up((unsigned long)x, size);
 }
 
+int atoi_paranoid(const char *num_str);
+
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index f42c6ac6d71d..ea7feb69bb88 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -461,7 +461,7 @@ int main(int argc, char *argv[])
 			p.test_mem_size = parse_size(optarg);
 			break;
 		case 'v':
-			nr_vcpus = atoi(optarg);
+			nr_vcpus = atoi_paranoid(optarg);
 			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
 				    "Invalid number of vcpus, must be between 1 and %d", max_vcpus);
 			break;
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 6d23878bbfe1..ec0f070a6f21 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -334,3 +334,22 @@ long get_run_delay(void)
 
 	return val[1];
 }
+
+int atoi_paranoid(const char *num_str)
+{
+	char *end_ptr;
+	long num;
+
+	errno = 0;
+	num = strtol(num_str, &end_ptr, 10);
+	TEST_ASSERT(!errno, "strtol(\"%s\") failed", num_str);
+	TEST_ASSERT(num_str != end_ptr,
+		    "strtol(\"%s\") didn't find a valid integer.\n", num_str);
+	TEST_ASSERT(*end_ptr == '\0',
+		    "strtol(\"%s\") failed to parse trailing characters \"%s\".\n",
+		    num_str, end_ptr);
+	TEST_ASSERT(num >= INT_MIN && num <= INT_MAX,
+		    "%ld not in range of [%d, %d]", num, INT_MIN, INT_MAX);
+
+	return num;
+}
diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
index 9a6e4f3ad6b5..1595b73dc09a 100644
--- a/tools/testing/selftests/kvm/max_guest_memory_test.c
+++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
@@ -193,15 +193,15 @@ int main(int argc, char *argv[])
 	while ((opt = getopt(argc, argv, "c:h:m:s:H")) != -1) {
 		switch (opt) {
 		case 'c':
-			nr_vcpus = atoi(optarg);
+			nr_vcpus = atoi_paranoid(optarg);
 			TEST_ASSERT(nr_vcpus > 0, "number of vcpus must be >0");
 			break;
 		case 'm':
-			max_mem = atoi(optarg) * size_1gb;
+			max_mem = atoi_paranoid(optarg) * size_1gb;
 			TEST_ASSERT(max_mem > 0, "memory size must be >0");
 			break;
 		case 's':
-			slot_size = atoi(optarg) * size_1gb;
+			slot_size = atoi_paranoid(optarg) * size_1gb;
 			TEST_ASSERT(slot_size > 0, "slot size must be >0");
 			break;
 		case 'H':
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 6ee7e1dde404..865276993ffb 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -166,7 +166,7 @@ int main(int argc, char *argv[])
 			guest_percpu_mem_size = parse_size(optarg);
 			break;
 		case 'v':
-			nr_vcpus = atoi(optarg);
+			nr_vcpus = atoi_paranoid(optarg);
 			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
 				    "Invalid number of vcpus, must be between 1 and %d",
 				    max_vcpus);
@@ -175,7 +175,7 @@ int main(int argc, char *argv[])
 			p.partition_vcpu_memory_access = false;
 			break;
 		case 'i':
-			p.nr_memslot_modifications = atoi(optarg);
+			p.nr_memslot_modifications = atoi_paranoid(optarg);
 			break;
 		case 'h':
 		default:
diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 44995446d942..4bae9e3f5ca1 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -885,21 +885,21 @@ static bool parse_args(int argc, char *argv[],
 			map_unmap_verify = true;
 			break;
 		case 's':
-			targs->nslots = atoi(optarg);
+			targs->nslots = atoi_paranoid(optarg);
 			if (targs->nslots <= 0 && targs->nslots != -1) {
 				pr_info("Slot count cap has to be positive or -1 for no cap\n");
 				return false;
 			}
 			break;
 		case 'f':
-			targs->tfirst = atoi(optarg);
+			targs->tfirst = atoi_paranoid(optarg);
 			if (targs->tfirst < 0) {
 				pr_info("First test to run has to be non-negative\n");
 				return false;
 			}
 			break;
 		case 'e':
-			targs->tlast = atoi(optarg);
+			targs->tlast = atoi_paranoid(optarg);
 			if (targs->tlast < 0 || targs->tlast >= NTESTS) {
 				pr_info("Last test to run has to be non-negative and less than %zu\n",
 					NTESTS);
@@ -907,14 +907,14 @@ static bool parse_args(int argc, char *argv[],
 			}
 			break;
 		case 'l':
-			targs->seconds = atoi(optarg);
+			targs->seconds = atoi_paranoid(optarg);
 			if (targs->seconds < 0) {
 				pr_info("Test length in seconds has to be non-negative\n");
 				return false;
 			}
 			break;
 		case 'r':
-			targs->runs = atoi(optarg);
+			targs->runs = atoi_paranoid(optarg);
 			if (targs->runs <= 0) {
 				pr_info("Runs per test has to be positive\n");
 				return false;
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 0d55f508d595..c366949c8362 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -407,7 +407,7 @@ int main(int argc, char *argv[])
 
 #ifdef __x86_64__
 	if (argc > 1)
-		loops = atoi(argv[1]);
+		loops = atoi_paranoid(argv[1]);
 	else
 		loops = 10;
 
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
index 59ffe7fd354f..354b6902849c 100644
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -241,10 +241,10 @@ int main(int argc, char **argv)
 	while ((opt = getopt(argc, argv, "hp:t:r")) != -1) {
 		switch (opt) {
 		case 'p':
-			reclaim_period_ms = atoi(optarg);
+			reclaim_period_ms = atoi_paranoid(optarg);
 			break;
 		case 't':
-			token = atoi(optarg);
+			token = atoi_paranoid(optarg);
 			break;
 		case 'r':
 			reboot_permissions = true;
-- 
2.38.0.135.g90850a2211-goog

