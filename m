Return-Path: <kvm+bounces-24643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B1E85958810
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 15:37:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3EC801F231E8
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 13:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC901190462;
	Tue, 20 Aug 2024 13:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="llQMeLkg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5987F1AACB
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 13:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724161015; cv=none; b=NJtFvkHwPPVIFNib2zsiXp6zVrv+iDV6Snp2H4tPNp8aFn0IwCL6X5TrFNWOa4kKzPvm12aa9WZXzIWvMfgQBjcjh19qFZoQl3R2merOxVAh0NLNZz25myk0qe3aJBtAgH6/Fy/3peixUXhfh6e7F2cDMPABd980cCXZ7ayA9rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724161015; c=relaxed/simple;
	bh=aduH0T7hxiSgWmx3n2ahktMEv5AKZbd25/yp2f4Dhsc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N+daXXNghpQwucoHRLwDky+8L61iXl7oN0p8VnSiXF0CVF3Hc7aNCeobx8EbxnKLY5LOTELUjkZaMLFIxYYei9QiKXoBPglqsBpFQnVEcbupFA/JIpoqgZuvAdN2jBSgJmq66ry2FoX+GlBqyeynFGGoFZgdjk+aNLmN6I3HvOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=llQMeLkg; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1724161013; x=1755697013;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K7k7RBTkcSQ4M5fikVS8zZMpnCTT/zMp/vaIahRivvo=;
  b=llQMeLkgJWo5kAwrwInkiygvriPykrTEwIQOPwCg1hT1jTkjEeXqjTAW
   XrcyHFPW3a2y3FI/KPnShRLxv3+YuQyHZ/3fl79LjJlGiO1c7iteqpVFB
   X+mnm8SeYtmuC+b6poyS0mcVnPDIGpJAcFTO1CBu4H9XuAVfsNpaQ4RXh
   Y=;
X-IronPort-AV: E=Sophos;i="6.10,162,1719878400"; 
   d="scan'208";a="322578885"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 13:36:51 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.10.100:40971]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.20.122:2525] with esmtp (Farcaster)
 id 68f18467-5b98-4d88-a815-4ed8256b8c9d; Tue, 20 Aug 2024 13:36:49 +0000 (UTC)
X-Farcaster-Flow-ID: 68f18467-5b98-4d88-a815-4ed8256b8c9d
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 20 Aug 2024 13:36:48 +0000
Received: from u94b036d6357a55.ant.amazon.com (10.106.82.48) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 20 Aug 2024 13:36:45 +0000
From: Ilias Stamatis <ilstam@amazon.com>
To: <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC: <pdurrant@amazon.co.uk>, <dwmw@amazon.co.uk>, <seanjc@google.com>,
	<nh-open-source@amazon.com>, Ilias Stamatis <ilstam@amazon.com>
Subject: [PATCH v3 6/6] KVM: selftests: Add coalesced_mmio_test
Date: Tue, 20 Aug 2024 14:33:33 +0100
Message-ID: <20240820133333.1724191-7-ilstam@amazon.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240820133333.1724191-1-ilstam@amazon.com>
References: <20240820133333.1724191-1-ilstam@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D032UWA003.ant.amazon.com (10.13.139.37) To
 EX19D018EUA002.ant.amazon.com (10.252.50.146)

Test the KVM_CREATE_COALESCED_MMIO_BUFFER, KVM_REGISTER_COALESCED_MMIO2
and KVM_UNREGISTER_COALESCED_MMIO2 ioctls.

Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/coalesced_mmio_test.c       | 313 ++++++++++++++++++
 2 files changed, 314 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/coalesced_mmio_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 48d32c5aa3eb..527297bfb9c5 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -147,6 +147,7 @@ TEST_GEN_PROGS_x86_64 += steal_time
 TEST_GEN_PROGS_x86_64 += kvm_binary_stats_test
 TEST_GEN_PROGS_x86_64 += system_counter_offset_test
 TEST_GEN_PROGS_x86_64 += pre_fault_memory_test
+TEST_GEN_PROGS_x86_64 += coalesced_mmio_test
 
 # Compiled outputs used by test targets
 TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
