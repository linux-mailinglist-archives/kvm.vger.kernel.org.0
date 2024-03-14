Return-Path: <kvm+bounces-11851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE7A287C652
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 00:31:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1985B1F262A6
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 23:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21AFC18028;
	Thu, 14 Mar 2024 23:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KI54MI4w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D62168B9
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 23:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710458807; cv=none; b=bvKjK9nDbxuYh/ssNWpQU4BqlkohU4F7EAgqayRM87FY31kF/r+FCPcxiI+dFZosMNRlruQ2x92dI0b7vsMlKkDUk23nM2NSXzBzssqXjdV752zsRHPXnZFH2YJGJN974IuEKAzeNcuFi83YWVY6//75ADLwdP8jJjgZgI0MoGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710458807; c=relaxed/simple;
	bh=wdHcaBxconB0uak6gvNherFwOSVp9FmYakKe5h3/TJA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QrOLW5DFDWMDsinXi2cSEuJ4oJoygFrR/v9EECjsRQIZqw5AxsVc2PZIQXZYN8+VcfAzfkfRCAbJqTCRmbDMpu/Hpl5HFdD1cziHY/3TTLdIphdiHNNDIMfTzR08VCtgiFAsckNbvOCYXlRGRwkwx7HSic+KQDlTMVPKa7eKYp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KI54MI4w; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e6edde53cfso625798b3a.0
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 16:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710458802; x=1711063602; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mD7YpdXIs+PmNHJvwuzZnTphxdu0SDGnH/vkr1UjjVA=;
        b=KI54MI4wWvzITe2xQZLnBVyN7JEjVo1vySDA69d7DORTDlxUuyfkELUgATlmQzayB5
         wpB3bfzSpGeytpd27WbSlyzQWNMiHfc3imMVS3RE+t6Y/7Wh9LFjSep0LbzfhbB/+FCz
         HVQV90hMzbEZLQLitrRbHwoo0u5PCRJhP8lgZUSmypJFVr3YdcxuiCORNCTVVIiEskrU
         2N1PFTE58d5l42fvYDyoMGld65arwVrSN/Hq0lPQlpVLTJ9cQ+HNtVUm0XHy6rfX+XUP
         3xC6TCCMz0N4UeKMQdP1BXUuojl0eguL1buBjcgQbrYGgh8kSgK2vfQd3bh4iCh1hNLY
         J+Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710458802; x=1711063602;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mD7YpdXIs+PmNHJvwuzZnTphxdu0SDGnH/vkr1UjjVA=;
        b=ndQEe0e4Xkk2r2mTdoprnWa+ZJwEZk0MIzc7WiMtzSULE3eb+YvlvKeYKBAEktCjEs
         duikMo0UeZ7o8RD59Kdvllyl95GoMYGrdrlvl9jPfcoXMY3JE6UImya4aGoGWGcGilE/
         ki3x970K2cY/AjL9wx7gjEO3b7+VNzvReY6z/6XzhlM67gwgBQ1tyFLBQ5yKUg3+rqOE
         N/UnpRCCehqgGGBopQe6Pa3khjeC7WLGUGby6dtuqQk9zfHkVoZBXAERsIqJZHrrOU2d
         Oou+fdYV0uHQzcTQib/fzAiwCh1zwn5V2ejz+4mv2npttcF8PDKhlr4QH1oDzrreXr/W
         Cgyg==
X-Forwarded-Encrypted: i=1; AJvYcCUdrMom4aE+c6vOwtA2drv2Ci/btnJAQhQ9RLUxyxlWBYBbufp+F8Lc0iGynOppljYPZAMs0uCtWUYwqzsr+4FeSqcF
X-Gm-Message-State: AOJu0YyMVk+QN6GMoNhecgOpPFseCd7fUK/2AqbTFdC0IIlqc7kGK8ah
	fj685cnEwbbS4BAHp6couC0aX4G5na2YXlBqBWtf4hBIkIhrKn71ou/cvHh7mEqidWb+5xiwPll
	Ubg==
X-Google-Smtp-Source: AGHT+IFj40cZH8qyWHT4oJdR+z51R20Y0862mUkx6SbxiEGW8rFGRWZ0aP3Ao8hOW0/02zedh3Hg1GSBeHE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d91:b0:6e6:9ac5:269 with SMTP id
 fb17-20020a056a002d9100b006e69ac50269mr130375pfb.1.1710458801729; Thu, 14 Mar
 2024 16:26:41 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 16:26:20 -0700
In-Reply-To: <20240314232637.2538648-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314232637.2538648-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314232637.2538648-2-seanjc@google.com>
Subject: [PATCH 01/18] Revert "kvm: selftests: move base kvm_util.h
 declarations to kvm_util_base.h"
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Effectively revert the movement of code from kvm_util.h => kvm_util_base.h,
as the TL;DR of the justification for the move was to avoid #idefs and/or
circular dependencies between what ended up being ucall_common.h and what
was (and now again, is), kvm_util.h.

But avoiding #ifdef and circular includes is trivial: don't do that.  The
cost of removing kvm_util_base.h is a few extra includes of ucall_common.h,
but that cost is practically nothing.  On the other hand, having a "base"
version of a header that is really just the header itself is confusing,
and makes it weird/hard to choose names for headers that actually are
"base" headers, e.g. to hold core KVM selftests typedefs.

For all intents and purposes, this reverts commit
7d9a662ed9f0403e7b94940dceb81552b8edb931.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/aarch64/arch_timer.c        |    1 +
 tools/testing/selftests/kvm/arch_timer.c      |    1 +
 .../selftests/kvm/demand_paging_test.c        |    1 +
 .../selftests/kvm/dirty_log_perf_test.c       |    1 +
 tools/testing/selftests/kvm/dirty_log_test.c  |    1 +
 .../testing/selftests/kvm/guest_memfd_test.c  |    2 +-
 .../testing/selftests/kvm/guest_print_test.c  |    1 +
 .../selftests/kvm/include/aarch64/processor.h |    2 +
 .../selftests/kvm/include/aarch64/ucall.h     |    2 +-
 .../testing/selftests/kvm/include/kvm_util.h  | 1128 +++++++++++++++-
 .../selftests/kvm/include/kvm_util_base.h     | 1135 -----------------
 .../selftests/kvm/include/s390x/ucall.h       |    2 +-
 .../selftests/kvm/include/x86_64/processor.h  |    3 +-
 .../selftests/kvm/include/x86_64/ucall.h      |    2 +-
 .../selftests/kvm/kvm_page_table_test.c       |    1 +
 .../selftests/kvm/lib/aarch64/processor.c     |    2 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |    1 +
 tools/testing/selftests/kvm/lib/memstress.c   |    1 +
 .../selftests/kvm/lib/riscv/processor.c       |    1 +
 .../testing/selftests/kvm/lib/ucall_common.c  |    5 +-
 .../testing/selftests/kvm/riscv/arch_timer.c  |    1 +
 tools/testing/selftests/kvm/rseq_test.c       |    1 +
 tools/testing/selftests/kvm/s390x/cmma_test.c |    1 +
 tools/testing/selftests/kvm/s390x/memop.c     |    1 +
 tools/testing/selftests/kvm/s390x/tprot.c     |    1 +
 tools/testing/selftests/kvm/steal_time.c      |    1 +
 .../x86_64/dirty_log_page_splitting_test.c    |    1 +
 .../x86_64/exit_on_emulation_failure_test.c   |    2 +-
 .../kvm/x86_64/ucna_injection_test.c          |    1 -
 29 files changed, 1156 insertions(+), 1147 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/include/kvm_util_base.h

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index ddba2c2fb5de..ee83b2413da8 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -12,6 +12,7 @@
 #include "gic.h"
 #include "processor.h"
 #include "timer_test.h"
+#include "ucall_common.h"
 #include "vgic.h"
 
 #define GICD_BASE_GPA			0x8000000ULL
diff --git a/tools/testing/selftests/kvm/arch_timer.c b/tools/testing/selftests/kvm/arch_timer.c
index ae1f1a6d8312..40cb6c1bec0a 100644
--- a/tools/testing/selftests/kvm/arch_timer.c
+++ b/tools/testing/selftests/kvm/arch_timer.c
@@ -29,6 +29,7 @@
 #include <sys/sysinfo.h>
 
 #include "timer_test.h"
