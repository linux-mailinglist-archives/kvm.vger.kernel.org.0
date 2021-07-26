Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3466A3D5BC5
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 16:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbhGZN4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 09:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbhGZN4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 09:56:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B77C061760;
        Mon, 26 Jul 2021 07:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=S+cnVdLKORaVbb/mYCmvY8/gzd5nCq3cLsgC8I0YOrA=; b=vbXaw9vp9QO5KDbMuZhFpXW7Oz
        bM37zgECM7bjB0fpLMrTyEgOjH7c95V/6p9rRxo7RBn3vFDoyQKqMWQdaRfrSrfYH4IWdC1RSnRDD
        /uMMbHs3yuiIwG6r/4BAgOEy6248oF1OqqTJrt6Oi5hv8h1nfZc18VnfkOWGiCXw8oYwafcRr0opp
        naO0p1pzskj/l4EKueqc5m6zB+8RzTJh/8ykg7ReJBaZtshgJPHJLoeEH1I/1I6jDuG/mX5KIOUk3
        SX/aOS0mI+z5W4TP04tQx2ctVhzmZ5/9+YqZ0dJYnUi2TbCX452wv2n9xAl20u9/DkaVsKpzHvUxC
        7tSk5+9Q==;
Received: from [2001:4bb8:184:87c5:ee29:e765:f641:52d7] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m81i0-00E2bi-6V; Mon, 26 Jul 2021 14:36:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] vfio/mdev: turn mdev_init into a subsys_initcall
Date:   Mon, 26 Jul 2021 16:35:23 +0200
Message-Id: <20210726143524.155779-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726143524.155779-1-hch@lst.de>
References: <20210726143524.155779-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Without this setups with buіlt-in mdev and mdev-drivers fail to
register like this:

[1.903149] Driver 'intel_vgpu_mdev' was unable to register with bus_type 'mdev' because the bus was not initialized.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vfio/mdev/mdev_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index e4581ec093a6..b16606ebafa1 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -398,7 +398,7 @@ static void __exit mdev_exit(void)
 	mdev_bus_unregister();
 }
 
-module_init(mdev_init)
+subsys_initcall(mdev_init)
 module_exit(mdev_exit)
 
 MODULE_VERSION(DRIVER_VERSION);
-- 
2.30.2

