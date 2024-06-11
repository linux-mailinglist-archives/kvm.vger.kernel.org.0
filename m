Return-Path: <kvm+bounces-19307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E45B9038CC
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 12:25:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C594F1F21B57
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 10:25:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C83F54750;
	Tue, 11 Jun 2024 10:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JNiOsjfI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1421420CC
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 10:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718101521; cv=none; b=S8mz94z4Y73cc0fu9k+w0DAvY3E6y6XwJuShgD9AQR17FY0UMt2O1l72MGgK35+4nAjUFyjiCX9OGSRgV4bhMRl61N1Vg5sti3Xj4a4vP0OL9mv3xHvDUPLxqtHgEw3ti5pe4B6+t4caCXpgcXFqbprKp2JPb5p9Fku1p/Mc9yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718101521; c=relaxed/simple;
	bh=VkZixBc8xDXERbSTJ4ump7kOefASQgvfg8WxNzP/Q/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lM4+4ZZxbMZcAGpURiG8L6JXxlAa7Y8lunFj+SsKVG7kmGt6No7HIxIlhjEIhleyyqrNptVcha2EjB749lrtFPAa9zAOTo31hu5HgX6Us4c7WzMo0GdAMYyi1VkuGRXbEGixuURQO5eWAg9ljnKJPagghjx+yOq4EazvdLXzB2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JNiOsjfI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718101519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4HuOD2re6A46u1UT855gJsftXL/2/HlhGFO/rN8lLuQ=;
	b=JNiOsjfI1EPwjpcl+4sDh5MsJW1ZN3/XAIW49mi7ah/lhgrc3dphWLANkV25AUtoK1c4GG
	y4gFGhk+/qVU4YtD/7lU2N0TwR5hxist9n+u4jO7ACYO22L1vAGfcGOfkcqGRRFkFKzsZx
	flmwQ1IdzlCyqsd35lYAU73TVuRpkOE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-171-CBhQ58dsOGqRfmxJAC6ePg-1; Tue,
 11 Jun 2024 06:25:17 -0400
X-MC-Unique: CBhQ58dsOGqRfmxJAC6ePg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7B7A619560B6;
	Tue, 11 Jun 2024 10:25:16 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CCBDB300021B;
	Tue, 11 Jun 2024 10:25:15 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v2] virt: guest_memfd: fix reference leak on hwpoisoned page
Date: Tue, 11 Jun 2024 06:25:15 -0400
Message-ID: <20240611102515.48048-1-pbonzini@redhat.com>
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
grabbed.  Add the forgotten folio_put().

Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	Sent v1 from the wrong directory, sorry about that.

 virt/kvm/guest_memfd.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 3bfe1824ec2d..19c220ec1efd 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -549,7 +549,6 @@ static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 	struct kvm_gmem *gmem = file->private_data;
 	struct folio *folio;
 	struct page *page;
-	int r;
 
 	if (file != slot->gmem.file) {
 		WARN_ON_ONCE(slot->gmem.file);
@@ -567,8 +566,9 @@ static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 		return PTR_ERR(folio);
 
 	if (folio_test_hwpoison(folio)) {
-		r = -EHWPOISON;
-		goto out_unlock;
+		folio_unlock(folio);
+		folio_put(folio);
+		return -EHWPOISON;
 	}
 
 	page = folio_file_page(folio, index);
@@ -577,12 +577,8 @@ static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
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


