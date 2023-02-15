Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF6C697336
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbjBOBIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbjBOBIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:08:14 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B4B32CD5
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:41 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id c11-20020a056e020bcb00b0030be9d07d63so12355000ilu.0
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YKcCEtcasEy96yYR95uUDcecBsDQdV3knxsKnUz3/Gk=;
        b=rIfYoIsp11nNcN2vFQFjrLmBGnkW3VKkYELEsBzzdFFKc1eONWEWEhfn7jUzJlAoMt
         cu+Ez8zm4icxn2Z2lh80OLwAA7AZ9w+CI8Ne5gadJqKHfe1Q7bGiltcBiADfflGELbs6
         OD0FlA7wv9AIURH3u6ovnn3pYVRsnG1ebwxoQooTVuO7okm7vXbEzbZwJHmW/pShuk65
         xdpN56Wij3QdIA7unnNsS67RhL4mUIgKWdwinB8n+P5sFOpntJ3UWdcJgjIqLdIzO2U2
         edssb8KFyLxO3/Pdh8xS1SPuuN+VDNJCWB1LSqHoH6tkJw8hiqvAyRZyO759S9TywzFw
         kRQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YKcCEtcasEy96yYR95uUDcecBsDQdV3knxsKnUz3/Gk=;
        b=oXEb4o5Ms7m+DIKf+i51pWQQiPhCCeNMUMpySFgUKPO7YVXwsdLy5cGGKoxWF66NVl
         mZi0fflIxa3UfTiYSHLVLvRuA/tcoDAFPncL9a2pZsUen9fhJWfaP85vyhVrLxzvi6XW
         2/+Lu+h5yMzqceu9O98BfioXBP/2GYsJsTzmModxCHNpvGjdxTtUO5ZmFt+QBYRRt4XZ
         VM5mnCFBwEL9SiXQngDHee/IQlHMQoySw+AL7RUahsdS5JdHxn8eFPhLkbleCAHKkq4K
         /QWwAMtPwAtoQc4gAtzh8KcvCtYO8P1LBpwvL5Pi3Ns8ROVLpHiRKmjqfYQ+7zfyh+7P
         2ISA==
X-Gm-Message-State: AO0yUKXCRlxtJf7NetpHDlhH6Jslqhd2N4LOLECeLsbE0/58qRPSHcPt
        aI0rYKMJh05oKlt3lyELzjydAYr304PZ
X-Google-Smtp-Source: AK7set8eypuzPxapcfOamnWx0i/1N4TWhXPPHogRkxrXl/P/lAHb3z5rdSK4UAh3DxdOcRqbbCw0c3QWJhrI
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:22b5])
 (user=rananta job=sendgmr) by 2002:a92:7606:0:b0:30f:4ee:3d93 with SMTP id
 r6-20020a927606000000b0030f04ee3d93mr296233ilc.1.1676423260760; Tue, 14 Feb
 2023 17:07:40 -0800 (PST)
Date:   Wed, 15 Feb 2023 01:07:17 +0000
In-Reply-To: <20230215010717.3612794-1-rananta@google.com>
Mime-Version: 1.0
References: <20230215010717.3612794-1-rananta@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010717.3612794-17-rananta@google.com>
Subject: [REPOST PATCH 16/16] selftests: KVM: aarch64: Extend the vCPU
 migration test to multi-vCPUs
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
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

To test KVM's handling of multiple vCPU contexts together, that are
frequently migrating across random pCPUs in the system, extend the test
to create a VM with multiple vCPUs and validate the behavior.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 .../testing/selftests/kvm/aarch64/vpmu_test.c | 166 ++++++++++++------
 1 file changed, 114 insertions(+), 52 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vpmu_test.c b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
index 239fc7e06b3b9..c9d8e5f9a22ab 100644
--- a/tools/testing/selftests/kvm/aarch64/vpmu_test.c
+++ b/tools/testing/selftests/kvm/aarch64/vpmu_test.c
@@ -19,11 +19,12 @@
  * higher exception levels (EL2, EL3). Verify this functionality by
  * configuring and trying to count the events for EL2 in the guest.
  *
