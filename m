Return-Path: <kvm+bounces-31185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 003559C112F
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 22:42:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 853461F24581
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 21:42:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01A5A2185B3;
	Thu,  7 Nov 2024 21:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qdyj52ii"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029FC2185A9
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 21:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731015705; cv=none; b=pSvF6HcH+HGPk+KVuVdfoxa4o95tdFbTeAxbSxMRsNBqrg9g8f4T+Ck1VpVMp4xceO0znlZ2EQ71XcH4FyO6sCOvK9FvqgRso5UPdQXmfkY5UlfZ238kAnKBWlplX02kl/85lIpwagQpPRdIgnaP4fwZ9YojmGkd7H1YDLR7cy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731015705; c=relaxed/simple;
	bh=saUEO8MRii+tu7LbkPBIMOl0Qo4TWPLGtamBE7oIXzs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hK+gSaB4g5PVDTIYlctAOWLzbzfyQLWokTra5XbpDImC9aPLcoYPHUNTheu1WO4TialroO66ir6ZDk3U+EcJGN+PEcNXkBj8LatReRihvMbBUz30sYa8YKlmbN3zeAXF1TGK1zNnEUTGIjwzIUoKqS5QJRPYtESyNihROQYmGac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qdyj52ii; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6ea8a5e86e9so26946427b3.2
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 13:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731015702; x=1731620502; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yAj8jUTaVQ6+wUnJQwBAG5LIu7qCm6LxX4OGg/NB8hs=;
        b=Qdyj52iifiliLjrrihNc9LmdCZg3CnvQW+KyJ9R7EmMHmvr62AiBkY6gOOd+PRzR/U
         hs0u8zyX86PJqybB/TK+eG2mlkmIvvkOmdRc+reCCLrTQh1/zHYyq9mj17tJDGIvUGdu
         zMliFVG/J8j/MQmKvN+KfrE4nQhfUNLv3pLGxajc4H7yhfFsbwzIZTHelXRUE/uBj/bw
         W4yQ1I6sL8Ia2Xopa6XBIRJb99tZUkkhkCHB1ZL7McF+P58xjJhPHzg64RY8xjD47mqT
         uvvAC/Axz/wXKyGr64RNBIXYOfoACBNb9nKKma3xGmMvYxudgiF/qjI/wNAa0oNiHuER
         Z0Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731015702; x=1731620502;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yAj8jUTaVQ6+wUnJQwBAG5LIu7qCm6LxX4OGg/NB8hs=;
        b=PKLhIB/SukDpWomM8LOrxpnLNpRReLFKtqNCntS1l40jrGe8gsiLed36G+p88z2Ezk
         scsqagvz/Dki/Ypuc9qQ9B2AavQxUPe21NKPczY5zu2sRozpr5QEC3czIsOh0aIot1Bh
         Cym5tw/seBG0zBc1WIVRBj5ZCD6wanQZyRuqqSKSl12Q+b6c/wmI8SrVEnFBv/eeZ/Vs
         lO6ErKk0LxRRtnjmRTTpu/VF7M0pDvA87HV4kLZyAxDMm9wljPmLNEHnpPFPU0jcwLVH
         vZL3ZgGaYhYTztvAAKWhc9zeIWK+5n3lNFY23tHCE8lFYLOObWQCh4zL3ut/KGIBG8bS
         1WFQ==
X-Gm-Message-State: AOJu0YwKVQHKQqQWnf72Z9JzlGYQcBHDk+nF4R6wklsI1xJp/KdawygH
	M4flnU9MW7btpVWyWE/Ym8ypI2oU61qHyw2gyyYT3bnv76Ag7B1U0PSc4IbyR/R5QrN9VTlL5Il
	T7+9u+eqfEBu9fApZQ57Kby7A+hf42KbCsuIkZaKMELuTOw/IJsL2aJ+sK4sq2TGny2VP2ufbV8
	tLa9OI/9+6i+FyIoB5MMfJxA6GjBQ6lYxcE+R1ynEk7R4ADB3IZVHLQ04=
