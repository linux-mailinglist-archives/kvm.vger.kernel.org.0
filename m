Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F222A6F98
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 22:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732114AbgKDVYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 16:24:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60035 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732110AbgKDVYj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 16:24:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604525077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gwVbUB2HzUIWHEqhXwEt7jlNke8HHA1zqk/x2+KYQVk=;
        b=GCd/QslBighjGrnCj5hjbf275sUTvuBkk8sRpNjD3KkKqxyLekXu9RSbVS0rToB7yPrgts
        Y2AJkT3sIpMru9HziswL8O0Oq8O1ZZF+99Cg7qwCvGqsU/pPRvDao2WW0S+M+jMngfhdQW
        DLbkq6+C4lGt9a9cfxJVbUlrPey+Jo0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-UAYa3vhqOjiJkd_Nj1oPtA-1; Wed, 04 Nov 2020 16:24:34 -0500
X-MC-Unique: UAYa3vhqOjiJkd_Nj1oPtA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1C501842147;
        Wed,  4 Nov 2020 21:24:32 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B89C35DA6B;
        Wed,  4 Nov 2020 21:24:28 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        bgardon@google.com, peterx@redhat.com
Subject: [PATCH 09/11] KVM: selftests: Make vm_create_default common
Date:   Wed,  4 Nov 2020 22:23:55 +0100
Message-Id: <20201104212357.171559-10-drjones@redhat.com>
In-Reply-To: <20201104212357.171559-1-drjones@redhat.com>
References: <20201104212357.171559-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The code is almost 100% the same anyway. Just move it to common
and add a few arch-specific helpers.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/include/aarch64/processor.h |  3 ++
 .../selftests/kvm/include/s390x/processor.h   |  4 +++
 .../selftests/kvm/include/x86_64/processor.h  |  4 +++
 .../selftests/kvm/lib/aarch64/processor.c     | 17 ----------
 tools/testing/selftests/kvm/lib/kvm_util.c    | 26 +++++++++++++++
 .../selftests/kvm/lib/s390x/processor.c       | 22 -------------
 .../selftests/kvm/lib/x86_64/processor.c      | 32 -------------------
 7 files changed, 37 insertions(+), 71 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index b7fa0c8551db..5e5849cdd115 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -9,6 +9,9 @@
 
 #include "kvm_util.h"
 
+#define PTRS_PER_PAGE(page_size)	((page_size) / 8)
+#define min_page_size()			(4096)
+#define min_page_shift()		(12)
 
 #define ARM64_CORE_REG(x) (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
 			   KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
diff --git a/tools/testing/selftests/kvm/include/s390x/processor.h b/tools/testing/selftests/kvm/include/s390x/processor.h
index e0e96a5f608c..0952f53c538b 100644
--- a/tools/testing/selftests/kvm/include/s390x/processor.h
+++ b/tools/testing/selftests/kvm/include/s390x/processor.h
@@ -5,6 +5,10 @@
 #ifndef SELFTEST_KVM_PROCESSOR_H
 #define SELFTEST_KVM_PROCESSOR_H
 
+#define PTRS_PER_PAGE(page_size)	((page_size) / 8)
+#define min_page_size()			(4096)
+#define min_page_shift()		(12)
+
 /* Bits in the region/segment table entry */
 #define REGION_ENTRY_ORIGIN	~0xfffUL /* region/segment table origin	   */
 #define REGION_ENTRY_PROTECT	0x200	 /* region protection bit	   */
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 82b7fe16a824..7f1fc597ed54 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -13,6 +13,10 @@
 
 #include <asm/msr-index.h>
 
+#define PTRS_PER_PAGE(page_size)	((page_size) / 8)
+#define min_page_size()			(4096)
+#define min_page_shift()		(12)
+
 #define X86_EFLAGS_FIXED	 (1u << 1)
 
 #define X86_CR4_VME		(1ul << 0)
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 2afa6618b396..da90e5a17d3a 100644
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
index b9943e935dc7..0d9d2242af2e 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2018, Google LLC.
  */
 
+#define _GNU_SOURCE /* for program_invocation_name */
 #include "test_util.h"
 #include "kvm_util.h"
 #include "kvm_util_internal.h"
@@ -243,6 +244,31 @@ struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
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
+	uint64_t extra_pg_pages = (extra_mem_pages / PTRS_PER_PAGE(min_page_size())) * 2;
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
index a88c5d665725..1c28e0ee75f2 100644
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
index f6eb34eaa0d2..835909b6038e 100644
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
@@ -721,36 +719,6 @@ void vcpu_set_cpuid(struct kvm_vm *vm,
 
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

