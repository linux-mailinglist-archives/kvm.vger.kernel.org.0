Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6949A6A636
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2019 12:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732681AbfGPKJV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 06:09:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732475AbfGPKJV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 06:09:21 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 272888552A;
        Tue, 16 Jul 2019 10:09:21 +0000 (UTC)
Received: from localhost (ovpn-117-180.ams2.redhat.com [10.36.117.180])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B296819C59;
        Tue, 16 Jul 2019 10:09:20 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 3/5] vfio-ccw: Set pa_nr to 0 if memory allocation fails for pa_iova_pfn
Date:   Tue, 16 Jul 2019 12:09:06 +0200
Message-Id: <20190716100908.3460-4-cohuck@redhat.com>
In-Reply-To: <20190716100908.3460-1-cohuck@redhat.com>
References: <20190716100908.3460-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 16 Jul 2019 10:09:21 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Farhan Ali <alifm@linux.ibm.com>

So we don't call try to call vfio_unpin_pages() incorrectly.

Fixes: 0a19e61e6d4c ("vfio: ccw: introduce channel program interfaces")
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <33a89467ad6369196ae6edf820cbcb1e2d8d050c.1562854091.git.alifm@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index e4e8724eddaa..3645d1720c4b 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -72,8 +72,10 @@ static int pfn_array_alloc(struct pfn_array *pa, u64 iova, unsigned int len)
 				  sizeof(*pa->pa_iova_pfn) +
 				  sizeof(*pa->pa_pfn),
 				  GFP_KERNEL);
-	if (unlikely(!pa->pa_iova_pfn))
+	if (unlikely(!pa->pa_iova_pfn)) {
+		pa->pa_nr = 0;
 		return -ENOMEM;
+	}
 	pa->pa_pfn = pa->pa_iova_pfn + pa->pa_nr;
 
 	pa->pa_iova_pfn[0] = pa->pa_iova >> PAGE_SHIFT;
-- 
2.20.1

