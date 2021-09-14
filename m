Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2192940BBA9
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 00:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235878AbhINWgU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 18:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235846AbhINWdc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 18:33:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1CFC06178A
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 15:31:56 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 83-20020a251956000000b0059948f541cbso947022ybz.7
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 15:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mkrEw/6odZA643/v871JIfxaL0FOz/JzQ68NluiA4Io=;
        b=pWguaZ1X+xc+kKgb8hGucMka7FFypIerPRLXgRPBLAECFpye62NakBo8+/PZ4szLMK
         0qBUCuVwIjlDg6CGOVVgtJS/H5b+HA0k7Bz+dVFJ3Z66BMhybAZTx9Q+zbYjuvzNm0uE
         pENB4oui1tQ2AGPrZY3vIqtHyJQSmhclt0fnLauAEtMiGrH94dv9Tj+XZf0CJ0/uP1y1
         RcZTOwSg8YPttPXs+F+gesKkiD/xrnxhe4cL1t96RKvMzT6MCUQ6+mvOtqke9Rxd8hQU
         BQvpFhqZUuV78y6q+EpEsFCwitAu1cnKeW6Zuix/Nl8BRhGfi+H3Uhc5Vwv5g9zzpB08
         3PsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mkrEw/6odZA643/v871JIfxaL0FOz/JzQ68NluiA4Io=;
        b=coePhgzQZKSpC6VyjaNeeqvpYNzvyhkcGpJrJPGktsjaR5jOAvunYCI/JaL/Mz89Wa
         /gyfz1djCG//8MGgdFOv7xuJhtASpoJpYriuQuoJZgczeLZqo8JzIPThAc5YKph14cam
         E8pSSRoX1/I/gPz5JEoj73VjxqV+SKqg6FSS8zcYZO3FxrUHm5067ALutb8jrZYB7V5u
         l9jkTKZiQ88eDI4s+NzcqzzliqGIQfujcgaGXme0kTWkuaPDncVBOLiuYEIkxEc1ykAM
         ktXVYzTXSN/FzqwMn3rcpEPMBgOfNFnH4GFXyiTnh/n3ZneYmm6tTA9+ArWQh6zAlGFF
         dmbA==
X-Gm-Message-State: AOAM531PLcgROtwfkcMOu8aMbP6wPGTeEbeYEqWGLzO03iVgSOthmjIH
        R5bPNpCH4rt0qLZ1QoqGsCX3Xn9+AJTM
X-Google-Smtp-Source: ABdhPJzpZoa9zZGM5vyPXwbQ3eFL89rD2TZs6diqA8ymkENI2ijJ9n/sNgUdRcVwqCDFoumpgDFICiXbFpuB
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:eb0b:: with SMTP id
 d11mr1889054ybs.101.1631658715856; Tue, 14 Sep 2021 15:31:55 -0700 (PDT)
Date:   Tue, 14 Sep 2021 22:31:14 +0000
In-Reply-To: <20210914223114.435273-1-rananta@google.com>
Message-Id: <20210914223114.435273-16-rananta@google.com>
Mime-Version: 1.0
References: <20210914223114.435273-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v7 15/15] KVM: arm64: selftests: arch_timer: Support vCPU migration
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
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/aarch64/arch_timer.c        | 115 +++++++++++++++++-
 1 file changed, 114 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 3b6ea6a462f4..228e7ed5531c 100644
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
@@ -80,6 +87,9 @@ static struct test_vcpu_shared_data vcpu_shared_data[KVM_MAX_VCPUS];
 
 static int vtimer_irq, ptimer_irq;
 
+static unsigned long *vcpu_done_map;
+static pthread_mutex_t vcpu_done_map_lock;
+
 static void
 guest_configure_timer_action(struct test_vcpu_shared_data *shared_data)
 {
@@ -215,6 +225,11 @@ static void *test_vcpu_run(void *arg)
 
 	vcpu_run(vm, vcpuid);
 
+	/* Currently, any exit from guest is an indication of completion */
+	pthread_mutex_lock(&vcpu_done_map_lock);
+	set_bit(vcpuid, vcpu_done_map);
+	pthread_mutex_unlock(&vcpu_done_map_lock);
+
 	switch (get_ucall(vm, vcpuid, &uc)) {
 	case UCALL_SYNC:
 	case UCALL_DONE:
@@ -233,9 +248,78 @@ static void *test_vcpu_run(void *arg)
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
+
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
+
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
@@ -243,8 +327,23 @@ static void test_run(struct kvm_vm *vm)
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
 
 static void test_init_timer_irq(struct kvm_vm *vm)
@@ -301,6 +400,8 @@ static void test_print_help(char *name)
 		NR_TEST_ITERS_DEF);
 	pr_info("\t-p: Periodicity (in ms) of the guest timer (default: %u)\n",
 		TIMER_TEST_PERIOD_MS_DEF);
+	pr_info("\t-m: Frequency (in ms) of vCPUs to migrate to different pCPU. 0 to turn off (default: %u)\n",
+		TIMER_TEST_MIGRATION_FREQ_MS);
 	pr_info("\t-h: print this help screen\n");
 }
 
@@ -308,7 +409,7 @@ static bool parse_args(int argc, char *argv[])
 {
 	int opt;
 
-	while ((opt = getopt(argc, argv, "hn:i:p:")) != -1) {
+	while ((opt = getopt(argc, argv, "hn:i:p:m:")) != -1) {
 		switch (opt) {
 		case 'n':
 			test_args.nr_vcpus = atoi(optarg);
@@ -335,6 +436,13 @@ static bool parse_args(int argc, char *argv[])
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
@@ -358,6 +466,11 @@ int main(int argc, char *argv[])
 	if (!parse_args(argc, argv))
 		exit(KSFT_SKIP);
 
+	if (test_args.migration_freq_ms && get_nprocs() < 2) {
+		print_skip("At least two physical CPUs needed for vCPU migration");
+		exit(KSFT_SKIP);
+	}
+
 	vm = test_vm_create();
 	test_run(vm);
 	kvm_vm_free(vm);
-- 
2.33.0.309.g3052b89438-goog

