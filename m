Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA061D3544
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 17:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgENPim (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 11:38:42 -0400
Received: from foss.arm.com ([217.140.110.172]:39144 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbgENPil (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 11:38:41 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DFC971045;
        Thu, 14 May 2020 08:38:40 -0700 (PDT)
Received: from e121566-lin.arm.com (unknown [10.57.31.200])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A84523F71E;
        Thu, 14 May 2020 08:38:39 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v4 kvmtool 01/12] ioport: mmio: Use a mutex and reference counting for locking
Date:   Thu, 14 May 2020 16:38:18 +0100
Message-Id: <1589470709-4104-2-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589470709-4104-1-git-send-email-alexandru.elisei@arm.com>
References: <1589470709-4104-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvmtool uses brlock for protecting accesses to the ioport and mmio
red-black trees. brlock allows concurrent reads, but only one writer, which
is assumed not to be a VCPU thread (for more information see commit
0b907ed2eaec ("kvm tools: Add a brlock)). This is done by issuing a
compiler barrier on read and pausing the entire virtual machine on writes.
When KVM_BRLOCK_DEBUG is defined, brlock uses instead a pthread read/write
lock.

When we will implement reassignable BARs, the mmio or ioport mapping will
be done as a result of a VCPU mmio access. When brlock is a pthread
read/write lock, it means that we will try to acquire a write lock with the
read lock already held by the same VCPU and we will deadlock. When it's
not, a VCPU will have to call kvm__pause, which means the virtual machine
will stay paused forever.

Let's avoid all this by using a mutex and reference counting the red-black
tree entries. This way we can guarantee that we won't unregister a node
that another thread is currently using for emulation.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/kvm/ioport.h          |   2 +
 include/kvm/rbtree-interval.h |   4 +-
 ioport.c                      |  85 ++++++++++++++++++++++-----------
 mmio.c                        | 107 ++++++++++++++++++++++++++++++++----------
 4 files changed, 143 insertions(+), 55 deletions(-)

diff --git a/include/kvm/ioport.h b/include/kvm/ioport.h
index 62a719327e3f..039633f76bdd 100644
--- a/include/kvm/ioport.h
+++ b/include/kvm/ioport.h
@@ -22,6 +22,8 @@ struct ioport {
 	struct ioport_operations	*ops;
 	void				*priv;
 	struct device_header		dev_hdr;
+	u32				refcount;
+	bool				remove;
 };
 
 struct ioport_operations {
diff --git a/include/kvm/rbtree-interval.h b/include/kvm/rbtree-interval.h
index 730eb5e8551d..17cd3b5f3199 100644
--- a/include/kvm/rbtree-interval.h
+++ b/include/kvm/rbtree-interval.h
@@ -6,7 +6,9 @@
 
 #define RB_INT_INIT(l, h) \
 	(struct rb_int_node){.low = l, .high = h}
-#define rb_int(n) rb_entry(n, struct rb_int_node, node)
+#define rb_int(n)	rb_entry(n, struct rb_int_node, node)
+#define rb_int_start(n)	((n)->low)
+#define rb_int_end(n)	((n)->low + (n)->high - 1)
 
 struct rb_int_node {
 	struct rb_node	node;
diff --git a/ioport.c b/ioport.c
index d9f2e8ea3c3b..844a832d25a4 100644
--- a/ioport.c
+++ b/ioport.c
@@ -2,7 +2,6 @@
 
 #include "kvm/kvm.h"
 #include "kvm/util.h"
-#include "kvm/brlock.h"
 #include "kvm/rbtree-interval.h"
 #include "kvm/mutex.h"
 
@@ -16,6 +15,8 @@
 
 #define ioport_node(n) rb_entry(n, struct ioport, node)
 
+static DEFINE_MUTEX(ioport_lock);
+
 static struct rb_root		ioport_tree = RB_ROOT;
 
 static struct ioport *ioport_search(struct rb_root *root, u64 addr)
@@ -39,6 +40,36 @@ static void ioport_remove(struct rb_root *root, struct ioport *data)
 	rb_int_erase(root, &data->node);
 }
 
+static struct ioport *ioport_get(struct rb_root *root, u64 addr)
+{
+	struct ioport *ioport;
+
+	mutex_lock(&ioport_lock);
+	ioport = ioport_search(root, addr);
+	if (ioport)
+		ioport->refcount++;
+	mutex_unlock(&ioport_lock);
+
+	return ioport;
+}
+
+/* Called with ioport_lock held. */
+static void ioport_unregister(struct rb_root *root, struct ioport *data)
+{
+	device__unregister(&data->dev_hdr);
+	ioport_remove(root, data);
+	free(data);
+}
+
+static void ioport_put(struct rb_root *root, struct ioport *data)
+{
+	mutex_lock(&ioport_lock);
+	data->refcount--;
+	if (data->remove && data->refcount == 0)
+		ioport_unregister(root, data);
+	mutex_unlock(&ioport_lock);
+}
+
 #ifdef CONFIG_HAS_LIBFDT
 static void generate_ioport_fdt_node(void *fdt,
 				     struct device_header *dev_hdr,
@@ -80,16 +111,22 @@ int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, i
 			.bus_type	= DEVICE_BUS_IOPORT,
 			.data		= generate_ioport_fdt_node,
 		},
+		/*
+		 * Start from 0 because ioport__unregister() doesn't decrement
+		 * the reference count.
+		 */
+		.refcount	= 0,
+		.remove		= false,
 	};
 
-	br_write_lock(kvm);
+	mutex_lock(&ioport_lock);
 	r = ioport_insert(&ioport_tree, entry);
 	if (r < 0)
 		goto out_free;
 	r = device__register(&entry->dev_hdr);
 	if (r < 0)
 		goto out_remove;
-	br_write_unlock(kvm);
+	mutex_unlock(&ioport_lock);
 
 	return port;
 
@@ -97,33 +134,28 @@ out_remove:
 	ioport_remove(&ioport_tree, entry);
 out_free:
 	free(entry);
-	br_write_unlock(kvm);
+	mutex_unlock(&ioport_lock);
 	return r;
 }
 
 int ioport__unregister(struct kvm *kvm, u16 port)
 {
 	struct ioport *entry;
-	int r;
-
-	br_write_lock(kvm);
 
-	r = -ENOENT;
+	mutex_lock(&ioport_lock);
 	entry = ioport_search(&ioport_tree, port);
-	if (!entry)
-		goto done;
-
-	device__unregister(&entry->dev_hdr);
-	ioport_remove(&ioport_tree, entry);
-
-	free(entry);
-
-	r = 0;
-
-done:
-	br_write_unlock(kvm);
+	if (!entry) {
+		mutex_unlock(&ioport_lock);
+		return -ENOENT;
+	}
+	/* The same reasoning from kvm__deregister_mmio() applies. */
+	if (entry->refcount == 0)
+		ioport_unregister(&ioport_tree, entry);
+	else
+		entry->remove = true;
+	mutex_unlock(&ioport_lock);
 
-	return r;
+	return 0;
 }
 
 static void ioport__unregister_all(void)
@@ -136,9 +168,7 @@ static void ioport__unregister_all(void)
 	while (rb) {
 		rb_node = rb_int(rb);
 		entry = ioport_node(rb_node);
-		device__unregister(&entry->dev_hdr);
-		ioport_remove(&ioport_tree, entry);
-		free(entry);
+		ioport_unregister(&ioport_tree, entry);
 		rb = rb_first(&ioport_tree);
 	}
 }
@@ -164,8 +194,7 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction,
 	void *ptr = data;
 	struct kvm *kvm = vcpu->kvm;
 
-	br_read_lock(kvm);
-	entry = ioport_search(&ioport_tree, port);
+	entry = ioport_get(&ioport_tree, port);
 	if (!entry)
 		goto out;
 
@@ -180,9 +209,9 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction,
 		ptr += size;
 	}
 
-out:
-	br_read_unlock(kvm);
+	ioport_put(&ioport_tree, entry);
 
+out:
 	if (ret)
 		return true;
 
diff --git a/mmio.c b/mmio.c
index 61e1d47a587d..cd141cd30750 100644
--- a/mmio.c
+++ b/mmio.c
@@ -1,7 +1,7 @@
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
 #include "kvm/rbtree-interval.h"
-#include "kvm/brlock.h"
+#include "kvm/mutex.h"
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -15,10 +15,14 @@
 
 #define mmio_node(n) rb_entry(n, struct mmio_mapping, node)
 
+static DEFINE_MUTEX(mmio_lock);
+
 struct mmio_mapping {
 	struct rb_int_node	node;
 	void			(*mmio_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len, u8 is_write, void *ptr);
 	void			*ptr;
+	u32			refcount;
+	bool			remove;
 };
 
 static struct rb_root mmio_tree = RB_ROOT;
@@ -51,6 +55,11 @@ static int mmio_insert(struct rb_root *root, struct mmio_mapping *data)
 	return rb_int_insert(root, &data->node);
 }
 
