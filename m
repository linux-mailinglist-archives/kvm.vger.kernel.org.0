Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3CE6527FF
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 21:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbiLTUji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 15:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234312AbiLTUjd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 15:39:33 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9539FCE2
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 12:39:32 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKJxHG7004720;
        Tue, 20 Dec 2022 20:39:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2022-7-12;
 bh=7dM+3fjcuWNeyADvyjQnR3O7DfKwlx7AQjEykXjgl20=;
 b=y4aQHdhuPkN7llDy0LtKPUBG1uvPiWO6sQOZ8e8Jer48zyrg1DIp3gCn9PGiggRAZ6mq
 wT1on12muyQiJY4kCnnWlS8cbXYVVbBn3d90MfNpA5KQXtBVmFkN/Cd/AfYa+xngsAb8
 q6SoAsXguL+RS9A70mSKvf5bDE7CRyQgDGLrZ15kUqnBdkyI1NwtHgfQp0f+lBfkkBuW
 oi6ua9gvJbEGKYK+fBin9BE0rDMX+Vb02dnHihcPqi2wzWy6cmbvIPgU6r+3bClVqTdg
 cU9cegMDkAblAPaR25maag910NN3W6ytlY5dWXSKva7O6NbeQACP/JSe+CM6QO/A60kZ iA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tnf5ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 20:39:27 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BKJEWt2012208;
        Tue, 20 Dec 2022 20:39:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh475vcma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 20:39:26 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BKKdQ0k014895;
        Tue, 20 Dec 2022 20:39:26 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3mh475vcks-1;
        Tue, 20 Dec 2022 20:39:26 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V7 0/7] fixes for virtual address update
Date:   Tue, 20 Dec 2022 12:39:18 -0800
Message-Id: <1671568765-297322-1-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212200169
X-Proofpoint-ORIG-GUID: oyp1ZrejpHXqLhLtCOIYzCSqCIZS5uug
X-Proofpoint-GUID: oyp1ZrejpHXqLhLtCOIYzCSqCIZS5uug
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

Changes in v7:
  * compare current->mm not group_leader->mm (missed one)
  * misc cosmetic changes

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

