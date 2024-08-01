Return-Path: <kvm+bounces-22901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BCB3194474E
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:01:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73063285E93
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDF1E170855;
	Thu,  1 Aug 2024 09:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hJ71OKUV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C82F16F29A
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 09:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722502888; cv=none; b=PiX7knBr4dPmzn3+M0radSLsr0MHIGsaFso0Ghb0/r8xGfnKb23gsgtqgm5dteec4+wVpjSOmqcGrlTBlH/ClaCN8uL6N2JtYB/+Dcdk6AH/Qx96jHDoXzI8Mffcly5h4Nml3LnFvHm/nDCe3mUm9q4n3fau03VQq8ZEhGc+oIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722502888; c=relaxed/simple;
	bh=7UlKYDzzEoWteaYTY1v3TroetnmwezP3ooLrZ6P40cw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KBSlqvkosMc5Ib5nvjPDNG082AwJ6BTdPJh4LK33ZEN3jeZk151Qb4ycr2vtn7ZeqjJVjT/Ki0wpfIzaqaju/wEX8E3Rw2ay/7E463jZgCWpTxWlr/NJ41SFSQ3xcmVsnRLsFfP1UoBQuSVTCSZSJ0DfhzmG35kPn+T0mEeB8is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hJ71OKUV; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-688777c95c4so3938327b3.1
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 02:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722502885; x=1723107685; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=31dOGsxSnS2qAkgpLgw/kAzkCwiCBaGMKDCBk/lWPaw=;
        b=hJ71OKUVAJxcNcW27aHrDTmsUOya2+03f2M5ICSAzZe/wO4YhNHmQdrbGbS5KQ4Jvj
         N5eMvRZTtufsoUNoCWUs+f0ZvIQGkSEKlkw0x5eXPrlkY0JkAnNUhmI7xc3VfLAxv03c
         OnSjxzLnTnJLLtlx4PCFDVW5OW1Ce7vUhuKXBgt97mkQ2ZFn/C/dFbUy4FPct8ZzCmJB
         lNIgD5Y2G+LzKjiAj1t+ASyIrOmoeJFoMdwc0sXn8nbkPfNXLTMuxOJUg9IMI6uEwr6Y
         py7WcclZt38Jg4zRfcGa2Ut1VIcujWKmVchFOCdK+OEJuswGcKnDgvKPGFm6VSwZBetE
         f4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722502885; x=1723107685;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=31dOGsxSnS2qAkgpLgw/kAzkCwiCBaGMKDCBk/lWPaw=;
        b=HVHqXuH+Rw6HjGqFW1gJ+osJIIJAx0h8m/P8BVE5wFBRUt7xe496Ivcl3H8HrlRsrJ
         WdczaNYuhYhw+YYkcfZ2SIg4+r5u6TqbflYiy71JX8S84ZxJC85+zrhg+hoDbbD7aVEu
         IRofJqmOIPOLUWD76o1K7tAWX7UT7B5BxLaDBkppnO4h1mqHg6kNy4hENQZY5OnvLC5n
         zeVjn/yXPaOhzQMCHfBqRoXJMClpyh3w7O7cb6H0+fDa8vzR/iA5UDHL8gNJootKwlP3
         wJ0hdjSXIVB4r7aIK2Jpbnt7weiACflVCoLZP3t/3pW7DZtFhBLKeMGCT0KUHOHtlspm
         Otrg==
X-Gm-Message-State: AOJu0YzHyqBGAnKAI+XhTBDTw51aeDqwOy57S5VyKot9lzVdv6de3NyR
	kmcy5JZ4Wp51kKyLeh+f5OmGiH1iMNPiLFNKz5sl/ks18pzBHrKtnKr+dywpVxVSkTLnm7haFDS
	yx4nR2WOrdQvcFg7pqGrxCM7hq277guFgvMLH2z5JU2o96YvdaZ7p+wjy9vduLQxS+YkDELU79+
	Mko6h4U5eG5l/YFwF9F5APqzw=
