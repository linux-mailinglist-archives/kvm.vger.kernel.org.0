Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0862AE0FF
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 21:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgKJUso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 15:48:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34200 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731696AbgKJUsg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Nov 2020 15:48:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605041315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I4kBWefGLmHDX26EApVEWDyVEAim2VaKPsFVtTF5ano=;
        b=QuazOqzBVYwpVLhynQBC4rOxVMGnVSzJeukEqIyPC0iXbH5QbUqEE2yqT+f4BtlpD+40xn
        WyLtXoHsxl2PLiLS58M+ZFZ5pkm4g9PEe8g8RUY65BVYE7EawHzipII5j19tWSpKSfIWDI
        OaR92cCo/S+N7BdSZjia+wDfj5qcY1U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-546-3gZpD50zN7qeLvYM_8zGTg-1; Tue, 10 Nov 2020 15:48:33 -0500
X-MC-Unique: 3gZpD50zN7qeLvYM_8zGTg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C9C31074655;
        Tue, 10 Nov 2020 20:48:32 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82B2D1002C32;
        Tue, 10 Nov 2020 20:48:21 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH 6/8] KVM: selftests: dirty_log_test: Remove create_vm
Date:   Tue, 10 Nov 2020 21:48:00 +0100
Message-Id: <20201110204802.417521-7-drjones@redhat.com>
In-Reply-To: <20201110204802.417521-1-drjones@redhat.com>
References: <20201110204802.417521-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use vm_create_with_vcpus instead of create_vm and do
some minor cleanups around it.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 56 ++++++--------------
 1 file changed, 16 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 1b7375d2acea..2e0dcd453ef0 100644
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
@@ -20,6 +18,9 @@
 
 #define VCPU_ID				1
 
+#define DIRTY_MEM_BITS			30 /* 1G */
+#define DIRTY_MEM_SIZE			(1UL << 30)
+
 /* The memory slot index to track dirty pages */
 #define TEST_MEM_SLOT_INDEX		1
 
@@ -353,27 +354,6 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
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
@@ -393,43 +373,39 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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

