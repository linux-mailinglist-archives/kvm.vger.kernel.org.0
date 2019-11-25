Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E042108BC7
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 11:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbfKYKcq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 05:32:46 -0500
Received: from foss.arm.com ([217.140.110.172]:47790 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727612AbfKYKco (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 05:32:44 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BE9E11045;
        Mon, 25 Nov 2019 02:32:43 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D73F83F52E;
        Mon, 25 Nov 2019 02:32:42 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH kvmtool 12/16] Use independent read/write locks for ioport and mmio
Date:   Mon, 25 Nov 2019 10:30:29 +0000
Message-Id: <20191125103033.22694-13-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191125103033.22694-1-alexandru.elisei@arm.com>
References: <20191125103033.22694-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvmtool uses brlock for protecting accesses to the ioport and mmio
red-black trees. brlock allows concurrent reads, but only one writer,
which is assumed not to be a VCPU thread. This is done by issuing a
compiler barrier on read and pausing the entire virtual machine on
writes. When KVM_BRLOCK_DEBUG is defined, brlock uses instead a pthread
read/write lock.

When we will implement reassignable BARs, the mmio or ioport mapping
will be done as a result of a VCPU mmio access. When brlock is a
read/write lock, it means that we will try to acquire a write lock with
the read lock already held by the same VCPU and we will deadlock. When
it's not, a VCPU will have to call kvm__pause, which means the virtual
machine will stay paused forever.

Let's avoid all this by using separate pthread_rwlock_t locks for the
mmio and the ioport red-black trees and carefully choosing our read
critical region such that modification as a result of a guest mmio
access doesn't deadlock.

In theory, this leaves us with a small window of opportunity for a VCPU
to modify a node used by another VCPU. Inserting in the trees is done by
the main thread before starting the virtual machine, and deleting is
done after the virtual machine has been paused to be destroyed, so in
practice this can only happen if the guest is bugged.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 ioport.c | 20 +++++++++++---------
 mmio.c   | 26 +++++++++++++++++---------
 2 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/ioport.c b/ioport.c
index a72e4035881a..3802d8300191 100644
--- a/ioport.c
+++ b/ioport.c
@@ -2,9 +2,9 @@
 
 #include "kvm/kvm.h"
 #include "kvm/util.h"
-#include "kvm/brlock.h"
 #include "kvm/rbtree-interval.h"
 #include "kvm/mutex.h"
+#include "kvm/rwsem.h"
 
 #include <linux/kvm.h>	/* for KVM_EXIT_* */
 #include <linux/types.h>
@@ -16,6 +16,8 @@
 
 #define ioport_node(n) rb_entry(n, struct ioport, node)
 
+static DECLARE_RWSEM(ioport_lock);
+
 static struct rb_root		ioport_tree = RB_ROOT;
 
 static struct ioport *ioport_search(struct rb_root *root, u64 addr)
@@ -68,7 +70,7 @@ int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, i
 	struct ioport *entry;
 	int r;
 
-	br_write_lock(kvm);
+	down_write(&ioport_lock);
 
 	entry = ioport_search(&ioport_tree, port);
 	if (entry) {
@@ -93,12 +95,12 @@ int ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops, i
 	r = ioport_insert(&ioport_tree, entry);
 	if (r < 0) {
 		free(entry);
-		br_write_unlock(kvm);
+		up_write(&ioport_lock);
 		return r;
 	}
 
 	device__register(&entry->dev_hdr);
-	br_write_unlock(kvm);
+	up_write(&ioport_lock);
 
 	return port;
 }
@@ -108,7 +110,7 @@ int ioport__unregister(struct kvm *kvm, u16 port)
 	struct ioport *entry;
 	int r;
 
-	br_write_lock(kvm);
+	down_write(&ioport_lock);
 
 	r = -ENOENT;
 	entry = ioport_search(&ioport_tree, port);
@@ -123,7 +125,7 @@ int ioport__unregister(struct kvm *kvm, u16 port)
 	r = 0;
 
 done:
-	br_write_unlock(kvm);
+	up_write(&ioport_lock);
 
 	return r;
 }
