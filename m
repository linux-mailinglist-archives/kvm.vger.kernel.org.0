Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54CE652559
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbiLTRM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234141AbiLTRMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:12:23 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7FA1DDC2;
        Tue, 20 Dec 2022 09:11:33 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKH8I7S003967;
        Tue, 20 Dec 2022 17:11:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=L33NEcKPIoUigZTV+vScsE/yvf9RxuUn9m/T+ueOd68=;
 b=AP6XvsGLbncN2bz2tyqYHUBN3T9oVNtUDGeE4+nKlB31OSmya5hz5UbIe3S17gCkWgR6
 0SETWxmXdKP9sHVgdGGwZffWLWDn9acJCd9OcFotsnxAR5ipGgfO7CBUHD9RYE/Mu1ja
 TmTqDrgaMydxWmCievufyre908wm3xa9jn3D4W0zMfnxG+oyCOeE1pd231LIKPRDmFAH
 QqYDWlpDiSCrX1vLv1GCFcpTelW3f0gqZzmMGOYQhdWMv5FQxUeZUPGnI4oE33W0Fwle
 odazWQ5E6rdE6Vsi6IeykMo95GaWxpissg7u19I1e38MQ9FQ1kUO2uqrQwn3Pugm4H87 Pg== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkgd220tx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:11:31 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKE9UCC031366;
        Tue, 20 Dec 2022 17:10:13 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3mh6yxk4uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:13 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHAAJ517433162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:10:10 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 276F72004B;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13EFF20040;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 8B5CCE08A5; Tue, 20 Dec 2022 18:10:09 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 06/16] vfio/ccw: simplify CCW chain fetch routines
Date:   Tue, 20 Dec 2022 18:09:58 +0100
Message-Id: <20221220171008.1362680-7-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220171008.1362680-1-farman@linux.ibm.com>
References: <20221220171008.1362680-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6sruTCKJFVqa1gJmmmvIyM1AZNyR_k11
X-Proofpoint-GUID: 6sruTCKJFVqa1gJmmmvIyM1AZNyR_k11
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 adultscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200141
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The act of processing a fetched CCW has two components:

 1) Process a Transfer-in-channel (TIC) CCW
 2) Process any other CCW

The former needs to look at whether the TIC jumps backwards into
the current channel program or forwards into a new segment,
while the latter just processes the CCW data address itself.

Rather than passing the chain segment and index within it to the
handlers for the above, and requiring each to calculate the
elements it needs, simply pass the needed pointers directly.

For the TIC, that means the CCW being processed and the location
of the entire channel program which holds all segments. For the
other CCWs, the page_array pointer is also needed to perform the
page pinning, etc.

While at it, rename ccwchain_fetch_direct to _ccw, to indicate
what it is. The name "_direct" is historical, when it used to
process a direct-addressed CCW, but IDAs are processed here too.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 1eacbb8dc860..d41d94cecdf8 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -482,11 +482,9 @@ static int ccwchain_loop_tic(struct ccwchain *chain, struct channel_program *cp)
 	return 0;
 }
 
-static int ccwchain_fetch_tic(struct ccwchain *chain,
-			      int idx,
+static int ccwchain_fetch_tic(struct ccw1 *ccw,
 			      struct channel_program *cp)
 {
-	struct ccw1 *ccw = chain->ch_ccw + idx;
 	struct ccwchain *iter;
 	u32 ccw_head;
 
@@ -502,14 +500,12 @@ static int ccwchain_fetch_tic(struct ccwchain *chain,
 	return -EFAULT;
 }
 
-static int ccwchain_fetch_direct(struct ccwchain *chain,
-				 int idx,
-				 struct channel_program *cp)
+static int ccwchain_fetch_ccw(struct ccw1 *ccw,
+			      struct page_array *pa,
+			      struct channel_program *cp)
 {
 	struct vfio_device *vdev =
 		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
-	struct ccw1 *ccw;
-	struct page_array *pa;
 	u64 iova;
 	unsigned long *idaws;
 	int ret;
@@ -517,8 +513,6 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 	int idaw_nr, idal_len;
 	int i;
 
-	ccw = chain->ch_ccw + idx;
-
 	if (ccw->count)
 		bytes = ccw->count;
 
@@ -548,7 +542,6 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 	 * required for the data transfer, since we only only support
 	 * 4K IDAWs today.
 	 */
-	pa = chain->ch_pa + idx;
 	ret = page_array_alloc(pa, iova, bytes);
 	if (ret < 0)
 		goto out_free_idaws;
@@ -604,16 +597,15 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
  * and to get rid of the cda 2G limitiaion of ccw1, we'll translate
  * direct ccws to idal ccws.
  */
-static int ccwchain_fetch_one(struct ccwchain *chain,
-			      int idx,
+static int ccwchain_fetch_one(struct ccw1 *ccw,
+			      struct page_array *pa,
 			      struct channel_program *cp)
-{
-	struct ccw1 *ccw = chain->ch_ccw + idx;
 
+{
 	if (ccw_is_tic(ccw))
-		return ccwchain_fetch_tic(chain, idx, cp);
+		return ccwchain_fetch_tic(ccw, cp);
 
-	return ccwchain_fetch_direct(chain, idx, cp);
+	return ccwchain_fetch_ccw(ccw, pa, cp);
 }
 
 /**
@@ -736,6 +728,8 @@ void cp_free(struct channel_program *cp)
 int cp_prefetch(struct channel_program *cp)
 {
 	struct ccwchain *chain;
+	struct ccw1 *ccw;
+	struct page_array *pa;
 	int len, idx, ret;
 
 	/* this is an error in the caller */
@@ -745,7 +739,10 @@ int cp_prefetch(struct channel_program *cp)
 	list_for_each_entry(chain, &cp->ccwchain_list, next) {
 		len = chain->ch_len;
 		for (idx = 0; idx < len; idx++) {
-			ret = ccwchain_fetch_one(chain, idx, cp);
+			ccw = chain->ch_ccw + idx;
+			pa = chain->ch_pa + idx;
+
+			ret = ccwchain_fetch_one(ccw, pa, cp);
 			if (ret)
 				goto out_err;
 		}
-- 
2.34.1

