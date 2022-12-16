Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C38564F13D
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 19:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbiLPSu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 13:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231470AbiLPSuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 13:50:50 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470011D0EC
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 10:50:47 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BGGhqC1016779;
        Fri, 16 Dec 2022 18:50:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2022-7-12;
 bh=2mEJPzRn86V/gkkSoSc3OWQBLusJgwdkSLJOJoFQVzc=;
 b=ROxtKhmS8gl390DqVseOyDiFH7eXRh8K7JbDpUAL7HgI9Uk2QKZdx9on4Mtj+GDmley9
 PkhGOCbBCbdOIu7bDQFkAF+EB1S6G+pdg0vMbqIRXLqv4SOoB+zHjf9ES4HvDtCBPcTz
 f6DXfZr6EW1mtL4CfYKqwiOpbYQqk8gorQJ/4dV/CYBiAqOjNoB9lY+8BkhRnFczQcAB
 Z3961HoApFzD4kpasazQcuq8kcvG8ObtJmedDIKcmewzuIPhwCKxmFr2yKft0KPPHBT5
 e1csIKnrPEgntk9ex/IvrtOgVhgGc2/oljl0kC6ckw74GkwC9itUG0aMuyUEEBJZ1/WZ Qg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewg54b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Dec 2022 18:50:42 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BGHKNRo027672;
        Fri, 16 Dec 2022 18:50:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyesnv3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Dec 2022 18:50:41 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BGIofeG032502;
        Fri, 16 Dec 2022 18:50:41 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3meyesnv2x-1;
        Fri, 16 Dec 2022 18:50:41 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V6 0/7] fixes for virtual address update
Date:   Fri, 16 Dec 2022 10:50:33 -0800
Message-Id: <1671216640-157935-1-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-16_12,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212160164
X-Proofpoint-GUID: adEqnV7MDyGp8rX3T7LO46sZ0HcaT7YG
X-Proofpoint-ORIG-GUID: adEqnV7MDyGp8rX3T7LO46sZ0HcaT7YG
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix bugs in the interfaces that allow the underlying memory object of an
iova range to be mapped in a new address space.  They allow userland to
indefinitely block vfio mediated device kernel threads, and do not
propagate the locked_vm count to a new mm.  Also fix a pre-existing bug
that allows locked_vm underflow.

The fixes impose restrictions that eliminate waiting conditions, so
revert the dead code:
  commit 898b9eaeb3fe ("vfio/type1: block on invalid vaddr")
  commit 487ace134053 ("vfio/type1: implement notify callback")
  commit ec5e32940cc9 ("vfio: iommu driver notify callback")

Changes in V2 (thanks Alex):
  * do not allow group attach while vaddrs are invalid
  * add patches to delete dead code
  * add WARN_ON for never-should-happen conditions
  * check for changed mm in unmap.
  * check for vfio_lock_acct failure in remap

Changes in V3 (ditto!):
  * return errno at WARN_ON sites, and make it unique
  * correctly check for dma task mm change
  * change dma owner to current when vaddr is updated
  * add Fixes to commit messages
  * refactored new code in vfio_dma_do_map

Changes in V4:
  * misc cosmetic changes

Changes in V5 (thanks Jason and Kevin):
  * grab mm and use it for locked_vm accounting
  * separate patches for underflow and restoring locked_vm
  * account for reserved pages
  * improve error messages

Changes in V6:
  * drop "count reserved pages" patch
  * add "track locked_vm" patch
  * grab current->mm not group_leader->mm
  * simplify vfio_change_dma_owner
  * fix commit messages

Steve Sistare (7):
  vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
  vfio/type1: prevent underflow of locked_vm via exec()
  vfio/type1: track locked_vm per dma
  vfio/type1: restore locked_vm
  vfio/type1: revert "block on invalid vaddr"
  vfio/type1: revert "implement notify callback"
  vfio: revert "iommu driver notify callback"

 drivers/vfio/container.c        |   5 -
 drivers/vfio/vfio.h             |   7 --
 drivers/vfio/vfio_iommu_type1.c | 226 ++++++++++++++++++----------------------
 include/uapi/linux/vfio.h       |  15 +--
 4 files changed, 111 insertions(+), 142 deletions(-)

-- 
1.8.3.1

