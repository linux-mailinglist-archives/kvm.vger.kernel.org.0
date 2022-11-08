Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470A462081D
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 05:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbiKHEOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 23:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbiKHEOM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 23:14:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDECD22B3A
        for <kvm@vger.kernel.org>; Mon,  7 Nov 2022 20:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667880791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UeYV9gtrEMC/f2NfGupIKl3UhHTgEqpO1AGhP6jS8dg=;
        b=AxHYCO1yDo08kQIC+4pfEHFsL/bhCj0ybB6P0HJAcQyoNq4TNH0CVeqZSg9G2QWlWexHLu
        0MdlKLDk64ygjO0yOo37hCvjJ/06lvOcGcfvJFhRo9K51EBpGbOR8aEJu1vED/yrX71Zzf
        fLRn3w+dgTySNqki4UopHkT/KByI07A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-OSlo_J59Oe64J_7pXqU6fw-1; Mon, 07 Nov 2022 23:13:03 -0500
X-MC-Unique: OSlo_J59Oe64J_7pXqU6fw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECA04833A0E;
        Tue,  8 Nov 2022 04:13:02 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-78.bne.redhat.com [10.64.54.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D584735429;
        Tue,  8 Nov 2022 04:12:56 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        shuah@kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
        ajones@ventanamicro.com, bgardon@google.com, dmatlack@google.com,
        will@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, maz@kernel.org, peterx@redhat.com,
        oliver.upton@linux.dev, seanjc@google.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com
Subject: [PATCH v9 7/7] KVM: selftests: Automate choosing dirty ring size in dirty_log_test
Date:   Tue,  8 Nov 2022 12:10:39 +0800
Message-Id: <20221108041039.111145-8-gshan@redhat.com>
In-Reply-To: <20221108041039.111145-1-gshan@redhat.com>
References: <20221108041039.111145-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the dirty ring case, we rely on vcpu exit due to full dirty ring
state. On ARM64 system, there are 4096 host pages when the host
page size is 64KB. In this case, the vcpu never exits due to the
full dirty ring state. The similar case is 4KB page size on host
and 64KB page size on guest. The vcpu corrupts same set of host
pages, but the dirty page information isn't collected in the main
thread. This leads to infinite loop as the following log shows.

  # ./dirty_log_test -M dirty-ring -c 65536 -m 5
  Setting log mode to: 'dirty-ring'
  Test iterations: 32, interval: 10 (ms)
  Testing guest mode: PA-bits:40,  VA-bits:48,  4K pages
  guest physical test memory offset: 0xffbffe0000
  vcpu stops because vcpu is kicked out...
  Notifying vcpu to continue
  vcpu continues now.
  Iteration 1 collected 576 pages
  <No more output afterwards>

Fix the issue by automatically choosing the best dirty ring size,
to ensure vcpu exit due to full dirty ring state. The option '-c'
becomes a hint to the dirty ring count, instead of the value of it.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 26 +++++++++++++++++---
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 8758c10ec850..a87e5f78ebf1 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -24,6 +24,9 @@
 #include "guest_modes.h"
 #include "processor.h"
 
+#define DIRTY_MEM_BITS 30 /* 1G */
+#define PAGE_SHIFT_4K  12
+
 /* The memory slot index to track dirty pages */
 #define TEST_MEM_SLOT_INDEX		1
 
@@ -273,6 +276,24 @@ static bool dirty_ring_supported(void)
 
 static void dirty_ring_create_vm_done(struct kvm_vm *vm)
 {
+	uint64_t pages;
+	uint32_t limit;
+
+	/*
+	 * We rely on vcpu exit due to full dirty ring state. Adjust
+	 * the ring buffer size to ensure we're able to reach the
+	 * full dirty ring state.
+	 */
+	pages = (1ul << (DIRTY_MEM_BITS - vm->page_shift)) + 3;
+	pages = vm_adjust_num_guest_pages(vm->mode, pages);
+	if (vm->page_size < getpagesize())
+		pages = vm_num_host_pages(vm->mode, pages);
+
+	limit = 1 << (31 - __builtin_clz(pages));
+	test_dirty_ring_count = 1 << (31 - __builtin_clz(test_dirty_ring_count));
+	test_dirty_ring_count = min(limit, test_dirty_ring_count);
+	pr_info("dirty ring count: 0x%x\n", test_dirty_ring_count);
+
 	/*
 	 * Switch to dirty ring mode after VM creation but before any
 	 * of the vcpu creation.
@@ -685,9 +706,6 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, struct kvm_vcpu **vcpu,
 	return vm;
 }
 
-#define DIRTY_MEM_BITS 30 /* 1G */
-#define PAGE_SHIFT_4K  12
-
 struct test_params {
 	unsigned long iterations;
 	unsigned long interval;
@@ -830,7 +848,7 @@ static void help(char *name)
 	printf("usage: %s [-h] [-i iterations] [-I interval] "
 	       "[-p offset] [-m mode]\n", name);
 	puts("");
-	printf(" -c: specify dirty ring size, in number of entries\n");
+	printf(" -c: hint to dirty ring size, in number of entries\n");
 	printf("     (only useful for dirty-ring test; default: %"PRIu32")\n",
 	       TEST_DIRTY_RING_COUNT);
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
-- 
2.23.0

