Return-Path: <kvm+bounces-69924-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ECdFM64mgWnsEQMAu9opvQ
	(envelope-from <kvm+bounces-69924-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:35:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EEC08D23C2
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 23:35:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C37CE3038044
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 22:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BE29367F22;
	Mon,  2 Feb 2026 22:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PPkQkDpT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6266938E128
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 22:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071440; cv=none; b=a37Oh1jf6YgjVJkHcFL6Pl+5P6hZuCuhjF1ZgWFOXkoeBAc71cPBQyFRJjt1Wwdb7no7alExk2s0af2w8vIaZh2UYmAwaE47KBltAdeOLQuByJ7Wih9hL6Oqyh68dMzc+lm7KVvoFK3yc4GFB6Yip2LAdKJJyjMDxjmPMG4aPRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071440; c=relaxed/simple;
	bh=QfKxevh++XzoNLZhvuOxk9WTPn9aR5809qtmbW8H8Kc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mY+PCGNpGcQRLVBeG+5M88CwNXkAP97ibEnUQVMLPFSZ04auASOlQAMeXe326FKZtKmJUqMi1hRBdkydjkirB2BFuGzerCaYgVHU/a2Mo8spooURNiYznfK5NlZ/+A9YKXVZKHBjx053IUxQ1oFAJiB1CFSaCbbGflSqZ8mfgCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PPkQkDpT; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c61dee98720so2934822a12.0
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 14:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770071438; x=1770676238; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9oaoOTJPFQs+PLfyIJYQ4yJAsgXpYIIcONJyOKyf78s=;
        b=PPkQkDpT2k6TdtXUkvZax2DtMxOqV0zfcX1PYhOeftHLOmFosJDEEQvHrMXi84hMtQ
         SKh79dqI8PVcYbyGHZnLSXZynebUwQ+RyCLlp80TuBQTneYnhwBp5rHoj0k95cfYyUy4
         u8vq3MpWNz0xG9rSgNy/U392GcTf+DZeoKIPXRtBjJ15Yah5VxFP4LYGcZNRK+q3fN19
         qoB0rJsTxc0x3K0BGtn7OBgF8W6pY4/vg331E1NOunggpOP5hXvUksgJNsfVkrCq9myv
         UroSjaV9vNTCGaW/OLZVY315OwL/lIsZgFXTWhbLIyWLUuUT1kpoBprZPc2v5M1MeL1b
         kj7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071438; x=1770676238;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9oaoOTJPFQs+PLfyIJYQ4yJAsgXpYIIcONJyOKyf78s=;
        b=wYCiiUlVLJugSyDmQ0t5EOw6GROJoi8nuiee1w0Szh1R5Udc2cR/0+1ALhKzvxhUT4
         FMZAb2o9JALG0CIeZ4U5xSgMN8skjBBN6KZIZ6p8VKNjUE/gwnRirxX8vjAGOVXjyklC
         0+hnlZrqxfWY9C01oaZuaZEzRY+n1snMr94naRWhlcQuKp+nXfI6K51jhD6vkJeobUA6
         Po3cr+89xb+KyMt8O5ELDrjNqElb7j6k8XBNJ5l2/7yKxF39dXWzdqugWA/z2QRLkWcd
         UsKiOVsU6cjzCCuzYoLOC0NfGLZ2ArRzY4YpIQ3R8DWSd17SEKgp+QONVDviNQeiHy7N
         /GTg==
X-Gm-Message-State: AOJu0YzduvCccxl/uA6/lKSEF2NFMzmyg4iXID0deDUUxmzDB5LlWcaW
	ED7BuI9iGiEkxfMYxR7m6D9CCYVP81gZZ9R3KpdewdRwMnj5orm0tiWve16m/+iQ+pAauqWyjhY
	9Z7p1oykI9N8KHQHDTA6AriHISnseRQsr2JRnMKQ85tP47F9b9XfIV5cCIFzdkYaTwNDGIeNYo7
	i305yswbmHkVMZIQqIW50OSD/yyZ/vpSOXmIZsN8A/zAWSGoBuqcD/t8SZfu0=
X-Received: from pgct17.prod.google.com ([2002:a05:6a02:5291:b0:c63:5610:9a42])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:7303:b0:38d:ecd6:60c with SMTP id adf61e73a8af0-392e01c230fmr13138371637.77.1770071437481;
 Mon, 02 Feb 2026 14:30:37 -0800 (PST)
Date: Mon,  2 Feb 2026 14:29:47 -0800
In-Reply-To: <cover.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <86ad28b767524e1e654b9c960e39ca8bfb24c114.1770071243.git.ackerleytng@google.com>
Subject: [RFC PATCH v2 09/37] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
From: Ackerley Tng <ackerleytng@google.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	bp@alien8.de, brauner@kernel.org, chao.p.peng@intel.com, 
	chao.p.peng@linux.intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com, 
	ira.weiny@intel.com, jgg@nvidia.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, maobibo@loongson.cn, mathieu.desnoyers@efficios.com, 
	maz@kernel.org, mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, prsampat@amd.com, qperret@google.com, 
	ricarkol@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shivankg@amd.com, shuah@kernel.org, 
	steven.price@arm.com, tabba@google.com, tglx@linutronix.de, 
	vannapurve@google.com, vbabka@suse.cz, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-69924-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_GT_50(0.00)[51];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EEC08D23C2
X-Rspamd-Action: no action

For shared to private conversions, if refcounts on any of the folios
within the range are elevated, fail the conversion with -EAGAIN.

At the point of shared to private conversion, all folios in range are
also unmapped. The filemap_invalidate_lock() is held, so no faulting
can occur. Hence, from that point on, only transient refcounts can be
taken on the folios associated with that guest_memfd.

Hence, it is safe to do the conversion from shared to private.

After conversion is complete, refcounts may become elevated, but that
is fine since users of transient refcounts don't actually access
memory.

For private to shared conversions, there are no refcount checks, since
the guest is the only user of private pages, and guest_memfd will be the
only holder of refcounts on private pages.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst |  48 +++++++-
 include/linux/kvm_host.h       |  10 ++
 include/uapi/linux/kvm.h       |   9 +-
 virt/kvm/Kconfig               |   2 +-
 virt/kvm/guest_memfd.c         | 210 +++++++++++++++++++++++++++++++--
 virt/kvm/kvm_main.c            |  15 +--
 6 files changed, 263 insertions(+), 31 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 23ec0b0c3e22..26e80745c8b4 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -117,7 +117,7 @@ description:
       x86 includes both i386 and x86_64.
 
   Type:
-      system, vm, or vcpu.
+      system, vm, vcpu or guest_memfd.
 
   Parameters:
       what parameters are accepted by the ioctl.
@@ -6523,11 +6523,22 @@ the capability to be present.
 ---------------------------------
 
 :Capability: KVM_CAP_MEMORY_ATTRIBUTES2
-:Architectures: x86
-:Type: vm ioctl
+:Architectures: all
+:Type: vm, guest_memfd ioctl
 :Parameters: struct kvm_memory_attributes2 (in/out)
 :Returns: 0 on success, <0 on error
 
+Errors:
+
+  ========== ===============================================================
+  EINVAL     The specified `offset` or `size` were invalid (e.g. not
+             page aligned, causes an overflow, or size is zero).
+  EFAULT     The parameter address was invalid.
+  EAGAIN     Some page within requested range had unexpected refcounts. The
+             offset of the page will be returned in `error_offset`.
+  ENOMEM     Ran out of memory trying to track private/shared state
+  ========== ===============================================================
+
 KVM_SET_MEMORY_ATTRIBUTES2 is an extension to
 KVM_SET_MEMORY_ATTRIBUTES that supports returning (writing) values to
 userspace.  The original (pre-extension) fields are shared with
@@ -6538,15 +6549,42 @@ Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
 ::
 
   struct kvm_memory_attributes2 {
-	__u64 address;
+	/* in */
+	union {
+		__u64 address;
+		__u64 offset;
+	};
 	__u64 size;
 	__u64 attributes;
 	__u64 flags;
-	__u64 reserved[12];
+	/* out */
+	__u64 error_offset;
+	__u64 reserved[11];
   };
 
   #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
 
+Set attributes for a range of offsets within a guest_memfd to
+KVM_MEMORY_ATTRIBUTE_PRIVATE to limit the specified guest_memfd backed
+memory range for guest_use. Even if KVM_CAP_GUEST_MEMFD_MMAP is
+supported, after a successful call to set
+KVM_MEMORY_ATTRIBUTE_PRIVATE, the requested range will not be mappable
+into host userspace and will only be mappable by the guest.
+
+To allow the range to be mappable into host userspace again, call
+KVM_SET_MEMORY_ATTRIBUTES2 on the guest_memfd again with
+KVM_MEMORY_ATTRIBUTE_PRIVATE unset.
+
+If this ioctl returns -EAGAIN, the offset of the page with unexpected
+refcounts will be returned in `error_offset`. This can occur if there
+are transient refcounts on the pages, taken by other parts of the
+kernel.
+
+Userspace is expected to figure out how to remove all known refcounts
+on the shared pages, such as refcounts taken by get_user_pages(), and
+try the ioctl again. A possible source of these long term refcounts is
+if the guest_memfd memory was pinned in IOMMU page tables.
+
 See also: :ref: `KVM_SET_MEMORY_ATTRIBUTES`.
 
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8f1e10a503f4..8276187f5e4c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2516,6 +2516,16 @@ static inline bool kvm_memslot_is_gmem_only(const struct kvm_memory_slot *slot)
 }
 
 #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