X-Google-Smtp-Source: AGHT+IFeMtDkO9X4o1H08sPbTOZyFDUmCP10xCQXIQm4WlBnMC+GIqYzlc/fnsdt6vCtEVOetfjohOJS0A==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:15:b0:64a:8aec:617c with SMTP id
 00721157ae682-6874580ff7emr1313617b3.0.1722502885098; Thu, 01 Aug 2024
 02:01:25 -0700 (PDT)
Date: Thu,  1 Aug 2024 10:01:09 +0100
In-Reply-To: <20240801090117.3841080-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801090117.3841080-1-tabba@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801090117.3841080-3-tabba@google.com>
Subject: [RFC PATCH v2 02/10] KVM: Add restricted support for mapping guestmem
 by the host
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Add support for mmap() and fault() for guest_memfd in the host.
The ability to fault in a guest page is contingent on that page
being shared with the host. To track this, this patch adds a new
xarray to each guest_memfd object, which tracks the mappability
of guest frames.

The guest_memfd PRIVATE memory attribute is not used for two
reasons. First because it reflects the userspace expectation for
that memory location, and therefore can be toggled by userspace.
The second is, although each guest_memfd file has a 1:1 binding
with a KVM instance, the plan is to allow multiple files per
inode, e.g. to allow intra-host migration to a new KVM instance,
without destroying guest_memfd.

This new feature is gated with a new configuration option,
CONFIG_KVM_PRIVATE_MEM_MAPPABLE.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h |  61 ++++++++++++++++++++
 virt/kvm/Kconfig         |   4 ++
 virt/kvm/guest_memfd.c   | 110 +++++++++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c      | 122 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 297 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 43a157f8171a..ab1344327e57 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2452,4 +2452,65 @@ static inline int kvm_gmem_get_pfn_locked(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
+#ifdef CONFIG_KVM_PRIVATE_MEM_MAPPABLE
+bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn, gfn_t end);
+bool kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end);
+int kvm_gmem_set_mappable(struct kvm *kvm, gfn_t start, gfn_t end);
+int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start, gfn_t end);
+int kvm_slot_gmem_toggle_mappable(struct kvm_memory_slot *slot, gfn_t start,
+				  gfn_t end, bool is_mappable);
+int kvm_slot_gmem_set_mappable(struct kvm_memory_slot *slot, gfn_t start,
+			       gfn_t end);
+int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot *slot, gfn_t start,
+				 gfn_t end);
+bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *slot, gfn_t gfn);
+#else
+static inline bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn, gfn_t end)
+{
+	WARN_ON_ONCE(1);
+	return false;
+}
+static inline bool kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	WARN_ON_ONCE(1);
+	return false;
+}
+static inline int kvm_gmem_set_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+static inline int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start,
+					  gfn_t end)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+static inline int kvm_slot_gmem_toggle_mappable(struct kvm_memory_slot *slot,
+						gfn_t start, gfn_t end,
+						bool is_mappable)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+static inline int kvm_slot_gmem_set_mappable(struct kvm_memory_slot *slot,
+					     gfn_t start, gfn_t end)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+static inline int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot *slot,
+					       gfn_t start, gfn_t end)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+static inline bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *slot,
+					     gfn_t gfn)
+{
+	WARN_ON_ONCE(1);
+	return false;
+}
+#endif /* CONFIG_KVM_PRIVATE_MEM_MAPPABLE */
+
 #endif
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 29b73eedfe74..a3970c5eca7b 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -109,3 +109,7 @@ config KVM_GENERIC_PRIVATE_MEM
        select KVM_GENERIC_MEMORY_ATTRIBUTES
        select KVM_PRIVATE_MEM
        bool
+
+config KVM_PRIVATE_MEM_MAPPABLE
+       select KVM_PRIVATE_MEM
+       bool
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index f3f4334a9ccb..0a1f266a16f9 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -11,6 +11,9 @@ struct kvm_gmem {
 	struct kvm *kvm;
 	struct xarray bindings;
 	struct list_head entry;
+#ifdef CONFIG_KVM_PRIVATE_MEM_MAPPABLE
+	struct xarray unmappable_gfns;
+#endif
 };
 
 static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