- * 4. Since the PMU registers are per-cpu, stress KVM by frequently
- * migrating the guest vCPU to random pCPUs in the system, and check
- * if the vPMU is still behaving as expected. The sub-tests include
- * testing basic functionalities such as basic counters behavior,
- * overflow, overflow interrupts, and chained events.
+ * 4. Since the PMU registers are per-cpu, stress KVM by creating a
+ * multi-vCPU VM, then frequently migrate the guest vCPUs to random
+ * pCPUs in the system, and check if the vPMU is still behaving as
+ * expected. The sub-tests include testing basic functionalities such
+ * as basic counters behavior, overflow, overflow interrupts, and
+ * chained events.
  *
  * Copyright (c) 2022 Google LLC.
  *
@@ -348,19 +349,22 @@ struct guest_irq_data {
 	struct spinlock lock;
 };
 
-static struct guest_irq_data guest_irq_data;
+static struct guest_irq_data guest_irq_data[KVM_MAX_VCPUS];
 
 #define VCPU_MIGRATIONS_TEST_ITERS_DEF		1000
 #define VCPU_MIGRATIONS_TEST_MIGRATION_FREQ_MS	2
+#define VCPU_MIGRATIONS_TEST_NR_VPUS_DEF	2
 
 struct test_args {
 	int vcpu_migration_test_iter;
 	int vcpu_migration_test_migrate_freq_ms;
+	int vcpu_migration_test_nr_vcpus;
 };
 
 static struct test_args test_args = {
 	.vcpu_migration_test_iter = VCPU_MIGRATIONS_TEST_ITERS_DEF,
 	.vcpu_migration_test_migrate_freq_ms = VCPU_MIGRATIONS_TEST_MIGRATION_FREQ_MS,
+	.vcpu_migration_test_nr_vcpus = VCPU_MIGRATIONS_TEST_NR_VPUS_DEF,
 };
 
 static void guest_sync_handler(struct ex_regs *regs)
@@ -396,26 +400,34 @@ static void guest_validate_irq(int pmc_idx, uint32_t pmovsclr, uint32_t pmc_idx_
 	}
 }
 
+static struct guest_irq_data *get_irq_data(void)
+{
+	uint32_t cpu = guest_get_vcpuid();
+
+	return &guest_irq_data[cpu];
+}
+
 static void guest_irq_handler(struct ex_regs *regs)
 {
 	uint32_t pmc_idx_bmap;
 	uint64_t i, pmcr_n = get_pmcr_n();
 	uint32_t pmovsclr = read_pmovsclr();
 	unsigned int intid = gic_get_and_ack_irq();
+	struct guest_irq_data *irq_data = get_irq_data();
 
 	/* No other IRQ apart from the PMU IRQ is expected */
 	GUEST_ASSERT_1(intid == PMU_IRQ, intid);
 
-	spin_lock(&guest_irq_data.lock);
-	pmc_idx_bmap = READ_ONCE(guest_irq_data.pmc_idx_bmap);
+	spin_lock(&irq_data->lock);
+	pmc_idx_bmap = READ_ONCE(irq_data->pmc_idx_bmap);
 
 	for (i = 0; i < pmcr_n; i++)
 		guest_validate_irq(i, pmovsclr, pmc_idx_bmap);
 	guest_validate_irq(ARMV8_PMU_CYCLE_COUNTER_IDX, pmovsclr, pmc_idx_bmap);
 
 	/* Mark IRQ as recived for the corresponding PMCs */
-	WRITE_ONCE(guest_irq_data.irq_received_bmap, pmovsclr);
-	spin_unlock(&guest_irq_data.lock);
+	WRITE_ONCE(irq_data->irq_received_bmap, pmovsclr);
+	spin_unlock(&irq_data->lock);
 
 	gic_set_eoi(intid);
 }
