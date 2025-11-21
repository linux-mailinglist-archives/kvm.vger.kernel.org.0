Return-Path: <kvm+bounces-64104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 17CD5C78B45
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 12:13:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8AD0236343C
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 11:13:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 314FB34A3D9;
	Fri, 21 Nov 2025 11:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hju2Hlra"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C39234BA4B
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 11:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763723501; cv=none; b=PeB8isEfJ/k/U10p7A0a+eDSB/jVbEvzWc6R1JgiWb0OJg96+xHuXE3vTdl55hoipVqCn3gJQgh+5jwxMTwYEMrACVCvTGndssdyN4VpKr+lzGeACgH+P+Pmmu1lvAa7axhsbJubCsoEwZaZT7XVUuDpbHRIdO9W04wGpfYjcU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763723501; c=relaxed/simple;
	bh=IuqcEOEbe0+RixX82HnLhcdMi0Mf/0K4mfVR0f073pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsMVwZgJJD8mHf9NJNbbJaokYQmbDmCSXJ6L1RTMSd/fAoEpKp/Bxicj11A4zJKB5qgUxUukft51uc0QsKyz4WbTF9XMbXepHX1lGV+arevczOZfHevMnbPqWIrMRl0Kd7guaBrmqbuh3I719h/J9LiHYgXkNRiY0Q85FTGBlP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hju2Hlra; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-42b2e9ac45aso1133006f8f.0
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 03:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763723495; x=1764328295; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UwlQx/OWwadt7gEx5Aj743IyAAkdjmoKIV+Gyuhnzno=;
        b=hju2HlraMTKxSAOEj+aejdFRCSCrnjPAb5+PNCWzEmHxEORtWGEg6qugUO+n4duIWa
         w33OGBh6w0s4EYPl4JuQbg9EWD9X3FpDvdzXdtVzLFMSwclpPZXKIGhY8Rltp5XBvGzC
         q3wy7sx9km3FpWLvGLRFwtQAYBxyUbqQigFBqU41p1YNOeBWaDNQhZstu9LP2onEsys8
         8jVlKnhJadzMXp48BQeZYdeRoU7QTjqtsdDQAPC1yBPY5N5XZO8xqm7DQglH4w03LQ44
         BLsfmtLyHEnbpqD7VfRipaJlbISsVcFpgvRF+QszkI/qF1R68gs46q60OiMWC09CGqQk
         HAUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763723495; x=1764328295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UwlQx/OWwadt7gEx5Aj743IyAAkdjmoKIV+Gyuhnzno=;
        b=EPQqfGfQsHP1UXBv3d6+a3JBYX0ukHLAir6fi+2lnU+GDK3FlxzazNGNN0zks8ryNR
         C8PLferzG4X0XEwYha7mt2ro0cT/LOeL86kt/+wpjkobkoImbBgPtyNs5UPXOGRQfhZx
         NhC1sg4wXV4zL8JhX+Tw+oaSAy5mwKM3bEqacRN165zJEd9/P/h4JKEd2Kbs4NZCraB5
         m36GRjn+rnImLLHhUvOOXybQfGnQVIODBRmWqIWZbxYUgVXMNKs2Mu5ZN12R3xfOyUxR
         EOUNsTeTF6bDwXOPXv0UIXhaeAPXmm7qsFEEouZK1E9UkUAgTUhsuJvEanpVQjdI/2Ui
         PI1A==
X-Gm-Message-State: AOJu0Yxfc19JjQqbLkO1P01NxTWMLhzOLg5ejctMiA8EX9/hQ45nlmkr
	BYsG+n2NY98bShG8Vuc8GRT200fuv0kh+3lTmS8P1zJ7uTWgjypG+sPg24RJhw2a4WXVxw==
X-Gm-Gg: ASbGncvXR++bIHOdBRCL/Cif8ne2L7MoZ3u/7RBl8tb5nxA1WDnX56BhCI295GOxHln
	u8O+BW6Yj/SIsZbOai4uPIdTONtmggrjsDm1sm7dAO1bw/JDojbxxNq1b2fe3HIcsIIHjMs/ocw
	gPMbUJo1wu+73r9zoOBDCwKiJZbGyWNvmFdfv94FX0ToFC+kUTNsbOXvYKq7tRI5ZSq8L7Y71+n
	PV8uJgDJOeHf3zlPq/A87vsuMFzBP/WISAbsXaWOFc2Uo4OmFCHW7IO5+vTNgShvCv21pAVi2wy
	0uGQEwUX9XhIkQ4088zS76eZ46TPFste3FDKH0WY9QA4DLyYh/cjPoxP34F3zhqkWeaQGZcsOxZ
	tSAfA7/agwHb/UrpaUWz/XMhutGnrRZ+PRvML8yDQUh35eZtjcJwViuiTs3/KhKogMDEwIrdd5C
	x7Vbq0UCnox9pDvcqPYqK3H6TMlywbt5fIOjhUIbCUGbm3f/KOJpnFJGeFK6g+mJ6Y8/c2j69Ve
	CO7dVceWevzw6fBTsLpK4gmRtjF1nMo
X-Google-Smtp-Source: AGHT+IHVJpc9/f8dm4MnHiPG8rhAYbdabzUczXwVfUZb1zuYY7xjGjgQXaM7mOC9X5Auu/VvvvBTgQ==
X-Received: by 2002:a05:6000:1789:b0:42b:40b5:e64c with SMTP id ffacd0b85a97d-42cc1d0c3bdmr1976326f8f.30.1763723494827;
        Fri, 21 Nov 2025 03:11:34 -0800 (PST)
Received: from ip-10-0-150-200.eu-west-1.compute.internal (ec2-52-49-196-232.eu-west-1.compute.amazonaws.com. [52.49.196.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7f363e4sm10484180f8f.12.2025.11.21.03.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 03:11:34 -0800 (PST)
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
Subject: [PATCH v3 08/10] KVM: x86: Add nested context management
Date: Fri, 21 Nov 2025 11:11:11 +0000
Message-ID: <20251121111113.456628-9-griffoul@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251121111113.456628-1-griffoul@gmail.com>
References: <20251121111113.456628-1-griffoul@gmail.com>
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


