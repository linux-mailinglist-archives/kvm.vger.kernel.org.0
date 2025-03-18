Return-Path: <kvm+bounces-41412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0AEDA67948
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 17:26:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAFAC3A4812
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:22:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A572212D8A;
	Tue, 18 Mar 2025 16:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1YiNsqoO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABCC21146B
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 16:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742314861; cv=none; b=Um6g4HnjRkcvMQeGpSlyda+yKf0LTY3RYm4YT/5D61YIhukEfwpl4wgppR20R+eOwpcMRwzs/ur2cy/vYIrtSBE3qvC61YrQGnI8fQ4c9SzwxyOYnecf9jLKrK7vNb08KUvqti5MQD6Eoj7JbpWNfWwtpB70G2f3lB4v1T6D14U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742314861; c=relaxed/simple;
	bh=bhX24/V7ZDV2nbmrKEq6K8/HqafZjTrBZh5jMYevWu0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LeyCBlLq7aGbp5PwWko0Pr+dwLJJev7qwi1HDXNumnDGF1Rw8PE1fBIRPg/QiFhWs8dMMRq/iM5cdwjGQ+/KRKhGqN7hWxg1huGAVNIoytSarpCLIlxz0NZHgZfSScenf/PS934A7y/IANxLQAFfRc31GClVidtWQ0RqZaMUO3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1YiNsqoO; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43ce245c5acso39935125e9.2
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 09:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742314858; x=1742919658; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a6WFCPXhVulU3JlKKdNPQ8TZldM3kvZLBiH+wPK8x24=;
        b=1YiNsqoONyy1QSkfUGH4BlQOoDhk8ZSk/y8IupzI/XUslQKBY63YD5FIEGAl2OwUNx
         OFD3X3/mRlDu5WyPE2tIeL/l+oru18Qejvk31rP7er1bYUreD0cdgsvLvyLCg6m3KTWj
         +7ri1AAYZRmNKCqNtz0CIsUNkwBfdKk6bCXCqKAPYmJ6oOydtcBYjKgpy04eMw0k3BAU
         VNZypRYvVWsYhyMtbhQ/UmYWh1JqYNhl6Z3El88rl0pHB2/5wrM8oxtEZ4HRHUZz9hTC
         5VBye2+kDNRn/mVlgGtIsQbZYBhajnd00ecKtOSrx5aqOMxWmm7m7f7yOo7IZDi4pwdV
         wfAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742314858; x=1742919658;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a6WFCPXhVulU3JlKKdNPQ8TZldM3kvZLBiH+wPK8x24=;
        b=xSV2d4Ej8uyVbxbXqtPnh+EoWnlFdpNDao0o5mmWfODg+HCwMKUhEoG/z6NtddLw1t
         /N4rNHUdv2WY1iSu9lPdy3Y7JUrf3u9LIq6emvn7ENqZJ3WJemC5Ml6p/LdUGLduoHoy
         cD6zyxmEvSewTLY9hvDVedvXyWDxKcIDUEBuyS3ZA3ducFQjr2SiBGKbFIERM6G197xy
         MJ7q8g7t0pxZqWv2c0Xt8jJ+0fvaODBJcEgwsVe4D4IspXsSbGI7P+UzsFKShQDwkkK5
         do5mwZkCD/DwyI+jNTsGjC9fNcmVr1BWSVSPD7ms/YwmVlsxzvMT6MSYY1TILXilYZJW
         j5nA==
X-Gm-Message-State: AOJu0YxX/Zv5k5Qhtgj/vNJZ7M+5ic+fTPkYYo9WzMVUN/9cREZAKuxn
	BGKnmubD26DBbo8m0nsetWIQE7QGRW69gZpJk3Tv76dzU5saR73uk5nH0suKy3AUTwHqZFM96Fo
	y+NwPJCCjdiB2QNyePkwr23U61z3PafK4Nmax0Dw27MMGtjFfKrm01fBTKU9dO3GMHD0VUdm0Zs
	YhuoEEb5Y9OSf+9W2bGISeKcM=
