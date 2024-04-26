Return-Path: <kvm+bounces-16031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84A168B3365
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 10:56:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A715B1C21EEF
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 08:56:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3684213CAB7;
	Fri, 26 Apr 2024 08:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q3sG2FVQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE4A13CF96
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 08:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714121766; cv=none; b=RFJb7DH/w9dHEYHqyWv5v8pe4JdbBz74Goq4fn+lV+Y4V75bEAE0KO0Hsu88j+MMtYl6kAkrjdBjRmDNsJTn3BoI0ZTsCpCvGfECXyuRwYedri18PNn4ljgp9F3lCDkm4De50NImY6FPzgM8saZ3/wrGPEeLm5nP0YiIbxoHY1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714121766; c=relaxed/simple;
	bh=GlZ1B8v/0cLbLEAY4J2NVInrTG/rSDZ7UA9AoUhONts=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hslmH5vG/KzEd4hm4bbIMy8LSn4GFSvEgu17O9zSBp+5oKJlgkJh2jxVPjI2/X/80zz4LihUvLTVZbEgHsi/3AaxfQHm4Im1IP0OCUjWqLR6r6B1WSnR51/NFEN7gFj0PkleYdIoojIwXh/VR7MZHcg/AJtH1JecCkVyIMXNuiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q3sG2FVQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714121763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=n8zGemF1SfCYbNk1FEg//7LYlxlOkILXpP9ensiSsiY=;
	b=Q3sG2FVQjDMnE5snz3u0a/Sx7hdMisNNdhLegHkZfTHA0OC9PdGtOPKla5ExO6Edp3kxDj
	kPdNzaznklLZMY1VO7xNRk4gLkOyUKKOxxZxanDH25uMDkPdaFHNughFb9rnnVFuNinH33
	dX6vFEPtcWxH3AcvHMnidMv+empXGZM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-138-l2vb6lE1Pl21g1mYn_e7vA-1; Fri, 26 Apr 2024 04:56:00 -0400
X-MC-Unique: l2vb6lE1Pl21g1mYn_e7vA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81D1F18065AA;
	Fri, 26 Apr 2024 08:55:59 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.39.194.59])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8A3CA1121312;
	Fri, 26 Apr 2024 08:55:57 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>
Subject: [PATCH] KVM: selftests: Use TAP interface in the set_memory_region test
Date: Fri, 26 Apr 2024 10:55:56 +0200
Message-ID: <20240426085556.619731-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Use the kselftest_harness.h interface in this test to get TAP
output, so that it is easier for the user to see what the test
is doing. (Note: We are not using the KVM_ONE_VCPU_TEST_SUITE()
macro here since these tests are creating their VMs with the
vm_create_barebones() function, not with vm_create_with_one_vcpu())

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .../selftests/kvm/set_memory_region_test.c    | 86 +++++++++----------
 1 file changed, 42 insertions(+), 44 deletions(-)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index bd57d991e27d..4db6a66a3001 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -16,6 +16,7 @@
 #include <test_util.h>
 #include <kvm_util.h>
 #include <processor.h>
+#include "kselftest_harness.h"
 
 /*
  * s390x needs at least 1MB alignment, and the x86_64 MOVE/DELETE tests need a
@@ -38,6 +39,8 @@ extern const uint64_t final_rip_end;
 
 static sem_t vcpu_ready;
 
+int loops;
+
 static inline uint64_t guest_spin_on_val(uint64_t spin_val)
 {
 	uint64_t val;
@@ -219,6 +222,13 @@ static void test_move_memory_region(void)
 	kvm_vm_free(vm);
 }
 
+TEST(move_in_use_region)
+{
+	ksft_print_msg("Testing MOVE of in-use region, %d loops\n", loops);
+	for (int i = 0; i < loops; i++)
+		test_move_memory_region();
+}
+
 static void guest_code_delete_memory_region(void)
 {
 	uint64_t val;
@@ -308,12 +318,19 @@ static void test_delete_memory_region(void)
 	kvm_vm_free(vm);
 }
 
-static void test_zero_memory_regions(void)
+TEST(delete_in_use_region)
+{
+	ksft_print_msg("Testing DELETE of in-use region, %d loops\n", loops);
+	for (int i = 0; i < loops; i++)
+		test_delete_memory_region();
+}
+
+TEST(zero_memory_regions)
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
-	pr_info("Testing KVM_RUN with zero added memory regions\n");
+	ksft_print_msg("Testing KVM_RUN with zero added memory regions\n");
 
 	vm = vm_create_barebones();
 	vcpu = __vm_vcpu_add(vm, 0);
@@ -326,7 +343,7 @@ static void test_zero_memory_regions(void)
 }
 #endif /* __x86_64__ */
 
