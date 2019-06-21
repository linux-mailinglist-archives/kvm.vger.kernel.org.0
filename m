Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3359C4EAB0
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 16:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfFUOeD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 10:34:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33554 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbfFUOeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 10:34:02 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 44937223864;
        Fri, 21 Jun 2019 14:34:02 +0000 (UTC)
Received: from localhost (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A2E05D772;
        Fri, 21 Jun 2019 14:34:01 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 01/14] s390/cio: Squash cp_free() and cp_unpin_free()
Date:   Fri, 21 Jun 2019 16:33:42 +0200
Message-Id: <20190621143355.29175-2-cohuck@redhat.com>
In-Reply-To: <20190621143355.29175-1-cohuck@redhat.com>
References: <20190621143355.29175-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 21 Jun 2019 14:34:02 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

The routine cp_free() does nothing but call cp_unpin_free(), and while
most places call cp_free() there is one caller of cp_unpin_free() used
when the cp is guaranteed to have not been marked initialized.

This seems like a dubious way to make a distinction, so let's combine
these routines and make cp_free() do all the work.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20190606202831.44135-2-farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 36 +++++++++++++++-------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index f73cfcfdd032..47cd7f94f42f 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -412,23 +412,6 @@ static void ccwchain_cda_free(struct ccwchain *chain, int idx)
 	kfree((void *)(u64)ccw->cda);
 }
 
-/* Unpin the pages then free the memory resources. */
-static void cp_unpin_free(struct channel_program *cp)
-{
-	struct ccwchain *chain, *temp;
-	int i;
-
-	cp->initialized = false;
-	list_for_each_entry_safe(chain, temp, &cp->ccwchain_list, next) {
-		for (i = 0; i < chain->ch_len; i++) {
-			pfn_array_table_unpin_free(chain->ch_pat + i,
-						   cp->mdev);
-			ccwchain_cda_free(chain, i);
-		}
-		ccwchain_free(chain);
-	}
-}
-
 /**
  * ccwchain_calc_length - calculate the length of the ccw chain.
  * @iova: guest physical address of the target ccw chain
@@ -796,7 +779,7 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
 	/* Now loop for its TICs. */
 	ret = ccwchain_loop_tic(chain, cp);
 	if (ret)
-		cp_unpin_free(cp);
+		cp_free(cp);
 	/* It is safe to force: if not set but idals used
 	 * ccwchain_calc_length returns an error.
 	 */
@@ -819,8 +802,21 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
  */
 void cp_free(struct channel_program *cp)
 {
-	if (cp->initialized)
-		cp_unpin_free(cp);
+	struct ccwchain *chain, *temp;
+	int i;
+
+	if (!cp->initialized)
+		return;
+
+	cp->initialized = false;
+	list_for_each_entry_safe(chain, temp, &cp->ccwchain_list, next) {
+		for (i = 0; i < chain->ch_len; i++) {
+			pfn_array_table_unpin_free(chain->ch_pat + i,
+						   cp->mdev);
+			ccwchain_cda_free(chain, i);
+		}
+		ccwchain_free(chain);
+	}
 }
 
 /**
-- 
2.20.1

