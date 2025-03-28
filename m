Return-Path: <kvm+bounces-42179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A4B0A74DD4
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 16:32:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88A4818928B2
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 15:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 277E51D8DF6;
	Fri, 28 Mar 2025 15:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LLcPt3No"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DBE14A627
	for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 15:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743175906; cv=none; b=Cn7BQS4axwksn2m8y4UrLh0QO9xTBDpxlU6ny/KCXuELbkasE/gQm6LLpBSVhluJeGTczry/KFIa0r+720PoRx6kpZsTQU5PM5eZcqaNn5wOBX98ES4g+AcFX4/RYpOx6L7TxeNVBHY90Y8U9NABPbvFMA/NID5h/2tldlsaFoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743175906; c=relaxed/simple;
	bh=U0ho/tm3JZHvTmCYzNDcZ1cG6BRZ9f/32jVstYt0n00=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ErcbCtNHSQo9zCTft/dYghEXhdlmLb6ADj0hmH93Yt67uIHS24YHrx7uZUWMc6VAkw26EuZfFxfJs8hZnaXyVFvxwQfF0AwPpx0hEpPALGYFfKkTwNSr2p2LpDxNvRG134zd0EDG8WuaNOOEJTFhDm4Yd1+yHpXsaCIcI037qU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LLcPt3No; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43d0a037f97so13376385e9.2
        for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 08:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743175903; x=1743780703; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DQKphsCXTEhqFMrf3VWaTcY0QsviPAOOuZY+cq7cn/w=;
        b=LLcPt3NocbXgLC74n1qPKI5W1E6Dpbg0Lb1GJPu2OnI/RiXhWzAydGO4jh70ymc5aD
         B6Uoe/IKFZ3rAKcwaavU7dX4PcaCRHvVgOdiseYjGUio/yImrjO0xytdp6OVXcQTHoOk
         JW4gFtrJIGPMEtQkuly7HyF0vzt7xFAgXFv7pdhf+t0qnVLucytvp35XqcvAtZiZkiiY
         hQNSVq49c4OW8wIxNCoHA0HkvE2VQMiKB/GBELsNs6kVTc1UlwhhyIOjYC36jZ3dDQLD
         6P/EUMGQH7kYAEGg0IqKZqXcwdlBonc8cV8oIp0AqhGDKJB8LRtJBI6xgMr5Av9rmsFC
         S2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743175903; x=1743780703;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DQKphsCXTEhqFMrf3VWaTcY0QsviPAOOuZY+cq7cn/w=;
        b=T22KqSdzhixT85+J3C/dDO8GsynjUSSS9lDBgJuWinhbFCEbCf1reDr6rZl3XpG1t3
         h6WsJsXEQjze4RVowx1tvo8FrVMJsXUKvdb+QfvvHJodUl6u6R5CT+5u5XGLd+SoYVko
         Ky4j8+/szxk7X9/DflnHVMostqIIuKxrOjm5GWDE41/TeZVceqFPQkPSJQW8vhKnUpue
         l9kWa4AlVkM1FdXciGNNeSthnut0lemOv05u+A0tc1Ccxieqr5RMtGaDbnAioAHrp+ms
         EzT3epTtWYMlrOnaG4U7SsTwnX7Y0ujzTVO8i82wpjPLFPdipQ5jBeqI/7AESg64KRVh
         utnQ==
X-Gm-Message-State: AOJu0Yw4BQ7e5Y0FARYmZBCQWvgdIimCaNEOljZzSizKbgPO7B38dJYh
	GiAEqpm3UqyzWVg7rs4NK20oICNVYx5Rb/IveqpY1TjnxQYwFddsR0PEImCbOd06GOZc65WcLq+
	igt6ePROLgx8i3e2XkXaeJrWyyChG9zTXzl/vKJ/vMpVg8pLPFCn1MU+0WAx6ZAp2nSp7RB6Mia
	zon8NoArvc9pFG8v2Y1WLA/+w=
X-Google-Smtp-Source: AGHT+IFeKUD228KCyiAqE0V133tP1161pUOyLkFtpOrh/x3TzNM0KdnO1/NnMHDp+Bj1LbLVaO4D8TJEbg==
X-Received: from wmbg10.prod.google.com ([2002:a05:600c:a40a:b0:43d:4d65:23e1])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:548a:b0:43c:f332:703a
 with SMTP id 5b1f17b1804b1-43d87508dd1mr76169855e9.31.1743175902548; Fri, 28
 Mar 2025 08:31:42 -0700 (PDT)
