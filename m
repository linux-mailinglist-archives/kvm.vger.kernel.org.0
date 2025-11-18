Return-Path: <kvm+bounces-63568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 98D41C6AEA4
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 18:21:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 02CC33A58BA
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 17:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFDA9366DA8;
	Tue, 18 Nov 2025 17:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WkTCh3q1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480AE31ED84
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 17:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763485895; cv=none; b=WhH+aUjmVS5kTlIqfQtkItGkgWp3lUqToeTOlRxn4Qs47Cx/hCsR5rwEGx3NV0eFcsOaTrJIx8iYSsCFYXVSh7x3uBkuUezm2p93DfO7LVB3vFgMwjxbYvRzpRZhLncdY9uk7VKNGMwfh+OSbgaoBrJLG/KbgihoM1CU4TyaG5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763485895; c=relaxed/simple;
	bh=qOLV8Bi1e4ENQ+HKeqe/SRVss1oeBj0jwvM6TksA9Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAW9LFkkjlq1YO7q2WuZ7L8PHOGxqll31d6x1z5w9kWP3zLej35dcQfUMbz0yriM++umEAgZqR/upWVYz4ZyB8QsDuVKYVP74SBlYmWDQPdIA81Kj8qLYl/VfbHpZk/IMhhh+Eq/EH3DSTJkjxzghJdybiku2Xb+cGgJ/rO8Zcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WkTCh3q1; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4775ae5684fso29730805e9.1
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 09:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763485891; x=1764090691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=69iXRF+UJC1hs3xkkz0CKthrLlBOVoAMZk7s5v+Iu2k=;
        b=WkTCh3q1TYT8VkIdZcv5yL7DGt9e3TOWL97uUgd56AhSBpljzINiIwj4EXhFqtGqd8
         ZApYnrcDsbwiyPQtlQwXLgWm94Ri8aOZxk6jpq5NwcKYDv5wylzm2oomUl4X/d2L3o0A
         DnWo7q/xUJUscKQI0rw2lhi2Vsw2PrrtMRNNQFcTHdCs0zkwhA2EtRZbb4/T0WrNqwIR
         UYLKazCRkVccbvLwE52+wKMX5etZdfaVRu+LX1DGWiNd85CFJmSMkQLhi6gGwZqUW3kR
         dcGIBZtSLy+951J4F8aL6TnuyPGLmRpFS+bqg8mbFWeGTZ/XItjIa6IBtyBT6gJWKh1L
         f2RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763485891; x=1764090691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=69iXRF+UJC1hs3xkkz0CKthrLlBOVoAMZk7s5v+Iu2k=;
        b=E6n0gt00RyDqNu+sgaUKJBYO43Q7mb5stHR7RsN3zqSfY78GuiYhi0tw5n4IytuXxd
         on38nELh17JUByr/PxsBvYPwvfVDoS1s9U+bWz+1Y2Xm2w6CK4obipiYzHleAzqQo2u/
         eGGKOXPHJtz6NcVj+48uFIv/YfqbMDI3hVjqlzPyj0PpykL96SfvKQ2fyvm5zjHPchSI
         wpS+IGL5YMcnH5h2yQuzhIvHKpVubAVEwinwlAr47KkqFu3hvYrm8Yra5CZEpX469nwF
         XFQFeuPNIsyVrvprCqnMnlG92gw4Q4jsighWExUEyr0J7OwtrGgcxQhCvqmMST5r1YA8
         uPFA==
X-Gm-Message-State: AOJu0Ywf57X+uNuyiXtYT8xjTi0IQic+igMt3ZSgo+p77g6vd28fhQkT
	C7c6CWWDLp/i3wxsMQY0NG5zDsbStdNGsBLPjC50At7i+rSSq2SqZLcN8NF25ICITxHUrQ==
X-Gm-Gg: ASbGncvpEuNJwu96vf1Gckd3e5wu/zVLwEfrBeXmmERTSMg/to8CAYCSkinxw1ICP3D
	HmAavKjO8frek3623o1GS9FBtiwS+ZBZEBGrK8aPOKjNeSlm3QSbqivhLNHsDV+9ETpeKzYQtnD
	oU1O/Gc0AVoM+Hva/WaGNOz0kV0j202liYMOqUKVRIMFHuXgiyCm/p2fiMpg4h+zR5nvkleVUy1
	Pnscd1JXSu3Bj6xvT+7d0GfdrBgRyl0O7akyqzZncMN4CMmDxLqtFjdTgGdugmxYxwBpfax9vZx
	uZmUgBlv6mTF2J6yEbWLwpmwvNmTZYbv+pVudCGpS+gS6OpEPHQ1429A3TfoVjcdO8T1hVlQ4bi
	U2FtLdd9XcksYUYLxEWg0R93tQYfHPg3ROZ+NxxOLHCQRwsEyf9V99d26CCt5M/kYHuS4qrtfQl
	X31ce/BtWdUyjHQzuf9SQ/93iqVWfKvOGKFM4wdY+KEBBMsWPhMrUemH6enqRo9C+lMS0hfN/NG
	bPIHI/wG3BnKVWdfePQoEGyNVfm0PUys88qEoVhYvI=
