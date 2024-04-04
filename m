Return-Path: <kvm+bounces-13606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8643898E53
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 20:52:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 711A628AA7D
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7165D13BADA;
	Thu,  4 Apr 2024 18:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hvPvBNkc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCE613440C
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 18:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712256645; cv=none; b=qKvWeHHrGOCmnqpHXrO+HwV2y4XIRY/FDMxezSw5RuJELY6S3N+a7E9qZZoZ9FvzNsVjXPYv+PsKvcIkJDLRC/Vt1+zukctWLuOFAHrPd19AYZ/7NOBRECxKkLi5mN4SrjDBJs7LmmxmYJQFoM5nLerd0U36qeSAlsJM/b6YJ+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712256645; c=relaxed/simple;
	bh=jdNIfZWZvPJII98ywtATikTD6VDJZQYwABwABAMUGS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nQ8rO6U4ThhWQrGeYWpynM6FzlJ6tjLNagYsVcT7es/r6bgTOhZt3r9I2N/bZZHKCERfhZfIR6jTLv5l3OBKDLbKpD/VQHZJqWa5dCCVaMLMx+XQXGwLHhTrkDJ4new800bZ4xVK7/47AjTjwu9Cwd6Z28WRJnWX77prjDBUVYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hvPvBNkc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712256642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JFajdk4fDiyh8VxZ37SkZXsZFlO1RmoQzZVvkfEWg0k=;
	b=hvPvBNkc5oZFwi8mSdmNZJsdkqYq/IBy+w6KonJPl0CF2EaBdHVVEd8Z3Ly8+L7ZqwTHVw
	z+OT76BoWJT6fs4aDR4Fjlr6g0X1ALnijbr3nkq/Rebqztga6PvgcRqOFJjo1pcdeFiP4O
	PWjZ1OE/t6+czWbnRHDW6JcFJLrzRq4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-64-rFD63vFJMpWHpRDgCAYm6Q-1; Thu,
 04 Apr 2024 14:50:36 -0400
X-MC-Unique: rFD63vFJMpWHpRDgCAYm6Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6107728B7402;
	Thu,  4 Apr 2024 18:50:36 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3B46D1C060A4;
	Thu,  4 Apr 2024 18:50:36 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	isaku.yamahata@intel.com
Subject: [PATCH 08/11] KVM: guest_memfd: extract __kvm_gmem_punch_hole()
Date: Thu,  4 Apr 2024 14:50:30 -0400
Message-ID: <20240404185034.3184582-9-pbonzini@redhat.com>
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

Extract a version of kvm_gmem_punch_hole() that expects the
caller to take the filemap invalidate_lock.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/guest_memfd.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index a537a7e63ab5..51c99667690a 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -152,19 +152,12 @@ static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
 	}
 }
 
-static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
+static long __kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
 	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
 	pgoff_t start = offset >> PAGE_SHIFT;
 	pgoff_t end = (offset + len) >> PAGE_SHIFT;
 	struct kvm_gmem *gmem;
-
-	/*
-	 * Bindings must be stable across invalidation to ensure the start+end
-	 * are balanced.
-	 */
-	filemap_invalidate_lock(inode->i_mapping);
-
 	list_for_each_entry(gmem, gmem_list, entry)
 		kvm_gmem_invalidate_begin(gmem, start, end);
 
@@ -173,11 +166,23 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	list_for_each_entry(gmem, gmem_list, entry)
 		kvm_gmem_invalidate_end(gmem, start, end);
 
-	filemap_invalidate_unlock(inode->i_mapping);
-
 	return 0;
 }
 
+static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
+{
+	int r;
+
+	/*
+	 * Bindings must be stable across invalidation to ensure the start+end
+	 * are balanced.
+	 */
+	filemap_invalidate_lock(inode->i_mapping);
+	r = __kvm_gmem_punch_hole(inode, offset, len);
+	filemap_invalidate_unlock(inode->i_mapping);
+	return r;
+}
+
 static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 {
 	struct address_space *mapping = inode->i_mapping;
-- 
2.43.0



