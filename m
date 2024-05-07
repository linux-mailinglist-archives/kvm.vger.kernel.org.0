Return-Path: <kvm+bounces-16910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 81C9A8BEB2B
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 20:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6F0BB273B7
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2619816DED8;
	Tue,  7 May 2024 18:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QG5DF8P7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A04916D32D
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 18:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715105258; cv=none; b=izkeEg//Am2XCfqQ3tVoi0fKP5VxxZ7qkycfLBqnfM8HJLfcVkdVPMo7dsOOg6tbVpdtaX848VdyRfoYc//f9dlRfLZIXZaoPCrZLoMhBE7c+TgMbBdJ5//RMiPLQxfUGEi3pV5+M1N2NWHef4LtdJ4NrSDujcFhnANOnjT6sC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715105258; c=relaxed/simple;
	bh=kwWzymVAllJk6GhLHE+hHnn6RZc//qTaWBniYDe7nwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q/JsPgXFOLqTrLK3zCMcXuIgLH0YlnxllBY7JVX+wOBZ+G3ckBarGIqiUArqD9jD35uz0u1XPpLsmuUO6/HmMYg6oOz3Sx1p5fkJ9R4GP/UE6DZGPre+rGVLdTi7BzQDaOrrYS8H2oqfwAXDU4yzT375GRlC8VDsGIOtsCZO7nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QG5DF8P7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715105255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0GKDNQVy7zEnmB2eFsd4kv9eYqaNGFJrNTdoEp6X0RE=;
	b=QG5DF8P7FM0fKo6rAUoAj70jI9b/6QgVfVRt03r8seoVRsMdHjDaDb44MjFTSqTBne4DJt
	+RiqNlc4HbGROGn2/VKs9Ym0lvKZBB+Wcho4OHhvKDT7TiGiC5IteycYacMDxla4bAjOZI
	qTtG40IaoFqdFMWPbpPkBfK5HWrSfX4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-538-2HrRYwIfOxqBdOtLdbApjg-1; Tue,
 07 May 2024 14:07:32 -0400
X-MC-Unique: 2HrRYwIfOxqBdOtLdbApjg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7C2E3802AD1;
	Tue,  7 May 2024 18:07:31 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 652A340C6EB7;
	Tue,  7 May 2024 18:07:31 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: vbabka@suse.cz,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	michael.roth@amd.com,
	yilun.xu@intel.com
Subject: [PATCH 5/9] KVM: guest_memfd: Add hook for initializing memory
Date: Tue,  7 May 2024 14:07:25 -0400
Message-ID: <20240507180729.3975856-6-pbonzini@redhat.com>
In-Reply-To: <20240507180729.3975856-1-pbonzini@redhat.com>
References: <20240507180729.3975856-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

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
 arch/x86/kvm/x86.c                 |  6 ++++
 include/linux/kvm_host.h           |  5 +++
 virt/kvm/Kconfig                   |  4 +++
 virt/kvm/guest_memfd.c             | 51 ++++++++++++++++++++++++++++--
 6 files changed, 65 insertions(+), 3 deletions(-)

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
index 9d6368512be6..5562a2443c5c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1814,6 +1814,7 @@ struct kvm_x86_ops {
 
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
index afbc99264ffa..1af069ab657c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2443,4 +2443,9 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
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
index fd32288d0fbc..0176089be731 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -13,7 +13,43 @@ struct kvm_gmem {
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
 
@@ -41,6 +77,15 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
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
@@ -145,7 +190,7 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 			break;
 		}
 
-		folio = kvm_gmem_get_folio(inode, index);
+		folio = kvm_gmem_get_folio(inode, index, true);
 		if (IS_ERR(folio)) {
 			r = PTR_ERR(folio);
 			break;
@@ -505,7 +550,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		goto out_fput;
 	}
 
-	folio = kvm_gmem_get_folio(file_inode(file), index);
+	folio = kvm_gmem_get_folio(file_inode(file), index, true);
 	if (IS_ERR(folio)) {
 		r = PTR_ERR(folio);
 		goto out_fput;
-- 
2.43.0



