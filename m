Return-Path: <kvm+bounces-14442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 401728A29C1
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:51:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75BCCB25161
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE86874404;
	Fri, 12 Apr 2024 08:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ury957Qe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F7F6F086
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 08:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911424; cv=none; b=AEnEWsBxe/Cqf5TLg91e0W7+fnWLsQ1BhR5KTNhVm9kdC9dpa7ZKQ9rDFFjAxbG5X+GfQb1E3isFC6SQssj8S9bGwyxK9TtcNu6AI5c5NHwazE7aTKbG+nWhGCqJ9cYaqvwW3C5cYhCRjEzS/5b7MnesyNI0eKvssUeYI75GATs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911424; c=relaxed/simple;
	bh=j7Y4ZpRE0Th2mRGXrMufOMFA5pgpOzLmfPeNzLiOs4E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dIKdKemm9r5xENt7PiDPupp8CIY9htMXEhzu16+32PpoOZ6auKGHJ3YmV4pEBf2NZKanm86uFDQLH9v3pv9X8mCDuVGzXBU0HJtlNIUeB0L2tqnx/iT9WklVUuUP9O4wTMeHFzuHyPWIa6V11DZuNhKgy+aKELxPlOIO9ure8qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ury957Qe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712911421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WhIdLWivIqIvKp3FSm9AKW2RcexApWfnR7lW4YKH3gc=;
	b=Ury957QeITgPo0pFJAp/zjg9EsZk+gT5bfrIZCNKsqUiCuMR0qZ2NJ/dCsHuffZRTNmSzW
	xfvkkc3VGmcPe2AaPqv4Zul4fwcW6x637N8oT94beXC6F/mgIc++GeyGMpSTBstMVV0IPi
	Luh+VBJXCiJh7cDX3/bcWpa/sDH1uUY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-463-nKXeVBXSP6uT3Uv1kyZYYA-1; Fri,
 12 Apr 2024 04:43:37 -0400
X-MC-Unique: nKXeVBXSP6uT3Uv1kyZYYA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34CAE1C05AAC;
	Fri, 12 Apr 2024 08:43:37 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.39.193.165])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 616F2C13FA0;
	Fri, 12 Apr 2024 08:43:34 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>
Subject: [PATCH v1] KVM: s390x: selftests: Add shared zeropage test
Date: Fri, 12 Apr 2024 10:43:29 +0200
Message-ID: <20240412084329.30315-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Let's test that we can have shared zeropages in our process as long as
storage keys are not getting used, that shared zeropages are properly
unshared (replaced by anonymous pages) once storage keys are enabled,
and that no new shared zeropages are populated after storage keys
were enabled.

We require the new pagemap interface to detect the shared zeropage.

On an old kernel (zeropages always disabled):
	# ./s390x/shared_zeropage_test
	TAP version 13
	1..3
	not ok 1 Shared zeropages should be enabled
	ok 2 Shared zeropage should be gone
	ok 3 Shared zeropages should be disabled
	# Totals: pass:2 fail:1 xfail:0 xpass:0 skip:0 error:0

On a fixed kernel:
	# ./s390x/shared_zeropage_test
	TAP version 13
	1..3
	ok 1 Shared zeropages should be enabled
	ok 2 Shared zeropage should be gone
	ok 3 Shared zeropages should be disabled
	# Totals: pass:3 fail:0 xfail:0 xpass:0 skip:0 error:0

Testing of UFFDIO_ZEROPAGE can be added later.

Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---

To get it right this time, test the relevant cases.

v3 of fixes are at:
 https://lore.kernel.org/all/20240411161441.910170-1-david@redhat.com/T/#u

---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/s390x/shared_zeropage_test.c          | 110 ++++++++++++++++++
 2 files changed, 111 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/s390x/shared_zeropage_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 741c7dc16afc..ed4ad591f193 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -180,6 +180,7 @@ TEST_GEN_PROGS_s390x += s390x/sync_regs_test
 TEST_GEN_PROGS_s390x += s390x/tprot
 TEST_GEN_PROGS_s390x += s390x/cmma_test
 TEST_GEN_PROGS_s390x += s390x/debug_test
