Return-Path: <kvm+bounces-19305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD258903880
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 12:13:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC9611C232F9
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 10:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E21DD17839A;
	Tue, 11 Jun 2024 10:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ETbSpJed"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAB2174EE2
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 10:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718100832; cv=none; b=dS4+TgOQNfhXB7M1xqzv9FTamHYYE24bb0UT8Vo98wRh6/iIcCKnmhSMif0tN0p77MK+lLyGUT4gdILrB1r/8cGQAe4PLSiUMpzvbwDvj95jxI326hvSF1yHEj9B8QOlg3GjVhpLM4K26bLvbOY6fhnOIJMT6QByuYbjzzggqTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718100832; c=relaxed/simple;
	bh=e91cTJatErGbekBWqz/uJfJ12erNRYVk96MmOGDg5qo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=owSM4Xag6jg1dnshoxX9nMT6EeCgrsmi3tpC+tmKT5kkLQlizKEvqMsPEm7fJKaATBEDIRgfM76HRijzai65q6zqjJWXi8FTa9eT56+9tcabAe6mfYPClCZoAo3zgy/c3bL4JWjrcprKrUDOT04eyQb44GXOzPdXBCIED9Lwsac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ETbSpJed; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718100829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6VhMwq6IV8ojsetECI+veTLijBZyD+BQ/+V7gyTzsOM=;
	b=ETbSpJedrzqBGrWBS+rSJhuE54nQ3WFFqXzsjnushhz62RmoAKANsWGRWw/6lopPg2VrBK
	kdywAKR6KQzQZPVIAHB9f5sAOw14OSMG8DbyeAfnejmT2K7aUz6tTG2T1Doh4VfZ7W3dqk
	eAbRCDgrcwEwPAJPvCXgH+G5hJNRHRw=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-358-UvMBWYR4OwK4leQOJdabBg-1; Tue,
 11 Jun 2024 06:13:47 -0400
X-MC-Unique: UvMBWYR4OwK4leQOJdabBg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DBE5C19560B0;
	Tue, 11 Jun 2024 10:13:46 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 609DF30000C4;
	Tue, 11 Jun 2024 10:13:46 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] virt: guest_memfd: fix reference leak on hwpoisoned page
Date: Tue, 11 Jun 2024 06:13:45 -0400
Message-ID: <20240611101345.42233-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

If __kvm_gmem_get_pfn() detects an hwpoisoned page, it returns -EHWPOISON
but it does not put back the reference that kvm_gmem_get_folio() had
grabbed.  Move the whole check to kvm_gmem_get_folio(), via an __-prefixed
function.  This removes a "goto" and simplifies the code.

Now even fallocate() is prevented from picking an hwpoisoned page successfully.
This is temporary until the page allocation flow is cleaned up.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/guest_memfd.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9714add38852..53742ec34a31 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -49,7 +49,7 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
 	return 0;
 }
 
-static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool prepare)
+static struct folio *__kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 {
 	struct folio *folio;
 
@@ -58,6 +58,19 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool
 	if (IS_ERR(folio))
 		return folio;
 
+	if (folio_test_hwpoison(folio)) {
+		folio_unlock(folio);
+		folio_put(folio);
+		folio = ERR_PTR(-EHWPOISON);
+	}
+
+	return folio;
+}
+
+static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool prepare)
+{
+	struct folio *folio = __kvm_gmem_get_folio(inode, index);
+
 	/*
 	 * Use the up-to-date flag to track whether or not the memory has been
 	 * zeroed before being handed off to the guest.  There is no backing
@@ -549,7 +562,6 @@ static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 	struct kvm_gmem *gmem = file->private_data;
 	struct folio *folio;
 	struct page *page;
-	int r;
 
 	if (file != slot->gmem.file) {
 		WARN_ON_ONCE(slot->gmem.file);
@@ -566,23 +578,14 @@ static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
 
-	if (folio_test_hwpoison(folio)) {
-		r = -EHWPOISON;
-		goto out_unlock;
-	}
-
 	page = folio_file_page(folio, index);
 
 	*pfn = page_to_pfn(page);
 	if (max_order)
 		*max_order = 0;
 
-	r = 0;
-
-out_unlock:
 	folio_unlock(folio);
-
-	return r;
+	return 0;
 }
 
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-- 
2.43.0


