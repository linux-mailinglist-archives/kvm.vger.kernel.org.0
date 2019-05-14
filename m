Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C89E1E5BC
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 01:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfENXnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 19:43:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36950 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726659AbfENXm6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 May 2019 19:42:58 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4ENMWWQ059890
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 19:42:57 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sg31128p4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 19:42:56 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Wed, 15 May 2019 00:42:54 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 May 2019 00:42:53 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4ENgqLV61538422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 23:42:52 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDA5D4203F;
        Tue, 14 May 2019 23:42:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D354342045;
        Tue, 14 May 2019 23:42:51 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 14 May 2019 23:42:51 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 36EF4E15C3; Wed, 15 May 2019 01:42:51 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 5/7] s390/cio: Allow zero-length CCWs in vfio-ccw
Date:   Wed, 15 May 2019 01:42:46 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190514234248.36203-1-farman@linux.ibm.com>
References: <20190514234248.36203-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19051423-4275-0000-0000-00000334CFB5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051423-4276-0000-0000-00003844515C
Message-Id: <20190514234248.36203-6-farman@linux.ibm.com>
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
address even though no data will be transferred.

Note that this doesn't provide us with a channel program that will
fail in the expected way.  Since our length is zero, vfio_pin_pages()
returns -EINVAL and cp_prefetch() will thus fail.  This will be fixed
in the next patch.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 0a97978d1d28..a68711114aab 100644
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
 
@@ -372,8 +369,6 @@ static void ccwchain_cda_free(struct ccwchain *chain, int idx)
 
 	if (ccw_is_test(ccw) || ccw_is_noop(ccw) || ccw_is_tic(ccw))
 		return;
-	if (!ccw->count)
-		return;
 
 	kfree((void *)(u64)ccw->cda);
 }
@@ -558,18 +553,12 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 	struct pfn_array_table *pat;
 	unsigned long *idaws;
 	int ret;
+	int bytes = 1;
 
 	ccw = chain->ch_ccw + idx;
 
-	if (!ccw->count) {
-		/*
-		 * We just want the translation result of any direct ccw
-		 * to be an IDA ccw, so let's add the IDA flag for it.
-		 * Although the flag will be ignored by firmware.
-		 */
-		ccw->flags |= CCW_FLAG_IDA;
-		return 0;
-	}
+	if (ccw->count)
+		bytes = ccw->count;
 
 	/*
 	 * Pin data page(s) in memory.
@@ -581,7 +570,7 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,
 	if (ret)
 		goto out_init;
 
-	ret = pfn_array_alloc(pat->pat_pa, ccw->cda, ccw->count);
+	ret = pfn_array_alloc(pat->pat_pa, ccw->cda, bytes);
 	if (ret < 0)
 		goto out_unpin;
 
@@ -620,17 +609,18 @@ static int ccwchain_fetch_idal(struct ccwchain *chain,
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
2.17.1

