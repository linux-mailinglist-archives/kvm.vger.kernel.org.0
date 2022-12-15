Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7917164E38F
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 22:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiLOV51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 16:57:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiLOV5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 16:57:14 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35B549B72
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 13:57:13 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFL3u1n026530;
        Thu, 15 Dec 2022 21:57:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2022-7-12;
 bh=VvxQ01uOzJ11T94Bx3CLwPH5gR/03ZQDOPGN59hu3jY=;
 b=bIERpTX7dsRwsrlFmY7/Vq4AC7RuMLqI1UqNZSHNns8omH83bjFHARu31+EdRO3F5x/3
 M6Oap02tctAp1AsJw+f6Zc3PS5YW0jR2OVEuVKEoezLI6D+Hv8z27IzzaufIwuraLdw1
 PAbclM2CUcyqnO6RfmhGTSFX4sQRTS3opU0rzBOSaf/dpmaABDPZ5NGJz9rTGCA4sC1t
 MaJyfa9wQnOZQNqMOP+OY9QnZDRKd94gUI90zQS96kPRxloC3j5euCOfrG8GzM9MttSr
 blm/JZ5cSqkzmd9nKyMaIrVfao6OgTjCFndjwrsL9T4ZRRj/OO2XhjXnCGTBiOJ4pVZ4 BQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyerxb1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 21:57:08 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFLoLo9033034;
        Thu, 15 Dec 2022 21:57:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyerdf43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 21:57:07 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BFLv5XO007209;
        Thu, 15 Dec 2022 21:57:07 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3meyerdf2f-5;
        Thu, 15 Dec 2022 21:57:07 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V5 4/7] vfio/type1: restore locked_vm
Date:   Thu, 15 Dec 2022 13:57:01 -0800
Message-Id: <1671141424-81853-5-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1671141424-81853-1-git-send-email-steven.sistare@oracle.com>
References: <1671141424-81853-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_11,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150182
X-Proofpoint-ORIG-GUID: -uNRGcpZdPVJGxQ2qszyjkgz7_ATF_C8
X-Proofpoint-GUID: -uNRGcpZdPVJGxQ2qszyjkgz7_ATF_C8
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
used and the dma's mm has changed, add the mapping's pinned page count to
the new mm->locked_vm, subject to the rlimit.  Now that mediated devices
are excluded when using VFIO_UPDATE_VADDR, the amount of pinned memory
equals the size of the mapping less the reserved page count.

Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 drivers/vfio/vfio_iommu_type1.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index add87cd..70b52e9 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1588,6 +1588,38 @@ static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
 	return list_empty(iova);
 }
 
+static int vfio_change_dma_owner(struct vfio_dma *dma)
+{
+	struct task_struct *new_task = current->group_leader;
+
+	if (new_task->mm != dma->mm) {
+		long npage = (dma->size >> PAGE_SHIFT) - dma->reserved_pages;
+		bool new_lock_cap = capable(CAP_IPC_LOCK);
+		int ret = mmap_write_lock_killable(new_task->mm);
+
+		if (ret)
+			return ret;
+
+		ret = __account_locked_vm(new_task->mm, npage, true,
+					  new_task, new_lock_cap);
+		mmap_write_unlock(new_task->mm);
+		if (ret)
+			return ret;
+
+		vfio_lock_acct(dma, -npage, true);
+		if (dma->task != new_task) {
+			put_task_struct(dma->task);
+			dma->task = get_task_struct(new_task);
+		}
+		mmdrop(dma->mm);
+		dma->mm = new_task->mm;
+		mmgrab(dma->mm);
+		dma->lock_cap = new_lock_cap;
+	}
+
+	return 0;
+}
+
 static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			   struct vfio_iommu_type1_dma_map *map)
 {
@@ -1637,6 +1669,9 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
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

