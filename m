Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8CD230C93
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 16:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgG1OiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 10:38:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52958 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730486AbgG1OiH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 10:38:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595947085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pOFRF28EbT8Q3R4fTExC5nvCZHNOSRSF8WWCt3CjB0k=;
        b=Kj+VaVYdDIV3i4FoK0wXuAJXeNdCjIqekfEvM1i31pDTkavRrVeqgwTZC6d2STUUYiH2aA
        ZAd7f0Mad5gr8y48q8QPowM5QPaibpbJQLIcvw/6ytvenMOwGOtZgoRcK0I4wViZ+FNOba
        BNKbzefRpu0B627yyDFI6rikZbVTG6c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-FFUuaVVEMy64ZwDDW35S8Q-1; Tue, 28 Jul 2020 10:38:03 -0400
X-MC-Unique: FFUuaVVEMy64ZwDDW35S8Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D67EF100AA22;
        Tue, 28 Jul 2020 14:38:01 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2EE147BD60;
        Tue, 28 Jul 2020 14:37:58 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>, Michael Tsirkin <mst@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: selftests: add KVM_MEM_PCI_HOLE test
Date:   Tue, 28 Jul 2020 16:37:41 +0200
Message-Id: <20200728143741.2718593-4-vkuznets@redhat.com>
In-Reply-To: <20200728143741.2718593-1-vkuznets@redhat.com>
References: <20200728143741.2718593-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test the newly introduced KVM_MEM_PCI_HOLE memslots:
- Reads from all pages return '0xff'
- Writes to all pages cause KVM_EXIT_MMIO

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  81 +++++++------
 .../kvm/x86_64/memory_slot_pci_hole.c         | 112 ++++++++++++++++++
 4 files changed, 162 insertions(+), 33 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/memory_slot_pci_hole.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 4a166588d99f..a6fe303fbf6a 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -41,6 +41,7 @@ LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c
 TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
+TEST_GEN_PROGS_x86_64 += x86_64/memory_slot_pci_hole
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 919e161dd289..8e7bec7bd287 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -59,6 +59,7 @@ enum vm_mem_backing_src_type {
 	VM_MEM_SRC_ANONYMOUS,
 	VM_MEM_SRC_ANONYMOUS_THP,
 	VM_MEM_SRC_ANONYMOUS_HUGETLB,
+	VM_MEM_SRC_NONE,
 };
 
 int kvm_check_cap(long cap);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 74776ee228f2..46bb28ea34ec 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -453,8 +453,11 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 		    "rc: %i errno: %i", ret, errno);
 
 	sparsebit_free(&region->unused_phy_pages);
-	ret = munmap(region->mmap_start, region->mmap_size);
-	TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
+	if (region->mmap_start) {
+		ret = munmap(region->mmap_start, region->mmap_size);
+		TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret,
+			    errno);
+	}
 
 	free(region);
 }
@@ -643,34 +646,42 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	alignment = 1;
 #endif
 
-	if (src_type == VM_MEM_SRC_ANONYMOUS_THP)
-		alignment = max(huge_page_size, alignment);
-
-	/* Add enough memory to align up if necessary */
-	if (alignment > 1)
-		region->mmap_size += alignment;
-
-	region->mmap_start = mmap(NULL, region->mmap_size,
-				  PROT_READ | PROT_WRITE,
-				  MAP_PRIVATE | MAP_ANONYMOUS
-				  | (src_type == VM_MEM_SRC_ANONYMOUS_HUGETLB ? MAP_HUGETLB : 0),
-				  -1, 0);
-	TEST_ASSERT(region->mmap_start != MAP_FAILED,
-		    "test_malloc failed, mmap_start: %p errno: %i",
-		    region->mmap_start, errno);
-
-	/* Align host address */
-	region->host_mem = align(region->mmap_start, alignment);
-
-	/* As needed perform madvise */
-	if (src_type == VM_MEM_SRC_ANONYMOUS || src_type == VM_MEM_SRC_ANONYMOUS_THP) {
-		ret = madvise(region->host_mem, npages * vm->page_size,
-			     src_type == VM_MEM_SRC_ANONYMOUS ? MADV_NOHUGEPAGE : MADV_HUGEPAGE);
-		TEST_ASSERT(ret == 0, "madvise failed,\n"
-			    "  addr: %p\n"
-			    "  length: 0x%lx\n"
-			    "  src_type: %x",
-			    region->host_mem, npages * vm->page_size, src_type);
+	if (src_type != VM_MEM_SRC_NONE) {
+		if (src_type == VM_MEM_SRC_ANONYMOUS_THP)
+			alignment = max(huge_page_size, alignment);
+
+		/* Add enough memory to align up if necessary */
+		if (alignment > 1)
+			region->mmap_size += alignment;
+
+		region->mmap_start = mmap(NULL, region->mmap_size,
+			  PROT_READ | PROT_WRITE,
+			  MAP_PRIVATE | MAP_ANONYMOUS
+			  | (src_type == VM_MEM_SRC_ANONYMOUS_HUGETLB ?
+			     MAP_HUGETLB : 0), -1, 0);
+		TEST_ASSERT(region->mmap_start != MAP_FAILED,
+			    "test_malloc failed, mmap_start: %p errno: %i",
+			    region->mmap_start, errno);
+
+		/* Align host address */
+		region->host_mem = align(region->mmap_start, alignment);
+
+		/* As needed perform madvise */
+		if (src_type == VM_MEM_SRC_ANONYMOUS ||
+		    src_type == VM_MEM_SRC_ANONYMOUS_THP) {
+			ret = madvise(region->host_mem, npages * vm->page_size,
+				      src_type == VM_MEM_SRC_ANONYMOUS ?
+				      MADV_NOHUGEPAGE : MADV_HUGEPAGE);
+			TEST_ASSERT(ret == 0, "madvise failed,\n"
+				    "  addr: %p\n"
+				    "  length: 0x%lx\n"
+				    "  src_type: %x",
+				    region->host_mem, npages * vm->page_size,
+				    src_type);
+		}
+	} else {
+		region->mmap_start = NULL;
+		region->host_mem = NULL;
 	}
 
 	region->unused_phy_pages = sparsebit_alloc();
@@ -1076,9 +1087,13 @@ void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
 	list_for_each_entry(region, &vm->userspace_mem_regions, list) {
 		if ((gpa >= region->region.guest_phys_addr)
 			&& (gpa <= (region->region.guest_phys_addr
-				+ region->region.memory_size - 1)))
-			return (void *) ((uintptr_t) region->host_mem
-				+ (gpa - region->region.guest_phys_addr));
+				+ region->region.memory_size - 1))) {
+			if (region->host_mem)
+				return (void *) ((uintptr_t) region->host_mem
+				 + (gpa - region->region.guest_phys_addr));
+			else
+				return NULL;
+		}
 	}
 
 	TEST_FAIL("No vm physical memory at 0x%lx", gpa);
