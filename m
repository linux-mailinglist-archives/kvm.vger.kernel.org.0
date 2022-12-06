Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAA7644E42
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 22:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiLFV4M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 16:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiLFV4B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 16:56:01 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C614C4875E
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 13:56:00 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6LKsHn027048;
        Tue, 6 Dec 2022 21:55:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=Usi00A1kgAqoDZOEZaUW0ixkNJsjTxjllytfirVHv+s=;
 b=WL+tz7FiZHp4VUCKwrLDv1DB7Ug3X9eMbi8RFxrcnzp41I6UzCszJ6zDcIo18muOX+0M
 WjwleW6F/QSfQ64qg82A0pIfGbCFIhQH+OC52Zu+jkdx4Ya4g1l0sEmWAl6S6hwQHp69
 r7PZjymoR0BrKt6c3LLZ778pZD95vpcWqgHIS38RUNx3XblHf2aMrFgrkUIcKLvt5JoY
 thmJYwoBLBudKTlV/oB0HokKjBnzaXeynW2OJ6/4m6ymSOs66rhlEjVhBo6yQHvmMJ2e
 LRhrtHd3h1H0DjfN1O0oRAdZfZlNsIzaWXk/n39tpUt8dPRXtvviiTbqjGaizhtpOI6F Eg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ycf91f2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 21:55:57 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B6LLBQA032611;
        Tue, 6 Dec 2022 21:55:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7b2mak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 21:55:57 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B6Lts0r038701;
        Tue, 6 Dec 2022 21:55:56 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3maa7b2m8v-6;
        Tue, 06 Dec 2022 21:55:56 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V1 5/8] vfio/type1: track locked_vm per dma
Date:   Tue,  6 Dec 2022 13:55:50 -0800
Message-Id: <1670363753-249738-6-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_12,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212060184
X-Proofpoint-ORIG-GUID: SSgSud_kOB4Ls1xbeXZhD8TWu4GF0e4J
X-Proofpoint-GUID: SSgSud_kOB4Ls1xbeXZhD8TWu4GF0e4J
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track locked_vm per dma struct, and create a new subroutine, both for use
in a subsequent patch.  No functional change.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 51bb687..3bd89d5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -97,6 +97,7 @@ struct vfio_dma {
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
 	struct vfio_iommu	*iommu;		/* back pointer */
+	uint64_t		locked_vm;
 };
 
 struct vfio_batch {
@@ -407,6 +408,19 @@ static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
 	return ret;
 }
 
+static int mm_lock_vm(struct task_struct *task, struct mm_struct *mm,
+		      bool lock_cap, long npage)
+{
+	int ret = mmap_write_lock_killable(mm);
+
+	if (!ret) {
+		ret = __account_locked_vm(mm, abs(npage), npage > 0, task,
+					  lock_cap);
+		mmap_write_unlock(mm);
+	}
+	return ret;
+}
+
 static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
 {
 	struct task_struct *task = dma->iommu->task;
@@ -429,12 +443,9 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
 	if (!mm)
 		return -ESRCH; /* process exited */
 
-	ret = mmap_write_lock_killable(mm);
-	if (!ret) {
-		ret = __account_locked_vm(mm, abs(npage), npage > 0, task,
-					  dma->lock_cap);
-		mmap_write_unlock(mm);
-	}
+	ret = mm_lock_vm(task, mm, dma->lock_cap, npage);
+	if (!ret)
+		dma->locked_vm += npage;
 
 	if (async)
 		mmput(mm);
-- 
1.8.3.1