+#include "ucall_common.h"
 
 struct test_args test_args = {
 	.nr_vcpus = NR_VCPUS_DEF,
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index bf3609f71854..a36227731564 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -22,6 +22,7 @@
 #include "test_util.h"
 #include "memstress.h"
 #include "guest_modes.h"
+#include "ucall_common.h"
 #include "userfaultfd_util.h"
 
 #ifdef __NR_userfaultfd
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 504f6fe980e8..f0d3ccdb023c 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -18,6 +18,7 @@
 #include "test_util.h"
 #include "memstress.h"
 #include "guest_modes.h"
+#include "ucall_common.h"
 
 #ifdef __aarch64__
 #include "aarch64/vgic.h"
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index eaad5b20854c..d95120f9dc40 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -23,6 +23,7 @@
 #include "test_util.h"
 #include "guest_modes.h"
 #include "processor.h"
+#include "ucall_common.h"
 
 #define DIRTY_MEM_BITS 30 /* 1G */
 #define PAGE_SHIFT_4K  12
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 92eae206baa6..38320de686f6 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -19,8 +19,8 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 
+#include "kvm_util.h"
 #include "test_util.h"
-#include "kvm_util_base.h"
 
 static void test_file_read_write(int fd)
 {
diff --git a/tools/testing/selftests/kvm/guest_print_test.c b/tools/testing/selftests/kvm/guest_print_test.c
index 3502caa3590c..8092c2d0f5d6 100644
--- a/tools/testing/selftests/kvm/guest_print_test.c
+++ b/tools/testing/selftests/kvm/guest_print_test.c
@@ -13,6 +13,7 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
+#include "ucall_common.h"
 
 struct guest_vals {
 	uint64_t a;
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 9e518b562827..1814af7d8567 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -8,6 +8,8 @@
 #define SELFTEST_KVM_PROCESSOR_H
 
 #include "kvm_util.h"
+#include "ucall_common.h"
+
 #include <linux/stringify.h>
 #include <linux/types.h>
 #include <asm/sysreg.h>
diff --git a/tools/testing/selftests/kvm/include/aarch64/ucall.h b/tools/testing/selftests/kvm/include/aarch64/ucall.h
index 4b68f37efd36..4ec801f37f00 100644
--- a/tools/testing/selftests/kvm/include/aarch64/ucall.h
+++ b/tools/testing/selftests/kvm/include/aarch64/ucall.h
@@ -2,7 +2,7 @@
 #ifndef SELFTEST_KVM_UCALL_H
 #define SELFTEST_KVM_UCALL_H
 
-#include "kvm_util_base.h"
+#include "kvm_util.h"
 
 #define UCALL_EXIT_REASON       KVM_EXIT_MMIO
 
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index c9286811a4cb..95baee5142a7 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1,13 +1,1133 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * tools/testing/selftests/kvm/include/kvm_util.h
- *
  * Copyright (C) 2018, Google LLC.
  */
 #ifndef SELFTEST_KVM_UTIL_H
 #define SELFTEST_KVM_UTIL_H
 
-#include "kvm_util_base.h"
-#include "ucall_common.h"
+#include "test_util.h"
+
+#include <linux/compiler.h>
+#include "linux/hashtable.h"
+#include "linux/list.h"
+#include <linux/kernel.h>
+#include <linux/kvm.h>
+#include "linux/rbtree.h"
+#include <linux/types.h>
+
+#include <asm/atomic.h>
+#include <asm/kvm.h>
+
+#include <sys/ioctl.h>
+
+#include "kvm_util_arch.h"
+#include "sparsebit.h"
+
+/*
+ * Provide a version of static_assert() that is guaranteed to have an optional
+ * message param.  If _ISOC11_SOURCE is defined, glibc (/usr/include/assert.h)
+ * #undefs and #defines static_assert() as a direct alias to _Static_assert(),
+ * i.e. effectively makes the message mandatory.  Many KVM selftests #define
+ * _GNU_SOURCE for various reasons, and _GNU_SOURCE implies _ISOC11_SOURCE.  As
+ * a result, static_assert() behavior is non-deterministic and may or may not
+ * require a message depending on #include order.
+ */
+#define __kvm_static_assert(expr, msg, ...) _Static_assert(expr, msg)
+#define kvm_static_assert(expr, ...) __kvm_static_assert(expr, ##__VA_ARGS__, #expr)
+
+#define KVM_DEV_PATH "/dev/kvm"
+#define KVM_MAX_VCPUS 512
+
+#define NSEC_PER_SEC 1000000000L
+
+typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
+typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
+
+struct userspace_mem_region {
+	struct kvm_userspace_memory_region2 region;
+	struct sparsebit *unused_phy_pages;
+	struct sparsebit *protected_phy_pages;
+	int fd;
+	off_t offset;
+	enum vm_mem_backing_src_type backing_src_type;
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
+struct kvm_vcpu {
+	struct list_head list;
+	uint32_t id;
+	int fd;
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+#ifdef __x86_64__
+	struct kvm_cpuid2 *cpuid;
+#endif
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
+enum kvm_mem_region_type {
+	MEM_REGION_CODE,
+	MEM_REGION_DATA,
+	MEM_REGION_PT,
+	MEM_REGION_TEST_DATA,
+	NR_MEM_REGIONS,
+};
+
+struct kvm_vm {
+	int mode;
+	unsigned long type;
+	uint8_t subtype;
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
+	vm_paddr_t ucall_mmio_addr;
+	vm_paddr_t pgd;
+	vm_vaddr_t gdt;
+	vm_vaddr_t tss;
+	vm_vaddr_t idt;
+	vm_vaddr_t handlers;
+	uint32_t dirty_ring_size;
+	uint64_t gpa_tag_mask;
+
+	struct kvm_vm_arch arch;
+
+	/* Cache of information for binary stats interface */
+	int stats_fd;
+	struct kvm_stats_header stats_header;
+	struct kvm_stats_desc *stats_desc;
+
+	/*
+	 * KVM region slots. These are the default memslots used by page
+	 * allocators, e.g., lib/elf uses the memslots[MEM_REGION_CODE]
+	 * memslot.
+	 */
+	uint32_t memslots[NR_MEM_REGIONS];
+};
+
+struct vcpu_reg_sublist {
+	const char *name;
+	long capability;
+	int feature;
+	int feature_type;
+	bool finalize;
+	__u64 *regs;
+	__u64 regs_n;
+	__u64 *rejects_set;
+	__u64 rejects_set_n;
+	__u64 *skips_set;
+	__u64 skips_set_n;
+};
+
+struct vcpu_reg_list {
+	char *name;
+	struct vcpu_reg_sublist sublists[];
+};
+
+#define for_each_sublist(c, s)		\
+	for ((s) = &(c)->sublists[0]; (s)->regs; ++(s))
+
+#define kvm_for_each_vcpu(vm, i, vcpu)			\
+	for ((i) = 0; (i) <= (vm)->last_vcpu_id; (i)++)	\
+		if (!((vcpu) = vm->vcpus[i]))		\
+			continue;			\
+		else
+
+struct userspace_mem_region *
+memslot2region(struct kvm_vm *vm, uint32_t memslot);
+
+static inline struct userspace_mem_region *vm_get_mem_region(struct kvm_vm *vm,
+							     enum kvm_mem_region_type type)
+{
+	assert(type < NR_MEM_REGIONS);
+	return memslot2region(vm, vm->memslots[type]);
+}
+
+/* Minimum allocated guest virtual and physical addresses */
+#define KVM_UTIL_MIN_VADDR		0x2000
+#define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
+
+#define DEFAULT_GUEST_STACK_VADDR_MIN	0xab6000
+#define DEFAULT_STACK_PGS		5
+
+enum vm_guest_mode {
+	VM_MODE_P52V48_4K,
+	VM_MODE_P52V48_16K,
+	VM_MODE_P52V48_64K,
+	VM_MODE_P48V48_4K,
+	VM_MODE_P48V48_16K,
+	VM_MODE_P48V48_64K,
+	VM_MODE_P40V48_4K,
+	VM_MODE_P40V48_16K,
+	VM_MODE_P40V48_64K,
+	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
+	VM_MODE_P47V64_4K,
+	VM_MODE_P44V64_4K,
+	VM_MODE_P36V48_4K,
+	VM_MODE_P36V48_16K,
+	VM_MODE_P36V48_64K,
+	VM_MODE_P36V47_16K,
+	NUM_VM_MODES,
+};
+
+struct vm_shape {
+	uint32_t type;
+	uint8_t  mode;
+	uint8_t  subtype;
+	uint16_t padding;
+};
+
+kvm_static_assert(sizeof(struct vm_shape) == sizeof(uint64_t));
+
+#define VM_TYPE_DEFAULT			0
+
+#define VM_SHAPE(__mode)			\
+({						\
+	struct vm_shape shape = {		\
+		.mode = (__mode),		\
+		.type = VM_TYPE_DEFAULT		\
+	};					\
+						\
+	shape;					\
+})
+
+#if defined(__aarch64__)
+
+extern enum vm_guest_mode vm_mode_default;
+
+#define VM_MODE_DEFAULT			vm_mode_default
+#define MIN_PAGE_SHIFT			12U
+#define ptes_per_page(page_size)	((page_size) / 8)
+
+#elif defined(__x86_64__)
+
+#define VM_MODE_DEFAULT			VM_MODE_PXXV48_4K
+#define MIN_PAGE_SHIFT			12U
+#define ptes_per_page(page_size)	((page_size) / 8)
+
+#elif defined(__s390x__)
+
+#define VM_MODE_DEFAULT			VM_MODE_P44V64_4K
+#define MIN_PAGE_SHIFT			12U
+#define ptes_per_page(page_size)	((page_size) / 16)
+
+#elif defined(__riscv)
+
+#if __riscv_xlen == 32
+#error "RISC-V 32-bit kvm selftests not supported"
+#endif
+
+#define VM_MODE_DEFAULT			VM_MODE_P40V48_4K
+#define MIN_PAGE_SHIFT			12U
+#define ptes_per_page(page_size)	((page_size) / 8)
+
+#endif
+
+#define VM_SHAPE_DEFAULT	VM_SHAPE(VM_MODE_DEFAULT)
+
+#define MIN_PAGE_SIZE		(1U << MIN_PAGE_SHIFT)
+#define PTES_PER_MIN_PAGE	ptes_per_page(MIN_PAGE_SIZE)
+
+struct vm_guest_mode_params {
+	unsigned int pa_bits;
+	unsigned int va_bits;
+	unsigned int page_size;
+	unsigned int page_shift;
+};
+extern const struct vm_guest_mode_params vm_guest_mode_params[];
+
+int open_path_or_exit(const char *path, int flags);
+int open_kvm_dev_path_or_exit(void);
+
+bool get_kvm_param_bool(const char *param);
+bool get_kvm_intel_param_bool(const char *param);
+bool get_kvm_amd_param_bool(const char *param);
+
+int get_kvm_param_integer(const char *param);
+int get_kvm_intel_param_integer(const char *param);
+int get_kvm_amd_param_integer(const char *param);
+
+unsigned int kvm_check_cap(long cap);
+
+static inline bool kvm_has_cap(long cap)
+{
+	return kvm_check_cap(cap);
+}
+
+#define __KVM_SYSCALL_ERROR(_name, _ret) \
+	"%s failed, rc: %i errno: %i (%s)", (_name), (_ret), errno, strerror(errno)
+
+/*
+ * Use the "inner", double-underscore macro when reporting errors from within
+ * other macros so that the name of ioctl() and not its literal numeric value
+ * is printed on error.  The "outer" macro is strongly preferred when reporting
+ * errors "directly", i.e. without an additional layer of macros, as it reduces
+ * the probability of passing in the wrong string.
+ */
+#define __KVM_IOCTL_ERROR(_name, _ret)	__KVM_SYSCALL_ERROR(_name, _ret)
+#define KVM_IOCTL_ERROR(_ioctl, _ret) __KVM_IOCTL_ERROR(#_ioctl, _ret)
+
+#define kvm_do_ioctl(fd, cmd, arg)						\
+({										\
+	kvm_static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) == _IOC_SIZE(cmd));	\
+	ioctl(fd, cmd, arg);							\
+})
+
+#define __kvm_ioctl(kvm_fd, cmd, arg)				\
+	kvm_do_ioctl(kvm_fd, cmd, arg)
+
+#define kvm_ioctl(kvm_fd, cmd, arg)				\
+({								\
+	int ret = __kvm_ioctl(kvm_fd, cmd, arg);		\
+								\
+	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
+})
+
+static __always_inline void static_assert_is_vm(struct kvm_vm *vm) { }
+
+#define __vm_ioctl(vm, cmd, arg)				\
+({								\
+	static_assert_is_vm(vm);				\
+	kvm_do_ioctl((vm)->fd, cmd, arg);			\
+})
+
+/*
+ * Assert that a VM or vCPU ioctl() succeeded, with extra magic to detect if
+ * the ioctl() failed because KVM killed/bugged the VM.  To detect a dead VM,
+ * probe KVM_CAP_USER_MEMORY, which (a) has been supported by KVM since before
+ * selftests existed and (b) should never outright fail, i.e. is supposed to
+ * return 0 or 1.  If KVM kills a VM, KVM returns -EIO for all ioctl()s for the
+ * VM and its vCPUs, including KVM_CHECK_EXTENSION.
+ */
+#define __TEST_ASSERT_VM_VCPU_IOCTL(cond, name, ret, vm)				\
+do {											\
+	int __errno = errno;								\
+											\
+	static_assert_is_vm(vm);							\
+											\
+	if (cond)									\
+		break;									\
+											\
+	if (errno == EIO &&								\
+	    __vm_ioctl(vm, KVM_CHECK_EXTENSION, (void *)KVM_CAP_USER_MEMORY) < 0) {	\
+		TEST_ASSERT(errno == EIO, "KVM killed the VM, should return -EIO");	\
+		TEST_FAIL("KVM killed/bugged the VM, check the kernel log for clues");	\
+	}										\
+	errno = __errno;								\
+	TEST_ASSERT(cond, __KVM_IOCTL_ERROR(name, ret));				\
+} while (0)
+
+#define TEST_ASSERT_VM_VCPU_IOCTL(cond, cmd, ret, vm)		\
+	__TEST_ASSERT_VM_VCPU_IOCTL(cond, #cmd, ret, vm)
+
+#define vm_ioctl(vm, cmd, arg)					\
+({								\
+	int ret = __vm_ioctl(vm, cmd, arg);			\
+								\
+	__TEST_ASSERT_VM_VCPU_IOCTL(!ret, #cmd, ret, vm);		\
+})
+
+static __always_inline void static_assert_is_vcpu(struct kvm_vcpu *vcpu) { }
+
+#define __vcpu_ioctl(vcpu, cmd, arg)				\
+({								\
+	static_assert_is_vcpu(vcpu);				\
+	kvm_do_ioctl((vcpu)->fd, cmd, arg);			\
+})
+
+#define vcpu_ioctl(vcpu, cmd, arg)				\
+({								\
+	int ret = __vcpu_ioctl(vcpu, cmd, arg);			\
+								\
+	__TEST_ASSERT_VM_VCPU_IOCTL(!ret, #cmd, ret, (vcpu)->vm);	\
+})
+
+/*
+ * Looks up and returns the value corresponding to the capability
+ * (KVM_CAP_*) given by cap.
+ */
+static inline int vm_check_cap(struct kvm_vm *vm, long cap)
+{
+	int ret =  __vm_ioctl(vm, KVM_CHECK_EXTENSION, (void *)cap);
+
+	TEST_ASSERT_VM_VCPU_IOCTL(ret >= 0, KVM_CHECK_EXTENSION, ret, vm);
+	return ret;
+}
+
+static inline int __vm_enable_cap(struct kvm_vm *vm, uint32_t cap, uint64_t arg0)
+{
+	struct kvm_enable_cap enable_cap = { .cap = cap, .args = { arg0 } };
+
+	return __vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
+}
+static inline void vm_enable_cap(struct kvm_vm *vm, uint32_t cap, uint64_t arg0)
+{
+	struct kvm_enable_cap enable_cap = { .cap = cap, .args = { arg0 } };
+
+	vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
+}
+
+static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
+					    uint64_t size, uint64_t attributes)
+{
+	struct kvm_memory_attributes attr = {
+		.attributes = attributes,
+		.address = gpa,
+		.size = size,
+		.flags = 0,
+	};
+
+	/*
+	 * KVM_SET_MEMORY_ATTRIBUTES overwrites _all_ attributes.  These flows
+	 * need significant enhancements to support multiple attributes.
+	 */
+	TEST_ASSERT(!attributes || attributes == KVM_MEMORY_ATTRIBUTE_PRIVATE,
+		    "Update me to support multiple attributes!");
+
+	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES, &attr);
+}
+
+
+static inline void vm_mem_set_private(struct kvm_vm *vm, uint64_t gpa,
+				      uint64_t size)
+{
+	vm_set_memory_attributes(vm, gpa, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
+}
+
+static inline void vm_mem_set_shared(struct kvm_vm *vm, uint64_t gpa,
+				     uint64_t size)
+{
+	vm_set_memory_attributes(vm, gpa, size, 0);
+}
+
+void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t gpa, uint64_t size,
+			    bool punch_hole);
+
+static inline void vm_guest_mem_punch_hole(struct kvm_vm *vm, uint64_t gpa,
+					   uint64_t size)
+{
+	vm_guest_mem_fallocate(vm, gpa, size, true);
+}
+
+static inline void vm_guest_mem_allocate(struct kvm_vm *vm, uint64_t gpa,
+					 uint64_t size)
+{
+	vm_guest_mem_fallocate(vm, gpa, size, false);
+}
+
+void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size);
+const char *vm_guest_mode_string(uint32_t i);
+
+void kvm_vm_free(struct kvm_vm *vmp);
+void kvm_vm_restart(struct kvm_vm *vmp);
+void kvm_vm_release(struct kvm_vm *vmp);
+int kvm_memcmp_hva_gva(void *hva, struct kvm_vm *vm, const vm_vaddr_t gva,
+		       size_t len);
+void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename);
+int kvm_memfd_alloc(size_t size, bool hugepages);
+
+void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
+
+static inline void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot, void *log)
+{
+	struct kvm_dirty_log args = { .dirty_bitmap = log, .slot = slot };
+
+	vm_ioctl(vm, KVM_GET_DIRTY_LOG, &args);
+}
+
+static inline void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slot, void *log,
+					  uint64_t first_page, uint32_t num_pages)
+{
+	struct kvm_clear_dirty_log args = {
+		.dirty_bitmap = log,
+		.slot = slot,
+		.first_page = first_page,
+		.num_pages = num_pages
+	};
+
+	vm_ioctl(vm, KVM_CLEAR_DIRTY_LOG, &args);
+}
+
+static inline uint32_t kvm_vm_reset_dirty_ring(struct kvm_vm *vm)
+{
+	return __vm_ioctl(vm, KVM_RESET_DIRTY_RINGS, NULL);
+}
+
+static inline int vm_get_stats_fd(struct kvm_vm *vm)
+{
+	int fd = __vm_ioctl(vm, KVM_GET_STATS_FD, NULL);
+
+	TEST_ASSERT_VM_VCPU_IOCTL(fd >= 0, KVM_GET_STATS_FD, fd, vm);
+	return fd;
+}
+
+static inline void read_stats_header(int stats_fd, struct kvm_stats_header *header)
+{
+	ssize_t ret;
+
+	ret = pread(stats_fd, header, sizeof(*header), 0);
+	TEST_ASSERT(ret == sizeof(*header),
+		    "Failed to read '%lu' header bytes, ret = '%ld'",
+		    sizeof(*header), ret);
+}
+
+struct kvm_stats_desc *read_stats_descriptors(int stats_fd,
+					      struct kvm_stats_header *header);
+
+static inline ssize_t get_stats_descriptor_size(struct kvm_stats_header *header)
+{
+	 /*
+	  * The base size of the descriptor is defined by KVM's ABI, but the
+	  * size of the name field is variable, as far as KVM's ABI is
+	  * concerned. For a given instance of KVM, the name field is the same
+	  * size for all stats and is provided in the overall stats header.
+	  */
+	return sizeof(struct kvm_stats_desc) + header->name_size;
+}
+
+static inline struct kvm_stats_desc *get_stats_descriptor(struct kvm_stats_desc *stats,
+							  int index,
+							  struct kvm_stats_header *header)
+{
+	/*
+	 * Note, size_desc includes the size of the name field, which is
+	 * variable. i.e. this is NOT equivalent to &stats_desc[i].
+	 */
+	return (void *)stats + index * get_stats_descriptor_size(header);
+}
+
+void read_stat_data(int stats_fd, struct kvm_stats_header *header,
+		    struct kvm_stats_desc *desc, uint64_t *data,
+		    size_t max_elements);
+
+void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
+		   size_t max_elements);
+
+static inline uint64_t vm_get_stat(struct kvm_vm *vm, const char *stat_name)
+{
+	uint64_t data;
+
+	__vm_get_stat(vm, stat_name, &data, 1);
+	return data;
+}
+
+void vm_create_irqchip(struct kvm_vm *vm);
+
+static inline int __vm_create_guest_memfd(struct kvm_vm *vm, uint64_t size,
+					uint64_t flags)
+{
+	struct kvm_create_guest_memfd guest_memfd = {
+		.size = size,
+		.flags = flags,
+	};
+
+	return __vm_ioctl(vm, KVM_CREATE_GUEST_MEMFD, &guest_memfd);
+}
+
+static inline int vm_create_guest_memfd(struct kvm_vm *vm, uint64_t size,
+					uint64_t flags)
+{
+	int fd = __vm_create_guest_memfd(vm, size, flags);
+
+	TEST_ASSERT(fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_GUEST_MEMFD, fd));
+	return fd;
+}
+
+void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+			       uint64_t gpa, uint64_t size, void *hva);
+int __vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+				uint64_t gpa, uint64_t size, void *hva);
+void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+				uint64_t gpa, uint64_t size, void *hva,
+				uint32_t guest_memfd, uint64_t guest_memfd_offset);
+int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
+				 uint64_t gpa, uint64_t size, void *hva,
+				 uint32_t guest_memfd, uint64_t guest_memfd_offset);
+
+void vm_userspace_mem_region_add(struct kvm_vm *vm,
+	enum vm_mem_backing_src_type src_type,
+	uint64_t guest_paddr, uint32_t slot, uint64_t npages,
+	uint32_t flags);
+void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
+		uint64_t guest_paddr, uint32_t slot, uint64_t npages,
+		uint32_t flags, int guest_memfd_fd, uint64_t guest_memfd_offset);
+
+#ifndef vm_arch_has_protected_memory
+static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
+{
+	return false;
+}
+#endif
+
+void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
+void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
+void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
+struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
+void vm_populate_vaddr_bitmap(struct kvm_vm *vm);
+vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
+vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
+vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
+			    enum kvm_mem_region_type type);
+vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
+				 vm_vaddr_t vaddr_min,
+				 enum kvm_mem_region_type type);
+vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
+vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm,
+				 enum kvm_mem_region_type type);
+vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
+
+void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+	      unsigned int npages);
+void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa);
+void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
+vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
+void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
+
+
+static inline vm_paddr_t vm_untag_gpa(struct kvm_vm *vm, vm_paddr_t gpa)
+{
+	return gpa & ~vm->gpa_tag_mask;
+}
+
+void vcpu_run(struct kvm_vcpu *vcpu);
+int _vcpu_run(struct kvm_vcpu *vcpu);
+
+static inline int __vcpu_run(struct kvm_vcpu *vcpu)
+{
+	return __vcpu_ioctl(vcpu, KVM_RUN, NULL);
+}
+
+void vcpu_run_complete_io(struct kvm_vcpu *vcpu);
+struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vcpu *vcpu);
+
+static inline void vcpu_enable_cap(struct kvm_vcpu *vcpu, uint32_t cap,
+				   uint64_t arg0)
+{
+	struct kvm_enable_cap enable_cap = { .cap = cap, .args = { arg0 } };
+
+	vcpu_ioctl(vcpu, KVM_ENABLE_CAP, &enable_cap);
+}
+
+static inline void vcpu_guest_debug_set(struct kvm_vcpu *vcpu,
+					struct kvm_guest_debug *debug)
+{
+	vcpu_ioctl(vcpu, KVM_SET_GUEST_DEBUG, debug);
+}
+
+static inline void vcpu_mp_state_get(struct kvm_vcpu *vcpu,
+				     struct kvm_mp_state *mp_state)
+{
+	vcpu_ioctl(vcpu, KVM_GET_MP_STATE, mp_state);
+}
+static inline void vcpu_mp_state_set(struct kvm_vcpu *vcpu,
+				     struct kvm_mp_state *mp_state)
+{
+	vcpu_ioctl(vcpu, KVM_SET_MP_STATE, mp_state);
+}
+
+static inline void vcpu_regs_get(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	vcpu_ioctl(vcpu, KVM_GET_REGS, regs);
+}
+
+static inline void vcpu_regs_set(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	vcpu_ioctl(vcpu, KVM_SET_REGS, regs);
+}
+static inline void vcpu_sregs_get(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
+{
+	vcpu_ioctl(vcpu, KVM_GET_SREGS, sregs);
+
+}
+static inline void vcpu_sregs_set(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
+{
+	vcpu_ioctl(vcpu, KVM_SET_SREGS, sregs);
+}
+static inline int _vcpu_sregs_set(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
+{
+	return __vcpu_ioctl(vcpu, KVM_SET_SREGS, sregs);
+}
+static inline void vcpu_fpu_get(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
+{
+	vcpu_ioctl(vcpu, KVM_GET_FPU, fpu);
+}
+static inline void vcpu_fpu_set(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
+{
+	vcpu_ioctl(vcpu, KVM_SET_FPU, fpu);
+}
+
+static inline int __vcpu_get_reg(struct kvm_vcpu *vcpu, uint64_t id, void *addr)
+{
+	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)addr };
+
+	return __vcpu_ioctl(vcpu, KVM_GET_ONE_REG, &reg);
+}
+static inline int __vcpu_set_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t val)
+{
+	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
+
+	return __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
+}
+static inline void vcpu_get_reg(struct kvm_vcpu *vcpu, uint64_t id, void *addr)
+{
+	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)addr };
+
+	vcpu_ioctl(vcpu, KVM_GET_ONE_REG, &reg);
+}
+static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t val)
+{
+	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
+
+	vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
+}
+
+#ifdef __KVM_HAVE_VCPU_EVENTS
+static inline void vcpu_events_get(struct kvm_vcpu *vcpu,
+				   struct kvm_vcpu_events *events)
+{
+	vcpu_ioctl(vcpu, KVM_GET_VCPU_EVENTS, events);
+}
+static inline void vcpu_events_set(struct kvm_vcpu *vcpu,
+				   struct kvm_vcpu_events *events)
+{
+	vcpu_ioctl(vcpu, KVM_SET_VCPU_EVENTS, events);
+}
+#endif
+#ifdef __x86_64__
+static inline void vcpu_nested_state_get(struct kvm_vcpu *vcpu,
+					 struct kvm_nested_state *state)
+{
+	vcpu_ioctl(vcpu, KVM_GET_NESTED_STATE, state);
+}
+static inline int __vcpu_nested_state_set(struct kvm_vcpu *vcpu,
+					  struct kvm_nested_state *state)
+{
+	return __vcpu_ioctl(vcpu, KVM_SET_NESTED_STATE, state);
+}
+
+static inline void vcpu_nested_state_set(struct kvm_vcpu *vcpu,
+					 struct kvm_nested_state *state)
+{
+	vcpu_ioctl(vcpu, KVM_SET_NESTED_STATE, state);
+}
+#endif
+static inline int vcpu_get_stats_fd(struct kvm_vcpu *vcpu)
+{
+	int fd = __vcpu_ioctl(vcpu, KVM_GET_STATS_FD, NULL);
+
+	TEST_ASSERT_VM_VCPU_IOCTL(fd >= 0, KVM_CHECK_EXTENSION, fd, vcpu->vm);
+	return fd;
+}
+
+int __kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr);
+
+static inline void kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr)
+{
+	int ret = __kvm_has_device_attr(dev_fd, group, attr);
+
+	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
+}
+
+int __kvm_device_attr_get(int dev_fd, uint32_t group, uint64_t attr, void *val);
+
+static inline void kvm_device_attr_get(int dev_fd, uint32_t group,
+				       uint64_t attr, void *val)
+{
+	int ret = __kvm_device_attr_get(dev_fd, group, attr, val);
+
+	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_GET_DEVICE_ATTR, ret));
+}
+
+int __kvm_device_attr_set(int dev_fd, uint32_t group, uint64_t attr, void *val);
+
+static inline void kvm_device_attr_set(int dev_fd, uint32_t group,
+				       uint64_t attr, void *val)
+{
+	int ret = __kvm_device_attr_set(dev_fd, group, attr, val);
+
+	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
+}
+
+static inline int __vcpu_has_device_attr(struct kvm_vcpu *vcpu, uint32_t group,
+					 uint64_t attr)
+{
+	return __kvm_has_device_attr(vcpu->fd, group, attr);
+}
+
+static inline void vcpu_has_device_attr(struct kvm_vcpu *vcpu, uint32_t group,
+					uint64_t attr)
+{
+	kvm_has_device_attr(vcpu->fd, group, attr);
+}
+
+static inline int __vcpu_device_attr_get(struct kvm_vcpu *vcpu, uint32_t group,
+					 uint64_t attr, void *val)
+{
+	return __kvm_device_attr_get(vcpu->fd, group, attr, val);
+}
+
+static inline void vcpu_device_attr_get(struct kvm_vcpu *vcpu, uint32_t group,
+					uint64_t attr, void *val)
+{
+	kvm_device_attr_get(vcpu->fd, group, attr, val);
+}
+
+static inline int __vcpu_device_attr_set(struct kvm_vcpu *vcpu, uint32_t group,
+					 uint64_t attr, void *val)
+{
+	return __kvm_device_attr_set(vcpu->fd, group, attr, val);
+}
+
+static inline void vcpu_device_attr_set(struct kvm_vcpu *vcpu, uint32_t group,
+					uint64_t attr, void *val)
+{
+	kvm_device_attr_set(vcpu->fd, group, attr, val);
+}
+
+int __kvm_test_create_device(struct kvm_vm *vm, uint64_t type);
+int __kvm_create_device(struct kvm_vm *vm, uint64_t type);
+
+static inline int kvm_create_device(struct kvm_vm *vm, uint64_t type)
+{
+	int fd = __kvm_create_device(vm, type);
+
+	TEST_ASSERT(fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_DEVICE, fd));
+	return fd;
+}
+
+void *vcpu_map_dirty_ring(struct kvm_vcpu *vcpu);
+
+/*
+ * VM VCPU Args Set
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   num - number of arguments
+ *   ... - arguments, each of type uint64_t
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Sets the first @num input parameters for the function at @vcpu's entry point,
+ * per the C calling convention of the architecture, to the values given as
+ * variable args. Each of the variable args is expected to be of type uint64_t.
+ * The maximum @num can be is specific to the architecture.
+ */
+void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...);
+
+void kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level);
+int _kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level);
+
+#define KVM_MAX_IRQ_ROUTES		4096
+
+struct kvm_irq_routing *kvm_gsi_routing_create(void);
+void kvm_gsi_routing_irqchip_add(struct kvm_irq_routing *routing,
+		uint32_t gsi, uint32_t pin);
+int _kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing);
+void kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing);
+
+const char *exit_reason_str(unsigned int exit_reason);
+
+vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
+			     uint32_t memslot);
+vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+				vm_paddr_t paddr_min, uint32_t memslot,
+				bool protected);
+vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
+
+static inline vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+					    vm_paddr_t paddr_min, uint32_t memslot)
+{
+	/*
+	 * By default, allocate memory as protected for VMs that support
+	 * protected memory, as the majority of memory for such VMs is
+	 * protected, i.e. using shared memory is effectively opt-in.
+	 */
+	return __vm_phy_pages_alloc(vm, num, paddr_min, memslot,
+				    vm_arch_has_protected_memory(vm));
+}
+
+/*
+ * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
+ * loads the test binary into guest memory and creates an IRQ chip (x86 only).
+ * __vm_create() does NOT create vCPUs, @nr_runnable_vcpus is used purely to
+ * calculate the amount of memory needed for per-vCPU data, e.g. stacks.
+ */
+struct kvm_vm *____vm_create(struct vm_shape shape);
+struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
+			   uint64_t nr_extra_pages);
+
+static inline struct kvm_vm *vm_create_barebones(void)
+{
+	return ____vm_create(VM_SHAPE_DEFAULT);
+}
+
+#ifdef __x86_64__
+static inline struct kvm_vm *vm_create_barebones_protected_vm(void)
+{
+	const struct vm_shape shape = {
+		.mode = VM_MODE_DEFAULT,
+		.type = KVM_X86_SW_PROTECTED_VM,
+	};
+
+	return ____vm_create(shape);
+}
+#endif
+
+static inline struct kvm_vm *vm_create(uint32_t nr_runnable_vcpus)
+{
+	return __vm_create(VM_SHAPE_DEFAULT, nr_runnable_vcpus, 0);
+}
+
+struct kvm_vm *__vm_create_with_vcpus(struct vm_shape shape, uint32_t nr_vcpus,
+				      uint64_t extra_mem_pages,
+				      void *guest_code, struct kvm_vcpu *vcpus[]);
+
+static inline struct kvm_vm *vm_create_with_vcpus(uint32_t nr_vcpus,
+						  void *guest_code,
+						  struct kvm_vcpu *vcpus[])
+{
+	return __vm_create_with_vcpus(VM_SHAPE_DEFAULT, nr_vcpus, 0,
+				      guest_code, vcpus);
+}
+
+
+struct kvm_vm *__vm_create_shape_with_one_vcpu(struct vm_shape shape,
+					       struct kvm_vcpu **vcpu,
+					       uint64_t extra_mem_pages,
+					       void *guest_code);
+
+/*
+ * Create a VM with a single vCPU with reasonable defaults and @extra_mem_pages
+ * additional pages of guest memory.  Returns the VM and vCPU (via out param).
+ */
+static inline struct kvm_vm *__vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
+						       uint64_t extra_mem_pages,
+						       void *guest_code)
+{
+	return __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, vcpu,
+					       extra_mem_pages, guest_code);
+}
+
+static inline struct kvm_vm *vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
+						     void *guest_code)
+{
+	return __vm_create_with_one_vcpu(vcpu, 0, guest_code);
+}
+
+static inline struct kvm_vm *vm_create_shape_with_one_vcpu(struct vm_shape shape,
+							   struct kvm_vcpu **vcpu,
+							   void *guest_code)
+{
+	return __vm_create_shape_with_one_vcpu(shape, vcpu, 0, guest_code);
+}
+
+struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm);
+
+void kvm_pin_this_task_to_pcpu(uint32_t pcpu);
+void kvm_print_vcpu_pinning_help(void);
+void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
+			    int nr_vcpus);
+
+unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
+unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size);
+unsigned int vm_num_host_pages(enum vm_guest_mode mode, unsigned int num_guest_pages);
+unsigned int vm_num_guest_pages(enum vm_guest_mode mode, unsigned int num_host_pages);
+static inline unsigned int
+vm_adjust_num_guest_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
+{
+	unsigned int n;
+	n = vm_num_guest_pages(mode, vm_num_host_pages(mode, num_guest_pages));
+#ifdef __s390x__
+	/* s390 requires 1M aligned guest sizes */
+	n = (n + 255) & ~255;
+#endif
+	return n;
+}
+
+#define sync_global_to_guest(vm, g) ({				\
+	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
+	memcpy(_p, &(g), sizeof(g));				\
+})
+
+#define sync_global_from_guest(vm, g) ({			\
+	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
+	memcpy(&(g), _p, sizeof(g));				\
+})
+
+/*
+ * Write a global value, but only in the VM's (guest's) domain.  Primarily used
+ * for "globals" that hold per-VM values (VMs always duplicate code and global
+ * data into their own region of physical memory), but can be used anytime it's
+ * undesirable to change the host's copy of the global.
+ */
+#define write_guest_global(vm, g, val) ({			\
+	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
+	typeof(g) _val = val;					\
+								\
+	memcpy(_p, &(_val), sizeof(g));				\
+})
+
+void assert_on_unhandled_exception(struct kvm_vcpu *vcpu);
+
+void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu,
+		    uint8_t indent);
+
+static inline void vcpu_dump(FILE *stream, struct kvm_vcpu *vcpu,
+			     uint8_t indent)
+{
+	vcpu_arch_dump(stream, vcpu, indent);
+}
+
+/*
+ * Adds a vCPU with reasonable defaults (e.g. a stack)
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   vcpu_id - The id of the VCPU to add to the VM.
+ */
+struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
+void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code);
+
+static inline struct kvm_vcpu *vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
+					   void *guest_code)
+{
+	struct kvm_vcpu *vcpu = vm_arch_vcpu_add(vm, vcpu_id);
+
+	vcpu_arch_set_entry_point(vcpu, guest_code);
+
+	return vcpu;
+}
+
+/* Re-create a vCPU after restarting a VM, e.g. for state save/restore tests. */
+struct kvm_vcpu *vm_arch_vcpu_recreate(struct kvm_vm *vm, uint32_t vcpu_id);
+
+static inline struct kvm_vcpu *vm_vcpu_recreate(struct kvm_vm *vm,
+						uint32_t vcpu_id)
+{
+	return vm_arch_vcpu_recreate(vm, vcpu_id);
+}
+
+void vcpu_arch_free(struct kvm_vcpu *vcpu);
+
+void virt_arch_pgd_alloc(struct kvm_vm *vm);
+
+static inline void virt_pgd_alloc(struct kvm_vm *vm)
+{
+	virt_arch_pgd_alloc(vm);
+}
+
+/*
+ * VM Virtual Page Map
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   vaddr - VM Virtual Address
+ *   paddr - VM Physical Address
+ *   memslot - Memory region slot for new virtual translation tables
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Within @vm, creates a virtual translation for the page starting
+ * at @vaddr to the page starting at @paddr.
+ */
+void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr);
+
+static inline void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
+{
+	virt_arch_pg_map(vm, vaddr, paddr);
+}
+
+
+/*
+ * Address Guest Virtual to Guest Physical
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   gva - VM virtual address
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Equivalent VM physical address
+ *
+ * Returns the VM physical address of the translated VM virtual
+ * address given by @gva.
+ */
+vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
+
+static inline vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
+{
+	return addr_arch_gva2gpa(vm, gva);
+}
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
+void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
+
+static inline void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
+{
+	virt_arch_dump(stream, vm, indent);
+}
+
+
+static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
+{
+	return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
+}
+
+/*
+ * Arch hook that is invoked via a constructor, i.e. before exeucting main(),
+ * to allow for arch-specific setup that is common to all tests, e.g. computing
+ * the default guest "mode".
+ */
+void kvm_selftest_arch_init(void);
+
+void kvm_arch_vm_post_create(struct kvm_vm *vm);
+
+bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr);
+
+uint32_t guest_get_vcpuid(void);
 
 #endif /* SELFTEST_KVM_UTIL_H */
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
deleted file mode 100644
index 3e0db283a46a..000000000000
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ /dev/null
@@ -1,1135 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * tools/testing/selftests/kvm/include/kvm_util_base.h
- *
- * Copyright (C) 2018, Google LLC.
- */
-#ifndef SELFTEST_KVM_UTIL_BASE_H
-#define SELFTEST_KVM_UTIL_BASE_H
-
-#include "test_util.h"
-
-#include <linux/compiler.h>
-#include "linux/hashtable.h"
-#include "linux/list.h"
-#include <linux/kernel.h>
-#include <linux/kvm.h>
-#include "linux/rbtree.h"
-#include <linux/types.h>
-
-#include <asm/atomic.h>
-#include <asm/kvm.h>
-
-#include <sys/ioctl.h>
-
-#include "kvm_util_arch.h"
-#include "sparsebit.h"
-
-/*
- * Provide a version of static_assert() that is guaranteed to have an optional
- * message param.  If _ISOC11_SOURCE is defined, glibc (/usr/include/assert.h)
- * #undefs and #defines static_assert() as a direct alias to _Static_assert(),
- * i.e. effectively makes the message mandatory.  Many KVM selftests #define
- * _GNU_SOURCE for various reasons, and _GNU_SOURCE implies _ISOC11_SOURCE.  As
- * a result, static_assert() behavior is non-deterministic and may or may not
- * require a message depending on #include order.
- */
-#define __kvm_static_assert(expr, msg, ...) _Static_assert(expr, msg)
-#define kvm_static_assert(expr, ...) __kvm_static_assert(expr, ##__VA_ARGS__, #expr)
-
-#define KVM_DEV_PATH "/dev/kvm"
-#define KVM_MAX_VCPUS 512
-
-#define NSEC_PER_SEC 1000000000L
-
-typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address */
-typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
-
-struct userspace_mem_region {
-	struct kvm_userspace_memory_region2 region;
-	struct sparsebit *unused_phy_pages;
-	struct sparsebit *protected_phy_pages;
-	int fd;
-	off_t offset;
-	enum vm_mem_backing_src_type backing_src_type;
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
-struct kvm_vcpu {
-	struct list_head list;
-	uint32_t id;
-	int fd;
-	struct kvm_vm *vm;
-	struct kvm_run *run;
-#ifdef __x86_64__
-	struct kvm_cpuid2 *cpuid;
-#endif
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
-enum kvm_mem_region_type {
-	MEM_REGION_CODE,
-	MEM_REGION_DATA,
-	MEM_REGION_PT,
-	MEM_REGION_TEST_DATA,
-	NR_MEM_REGIONS,
-};
-
-struct kvm_vm {
-	int mode;
-	unsigned long type;
-	uint8_t subtype;
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
-	vm_paddr_t ucall_mmio_addr;
-	vm_paddr_t pgd;
-	vm_vaddr_t gdt;
-	vm_vaddr_t tss;
-	vm_vaddr_t idt;
-	vm_vaddr_t handlers;
-	uint32_t dirty_ring_size;
-	uint64_t gpa_tag_mask;
-
-	struct kvm_vm_arch arch;
-
-	/* Cache of information for binary stats interface */
-	int stats_fd;
-	struct kvm_stats_header stats_header;
-	struct kvm_stats_desc *stats_desc;
-
-	/*
-	 * KVM region slots. These are the default memslots used by page
-	 * allocators, e.g., lib/elf uses the memslots[MEM_REGION_CODE]
-	 * memslot.
-	 */
-	uint32_t memslots[NR_MEM_REGIONS];
-};
-
-struct vcpu_reg_sublist {
-	const char *name;
-	long capability;
-	int feature;
-	int feature_type;
-	bool finalize;
-	__u64 *regs;
-	__u64 regs_n;
-	__u64 *rejects_set;
-	__u64 rejects_set_n;
-	__u64 *skips_set;
-	__u64 skips_set_n;
-};
-
-struct vcpu_reg_list {
-	char *name;
-	struct vcpu_reg_sublist sublists[];
-};
-
-#define for_each_sublist(c, s)		\
-	for ((s) = &(c)->sublists[0]; (s)->regs; ++(s))
-
-#define kvm_for_each_vcpu(vm, i, vcpu)			\
-	for ((i) = 0; (i) <= (vm)->last_vcpu_id; (i)++)	\
-		if (!((vcpu) = vm->vcpus[i]))		\
-			continue;			\
-		else
-
-struct userspace_mem_region *
-memslot2region(struct kvm_vm *vm, uint32_t memslot);
-
-static inline struct userspace_mem_region *vm_get_mem_region(struct kvm_vm *vm,
-							     enum kvm_mem_region_type type)
-{
-	assert(type < NR_MEM_REGIONS);
-	return memslot2region(vm, vm->memslots[type]);
-}
-
-/* Minimum allocated guest virtual and physical addresses */
-#define KVM_UTIL_MIN_VADDR		0x2000
-#define KVM_GUEST_PAGE_TABLE_MIN_PADDR	0x180000
-
-#define DEFAULT_GUEST_STACK_VADDR_MIN	0xab6000
-#define DEFAULT_STACK_PGS		5
-
-enum vm_guest_mode {
-	VM_MODE_P52V48_4K,
-	VM_MODE_P52V48_16K,
-	VM_MODE_P52V48_64K,
-	VM_MODE_P48V48_4K,
-	VM_MODE_P48V48_16K,
-	VM_MODE_P48V48_64K,
-	VM_MODE_P40V48_4K,
-	VM_MODE_P40V48_16K,
-	VM_MODE_P40V48_64K,
-	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
-	VM_MODE_P47V64_4K,
-	VM_MODE_P44V64_4K,
-	VM_MODE_P36V48_4K,
-	VM_MODE_P36V48_16K,
-	VM_MODE_P36V48_64K,
-	VM_MODE_P36V47_16K,
-	NUM_VM_MODES,
-};
-
-struct vm_shape {
-	uint32_t type;
-	uint8_t  mode;
-	uint8_t  subtype;
-	uint16_t padding;
-};
-
-kvm_static_assert(sizeof(struct vm_shape) == sizeof(uint64_t));
-
-#define VM_TYPE_DEFAULT			0
-
-#define VM_SHAPE(__mode)			\
-({						\
-	struct vm_shape shape = {		\
-		.mode = (__mode),		\
-		.type = VM_TYPE_DEFAULT		\
-	};					\
-						\
-	shape;					\
-})
-
-#if defined(__aarch64__)
-
-extern enum vm_guest_mode vm_mode_default;
-
-#define VM_MODE_DEFAULT			vm_mode_default
-#define MIN_PAGE_SHIFT			12U
-#define ptes_per_page(page_size)	((page_size) / 8)
-
-#elif defined(__x86_64__)
-
-#define VM_MODE_DEFAULT			VM_MODE_PXXV48_4K
-#define MIN_PAGE_SHIFT			12U
-#define ptes_per_page(page_size)	((page_size) / 8)
-
-#elif defined(__s390x__)
-
-#define VM_MODE_DEFAULT			VM_MODE_P44V64_4K
-#define MIN_PAGE_SHIFT			12U
-#define ptes_per_page(page_size)	((page_size) / 16)
-
-#elif defined(__riscv)
-
-#if __riscv_xlen == 32
-#error "RISC-V 32-bit kvm selftests not supported"
-#endif
-
-#define VM_MODE_DEFAULT			VM_MODE_P40V48_4K
-#define MIN_PAGE_SHIFT			12U
-#define ptes_per_page(page_size)	((page_size) / 8)
-
-#endif
-
-#define VM_SHAPE_DEFAULT	VM_SHAPE(VM_MODE_DEFAULT)
-
-#define MIN_PAGE_SIZE		(1U << MIN_PAGE_SHIFT)
-#define PTES_PER_MIN_PAGE	ptes_per_page(MIN_PAGE_SIZE)
-
-struct vm_guest_mode_params {
-	unsigned int pa_bits;
-	unsigned int va_bits;
-	unsigned int page_size;
-	unsigned int page_shift;
-};
-extern const struct vm_guest_mode_params vm_guest_mode_params[];
-
-int open_path_or_exit(const char *path, int flags);
-int open_kvm_dev_path_or_exit(void);
-
-bool get_kvm_param_bool(const char *param);
-bool get_kvm_intel_param_bool(const char *param);
-bool get_kvm_amd_param_bool(const char *param);
-
-int get_kvm_param_integer(const char *param);
-int get_kvm_intel_param_integer(const char *param);
-int get_kvm_amd_param_integer(const char *param);
-
-unsigned int kvm_check_cap(long cap);
-
-static inline bool kvm_has_cap(long cap)
-{
-	return kvm_check_cap(cap);
-}
-
-#define __KVM_SYSCALL_ERROR(_name, _ret) \
-	"%s failed, rc: %i errno: %i (%s)", (_name), (_ret), errno, strerror(errno)
-
-/*
- * Use the "inner", double-underscore macro when reporting errors from within
- * other macros so that the name of ioctl() and not its literal numeric value
- * is printed on error.  The "outer" macro is strongly preferred when reporting
- * errors "directly", i.e. without an additional layer of macros, as it reduces
- * the probability of passing in the wrong string.
- */
-#define __KVM_IOCTL_ERROR(_name, _ret)	__KVM_SYSCALL_ERROR(_name, _ret)
-#define KVM_IOCTL_ERROR(_ioctl, _ret) __KVM_IOCTL_ERROR(#_ioctl, _ret)
-
-#define kvm_do_ioctl(fd, cmd, arg)						\
-({										\
-	kvm_static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) == _IOC_SIZE(cmd));	\
-	ioctl(fd, cmd, arg);							\
-})
-
-#define __kvm_ioctl(kvm_fd, cmd, arg)				\
-	kvm_do_ioctl(kvm_fd, cmd, arg)
-
-#define kvm_ioctl(kvm_fd, cmd, arg)				\
-({								\
-	int ret = __kvm_ioctl(kvm_fd, cmd, arg);		\
-								\
-	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
-})
-
-static __always_inline void static_assert_is_vm(struct kvm_vm *vm) { }
-
-#define __vm_ioctl(vm, cmd, arg)				\
-({								\
-	static_assert_is_vm(vm);				\
-	kvm_do_ioctl((vm)->fd, cmd, arg);			\
-})
-
-/*
- * Assert that a VM or vCPU ioctl() succeeded, with extra magic to detect if
- * the ioctl() failed because KVM killed/bugged the VM.  To detect a dead VM,
- * probe KVM_CAP_USER_MEMORY, which (a) has been supported by KVM since before
- * selftests existed and (b) should never outright fail, i.e. is supposed to
- * return 0 or 1.  If KVM kills a VM, KVM returns -EIO for all ioctl()s for the
- * VM and its vCPUs, including KVM_CHECK_EXTENSION.
- */
-#define __TEST_ASSERT_VM_VCPU_IOCTL(cond, name, ret, vm)				\
-do {											\
-	int __errno = errno;								\
-											\
-	static_assert_is_vm(vm);							\
-											\
-	if (cond)									\
-		break;									\
-											\
-	if (errno == EIO &&								\
-	    __vm_ioctl(vm, KVM_CHECK_EXTENSION, (void *)KVM_CAP_USER_MEMORY) < 0) {	\
-		TEST_ASSERT(errno == EIO, "KVM killed the VM, should return -EIO");	\
-		TEST_FAIL("KVM killed/bugged the VM, check the kernel log for clues");	\
-	}										\
-	errno = __errno;								\
-	TEST_ASSERT(cond, __KVM_IOCTL_ERROR(name, ret));				\
-} while (0)
-
-#define TEST_ASSERT_VM_VCPU_IOCTL(cond, cmd, ret, vm)		\
-	__TEST_ASSERT_VM_VCPU_IOCTL(cond, #cmd, ret, vm)
-
-#define vm_ioctl(vm, cmd, arg)					\
-({								\
-	int ret = __vm_ioctl(vm, cmd, arg);			\
-								\
-	__TEST_ASSERT_VM_VCPU_IOCTL(!ret, #cmd, ret, vm);		\
-})
-
-static __always_inline void static_assert_is_vcpu(struct kvm_vcpu *vcpu) { }
-
-#define __vcpu_ioctl(vcpu, cmd, arg)				\
-({								\
-	static_assert_is_vcpu(vcpu);				\
-	kvm_do_ioctl((vcpu)->fd, cmd, arg);			\
-})
-
-#define vcpu_ioctl(vcpu, cmd, arg)				\
-({								\
-	int ret = __vcpu_ioctl(vcpu, cmd, arg);			\
-								\
-	__TEST_ASSERT_VM_VCPU_IOCTL(!ret, #cmd, ret, (vcpu)->vm);	\
-})
-
-/*
- * Looks up and returns the value corresponding to the capability
- * (KVM_CAP_*) given by cap.
- */
-static inline int vm_check_cap(struct kvm_vm *vm, long cap)
-{
-	int ret =  __vm_ioctl(vm, KVM_CHECK_EXTENSION, (void *)cap);
-
-	TEST_ASSERT_VM_VCPU_IOCTL(ret >= 0, KVM_CHECK_EXTENSION, ret, vm);
-	return ret;
-}
-
-static inline int __vm_enable_cap(struct kvm_vm *vm, uint32_t cap, uint64_t arg0)
-{
-	struct kvm_enable_cap enable_cap = { .cap = cap, .args = { arg0 } };
-
-	return __vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
-}
-static inline void vm_enable_cap(struct kvm_vm *vm, uint32_t cap, uint64_t arg0)
-{
-	struct kvm_enable_cap enable_cap = { .cap = cap, .args = { arg0 } };
-
-	vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
-}
-
-static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
-					    uint64_t size, uint64_t attributes)
-{
-	struct kvm_memory_attributes attr = {
-		.attributes = attributes,
-		.address = gpa,
-		.size = size,
-		.flags = 0,
-	};
-
-	/*
-	 * KVM_SET_MEMORY_ATTRIBUTES overwrites _all_ attributes.  These flows
-	 * need significant enhancements to support multiple attributes.
-	 */
-	TEST_ASSERT(!attributes || attributes == KVM_MEMORY_ATTRIBUTE_PRIVATE,
-		    "Update me to support multiple attributes!");
-
-	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES, &attr);
-}
-
-
-static inline void vm_mem_set_private(struct kvm_vm *vm, uint64_t gpa,
-				      uint64_t size)
-{
-	vm_set_memory_attributes(vm, gpa, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
-}
-
-static inline void vm_mem_set_shared(struct kvm_vm *vm, uint64_t gpa,
-				     uint64_t size)
-{
-	vm_set_memory_attributes(vm, gpa, size, 0);
-}
-
-void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t gpa, uint64_t size,
-			    bool punch_hole);
-
-static inline void vm_guest_mem_punch_hole(struct kvm_vm *vm, uint64_t gpa,
-					   uint64_t size)
-{
-	vm_guest_mem_fallocate(vm, gpa, size, true);
-}
-
-static inline void vm_guest_mem_allocate(struct kvm_vm *vm, uint64_t gpa,
-					 uint64_t size)
-{
-	vm_guest_mem_fallocate(vm, gpa, size, false);
-}
-
-void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size);
-const char *vm_guest_mode_string(uint32_t i);
-
-void kvm_vm_free(struct kvm_vm *vmp);
-void kvm_vm_restart(struct kvm_vm *vmp);
-void kvm_vm_release(struct kvm_vm *vmp);
-int kvm_memcmp_hva_gva(void *hva, struct kvm_vm *vm, const vm_vaddr_t gva,
-		       size_t len);
-void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename);
-int kvm_memfd_alloc(size_t size, bool hugepages);
-
-void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
-
-static inline void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot, void *log)
-{
-	struct kvm_dirty_log args = { .dirty_bitmap = log, .slot = slot };
-
-	vm_ioctl(vm, KVM_GET_DIRTY_LOG, &args);
-}
-
-static inline void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slot, void *log,
-					  uint64_t first_page, uint32_t num_pages)
-{
-	struct kvm_clear_dirty_log args = {
-		.dirty_bitmap = log,
-		.slot = slot,
-		.first_page = first_page,
-		.num_pages = num_pages
-	};
-
-	vm_ioctl(vm, KVM_CLEAR_DIRTY_LOG, &args);
-}
-
-static inline uint32_t kvm_vm_reset_dirty_ring(struct kvm_vm *vm)
-{
-	return __vm_ioctl(vm, KVM_RESET_DIRTY_RINGS, NULL);
-}
-
-static inline int vm_get_stats_fd(struct kvm_vm *vm)
-{
-	int fd = __vm_ioctl(vm, KVM_GET_STATS_FD, NULL);
-
-	TEST_ASSERT_VM_VCPU_IOCTL(fd >= 0, KVM_GET_STATS_FD, fd, vm);
-	return fd;
-}
-
-static inline void read_stats_header(int stats_fd, struct kvm_stats_header *header)
-{
-	ssize_t ret;
-
-	ret = pread(stats_fd, header, sizeof(*header), 0);
-	TEST_ASSERT(ret == sizeof(*header),
-		    "Failed to read '%lu' header bytes, ret = '%ld'",
-		    sizeof(*header), ret);
-}
-
-struct kvm_stats_desc *read_stats_descriptors(int stats_fd,
-					      struct kvm_stats_header *header);
-
-static inline ssize_t get_stats_descriptor_size(struct kvm_stats_header *header)
-{
-	 /*
-	  * The base size of the descriptor is defined by KVM's ABI, but the
-	  * size of the name field is variable, as far as KVM's ABI is
-	  * concerned. For a given instance of KVM, the name field is the same
-	  * size for all stats and is provided in the overall stats header.
-	  */
-	return sizeof(struct kvm_stats_desc) + header->name_size;
-}
-
-static inline struct kvm_stats_desc *get_stats_descriptor(struct kvm_stats_desc *stats,
-							  int index,
-							  struct kvm_stats_header *header)
-{
-	/*
-	 * Note, size_desc includes the size of the name field, which is
-	 * variable. i.e. this is NOT equivalent to &stats_desc[i].
-	 */
-	return (void *)stats + index * get_stats_descriptor_size(header);
-}
-
-void read_stat_data(int stats_fd, struct kvm_stats_header *header,
-		    struct kvm_stats_desc *desc, uint64_t *data,
-		    size_t max_elements);
-
-void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
-		   size_t max_elements);
-
-static inline uint64_t vm_get_stat(struct kvm_vm *vm, const char *stat_name)
-{
-	uint64_t data;
-
-	__vm_get_stat(vm, stat_name, &data, 1);
-	return data;
-}
-
-void vm_create_irqchip(struct kvm_vm *vm);
-
-static inline int __vm_create_guest_memfd(struct kvm_vm *vm, uint64_t size,
-					uint64_t flags)
-{
-	struct kvm_create_guest_memfd guest_memfd = {
-		.size = size,
-		.flags = flags,
-	};
-
-	return __vm_ioctl(vm, KVM_CREATE_GUEST_MEMFD, &guest_memfd);
-}
-
-static inline int vm_create_guest_memfd(struct kvm_vm *vm, uint64_t size,
-					uint64_t flags)
-{
-	int fd = __vm_create_guest_memfd(vm, size, flags);
-
-	TEST_ASSERT(fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_GUEST_MEMFD, fd));
-	return fd;
-}
-
-void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
-			       uint64_t gpa, uint64_t size, void *hva);
-int __vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
-				uint64_t gpa, uint64_t size, void *hva);
-void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
-				uint64_t gpa, uint64_t size, void *hva,
-				uint32_t guest_memfd, uint64_t guest_memfd_offset);
-int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
-				 uint64_t gpa, uint64_t size, void *hva,
-				 uint32_t guest_memfd, uint64_t guest_memfd_offset);
-
-void vm_userspace_mem_region_add(struct kvm_vm *vm,
-	enum vm_mem_backing_src_type src_type,
-	uint64_t guest_paddr, uint32_t slot, uint64_t npages,
-	uint32_t flags);
-void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
-		uint64_t guest_paddr, uint32_t slot, uint64_t npages,
-		uint32_t flags, int guest_memfd_fd, uint64_t guest_memfd_offset);
-
-#ifndef vm_arch_has_protected_memory
-static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
-{
-	return false;
-}
-#endif
-
-void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
-void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
-void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
-struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
-void vm_populate_vaddr_bitmap(struct kvm_vm *vm);
-vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
-vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
-vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
-			    enum kvm_mem_region_type type);
-vm_vaddr_t vm_vaddr_alloc_shared(struct kvm_vm *vm, size_t sz,
-				 vm_vaddr_t vaddr_min,
-				 enum kvm_mem_region_type type);
-vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
-vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm,
-				 enum kvm_mem_region_type type);
-vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
-
-void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-	      unsigned int npages);
-void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa);
-void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
-vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
-void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
-
-
-static inline vm_paddr_t vm_untag_gpa(struct kvm_vm *vm, vm_paddr_t gpa)
-{
-	return gpa & ~vm->gpa_tag_mask;
-}
-
-void vcpu_run(struct kvm_vcpu *vcpu);
-int _vcpu_run(struct kvm_vcpu *vcpu);
-
-static inline int __vcpu_run(struct kvm_vcpu *vcpu)
-{
-	return __vcpu_ioctl(vcpu, KVM_RUN, NULL);
-}
-
-void vcpu_run_complete_io(struct kvm_vcpu *vcpu);
-struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vcpu *vcpu);
-
-static inline void vcpu_enable_cap(struct kvm_vcpu *vcpu, uint32_t cap,
-				   uint64_t arg0)
-{
-	struct kvm_enable_cap enable_cap = { .cap = cap, .args = { arg0 } };
-
-	vcpu_ioctl(vcpu, KVM_ENABLE_CAP, &enable_cap);
-}
-
-static inline void vcpu_guest_debug_set(struct kvm_vcpu *vcpu,
-					struct kvm_guest_debug *debug)
-{
-	vcpu_ioctl(vcpu, KVM_SET_GUEST_DEBUG, debug);
-}
-
-static inline void vcpu_mp_state_get(struct kvm_vcpu *vcpu,
-				     struct kvm_mp_state *mp_state)
-{
-	vcpu_ioctl(vcpu, KVM_GET_MP_STATE, mp_state);
-}
-static inline void vcpu_mp_state_set(struct kvm_vcpu *vcpu,
-				     struct kvm_mp_state *mp_state)
-{
-	vcpu_ioctl(vcpu, KVM_SET_MP_STATE, mp_state);
-}
-
-static inline void vcpu_regs_get(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
-{
-	vcpu_ioctl(vcpu, KVM_GET_REGS, regs);
-}
-
-static inline void vcpu_regs_set(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
-{
-	vcpu_ioctl(vcpu, KVM_SET_REGS, regs);
-}
-static inline void vcpu_sregs_get(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
-{
-	vcpu_ioctl(vcpu, KVM_GET_SREGS, sregs);
-
-}
-static inline void vcpu_sregs_set(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
-{
-	vcpu_ioctl(vcpu, KVM_SET_SREGS, sregs);
-}
-static inline int _vcpu_sregs_set(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
-{
-	return __vcpu_ioctl(vcpu, KVM_SET_SREGS, sregs);
-}
-static inline void vcpu_fpu_get(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
-{
-	vcpu_ioctl(vcpu, KVM_GET_FPU, fpu);
-}
-static inline void vcpu_fpu_set(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
-{
-	vcpu_ioctl(vcpu, KVM_SET_FPU, fpu);
-}
-
-static inline int __vcpu_get_reg(struct kvm_vcpu *vcpu, uint64_t id, void *addr)
-{
-	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)addr };
-
-	return __vcpu_ioctl(vcpu, KVM_GET_ONE_REG, &reg);
-}
-static inline int __vcpu_set_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t val)
-{
-	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
-
-	return __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
-}
-static inline void vcpu_get_reg(struct kvm_vcpu *vcpu, uint64_t id, void *addr)
-{
-	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)addr };
-
-	vcpu_ioctl(vcpu, KVM_GET_ONE_REG, &reg);
-}
-static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, uint64_t id, uint64_t val)
-{
-	struct kvm_one_reg reg = { .id = id, .addr = (uint64_t)&val };
-
-	vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
-}
-
-#ifdef __KVM_HAVE_VCPU_EVENTS
-static inline void vcpu_events_get(struct kvm_vcpu *vcpu,
-				   struct kvm_vcpu_events *events)
-{
-	vcpu_ioctl(vcpu, KVM_GET_VCPU_EVENTS, events);
-}
-static inline void vcpu_events_set(struct kvm_vcpu *vcpu,
-				   struct kvm_vcpu_events *events)
-{
-	vcpu_ioctl(vcpu, KVM_SET_VCPU_EVENTS, events);
-}
-#endif
-#ifdef __x86_64__
-static inline void vcpu_nested_state_get(struct kvm_vcpu *vcpu,
-					 struct kvm_nested_state *state)
-{
-	vcpu_ioctl(vcpu, KVM_GET_NESTED_STATE, state);
-}
-static inline int __vcpu_nested_state_set(struct kvm_vcpu *vcpu,
-					  struct kvm_nested_state *state)
-{
-	return __vcpu_ioctl(vcpu, KVM_SET_NESTED_STATE, state);
-}
-
-static inline void vcpu_nested_state_set(struct kvm_vcpu *vcpu,
-					 struct kvm_nested_state *state)
-{
-	vcpu_ioctl(vcpu, KVM_SET_NESTED_STATE, state);
-}
-#endif
-static inline int vcpu_get_stats_fd(struct kvm_vcpu *vcpu)
-{
-	int fd = __vcpu_ioctl(vcpu, KVM_GET_STATS_FD, NULL);
-
-	TEST_ASSERT_VM_VCPU_IOCTL(fd >= 0, KVM_CHECK_EXTENSION, fd, vcpu->vm);
-	return fd;
-}
-
-int __kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr);
-
-static inline void kvm_has_device_attr(int dev_fd, uint32_t group, uint64_t attr)
-{
-	int ret = __kvm_has_device_attr(dev_fd, group, attr);
-
-	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR failed, rc: %i errno: %i", ret, errno);
-}
-
-int __kvm_device_attr_get(int dev_fd, uint32_t group, uint64_t attr, void *val);
-
-static inline void kvm_device_attr_get(int dev_fd, uint32_t group,
-				       uint64_t attr, void *val)
-{
-	int ret = __kvm_device_attr_get(dev_fd, group, attr, val);
-
-	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_GET_DEVICE_ATTR, ret));
-}
-
-int __kvm_device_attr_set(int dev_fd, uint32_t group, uint64_t attr, void *val);
-
-static inline void kvm_device_attr_set(int dev_fd, uint32_t group,
-				       uint64_t attr, void *val)
-{
-	int ret = __kvm_device_attr_set(dev_fd, group, attr, val);
-
-	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
-}
-
-static inline int __vcpu_has_device_attr(struct kvm_vcpu *vcpu, uint32_t group,
-					 uint64_t attr)
-{
-	return __kvm_has_device_attr(vcpu->fd, group, attr);
-}
-
-static inline void vcpu_has_device_attr(struct kvm_vcpu *vcpu, uint32_t group,
-					uint64_t attr)
-{
-	kvm_has_device_attr(vcpu->fd, group, attr);
-}
-
-static inline int __vcpu_device_attr_get(struct kvm_vcpu *vcpu, uint32_t group,
-					 uint64_t attr, void *val)
-{
-	return __kvm_device_attr_get(vcpu->fd, group, attr, val);
-}
-
-static inline void vcpu_device_attr_get(struct kvm_vcpu *vcpu, uint32_t group,
-					uint64_t attr, void *val)
-{
-	kvm_device_attr_get(vcpu->fd, group, attr, val);
-}
-
-static inline int __vcpu_device_attr_set(struct kvm_vcpu *vcpu, uint32_t group,
-					 uint64_t attr, void *val)
-{
-	return __kvm_device_attr_set(vcpu->fd, group, attr, val);
-}
-
-static inline void vcpu_device_attr_set(struct kvm_vcpu *vcpu, uint32_t group,
-					uint64_t attr, void *val)
-{
-	kvm_device_attr_set(vcpu->fd, group, attr, val);
-}
-
-int __kvm_test_create_device(struct kvm_vm *vm, uint64_t type);
-int __kvm_create_device(struct kvm_vm *vm, uint64_t type);
-
-static inline int kvm_create_device(struct kvm_vm *vm, uint64_t type)
-{
-	int fd = __kvm_create_device(vm, type);
-
-	TEST_ASSERT(fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_DEVICE, fd));
-	return fd;
-}
-
-void *vcpu_map_dirty_ring(struct kvm_vcpu *vcpu);
-
-/*
- * VM VCPU Args Set
- *
- * Input Args:
- *   vm - Virtual Machine
- *   num - number of arguments
- *   ... - arguments, each of type uint64_t
- *
- * Output Args: None
- *
- * Return: None
- *
- * Sets the first @num input parameters for the function at @vcpu's entry point,
- * per the C calling convention of the architecture, to the values given as
- * variable args. Each of the variable args is expected to be of type uint64_t.
- * The maximum @num can be is specific to the architecture.
- */
-void vcpu_args_set(struct kvm_vcpu *vcpu, unsigned int num, ...);
-
-void kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level);
-int _kvm_irq_line(struct kvm_vm *vm, uint32_t irq, int level);
-
-#define KVM_MAX_IRQ_ROUTES		4096
-
-struct kvm_irq_routing *kvm_gsi_routing_create(void);
-void kvm_gsi_routing_irqchip_add(struct kvm_irq_routing *routing,
-		uint32_t gsi, uint32_t pin);
-int _kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing);
-void kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing);
-
-const char *exit_reason_str(unsigned int exit_reason);
-
-vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
-			     uint32_t memslot);
-vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-				vm_paddr_t paddr_min, uint32_t memslot,
-				bool protected);
-vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
-
-static inline vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-					    vm_paddr_t paddr_min, uint32_t memslot)
-{
-	/*
-	 * By default, allocate memory as protected for VMs that support
-	 * protected memory, as the majority of memory for such VMs is
-	 * protected, i.e. using shared memory is effectively opt-in.
-	 */
-	return __vm_phy_pages_alloc(vm, num, paddr_min, memslot,
-				    vm_arch_has_protected_memory(vm));
-}
-
-/*
- * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
- * loads the test binary into guest memory and creates an IRQ chip (x86 only).
- * __vm_create() does NOT create vCPUs, @nr_runnable_vcpus is used purely to
- * calculate the amount of memory needed for per-vCPU data, e.g. stacks.
- */
-struct kvm_vm *____vm_create(struct vm_shape shape);
-struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
-			   uint64_t nr_extra_pages);
-
-static inline struct kvm_vm *vm_create_barebones(void)
-{
-	return ____vm_create(VM_SHAPE_DEFAULT);
-}
-
-#ifdef __x86_64__
-static inline struct kvm_vm *vm_create_barebones_protected_vm(void)
-{
-	const struct vm_shape shape = {
-		.mode = VM_MODE_DEFAULT,
-		.type = KVM_X86_SW_PROTECTED_VM,
-	};
-
-	return ____vm_create(shape);
-}
-#endif
-
-static inline struct kvm_vm *vm_create(uint32_t nr_runnable_vcpus)
-{
-	return __vm_create(VM_SHAPE_DEFAULT, nr_runnable_vcpus, 0);
-}
-
-struct kvm_vm *__vm_create_with_vcpus(struct vm_shape shape, uint32_t nr_vcpus,
-				      uint64_t extra_mem_pages,
-				      void *guest_code, struct kvm_vcpu *vcpus[]);
-
-static inline struct kvm_vm *vm_create_with_vcpus(uint32_t nr_vcpus,
-						  void *guest_code,
-						  struct kvm_vcpu *vcpus[])
-{
-	return __vm_create_with_vcpus(VM_SHAPE_DEFAULT, nr_vcpus, 0,
-				      guest_code, vcpus);
-}
-
-
-struct kvm_vm *__vm_create_shape_with_one_vcpu(struct vm_shape shape,
-					       struct kvm_vcpu **vcpu,
-					       uint64_t extra_mem_pages,
-					       void *guest_code);
-
-/*
- * Create a VM with a single vCPU with reasonable defaults and @extra_mem_pages
- * additional pages of guest memory.  Returns the VM and vCPU (via out param).
- */
-static inline struct kvm_vm *__vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
-						       uint64_t extra_mem_pages,
-						       void *guest_code)
-{
-	return __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, vcpu,
-					       extra_mem_pages, guest_code);
-}
-
-static inline struct kvm_vm *vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
-						     void *guest_code)
-{
-	return __vm_create_with_one_vcpu(vcpu, 0, guest_code);
-}
-
-static inline struct kvm_vm *vm_create_shape_with_one_vcpu(struct vm_shape shape,
-							   struct kvm_vcpu **vcpu,
-							   void *guest_code)
-{
-	return __vm_create_shape_with_one_vcpu(shape, vcpu, 0, guest_code);
-}
-
-struct kvm_vcpu *vm_recreate_with_one_vcpu(struct kvm_vm *vm);
-
-void kvm_pin_this_task_to_pcpu(uint32_t pcpu);
-void kvm_print_vcpu_pinning_help(void);
-void kvm_parse_vcpu_pinning(const char *pcpus_string, uint32_t vcpu_to_pcpu[],
-			    int nr_vcpus);
-
-unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
-unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size);
-unsigned int vm_num_host_pages(enum vm_guest_mode mode, unsigned int num_guest_pages);
-unsigned int vm_num_guest_pages(enum vm_guest_mode mode, unsigned int num_host_pages);
-static inline unsigned int
-vm_adjust_num_guest_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
-{
-	unsigned int n;
-	n = vm_num_guest_pages(mode, vm_num_host_pages(mode, num_guest_pages));
-#ifdef __s390x__
-	/* s390 requires 1M aligned guest sizes */
-	n = (n + 255) & ~255;
-#endif
-	return n;
-}
-
-#define sync_global_to_guest(vm, g) ({				\
-	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
-	memcpy(_p, &(g), sizeof(g));				\
-})
-
-#define sync_global_from_guest(vm, g) ({			\
-	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
-	memcpy(&(g), _p, sizeof(g));				\
-})
-
-/*
- * Write a global value, but only in the VM's (guest's) domain.  Primarily used
- * for "globals" that hold per-VM values (VMs always duplicate code and global
- * data into their own region of physical memory), but can be used anytime it's
- * undesirable to change the host's copy of the global.
- */
-#define write_guest_global(vm, g, val) ({			\
-	typeof(g) *_p = addr_gva2hva(vm, (vm_vaddr_t)&(g));	\
-	typeof(g) _val = val;					\
-								\
-	memcpy(_p, &(_val), sizeof(g));				\
-})
-
-void assert_on_unhandled_exception(struct kvm_vcpu *vcpu);
-
-void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu,
-		    uint8_t indent);
-
-static inline void vcpu_dump(FILE *stream, struct kvm_vcpu *vcpu,
-			     uint8_t indent)
-{
-	vcpu_arch_dump(stream, vcpu, indent);
-}
-
-/*
- * Adds a vCPU with reasonable defaults (e.g. a stack)
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpu_id - The id of the VCPU to add to the VM.
- */
-struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
-void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code);
-
-static inline struct kvm_vcpu *vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
-					   void *guest_code)
-{
-	struct kvm_vcpu *vcpu = vm_arch_vcpu_add(vm, vcpu_id);
-
-	vcpu_arch_set_entry_point(vcpu, guest_code);
-
-	return vcpu;
-}
-
-/* Re-create a vCPU after restarting a VM, e.g. for state save/restore tests. */
-struct kvm_vcpu *vm_arch_vcpu_recreate(struct kvm_vm *vm, uint32_t vcpu_id);
-
-static inline struct kvm_vcpu *vm_vcpu_recreate(struct kvm_vm *vm,
-						uint32_t vcpu_id)
-{
-	return vm_arch_vcpu_recreate(vm, vcpu_id);
-}
-
-void vcpu_arch_free(struct kvm_vcpu *vcpu);
-
-void virt_arch_pgd_alloc(struct kvm_vm *vm);
-
-static inline void virt_pgd_alloc(struct kvm_vm *vm)
-{
-	virt_arch_pgd_alloc(vm);
-}
-
-/*
- * VM Virtual Page Map
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vaddr - VM Virtual Address
- *   paddr - VM Physical Address
- *   memslot - Memory region slot for new virtual translation tables
- *
- * Output Args: None
- *
- * Return: None
- *
- * Within @vm, creates a virtual translation for the page starting
- * at @vaddr to the page starting at @paddr.
- */
-void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr);
-
-static inline void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
-{
-	virt_arch_pg_map(vm, vaddr, paddr);
-}
-
-
-/*
- * Address Guest Virtual to Guest Physical
- *
- * Input Args:
- *   vm - Virtual Machine
- *   gva - VM virtual address
- *
- * Output Args: None
- *
- * Return:
- *   Equivalent VM physical address
- *
- * Returns the VM physical address of the translated VM virtual
- * address given by @gva.
- */
-vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
-
-static inline vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
-{
-	return addr_arch_gva2gpa(vm, gva);
-}
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
-void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
-
-static inline void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
-{
-	virt_arch_dump(stream, vm, indent);
-}
-
-
-static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
-{
-	return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
-}
-
-/*
- * Arch hook that is invoked via a constructor, i.e. before exeucting main(),
- * to allow for arch-specific setup that is common to all tests, e.g. computing
- * the default guest "mode".
- */
-void kvm_selftest_arch_init(void);
-
-void kvm_arch_vm_post_create(struct kvm_vm *vm);
-
-bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr);
-
-uint32_t guest_get_vcpuid(void);
-
-#endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/include/s390x/ucall.h b/tools/testing/selftests/kvm/include/s390x/ucall.h
index b231bf2e49d6..8035a872a351 100644
--- a/tools/testing/selftests/kvm/include/s390x/ucall.h
+++ b/tools/testing/selftests/kvm/include/s390x/ucall.h
@@ -2,7 +2,7 @@
 #ifndef SELFTEST_KVM_UCALL_H
 #define SELFTEST_KVM_UCALL_H
 
