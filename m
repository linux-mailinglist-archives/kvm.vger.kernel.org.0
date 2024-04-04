Return-Path: <kvm+bounces-13604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AC65898E50
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 20:52:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F86728A99F
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:52:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA6711386C6;
	Thu,  4 Apr 2024 18:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a0aZuJ02"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B7F1332A7
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 18:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712256644; cv=none; b=Vbxao7w+Hfz0s2N0FA0vwU7JdfYdJEuFmAX+H1/SvJI0Lh68Ngl7ntXLK4SGEogW33HfW3+MHEeiw5ZlwBi226gHI8DFnjVpcVtrX/b6bq7FHuz/RSlPFyRuH4PQwyfRr1ensC4gtqbBUR2WMmvp+rub3VHo/joDjVz7ibLoZss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712256644; c=relaxed/simple;
	bh=VbgH6uZaEHHyV8AL0EthlfR7wtEenAYOlnIUsv2wVH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FJZ+7NnAcKt57Obe8qztcFaP1bJZc4s4eEvEMyDpcenQDZdVoWx8z3L13bdoinTle6takilQvE7NjyGUBOvFN10YYKDuNyGH/FufEJP8+QhtUDtT9NhuNbLcFr5UMqbgbH8ig1i0LgubEPyiSIgOyvMAp551T1wWZhPnPbOA7x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a0aZuJ02; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712256640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K+P0fAcIDgRo831gUWKyfWbrgU4oYVbYxE0Ac1b196I=;
	b=a0aZuJ020nd4CZAouQuurVF7TmhaAifHGyqcvQ2dUva7cm/FwQZONnu491cm6wDgmxiw7N
	ZKthykuyVCDy1GAwGti3atursIg2I4gd8rWEr152Jy8vfFPZMt/9q2nrFZykrFg2rgADEH
	6MQ7FtDUWGEiDl5aAVExsxtgtzcqp28=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-232-3pSD-D3-MhqNQ8Jx0YD62w-1; Thu, 04 Apr 2024 14:50:36 -0400
X-MC-Unique: 3pSD-D3-MhqNQ8Jx0YD62w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9988985CE41;
	Thu,  4 Apr 2024 18:50:35 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 687EE1C060A4;
	Thu,  4 Apr 2024 18:50:35 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	isaku.yamahata@intel.com,
	Matthew Wilcox <willy@infradead.org>,
	Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH 04/11] filemap: add FGP_CREAT_ONLY
Date: Thu,  4 Apr 2024 14:50:26 -0400
Message-ID: <20240404185034.3184582-5-pbonzini@redhat.com>
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

KVM would like to add a ioctl to encrypt and install a page into private
memory (i.e. into a guest_memfd), in preparation for launching an
encrypted guest.

This API should be used only once per page (unless there are failures),
so we want to rule out the possibility of operating on a page that is
already in the guest_memfd's filemap.  Overwriting the page is almost
certainly a sign of a bug, so we might as well forbid it.

Therefore, introduce a new flag for __filemap_get_folio (to be passed
together with FGP_CREAT) that allows *adding* a new page to the filemap
but not returning an existing one.

An alternative possibility would be to force KVM users to initialize
the whole filemap in one go, but that is complicated by the fact that
the filemap includes pages of different kinds, including some that are
per-vCPU rather than per-VM.  Basically the result would be closer to
a system call that multiplexes multiple ioctls, than to something
cleaner like readv/writev.

Races between callers that pass FGP_CREAT_ONLY are uninteresting to
the filemap code: one of the racers wins and one fails with EEXIST,
similar to calling open(2) with O_CREAT|O_EXCL.  It doesn't matter to
filemap.c if the missing synchronization is in the kernel or in userspace,
and in fact it could even be intentional.  (In the case of KVM it turns
out that a mutex is taken around these calls for unrelated reasons,
so there can be no races.)

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 include/linux/pagemap.h | 2 ++
 mm/filemap.c            | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index f879c1d54da7..a8c0685e8c08 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -587,6 +587,7 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
  * * %FGP_CREAT - If no folio is present then a new folio is allocated,
  *   added to the page cache and the VM's LRU list.  The folio is
  *   returned locked.
+ * * %FGP_CREAT_ONLY - Fail if a folio is present
  * * %FGP_FOR_MMAP - The caller wants to do its own locking dance if the
  *   folio is already in cache.  If the folio was allocated, unlock it
  *   before returning so the caller can do the same dance.
@@ -607,6 +608,7 @@ typedef unsigned int __bitwise fgf_t;
 #define FGP_NOWAIT		((__force fgf_t)0x00000020)
 #define FGP_FOR_MMAP		((__force fgf_t)0x00000040)
 #define FGP_STABLE		((__force fgf_t)0x00000080)
+#define FGP_CREAT_ONLY		((__force fgf_t)0x00000100)
 #define FGF_GET_ORDER(fgf)	(((__force unsigned)fgf) >> 26)	/* top 6 bits */
 
 #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
diff --git a/mm/filemap.c b/mm/filemap.c
index 7437b2bd75c1..e7440e189ebd 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1863,6 +1863,10 @@ struct folio *__filemap_get_folio(struct address_space *mapping, pgoff_t index,
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
2.43.0



