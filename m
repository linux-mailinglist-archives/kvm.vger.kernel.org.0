Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF562AF08B
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 13:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgKKM05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 07:26:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46944 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726514AbgKKM04 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Nov 2020 07:26:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605097613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uw97qBtbEfC7TKTCSGwlrqn4AkauGHUs+g14D/LwhQs=;
        b=LcnDLIbxSF9IDUIbS7atjmPzeklPa9bsLWfDr4CMzH1lkwlVagep3pUWj4q0WMRwkHcsA3
        7L+Q4xNIQpyE5d357YfbrThSPtuecCK96Z5Ax/yZ9i5VfQk2/N+uB3fUBkwZiBosBMEbeo
        bYE5STloo2hw/cQxl7v+7XQfYT0ZTZc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-VPLirjQMNCGQ7Zkqc4swxg-1; Wed, 11 Nov 2020 07:26:52 -0500
X-MC-Unique: VPLirjQMNCGQ7Zkqc4swxg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5891C80364D;
        Wed, 11 Nov 2020 12:26:51 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71E2410013BD;
        Wed, 11 Nov 2020 12:26:49 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH v2 04/11] KVM: selftests: Make vm_create_default common
Date:   Wed, 11 Nov 2020 13:26:29 +0100
Message-Id: <20201111122636.73346-5-drjones@redhat.com>
In-Reply-To: <20201111122636.73346-1-drjones@redhat.com>
References: <20201111122636.73346-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The code is almost 100% the same anyway. Just move it to common
and add a few arch-specific macros.

Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  | 23 ++++++++++---
 .../selftests/kvm/lib/aarch64/processor.c     | 17 ----------
 tools/testing/selftests/kvm/lib/kvm_util.c    | 26 +++++++++++++++
 .../selftests/kvm/lib/s390x/processor.c       | 22 -------------
 .../selftests/kvm/lib/x86_64/processor.c      | 32 -------------------
 5 files changed, 45 insertions(+), 75 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 7d29aa786959..48b48a0014e2 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -45,13 +45,28 @@ enum vm_guest_mode {
 };
 
 #if defined(__aarch64__)
-#define VM_MODE_DEFAULT VM_MODE_P40V48_4K
+
+#define VM_MODE_DEFAULT			VM_MODE_P40V48_4K
+#define MIN_PAGE_SHIFT			12U
+#define ptes_per_page(page_size)	((page_size) / 8)
+
 #elif defined(__x86_64__)
-#define VM_MODE_DEFAULT VM_MODE_PXXV48_4K
-#else
-#define VM_MODE_DEFAULT VM_MODE_P52V48_4K
+
+#define VM_MODE_DEFAULT			VM_MODE_PXXV48_4K
+#define MIN_PAGE_SHIFT			12U
+#define ptes_per_page(page_size)	((page_size) / 8)
+
+#elif defined(__s390x__)
+
+#define VM_MODE_DEFAULT			VM_MODE_P52V48_4K
+#define MIN_PAGE_SHIFT			12U
+#define ptes_per_page(page_size)	((page_size) / 16)
+
 #endif
 
+#define MIN_PAGE_SIZE		(1U << MIN_PAGE_SHIFT)
+#define PTES_PER_MIN_PAGE	ptes_per_page(MIN_PAGE_SIZE)
+
 #define vm_guest_mode_string(m) vm_guest_mode_string[m]
 extern const char * const vm_guest_mode_string[];
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index d6c32c328e9a..cee92d477dc0 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -5,8 +5,6 @@
  * Copyright (C) 2018, Red Hat, Inc.
  */
 
-#define _GNU_SOURCE /* for program_invocation_name */
-
 #include <linux/compiler.h>
 
 #include "kvm_util.h"
@@ -219,21 +217,6 @@ void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	}
 }
 
-struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
-				 void *guest_code)
-{
-	uint64_t ptrs_per_4k_pte = 512;
-	uint64_t extra_pg_pages = (extra_mem_pages / ptrs_per_4k_pte) * 2;
-	struct kvm_vm *vm;
-
-	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
-
-	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
-	vm_vcpu_add_default(vm, vcpuid, guest_code);
-
-	return vm;
-}
-
 void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *init)
 {
 	struct kvm_vcpu_init default_init = { .target = -1, };
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 126c6727a6b0..a7e28e33fc3b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2018, Google LLC.
  */
 
+#define _GNU_SOURCE /* for program_invocation_name */
 #include "test_util.h"
 #include "kvm_util.h"
 #include "kvm_util_internal.h"
@@ -271,6 +272,31 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 	return vm;
 }
 
+struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
+				 void *guest_code)
+{
+	/* The maximum page table size for a memory region will be when the
+	 * smallest pages are used. Considering each page contains x page
+	 * table descriptors, the total extra size for page tables (for extra
+	 * N pages) will be: N/x+N/x^2+N/x^3+... which is definitely smaller
+	 * than N/x*2.
+	 */
+	uint64_t extra_pg_pages = (extra_mem_pages / PTES_PER_MIN_PAGE) * 2;
+	struct kvm_vm *vm;
+
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
+
+	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
+
+#ifdef __x86_64__
+	vm_create_irqchip(vm);
+#endif
+
+	vm_vcpu_add_default(vm, vcpuid, guest_code);
+
+	return vm;
+}
+
 /*
  * VM Restart
  *
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index 7349bb2e1a24..0152f356c099 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -5,8 +5,6 @@
  * Copyright (C) 2019, Red Hat, Inc.
  */
 
-#define _GNU_SOURCE /* for program_invocation_name */
-
 #include "processor.h"
 #include "kvm_util.h"
 #include "../kvm_util_internal.h"
@@ -160,26 +158,6 @@ void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	virt_dump_region(stream, vm, indent, vm->pgd);
 }
 
-struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
-				 void *guest_code)
-{
-	/*
-	 * The additional amount of pages required for the page tables is:
-	 * 1 * n / 256 + 4 * (n / 256) / 2048 + 4 * (n / 256) / 2048^2 + ...
-	 * which is definitely smaller than (n / 256) * 2.
-	 */
-	uint64_t extra_pg_pages = extra_mem_pages / 256 * 2;
-	struct kvm_vm *vm;
-
-	vm = vm_create(VM_MODE_DEFAULT,
-		       DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDWR);
-
-	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
-	vm_vcpu_add_default(vm, vcpuid, guest_code);
-
-	return vm;
-}
-
 void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 {
 	size_t stack_size =  DEFAULT_STACK_PGS * getpagesize();
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index d10c5c05bdf0..95e1a757c629 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -5,8 +5,6 @@
  * Copyright (C) 2018, Google LLC.
  */
 
-#define _GNU_SOURCE /* for program_invocation_name */
-
 #include "test_util.h"
 #include "kvm_util.h"
 #include "../kvm_util_internal.h"
@@ -731,36 +729,6 @@ void vcpu_set_cpuid(struct kvm_vm *vm,
 
 }
 
-struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
-				 void *guest_code)
-{
-	struct kvm_vm *vm;
-	/*
-	 * For x86 the maximum page table size for a memory region
-	 * will be when only 4K pages are used.  In that case the
-	 * total extra size for page tables (for extra N pages) will
-	 * be: N/512+N/512^2+N/512^3+... which is definitely smaller
-	 * than N/512*2.
-	 */
-	uint64_t extra_pg_pages = extra_mem_pages / 512 * 2;
-
-	/* Create VM */
-	vm = vm_create(VM_MODE_DEFAULT,
-		       DEFAULT_GUEST_PHY_PAGES + extra_pg_pages,
-		       O_RDWR);
-
-	/* Setup guest code */
-	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
-
-	/* Setup IRQ Chip */
-	vm_create_irqchip(vm);
-
-	/* Add the first vCPU. */
-	vm_vcpu_add_default(vm, vcpuid, guest_code);
-
-	return vm;
-}
-
 /*
  * VCPU Get MSR
  *
-- 
2.26.2

