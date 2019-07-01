Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AACB4AFD7
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2019 04:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbfFSCEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 22:04:41 -0400
Received: from mga04.intel.com ([192.55.52.120]:42367 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726047AbfFSCEl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 22:04:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 19:04:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,391,1557212400"; 
   d="scan'208";a="160231713"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga008.fm.intel.com with ESMTP; 18 Jun 2019 19:04:38 -0700
From:   Weijiang Yang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mst@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com, yu.c.zhang@intel.com
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH 1/1] kvm: selftests: add selftest for SPP feature
Date:   Wed, 19 Jun 2019 10:03:00 +0800
Message-Id: <20190619020300.30392-2-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190619020300.30392-1-weijiang.yang@intel.com>
References: <20190619020300.30392-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yang Weijiang <weijiang.yang@intel.com>

Sub-Page Permission(SPP) is to protect finer granularity subpages
(128Byte each) within a 4KB page. It's not enabled in KVM by default,
the test first initializes the SPP runtime environment with
KVM_INIT_SPP ioctl, then sets protection with KVM_SUBPAGES_SET_ACCESS
for the target guest page, check permissions with KVM_SUBPAGES_GET_ACCESS
to make sure they are set as expected.

There're two steps in guest code to very whether SPP is working:
1) protect all 128byte subpages, write data to each subpage
to see if SPP induced EPT violation happening. 2)unprotect all
subpages, again write data to each subpage to see if SPP still
works or not.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
 tools/testing/selftests/kvm/x86_64/spp_test.c | 206 ++++++++++++++++++
 3 files changed, 208 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/spp_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index f8588cca2bef..5e82376016fc 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -20,6 +20,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
 TEST_GEN_PROGS_x86_64 += x86_64/smm_test