+TEST_GEN_PROGS_s390x += s390x/shared_zeropage_test
 TEST_GEN_PROGS_s390x += demand_paging_test
 TEST_GEN_PROGS_s390x += dirty_log_test
 TEST_GEN_PROGS_s390x += guest_print_test
diff --git a/tools/testing/selftests/kvm/s390x/shared_zeropage_test.c b/tools/testing/selftests/kvm/s390x/shared_zeropage_test.c
new file mode 100644
index 000000000000..74e829748fb1
--- /dev/null
+++ b/tools/testing/selftests/kvm/s390x/shared_zeropage_test.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Test shared zeropage handling (with/without storage keys)
+ *
+ * Copyright (C) 2024, Red Hat, Inc.
+ */
+#include <sys/mman.h>
+
+#include <linux/fs.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "kselftest.h"
+
+static void set_storage_key(void *addr, uint8_t skey)
+{
+	asm volatile("sske %0,%1" : : "d" (skey), "a" (addr));
+}
+
+static void guest_code(void)
+{
+	/* Issue some storage key instruction. */
+	set_storage_key((void *)0, 0x98);
+	GUEST_DONE();
+}
+
+/*
+ * Returns 1 if the shared zeropage is mapped, 0 if something else is mapped.
+ * Returns < 0 on error or if nothing is mapped.
+ */
+static int maps_shared_zeropage(int pagemap_fd, void *addr)
+{
+	struct page_region region;
+	struct pm_scan_arg arg = {
+		.start = (uintptr_t)addr,
+		.end = (uintptr_t)addr + 4096,
+		.vec = (uintptr_t)&region,
+		.vec_len = 1,
+		.size = sizeof(struct pm_scan_arg),
+		.category_mask = PAGE_IS_PFNZERO,
+		.category_anyof_mask = PAGE_IS_PRESENT,
+		.return_mask = PAGE_IS_PFNZERO,
+	};
+	return ioctl(pagemap_fd, PAGEMAP_SCAN, &arg);
+}
+
+int main(int argc, char *argv[])
+{
+	char *mem, *page0, *page1, *page2, tmp;
+	const size_t pagesize = getpagesize();
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+	int pagemap_fd;
+
+	ksft_print_header();
+	ksft_set_plan(3);
+
+	/*
+	 * We'll use memory that is not mapped into the VM for simplicity.
+	 * Shared zeropages are enabled/disabled per-process.
+	 */
+	mem = mmap(0, 3 * pagesize, PROT_READ, MAP_PRIVATE|MAP_ANON, -1, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap() failed");
+
+	/* Disable THP. Ignore errors on older kernels. */
+	madvise(mem, 3 * pagesize, MADV_NOHUGEPAGE);
+
+	page0 = mem;
+	page1 = page0 + pagesize;
+	page2 = page1 + pagesize;
+
+	/* Can we even detect shared zeropages? */
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	TEST_REQUIRE(pagemap_fd >= 0);
+
+	tmp = *page0;
+	asm volatile("" : "+r" (tmp));
+	TEST_REQUIRE(maps_shared_zeropage(pagemap_fd, page0) == 1);
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	/* Verify that we get the shared zeropage after VM creation. */
+	tmp = *page1;
+	asm volatile("" : "+r" (tmp));
+	ksft_test_result(maps_shared_zeropage(pagemap_fd, page1) == 1,
+			 "Shared zeropages should be enabled\n");
+
+	/*
+	 * Let our VM execute a storage key instruction that should
+	 * unshare all shared zeropages.
+	 */
+	vcpu_run(vcpu);
+	get_ucall(vcpu, &uc);
+	TEST_ASSERT_EQ(uc.cmd, UCALL_DONE);
+
+	/* Verify that we don't have a shared zeropage anymore. */
+	ksft_test_result(!maps_shared_zeropage(pagemap_fd, page1),
+			 "Shared zeropage should be gone\n");
+
+	/* Verify that we don't get any new shared zeropages. */
+	tmp = *page2;
+	asm volatile("" : "+r" (tmp));
+	ksft_test_result(!maps_shared_zeropage(pagemap_fd, page2),
+			 "Shared zeropages should be disabled\n");
+
+	kvm_vm_free(vm);
+
+	ksft_finished();
+}
-- 
2.44.0


