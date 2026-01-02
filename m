Return-Path: <kvm+bounces-66938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F638CEEC24
	for <lists+kvm@lfdr.de>; Fri, 02 Jan 2026 15:29:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 214903027A6B
	for <lists+kvm@lfdr.de>; Fri,  2 Jan 2026 14:25:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F8252EDD7E;
	Fri,  2 Jan 2026 14:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KTo4m9Jz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0C03128D8
	for <kvm@vger.kernel.org>; Fri,  2 Jan 2026 14:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767363891; cv=none; b=PAMAjwGC9X98mf86uMCvYvYaLHg+4MFI7cLCCsS/ZDZLOcy1Hk8bVsPOToEeO8owSlgOwvWXB/LbB5QVca9iS5Uk2W61RYxbZ3wQGnuzEAgP+j9q3sQvPmXGrhO9lGZhLlWODhzEOSwK9GglvlQMxUa2yKowY4wSQ2e4zBfpmsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767363891; c=relaxed/simple;
	bh=i5Gkck+T4vEsec3YZqZ9GfnW3xyFRPHL8iqEXxEE554=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTnnzzjZG5WiBqsQyU0tWfxMNYmu1r0nNg7YTcFkHRFH0sYA+OQDjxSsxH2eaHO5ckbn2d/EbDFPZepIGmhUitg4q5B+7jl5FW7Y9iWuS7SO/yvD+9CVZ/letG650+MDmw6lQoi5tVlu9qTF3IELKoIxhpxFJ1XuDEDmQ7027n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KTo4m9Jz; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso115232355e9.3
        for <kvm@vger.kernel.org>; Fri, 02 Jan 2026 06:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767363886; x=1767968686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ksAHoz4VRcwLYvgsvjvpNNjYc97wIiL/qsWKR4MCnOk=;
        b=KTo4m9JzrQUJMiMlywpsWIzjXe5y2MyqIhC5OWzjO6Mxyg9vmQXnaqnq06dJ4ph860
         jov3FGIvQIbTsO1F3xGnrM7uLF/voZP8s8rc31SmQi3DXTPiGwm8t/k1dTtSctelxVpv
         rDsmmwr4met7bD1j095lsIWvqyfQrj4UIPffyqGme2VRIjCALfCn7z8PL9RZqOxKMd1K
         dhFSv4BZZPvdaKkxLicLmG7e2VJOt3rjtoG9p5/yefocBr/bVRGyb8wzSI7S+ZiA6oiS
         eVMy7cGsnyd9OYmlx2WKAMs0gDz+/hb+6LQfA8aj3N2Bx2Z5AdYHYWA9jJU7fOm0KTTB
         mttg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767363886; x=1767968686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ksAHoz4VRcwLYvgsvjvpNNjYc97wIiL/qsWKR4MCnOk=;
        b=IlmMKcarqq5RkdZV0Y5ZikoTp4/A2EgSFLHdICNeMwRVs4bZM6zecru1gZ6h4AUggq
         zP/YFjNcQnwgs4hhxPnw9s/xXIs9KWNpR8E5tye+QaL2OmZRETyh3MKMugnlJNSU3dgk
         RVsaShKzc00STF/oOZNn+hcIX89Uybumx/ZcL0PdBsUU3QQjfKRI9FUo8pvsyp/3nLZn
         WkWqFzwqMgWQap9hsx3cXmmHcJAvmZAMq5yxFUIBQotGjOIaXe0HXcOLTT73ZWB2Gc5G
         SnnRdLSYtPyjr4wIxrzvKw7JajJ8zgfViC0E4zIexN/GCxbS5obMPoRDbyXMfFIWpINM
         Q9JQ==
X-Gm-Message-State: AOJu0YxVMOIyupXRbZwzlYr7MF7yZwNhx0o1xe1BF7l3FnmEXl6N9FU5
	krSn5l5Dn/B2W4kbGl4eEScDY92rpZUQmXt2pJtVsgoFhAFwOOoNRJuYO8qSulGoQAM=
