Return-Path: <kvm+bounces-1541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A47F87E9498
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 03:25:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 033D1B209DE
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 02:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA838480;
	Mon, 13 Nov 2023 02:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="0mhnZA1x"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C44D79EA
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 02:25:09 +0000 (UTC)
X-Greylist: delayed 65 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 12 Nov 2023 18:25:02 PST
Received: from smtp-bc09.mail.infomaniak.ch (smtp-bc09.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc09])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4942830D5
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 18:25:02 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
	by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4STCv05yshzMq2HC;
	Mon, 13 Nov 2023 02:25:00 +0000 (UTC)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4STCtz4hvPz3W;
	Mon, 13 Nov 2023 03:24:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1699842300;
	bh=PATv6XqDzwsqZ2hzsduhnRZLYujicEUOyMqcIKoFSMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0mhnZA1xfB5IXGthCsMhNYtbubItWy18yziuYfeR6AWnv19fq1a5ISoUh4unXyOIh
	 SC9+Jk+sOe/3QbX5C7M0oDyImgy94uTLkrpYq/BH7ntImAVOjNoVR0spQpk+hAJBca
	 WdT/RtauYzVOLQlQ7Hw86Ab44ZapL/N2SdK3uwOw=
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
Subject: [RFC PATCH v2 18/19] heki: x86: Protect guest kernel memory using the KVM hypervisor
Date: Sun, 12 Nov 2023 21:23:25 -0500
Message-ID: <20231113022326.24388-19-mic@digikod.net>
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

Implement a hypervisor function, kvm_protect_memory() that calls the
KVM_HC_PROTECT_MEMORY hypercall to request the KVM hypervisor to
set specified permissions on a list of guest pages.

Using the protect_memory() function, set proper EPT permissions for all
guest pages.

Use the MEM_ATTR_IMMUTABLE property to protect the kernel static
sections and the boot-time read-only sections. This enables to make sure
a compromised guest will not be able to change its main physical memory
page permissions. However, this also disable any feature that may change
the kernel's text section (e.g., ftrace, Kprobes), but they can still be
used on kernel modules.

Module loading/unloading, and eBPF JIT is allowed without restrictions
for now, but we'll need a way to authenticate these code changes to
really improve the guests' security. We plan to use module signatures,
but there is no solution yet to authenticate eBPF programs.

Being able to use ftrace and Kprobes in a secure way is a challenge not
solved yet. We're looking for ideas to make this work.

Likewise, the JUMP_LABEL feature cannot work because the kernel's text
section is read-only.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Co-developed-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---

Changes since v1:
* New patch
---
 arch/x86/kernel/kvm.c  | 11 ++++++
 arch/x86/kvm/mmu/mmu.c |  2 +-
 arch/x86/mm/heki.c     | 21 ++++++++++
 include/linux/heki.h   | 26 ++++++++++++
 virt/heki/Kconfig      |  1 +
 virt/heki/counters.c   | 90 ++++++++++++++++++++++++++++++++++++++++--
 virt/heki/main.c       | 83 +++++++++++++++++++++++++++++++++++++-
 7 files changed, 229 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 8349f4ad3bbd..343615b0e3bf 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1021,8 +1021,19 @@ static int kvm_lock_crs(void)
 	return err;
 }
 
+static int kvm_protect_memory(gpa_t pa)
+{
+	long err;
+
+	WARN_ON_ONCE(in_interrupt());
+
+	err = kvm_hypercall1(KVM_HC_PROTECT_MEMORY, pa);
+	return err;
+}
+
 static struct heki_hypervisor kvm_heki_hypervisor = {
 	.lock_crs = kvm_lock_crs,
+	.protect_memory = kvm_protect_memory,
 };
 
 static void kvm_init_heki(void)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2d09bcc35462..13be05e9ccf1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7374,7 +7374,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 	int level;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-	lockdep_assert_held(&kvm->slots_lock);
