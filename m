Return-Path: <kvm+bounces-16906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8C098BEB24
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 20:08:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA23F1C221E0
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9D2C16D4E9;
	Tue,  7 May 2024 18:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EHV4qBW9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C57016C85B
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 18:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715105257; cv=none; b=Uuz/cXZzCkJEB5R1cWkmMMrboNZt8TRVfdRsV7Q4VfjPiaKs+d/I3DmEZVGLxLhYmSeiDFv6mgKbReQ2O8eF4TSXw8mSXurjvuDXpZa3YeiW9mLcRKF+E2l38t/GB7yzlAE3SAI++shhQkrFm5h5fvRi3HGKsrm55LiTBJI/+C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715105257; c=relaxed/simple;
	bh=ncuQ1t7V7AqiuABGSuceVYtvt0SUfikgICT9ePcTLnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F3yrT2bLNpttu+vd84o64rKhJfYm6ZO9hmkd5qlXaIIy+r0ZKcNxcRVPQj7dG0UxlPlWU42VA/WG56RzEbrodBXApcRmiLTug3zSUd5BQEYLzT2ZjfFw98Qd5KmNTlDDVvLz7HgPWTIB+j2zm/S4CspC48ZbtF3uCLtg7x6vkIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EHV4qBW9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715105254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=POOqEjjvAisilBRWkZv/6Psur3AbWbqixz2YRu4q4B8=;
	b=EHV4qBW9aTAtqFoxEKsfT+ndzkuynSAP7XRSOEYHBwKq6F0ApgtChXhUOvbbK0YQEiPLL+
	Z9L1RKsEmtmQH1Q4NPboKBtDNekX1wdLIzikmu1bFVelPUqD75JlO4k/YGP1zlDC+gB64o
	iC0n4Eh2XbK5K6pvfZ2wmWw+G/LqCvE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-663-yZBbjYNhNH6xlKT3EqkXqw-1; Tue,
 07 May 2024 14:07:31 -0400
X-MC-Unique: yZBbjYNhNH6xlKT3EqkXqw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CB793C3D0CB;
	Tue,  7 May 2024 18:07:30 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 216FA40C6EB7;
	Tue,  7 May 2024 18:07:30 +0000 (UTC)
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
	yilun.xu@intel.com,
	Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH 1/9] mm: Introduce AS_INACCESSIBLE for encrypted/confidential memory
Date: Tue,  7 May 2024 14:07:21 -0400
Message-ID: <20240507180729.3975856-2-pbonzini@redhat.com>
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

From: Michael Roth <michael.roth@amd.com>

filemap users like guest_memfd may use page cache pages to
allocate/manage memory that is only intended to be accessed by guests
via hardware protections like encryption. Writes to memory of this sort
in common paths like truncation may cause unexpected behavior such as
writing garbage instead of zeros when attempting to zero pages, or
worse, triggering hardware protections that are considered fatal as far
as the kernel is concerned.

Introduce a new address_space flag, AS_INACCESSIBLE, and use this
initially to prevent zero'ing of pages during truncation, with the
understanding that it is up to the owner of the mapping to handle this
specially if needed.

This is admittedly a rather blunt solution, but it seems like
there are no other places that should take into account the
flag to keep its promise.

Link: https://lore.kernel.org/lkml/ZR9LYhpxTaTk6PJX@google.com/
Cc: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Message-ID: <20240329212444.395559-5-michael.roth@amd.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
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



