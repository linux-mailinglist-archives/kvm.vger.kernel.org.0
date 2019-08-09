Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9F087F52
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437183AbfHIQPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:55 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52860 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437106AbfHIQPG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:06 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 9A916305D35B;
        Fri,  9 Aug 2019 19:01:37 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 53189305B7A0;
        Fri,  9 Aug 2019 19:01:35 +0300 (EEST)
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
Subject: [RFC PATCH v6 73/92] kvm: introspection: use remote mapping
Date:   Fri,  9 Aug 2019 19:00:28 +0300
Message-Id: <20190809160047.8319-74-alazar@bitdefender.com>
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

This commit adds the missing KVMI_GET_MAP_TOKEN command and handle the
hypercalls used to map/unmap guest pages.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst |  39 ++++
 arch/x86/kvm/Makefile              |   2 +-
 arch/x86/kvm/x86.c                 |   6 +
 include/linux/kvmi.h               |   3 +
 virt/kvm/kvmi.c                    |  12 +-
 virt/kvm/kvmi_int.h                |  10 +
 virt/kvm/kvmi_mem.c                | 319 +++++++++++++++++++++++++++++
 virt/kvm/kvmi_msg.c                |  15 ++
 8 files changed, 404 insertions(+), 2 deletions(-)
 create mode 100644 virt/kvm/kvmi_mem.c

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index 572abab1f6ef..b12e14f14c21 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -1144,6 +1144,45 @@ Returns the guest memory type for a specific physical address.
 * -KVM_EINVAL - padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+25. KVMI_GET_MAP_TOKEN
+----------------------
+
+:Architecture: all
+:Versions: >= 1
+:Parameters: none
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+	struct kvmi_get_map_token_reply {
+		struct kvmi_map_mem_token token;
+	};
+
+Where::
+
+	struct kvmi_map_mem_token {
+		__u64 token[4];
+	};
+
+Requests a token for a memory map operation.
+
+On this command, the host generates a random token to be used (once)
+to map a physical page from the introspected guest. The introspector
+could use the token with the KVM_INTRO_MEM_MAP ioctl (on /dev/kvmmem)
+to map a guest physical page to one of its memory pages. The ioctl,
+in turn, will use the KVM_HC_MEM_MAP hypercall (see hypercalls.txt).
+
+The guest kernel exposing /dev/kvmmem keeps a list with all the mappings
+(to all the guests introspected by the tool) in order to unmap them
+(using the KVM_HC_MEM_UNMAP hypercall) when /dev/kvmmem is closed or on
+demand (using the KVM_INTRO_MEM_UNMAP ioctl).
+
+:Errors:
+
+* -KVM_EAGAIN - too many tokens have accumulated
+* -KVM_ENOMEM - not enough memory to allocate a new token
+
 Events
 ======
 
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 673cf37c0747..5bea446219ca 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -7,7 +7,7 @@ KVM := ../../../virt/kvm
 kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
 				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
-kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVM)/kvmi.o $(KVM)/kvmi_msg.o kvmi.o
+kvm-$(CONFIG_KVM_INTROSPECTION) += $(KVM)/kvmi.o $(KVM)/kvmi_msg.o $(KVM)/kvmi_mem.o kvmi.o
 
 kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 06f44ce8ed07..04b1d2916a0a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7337,6 +7337,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		ret = kvm_pv_send_ipi(vcpu->kvm, a0, a1, a2, a3, op_64_bit);
 		break;
 #ifdef CONFIG_KVM_INTROSPECTION
+	case KVM_HC_MEM_MAP:
+		ret = kvmi_host_mem_map(vcpu, (gva_t)a0, (gpa_t)a1, (gpa_t)a2);
+		break;
+	case KVM_HC_MEM_UNMAP:
+		ret = kvmi_host_mem_unmap(vcpu, (gpa_t)a0);
+		break;
 	case KVM_HC_XEN_HVM_OP:
 		ret = 0;
 		if (!kvmi_hypercall_event(vcpu))
diff --git a/include/linux/kvmi.h b/include/linux/kvmi.h
index 10cd6c6412d2..dd980fb0ebcd 100644
--- a/include/linux/kvmi.h
+++ b/include/linux/kvmi.h
@@ -24,6 +24,9 @@ bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, u8 write);
 bool kvmi_tracked_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 bool kvmi_single_step(struct kvm_vcpu *vcpu, gpa_t gpa, int *emulation_type);
 void kvmi_handle_requests(struct kvm_vcpu *vcpu);
