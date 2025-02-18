Return-Path: <kvm+bounces-38498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 89BE3A3AB91
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 23:22:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B26B67A2251
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 22:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9ADF1D7E5F;
	Tue, 18 Feb 2025 22:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ANYQoFGG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D7F17A309
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 22:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739917350; cv=none; b=Fc/+BzAuwYJqs/6XUKg02znz3sUBW8V+l+6OMjM0N04PkFhJyCEnFZBx+nHq2UnxjsZKyns0x0mRXQ8b2D2+fDcBM3YeWDscGziLgGRqeoamdKooP6kVYGorZwH37nUlax0jLHcD1IxxnDh3iFtBz1UoRLUfsKzoTebmk5qjzN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739917350; c=relaxed/simple;
	bh=OFxtNMO544u4QXflyKyJc+PEeJaBK8eyu4Fj+6JaLc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/0AKVV87imHqixs2jULPw4nmc/qWqxPbIsw5X0LfG0cD2q40KiYOl/1prURjhYalOzrPj79ORUI1ZJnrhTeVI6IoH6ee384dZJAo/wycaLTR5+D+wk7w5GgxLcC+9eyi/BZ8PNpHo+bl2qD/Ori4lj0gGMl/qwzJ5+qI85i6i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ANYQoFGG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739917347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z8/iHQhrJ/aZGVyYP8XcAahgAPdzcbyxdw/jYg/Ap0s=;
	b=ANYQoFGG6jwphE+gCsiQAQlVC2GprNd4qAXo6VnENCKyjZrhfNNML8d5sKdl9F6xXT4HWy
	YJ8P+2YhXXhuo4Lr0TfRzwd2eylTwFnTn86IZsM6iOcjd7UxmzXzoJOvL3SA4vOSXUv/au
	m0RbrTvWXmGoWuNOjG3cMylFMf975PA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-641-keIo2oqgMQmrNKfT2a6hWQ-1; Tue,
 18 Feb 2025 17:22:23 -0500
X-MC-Unique: keIo2oqgMQmrNKfT2a6hWQ-1
X-Mimecast-MFC-AGG-ID: keIo2oqgMQmrNKfT2a6hWQ_1739917342
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A6950180087A;
	Tue, 18 Feb 2025 22:22:22 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.88.77])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3A65D30001A5;
	Tue, 18 Feb 2025 22:22:20 +0000 (UTC)
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	peterx@redhat.com,
	mitchell.augustin@canonical.com,
	clg@redhat.com,
	jgg@nvidia.com
Subject: [PATCH v2 1/6] vfio/type1: Catch zero from pin_user_pages_remote()
Date: Tue, 18 Feb 2025 15:22:01 -0700
Message-ID: <20250218222209.1382449-2-alex.williamson@redhat.com>
In-Reply-To: <20250218222209.1382449-1-alex.williamson@redhat.com>
References: <20250218222209.1382449-1-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

pin_user_pages_remote() can currently return zero for invalid args
or zero nr_pages, neither of which should ever happen.  However
vaddr_get_pfns() indicates it should only ever return a positive
value or -errno and there's a theoretical case where this can slip
through and be unhandled by callers.  Therefore convert zero to
-EFAULT.

Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
Tested-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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
2.48.1


