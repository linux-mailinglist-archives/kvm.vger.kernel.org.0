Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D7B53C1ED
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240181AbiFCAo7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240037AbiFCAoW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:22 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BED53465E
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:44:14 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id lk16-20020a17090b33d000b001e68a9ac3a1so1807726pjb.2
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=rtTFGDyz/q8Y5NWxrcS4bYZ0DlnGrwIoWlUoM/5g01I=;
        b=gyIXPhPoIYKMp0MOhikP2eG1qFVSum9UCkYfXVUScUtD4l0pf/fmsuNsqdd0ZP6eYI
         nT49cXLdsBWs6BiMKuKBIyDnlHSVmZUB0i3Xt2TlZ80zFGBmiLuvCRQIDY+QTST7k/+n
         W1JtovkKLSEYS8r4jmvCwGcTfzcy2kdGxZfcmgpqcc9fC6ErzunKTBfXR64nQjI32gok
         o+4LfbKTBB20QojU6eL6XTBqEUFOJOuAoq3g0CxzgkHZIjv6UecgmcmiAjodnjGeuBt4
         ovgxizXBWBWnd6aULuitT5grKSSyOKKqMwiF2TSaEvuO6aMh8MMDsP+Tbd54goCqaNMV
         bLPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=rtTFGDyz/q8Y5NWxrcS4bYZ0DlnGrwIoWlUoM/5g01I=;
        b=ZDhWVtCdJe/Blia0gKloxu2YAa/UFVxi579xORYXhsnF+WmWL/xKw0OssB+BA/8OhG
         QsRPdWVIjDKXTL2zSA46vulXJgbXdHCLK6v0UCiiEx77QrIXPpR5MkPnvOLTg5VVNnvz
         b4B7DHX53DgG/sP//tIVKg1rQf4XZ7x6h+2bESzPO/zOy9NDLeg35aycwVsqBR1VdTkV
         rQk2CJYI+5/5YdAQU3D2eS9RUaEtHciSQo6krELDH55gkWVTGExNXQnlREEw0WhvBimK
         rTexQTkX/b+PGcA9OK/yWXBuwnKfruxQkJCjDoG3+yxEmr6vjW4jeE+PfAQIDt8sSTsA
         oYSQ==
X-Gm-Message-State: AOAM533s3f5d9J2iZ1R4zJ2Al7/slvpbK/h+zHBqOUt13WKx0b5ILGLN
        eLfMIvH0L8Ipy5nUkEg6KIttGCdxn8U=
X-Google-Smtp-Source: ABdhPJxjHa+98iRwt/CT1D/OXvOix+sswXN8vidJr9Ob1D1jCiCbVbY5of+PXl2z8AabMqPmTadCnn9NRqA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:d4d1:b0:166:3bff:4479 with SMTP id
 o17-20020a170902d4d100b001663bff4479mr7160432plg.161.1654217053784; Thu, 02
 Jun 2022 17:44:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:28 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-22-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 021/144] KVM: selftests: Get rid of kvm_util_internal.h
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fold kvm_util_internal.h into kvm_util_base.h, i.e. make all KVM utility
stuff "public".  Hiding struct implementations from tests has been a
massive failure, as it has led to pointless and poorly named wrappers,
unnecessarily opaque code, etc...