X-Google-Smtp-Source: AGHT+IFpCY8S6zPBB8YKDIAA3pydzkUV4b8FblJAz6faFFJzNyDdarVqLGdmgRcnMjMcQ62t91jU7QaUhQ==
X-Received: from wmrs14.prod.google.com ([2002:a05:600c:384e:b0:43c:f8ae:4d6c])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e0b:b0:43c:fbbf:7bf1
 with SMTP id 5b1f17b1804b1-43d3ba0f389mr35016465e9.30.1742314857836; Tue, 18
 Mar 2025 09:20:57 -0700 (PDT)
Date: Tue, 18 Mar 2025 16:20:44 +0000
In-Reply-To: <20250318162046.4016367-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250318162046.4016367-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250318162046.4016367-6-tabba@google.com>
Subject: [PATCH v6 5/7] KVM: guest_memfd: Restore folio state after final folio_put()
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

Before transitioning a guest_memfd folio to unshared, thereby
disallowing access by the host and allowing the hypervisor to transition
its view of the guest page as private, we need to be sure that the host
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

[*] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-6.13-v6-pkvm
---
 include/linux/kvm_host.h |   6 ++
 virt/kvm/guest_memfd.c   | 142 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 147 insertions(+), 1 deletion(-)

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
index 4b857ab421bf..4fd9e5760503 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -391,6 +391,28 @@ enum folio_shareability {
 	KVM_GMEM_NONE_SHARED	= 0b11, /* Not shared, transient state. */
 };
 
+/*
+ * Unregisters the __folio_put() callback from the folio.
+ *
+ * Restores a folio's refcount after all pending references have been released,
+ * and removes the folio type, thereby removing the callback. Now the folio can
+ * be freed normaly once all actual references have been dropped.
+ *
+ * Must be called with the filemap (inode->i_mapping) invalidate_lock held, and
+ * the folio must be locked.
+ */
+static void kvm_gmem_restore_pending_folio(struct folio *folio, const struct inode *inode)
+{
+	rwsem_assert_held_write_nolockdep(&inode->i_mapping->invalidate_lock);
+	WARN_ON_ONCE(!folio_test_locked(folio));
+
+	if (WARN_ON_ONCE(folio_mapped(folio) || !folio_test_guestmem(folio)))
+		return;
+
+	__folio_clear_guestmem(folio);
+	folio_ref_add(folio, folio_nr_pages(folio));
+}
+
 static int kvm_gmem_offset_set_shared(struct inode *inode, pgoff_t index)
 {
 	struct xarray *shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
@@ -398,6 +420,24 @@ static int kvm_gmem_offset_set_shared(struct inode *inode, pgoff_t index)
 
 	rwsem_assert_held_write_nolockdep(&inode->i_mapping->invalidate_lock);
 
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
 
@@ -498,9 +538,109 @@ static int kvm_gmem_offset_range_clear_shared(struct inode *inode,
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
+ * Must be called with the filemap (inode->i_mapping) invalidate_lock held, and
+ * the folio must be locked.
+ */
+static int kvm_gmem_register_callback(struct folio *folio, struct inode *inode, pgoff_t index)
+{
+	struct xarray *shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
+	void *xval_guest = xa_mk_value(KVM_GMEM_GUEST_SHARED);
+	int refcount;
+	int r = 0;
+
+	rwsem_assert_held_write_nolockdep(&inode->i_mapping->invalidate_lock);
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
+	struct folio *folio;
+	int r;
+
+	filemap_invalidate_lock(inode->i_mapping);
+
+	folio = filemap_lock_folio(inode->i_mapping, pgoff);
+	if (WARN_ON_ONCE(IS_ERR(folio))) {
+		r = PTR_ERR(folio);
+		goto out;
+	}
+
+	r = kvm_gmem_register_callback(folio, inode, pgoff);
+
+	folio_unlock(folio);
+	folio_put(folio);
+out:
+	filemap_invalidate_unlock(inode->i_mapping);
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
+	xval = xa_mk_value(KVM_GMEM_GUEST_SHARED);
+
+	filemap_invalidate_lock(inode->i_mapping);
+	folio_lock(folio);
+	kvm_gmem_restore_pending_folio(folio, inode);
+	folio_unlock(folio);
+	WARN_ON_ONCE(xa_err(xa_store(shared_offsets, index, xval, GFP_KERNEL)));
+	filemap_invalidate_unlock(inode->i_mapping);
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_handle_folio_put);
 
-- 
2.49.0.rc1.451.g8f38331e32-goog