-#include "kvm_util_base.h"
+#include "kvm_util.h"
 
 #define UCALL_EXIT_REASON       KVM_EXIT_S390_SIEIC
 
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 3bd03b088dda..d6ffe03c9d0b 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -18,7 +18,8 @@
 #include <linux/kvm_para.h>
 #include <linux/stringify.h>
 
-#include "../kvm_util.h"
+#include "kvm_util.h"
+#include "ucall_common.h"
 
 extern bool host_cpu_is_intel;
 extern bool host_cpu_is_amd;
diff --git a/tools/testing/selftests/kvm/include/x86_64/ucall.h b/tools/testing/selftests/kvm/include/x86_64/ucall.h
index 06b244bd06ee..d3825dcc3cd9 100644
--- a/tools/testing/selftests/kvm/include/x86_64/ucall.h
+++ b/tools/testing/selftests/kvm/include/x86_64/ucall.h
@@ -2,7 +2,7 @@
 #ifndef SELFTEST_KVM_UCALL_H
 #define SELFTEST_KVM_UCALL_H
 
-#include "kvm_util_base.h"
+#include "kvm_util.h"
 
 #define UCALL_EXIT_REASON       KVM_EXIT_IO
 
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index e0ba97ac1c56..e16ef18bcfc0 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -21,6 +21,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "guest_modes.h"
+#include "ucall_common.h"
 
 #define TEST_MEM_SLOT_INDEX             1
 
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index a9eb17295be4..0ac7cc89f38c 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -11,6 +11,8 @@
 #include "guest_modes.h"
 #include "kvm_util.h"
 #include "processor.h"