Date: Fri, 28 Mar 2025 15:31:30 +0000
In-Reply-To: <20250328153133.3504118-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250328153133.3504118-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250328153133.3504118-5-tabba@google.com>
Subject: [PATCH v7 4/7] KVM: guest_memfd: Folio sharing states and functions
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
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	tabba@google.com
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
 virt/kvm/guest_memfd.c   | 208 ++++++++++++++++++++++++++++++++++++---
 virt/kvm/kvm_main.c      |  62 ++++++++++++
 3 files changed, 295 insertions(+), 14 deletions(-)

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
index cde16ed3b230..3b4d724084a8 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -29,14 +29,6 @@ static struct kvm_gmem_inode_private *kvm_gmem_private(struct inode *inode)
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
@@ -389,22 +381,211 @@ static void kvm_gmem_init_mount(void)
 }
 
 #ifdef CONFIG_KVM_GMEM_SHARED_MEM
-static bool kvm_gmem_offset_is_shared(struct file *file, pgoff_t index)
+/*
+ * An enum of the valid folio sharing states:
+ * Bit 0: set if not shared with the guest (guest cannot fault it in)
+ * Bit 1: set if not shared with the host (host cannot fault it in)
+ */
+enum folio_shareability {
+	KVM_GMEM_ALL_SHARED	= 0b00,	/* Shared with the host and the guest. */
+	KVM_GMEM_GUEST_SHARED	= 0b10, /* Shared only with the guest. */
+	KVM_GMEM_NONE_SHARED	= 0b11, /* Not shared, transient state. */
+};
+
+static int kvm_gmem_offset_set_shared(struct inode *inode, pgoff_t index)
 {
-	struct kvm_gmem *gmem = file->private_data;
+	struct xarray *shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
+	rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
+	void *xval = xa_mk_value(KVM_GMEM_ALL_SHARED);
+
+	lockdep_assert_held_write(offsets_lock);
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
+	rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
+	pgoff_t i;
+	int r = 0;
+
+	write_lock(offsets_lock);
+	for (i = start; i < end; i++) {
+		r = kvm_gmem_offset_set_shared(inode, i);
+		if (WARN_ON_ONCE(r))
+			break;
+	}
+	write_unlock(offsets_lock);
+
+	return r;
+}
+
+static int kvm_gmem_offset_clear_shared(struct inode *inode, pgoff_t index)
+{
+	struct xarray *shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
+	rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
+	void *xval_guest = xa_mk_value(KVM_GMEM_GUEST_SHARED);
+	void *xval_none = xa_mk_value(KVM_GMEM_NONE_SHARED);
+	struct folio *folio;
+	int refcount;
+	int r;
+
+	lockdep_assert_held_write(offsets_lock);
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
+	rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
+	pgoff_t i;
+	int r = 0;
+
+	write_lock(offsets_lock);
+	for (i = start; i < end; i++) {
+		r = kvm_gmem_offset_clear_shared(inode, i);
+		if (WARN_ON_ONCE(r))
+			break;
+	}
+	write_unlock(offsets_lock);
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
+/*
+ * Returns true if the folio is shared with the host and the guest.
+ *
+ * Must be called with the offsets_lock lock held.
+ */
+static bool kvm_gmem_offset_is_shared(struct inode *inode, pgoff_t index)
+{
+	struct xarray *shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
+	rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
+	unsigned long r;
+
+	lockdep_assert_held(offsets_lock);
 
-	/* For now, VMs that support shared memory share all their memory. */
-	return kvm_arch_gmem_supports_shared_mem(gmem->kvm);
+	r = xa_to_value(xa_load(shared_offsets, index));
+
+	return r == KVM_GMEM_ALL_SHARED;
+}
+
+/*
+ * Returns true if the folio is shared with the guest (not transitioning).
+ *
+ * Must be called with the offsets_lock lock held.
+ */
+static bool kvm_gmem_offset_is_guest_shared(struct inode *inode, pgoff_t index)
+{
+	struct xarray *shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
+	rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
+	unsigned long r;
+
+	lockdep_assert_held(offsets_lock);
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
+	rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
+	unsigned long pgoff = slot->gmem.pgoff + gfn - slot->base_gfn;
+	bool r;
+
+	read_lock(offsets_lock);
+	r = kvm_gmem_offset_is_guest_shared(inode, pgoff);
+	read_unlock(offsets_lock);
+
+	return r;
 }
 
 static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
 {
 	struct inode *inode = file_inode(vmf->vma->vm_file);
+	rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
 	struct folio *folio;
 	vm_fault_t ret = VM_FAULT_LOCKED;
 
 	filemap_invalidate_lock_shared(inode->i_mapping);
+	read_lock(offsets_lock);
 
 	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
 	if (IS_ERR(folio)) {
@@ -423,7 +604,7 @@ static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
 		goto out_folio;
 	}
 
-	if (!kvm_gmem_offset_is_shared(vmf->vma->vm_file, vmf->pgoff)) {
+	if (!kvm_gmem_offset_is_shared(inode, vmf->pgoff)) {
 		ret = VM_FAULT_SIGBUS;
 		goto out_folio;
 	}
@@ -457,6 +638,7 @@ static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
 	}
 
 out_filemap:
+	read_unlock(offsets_lock);
 	filemap_invalidate_unlock_shared(inode->i_mapping);
 
 	return ret;
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
2.49.0.472.ge94155a9ec-goog


