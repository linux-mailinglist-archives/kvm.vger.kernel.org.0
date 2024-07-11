Return-Path: <kvm+bounces-21445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18C4492F1E4
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 00:29:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3CD1284068
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 22:29:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7B361A2FA9;
	Thu, 11 Jul 2024 22:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K9qLzK8J"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547251A254E
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 22:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720736887; cv=none; b=It50SGEeeKFM+oo47TABkqup9MrKi5yGkwq0lB1xTUhjMVksxrlMjH64CgrNUg5VDYgoESPyXr9S1tIbnmoS+T3SYO1wxiSlXX8hW5rFb4jbpllvO7yORF+U1XYHPIE/9Gt1weqotsD/SocZPG40OzPYOIw1GJsNkR4h/mcWGeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720736887; c=relaxed/simple;
	bh=c6++jZ9Vq4mbxWHs/E5s5/t2TpDV/B7uGsl8FnP9omE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uRhGbjwDahEKp4EhngU5e6U77Lf2kT5PCzpRWKwjr1/s5DG4Hvpi8AP6O6MICJg2oEe75/9/8EJ4HyxyHHl5YPO0bHx+ctePnU4806f6TLRPTnJAUQOlookx4TCW9knqVo/YAT4Uw12vxl/yrEFUX9xii6sVwS0MbMGJFULKtI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K9qLzK8J; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720736885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cBzkcMlAqM2DYy44QBoHHnpRLCW6Bwp/3x9Z7IIRW1Y=;
	b=K9qLzK8JMlsql/wIlHmK1kZBW8IwxVzHpF/uUOX7nO19F6hsbDtlH/Ui3JefTQkfzPUwo9
	gk42AX6PsS1W0ekwGfGhoKAR2eVd+sPPUziZ17PEBi/VCAPDawRaNPUC1k24V0w74Ddzf7
	/l3ZxldeKZlMMnF4DLsviw1wRwekDFA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-48-GP78KJSDONmgZ3_h1VhNlg-1; Thu,
 11 Jul 2024 18:28:00 -0400
X-MC-Unique: GP78KJSDONmgZ3_h1VhNlg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5A38B19560AA;
	Thu, 11 Jul 2024 22:27:59 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7013B1956046;
	Thu, 11 Jul 2024 22:27:58 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com
Subject: [PATCH 03/12] KVM: guest_memfd: do not go through struct page
Date: Thu, 11 Jul 2024 18:27:46 -0400
Message-ID: <20240711222755.57476-4-pbonzini@redhat.com>
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

We have a perfectly usable folio, use it to retrieve the pfn and order.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/guest_memfd.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 1ea632dbae57..5221b584288f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -13,6 +13,18 @@ struct kvm_gmem {
 	struct list_head entry;
 };
 
+/**
+ * folio_file_pfn - like folio_file_page, but return a pfn.
+ * @folio: The folio which contains this index.
+ * @index: The index we want to look up.
+ *
+ * Return: The pfn for this index.
+ */
+static inline kvm_pfn_t folio_file_pfn(struct folio *folio, pgoff_t index)
+{
+	return folio_pfn(folio) + (index & (folio_nr_pages(folio) - 1));
+}
+
 static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct folio *folio)
 {
 #ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
@@ -22,7 +34,6 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
 	list_for_each_entry(gmem, gmem_list, entry) {
 		struct kvm_memory_slot *slot;
 		struct kvm *kvm = gmem->kvm;
-		struct page *page;
 		kvm_pfn_t pfn;
 		gfn_t gfn;
 		int rc;
@@ -34,13 +45,12 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
 		if (!slot)
 			continue;
 
-		page = folio_file_page(folio, index);
-		pfn = page_to_pfn(page);
+		pfn = folio_file_pfn(folio, index);
 		gfn = slot->base_gfn + index - slot->gmem.pgoff;
-		rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, compound_order(compound_head(page)));
+		rc = kvm_arch_gmem_prepare(kvm, gfn, pfn, folio_order(folio));
 		if (rc) {
-			pr_warn_ratelimited("gmem: Failed to prepare folio for index %lx GFN %llx PFN %llx error %d.\n",
-					    index, gfn, pfn, rc);
+			pr_warn_ratelimited("gmem: Failed to prepare folio for GFN %llx PFN %llx error %d.\n",
+					    gfn, pfn, rc);
 			return rc;
 		}
 	}
@@ -548,7 +558,6 @@ __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
 	struct kvm_gmem *gmem = file->private_data;
 	struct folio *folio;
-	struct page *page;
 
 	if (file != slot->gmem.file) {
 		WARN_ON_ONCE(slot->gmem.file);
@@ -571,9 +580,7 @@ __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 		return ERR_PTR(-EHWPOISON);
 	}
 
-	page = folio_file_page(folio, index);
-
-	*pfn = page_to_pfn(page);
+	*pfn = folio_file_pfn(folio, index);
 	if (max_order)
 		*max_order = 0;
 
-- 
2.43.0