+static inline u64 kvm_supported_mem_attributes(struct kvm *kvm)
+{
+#ifdef kvm_arch_has_private_mem
+	if (!kvm || kvm_arch_has_private_mem(kvm))
+		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
+#endif
+
+	return 0;
+}
+
 typedef unsigned long (kvm_get_memory_attributes_t)(struct kvm *kvm, gfn_t gfn);
 DECLARE_STATIC_CALL(__kvm_get_memory_attributes, kvm_get_memory_attributes_t);
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7f8dac4f4fd3..fba5e0c851f2 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -975,6 +975,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_SEA_TO_USER 245
 #define KVM_CAP_S390_USER_OPEREXEC 246
 #define KVM_CAP_MEMORY_ATTRIBUTES2 247
+#define KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES 248
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1612,11 +1613,15 @@ struct kvm_memory_attributes {
 #define KVM_SET_MEMORY_ATTRIBUTES2              _IOWR(KVMIO,  0xd2, struct kvm_memory_attributes2)
 
 struct kvm_memory_attributes2 {
-	__u64 address;
+	union {
+		__u64 address;
+		__u64 offset;
+	};
 	__u64 size;
 	__u64 attributes;
 	__u64 flags;
-	__u64 reserved[12];
+	__u64 error_offset;
+	__u64 reserved[11];
 };
 
 #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 02c4c653bb31..f42bc6e7de44 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -114,7 +114,7 @@ config KVM_VM_MEMORY_ATTRIBUTES
        bool
 
 config KVM_GUEST_MEMFD
-       depends on KVM_GENERIC_MMU_NOTIFIER
+       select KVM_MEMORY_ATTRIBUTES
        select XARRAY_MULTI
        bool
 
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 6b3477b226ad..1cd8024cdb39 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -86,6 +86,23 @@ static bool kvm_gmem_is_shared_mem(struct inode *inode, pgoff_t index)
 	return !kvm_gmem_is_private_mem(inode, index);
 }
 
