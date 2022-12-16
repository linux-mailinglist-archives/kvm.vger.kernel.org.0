Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943C364F140
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 19:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiLPSvE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 13:51:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231504AbiLPSuw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 13:50:52 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19AE1E73F
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 10:50:48 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BGGhhK7027617;
        Fri, 16 Dec 2022 18:50:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=ctvqsPkAuGkDuVcyN7DNqlN53Zgo9ZZmhVWMtI77c3A=;
 b=hq9yQiuSlEHIWWWWYlSypnTVU/Ajq0mkcER2vx1+bNh0cSuFnKET3prh4mVeHdcekMNZ
 U6DvvPsQK8M4owWi9WL0FT+jPeMW8I8+83FDzjqH8o3h+59jg1yaW119/pGlGlW2VxtP
 bcVuhYYdBxBpWKpFT/8krFx/fFDK8R6iA3/3MoeiO+SQnEqMNooKD9sbz6tC1pGmgh5E
 kFUADP3SZ1W6/k8ADrCB/i0qBm2zV/ofISzQ08FspJ+SaXt/m6irVMyVp902ukpKwWwl
 Lcq6zdiFfdUwEU4O2N9AQ8INcqeUuBLlGXt1u4e6cT/KJmPEe9wcwngb6fY23wv2Zj1Z ww== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyex05ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Dec 2022 18:50:43 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BGHNDhG027747;
        Fri, 16 Dec 2022 18:50:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyesnv4p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Dec 2022 18:50:42 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BGIofeM032502;
        Fri, 16 Dec 2022 18:50:42 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3meyesnv2x-4;
        Fri, 16 Dec 2022 18:50:42 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V6 3/7] vfio/type1: track locked_vm per dma
Date:   Fri, 16 Dec 2022 10:50:36 -0800
Message-Id: <1671216640-157935-4-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1671216640-157935-1-git-send-email-steven.sistare@oracle.com>
References: <1671216640-157935-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-16_12,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212160164
X-Proofpoint-GUID: uMPl0mLC40X9oh5VkldymIIDLWXLnqbb
X-Proofpoint-ORIG-GUID: uMPl0mLC40X9oh5VkldymIIDLWXLnqbb
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

Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
Cc: stable@vger.kernel.org
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 71f980b..889e920 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -101,6 +101,7 @@ struct vfio_dma {
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
 	struct mm_struct	*mm;
+	long			locked_vm;
 };
 
 struct vfio_batch {
@@ -413,22 +414,21 @@ static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
 	return ret;
 }
 
-static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
+static int task_lock_acct(struct task_struct *task, struct mm_struct *mm,
+			  bool lock_cap, long npage, bool async)
 {
-	struct mm_struct *mm;
 	int ret;
 
 	if (!npage)
 		return 0;
 
-	mm = dma->mm;
 	if (async && !mmget_not_zero(mm))
 		return -ESRCH; /* process exited */
 
 	ret = mmap_write_lock_killable(mm);
 	if (!ret) {
-		ret = __account_locked_vm(mm, abs(npage), npage > 0, dma->task,
-					  dma->lock_cap);
+		ret = __account_locked_vm(mm, abs(npage), npage > 0, task,
+					  lock_cap);
 		mmap_write_unlock(mm);
 	}
 
@@ -438,6 +438,16 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
 	return ret;
 }
 
+static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
+{
+	int ret;
+
+	ret = task_lock_acct(dma->task, dma->mm, dma->lock_cap, npage, async);
+	if (!ret)
+		dma->locked_vm += npage;
+	return ret;
+}
+
 /*
  * Some mappings aren't backed by a struct page, for example an mmap'd
  * MMIO range for our own or another device.  These use a different
-- 
1.8.3.1

