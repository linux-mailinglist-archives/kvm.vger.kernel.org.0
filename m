Return-Path: <kvm+bounces-21451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 661B492F1EF
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 00:30:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97A031C2225D
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 22:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8434A1A652B;
	Thu, 11 Jul 2024 22:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GYaXMaz1"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774221A2C03
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 22:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720736890; cv=none; b=XR17dYu3yRRKMAZFWvGigG5p4etJZLytcYovFZJsGMMzGJNyLvH0KlIZTKa+KqkkpFLvSGtefLuJ4gr6EZmovoYoGNZhlIeNXFBLc8sR1Wj/TyU/ymno3T3K8FVeUSfIBGOfAF79r5VJKOzDRtowRXlTvEOaquZ2pYQwO1R+d0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720736890; c=relaxed/simple;
	bh=Ve367pixorBRdOPefjPXUuwrWqmI9xjXUI0HpZqTyLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WfS6nWQVIVaDhRSgx2NR5JBEIoS4vE2aG0A+TPW5vsfXi6zI5ZzMHMmAYzhuJhzata1ZiGzQ2IR/nNTIFI0ZuDteBFfx5mFOz4fmEZwlCUyPJkcFvgIcPAQx4QutK+e44yEgqGGWKFuV1gCCxDXS+dcGskqZO3rpbePrXFSwafE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GYaXMaz1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720736886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GZEoVsxg65CVVTTTaTfnB0vLKsXzsAVAh8awqP2v8tc=;
	b=GYaXMaz17vtAZkfIrUUYnlPa7nYfW8OWkMBAlv1n7Xp9tfJVjdzkVUKtj/U+kTLwwcrrI+
	21iSkYYijOyyY46AL3ptewBYA+PmeMxxvw99ZPYto/LqEauVoDjdfvROgJcLmtASqPvQKQ
	20jnivVT2bstgTjeXIoStcoJ8+MyPEU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-678-arPgLaZTNY2jfzuIKPN2uQ-1; Thu,
 11 Jul 2024 18:28:03 -0400
X-MC-Unique: arPgLaZTNY2jfzuIKPN2uQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 35BB21955D66;
	Thu, 11 Jul 2024 22:28:02 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 71E0919560AE;
	Thu, 11 Jul 2024 22:28:01 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com
Subject: [PATCH 07/12] KVM: guest_memfd: make kvm_gmem_prepare_folio() operate on a single struct kvm
Date: Thu, 11 Jul 2024 18:27:50 -0400
Message-ID: <20240711222755.57476-8-pbonzini@redhat.com>
In-Reply-To: <20240711222755.57476-1-pbonzini@redhat.com>
References: <20240711222755.57476-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

This is now possible because preparation is done by kvm_gmem_get_pfn()
instead of fallocate().  In practice this is not a limitation, because
even though guest_memfd can be bound to multiple struct kvm, for
hardware implementations of confidential computing only one guest
(identified by an ASID on SEV-SNP, or an HKID on TDX) will be able
to access it.

In the case of intra-host migration (not implemented yet for SEV-SNP,
but we can use SEV-ES as an idea of how it will work), the new struct
kvm inherits the same ASID and preparation need not be repeated.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/guest_memfd.c | 47 ++++++++++++++++--------------------------
 1 file changed, 18 insertions(+), 29 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index f637327ad8e1..f4d82719ec19 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -25,37 +25,27 @@ static inline kvm_pfn_t folio_file_pfn(struct folio *folio, pgoff_t index)
 	return folio_pfn(folio) + (index & (folio_nr_pages(folio) - 1));
 }
 
-static int __kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct folio *folio)
+static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
+				    pgoff_t index, struct folio *folio)
 {
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
-	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
-	struct kvm_gmem *gmem;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+	int rc;
 
-	list_for_each_entry(gmem, gmem_list, entry) {
-		struct kvm_memory_slot *slot;
-		struct kvm *kvm = gmem->kvm;
-		kvm_pfn_t pfn;
-		gfn_t gfn;
-		int rc;
+	if (!kvm_arch_gmem_prepare_needed(kvm))
+		return 0;
 
-		if (!kvm_arch_gmem_prepare_needed(kvm))
-			continue;
-
-		slot = xa_load(&gmem->bindings, index);
-		if (!slot)
-			continue;
-
-		pfn = folio_file_pfn(folio, index);
-		gfn = slot->base_gfn + index - slot->gmem.pgoff;
-		rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, folio_order(folio));
-		if (rc) {
-			pr_warn_ratelimited("gmem: Failed to prepare folio for GFN %llx PFN %llx error %d.\n",
-					    gfn, pfn, rc);
-			return rc;
-		}
+	pfn = folio_file_pfn(folio, index);
+	gfn = slot->base_gfn + index - slot->gmem.pgoff;
+	rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, folio_order(folio));
+	if (rc) {
+		pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN %llx PFN %llx error %d.\n",
+				    index, gfn, pfn, rc);
+		return rc;
 	}
-
 #endif
+
 	return 0;
 }
 
@@ -63,7 +53,7 @@ static int __kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct f
  * so that the guest can use it.  On successful return the guest sees a zero
  * page so as to avoid leaking host data and the up-to-date flag is set.
  */
-static int kvm_gmem_prepare_folio(struct file *file, struct kvm_memory_slot *slot,
+static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 				  gfn_t gfn, struct folio *folio)
 {
 	unsigned long nr_pages, i;
@@ -92,8 +82,7 @@ static int kvm_gmem_prepare_folio(struct file *file, struct kvm_memory_slot *slo
 	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));
 	index = gfn - slot->base_gfn + slot->gmem.pgoff;
 	index = ALIGN_DOWN(index, 1 << folio_order(folio));
-
-	r = __kvm_gmem_prepare_folio(file_inode(file), index, folio);
+	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
 	if (!r)
 		folio_mark_uptodate(folio);
 
@@ -616,7 +605,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		goto out;
 	}
 
-	r = kvm_gmem_prepare_folio(file, slot, gfn, folio);
+	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
 	folio_unlock(folio);
 	if (r < 0)
 		folio_put(folio);
-- 
2.43.0



