Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80A554EABE
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 16:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfFUOeT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 10:34:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50088 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfFUOeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 10:34:18 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2F39B6EB88;
        Fri, 21 Jun 2019 14:34:18 +0000 (UTC)
Received: from localhost (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BEFD45D9E2;
        Fri, 21 Jun 2019 14:34:17 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 08/14] vfio-ccw: Rearrange IDAL allocation in direct CCW
Date:   Fri, 21 Jun 2019 16:33:49 +0200
Message-Id: <20190621143355.29175-9-cohuck@redhat.com>
In-Reply-To: <20190621143355.29175-1-cohuck@redhat.com>
References: <20190621143355.29175-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 21 Jun 2019 14:34:18 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

This is purely deck furniture, to help understand the merge of the
direct and indirect handlers.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20190606202831.44135-9-farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 76ffcc823944..8205d0b527fc 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -537,13 +537,21 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 	unsigned long *idaws;
 	int ret;
 	int bytes = 1;
-	int idaw_nr = 1;
+	int idaw_nr;
 
 	ccw = chain->ch_ccw + idx;
 
-	if (ccw->count) {
+	if (ccw->count)
 		bytes = ccw->count;
-		idaw_nr = idal_nr_words((void *)(u64)ccw->cda, ccw->count);
+
+	/* Calculate size of IDAL */
+	idaw_nr = idal_nr_words((void *)(u64)ccw->cda, bytes);
+
+	/* Allocate an IDAL from host storage */
+	idaws = kcalloc(idaw_nr, sizeof(*idaws), GFP_DMA | GFP_KERNEL);
+	if (!idaws) {
+		ret = -ENOMEM;
+		goto out_init;
 	}
 
 	/*
@@ -554,7 +562,7 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 	pa = chain->ch_pa + idx;
 	ret = pfn_array_alloc(pa, ccw->cda, bytes);
 	if (ret < 0)
-		goto out_unpin;
+		goto out_free_idaws;
 
 	if (ccw_does_data_transfer(ccw)) {
 		ret = pfn_array_pin(pa, cp->mdev);
@@ -564,21 +572,18 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 		pa->pa_nr = 0;
 	}
 
-	/* Translate this direct ccw to a idal ccw. */
-	idaws = kcalloc(idaw_nr, sizeof(*idaws), GFP_DMA | GFP_KERNEL);
-	if (!idaws) {
-		ret = -ENOMEM;
-		goto out_unpin;
-	}
 	ccw->cda = (__u32) virt_to_phys(idaws);
 	ccw->flags |= CCW_FLAG_IDA;
 
+	/* Populate the IDAL with pinned/translated addresses from pfn */
 	pfn_array_idal_create_words(pa, idaws);
 
 	return 0;
 
 out_unpin:
 	pfn_array_unpin_free(pa, cp->mdev);
+out_free_idaws:
+	kfree(idaws);
 out_init:
 	ccw->cda = 0;
 	return ret;
-- 
2.20.1

