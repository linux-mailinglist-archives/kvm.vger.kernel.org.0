Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48BA420CB3
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 18:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfEPQPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 12:15:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51008 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726638AbfEPQPA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 May 2019 12:15:00 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4GGEnY7041556
        for <kvm@vger.kernel.org>; Thu, 16 May 2019 12:14:59 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2shb45r6ry-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 16 May 2019 12:14:54 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Thu, 16 May 2019 17:14:09 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 16 May 2019 17:14:07 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4GGE66j36110576
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 May 2019 16:14:06 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EAA654C046;
        Thu, 16 May 2019 16:14:05 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D97C34C059;
        Thu, 16 May 2019 16:14:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 16 May 2019 16:14:05 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 7C7BBE0772; Thu, 16 May 2019 18:14:05 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 1/3] s390/cio: Don't pin vfio pages for empty transfers
Date:   Thu, 16 May 2019 18:14:01 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190516161403.79053-1-farman@linux.ibm.com>
References: <20190516161403.79053-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19051616-0028-0000-0000-0000036E6A2F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051616-0029-0000-0000-0000242E05BA
Message-Id: <20190516161403.79053-2-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-16_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=831 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905160103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

As we do this, since the pfn_array_pin() routine returns the number of
pages pinned, and we might not be doing that, the logic for converting
a CCW from direct-addressed to IDAL needs to ensure there is room for
one IDAW in the IDAL being built since a zero-length IDAL isn't great.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
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
2.17.1

