Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2EB9E8BE
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 15:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbfH0NKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 09:10:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38990 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730035AbfH0NKn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 09:10:43 -0400
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3343A182D
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 13:10:42 +0000 (UTC)
Received: by mail-pf1-f197.google.com with SMTP id n186so14602957pfn.6
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 06:10:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9PhF+WzMKEVGVdytBhJDcKZmYrRN4rhUAiWIIAXwSj8=;
        b=NL9cZh6S96hK1t4n/JWBb1HFEsvYVMgG+EdSwRTRSS/4ACXvToWVuacD0tQdzoOK90
         fd1eDAGTBbxQgZFRxupgJaU4af3X68NZwcYTZTZAeNbeckemYCl6ZCK3pgaVBwBGhaAQ
         tYGudrhUFsbOunjdl/c6JNS5IIGwB7hDFhrcfumpbr4VVFt1NOx7szl7sh8YxV2nyMAq
         YxUIunfRLKpKZEpOeYaLuQUT0cbhTmk/VY6uE2iKj5Fx5QpDIkzvr9qrYJGmVpYeien2
         WRCPLri785qq4GOOrN7oL7MJRkhelhxh45EOoQ5qWc2EWlxS+7hxUpD+kVr/zF+RWtBo
         kxwQ==
X-Gm-Message-State: APjAAAVEYn4DqX3anpC8lbeN0k9H/0O2KpYHrLiChdHJj4DPQY3subaR
        s8pXTStX/Z/hL5dMEdIqSyr44OvFBvm/WCfRqkVBdjXEBKZSvLRqWqCDv3k7D0aJJhmS23tjnuD
        ZYmLvtNcKXguF
X-Received: by 2002:aa7:920b:: with SMTP id 11mr12173425pfo.231.1566911441030;
        Tue, 27 Aug 2019 06:10:41 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxl4ndWKGKKVsD40EsTAmc/7MTedBGO77V4mmisEM/IW00P/JOhZNRtHu1/CCMcRt62+TxhzQ==
X-Received: by 2002:aa7:920b:: with SMTP id 11mr12173396pfo.231.1566911440783;
        Tue, 27 Aug 2019 06:10:40 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o67sm24393050pfb.39.2019.08.27.06.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2019 06:10:40 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>, peterx@redhat.com
Subject: [PATCH 3/4] KVM: selftests: Introduce VM_MODE_PXXV48_4K
Date:   Tue, 27 Aug 2019 21:10:14 +0800
Message-Id: <20190827131015.21691-4-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190827131015.21691-1-peterx@redhat.com>
References: <20190827131015.21691-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The naming VM_MODE_P52V48_4K is explicit but unclear when used on
x86_64 machines, because x86_64 machines are having various physical
address width rather than some static values.  Here's some examples:

  - Intel Xeon E3-1220:  36 bits
  - Intel Core i7-8650:  39 bits
  - AMD   EPYC 7251:     48 bits

All of them are using 48 bits linear address width but with totally
different physical address width (and most of the old machines should
be less than 52 bits).

Let's create a new guest mode called VM_MODE_PXXV48_4K for current
x86_64 tests and make it as the default to replace the old naming of
VM_MODE_P52V48_4K because it shows more clearly that the PA width is
not really a constant.  Meanwhile we also stop assuming all the x86
machines are having 52 bits PA width but instead we fetch the real
vm->pa_bits from CPUID 0x80000008 during runtime.

We currently make this exclusively used by x86_64 but no other arch.

As a slight touch up, moving DEBUG macro from dirty_log_test.c to
kvm_util.h so lib can use it too.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c  |  5 +--
 .../testing/selftests/kvm/include/kvm_util.h  | 11 ++++-
 .../selftests/kvm/lib/aarch64/processor.c     |  3 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 40 ++++++++++++++++---
 .../selftests/kvm/lib/x86_64/processor.c      |  8 ++--
 5 files changed, 53 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 040952f3d4ad..b2e07a3173b2 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -19,8 +19,6 @@
 #include "kvm_util.h"
 #include "processor.h"
 
-#define DEBUG printf
-
 #define VCPU_ID				1
 
 /* The memory slot index to track dirty pages */
