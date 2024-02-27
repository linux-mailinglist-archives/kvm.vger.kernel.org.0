Return-Path: <kvm+bounces-10163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ABF686A3D5
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 00:37:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63ACAB22A59
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 23:24:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43DBF5B5AB;
	Tue, 27 Feb 2024 23:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BGZMn+8w"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A081957330
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 23:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709076072; cv=none; b=Sfz3hE4siYAOh/6shtFMgiRgbGhaVKcyrldjlELz2YMPjQPzeKrA8tcLw3fdzkq9ptTDL14P28o5V4DZa+mRvaystJ5ynXdYJ7f7Ct0NeuTvK0A84Uun3IBc+GVURFMwgS6n6au96ABMfZzakeyJ4SuqaiorCz8iZq9ZFhOfUXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709076072; c=relaxed/simple;
	bh=OLt+wNDAa/PlC0MocwRZGW/hSrIQo2bbqPZ4SFDPyW4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q3iZHZsppUSfR2Lih7h7+78Vs2fPS3hLvFeg/RJY5XQugi8t3aot6wiWEEd5YfChDucTD3N3RP5pJN5WMOZATI+Gu9DBkT7PljV1WcUIJjlCUkyUI3MnhB2uTsQ0LZsUoIOs7idEJzTknmgE9tT4ffA5WAl8RKvnuABggLEkvNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BGZMn+8w; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709076067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ftcL7+OPYGlo5d6Nni9SG+r/od+uKOzlm+jactKOZTc=;
	b=BGZMn+8wvJ/num+Jwwm1bRHi6lz+LYJYHoAdNtm0qW77MsisluafXcaFdGDvBtrA8vSdaE
	QA+N+1OZ5ULkzhJsP3BUDIHIY0N4v1oO5gJaINr7Yp4C2Xzf2GGn/PsNrrD9Cc4RhbuYfL
	bigKQPB0vd8FFrhiv9nHhc2Hw8q2P68=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-mRREPKasOAOms7AZ0ZWBPw-1; Tue, 27 Feb 2024 18:21:05 -0500
X-MC-Unique: mRREPKasOAOms7AZ0ZWBPw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DBE585A58E;
	Tue, 27 Feb 2024 23:21:05 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D5472C1596E;
	Tue, 27 Feb 2024 23:21:04 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	isaku.yamahata@intel.com,
	thomas.lendacky@amd.com
Subject: [PATCH 18/21] KVM: x86: Add gmem hook for initializing memory
Date: Tue, 27 Feb 2024 18:20:57 -0500
Message-Id: <20240227232100.478238-19-pbonzini@redhat.com>
In-Reply-To: <20240227232100.478238-1-pbonzini@redhat.com>
References: <20240227232100.478238-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

guest_memfd pages are generally expected to be in some arch-defined
initial state prior to using them for guest memory. For SEV-SNP this
initial state is 'private', or 'guest-owned', and requires additional
operations to move these pages into a 'private' state by updating the
corresponding entries the RMP table.

Allow for an arch-defined hook to handle updates of this sort, and go
ahead and implement one for x86 so KVM implementations like AMD SVM can
register a kvm_x86_ops callback to handle these updates for SEV-SNP
guests.

The preparation callback is always called when allocating/grabbing
folios via gmem, and it is up to the architecture to keep track of
whether or not the pages are already in the expected state (e.g. the RMP
table in the case of SEV-SNP).

In some cases, it is necessary to defer the preparation of the pages to
handle things like in-place encryption of initial guest memory payloads
before marking these pages as 'private'/'guest-owned', so also add a
helper that performs the same function as kvm_gmem_get_pfn(), but allows
for the preparation callback to be bypassed to allow for pages to be
accessed beforehand.

Link: https://lore.kernel.org/lkml/ZLqVdvsF11Ddo7Dq@google.com/
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Message-Id: <20231230172351.574091-5-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/x86.c                 |  6 +++
 include/linux/kvm_host.h           | 14 ++++++
 virt/kvm/Kconfig                   |  4 ++
 virt/kvm/guest_memfd.c             | 72 +++++++++++++++++++++++++++---
 6 files changed, 92 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index ac8b7614e79d..adfaad15e7e6 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -139,6 +139,7 @@ KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
+KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7de8a3f2a118..6d873d08f739 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1804,6 +1804,7 @@ struct kvm_x86_ops {
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
 
 	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
+	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f10a5a617120..eff532ea59c9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13598,6 +13598,12 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
 
+#ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
+int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
+{
+	return static_call(kvm_x86_gmem_prepare)(kvm, pfn, gfn, max_order);
+}
+#endif
 
 int kvm_spec_ctrl_test_value(u64 value)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 97afe4519772..03bf616b7308 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2434,6 +2434,8 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #ifdef CONFIG_KVM_PRIVATE_MEM
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
+int kvm_gmem_get_uninit_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+		            gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
@@ -2442,6 +2444,18 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
 }
+
+static inline int kvm_gmem_get_uninit_pfn(struct kvm *kvm,
+				          struct kvm_memory_slot *slot, gfn_t gfn,
+				          kvm_pfn_t *pfn, int *max_order)
+{
+	KVM_BUG_ON(1, kvm);
+	return -EIO;
+}
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
+#ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
+int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
+#endif
+
 #endif
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index a11e9c80fac9..dcce0c3b5b13 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -111,3 +111,7 @@ config KVM_GENERIC_PRIVATE_MEM
        select KVM_GENERIC_MEMORY_ATTRIBUTES
        select KVM_PRIVATE_MEM
        bool
+
+config HAVE_KVM_GMEM_PREPARE
+       bool
+       depends on KVM_PRIVATE_MEM
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index de0d5a5c210c..7ec7afafc960 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -13,12 +13,50 @@ struct kvm_gmem {
 	struct list_head entry;
 };
 
-static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
+static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct folio *folio)
+{
+#ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
+	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
+	struct kvm_gmem *gmem;
+
+	list_for_each_entry(gmem, gmem_list, entry) {
+		struct kvm_memory_slot *slot;
+		struct kvm *kvm = gmem->kvm;
+		struct page *page;
+		kvm_pfn_t pfn;
+		gfn_t gfn;
+		int rc;
+
+		slot = xa_load(&gmem->bindings, index);
+		if (!slot)
+			continue;
+
+		page = folio_file_page(folio, index);
+		pfn = page_to_pfn(page);
+		gfn = slot->base_gfn + index - slot->gmem.pgoff;
+		rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, compound_order(compound_head(page)));
+		if (rc) {
+			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx, error %d.\n",
+					    index, rc);
+			return rc;
+		}
+	}
+
+#endif
+	return 0;
+}
+
+static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool prepare)
 {
 	struct folio *folio;
+	fgf_t fgp_flags = FGP_LOCK | FGP_ACCESSED | FGP_CREAT;
+
+	if (!prepare)
+		fgp_flags |= FGP_CREAT_ONLY;
 
 	/* TODO: Support huge pages. */
-	folio = filemap_grab_folio(inode->i_mapping, index);
+	folio = __filemap_get_folio(inode->i_mapping, index, fgp_flags,
+				    mapping_gfp_mask(inode->i_mapping));
 	if (IS_ERR_OR_NULL(folio))
 		return folio;
 
@@ -41,6 +79,15 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 		folio_mark_uptodate(folio);
 	}
 
+	if (prepare) {
+		int r =	kvm_gmem_prepare_folio(inode, index, folio);
+		if (r < 0) {
+			folio_unlock(folio);
+			folio_put(folio);
+			return ERR_PTR(r);
+		}
+	}
+
 	/*
 	 * Ignore accessed, referenced, and dirty flags.  The memory is
 	 * unevictable and there is no storage to write back to.
@@ -145,7 +192,7 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 			break;
 		}
 
-		folio = kvm_gmem_get_folio(inode, index);
+		folio = kvm_gmem_get_folio(inode, index, true);
 		if (IS_ERR_OR_NULL(folio)) {
 			r = folio ? PTR_ERR(folio) : -ENOMEM;
 			break;
@@ -482,8 +529,8 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	fput(file);
 }
 
-int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
+static int __kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+		       gfn_t gfn, kvm_pfn_t *pfn, int *max_order, bool prepare)
 {
 	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
 	struct kvm_gmem *gmem;
@@ -503,7 +550,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		goto out_fput;
 	}
 
-	folio = kvm_gmem_get_folio(file_inode(file), index);
+	folio = kvm_gmem_get_folio(file_inode(file), index, prepare);
 	if (!folio) {
 		r = -ENOMEM;
 		goto out_fput;
@@ -529,4 +576,17 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	return r;
 }
+
+int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
+{
+	return __kvm_gmem_get_pfn(kvm, slot, gfn, pfn, max_order, true);
+}
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
+
+int kvm_gmem_get_uninit_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+		            gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
+{
+	return __kvm_gmem_get_pfn(kvm, slot, gfn, pfn, max_order, false);
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_get_uninit_pfn);
-- 
2.39.0



