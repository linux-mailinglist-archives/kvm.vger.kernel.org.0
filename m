Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75F7632DFD
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 12:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbfFCKvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 06:51:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727513AbfFCKvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 06:51:01 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 47BF03082E69;
        Mon,  3 Jun 2019 10:51:00 +0000 (UTC)
Received: from localhost (ovpn-204-96.brq.redhat.com [10.40.204.96])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CD2761972A;
        Mon,  3 Jun 2019 10:50:59 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 6/7] s390/cio: Allow zero-length CCWs in vfio-ccw
Date:   Mon,  3 Jun 2019 12:50:37 +0200
Message-Id: <20190603105038.11788-7-cohuck@redhat.com>
In-Reply-To: <20190603105038.11788-1-cohuck@redhat.com>
References: <20190603105038.11788-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 03 Jun 2019 10:51:00 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

It is possible that a guest might issue a CCW with a length of zero,
and will expect a particular response.  Consider this chain:

   Address   Format-1 CCW
   --------  -----------------
 0 33110EC0  346022CC 33177468
 1 33110EC8  CF200000 3318300C

CCW[0] moves a little more than two pages, but also has the
Suppress Length Indication (SLI) bit set to handle the expectation
that considerably less data will be moved.  CCW[1] also has the SLI
bit set, and has a length of zero.  Once vfio-ccw does its magic,
the kernel issues a start subchannel on behalf of the guest with this:

   Address   Format-1 CCW
   --------  -----------------
 0 021EDED0  346422CC 021F0000
 1 021EDED8  CF240000 3318300C

Both CCWs were converted to an IDAL and have the corresponding flags
set (which is by design), but only the address of the first data
address is converted to something the host is aware of.  The second
CCW still has the address used by the guest, which happens to be (A)
(probably) an invalid address for the host, and (B) an invalid IDAW
address (doubleword boundary, etc.).

While the I/O fails, it doesn't fail correctly.  In this example, we
would receive a program check for an invalid IDAW address, instead of
a unit check for an invalid command.

To fix this, revert commit 4cebc5d6a6ff ("vfio: ccw: validate the
count field of a ccw before pinning") and allow the individual fetch
routines to process them like anything else.  We'll make a slight
adjustment to our allocation of the pfn_array (for direct CCWs) or
IDAL (for IDAL CCWs) memory, so that we have room for at least one
address even though no guest memory will be pinned and thus the
IDAW will not be populated with a host address.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Message-Id: <20190516161403.79053-3-farman@linux.ibm.com>
Acked-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 0467838aed23..c77c9b4cd2a8 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -70,9 +70,6 @@ static int pfn_array_alloc(struct pfn_array *pa, u64 iova, unsigned int len)
 {
 	int i;
 
-	if (!len)
-		return 0;
-
 	if (pa->pa_nr || pa->pa_iova_pfn)
 		return -EINVAL;
 
@@ -319,6 +316,10 @@ static long copy_ccw_from_iova(struct channel_program *cp,
  */
 static inline int ccw_does_data_transfer(struct ccw1 *ccw)
 {
+	/* If the count field is zero, then no data will be transferred */
+	if (ccw->count == 0)
+		return 0;
+
 	/* If the skip flag is off, then data will be transferred */
 	if (!ccw_is_skip(ccw))
 		return 1;
@@ -405,8 +406,6 @@ static void ccwchain_cda_free(struct ccwchain *chain, int idx)
 
 	if (ccw_is_test(ccw) || ccw_is_noop(ccw) || ccw_is_tic(ccw))
 		return;
-	if (!ccw->count)
-		return;
 
 	kfree((void *)(u64)ccw->cda);
 }
@@ -592,19 +591,13 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 	struct pfn_array_table *pat;
 	unsigned long *idaws;
 	int ret;
+	int bytes = 1;
 	int idaw_nr = 1;
 
 	ccw = chain->ch_ccw + idx;
 
-	if (!ccw->count) {
-		/*
-		 * We just want the translation result of any direct ccw
-		 * to be an IDA ccw, so let's add the IDA flag for it.
-		 * Although the flag will be ignored by firmware.
-		 */
-		ccw->flags |= CCW_FLAG_IDA;
-		return 0;
-	} else {
+	if (ccw->count) {
+		bytes = ccw->count;
 		idaw_nr = idal_nr_words((void *)(u64)ccw->cda, ccw->count);
 	}
 
@@ -618,7 +611,7 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 	if (ret)
 		goto out_init;
 
-	ret = pfn_array_alloc(pat->pat_pa, ccw->cda, ccw->count);
+	ret = pfn_array_alloc(pat->pat_pa, ccw->cda, bytes);
 	if (ret < 0)
 		goto out_unpin;
 
@@ -661,17 +654,18 @@ static int ccwchain_fetch_idal(struct ccwchain *chain,
 	u64 idaw_iova;
 	unsigned int idaw_nr, idaw_len;
 	int i, ret;
+	int bytes = 1;
 
 	ccw = chain->ch_ccw + idx;
 
-	if (!ccw->count)
-		return 0;
+	if (ccw->count)
+		bytes = ccw->count;
 
 	/* Calculate size of idaws. */
 	ret = copy_from_iova(cp->mdev, &idaw_iova, ccw->cda, sizeof(idaw_iova));
 	if (ret)
 		return ret;
-	idaw_nr = idal_nr_words((void *)(idaw_iova), ccw->count);
+	idaw_nr = idal_nr_words((void *)(idaw_iova), bytes);
 	idaw_len = idaw_nr * sizeof(*idaws);
 
 	/* Pin data page(s) in memory. */
-- 
2.20.1

