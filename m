Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28D9229C9A
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731580AbgGVQB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:01:59 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:38032 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729178AbgGVQBl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:41 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 8EA6E305D768;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 807BE305FFA4;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 17/34] KVM: introspection: extend the access rights database with EPT view info
Date:   Wed, 22 Jul 2020 19:01:04 +0300
Message-Id: <20200722160121.9601-18-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

On EPT violations, when we check if the introspection tool has shown
interest in the current guest page, we will take into consideration
the EPT view of the current vCPU too.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvmi_host.h  |   1 +
 arch/x86/kvm/kvmi.c               |   9 +--
 include/linux/kvmi_host.h         |   2 +-
 virt/kvm/introspection/kvmi.c     | 107 +++++++++++++++++-------------
 virt/kvm/introspection/kvmi_int.h |   4 +-
 5 files changed, 71 insertions(+), 52 deletions(-)

diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 509fa3fff5e7..8af03ba38316 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -9,6 +9,7 @@ struct msr_data;
 
 #define KVMI_NUM_CR 5
 #define KVMI_NUM_MSR 0x2000
+#define KVMI_MAX_ACCESS_TREES KVM_MAX_EPT_VIEWS
 
 struct kvmi_monitor_interception {
 	bool kvmi_intercepted;
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 06357b8ab54a..52885b9e5b6e 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1197,7 +1197,7 @@ static const struct {
 
 void kvmi_arch_update_page_tracking(struct kvm *kvm,
 				    struct kvm_memory_slot *slot,
-				    struct kvmi_mem_access *m)
+				    struct kvmi_mem_access *m, u16 view)
 {
 	struct kvmi_arch_mem_access *arch = &m->arch;
 	int i;
@@ -1217,12 +1217,12 @@ void kvmi_arch_update_page_tracking(struct kvm *kvm,
 			if (slot_tracked) {
 				kvm_slot_page_track_remove_page(kvm, slot,
 								m->gfn, mode,
-								0);
+								view);
 				clear_bit(slot->id, arch->active[mode]);
 			}
 		} else if (!slot_tracked) {
 			kvm_slot_page_track_add_page(kvm, slot, m->gfn, mode,
-						     0);
+						     view);
 			set_bit(slot->id, arch->active[mode]);
 		}
 	}
@@ -1256,7 +1256,8 @@ static bool is_pf_of_interest(struct kvm_vcpu *vcpu, gpa_t gpa, u8 access)
 	if (kvm_x86_ops.gpt_translation_fault(vcpu))
 		return false;
 
-	return kvmi_restricted_page_access(KVMI(vcpu->kvm), gpa, access);
+	return kvmi_restricted_page_access(KVMI(vcpu->kvm), gpa, access,
+					   kvm_get_ept_view(vcpu));
 }
 
 static bool handle_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 5baef68d8cbe..c38c7f16d5d0 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -69,7 +69,7 @@ struct kvm_introspection {
 
 	bool cleanup_on_unhook;
 
-	struct radix_tree_root access_tree;
+	struct radix_tree_root access_tree[KVMI_MAX_ACCESS_TREES];
 	rwlock_t access_tree_lock;
 };
 
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 2a96b80bddb2..737fe3c7a956 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -258,20 +258,23 @@ static void kvmi_clear_mem_access(struct kvm *kvm)
 	struct kvm_introspection *kvmi = KVMI(kvm);
 	struct radix_tree_iter iter;
 	void **slot;
-	int idx;
+	int idx, view;
 
 	idx = srcu_read_lock(&kvm->srcu);
 	spin_lock(&kvm->mmu_lock);
 
-	radix_tree_for_each_slot(slot, &kvmi->access_tree, &iter, 0) {
-		struct kvmi_mem_access *m = *slot;
+	for (view = 0; view < KVMI_MAX_ACCESS_TREES; view++)
+		radix_tree_for_each_slot(slot, &kvmi->access_tree[view],
+					 &iter, 0) {
+			struct kvmi_mem_access *m = *slot;
 
-		m->access = full_access;
-		kvmi_arch_update_page_tracking(kvm, NULL, m);
+			m->access = full_access;
+			kvmi_arch_update_page_tracking(kvm, NULL, m, view);
 
-		radix_tree_iter_delete(&kvmi->access_tree, &iter, slot);
-		kmem_cache_free(radix_cache, m);
-	}
+			radix_tree_iter_delete(&kvmi->access_tree[view],
+					       &iter, slot);
+			kmem_cache_free(radix_cache, m);
+		}
 
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -335,8 +338,9 @@ alloc_kvmi(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 
 	atomic_set(&kvmi->ev_seq, 0);
 
-	INIT_RADIX_TREE(&kvmi->access_tree,
-			GFP_KERNEL & ~__GFP_DIRECT_RECLAIM);
+	for (i = 0; i < ARRAY_SIZE(kvmi->access_tree); i++)
+		INIT_RADIX_TREE(&kvmi->access_tree[i],
+				GFP_KERNEL & ~__GFP_DIRECT_RECLAIM);
 	rwlock_init(&kvmi->access_tree_lock);
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
@@ -1065,33 +1069,35 @@ bool kvmi_enter_guest(struct kvm_vcpu *vcpu)
 }
 
 static struct kvmi_mem_access *