Not to mention that the approach was a complete failure as evidenced by
the non-zero number of tests that were including kvm_util_internal.h.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 99 +++++++++++++++++--
 .../selftests/kvm/lib/aarch64/processor.c     |  1 -
 .../testing/selftests/kvm/lib/aarch64/ucall.c |  1 -
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |  1 -
 tools/testing/selftests/kvm/lib/elf.c         |  1 -
 tools/testing/selftests/kvm/lib/kvm_util.c    |  1 -
 .../selftests/kvm/lib/kvm_util_internal.h     | 94 ------------------
 .../selftests/kvm/lib/riscv/processor.c       |  1 -
 tools/testing/selftests/kvm/lib/riscv/ucall.c |  1 -
 .../selftests/kvm/lib/s390x/processor.c       |  1 -
 .../selftests/kvm/lib/x86_64/processor.c      |  1 -
 tools/testing/selftests/kvm/lib/x86_64/svm.c  |  1 -
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  1 -
 .../kvm/x86_64/max_vcpuid_cap_test.c          |  1 -
 .../selftests/kvm/x86_64/sev_migrate_tests.c  |  1 -
 .../kvm/x86_64/svm_nested_soft_inject_test.c  |  1 -
 16 files changed, 91 insertions(+), 116 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/lib/kvm_util_internal.h

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index f5bfdf0b4548..c0199f3b59bb 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -9,9 +9,13 @@
 
 #include "test_util.h"
 
-#include "asm/kvm.h"
+#include <linux/compiler.h>
+#include "linux/hashtable.h"
 #include "linux/list.h"
-#include "linux/kvm.h"
+#include <linux/kernel.h>
+#include <linux/kvm.h>
+#include "linux/rbtree.h"
+
 #include <sys/ioctl.h>
 
 #include "sparsebit.h"
@@ -21,15 +25,94 @@
 
 #define NSEC_PER_SEC 1000000000L
 
-/*
- * Callers of kvm_util only have an incomplete/opaque description of the
- * structure kvm_util is using to maintain the state of a VM.
- */
-struct kvm_vm;
-
 typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
 typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
 
+struct userspace_mem_region {
+	struct kvm_userspace_memory_region region;
+	struct sparsebit *unused_phy_pages;
+	int fd;
+	off_t offset;
+	void *host_mem;
+	void *host_alias;
+	void *mmap_start;
+	void *mmap_alias;
+	size_t mmap_size;
+	struct rb_node gpa_node;
+	struct rb_node hva_node;
+	struct hlist_node slot_node;
+};
+
+struct vcpu {
+	struct list_head list;
+	uint32_t id;
+	int fd;
+	struct kvm_run *state;
+	struct kvm_dirty_gfn *dirty_gfns;
+	uint32_t fetch_index;
+	uint32_t dirty_gfns_count;
+};
+
+struct userspace_mem_regions {
+	struct rb_root gpa_tree;
+	struct rb_root hva_tree;
+	DECLARE_HASHTABLE(slot_hash, 9);
+};
+
+struct kvm_vm {
+	int mode;
+	unsigned long type;
+	int kvm_fd;
+	int fd;
+	unsigned int pgtable_levels;
+	unsigned int page_size;
+	unsigned int page_shift;
+	unsigned int pa_bits;
+	unsigned int va_bits;
+	uint64_t max_gfn;
+	struct list_head vcpus;
+	struct userspace_mem_regions regions;
+	struct sparsebit *vpages_valid;
+	struct sparsebit *vpages_mapped;
+	bool has_irqchip;
+	bool pgd_created;
+	vm_paddr_t pgd;
+	vm_vaddr_t gdt;
+	vm_vaddr_t tss;
+	vm_vaddr_t idt;
+	vm_vaddr_t handlers;
+	uint32_t dirty_ring_size;
+};
+
+
+#define kvm_for_each_vcpu(vm, i, vcpu)			\
+	for ((i) = 0; (i) <= (vm)->last_vcpu_id; (i)++)	\
+		if (!((vcpu) = vm->vcpus[i]))		\
+			continue;			\
+		else
+
+struct vcpu *vcpu_get(struct kvm_vm *vm, uint32_t vcpuid);
+
+/*
+ * Virtual Translation Tables Dump
+ *
+ * Input Args:
+ *   stream - Output FILE stream
+ *   vm     - Virtual Machine
+ *   indent - Left margin indent amount
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Dumps to the FILE stream given by @stream, the contents of all the
+ * virtual translation tables for the VM given by @vm.
+ */
+void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
+
+struct userspace_mem_region *
+memslot2region(struct kvm_vm *vm, uint32_t memslot);
+
 /* Minimum allocated guest virtual and physical addresses */
 #define KVM_UTIL_MIN_VADDR		0x2000
 #define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index d28cc12cea1d..388bd7d87c02 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -10,7 +10,6 @@
 
 #include "guest_modes.h"
 #include "kvm_util.h"
