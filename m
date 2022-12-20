Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36DF16527F9
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 21:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbiLTUjq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 15:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbiLTUje (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 15:39:34 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32019101F0
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 12:39:34 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKJwstm008687;
        Tue, 20 Dec 2022 20:39:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=txwcAUFkgSerkVFT77lycVocIuE0DlMiSijuebOH+ak=;
 b=hn1HpwxxingAWb5/iw03Grz3HDhLH36soGk+CIX1qHm4WLkotOq6kiTLp1IPCFNTHXzc
 1nunk37t6yAbseZcscWpsvmgJDA4L9XwVGVK2wNPIkTQl2/8uxC5+8ybBfQTf1kf5gyE
 RgYmCkbQcNpLdaC7O98g7kAx+gCHE02JfNTrTeCL3fGiSKGJeZkZBc8ApTrgQjmNAwC7
 /azuqXy+goHPIBa2GzIkve6EWEhNcgbiCC+WURsJbLVoq5/R6fIMSlOwd+c94Ani+uKM
 De2A4WitGgLN0zwwMpvXrPpnjBztp7c/fEy+MHFv8I+ZDLp6YdxtyQEqAzbxa51eMiO5 TA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tmy12r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 20:39:29 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BKKQP2D012253;
        Tue, 20 Dec 2022 20:39:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh475vcnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 20:39:28 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BKKdQ0s014895;
        Tue, 20 Dec 2022 20:39:28 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3mh475vcks-5;
        Tue, 20 Dec 2022 20:39:28 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V7 4/7] vfio/type1: restore locked_vm
Date:   Tue, 20 Dec 2022 12:39:22 -0800
Message-Id: <1671568765-297322-5-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1671568765-297322-1-git-send-email-steven.sistare@oracle.com>
References: <1671568765-297322-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212200169
X-Proofpoint-ORIG-GUID: vurKEhAvtytmI4BVk6gXDZodsE8VTtey
X-Proofpoint-GUID: vurKEhAvtytmI4BVk6gXDZodsE8VTtey
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a vfio container is preserved across exec or fork-exec, the new
task's mm has a locked_vm count of 0.  After a dma vaddr is updated using
VFIO_DMA_MAP_FLAG_VADDR, locked_vm remains 0, and the pinned memory does
not count against the task's RLIMIT_MEMLOCK.

To restore the correct locked_vm count, when VFIO_DMA_MAP_FLAG_VADDR is
used and the dma's mm has changed, add the dma's locked_vm count to
the new mm->locked_vm, subject to the rlimit.

Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
Cc: stable@vger.kernel.org
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 588d690..1036736 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1590,6 +1590,35 @@ static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
 	return list_empty(iova);
 }
 
+static int vfio_change_dma_owner(struct vfio_dma *dma)
+{
+	int ret = 0;
+	struct task_struct *task = current->group_leader;
+	struct mm_struct *mm = current->mm;
+
+	if (mm != dma->mm) {
+		long npage = dma->locked_vm;
+		bool lock_cap = capable(CAP_IPC_LOCK);
+
+		ret = mm_lock_acct(task, mm, lock_cap, npage, false);
+		if (ret)
+			return ret;
+
+		mm_lock_acct(dma->task, dma->mm, dma->lock_cap, -npage, true);
+
+		if (dma->task != task) {
+			put_task_struct(dma->task);
+			dma->task = get_task_struct(task);
+		}
+		mmdrop(dma->mm);
+		dma->mm = mm;
+		mmgrab(dma->mm);
+		dma->lock_cap = lock_cap;
+	}
+
+	return ret;
+}
+
 static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			   struct vfio_iommu_type1_dma_map *map)
 {
@@ -1639,6 +1668,9 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			   dma->size != size) {
 			ret = -EINVAL;
 		} else {
+			ret = vfio_change_dma_owner(dma);
+			if (ret)
+				goto out_unlock;
 			dma->vaddr = vaddr;
 			dma->vaddr_invalid = false;
 			iommu->vaddr_invalid_count--;
-- 
1.8.3.1

