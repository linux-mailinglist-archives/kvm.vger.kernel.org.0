Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3222E87F99
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437200AbfHIQUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:20:03 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53312 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437142AbfHIQUB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:20:01 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 7549D305D3E0;
        Fri,  9 Aug 2019 19:01:02 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 4B1D9305B7A1;
        Fri,  9 Aug 2019 19:01:01 +0300 (EEST)
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
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>
Subject: [RFC PATCH v6 27/92] kvm: introspection: use page track
Date:   Fri,  9 Aug 2019 18:59:42 +0300
Message-Id: <20190809160047.8319-28-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

From preread, prewrite and preexec callbacks we will send the
KVMI_EVENT_PF events caused by access rights enforced by the introspection
tool.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Co-developed-by: Marian Rotariu <marian.c.rotariu@gmail.com>
Signed-off-by: Marian Rotariu <marian.c.rotariu@gmail.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvmi_host.h |  12 ++
 arch/x86/kvm/kvmi.c              |  45 +++++
 include/uapi/linux/kvmi.h        |   4 +
 virt/kvm/kvmi.c                  | 293 ++++++++++++++++++++++++++++++-
 virt/kvm/kvmi_int.h              |  21 +++
 5 files changed, 374 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/kvmi_host.h

diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
new file mode 100644
index 000000000000..7ab6dd71a0c2
--- /dev/null
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_KVMI_HOST_H
+#define _ASM_X86_KVMI_HOST_H
+
+#include <asm/kvm_host.h>
+#include <asm/kvm_page_track.h>
+
+struct kvmi_arch_mem_access {
+	unsigned long active[KVM_PAGE_TRACK_MAX][BITS_TO_LONGS(KVM_MEM_SLOTS_NUM)];
+};
+
+#endif /* _ASM_X86_KVMI_HOST_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 97c72cdc6fb0..d7b9201582b4 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -91,6 +91,12 @@ void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev)
 	kvmi_get_msrs(vcpu, event);
 }
 
+bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			u8 access)
+{
+	return KVMI_EVENT_ACTION_CONTINUE; /* TODO */
+}
+
 int kvmi_arch_cmd_get_vcpu_info(struct kvm_vcpu *vcpu,
 				struct kvmi_get_vcpu_info_reply *rpl)
 {
@@ -102,3 +108,42 @@ int kvmi_arch_cmd_get_vcpu_info(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static const struct {
+	unsigned int allow_bit;
+	enum kvm_page_track_mode track_mode;
+} track_modes[] = {
+	{ KVMI_PAGE_ACCESS_R, KVM_PAGE_TRACK_PREREAD },
+	{ KVMI_PAGE_ACCESS_W, KVM_PAGE_TRACK_PREWRITE },
+	{ KVMI_PAGE_ACCESS_X, KVM_PAGE_TRACK_PREEXEC },
+};
+
+void kvmi_arch_update_page_tracking(struct kvm *kvm,
+				    struct kvm_memory_slot *slot,
+				    struct kvmi_mem_access *m)
+{
+	struct kvmi_arch_mem_access *arch = &m->arch;
+	int i;
+
+	if (!slot) {
+		slot = gfn_to_memslot(kvm, m->gfn);
+		if (!slot)
+			return;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(track_modes); i++) {
+		unsigned int allow_bit = track_modes[i].allow_bit;
+		enum kvm_page_track_mode mode = track_modes[i].track_mode;
+		bool slot_tracked = test_bit(slot->id, arch->active[mode]);
+
+		if (m->access & allow_bit) {
+			if (slot_tracked) {
+				kvm_slot_page_track_remove_page(kvm, slot,
+								m->gfn, mode);
+				clear_bit(slot->id, arch->active[mode]);
+			}
+		} else if (!slot_tracked) {
+			kvm_slot_page_track_add_page(kvm, slot, m->gfn, mode);
+			set_bit(slot->id, arch->active[mode]);
+		}
+	}
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index aa5bc909e278..c56e676ddb2b 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -70,6 +70,10 @@ enum {
 #define KVMI_EVENT_ACTION_RETRY         1
 #define KVMI_EVENT_ACTION_CRASH         2
 
+#define KVMI_PAGE_ACCESS_R (1 << 0)
+#define KVMI_PAGE_ACCESS_W (1 << 1)
+#define KVMI_PAGE_ACCESS_X (1 << 2)
+
 #define KVMI_MSG_SIZE (4096 - sizeof(struct kvmi_msg_hdr))
 
 struct kvmi_msg_hdr {
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index d0d9adf5b6ed..5cbc82b284f4 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -11,10 +11,27 @@
 #include <linux/bitmap.h>
 
 static struct kmem_cache *msg_cache;
+static struct kmem_cache *radix_cache;
 static struct kmem_cache *job_cache;
 
 static bool kvmi_create_vcpu_event(struct kvm_vcpu *vcpu);
 static void kvmi_abort_events(struct kvm *kvm);
+static bool kvmi_track_preread(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+	u8 *new, int bytes, struct kvm_page_track_notifier_node *node,
+	bool *data_ready);
+static bool kvmi_track_prewrite(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+	const u8 *new, int bytes, struct kvm_page_track_notifier_node *node);
+static bool kvmi_track_preexec(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+	struct kvm_page_track_notifier_node *node);
+static void kvmi_track_create_slot(struct kvm *kvm,
+	struct kvm_memory_slot *slot, unsigned long npages,
+	struct kvm_page_track_notifier_node *node);
+static void kvmi_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
+	struct kvm_page_track_notifier_node *node);
+
+static const u8 full_access  =	KVMI_PAGE_ACCESS_R |
+				KVMI_PAGE_ACCESS_W |
+				KVMI_PAGE_ACCESS_X;
 
 void *kvmi_msg_alloc(void)
 {
@@ -34,23 +51,96 @@ void kvmi_msg_free(void *addr)
 		kmem_cache_free(msg_cache, addr);
 }
 
+static struct kvmi_mem_access *__kvmi_get_gfn_access(struct kvmi *ikvm,
+						     const gfn_t gfn)
+{
+	return radix_tree_lookup(&ikvm->access_tree, gfn);
+}
+
+static int kvmi_get_gfn_access(struct kvmi *ikvm, const gfn_t gfn,
+			       u8 *access)
+{
+	struct kvmi_mem_access *m;
+
+	*access = full_access;
+
+	read_lock(&ikvm->access_tree_lock);
+	m = __kvmi_get_gfn_access(ikvm, gfn);
+	if (m)
+		*access = m->access;
+	read_unlock(&ikvm->access_tree_lock);
+
+	return m ? 0 : -1;
+}
+
+static bool kvmi_restricted_access(struct kvmi *ikvm, gpa_t gpa, u8 access)
+{
+	u8 allowed_access;
+	int err;
+
+	err = kvmi_get_gfn_access(ikvm, gpa_to_gfn(gpa), &allowed_access);
+
+	if (err)
+		return false;
+
+	/*
+	 * We want to be notified only for violations involving access
+	 * bits that we've specifically cleared
+	 */
+	if ((~allowed_access) & access)
+		return true;
+
+	return false;
+}
+
+static void kvmi_clear_mem_access(struct kvm *kvm)
+{
+	void **slot;
+	struct radix_tree_iter iter;
+	struct kvmi *ikvm = IKVM(kvm);
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	spin_lock(&kvm->mmu_lock);
+	write_lock(&ikvm->access_tree_lock);
+
+	radix_tree_for_each_slot(slot, &ikvm->access_tree, &iter, 0) {
+		struct kvmi_mem_access *m = *slot;
+
+		m->access = full_access;
+		kvmi_arch_update_page_tracking(kvm, NULL, m);
+
+		radix_tree_iter_delete(&ikvm->access_tree, &iter, slot);
+		kmem_cache_free(radix_cache, m);
+	}
+
+	write_unlock(&ikvm->access_tree_lock);
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+}
+
 static void kvmi_cache_destroy(void)
 {
 	kmem_cache_destroy(msg_cache);
 	msg_cache = NULL;
+	kmem_cache_destroy(radix_cache);
+	radix_cache = NULL;
 	kmem_cache_destroy(job_cache);
 	job_cache = NULL;
 }
 
 static int kvmi_cache_create(void)
 {
+	radix_cache = kmem_cache_create("kvmi_radix_tree",
+					sizeof(struct kvmi_mem_access),
+					0, SLAB_ACCOUNT, NULL);
 	job_cache = kmem_cache_create("kvmi_job",
 				      sizeof(struct kvmi_job),
 				      0, SLAB_ACCOUNT, NULL);
 	msg_cache = kmem_cache_create("kvmi_msg", KVMI_MSG_SIZE_ALLOC,
 				      4096, SLAB_ACCOUNT, NULL);
 
-	if (!msg_cache || !job_cache) {
+	if (!msg_cache || !radix_cache || !job_cache) {
 		kvmi_cache_destroy();
 
 		return -1;
@@ -77,6 +167,10 @@ static bool alloc_kvmi(struct kvm *kvm, const struct kvm_introspection *qemu)
 	if (!ikvm)
 		return false;
 
+	/* see comments of radix_tree_preload() - no direct reclaim */
+	INIT_RADIX_TREE(&ikvm->access_tree, GFP_KERNEL & ~__GFP_DIRECT_RECLAIM);
+	rwlock_init(&ikvm->access_tree_lock);
+
 	atomic_set(&ikvm->ev_seq, 0);
 
 	set_bit(KVMI_GET_VERSION, ikvm->cmd_allow_mask);
@@ -85,6 +179,12 @@ static bool alloc_kvmi(struct kvm *kvm, const struct kvm_introspection *qemu)
 
 	memcpy(&ikvm->uuid, &qemu->uuid, sizeof(ikvm->uuid));
 
+	ikvm->kptn_node.track_preread = kvmi_track_preread;
+	ikvm->kptn_node.track_prewrite = kvmi_track_prewrite;
+	ikvm->kptn_node.track_preexec = kvmi_track_preexec;
+	ikvm->kptn_node.track_create_slot = kvmi_track_create_slot;
+	ikvm->kptn_node.track_flush_slot = kvmi_track_flush_slot;
+
 	ikvm->kvm = kvm;
 	kvm->kvmi = ikvm;
 
@@ -276,6 +376,179 @@ void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu)
 	vcpu->kvmi = NULL;
 }
 
+static bool is_pf_of_interest(struct kvm_vcpu *vcpu, gpa_t gpa, u8 access)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	if (kvm_mmu_nested_pagefault(vcpu))
+		return false;
+
+	/* Have we shown interest in this page? */
+	return kvmi_restricted_access(IKVM(kvm), gpa, access);
+}
+
+static bool __kvmi_track_preread(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+	u8 *new, int bytes, struct kvm_page_track_notifier_node *node,
+	bool *data_ready)
+{
+	bool ret;
+
+	if (!is_pf_of_interest(vcpu, gpa, KVMI_PAGE_ACCESS_R))
+		return true;
+
+	ret = kvmi_arch_pf_event(vcpu, gpa, gva, KVMI_PAGE_ACCESS_R);
+
+	return ret;
+}
+
+static bool kvmi_track_preread(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+	u8 *new, int bytes, struct kvm_page_track_notifier_node *node,
+	bool *data_ready)
+{
+	struct kvmi *ikvm;
+	bool ret = true;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
+		return true;
+
+	if (is_event_enabled(vcpu, KVMI_EVENT_PF))
+		ret = __kvmi_track_preread(vcpu, gpa, gva, new, bytes, node,
+					   data_ready);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+
+static bool __kvmi_track_prewrite(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+	const u8 *new, int bytes,
+	struct kvm_page_track_notifier_node *node)
+{
+	if (!is_pf_of_interest(vcpu, gpa, KVMI_PAGE_ACCESS_W))
+		return true;
+
+	return kvmi_arch_pf_event(vcpu, gpa, gva, KVMI_PAGE_ACCESS_W);
+}
+
+static bool kvmi_track_prewrite(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+	const u8 *new, int bytes,
+	struct kvm_page_track_notifier_node *node)
+{
+	struct kvmi *ikvm;
+	bool ret = true;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
+		return true;
+
+	if (is_event_enabled(vcpu, KVMI_EVENT_PF))
+		ret = __kvmi_track_prewrite(vcpu, gpa, gva, new, bytes, node);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+
+static bool __kvmi_track_preexec(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+	struct kvm_page_track_notifier_node *node)
+{
+	if (!is_pf_of_interest(vcpu, gpa, KVMI_PAGE_ACCESS_X))
+		return true;
+
+	return kvmi_arch_pf_event(vcpu, gpa, gva, KVMI_PAGE_ACCESS_X);
+}
+
+static bool kvmi_track_preexec(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+	struct kvm_page_track_notifier_node *node)
+{
+	struct kvmi *ikvm;
+	bool ret = true;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
+		return true;
+
+	if (is_event_enabled(vcpu, KVMI_EVENT_PF))
+		ret = __kvmi_track_preexec(vcpu, gpa, gva, node);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+
+static void kvmi_track_create_slot(struct kvm *kvm,
+	struct kvm_memory_slot *slot,
+	unsigned long npages,
+	struct kvm_page_track_notifier_node *node)
+{
+	struct kvmi *ikvm;
+	gfn_t start = slot->base_gfn;
+	const gfn_t end = start + npages;
+	int idx;
+
+	ikvm = kvmi_get(kvm);
+	if (!ikvm)
+		return;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	spin_lock(&kvm->mmu_lock);
+	read_lock(&ikvm->access_tree_lock);
+
+	while (start < end) {
+		struct kvmi_mem_access *m;
+
+		m = __kvmi_get_gfn_access(ikvm, start);
+		if (m)
+			kvmi_arch_update_page_tracking(kvm, slot, m);
+		start++;
+	}
+
+	read_unlock(&ikvm->access_tree_lock);
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	kvmi_put(kvm);
+}
+
+static void kvmi_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
+	struct kvm_page_track_notifier_node *node)
+{
+	struct kvmi *ikvm;
+	gfn_t start = slot->base_gfn;
+	const gfn_t end = start + slot->npages;
+	int idx;
+
+	ikvm = kvmi_get(kvm);
+	if (!ikvm)
+		return;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	spin_lock(&kvm->mmu_lock);
+	write_lock(&ikvm->access_tree_lock);
+
+	while (start < end) {
+		struct kvmi_mem_access *m;
+
+		m = __kvmi_get_gfn_access(ikvm, start);
+		if (m) {
+			u8 prev_access = m->access;
+
+			m->access = full_access;
+			kvmi_arch_update_page_tracking(kvm, slot, m);
+			m->access = prev_access;
+		}
+
+		start++;
+	}
+
+	write_unlock(&ikvm->access_tree_lock);
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	kvmi_put(kvm);
+}
+
 static void kvmi_end_introspection(struct kvmi *ikvm)
 {
 	struct kvm *kvm = ikvm->kvm;
@@ -290,6 +563,22 @@ static void kvmi_end_introspection(struct kvmi *ikvm)
 	 */
 	kvmi_abort_events(kvm);
 
+	/*
+	 * This may sleep on synchronize_srcu() so it's not allowed to be
+	 * called under kvmi_put().
+	 * Also synchronize_srcu() may deadlock on (page tracking) read-side
+	 * regions that are waiting for reply to events, so must be called
+	 * after kvmi_abort_events().
+	 */
+	kvm_page_track_unregister_notifier(kvm, &ikvm->kptn_node);
+
+	/*
+	 * This function uses kvm->mmu_lock so it's not allowed to be
+	 * called under kvmi_put(). It can reach a deadlock if called
+	 * from kvm_mmu_load -> kvmi_tracked_gfn -> kvmi_put.
+	 */
+	kvmi_clear_mem_access(kvm);
+
 	/*
 	 * At this moment the socket is shut down, no more commands will come
 	 * from the introspector, and the only way into the introspection is
@@ -351,6 +640,8 @@ int kvmi_hook(struct kvm *kvm, const struct kvm_introspection *qemu)
 		goto err_alloc;
 	}
 
+	kvm_page_track_register_notifier(kvm, &ikvm->kptn_node);
+
 	/*
 	 * Make sure all the KVM/KVMI structures are linked and no pointer
 	 * is read as NULL after the reference count has been set.
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 7cff91bc1acc..d798908d0f70 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -6,6 +6,7 @@
 #include <linux/kvm_host.h>
 
 #include <uapi/linux/kvmi.h>
+#include <asm/kvmi_host.h>
 
 #define kvmi_debug(ikvm, fmt, ...) \
 	kvm_debug("%pU " fmt, &ikvm->uuid, ## __VA_ARGS__)
@@ -104,6 +105,10 @@ struct kvmi_vcpu {
 
 struct kvmi {
 	struct kvm *kvm;
+	struct kvm_page_track_notifier_node kptn_node;
+
+	struct radix_tree_root access_tree;
+	rwlock_t access_tree_lock;
 
 	struct socket *sock;
 	struct task_struct *recv;
@@ -118,6 +123,17 @@ struct kvmi {
 	bool cmd_reply_disabled;
 };
 
+struct kvmi_mem_access {
+	gfn_t gfn;
+	u8 access;
+	struct kvmi_arch_mem_access arch;
+};
+
+static inline bool is_event_enabled(struct kvm_vcpu *vcpu, int event)
+{
+	return false; /* TODO */
+}
+
 /* kvmi_msg.c */
 bool kvmi_sock_get(struct kvmi *ikvm, int fd);
 void kvmi_sock_shutdown(struct kvmi *ikvm);
@@ -138,7 +154,12 @@ int kvmi_add_job(struct kvm_vcpu *vcpu,
 		 void *ctx, void (*free_fct)(void *ctx));
 
 /* arch */
+void kvmi_arch_update_page_tracking(struct kvm *kvm,
+				    struct kvm_memory_slot *slot,
+				    struct kvmi_mem_access *m);
 void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev);
+bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
+			u8 access);
 int kvmi_arch_cmd_get_vcpu_info(struct kvm_vcpu *vcpu,
 				struct kvmi_get_vcpu_info_reply *rpl);
 
