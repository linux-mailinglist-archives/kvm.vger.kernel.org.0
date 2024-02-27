Return-Path: <kvm+bounces-10157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 886EB86A399
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 00:30:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57FBAB2DA68
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 23:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5123A59B4D;
	Tue, 27 Feb 2024 23:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S+inPmar"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7EB57866
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 23:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709076071; cv=none; b=e+PHs/ahm53CVkd2rmF0j3z+Ohry8bLXI2U5BGf6rJfJ6EQde1kQof3oZt6mnigjGAFKcpeEXdSzfBHU1+qKAj7/ih4F8plggTPvzmmaZHtbWqQTTbbRZln36Oz3fLRG7NP78z9SL/476pOyCbLSagJOMeXO2QJCVWhe1DQ28Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709076071; c=relaxed/simple;
	bh=KY7Vtiin2PBxkQCqTTa5Z5E0FoYbvkUJVSGQWBSa3os=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hyRTGYxRQpZXjLNHv/SuL4YUJVTA3VGUJAX1oxowqDdRWpxkekEn9aeWXOi3xbVAxJZAfVmUzf+LbEscQT6aqRwfR8bv+kE5txQGBXkQa25T7r7abO2jbr1cL6ShkR8sAwfrMbl/SgyFrScGAg7mNmetdbR1xEQF295KGaLTGvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S+inPmar; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709076067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BG4ZL+4+5uPAuYv+ozkJ6gsYKFZe75rDBIaL5MNApAs=;
	b=S+inPmar82UGzsy/pzFbf2sT8rDtf7brfY0qcCjrsumUAqDkYa3+zZZ3nqxM2HTBMmwRgu
	l4jfoVb1hLd/jHvTRz1cmtGm/yGzhqBVdVEJ/kSzCyse/aXzkW1VDdgi9e6BWAzgs6p5qI
	j3pw3+drMoJamioyaDvwJHl7z5cWvmU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-90-mamPH8I0Pzi2AWxQuplGCw-1; Tue,
 27 Feb 2024 18:21:05 -0500
X-MC-Unique: mamPH8I0Pzi2AWxQuplGCw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD66D1E441C3;
	Tue, 27 Feb 2024 23:21:04 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A1441C0348F;
	Tue, 27 Feb 2024 23:21:04 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	isaku.yamahata@intel.com,
	thomas.lendacky@amd.com
Subject: [PATCH 17/21] filemap: add FGP_CREAT_ONLY
Date: Tue, 27 Feb 2024 18:20:56 -0500
Message-Id: <20240227232100.478238-18-pbonzini@redhat.com>
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

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/pagemap.h | 2 ++
 mm/filemap.c            | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 2df35e65557d..e8ac0b32f84d 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -586,6 +586,7 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
  * * %FGP_CREAT - If no folio is present then a new folio is allocated,
  *   added to the page cache and the VM's LRU list.  The folio is
  *   returned locked.
+ * * %FGP_CREAT_ONLY - Fail if a folio is not present
  * * %FGP_FOR_MMAP - The caller wants to do its own locking dance if the
  *   folio is already in cache.  If the folio was allocated, unlock it
  *   before returning so the caller can do the same dance.
@@ -606,6 +607,7 @@ typedef unsigned int __bitwise fgf_t;
 #define FGP_NOWAIT		((__force fgf_t)0x00000020)
 #define FGP_FOR_MMAP		((__force fgf_t)0x00000040)
 #define FGP_STABLE		((__force fgf_t)0x00000080)
+#define FGP_CREAT_ONLY		((__force fgf_t)0x00000100)
 #define FGF_GET_ORDER(fgf)	(((__force unsigned)fgf) >> 26)	/* top 6 bits */
 
 #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
diff --git a/mm/filemap.c b/mm/filemap.c
index 750e779c23db..d5107bd0cd09 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1854,6 +1854,10 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
 		folio = NULL;
 	if (!folio)
 		goto no_page;
+	if (fgp_flags & FGP_CREAT_ONLY) {
+		folio_put(folio);
+		return ERR_PTR(-EEXIST);
+	}
 
 	if (fgp_flags & FGP_LOCK) {
 		if (fgp_flags & FGP_NOWAIT) {
-- 
2.39.0



