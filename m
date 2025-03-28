Return-Path: <kvm+bounces-42180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8E0FA74DD3
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 16:32:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38DCB17B171
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 15:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE2371DA634;
	Fri, 28 Mar 2025 15:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2aYYOI0K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108FA1D88D7
	for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 15:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743175907; cv=none; b=mCwbgdhiBUdhOpJzhvmNIzx9UUr3txHpLj+KBsL28NnIE7SaVn3FsUrTuro2+8l0veHhA5FgvX0bzt/T3xn0/HR5uj7REN6wdWRwSaxd62cuFo10kSfE7nfvnLPFvOrf4w+kLbvnVHso0XeCEH0VB6YKbZkLH518uZgZFnLSuzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743175907; c=relaxed/simple;
	bh=FNZ5rbF/GwQ04BpQvSx2eGZdOReGNlh9r02eIimMdjs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=azpGcLXTw3qvJtewtksi3iMH/4nKGx9/n8J/Ji8rLs4QxsblVDieCdSgUrEoksb+JWgMV4aHcGvxhFg9McGdwOqkkBCsjMNmYnPEM5BPu6q3+/H+sN8bUqQG+Qhv/EeFIn8Y1H4KqeMyZp5F4Yrr+WFbI/G7TGu5k3D/iCYYdRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2aYYOI0K; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3912d9848a7so1769584f8f.0
        for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 08:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743175904; x=1743780704; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jBMUpGqTWD4UpO2EN6fhtj6WpgPcfU+elgx/+TqNl3U=;
        b=2aYYOI0KPANBxjlszDqd/xXP/bSZ6k0VyLFVb2g3Hjwfjip072qB5SQ47pKumhA/wi
         /NKDhMQ8odpO2gBmkDm91ir0EEk/pKon2pTIJioYRZaZDBmT6uOm2YAiNh2/6b+8h59m
         1SGvh8At4SnqpqFin24IehveOR4TFHYji+OKdlCdqhOFb6QxmwogndJ01crbb9UGlqIt
         Xwrv3BwBPc8ozKG29f/GeGyrFPUWm/2i9SSc3h/Q0EmsMlo3S3/tiPS78BXynrMIYXqO
         9u98XKkOGXEq29yLrMHLP04DgyuyugmcQoDQ015OKmnirrkejeTAkie7K5JTFgTaSGGs
         VSmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743175904; x=1743780704;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jBMUpGqTWD4UpO2EN6fhtj6WpgPcfU+elgx/+TqNl3U=;
        b=bE3IKOUksR6HsjcO91J5kVO0TamUamC/KzVYRXZ+1vV9CEkN0i5McV91FRTX2KXf8n
         bURbQCAzIKbATgRpxVi2IllYyNu9Turdo3jjOvJuMjI5UDxczeptHB1CnK84cL7VZHaQ
         hCExR71iPyobtbaxVuFt4xuwKBvAKesYTKBwskUyeOA+um3Up2BtZAQIYskrKS6tdOmU
         lSUzbpuxfTPzL7XuSXJ5lEY8lL8wygJPxKoBCNRoWXDl1UkAq1/x00QznHeQI/7XxDoV
         C6URWQM4ZFL5QjlaEZ9XpX5ioZOEvH80nBOszWPWkAplYGn8FQ71BMj672ylYudp/JMs
         i9Mw==
X-Gm-Message-State: AOJu0YyRPPEQIMYxb4QkhZGZj6cnP048s5VJKmW2Xw60JueuuJRmtJCU
	hd1LgfvQs3FNGAe4VvOFYJGOyOH0yy+zx146alUc2qn03Ar/IIXYQe2mHjAPV7EQzDhYFWFTZIw
	U9c78cmpfLSN2vnraLWABj6khJEjsXWaIYnQou1FweVexEhpTt6GQAvfSmVxOXEgoDzyLTZgwAw
	g2twP2Kh0LkhxAS52/EaIjO0w=
X-Google-Smtp-Source: AGHT+IGsVvvboBRAyzbhN+VadIQHCOH8PGYVPxU5z0Lyav96vZClKVh4KR5eyXtOx0aT0txiHrEbB6kiHg==
X-Received: from wmrn12.prod.google.com ([2002:a05:600c:500c:b0:43d:41a2:b768])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6dca:b0:43c:f509:2bbf
 with SMTP id 5b1f17b1804b1-43d911902efmr30762195e9.15.1743175904477; Fri, 28
 Mar 2025 08:31:44 -0700 (PDT)
