Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1A260581C
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 09:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiJTHOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 03:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiJTHNf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 03:13:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8806C1645E1
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 00:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666249998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J1UM8Q4XCnJXEEhn+ghVOV9BUOCnBbI8Wc42C/4GuEI=;
        b=E0thmQqnVZcY3k0UFIOjyk2kRb+G7bGi0yoI+TLUQxSgq/Vsc3VmgPy9EnHSA8ziDV2/PG
        R+vmqHCzsPV+ymM71LiobrjODKMM47C78SoR8xGuJipnkuLiHy/y3s5wqUBHV/FPHkhqva
        5l/ICpqPT+/59WG+m2RXmB+BvkKP4NM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-RAFMVK5ONQWj7_8GG4AbPA-1; Thu, 20 Oct 2022 03:13:14 -0400
X-MC-Unique: RAFMVK5ONQWj7_8GG4AbPA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B48585A5B6;
        Thu, 20 Oct 2022 07:13:14 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-70.bne.redhat.com [10.64.54.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A428E40C6EC2;
        Thu, 20 Oct 2022 07:13:08 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mail@maciej.szmigiero.name,
        maz@kernel.org, pbonzini@redhat.com, ajones@ventanamicro.com,
        shuah@kernel.org, peterx@redhat.com, oliver.upton@linux.dev,
        seanjc@google.com, ricarkol@google.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com
Subject: [PATCH v3 5/6] KVM: selftests: memslot_perf_test: Consolidate memory
Date:   Thu, 20 Oct 2022 15:12:08 +0800
Message-Id: <20221020071209.559062-6-gshan@redhat.com>
In-Reply-To: <20221020071209.559062-1-gshan@redhat.com>
References: <20221020071209.559062-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The addresses and sizes passed to vm_userspace_mem_region_add() and
madvise() should be aligned to host page size, which can be 64KB on
aarch64. So it's wrong by passing additional fixed 4KB memory area
to various tests.

Fix it by passing additional fixed 64KB memory area to various tests.
We also add checks to ensure that none of host/guest page size exceeds
64KB. MEM_TEST_MOVE_SIZE is fixed up to 192KB either.

With this, the following command works fine on 64KB-page-size-host and
4KB-page-size-guest.

  # ./memslot_perf_test -v -s 512

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 .../testing/selftests/kvm/memslot_perf_test.c | 43 +++++++++++--------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 9af61ca8ad0a..daebc264de5a 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -20,17 +20,20 @@
 #include <unistd.h>
 
 #include <linux/compiler.h>
+#include <linux/sizes.h>
 
 #include <test_util.h>
 #include <kvm_util.h>
 #include <processor.h>
 
-#define MEM_SIZE		((512U << 20) + 4096)
-#define MEM_GPA		0x10000000UL
+#define MEM_EXTRA_SIZE		SZ_64K
+
+#define MEM_SIZE		(SZ_512M + MEM_EXTRA_SIZE)
+#define MEM_GPA			SZ_256M
 #define MEM_AUX_GPA		MEM_GPA
 #define MEM_SYNC_GPA		MEM_AUX_GPA
-#define MEM_TEST_GPA		(MEM_AUX_GPA + 4096)
-#define MEM_TEST_SIZE		(MEM_SIZE - 4096)
+#define MEM_TEST_GPA		(MEM_AUX_GPA + MEM_EXTRA_SIZE)
+#define MEM_TEST_SIZE		(MEM_SIZE - MEM_EXTRA_SIZE)
 
 /*
  * 32 MiB is max size that gets well over 100 iterations on 509 slots.
@@ -38,8 +41,8 @@
  * 8194 slots in use can then be tested (although with slightly
  * limited resolution).
  */
-#define MEM_SIZE_MAP		((32U << 20) + 4096)
-#define MEM_TEST_MAP_SIZE	(MEM_SIZE_MAP - 4096)
+#define MEM_SIZE_MAP		(SZ_32M + MEM_EXTRA_SIZE)
+#define MEM_TEST_MAP_SIZE	(MEM_SIZE_MAP - MEM_EXTRA_SIZE)
 
 /*
  * 128 MiB is min size that fills 32k slots with at least one page in each
@@ -47,8 +50,8 @@
  *
  * 2 MiB chunk size like a typical huge page
  */
-#define MEM_TEST_UNMAP_SIZE		(128U << 20)
-#define MEM_TEST_UNMAP_CHUNK_SIZE	(2U << 20)
+#define MEM_TEST_UNMAP_SIZE		SZ_128M
+#define MEM_TEST_UNMAP_CHUNK_SIZE	SZ_2M
 
 /*
  * For the move active test the middle of the test area is placed on
@@ -64,12 +67,12 @@
  *
  * architecture   slots    memory-per-slot    memory-on-last-slot
  * --------------------------------------------------------------
- * x86-4KB        32763    16KB               100KB
- * arm64-4KB      32766    16KB               52KB
- * arm64-16KB     32766    16KB               48KB
- * arm64-64KB     8192     64KB               64KB
+ * x86-4KB        32763    16KB               160KB
+ * arm64-4KB      32766    16KB               112KB
+ * arm64-16KB     32766    16KB               112KB
+ * arm64-64KB     8192     64KB               128KB
  */
-#define MEM_TEST_MOVE_SIZE		0x10000
+#define MEM_TEST_MOVE_SIZE		(3 * SZ_64K)
 #define MEM_TEST_MOVE_GPA_DEST		(MEM_GPA + MEM_SIZE)
 static_assert(MEM_TEST_MOVE_SIZE <= MEM_TEST_SIZE,
 	      "invalid move test region size");
@@ -533,7 +536,6 @@ static bool test_memslot_move_prepare(struct vm_data *data,
 				      uint64_t *maxslots, bool isactive)
 {
 	uint32_t guest_page_size = data->vm->page_size;
-	uint64_t move_pages = MEM_TEST_MOVE_SIZE / guest_page_size;
 	uint64_t movesrcgpa, movetestgpa;
 
 	movesrcgpa = vm_slot2gpa(data, data->nslots - 1);
@@ -542,7 +544,7 @@ static bool test_memslot_move_prepare(struct vm_data *data,
 		uint64_t lastpages;
 
 		vm_gpa2hva(data, movesrcgpa, &lastpages);
-		if (lastpages < move_pages / 2) {
+		if (lastpages * guest_page_size < MEM_TEST_MOVE_SIZE / 2) {
 			*maxslots = 0;
 			return false;
 		}
@@ -808,13 +810,13 @@ static const struct test_data tests[] = {
 	},
 	{
 		.name = "unmap",
-		.mem_size = MEM_TEST_UNMAP_SIZE + 4096,
+		.mem_size = MEM_TEST_UNMAP_SIZE + MEM_EXTRA_SIZE,
 		.guest_code = guest_code_test_memslot_unmap,
 		.loop = test_memslot_unmap_loop,
 	},
 	{
 		.name = "unmap chunked",
-		.mem_size = MEM_TEST_UNMAP_SIZE + 4096,
+		.mem_size = MEM_TEST_UNMAP_SIZE + MEM_EXTRA_SIZE,
 		.guest_code = guest_code_test_memslot_unmap,
 		.loop = test_memslot_unmap_loop_chunked,
 	},
@@ -874,8 +876,15 @@ static void help(char *name, struct test_args *targs)
 
 static bool check_memory_sizes(void)
 {
+	uint32_t host_page_size = getpagesize();
 	uint32_t guest_page_size = vm_guest_mode_params[VM_MODE_DEFAULT].page_size;
 
+	if (host_page_size > SZ_64K || guest_page_size > SZ_64K) {
+		pr_info("Unsupported page size on host (0x%x) or guest (0x%x)\n",
+			host_page_size, guest_page_size);
+		return false;
+	}
+
 	if (MEM_SIZE % guest_page_size ||
 	    MEM_TEST_SIZE % guest_page_size) {
 		pr_info("invalid MEM_SIZE or MEM_TEST_SIZE\n");
-- 
2.23.0

