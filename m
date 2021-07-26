Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A3A3D5BD3
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 16:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234673AbhGZN5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 09:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233939AbhGZN5Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 09:57:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0DEC061757;
        Mon, 26 Jul 2021 07:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=kjP8XL3gAAQmLIUQhlu9GWo9RK6RrkKJjMyFl/c4u5E=; b=oigzRQ4uCRljWEwC0f1Bbt6rtY
        k+rE676s5UiKLt1KJfMy+YjKS01RfM9Kd4BjiaEeFtz+HYd9WL7VEeLf9t7QErqUG+V5s3TP7OlJF
        HQQhZDGigigMhVSThuxVel5Rag8s9taG+on9Gzf53LaJIOC1aQi7RFq0e5msbi1uitWwhSOKsg+5p
        bdFVoeLuPM331GQ3ew/fq16bPd6evK5Abrx8xGwFbLa1Vqq1rXw27iu+KBTQbvmrZ7gaSZnhWWLcI
        gpb08EQSQiiTcjqtuRSRYm9KxwVCoxEDcLU1mdAQBRtp1QqC29tpIdNRjOGC6MGZVqKcBDnUXqbvi
        6FlcVRgA==;
Received: from [2001:4bb8:184:87c5:ee29:e765:f641:52d7] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m81ib-00E2d9-6k; Mon, 26 Jul 2021 14:36:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] vfio/mdev: don't warn if ->request is not set
Date:   Mon, 26 Jul 2021 16:35:24 +0200
Message-Id: <20210726143524.155779-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726143524.155779-1-hch@lst.de>
References: <20210726143524.155779-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Only a single driver actually sets the ->request method, so don't print
a scary warning if it isn't.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vfio/mdev/mdev_core.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index b16606ebafa1..b314101237fe 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -138,10 +138,6 @@ int mdev_register_device(struct device *dev, const struct mdev_parent_ops *ops)
 	if (!dev)
 		return -EINVAL;
 
-	/* Not mandatory, but its absence could be a problem */
-	if (!ops->request)
-		dev_info(dev, "Driver cannot be asked to release device\n");
-
 	mutex_lock(&parent_list_lock);
 
 	/* Check for duplicate */
-- 
2.30.2