+int kvmi_host_mem_map(struct kvm_vcpu *vcpu, gva_t tkn_gva,
+			     gpa_t req_gpa, gpa_t map_gpa);
+int kvmi_host_mem_unmap(struct kvm_vcpu *vcpu, gpa_t map_gpa);
 void kvmi_stop_ss(struct kvm_vcpu *vcpu);
 bool kvmi_vcpu_enabled_ss(struct kvm_vcpu *vcpu);
 void kvmi_init_emulate(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index ca146ffec061..157f3a401d64 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -10,6 +10,7 @@
 #include "kvmi_int.h"
 #include <linux/kthread.h>
 #include <linux/bitmap.h>
+#include <linux/remote_mapping.h>
 
 #define MAX_PAUSE_REQUESTS 1001
 
@@ -320,11 +321,13 @@ static int kvmi_cache_create(void)
 
 int kvmi_init(void)
 {
+	kvmi_mem_init();
 	return kvmi_cache_create();
 }
 
 void kvmi_uninit(void)
 {
+	kvmi_mem_exit();
 	kvmi_cache_destroy();
 }
 
@@ -1647,6 +1650,11 @@ int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, u64 size, const void *buf)
 	return 0;
 }
 
+int kvmi_cmd_alloc_token(struct kvm *kvm, struct kvmi_map_mem_token *token)
+{
+	return kvmi_mem_generate_token(kvm, token);
+}
+
 int kvmi_cmd_control_events(struct kvm_vcpu *vcpu, unsigned int event_id,
 			    bool enable)
 {
@@ -2015,7 +2023,9 @@ int kvmi_ioctl_unhook(struct kvm *kvm, bool force_reset)
 	if (!ikvm)
 		return -EFAULT;
 
-	if (!force_reset && !kvmi_unhook_event(kvm))
+	if (force_reset)
+		mm_remote_reset();
+	else if (!kvmi_unhook_event(kvm))
 		err = -ENOENT;
 
 	kvmi_put(kvm);
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index c96fa2b1e9b7..2432377d6371 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -148,6 +148,8 @@ struct kvmi {
 	struct task_struct *recv;
 	atomic_t ev_seq;
 
+	atomic_t num_tokens;
+
 	uuid_t uuid;
 
 	DECLARE_BITMAP(cmd_allow_mask, KVMI_NUM_COMMANDS);
@@ -229,7 +231,9 @@ int kvmi_cmd_control_events(struct kvm_vcpu *vcpu, unsigned int event_id,
 			    bool enable);
 int kvmi_cmd_control_vm_events(struct kvmi *ikvm, unsigned int event_id,
 			       bool enable);
+int kvmi_cmd_alloc_token(struct kvm *kvm, struct kvmi_map_mem_token *token);
 int kvmi_cmd_pause_vcpu(struct kvm_vcpu *vcpu, bool wait);
+unsigned long gfn_to_hva_safe(struct kvm *kvm, gfn_t gfn);
 struct kvmi * __must_check kvmi_get(struct kvm *kvm);
 void kvmi_put(struct kvm *kvm);
 int kvmi_run_jobs_and_wait(struct kvm_vcpu *vcpu);
@@ -298,4 +302,10 @@ int kvmi_arch_cmd_control_msr(struct kvm_vcpu *vcpu,
 			      const struct kvmi_control_msr *req);
 int kvmi_arch_cmd_get_mtrr_type(struct kvm_vcpu *vcpu, u64 gpa, u8 *type);
 
+/* kvmi_mem.c */
+void kvmi_mem_init(void);
+void kvmi_mem_exit(void);
+int kvmi_mem_generate_token(struct kvm *kvm, struct kvmi_map_mem_token *token);
+void kvmi_clear_vm_tokens(struct kvm *kvm);
+
 #endif
diff --git a/virt/kvm/kvmi_mem.c b/virt/kvm/kvmi_mem.c
new file mode 100644
index 000000000000..6244add60062
--- /dev/null
+++ b/virt/kvm/kvmi_mem.c
@@ -0,0 +1,319 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KVM introspection memory mapping implementation
+ *
+ * Copyright (C) 2017-2019 Bitdefender S.R.L.
+ *
+ * Author:
+ *   Mircea Cirjaliu <mcirjaliu@bitdefender.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/kvm_host.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/pagemap.h>
+#include <linux/spinlock.h>
+#include <linux/printk.h>
+#include <linux/random.h>
+#include <linux/kvmi.h>
+#include <linux/ktime.h>
+#include <linux/hrtimer.h>
+#include <linux/workqueue.h>
+#include <linux/remote_mapping.h>
+
+#include <uapi/linux/kvmi.h>
+
+#include "kvmi_int.h"
+
+#define KVMI_MEM_MAX_TOKENS 8
+#define KVMI_MEM_TOKEN_TIMEOUT 3
+#define TOKEN_TIMEOUT_NSEC (KVMI_MEM_TOKEN_TIMEOUT * NSEC_PER_SEC)
+
+static struct list_head token_list;
+static spinlock_t token_lock;
+static struct hrtimer token_timer;
+static struct work_struct token_work;
+
+struct token_entry {
+	struct list_head token_list;
+	struct kvmi_map_mem_token token;
+	struct kvm *kvm;
+	ktime_t timestamp;
+};
+
+void kvmi_clear_vm_tokens(struct kvm *kvm)
+{
+	struct token_entry *cur, *next;
+	struct kvmi *ikvm = IKVM(kvm);
+	struct list_head temp;
+
+	INIT_LIST_HEAD(&temp);
+
+	spin_lock(&token_lock);
+	list_for_each_entry_safe(cur, next, &token_list, token_list) {
+		if (cur->kvm == kvm) {
+			atomic_dec(&ikvm->num_tokens);
+
+			list_del(&cur->token_list);
+			list_add(&cur->token_list, &temp);
+		}
+	}
+	spin_unlock(&token_lock);
+
+	/* freeing a KVM may sleep */
+	list_for_each_entry_safe(cur, next, &temp, token_list) {
+		kvm_put_kvm(cur->kvm);
+		kfree(cur);
+	}
+}
+
+static void token_timeout_work(struct work_struct *work)
+{
+	struct token_entry *cur, *next;
+	ktime_t now = ktime_get();
+	struct kvmi *ikvm;
+	struct list_head temp;
+
+	INIT_LIST_HEAD(&temp);
+
+	spin_lock(&token_lock);
+	list_for_each_entry_safe(cur, next, &token_list, token_list)
+		if (ktime_sub(now, cur->timestamp) > TOKEN_TIMEOUT_NSEC) {
+			ikvm = kvmi_get(cur->kvm);
+			if (ikvm) {
+				atomic_dec(&ikvm->num_tokens);
+				kvmi_put(cur->kvm);
+			}
+
+			list_del(&cur->token_list);
+			list_add(&cur->token_list, &temp);
+		}
+	spin_unlock(&token_lock);
+
+	if (!list_empty(&temp))
+		kvm_info("kvmi: token(s) timed out\n");
+
+	/* freeing a KVM may sleep */
+	list_for_each_entry_safe(cur, next, &temp, token_list) {
+		kvm_put_kvm(cur->kvm);
+		kfree(cur);
+	}
+}
+
+static enum hrtimer_restart token_timer_fn(struct hrtimer *timer)
+{
+	schedule_work(&token_work);
+
+	hrtimer_add_expires_ns(timer, NSEC_PER_SEC);
+	return HRTIMER_RESTART;
+}
+
+int kvmi_mem_generate_token(struct kvm *kvm, struct kvmi_map_mem_token *token)
+{
+	struct kvmi *ikvm;
+	struct token_entry *tep;
+
+	/* too many tokens have accumulated, retry later */
+	ikvm = IKVM(kvm);
+	if (atomic_read(&ikvm->num_tokens) > KVMI_MEM_MAX_TOKENS)
+		return -KVM_EAGAIN;
+
+	print_hex_dump_debug("kvmi: new token ", DUMP_PREFIX_NONE,
+			     32, 1, token, sizeof(*token), false);
+
+	tep = kmalloc(sizeof(*tep), GFP_KERNEL);
+	if (tep == NULL)
+		return -KVM_ENOMEM;
+
+	/* pin KVM so it won't go away while we wait for HC */
+	kvm_get_kvm(kvm);
+	get_random_bytes(token, sizeof(*token));
+	atomic_inc(&ikvm->num_tokens);
+
+	/* init token entry */
+	INIT_LIST_HEAD(&tep->token_list);
+	memcpy(&tep->token, token, sizeof(*token));
+	tep->kvm = kvm;
+	tep->timestamp = ktime_get();
+
+	/* add to list */
+	spin_lock(&token_lock);
+	list_add_tail(&tep->token_list, &token_list);
+	spin_unlock(&token_lock);
+
+	return 0;
+}
+
+static struct kvm *find_machine_at(struct kvm_vcpu *vcpu, gva_t tkn_gva)
+{
+	long result;
+	gpa_t tkn_gpa;
+	struct kvmi_map_mem_token token;
+	struct list_head *cur;
+	struct token_entry *tep, *found = NULL;
+	struct kvm *target_kvm = NULL;
+	struct kvmi *ikvm;
+
+	/* machine token is passed as pointer */
+	tkn_gpa = kvm_mmu_gva_to_gpa_system(vcpu, tkn_gva, 0, NULL);
+	if (tkn_gpa == UNMAPPED_GVA)
+		return NULL;
+
+	/* copy token to local address space */
+	result = kvm_read_guest(vcpu->kvm, tkn_gpa, &token, sizeof(token));
+	if (IS_ERR_VALUE(result)) {
+		kvm_err("kvmi: failed copying token from user\n");
+		return ERR_PTR(result);
+	}
+
+	/* consume token & find the VM */
+	spin_lock(&token_lock);
+	list_for_each(cur, &token_list) {
+		tep = list_entry(cur, struct token_entry, token_list);
+
+		if (!memcmp(&token, &tep->token, sizeof(token))) {
+			list_del(&tep->token_list);
+			found = tep;
+			break;
+		}
+	}
+	spin_unlock(&token_lock);
+
+	if (found != NULL) {
+		target_kvm = found->kvm;
+		kfree(found);
+
+		ikvm = kvmi_get(target_kvm);
+		if (ikvm) {
+			atomic_dec(&ikvm->num_tokens);
+			kvmi_put(target_kvm);
+		}
+	}
+
+	return target_kvm;
+}
+
+
+int kvmi_host_mem_map(struct kvm_vcpu *vcpu, gva_t tkn_gva,
+		      gpa_t req_gpa, gpa_t map_gpa)
+{
+	int result = 0;
+	struct kvm *target_kvm;
+
+	gfn_t req_gfn;
+	hva_t req_hva;
+	struct mm_struct *req_mm;
+
+	gfn_t map_gfn;
+	hva_t map_hva;
+
+	kvm_debug("kvmi: mapping request req_gpa %016llx, map_gpa %016llx\n",
+		  req_gpa, map_gpa);
+
+	/* get the struct kvm * corresponding to the token */
+	target_kvm = find_machine_at(vcpu, tkn_gva);
+	if (IS_ERR_VALUE(target_kvm)) {
+		return PTR_ERR(target_kvm);
+	} else if (target_kvm == NULL) {
+		kvm_err("kvmi: unable to find target machine\n");
+		return -KVM_ENOENT;
+	}
+	req_mm = target_kvm->mm;
+
+	/* translate source addresses */
+	req_gfn = gpa_to_gfn(req_gpa);
+	req_hva = gfn_to_hva_safe(target_kvm, req_gfn);
+	if (kvm_is_error_hva(req_hva)) {
+		kvm_err("kvmi: invalid req_gpa %016llx\n", req_gpa);
+		result = -KVM_EFAULT;
+		goto out;
+	}
+
+	kvm_debug("kvmi: req_gpa %016llx -> req_hva %016lx\n",
+		  req_gpa, req_hva);
+
+	/* translate destination addresses */
+	map_gfn = gpa_to_gfn(map_gpa);
+	map_hva = gfn_to_hva_safe(vcpu->kvm, map_gfn);
+	if (kvm_is_error_hva(map_hva)) {
+		kvm_err("kvmi: invalid map_gpa %016llx\n", map_gpa);
+		result = -KVM_EFAULT;
+		goto out;
+	}
+
+	kvm_debug("kvmi: map_gpa %016llx -> map_hva %016lx\n",
+		map_gpa, map_hva);
+
+	/* actually do the mapping */
+	result = mm_remote_map(req_mm, req_hva, map_hva);
+	if (IS_ERR_VALUE((long)result)) {
+		if (result == -EBUSY)
+			kvm_debug("kvmi: mapping of req_gpa %016llx failed: %d.\n",
+				req_gpa, result);
+		else
+			kvm_err("kvmi: mapping of req_gpa %016llx failed: %d.\n",
+				req_gpa, result);
+		goto out;
+	}
+
+	/* all fine */
+	kvm_debug("kvmi: mapping of req_gpa %016llx successful\n", req_gpa);
+
+out:
+	kvm_put_kvm(target_kvm);
+
+	return result;
+}
+
+int kvmi_host_mem_unmap(struct kvm_vcpu *vcpu, gpa_t map_gpa)
+{
+	gfn_t map_gfn;
+	hva_t map_hva;
+	int result;
+
+	kvm_debug("kvmi: unmapping request for map_gpa %016llx\n", map_gpa);
+
+	/* convert GPA -> HVA */
+	map_gfn = gpa_to_gfn(map_gpa);
+	map_hva = gfn_to_hva_safe(vcpu->kvm, map_gfn);
+	if (kvm_is_error_hva(map_hva)) {
+		result = -KVM_EFAULT;
+		kvm_err("kvmi: invalid map_gpa %016llx\n", map_gpa);
+		goto out;
+	}
+
+	kvm_debug("kvmi: map_gpa %016llx -> map_hva %016lx\n",
+		map_gpa, map_hva);
+
+	/* actually do the unmapping */
+	result = mm_remote_unmap(map_hva);
+	if (IS_ERR_VALUE((long)result))
+		goto out;
+
+	kvm_debug("kvmi: unmapping of map_gpa %016llx successful\n", map_gpa);
+
+out:
+	return result;
+}
+
+void kvmi_mem_init(void)
+{
+	ktime_t expire;
+
+	INIT_LIST_HEAD(&token_list);
+	spin_lock_init(&token_lock);
+	INIT_WORK(&token_work, token_timeout_work);
+
+	hrtimer_init(&token_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	token_timer.function = token_timer_fn;
+	expire = ktime_add_ns(ktime_get(), NSEC_PER_SEC);
+	hrtimer_start(&token_timer, expire, HRTIMER_MODE_ABS);
+
+	kvm_info("kvmi: initialized host memory introspection\n");
+}
+
+void kvmi_mem_exit(void)
+{
+	hrtimer_cancel(&token_timer);
+}
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index 3e381f95b686..a5f87aafa237 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -33,6 +33,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_EVENT_REPLY]           = "KVMI_EVENT_REPLY",
 	[KVMI_GET_CPUID]             = "KVMI_GET_CPUID",
 	[KVMI_GET_GUEST_INFO]        = "KVMI_GET_GUEST_INFO",
+	[KVMI_GET_MAP_TOKEN]         = "KVMI_GET_MAP_TOKEN",
 	[KVMI_GET_MTRR_TYPE]         = "KVMI_GET_MTRR_TYPE",
 	[KVMI_GET_PAGE_ACCESS]       = "KVMI_GET_PAGE_ACCESS",
 	[KVMI_GET_PAGE_WRITE_BITMAP] = "KVMI_GET_PAGE_WRITE_BITMAP",
@@ -352,6 +353,19 @@ static int handle_write_physical(struct kvmi *ikvm,
 	return kvmi_msg_vm_maybe_reply(ikvm, msg, ec, NULL, 0);
 }
 
+static int handle_get_map_token(struct kvmi *ikvm,
+				const struct kvmi_msg_hdr *msg,
+				const void *_req)
+{
+	struct kvmi_get_map_token_reply rpl;
+	int ec;
+
+	memset(&rpl, 0, sizeof(rpl));
+	ec = kvmi_cmd_alloc_token(ikvm->kvm, &rpl.token);
+
+	return kvmi_msg_vm_maybe_reply(ikvm, msg, ec, &rpl, sizeof(rpl));
+}
+
 static bool enable_spp(struct kvmi *ikvm)
 {
 	if (!ikvm->spp.initialized) {
@@ -524,6 +538,7 @@ static int(*const msg_vm[])(struct kvmi *, const struct kvmi_msg_hdr *,
 	[KVMI_CONTROL_SPP]           = handle_control_spp,
 	[KVMI_CONTROL_VM_EVENTS]     = handle_control_vm_events,
 	[KVMI_GET_GUEST_INFO]        = handle_get_guest_info,
+	[KVMI_GET_MAP_TOKEN]         = handle_get_map_token,
 	[KVMI_GET_PAGE_ACCESS]       = handle_get_page_access,
 	[KVMI_GET_PAGE_WRITE_BITMAP] = handle_get_page_write_bitmap,
 	[KVMI_GET_VERSION]           = handle_get_version,