+TEST_GEN_PROGS_x86_64 += x86_64/spp_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 4ca96b228e46..04533144da53 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1422,6 +1422,7 @@ static struct exit_reason {
 	{KVM_EXIT_UNKNOWN, "UNKNOWN"},
 	{KVM_EXIT_EXCEPTION, "EXCEPTION"},
 	{KVM_EXIT_IO, "IO"},
+	{KVM_EXIT_SPP, "SPP"},
 	{KVM_EXIT_HYPERCALL, "HYPERCALL"},
 	{KVM_EXIT_DEBUG, "DEBUG"},
 	{KVM_EXIT_HLT, "HLT"},
diff --git a/tools/testing/selftests/kvm/x86_64/spp_test.c b/tools/testing/selftests/kvm/x86_64/spp_test.c
new file mode 100644
index 000000000000..f8425a5a6b49
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/spp_test.c
@@ -0,0 +1,206 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Sub-Page Permission test
+ *
+ * Copyright (C) 2019, Intel Corp.
+ *
+ */
+
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "../../lib/kvm_util_internal.h"
+
+#define VCPU_ID           1
+#define PAGE_SIZE         (4096)
+#define SPP_GUARD_SIZE    (16 * PAGE_SIZE)
+#define SPP_GUARD_MEMSLOT (1)
+#define SPP_GUARD_PAGES   (SPP_GUARD_SIZE / PAGE_SIZE)
+#define SPP_GUARD_GPA      0x10000000
+
+#define SUBPAGE_ACCESS_DEFAULT   (0x0)
+#define SUBPAGE_ACCESS_FULL      (0xFFFFFFFF)
+#define START_SPP_VM_ADDR        (0x700000)
+#define SUBPAGE_SIZE             (128)
+
+vm_vaddr_t vspp_start;
+vm_paddr_t pspp_start;
+
+void guest_code(void)
+{
+	uint8_t *iterator = (uint8_t *)vspp_start;
+	int count;
+
+	GUEST_SYNC(1);
+	/*
+	 * expect EPT violation induced by SPP in each interation since
+	 * the full page is protected by SPP.
+	 */
+	for (count = 0; count < PAGE_SIZE / SUBPAGE_SIZE; count++) {
+		*(uint32_t *)(iterator) = 0x99;
+		iterator += SUBPAGE_SIZE;
+	}
+	GUEST_SYNC(2);
+	iterator = (uint8_t *)vspp_start;
+
+	/*
+	 * don't expect EPT violation happen since SPP is disabled
+	 * for the page
+	 */
+	for (count = 0; count < PAGE_SIZE / SUBPAGE_SIZE; count++) {
+		*(uint32_t *)(iterator) = 0x99;
+		iterator += SUBPAGE_SIZE;
+	}
+}
+
+void prepare_test(struct kvm_vm **g_vm, struct kvm_run **g_run)
+{
+	void *spp_hva;
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+	/* Create VM, SPP is only valid for 4KB page mode */
+	*g_vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vm = *g_vm;
+
+	*g_run = vcpu_state(vm, VCPU_ID);
+	run = *g_run;
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, SPP_GUARD_GPA,
+				    SPP_GUARD_MEMSLOT, SPP_GUARD_PAGES, 0);
+
+	pspp_start = vm_phy_pages_alloc(vm, 1, SPP_GUARD_GPA,
+					SPP_GUARD_MEMSLOT);
+
+	memset(addr_gpa2hva(vm, SPP_GUARD_GPA), 0x0, PAGE_SIZE);
+
+	virt_map(vm, START_SPP_VM_ADDR, SPP_GUARD_GPA, PAGE_SIZE, 0);
+
+	vspp_start = vm_vaddr_alloc(vm, PAGE_SIZE, START_SPP_VM_ADDR,
+				    SPP_GUARD_MEMSLOT, 0);
+
+	spp_hva = addr_gva2hva(vm, vspp_start);
+
+	pspp_start = addr_hva2gpa(vm, spp_hva);
+
+	printf("SPP protected zone: size = %d, gva = 0x%llx, gpa = 0x%llx, "
+	       "hva = 0x%p\n", PAGE_SIZE, vspp_start, pspp_start, spp_hva);
+
+	/* make sure the virtual address is visible to VM. */
+	sync_global_to_guest(vm, vspp_start);
+
+	_vcpu_run(vm, VCPU_ID);
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		    "exit reason: %u (%s),\n", run->exit_reason,
+		     exit_reason_str(run->exit_reason));
+}
+
+void setup_spp(struct kvm_vm *vm)
+{
+	struct kvm_subpage spp_info = {0};
+	int ret;
+
+	/* initialize the SPP runtime environment.*/
+	ret = ioctl(vm->fd, KVM_INIT_SPP, 0);
+
+	TEST_ASSERT(ret == 0, "KVM_INIT_SPP failed.");
+
+	printf("SPP initialized successfully.\n");
+
+	/* set up SPP protection for the page. */
+	spp_info.npages = 1;
+	spp_info.base_gfn = pspp_start >> 12;
+	spp_info.access_map[0] = SUBPAGE_ACCESS_DEFAULT;
+	ret = ioctl(vm->fd, KVM_SUBPAGES_SET_ACCESS, &spp_info);
+
+	TEST_ASSERT(ret == 1, "KVM_SUBPAGES_SET_ACCESS failed. ret = 0x%x, "
+		    "base_gfn = 0x%llx\n", ret, spp_info.base_gfn);
+	printf("set spp protection info: gfn = 0x%llx, access = 0x%lx, "
+	       "npages = %d\n", spp_info.base_gfn, spp_info.access_map[0],
+	       spp_info.npages);
+
+	/* make sure the SPP permission bits are actully set as expected. */
+	memset(&spp_info, 0, sizeof(spp_info));
+	spp_info.npages = 1;
+	spp_info.base_gfn = pspp_start >> 12;
+
+	ret = ioctl(vm->fd, KVM_SUBPAGES_GET_ACCESS, &spp_info);
+
+	TEST_ASSERT(ret == 1, "KVM_SUBPAGES_GET_ACCESS failed.");
+
+	TEST_ASSERT(spp_info.access_map[0] == SUBPAGE_ACCESS_DEFAULT,
+		    "subpage access didn't match.");
+	printf("get spp protection info: gfn = 0x%llx, access = 0x%lx, "
+	       "npages = %d\n", spp_info.base_gfn,
+	       spp_info.access_map[0], spp_info.npages);
+
+	printf("got matched subpage permission vector.\n");
+	printf("expect VM exits caused by SPP below.\n");
+}
+
+void unset_spp(struct kvm_vm *vm)
+{
+	struct kvm_subpage spp_info = {0};
+	int ret;
+
+	/* now unprotect the SPP to the page.*/
+	spp_info.base_gfn = pspp_start >> 12;
+	spp_info.access_map[0] = SUBPAGE_ACCESS_FULL;
+	ret = ioctl(vm->fd, KVM_SUBPAGES_SET_ACCESS, &spp_info);
+
+	printf("unset SPP protection at gfn: 0x%llx\n", spp_info.base_gfn);
+	printf("expect NO VM exits caused by SPP below.\n");
+}
+
+void run_test(struct kvm_vm *vm, struct kvm_run *run)
+{
+	int loop;
+	int ept_fault;
+
+	_vcpu_run(vm, VCPU_ID);
+
+	for (loop = 0; loop < PAGE_SIZE / SUBPAGE_SIZE; loop++) {
+		/*
+		 * if everything goes correctly, should get VM exit
+		 * with KVM_EXIT_SPP.
+		 */
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_SPP,
+			    "exit reason: %u (%s),\n", run->exit_reason,
+			    exit_reason_str(run->exit_reason));
+		printf("%d - exit reason: %s\n", loop + 1,
+		       exit_reason_str(run->exit_reason));
+		ept_fault++;
+		_vcpu_run(vm, VCPU_ID);
+	}
+
+	printf("total EPT violation count: %d\n", ept_fault);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+
+	prepare_test(&vm, &run);
+
+	setup_spp(vm);
+
+	run_test(vm, run);
+
+	unset_spp(vm);
+
+	_vcpu_run(vm, VCPU_ID);
+
+	printf("completed SPP test successfully!\n");
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
+
-- 
2.17.2

