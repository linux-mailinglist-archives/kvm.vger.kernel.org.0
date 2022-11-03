Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C536A6188A8
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 20:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbiKCTUQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 15:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbiKCTTi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 15:19:38 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27837222BD
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 12:17:54 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id q3-20020a17090311c300b0017898180dddso1924578plh.0
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 12:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e3JYiAUQQRWKLGF50CeTvf+Wuh3InMfajk/MWXVrEkI=;
        b=sfZh29qx0kLnNdp34OArwg6gIrmM7CTmPWLBNm+sovfEYu59QOJQAq3M32tbcljgyB
         +HpflTek3WA33NIfmLjd1yIJJAC7RQ2p0Qu4syYEivEGv2aA7/zJcF6zOjM2IVfkxDlb
         WYMUSza+OFrfAqu+KhDWv1I30uaAlNWJ6nK5F97/Tw2Uykvt+cSAe9kxo1SlSWT6jQmp
         aGk9GrX/vT2lfJc9wg0TFYkwFSxxwcp8TYqwiXDPpf7I2VsEzI+WB7CD2Q87weVkgwLG
         vuQJmvwSjoOn/vnCubTlYcTeqPSCGvOJEwVQ45ojujTY83cqJvpqnpE7vkISZd2cmhiY
         HMKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e3JYiAUQQRWKLGF50CeTvf+Wuh3InMfajk/MWXVrEkI=;
        b=hxqzIZGphiK+EwApa7Fl3PIga/YCC0yA5W7a7OBfwInBHq6Y4XQkykNafqRSUr0Ipp
         0g/fi4V2ANqqhVHC+QPWZh0eNq8BkeCnqonMWlWLmc8XDs3SPJaoSXfYKlVRztMaz+6Z
         Gy6y8MICJgG0YyOBVHnYbbsELGIUmZQx5eh2RFy4fWXtCWZiBQ7HV6fvomyLOfgpJ8je
         7FZoztjzQpprIul+VIM9tf7+8JtKwzkWfGqUCQ3wYiWu26nHrMt8hODcoPmxLwyAzfgk
         Whs/IZvGrsAd/D2XFC+ggPdX6dFpBE4CZAAEbhSuBb4myGvOmbre8WoRG7upir9FZEBa
         bIsw==
X-Gm-Message-State: ACrzQf3D7IB5OB0caLe4J2Jb3ziaIp0mqEB/yixROQxVNIUu/mwm03Qr
        Zh4aiKYqVNKPX+lv+6nwLyuPVkEUVlKz
X-Google-Smtp-Source: AMsMyM7lWBa42ivfsP1sfDSsFCOumi6d48dIk0I2oBW7EfC12C+nUhCGnUkOc/QKtXn7UZsghL1zazCYHH8c
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:1a04:b0:52a:d4dc:5653 with SMTP
 id g4-20020a056a001a0400b0052ad4dc5653mr31954891pfv.69.1667503056685; Thu, 03
 Nov 2022 12:17:36 -0700 (PDT)
Date:   Thu,  3 Nov 2022 12:17:18 -0700
In-Reply-To: <20221103191719.1559407-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221103191719.1559407-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221103191719.1559407-7-vipinsh@google.com>
Subject: [PATCH v9 6/7] KVM: selftests: Add atoi_positive() and
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
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/arch_timer.c        | 25 ++++---------------
 .../selftests/kvm/aarch64/debug-exceptions.c  |  2 +-
 .../testing/selftests/kvm/aarch64/vgic_irq.c  |  2 +-
 .../selftests/kvm/access_tracking_perf_test.c |  2 +-
 .../selftests/kvm/demand_paging_test.c        |  4 +--
 .../selftests/kvm/dirty_log_perf_test.c       | 12 ++++-----
 .../testing/selftests/kvm/include/test_util.h | 16 ++++++++++++
 .../selftests/kvm/kvm_page_table_test.c       |  4 +--
 .../selftests/kvm/max_guest_memory_test.c     |  9 +++----
 .../kvm/memslot_modification_stress_test.c    | 10 +++-----
 .../testing/selftests/kvm/memslot_perf_test.c | 22 ++++------------
 .../selftests/kvm/set_memory_region_test.c    |  2 +-
 .../selftests/kvm/x86_64/nx_huge_pages_test.c |  3 +--
 13 files changed, 47 insertions(+), 66 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 251e7ff04883..9409617fce9c 100644
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
+			test_args.nr_vcpus = atoi_positive("Number of vCPUs", optarg);
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
+			test_args.nr_iter = atoi_positive("Number of iterations", optarg);
 			break;
 		case 'p':
-			test_args.timer_period_ms = atoi_paranoid(optarg);
-			if (test_args.timer_period_ms <= 0) {
-				pr_info("Positive value needed for -p\n");
-				goto err;
-			}
+			test_args.timer_period_ms = atoi_positive("Periodicity", optarg);
 			break;
 		case 'm':
