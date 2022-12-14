Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719B264D00A
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238571AbiLNTXH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237321AbiLNTXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:23:04 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2011D30D
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 11:23:03 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEHFfxp025180;
        Wed, 14 Dec 2022 19:22:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2022-7-12;
 bh=Bu7WNG27VOibczxBKHxZqLp9v/uNMr/9TN/vPaBna0k=;
 b=x5yKn6qfCkOeyaDFBIODMB9JWzenivkUcYgQlz82fzQMPy5G9uNAyjhc3DypIoFbVMVa
 ZoK4BKQuCxfwfe6wHvNZNss+OCjTZFTKoU51FFOLOLKQDw8cgSiESe6eIDZEqIeYQ7N/
 67NLN7fMLvAWiqea5jtLUZz6V9Z1+GjBK+h8wIuLmnoQALQab+HGd2hUpTitJ+3zi5Yf
 GI2ZC+kzg8BDkzpyaovb44liMNSTTWaKjsMENr3yDQzTU+DrM0+gXeWSzyohcZVe2Wbt
 2FjIXGNxNyMCu2ddnt6s0AwTFS8Yf7MpTmEVOxXzcvwrjDS5WZzM66MRpiuq3Xe0nAF7 6w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyex35u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 19:22:59 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BEJ5b88007125;
        Wed, 14 Dec 2022 19:22:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyeqa839-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 19:22:57 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BEJMv37040903;
        Wed, 14 Dec 2022 19:22:57 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3meyeqa7y1-1;
        Wed, 14 Dec 2022 19:22:57 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V3 0/5] fixes for virtual address update
Date:   Wed, 14 Dec 2022 11:22:46 -0800
Message-Id: <1671045771-59788-1-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_10,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140157
X-Proofpoint-GUID: zdwqUkAI6gHXXExmrrQlxTKzU_2QD0OU
X-Proofpoint-ORIG-GUID: zdwqUkAI6gHXXExmrrQlxTKzU_2QD0OU
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
propagate the locked_vm count to a new mm.

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

Steve Sistare (5):
  vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
  vfio/type1: prevent locked_vm underflow
  vfio/type1: revert "block on invalid vaddr"
  vfio/type1: revert "implement notify callback"
  vfio: revert "iommu driver notify callback"

 drivers/vfio/container.c        |   5 --
 drivers/vfio/vfio.h             |   7 --
 drivers/vfio/vfio_iommu_type1.c | 193 +++++++++++++++++++---------------------
 include/uapi/linux/vfio.h       |  15 ++--
 4 files changed, 99 insertions(+), 121 deletions(-)

-- 
1.8.3.1

