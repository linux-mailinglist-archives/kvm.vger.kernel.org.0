Return-Path: <kvm+bounces-13605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A146898E54
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 20:52:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D219BB22F47
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B76013BACF;
	Thu,  4 Apr 2024 18:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CfnOe289"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6705F134436
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 18:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712256645; cv=none; b=nBFqzFZ06mOWMq/fXv0aX1hk+mXh0jR30KdRlYUtH3vBZXWhFCNTaNUdXr/R2SF70aPoTiNzQ4JVexI8QMmW1RZG4gHTEyzxvElqhQSkVnrLNNqbwacoRh3SzuuYG8n0JO4568L3fMt/WqWUIKR6dPDCwJ2Q1eKwPnoJk4cp1kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712256645; c=relaxed/simple;
	bh=xLRvqZBxE8nyyslPqQaHeAePgGUJ5/dbiqlvXpYDL9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TQrVHDX7y7iAzpKqer729AJ3DODaUmgS8npqpXnbOyZzW00HqpsvJBhz7imrkwbjzhc2euQhxVeXAW3ejIfA2su30li37US4JRJGMAOcBubF7tB45jp736MC+ibhGXIOJo1IzpbZVcBjyIHpe+77S20f8cbPXw41euLg5iMu8vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CfnOe289; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712256642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4MThrRX4woKvTXfjRRP0DuefjayuTL5Cbh2ShiuiO1E=;
	b=CfnOe289nTBPc1YZ4qGuB9OerjlXdfomrfr/A5bHjMTAOB8wkFu/jY6m++vV/ifxQXQpYg
	58lQGNT/QomQ5QDK04mjCqsqUrN43gbTdnGmdaXUk6jb92qltW414lw84dqvFfvkFgKgzR
	vRbl+s25kkk36Fv7+o5XGEWHmKXW/Rs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-12-ZHOW8xWvPXKhmDMMj-J8PA-1; Thu,
 04 Apr 2024 14:50:35 -0400
X-MC-Unique: ZHOW8xWvPXKhmDMMj-J8PA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 034981C0F2E0;
	Thu,  4 Apr 2024 18:50:35 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CBC861C060A4;
	Thu,  4 Apr 2024 18:50:34 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	isaku.yamahata@intel.com,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 01/11] mm: Introduce AS_INACCESSIBLE for encrypted/confidential memory
Date: Thu,  4 Apr 2024 14:50:23 -0400
Message-ID: <20240404185034.3184582-2-pbonzini@redhat.com>
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

From: Michael Roth <michael.roth@amd.com>

filemap users like guest_memfd may use page cache pages to
allocate/manage memory that is only intended to be accessed by guests
via hardware protections like encryption. Writes to memory of this sort
in common paths like truncation may cause unexpected behavior such
writing garbage instead of zeros when attempting to zero pages, or
worse, triggering hardware protections that are considered fatal as far
as the kernel is concerned.

Introduce a new address_space flag, AS_INACCESSIBLE, and use this
initially to prevent zero'ing of pages during truncation, with the
understanding that it is up to the owner of the mapping to handle this
specially if needed.

Link: https://lore.kernel.org/lkml/ZR9LYhpxTaTk6PJX@google.com/
Cc: Matthew Wilcox <willy@infradead.org>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Message-ID: <20240329212444.395559-5-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/pagemap.h | 1 +
 mm/truncate.c           | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 2df35e65557d..f879c1d54da7 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -207,6 +207,7 @@ enum mapping_flags {
 	AS_STABLE_WRITES,	/* must wait for writeback before modifying
 				   folio contents */
 	AS_UNMOVABLE,		/* The mapping cannot be moved, ever */
+	AS_INACCESSIBLE,	/* Do not attempt direct R/W access to the mapping */
 };
 
 /**
diff --git a/mm/truncate.c b/mm/truncate.c
index 725b150e47ac..c501338c7ebd 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -233,7 +233,8 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
 	 * doing a complex calculation here, and then doing the zeroing
 	 * anyway if the page split fails.
 	 */
-	folio_zero_range(folio, offset, length);
+	if (!(folio->mapping->flags & AS_INACCESSIBLE))
+		folio_zero_range(folio, offset, length);
 
 	if (folio_has_private(folio))
 		folio_invalidate(folio, offset, length);
-- 
2.43.0