X-Google-Smtp-Source: AGHT+IFZ4/MRyA8vJVU6aKyTyPGaMH/v+gvLevN5T+rrezHzwOlZK22xayTCUH75IQYWuEO3OcpOSwGNEZ5RoDfidg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:36:e7b8:ac13:c96f])
 (user=jingzhangos job=sendgmr) by 2002:a05:690c:6f12:b0:6e3:f32:5fc8 with
 SMTP id 00721157ae682-6eaddd6a3e4mr55087b3.1.1731015701682; Thu, 07 Nov 2024
 13:41:41 -0800 (PST)
Date: Thu,  7 Nov 2024 13:41:33 -0800
In-Reply-To: <20241107214137.428439-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241107214137.428439-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241107214137.428439-2-jingzhangos@google.com>
Subject: [PATCH v4 1/5] KVM: selftests: aarch64: Add VGIC selftest for
 save/restore ITS table mappings
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Kunkun Jiang <jiangkunkun@huawei.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andre Przywara <andre.przywara@arm.com>, 
	Colton Lewis <coltonlewis@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Shusen Li <lishusen2@huawei.com>, Eric Auger <eauger@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch adds a selftest to verify the integrity of GIC ITS
table mappings after save/restore operations, triggered via the
KVM_DEV_ARM_ITS_[SAVE|RESTORE]_TABLES ioctls.

The current save/restore mechanism can exhibit inconsistencies
due to concurrent device interrupt registration and freeing during
repeated suspend attempts. This can lead to orphaned Device
Translation Entries (DTEs) and Interrupt Translation Entries (ITEs),
causing EINVAL errors or mapping corruption during restore.

EINVAL Error: If an orphaned entry lacks a corresponding collection
ID, the restore operation fails with an EINVAL error.
Mapping Corruption: If an orphaned entry possesses a valid collection
ID, the restore operation may succeed but with incorrect or lost
mappings, compromising system integrity.

This selftest reproduces these error scenarios:

*  EINVAL: `./vgic_its_tables`
*  Mapping corruption: `./vgic_its_tables -s`
The -s option enforces identical collection IDs for all mappings.

The `-c` option demonstrates a potential fix by clearing the tables
before saving.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/vgic_its_tables.c   | 565 ++++++++++++++++++
 .../kvm/include/aarch64/gic_v3_its.h          |   3 +-
 .../testing/selftests/kvm/include/kvm_util.h  |   4 +-
 .../selftests/kvm/lib/aarch64/gic_v3_its.c    |  24 +-
 5 files changed, 591 insertions(+), 6 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_its_tables.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 156fbfae940f..9cba573c23f3 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -163,6 +163,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/smccc_filter
 TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
