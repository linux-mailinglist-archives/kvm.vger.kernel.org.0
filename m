Return-Path: <kvm+bounces-1560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16F6D7E950B
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 03:34:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97BA91F2118B
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 02:34:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E58871F612;
	Mon, 13 Nov 2023 02:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="jIruH5wh"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286341BDD6
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 02:32:36 +0000 (UTC)
X-Greylist: delayed 506 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 12 Nov 2023 18:32:29 PST
Received: from smtp-190c.mail.infomaniak.ch (smtp-190c.mail.infomaniak.ch [IPv6:2001:1600:4:17::190c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21432111
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 18:32:28 -0800 (PST)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4STCtk62jlzMpvbR;
	Mon, 13 Nov 2023 02:24:46 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4STCtj3BHpzMpnPj;
	Mon, 13 Nov 2023 03:24:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1699842286;
	bh=cKEtzyAn6nu6IgS2HwQtrr3Q0FdnoNCxsjW/LjtBy3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIruH5whNlSM69bid+qC3QXUvSlkIk75w7vIB/z+Qo7hEu+vNgXjfS7u+hLyxFvJh
	 GvNxrzuFYdFr4xGhRvANkM2xckqutIUrO++9D0gm+yBcTUiZrahZ5H3unv9L5ngWMM
	 D6Za9ta9LWpEPpfa0MoQWkvjZSapc+FeceMFwMpo=
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
Subject: [RFC PATCH v2 14/19] heki: x86: Initialize permissions counters for pages mapped into KVA
Date: Sun, 12 Nov 2023 21:23:21 -0500
Message-ID: <20231113022326.24388-15-mic@digikod.net>
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

Define a permissions counters structure that contains a counter for
read, write and execute. Each mapped guest page will be allocated a
permissions counters structure.

During kernel boot, walk the kernel address space, locate all the
mappings, create permissions counters for each mapped guest page and
update the counters to reflect the collective permissions for each page
across all of its mappings.

The collective permissions will be applied in the EPT in a following
commit.

We might want to move these counters to a safer place (e.g., KVM) to
protect it from tampering by the guest kernel itself.

We should note that walking through all mappings might be slow if KASAN
is enabled.

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
Suggested-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---

Changes since v1:
* New patch and new files: arch/x86/mm/heki.c and virt/heki/counters.c
---
 arch/x86/mm/Makefile |   2 +
 arch/x86/mm/heki.c   |  56 +++++++++++++++++
 include/linux/heki.h |  32 ++++++++++
 virt/heki/Kconfig    |   2 +
 virt/heki/Makefile   |   1 +
 virt/heki/counters.c | 147 +++++++++++++++++++++++++++++++++++++++++++
 virt/heki/main.c     |  13 ++++
 7 files changed, 253 insertions(+)
 create mode 100644 arch/x86/mm/heki.c
 create mode 100644 virt/heki/counters.c

diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index c80febc44cd2..2998eaac0dbb 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -67,3 +67,5 @@ obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_amd.o
 
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_identity.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_boot.o
+
+obj-$(CONFIG_HEKI)		+= heki.o
diff --git a/arch/x86/mm/heki.c b/arch/x86/mm/heki.c
new file mode 100644
index 000000000000..c495df0d8772
--- /dev/null
+++ b/arch/x86/mm/heki.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Hypervisor Enforced Kernel Integrity (Heki) - Arch specific.
+ *
+ * Copyright © 2023 Microsoft Corporation
+ */
+
+#include <linux/heki.h>
+#include <linux/kvm_mem_attr.h>
+
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) "heki-guest: " fmt
+
+static unsigned long kernel_va;
+static unsigned long kernel_end;
+static unsigned long direct_map_va;
+static unsigned long direct_map_end;
+
+__init void heki_arch_early_init(void)
+{
+	/* Kernel virtual address space range, not yet compatible with KASLR. */
+	if (pgtable_l5_enabled()) {
+		kernel_va = 0xff00000000000000UL;
+		kernel_end = 0xffffffffffe00000UL;
+		direct_map_va = 0xff11000000000000UL;
+		direct_map_end = 0xff91000000000000UL;
+	} else {
+		kernel_va = 0xffff800000000000UL;
+		kernel_end = 0xffffffffffe00000UL;
+		direct_map_va = 0xffff888000000000UL;
+		direct_map_end = 0xffffc88000000000UL;
+	}
+
+	/*
+	 * Initialize the counters for all existing kernel mappings except
+	 * for direct map.
+	 */
+	heki_map(kernel_va, direct_map_va);
+	heki_map(direct_map_end, kernel_end);
+}
+
+unsigned long heki_flags_to_permissions(unsigned long flags)
+{
+	unsigned long permissions;
+
+	permissions = MEM_ATTR_READ | MEM_ATTR_EXEC;
+	if (flags & _PAGE_RW)
+		permissions |= MEM_ATTR_WRITE;
+	if (flags & _PAGE_NX)
+		permissions &= ~MEM_ATTR_EXEC;
+
+	return permissions;
+}
diff --git a/include/linux/heki.h b/include/linux/heki.h
index a7ae0b387dfe..86c787d121e0 100644
--- a/include/linux/heki.h
+++ b/include/linux/heki.h
@@ -19,6 +19,16 @@
 
 #ifdef CONFIG_HEKI
 
+/*
+ * This structure keeps track of the collective permissions for a guest page
+ * across all of its mappings.
+ */
+struct heki_counters {
+	int read;
+	int write;
+	int execute;
+};
+
 /*
  * This structure contains a guest physical range and its permissions (RWX).
  */
@@ -56,9 +66,17 @@ struct heki_hypervisor {
 /*
  * If the active hypervisor supports Heki, it will plug its heki_hypervisor
  * pointer into this heki structure.
+ *
+ * During guest kernel boot, permissions counters for each guest page are
+ * initialized based on the page's current permissions.
  */
 struct heki {
 	struct heki_hypervisor *hypervisor;
+	struct mem_table *counters;
+};
+
+enum heki_cmd {
+	HEKI_MAP,
 };
 
 /*
@@ -72,6 +90,9 @@ struct heki_args {
 	phys_addr_t pa;
 	size_t size;
 	unsigned long flags;
+
+	/* Command passed by caller. */
+	enum heki_cmd cmd;
 };
 
 /* Callback function called by the table walker. */
@@ -84,6 +105,14 @@ extern bool __read_mostly enable_mbec;
 
 void heki_early_init(void);
 void heki_late_init(void);
+void heki_counters_init(void);
+void heki_walk(unsigned long va, unsigned long va_end, heki_func_t func,
+	       struct heki_args *args);
+void heki_map(unsigned long va, unsigned long end);
+
+/* Arch-specific functions. */
+void heki_arch_early_init(void);
+unsigned long heki_flags_to_permissions(unsigned long flags);
 
 #else /* !CONFIG_HEKI */
 
@@ -93,6 +122,9 @@ static inline void heki_early_init(void)
 static inline void heki_late_init(void)
 {
 }
+static inline void heki_map(unsigned long va, unsigned long end)
+{
+}
 
 #endif /* CONFIG_HEKI */
 
diff --git a/virt/heki/Kconfig b/virt/heki/Kconfig
index 75a784653e31..6d956eb9d04b 100644
--- a/virt/heki/Kconfig
+++ b/virt/heki/Kconfig
@@ -6,6 +6,8 @@ config HEKI
 	bool "Hypervisor Enforced Kernel Integrity (Heki)"
 	depends on ARCH_SUPPORTS_HEKI && HYPERVISOR_SUPPORTS_HEKI
 	select KVM_GENERIC_MEMORY_ATTRIBUTES
+	depends on !X86_16BIT
+	select SPARSEMEM
 	help
 	  This feature enhances guest virtual machine security by taking
 	  advantage of security features provided by the hypervisor for guests.
diff --git a/virt/heki/Makefile b/virt/heki/Makefile
index a5daa4ff7a4f..564f92faa9d8 100644
--- a/virt/heki/Makefile
+++ b/virt/heki/Makefile
@@ -2,3 +2,4 @@
 
 obj-y += main.o
 obj-y += walk.o
+obj-y += counters.o
diff --git a/virt/heki/counters.c b/virt/heki/counters.c
new file mode 100644
index 000000000000..7067449cabca
--- /dev/null
+++ b/virt/heki/counters.c
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Hypervisor Enforced Kernel Integrity (Heki) - Permissions counters.
+ *
+ * Copyright © 2023 Microsoft Corporation
+ */
+
+#include <linux/heki.h>
+#include <linux/kvm_mem_attr.h>
+#include <linux/mem_table.h>
+
+#include "common.h"
+
+DEFINE_MUTEX(heki_lock);
+
+static void heki_update_counters(struct heki_counters *counters,
+				 unsigned long perm, unsigned long set,
+				 unsigned long clear)
+{
+	if (WARN_ON_ONCE(!counters))
+		return;
+
+	if ((clear & MEM_ATTR_READ) && (perm & MEM_ATTR_READ))
+		counters->read--;
+	if ((clear & MEM_ATTR_WRITE) && (perm & MEM_ATTR_WRITE))
+		counters->write--;
+	if ((clear & MEM_ATTR_EXEC) && (perm & MEM_ATTR_EXEC))
+		counters->execute--;
+
+	if ((set & MEM_ATTR_READ) && !(perm & MEM_ATTR_READ))
+		counters->read++;
+	if ((set & MEM_ATTR_WRITE) && !(perm & MEM_ATTR_WRITE))
+		counters->write++;
+	if ((set & MEM_ATTR_EXEC) && !(perm & MEM_ATTR_EXEC))
+		counters->execute++;
+}
+
+static struct heki_counters *heki_create_counters(struct mem_table *table,
+						  phys_addr_t pa)
+{
+	struct heki_counters *counters;
+	void **entry;
+
+	entry = mem_table_create(table, pa);
+	if (WARN_ON(!entry))
+		return NULL;
+
+	counters = kzalloc(sizeof(*counters), GFP_KERNEL);
+	if (WARN_ON(!counters))
+		return NULL;
+
+	*entry = counters;
+	return counters;
+}
+
+void heki_callback(struct heki_args *args)
+{
+	/* The VA is only for debug. It is not really used in this function. */
+	unsigned long va;
+	phys_addr_t pa, pa_end;
+	unsigned long permissions;
+	void **entry;
+	struct heki_counters *counters;
+	unsigned int ignore;
+
+	if (!pfn_valid(args->pa >> PAGE_SHIFT))
+		return;
+
+	permissions = heki_flags_to_permissions(args->flags);
+
+	/*
+	 * Handle counters for a leaf entry in the kernel page table.
+	 */
+	pa_end = args->pa + args->size;
+	for (pa = args->pa, va = args->va; pa < pa_end;
+	     pa += PAGE_SIZE, va += PAGE_SIZE) {
+		entry = mem_table_find(heki.counters, pa, &ignore);
+		if (entry)
+			counters = *entry;
+		else
+			counters = NULL;
+
+		switch (args->cmd) {
+		case HEKI_MAP:
+			if (!counters)
+				counters =
+					heki_create_counters(heki.counters, pa);
+			heki_update_counters(counters, 0, permissions, 0);
+			break;
+
+		default:
+			WARN_ON_ONCE(1);
+			break;
+		}
+	}
+}
+
+static void heki_func(unsigned long va, unsigned long end,
+		      struct heki_args *args)
+{
+	if (!heki.counters || va >= end)
+		return;
+
+	va = ALIGN_DOWN(va, PAGE_SIZE);
+	end = ALIGN(end, PAGE_SIZE);
+
+	mutex_lock(&heki_lock);
+
+	heki_walk(va, end, heki_callback, args);
+
+	mutex_unlock(&heki_lock);
+}
+
+/*
+ * Find the mappings in the given range and initialize permission counters for
+ * them.
+ */
+void heki_map(unsigned long va, unsigned long end)
+{
+	struct heki_args args = {
+		.cmd = HEKI_MAP,
+	};
+
+	heki_func(va, end, &args);
+}
+
+/*
+ * Permissions counters are associated with each guest page using the
+ * Memory Table feature. Initialize the permissions counters here.
+ * Note that we don't support large page entries for counters because
+ * it is difficult to merge/split counters for large pages.
+ */
+
+static void heki_counters_free(void *counters)
+{
+	kfree(counters);
+}
+
+static struct mem_table_ops heki_counters_ops = {
+	.free = heki_counters_free,
+};
+
+__init void heki_counters_init(void)
+{
+	heki.counters = mem_table_alloc(&heki_counters_ops);
+	WARN_ON(!heki.counters);
+}
diff --git a/virt/heki/main.c b/virt/heki/main.c
index ff1937e1c946..0ab7de659e6f 100644
--- a/virt/heki/main.c
+++ b/virt/heki/main.c
@@ -21,6 +21,16 @@ __init void heki_early_init(void)
 		pr_warn("Heki is not enabled\n");
 		return;
 	}
+
+	/*
+	 * Static addresses (see heki_arch_early_init) are not compatible with
+	 * KASLR. This will be handled in a next patch series.
+	 */
+	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
+		pr_warn("Heki is disabled because KASLR is not supported yet\n");
+		return;
+	}
+
 	pr_warn("Heki is enabled\n");
 
 	if (!heki.hypervisor) {
@@ -29,6 +39,9 @@ __init void heki_early_init(void)
 		return;
 	}
 	pr_warn("Heki is supported by the active Hypervisor\n");
+
+	heki_counters_init();
+	heki_arch_early_init();
 }
 
 /*
-- 
2.42.1


