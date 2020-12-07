Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E889C2D1B3B
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbgLGUtC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:49:02 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42594 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727591AbgLGUsx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:53 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 576B3305D483;
        Mon,  7 Dec 2020 22:46:25 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 295DB3072784;
        Mon,  7 Dec 2020 22:46:25 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 74/81] KVM: introspection: add KVMI_VM_SET_PAGE_ACCESS
Date:   Mon,  7 Dec 2020 22:46:15 +0200
Message-Id: <20201207204622.15258-75-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This command sets the spte access bits (rwx) for an array of guest
physical addresses (through the page tracking subsystem).

These GPAs, with the requested access bits, are also kept in a radix
tree in order to filter out the #PF events which are of no interest to
the introspection tool and to reapply the settings when a memory slot
is moved.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               |  59 +++++++++
 arch/x86/include/asm/kvm_host.h               |   2 +
 arch/x86/include/asm/kvmi_host.h              |   7 ++
 arch/x86/kvm/kvmi.c                           |  40 ++++++
 include/linux/kvmi_host.h                     |   3 +
 include/uapi/linux/kvmi.h                     |  20 +++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  |  50 ++++++++
 virt/kvm/introspection/kvmi.c                 | 119 +++++++++++++++++-
 virt/kvm/introspection/kvmi_int.h             |  10 ++
 virt/kvm/introspection/kvmi_msg.c             |  59 +++++++++
 10 files changed, 368 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 7220f27ea5c3..dc96f935320a 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -965,6 +965,65 @@ to control events for any other register will fail with -KVM_EINVAL::
 * -KVM_EPERM  - the interception of the selected MSR is disallowed
                 from userspace (KVM_X86_SET_MSR_FILTER)
 
+23. KVMI_VM_SET_PAGE_ACCESS
+---------------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vm_set_page_access {
+		__u16 count;
+		__u16 padding1;
+		__u32 padding2;
+		struct kvmi_page_access_entry entries[0];
+	};
+
+where::
+
+	struct kvmi_page_access_entry {
+		__u64 gpa;
+		__u8 access;
+		__u8 padding[7];
+	};
+
+
+:Returns:
+
+::
+
+	struct kvmi_error_code
+
+Sets the access bits (rwx) for an array of ``count`` guest physical
+addresses (``gpa``).
+
+The valid access bits are::
+
+	KVMI_PAGE_ACCESS_R
+	KVMI_PAGE_ACCESS_W
+	KVMI_PAGE_ACCESS_X
+
+
+The command will fail with -KVM_EINVAL if any of the specified combination
+of access bits is not supported or the address (``gpa``) is not valid
+(visible).
+
+The command will try to apply all changes and return the first error if
+some failed. The introspection tool should handle the rollback.
+
+In order to 'forget' an address, all three bits ('rwx') must be set.
+
+:Errors:
+
+* -KVM_EINVAL - the specified access bits combination is invalid
+* -KVM_EINVAL - the address is not valid
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EINVAL - the message size is invalid
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_ENOMEM - there is not enough memory to add the page tracking structures
+
 Events
 ======
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3639e50b6488..3503457f1de1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -45,6 +45,8 @@
 #define KVM_PRIVATE_MEM_SLOTS 3
 #define KVM_MEM_SLOTS_NUM (KVM_USER_MEM_SLOTS + KVM_PRIVATE_MEM_SLOTS)
 
+#include <asm/kvmi_host.h>
+
 #define KVM_HALT_POLL_NS_DEFAULT 200000
 
 #define KVM_IRQCHIP_NUM_PINS  KVM_IOAPIC_NUM_PINS
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 8822f0310156..420358c4a9ae 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_X86_KVMI_HOST_H
 #define _ASM_X86_KVMI_HOST_H
 
+#include <asm/kvm_page_track.h>
 #include <asm/kvmi.h>
 
 struct msr_data;
@@ -54,6 +55,12 @@ struct kvm_vcpu_arch_introspection {
 struct kvm_arch_introspection {
 };
 
+#define SLOTS_SIZE BITS_TO_LONGS(KVM_MEM_SLOTS_NUM)
+
+struct kvmi_arch_mem_access {
+	unsigned long active[KVM_PAGE_TRACK_MAX][SLOTS_SIZE];
+};
+
 #ifdef CONFIG_KVM_INTROSPECTION
 
 bool kvmi_monitor_bp_intercept(struct kvm_vcpu *vcpu, u32 dbg);
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index e325dad88dbb..acd4756e0d78 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -919,3 +919,43 @@ bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 	return ret;
 }
