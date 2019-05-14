Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB0311E5BB
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 01:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfENXnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 19:43:08 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48776 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726369AbfENXm6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 May 2019 19:42:58 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4ENLvC7139829
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 19:42:57 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sg46gyqrv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 19:42:56 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Wed, 15 May 2019 00:42:55 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 May 2019 00:42:53 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4ENgqrU54132962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 23:42:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E5F2AAE053;
        Tue, 14 May 2019 23:42:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2FDBAE051;
        Tue, 14 May 2019 23:42:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 14 May 2019 23:42:51 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 3C2E7E1954; Wed, 15 May 2019 01:42:51 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 7/7] s390/cio: Remove vfio-ccw checks of command codes
Date:   Wed, 15 May 2019 01:42:48 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190514234248.36203-1-farman@linux.ibm.com>
References: <20190514234248.36203-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19051423-0012-0000-0000-0000031BB7C3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051423-0013-0000-0000-000021545248
Message-Id: <20190514234248.36203-8-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-14_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905140153
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the CCW being processed is a No-Operation, then by definition no
data is being transferred.  Let's fold those checks into the normal
CCW processors, rather than skipping out early.

Likewise, if the CCW being processed is a "test" (an invented
definition to simply mean it ends in a zero), let's permit that to go
through to the hardware.  There's nothing inherently unique about
those command codes versus one that ends in an eight [1], or any other
otherwise valid command codes that are undefined for the device type
in question.

[1] POPS states that a x08 is a TIC CCW, and that having any high-order
bits enabled is invalid for format-1 CCWs.  For format-0 CCWs, the
high-order bits are ignored.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 94888094ed2c..abe0f501a963 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -295,8 +295,6 @@ static long copy_ccw_from_iova(struct channel_program *cp,
 #define ccw_is_read_backward(_ccw) (((_ccw)->cmd_code & 0x0F) == 0x0C)
 #define ccw_is_sense(_ccw) (((_ccw)->cmd_code & 0x0F) == CCW_CMD_BASIC_SENSE)
 
-#define ccw_is_test(_ccw) (((_ccw)->cmd_code & 0x0F) == 0)
-
 #define ccw_is_noop(_ccw) ((_ccw)->cmd_code == CCW_CMD_NOOP)
 
 #define ccw_is_tic(_ccw) ((_ccw)->cmd_code == CCW_CMD_TIC)
@@ -320,6 +318,10 @@ static inline int ccw_does_data_transfer(struct ccw1 *ccw)
 	if (ccw->count == 0)
 		return 0;
 
+	/* If the command is a NOP, then no data will be transferred */
+	if (ccw_is_noop(ccw))
+		return 0;
+
 	/* If the skip flag is off, then data will be transferred */
 	if (!ccw_is_skip(ccw))
 		return 1;
@@ -404,7 +406,7 @@ static void ccwchain_cda_free(struct ccwchain *chain, int idx)
 {
 	struct ccw1 *ccw = chain->ch_ccw + idx;
 
-	if (ccw_is_test(ccw) || ccw_is_noop(ccw) || ccw_is_tic(ccw))
+	if (ccw_is_tic(ccw))
 		return;
 
 	kfree((void *)(u64)ccw->cda);
@@ -729,9 +731,6 @@ static int ccwchain_fetch_one(struct ccwchain *chain,
 {
 	struct ccw1 *ccw = chain->ch_ccw + idx;
 
-	if (ccw_is_test(ccw) || ccw_is_noop(ccw))
-		return 0;
-
 	if (ccw_is_tic(ccw))
 		return ccwchain_fetch_tic(chain, idx, cp);
 
-- 
2.17.1

