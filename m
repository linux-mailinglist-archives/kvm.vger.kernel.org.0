Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC8140430C
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 03:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350256AbhIIBma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 21:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350286AbhIIBl5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 21:41:57 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D159C0619FE
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 18:39:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f83-20020a25cf56000000b005a0445377e8so360490ybg.20
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 18:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4OIc2sSKc5PiPc2xTSosx0KfrjbnKTlWe//IPTDuYu4=;
        b=icCH1PAZUBFK2QTRdnVCwUZk++tC3+Z/TKIBuCVxZtlGzQ97I3F4gyGsHngVphVsI9
         o4r6WjEUk26x3P3ydmjoLIRILK7iOi1YHJSCE1vbkZnAAceei8hCkoh5A+yKEbwhyRVO
         demvx+RcQSAcrO5eElDdTV7+nbYP3Ph+UD/gYB/WeKQzh2hK7IRtusYsumIPJ4zRszU9
         w+Gw37Pzhkibz+KSrFMugXzTaWpDYxIXLaOEYQzuIXpMJMlQkEDNeWOHM8U7IW0j5Hiz
         tVBy66xElaMw5oKiEHab7SRt4rSnZF4o3T2vZ3aGQ+rOBBUnJ28nPdRS/dl4qz3fuoH4
         fiYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4OIc2sSKc5PiPc2xTSosx0KfrjbnKTlWe//IPTDuYu4=;
        b=qixSffC8TBAIeWd3X63wJ1oxGD4dtp6BL26QwPimGXojLCGFS2ArG7EWiao+3j+qnV
         PCMhA1sA7p8q+U7wwnnbJZzfWQ7+u7xquXGXScZ9WQ2OPYUksoLRyU00dug1LsBCLZM6
         PWBWMt4aHme9HtlNgR0rTlG8CmCOiY8Wj9mRIWSeKrVlxz9mqlqr5sWDIzo5ctlSrYX+
         KL0tKm61kcVIJew7OTcIaSgLGY9Yi9Sl7x2olbJ7JvwQxNMi69O2hZuu7ryCUQFYtG0q
         wBwROMySVJ6/J0c6id+WnLKN/zNTzxxDIRWBPJFsXrQGDUNzOi7SP0TpRXfVsiaqwBl/
         xkcg==
X-Gm-Message-State: AOAM530lGGAkdOCll0D2egxp76tYmAAp7iipQR0fanG5edr0GbPHZdQp
        6tVos/z0SA8bWMAZfEy3lTEOmS6XCi9c
X-Google-Smtp-Source: ABdhPJzV7/nQ7w8OHl4rXBpv1VGAeMX7mcXIRC/vkEWV39vJHcqhs3IbBsVcXu/0kz+YtVcN0eg7d/mHOnYG
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:c6c1:: with SMTP id
 k184mr521559ybf.277.1631151542393; Wed, 08 Sep 2021 18:39:02 -0700 (PDT)
Date:   Thu,  9 Sep 2021 01:38:16 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-17-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 16/18] KVM: arm64: selftests: arch_timer: Support vCPU migration
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the timer stack (hardware and KVM) is per-CPU, there
are potential chances for races to occur when the scheduler
decides to migrate a vCPU thread to a different physical CPU.
Hence, include an option to stress-test this part as well by
forcing the vCPUs to migrate across physical CPUs in the
system at a particular rate.

Originally, the bug for the fix with commit 3134cc8beb69d0d
("KVM: arm64: vgic: Resample HW pending state on deactivation")
was discovered using arch_timer test with vCPU migrations and
can be easily reproduced.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../selftests/kvm/aarch64/arch_timer.c        | 113 +++++++++++++++++-
 1 file changed, 112 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 6141c387e6dc..aac7bcea4352 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -14,6 +14,8 @@
  *
  * The test provides command-line options to configure the timer's
  * period (-p), number of vCPUs (-n), and iterations per stage (-i).