X-Gm-Gg: AY/fxX6DyaEM//6s2nTpyiJOvAk/p886Nl5cAswhpdXqg+hLt8cE4AF916xsXmzM1Ry
	HrYWOWn6JpGDW/jUuI2T5MAzmQkZZvr6iZ+fPnb8MPuqz2EQ/5kKIe8pP401HrYJ/80mkkFQldc
	FDM/Oql9iFby9IDpsRBhQc11bX1FSEkRYZbqfvM9kwBI/jWE7AviOOIMd27CkIVUHD+jVTPHqma
	Jb7437MMXbchwtCAwD1bORrXlQVdRnxlIKn+HhNwBfsSbnIIqlKvbeCiAs1G/6JdM73xrRY9ZT6
	ZqY2Qxf9C5bHjwRhyoroH6nh88JhYyzB0w1IHEMrRDFf1xr+xDYopU9w2/llCH0r5Xkdke+RsVD
	3y/i3A1wNh/+VeWcWXlN+ZH/aujQHkR+5ZVZUF1Hgnb/A0UL+5LqDZ6yWJnqIY71ZeMcaHaV67l
	otpdnp18Rv73IP1imPnObhhMye+oO/5+zKDTr1HNlwXG9P6AXuJ81zqzWJ7vG6ddk2hOz9jigD4
	EIp40sqlx2SpVaITiBJF8qSSZLw9vVD
X-Google-Smtp-Source: AGHT+IFnP8x4t7nk5LISqY1DnnH4/ON4U4WEURK37JteQYnnOc95DuJv9yKDOdRn9+o1IWqoF9+cyg==
X-Received: by 2002:a05:600c:190f:b0:475:dd89:acb with SMTP id 5b1f17b1804b1-47d195a72fbmr514761835e9.22.1767363885980;
        Fri, 02 Jan 2026 06:24:45 -0800 (PST)
Received: from ip-10-0-150-200.eu-west-1.compute.internal (ec2-52-49-196-232.eu-west-1.compute.amazonaws.com. [52.49.196.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be27b0d5asm806409235e9.13.2026.01.02.06.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jan 2026 06:24:45 -0800 (PST)
From: Fred Griffoul <griffoul@gmail.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	vkuznets@redhat.com,
	shuah@kernel.org,
	dwmw@amazon.co.uk,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fred Griffoul <fgriffo@amazon.co.uk>
Subject: [PATCH v4 08/10] KVM: x86: Add nested context management
Date: Fri,  2 Jan 2026 14:24:27 +0000
Message-ID: <20260102142429.896101-9-griffoul@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260102142429.896101-1-griffoul@gmail.com>
References: <20260102142429.896101-1-griffoul@gmail.com>
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
index c9a1a43fbfde..ab31885f0e99 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1376,6 +1376,28 @@ enum kvm_mmu_type {
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
@@ -1613,6 +1635,9 @@ struct kvm_arch {
 	 * current VM.
 	 */
 	int cpu_dirty_log_size;
+
+	/* Cache for nested contexts */
+	struct kvm_nested_context_table *nested_context_table;
 };
 
 struct kvm_vm_stat {
@@ -1635,6 +1660,8 @@ struct kvm_vm_stat {
 	u64 nx_lpage_splits;
 	u64 max_mmu_page_hash_collisions;
 	u64 max_mmu_rmap_size;
+	u64 nested_context_recycle;
+	u64 nested_context_reuse;
 };
 
 struct kvm_vcpu_stat {
@@ -1963,6 +1990,10 @@ struct kvm_x86_nested_ops {
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
index 7ceff6583652..8625aa861132 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -1043,4 +1043,6 @@ struct kvm_tdx_init_mem_region {
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
index 000000000000..986820cb525f
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
+		return NULL;
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
index d830770363ab..8128b82856ae 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -251,7 +251,9 @@ const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	STATS_DESC_ICOUNTER(VM, pages_1g),
 	STATS_DESC_ICOUNTER(VM, nx_lpage_splits),
 	STATS_DESC_PCOUNTER(VM, max_mmu_rmap_size),
-	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions)
+	STATS_DESC_PCOUNTER(VM, max_mmu_page_hash_collisions),
+	STATS_DESC_COUNTER(VM, nested_context_recycle),
+	STATS_DESC_COUNTER(VM, nested_context_reuse)
 };
 
 const struct kvm_stats_header kvm_vm_stats_header = {
@@ -13350,6 +13352,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_page_track_cleanup(kvm);
 	kvm_xen_destroy_vm(kvm);
 	kvm_hv_destroy_vm(kvm);
+	kvm_nested_context_table_destroy(kvm);
 	kvm_x86_call(vm_destroy)(kvm);
 }
 
-- 
2.43.0