@@ -290,6 +288,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 
 	switch (mode) {
 	case VM_MODE_P52V48_4K:
+	case VM_MODE_PXXV48_4K:
 		guest_pa_bits = 52;
 		guest_page_shift = 12;
 		break;
@@ -489,7 +488,7 @@ int main(int argc, char *argv[])
 #endif
 
 #ifdef __x86_64__
-	vm_guest_mode_params_init(VM_MODE_P52V48_4K, true, true);
+	vm_guest_mode_params_init(VM_MODE_PXXV48_4K, true, true);
 #endif
 #ifdef __aarch64__
 	vm_guest_mode_params_init(VM_MODE_P40V48_4K, true, true);
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index cfc079f20815..1c700c6b31b5 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -24,6 +24,8 @@ struct kvm_vm;
 typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
 typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
 
+#define DEBUG printf
+
 /* Minimum allocated guest virtual and physical addresses */
 #define KVM_UTIL_MIN_VADDR		0x2000
 
@@ -38,12 +40,19 @@ enum vm_guest_mode {
 	VM_MODE_P48V48_64K,
 	VM_MODE_P40V48_4K,
 	VM_MODE_P40V48_64K,
+	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
 	NUM_VM_MODES,
 };
 
 #ifdef __aarch64__
 #define VM_MODE_DEFAULT VM_MODE_P40V48_4K
-#else
+#endif
+
+#ifdef __x86_64__
+#define VM_MODE_DEFAULT VM_MODE_PXXV48_4K
+#endif
+
+#ifndef VM_MODE_DEFAULT
 #define VM_MODE_DEFAULT VM_MODE_P52V48_4K
 #endif
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 486400a97374..86036a59a668 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -264,6 +264,9 @@ void aarch64_vcpu_setup(struct kvm_vm *vm, int vcpuid, struct kvm_vcpu_init *ini
 	case VM_MODE_P52V48_4K:
 		TEST_ASSERT(false, "AArch64 does not support 4K sized pages "
 				   "with 52-bit physical address ranges");
+	case VM_MODE_PXXV48_4K:
+		TEST_ASSERT(false, "AArch64 does not support 4K sized pages "
+				   "with ANY-bit physical address ranges");
 	case VM_MODE_P52V48_64K:
 		tcr_el1 |= 1ul << 14; /* TG0 = 64KB */
 		tcr_el1 |= 6ul << 32; /* IPS = 52 bits */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 0c7c4368bc14..8c6f872a8793 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -8,6 +8,7 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "kvm_util_internal.h"
+#include "processor.h"
 
 #include <assert.h>
 #include <sys/mman.h>
@@ -101,12 +102,13 @@ static void vm_open(struct kvm_vm *vm, int perm)
 }
 
 const char * const vm_guest_mode_string[] = {
-	"PA-bits:52, VA-bits:48, 4K pages",
-	"PA-bits:52, VA-bits:48, 64K pages",
-	"PA-bits:48, VA-bits:48, 4K pages",
-	"PA-bits:48, VA-bits:48, 64K pages",
-	"PA-bits:40, VA-bits:48, 4K pages",
-	"PA-bits:40, VA-bits:48, 64K pages",
+	"PA-bits:52,  VA-bits:48, 4K pages",
+	"PA-bits:52,  VA-bits:48, 64K pages",
+	"PA-bits:48,  VA-bits:48, 4K pages",
+	"PA-bits:48,  VA-bits:48, 64K pages",
+	"PA-bits:40,  VA-bits:48, 4K pages",
+	"PA-bits:40,  VA-bits:48, 64K pages",
+	"PA-bits:ANY, VA-bits:48, 4K pages",
 };
 _Static_assert(sizeof(vm_guest_mode_string)/sizeof(char *) == NUM_VM_MODES,
 	       "Missing new mode strings?");
@@ -185,6 +187,32 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages,
 		vm->page_size = 0x10000;
 		vm->page_shift = 16;
 		break;
+	case VM_MODE_PXXV48_4K:
+#ifdef __x86_64__
+		{
+			struct kvm_cpuid_entry2 *entry;
+
+			/* SDM 4.1.4 */
+			entry = kvm_get_supported_cpuid_entry(0x80000008);
+			if (entry) {
+				vm->pa_bits = entry->eax & 0xff;
+				vm->va_bits = (entry->eax >> 8) & 0xff;
+			} else {
+				vm->pa_bits = vm->va_bits = 32;
+			}
+			TEST_ASSERT(vm->va_bits == 48, "Linear address width "
+				    "(%d bits) not supported", vm->va_bits);
+			vm->pgtable_levels = 4;
+			vm->page_size = 0x1000;
+			vm->page_shift = 12;
+			DEBUG("Guest physical address width detected: %d\n",
+			      vm->pa_bits);
+		}
+#else
+		TEST_ASSERT(false, "VM_MODE_PXXV48_4K not supported on "
+			    "non-x86 platforms");
+#endif
+		break;
 	default:
 		TEST_ASSERT(false, "Unknown guest mode, mode: 0x%x", mode);
 	}
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 6cb34a0fa200..eb750ee24d2e 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -228,7 +228,7 @@ void sregs_dump(FILE *stream, struct kvm_sregs *sregs,
 
 void virt_pgd_alloc(struct kvm_vm *vm, uint32_t pgd_memslot)
 {
-	TEST_ASSERT(vm->mode == VM_MODE_P52V48_4K, "Attempt to use "
+	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
 		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
 
 	/* If needed, create page map l4 table. */
@@ -261,7 +261,7 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	uint16_t index[4];
 	struct pageMapL4Entry *pml4e;
 
-	TEST_ASSERT(vm->mode == VM_MODE_P52V48_4K, "Attempt to use "
+	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
 		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
 
 	TEST_ASSERT((vaddr % vm->page_size) == 0,
@@ -547,7 +547,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	struct pageDirectoryEntry *pde;
 	struct pageTableEntry *pte;
 
-	TEST_ASSERT(vm->mode == VM_MODE_P52V48_4K, "Attempt to use "
+	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
 		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
 
 	index[0] = (gva >> 12) & 0x1ffu;
@@ -621,7 +621,7 @@ static void vcpu_setup(struct kvm_vm *vm, int vcpuid, int pgd_memslot, int gdt_m
 	kvm_setup_gdt(vm, &sregs.gdt, gdt_memslot, pgd_memslot);
 
 	switch (vm->mode) {
-	case VM_MODE_P52V48_4K:
+	case VM_MODE_PXXV48_4K:
 		sregs.cr0 = X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
 		sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
 		sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
-- 
2.21.0

