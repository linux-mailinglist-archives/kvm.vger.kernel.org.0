Return-Path: <kvm+bounces-16908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F4EB8BEB27
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 20:08:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F68B1F22373
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 938B316D9CA;
	Tue,  7 May 2024 18:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WwUrNBs+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE7216D325
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 18:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715105257; cv=none; b=SiNW29TMf+IiHmVZ0rOHjYpxHkUMwdQaXViRdzUozmGEdBSbYt1BuZVlH7QrhnY18Geo3DKAdzMJ4mF52DZRn9FxzOW4FTxPUr/uam1KHbIhONrzsGGVzVhWICH3ghw7KuPXwkfhKUB64EbK3JtpzLCeOOMaliONGVeN3pt4NxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715105257; c=relaxed/simple;
	bh=4FD3tqr2t4IpN6Mf9tAY2Lg2qs/GATirslBpU8gtVWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xepv+wmNnlRIMiwLxELo3M5DamxiQKqKD28fDkxzlzEpsiqAOhK7JgfeZ+GdkOGjiiD5x6Helj36NPp/AL5Se8SIns8aIx8npzy4gZm5Y5Z/qeGo5URG+GKBfyI6jv7mUrcP9JhkTvFEnynLNdrrJI3UiVQgsrZSgZ/YJVfWL2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WwUrNBs+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715105255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=84S9YTb1A848Gfhc9IGVmnU4na6DpJYIQ4q1jmZ4h+M=;
	b=WwUrNBs+N/VJNMuoKVG6QDT0z3ImIrBXu7w6kdZxoFLmxYRvfT1/0Zrhw5McqbDsc55ash
	9lCep2ajIvRIIzxZovJcV9HUBy/Jb+2JdFyMo42yJwFaP2VOR8pX8kBGkyQqSoOld/m7+X
	AVSJWEoKzO0m0GZ3ic6z/2ffiY7YcQc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-532-gU33u87IPlu7g6xAckBFPA-1; Tue,
 07 May 2024 14:07:31 -0400
X-MC-Unique: gU33u87IPlu7g6xAckBFPA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 124BF1C4C3EB;
	Tue,  7 May 2024 18:07:31 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C5FA240C6EB7;
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
	yilun.xu@intel.com
Subject: [PATCH 3/9] KVM: guest_memfd: pass error up from filemap_grab_folio
Date: Tue,  7 May 2024 14:07:23 -0400
Message-ID: <20240507180729.3975856-4-pbonzini@redhat.com>
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

Some SNP ioctls will require the page not to be in the pagecache, and as such they
will want to return EEXIST to userspace.  Start by passing the error up from
filemap_grab_folio.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/guest_memfd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 5a929536ecf2..c27828b0d42d 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -19,8 +19,8 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 
 	/* TODO: Support huge pages. */
 	folio = filemap_grab_folio(inode->i_mapping, index);
-	if (IS_ERR_OR_NULL(folio))
-		return NULL;
+	if (IS_ERR(folio))
+		return folio;
 
 	/*
 	 * Use the up-to-date flag to track whether or not the memory has been
@@ -146,8 +146,8 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 		}
 
 		folio = kvm_gmem_get_folio(inode, index);
-		if (!folio) {
-			r = -ENOMEM;
+		if (IS_ERR(folio)) {
+			r = PTR_ERR(folio);
 			break;
 		}
 
@@ -505,8 +505,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	}
 
 	folio = kvm_gmem_get_folio(file_inode(file), index);
-	if (!folio) {
-		r = -ENOMEM;
+	if (IS_ERR(folio)) {
+		r = PTR_ERR(folio);
 		goto out_fput;
 	}
 
-- 
2.43.0



