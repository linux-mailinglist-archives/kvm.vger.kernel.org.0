Return-Path: <kvm+bounces-22340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4044D93D8A4
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 20:53:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71CF41C209C6
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 18:53:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E655B149E15;
	Fri, 26 Jul 2024 18:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jz1SpS5k"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEFF143C6C
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 18:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722019931; cv=none; b=gZ3eDESv5k/p9GWs2+3HwO45dUsnTh+E5FhX1CwRuCzSt1OlSJpssUS2Fg9oxn6OQkJng+mDK4SAbdHSd5o4q1FllXRFrOAGdWOctlMAkcmNWAUsbwY9slzCDzd+88p2gNs3MeRytpGIOUC8A5t1buuKB5Dvgsi6H9G3CvfRScw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722019931; c=relaxed/simple;
	bh=NDbda/Ay/1xJqArcGx0bked2NGRi+6Ohsay/zZhA/IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=adLQ1LZJuAfhIkL3iwvWx5ARSUtHIEDan34CevXz3EvRTgJUaoSoT91DjSVxjujCl1TYqE9djei/5hugW7rBvJg5whjZ5GRQcRgpkjGjxKd5RD2wjfN5SpbR5xOFnb4T95ydelbxInbfg5yDQjPMFZC1qaTQW30J0X73kDS6ygc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jz1SpS5k; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722019928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ta8n6FT1C8nWR9P2nHAKq1BKuhG6d6FvblCdyS+kHxw=;
	b=Jz1SpS5kKgbMwt6xYUPBeRwCFrlc3zuwx++jEZf//9vlpjVGGCeIchnVMlW6IfqtpUqfYa
	LvEHZ4270YTeMdaz2Kbm3EL8rRYAjxUVgKZ4Ju3fiFzRsutQAggHro/FkKz7AxvijchOw6
	6C6Nfdhi+t4oBdDrPB8WAs/4p1ohJbk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-61-Br-Vhj7bPlei2CGeHRIeOg-1; Fri,
 26 Jul 2024 14:52:03 -0400
X-MC-Unique: Br-Vhj7bPlei2CGeHRIeOg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6EE881955F65;
	Fri, 26 Jul 2024 18:52:02 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 83CEE3000194;
	Fri, 26 Jul 2024 18:52:01 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com
Subject: [PATCH v2 04/14] KVM: guest_memfd: do not go through struct page
Date: Fri, 26 Jul 2024 14:51:47 -0400
Message-ID: <20240726185157.72821-5-pbonzini@redhat.com>
In-Reply-To: <20240726185157.72821-1-pbonzini@redhat.com>
References: <20240726185157.72821-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

We have a perfectly usable folio, use it to retrieve the pfn and order.
All that's needed is a version of folio_file_page that returns a pfn.

Reviewed-by: Michael Roth <michael.roth@amd.com>
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