@@ -423,35 +435,40 @@ static void guest_irq_handler(struct ex_regs *regs)
 static int pmu_irq_received(int pmc_idx)
 {
 	bool irq_received;
+	struct guest_irq_data *irq_data = get_irq_data();
 
-	spin_lock(&guest_irq_data.lock);
-	irq_received = READ_ONCE(guest_irq_data.irq_received_bmap) & BIT(pmc_idx);
-	WRITE_ONCE(guest_irq_data.irq_received_bmap, guest_irq_data.pmc_idx_bmap & ~BIT(pmc_idx));
-	spin_unlock(&guest_irq_data.lock);
+	spin_lock(&irq_data->lock);
+	irq_received = READ_ONCE(irq_data->irq_received_bmap) & BIT(pmc_idx);
+	WRITE_ONCE(irq_data->irq_received_bmap, irq_data->pmc_idx_bmap & ~BIT(pmc_idx));
+	spin_unlock(&irq_data->lock);
 
 	return irq_received;
 }
 
 static void pmu_irq_init(int pmc_idx)
 {
+	struct guest_irq_data *irq_data = get_irq_data();
+
 	write_pmovsclr(BIT(pmc_idx));
 
-	spin_lock(&guest_irq_data.lock);
-	WRITE_ONCE(guest_irq_data.irq_received_bmap, guest_irq_data.pmc_idx_bmap & ~BIT(pmc_idx));
-	WRITE_ONCE(guest_irq_data.pmc_idx_bmap, guest_irq_data.pmc_idx_bmap | BIT(pmc_idx));
-	spin_unlock(&guest_irq_data.lock);
+	spin_lock(&irq_data->lock);
+	WRITE_ONCE(irq_data->irq_received_bmap, irq_data->pmc_idx_bmap & ~BIT(pmc_idx));
+	WRITE_ONCE(irq_data->pmc_idx_bmap, irq_data->pmc_idx_bmap | BIT(pmc_idx));
+	spin_unlock(&irq_data->lock);
 
 	enable_irq(pmc_idx);
 }
 
 static void pmu_irq_exit(int pmc_idx)
 {
+	struct guest_irq_data *irq_data = get_irq_data();
+
 	write_pmovsclr(BIT(pmc_idx));
 
-	spin_lock(&guest_irq_data.lock);
-	WRITE_ONCE(guest_irq_data.irq_received_bmap, guest_irq_data.pmc_idx_bmap & ~BIT(pmc_idx));
-	WRITE_ONCE(guest_irq_data.pmc_idx_bmap, guest_irq_data.pmc_idx_bmap & ~BIT(pmc_idx));
-	spin_unlock(&guest_irq_data.lock);
+	spin_lock(&irq_data->lock);
+	WRITE_ONCE(irq_data->irq_received_bmap, irq_data->pmc_idx_bmap & ~BIT(pmc_idx));
+	WRITE_ONCE(irq_data->pmc_idx_bmap, irq_data->pmc_idx_bmap & ~BIT(pmc_idx));
+	spin_unlock(&irq_data->lock);
 
 	disable_irq(pmc_idx);
 }
@@ -783,7 +800,8 @@ static void test_event_count(uint64_t event, int pmc_idx, bool expect_count)
 static void test_basic_pmu_functionality(void)
 {
 	local_irq_disable();
-	gic_init(GIC_V3, 1, (void *)GICD_BASE_GPA, (void *)GICR_BASE_GPA);
+	gic_init(GIC_V3, test_args.vcpu_migration_test_nr_vcpus,
+			(void *)GICD_BASE_GPA, (void *)GICR_BASE_GPA);
 	gic_irq_enable(PMU_IRQ);
 	local_irq_enable();
 
@@ -1093,11 +1111,13 @@ static void guest_evtype_filter_test(void)
 
 static void guest_vcpu_migration_test(void)
 {
+	int iter = test_args.vcpu_migration_test_iter;
+
 	/*
 	 * While the userspace continuously migrates this vCPU to random pCPUs,
 	 * run basic PMU functionalities and verify the results.
 	 */
-	while (test_args.vcpu_migration_test_iter--)
+	while (iter--)
 		test_basic_pmu_functionality();
 }
 
@@ -1472,17 +1492,23 @@ static void run_kvm_evtype_filter_test(void)
 
 struct vcpu_migrate_data {
 	struct vpmu_vm *vpmu_vm;
-	pthread_t *pt_vcpu;
-	bool vcpu_done;
+	pthread_t *pt_vcpus;
+	unsigned long *vcpu_done_map;
+	pthread_mutex_t vcpu_done_map_lock;
 };
 
+struct vcpu_migrate_data migrate_data;
+
 static void *run_vcpus_migrate_test_func(void *arg)
 {
-	struct vcpu_migrate_data *migrate_data = arg;
-	struct vpmu_vm *vpmu_vm = migrate_data->vpmu_vm;
+	struct vpmu_vm *vpmu_vm = migrate_data.vpmu_vm;
+	unsigned int vcpu_idx = (unsigned long)arg;
 
-	run_vcpu(vpmu_vm->vcpus[0]);
-	migrate_data->vcpu_done = true;
+	run_vcpu(vpmu_vm->vcpus[vcpu_idx]);
+
+	pthread_mutex_lock(&migrate_data.vcpu_done_map_lock);
+	__set_bit(vcpu_idx, migrate_data.vcpu_done_map);
+	pthread_mutex_unlock(&migrate_data.vcpu_done_map_lock);
 
 	return NULL;
 }
@@ -1504,7 +1530,7 @@ static uint32_t get_pcpu(void)
 	return pcpu;
 }
 
