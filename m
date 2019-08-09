Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B24D687F2A
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437118AbfHIQPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:03 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52912 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2436990AbfHIQPB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:01 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 58D6C305D35A;
        Fri,  9 Aug 2019 19:01:35 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id ECE6F305B7A4;
        Fri,  9 Aug 2019 19:01:34 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>
Subject: [RFC PATCH v6 72/92] kvm: introspection: add memory map/unmap support on the guest side
Date:   Fri,  9 Aug 2019 19:00:27 +0300
Message-Id: <20190809160047.8319-73-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>

An introspection tool running in a dedicated VM can use the new device
(/dev/kvmmem) to map memory from other introspected VM-s.

Two ioctl operations are supported:
  - KVM_HC_MEM_MAP/struct kvmi_mem_map
  - KVM_HC_MEM_UNMAP/unsigned long

In order to map an introspected gpa to the local gva, the process using
this device needs to obtain a token from the host KVMI subsystem (see
Documentation/virtual/kvm/kvmi.rst - KVMI_GET_MAP_TOKEN).

Both operations use hypercalls (KVM_HC_MEM_MAP, KVM_HC_MEM_UNMAP)
to pass the requests to the host kernel/KVMi (see hypercalls.txt).

Signed-off-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/hypercalls.txt |  34 ++
 arch/x86/Kconfig                         |   9 +
 arch/x86/include/asm/kvmi_guest.h        |  10 +
 arch/x86/kernel/Makefile                 |   1 +
 arch/x86/kernel/kvmi_mem_guest.c         |  26 +
 include/uapi/linux/kvm_para.h            |   2 +
 include/uapi/linux/kvmi.h                |  21 +
 virt/kvm/kvmi_mem_guest.c                | 651 +++++++++++++++++++++++
 8 files changed, 754 insertions(+)
 create mode 100644 arch/x86/include/asm/kvmi_guest.h
 create mode 100644 arch/x86/kernel/kvmi_mem_guest.c
 create mode 100644 virt/kvm/kvmi_mem_guest.c

diff --git a/Documentation/virtual/kvm/hypercalls.txt b/Documentation/virtual/kvm/hypercalls.txt
index 1ab59537b2fb..a47fae926201 100644
--- a/Documentation/virtual/kvm/hypercalls.txt
+++ b/Documentation/virtual/kvm/hypercalls.txt
@@ -173,3 +173,37 @@ The following registers are clobbered:
 In particular, for KVM_HC_XEN_HVM_OP_GUEST_REQUEST_VM_EVENT, the last two
 registers can be poisoned deliberately and cannot be used for passing
 information.
+
+9. KVM_HC_MEM_MAP
+-----------------
+
+Architecture: x86
+Status: active
+Purpose: Map a guest physical page to another VM (the introspector).
+Usage:
+
+a0: pointer to a token obtained with a KVMI_GET_MAP_TOKEN command (see kvmi.rst)
+	struct kvmi_map_mem_token {
+		__u64 token[4];
+	};
+
+a1: guest physical address to be mapped
+
+a2: guest physical address from introspector that will be replaced
+
+Both guest physical addresses will end up poiting to the same physical page.
+
+Returns any error that the memory manager can return.
+
+10. KVM_HC_MEM_UNMAP
+-------------------
+
+Architecture: x86
+Status: active
+Purpose: Unmap a previously mapped page.
+Usage:
+
+a0: guest physical address from introspector
+
+The address will stop pointing to the introspected page and a new physical
+page is allocated for this gpa.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 68261430fe6e..a7527c1f90a0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -820,6 +820,15 @@ config KVM_DEBUG_FS
 	  Statistics are displayed in debugfs filesystem. Enabling this option
 	  may incur significant overhead.
 
