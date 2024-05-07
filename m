Return-Path: <kvm+bounces-16912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BC2548BEB2F
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 20:09:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4911AB277CC
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0240A16EC01;
	Tue,  7 May 2024 18:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XozMcnGr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681A916D31A
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 18:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715105259; cv=none; b=oyQZtHDPh38cHh1YSVpSpa8F5pN9askfZQWY2EEpzkAdjFipQJzM3aGn5yNlks2yRIVmiTwKjVmZF9o2C+QTgMs8itCvc3zWsZRYpMa6jZZ0SM7aZaZA8BH4xoucT9ItrELfnTaUMPvOiltH9/bgAN4WF+/4dVhkdKq6HKqrrro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715105259; c=relaxed/simple;
	bh=jvqvn+8mocOHRHNhWwM9lYAjWgSVkEtH4f321YwzVPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kyztsJrvxb5Kvk3ncSpMtqkCM3r6XMz5Aegf9ZJMb6NBVuV5Jd21HSUE1H329nYIRw0LM6CkyjpHFnH7KiDZNv8kPYBvCWD3P4zCgskuFG/vZeQP8YE4vOFzvQUDAuol9sQPvwVEYd6tD77sYdftt5ystv4WX5ztcFhXjvnQ81E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XozMcnGr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715105255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iJo566QBGqWzWWdhoS3/FTnwQOx8annMHtRX1QpbOmc=;
	b=XozMcnGrisAusLX3jLvdnvc8WNSii532/JtdUtoIdDa9I87BpIEE3gk9OaAG7zeGhYDnNu
	ifSE9uDzhm0BcsSnVJh7M9DCOxnPHGBBiQ5GEQxd/jrCGOui2bIcHwB9CyddeGvPiQjby6
	6U20b+ttJWayVq71sEtfvutPmqAARpE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-572-4HGfDG3FOxys7MugJCTPpQ-1; Tue, 07 May 2024 14:07:32 -0400
X-MC-Unique: 4HGfDG3FOxys7MugJCTPpQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE924101A54F;
	Tue,  7 May 2024 18:07:31 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AE44B40C6EB7;
	Tue,  7 May 2024 18:07:31 +0000 (UTC)
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
Subject: [PATCH 6/9] KVM: guest_memfd: extract __kvm_gmem_get_pfn()
Date: Tue,  7 May 2024 14:07:26 -0400
Message-ID: <20240507180729.3975856-7-pbonzini@redhat.com>
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

In preparation for adding a function that walks a set of pages
provided by userspace and populates them in a guest_memfd,
add a version of kvm_gmem_get_pfn() that has a "bool prepare"
argument and passes it down to kvm_gmem_get_folio().

Populating guest memory has to call repeatedly __kvm_gmem_get_pfn()
on the same file, so make the new function take struct file*.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/guest_memfd.c | 40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 0176089be731..bfe437098b79 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -528,33 +528,29 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 	fput(file);
 }
 
-int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
+static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
+		       gfn_t gfn, kvm_pfn_t *pfn, int *max_order, bool prepare)
 {
 	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
-	struct kvm_gmem *gmem;
+	struct kvm_gmem *gmem = file->private_data;
 	struct folio *folio;
 	struct page *page;
-	struct file *file;
 	int r;
 
-	file = kvm_gmem_get_file(slot);
-	if (!file)
+	if (file != slot->gmem.file) {
+		WARN_ON_ONCE(slot->gmem.file);
 		return -EFAULT;
+	}
 
 	gmem = file->private_data;
-
 	if (xa_load(&gmem->bindings, index) != slot) {
 		WARN_ON_ONCE(xa_load(&gmem->bindings, index));
-		r = -EIO;
-		goto out_fput;
+		return -EIO;
 	}
 
-	folio = kvm_gmem_get_folio(file_inode(file), index, true);
-	if (IS_ERR(folio)) {
-		r = PTR_ERR(folio);
-		goto out_fput;
-	}
+	folio = kvm_gmem_get_folio(file_inode(file), index, prepare);
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
 
 	if (folio_test_hwpoison(folio)) {
 		r = -EHWPOISON;
@@ -571,9 +567,21 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 out_unlock:
 	folio_unlock(folio);
-out_fput:
-	fput(file);
 
 	return r;
 }
+
+int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
+{
+	struct file *file = kvm_gmem_get_file(slot);
+	int r;
+
+	if (!file)
+		return -EFAULT;
+
+	r = __kvm_gmem_get_pfn(file, slot, gfn, pfn, max_order, true);
+	fput(file);
+	return r;
+}
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
-- 
2.43.0



