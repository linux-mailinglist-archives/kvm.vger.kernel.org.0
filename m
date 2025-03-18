Return-Path: <kvm+bounces-41410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9878A6792B
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:23:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B79F617AA21
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:22:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84F14212D63;
	Tue, 18 Mar 2025 16:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iW45dRvt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F008212B35
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 16:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742314859; cv=none; b=hM0x0W/ftgLlyjJMGmn47W6ezf+nLvmCgcwReQjlGBksrPG5eSV8RnXn6mUFw7sn8AZsQ0xY+2FCstc53EOjMfSyQ6SdmL9unCCT1deARVSnTW/aYGJFg/QpMw+39SX3BxyHcd9iy60wPTFxKwuUYcWCwpYt5lkm8F5oQwZuhgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742314859; c=relaxed/simple;
	bh=JUU23I6tKOkKsBHRmuxqzsOtwT9UumaU5EtMA2UgMl4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WzYfV6dwkePRzm+347fSOkVrwJEdc6Hmebsph77ttrQD53kke6yP8D3AZF1VZw4M2wB5J2xfm9GoYvr3trRO1rjA7shS1rcBWieXvvjO8lVkcqLKGzlvMbq0hz7gBb9efxlK5jpOSYifdMyqjI62sqQGawMYyRZVVyDnQc+NPmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iW45dRvt; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43bd0586b86so19671145e9.3
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 09:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742314856; x=1742919656; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0uRqiA5y6bwZJswTBUBVpBBlKkERam5rlpE8w5/s9pQ=;
        b=iW45dRvtnYA2do8SlL+JYjNAiweGhhBkWOgiWNl/l0vY+DvxNw+r/XsEjtEeuU1ISl
         yp2xxH25HWsSkTdWLwgJrMLiustEatbyQ6lheczZSwJ7Dr01BSGwoqxPFLyHU+dXqGcd
         iRpa5J/bymrX9AMWXAPKkPUMQw2zENK24GVuXndJJg6ayjsbKX3JXDMp8+HopbDubU17
         hmZAuLjB4+An7PmcmaZo6MFfiXMzx3xzgcz+EfBqeZjIEpDCyemYooTI5dddq3OpdTpZ
         gcUbu1WzpD/07ONZ9dQq66osrpNLU43lY0Un/rzeY+0Xg2M0lyUyd8FtWYOmbgO8iF0t
         BolA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742314856; x=1742919656;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0uRqiA5y6bwZJswTBUBVpBBlKkERam5rlpE8w5/s9pQ=;
        b=himfgDwASMn3y7uraMcjI6i5iad5jlIQYqYN4xxp1zw86T5N1Zo2kjUKcn/2r/Jqpv
         /XmF2pSFlqYictPAn+Hw3cM8bYm0gvbLZ8E3E3vWC+ovQXujv+sF+bSznkUyUJacIMod
         bWkVM51KckR57AmuE6v6zMQ3jl9XfoFa/rX98tCaFNgmfIT0jUXr3YJVJ2SlA0oBFFCO
         RdU8L68te2wk0XhMGlcjTAoeU7M70qFIb6RlWhtl4iV7LFICJi2X+xrfvvr8gN2CPLol
         2HGeWWhxCXuxrjLPCebMSVoT497sWJllQUDK5B/+B6E7c7WB0zuEpDTDSS0Ex6gItWNF
         p8BQ==
X-Gm-Message-State: AOJu0Yx934q060bsvOgamXc6n/Ig8b8TUMxrKO0eAVDLXJmplxhM2mQ9
	r4Adv9jYAdmr+SD6BT7FDgK11ofSN/OlJPUU+SQcj9GncwfLlC7W5zSzJXn5GqqlUqZRhWp5sqN
	k2RpfHlGePtNZu8BhyxDozWO6f+2DAdiq1qtpaHYJl3MUQ2gQUKCrOfoQ2C9Vw2qdJ0JQJ59KOl
	mu09UaoAXpe4SQ4jPGPcqdr/g=
