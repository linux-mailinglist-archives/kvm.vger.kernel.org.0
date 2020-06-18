Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B981FFBA2
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 21:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgFRTQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 15:16:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728199AbgFRTQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 15:16:12 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 477BE207E8;
        Thu, 18 Jun 2020 19:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592507771;
        bh=GKvyYGsgx2yaXPftx75dKRpr9bN/B2GO4AJDXtGC5gg=;
        h=Date:From:To:Cc:Subject:From;
        b=uI3teB5B/fXNlwUMuCmt7oZL7V2rKZwgv11rCamXcgA0gCjDvXhESWovaTch6TRyT
         0SDa+oC2QyKAEFlS1klmR2RJsRA8hPrZ5TCWMyseoGh7+u3pnZgi6CMRypr2/Yx33V
         w64cO+I4FyeMU2oMFEzN1g46KH21YejZhgC/Zm3A=
Date:   Thu, 18 Jun 2020 14:21:34 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] vfio/type1: Use struct_size() helper
Message-ID: <20200618192134.GA30734@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

This code was detected with the help of Coccinelle and, audited and
fixed manually.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/vfio/vfio_iommu_type1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 5e556ac9102a..b7e71e10a169 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2493,7 +2493,7 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
 		return 0;
 	}
 
-	size = sizeof(*cap_iovas) + (iovas * sizeof(*cap_iovas->iova_ranges));
+	size = struct_size(cap_iovas, iova_ranges, iovas);
 
 	cap_iovas = kzalloc(size, GFP_KERNEL);
 	if (!cap_iovas)
-- 
2.27.0

