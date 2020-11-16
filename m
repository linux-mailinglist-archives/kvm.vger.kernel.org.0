Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9316F2B438B
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 13:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbgKPMUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 07:20:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59121 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727027AbgKPMUA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 07:20:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605529199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O1VS2BHZgYsg5NpOrLKMKTwdQceFNehI3Uj6biWkzsU=;
        b=iQre191KEn17u1TtrLgAZKEeK6Axn/gvv4Z86XfSh/MqBgv+GVf6P4Yd1d2EUNJQWCb0Lx
        qunlSuSQRE9eeUcx+n1WzBfFkq1pi6/wovuyQiI3Nqo2kaRj76sYZV1jRni9xDLmCNQVRG
        d3/ShWRZdvzqPF0R2IIoqvuUY6KGHLI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-rSeSNpgdMACjqnA4UUBUlA-1; Mon, 16 Nov 2020 07:19:57 -0500
X-MC-Unique: rSeSNpgdMACjqnA4UUBUlA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DD44186DD21;
        Mon, 16 Nov 2020 12:19:56 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B29560BF1;
        Mon, 16 Nov 2020 12:19:51 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH v3 2/4] KVM: selftests: dirty_log_test: Remove create_vm
Date:   Mon, 16 Nov 2020 13:19:40 +0100
Message-Id: <20201116121942.55031-3-drjones@redhat.com>
In-Reply-To: <20201116121942.55031-1-drjones@redhat.com>
References: <20201116121942.55031-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vm_create_with_vcpus instead of create_vm and do
some minor cleanups around it.

Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 56 ++++++--------------
 1 file changed, 16 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index bb2752d78fe3..5af730deb86b 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -5,8 +5,6 @@
  * Copyright (C) 2018, Red Hat, Inc.
  */
 
-#define _GNU_SOURCE /* for program_invocation_name */
-
 #include <stdio.h>
 #include <stdlib.h>
 #include <pthread.h>
@@ -25,6 +23,9 @@
 
 #define VCPU_ID				1
 
+#define DIRTY_MEM_BITS			30 /* 1G */
+#define DIRTY_MEM_SIZE			(1UL << DIRTY_MEM_BITS)
+
 /* The memory slot index to track dirty pages */
 #define TEST_MEM_SLOT_INDEX		1
 
@@ -651,27 +652,6 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 	}
 }
 
-static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
-				uint64_t extra_mem_pages, void *guest_code)
-{
-	struct kvm_vm *vm;
-	uint64_t extra_pg_pages = extra_mem_pages / 512 * 2;
-
-	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
-
-	vm = vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
-	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
-#ifdef __x86_64__
-	vm_create_irqchip(vm);
-#endif
-	log_mode_create_vm_done(vm);
-	vm_vcpu_add_default(vm, vcpuid, guest_code);
-	return vm;
-}
-
-#define DIRTY_MEM_BITS 30 /* 1G */
-#define PAGE_SHIFT_4K  12
-
 struct test_params {
 	unsigned long iterations;
 	unsigned long interval;
@@ -690,43 +670,39 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		return;
 	}
 
+	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
+
 	/*
 	 * We reserve page table for 2 times of extra dirty mem which
-	 * will definitely cover the original (1G+) test range.  Here
-	 * we do the calculation with 4K page size which is the
-	 * smallest so the page number will be enough for all archs
-	 * (e.g., 64K page size guest will need even less memory for
-	 * page tables).
+	 * will definitely cover the original (1G+) test range.
 	 */
-	vm = create_vm(mode, VCPU_ID,
-		       2ul << (DIRTY_MEM_BITS - PAGE_SHIFT_4K),
-		       guest_code);
+	vm = vm_create_with_vcpus(mode, 1,
+			vm_calc_num_guest_pages(mode, DIRTY_MEM_SIZE * 2),
+			0, guest_code, (uint32_t []){ VCPU_ID });
+
+	log_mode_create_vm_done(vm);
 
 	guest_page_size = vm_get_page_size(vm);
+	host_page_size = getpagesize();
+
 	/*
 	 * A little more than 1G of guest page sized pages.  Cover the
 	 * case where the size is not aligned to 64 pages.
 	 */
-	guest_num_pages = (1ul << (DIRTY_MEM_BITS -
-				   vm_get_page_shift(vm))) + 3;
-	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
-
-	host_page_size = getpagesize();
+	guest_num_pages = vm_adjust_num_guest_pages(mode,
+				(1ul << (DIRTY_MEM_BITS - vm_get_page_shift(vm))) + 3);
 	host_num_pages = vm_num_host_pages(mode, guest_num_pages);
 
 	if (!p->phys_offset) {
-		guest_test_phys_mem = (vm_get_max_gfn(vm) -
-				       guest_num_pages) * guest_page_size;
+		guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) * guest_page_size;
 		guest_test_phys_mem &= ~(host_page_size - 1);
 	} else {
 		guest_test_phys_mem = p->phys_offset;
 	}
-
 #ifdef __s390x__
 	/* Align to 1M (segment size) */
 	guest_test_phys_mem &= ~((1 << 20) - 1);
 #endif
-
 	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
 
 	bmap = bitmap_alloc(host_num_pages);
-- 
2.26.2

