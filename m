Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E1E7206EC
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 18:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236609AbjFBQJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 12:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236592AbjFBQJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 12:09:32 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52AE31BB
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 09:09:28 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-53f44c2566dso973969a12.2
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 09:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722167; x=1688314167;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vX8ZCjC9l+xt5cqUnwzlqCkk/7EvJIEZcs67EwYM95Y=;
        b=ZpYUhbbZC6uUYrReM+ixNdEUwp22WUU7l8j2aahWsJUYqP381L7DaYeopKye6+Q9sn
         w6jGO0nX6WnAtH7Q3sGlOdc68vECR5PacYtF8uFrv3gPYqUB1KYLtsQIi3wA+701ktoo
         VcYLyZENUnFYI88cWmJbgLosheXItBqWsjUj1JOOFK7yQMQ1EVYBrKEM74EAZ9G1JJes
         +Fy3XP3gLD3JszJ1CTZiXeoILpXFoZBpgnn/vdDYBMvk+Dqwv0kvHMMpaOH7tt3QFj+s
         ke1ao1kRwftxIusnCaBSonu2zz1KVzCGGfUgW7HZsGqYe4xCh5lCKxmVw7qkF3LGd5ny
         Gpkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722167; x=1688314167;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vX8ZCjC9l+xt5cqUnwzlqCkk/7EvJIEZcs67EwYM95Y=;
        b=Et5cILaqsl6BApuzPypYW0yyYnRP0JSdZ2vmomc1zKJvOGhcdi8RjFnFiCQxI6J6UF
         si/+WqrSINWcrtdlJbIHCgNc8vnvgep4cDEtpC5QhGL6fXgUFRb8CxZZGjseRG8xM00G
         3seP7agcaTAH9rQXQRMe+v/A07Xo+hwgn0XibfPyj16fvVBIof1qQm+LRFQZh7N2aSAh
         l0nXHOBZ0UqRFuMMagceDNA/zea2qFcdGCfpjesk0DJ68sMu88RkL6tiHWFxj/hYtO9h
         sWBwr4fuNhNlmhZBycwpgUSwSaYmLA5Xwm/vbb5zGLeh+3/kXRKCuoTOnCoDsb2YndJG
         rF1A==
X-Gm-Message-State: AC+VfDwtcPYfpR67wzoeKlAll1MoPDXMx4G8d8QYAGqaB8eSUKESfqbx
        wf0NaCU+u9M3ak2JW9VAHncb2AlES29Y
X-Google-Smtp-Source: ACHHUZ7w+3zMwOJ66cN0pwH2useIGj7AgTlfLjnw5VFZgi7VE2BNKptqAZGtU12TE7bl7/aJEHHayi6hzCyj
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a63:685:0:b0:530:866e:c3c1 with SMTP id
 127-20020a630685000000b00530866ec3c1mr2520235pgg.11.1685722167618; Fri, 02
 Jun 2023 09:09:27 -0700 (PDT)
Date:   Fri,  2 Jun 2023 09:09:02 -0700
In-Reply-To: <20230602160914.4011728-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230602160914.4011728-1-vipinsh@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602160914.4011728-5-vipinsh@google.com>
Subject: [PATCH v2 04/16] KVM: selftests: Print read-write progress by vCPUs
 in dirty_log_perf_test
From:   Vipin Sharma <vipinsh@google.com>
To:     maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
        aleksandar.qemu.devel@gmail.com, tsbogend@alpha.franken.de,
        anup@brainfault.org, atishp@atishpatra.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, seanjc@google.com, pbonzini@redhat.com,
        dmatlack@google.com, ricarkol@google.com
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
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

Fetch count of read and write accesses from guest code and print sum of
these values across all vCPUs in dirty_log_perf_test.

This data provides progress made by vCPUs during dirty logging
operations. Since, vCPUs execute in lockstep with userspace dirty log
iterations, this metric is not very interesting. However, in future
commits when dirty_log_perf_test can execute vCPUs independently from
dirty log iterations then this metric can give good measure of vCPUs
performance during dirty logging.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c        | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 2e31f13aaba6..14b012a0dcb1 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -12,6 +12,7 @@
 #include <stdlib.h>
 #include <time.h>
 #include <pthread.h>
+#include <stdatomic.h>
 #include <linux/bitmap.h>
 
 #include "kvm_util.h"
@@ -66,17 +67,22 @@ static u64 dirty_log_manual_caps;
 static bool host_quit;
 static int iteration;
 static int vcpu_last_completed_iteration[KVM_MAX_VCPUS];
+static atomic_ullong total_reads;
+static atomic_ullong total_writes;
 
 static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 {
 	struct kvm_vcpu *vcpu = vcpu_args->vcpu;
 	int vcpu_idx = vcpu_args->vcpu_idx;
 	uint64_t pages_count = 0;
+	uint64_t reads = 0;
+	uint64_t writes = 0;
 	struct kvm_run *run;
 	struct timespec start;
 	struct timespec ts_diff;
 	struct timespec total = (struct timespec){0};
 	struct timespec avg;
+	struct ucall uc = {};
 	int ret;
 
 	run = vcpu->run;
@@ -89,7 +95,7 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 		ts_diff = timespec_elapsed(start);
 
 		TEST_ASSERT(ret == 0, "vcpu_run failed: %d\n", ret);
-		TEST_ASSERT(get_ucall(vcpu, NULL) == UCALL_SYNC,
+		TEST_ASSERT(get_ucall(vcpu, &uc) == UCALL_SYNC,
 			    "Invalid guest sync status: exit_reason=%s\n",
 			    exit_reason_str(run->exit_reason));
 
@@ -101,6 +107,8 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 		if (current_iteration) {
 			pages_count += vcpu_args->pages;
 			total = timespec_add(total, ts_diff);
+			reads += uc.args[2];
+			writes += uc.args[3];
 			pr_debug("vCPU %d iteration %d dirty memory time: %ld.%.9lds\n",
 				vcpu_idx, current_iteration, ts_diff.tv_sec,
 				ts_diff.tv_nsec);
@@ -123,6 +131,8 @@ static void vcpu_worker(struct memstress_vcpu_args *vcpu_args)
 	pr_debug("\nvCPU %d dirtied 0x%lx pages over %d iterations in %ld.%.9lds. (Avg %ld.%.9lds/iteration)\n",
 		vcpu_idx, pages_count, vcpu_last_completed_iteration[vcpu_idx],
 		total.tv_sec, total.tv_nsec, avg.tv_sec, avg.tv_nsec);
+	atomic_fetch_add(&total_reads, reads);
+	atomic_fetch_add(&total_writes, writes);
 }
 
 struct test_params {
@@ -270,6 +280,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			      dirty_log_manual_caps);
 
 	arch_setup_vm(vm, nr_vcpus);
+	atomic_store(&total_reads, 0);
+	atomic_store(&total_writes, 0);
 
 	/* Start the iterations */
 	iteration = 0;
@@ -388,6 +400,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			clear_dirty_log_total.tv_nsec, avg.tv_sec, avg.tv_nsec);
 	}
 
+	pr_info("Total pages touched: %llu (Reads: %llu, Writes: %llu)\n",
+		atomic_load(&total_reads) + atomic_load(&total_writes),
+		atomic_load(&total_reads), atomic_load(&total_writes));
+
 	free_bitmaps(bitmaps, p->slots);
 	arch_cleanup_vm(vm);
 	memstress_destroy_vm(vm);
-- 
2.41.0.rc0.172.g3f132b7071-goog

