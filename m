Return-Path: <kvm+bounces-8617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C000852CF5
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 10:51:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C169B1F23741
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 09:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FC2F56741;
	Tue, 13 Feb 2024 09:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lYJQgbKH"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9B05646E
	for <kvm@vger.kernel.org>; Tue, 13 Feb 2024 09:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707817433; cv=none; b=H57KiP6JTNizEoGCx0DK8AZtk1JSwK5Kfm5Y5gzVkN84p1Nw1ph7bvEKAgwTlrDNWG5CPofmGJMLhzGxQeCttrDzjyIQJ5vCXeeMt27mOwlb14FvtqXUaYfnn2wv8tNC5HGj2VGtIw7BVNBfdPq1Lt20OfRD88tp4p3Yt0I9oPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707817433; c=relaxed/simple;
	bh=EV24iNdzDT2nEj7Q1vml0ardEk2Nqgw3CUGt3h9w/3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRdSkxOY3GUnR6H4ibDOtvz/xtUDjbUxgG3jT3bKLxrygAlvm7aOddcR2pRN8ZODWBK/fUJnxwTtj7Yy8c9ShRodNNPY1Hfz62eeEZvrB7MCFkKGlJruSD5gKmTsxAEXKr+51RqNuHsGnh2NAl/nfcwTz6JurbIF4Y1qJ4nZAfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lYJQgbKH; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707817429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H13Cz6CLHkaFtkIfr3ij1xpNFb/J5ZQsFY/+Jqrv/6c=;
	b=lYJQgbKHGs5rTKG8xSw+PjdRNhoA6IMdh3A+K7IvmYSODoqaXsQ3KOr34W0wdEhnkfNsRc
	M3S6tIxLTOfED1QPyMkXT0QWLO6H1zFIRS8Jsfsv5rQMOtH/+xkp5BJjLY5x9riqVLUbi+
	S3gze4o6ow2WHJXQgwJgbUG8TyMJiQk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 23/23] KVM: selftests: Add stress test for LPI injection
Date: Tue, 13 Feb 2024 09:43:34 +0000
Message-ID: <20240213094334.3963630-1-oliver.upton@linux.dev>
In-Reply-To: <20240213093250.3960069-1-oliver.upton@linux.dev>
References: <20240213093250.3960069-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Now that all the infrastructure is in place, add a test to stress KVM's
LPI injection. Keep a 1:1 mapping of device IDs to signalling threads,
allowing the user to scale up/down the sender side of an LPI. Make use
of the new VM stats for the translation cache to estimate the
translation hit rate.

Since the primary focus of the test is on performance, you'll notice
that the guest code is not pedantic about the LPIs it receives. Counting
the number of LPIs would require synchronization between the device and
vCPU threads to avoid coalescing and would get in the way of performance
numbers.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/vgic_lpi_stress.c   | 388 ++++++++++++++++++
 2 files changed, 389 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_lpi_stress.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 492e937fab00..8a240d20ec5e 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -153,6 +153,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/smccc_filter
 TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