@@ -230,6 +233,11 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	mutex_unlock(&kvm->slots_lock);
 
 	xa_destroy(&gmem->bindings);
+
+#ifdef CONFIG_KVM_PRIVATE_MEM_MAPPABLE
+	xa_destroy(&gmem->unmappable_gfns);
+#endif
+
 	kfree(gmem);
 
 	kvm_put_kvm(kvm);
@@ -248,7 +256,105 @@ static inline struct file *kvm_gmem_get_file(struct kvm_memory_slot *slot)
 	return get_file_active(&slot->gmem.file);
 }
 
+#ifdef CONFIG_KVM_PRIVATE_MEM_MAPPABLE
+int kvm_slot_gmem_toggle_mappable(struct kvm_memory_slot *slot, gfn_t start,
+				  gfn_t end, bool is_mappable)
+{
+	struct kvm_gmem *gmem = slot->gmem.file->private_data;
+	void *xval = is_mappable ? NULL : xa_mk_value(true);
+	void *r;
+
+	r = xa_store_range(&gmem->unmappable_gfns, start, end - 1, xval, GFP_KERNEL);
+
+	return xa_err(r);
+}
+
+int kvm_slot_gmem_set_mappable(struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
+{
+	return kvm_slot_gmem_toggle_mappable(slot, start, end, true);
+}
+
+int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
+{
+	return kvm_slot_gmem_toggle_mappable(slot, start, end, false);
+}
+
+bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	struct kvm_gmem *gmem = slot->gmem.file->private_data;
+	unsigned long _gfn = gfn;
+
+	return !xa_find(&gmem->unmappable_gfns, &_gfn, ULONG_MAX, XA_PRESENT);
+}
+
+static bool kvm_gmem_isfaultable(struct vm_fault *vmf)
+{
+	struct kvm_gmem *gmem = vmf->vma->vm_file->private_data;
+	struct inode *inode = file_inode(vmf->vma->vm_file);
+	pgoff_t pgoff = vmf->pgoff;
+	struct kvm_memory_slot *slot;
+	unsigned long index;
+	bool r = true;
+
+	filemap_invalidate_lock(inode->i_mapping);
+
+	xa_for_each_range(&gmem->bindings, index, slot, pgoff, pgoff) {
+		pgoff_t base_gfn = slot->base_gfn;
+		pgoff_t gfn_pgoff = slot->gmem.pgoff;
+		pgoff_t gfn = base_gfn + max(gfn_pgoff, pgoff) - gfn_pgoff;
+
+		if (!kvm_slot_gmem_is_mappable(slot, gfn)) {
+			r = false;
+			break;
+		}
+	}
+
+	filemap_invalidate_unlock(inode->i_mapping);
+
+	return r;
+}
+
+static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
+{
+	struct folio *folio;
+
+	folio = kvm_gmem_get_folio(file_inode(vmf->vma->vm_file), vmf->pgoff);
+	if (!folio)
+		return VM_FAULT_SIGBUS;
+
+	if (!kvm_gmem_isfaultable(vmf)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		return VM_FAULT_SIGBUS;
+	}
+
+	vmf->page = folio_file_page(folio, vmf->pgoff);
+	return VM_FAULT_LOCKED;
+}
+
+static const struct vm_operations_struct kvm_gmem_vm_ops = {
+	.fault = kvm_gmem_fault,
+};
+
+static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
+	    (VM_SHARED | VM_MAYSHARE)) {
+		return -EINVAL;
+	}
+
+	file_accessed(file);
+	vm_flags_set(vma, VM_DONTDUMP);
+	vma->vm_ops = &kvm_gmem_vm_ops;
+
+	return 0;
+}
+#else
+#define kvm_gmem_mmap NULL
+#endif /* CONFIG_KVM_PRIVATE_MEM_MAPPABLE */
+
 static struct file_operations kvm_gmem_fops = {
+	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
 	.fallocate	= kvm_gmem_fallocate,
@@ -369,6 +475,10 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	xa_init(&gmem->bindings);
 	list_add(&gmem->entry, &inode->i_mapping->i_private_list);
 
+#ifdef CONFIG_KVM_PRIVATE_MEM_MAPPABLE
+	xa_init(&gmem->unmappable_gfns);
+#endif
+
 	fd_install(fd, file);
 	return fd;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1192942aef91..f4b4498d4de6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3265,6 +3265,128 @@ static int next_segment(unsigned long len, int offset)
 		return len;
 }
 