-__kvmi_get_gfn_access(struct kvm_introspection *kvmi, const gfn_t gfn)
+__kvmi_get_gfn_access(struct kvm_introspection *kvmi, const gfn_t gfn, u16 view)
 {
-	return radix_tree_lookup(&kvmi->access_tree, gfn);
+	return radix_tree_lookup(&kvmi->access_tree[view], gfn);
 }
 
-static void kvmi_update_mem_access(struct kvm *kvm, struct kvmi_mem_access *m)
+static void kvmi_update_mem_access(struct kvm *kvm, struct kvmi_mem_access *m,
+				   u16 view)
 {
 	struct kvm_introspection *kvmi = KVMI(kvm);
 
-	kvmi_arch_update_page_tracking(kvm, NULL, m);
+	kvmi_arch_update_page_tracking(kvm, NULL, m, view);
 
 	if (m->access == full_access) {
-		radix_tree_delete(&kvmi->access_tree, m->gfn);
+		radix_tree_delete(&kvmi->access_tree[view], m->gfn);
 		kmem_cache_free(radix_cache, m);
 	}
 }
 
-static void kvmi_insert_mem_access(struct kvm *kvm, struct kvmi_mem_access *m)
+static void kvmi_insert_mem_access(struct kvm *kvm, struct kvmi_mem_access *m,
+				   u16 view)
 {
 	struct kvm_introspection *kvmi = KVMI(kvm);
 
-	radix_tree_insert(&kvmi->access_tree, m->gfn, m);
-	kvmi_arch_update_page_tracking(kvm, NULL, m);
+	radix_tree_insert(&kvmi->access_tree[view], m->gfn, m);
+	kvmi_arch_update_page_tracking(kvm, NULL, m, view);
 }
 
 static void kvmi_set_mem_access(struct kvm *kvm, struct kvmi_mem_access *m,
-				bool *used)
+				u16 view, bool *used)
 {
 	struct kvm_introspection *kvmi = KVMI(kvm);
 	struct kvmi_mem_access *found;
@@ -1101,12 +1107,12 @@ static void kvmi_set_mem_access(struct kvm *kvm, struct kvmi_mem_access *m,
 	spin_lock(&kvm->mmu_lock);
 	write_lock(&kvmi->access_tree_lock);
 
-	found = __kvmi_get_gfn_access(kvmi, m->gfn);
+	found = __kvmi_get_gfn_access(kvmi, m->gfn, view);
 	if (found) {
 		found->access = m->access;
-		kvmi_update_mem_access(kvm, found);
+		kvmi_update_mem_access(kvm, found, view);
 	} else if (m->access != full_access) {
-		kvmi_insert_mem_access(kvm, m);
+		kvmi_insert_mem_access(kvm, m, view);
 		*used = true;
 	}
 
@@ -1115,7 +1121,8 @@ static void kvmi_set_mem_access(struct kvm *kvm, struct kvmi_mem_access *m,
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
-static int kvmi_set_gfn_access(struct kvm *kvm, gfn_t gfn, u8 access)
+static int kvmi_set_gfn_access(struct kvm *kvm, gfn_t gfn, u8 access,
+			       u16 view)
 {
 	struct kvmi_mem_access *m;
 	bool used = false;
@@ -1131,7 +1138,7 @@ static int kvmi_set_gfn_access(struct kvm *kvm, gfn_t gfn, u8 access)
 	if (radix_tree_preload(GFP_KERNEL))
 		err = -KVM_ENOMEM;
 	else
-		kvmi_set_mem_access(kvm, m, &used);
+		kvmi_set_mem_access(kvm, m, view, &used);
 
 	radix_tree_preload_end();
 
@@ -1153,7 +1160,7 @@ static bool kvmi_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 	return visible;
 }
 
-static int set_page_access_entry(struct kvm_introspection *kvmi,
+static int set_page_access_entry(struct kvm_introspection *kvmi, u16 view,
 				 const struct kvmi_page_access_entry *entry)
 {
 	u8 unknown_bits = ~(KVMI_PAGE_ACCESS_R | KVMI_PAGE_ACCESS_W
@@ -1169,7 +1176,7 @@ static int set_page_access_entry(struct kvm_introspection *kvmi,
 	if (!kvmi_is_visible_gfn(kvm, gfn))
 		return entry->visible ? -KVM_EINVAL : 0;
 
-	return kvmi_set_gfn_access(kvm, gfn, entry->access);
+	return kvmi_set_gfn_access(kvm, gfn, entry->access, view);
 }
 
 int kvmi_cmd_set_page_access(struct kvm_introspection *kvmi,
@@ -1187,7 +1194,7 @@ int kvmi_cmd_set_page_access(struct kvm_introspection *kvmi,
 		return -KVM_EINVAL;
 
 	for (; entry < end; entry++) {
-		int r = set_page_access_entry(kvmi, entry);
+		int r = set_page_access_entry(kvmi, 0, entry);
 
 		if (r && !ec)
 			ec = r;
@@ -1197,12 +1204,12 @@ int kvmi_cmd_set_page_access(struct kvm_introspection *kvmi,
 }
 
 static int kvmi_get_gfn_access(struct kvm_introspection *kvmi, const gfn_t gfn,
-			       u8 *access)
+			       u8 *access, u16 view)
 {
 	struct kvmi_mem_access *m;
 
 	read_lock(&kvmi->access_tree_lock);
-	m = __kvmi_get_gfn_access(kvmi, gfn);
+	m = __kvmi_get_gfn_access(kvmi, gfn, view);
 	if (m)
 		*access = m->access;
 	read_unlock(&kvmi->access_tree_lock);
@@ -1211,12 +1218,13 @@ static int kvmi_get_gfn_access(struct kvm_introspection *kvmi, const gfn_t gfn,
 }
 
 bool kvmi_restricted_page_access(struct kvm_introspection *kvmi, gpa_t gpa,
-				 u8 access)
+				 u8 access, u16 view)
 {
 	u8 allowed_access;
 	int err;
 
-	err = kvmi_get_gfn_access(kvmi, gpa_to_gfn(gpa), &allowed_access);
+	err = kvmi_get_gfn_access(kvmi, gpa_to_gfn(gpa), &allowed_access, view);
+
 	if (err)
 		return false;
 
@@ -1264,10 +1272,14 @@ void kvmi_add_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	while (start < end) {
 		struct kvmi_mem_access *m;
+		u16 view;
 
-		m = __kvmi_get_gfn_access(kvmi, start);
-		if (m)
-			kvmi_arch_update_page_tracking(kvm, slot, m);
+		for (view = 0; view < KVMI_MAX_ACCESS_TREES; view++) {
+			m = __kvmi_get_gfn_access(kvmi, start, view);
+			if (m)
+				kvmi_arch_update_page_tracking(kvm, slot, m,
+							       view);
+		}
 		start++;
 	}
 
@@ -1289,14 +1301,18 @@ void kvmi_remove_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 
 	while (start < end) {
 		struct kvmi_mem_access *m;
+		u16 view;
 
-		m = __kvmi_get_gfn_access(kvmi, start);
-		if (m) {
-			u8 prev_access = m->access;
+		for (view = 0; view < KVMI_MAX_ACCESS_TREES; view++) {
+			m = __kvmi_get_gfn_access(kvmi, start, view);
+			if (m) {
+				u8 prev_access = m->access;
 
-			m->access = full_access;
-			kvmi_arch_update_page_tracking(kvm, slot, m);
-			m->access = prev_access;
+				m->access = full_access;
+				kvmi_arch_update_page_tracking(kvm, slot, m,
+							       view);
+				m->access = prev_access;
+			}
 		}
 		start++;
 	}
@@ -1382,14 +1398,15 @@ void kvmi_singlestep_failed(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL(kvmi_singlestep_failed);
 
-static bool __kvmi_tracked_gfn(struct kvm_introspection *kvmi, gfn_t gfn)
+static bool __kvmi_tracked_gfn(struct kvm_introspection *kvmi, gfn_t gfn,
+			       u16 view)
 {
 	u8 ignored_access;
+	int err;
 
-	if (kvmi_get_gfn_access(kvmi, gfn, &ignored_access))
-		return false;
+	err = kvmi_get_gfn_access(kvmi, gfn, &ignored_access, view);
 
-	return true;
+	return !err;
 }
 
 bool kvmi_tracked_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
@@ -1401,7 +1418,7 @@ bool kvmi_tracked_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
 	if (!kvmi)
 		return false;
 
-	ret = __kvmi_tracked_gfn(kvmi, gfn);
+	ret = __kvmi_tracked_gfn(kvmi, gfn, kvm_get_ept_view(vcpu));
 
 	kvmi_put(vcpu->kvm);
 
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index d78116442ddd..fc6dbd3a6472 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -89,7 +89,7 @@ int kvmi_cmd_set_page_access(struct kvm_introspection *kvmi,
 			     const struct kvmi_msg_hdr *msg,
 			     const struct kvmi_vm_set_page_access *req);
 bool kvmi_restricted_page_access(struct kvm_introspection *kvmi, gpa_t gpa,
-				 u8 access);
+				 u8 access, u16 view);
 bool kvmi_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva, u8 access);
 void kvmi_add_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 		      unsigned long npages);
@@ -140,7 +140,7 @@ int kvmi_arch_cmd_vcpu_control_msr(struct kvm_vcpu *vcpu,
 				   const struct kvmi_vcpu_control_msr *req);
 void kvmi_arch_update_page_tracking(struct kvm *kvm,
 				    struct kvm_memory_slot *slot,
-				    struct kvmi_mem_access *m);
+				    struct kvmi_mem_access *m, u16 view);
 void kvmi_arch_hook(struct kvm *kvm);
 void kvmi_arch_unhook(struct kvm *kvm);
 void kvmi_arch_features(struct kvmi_features *feat);
