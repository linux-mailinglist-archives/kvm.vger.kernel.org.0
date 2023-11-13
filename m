Return-Path: <kvm+bounces-1551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 059D77E94F1
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 03:33:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEAC4281024
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 02:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69EF51C6B3;
	Mon, 13 Nov 2023 02:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="JKmMqdli"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111BC18634
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 02:32:32 +0000 (UTC)
X-Greylist: delayed 501 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 12 Nov 2023 18:32:28 PST
Received: from smtp-8fac.mail.infomaniak.ch (smtp-8fac.mail.infomaniak.ch [83.166.143.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B401310D
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 18:32:28 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4STCtb03xVzMpvcL;
	Mon, 13 Nov 2023 02:24:39 +0000 (UTC)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4STCtY6j2Kz3W;
	Mon, 13 Nov 2023 03:24:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1699842278;
	bh=udX3yMbRw+y6U4YMfanKu8XE/62XvcB7w1fSqqDyDOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JKmMqdlijgI0WHD2CFxV/y7DWfB+LUKrwQo0xOX8EfXAZsvA9YZ7OO5gDS9iDz+rl
	 OhhkExnEBcdos98SON70W/UL9RJeu0hGR5koDZT8lkh5am5LEoQnacmgelAtWgQqxy
	 GoKDTdCaRbpksDhhbdbuDq2zFJFNL69+pG5malPA=
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Alexander Graf <graf@amazon.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Forrest Yuan Yu <yuanyu@google.com>,
	James Gowans <jgowans@amazon.com>,
	James Morris <jamorris@linux.microsoft.com>,
	John Andersen <john.s.andersen@intel.com>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Marian Rotariu <marian.c.rotariu@gmail.com>,
	=?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
	=?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
	Thara Gopinath <tgopinath@microsoft.com>,
	Trilok Soni <quic_tsoni@quicinc.com>,
	Wei Liu <wei.liu@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Zahra Tarkhani <ztarkhani@microsoft.com>,
	=?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
	dev@lists.cloudhypervisor.org,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	qemu-devel@nongnu.org,
	virtualization@lists.linux-foundation.org,
	x86@kernel.org,
	xen-devel@lists.xenproject.org
Subject: [RFC PATCH v2 12/19] x86: Implement the Memory Table feature to store arbitrary per-page data
Date: Sun, 12 Nov 2023 21:23:19 -0500
Message-ID: <20231113022326.24388-13-mic@digikod.net>
In-Reply-To: <20231113022326.24388-1-mic@digikod.net>
References: <20231113022326.24388-1-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

From: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>

This feature can be used by a consumer to associate any arbitrary
pointer with a physical page. The feature implements a page table format
that mirrors the hardware page table. A leaf entry in the table points
to consumer data for that page.

The page table format has these advantages:

- The format allows for a sparse representation. This is useful since
  the physical address space can be large and is typically sparsely
  populated in a system.

- A consumer of this feature can choose to populate data just for the
  pages he is interested in.

- Information can be stored for large pages, if a consumer wishes.

For instance, for Heki, the guest kernel uses this to create permissions
counters for each guest physical page. The permissions counters reflects
the collective permissions for a guest physical page across all mappings
to that page. This allows the guest to request the hypervisor to set
only the necessary permissions for a guest physical page in the EPT
(instead of RWX).

This feature could also be used to improve the KVM's memory attribute
and the write page tracking.

We will support large page entries in mem_table in a future version
thanks to extra mem_table_ops's merge() and split() operations.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Cc: Mickaël Salaün <mic@digikod.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---

Changes since v1:
* New patch and new file: kernel/mem_table.c
---
 arch/x86/kernel/setup.c   |   2 +
 include/linux/heki.h      |   1 +
 include/linux/mem_table.h |  55 ++++++++++
 kernel/Makefile           |   2 +
 kernel/mem_table.c        | 219 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 279 insertions(+)
 create mode 100644 include/linux/mem_table.h
 create mode 100644 kernel/mem_table.c

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b098b1fa2470..e7ae46953ae4 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -25,6 +25,7 @@
 #include <linux/static_call.h>
 #include <linux/swiotlb.h>
 #include <linux/random.h>
+#include <linux/mem_table.h>
 
 #include <uapi/linux/mount.h>
 
@@ -1315,6 +1316,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	unwind_init();
+	mem_table_init(PG_LEVEL_4K);
 }
 
 #ifdef CONFIG_X86_32
diff --git a/include/linux/heki.h b/include/linux/heki.h
index 89cc9273a968..9b0c966c50d1 100644
--- a/include/linux/heki.h
+++ b/include/linux/heki.h
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/printk.h>
+#include <linux/slab.h>
 
 #ifdef CONFIG_HEKI
 
diff --git a/include/linux/mem_table.h b/include/linux/mem_table.h
new file mode 100644
index 000000000000..738bf12309f3
--- /dev/null
+++ b/include/linux/mem_table.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Memory table feature - Definitions.
+ *
+ * Copyright © 2023 Microsoft Corporation.
+ */
+
+#ifndef __MEM_TABLE_H__
+#define __MEM_TABLE_H__
+
+/* clang-format off */
+
+/*
+ * The MEM_TABLE bit is set on entries that point to an intermediate table.
+ * So, this bit is reserved. This means that pointers to consumer data must
+ * be at least two-byte aligned (so the MEM_TABLE bit is 0).
+ */
+#define MEM_TABLE		BIT(0)
+#define IS_LEAF(entry)		!((uintptr_t)entry & MEM_TABLE)
+
+/* clang-format on */
+
+/*
+ * A memory table is arranged exactly like a page table. The memory table
+ * configuration reflects the hardware page table configuration.
+ */
+
+/* Parameters at each level of the memory table hierarchy. */
+struct mem_table_level {
+	unsigned int number;
+	unsigned int nentries;
+	unsigned int shift;
+	unsigned int mask;
+};
+
+struct mem_table {
+	struct mem_table_level *level;
+	struct mem_table_ops *ops;
+	bool changed;
+	void *entries[];
+};
+
+/* Operations that need to be supplied by a consumer of memory tables. */
+struct mem_table_ops {
+	void (*free)(void *buf);
+};
+
+void mem_table_init(unsigned int base_level);
+struct mem_table *mem_table_alloc(struct mem_table_ops *ops);
+void mem_table_free(struct mem_table *table);
+void **mem_table_create(struct mem_table *table, phys_addr_t pa);
+void **mem_table_find(struct mem_table *table, phys_addr_t pa,
+		      unsigned int *level_num);
+
+#endif /* __MEM_TABLE_H__ */
diff --git a/kernel/Makefile b/kernel/Makefile
index 3947122d618b..dcef03ec5c54 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -131,6 +131,8 @@ obj-$(CONFIG_WATCH_QUEUE) += watch_queue.o
 obj-$(CONFIG_RESOURCE_KUNIT_TEST) += resource_kunit.o
 obj-$(CONFIG_SYSCTL_KUNIT_TEST) += sysctl-test.o
 
+obj-$(CONFIG_SPARSEMEM) += mem_table.o
+
 CFLAGS_stackleak.o += $(DISABLE_STACKLEAK_PLUGIN)
 obj-$(CONFIG_GCC_PLUGIN_STACKLEAK) += stackleak.o
 KASAN_SANITIZE_stackleak.o := n
diff --git a/kernel/mem_table.c b/kernel/mem_table.c
new file mode 100644
index 000000000000..280a1b5ddde0
--- /dev/null
+++ b/kernel/mem_table.c
@@ -0,0 +1,219 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Memory table feature.
+ *
+ * This feature can be used by a consumer to associate any arbitrary pointer
+ * with a physical page. The feature implements a page table format that
+ * mirrors the hardware page table. A leaf entry in the table points to
+ * consumer data for that page.
+ *
+ * The page table format has these advantages:
+ *
+ *	- The format allows for a sparse representation. This is useful since
+ *	  the physical address space can be large and is typically sparsely
+ *	  populated in a system.
+ *
+ *	- A consumer of this feature can choose to populate data just for
+ *	  the pages he is interested in.
+ *
+ *	- Information can be stored for large pages, if a consumer wishes.
+ *
+ * For instance, for Heki, the guest kernel uses this to create permissions
+ * counters for each guest physical page. The permissions counters reflects the
+ * collective permissions for a guest physical page across all mappings to that
+ * page. This allows the guest to request the hypervisor to set only the
+ * necessary permissions for a guest physical page in the EPT (instead of RWX).
+ *
+ * Copyright © 2023 Microsoft Corporation.
+ */
+
+/*
+ * Memory table functions use recursion for simplicity. The recursion is bounded
+ * by the number of hardware page table levels.
+ *
+ * Locking is left to the caller of these functions.
+ */
+#include <linux/heki.h>
+#include <linux/mem_table.h>
+#include <linux/pgtable.h>
+
+#define TABLE(entry) ((void *)((uintptr_t)entry & ~MEM_TABLE))
+#define ENTRY(table) ((void *)((uintptr_t)table | MEM_TABLE))
+
+/*
+ * Within this feature, the table levels start from 0. On X86, the base level
+ * is not 0.
+ */
+unsigned int mem_table_base_level __ro_after_init;
+unsigned int mem_table_nlevels __ro_after_init;
+struct mem_table_level mem_table_levels[CONFIG_PGTABLE_LEVELS] __ro_after_init;
+
+void __init mem_table_init(unsigned int base_level)
+{
+	struct mem_table_level *level;
+	unsigned long shift, delta_shift;
+	int physmem_bits;
+	int i, max_levels;
+
+	/*
+	 * Compute the actual number of levels present. Compute the parameters
+	 * for each level.
+	 */
+	shift = ilog2(PAGE_SIZE);
+	physmem_bits = PAGE_SHIFT;
+	max_levels = CONFIG_PGTABLE_LEVELS;
+
+	for (i = 0; i < max_levels && physmem_bits < MAX_PHYSMEM_BITS; i++) {
+		level = &mem_table_levels[i];
+
+		switch (i) {
+		case 0:
+			level->nentries = PTRS_PER_PTE;
+			break;
+		case 1:
+			level->nentries = PTRS_PER_PMD;
+			break;
+		case 2:
+			level->nentries = PTRS_PER_PUD;
+			break;
+		case 3:
+			level->nentries = PTRS_PER_P4D;
+			break;
+		case 4:
+			level->nentries = PTRS_PER_PGD;
+			break;
+		}
+		level->number = i;
+		level->shift = shift;
+		level->mask = level->nentries - 1;
+
+		delta_shift = ilog2(level->nentries);
+		shift += delta_shift;
+		physmem_bits += delta_shift;
+	}
+	mem_table_nlevels = i;
+	mem_table_base_level = base_level;
+}
+
+struct mem_table *mem_table_alloc(struct mem_table_ops *ops)
+{
+	struct mem_table_level *level;
+	struct mem_table *table;
+
+	level = &mem_table_levels[mem_table_nlevels - 1];
+
+	table = kzalloc(struct_size(table, entries, level->nentries),
+			GFP_KERNEL);
+	if (table) {
+		table->level = level;
+		table->ops = ops;
+		return table;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(mem_table_alloc);
+
+static void _mem_table_free(struct mem_table *table)
+{
+	struct mem_table_level *level = table->level;
+	void **entries = table->entries;
+	struct mem_table_ops *ops = table->ops;
+	int i;
+
+	for (i = 0; i < level->nentries; i++) {
+		if (!entries[i])
+			continue;
+		if (IS_LEAF(entries[i])) {
+			/* The consumer frees the pointer. */
+			ops->free(entries[i]);
+			continue;
+		}
+		_mem_table_free(TABLE(entries[i]));
+	}
+	kfree(table);
+}
+
+void mem_table_free(struct mem_table *table)
+{
+	_mem_table_free(table);
+}
+EXPORT_SYMBOL_GPL(mem_table_free);
+
+static void **_mem_table_find(struct mem_table *table, phys_addr_t pa,
+			      unsigned int *level_number)
+{
+	struct mem_table_level *level = table->level;
+	void **entries = table->entries;
+	unsigned long i;
+
+	i = (pa >> level->shift) & level->mask;
+
+	*level_number = level->number;
+	if (!entries[i])
+		return NULL;
+
+	if (IS_LEAF(entries[i]))
+		return &entries[i];
+
+	return _mem_table_find(TABLE(entries[i]), pa, level_number);
+}
+
+void **mem_table_find(struct mem_table *table, phys_addr_t pa,
+		      unsigned int *level_number)
+{
+	void **entry;
+
+	entry = _mem_table_find(table, pa, level_number);
+	level_number += mem_table_base_level;
+
+	return entry;
+}
+EXPORT_SYMBOL_GPL(mem_table_find);
+
+static void **_mem_table_create(struct mem_table *table, phys_addr_t pa)
+{
+	struct mem_table_level *level = table->level;
+	void **entries = table->entries;
+	unsigned long i;
+
+	table->changed = true;
+	i = (pa >> level->shift) & level->mask;
+
+	if (!level->number) {
+		/*
+		 * Reached the lowest level. Return a pointer to the entry
+		 * so that the consumer can populate it.
+		 */
+		return &entries[i];
+	}
+
+	/*
+	 * If the entry is NULL, then create a lower level table and make the
+	 * entry point to it. Or, if the entry is a leaf, then we need to
+	 * split the entry. In this case as well, create a lower level table
+	 * to split the entry.
+	 */
+	if (!entries[i] || IS_LEAF(entries[i])) {
+		struct mem_table *next;
+
+		/* Create next level table. */
+		level--;
+		next = kzalloc(struct_size(table, entries, level->nentries),
+			       GFP_KERNEL);
+		if (!next)
+			return NULL;
+
+		next->level = level;
+		next->ops = table->ops;
+		next->changed = true;
+		entries[i] = ENTRY(next);
+	}
+
+	return _mem_table_create(TABLE(entries[i]), pa);
+}
+
+void **mem_table_create(struct mem_table *table, phys_addr_t pa)
+{
+	return _mem_table_create(table, pa);
+}
+EXPORT_SYMBOL_GPL(mem_table_create);
-- 
2.42.1