Date: Fri, 28 Mar 2025 15:31:31 +0000
In-Reply-To: <20250328153133.3504118-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250328153133.3504118-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250328153133.3504118-6-tabba@google.com>
Subject: [PATCH v7 5/7] KVM: guest_memfd: Restore folio state after final folio_put()
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

Before transitioning a guest_memfd folio to unshared, thereby
disallowing access by the host and allowing the hypervisor to transition
its view of the guest page as private, we need to ensure that the host
doesn't have any references to the folio.

This patch uses the guest_memfd folio type to register a callback that
informs the guest_memfd subsystem when the last reference is dropped,
therefore knowing that the host doesn't have any remaining references.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
The function kvm_slot_gmem_register_callback() isn't used in this
series. It will be used later in code that performs unsharing of
memory. I have tested it with pKVM, based on downstream code [*].
It's included in this RFC since it demonstrates the plan to
handle unsharing of private folios.

[*] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-6.13-v7-pkvm
---
 include/linux/kvm_host.h |   6 ++
 virt/kvm/guest_memfd.c   | 143 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 148 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bf82faf16c53..d9d9d72d8beb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2607,6 +2607,7 @@ int kvm_gmem_slot_set_shared(struct kvm_memory_slot *slot, gfn_t start,
 int kvm_gmem_slot_clear_shared(struct kvm_memory_slot *slot, gfn_t start,
 			       gfn_t end);
 bool kvm_gmem_slot_is_guest_shared(struct kvm_memory_slot *slot, gfn_t gfn);
+int kvm_gmem_slot_register_callback(struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_gmem_handle_folio_put(struct folio *folio);
 #else
 static inline int kvm_gmem_set_shared(struct kvm *kvm, gfn_t start, gfn_t end)
@@ -2638,6 +2639,11 @@ static inline bool kvm_gmem_slot_is_guest_shared(struct kvm_memory_slot *slot,
 	WARN_ON_ONCE(1);
 	return false;
 }
+static inline int kvm_gmem_slot_register_callback(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
 #endif /* CONFIG_KVM_GMEM_SHARED_MEM */
 
 #endif
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 3b4d724084a8..ce19bd6c2031 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -392,6 +392,27 @@ enum folio_shareability {
 	KVM_GMEM_NONE_SHARED	= 0b11, /* Not shared, transient state. */
 };
 
+/*
+ * Unregisters the __folio_put() callback from the folio.
+ *
+ * Restores a folio's refcount after all pending references have been released,
+ * and removes the folio type, thereby removing the callback. Now the folio can
+ * be freed normaly once all actual references have been dropped.
+ *
+ * Must be called with the folio locked and the offsets_lock write lock held.
+ */
+static void kvm_gmem_restore_pending_folio(struct folio *folio, struct inode *inode)
+{
+	rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
+
+	lockdep_assert_held_write(offsets_lock);
+	WARN_ON_ONCE(!folio_test_locked(folio));
+	WARN_ON_ONCE(!folio_test_guestmem(folio));
+
+	__folio_clear_guestmem(folio);
+	folio_ref_add(folio, folio_nr_pages(folio));
+}
+
 static int kvm_gmem_offset_set_shared(struct inode *inode, pgoff_t index)
 {
 	struct xarray *shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
@@ -400,6 +421,24 @@ static int kvm_gmem_offset_set_shared(struct inode *inode, pgoff_t index)
 
 	lockdep_assert_held_write(offsets_lock);
 
+	/*
+	 * If the folio is NONE_SHARED, it indicates that it is transitioning to
+	 * private (GUEST_SHARED). Transition it to shared (ALL_SHARED)
+	 * immediately, and remove the callback.
+	 */
+	if (xa_to_value(xa_load(shared_offsets, index)) == KVM_GMEM_NONE_SHARED) {
+		struct folio *folio = filemap_lock_folio(inode->i_mapping, index);
+
+		if (WARN_ON_ONCE(IS_ERR(folio)))
+			return PTR_ERR(folio);
+
+		if (folio_test_guestmem(folio))
+			kvm_gmem_restore_pending_folio(folio, inode);
+
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
 	return xa_err(xa_store(shared_offsets, index, xval, GFP_KERNEL));
 }
 
@@ -503,9 +542,111 @@ static int kvm_gmem_offset_range_clear_shared(struct inode *inode,
 	return r;
 }
 
+/*
+ * Registers a callback to __folio_put(), so that gmem knows that the host does
+ * not have any references to the folio. The callback itself is registered by
+ * setting the folio type to guestmem.
+ *
+ * Returns 0 if a callback was registered or already has been registered, or
+ * -EAGAIN if the host has references, indicating a callback wasn't registered.
+ *
+ * Must be called with the folio locked and the offsets_lock write lock held.
+ */
+static int kvm_gmem_register_callback(struct folio *folio, struct inode *inode, pgoff_t index)
+{
+	struct xarray *shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
+	rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
+	void *xval_guest = xa_mk_value(KVM_GMEM_GUEST_SHARED);
+	int refcount;
+	int r = 0;
+
+	lockdep_assert_held_write(offsets_lock);
+	WARN_ON_ONCE(!folio_test_locked(folio));
+
+	if (folio_test_guestmem(folio))
+		return 0;
+
+	if (folio_mapped(folio))
+		return -EAGAIN;
+
+	refcount = folio_ref_count(folio);
+	if (!folio_ref_freeze(folio, refcount))
+		return -EAGAIN;
+
+	/*
+	 * Register callback by setting the folio type and subtracting gmem's
+	 * references for it to trigger once outstanding references are dropped.
+	 */
+	if (refcount > 1) {
+		__folio_set_guestmem(folio);
+		refcount -= folio_nr_pages(folio);
+	} else {
+		/* No outstanding references, transition it to guest shared. */
+		r = WARN_ON_ONCE(xa_err(xa_store(shared_offsets, index, xval_guest, GFP_KERNEL)));
+	}
+
+	folio_ref_unfreeze(folio, refcount);
+	return r;
+}
+
+int kvm_gmem_slot_register_callback(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	unsigned long pgoff = slot->gmem.pgoff + gfn - slot->base_gfn;
+	struct inode *inode = file_inode(READ_ONCE(slot->gmem.file));
+	rwlock_t *offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
+	struct folio *folio;
+	int r;
+
+	write_lock(offsets_lock);
+
+	folio = filemap_lock_folio(inode->i_mapping, pgoff);
+	if (WARN_ON_ONCE(IS_ERR(folio))) {
+		write_unlock(offsets_lock);
+		return PTR_ERR(folio);
+	}
+
+	r = kvm_gmem_register_callback(folio, inode, pgoff);
+
+	folio_unlock(folio);
+	folio_put(folio);
+	write_unlock(offsets_lock);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_slot_register_callback);
+
+/*
+ * Callback function for __folio_put(), i.e., called once all references by the
+ * host to the folio have been dropped. This allows gmem to transition the state
+ * of the folio to shared with the guest, and allows the hypervisor to continue
+ * transitioning its state to private, since the host cannot attempt to access
+ * it anymore.
+ */
 void kvm_gmem_handle_folio_put(struct folio *folio)
 {
-	WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
+	struct address_space *mapping;
+	struct xarray *shared_offsets;
+	rwlock_t *offsets_lock;
+	struct inode *inode;
+	pgoff_t index;
+	void *xval;
+
+	mapping = folio->mapping;
+	if (WARN_ON_ONCE(!mapping))
+		return;
+
+	inode = mapping->host;
+	index = folio->index;
+	shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
+	offsets_lock = &kvm_gmem_private(inode)->offsets_lock;
+	xval = xa_mk_value(KVM_GMEM_GUEST_SHARED);
+
+	write_lock(offsets_lock);
+	folio_lock(folio);
+	kvm_gmem_restore_pending_folio(folio, inode);
+	folio_unlock(folio);
+	WARN_ON_ONCE(xa_err(xa_store(shared_offsets, index, xval, GFP_KERNEL)));
+	write_unlock(offsets_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_handle_folio_put);
 
-- 
2.49.0.472.ge94155a9ec-goog