+ * To stress-test the timer stack even more, an option to migrate the
+ * vCPUs across pCPUs (-m), at a particular rate, is also provided.
  *
  * Copyright (c) 2021, Google LLC.
  */
@@ -24,6 +26,8 @@
 #include <pthread.h>
 #include <linux/kvm.h>
 #include <linux/sizes.h>
+#include <linux/bitmap.h>
+#include <sys/sysinfo.h>
 
 #include "kvm_util.h"
 #include "processor.h"
@@ -36,17 +40,20 @@
 #define NR_TEST_ITERS_DEF		5
 #define TIMER_TEST_PERIOD_MS_DEF	10
 #define TIMER_TEST_ERR_MARGIN_US	100
+#define TIMER_TEST_MIGRATION_FREQ_MS	2
 
 struct test_args {
 	int nr_vcpus;
 	int nr_iter;
 	int timer_period_ms;
+	int migration_freq_ms;
 };
 
 static struct test_args test_args = {
 	.nr_vcpus = NR_VCPUS_DEF,
 	.nr_iter = NR_TEST_ITERS_DEF,
 	.timer_period_ms = TIMER_TEST_PERIOD_MS_DEF,
+	.migration_freq_ms = TIMER_TEST_MIGRATION_FREQ_MS,
 };
 
 #define msecs_to_usecs(msec)		((msec) * 1000LL)