+TEST_GEN_PROGS_aarch64 += aarch64/vgic_its_tables
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_lpi_stress
 TEST_GEN_PROGS_aarch64 += aarch64/vpmu_counter_access
 TEST_GEN_PROGS_aarch64 += aarch64/no-vgic-v3
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_its_tables.c b/tools/testing/selftests/kvm/aarch64/vgic_its_tables.c
new file mode 100644
index 000000000000..fd4e7cbf7bc0
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/vgic_its_tables.c
@@ -0,0 +1,565 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * vgic_its_tables - VGIC selftest for save/restore ITS table mappings
+ *
+ * Copyright (c) 2024 Google LLC
+ */
+
+#include <linux/sizes.h>
+#include <pthread.h>
+#include <stdatomic.h>
+#include <sys/sysinfo.h>
+
+#include "kvm_util.h"
+#include "gic.h"
+#include "gic_v3.h"
+#include "gic_v3_its.h"
+#include "processor.h"
+#include "ucall.h"
+#include "vgic.h"
+#include "kselftest.h"
+
+
+#define GIC_LPI_OFFSET		8192
+#define TEST_MEMSLOT_INDEX	1
+#define TABLE_SIZE		SZ_64K
+#define DEFAULT_NR_L2		4ULL
+#define DTE_SIZE		8ULL
+#define ITE_SIZE		8ULL
+#define NR_EVENTS		(TABLE_SIZE / ITE_SIZE)
+/* We only have 64K PEND/PROP tables */
+#define MAX_NR_L2		((TABLE_SIZE - GIC_LPI_OFFSET) * DTE_SIZE / TABLE_SIZE)
+
+static vm_paddr_t gpa_base;
+
+static struct kvm_vm *vm;
+static struct kvm_vcpu *vcpu;
+static int gic_fd, its_fd;
+static u32 collection_id = 0;
+
+struct event_id_block {
+	u32 start;
+	u32 size;
+};
+
+static struct mappings_tracker {
+	struct event_id_block *devices;
+	struct event_id_block *devices_va;
+} mtracker;
+
+static struct test_data {
+	vm_paddr_t	l1_device_table;
+	vm_paddr_t	l2_device_tables;
+	vm_paddr_t	collection_table;
+	vm_paddr_t	cmdq_base;
+	void		*cmdq_base_va;
+	vm_paddr_t	itt_tables;
+
+	vm_paddr_t	lpi_prop_table;
+	vm_paddr_t	lpi_pend_tables;
+
+	int		control_cmd;
+	bool		clear_before_save;
+	bool		same_coll_id;
+	size_t		nr_l2_tables;
+	size_t		nr_devices;
+} td = {
+	.clear_before_save = false,
+	.same_coll_id = false,
+	.nr_l2_tables = DEFAULT_NR_L2,
+	.nr_devices = DEFAULT_NR_L2 * TABLE_SIZE / DTE_SIZE,
+};
+
+static void guest_its_mappings_clear(void)
+{
+	memset((void *)td.l2_device_tables, 0, TABLE_SIZE * td.nr_l2_tables);
+	memset((void *)td.collection_table, 0, TABLE_SIZE);
+	memset((void *)td.itt_tables, 0, td.nr_devices * TABLE_SIZE);
+}
+
+static void guest_its_unmap_all(bool update_tracker)
+{
+	u32 device_id, event_id;
+
+	for (device_id = 0; device_id < td.nr_devices; device_id++) {
+		vm_paddr_t itt_base = td.itt_tables + (device_id * TABLE_SIZE);
+		u32 start_id = mtracker.devices[device_id].start;
+		u32 end_id = start_id + mtracker.devices[device_id].size;
+
+		for (event_id = start_id; event_id < end_id ; event_id++)
+			its_send_discard_cmd(td.cmdq_base_va,
+					     device_id, event_id);
+
+		if (end_id - start_id > 0)
+			its_send_mapd_cmd(td.cmdq_base_va, device_id,
+					  itt_base, TABLE_SIZE, false);
+
+		if (update_tracker) {
+			mtracker.devices[device_id].start = 0;
+			mtracker.devices[device_id].size = 0;
+		}
+
+	}
+
+	for (u32 i= 0; i <= collection_id; i++)
+		its_send_mapc_cmd(td.cmdq_base_va, 0, i, false);
+}
+
+static void guest_its_map_single_event(u32 device_id, u32 event_id, u32 coll_id)
+{
+	u32 intid = GIC_LPI_OFFSET;
+
+	guest_its_unmap_all(true);
+
+	its_send_mapc_cmd(td.cmdq_base_va, guest_get_vcpuid(), coll_id, true);
+	its_send_mapd_cmd(td.cmdq_base_va, device_id,
+			  td.itt_tables + (device_id * TABLE_SIZE), TABLE_SIZE, true);
+	its_send_mapti_cmd(td.cmdq_base_va, device_id,
+			   event_id, coll_id, intid);
+
+
+	mtracker.devices[device_id].start = event_id;
+	mtracker.devices[device_id].size = 1;
+}
+
+static void guest_its_map_event_per_device(u32 event_id, u32 coll_id)
+{
+	u32 device_id, intid = GIC_LPI_OFFSET;
+
+	guest_its_unmap_all(true);
+
+	its_send_mapc_cmd(td.cmdq_base_va, guest_get_vcpuid(), coll_id, true);
+
+	for (device_id = 0; device_id < td.nr_devices; device_id++) {
+		vm_paddr_t itt_base = td.itt_tables + (device_id * TABLE_SIZE);
+
+		its_send_mapd_cmd(td.cmdq_base_va, device_id,
+				  itt_base, TABLE_SIZE, true);
+
+		its_send_mapti_cmd(td.cmdq_base_va, device_id,
+				   event_id, coll_id, intid++);
+
+		mtracker.devices[device_id].start = event_id;
+		mtracker.devices[device_id].size = 1;
+
+	}
+}
+
+static void guest_setup_gic(void)
+{
+	u32 cpuid = guest_get_vcpuid();
+
+	gic_init(GIC_V3, 1);
+	gic_rdist_enable_lpis(td.lpi_prop_table, TABLE_SIZE,
+			      td.lpi_pend_tables + (cpuid * TABLE_SIZE));
+
+	guest_its_mappings_clear();
+
+	its_init(td.collection_table, TABLE_SIZE,
+		 td.l1_device_table, TABLE_SIZE,
+		 td.cmdq_base, TABLE_SIZE, true);
+}
+
+enum {
+	GUEST_EXIT,
+	MAP_INIT,
+	MAP_INIT_DONE,
+	MAP_DONE,
+	PREPARE_FOR_SAVE,
+	PREPARE_DONE,
+	MAP_EMPTY,
+	MAP_SINGLE_EVENT_FIRST,
+	MAP_SINGLE_EVENT_LAST,
+	MAP_FIRST_EVENT_PER_DEVICE,
+	MAP_LAST_EVENT_PER_DEVICE,
+};
+
+static void guest_code(size_t nr_lpis)
+{
+	int cmd;
+
+	guest_setup_gic();
+	GUEST_SYNC1(MAP_INIT_DONE);
+
+	while ((cmd = READ_ONCE(td.control_cmd)) != GUEST_EXIT) {
+		switch (cmd) {
+		case MAP_INIT:
+			guest_its_unmap_all(true);
+			if (td.clear_before_save)
+				guest_its_mappings_clear();
+			GUEST_SYNC1(MAP_INIT_DONE);
+			break;
+		case PREPARE_FOR_SAVE:
+			its_init(td.collection_table, TABLE_SIZE,
+				 td.l1_device_table, TABLE_SIZE,
+				 td.cmdq_base, TABLE_SIZE, true);
+			GUEST_SYNC1(PREPARE_DONE);
+			break;
+		case MAP_EMPTY:
+			guest_its_mappings_clear();
+			GUEST_SYNC1(MAP_DONE);
+			break;
+		case MAP_SINGLE_EVENT_FIRST:
+			guest_its_map_single_event(1, 1, collection_id);
+			if (!td.same_coll_id)
+				collection_id++;
+			GUEST_SYNC1(MAP_DONE);
+			break;
+		case MAP_SINGLE_EVENT_LAST:
+			guest_its_map_single_event(td.nr_devices - 2, NR_EVENTS - 2,
+						   collection_id);
+			if (!td.same_coll_id)
+				collection_id++;
+			GUEST_SYNC1(MAP_DONE);
+			break;
+		case MAP_FIRST_EVENT_PER_DEVICE:
+			guest_its_map_event_per_device(2, collection_id);
+			if (!td.same_coll_id)
+				collection_id++;
+			GUEST_SYNC1(MAP_DONE);
+			break;
+		case MAP_LAST_EVENT_PER_DEVICE:
+			guest_its_map_event_per_device(NR_EVENTS - 3,
+						       collection_id);
+			if (!td.same_coll_id)
+				collection_id++;
+			GUEST_SYNC1(MAP_DONE);
+			break;
+		default:
+			break;
+		}
+	}
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
+	 *  - A single l1 level device table
+	 *  - td.nr_l2_tables l2 level device tables
+	 *  - A single level collection table
+	 *  - The command queue
+	 *  - An ITT for each device
+	 */
+	sz = (3 + td.nr_l2_tables + td.nr_devices) * TABLE_SIZE;
+
+	/*
+	 * For the redistributors:
+	 *  - A shared LPI configuration table
+	 *  - An LPI pending table for the vCPU
+	 */
+	sz += 2 * TABLE_SIZE;
+
+	/*
+	 * For the mappings tracker
+	 */
+	sz += sizeof(*mtracker.devices) * td.nr_devices;
+
+	pages = sz / vm->page_size;
+	gpa_base = ((vm_compute_max_gfn(vm) + 1) * vm->page_size) - sz;
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa_base,
+				    TEST_MEMSLOT_INDEX, pages, 0);
+}
+
+#define KVM_ITS_L1E_VALID_MASK		BIT_ULL(63)
+#define KVM_ITS_L1E_ADDR_MASK		GENMASK_ULL(51, 16)
+
+static void setup_test_data(void)
+{
+	size_t pages_per_table = vm_calc_num_guest_pages(vm->mode, TABLE_SIZE);
+	size_t pages_mt = sizeof(*mtracker.devices) * td.nr_devices / vm->page_size;
+
+	mtracker.devices = (void *)vm_phy_pages_alloc(vm, pages_mt, gpa_base,
+						      TEST_MEMSLOT_INDEX);
+	virt_map(vm, (vm_paddr_t)mtracker.devices,
+		 (vm_paddr_t)mtracker.devices, pages_mt);
+	mtracker.devices_va = (void *)addr_gpa2hva(vm, (vm_paddr_t)mtracker.devices);
+
+	td.l2_device_tables = vm_phy_pages_alloc(vm,
+						 pages_per_table * td.nr_l2_tables,
+						 gpa_base, TEST_MEMSLOT_INDEX);
+	td.l1_device_table = vm_phy_pages_alloc(vm, pages_per_table,
+						gpa_base,
+						TEST_MEMSLOT_INDEX);
+	td.collection_table = vm_phy_pages_alloc(vm, pages_per_table,
+						gpa_base,
+						TEST_MEMSLOT_INDEX);
+	td.itt_tables = vm_phy_pages_alloc(vm, pages_per_table * td.nr_devices,
+					   gpa_base, TEST_MEMSLOT_INDEX);
+	td.lpi_prop_table = vm_phy_pages_alloc(vm, pages_per_table,
+					       gpa_base, TEST_MEMSLOT_INDEX);
+	td.lpi_pend_tables = vm_phy_pages_alloc(vm, pages_per_table,
+						gpa_base, TEST_MEMSLOT_INDEX);
+	td.cmdq_base = vm_phy_pages_alloc(vm, pages_per_table, gpa_base,
+					  TEST_MEMSLOT_INDEX);
+
+	u64 *l1_tbl = addr_gpa2hva(vm, td.l1_device_table);
+	for (int i = 0; i < td.nr_l2_tables; i++) {
+		u64 l2_addr = ((u64)td.l2_device_tables + i * TABLE_SIZE);
+		*(l1_tbl + i) = cpu_to_le64(l2_addr | KVM_ITS_L1E_VALID_MASK);
+	}
+
+	virt_map(vm, td.l2_device_tables, td.l2_device_tables,
+		 pages_per_table * td.nr_l2_tables);
+	virt_map(vm, td.l1_device_table,
+		 td.l1_device_table, pages_per_table);
+	virt_map(vm, td.collection_table,
+		 td.collection_table, pages_per_table);
+	virt_map(vm, td.itt_tables,
+		 td.itt_tables, pages_per_table * td.nr_devices);
+	virt_map(vm, td.cmdq_base, td.cmdq_base, pages_per_table);
+	td.cmdq_base_va = (void *)td.cmdq_base;
+
+	sync_global_to_guest(vm, mtracker);
+	sync_global_to_guest(vm, td);
+}
+
+static void setup_gic(void)
+{
+	gic_fd = vgic_v3_setup(vm, 1, 64);
+	__TEST_REQUIRE(gic_fd >= 0, "Failed to create GICv3");
+
+	its_fd = vgic_its_setup(vm);
+}
+
+static bool is_mapped(u32 device_id, u32 event_id)
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
+	return __vm_ioctl(vm, KVM_SIGNAL_MSI, &msi);
+}
+
+static bool restored_mappings_sanity_check(void)
+{
+	u64 lost_count = 0, wrong_count = 0;
+	bool pass = true;
+
+	sync_global_from_guest(vm, mtracker);
+
+	ksft_print_msg("\tChecking restored ITS mappings ...\n");
+	for(u32 dev_id = 0; dev_id < td.nr_devices; dev_id++) {
+		u32 start_id = mtracker.devices_va[dev_id].start;
+		u32 end_id = start_id + mtracker.devices_va[dev_id].size;
+
+		for (u32 eid = 0; eid < NR_EVENTS; eid++) {
+			bool save_mapped = eid >= start_id && eid < end_id;
+			bool restore_mapped = is_mapped(dev_id, eid);
+
+			if(save_mapped && !restore_mapped && ++lost_count < 6) {
+				ksft_print_msg("\t\tMapping lost for device:%u, event:%u\n",
+					dev_id, eid);
+				pass = false;
+			} else if (!save_mapped && restore_mapped && ++wrong_count < 6) {
+				ksft_print_msg("\t\tWrong mapping from device:%u, event:%u\n",
+					dev_id, eid);
+				pass = false;
+			}
+			/*
+			 * For test purpose, we only use the first and last 3 events
+			 * per device.
+			 */
+			if (eid == 2)
+				eid = NR_EVENTS - 4;
+		}
+		if (lost_count > 5 || wrong_count > 5) {
+			ksft_print_msg("\tThere are more lost/wrong mappings found.\n");
+			break;
+		}
+	}
+
+	return pass;
+}
+
+static void run_its_tables_save_restore_test(int test_cmd)
+{
+	struct timespec start, delta;
+	struct ucall uc;
+	bool done = false;
+	double duration;
+	bool pass = true;
+
+	write_guest_global(vm, td.control_cmd, MAP_INIT);
+	while (!done) {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			switch (uc.args[0]) {
+			case MAP_INIT_DONE:
+				write_guest_global(vm, td.control_cmd, test_cmd);
+				break;
+			case MAP_DONE:
+				clock_gettime(CLOCK_MONOTONIC, &start);
+
+				kvm_device_attr_set(its_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+						KVM_DEV_ARM_ITS_SAVE_TABLES, NULL);
+
+				delta = timespec_elapsed(start);
+				duration = (double)delta.tv_sec * USEC_PER_SEC;
+				duration += (double)delta.tv_nsec / NSEC_PER_USEC;
+				ksft_print_msg("\tITS tables save time: %.2f (us)\n", duration);
+
+				/* Prepare for restoring */
+				kvm_device_attr_set(its_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+						KVM_DEV_ARM_ITS_CTRL_RESET, NULL);
+				write_guest_global(vm, td.control_cmd, PREPARE_FOR_SAVE);
+				break;
+			case PREPARE_DONE:
+				done = true;
+				break;
+			}
+			break;
+		case UCALL_DONE:
+			done = true;
+			break;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		default:
+			TEST_FAIL("Unknown ucall: %lu", uc.cmd);
+		}
+	}
+
+
+	clock_gettime(CLOCK_MONOTONIC, &start);
+
+	int ret = __kvm_device_attr_set(its_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+					KVM_DEV_ARM_ITS_RESTORE_TABLES, NULL);
+	if (ret) {
+		ksft_print_msg("\t");
+		ksft_print_msg(KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
+		ksft_print_msg("\n");
+		ksft_print_msg("\tFailed to restore ITS tables.\n");
+		pass = false;
+	}
+
+	delta = timespec_elapsed(start);
+	duration = (double)delta.tv_sec * USEC_PER_SEC;
+	duration += (double)delta.tv_nsec / NSEC_PER_USEC;
+	ksft_print_msg("\tITS tables restore time: %.2f (us)\n", duration);
+
+	if (restored_mappings_sanity_check() && pass)
+		ksft_test_result_pass("*** PASSED ***\n");
+	else
+		ksft_test_result_fail("*** FAILED ***\n");
+
+}
+
+static void setup_vm(void)
+{
+	vm = __vm_create_with_one_vcpu(&vcpu, 1024*1024, guest_code);
+
+	setup_memslot();
+
+	setup_gic();
+
+	setup_test_data();
+}
+
+static void destroy_vm(void)
+{
+	close(its_fd);
+	close(gic_fd);
+	kvm_vm_free(vm);
+}
+
+static void run_test(int test_cmd)
+{
+	pr_info("------------------------------------------------------------------------------\n");
+	switch (test_cmd) {
+	case MAP_EMPTY:
+		pr_info("Test ITS save/restore with empty mapping\n");
+		break;
+	case MAP_SINGLE_EVENT_FIRST:
+		pr_info("Test ITS save/restore with one mapping (device:1, event:1)\n");
+		break;
+	case MAP_SINGLE_EVENT_LAST:
+		pr_info("Test ITS save/restore with one mapping (device:%zu, event:%llu)\n",
+			td.nr_devices - 2, NR_EVENTS - 2);
+		break;
+	case MAP_FIRST_EVENT_PER_DEVICE:
+		pr_info("Test ITS save/restore with one small event per device (device:[0-%zu], event:2)\n",
+			td.nr_devices - 1);
+		break;
+	case MAP_LAST_EVENT_PER_DEVICE:
+		pr_info("Test ITS save/restore with one big event per device (device:[0-%zu], event:%llu)\n",
+			td.nr_devices - 1, NR_EVENTS - 3);
+		break;
+	}
+	pr_info("------------------------------------------------------------------------------\n");
+
+	run_its_tables_save_restore_test(test_cmd);
+
+	ksft_print_msg("\n");
+}
+
+static void pr_usage(const char *name)
+{
+	pr_info("%s -c -s -h\n", name);
+	pr_info("  -c:\tclear ITS tables entries before saving\n");
+	pr_info("  -s:\tuse the same collection ID for all mappings\n");
+	pr_info("  -n:\tnumber of L2 device tables (default: %zu, range: [1 - %llu])\n",
+		td.nr_l2_tables, MAX_NR_L2);
+}
+
+int main(int argc, char **argv)
+{
+	int c;
+
+	while ((c = getopt(argc, argv, "hcsn:")) != -1) {
+		switch (c) {
+		case 'c':
+			td.clear_before_save = true;
+			break;
+		case 's':
+			td.same_coll_id = true;
+			break;
+		case 'n':
+			td.nr_l2_tables = atoi(optarg);
+			if (td.nr_l2_tables > 0 && td.nr_l2_tables <= MAX_NR_L2) {
+				td.nr_devices = td.nr_l2_tables * TABLE_SIZE / DTE_SIZE;
+				break;
+			}
+			pr_info("The specified number of L2 device tables is out of range!\n");
+		case 'h':
+		default:
+			pr_usage(argv[0]);
+			return 1;
+		}
+	}
+
+	ksft_print_header();
+
+	setup_vm();
+
+	ksft_set_plan(5);
+
+	run_test(MAP_EMPTY);
+	run_test(MAP_SINGLE_EVENT_FIRST);
+	run_test(MAP_SINGLE_EVENT_LAST);
+	run_test(MAP_FIRST_EVENT_PER_DEVICE);
+	run_test(MAP_LAST_EVENT_PER_DEVICE);
+
+	destroy_vm();
+
+	ksft_finished();
+
+	return 0;
+}
diff --git a/tools/testing/selftests/kvm/include/aarch64/gic_v3_its.h b/tools/testing/selftests/kvm/include/aarch64/gic_v3_its.h
index 3722ed9c8f96..ecf1eb955471 100644
--- a/tools/testing/selftests/kvm/include/aarch64/gic_v3_its.h
+++ b/tools/testing/selftests/kvm/include/aarch64/gic_v3_its.h
@@ -7,7 +7,7 @@
 
 void its_init(vm_paddr_t coll_tbl, size_t coll_tbl_sz,
 	      vm_paddr_t device_tbl, size_t device_tbl_sz,
-	      vm_paddr_t cmdq, size_t cmdq_size);
+	      vm_paddr_t cmdq, size_t cmdq_size, bool indirect_device_tbl);
 
 void its_send_mapd_cmd(void *cmdq_base, u32 device_id, vm_paddr_t itt_base,
 		       size_t itt_size, bool valid);
