Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBE4602325
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 06:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbiJREGi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 00:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiJREGE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 00:06:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB5F9379D
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 21:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666065952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2JseUvCnBtDKpXX2u+0xKEawSnwnBYCh4Pw+SGrWbXc=;
        b=N2aVPZT2Fu6VlW0CJbjEbar2+yFysoys+pBOsrBs9kWKsMB3VWUEeNc5wWJaOCYycRMtPq
        dnJQGY2zk6XVRJJw6zLeh9FjsvRYuJ+1svfoMZhpcdi+WTu27LeYYqGUv6uSi8vhA+xE8T
        dGU/LlysOhcWhYntnNsIzMUhv2fVwoc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-YA2M8vYJOtKYrLvyIt9skQ-1; Tue, 18 Oct 2022 00:05:37 -0400
X-MC-Unique: YA2M8vYJOtKYrLvyIt9skQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EA953C3C964;
        Tue, 18 Oct 2022 04:05:36 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-70.bne.redhat.com [10.64.54.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7188B2166B41;
        Tue, 18 Oct 2022 04:05:30 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ajones@ventanamicro.com,
        pbonzini@redhat.com, maz@kernel.org, shuah@kernel.org,
        oliver.upton@linux.dev, mail@maciej.szmigiero.name,
        maciej.szmigiero@oracle.com, seanjc@google.com, peterx@redhat.com,
        ricarkol@google.com, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: [PATCH v2 5/6] KVM: selftests: memslot_perf_test: Consolidate memory sizes
Date:   Tue, 18 Oct 2022 12:04:53 +0800
Message-Id: <20221018040454.405719-6-gshan@redhat.com>
In-Reply-To: <20221018040454.405719-1-gshan@redhat.com>
References: <20221018040454.405719-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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

Fix it by passing additional fixed 64KB memory area to various tests. We
also add checks to ensure that none of host/guest page size exceeds 64KB.
After it's applied, the following command works fine on 64KB-page-size-host
and 4KB-page-size-guest.

  # ./memslot_perf_test -v -s 512

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 15 ++++++++++
 .../testing/selftests/kvm/memslot_perf_test.c | 30 ++++++++++++-------
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index e42a09cd24a0..bd9a19b9054b 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -26,6 +26,21 @@
 
 #define NSEC_PER_SEC 1000000000L
 
+#define SIZE_KiB	(1UL << 10)
+#define SIZE_MiB	(1UL << 20)
+#define SIZE_GiB	(1UL << 30)
+#define SIZE_TiB	(1UL << 40)
+
+/* Base and huge page size */
+#define SIZE_4KiB	(4 * SIZE_KiB)
+#define SIZE_16KiB	(16 * SIZE_KiB)
+#define SIZE_64KiB	(64 * SIZE_KiB)
+#define SIZE_2MiB	(2  * SIZE_MiB)
+#define SIZE_32MiB	(32 * SIZE_MiB)
+#define SIZE_512MiB	(512 * SIZE_MiB)
+#define SIZE_1GiB	(1 * SIZE_GiB)
+#define SIZE_16GiB	(16 * SIZE_GiB)
+
 typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
 typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
 
diff --git a/tools/testing/selftests/kvm/memslot_perf_test.c b/tools/testing/selftests/kvm/memslot_perf_test.c
index 78a481501ec4..3ab385e40bc0 100644
--- a/tools/testing/selftests/kvm/memslot_perf_test.c
+++ b/tools/testing/selftests/kvm/memslot_perf_test.c
@@ -25,12 +25,14 @@
 #include <kvm_util.h>
 #include <processor.h>
 
-#define MEM_SIZE		((512U << 20) + 4096)
-#define MEM_GPA		0x10000000UL
+#define MEM_EXTRA_SIZE		SIZE_64KiB
+
+#define MEM_SIZE		(SIZE_512MiB + MEM_EXTRA_SIZE)
+#define MEM_GPA			(256 * SIZE_MiB)
 #define MEM_AUX_GPA		MEM_GPA
 #define MEM_SYNC_GPA		MEM_AUX_GPA
-#define MEM_TEST_GPA		(MEM_AUX_GPA + 4096)
-#define MEM_TEST_SIZE		(MEM_SIZE - 4096)
+#define MEM_TEST_GPA		(MEM_AUX_GPA + MEM_EXTRA_SIZE)
+#define MEM_TEST_SIZE		(MEM_SIZE - MEM_EXTRA_SIZE)
 
 /*
  * 32 MiB is max size that gets well over 100 iterations on 509 slots.
@@ -38,8 +40,8 @@
  * 8194 slots in use can then be tested (although with slightly
  * limited resolution).
  */
-#define MEM_SIZE_MAP		((32U << 20) + 4096)
-#define MEM_TEST_MAP_SIZE	(MEM_SIZE_MAP - 4096)
+#define MEM_SIZE_MAP		(SIZE_32MiB + MEM_EXTRA_SIZE)
+#define MEM_TEST_MAP_SIZE	(MEM_SIZE_MAP - MEM_EXTRA_SIZE)
 
 /*
  * 128 MiB is min size that fills 32k slots with at least one page in each
@@ -47,8 +49,8 @@
  *
  * 2 MiB chunk size like a typical huge page
  */
-#define MEM_TEST_UNMAP_SIZE		(128U << 20)
-#define MEM_TEST_UNMAP_CHUNK_SIZE	(2U << 20)
+#define MEM_TEST_UNMAP_SIZE		(128 * SIZE_MiB)
+#define MEM_TEST_UNMAP_CHUNK_SIZE	SIZE_2MiB
 
 /*
  * For the move active test the middle of the test area is placed on
@@ -60,7 +62,7 @@
  * last slot contains 100KB memory with the remaining 84KB. Hence,
  * the maximum size is double of that (200KB)
  */
-#define MEM_TEST_MOVE_SIZE		0x32000
+#define MEM_TEST_MOVE_SIZE		(200 * SIZE_KiB)
 #define MEM_TEST_MOVE_GPA_DEST		(MEM_GPA + MEM_SIZE)
 static_assert(MEM_TEST_MOVE_SIZE <= MEM_TEST_SIZE,
 	      "invalid move test region size");
@@ -799,13 +801,13 @@ static const struct test_data tests[] = {
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
@@ -865,8 +867,14 @@ static void help(char *name, struct test_args *targs)
 
 static bool check_memory_sizes(void)
 {
+	uint32_t host_page_size = getpagesize();
 	uint32_t guest_page_size = vm_guest_mode_params[VM_MODE_DEFAULT].page_size;
 
+	if (host_page_size > SIZE_64KiB || guest_page_size > SIZE_64KiB) {
+		pr_info("Unsupported page size on host (0x%x) or guest (0x%x)\n",
+			host_page_size, guest_page_size);
+	}
+
 	if (MEM_SIZE % guest_page_size ||
 	    MEM_TEST_SIZE % guest_page_size) {
 		pr_info("invalid MEM_SIZE or MEM_TEST_SIZE\n");
-- 
2.23.0

