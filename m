Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F3237ED0
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 22:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfFFU25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 16:28:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36130 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727015AbfFFU2l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jun 2019 16:28:41 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56KQu4m059154
        for <kvm@vger.kernel.org>; Thu, 6 Jun 2019 16:28:40 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sy78q7dcg-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 16:28:40 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Thu, 6 Jun 2019 21:28:37 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Jun 2019 21:28:36 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x56KSYVC50004026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jun 2019 20:28:34 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AFBC4C04E;
        Thu,  6 Jun 2019 20:28:34 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FE0A4C040;
        Thu,  6 Jun 2019 20:28:34 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  6 Jun 2019 20:28:34 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 5C144E030B; Thu,  6 Jun 2019 22:28:33 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 5/9] vfio-ccw: Rearrange pfn_array and pfn_array_table arrays
Date:   Thu,  6 Jun 2019 22:28:27 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606202831.44135-1-farman@linux.ibm.com>
References: <20190606202831.44135-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19060620-0008-0000-0000-000002F0EC10
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060620-0009-0000-0000-0000225DD9D2
Message-Id: <20190606202831.44135-6-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While processing a channel program, we currently have two nested
arrays that carry a slightly different structure.  The direct CCW
path creates this:

  ccwchain->pfn_array_table[1]->pfn_array[#pages]

while an IDA CCW creates:

  ccwchain->pfn_array_table[#idaws]->pfn_array[1]

The distinction appears to state that each pfn_array_table entry
points to an array of contiguous pages, represented by a pfn_array,
um, array.  Since the direct-addressed scenario can ONLY represent
contiguous pages, it makes the intermediate array necessary but
difficult to recognize.  Meanwhile, since an IDAL can contain
non-contiguous pages and there is no logic in vfio-ccw to detect
adjacent IDAWs, it is the second array that is necessary but appearing
to be superfluous.

I am not aware of any documentation that states the pfn_array[] needs
to be of contiguous pages; it is just what the code does today.
I don't see any reason for this either, let's just flip the IDA
codepath around so that it generates:

  ch_pat->pfn_array_table[1]->pfn_array[#idaws]

This will bring it in line with the direct-addressed codepath,
so that we can understand the behavior of this memory regardless
of what type of CCW is being processed.  And it means the casual
observer does not need to know/care whether the pfn_array[]
represents contiguous pages or not.

NB: The existing vfio-ccw code only supports 4K-block Format-2 IDAs,
so that "#pages" == "#idaws" in this area.  This means that we will
have difficulty with this overlap in terminology if support for
Format-1 or 2K-block Format-2 IDAs is ever added.  I don't think that
this patch changes our ability to make that distinction.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 5b98bea433b7..86a0e76ef2b5 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -635,7 +635,6 @@ static int ccwchain_fetch_idal(struct ccwchain *chain,
 {
 	struct ccw1 *ccw;
 	struct pfn_array_table *pat;
-	struct pfn_array *pa;
 	unsigned long *idaws;
 	u64 idaw_iova;
 	unsigned int idaw_nr, idaw_len;
@@ -656,10 +655,14 @@ static int ccwchain_fetch_idal(struct ccwchain *chain,
 
 	/* Pin data page(s) in memory. */
 	pat = chain->ch_pat + idx;
-	ret = pfn_array_table_init(pat, idaw_nr);
+	ret = pfn_array_table_init(pat, 1);
 	if (ret)
 		goto out_init;
 
+	ret = pfn_array_alloc(pat->pat_pa, idaw_iova, bytes);
+	if (ret)
+		goto out_unpin;
+
 	/* Translate idal ccw to use new allocated idaws. */
 	idaws = kzalloc(idaw_len, GFP_DMA | GFP_KERNEL);
 	if (!idaws) {
@@ -673,22 +676,15 @@ static int ccwchain_fetch_idal(struct ccwchain *chain,
 
 	ccw->cda = virt_to_phys(idaws);
 
-	for (i = 0; i < idaw_nr; i++) {
-		idaw_iova = *(idaws + i);
-		pa = pat->pat_pa + i;
-
-		ret = pfn_array_alloc(pa, idaw_iova, 1);
-		if (ret < 0)
-			goto out_free_idaws;
-
-		if (!ccw_does_data_transfer(ccw)) {
-			pa->pa_nr = 0;
-			continue;
-		}
+	for (i = 0; i < idaw_nr; i++)
+		pat->pat_pa->pa_iova_pfn[i] = idaws[i] >> PAGE_SHIFT;
 
-		ret = pfn_array_pin(pa, cp->mdev);
+	if (ccw_does_data_transfer(ccw)) {
+		ret = pfn_array_pin(pat->pat_pa, cp->mdev);
 		if (ret < 0)
 			goto out_free_idaws;
+	} else {
+		pat->pat_pa->pa_nr = 0;
 	}
 
 	pfn_array_table_idal_create_words(pat, idaws);
-- 
2.17.1