-#include "../kvm_util_internal.h"
 #include "processor.h"
 
 #define DEFAULT_ARM64_GUEST_STACK_VADDR_MIN	0xac0000
diff --git a/tools/testing/selftests/kvm/lib/aarch64/ucall.c b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
index 00be3ef195ca..868ebab5369e 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/ucall.c
@@ -5,7 +5,6 @@
  * Copyright (C) 2018, Red Hat, Inc.
  */
 #include "kvm_util.h"
-#include "../kvm_util_internal.h"
 
 static vm_vaddr_t *ucall_exit_mmio_addr;
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index 25d1ec65621d..c34f0f116f39 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -9,7 +9,6 @@
 #include <asm/kvm.h>
 
 #include "kvm_util.h"
-#include "../kvm_util_internal.h"
 #include "vgic.h"
 #include "gic.h"
 #include "gic_v3.h"
diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
index 13e8e3dcf984..9f54c098d9d0 100644
--- a/tools/testing/selftests/kvm/lib/elf.c
+++ b/tools/testing/selftests/kvm/lib/elf.c
@@ -11,7 +11,6 @@
 #include <linux/elf.h>
 
 #include "kvm_util.h"
-#include "kvm_util_internal.h"
 
 static void elfhdr_get(const char *filename, Elf64_Ehdr *hdrp)
 {
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index c7df8ba04ec5..a57958a39c1b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -8,7 +8,6 @@
 #define _GNU_SOURCE /* for program_invocation_name */
 #include "test_util.h"
 #include "kvm_util.h"
-#include "kvm_util_internal.h"
 #include "processor.h"
 
 #include <assert.h>
diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
deleted file mode 100644
index 544b90df2f80..000000000000
--- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
+++ /dev/null
@@ -1,94 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * tools/testing/selftests/kvm/lib/kvm_util_internal.h
- *
- * Copyright (C) 2018, Google LLC.
- */
-
-#ifndef SELFTEST_KVM_UTIL_INTERNAL_H
-#define SELFTEST_KVM_UTIL_INTERNAL_H
-
-#include "linux/hashtable.h"
-#include "linux/rbtree.h"
-
-#include "sparsebit.h"
-
-struct userspace_mem_region {
-	struct kvm_userspace_memory_region region;
-	struct sparsebit *unused_phy_pages;
-	int fd;
-	off_t offset;
-	void *host_mem;
-	void *host_alias;
-	void *mmap_start;
-	void *mmap_alias;
-	size_t mmap_size;
-	struct rb_node gpa_node;
-	struct rb_node hva_node;
-	struct hlist_node slot_node;
-};
-
-struct vcpu {
-	struct list_head list;
-	uint32_t id;
-	int fd;
-	struct kvm_run *state;
-	struct kvm_dirty_gfn *dirty_gfns;
-	uint32_t fetch_index;
-	uint32_t dirty_gfns_count;
-};
-
-struct userspace_mem_regions {
-	struct rb_root gpa_tree;
-	struct rb_root hva_tree;
-	DECLARE_HASHTABLE(slot_hash, 9);
-};
-
-struct kvm_vm {
-	int mode;
-	unsigned long type;
-	int kvm_fd;
-	int fd;
-	unsigned int pgtable_levels;
-	unsigned int page_size;
-	unsigned int page_shift;
-	unsigned int pa_bits;
-	unsigned int va_bits;
-	uint64_t max_gfn;
-	struct list_head vcpus;
-	struct userspace_mem_regions regions;
-	struct sparsebit *vpages_valid;
-	struct sparsebit *vpages_mapped;
-	bool has_irqchip;
-	bool pgd_created;
-	vm_paddr_t pgd;
-	vm_vaddr_t gdt;
-	vm_vaddr_t tss;
-	vm_vaddr_t idt;
-	vm_vaddr_t handlers;
-	uint32_t dirty_ring_size;
-};
-
-struct vcpu *vcpu_get(struct kvm_vm *vm, uint32_t vcpuid);
-
-/*
- * Virtual Translation Tables Dump
- *
- * Input Args:
- *   stream - Output FILE stream
- *   vm     - Virtual Machine
- *   indent - Left margin indent amount
- *
- * Output Args: None
- *
- * Return: None
- *
- * Dumps to the FILE stream given by @stream, the contents of all the
- * virtual translation tables for the VM given by @vm.
- */
-void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
-
-struct userspace_mem_region *
-memslot2region(struct kvm_vm *vm, uint32_t memslot);
-
-#endif /* SELFTEST_KVM_UTIL_INTERNAL_H */
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index c89e6b1fbfb1..5ee8250dd74c 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -9,7 +9,6 @@
 #include <assert.h>
 
 #include "kvm_util.h"
-#include "../kvm_util_internal.h"
 #include "processor.h"
 
 #define DEFAULT_RISCV_GUEST_STACK_VADDR_MIN	0xac0000
diff --git a/tools/testing/selftests/kvm/lib/riscv/ucall.c b/tools/testing/selftests/kvm/lib/riscv/ucall.c
index c2ed59f5783d..48d91b77fa1d 100644
--- a/tools/testing/selftests/kvm/lib/riscv/ucall.c
+++ b/tools/testing/selftests/kvm/lib/riscv/ucall.c
@@ -8,7 +8,6 @@
 #include <linux/kvm.h>
 
 #include "kvm_util.h"
-#include "../kvm_util_internal.h"
 #include "processor.h"
 
 void ucall_init(struct kvm_vm *vm, void *arg)
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index 7cc1051c4b71..53c413932f64 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -7,7 +7,6 @@
 
 #include "processor.h"
 #include "kvm_util.h"
-#include "../kvm_util_internal.h"
 
 #define PAGES_PER_REGION 4
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 93726d8cac44..1e3d68bdfc7d 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -7,7 +7,6 @@
 
 #include "test_util.h"
 #include "kvm_util.h"
-#include "../kvm_util_internal.h"
 #include "processor.h"
 
 #ifndef NUM_INTERRUPTS
diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
index 736ee4a23df6..01a9d831da13 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
@@ -9,7 +9,6 @@
 
 #include "test_util.h"
 #include "kvm_util.h"
-#include "../kvm_util_internal.h"
 #include "processor.h"
 #include "svm_util.h"
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index d089d8b850b5..0d42aa821833 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -7,7 +7,6 @@
 
 #include "test_util.h"
 #include "kvm_util.h"
-#include "../kvm_util_internal.h"
 #include "processor.h"
 #include "vmx.h"
 
diff --git a/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c b/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
index e83afd4bb4cf..419fbdc51246 100644
--- a/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
+++ b/tools/testing/selftests/kvm/x86_64/max_vcpuid_cap_test.c
@@ -8,7 +8,6 @@
  */
 
 #include "kvm_util.h"
-#include "../lib/kvm_util_internal.h"
 
 #define MAX_VCPU_ID	2
 
diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index 7424bec5ae23..5b565aa11e32 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -12,7 +12,6 @@
 #include "processor.h"
 #include "svm_util.h"
 #include "kselftest.h"
-#include "../lib/kvm_util_internal.h"
 
 #define SEV_POLICY_ES 0b100
 
diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
index f94f1b449aef..18061677154f 100644
--- a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
+++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
@@ -17,7 +17,6 @@
 #include "processor.h"
 #include "svm_util.h"
 #include "test_util.h"
-#include "../lib/kvm_util_internal.h"
 
 #define VCPU_ID		0
 #define INT_NR			0x20
-- 
2.36.1.255.ge46751e96f-goog