X-Google-Smtp-Source: AGHT+IGmIciTBdHZ96gCAdqnT6Aeuf4gTKWQU8tfq92iyygo3HUg48wgjEHxGX/Kbvi4hg2TcPjULeDUFw==
X-Received: from wmbfl10.prod.google.com ([2002:a05:600c:b8a:b0:43c:f122:1874])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3c9e:b0:43c:f4df:4870
 with SMTP id 5b1f17b1804b1-43d3ba06316mr23345235e9.25.1742314855816; Tue, 18
 Mar 2025 09:20:55 -0700 (PDT)
Date: Tue, 18 Mar 2025 16:20:43 +0000
In-Reply-To: <20250318162046.4016367-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318162046.4016367-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318162046.4016367-5-tabba@google.com>
Subject: [PATCH v6 4/7] KVM: guest_memfd: Folio sharing states and functions
 that manage their transition
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

To allow in-place sharing of guest_memfd folios with the host,
guest_memfd needs to track their sharing state, because mapping of
shared folios will only be allowed where it safe to access these folios.
It is safe to map and access these folios when explicitly shared with
the host, or potentially if not yet exposed to the guest (e.g., at
initialization).

This patch introduces sharing states for guest_memfd folios as well as
the functions that manage transitioning between those states.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h |  39 +++++++-
 virt/kvm/guest_memfd.c   | 188 ++++++++++++++++++++++++++++++++++++---
 virt/kvm/kvm_main.c      |  62 +++++++++++++
 3 files changed, 275 insertions(+), 14 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bc73d7426363..bf82faf16c53 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2600,7 +2600,44 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 #endif
 
 #ifdef CONFIG_KVM_GMEM_SHARED_MEM