+config KVM_INTROSPECTION_GUEST
+	bool "KVM Memory Introspection support on Guest"
+	depends on KVM_GUEST
+	default n
+	help
+	  This option enables functions and hypercalls for security applications
+	  running in a separate VM to control the execution of other VM-s, query
+	  the state of the vCPU-s (GPR-s, MSR-s etc.).
+
 config PARAVIRT_TIME_ACCOUNTING
 	bool "Paravirtual steal time accounting"
 	depends on PARAVIRT
diff --git a/arch/x86/include/asm/kvmi_guest.h b/arch/x86/include/asm/kvmi_guest.h
new file mode 100644
index 000000000000..c7ed53a938e0
--- /dev/null
+++ b/arch/x86/include/asm/kvmi_guest.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVMI_GUEST_H__
+#define __KVMI_GUEST_H__
+
+long kvmi_arch_map_hc(struct kvmi_map_mem_token *tknp,
+	gpa_t req_gpa, gpa_t map_gpa);
+long kvmi_arch_unmap_hc(gpa_t map_gpa);
+
+
+#endif
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 00b7e27bc2b7..995652ba53b3 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -116,6 +116,7 @@ obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= paravirt-spinlocks.o
 obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
 obj-$(CONFIG_X86_PMEM_LEGACY_DEVICE) += pmem.o
+obj-$(CONFIG_KVM_INTROSPECTION_GUEST)	+= kvmi_mem_guest.o ../../../virt/kvm/kvmi_mem_guest.o
 
 obj-$(CONFIG_JAILHOUSE_GUEST)	+= jailhouse.o
 
diff --git a/arch/x86/kernel/kvmi_mem_guest.c b/arch/x86/kernel/kvmi_mem_guest.c
new file mode 100644
index 000000000000..c4e2613f90f3
--- /dev/null
+++ b/arch/x86/kernel/kvmi_mem_guest.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM introspection guest implementation
+ *
+ * Copyright (C) 2017 Bitdefender S.R.L.
+ *
+ * Author:
+ *   Mircea Cirjaliu <mcirjaliu@bitdefender.com>
+ */
+
+#include <uapi/linux/kvmi.h>
+#include <uapi/linux/kvm_para.h>
+#include <linux/kvm_types.h>
+#include <asm/kvm_para.h>
+
+long kvmi_arch_map_hc(struct kvmi_map_mem_token *tknp,
+		       gpa_t req_gpa, gpa_t map_gpa)
+{
+	return kvm_hypercall3(KVM_HC_MEM_MAP, (unsigned long)tknp,
+			      req_gpa, map_gpa);
+}
+
+long kvmi_arch_unmap_hc(gpa_t map_gpa)
+{
+	return kvm_hypercall1(KVM_HC_MEM_UNMAP, map_gpa);
+}
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 592bda92b6d5..a083e3e66de6 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -33,6 +33,8 @@
 #define KVM_HC_CLOCK_PAIRING		9
 #define KVM_HC_SEND_IPI		10
 
