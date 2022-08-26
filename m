Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7795A2F39
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 20:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345098AbiHZStY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 14:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345092AbiHZSsx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 14:48:53 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23C1E9921
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 11:46:00 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id j3-20020a634a43000000b00429f2cb4a43so1232085pgl.0
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 11:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=OKhiGPhhBpk2IflQMoyVC2O8DiKKOEa1AJ4NqkPjkaI=;
        b=MftNhJIe3G7MJZO34epL9AuN+qQpSAABFbDWBHTPnMbZJCT2snjdTRc/1zf8J0kdT/
         o56u8r+969adVVsW/O9vyWxX+sZVphDx0PNuivOMRrLwj17iZ24WnsboI3M5o75VFMMW
         6M7IfMly+wXSeT7ZyjjMQz7/jS8HKBaZ342r605aOc4Val9h6Ad4h+nv1Xg5k5t5+sce
         VQcVK5f0oKzUZzgrnHIECwhAHb6mS3/OD7egDy4c4B50dMTx0Eyv8d7FFHuEtKzgn0dc
         k5W4c6/1k4pYnGd0Zy+aEopZUkJnGf4goVtducacZwT758klnGBsn7D3px8xPDw18gA9
         lLNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=OKhiGPhhBpk2IflQMoyVC2O8DiKKOEa1AJ4NqkPjkaI=;
        b=uzc4duklH77+6IunB4ZVqIU8nOCH0n9GuGmfCz85aaJnUl+FA5JxqySTzNum9tltQe
         sjKNs5tXAW5BVzxzx5IEmomDpF7Kuqd3ztkHX09e/Nkl8f8jbH+CNqaB6W+nB/Cagi/H
         P0luzkFi2LABJVg+gIv8SoGWUDL6IhRQ2uYkuA6fWeX396gwhTJ98+2/zGie2c4zT6BP
         LBbnONpMBsHCk8wPnUi1bg03Fhi6AbiPjMPOTaC0hTkYsHYKl0ysN1+bN7lh8lAmoCC9
         xPWBDmpASalGWbM23N6vVitzxuijAi6KL53djrxsxGXCuB5T8MfP0DM0WMoLECF1t8Nt
         OX1g==
X-Gm-Message-State: ACgBeo0DaOmtWhhF1I9ykZP3Wrob3+oSWg2U6o6r0jPyHfYc8tgrbTA5
        51xt36Uxq39CocIPMaTVKD8YtSbNU2Dk
X-Google-Smtp-Source: AA6agR56m2+XvKqCue/yU4iW5ZSp8iYPOv6u/rpaz8OGs17UrQEZWrXNO4NPmOK784SzWZX23VM5N3q2EcZS
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:aa81:b0:173:3f68:e768 with SMTP id
 d1-20020a170902aa8100b001733f68e768mr4882412plr.80.1661539560401; Fri, 26 Aug
 2022 11:46:00 -0700 (PDT)
Date:   Fri, 26 Aug 2022 11:44:59 -0700
In-Reply-To: <20220826184500.1940077-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20220826184500.1940077-1-vipinsh@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220826184500.1940077-4-vipinsh@google.com>
Subject: [PATCH v3 3/4] KVM: selftests: Add atoi_paranoid to catch errors
 missed by atoi
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, dmatlack@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

atoi() doesn't detect errors. There is no way to know that a 0 return
is correct conversion or due to an error.

Introduce atoi_paranoid() to detect errors and provide correct
conversion. Replace all atoi calls with atoi_paranoid.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Suggested-by: David Matlack <dmatlack@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/aarch64/arch_timer.c   |  8 ++++----
 tools/testing/selftests/kvm/aarch64/vgic_irq.c     |  6 +++---
 .../selftests/kvm/access_tracking_perf_test.c      |  2 +-
 tools/testing/selftests/kvm/demand_paging_test.c   |  2 +-
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |  8 ++++----
 tools/testing/selftests/kvm/include/test_util.h    |  2 ++
 tools/testing/selftests/kvm/kvm_page_table_test.c  |  2 +-
 tools/testing/selftests/kvm/lib/test_util.c        | 14 ++++++++++++++
 .../testing/selftests/kvm/max_guest_memory_test.c  |  6 +++---
 .../kvm/memslot_modification_stress_test.c         |  4 ++--
 tools/testing/selftests/kvm/memslot_perf_test.c    | 10 +++++-----
 .../testing/selftests/kvm/set_memory_region_test.c |  2 +-
 .../selftests/kvm/x86_64/nx_huge_pages_test.c      |  4 ++--
 13 files changed, 43 insertions(+), 27 deletions(-)

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
index 1c2749b1481a..99b16302d94d 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -361,7 +361,7 @@ int main(int argc, char *argv[])
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
index acf8b80c91d1..1346f6b5a9bd 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -417,7 +417,7 @@ int main(int argc, char *argv[])
 			dirty_log_manual_caps = 0;
 			break;
 		case 'f':
-			p.wr_fract = atoi(optarg);
+			p.wr_fract = atoi_paranoid(optarg);
 			TEST_ASSERT(p.wr_fract >= 1,
 				    "Write fraction cannot be less than one");
 			break;
@@ -428,7 +428,7 @@ int main(int argc, char *argv[])
 			help(argv[0]);
 			break;
 		case 'i':
-			p.iterations = atoi(optarg);
+			p.iterations = atoi_paranoid(optarg);
 			break;
 		case 'm':
 			guest_modes_cmdline(optarg);
@@ -446,12 +446,12 @@ int main(int argc, char *argv[])
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
index 5c5a88180b6c..56776f431733 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -150,4 +150,6 @@ static inline void *align_ptr_up(void *x, size_t size)
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
index 6d23878bbfe1..1e560c30a696 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -334,3 +334,17 @@ long get_run_delay(void)
 
 	return val[1];
 }
+
+int atoi_paranoid(const char *num_str)
+{
+	int num;
+	char *end_ptr;
+
+	errno = 0;
+	num = (int)strtol(num_str, &end_ptr, 10);
+	TEST_ASSERT(errno == 0, "Conversion error: %d\n", errno);
+	TEST_ASSERT(num_str != end_ptr && *end_ptr == '\0',
+		    "Invalid number string.\n");
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
index cc6421716400..5e18d716782b 100644
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -233,10 +233,10 @@ int main(int argc, char **argv)
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
2.37.2.672.g94769d06f0-goog