@@ -81,6 +88,9 @@ struct test_vcpu {
 static struct test_vcpu test_vcpu[KVM_MAX_VCPUS];
 static struct test_vcpu_shared_data vcpu_shared_data[KVM_MAX_VCPUS];
 
+static unsigned long *vcpu_done_map;
+static pthread_mutex_t vcpu_done_map_lock;
+
 static void
 guest_configure_timer_action(struct test_vcpu_shared_data *shared_data)
 {
@@ -216,6 +226,11 @@ static void *test_vcpu_run(void *arg)
 
 	vcpu_run(vm, vcpuid);
 
+	/* Currently, any exit from guest is an indication of completion */
+	pthread_mutex_lock(&vcpu_done_map_lock);
+	set_bit(vcpuid, vcpu_done_map);
+	pthread_mutex_unlock(&vcpu_done_map_lock);
+
 	switch (get_ucall(vm, vcpuid, &uc)) {
 	case UCALL_SYNC:
 	case UCALL_DONE:
@@ -234,9 +249,76 @@ static void *test_vcpu_run(void *arg)
 	return NULL;
 }
 
+static uint32_t test_get_pcpu(void)
+{
+	uint32_t pcpu;
+	unsigned int nproc_conf;
+	cpu_set_t online_cpuset;
+
+	nproc_conf = get_nprocs_conf();
+	sched_getaffinity(0, sizeof(cpu_set_t), &online_cpuset);
+
+	/* Randomly find an available pCPU to place a vCPU on */
+	do {
+		pcpu = rand() % nproc_conf;
+	} while (!CPU_ISSET(pcpu, &online_cpuset));
+
+	return pcpu;
+}
+static int test_migrate_vcpu(struct test_vcpu *vcpu)
+{
+	int ret;
+	cpu_set_t cpuset;
+	uint32_t new_pcpu = test_get_pcpu();
+
+	CPU_ZERO(&cpuset);
+	CPU_SET(new_pcpu, &cpuset);
+
+	pr_debug("Migrating vCPU: %u to pCPU: %u\n", vcpu->vcpuid, new_pcpu);
+
+	ret = pthread_setaffinity_np(vcpu->pt_vcpu_run,
+					sizeof(cpuset), &cpuset);
+
+	/* Allow the error where the vCPU thread is already finished */
+	TEST_ASSERT(ret == 0 || ret == ESRCH,
+			"Failed to migrate the vCPU:%u to pCPU: %u; ret: %d\n",
+			vcpu->vcpuid, new_pcpu, ret);
+
+	return ret;
+}
+static void *test_vcpu_migration(void *arg)
+{
+	unsigned int i, n_done;
+	bool vcpu_done;
+
+	do {
+		usleep(msecs_to_usecs(test_args.migration_freq_ms));
+
+		for (n_done = 0, i = 0; i < test_args.nr_vcpus; i++) {
+			pthread_mutex_lock(&vcpu_done_map_lock);
+			vcpu_done = test_bit(i, vcpu_done_map);
+			pthread_mutex_unlock(&vcpu_done_map_lock);
+
+			if (vcpu_done) {
+				n_done++;
+				continue;
+			}
+
+			test_migrate_vcpu(&test_vcpu[i]);
+		}
+	} while (test_args.nr_vcpus != n_done);
+
+	return NULL;
+}
+
 static void test_run(struct kvm_vm *vm)
 {
 	int i, ret;
+	pthread_t pt_vcpu_migration;
+
+	pthread_mutex_init(&vcpu_done_map_lock, NULL);
+	vcpu_done_map = bitmap_alloc(test_args.nr_vcpus);
+	TEST_ASSERT(vcpu_done_map, "Failed to allocate vcpu done bitmap\n");
 
 	for (i = 0; i < test_args.nr_vcpus; i++) {
 		ret = pthread_create(&test_vcpu[i].pt_vcpu_run, NULL,
@@ -244,8 +326,23 @@ static void test_run(struct kvm_vm *vm)
 		TEST_ASSERT(!ret, "Failed to create vCPU-%d pthread\n", i);
 	}
 
+	/* Spawn a thread to control the vCPU migrations */
+	if (test_args.migration_freq_ms) {
+		srand(time(NULL));
+
+		ret = pthread_create(&pt_vcpu_migration, NULL,
+					test_vcpu_migration, NULL);
+		TEST_ASSERT(!ret, "Failed to create the migration pthread\n");
+	}
+
+
 	for (i = 0; i < test_args.nr_vcpus; i++)
 		pthread_join(test_vcpu[i].pt_vcpu_run, NULL);
+
+	if (test_args.migration_freq_ms)
+		pthread_join(pt_vcpu_migration, NULL);
+
+	bitmap_free(vcpu_done_map);
 }
 
 static struct kvm_vm *test_vm_create(void)
@@ -286,6 +383,8 @@ static void test_print_help(char *name)
 		NR_TEST_ITERS_DEF);
 	pr_info("\t-p: Periodicity (in ms) of the guest timer (default: %u)\n",
 		TIMER_TEST_PERIOD_MS_DEF);
+	pr_info("\t-m: Frequency (in ms) of vCPUs to migrate to different pCPU. 0 to turn off (default: %u)\n",
+		TIMER_TEST_MIGRATION_FREQ_MS);
 	pr_info("\t-h: print this help screen\n");
 }
 
@@ -293,7 +392,7 @@ static bool parse_args(int argc, char *argv[])
 {
 	int opt;
 
-	while ((opt = getopt(argc, argv, "hn:i:p:")) != -1) {
+	while ((opt = getopt(argc, argv, "hn:i:p:m:")) != -1) {
 		switch (opt) {
 		case 'n':
 			test_args.nr_vcpus = atoi(optarg);
@@ -320,6 +419,13 @@ static bool parse_args(int argc, char *argv[])
 				goto err;
 			}
 			break;
+		case 'm':
+			test_args.migration_freq_ms = atoi(optarg);
+			if (test_args.migration_freq_ms < 0) {
+				pr_info("0 or positive value needed for -m\n");
+				goto err;
+			}
+			break;
 		case 'h':
 		default:
 			goto err;
@@ -343,6 +449,11 @@ int main(int argc, char *argv[])
 	if (!parse_args(argc, argv))
 		exit(KSFT_SKIP);
 
+	if (get_nprocs() < 2) {
+		print_skip("At least two physical CPUs needed for vCPU migration");
+		exit(KSFT_SKIP);
+	}
+
 	vm = test_vm_create();
 	test_run(vm);
 	kvm_vm_free(vm);
-- 
2.33.0.153.gba50c8fa24-goog

