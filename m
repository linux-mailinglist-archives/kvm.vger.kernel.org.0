Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C762B37EBE
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 22:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbfFFU2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 16:28:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48152 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726942AbfFFU2k (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jun 2019 16:28:40 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56KQu0w084008
        for <kvm@vger.kernel.org>; Thu, 6 Jun 2019 16:28:39 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2sy8e9bk4b-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 16:28:38 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Thu, 6 Jun 2019 21:28:37 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Jun 2019 21:28:35 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x56KSYaO61341720
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jun 2019 20:28:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 43948AE058;
        Thu,  6 Jun 2019 20:28:34 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 308EAAE055;
        Thu,  6 Jun 2019 20:28:34 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  6 Jun 2019 20:28:34 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 63CC4E0365; Thu,  6 Jun 2019 22:28:33 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 8/9] vfio-ccw: Rearrange IDAL allocation in direct CCW
Date:   Thu,  6 Jun 2019 22:28:30 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606202831.44135-1-farman@linux.ibm.com>
References: <20190606202831.44135-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19060620-0008-0000-0000-000002F0EC0F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060620-0009-0000-0000-0000225DD9D1
Message-Id: <20190606202831.44135-9-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=965 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is purely deck furniture, to help understand the merge of the
direct and indirect handlers.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
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
2.17.1