+static void mmio_remove(struct rb_root *root, struct mmio_mapping *data)
+{
+	rb_int_erase(root, &data->node);
+}
+
 static const char *to_direction(u8 is_write)
 {
 	if (is_write)
@@ -59,6 +68,41 @@ static const char *to_direction(u8 is_write)
 	return "read";
 }
 
+static struct mmio_mapping *mmio_get(struct rb_root *root, u64 phys_addr, u32 len)
+{
+	struct mmio_mapping *mmio;
+
+	mutex_lock(&mmio_lock);
+	mmio = mmio_search(root, phys_addr, len);
+	if (mmio)
+		mmio->refcount++;
+	mutex_unlock(&mmio_lock);
+
+	return mmio;
+}
+
+/* Called with mmio_lock held. */
+static void mmio_deregister(struct kvm *kvm, struct rb_root *root, struct mmio_mapping *mmio)
+{
+	struct kvm_coalesced_mmio_zone zone = (struct kvm_coalesced_mmio_zone) {
+		.addr	= rb_int_start(&mmio->node),
+		.size	= 1,
+	};
+	ioctl(kvm->vm_fd, KVM_UNREGISTER_COALESCED_MMIO, &zone);
+
+	mmio_remove(root, mmio);
+	free(mmio);
+}
+
+static void mmio_put(struct kvm *kvm, struct rb_root *root, struct mmio_mapping *mmio)
+{
+	mutex_lock(&mmio_lock);
+	mmio->refcount--;
+	if (mmio->remove && mmio->refcount == 0)
+		mmio_deregister(kvm, root, mmio);
+	mutex_unlock(&mmio_lock);
+}
+
 int kvm__register_mmio(struct kvm *kvm, u64 phys_addr, u64 phys_addr_len, bool coalesce,
 		       void (*mmio_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len, u8 is_write, void *ptr),
 			void *ptr)
