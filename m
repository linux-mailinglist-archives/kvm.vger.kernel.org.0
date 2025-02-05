Return-Path: <kvm+bounces-37412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B753AA29D69
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 00:18:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B12471888E97
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 23:18:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 289A521CFF7;
	Wed,  5 Feb 2025 23:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ke2tI1Pe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8078721B1AC
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 23:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738797496; cv=none; b=oCxkC5cZfSq87KWkY1mo0o0MBA9SJm5BLvdsnKE5fRXLiVLVU/zPUWHaE0WZlfWEh6HFkLkbvqleTuOFo+vIcZNNw116snznYOASFNIaCKevXowYfaVmgn67bFcnUrccyqaNGKLT2D5z5dFEJTYiCQMEydRqCb55VJMAbDO7kys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738797496; c=relaxed/simple;
	bh=c0FKae0datf842mFkxPTOtU/p5nszLRuh9nfgAkopfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+VOBRQ6+DhI4gE/NR1UZl7UNylmgHGryjS/ZfXSVy+L0GLbz9fmJYxptso3YESTge6u78P50iklIO2Dik2VkEYFDdQlLq+FSLUOSi5Nh0GyTjdN9lrYYVugBwfhFqALC4vEkHUEU2+8FJcjwcQDt5xa8g3rSXN+kTkO37HoYIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ke2tI1Pe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738797493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VBKJl1czRBY86nXc1glbEuEYIO4hJO4j3CmfeALteSw=;
	b=Ke2tI1Pex6YtWblABhQJodayPQlqv4IEtsVcKCNZt1NU1AZVNo9XCUnajDpl817XOqHuGx
	1b0DUVZP5940eKIR4C7RYbYrixN3T9zwZgOCMdwrO3CrEDMA/EBANNwiIqFM5EBGhY7lQ/
	XewnLV4dw2/C3fVORdbAAi8RDblBN20=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-663-wEuLXHT-MzWAqIlLtDFQ3Q-1; Wed,
 05 Feb 2025 18:18:11 -0500
X-MC-Unique: wEuLXHT-MzWAqIlLtDFQ3Q-1
X-Mimecast-MFC-AGG-ID: wEuLXHT-MzWAqIlLtDFQ3Q
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B4B131800873;
	Wed,  5 Feb 2025 23:18:10 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.81.141])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 46B6B1800265;
	Wed,  5 Feb 2025 23:18:09 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	peterx@redhat.com,
	mitchell.augustin@canonical.com,
	clg@redhat.com
Subject: [PATCH 1/5] vfio/type1: Catch zero from pin_user_pages_remote()
Date: Wed,  5 Feb 2025 16:17:17 -0700
Message-ID: <20250205231728.2527186-2-alex.williamson@redhat.com>
In-Reply-To: <20250205231728.2527186-1-alex.williamson@redhat.com>
References: <20250205231728.2527186-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

pin_user_pages_remote() can currently return zero for invalid args
or zero nr_pages, neither of which should ever happen.  However
vaddr_get_pfns() indicates it should only ever return a positive
value or -errno and there's a theoretical case where this can slip
through and be unhandled by callers.  Therefore convert zero to
-EFAULT.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 50ebc9593c9d..119cf886d8c0 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -564,6 +564,8 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
 	if (ret > 0) {
 		*pfn = page_to_pfn(pages[0]);
 		goto done;
+	} else if (!ret) {
+		ret = -EFAULT;
 	}
 
 	vaddr = untagged_addr_remote(mm, vaddr);
-- 
2.47.1