+#ifdef CONFIG_KVM_PRIVATE_MEM_MAPPABLE
+static bool __kvm_gmem_is_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	struct kvm_memslot_iter iter;
+
+	lockdep_assert_held(&kvm->slots_lock);
+
+	kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start, end) {
+		struct kvm_memory_slot *memslot = iter.slot;
+		gfn_t gfn_start, gfn_end, i;
+
+		gfn_start = max(start, memslot->base_gfn);
+		gfn_end = min(end, memslot->base_gfn + memslot->npages);
+		if (WARN_ON_ONCE(gfn_start >= gfn_end))
+			continue;
+
+		for (i = gfn_start; i < gfn_end; i++) {
+			if (!kvm_slot_gmem_is_mappable(memslot, i))
+				return false;
+		}
+	}
+
+	return true;
+}
+
+bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	bool r;
+
+	mutex_lock(&kvm->slots_lock);
+	r = __kvm_gmem_is_mappable(kvm, start, end);
+	mutex_unlock(&kvm->slots_lock);
+
+	return r;
+}
+
+static bool __kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	struct kvm_memslot_iter iter;
+
+	lockdep_assert_held(&kvm->slots_lock);
+
+	kvm_for_each_memslot_in_gfn_range(&iter, kvm_memslots(kvm), start, end) {
+		struct kvm_memory_slot *memslot = iter.slot;
+		gfn_t gfn_start, gfn_end, i;
+
+		gfn_start = max(start, memslot->base_gfn);
+		gfn_end = min(end, memslot->base_gfn + memslot->npages);
+		if (WARN_ON_ONCE(gfn_start >= gfn_end))
+			continue;
+
+		for (i = gfn_start; i < gfn_end; i++) {
+			struct page *page;
+			bool is_mapped;
+			kvm_pfn_t pfn;
+
+			if (WARN_ON_ONCE(kvm_gmem_get_pfn_locked(kvm, memslot, i, &pfn, NULL)))
+				continue;
+
+			page = pfn_to_page(pfn);
+			is_mapped = page_mapped(page) || page_maybe_dma_pinned(page);
+			unlock_page(page);
+			put_page(page);
+
+			if (is_mapped)
+				return true;
+		}
+	}
+
+	return false;
+}
+
+bool kvm_gmem_is_mapped(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	bool r;
+
+	mutex_lock(&kvm->slots_lock);
+	r = __kvm_gmem_is_mapped(kvm, start, end);
+	mutex_unlock(&kvm->slots_lock);
+
+	return r;
+}
+
+static int kvm_gmem_toggle_mappable(struct kvm *kvm, gfn_t start, gfn_t end,
+				    bool is_mappable)
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
+		gfn_start = max(start, memslot->base_gfn);
+		gfn_end = min(end, memslot->base_gfn + memslot->npages);
+		if (WARN_ON_ONCE(start >= end))
+			continue;
+
+		r = kvm_slot_gmem_toggle_mappable(memslot, gfn_start, gfn_end, is_mappable);
+		if (WARN_ON_ONCE(r))
+			break;
+	}
+
+	mutex_unlock(&kvm->slots_lock);
+
+	return r;
+}
+
+int kvm_gmem_set_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	return kvm_gmem_toggle_mappable(kvm, start, end, true);
+}
+
+int kvm_gmem_clear_mappable(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	return kvm_gmem_toggle_mappable(kvm, start, end, false);
+}
+
+#endif /* CONFIG_KVM_PRIVATE_MEM_MAPPABLE */
+
 /* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
 static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 				 void *data, int offset, int len)
-- 
2.46.0.rc1.232.g9752f9e123-goog