-static int migrate_vcpu(struct vcpu_migrate_data *migrate_data)
+static int migrate_vcpu(int vcpu_idx)
 {
 	int ret;
 	cpu_set_t cpuset;
@@ -1513,9 +1539,9 @@ static int migrate_vcpu(struct vcpu_migrate_data *migrate_data)
 	CPU_ZERO(&cpuset);
 	CPU_SET(new_pcpu, &cpuset);
 
-	pr_debug("Migrating vCPU to pCPU: %u\n", new_pcpu);
+	pr_debug("Migrating vCPU %d to pCPU: %u\n", vcpu_idx, new_pcpu);
 
-	ret = pthread_setaffinity_np(*migrate_data->pt_vcpu, sizeof(cpuset), &cpuset);
+	ret = pthread_setaffinity_np(migrate_data.pt_vcpus[vcpu_idx], sizeof(cpuset), &cpuset);
 
 	/* Allow the error where the vCPU thread is already finished */
 	TEST_ASSERT(ret == 0 || ret == ESRCH,
@@ -1526,48 +1552,74 @@ static int migrate_vcpu(struct vcpu_migrate_data *migrate_data)
 
 static void *vcpus_migrate_func(void *arg)
 {
-	struct vcpu_migrate_data *migrate_data = arg;
+	struct vpmu_vm *vpmu_vm = migrate_data.vpmu_vm;
+	int i, n_done, nr_vcpus = vpmu_vm->nr_vcpus;
+	bool vcpu_done;
 
-	while (!migrate_data->vcpu_done) {
+	do {
 		usleep(msecs_to_usecs(test_args.vcpu_migration_test_migrate_freq_ms));
-		migrate_vcpu(migrate_data);
-	}
+		for (n_done = 0, i = 0; i < nr_vcpus; i++) {
+			pthread_mutex_lock(&migrate_data.vcpu_done_map_lock);
+			vcpu_done = test_bit(i, migrate_data.vcpu_done_map);
+			pthread_mutex_unlock(&migrate_data.vcpu_done_map_lock);
+
+			if (vcpu_done) {
+				n_done++;
+				continue;
+			}
+
+			migrate_vcpu(i);
+		}
+
+	} while (nr_vcpus != n_done);
 
 	return NULL;
 }
 
 static void run_vcpu_migration_test(uint64_t pmcr_n)
 {
-	int ret;
+	int i, nr_vcpus, ret;
 	struct vpmu_vm *vpmu_vm;
-	pthread_t pt_vcpu, pt_sched;
-	struct vcpu_migrate_data migrate_data = {
-		.pt_vcpu = &pt_vcpu,
-		.vcpu_done = false,
-	};
+	pthread_t pt_sched, *pt_vcpus;
 
 	__TEST_REQUIRE(get_nprocs() >= 2, "At least two pCPUs needed for vCPU migration test");
 
 	guest_data.test_stage = TEST_STAGE_VCPU_MIGRATION;
 	guest_data.expected_pmcr_n = pmcr_n;
 
-	migrate_data.vpmu_vm = vpmu_vm = create_vpmu_vm(1, guest_code, NULL);
+	nr_vcpus = test_args.vcpu_migration_test_nr_vcpus;
+
+	migrate_data.vcpu_done_map = bitmap_zalloc(nr_vcpus);
+	TEST_ASSERT(migrate_data.vcpu_done_map, "Failed to create vCPU done bitmap");
+	pthread_mutex_init(&migrate_data.vcpu_done_map_lock, NULL);
+
+	migrate_data.pt_vcpus = pt_vcpus = calloc(nr_vcpus, sizeof(*pt_vcpus));
+	TEST_ASSERT(pt_vcpus, "Failed to create vCPU thread pointers");
+
+	migrate_data.vpmu_vm = vpmu_vm = create_vpmu_vm(nr_vcpus, guest_code, NULL);
 
 	/* Initialize random number generation for migrating vCPUs to random pCPUs */
 	srand(time(NULL));
 
-	/* Spawn a vCPU thread */
-	ret = pthread_create(&pt_vcpu, NULL, run_vcpus_migrate_test_func, &migrate_data);
-	TEST_ASSERT(!ret, "Failed to create the vCPU thread");
+	/* Spawn vCPU threads */
+	for (i = 0; i < nr_vcpus; i++) {
+		ret = pthread_create(&pt_vcpus[i], NULL,
+					run_vcpus_migrate_test_func,  (void *)(unsigned long)i);
+		TEST_ASSERT(!ret, "Failed to create the vCPU thread: %d", i);
+	}
 
 	/* Spawn a scheduler thread to force-migrate vCPUs to various pCPUs */
-	ret = pthread_create(&pt_sched, NULL, vcpus_migrate_func, &migrate_data);
+	ret = pthread_create(&pt_sched, NULL, vcpus_migrate_func, NULL);
 	TEST_ASSERT(!ret, "Failed to create the scheduler thread for migrating the vCPUs");
 
 	pthread_join(pt_sched, NULL);
-	pthread_join(pt_vcpu, NULL);
+
+	for (i = 0; i < nr_vcpus; i++)
+		pthread_join(pt_vcpus[i], NULL);
 
 	destroy_vpmu_vm(vpmu_vm);
+	free(pt_vcpus);
+	bitmap_free(migrate_data.vcpu_done_map);
 }
 
 static void run_tests(uint64_t pmcr_n)
@@ -1596,12 +1648,14 @@ static uint64_t get_pmcr_n_limit(void)
 
 static void print_help(char *name)
 {
-	pr_info("Usage: %s [-h] [-i vcpu_migration_test_iterations] [-m vcpu_migration_freq_ms]\n",
-		name);
+	pr_info("Usage: %s [-h] [-i vcpu_migration_test_iterations] [-m vcpu_migration_freq_ms]"
+		"[-n vcpu_migration_nr_vcpus]\n", name);
 	pr_info("\t-i: Number of iterations of vCPU migrations test (default: %u)\n",
 		VCPU_MIGRATIONS_TEST_ITERS_DEF);
 	pr_info("\t-m: Frequency (in ms) of vCPUs to migrate to different pCPU. (default: %u)\n",
 		VCPU_MIGRATIONS_TEST_MIGRATION_FREQ_MS);
+	pr_info("\t-n: Number of vCPUs for vCPU migrations test. (default: %u)\n",
+		VCPU_MIGRATIONS_TEST_NR_VPUS_DEF);
 	pr_info("\t-h: print this help screen\n");
 }
 
@@ -1609,7 +1663,7 @@ static bool parse_args(int argc, char *argv[])
 {
 	int opt;
 
-	while ((opt = getopt(argc, argv, "hi:m:")) != -1) {
+	while ((opt = getopt(argc, argv, "hi:m:n:")) != -1) {
 		switch (opt) {
 		case 'i':
 			test_args.vcpu_migration_test_iter =
@@ -1619,6 +1673,14 @@ static bool parse_args(int argc, char *argv[])
 			test_args.vcpu_migration_test_migrate_freq_ms =
 				atoi_positive("vCPU migration frequency", optarg);
 			break;
+		case 'n':
+			test_args.vcpu_migration_test_nr_vcpus =
+				atoi_positive("Nr vCPUs for vCPU migrations", optarg);
+			if (test_args.vcpu_migration_test_nr_vcpus > KVM_MAX_VCPUS) {
+				pr_info("Max allowed vCPUs: %u\n", KVM_MAX_VCPUS);
+				goto err;
+			}
+			break;
 		case 'h':
 		default:
 			goto err;
-- 
2.39.1.581.gbfd45094c4-goog