+	lockdep_assert_held(&kvm->slots_arch_lock);
 
 	/*
 	 * The sequence matters here: upper levels consume the result of lower
diff --git a/arch/x86/mm/heki.c b/arch/x86/mm/heki.c
index e4c60d8b4f2d..6c3fa9defada 100644
--- a/arch/x86/mm/heki.c
+++ b/arch/x86/mm/heki.c
@@ -45,6 +45,19 @@ __init void heki_arch_early_init(void)
 	heki_map(direct_map_end, kernel_end);
 }
 
+void heki_arch_late_init(void)
+{
+	/*
+	 * The permission counters for all existing kernel mappings have
+	 * already been updated. Now, walk all the pages, compute their
+	 * permissions from the counters and apply the permissions in the
+	 * host page table. To accomplish this, we walk the direct map
+	 * range.
+	 */
+	heki_protect(direct_map_va, direct_map_end);
+	pr_warn("Guest memory protected\n");
+}
+
 unsigned long heki_flags_to_permissions(unsigned long flags)
 {
 	unsigned long permissions;
@@ -67,6 +80,11 @@ void heki_pgprot_to_permissions(pgprot_t prot, unsigned long *set,
 		*clear |= MEM_ATTR_EXEC;
 }
 
+unsigned long heki_default_permissions(void)
+{
+	return MEM_ATTR_READ | MEM_ATTR_WRITE;
+}
+
 static unsigned long heki_pgprot_to_flags(pgprot_t prot)
 {
 	unsigned long flags = 0;
@@ -100,6 +118,9 @@ static void heki_text_poke_common(struct page **pages, int npages,
 		heki_callback(&args);
 	}
 
+	if (args.head)
+		heki_apply_permissions(&args);
+
 	mutex_unlock(&heki_lock);
 }
 
diff --git a/include/linux/heki.h b/include/linux/heki.h
index 6f2cfddc6dac..306bcec7ae92 100644
--- a/include/linux/heki.h
+++ b/include/linux/heki.h
@@ -15,6 +15,8 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/printk.h>
+#include <linux/mm.h>
+#include <linux/memblock.h>
 #include <linux/slab.h>
 
 #ifdef CONFIG_HEKI
@@ -61,6 +63,7 @@ struct heki_page_list {
  */
 struct heki_hypervisor {
 	int (*lock_crs)(void); /* Lock control registers. */
+	int (*protect_memory)(gpa_t pa); /* Protect guest memory */
 };
 
 /*
@@ -74,16 +77,28 @@ struct heki_hypervisor {
  *	- a page is mapped into the kernel address space
  *	- a page is unmapped from the kernel address space
  *	- permissions are changed for a mapped page
+ *
+ * At the end of kernel boot (before kicking off the init process), the
+ * permissions for guest pages are applied to the host page table.
+ *
+ * Beyond that point, the counters and host page table permissions are updated
+ * whenever:
+ *
+ *	- a guest page is mapped into the kernel address space
+ *	- a guest page is unmapped from the kernel address space
+ *	- permissions are changed for a mapped guest page
  */
 struct heki {
 	struct heki_hypervisor *hypervisor;
 	struct mem_table *counters;
+	bool protect_memory;
 };
 
 enum heki_cmd {
 	HEKI_MAP,
 	HEKI_UPDATE,
 	HEKI_UNMAP,
+	HEKI_PROTECT_MEMORY,
 };
 
 /*
@@ -103,7 +118,12 @@ struct heki_args {
 
 	/* Permissions passed by heki_update(). */
 	unsigned long set;
+	unsigned long set_global;
 	unsigned long clear;
+
+	/* Page list is built by the callback. */
+	struct heki_page_list *head;
+	phys_addr_t head_pa;
 };
 
 /* Callback function called by the table walker. */
@@ -125,14 +145,20 @@ void heki_update(unsigned long va, unsigned long end, unsigned long set,
 		 unsigned long clear);
 void heki_unmap(unsigned long va, unsigned long end);
 void heki_callback(struct heki_args *args);
+void heki_protect(unsigned long va, unsigned long end);
+void heki_add_pa(struct heki_args *args, phys_addr_t pa,
+		 unsigned long permissions);
+void heki_apply_permissions(struct heki_args *args);
 
 /* Arch-specific functions. */
 void heki_arch_early_init(void);
+void heki_arch_late_init(void);
 unsigned long heki_flags_to_permissions(unsigned long flags);
 void heki_pgprot_to_permissions(pgprot_t prot, unsigned long *set,
 				unsigned long *clear);
 void heki_text_poke_start(struct page **pages, int npages, pgprot_t prot);
 void heki_text_poke_end(struct page **pages, int npages, pgprot_t prot);
+unsigned long heki_default_permissions(void);
 
 #else /* !CONFIG_HEKI */
 
diff --git a/virt/heki/Kconfig b/virt/heki/Kconfig
index 6d956eb9d04b..9bde84cd759e 100644
--- a/virt/heki/Kconfig
+++ b/virt/heki/Kconfig
@@ -8,6 +8,7 @@ config HEKI
 	select KVM_GENERIC_MEMORY_ATTRIBUTES
 	depends on !X86_16BIT
 	select SPARSEMEM
+	depends on !JUMP_LABEL
 	help
 	  This feature enhances guest virtual machine security by taking
 	  advantage of security features provided by the hypervisor for guests.
diff --git a/virt/heki/counters.c b/virt/heki/counters.c
index d0f830b0775a..302113bee6ff 100644
--- a/virt/heki/counters.c
+++ b/virt/heki/counters.c
@@ -13,6 +13,25 @@
 
 DEFINE_MUTEX(heki_lock);
 
+static inline unsigned long heki_permissions(struct heki_counters *counters)
+{
+	unsigned long permissions;
+
+	if (!counters)
+		return heki_default_permissions();
+
+	permissions = 0;
+	if (counters->read)
+		permissions |= MEM_ATTR_READ;
+	if (counters->write)
+		permissions |= MEM_ATTR_WRITE;
+	if (counters->execute)
+		permissions |= MEM_ATTR_EXEC;
+	if (!permissions)
+		permissions = heki_default_permissions();
+	return permissions;
+}
+
 static void heki_update_counters(struct heki_counters *counters,
 				 unsigned long perm, unsigned long set,
 				 unsigned long clear)
@@ -53,20 +72,38 @@ static struct heki_counters *heki_create_counters(struct mem_table *table,
 	return counters;
 }
 
+static void heki_check_counters(struct heki_counters *counters,
+				unsigned long permissions)
+{
+	/*
+	 * If a permission has been added to a PTE directly, it will not be
+	 * reflected in the counters. Adjust for that. This is a bit of a
+	 * hack, really.
+	 */
+	if ((permissions & MEM_ATTR_READ) && !counters->read)
+		counters->read++;
+	if ((permissions & MEM_ATTR_WRITE) && !counters->write)
+		counters->write++;
+	if ((permissions & MEM_ATTR_EXEC) && !counters->execute)
+		counters->execute++;
+}
+
 void heki_callback(struct heki_args *args)
 {
 	/* The VA is only for debug. It is not really used in this function. */
 	unsigned long va;
 	phys_addr_t pa, pa_end;
-	unsigned long permissions;
+	unsigned long permissions, existing, new;
 	void **entry;
 	struct heki_counters *counters;
 	unsigned int ignore;
+	bool protect_memory;
 
 	if (!pfn_valid(args->pa >> PAGE_SHIFT))
 		return;
 
 	permissions = heki_flags_to_permissions(args->flags);
+	protect_memory = heki.protect_memory;
 
 	/*
 	 * Handle counters for a leaf entry in the kernel page table.
@@ -80,6 +117,8 @@ void heki_callback(struct heki_args *args)
 		else
 			counters = NULL;
 
+		existing = heki_permissions(counters);
+
 		switch (args->cmd) {
 		case HEKI_MAP:
 			if (!counters)
@@ -102,10 +141,30 @@ void heki_callback(struct heki_args *args)
 					     permissions);
 			break;
 
+		case HEKI_PROTECT_MEMORY:
+			if (counters)
+				heki_check_counters(counters, permissions);
+			existing = 0;
+			break;
+
 		default:
 			WARN_ON_ONCE(1);
 			break;
 		}
+
+		new = heki_permissions(counters) | args->set_global;
+
+		/*
+		 * To be able to use a pool of allocated memory for new
+		 * executable or read-only mappings (e.g., kernel module
+		 * loading), ignores immutable attribute if memory can be
+		 * changed.
+		 */
+		if (new & MEM_ATTR_WRITE)
+			new &= ~MEM_ATTR_IMMUTABLE;
+
+		if (protect_memory && existing != new)
+			heki_add_pa(args, pa, new);
 	}
 }
 