+static bool kvm_gmem_range_has_attributes(struct maple_tree *mt,
+					  pgoff_t index, size_t nr_pages,
+					  u64 attributes)
+{
+	pgoff_t end = index + nr_pages - 1;
+	void *entry;
+
+	lockdep_assert(mt_lock_is_held(mt));
+
+	mt_for_each(mt, entry, index, end) {
+		if (xa_to_value(entry) != attributes)
+			return false;
+	}
+
+	return true;
+}
+
 static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 				    pgoff_t index, struct folio *folio)
 {
@@ -183,10 +200,12 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 
 static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *inode)
 {
-	if (GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED)
-		return KVM_FILTER_SHARED;
-
-	return KVM_FILTER_PRIVATE;
+	/*
+	 * TODO: Limit invalidations based on the to-be-invalidated range, i.e.
+	 *       invalidate shared/private if and only if there can possibly be
+	 *       such mappings.
+	 */
+	return KVM_FILTER_SHARED | KVM_FILTER_PRIVATE;
 }
 
 static void __kvm_gmem_invalidate_begin(struct gmem_file *f, pgoff_t start,
@@ -552,11 +571,183 @@ unsigned long kvm_gmem_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_get_memory_attributes);
 
+static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
+					    size_t nr_pages, pgoff_t *err_index)
+{
+	struct address_space *mapping = inode->i_mapping;
+	const int filemap_get_folios_refcount = 1;
+	pgoff_t last = start + nr_pages - 1;
+	struct folio_batch fbatch;
+	bool safe = true;
+	int i;
+
+	folio_batch_init(&fbatch);
+	while (safe && filemap_get_folios(mapping, &start, last, &fbatch)) {
+
+		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
+			struct folio *folio = fbatch.folios[i];
+
+			if (folio_ref_count(folio) !=
+			    folio_nr_pages(folio) + filemap_get_folios_refcount) {
+				safe = false;
+				*err_index = folio->index;
+				break;
+			}
+		}
+
+		folio_batch_release(&fbatch);
+	}
+
+	return safe;
+}
+
+/*
+ * Preallocate memory for attributes to be stored on a maple tree, pointed to
+ * by mas.  Adjacent ranges with attributes identical to the new attributes
+ * will be merged.  Also sets mas's bounds up for storing attributes.
+ *
+ * This maintains the invariant that ranges with the same attributes will
+ * always be merged.
+ */
+static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
+				    pgoff_t start, size_t nr_pages)
+{
+	pgoff_t end = start + nr_pages;
+	pgoff_t last = end - 1;
+	void *entry;
+
+	/* Try extending range. entry is NULL on overflow/wrap-around. */
+	mas_set_range(mas, end, end);
+	entry = mas_find(mas, end);
+	if (entry && xa_to_value(entry) == attributes)
+		last = mas->last;
+
+	if (start > 0) {
+		mas_set_range(mas, start - 1, start - 1);
+		entry = mas_find(mas, start - 1);
+		if (entry && xa_to_value(entry) == attributes)
+			start = mas->index;
+	}
+
+	mas_set_range(mas, start, last);
+	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
+}
+
+static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
+				     size_t nr_pages, uint64_t attrs,
+				     pgoff_t *err_index)
+{
+	struct address_space *mapping = inode->i_mapping;
+	struct gmem_inode *gi = GMEM_I(inode);
+	pgoff_t end = start + nr_pages;
+	struct maple_tree *mt;
+	struct ma_state mas;
+	int r;
+
+	mt = &gi->attributes;
+
+	filemap_invalidate_lock(mapping);
+
+	mas_init(&mas, mt, start);
+
+	if (kvm_gmem_range_has_attributes(mt, start, nr_pages, attrs)) {
+		r = 0;
+		goto out;
+	}
+
+	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
+	if (r) {
+		*err_index = start;
+		goto out;
+	}
+
+	if (attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE) {
+		unmap_mapping_pages(mapping, start, nr_pages, false);
+
+		if (!kvm_gmem_is_safe_for_conversion(inode, start, nr_pages,
+						     err_index)) {
+			mas_destroy(&mas);
+			r = -EAGAIN;
+			goto out;
+		}
+	}
+
+	kvm_gmem_invalidate_begin(inode, start, end);
+
+	mas_store_prealloc(&mas, xa_mk_value(attrs));
+
+	kvm_gmem_invalidate_end(inode, start, end);
+out:
+	filemap_invalidate_unlock(mapping);
+	return r;
+}
+
+static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
+{
+	struct gmem_file *f = file->private_data;
+	struct inode *inode = file_inode(file);
+	struct kvm_memory_attributes2 attrs;
+	pgoff_t err_index;
+	size_t nr_pages;
+	pgoff_t index;
+	int i, r;
+
+	if (copy_from_user(&attrs, argp, sizeof(attrs)))
+		return -EFAULT;
+
+	if (attrs.flags)
+		return -EINVAL;
+	if (attrs.error_offset)
+		return -EINVAL;
+	for (i = 0; i < ARRAY_SIZE(attrs.reserved); i++) {
+		if (attrs.reserved[i])
+			return -EINVAL;
+	}
+	if (attrs.attributes & ~kvm_supported_mem_attributes(f->kvm))
+		return -EINVAL;
+	if (attrs.size == 0 || attrs.offset + attrs.size < attrs.offset)
+		return -EINVAL;
+	if (!PAGE_ALIGNED(attrs.offset) || !PAGE_ALIGNED(attrs.size))
+		return -EINVAL;
+
+	if (attrs.offset >= inode->i_size ||
+	    attrs.offset + attrs.size > inode->i_size)
+		return -EINVAL;
+
+	nr_pages = attrs.size >> PAGE_SHIFT;
+	index = attrs.offset >> PAGE_SHIFT;
+	r = __kvm_gmem_set_attributes(inode, index, nr_pages, attrs.attributes,
+				      &err_index);
+	if (r) {
+		attrs.error_offset = err_index << PAGE_SHIFT;
+
+		if (copy_to_user(argp, &attrs, sizeof(attrs)))
+			return -EFAULT;
+	}
+
+	return r;
+}
+
+static long kvm_gmem_ioctl(struct file *file, unsigned int ioctl,
+			   unsigned long arg)
+{
+	switch (ioctl) {
+	case KVM_SET_MEMORY_ATTRIBUTES2:
+		if (vm_memory_attributes)
+			return -ENOTTY;
+
+		return kvm_gmem_set_attributes(file, (void __user *)arg);
+	default:
+		return -ENOTTY;
+	}
+}
+
 static struct file_operations kvm_gmem_fops = {
 	.mmap		= kvm_gmem_mmap,
 	.open		= generic_file_open,
 	.release	= kvm_gmem_release,
 	.fallocate	= kvm_gmem_fallocate,
+	.unlocked_ioctl	= kvm_gmem_ioctl,
 };
 
 static int kvm_gmem_migrate_folio(struct address_space *mapping,
@@ -937,20 +1128,13 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
 static bool kvm_gmem_range_is_private(struct gmem_inode *gi, pgoff_t index,
 				      size_t nr_pages, struct kvm *kvm, gfn_t gfn)
 {
-	pgoff_t end = index + nr_pages - 1;
-	void *entry;
-
 	if (vm_memory_attributes)
 		return kvm_range_has_vm_memory_attributes(kvm, gfn, gfn + nr_pages,
 						       KVM_MEMORY_ATTRIBUTE_PRIVATE,
 						       KVM_MEMORY_ATTRIBUTE_PRIVATE);
 
-	mt_for_each(&gi->attributes, entry, index, end) {
-		if (xa_to_value(entry) != attributes)
-			return false;
-	}
-
-	return true;
+	return kvm_gmem_range_has_attributes(&gi->attributes, index, nr_pages,
+					     KVM_MEMORY_ATTRIBUTE_PRIVATE);
 }
 
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ad70101c2e3f..cf56cc892e7c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2451,16 +2451,6 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
 #endif /* CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
 
 #ifdef CONFIG_KVM_MEMORY_ATTRIBUTES
-static u64 kvm_supported_mem_attributes(struct kvm *kvm)
-{
-#ifdef kvm_arch_has_private_mem
-	if (!kvm || kvm_arch_has_private_mem(kvm))
-		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
-#endif
-
-	return 0;
-}
-
 #ifdef CONFIG_KVM_VM_MEMORY_ATTRIBUTES
 static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
 {
@@ -4993,6 +4983,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		return 1;
 	case KVM_CAP_GUEST_MEMFD_FLAGS:
 		return kvm_gmem_get_supported_flags(kvm);
+	case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
+		if (vm_memory_attributes)
+			return 0;
+
+		return kvm_supported_mem_attributes(kvm);
 #endif
 	default:
 		break;
-- 
2.53.0.rc1.225.gd81095ad13-goog