@@ -15,5 +15,6 @@ void its_send_mapc_cmd(void *cmdq_base, u32 vcpu_id, u32 collection_id, bool val
 void its_send_mapti_cmd(void *cmdq_base, u32 device_id, u32 event_id,
 			u32 collection_id, u32 intid);
 void its_send_invall_cmd(void *cmdq_base, u32 collection_id);
+void its_send_discard_cmd(void *cmdq_base, u32 device_id, u32 event_id);
 
 #endif // __SELFTESTS_GIC_V3_ITS_H__
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index bc7c242480d6..3abe06ad1f85 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -27,7 +27,9 @@
 #define KVM_DEV_PATH "/dev/kvm"
 #define KVM_MAX_VCPUS 512
 
-#define NSEC_PER_SEC 1000000000L
+#define NSEC_PER_USEC	1000L
+#define USEC_PER_SEC	1000000L
+#define NSEC_PER_SEC	1000000000L
 
 struct userspace_mem_region {
 	struct kvm_userspace_memory_region2 region;
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3_its.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3_its.c
index 09f270545646..cd3c65d762d2 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3_its.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3_its.c
@@ -52,7 +52,8 @@ static unsigned long its_find_baser(unsigned int type)
 	return -1;
 }
 
-static void its_install_table(unsigned int type, vm_paddr_t base, size_t size)
+static void its_install_table(unsigned int type, vm_paddr_t base,
+			      size_t size, bool indirect)
 {
 	unsigned long offset = its_find_baser(type);
 	u64 baser;
@@ -64,6 +65,9 @@ static void its_install_table(unsigned int type, vm_paddr_t base, size_t size)
 		GITS_BASER_RaWaWb |
 		GITS_BASER_VALID;
 
+	if (indirect)
+		baser |= GITS_BASER_INDIRECT;
+
 	its_write_u64(offset, baser);
 }
 
@@ -82,12 +86,13 @@ static void its_install_cmdq(vm_paddr_t base, size_t size)
 
 void its_init(vm_paddr_t coll_tbl, size_t coll_tbl_sz,
 	      vm_paddr_t device_tbl, size_t device_tbl_sz,
-	      vm_paddr_t cmdq, size_t cmdq_size)
+	      vm_paddr_t cmdq, size_t cmdq_size, bool indirect_device_tbl)
 {
 	u32 ctlr;
 
-	its_install_table(GITS_BASER_TYPE_COLLECTION, coll_tbl, coll_tbl_sz);
-	its_install_table(GITS_BASER_TYPE_DEVICE, device_tbl, device_tbl_sz);
+	its_install_table(GITS_BASER_TYPE_COLLECTION, coll_tbl, coll_tbl_sz, false);
+	its_install_table(GITS_BASER_TYPE_DEVICE, device_tbl, device_tbl_sz,
+			  indirect_device_tbl);
 	its_install_cmdq(cmdq, cmdq_size);
 
 	ctlr = its_read_u32(GITS_CTLR);
@@ -237,6 +242,17 @@ void its_send_mapti_cmd(void *cmdq_base, u32 device_id, u32 event_id,
 	its_send_cmd(cmdq_base, &cmd);
 }
 
+void its_send_discard_cmd(void *cmdq_base, u32 device_id, u32 event_id)
+{
+	struct its_cmd_block cmd = {};
+
+	its_encode_cmd(&cmd, GITS_CMD_DISCARD);
+	its_encode_devid(&cmd, device_id);
+	its_encode_event_id(&cmd, event_id);
+
+	its_send_cmd(cmdq_base, &cmd);
+}
+
 void its_send_invall_cmd(void *cmdq_base, u32 collection_id)
 {
 	struct its_cmd_block cmd = {};
-- 
2.47.0.277.g8800431eea-goog