+
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
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 7a7360306812..14ac075a3ea9 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -52,6 +52,9 @@ struct kvm_introspection {
 	atomic_t ev_seq;
 
 	bool restore_on_unhook;
+
+	struct radix_tree_root access_tree;
+	rwlock_t access_tree_lock;
 };
 
 int kvmi_version(void);
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index c8e7f4516379..42c8e6342fcf 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -30,6 +30,7 @@ enum {
 	KVMI_VM_PAUSE_VCPU      = KVMI_VM_MESSAGE_ID(8),
 	KVMI_VM_CONTROL_CLEANUP = KVMI_VM_MESSAGE_ID(9),
 	KVMI_VM_GET_MAX_GFN     = KVMI_VM_MESSAGE_ID(10),
+	KVMI_VM_SET_PAGE_ACCESS = KVMI_VM_MESSAGE_ID(11),
 
 	KVMI_NEXT_VM_MESSAGE
 };
@@ -81,6 +82,12 @@ enum {
 	KVMI_EVENT_ACTION_CRASH    = 2,
 };
 
+enum {
+	KVMI_PAGE_ACCESS_R = 1 << 0,
+	KVMI_PAGE_ACCESS_W = 1 << 1,
+	KVMI_PAGE_ACCESS_X = 1 << 2,
+};
+
 struct kvmi_msg_hdr {
 	__u16 id;
 	__u16 size;
@@ -190,4 +197,17 @@ struct kvmi_vm_get_max_gfn_reply {
 	__u64 gfn;
 };
 
+struct kvmi_page_access_entry {
+	__u64 gpa;
+	__u8 access;
+	__u8 padding[7];
+};
+
+struct kvmi_vm_set_page_access {
+	__u16 count;
+	__u16 padding1;
+	__u32 padding2;
+	struct kvmi_page_access_entry entries[0];
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 2e07b22bc8c0..c9d6ee57d506 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1689,6 +1689,55 @@ static void test_cmd_vcpu_control_msr(struct kvm_vm *vm)
 	test_invalid_control_msr(vm, msr);
 }
 
+static int cmd_set_page_access(__u16 count, __u64 *gpa, __u8 *access)
+{
+	struct kvmi_page_access_entry *entry, *end;
+	struct kvmi_vm_set_page_access *cmd;
+	struct kvmi_msg_hdr *req;
+	size_t req_size;
+	int r;
+
+	req_size = sizeof(*req) + sizeof(*cmd) + count * sizeof(*entry);
+	req = calloc(1, req_size);
+
+	cmd = (struct kvmi_vm_set_page_access *)(req + 1);
+	cmd->count = count;
+
+	entry = cmd->entries;
+	end = cmd->entries + count;
+	for (; entry < end; entry++) {
+		entry->gpa = *gpa++;
+		entry->access = *access++;
+	}
+
+	r = do_command(KVMI_VM_SET_PAGE_ACCESS, req, req_size, NULL, 0);
+
+	free(req);
+	return r;
+}
+
+static void set_page_access(__u64 gpa, __u8 access)
+{
+	int r;
+
+	r = cmd_set_page_access(1, &gpa, &access);
+	TEST_ASSERT(r == 0,
+		"KVMI_VM_SET_PAGE_ACCESS failed, gpa 0x%llx, access 0x%x, error %d (%s)\n",
+		gpa, access, -r, kvm_strerror(-r));
+}
+
+static void test_cmd_vm_set_page_access(struct kvm_vm *vm)
+{
+	__u8 full_access = KVMI_PAGE_ACCESS_R | KVMI_PAGE_ACCESS_W |
+			   KVMI_PAGE_ACCESS_X;
+	__u8 no_access = 0;
+	__u64 gpa = 0;
+
+	set_page_access(gpa, no_access);
+
+	set_page_access(gpa, full_access);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1721,6 +1770,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_get_mtrr_type(vm);
 	test_event_descriptor(vm);
 	test_cmd_vcpu_control_msr(vm);
+	test_cmd_vm_set_page_access(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 8978791b7469..c21c705ccddf 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -26,6 +26,11 @@ static DECLARE_BITMAP(Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
 
 static struct kmem_cache *msg_cache;
 static struct kmem_cache *job_cache;
+static struct kmem_cache *radix_cache;
+
+static const u8 full_access  =	KVMI_PAGE_ACCESS_R |
+				KVMI_PAGE_ACCESS_W |
+				KVMI_PAGE_ACCESS_X;
 
 void *kvmi_msg_alloc(void)
 {
@@ -44,6 +49,8 @@ static void kvmi_cache_destroy(void)
 	msg_cache = NULL;
 	kmem_cache_destroy(job_cache);
 	job_cache = NULL;
+	kmem_cache_destroy(radix_cache);
+	radix_cache = NULL;
 }
 
 static int kvmi_cache_create(void)
@@ -53,8 +60,11 @@ static int kvmi_cache_create(void)
 	job_cache = kmem_cache_create("kvmi_job",
 				      sizeof(struct kvmi_job),
 				      0, SLAB_ACCOUNT, NULL);
+	radix_cache = kmem_cache_create("kvmi_radix_tree",
+					sizeof(struct kvmi_mem_access),
+					0, SLAB_ACCOUNT, NULL);
 
-	if (!msg_cache || !job_cache) {
+	if (!msg_cache || !job_cache || !radix_cache) {
 		kvmi_cache_destroy();
 
 		return -1;
@@ -245,12 +255,38 @@ static void kvmi_free_vcpui(struct kvm_vcpu *vcpu, bool restore_interception)
 	kvmi_make_request(vcpu, false);
 }
 
+static void kvmi_clear_mem_access(struct kvm *kvm)
+{
+	struct kvm_introspection *kvmi = KVMI(kvm);
+	struct radix_tree_iter iter;
+	void **slot;
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	spin_lock(&kvm->mmu_lock);
+
+	radix_tree_for_each_slot(slot, &kvmi->access_tree, &iter, 0) {
+		struct kvmi_mem_access *m = *slot;
+
+		m->access = full_access;
+		kvmi_arch_update_page_tracking(kvm, NULL, m);
+
+		radix_tree_iter_delete(&kvmi->access_tree, &iter, slot);
+		kmem_cache_free(radix_cache, m);
+	}
+
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+}
+
 static void kvmi_free(struct kvm *kvm)
 {
 	bool restore_interception = KVMI(kvm)->restore_on_unhook;
 	struct kvm_vcpu *vcpu;
 	int i;
 
+	kvmi_clear_mem_access(kvm);
+
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvmi_free_vcpui(vcpu, restore_interception);
 
@@ -305,6 +341,10 @@ kvmi_alloc(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 
 	atomic_set(&kvmi->ev_seq, 0);
 
+	INIT_RADIX_TREE(&kvmi->access_tree,
+			GFP_KERNEL & ~__GFP_DIRECT_RECLAIM);
+	rwlock_init(&kvmi->access_tree_lock);
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		int err = kvmi_create_vcpui(vcpu);
 
@@ -938,3 +978,80 @@ bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len)
 	return ret;
 }
 EXPORT_SYMBOL(kvmi_breakpoint_event);
+
+static struct kvmi_mem_access *
+__kvmi_get_gfn_access(struct kvm_introspection *kvmi, const gfn_t gfn)
+{
+	return radix_tree_lookup(&kvmi->access_tree, gfn);
+}
+
+static void kvmi_update_mem_access(struct kvm *kvm, struct kvmi_mem_access *m)
+{
+	struct kvm_introspection *kvmi = KVMI(kvm);
+
+	kvmi_arch_update_page_tracking(kvm, NULL, m);
+
+	if (m->access == full_access) {
+		radix_tree_delete(&kvmi->access_tree, m->gfn);
+		kmem_cache_free(radix_cache, m);
+	}
+}
+
+static void kvmi_insert_mem_access(struct kvm *kvm, struct kvmi_mem_access *m)
+{
+	struct kvm_introspection *kvmi = KVMI(kvm);
+
+	radix_tree_insert(&kvmi->access_tree, m->gfn, m);
+	kvmi_arch_update_page_tracking(kvm, NULL, m);
+}
+
+static void kvmi_set_mem_access(struct kvm *kvm, struct kvmi_mem_access *m,
+				bool *used)
+{
+	struct kvm_introspection *kvmi = KVMI(kvm);
+	struct kvmi_mem_access *found;
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvmi->access_tree_lock);
+
+	found = __kvmi_get_gfn_access(kvmi, m->gfn);
+	if (found) {
+		found->access = m->access;
+		kvmi_update_mem_access(kvm, found);
+	} else if (m->access != full_access) {
+		kvmi_insert_mem_access(kvm, m);
+		*used = true;
+	}
+
+	write_unlock(&kvmi->access_tree_lock);
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+}
+
+int kvmi_set_gfn_access(struct kvm *kvm, gfn_t gfn, u8 access)
+{
+	struct kvmi_mem_access *m;
+	bool used = false;
+	int err = 0;
+
+	m = kmem_cache_zalloc(radix_cache, GFP_KERNEL);
+	if (!m)
+		return -KVM_ENOMEM;
+
+	m->gfn = gfn;
+	m->access = access;
+
+	if (radix_tree_preload(GFP_KERNEL))
+		err = -KVM_ENOMEM;
+	else
+		kvmi_set_mem_access(kvm, m, &used);
+
+	radix_tree_preload_end();
+
+	if (!used)
+		kmem_cache_free(radix_cache, m);
+
+	return err;
+}
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 0a7a8285b981..41720b194458 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -26,6 +26,12 @@ typedef int (*kvmi_vcpu_msg_job_fct)(const struct kvmi_vcpu_msg_job *job,
 				     const struct kvmi_msg_hdr *msg,
 				     const void *req);
 
+struct kvmi_mem_access {
+	gfn_t gfn;
+	u8 access;
+	struct kvmi_arch_mem_access arch;
+};
+
 static inline bool is_vcpu_event_enabled(struct kvm_vcpu *vcpu, u16 event_id)
 {
 	return test_bit(event_id, VCPUI(vcpu)->ev_enable_mask);
@@ -86,6 +92,7 @@ int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, size_t size,
 int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, size_t size,
 			    const void *buf);
 int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait);
+int kvmi_set_gfn_access(struct kvm *kvm, gfn_t gfn, u8 access);
 
 /* arch */
 void kvmi_arch_init_vcpu_events_mask(unsigned long *supported);
@@ -104,5 +111,8 @@ void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
 int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
 				    unsigned int event_id, bool enable);
 void kvmi_arch_send_pending_event(struct kvm_vcpu *vcpu);
+void kvmi_arch_update_page_tracking(struct kvm *kvm,
+				    struct kvm_memory_slot *slot,
+				    struct kvmi_mem_access *m);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 30692d84a247..2cba745db7e3 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -302,6 +302,64 @@ static int handle_vm_get_max_gfn(struct kvm_introspection *kvmi,
 	return kvmi_msg_vm_reply(kvmi, msg, 0, &rpl, sizeof(rpl));
 }
 
+static bool kvmi_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
+{
+	bool visible;
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	visible = kvm_is_visible_gfn(kvm, gfn);
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	return visible;
+}
+
+static int set_page_access_entry(struct kvm_introspection *kvmi,
+				 const struct kvmi_page_access_entry *entry)
+{
+	u8 unknown_bits = ~(KVMI_PAGE_ACCESS_R | KVMI_PAGE_ACCESS_W |
+			    KVMI_PAGE_ACCESS_X);
+	gfn_t gfn = gpa_to_gfn(entry->gpa);
+	struct kvm *kvm = kvmi->kvm;
+
+	if ((entry->access & unknown_bits) ||
+	     non_zero_padding(entry->padding, ARRAY_SIZE(entry->padding)))
+		return -KVM_EINVAL;
+
+	if (!kvmi_is_visible_gfn(kvm, gfn))
+		return -KVM_EINVAL;
+
+	return kvmi_set_gfn_access(kvm, gfn, entry->access);
+}
+
+static int handle_vm_set_page_access(struct kvm_introspection *kvmi,
+				     const struct kvmi_msg_hdr *msg,
+				     const void *_req)
+{
+	const struct kvmi_vm_set_page_access *req = _req;
+	const struct kvmi_page_access_entry *entry;
+	size_t n = req->count;
+	int ec = 0;
+
+	if (struct_size(req, entries, n) > msg->size)
+		return -EINVAL;
+
+	if (req->padding1 || req->padding2) {
+		ec = -KVM_EINVAL;
+		goto reply;
+	}
+
+	for (entry = req->entries; n; n--, entry++) {
+		int err = set_page_access_entry(kvmi, entry);
+
+		if (err && !ec)
+			ec = err;
+	}
+
+reply:
+	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
+}
+
 /*
  * These commands are executed by the receiving thread.
  */
@@ -315,6 +373,7 @@ static kvmi_vm_msg_fct const msg_vm[] = {
 	[KVMI_VM_GET_MAX_GFN]     = handle_vm_get_max_gfn,
 	[KVMI_VM_PAUSE_VCPU]      = handle_vm_pause_vcpu,
 	[KVMI_VM_READ_PHYSICAL]   = handle_vm_read_physical,
+	[KVMI_VM_SET_PAGE_ACCESS] = handle_vm_set_page_access,
 	[KVMI_VM_WRITE_PHYSICAL]  = handle_vm_write_physical,
 };
 