diff --git a/tools/testing/selftests/kvm/coalesced_mmio_test.c b/tools/testing/selftests/kvm/coalesced_mmio_test.c
new file mode 100644
index 000000000000..7a000596279f
--- /dev/null
+++ b/tools/testing/selftests/kvm/coalesced_mmio_test.c
@@ -0,0 +1,313 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright 2024 Amazon.com, Inc. or its affiliates. All Rights Reserved.
+ *
+ * Test the KVM_CREATE_COALESCED_MMIO_BUFFER, KVM_REGISTER_COALESCED_MMIO2 and
+ * KVM_UNREGISTER_COALESCED_MMIO2 ioctls by making sure that MMIO writes to
+ * associated zones end up in the correct ring buffer. Also test that we don't
+ * exit to userspace when there is space in the corresponding buffer.
+ */
+
+#include <kvm_util.h>
+#include <ucall_common.h>
+
+#define PAGE_SIZE 4096
+
+/*
+ * Somewhat arbitrary location and slot, intended to not overlap anything.
+ */
+#define MEM_REGION_SLOT         10
+#define MEM_REGION_GPA          0xc0000000UL
+#define MEM_REGION_SIZE         (PAGE_SIZE * 2)
+#define MEM_REGION_PAGES        DIV_ROUND_UP(MEM_REGION_SIZE, PAGE_SIZE)
+
+#define COALESCING_ZONE1_GPA    MEM_REGION_GPA
+#define COALESCING_ZONE1_SIZE   PAGE_SIZE
+#define COALESCING_ZONE2_GPA    (COALESCING_ZONE1_GPA + COALESCING_ZONE1_SIZE)
+#define COALESCING_ZONE2_SIZE   PAGE_SIZE
+
+#define MMIO_WRITE_DATA         0xdeadbeef
+#define MMIO_WRITE_DATA2        0xbadc0de
+
+#define BATCH_SIZE              4
+
+static void guest_code(void)
+{
+	uint64_t *gpa;
+
+	/*
+	 * The first write should result in an exit
+	 */
+	gpa = (uint64_t *)(MEM_REGION_GPA);
+	WRITE_ONCE(*gpa, MMIO_WRITE_DATA);
+
+	/*
+	 * These writes should be stored in a coalescing ring buffer and only
+	 * the last one should result in an exit.
+	 */
+	for (int i = 0; i < KVM_COALESCED_MMIO_MAX; i++) {
+		gpa = (uint64_t *)(COALESCING_ZONE1_GPA + i * sizeof(*gpa));
+		WRITE_ONCE(*gpa, MMIO_WRITE_DATA + i);
+
+		/* Let's throw a PIO into the mix */
+		if (i == KVM_COALESCED_MMIO_MAX / 2)
+			GUEST_SYNC(0);
+	}
+
+	/*
+	 * These writes should be stored in two separate ring buffers and they
+	 * shouldn't result in an exit.
+	 */
+	for (int i = 0; i < BATCH_SIZE; i++) {
+		gpa = (uint64_t *)(COALESCING_ZONE1_GPA + i * sizeof(*gpa));
+		WRITE_ONCE(*gpa, MMIO_WRITE_DATA + i);
+
+		gpa = (uint64_t *)(COALESCING_ZONE2_GPA + i * sizeof(*gpa));
+		WRITE_ONCE(*gpa, MMIO_WRITE_DATA2 + i);
+	}
+
+	GUEST_SYNC(0);
+
+	/*
+	 * These writes should be stored in the same ring buffer and they
+	 * shouldn't result in an exit.
+	 */
+	for (int i = 0; i < BATCH_SIZE; i++) {
+		if (i < BATCH_SIZE / 2)
+			gpa = (uint64_t *)(COALESCING_ZONE1_GPA + i * sizeof(*gpa));
+		else
+			gpa = (uint64_t *)(COALESCING_ZONE2_GPA + i * sizeof(*gpa));
+
+		WRITE_ONCE(*gpa, MMIO_WRITE_DATA2 + i);
+	}
+
+	GUEST_SYNC(0);
+
+	/*
+	 * This last write should result in an exit because the host should
+	 * have disabled I/O coalescing by now.
+	 */
+	gpa = (uint64_t *)(COALESCING_ZONE1_GPA);
+	WRITE_ONCE(*gpa, MMIO_WRITE_DATA);
+}
+
+static void assert_mmio_write(struct kvm_vcpu *vcpu, uint64_t addr, uint64_t value)
+{
+	uint64_t data;
+
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_MMIO);
+	TEST_ASSERT(vcpu->run->mmio.is_write, "Got MMIO read, not MMIO write");
+
+	memcpy(&data, vcpu->run->mmio.data, vcpu->run->mmio.len);
+	TEST_ASSERT_EQ(vcpu->run->mmio.phys_addr, addr);
+	TEST_ASSERT_EQ(value, data);
+}
+
+static void assert_ucall_exit(struct kvm_vcpu *vcpu, uint64_t command)
+{
+	uint64_t cmd;
+	struct ucall uc;
+
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+	cmd = get_ucall(vcpu, &uc);
+	TEST_ASSERT_EQ(cmd, command);
+}
+
+static void assert_ring_entries(struct kvm_coalesced_mmio_ring *ring,
+				uint32_t nentries,
+				uint64_t addr,
+				uint64_t value)
+{
+	uint64_t data;
+
+	for (int i = READ_ONCE(ring->first); i < nentries; i++) {
+		TEST_ASSERT_EQ(READ_ONCE(ring->coalesced_mmio[i].len),
+			       sizeof(data));
+		memcpy(&data, ring->coalesced_mmio[i].data,
+		       READ_ONCE(ring->coalesced_mmio[i].len));
+
+		TEST_ASSERT_EQ(READ_ONCE(ring->coalesced_mmio[i].phys_addr),
+			       addr + i * sizeof(data));
+		TEST_ASSERT_EQ(data, value + i);
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	uint64_t gpa;
+	struct kvm_coalesced_mmio_ring *ring, *ring2;
+	struct kvm_coalesced_mmio_zone2 zone, zone2;
+	int ring_fd, ring_fd2;
+	int r;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_COALESCED_MMIO2));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_READONLY_MEM));
+	TEST_ASSERT(BATCH_SIZE * 2 <= KVM_COALESCED_MMIO_MAX,
+		"KVM_COALESCED_MMIO_MAX too small");
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, MEM_REGION_GPA,
+				    MEM_REGION_SLOT, MEM_REGION_PAGES,
+				    KVM_MEM_READONLY);
+
+	gpa = vm_phy_pages_alloc(vm, MEM_REGION_PAGES, MEM_REGION_GPA,
+				 MEM_REGION_SLOT);
+	TEST_ASSERT(gpa == MEM_REGION_GPA, "Failed vm_phy_pages_alloc");
+
+	virt_map(vm, MEM_REGION_GPA, MEM_REGION_GPA, MEM_REGION_PAGES);
+
+	/*
+	 * Test that allocating an fd and memory mapping it works
+	 */
+	ring_fd = __vm_ioctl(vm, KVM_CREATE_COALESCED_MMIO_BUFFER, NULL);
+	TEST_ASSERT(ring_fd != -1, "Failed KVM_CREATE_COALESCED_MMIO_BUFFER");
+
+	ring = mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED,
+		    ring_fd, 0);
+	TEST_ASSERT(ring != MAP_FAILED, "Failed to allocate ring buffer");
+
+	/*
+	 * Test that trying to map the same fd again fails
+	 */
+	ring2 = mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED,
+		     ring_fd, 0);
+	TEST_ASSERT(ring2 == MAP_FAILED && errno == EBUSY,
+		    "Mapping the same fd again should fail with EBUSY");
+
+	/*
+	 * Test that the first and last ring indices are zero
+	 */
+	TEST_ASSERT_EQ(READ_ONCE(ring->first), 0);
+	TEST_ASSERT_EQ(READ_ONCE(ring->last), 0);
+
+	/*
+	 * Run the vCPU and make sure the first MMIO write results in a
+	 * userspace exit since we have not setup MMIO coalescing yet.
+	 */
+	vcpu_run(vcpu);
+	assert_mmio_write(vcpu, MEM_REGION_GPA, MMIO_WRITE_DATA);
+
+	/*
+	 * Let's actually setup MMIO coalescing now...
+	 */
+	zone.addr = COALESCING_ZONE1_GPA;
+	zone.size = COALESCING_ZONE1_SIZE;
+	zone.buffer_fd = ring_fd;
+	r = __vm_ioctl(vm, KVM_REGISTER_COALESCED_MMIO2, &zone);
+	TEST_ASSERT(r != -1, "Failed KVM_REGISTER_COALESCED_MMIO2");
+
+	/*
+	 * The guest will start doing MMIO writes in the coalesced regions but
+	 * will also do a ucall when the buffer is half full. The first
+	 * userspace exit should be due to the ucall and not an MMIO exit.
+	 */
+	vcpu_run(vcpu);
+	assert_ucall_exit(vcpu, UCALL_SYNC);
+	TEST_ASSERT_EQ(READ_ONCE(ring->first), 0);
+	TEST_ASSERT_EQ(READ_ONCE(ring->last), KVM_COALESCED_MMIO_MAX / 2 + 1);
+
+	/*
+	 * Run the guest again. Next exit should be when the buffer is full.
+	 * One entry always remains unused.
+	 */
+	vcpu_run(vcpu);
+	assert_mmio_write(vcpu,
+	    COALESCING_ZONE1_GPA + (KVM_COALESCED_MMIO_MAX - 1) * sizeof(uint64_t),
+	    MMIO_WRITE_DATA + KVM_COALESCED_MMIO_MAX - 1);
+	TEST_ASSERT_EQ(READ_ONCE(ring->first), 0);
+	TEST_ASSERT_EQ(READ_ONCE(ring->last), KVM_COALESCED_MMIO_MAX - 1);
+
+	assert_ring_entries(ring, KVM_COALESCED_MMIO_MAX - 1,
+			    COALESCING_ZONE1_GPA, MMIO_WRITE_DATA);
+
+	/*
+	 * Let's setup another region with a separate buffer
+	 */
+	ring_fd2 = __vm_ioctl(vm, KVM_CREATE_COALESCED_MMIO_BUFFER, NULL);
+	TEST_ASSERT(ring_fd != -1, "Failed KVM_CREATE_COALESCED_MMIO_BUFFER");
+
+	ring2 = mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED,
+		     ring_fd2, 0);
+	TEST_ASSERT(ring2 != MAP_FAILED, "Failed to allocate ring buffer");
+
+	zone2.addr = COALESCING_ZONE2_GPA;
+	zone2.size = COALESCING_ZONE2_SIZE;
+	zone2.buffer_fd = ring_fd2;
+	r = __vm_ioctl(vm, KVM_REGISTER_COALESCED_MMIO2, &zone2);
+	TEST_ASSERT(r != -1, "Failed KVM_REGISTER_COALESCED_MMIO2");
+
+	/*
+	 * Move the consumer pointer of the first ring forward.
+	 *
+	 * When re-entering the vCPU the guest will write BATCH_SIZE
+	 * times to each MMIO zone.
+	 */
+	WRITE_ONCE(ring->first,
+		(READ_ONCE(ring->first) + BATCH_SIZE) % KVM_COALESCED_MMIO_MAX);
+
+	vcpu_run(vcpu);
+	assert_ucall_exit(vcpu, UCALL_SYNC);
+
+	TEST_ASSERT_EQ(READ_ONCE(ring->first), BATCH_SIZE);
+	TEST_ASSERT_EQ(READ_ONCE(ring->last),
+	  (KVM_COALESCED_MMIO_MAX - 1 + BATCH_SIZE) % KVM_COALESCED_MMIO_MAX);
+	TEST_ASSERT_EQ(READ_ONCE(ring2->first), 0);
+	TEST_ASSERT_EQ(READ_ONCE(ring2->last), BATCH_SIZE);
+
+	assert_ring_entries(ring, BATCH_SIZE, COALESCING_ZONE1_GPA, MMIO_WRITE_DATA);
+	assert_ring_entries(ring2, BATCH_SIZE, COALESCING_ZONE2_GPA, MMIO_WRITE_DATA2);
+
+	/*
+	 * Unregister zone 2 and register it again but this time use the same
+	 * ring buffer used for zone 1.
+	 */
+	r = __vm_ioctl(vm, KVM_UNREGISTER_COALESCED_MMIO2, &zone2);
+	TEST_ASSERT(r != -1, "Failed KVM_UNREGISTER_COALESCED_MMIO2");
+
+	zone2.buffer_fd = ring_fd;
+	r = __vm_ioctl(vm, KVM_REGISTER_COALESCED_MMIO2, &zone2);
+	TEST_ASSERT(r != -1, "Failed KVM_REGISTER_COALESCED_MMIO2");
+
+	/*
+	 * Enter the vCPU again. This time writes to both regions should go
+	 * to the same ring buffer.
+	 */
+	WRITE_ONCE(ring->first,
+		(READ_ONCE(ring->first) + BATCH_SIZE) % KVM_COALESCED_MMIO_MAX);
+
+	vcpu_run(vcpu);
+	assert_ucall_exit(vcpu, UCALL_SYNC);
+
+	TEST_ASSERT_EQ(READ_ONCE(ring->first), BATCH_SIZE * 2);
+	TEST_ASSERT_EQ(READ_ONCE(ring->last),
+	  (KVM_COALESCED_MMIO_MAX - 1 + BATCH_SIZE * 2) % KVM_COALESCED_MMIO_MAX);
+
+	WRITE_ONCE(ring->first,
+		(READ_ONCE(ring->first) + BATCH_SIZE) % KVM_COALESCED_MMIO_MAX);
+
+	/*
+	 * Test that munmap and close work.
+	 */
+	r = munmap(ring, PAGE_SIZE);
+	TEST_ASSERT(r == 0, "Failed to munmap()");
+	r = close(ring_fd);
+	TEST_ASSERT(r == 0, "Failed to close()");
+
+	r = munmap(ring2, PAGE_SIZE);
+	TEST_ASSERT(r == 0, "Failed to munmap()");
+	r = close(ring_fd2);
+	TEST_ASSERT(r == 0, "Failed to close()");
+
+	/*
+	 * close() should have also deregistered all I/O regions associated
+	 * with the ring buffer automatically. Make sure that when the guest
+	 * writes to the region again this results in an immediate exit.
+	 */
+	vcpu_run(vcpu);
+	assert_mmio_write(vcpu, COALESCING_ZONE1_GPA, MMIO_WRITE_DATA);
+
+	return 0;
+}
-- 
2.34.1


