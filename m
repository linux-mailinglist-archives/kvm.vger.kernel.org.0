Return-Path: <kvm+bounces-13607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DEFE898E56
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 20:52:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34DB228AA4B
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8D2D12EBDC;
	Thu,  4 Apr 2024 18:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hx+dcR9T"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41012133425
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 18:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712256645; cv=none; b=Q/nar2VbS9lEFH4EuwDOtuXCk9Kc7c59pQhsB1TFlJ6xK0qA9ncsau2QL66n8xB1IShGAIwq5tXqlvJXs6hGNT42pIwrKdBet3Pmd2nVb6MiaPUZ6LgzMluLjBgdTunxB/73mlHz/Zxjo0RmktiQX/OnOMAxE3LIxNzrm875dr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712256645; c=relaxed/simple;
	bh=B3S0LcYTsWFD+kUOBskvthZWdEqFSYGDHrnXM3mb+f4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xu2NPQZSAc7MZVkOcEhOPGnKXKShinjFNDQ3ZvqFYwNA7k2+wPUUpwXLwVu94/ISJaoGNnMLhe9+QNgsmLvaXyXx6oc453y3NZOfwp0kwcaZElHcdytrFkcAkbNUena38CKDrK+T2zZ4PiVqJmyjyq/Xj2woHYPsA0miCK0cDsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hx+dcR9T; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712256641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4+/Ieq4l7FZQ/9j1N8+GqzvijiucWTeDAVP6XMMN/jA=;
	b=Hx+dcR9THa+s/hmu44RWhhnji4Ciz+ajsA8mOdAp47l2dVZ/mfN4F6mFrnPKs0KHKAXj5f
	hGlv4EaeHs+A6/BC5TpzmHHEIEY7UKkkZCNJEEfXr8vh5A0I94QuyKfB17oFp/GdbSrrZ5
	Y7ehQqV4kr31ddMqsuDRTxtlEWS6PFk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-YXh2MNpQN2uul4WBoHbJsQ-1; Thu, 04 Apr 2024 14:50:36 -0400
X-MC-Unique: YXh2MNpQN2uul4WBoHbJsQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 047858007BB;
	Thu,  4 Apr 2024 18:50:36 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D274D1C060A4;
	Thu,  4 Apr 2024 18:50:35 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	isaku.yamahata@intel.com
Subject: [PATCH 06/11] KVM: guest_memfd: Add hook for initializing memory
Date: Thu,  4 Apr 2024 14:50:28 -0400
Message-ID: <20240404185034.3184582-7-pbonzini@redhat.com>
In-Reply-To: <20240404185034.3184582-1-pbonzini@redhat.com>
References: <20240404185034.3184582-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

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
before marking these pages as 'private'/'guest-owned'.  Add an argument
(always true for now) to kvm_gmem_get_folio() that allows for the
preparation callback to be bypassed.  To detect possible issues in
the way userspace initializes memory, it is only possible to add an
unprepared page if it is not already included in the filemap.

Link: https://lore.kernel.org/lkml/ZLqVdvsF11Ddo7Dq@google.com/
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Message-Id: <20231230172351.574091-5-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/x86.c                 |  6 +++
 include/linux/kvm_host.h           |  5 +++
 virt/kvm/Kconfig                   |  4 ++
 virt/kvm/guest_memfd.c             | 65 ++++++++++++++++++++++++++++--
 6 files changed, 78 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 5187fcf4b610..d26fcad13e36 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -139,6 +139,7 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
 KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
+KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 01c69840647e..f101fab0040e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1809,6 +1809,7 @@ struct kvm_x86_ops {
 
 	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
+	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2d2619d3eee4..972524ddcfdb 100644
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
index 48f31dcd318a..33ed3b884a6b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2445,4 +2445,9 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 }
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
+#ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
+int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order);
+bool kvm_arch_gmem_prepare_needed(struct kvm *kvm);
+#endif
+
 #endif
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 29b73eedfe74..ca870157b2ed 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -109,3 +109,7 @@ config KVM_GENERIC_PRIVATE_MEM
        select KVM_GENERIC_MEMORY_ATTRIBUTES
        select KVM_PRIVATE_MEM
        bool
+
+config HAVE_KVM_GMEM_PREPARE
+       bool
+       depends on KVM_PRIVATE_MEM
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index e5b3cd02b651..486748e65f36 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -13,12 +13,60 @@ struct kvm_gmem {
 	struct list_head entry;
 };
 
-static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
+#ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
+bool __weak kvm_arch_gmem_prepare_needed(struct kvm *kvm)
+{
+	return false;
+}
+#endif
+
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
+		if (!kvm_arch_gmem_prepare_needed(kvm))
+			continue;
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
 
@@ -41,6 +89,15 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
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
@@ -145,7 +202,7 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 			break;
 		}
 
-		folio = kvm_gmem_get_folio(inode, index);
+		folio = kvm_gmem_get_folio(inode, index, true);
 		if (IS_ERR_OR_NULL(folio)) {
 			r = folio ? PTR_ERR(folio) : -ENOMEM;
 			break;
@@ -505,7 +562,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		goto out_fput;
 	}
 
-	folio = kvm_gmem_get_folio(file_inode(file), index);
+	folio = kvm_gmem_get_folio(file_inode(file), index, true);
 	if (!folio) {
 		r = -ENOMEM;
 		goto out_fput;
-- 
2.43.0