X-Google-Smtp-Source: AGHT+IFe10O1HbN8XBISm2rDJQYB2sWUAALs7N+f2tKf49wh6KXWZD3EXSl0Z/nwQeJNMFeLXzIjZQ==
X-Received: by 2002:a05:600c:a04:b0:477:63db:c718 with SMTP id 5b1f17b1804b1-4778fe5dccdmr193648735e9.16.1763485891125;
        Tue, 18 Nov 2025 09:11:31 -0800 (PST)
Received: from ip-10-0-150-200.eu-west-1.compute.internal (ec2-52-49-196-232.eu-west-1.compute.amazonaws.com. [52.49.196.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b103d312sm706385e9.13.2025.11.18.09.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 09:11:30 -0800 (PST)
From: griffoul@gmail.com
X-Google-Original-From: griffoul@gmail.org
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	vkuznets@redhat.com,
	shuah@kernel.org,
	dwmw@amazon.co.uk,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fred Griffoul <fgriffo@amazon.co.uk>
Subject: [PATCH v2 08/10] KVM: x86: Add nested context management
Date: Tue, 18 Nov 2025 17:11:11 +0000
Message-ID: <20251118171113.363528-9-griffoul@gmail.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251118171113.363528-1-griffoul@gmail.org>
References: <20251118171113.363528-1-griffoul@gmail.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fred Griffoul <fgriffo@amazon.co.uk>

Add infrastructure to persist nested virtualization state when L2 vCPUs
are switched on an L1 vCPU or migrated between L1 vCPUs.

The nested context table uses a hash table for fast lookup by nested
control block GPA (VMPTR for VMX, VMCB for SVM) and maintains a free
list for context management.

The kvm_nested_context_load() function searches for a context indexed by
the target GPA; if not found, it allocates a new context up to the
configured maximum. If at capacity, it recycles the oldest context from
the free list.

The oversubscription is hardcoded to support up to 8 L2 vCPUs per L1
vCPU.

The kvm_nested_context_clear() function moves the context to the free
list while keeping it in the hash table for potential reuse.

This allows nested hypervisors to multiplex multiple L2 vCPUs on L1
vCPUs without losing cached nested state, significantly improving
performance for workloads with frequent L2 context switches.

This patch adds the basic infrastructure. Subsequent patches will add
the nested VMX and SVM specific support to populate and utilize the
cached nested state.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  31 +++++
 arch/x86/include/uapi/asm/kvm.h |   2 +
 arch/x86/kvm/Makefile           |   2 +-
 arch/x86/kvm/nested.c           | 199 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |   5 +-
 5 files changed, 237 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/kvm/nested.c

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4675e71b33a7..75f3cd82a073 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1379,6 +1379,28 @@ enum kvm_mmu_type {
 	KVM_NR_MMU_TYPES,
 };
 
+struct kvm_nested_context {
+	gpa_t gpa;
+	struct hlist_node hnode;
+	struct list_head lru_link;
+	struct kvm_vcpu *vcpu;
+};
+
+struct kvm_nested_context_table {
+	spinlock_t lock;
+	u32 count;
+	struct list_head lru_list;
+	DECLARE_HASHTABLE(hash, 8);
+};
+
+void kvm_nested_context_clear(struct kvm_vcpu *vcpu, gpa_t gpa);
+struct kvm_nested_context *kvm_nested_context_load(
+		struct kvm_vcpu *vcpu,
+		gpa_t gpa);
+
+int kvm_nested_context_table_init(struct kvm *kvm);
+void kvm_nested_context_table_destroy(struct kvm *kvm);
+
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
 	unsigned long n_requested_mmu_pages;
@@ -1618,6 +1640,9 @@ struct kvm_arch {
 	 * current VM.
 	 */
 	int cpu_dirty_log_size;
+
+	/* Cache for nested contexts */
+	struct kvm_nested_context_table *nested_context_table;
 };
 
 struct kvm_vm_stat {
@@ -1640,6 +1665,8 @@ struct kvm_vm_stat {
 	u64 nx_lpage_splits;
 	u64 max_mmu_page_hash_collisions;
 	u64 max_mmu_rmap_size;
+	u64 nested_context_recycle;
+	u64 nested_context_reuse;
 };
 
 struct kvm_vcpu_stat {
@@ -1967,6 +1994,10 @@ struct kvm_x86_nested_ops {
 			    uint16_t *vmcs_version);
 	uint16_t (*get_evmcs_version)(struct kvm_vcpu *vcpu);
 	void (*hv_inject_synthetic_vmexit_post_tlb_flush)(struct kvm_vcpu *vcpu);
+
+	struct kvm_nested_context *(*alloc_context)(struct kvm_vcpu *vcpu);
+	void (*free_context)(struct kvm_nested_context *ctx);
+	void (*reset_context)(struct kvm_nested_context *ctx);
 };
 
 struct kvm_x86_init_ops {
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index d420c9c066d4..637ed9286f8e 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -1042,4 +1042,6 @@ struct kvm_tdx_init_mem_region {
 	__u64 nr_pages;
 };
 
+#define KVM_NESTED_OVERSUB_RATIO 8
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index c4b8950c7abe..2a5289cb5bd1 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -6,7 +6,7 @@ ccflags-$(CONFIG_KVM_WERROR) += -Werror
 include $(srctree)/virt/kvm/Makefile.kvm
 
 kvm-y			+= x86.o emulate.o irq.o lapic.o cpuid.o pmu.o mtrr.o \
-			   debugfs.o mmu/mmu.o mmu/page_track.o mmu/spte.o
+			   debugfs.o nested.o mmu/mmu.o mmu/page_track.o mmu/spte.o
 
 kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
 kvm-$(CONFIG_KVM_IOAPIC) += i8259.o i8254.o ioapic.o
diff --git a/arch/x86/kvm/nested.c b/arch/x86/kvm/nested.c
new file mode 100644
index 000000000000..6e4e95567427
--- /dev/null
+++ b/arch/x86/kvm/nested.c
@@ -0,0 +1,199 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kvm_host.h>
+
+static struct kvm_nested_context_table *kvm_nested_context_table_alloc(void)
+{
+	struct kvm_nested_context_table *table;
+
+	table = kzalloc(sizeof(*table), GFP_KERNEL_ACCOUNT);
+	if (!table)
+		return NULL;
+
+	spin_lock_init(&table->lock);
+	INIT_LIST_HEAD(&table->lru_list);
+	hash_init(table->hash);
+	return table;
+}
+
+static void kvm_nested_context_table_free(struct kvm_nested_context_table
+					  *table)
+{
+	kfree(table);
+}
+
+int kvm_nested_context_table_init(struct kvm *kvm)
+{
+	struct kvm_nested_context_table *table;
+
+	if (!kvm_x86_ops.nested_ops->alloc_context ||
+	    !kvm_x86_ops.nested_ops->free_context ||
+	    !kvm_x86_ops.nested_ops->reset_context)
+		return -EINVAL;
+
+	table = kvm_nested_context_table_alloc();
+	if (!table)
+		return -ENOMEM;
+
+	kvm->arch.nested_context_table = table;
+	return 0;
+}
+
+void kvm_nested_context_table_destroy(struct kvm *kvm)
+{
+	struct kvm_nested_context_table *table;
+	struct kvm_nested_context *ctx;
+	struct hlist_node *tmp;
+	int bkt;
+
+	table = kvm->arch.nested_context_table;
+	if (!table)
+		return;
+
+	hash_for_each_safe(table->hash, bkt, tmp, ctx, hnode) {
+		hash_del(&ctx->hnode);
+		kvm_x86_ops.nested_ops->free_context(ctx);
+	}
+
+	kvm_nested_context_table_free(table);
+}
+
+static unsigned int kvm_nested_context_max(struct kvm *kvm)
+{
+	return KVM_NESTED_OVERSUB_RATIO * atomic_read(&kvm->online_vcpus);
+}
+
+static struct kvm_nested_context *__kvm_nested_context_find(struct kvm_nested_context_table
+							    *table, gpa_t gpa)
+{
+	struct kvm_nested_context *ctx;
+
+	hash_for_each_possible(table->hash, ctx, hnode, gpa) {
+		if (ctx->gpa == gpa)
+			return ctx;
+	}
+
+	return NULL;
+}
+
+static struct kvm_nested_context *kvm_nested_context_find(struct
+							  kvm_nested_context_table
+							  *table,
+							  struct kvm_vcpu *vcpu,
+							  gpa_t gpa)
+{
+	struct kvm_nested_context *ctx;
+
+	ctx = __kvm_nested_context_find(table, gpa);
+	if (!ctx)
+		return NULL;
+
+	WARN_ON_ONCE(ctx->vcpu && ctx->vcpu != vcpu);
+
+	/* Remove from the LRU list if not attached to a vcpu */
+	if (!ctx->vcpu)
+		list_del(&ctx->lru_link);
+
+	return ctx;
+}
+
+static struct kvm_nested_context *kvm_nested_context_recycle(struct
+							     kvm_nested_context_table
+							     *table)
+{
+	struct kvm_nested_context *ctx;
+
+	if (list_empty(&table->lru_list))
+		return NULL;
+
+	ctx =
+	    list_first_entry(&table->lru_list, struct kvm_nested_context,
+			     lru_link);
+	list_del(&ctx->lru_link);
+	hash_del(&ctx->hnode);
+	return ctx;
+}
+
+static void kvm_nested_context_insert(struct kvm_nested_context_table *table,
+				      struct kvm_nested_context *ctx, gpa_t gpa)
+{
+	hash_add(table->hash, &ctx->hnode, gpa);
+	ctx->gpa = gpa;
+}
+
+struct kvm_nested_context *kvm_nested_context_load(struct kvm_vcpu *vcpu,
+						   gpa_t gpa)
+{
+	struct kvm_nested_context_table *table;
+	struct kvm_nested_context *ctx, *new_ctx = NULL;
+	struct kvm *vm = vcpu->kvm;
+	bool reset = false;
+
+	table = vcpu->kvm->arch.nested_context_table;
+	if (WARN_ON_ONCE(!table))
+		return false;
+retry:
+	spin_lock(&table->lock);
+	ctx = kvm_nested_context_find(table, vcpu, gpa);
+	if (!ctx) {
+		/* At capacity? Recycle the LRU context */
+		if (table->count >= kvm_nested_context_max(vcpu->kvm)) {
+			ctx = kvm_nested_context_recycle(table);
+			if (unlikely(!ctx))
+				goto finish;
+
+			kvm_nested_context_insert(table, ctx, gpa);
+			++vm->stat.nested_context_recycle;
+			reset = true;
+
+		} else if (new_ctx) {
+			++table->count;
+			ctx = new_ctx;
+			kvm_nested_context_insert(table, ctx, gpa);
+			new_ctx = NULL;
+
+		} else {
+			/* Allocate a new context without holding the lock */
+			spin_unlock(&table->lock);
+			new_ctx = kvm_x86_ops.nested_ops->alloc_context(vcpu);
+			if (unlikely(!new_ctx))
+				return NULL;
+
+			goto retry;
+		}
+	} else
+		++vm->stat.nested_context_reuse;
+
+	ctx->vcpu = vcpu;
+finish:
+	spin_unlock(&table->lock);
+
+	if (new_ctx)
+		kvm_x86_ops.nested_ops->free_context(new_ctx);
+
+	if (reset)
+		kvm_x86_ops.nested_ops->reset_context(ctx);
+
+	return ctx;
+}
+
+void kvm_nested_context_clear(struct kvm_vcpu *vcpu, gpa_t gpa)
+{
+	struct kvm_nested_context_table *table;
+	struct kvm_nested_context *ctx;
+
+	table = vcpu->kvm->arch.nested_context_table;
+	if (WARN_ON_ONCE(!table))
+		return;
+
+	spin_lock(&table->lock);
+	ctx = __kvm_nested_context_find(table, gpa);
+	if (ctx && ctx->vcpu) {
+		/*
+		 * Move to LRU list but keep it in the hash table for possible future
+		 * reuse.
+		 */
+		list_add_tail(&ctx->lru_link, &table->lru_list);
+		ctx->vcpu = NULL;
+	}
+	spin_unlock(&table->lock);
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1a9c1171df49..db13b1921aff 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -255,7 +255,9 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_ICOUNTER(VM, pages_1g),
 	STATS_DESC_ICOUNTER(VM, nx_lpage_splits),
 	STATS_DESC_PCOUNTER(VM, max_mmu_rmap_size),
-	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions)
+	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions),
+	STATS_DESC_COUNTER(VM, nested_context_recycle),
+	STATS_DESC_COUNTER(VM, nested_context_reuse)
 };
 
 const struct kvm_stats_header kvm_vm_stats_header = {
@@ -13311,6 +13313,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_page_track_cleanup(kvm);
 	kvm_xen_destroy_vm(kvm);
 	kvm_hv_destroy_vm(kvm);
+	kvm_nested_context_table_destroy(kvm);
 	kvm_x86_call(vm_destroy)(kvm);
 }
 
-- 
2.43.0


