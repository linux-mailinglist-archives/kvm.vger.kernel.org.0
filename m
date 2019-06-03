Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0866432DFA
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 12:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbfFCKu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 06:50:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34206 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727468AbfFCKu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 06:50:58 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9B1C33082B46;
        Mon,  3 Jun 2019 10:50:57 +0000 (UTC)
Received: from localhost (ovpn-204-96.brq.redhat.com [10.40.204.96])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B28B648A9;
        Mon,  3 Jun 2019 10:50:56 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 5/7] s390/cio: Don't pin vfio pages for empty transfers
Date:   Mon,  3 Jun 2019 12:50:36 +0200
Message-Id: <20190603105038.11788-6-cohuck@redhat.com>
In-Reply-To: <20190603105038.11788-1-cohuck@redhat.com>
References: <20190603105038.11788-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 03 Jun 2019 10:50:57 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

The skip flag of a CCW offers the possibility of data not being
transferred, but is only meaningful for certain commands.
Specifically, it is only applicable for a read, read backward, sense,
or sense ID CCW and will be ignored for any other command code
(SA22-7832-11 page 15-64, and figure 15-30 on page 15-75).

(A sense ID is xE4, while a sense is x04 with possible modifiers in the
upper four bits.  So we will cover the whole "family" of sense CCWs.)

For those scenarios, since there is no requirement for the target
address to be valid, we should skip the call to vfio_pin_pages() and
rely on the IDAL address we have allocated/built for the channel
program.  The fact that the individual IDAWs within the IDAL are
invalid is fine, since they aren't actually checked in these cases.

Set pa_nr to zero when skipping the pfn_array_pin() call, since it is
defined as the number of pages pinned and is used to determine
whether to call vfio_unpin_pages() upon cleanup.

The pfn_array_pin() routine returns the number of pages that were
pinned, but now might be skipped for some CCWs.  Thus we need to
calculate the expected number of pages ourselves such that we are
guaranteed to allocate a reasonable number of IDAWs, which will
provide a valid address in CCW.CDA regardless of whether the IDAWs
are filled in with pinned/translated addresses or not.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Message-Id: <20190516161403.79053-2-farman@linux.ibm.com>
Acked-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 55 ++++++++++++++++++++++++++++++----
 1 file changed, 50 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 086faf2dacd3..0467838aed23 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -294,6 +294,10 @@ static long copy_ccw_from_iova(struct channel_program *cp,
 /*
  * Helpers to operate ccwchain.
  */
+#define ccw_is_read(_ccw) (((_ccw)->cmd_code & 0x03) == 0x02)
+#define ccw_is_read_backward(_ccw) (((_ccw)->cmd_code & 0x0F) == 0x0C)
+#define ccw_is_sense(_ccw) (((_ccw)->cmd_code & 0x0F) == CCW_CMD_BASIC_SENSE)
+
 #define ccw_is_test(_ccw) (((_ccw)->cmd_code & 0x0F) == 0)
 
 #define ccw_is_noop(_ccw) ((_ccw)->cmd_code == CCW_CMD_NOOP)
@@ -301,10 +305,39 @@ static long copy_ccw_from_iova(struct channel_program *cp,
 #define ccw_is_tic(_ccw) ((_ccw)->cmd_code == CCW_CMD_TIC)
 
 #define ccw_is_idal(_ccw) ((_ccw)->flags & CCW_FLAG_IDA)
-
+#define ccw_is_skip(_ccw) ((_ccw)->flags & CCW_FLAG_SKIP)
 
 #define ccw_is_chain(_ccw) ((_ccw)->flags & (CCW_FLAG_CC | CCW_FLAG_DC))
 
+/*
+ * ccw_does_data_transfer()
+ *
+ * Determine whether a CCW will move any data, such that the guest pages
+ * would need to be pinned before performing the I/O.
+ *
+ * Returns 1 if yes, 0 if no.
+ */
+static inline int ccw_does_data_transfer(struct ccw1 *ccw)
+{
+	/* If the skip flag is off, then data will be transferred */
+	if (!ccw_is_skip(ccw))
+		return 1;
+
+	/*
+	 * If the skip flag is on, it is only meaningful if the command
+	 * code is a read, read backward, sense, or sense ID.  In those
+	 * cases, no data will be transferred.
+	 */
+	if (ccw_is_read(ccw) || ccw_is_read_backward(ccw))
+		return 0;
+
+	if (ccw_is_sense(ccw))
+		return 0;
+
+	/* The skip flag is on, but it is ignored for this command code. */
+	return 1;
+}
+
 /*
  * is_cpa_within_range()
  *
@@ -559,6 +592,7 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 	struct pfn_array_table *pat;
 	unsigned long *idaws;
 	int ret;
+	int idaw_nr = 1;
 
 	ccw = chain->ch_ccw + idx;
 
@@ -570,6 +604,8 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 		 */
 		ccw->flags |= CCW_FLAG_IDA;
 		return 0;
+	} else {
+		idaw_nr = idal_nr_words((void *)(u64)ccw->cda, ccw->count);
 	}
 
 	/*
@@ -586,12 +622,16 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 	if (ret < 0)
 		goto out_unpin;
 
-	ret = pfn_array_pin(pat->pat_pa, cp->mdev);
-	if (ret < 0)
-		goto out_unpin;
+	if (ccw_does_data_transfer(ccw)) {
+		ret = pfn_array_pin(pat->pat_pa, cp->mdev);
+		if (ret < 0)
+			goto out_unpin;
+	} else {
+		pat->pat_pa->pa_nr = 0;
+	}
 
 	/* Translate this direct ccw to a idal ccw. */
-	idaws = kcalloc(ret, sizeof(*idaws), GFP_DMA | GFP_KERNEL);
+	idaws = kcalloc(idaw_nr, sizeof(*idaws), GFP_DMA | GFP_KERNEL);
 	if (!idaws) {
 		ret = -ENOMEM;
 		goto out_unpin;
@@ -661,6 +701,11 @@ static int ccwchain_fetch_idal(struct ccwchain *chain,
 		if (ret < 0)
 			goto out_free_idaws;
 
+		if (!ccw_does_data_transfer(ccw)) {
+			pa->pa_nr = 0;
+			continue;
+		}
+
 		ret = pfn_array_pin(pa, cp->mdev);
 		if (ret < 0)
 			goto out_free_idaws;
-- 
2.20.1

