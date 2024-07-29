Return-Path: <kvm+bounces-22524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F03493FD90
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 20:41:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22AD2281AEA
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 18:41:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 662CF187324;
	Mon, 29 Jul 2024 18:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gtuLH1gu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337E9189F41
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 18:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722278370; cv=none; b=b0n3c2i1DuMAlw91u8mXh4ltJ0VaC4jGRhapWywpUCsLWXLrOJXa0TxK3H/EuF2Mwh1uzdmfvGYFgOcD1hctplryIaOSZZh6450M050SaK5mqF14EJ2vpXGPdRhtTn5mGYfUfXrET4BQ6jI+ww7KW2EdY049iVtAjygr3PPJ7/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722278370; c=relaxed/simple;
	bh=xk3+KuScjITGXiDzDjfIu4gA/sRyc3tOmEiEhe4VNEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxCRQX3qIE7XfggGwWNh/a074SYfR9HUk9xuxw3V/kRlFlu8OgHooxLpRDplsXGtYnhULOwJpLTDotu+WKuuX+9HHWKswg3rpL3Sjbbl+zLDbqNThcc0A9LHmEwlW59XdMxIQ8NSNOQm0982WmLX+4Op4P7+mZbCZpVec1L2d9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gtuLH1gu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722278368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9H38+PlxDPb0B2kVTxHGHrLppqPJ/7ePtq7mF29j+5Q=;
	b=gtuLH1guRAFD6VquF0kOvqdriPk8Wp2tnEIhxjmIBTfP3P91KqqFXMCvY6t6HJlislkDWi
	4CYFLXVnvymHvdWAtoRtlvNH264r/zLpYmROPOM3I2UZTKDYipFKRMueOUBCTrHX4HIUFg
	EVFvNXzUadnu5SN9PWC2amOJwj8YGm0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-274-TyEAJ39yMBCJknv_CsRGMA-1; Mon,
 29 Jul 2024 14:39:22 -0400
X-MC-Unique: TyEAJ39yMBCJknv_CsRGMA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8C61E19560A1;
	Mon, 29 Jul 2024 18:39:19 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.192.25])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5EF6D1955D42;
	Mon, 29 Jul 2024 18:39:13 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	kvm@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH v1 3/3] s390/uv: drop arch_make_page_accessible()
Date: Mon, 29 Jul 2024 20:38:44 +0200
Message-ID: <20240729183844.388481-4-david@redhat.com>
In-Reply-To: <20240729183844.388481-1-david@redhat.com>
References: <20240729183844.388481-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

All code was converted to using arch_make_folio_accessible(), let's drop
arch_make_page_accessible().

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/include/asm/page.h | 2 --
 arch/s390/kernel/uv.c        | 5 -----
 include/linux/mm.h           | 7 -------
 3 files changed, 14 deletions(-)

diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index 06416b3f94f59..515db8241eb6b 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -176,8 +176,6 @@ static inline int devmem_is_allowed(unsigned long pfn)
 
 int arch_make_folio_accessible(struct folio *folio);
 #define HAVE_ARCH_MAKE_FOLIO_ACCESSIBLE
-int arch_make_page_accessible(struct page *page);
-#define HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
 
 struct vm_layout {
 	unsigned long kaslr_offset;
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 36db065c7cf75..35ed2aea88918 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -548,11 +548,6 @@ int arch_make_folio_accessible(struct folio *folio)
 }
 EXPORT_SYMBOL_GPL(arch_make_folio_accessible);
 
-int arch_make_page_accessible(struct page *page)
-{
-	return arch_make_folio_accessible(page_folio(page));
-}
-EXPORT_SYMBOL_GPL(arch_make_page_accessible);
 static ssize_t uv_query_facilities(struct kobject *kobj,
 				   struct kobj_attribute *attr, char *buf)
 {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index bab689ec77f94..07b478952bb02 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2205,13 +2205,6 @@ static inline bool folio_likely_mapped_shared(struct folio *folio)
 	return atomic_read(&folio->_mapcount) > 0;
 }
 
-#ifndef HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
-static inline int arch_make_page_accessible(struct page *page)
-{
-	return 0;
-}
-#endif
-
 #ifndef HAVE_ARCH_MAKE_FOLIO_ACCESSIBLE
 static inline int arch_make_folio_accessible(struct folio *folio)
 {
-- 
2.45.2


