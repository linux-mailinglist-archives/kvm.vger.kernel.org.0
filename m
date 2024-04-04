Return-Path: <kvm+bounces-13598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C2C2898E48
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 20:51:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 11BD21F2467E
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7DAD1350D8;
	Thu,  4 Apr 2024 18:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CGwbto6/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5213E131BDB
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 18:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712256642; cv=none; b=HRCGHTse9ZznQq6Y2VEFPqNMpM20JAvwiCCiJu7YuafpAlSMBcWg0O09ALYNw99RvU9vx81phrftEp0FCq0YJQr3L9v8EUWPZPrC0MCItV1SRpibJb5BG3B43IYonTMzfvMQY8KnPLi+0IY3s16+lfBx0wXRphJEpXnWrY7ze18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712256642; c=relaxed/simple;
	bh=F9Opcs5Sfjt55zjO6/Xlftcpp0gbWr27hsN6hC6zdq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oIr3Wnnbk+KvMioUtPP1a46Z/9fIeFCj9nt4E0KmS2Oz2kdSiPjinFqFvrYNn73jwPz/E5ZEZHcP+rA5adoh7LL0hngatG2vIFv0VmP5/3sDnh1YO9atfKvfK+ELN/5TQDIbZTIFSvHePZkTabGEfJ+KgvzHOHSP1pdNsfhcIdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CGwbto6/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712256639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IGNOj1ZA+U6rAjLuPpugLuw9vdunQ/dJ6CvoC6KHQIo=;
	b=CGwbto6/ViFZrsOs8kiwksDMkpq634tYwaWX/x7rrKAVIuv7AgNs0IxEPgYbPm822eNBBK
	B8F+9xzUxG4gXhpYyJikGPu7gv/2B5BPciqhj77vQ3OPIdItqTf8TEK9pECdYFkHr9mjhs
	/lMVF3Kq8gGUgHtnBxDruY+TQ7j8+Vk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-4NWzNcSxOBKwgJ5puyVL_Q-1; Thu, 04 Apr 2024 14:50:35 -0400
X-MC-Unique: 4NWzNcSxOBKwgJ5puyVL_Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FEBB85A588;
	Thu,  4 Apr 2024 18:50:35 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 39C4E1C060A4;
	Thu,  4 Apr 2024 18:50:35 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	isaku.yamahata@intel.com
Subject: [PATCH 03/11] KVM: guest_memfd: pass error up from filemap_grab_folio
Date: Thu,  4 Apr 2024 14:50:25 -0400
Message-ID: <20240404185034.3184582-4-pbonzini@redhat.com>
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

Some SNP ioctls will require the page not to be in the pagecache, and as such they
will want to return EEXIST to userspace.  Start by passing the error up from
filemap_grab_folio.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/guest_memfd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 5a929536ecf2..409cf9b51313 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -20,7 +20,7 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	/* TODO: Support huge pages. */
 	folio = filemap_grab_folio(inode->i_mapping, index);
 	if (IS_ERR_OR_NULL(folio))
-		return NULL;
+		return folio;
 
 	/*
 	 * Use the up-to-date flag to track whether or not the memory has been
@@ -146,8 +146,8 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 		}
 
 		folio = kvm_gmem_get_folio(inode, index);
-		if (!folio) {
-			r = -ENOMEM;
+		if (IS_ERR_OR_NULL(folio)) {
+			r = folio ? PTR_ERR(folio) : -ENOMEM;
 			break;
 		}
 
-- 
2.43.0