diff --git a/tools/testing/selftests/kvm/x86_64/memory_slot_pci_hole.c b/tools/testing/selftests/kvm/x86_64/memory_slot_pci_hole.c
new file mode 100644
index 000000000000..f5fa80dfcba7
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/memory_slot_pci_hole.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <fcntl.h>
+#include <pthread.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include <linux/compiler.h>
+
+#include <test_util.h>
+#include <kvm_util.h>
+#include <processor.h>
+
+#define VCPU_ID 0
+
+#define MEM_REGION_GPA		0xc0000000
+#define MEM_REGION_SIZE		0x4000
+#define MEM_REGION_SLOT		10
+
+static void guest_code(void)
+{
+	uint8_t val;
+
+	/* First byte in the first page */
+	val = READ_ONCE(*((uint8_t *)MEM_REGION_GPA));
+	GUEST_ASSERT(val == 0xff);
+
+	GUEST_SYNC(1);
+
+	/* Random byte in the second page */
+	val = READ_ONCE(*((uint8_t *)MEM_REGION_GPA + 5000));
+	GUEST_ASSERT(val == 0xff);
+
+	GUEST_SYNC(2);
+
+	/* Write to the first page */
+	WRITE_ONCE(*((uint64_t *)MEM_REGION_GPA + 1024/8), 0xdeafbeef);
+
+	GUEST_SYNC(3);
+
+	/* Write to the second page */
+	WRITE_ONCE(*((uint64_t *)MEM_REGION_GPA + 8000/8), 0xdeafbeef);
+
+	GUEST_SYNC(4);
+
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+	struct ucall uc;
+	int stage, rv;
+
+	rv = kvm_check_cap(KVM_CAP_PCI_HOLE_MEM);
+	if (!rv) {
+		print_skip("KVM_CAP_PCI_HOLE_MEM not supported");
+		exit(KSFT_SKIP);
+	}
+
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+
+	run = vcpu_state(vm, VCPU_ID);
+
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_NONE,
+				    MEM_REGION_GPA, MEM_REGION_SLOT,
+				    MEM_REGION_SIZE / getpagesize(),
+				    KVM_MEM_PCI_HOLE);
+
+	virt_map(vm, MEM_REGION_GPA, MEM_REGION_GPA,
+		 MEM_REGION_SIZE / getpagesize(), 0);
+
+	for (stage = 1;; stage++) {
+		_vcpu_run(vm, VCPU_ID);
+
+		if (stage == 3 || stage == 5) {
+			TEST_ASSERT(run->exit_reason == KVM_EXIT_MMIO,
+			   "Write to PCI_HOLE page should cause KVM_EXIT_MMIO");
+			continue;
+		}
+
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "Stage %d: unexpected exit reason: %u (%s),\n",
+			    stage, run->exit_reason,
+			    exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_ABORT:
+			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
+				  __FILE__, uc.args[1]);
+			/* NOT REACHED */
+		case UCALL_SYNC:
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	kvm_vm_free(vm);
+
+	return 0;
+}
-- 
2.25.4

