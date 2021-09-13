Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01EC40A167
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 01:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344450AbhIMXMx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 19:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349613AbhIMXL6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 19:11:58 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D426EC06178C
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 16:10:33 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f64-20020a2538430000b0290593bfc4b046so14970317yba.9
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 16:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mkrEw/6odZA643/v871JIfxaL0FOz/JzQ68NluiA4Io=;
        b=omSztA5jx1ZDK4bGekWatikS8TbQnmzTqKwcBBBDzYL2BqrEO7cS4B1CwTFlfJH+zl
         la3SCcyApQoAR2rBE8BzpKgjc8TOA5SZl3P5/Q9a9G5bW3znc3Vi7pdbi6V5JhdHpgTQ
         j+4Um5G1sI3S/PLcBq2MdaWMKG4OCo3AqeTJT6zSbLq585/gywL6olfHQJuW8watr0ou
         MrsHy62s3NRaT1fSPWjCxJ7JCqbIXf11ikshRUXP9hlpVkG0hweJMo5S1c1UcjSFdbam
         QTZZ2w7DBDPWl35weml+QVk4VLL1jkfO3IG7MblakMqQO3OnbMwXuyaH0vP9QI558Vio
         x6+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mkrEw/6odZA643/v871JIfxaL0FOz/JzQ68NluiA4Io=;
        b=cvG4bH/MKQcoDTHOESJi70dWKy1bVjedwCdI99SKiStdKaeNkqyEebbfL4qT9eVg+K
         jT91jDErIorgE0H8NHFOF/NR1AOWgutJUuj6Yo8bmWLgki1qbp8PHrNRU0YYtaFdlJS4
         UuGBdze7D91nkDYvd4lstzbG7EQoH65f4uEyYbGY4agP9Hi0JOueupSksZPacxpB1MwT
         HmIRJWpy8bFn9lL9Y9xmxMVnUDODgwvKIe4fTDedVqaJieXoo1Un2/5hF0stpXWcsiB3
         7GO61gCHo/Gw2S0aZElGKOrCOAJNcSz4SSMbSW+CQlNI5T/HKEG28dx9kqw1Bvd+5RT3
         7yDw==
X-Gm-Message-State: AOAM533La8aQeqpt3jHH4c6JQr+LFHlHrkgaY4mOPnrGl6q4V5r8WMkn
        L2ozkScRxeXKI+0gUxO8z36fmW6ddIRg
X-Google-Smtp-Source: ABdhPJwr/zwzZfn9H8PexHzVbehoGCRGw3mByNih/740GTSh9rk5TRjsqEPUSLw1qhKgiEOY0w090Wpoao0P
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:b98b:: with SMTP id
 r11mr18356489ybg.189.1631574633078; Mon, 13 Sep 2021 16:10:33 -0700 (PDT)
Date:   Mon, 13 Sep 2021 23:09:55 +0000
In-Reply-To: <20210913230955.156323-1-rananta@google.com>
Message-Id: <20210913230955.156323-15-rananta@google.com>
Mime-Version: 1.0
References: <20210913230955.156323-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v6 14/14] KVM: arm64: selftests: arch_timer: Support vCPU migration
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