+TEST_GEN_PROGS_aarch64 += aarch64/vgic_lpi_stress
 TEST_GEN_PROGS_aarch64 += aarch64/vpmu_counter_access
 TEST_GEN_PROGS_aarch64 += access_tracking_perf_test
 TEST_GEN_PROGS_aarch64 += demand_paging_test
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_lpi_stress.c b/tools/testing/selftests/kvm/aarch64/vgic_lpi_stress.c
new file mode 100644
index 000000000000..d557d907728a
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/vgic_lpi_stress.c
@@ -0,0 +1,388 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * vgic_lpi_stress - Stress test for KVM's ITS emulation
+ *
+ * Copyright (c) 2024 Google LLC
+ */
+
+#include <linux/sizes.h>
+#include <pthread.h>
+#include <sys/sysinfo.h>
+
+#include "kvm_util.h"
+#include "gic.h"
+#include "gic_v3.h"
+#include "processor.h"
+#include "ucall.h"
+#include "vgic.h"
+
+#define TEST_MEMSLOT_INDEX	1
+
+#define GIC_LPI_OFFSET	8192
+
+static u32 nr_vcpus = 1;
+static u32 nr_devices = 1;
+static u32 nr_event_ids = 16;
+static size_t nr_iterations = 1000;
+static vm_paddr_t gpa_base;
+
+static struct kvm_vm *vm;
+static struct kvm_vcpu **vcpus;
+static struct vgic_its *its;
+static int gic_fd;
+
+static bool request_vcpus_stop;
+
+static void guest_irq_handler(struct ex_regs *regs)
+{
+	u32 intid = gic_get_and_ack_irq();
+
+	if (intid == IAR_SPURIOUS)
+		return;
+
+	GUEST_ASSERT(intid >= GIC_LPI_OFFSET);
+	gic_set_eoi(intid);
+}
+
+static void guest_code(size_t nr_lpis)
+{
+	gic_init(GIC_V3, nr_vcpus);
+
+	GUEST_SYNC(0);
+
+	/*
+	 * Don't use WFI here to avoid blocking the vCPU thread indefinitely and
+	 * never getting the stop singal.
+	 */
+	while (!READ_ONCE(request_vcpus_stop))
+		cpu_relax();
+
+	GUEST_DONE();
+}
+
+static void setup_memslot(void)
+{
+	size_t pages;
+	size_t sz;
+
+	/*
+	 * For the ITS:
+	 *  - A single level device table
+	 *  - A single level collection table
+	 *  - The command queue
+	 *  - An ITT for each device
+	 */
+	sz = (3 + nr_devices) * SZ_64K;
+
+	/*
+	 * For the redistributors:
+	 *  - A shared LPI configuration table
+	 *  - An LPI pending table for each vCPU
+	 */
+	sz += (1 + nr_vcpus) * SZ_64K;
+
+	pages = sz / vm->page_size;
+	gpa_base = ((vm_compute_max_gfn(vm) + 1) * vm->page_size) - sz;
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa_base,
+				    TEST_MEMSLOT_INDEX, pages, 0);
+}
+
+#define LPI_PROP_DEFAULT_PRIO	0xa0
+
+static void configure_lpis(vm_paddr_t prop_table)
+{
+	u8 *tbl = addr_gpa2hva(vm, prop_table);
+	size_t i;
+
+	for (i = 0; i < (nr_devices * nr_event_ids); i++) {
+		tbl[i] = LPI_PROP_DEFAULT_PRIO |
+			 LPI_PROP_GROUP1 |
+			 LPI_PROP_ENABLED;
+	}
+}
+
+static void setup_gic(void)
+{
+	vm_paddr_t coll_table, device_table, cmdq_base;
+
+	gic_fd = vgic_v3_setup(vm, nr_vcpus, 64);
+	__TEST_REQUIRE(gic_fd >= 0, "Failed to create GICv3");
+
+	coll_table = vm_phy_pages_alloc_aligned(vm, SZ_64K / vm->page_size,
+						gpa_base, TEST_MEMSLOT_INDEX);
+	device_table = vm_phy_pages_alloc_aligned(vm, SZ_64K / vm->page_size,
+						  gpa_base, TEST_MEMSLOT_INDEX);
+	cmdq_base = vm_phy_pages_alloc_aligned(vm, SZ_64K / vm->page_size,
+					       gpa_base, TEST_MEMSLOT_INDEX);
+
+	its = vgic_its_setup(vm, coll_table, SZ_64K,
+			     device_table, SZ_64K, cmdq_base, SZ_64K);
+}
+
+static void setup_its_mappings(void)
+{
+	u32 coll_id, device_id, event_id, intid = GIC_LPI_OFFSET;
+
+	for (coll_id = 0; coll_id < nr_vcpus; coll_id++)
+		vgic_its_send_mapc_cmd(its, vcpus[coll_id], coll_id, true);
+
+	/* Round-robin the LPIs to all of the vCPUs in the VM */
+	coll_id = 0;
+	for (device_id = 0; device_id < nr_devices; device_id++) {
+		vm_paddr_t itt_base = vm_phy_pages_alloc_aligned(vm, SZ_64K / vm->page_size,
+								 gpa_base, TEST_MEMSLOT_INDEX);
+
+		vgic_its_send_mapd_cmd(its, device_id, itt_base, SZ_64K, true);
+
+		for (event_id = 0; event_id < nr_event_ids; event_id++) {
+			vgic_its_send_mapti_cmd(its, device_id, event_id, coll_id,
+						intid++);
+
+			coll_id = (coll_id + 1) % nr_vcpus;
+		}
+	}
+}
+
+static void setup_rdists_for_lpis(void)
+{
+	size_t i;
+
+	vm_paddr_t prop_table = vm_phy_pages_alloc_aligned(vm, SZ_64K / vm->page_size,
+							   gpa_base, TEST_MEMSLOT_INDEX);
+
+	configure_lpis(prop_table);
+
+	for (i = 0; i < nr_vcpus; i++) {
+		vm_paddr_t pend_table;
+
+		pend_table = vm_phy_pages_alloc_aligned(vm, SZ_64K / vm->page_size,
+							gpa_base, TEST_MEMSLOT_INDEX);
+
+		vgic_rdist_enable_lpis(gic_fd, vcpus[i], prop_table, SZ_64K, pend_table);
+	}
+}
+
+static void invalidate_all_rdists(void)
+{
+	int i;
+
+	for (i = 0; i < nr_vcpus; i++)
+		vgic_its_send_invall_cmd(its, i);
+}
+
+static void signal_lpi(u32 device_id, u32 event_id)
+{
+	vm_paddr_t db_addr = GITS_BASE_GPA + GITS_TRANSLATER;
+
+	struct kvm_msi msi = {
+		.address_lo	= db_addr,
+		.address_hi	= db_addr >> 32,
+		.data		= event_id,
+		.devid		= device_id,
+		.flags		= KVM_MSI_VALID_DEVID,
+	};
+
+	/*
+	 * KVM_SIGNAL_MSI returns 1 if the MSI wasn't 'blocked' by the VM,
+	 * which for arm64 implies having a valid translation in the ITS.
+	 */
+	TEST_ASSERT(__vm_ioctl(vm, KVM_SIGNAL_MSI, &msi) == 1,
+		    "KVM_SIGNAL_MSI ioctl failed");
+}
+
+static pthread_barrier_t test_setup_barrier;
+static pthread_barrier_t test_start_barrier;
+
+static void *lpi_worker_thread(void *data)
+{
+	u32 device_id = (size_t)data;
+	u32 event_id;
+	size_t i;
+
+	pthread_barrier_wait(&test_start_barrier);
+
+	for (i = 0; i < nr_iterations; i++)
+		for (event_id = 0; event_id < nr_event_ids; event_id++)
+			signal_lpi(device_id, event_id);
+
+	return NULL;
+}
+
+static void *vcpu_worker_thread(void *data)
+{
+	struct kvm_vcpu *vcpu = data;
+	struct ucall uc;
+
+	while (true) {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			/*
+			 * Tell the main thread to complete its last bit of
+			 * setup and wait for the signal to start the test.
+			 */
+			pthread_barrier_wait(&test_setup_barrier);
+			pthread_barrier_wait(&test_start_barrier);
+			break;
+		case UCALL_DONE:
+			return NULL;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		default:
+			TEST_FAIL("Unknown ucall: %lu", uc.cmd);
+		}
+	}
+
+	return NULL;
+}
+
+static void report_stats(struct timespec delta)
+{
+	u64 cache_hits, cache_misses, cache_accesses;
+	double nr_lpis;
+	double time;
+
+	nr_lpis = nr_devices * nr_event_ids * nr_iterations;
+
+	time = delta.tv_sec;
+	time += ((double)delta.tv_nsec) / NSEC_PER_SEC;
+
+	pr_info("Rate: %.2f LPIs/sec\n", nr_lpis / time);
+
+	__vm_get_stat(vm, "vgic_its_trans_cache_hit", &cache_hits, 1);
+	__vm_get_stat(vm, "vgic_its_trans_cache_miss", &cache_misses, 1);
+
+	cache_accesses = cache_hits + cache_misses;
+
+	pr_info("Translation Cache\n");
+	pr_info("  %lu hits\n", cache_hits);
+	pr_info("  %lu misses\n", cache_misses);
+	pr_info("  %.2f%% hit rate\n", 100 * (((double)cache_hits) / cache_accesses));
+}
+
+static void run_test(void)
+{
+	pthread_t *lpi_threads = malloc(nr_devices * sizeof(pthread_t));
+	pthread_t *vcpu_threads = malloc(nr_vcpus * sizeof(pthread_t));
+	struct timespec start, delta;
+	size_t i;
+
+	TEST_ASSERT(lpi_threads && vcpu_threads, "Failed to allocate pthread arrays");
+
+	/* Only the vCPU threads need to do setup before starting the VM. */
+	pthread_barrier_init(&test_setup_barrier, NULL, nr_vcpus + 1);
+	pthread_barrier_init(&test_start_barrier, NULL, nr_devices + nr_vcpus + 1);
+
+	for (i = 0; i < nr_vcpus; i++)
+		pthread_create(&vcpu_threads[i], NULL, vcpu_worker_thread, vcpus[i]);
+
+	for (i = 0; i < nr_devices; i++)
+		pthread_create(&lpi_threads[i], NULL, lpi_worker_thread, (void *)i);
+
+	pthread_barrier_wait(&test_setup_barrier);
+
+	/*
+	 * Setup LPIs for the VM after the guest has initialized the GIC. Yes,
+	 * this is weird to be doing in userspace, but creating ITS translations
+	 * requires allocating an ITT for every device.
+	 */
+	setup_rdists_for_lpis();
+	setup_its_mappings();
+	invalidate_all_rdists();
+
+	clock_gettime(CLOCK_MONOTONIC, &start);
+	pthread_barrier_wait(&test_start_barrier);
+
+	for (i = 0; i < nr_devices; i++)
+		pthread_join(lpi_threads[i], NULL);
+
+	delta = timespec_elapsed(start);
+	write_guest_global(vm, request_vcpus_stop, true);
+
+	for (i = 0; i < nr_vcpus; i++)
+		pthread_join(vcpu_threads[i], NULL);
+
+	report_stats(delta);
+}
+
+static void setup_vm(void)
+{
+	int i;
+
+	vcpus = malloc(nr_vcpus * sizeof(struct kvm_vcpu));
+	TEST_ASSERT(vcpus, "Failed to allocate vCPU array");
+
+	vm = vm_create_with_vcpus(nr_vcpus, guest_code, vcpus);
+
+	vm_init_descriptor_tables(vm);
+	for (i = 0; i < nr_vcpus; i++)
+		vcpu_init_descriptor_tables(vcpus[i]);
+
+	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT, guest_irq_handler);
+
+	setup_memslot();
+
+	setup_gic();
+
+	/* gic_init() demands the number of vCPUs in the VM */
+	sync_global_to_guest(vm, nr_vcpus);
+}
+
+static void destroy_vm(void)
+{
+	vgic_its_destroy(its);
+	close(gic_fd);
+	kvm_vm_free(vm);
+	free(vcpus);
+}
+
+static void pr_usage(const char *name)
+{
+	pr_info("%s [-v NR_VCPUS] [-d NR_DEVICES] [-e NR_EVENTS] [-i ITERS] -h\n", name);
+	pr_info("  -v:\tnumber of vCPUs (default: %u)\n", nr_vcpus);
+	pr_info("  -d:\tnumber of devices (default: %u)\n", nr_devices);
+	pr_info("  -e:\tnumber of event IDs per device (default: %u)\n", nr_event_ids);
+	pr_info("  -i:\tnumber of iterations (default: %lu)\n", nr_iterations);
+}
+
+int main(int argc, char **argv)
+{
+	u32 nr_threads;
+	int c;
+
+	while ((c = getopt(argc, argv, "hv:d:e:i:")) != -1) {
+		switch (c) {
+		case 'v':
+			nr_vcpus = atoi(optarg);
+			break;
+		case 'd':
+			nr_devices = atoi(optarg);
+			break;
+		case 'e':
+			nr_event_ids = atoi(optarg);
+			break;
+		case 'i':
+			nr_iterations = strtoul(optarg, NULL, 0);
+			break;
+		case 'h':
+		default:
+			pr_usage(argv[0]);
+			return 1;
+		}
+	}
+
+	nr_threads = nr_vcpus + nr_devices;
+	if (nr_threads > get_nprocs())
+		pr_info("WARNING: running %u threads on %d CPUs; performance is degraded.\n",
+			 nr_threads, get_nprocs());
+
+	setup_vm();
+
+	run_test();
+
+	destroy_vm();
+
+	return 0;
+}
-- 
2.43.0.687.g38aa6559b0-goog


