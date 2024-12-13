Return-Path: <kvm+bounces-33746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 247019F12D2
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 17:51:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34CAD16ABA5
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 16:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F8B21F2C2D;
	Fri, 13 Dec 2024 16:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uguuZLzO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C52A1F2375
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 16:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734108509; cv=none; b=YqTNwUPvNSb8FaqsNKz2irJqc/IvWDqiILySHzQArislA3u6QBPR0VpkT7TPd8UvkihYrDU1kFEmhHdNq+mlgdHYzSWKHLg88YKAO5RYSA6KcGquDlnDoRgvOz/C6MeYJgMGuwU2PwbCly2asD/QdDTPpgCo6LnZWtXb+mbMoFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734108509; c=relaxed/simple;
	bh=MRziK0nkXcHn0W5MKOVYd7k+EfFkyEYOhsd8aAEHo54=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ImPS2V10n9bACh/C1mzWjyJkO3fHflYYx2grsoPwqQDEhd0LPnfA1pU7zqOfJIXe/+Q5duwv86mlR1KJDmo2hMGgxiJSUhg4toUxr4O0tyPsh3WS7iDirABMAqwmQlsgOvJV6n6zuLMJfbqJfLrHxBtpr0XLCP3lq4hDCqthn4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uguuZLzO; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3860bc1d4f1so1298543f8f.2
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 08:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734108506; x=1734713306; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gdnqwTM+ekDbCobF/sslf1fAX7qCXn0A+3Ru0J9WkCw=;
        b=uguuZLzOvjxhPcOp/RGtEbyC0Jt7PocV66FFZB4CADUvP/O7EXQCAMQf1Uhiw6lhnT
         EuoVEhPYqU0e2kQ84BCJ0hHMStIE3FxluK1ryYnCL1jTMVgZTFjiF0FeYLPwL3xvPKeg
         Xwhlsprrtsl1ASg7rtxSPBNbPYweFFVGFri6L+DmYf9WGRWxIBMvJHXxvOv4gHdIr7ke
         E/cTu7CMKAg5zBElF7qOT0+R39LxRCunCeZYnxCxp3kvN73VxFZGlYtiqsjn6aGi6WrO
         Fdf5zgPzIo4+8ZDleEi0wRUZHRULEVC9eRoJsO0dijt0WD9MA7EtZgFP/26GzbUSXMsT
         JREA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734108506; x=1734713306;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gdnqwTM+ekDbCobF/sslf1fAX7qCXn0A+3Ru0J9WkCw=;
        b=FP1rZx24OuoctknVRmHqUydNHW3gOQtqkZ0OyiJZkXzRjKRBdPpUm69qGSZ6gYZaex
         1mo9Ol/MRF6rMRueRMk+tC6+HAy2oWBggh85yDlUYoZa9KKLlEl74SnJPcJIfA3YnFvc
         Wh75nk30OpULLMSZpDo1QrEdjXUpMD3tDTzVlGvZCO6nrYm27hoL8/BUCoqaKxnHNb1U
         jkCvDmXl4V2DbFfLG73JHJrz9RxWz++NxpGKTvjzx6bhI/F0NcNM1WsghYcd5PpGDLMq
         ULCyu6IwhO3FS4BAhpjZbzMYdIvJEpGG5LGC95gGzGXe/w3nN4EP9HWugb+jmercXFOV
         fx2w==
X-Gm-Message-State: AOJu0YzO4h4nnPDmySoy0H6S8zTXPvQugRYVxe/yzWTBA7F/NzbqjPN6
	kU7+xK0dI+WTOqID3DgVrGYfze03YGX/lqYpEISEE255f1XxoUESTtXtQpOPqw9rMwyAyMMnt65
	bCR4mSKAbneuXjfBX3OJr7HsLhUpspEJUNpJGptvUFqP7sIi8gNmWOd24+knU7hUoGgLauCRfHb
	54Ge+iMl6zNhfQLcOJpljOSyc=
X-Google-Smtp-Source: AGHT+IHsiL1TU4JB1jwgTJjdMcyuypfsiIlUlbhs/D1z5iTg4X32f0hrac57+zGyUbo1D5HK1o3YHzzCeg==
X-Received: from wrpa7.prod.google.com ([2002:adf:eec7:0:b0:382:31e8:c1f8])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:1f82:b0:385:effc:a279
 with SMTP id ffacd0b85a97d-3888e0c184dmr1858759f8f.58.1734108505690; Fri, 13
 Dec 2024 08:48:25 -0800 (PST)
Date: Fri, 13 Dec 2024 16:48:02 +0000
In-Reply-To: <20241213164811.2006197-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241213164811.2006197-1-tabba@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241213164811.2006197-7-tabba@google.com>
Subject: [RFC PATCH v4 06/14] KVM: guest_memfd: Handle final folio_put() of
 guestmem pages
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
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Before transitioning a guest_memfd folio to unshared, thereby
disallowing access by the host and allowing the hypervisor to
transition its view of the guest page as private, we need to be
sure that the host doesn't have any references to the folio.