-			test_args.migration_freq_ms = atoi_paranoid(optarg);
-			if (test_args.migration_freq_ms < 0) {
-				pr_info("0 or positive value needed for -m\n");
-				goto err;
-			}
+			test_args.migration_freq_ms = atoi_non_negative("Frequency", optarg);
 			break;
 		case 'h':
 		default:
diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 19fffdf19c9f..878c334607e1 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -423,7 +423,7 @@ int main(int argc, char *argv[])
 	while ((opt = getopt(argc, argv, "i:")) != -1) {
 		switch (opt) {
 		case 'i':
-			ss_iteration = atoi_paranoid(optarg);
+			ss_iteration = atoi_positive("Number of iterations", optarg);
 			break;
 		case 'h':
 		default:
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index ae90b718070a..4ead42a072b7 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -824,7 +824,7 @@ int main(int argc, char **argv)
 	while ((opt = getopt(argc, argv, "hn:e:l:")) != -1) {
 		switch (opt) {
 		case 'n':
-			nr_irqs = atoi_paranoid(optarg);
+			nr_irqs = atoi_non_negative("Number of IRQs", optarg);
 			if (nr_irqs > 1024 || nr_irqs % 32)
 				help(argv[0]);
 			break;
diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index c6bcc5301e2c..a81e7a7ae18f 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -368,7 +368,7 @@ int main(int argc, char *argv[])
 			params.vcpu_memory_bytes = parse_size(optarg);
 			break;
 		case 'v':
-			params.nr_vcpus = atoi_paranoid(optarg);
+			params.nr_vcpus = atoi_positive("Number of vCPUs", optarg);
 			break;
 		case 'o':
 			overlap_memory_access = true;
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 82597fb04146..0c98181fa248 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -427,8 +427,8 @@ int main(int argc, char *argv[])
 			p.src_type = parse_backing_src_type(optarg);
 			break;
 		case 'v':
-			nr_vcpus = atoi_paranoid(optarg);
-			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
+			nr_vcpus = atoi_positive("Number of vCPUs", optarg);
+			TEST_ASSERT(nr_vcpus <= max_vcpus,
 				    "Invalid number of vcpus, must be between 1 and %d", max_vcpus);
 			break;
 		case 'o':
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index ecda802b78ff..4d639683b8ef 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -416,9 +416,7 @@ int main(int argc, char *argv[])
 			run_vcpus_while_disabling_dirty_logging = true;
 			break;
 		case 'f':
-			p.wr_fract = atoi_paranoid(optarg);
-			TEST_ASSERT(p.wr_fract >= 1,
-				    "Write fraction cannot be less than one");
+			p.wr_fract = atoi_positive("Write fraction", optarg);
 			break;
 		case 'g':
 			dirty_log_manual_caps = 0;
@@ -427,7 +425,7 @@ int main(int argc, char *argv[])
 			help(argv[0]);
 			break;
 		case 'i':
-			p.iterations = atoi_paranoid(optarg);
+			p.iterations = atoi_positive("Number of iterations", optarg);
 			break;
 		case 'm':
 			guest_modes_cmdline(optarg);
@@ -445,12 +443,12 @@ int main(int argc, char *argv[])
 			p.backing_src = parse_backing_src_type(optarg);
 			break;
 		case 'v':
-			nr_vcpus = atoi_paranoid(optarg);
-			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
+			nr_vcpus = atoi_positive("Number of vCPUs", optarg);
+			TEST_ASSERT(nr_vcpus <= max_vcpus,
 				    "Invalid number of vcpus, must be between 1 and %d", max_vcpus);
 			break;
 		case 'x':
-			p.slots = atoi_paranoid(optarg);
+			p.slots = atoi_positive("Number of slots", optarg);
 			break;
 		default:
 			help(argv[0]);
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index feae42863759..3be98e81189a 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -154,4 +154,20 @@ static inline void *align_ptr_up(void *x, size_t size)
 
 int atoi_paranoid(const char *num_str);
 
+static inline uint32_t atoi_positive(const char *name, const char *num_str)
+{
+	int num = atoi_paranoid(num_str);
+
+	TEST_ASSERT(num > 0, "%s must be greater than 0, got '%s'", name, num_str);
+	return num;
+}
+
+static inline uint32_t atoi_non_negative(const char *name, const char *num_str)
+{
+	int num = atoi_paranoid(num_str);
+
+	TEST_ASSERT(num >= 0, "%s must be non-negative, got '%s'", name, num_str);
+	return num;
+}
+
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index ea7feb69bb88..696b366be06b 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -461,8 +461,8 @@ int main(int argc, char *argv[])
 			p.test_mem_size = parse_size(optarg);
 			break;
 		case 'v':
-			nr_vcpus = atoi_paranoid(optarg);
-			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
+			nr_vcpus = atoi_positive("Number of vCPUs", optarg);
+			TEST_ASSERT(nr_vcpus <= max_vcpus,
 				    "Invalid number of vcpus, must be between 1 and %d", max_vcpus);
 			break;
 		case 's':
diff --git a/tools/testing/selftests/kvm/max_guest_memory_test.c b/tools/testing/selftests/kvm/max_guest_memory_test.c
index 8056dc5831b5..feaf2be20ff2 100644
--- a/tools/testing/selftests/kvm/max_guest_memory_test.c
+++ b/tools/testing/selftests/kvm/max_guest_memory_test.c
@@ -193,16 +193,13 @@ int main(int argc, char *argv[])
 	while ((opt = getopt(argc, argv, "c:h:m:s:H")) != -1) {
 		switch (opt) {
 		case 'c':
-			nr_vcpus = atoi_paranoid(optarg);
-			TEST_ASSERT(nr_vcpus > 0, "number of vcpus must be >0");
+			nr_vcpus = atoi_positive("Number of vCPUs", optarg);
 			break;
 		case 'm':
-			max_mem = 1ull * atoi_paranoid(optarg) * SZ_1G;
-			TEST_ASSERT(max_mem > 0, "memory size must be >0");
+			max_mem = 1ull * atoi_positive("Memory size", optarg) * SZ_1G;
 			break;
 		case 's':
-			slot_size = 1ull * atoi_paranoid(optarg) * SZ_1G;
-			TEST_ASSERT(slot_size > 0, "slot size must be >0");
+			slot_size = 1ull * atoi_positive("Slot size", optarg) * SZ_1G;
 			break;
 		case 'H':
 			hugepages = true;
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index f27f07e4a5cc..3ddf2fb9fa86 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -156,16 +156,14 @@ int main(int argc, char *argv[])
 			guest_modes_cmdline(optarg);
 			break;
 		case 'd':
-			p.delay = atoi_paranoid(optarg);
-			TEST_ASSERT(p.delay >= 0,
-				    "A negative delay is not supported.");
+			p.delay = atoi_non_negative("Delay", optarg);
 			break;
 		case 'b':
 			guest_percpu_mem_size = parse_size(optarg);
 			break;
 		case 'v':
-			nr_vcpus = atoi_paranoid(optarg);
-			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
+			nr_vcpus = atoi_positive("Number of vCPUs", optarg);
+			TEST_ASSERT(nr_vcpus <= max_vcpus,
 				    "Invalid number of vcpus, must be between 1 and %d",
 				    max_vcpus);
 			break;
@@ -173,7 +171,7 @@ int main(int argc, char *argv[])
 			p.partition_vcpu_memory_access = false;
 			break;
 		case 'i':
-			p.nr_iterations = atoi_paranoid(optarg);
+			p.nr_iterations = atoi_positive("Number of iterations", optarg);
 			break;
 		case 'h':
 		default:
diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 4bae9e3f5ca1..330aaef1c02f 100644
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
+			targs->tfirst = atoi_non_negative("First test", optarg);
 			break;
 		case 'e':
-			targs->tlast = atoi_paranoid(optarg);
-			if (targs->tlast < 0 || targs->tlast >= NTESTS) {
+			targs->tlast = atoi_non_negative("Last test", optarg);
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
+			targs->seconds = atoi_non_negative("Test length", optarg);
 			break;
 		case 'r':
-			targs->runs = atoi_paranoid(optarg);
-			if (targs->runs <= 0) {
-				pr_info("Runs per test has to be positive\n");
-				return false;
-			}
+			targs->runs = atoi_positive("Runs per test", optarg);
 			break;
 		}
 	}
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index c366949c8362..85c16f09a50e 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -407,7 +407,7 @@ int main(int argc, char *argv[])
 
 #ifdef __x86_64__
 	if (argc > 1)
-		loops = atoi_paranoid(argv[1]);
+		loops = atoi_positive("Number of iterations", argv[1]);
 	else
 		loops = 10;
 
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
index 354b6902849c..ea0978f22db8 100644
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -241,7 +241,7 @@ int main(int argc, char **argv)
 	while ((opt = getopt(argc, argv, "hp:t:r")) != -1) {
 		switch (opt) {
 		case 'p':
-			reclaim_period_ms = atoi_paranoid(optarg);
+			reclaim_period_ms = atoi_non_negative("Reclaim period", optarg);
 			break;
 		case 't':
 			token = atoi_paranoid(optarg);
@@ -257,7 +257,6 @@ int main(int argc, char **argv)
 	}
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_VM_DISABLE_NX_HUGE_PAGES));
-	TEST_REQUIRE(reclaim_period_ms > 0);
 
 	__TEST_REQUIRE(token == MAGIC_TOKEN,
 		       "This test must be run with the magic token %d.\n"
-- 
2.38.1.273.g43a17bfeac-goog