@@ -120,14 +179,20 @@ static void heki_func(unsigned long va, unsigned long end,
 
 	mutex_lock(&heki_lock);
 
+	if (args->cmd == HEKI_PROTECT_MEMORY)
+		heki.protect_memory = true;
+
 	heki_walk(va, end, heki_callback, args);
 
+	if (args->head)
+		heki_apply_permissions(args);
+
 	mutex_unlock(&heki_lock);
 }
 
 /*
  * Find the mappings in the given range and initialize permission counters for
- * them.
+ * them. Apply permissions in the host page table.
  */
 void heki_map(unsigned long va, unsigned long end)
 {
@@ -138,6 +203,25 @@ void heki_map(unsigned long va, unsigned long end)
 	heki_func(va, end, &args);
 }
 
+/*
+ * The architecture calls this to protect all guest pages at the end of
+ * kernel init. Up to this point, only the counters for guest pages have been
+ * updated. No permissions have been applied on the host page table.
+ * Now, the permissions will be applied.
+ *
+ * Beyond this point, the host page table permissions will always be updated
+ * whenever the counters are updated.
+ */
+void heki_protect(unsigned long va, unsigned long end)
+{
+	struct heki_args args = {
+		.cmd = HEKI_PROTECT_MEMORY,
+		.set_global = MEM_ATTR_IMMUTABLE,
+	};
+
+	heki_func(va, end, &args);
+}
+
 /*
  * Find the mappings in the given range and update permission counters for
  * them. Apply permissions in the host page table.
@@ -156,7 +240,7 @@ void heki_update(unsigned long va, unsigned long end, unsigned long set,
 
 /*
  * Find the mappings in the given range and revert the permission counters for
- * them.
+ * them. Apply permissions in the host page table.
  */
 void heki_unmap(unsigned long va, unsigned long end)
 {
diff --git a/virt/heki/main.c b/virt/heki/main.c
index 0ab7de659e6f..5629334112e7 100644
--- a/virt/heki/main.c
+++ b/virt/heki/main.c
@@ -51,7 +51,7 @@ void heki_late_init(void)
 {
 	struct heki_hypervisor *hypervisor = heki.hypervisor;
 
-	if (!heki_enabled || !heki.hypervisor)
+	if (!heki.counters)
 		return;
 
 	/* Locks control registers so a compromised guest cannot change them. */
@@ -59,6 +59,87 @@ void heki_late_init(void)
 		return;
 
 	pr_warn("Control registers locked\n");
+
+	heki_arch_late_init();
+}
+
+/*
+ * Build a list of guest pages with their permissions. This list will be
+ * passed to the VMM/Hypervisor to set these permissions in the host page
+ * table.
+ */
+void heki_add_pa(struct heki_args *args, phys_addr_t pa,
+		 unsigned long permissions)
+{
+	struct heki_page_list *list = args->head;
+	struct heki_pages *hpage;
+	u64 max_pages;
+	struct page *page;
+	bool new = false;
+
+	max_pages = (PAGE_SIZE - sizeof(*list)) / sizeof(*hpage);
+again:
+	if (!list || list->npages == max_pages) {
+		page = alloc_page(GFP_KERNEL);
+		if (WARN_ON_ONCE(!page))
+			return;
+
+		list = page_address(page);
+		list->npages = 0;
+		list->next_pa = args->head_pa;
+		list->next = args->head;
+
+		args->head = list;
+		args->head_pa = page_to_pfn(page) << PAGE_SHIFT;
+		new = true;
+	}
+
+	hpage = &list->pages[list->npages];
+	if (new) {
+		hpage->pa = pa;
+		hpage->epa = pa + PAGE_SIZE;
+		hpage->permissions = permissions;
+		return;
+	}
+
+	if (pa == hpage->epa && permissions == hpage->permissions) {
+		hpage->epa += PAGE_SIZE;
+		return;
+	}
+
+	list->npages++;
+	new = true;
+	goto again;
+}
+
+void heki_apply_permissions(struct heki_args *args)
+{
+	struct heki_hypervisor *hypervisor = heki.hypervisor;
+	struct heki_page_list *list = args->head;
+	phys_addr_t list_pa = args->head_pa;
+	struct page *page;
+	int ret;
+
+	if (!list)
+		return;
+
+	/* The very last one must be included. */
+	list->npages++;
+
+	/* Protect guest memory in the host page table. */
+	ret = hypervisor->protect_memory(list_pa);
+	if (ret) {
+		pr_warn("Failed to set memory permission\n");
+		return;
+	}
+
+	/* Free all the pages in the page list. */
+	while (list) {
+		page = pfn_to_page(list_pa >> PAGE_SHIFT);
+		list_pa = list->next_pa;
+		list = list->next;
+		__free_pages(page, 0);
+	}
 }
 
 static int __init heki_parse_config(char *str)
-- 
2.42.1