This patch introduces a new type for guest_memfd folios, and uses
that to register a callback that informs the guest_memfd
subsystem when the last reference is dropped, therefore knowing
that the host doesn't have any remaining references.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
The function kvm_slot_gmem_register_callback() isn't used in this
series. It will be used later in code that performs unsharing of
memory. I have tested it with pKVM, based on downstream code [*].
It's included in this RFC since it demonstrates the plan to
handle unsharing of private folios.

[*] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-6.13-v4-pkvm
---
 include/linux/kvm_host.h   |  11 +++
 include/linux/page-flags.h |   7 ++
 mm/debug.c                 |   1 +
 mm/swap.c                  |   4 +
 virt/kvm/guest_memfd.c     | 145 +++++++++++++++++++++++++++++++++++++
 5 files changed, 168 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 84aa7908a5dd..7ada5f78ded4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2574,6 +2574,8 @@ int kvm_slot_gmem_clear_mappable(struct kvm_memory_slot *slot, gfn_t start,
 				 gfn_t end);
 bool kvm_slot_gmem_is_mappable(struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_slot_gmem_is_guest_mappable(struct kvm_memory_slot *slot, gfn_t gfn);
+int kvm_slot_gmem_register_callback(struct kvm_memory_slot *slot, gfn_t gfn);
+void kvm_gmem_handle_folio_put(struct folio *folio);
 #else
 static inline bool kvm_gmem_is_mappable(struct kvm *kvm, gfn_t gfn, gfn_t end)
 {
@@ -2615,6 +2617,15 @@ static inline bool kvm_slot_gmem_is_guest_mappable(struct kvm_memory_slot *slot,
 	WARN_ON_ONCE(1);
 	return false;
 }
+int kvm_slot_gmem_register_callback(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+static inline void kvm_gmem_handle_folio_put(struct folio *folio)
+{
+	WARN_ON_ONCE(1);
+}
 #endif /* CONFIG_KVM_GMEM_MAPPABLE */
 
 #endif
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index aca57802d7c7..b0e8e43de77c 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -950,6 +950,7 @@ enum pagetype {
 	PGTY_slab	= 0xf5,
 	PGTY_zsmalloc	= 0xf6,
 	PGTY_unaccepted	= 0xf7,
+	PGTY_guestmem	= 0xf8,
 
 	PGTY_mapcount_underflow = 0xff
 };
@@ -1099,6 +1100,12 @@ FOLIO_TYPE_OPS(hugetlb, hugetlb)
 FOLIO_TEST_FLAG_FALSE(hugetlb)
 #endif
 
+#ifdef CONFIG_KVM_GMEM_MAPPABLE
+FOLIO_TYPE_OPS(guestmem, guestmem)
+#else
+FOLIO_TEST_FLAG_FALSE(guestmem)
+#endif
+
 PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
 
 /*
diff --git a/mm/debug.c b/mm/debug.c
index 95b6ab809c0e..db93be385ed9 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -56,6 +56,7 @@ static const char *page_type_names[] = {
 	DEF_PAGETYPE_NAME(table),
 	DEF_PAGETYPE_NAME(buddy),
 	DEF_PAGETYPE_NAME(unaccepted),
+	DEF_PAGETYPE_NAME(guestmem),
 };
 
 static const char *page_type_name(unsigned int page_type)
diff --git a/mm/swap.c b/mm/swap.c
index 6f01b56bce13..15220eaabc86 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -37,6 +37,7 @@
 #include <linux/page_idle.h>
 #include <linux/local_lock.h>
 #include <linux/buffer_head.h>
+#include <linux/kvm_host.h>
 
 #include "internal.h"
 
@@ -103,6 +104,9 @@ static void free_typed_folio(struct folio *folio)
 	case PGTY_offline:
 		/* Nothing to do, it's offline. */
 		return;
+	case PGTY_guestmem:
+		kvm_gmem_handle_folio_put(folio);
+		return;
 	default:
 		WARN_ON_ONCE(1);
 	}
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index d1c192927cf7..5ecaa5dfcd00 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -387,6 +387,28 @@ enum folio_mappability {
 	KVM_GMEM_NONE_MAPPABLE	= 0b11, /* Not mappable, transient state. */
 };
 
+/*
+ * Unregisters the __folio_put() callback from the folio.
+ *
+ * Restores a folio's refcount after all pending references have been released,
+ * and removes the folio type, thereby removing the callback. Now the folio can
+ * be freed normaly once all actual references have been dropped.
+ *
+ * Must be called with the filemap (inode->i_mapping) invalidate_lock held.
+ * Must also have exclusive access to the folio: folio must be either locked, or
+ * gmem holds the only reference.
+ */
+static void __kvm_gmem_restore_pending_folio(struct folio *folio)
+{
+	if (WARN_ON_ONCE(folio_mapped(folio) || !folio_test_guestmem(folio)))
+		return;
+
+	WARN_ON_ONCE(!folio_test_locked(folio) || folio_ref_count(folio) > 1);
+
+	__folio_clear_guestmem(folio);
+	folio_ref_add(folio, folio_nr_pages(folio));
+}
+
 /*
  * Marks the range [start, end) as mappable by both the host and the guest.
  * Usually called when guest shares memory with the host.
@@ -400,7 +422,31 @@ static int gmem_set_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
 
 	filemap_invalidate_lock(inode->i_mapping);
 	for (i = start; i < end; i++) {
+		struct folio *folio = NULL;
+
+		/*
+		 * If the folio is NONE_MAPPABLE, it indicates that it is
+		 * transitioning to private (GUEST_MAPPABLE). Transition it to
+		 * shared (ALL_MAPPABLE) immediately, and remove the callback.
+		 */
+		if (xa_to_value(xa_load(mappable_offsets, i)) == KVM_GMEM_NONE_MAPPABLE) {
+			folio = filemap_lock_folio(inode->i_mapping, i);
+			if (WARN_ON_ONCE(IS_ERR(folio))) {
+				r = PTR_ERR(folio);
+				break;
+			}
+
+			if (folio_test_guestmem(folio))
+				__kvm_gmem_restore_pending_folio(folio);
+		}
+
 		r = xa_err(xa_store(mappable_offsets, i, xval, GFP_KERNEL));
+
+		if (folio) {
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+
 		if (r)
 			break;
 	}
@@ -473,6 +519,105 @@ static int gmem_clear_mappable(struct inode *inode, pgoff_t start, pgoff_t end)
 	return r;
 }
 
+/*
+ * Registers a callback to __folio_put(), so that gmem knows that the host does
+ * not have any references to the folio. It does that by setting the folio type
+ * to guestmem.
+ *
+ * Returns 0 if the host doesn't have any references, or -EAGAIN if the host
+ * has references, and the callback has been registered.
+ *
+ * Must be called with the following locks held:
+ * - filemap (inode->i_mapping) invalidate_lock
+ * - folio lock
+ */
+static int __gmem_register_callback(struct folio *folio, struct inode *inode, pgoff_t idx)
+{
+	struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
+	void *xval_guest = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
+	int refcount;
+
+	rwsem_assert_held_write_nolockdep(&inode->i_mapping->invalidate_lock);
+	WARN_ON_ONCE(!folio_test_locked(folio));
+
+	if (folio_mapped(folio) || folio_test_guestmem(folio))
+		return -EAGAIN;
+
+	/* Register a callback first. */
+	__folio_set_guestmem(folio);
+
+	/*
+	 * Check for references after setting the type to guestmem, to guard
+	 * against potential races with the refcount being decremented later.
+	 *
+	 * At least one reference is expected because the folio is locked.
+	 */
+
+	refcount = folio_ref_sub_return(folio, folio_nr_pages(folio));
+	if (refcount == 1) {
+		int r;
+
+		/* refcount isn't elevated, it's now faultable by the guest. */
+		r = WARN_ON_ONCE(xa_err(xa_store(mappable_offsets, idx, xval_guest, GFP_KERNEL)));
+		if (!r)
+			__kvm_gmem_restore_pending_folio(folio);
+
+		return r;
+	}
+
+	return -EAGAIN;
+}
+
+int kvm_slot_gmem_register_callback(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	unsigned long pgoff = slot->gmem.pgoff + gfn - slot->base_gfn;
+	struct inode *inode = file_inode(slot->gmem.file);
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
+	r = __gmem_register_callback(folio, inode, pgoff);
+
+	folio_unlock(folio);
+	folio_put(folio);
+out:
+	filemap_invalidate_unlock(inode->i_mapping);
+
+	return r;
+}
+
+/*
+ * Callback function for __folio_put(), i.e., called when all references by the
+ * host to the folio have been dropped. This allows gmem to transition the state
+ * of the folio to mappable by the guest, and allows the hypervisor to continue
+ * transitioning its state to private, since the host cannot attempt to access
+ * it anymore.
+ */
+void kvm_gmem_handle_folio_put(struct folio *folio)
+{
+	struct xarray *mappable_offsets;
+	struct inode *inode;
+	pgoff_t index;
+	void *xval;
+
+	inode = folio->mapping->host;
+	index = folio->index;
+	mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
+	xval = xa_mk_value(KVM_GMEM_GUEST_MAPPABLE);
+
+	filemap_invalidate_lock(inode->i_mapping);
+	__kvm_gmem_restore_pending_folio(folio);
+	WARN_ON_ONCE(xa_err(xa_store(mappable_offsets, index, xval, GFP_KERNEL)));
+	filemap_invalidate_unlock(inode->i_mapping);
+}
+
 static bool gmem_is_mappable(struct inode *inode, pgoff_t pgoff)
 {
 	struct xarray *mappable_offsets = &kvm_gmem_private(inode)->mappable_offsets;
-- 
2.47.1.613.gc27f4b7a9f-goog