-static void test_invalid_memory_region_flags(void)
+TEST(invalid_memory_region_flags)
 {
 	uint32_t supported_flags = KVM_MEM_LOG_DIRTY_PAGES;
 	const uint32_t v2_only_flags = KVM_MEM_GUEST_MEMFD;
@@ -389,7 +406,7 @@ static void test_invalid_memory_region_flags(void)
  * Test it can be added memory slots up to KVM_CAP_NR_MEMSLOTS, then any
  * tentative to add further slots should fail.
  */
-static void test_add_max_memory_regions(void)
+TEST(add_max_memory_regions)
 {
 	int ret;
 	struct kvm_vm *vm;
@@ -408,13 +425,13 @@ static void test_add_max_memory_regions(void)
 	max_mem_slots = kvm_check_cap(KVM_CAP_NR_MEMSLOTS);
 	TEST_ASSERT(max_mem_slots > 0,
 		    "KVM_CAP_NR_MEMSLOTS should be greater than 0");
-	pr_info("Allowed number of memory slots: %i\n", max_mem_slots);
+	ksft_print_msg("Allowed number of memory slots: %i\n", max_mem_slots);
 
 	vm = vm_create_barebones();
 
 	/* Check it can be added memory slots up to the maximum allowed */
-	pr_info("Adding slots 0..%i, each memory region with %dK size\n",
-		(max_mem_slots - 1), MEM_REGION_SIZE >> 10);
+	ksft_print_msg("Adding slots 0..%i, each memory region with %dK size\n",
+		       (max_mem_slots - 1), MEM_REGION_SIZE >> 10);
 
 	mem = mmap(NULL, (size_t)max_mem_slots * MEM_REGION_SIZE + alignment,
 		   PROT_READ | PROT_WRITE,
@@ -455,12 +472,21 @@ static void test_invalid_guest_memfd(struct kvm_vm *vm, int memfd,
 	TEST_ASSERT(r == -1 && errno == EINVAL, "%s", msg);
 }
 
-static void test_add_private_memory_region(void)
+static bool has_cap_guest_memfd(void)
+{
+	return kvm_has_cap(KVM_CAP_GUEST_MEMFD) &&
+	       (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
+}
+
+TEST(add_private_memory_region)
 {
 	struct kvm_vm *vm, *vm2;
 	int memfd, i;
 
-	pr_info("Testing ADD of KVM_MEM_GUEST_MEMFD memory regions\n");
+	if (!has_cap_guest_memfd())
+		SKIP(return, "Missing KVM_MEM_GUEST_MEMFD / KVM_X86_SW_PROTECTED_VM");
+
+	ksft_print_msg("Testing ADD of KVM_MEM_GUEST_MEMFD memory regions\n");
 
 	vm = vm_create_barebones_protected_vm();
 
@@ -491,13 +517,16 @@ static void test_add_private_memory_region(void)
 	kvm_vm_free(vm);
 }
 
-static void test_add_overlapping_private_memory_regions(void)
+TEST(add_overlapping_private_memory_regions)
 {
 	struct kvm_vm *vm;
 	int memfd;
 	int r;
 
-	pr_info("Testing ADD of overlapping KVM_MEM_GUEST_MEMFD memory regions\n");
+	if (!has_cap_guest_memfd())
+		SKIP(return, "Missing KVM_MEM_GUEST_MEMFD / KVM_X86_SW_PROTECTED_VM");
+
+	ksft_print_msg("Testing ADD of overlapping KVM_MEM_GUEST_MEMFD memory regions\n");
 
 	vm = vm_create_barebones_protected_vm();
 
@@ -536,46 +565,15 @@ static void test_add_overlapping_private_memory_regions(void)
 	close(memfd);
 	kvm_vm_free(vm);
 }
+
 #endif
 
 int main(int argc, char *argv[])
 {
-#ifdef __x86_64__
-	int i, loops;
-
-	/*
-	 * FIXME: the zero-memslot test fails on aarch64 and s390x because
-	 * KVM_RUN fails with ENOEXEC or EFAULT.
-	 */
-	test_zero_memory_regions();
-#endif
-
-	test_invalid_memory_region_flags();
-
-	test_add_max_memory_regions();
-
-#ifdef __x86_64__
-	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD) &&
-	    (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))) {
-		test_add_private_memory_region();
-		test_add_overlapping_private_memory_regions();
-	} else {
-		pr_info("Skipping tests for KVM_MEM_GUEST_MEMFD memory regions\n");
-	}
-
 	if (argc > 1)
 		loops = atoi_positive("Number of iterations", argv[1]);
 	else
 		loops = 10;
 
-	pr_info("Testing MOVE of in-use region, %d loops\n", loops);
-	for (i = 0; i < loops; i++)
-		test_move_memory_region();
-
-	pr_info("Testing DELETE of in-use region, %d loops\n", loops);
-	for (i = 0; i < loops; i++)
-		test_delete_memory_region();
-#endif
-
-	return 0;
+	return test_harness_run(argc, argv);
 }
-- 
2.44.0


