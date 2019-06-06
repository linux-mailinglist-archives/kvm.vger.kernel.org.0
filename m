Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4743537EBF
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 22:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfFFU2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 16:28:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46330 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726959AbfFFU2k (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jun 2019 16:28:40 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56KQxvf054193
        for <kvm@vger.kernel.org>; Thu, 6 Jun 2019 16:28:39 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sy79xy76k-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 16:28:39 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Thu, 6 Jun 2019 21:28:37 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Jun 2019 21:28:35 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x56KSXJ227263394
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jun 2019 20:28:34 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6DBB11C04A;
        Thu,  6 Jun 2019 20:28:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C49D611C050;
        Thu,  6 Jun 2019 20:28:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  6 Jun 2019 20:28:33 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 51BB1E01EE; Thu,  6 Jun 2019 22:28:33 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 1/9] s390/cio: Squash cp_free() and cp_unpin_free()
Date:   Thu,  6 Jun 2019 22:28:23 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606202831.44135-1-farman@linux.ibm.com>
References: <20190606202831.44135-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19060620-0020-0000-0000-00000347C041
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060620-0021-0000-0000-0000219AD689
Message-Id: <20190606202831.44135-2-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The routine cp_free() does nothing but call cp_unpin_free(), and while
most places call cp_free() there is one caller of cp_unpin_free() used
when the cp is guaranteed to have not been marked initialized.

This seems like a dubious way to make a distinction, so let's combine
these routines and make cp_free() do all the work.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
The RFC version of this patch received r-b's from Farhan [1] and
Pierre [2].  This patch is almost identical to that one, but I
opted to not include those tags because of the cp->initialized
check that now has an impact here.  I still think this patch makes
sense, but want them (well, Farhan) to have a chance to look it
over since it's been six or seven months.

[1] https://patchwork.kernel.org/comment/22310411/
[2] https://patchwork.kernel.org/comment/22317927/
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
2.17.1