+#define KVM_HC_MEM_MAP			32
+#define KVM_HC_MEM_UNMAP		33
 #define KVM_HC_XEN_HVM_OP		34 /* Xen's __HYPERVISOR_hvm_op */
 
 /*
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index b072e0a4f33d..8591c748524f 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -262,4 +262,25 @@ struct kvmi_event_breakpoint {
 	__u8 padding[7];
 };
 
+struct kvmi_map_mem_token {
+	__u64 token[4];
+};
+
+struct kvmi_get_map_token_reply {
+	struct kvmi_map_mem_token token;
+};
+
+/* Map other guest's gpa to local gva */
+struct kvmi_mem_map {
+	struct kvmi_map_mem_token token;
+	__u64 gpa;
+	__u64 gva;
+};
+
+/*
+ * ioctls for /dev/kvmmem
+ */
+#define KVM_INTRO_MEM_MAP       _IOW('i', 0x01, struct kvmi_mem_map)
+#define KVM_INTRO_MEM_UNMAP     _IOW('i', 0x02, unsigned long)
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/virt/kvm/kvmi_mem_guest.c b/virt/kvm/kvmi_mem_guest.c
new file mode 100644
index 000000000000..bec473b45289
--- /dev/null
+++ b/virt/kvm/kvmi_mem_guest.c
@@ -0,0 +1,651 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM introspection guest implementation
+ *
+ * Copyright (C) 2017-2019 Bitdefender S.R.L.
+ *
+ * Author:
+ *   Mircea Cirjaliu <mcirjaliu@bitdefender.com>
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/sched/mm.h>
+#include <linux/types.h>
+#include <linux/kvm_types.h>
+#include <linux/kvm_para.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/rwlock.h>
+#include <linux/hashtable.h>
+#include <linux/refcount.h>
+#include <linux/ioctl.h>
+
+#include <uapi/linux/kvmi.h>
+#include <asm/kvmi_guest.h>
+
+#define ASSERT(exp) BUG_ON(!(exp))
+#define DB_HASH_BITS 4
+
+static struct kmem_cache *proc_map_cachep;
+static struct kmem_cache *file_map_cachep;
+static struct kmem_cache *page_map_cachep;
+
+/* process/mm to proc_map */
+static DEFINE_HASHTABLE(db_hash, DB_HASH_BITS);
+static DEFINE_SPINLOCK(db_hash_lock);
+
+struct proc_map {
+	struct mm_struct *mm;		/* database key */
+	struct hlist_node db_link;	/* database link */
+	refcount_t refcnt;
+
+	struct rb_root entries;		/* mapping entries for this mm */
+	rwlock_t entries_lock;
+};
+
+struct file_map {
+	struct proc_map *proc;
+
+	struct list_head entries;	/* mapping entries for this file */
+	spinlock_t entries_lock;
+};
+
+struct page_map {
+	struct rb_node proc_link;	/* link to struct proc_map */
+	struct list_head file_link;	/* link to struct file_map */
+
+	gpa_t gpa;			/* target GPA */
+	gva_t vaddr;			/* local GVA */
+};
+
+static void proc_map_init(struct proc_map *pmap)
+{
+	pmap->mm = NULL;
+	INIT_HLIST_NODE(&pmap->db_link);
+	refcount_set(&pmap->refcnt, 0);
+
+	pmap->entries = RB_ROOT;
+	rwlock_init(&pmap->entries_lock);
+}
+
+static struct proc_map *proc_map_alloc(void)
+{
+	struct proc_map *obj;
+
+	obj = kmem_cache_alloc(proc_map_cachep, GFP_KERNEL);
+	if (obj != NULL)
+		proc_map_init(obj);
+
+	return obj;
+}
+
+static void proc_map_free(struct proc_map *pmap)
+{
+	ASSERT(hlist_unhashed(&pmap->db_link));
+	ASSERT(refcount_read(&pmap->refcnt) == 0);
+	ASSERT(RB_EMPTY_ROOT(&pmap->entries));
+
+	kmem_cache_free(proc_map_cachep, pmap);
+}
+
+static void file_map_init(struct file_map *fmp)
+{
+	INIT_LIST_HEAD(&fmp->entries);
+	spin_lock_init(&fmp->entries_lock);
+}
+
+static struct file_map *file_map_alloc(void)
+{
+	struct file_map *obj;
+
+	obj = kmem_cache_alloc(file_map_cachep, GFP_KERNEL);
+	if (obj != NULL)
+		file_map_init(obj);
+
+	return obj;
+}
+
+static void file_map_free(struct file_map *fmp)
+{
+	ASSERT(list_empty(&fmp->entries));
+
+	kmem_cache_free(file_map_cachep, fmp);
+}
+
+static void page_map_init(struct page_map *pmp)
+{
+	memset(pmp, 0, sizeof(*pmp));
+
+	RB_CLEAR_NODE(&pmp->proc_link);
+	INIT_LIST_HEAD(&pmp->file_link);
+}
+
+static struct page_map *page_map_alloc(void)
+{
+	struct page_map *obj;
+
+	obj = kmem_cache_alloc(page_map_cachep, GFP_KERNEL);
+	if (obj != NULL)
+		page_map_init(obj);
+
+	return obj;
+}
+
+static void page_map_free(struct page_map *pmp)
+{
+	ASSERT(RB_EMPTY_NODE(&pmp->proc_link));
+
+	kmem_cache_free(page_map_cachep, pmp);
+}
+
+static struct proc_map *get_proc_map(void)
+{
+	struct proc_map *pmap, *allocated;
+	struct mm_struct *mm;
+	bool found = false;
+
+	if (!mmget_not_zero(current->mm))
+		return NULL;
+	mm = current->mm;
+
+	allocated = proc_map_alloc();	/* may be NULL */
+
+	spin_lock(&db_hash_lock);
+
+	hash_for_each_possible(db_hash, pmap, db_link, (unsigned long)mm)
+		if (pmap->mm == mm && refcount_inc_not_zero(&pmap->refcnt)) {
+			found = true;
+			break;
+		}
+
+	if (!found && allocated != NULL) {
+		pmap = allocated;
+		allocated = NULL;
+
+		pmap->mm = mm;
+		hash_add(db_hash, &pmap->db_link, (unsigned long)mm);
+		refcount_set(&pmap->refcnt, 1);
+	} else
+		mmput(mm);
+
+	spin_unlock(&db_hash_lock);
+
+	if (allocated != NULL)
+		proc_map_free(allocated);
+
+	return pmap;
+}
+
+static void put_proc_map(struct proc_map *pmap)
+{
+	if (refcount_dec_and_test(&pmap->refcnt)) {
+		mmput(pmap->mm);
+
+		/* remove from hash table */
+		spin_lock(&db_hash_lock);
+		hash_del(&pmap->db_link);
+		spin_unlock(&db_hash_lock);
+
+		proc_map_free(pmap);
+	}
+}
+
+static bool proc_map_insert(struct proc_map *pmap, struct page_map *pmp)
+{
+	struct rb_root *root = &pmap->entries;
+	struct rb_node **new = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct page_map *this;
+	bool inserted = true;
+
+	write_lock(&pmap->entries_lock);
+
+	/* Figure out where to put new node */
+	while (*new) {
+		this = rb_entry(*new, struct page_map, proc_link);
+
+		parent = *new;
+		if (pmp->vaddr < this->vaddr)
+			new = &((*new)->rb_left);
+		else if (pmp->vaddr > this->vaddr)
+			new = &((*new)->rb_right);
+		else {
+			/* Already have this address */
+			inserted = false;
+			goto out;
+		}
+	}
+
+	/* Add new node and rebalance tree. */
+	rb_link_node(&pmp->proc_link, parent, new);
+	rb_insert_color(&pmp->proc_link, root);
+
+out:
+	write_unlock(&pmap->entries_lock);
+
+	return inserted;
+}
+
+#if 0 /* will use this later */
+static struct page_map *proc_map_search(struct proc_map *pmap,
+					unsigned long vaddr)
+{
+	struct rb_root *root = &pmap->entries;
+	struct rb_node *node;
+	struct page_map *pmp;
+
+	read_lock(&pmap->entries_lock);
+
+	node = root->rb_node;
+
+	while (node) {
+		pmp = rb_entry(node, struct page_map, proc_link);
+
+		if (vaddr < pmp->vaddr)
+			node = node->rb_left;
+		else if (vaddr > pmp->vaddr)
+			node = node->rb_right;
+		else
+			break;
+	}
+
+	if (!node)
+		pmp = NULL;
+
+	read_unlock(&pmap->entries_lock);
+
+	return pmp;
+}
+#endif
+
+static struct page_map *proc_map_search_extract(struct proc_map *pmap,
+						unsigned long vaddr)
+{
+	struct rb_root *root = &pmap->entries;
+	struct rb_node *node;
+	struct page_map *pmp;
+
+	write_lock(&pmap->entries_lock);
+
+	node = root->rb_node;
+
+	while (node) {
+		pmp = rb_entry(node, struct page_map, proc_link);
+
+		if (vaddr < pmp->vaddr)
+			node = node->rb_left;
+		else if (vaddr > pmp->vaddr)
+			node = node->rb_right;
+		else
+			break;
+	}
+
+	if (node) {
+		rb_erase(&pmp->proc_link, &pmap->entries);
+		RB_CLEAR_NODE(&pmp->proc_link);
+	} else
+		pmp = NULL;
+
+	write_unlock(&pmap->entries_lock);
+
+	return pmp;
+}
+
+static void proc_map_remove(struct proc_map *pmap, struct page_map *pmp)
+{
+	write_lock(&pmap->entries_lock);
+	rb_erase(&pmp->proc_link, &pmap->entries);
+	RB_CLEAR_NODE(&pmp->proc_link);
+	write_unlock(&pmap->entries_lock);
+}
+
+static void file_map_insert(struct file_map *fmp, struct page_map *pmp)
+{
+	spin_lock(&fmp->entries_lock);
+	list_add(&pmp->file_link, &fmp->entries);
+	spin_unlock(&fmp->entries_lock);
+}
+
+static void file_map_remove(struct file_map *fmp, struct page_map *pmp)
+{
+	spin_lock(&fmp->entries_lock);
+	list_del(&pmp->file_link);
+	spin_unlock(&fmp->entries_lock);
+}
+
+/*
+ * Opens the device for map/unmap operations. The mm of this process is
+ * associated with these files in a 1:many relationship.
+ * Operations on this file must be done within the same process that opened it.
+ */
+static int kvm_dev_open(struct inode *inodep, struct file *filp)
+{
+	struct proc_map *pmap;
+	struct file_map *fmp;
+
+	pr_debug("kvmi: file %016lx opened by mm %016lx\n",
+		 (unsigned long) filp, (unsigned long)current->mm);
+
+	pmap = get_proc_map();
+	if (pmap == NULL)
+		return -ENOENT;
+
+	/* link the file 1:1 with such a structure */
+	fmp = file_map_alloc();
+	if (fmp == NULL)
+		return -ENOMEM;
+
+	fmp->proc = pmap;
+	filp->private_data = fmp;
+
+	return 0;
+}
+
+static long _do_mapping(struct kvmi_mem_map *map_req, struct page_map *pmp)
+{
+	struct page *page;
+	phys_addr_t paddr;
+	long nrpages;
+	long result = 0;
+
+	down_read(&current->mm->mmap_sem);
+
+	/* pin the page to be replaced (also swaps in the page) */
+	nrpages = get_user_pages_locked(map_req->gva, 1,
+					FOLL_SPLIT | FOLL_MIGRATION,
+					&page, NULL);
+	if (unlikely(nrpages == 0)) {
+		result = -ENOENT;
+		pr_err("kvmi: found no page for %016llx\n", map_req->gva);
+		goto out;
+	} else if (IS_ERR_VALUE(nrpages)) {
+		result = nrpages;
+		pr_err("kvmi: get_user_pages_locked() failed (%ld)\n", result);
+		goto out;
+	}
+
+	paddr = page_to_phys(page);
+	pr_debug("%s: page phys addr %016llx\n", __func__, paddr);
+
+	/* last thing to do is host mapping */
+	result = kvmi_arch_map_hc(&map_req->token, map_req->gpa, paddr);
+	if (IS_ERR_VALUE(result)) {
+		pr_err("kvmi: mapping failed for %016llx -> %016lx (%ld)\n",
+			pmp->gpa, pmp->vaddr, result);
+
+		/* don't need this page anymore */
+		put_page(page);
+	}
+
+out:
+	up_read(&current->mm->mmap_sem);
+
+	return result;
+}
+
+static long _do_unmapping(struct mm_struct *mm, struct page_map *pmp)
+{
+	struct vm_area_struct *vma;
+	struct page *page;
+	phys_addr_t paddr;
+	long result = 0;
+
+	down_read(&mm->mmap_sem);
+
+	/* find the VMA for the virtual address */
+	vma = find_vma(mm, pmp->vaddr);
+	if (vma == NULL) {
+		result = -ENOENT;
+		pr_err("kvmi: find_vma() found no VMA\n");
+		goto out;
+	}
+
+	/* the page is pinned, thus easy to access */
+	page = follow_page(vma, pmp->vaddr, 0);
+	if (IS_ERR_VALUE(page)) {
+		result = PTR_ERR(page);
+		pr_err("kvmi: follow_page() failed (%ld)\n", result);
+		goto out;
+	} else if (page == NULL) {
+		result = -ENOENT;
+		pr_err("kvmi: follow_page() found no page\n");
+		goto out;
+	}
+
+	paddr = page_to_phys(page);
+	pr_debug("%s: page phys addr %016llx\n", __func__, paddr);
+
+	/* last thing to do is host unmapping */
+	result = kvmi_arch_unmap_hc(paddr);
+	if (IS_ERR_VALUE(result))
+		pr_warn("kvmi: unmapping failed for %016lx (%ld)\n",
+			pmp->vaddr, result);
+
+	/* finally unpin the page */
+	put_page(page);
+
+out:
+	up_read(&mm->mmap_sem);
+
+	return result;
+}
+
+static noinline long kvm_dev_ioctl_map(struct file_map *fmp,
+				       struct kvmi_mem_map *map)
+{
+	struct proc_map *pmap = fmp->proc;
+	struct page_map *pmp;
+	bool added;
+	long result = 0;
+
+	pr_debug("kvmi: mm %016lx map request %016llx -> %016llx\n",
+		(unsigned long)current->mm, map->gpa, map->gva);
+
+	if (!access_ok(map->gva, PAGE_SIZE))
+		return -EINVAL;
+
+	/* prepare list entry */
+	pmp = page_map_alloc();
+	if (pmp == NULL)
+		return -ENOMEM;
+
+	pmp->gpa = map->gpa;
+	pmp->vaddr = map->gva;
+
+	added = proc_map_insert(pmap, pmp);
+	if (added == false) {
+		result = -EALREADY;
+		pr_err("kvmi: address %016llx already mapped into\n", map->gva);
+		goto out_free;
+	}
+	file_map_insert(fmp, pmp);
+
+	/* actual mapping here */
+	result = _do_mapping(map, pmp);
+	if (IS_ERR_VALUE(result))
+		goto out_remove;
+
+	return 0;
+
+out_remove:
+	proc_map_remove(pmap, pmp);
+	file_map_remove(fmp, pmp);
+
+out_free:
+	page_map_free(pmp);
+
+	return result;
+}
+
+static noinline long kvm_dev_ioctl_unmap(struct file_map *fmp,
+					 unsigned long vaddr)
+{
+	struct proc_map *pmap = fmp->proc;
+	struct page_map *pmp;
+	long result = 0;
+
+	pr_debug("kvmi: mm %016lx unmap request %016lx\n",
+		(unsigned long)current->mm, vaddr);
+
+	pmp = proc_map_search_extract(pmap, vaddr);
+	if (pmp == NULL) {
+		pr_err("kvmi: address %016lx not mapped\n", vaddr);
+		return -ENOENT;
+	}
+
+	/* actual unmapping here */
+	result = _do_unmapping(current->mm, pmp);
+
+	file_map_remove(fmp, pmp);
+	page_map_free(pmp);
+
+	return result;
+}
+
+/*
+ * Operations on this file must be done within the same process that opened it.
+ */
+static long kvm_dev_ioctl(struct file *filp,
+			  unsigned int ioctl, unsigned long arg)
+{
+	void __user *argp = (void __user *) arg;
+	struct file_map *fmp = filp->private_data;
+	struct proc_map *pmap = fmp->proc;
+	long result;
+
+	/* this helps keep my code simpler */
+	if (current->mm != pmap->mm) {
+		pr_err("kvmi: ioctl request by different process\n");
+		return -EINVAL;
+	}
+
+	switch (ioctl) {
+	case KVM_INTRO_MEM_MAP: {
+		struct kvmi_mem_map map;
+
+		result = -EFAULT;
+		if (copy_from_user(&map, argp, sizeof(map)))
+			break;
+
+		result = kvm_dev_ioctl_map(fmp, &map);
+		break;
+	}
+	case KVM_INTRO_MEM_UNMAP: {
+		unsigned long vaddr = (unsigned long) arg;
+
+		result = kvm_dev_ioctl_unmap(fmp, vaddr);
+		break;
+	}
+	default:
+		pr_err("kvmi: ioctl %d not implemented\n", ioctl);
+		result = -ENOTTY;
+	}
+
+	return result;
+}
+
+/*
+ * No constraint on closing the device.
+ */
+static int kvm_dev_release(struct inode *inodep, struct file *filp)
+{
+	struct file_map *fmp = filp->private_data;
+	struct proc_map *pmap = fmp->proc;
+	struct page_map *pmp, *temp;
+
+	pr_debug("kvmi: file %016lx closed by mm %016lx\n",
+		 (unsigned long) filp, (unsigned long)current->mm);
+
+	/* this file_map has no more users, thus no more concurrent access */
+	list_for_each_entry_safe(pmp, temp, &fmp->entries, file_link) {
+		proc_map_remove(pmap, pmp);
+		list_del(&pmp->file_link);
+
+		_do_unmapping(pmap->mm, pmp);
+
+		page_map_free(pmp);
+	}
+
+	file_map_free(fmp);
+	put_proc_map(pmap);
+
+	return 0;
+}
+
+static const struct file_operations kvmmem_ops = {
+	.open		= kvm_dev_open,
+	.unlocked_ioctl = kvm_dev_ioctl,
+	.compat_ioctl   = kvm_dev_ioctl,
+	.release	= kvm_dev_release,
+};
+
+static struct miscdevice kvm_mem_dev = {
+	.minor		= MISC_DYNAMIC_MINOR,
+	.name		= "kvmmem",
+	.fops		= &kvmmem_ops,
+};
+
+static int __init kvm_intro_guest_init(void)
+{
+	int result = 0;
+
+	if (!kvm_para_available()) {
+		pr_err("kvmi: paravirt not available\n");
+		return -EPERM;
+	}
+
+	proc_map_cachep = KMEM_CACHE(proc_map, SLAB_PANIC | SLAB_ACCOUNT);
+	if (proc_map_cachep == NULL) {
+		result = -ENOMEM;
+		goto out_err;
+	}
+
+	file_map_cachep = KMEM_CACHE(file_map, SLAB_PANIC | SLAB_ACCOUNT);
+	if (file_map_cachep == NULL) {
+		result = -ENOMEM;
+		goto out_err;
+	}
+
+	page_map_cachep = KMEM_CACHE(page_map, SLAB_PANIC | SLAB_ACCOUNT);
+	if (page_map_cachep == NULL) {
+		result = -ENOMEM;
+		goto out_err;
+	}
+
+	result = misc_register(&kvm_mem_dev);
+	if (result) {
+		pr_err("kvmi: misc device register failed (%d)\n", result);
+		goto out_err;
+	}
+
+	pr_debug("kvmi: guest memory introspection device created\n");
+
+	return 0;
+
+out_err:
+	kmem_cache_destroy(page_map_cachep);
+	kmem_cache_destroy(file_map_cachep);
+	kmem_cache_destroy(proc_map_cachep);
+
+	return result;
+}
+
+static void __exit kvm_intro_guest_exit(void)
+{
+	misc_deregister(&kvm_mem_dev);
+
+	kmem_cache_destroy(page_map_cachep);
+	kmem_cache_destroy(file_map_cachep);
+	kmem_cache_destroy(proc_map_cachep);
+}
+
+module_init(kvm_intro_guest_init)
+module_exit(kvm_intro_guest_exit)