+#include "ucall_common.h"
+
 #include <linux/bitfield.h>
 #include <linux/sizes.h>
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index b2262b5fad9e..cec39b52b90d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -9,6 +9,7 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
+#include "ucall_common.h"
 
 #include <assert.h>
 #include <sched.h>
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index cf2c73971308..96432ad9efa6 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -10,6 +10,7 @@
 #include "kvm_util.h"
 #include "memstress.h"
 #include "processor.h"
+#include "ucall_common.h"
 
 struct memstress_args memstress_args;
 
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index e8211f5d6863..79b67e2627cb 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -10,6 +10,7 @@
 
 #include "kvm_util.h"
 #include "processor.h"
+#include "ucall_common.h"
 
 #define DEFAULT_RISCV_GUEST_STACK_VADDR_MIN	0xac0000
 
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index f5af65a41c29..42151e571953 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -1,9 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0-only
-#include "kvm_util.h"
 #include "linux/types.h"
 #include "linux/bitmap.h"
 #include "linux/atomic.h"
 
+#include "kvm_util.h"
+#include "ucall_common.h"
+
+
 #define GUEST_UCALL_FAILED -1
 
 struct ucall_header {
diff --git a/tools/testing/selftests/kvm/riscv/arch_timer.c b/tools/testing/selftests/kvm/riscv/arch_timer.c
index e22848f747c0..d6375af0b23e 100644
--- a/tools/testing/selftests/kvm/riscv/arch_timer.c
+++ b/tools/testing/selftests/kvm/riscv/arch_timer.c
@@ -14,6 +14,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "timer_test.h"
+#include "ucall_common.h"
 
 static int timer_irq = IRQ_S_TIMER;
 
diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 28f97fb52044..d81f9b9c5809 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -19,6 +19,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "test_util.h"
+#include "ucall_common.h"
 
 #include "../rseq/rseq.c"
 
diff --git a/tools/testing/selftests/kvm/s390x/cmma_test.c b/tools/testing/selftests/kvm/s390x/cmma_test.c
index 626a2b8a2037..9e0033906638 100644
--- a/tools/testing/selftests/kvm/s390x/cmma_test.c
+++ b/tools/testing/selftests/kvm/s390x/cmma_test.c
@@ -18,6 +18,7 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "kselftest.h"
+#include "ucall_common.h"
 
 #define MAIN_PAGE_COUNT 512
 
diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
index bb3ca9a5d731..9b31693be1cb 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -15,6 +15,7 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "kselftest.h"
+#include "ucall_common.h"
 
 enum mop_target {
 	LOGICAL,
diff --git a/tools/testing/selftests/kvm/s390x/tprot.c b/tools/testing/selftests/kvm/s390x/tprot.c
index c73f948c9b63..7a742a673b7c 100644
--- a/tools/testing/selftests/kvm/s390x/tprot.c
+++ b/tools/testing/selftests/kvm/s390x/tprot.c
@@ -8,6 +8,7 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "kselftest.h"
+#include "ucall_common.h"
 
 #define PAGE_SHIFT 12
 #define PAGE_SIZE (1 << PAGE_SHIFT)
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index bae0c5026f82..4c669d0cb8c0 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -18,6 +18,7 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
+#include "ucall_common.h"
 
 #define NR_VCPUS		4
 #define ST_GPA_BASE		(1 << 30)
diff --git a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
index ee3b384b991c..2929c067c207 100644
--- a/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
+++ b/tools/testing/selftests/kvm/x86_64/dirty_log_page_splitting_test.c
@@ -17,6 +17,7 @@
 #include "test_util.h"
 #include "memstress.h"
 #include "guest_modes.h"
+#include "ucall_common.h"
 
 #define VCPUS		2
 #define SLOTS		2
diff --git a/tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c b/tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c
index 6c2e5e0ceb1f..fbac69d49b39 100644
--- a/tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c
+++ b/tools/testing/selftests/kvm/x86_64/exit_on_emulation_failure_test.c
@@ -8,8 +8,8 @@
 #define _GNU_SOURCE /* for program_invocation_short_name */
 
 #include "flds_emulation.h"
-
 #include "test_util.h"
+#include "ucall_common.h"
 
 #define MMIO_GPA	0x700000000
 #define MMIO_GVA	MMIO_GPA
diff --git a/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c b/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
index dcbb3c29fb8e..bc9be20f9600 100644
--- a/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
+++ b/tools/testing/selftests/kvm/x86_64/ucna_injection_test.c
@@ -24,7 +24,6 @@
 #include <string.h>
 #include <time.h>
 
-#include "kvm_util_base.h"
 #include "kvm_util.h"
 #include "mce.h"
 #include "processor.h"
-- 
2.44.0.291.gc1ea87d7ee-goog


