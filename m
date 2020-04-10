Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51D951A4C8D
	for <lists+kvm@lfdr.de>; Sat, 11 Apr 2020 01:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgDJXR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 19:17:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:20816 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbgDJXRN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 19:17:13 -0400
IronPort-SDR: R5aoyWtH1y/suQtyCQbi5/7yapfl1w+WP/UybIJ6SGvSrHxsqvGQhn1/tocWF75OL63/GGB8C3
 HjaceFAw1BnQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 16:17:13 -0700
IronPort-SDR: ikwq143VSWmYHHh6IAwovH9GlLVjgvSTOHYgfvdMlRY08Nb1My+2USJkmo9XigehpCYXpNSeZb
 IYEslCwrI52w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,368,1580803200"; 
   d="scan'208";a="452542251"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 10 Apr 2020 16:17:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
Subject: [PATCH 09/10] KVM: selftests: Make set_memory_region_test common to all architectures
Date:   Fri, 10 Apr 2020 16:17:06 -0700
Message-Id: <20200410231707.7128-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200410231707.7128-1-sean.j.christopherson@intel.com>
References: <20200410231707.7128-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make set_memory_region_test available on all architectures by wrapping
the bits that are x86-specific in ifdefs.  All architectures can do
no-harm testing of running with zero memslots, and a future testcase
to create the maximum number of memslots will also be architecture
agnostic.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/kvm/.gitignore              |  2 +-
 tools/testing/selftests/kvm/Makefile                |  4 +++-
 .../kvm/{x86_64 => }/set_memory_region_test.c       | 13 ++++++++++++-
 3 files changed, 16 insertions(+), 3 deletions(-)
 rename tools/testing/selftests/kvm/{x86_64 => }/set_memory_region_test.c (97%)

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 16877c3daabf..5947cc119abc 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -6,7 +6,6 @@
 /x86_64/hyperv_cpuid
 /x86_64/mmio_warning_test
 /x86_64/platform_info_test
-/x86_64/set_memory_region_test
 /x86_64/set_sregs_test
 /x86_64/smm_test
 /x86_64/state_test
@@ -21,4 +20,5 @@
 /demand_paging_test
 /dirty_log_test
 /kvm_create_max_vcpus
+/set_memory_region_test
 /steal_time
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 712a2ddd2a27..7af62030c12f 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -17,7 +17,6 @@ TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
 TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
-TEST_GEN_PROGS_x86_64 += x86_64/set_memory_region_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
 TEST_GEN_PROGS_x86_64 += x86_64/smm_test
 TEST_GEN_PROGS_x86_64 += x86_64/state_test
@@ -32,12 +31,14 @@ TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
+TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 
 TEST_GEN_PROGS_aarch64 += clear_dirty_log_test
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
 TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
+TEST_GEN_PROGS_aarch64 += set_memory_region_test
 TEST_GEN_PROGS_aarch64 += steal_time
 
 TEST_GEN_PROGS_s390x = s390x/memop
@@ -46,6 +47,7 @@ TEST_GEN_PROGS_s390x += s390x/sync_regs_test
 TEST_GEN_PROGS_s390x += demand_paging_test
 TEST_GEN_PROGS_s390x += dirty_log_test
 TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
+TEST_GEN_PROGS_s390x += set_memory_region_test
 
 TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
 LIBKVM += $(LIBKVM_$(UNAME_M))
diff --git a/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
similarity index 97%
rename from tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
rename to tools/testing/selftests/kvm/set_memory_region_test.c
index c274ce6b4ba2..0f36941ebb96 100644
--- a/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -18,6 +18,7 @@
 
 #define VCPU_ID 0
 
+#ifdef __x86_64__
 /*
  * Somewhat arbitrary location and slot, intended to not overlap anything.  The
  * location and size are specifically 2mb sized/aligned so that the initial
@@ -288,6 +289,7 @@ static void test_delete_memory_region(void)
 
 	kvm_vm_free(vm);
 }
+#endif /* __x86_64__ */
 
 static void test_zero_memory_regions(void)
 {
@@ -299,13 +301,18 @@ static void test_zero_memory_regions(void)
 	vm = vm_create(VM_MODE_DEFAULT, 0, O_RDWR);
 	vm_vcpu_add(vm, VCPU_ID);
 
+#ifdef __x86_64__
 	TEST_ASSERT(!ioctl(vm_get_fd(vm), KVM_SET_NR_MMU_PAGES, 64),
 		    "KVM_SET_NR_MMU_PAGES failed, errno = %d\n", errno);
-
+#endif
 	vcpu_run(vm, VCPU_ID);
 
 	run = vcpu_state(vm, VCPU_ID);
+#ifdef __x86_64__
 	TEST_ASSERT(run->exit_reason == KVM_EXIT_INTERNAL_ERROR,
+#else
+	TEST_ASSERT(run->exit_reason != KVM_EXIT_UNKNOWN,
+#endif
 		    "Unexpected exit_reason = %u\n", run->exit_reason);
 
 	kvm_vm_free(vm);
@@ -313,13 +320,16 @@ static void test_zero_memory_regions(void)
 
 int main(int argc, char *argv[])
 {
+#ifdef __x86_64__
 	int i, loops;
+#endif
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
 	test_zero_memory_regions();
 
+#ifdef __x86_64__
 	if (argc > 1)
 		loops = atoi(argv[1]);
 	else
@@ -332,6 +342,7 @@ int main(int argc, char *argv[])
 	pr_info("Testing DELETE of in-use region, %d loops\n", loops);
 	for (i = 0; i < loops; i++)
 		test_delete_memory_region();
+#endif
 
 	return 0;
 }
-- 
2.26.0