@@ -166,8 +168,10 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction,
 	void *ptr = data;
 	struct kvm *kvm = vcpu->kvm;
 
-	br_read_lock(kvm);
+	down_read(&ioport_lock);
 	entry = ioport_search(&ioport_tree, port);
+	up_read(&ioport_lock);
+
 	if (!entry)
 		goto out;
 
@@ -183,8 +187,6 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction,
 	}
 
 out:
-	br_read_unlock(kvm);
-
 	if (ret)
 		return true;
 
diff --git a/mmio.c b/mmio.c
index 61e1d47a587d..4e0ff830c738 100644
--- a/mmio.c
+++ b/mmio.c
@@ -1,7 +1,7 @@
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
 #include "kvm/rbtree-interval.h"
-#include "kvm/brlock.h"
+#include "kvm/rwsem.h"
 
 #include <stdio.h>
 #include <stdlib.h>
@@ -15,6 +15,8 @@
 
 #define mmio_node(n) rb_entry(n, struct mmio_mapping, node)
 
+static DECLARE_RWSEM(mmio_lock);
+
 struct mmio_mapping {
 	struct rb_int_node	node;
 	void			(*mmio_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len, u8 is_write, void *ptr);
@@ -61,7 +63,7 @@ static const char *to_direction(u8 is_write)
 
 int kvm__register_mmio(struct kvm *kvm, u64 phys_addr, u64 phys_addr_len, bool coalesce,
 		       void (*mmio_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data, u32 len, u8 is_write, void *ptr),
-			void *ptr)
+		       void *ptr)
 {
 	struct mmio_mapping *mmio;
 	struct kvm_coalesced_mmio_zone zone;
@@ -88,9 +90,9 @@ int kvm__register_mmio(struct kvm *kvm, u64 phys_addr, u64 phys_addr_len, bool c
 			return -errno;
 		}
 	}
-	br_write_lock(kvm);
+	down_write(&mmio_lock);
 	ret = mmio_insert(&mmio_tree, mmio);
-	br_write_unlock(kvm);
+	up_write(&mmio_lock);
 
 	return ret;
 }
@@ -100,10 +102,10 @@ bool kvm__deregister_mmio(struct kvm *kvm, u64 phys_addr)
 	struct mmio_mapping *mmio;
 	struct kvm_coalesced_mmio_zone zone;
 
-	br_write_lock(kvm);
+	down_write(&mmio_lock);
 	mmio = mmio_search_single(&mmio_tree, phys_addr);
 	if (mmio == NULL) {
-		br_write_unlock(kvm);
+		up_write(&mmio_lock);
 		return false;
 	}
 
@@ -114,7 +116,7 @@ bool kvm__deregister_mmio(struct kvm *kvm, u64 phys_addr)
 	ioctl(kvm->vm_fd, KVM_UNREGISTER_COALESCED_MMIO, &zone);
 
 	rb_int_erase(&mmio_tree, &mmio->node);
-	br_write_unlock(kvm);
+	up_write(&mmio_lock);
 
 	free(mmio);
 	return true;
@@ -124,8 +126,15 @@ bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u
 {
 	struct mmio_mapping *mmio;
 
-	br_read_lock(vcpu->kvm);
+	/*
+	 * The callback might call kvm__register_mmio which takes a write lock,
+	 * so avoid deadlocks by protecting only the node search with a reader
+	 * lock. Note that there is still a small time window for a node to be
+	 * deleted by another vcpu before mmio_fn gets called.
+	 */
+	down_read(&mmio_lock);
 	mmio = mmio_search(&mmio_tree, phys_addr, len);
+	up_read(&mmio_lock);
 
 	if (mmio)
 		mmio->mmio_fn(vcpu, phys_addr, data, len, is_write, mmio->ptr);
@@ -135,7 +144,6 @@ bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u
 				to_direction(is_write),
 				(unsigned long long)phys_addr, len);
 	}
-	br_read_unlock(vcpu->kvm);
 
 	return true;
 }
-- 
2.20.1