@@ -72,9 +116,15 @@ int kvm__register_mmio(struct kvm *kvm, u64 phys_addr, u64 phys_addr_len, bool c
 		return -ENOMEM;
 
 	*mmio = (struct mmio_mapping) {
-		.node = RB_INT_INIT(phys_addr, phys_addr + phys_addr_len),
-		.mmio_fn = mmio_fn,
-		.ptr	= ptr,
+		.node		= RB_INT_INIT(phys_addr, phys_addr + phys_addr_len),
+		.mmio_fn	= mmio_fn,
+		.ptr		= ptr,
+		/*
+		 * Start from 0 because kvm__deregister_mmio() doesn't decrement
+		 * the reference count.
+		 */
+		.refcount	= 0,
+		.remove		= false,
 	};
 
 	if (coalesce) {
@@ -88,9 +138,9 @@ int kvm__register_mmio(struct kvm *kvm, u64 phys_addr, u64 phys_addr_len, bool c
 			return -errno;
 		}
 	}
-	br_write_lock(kvm);
+	mutex_lock(&mmio_lock);
 	ret = mmio_insert(&mmio_tree, mmio);
-	br_write_unlock(kvm);
+	mutex_unlock(&mmio_lock);
 
 	return ret;
 }
@@ -98,25 +148,30 @@ int kvm__register_mmio(struct kvm *kvm, u64 phys_addr, u64 phys_addr_len, bool c
 bool kvm__deregister_mmio(struct kvm *kvm, u64 phys_addr)
 {
 	struct mmio_mapping *mmio;
-	struct kvm_coalesced_mmio_zone zone;
 
-	br_write_lock(kvm);
+	mutex_lock(&mmio_lock);
 	mmio = mmio_search_single(&mmio_tree, phys_addr);
 	if (mmio == NULL) {
-		br_write_unlock(kvm);
+		mutex_unlock(&mmio_lock);
 		return false;
 	}
+	/*
+	 * The PCI emulation code calls this function when memory access is
+	 * disabled for a device, or when a BAR has a new address assigned. PCI
+	 * emulation doesn't use any locks and as a result we can end up in a
+	 * situation where we have called mmio_get() to do emulation on one VCPU
+	 * thread (let's call it VCPU0), and several other VCPU threads have
+	 * called kvm__deregister_mmio(). In this case, if we decrement refcount
+	 * kvm__deregister_mmio() (either directly, or by calling mmio_put()),
+	 * refcount will reach 0 and we will free the mmio node before VCPU0 has
+	 * called mmio_put(). This will trigger use-after-free errors on VCPU0.
+	 */
+	if (mmio->refcount == 0)
+		mmio_deregister(kvm, &mmio_tree, mmio);
+	else
+		mmio->remove = true;
+	mutex_unlock(&mmio_lock);
 
-	zone = (struct kvm_coalesced_mmio_zone) {
-		.addr	= phys_addr,
-		.size	= 1,
-	};
-	ioctl(kvm->vm_fd, KVM_UNREGISTER_COALESCED_MMIO, &zone);
-
-	rb_int_erase(&mmio_tree, &mmio->node);
-	br_write_unlock(kvm);
-
-	free(mmio);
 	return true;
 }
 
@@ -124,18 +179,18 @@ bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u
 {
 	struct mmio_mapping *mmio;
 
-	br_read_lock(vcpu->kvm);
-	mmio = mmio_search(&mmio_tree, phys_addr, len);
-
-	if (mmio)
-		mmio->mmio_fn(vcpu, phys_addr, data, len, is_write, mmio->ptr);
-	else {
+	mmio = mmio_get(&mmio_tree, phys_addr, len);
+	if (!mmio) {
 		if (vcpu->kvm->cfg.mmio_debug)
 			fprintf(stderr,	"Warning: Ignoring MMIO %s at %016llx (length %u)\n",
 				to_direction(is_write),
 				(unsigned long long)phys_addr, len);
+		goto out;
 	}
-	br_read_unlock(vcpu->kvm);
 
+	mmio->mmio_fn(vcpu, phys_addr, data, len, is_write, mmio->ptr);
+	mmio_put(vcpu->kvm, &mmio_tree, mmio);
+
+out:
 	return true;
 }
-- 
2.7.4