+int kvm_gmem_set_shared(struct kvm *kvm, gfn_t start, gfn_t end);
+int kvm_gmem_clear_shared(struct kvm *kvm, gfn_t start, gfn_t end);
+int kvm_gmem_slot_set_shared(struct kvm_memory_slot *slot, gfn_t start,
+			     gfn_t end);
+int kvm_gmem_slot_clear_shared(struct kvm_memory_slot *slot, gfn_t start,
+			       gfn_t end);
+bool kvm_gmem_slot_is_guest_shared(struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_gmem_handle_folio_put(struct folio *folio);
-#endif
+#else
+static inline int kvm_gmem_set_shared(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+static inline int kvm_gmem_clear_shared(struct kvm *kvm, gfn_t start,
+					gfn_t end)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+static inline int kvm_gmem_slot_set_shared(struct kvm_memory_slot *slot,
+					   gfn_t start, gfn_t end)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+static inline int kvm_gmem_slot_clear_shared(struct kvm_memory_slot *slot,
+					     gfn_t start, gfn_t end)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+static inline bool kvm_gmem_slot_is_guest_shared(struct kvm_memory_slot *slot,
+						 gfn_t gfn)
+{
+	WARN_ON_ONCE(1);
+	return false;
+}
+#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
 
 #endif
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index a7f7c6eb6b4a..4b857ab421bf 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -28,14 +28,6 @@ static struct kvm_gmem_inode_private *kvm_gmem_private(struct inode *inode)
 	return inode->i_mapping->i_private_data;
 }
 
-#ifdef CONFIG_KVM_GMEM_SHARED_MEM
-void kvm_gmem_handle_folio_put(struct folio *folio)
-{
-	WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
-}
-EXPORT_SYMBOL_GPL(kvm_gmem_handle_folio_put);
-#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
-
 /**
  * folio_file_pfn - like folio_file_page, but return a pfn.
  * @folio: The folio which contains this index.
@@ -388,13 +380,183 @@ static void kvm_gmem_init_mount(void)
 }
 
 #ifdef CONFIG_KVM_GMEM_SHARED_MEM
-static bool kvm_gmem_offset_is_shared(struct file *file, pgoff_t index)
+/*
+ * An enum of the valid folio sharing states:
+ * Bit 0: set if not shared with the guest (guest cannot fault it in)
+ * Bit 1: set if not shared with the host (host cannot fault it in)
+ */
+enum folio_shareability {
+	KVM_GMEM_ALL_SHARED	= 0b00,	/* Shared with host and guest. */
+	KVM_GMEM_GUEST_SHARED	= 0b10, /* Shared only with guest. */
+	KVM_GMEM_NONE_SHARED	= 0b11, /* Not shared, transient state. */
+};
+
+static int kvm_gmem_offset_set_shared(struct inode *inode, pgoff_t index)
 {
-	struct kvm_gmem *gmem = file->private_data;
+	struct xarray *shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
+	void *xval = xa_mk_value(KVM_GMEM_ALL_SHARED);
+
+	rwsem_assert_held_write_nolockdep(&inode->i_mapping->invalidate_lock);
+
+	return xa_err(xa_store(shared_offsets, index, xval, GFP_KERNEL));
+}
+
+/*
+ * Marks the range [start, end) as shared with both the host and the guest.
+ * Called when guest shares memory with the host.
+ */
+static int kvm_gmem_offset_range_set_shared(struct inode *inode,
+					    pgoff_t start, pgoff_t end)
+{
+	pgoff_t i;
+	int r = 0;
+
+	filemap_invalidate_lock(inode->i_mapping);
+	for (i = start; i < end; i++) {
+		r = kvm_gmem_offset_set_shared(inode, i);
+		if (WARN_ON_ONCE(r))
+			break;
+	}
+	filemap_invalidate_unlock(inode->i_mapping);
+
+	return r;
+}
+
+static int kvm_gmem_offset_clear_shared(struct inode *inode, pgoff_t index)
+{
+	struct xarray *shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
+	void *xval_guest = xa_mk_value(KVM_GMEM_GUEST_SHARED);
+	void *xval_none = xa_mk_value(KVM_GMEM_NONE_SHARED);
+	struct folio *folio;
+	int refcount;
+	int r;
+
+	rwsem_assert_held_write_nolockdep(&inode->i_mapping->invalidate_lock);
+
+	folio = filemap_lock_folio(inode->i_mapping, index);
+	if (!IS_ERR(folio)) {
+		/* +1 references are expected because of filemap_lock_folio(). */
+		refcount = folio_nr_pages(folio) + 1;
+	} else {
+		r = PTR_ERR(folio);
+		if (WARN_ON_ONCE(r != -ENOENT))
+			return r;
+
+		folio = NULL;
+	}
+
+	if (!folio || folio_ref_freeze(folio, refcount)) {
+		/*
+		 * No outstanding references: transition to guest shared.
+		 */
+		r = xa_err(xa_store(shared_offsets, index, xval_guest, GFP_KERNEL));
+
+		if (folio)
+			folio_ref_unfreeze(folio, refcount);
+	} else {
+		/*
+		 * Outstanding references: the folio cannot be faulted in by
+		 * anyone until they're dropped.
+		 */
+		r = xa_err(xa_store(shared_offsets, index, xval_none, GFP_KERNEL));
+	}
+
+	if (folio) {
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
+	return r;
+}
+
+/*
+ * Marks the range [start, end) as not shared with the host. If the host doesn't
+ * have any references to a particular folio, then that folio is marked as
+ * shared with the guest.
+ *
+ * However, if the host still has references to the folio, then the folio is
+ * marked and not shared with anyone. Marking it as not shared allows draining
+ * all references from the host, and ensures that the hypervisor does not
+ * transition the folio to private, since the host still might access it.
+ *
+ * Called when guest unshares memory with the host.
+ */
+static int kvm_gmem_offset_range_clear_shared(struct inode *inode,
+					      pgoff_t start, pgoff_t end)
+{
+	pgoff_t i;
+	int r = 0;
+
+	filemap_invalidate_lock(inode->i_mapping);
+	for (i = start; i < end; i++) {
+		r = kvm_gmem_offset_clear_shared(inode, i);
+		if (WARN_ON_ONCE(r))
+			break;
+	}
+	filemap_invalidate_unlock(inode->i_mapping);
+
+	return r;
+}
+
+void kvm_gmem_handle_folio_put(struct folio *folio)
+{
+	WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_handle_folio_put);
+
+static bool kvm_gmem_offset_is_shared(struct inode *inode, pgoff_t index)
+{
+	struct xarray *shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
+	unsigned long r;
+
+	rwsem_assert_held_nolockdep(&inode->i_mapping->invalidate_lock);
+
+	r = xa_to_value(xa_load(shared_offsets, index));
+
+	return r == KVM_GMEM_ALL_SHARED;
+}
+
+static bool kvm_gmem_offset_is_guest_shared(struct inode *inode, pgoff_t index)
+{
+	struct xarray *shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
+	unsigned long r;
+
+	rwsem_assert_held_nolockdep(&inode->i_mapping->invalidate_lock);
+
+	r = xa_to_value(xa_load(shared_offsets, index));
+
+	return (r == KVM_GMEM_ALL_SHARED || r == KVM_GMEM_GUEST_SHARED);
+}
+
+int kvm_gmem_slot_set_shared(struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
+{
+	struct inode *inode = file_inode(READ_ONCE(slot->gmem.file));
+	pgoff_t start_off = slot->gmem.pgoff + start - slot->base_gfn;
+	pgoff_t end_off = start_off + end - start;
+
+	return kvm_gmem_offset_range_set_shared(inode, start_off, end_off);
+}
+
+int kvm_gmem_slot_clear_shared(struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
+{
+	struct inode *inode = file_inode(READ_ONCE(slot->gmem.file));
+	pgoff_t start_off = slot->gmem.pgoff + start - slot->base_gfn;
+	pgoff_t end_off = start_off + end - start;
+
+	return kvm_gmem_offset_range_clear_shared(inode, start_off, end_off);
+}
+
+bool kvm_gmem_slot_is_guest_shared(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	struct inode *inode = file_inode(READ_ONCE(slot->gmem.file));
+	unsigned long pgoff = slot->gmem.pgoff + gfn - slot->base_gfn;
+	bool r;
 
+	filemap_invalidate_lock_shared(inode->i_mapping);
+	r = kvm_gmem_offset_is_guest_shared(inode, pgoff);
+	filemap_invalidate_unlock_shared(inode->i_mapping);
 
-	/* For now, VMs that support shared memory share all their memory. */
-	return kvm_arch_gmem_supports_shared_mem(gmem->kvm);
+	return r;
 }
 
 static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
@@ -422,7 +584,7 @@ static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
 		goto out_folio;
 	}
 
-	if (!kvm_gmem_offset_is_shared(vmf->vma->vm_file, vmf->pgoff)) {
+	if (!kvm_gmem_offset_is_shared(inode, vmf->pgoff)) {
 		ret = VM_FAULT_SIGBUS;
 		goto out_folio;
 	}
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3e40acb9f5c0..90762252381c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3091,6 +3091,68 @@ static int next_segment(unsigned long len, int offset)
 		return len;
 }
 
+#ifdef CONFIG_KVM_GMEM_SHARED_MEM
+int kvm_gmem_set_shared(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	struct kvm_memslot_iter iter;
+	int r = 0;
+
+	mutex_lock(&kvm->slots_lock);
+
+	kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start, end) {
+		struct kvm_memory_slot *memslot = iter.slot;
+		gfn_t gfn_start, gfn_end;
+
+		if (!kvm_slot_can_be_private(memslot))
+			continue;
+
+		gfn_start = max(start, memslot->base_gfn);
+		gfn_end = min(end, memslot->base_gfn + memslot->npages);
+		if (WARN_ON_ONCE(start >= end))
+			continue;
+
+		r = kvm_gmem_slot_set_shared(memslot, gfn_start, gfn_end);
+		if (WARN_ON_ONCE(r))
+			break;
+	}
+
+	mutex_unlock(&kvm->slots_lock);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_set_shared);
+
+int kvm_gmem_clear_shared(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	struct kvm_memslot_iter iter;
+	int r = 0;
+
+	mutex_lock(&kvm->slots_lock);
+
+	kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start, end) {
+		struct kvm_memory_slot *memslot = iter.slot;
+		gfn_t gfn_start, gfn_end;
+
+		if (!kvm_slot_can_be_private(memslot))
+			continue;
+
+		gfn_start = max(start, memslot->base_gfn);
+		gfn_end = min(end, memslot->base_gfn + memslot->npages);
+		if (WARN_ON_ONCE(start >= end))
+			continue;
+
+		r = kvm_gmem_slot_clear_shared(memslot, gfn_start, gfn_end);
+		if (WARN_ON_ONCE(r))
+			break;
+	}
+
+	mutex_unlock(&kvm->slots_lock);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_clear_shared);
+#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
+
 /* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
 static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 				 void *data, int offset, int len)
-- 
2.49.0.rc1.451.g8f38331e32-goog


