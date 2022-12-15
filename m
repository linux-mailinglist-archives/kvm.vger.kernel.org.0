Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792A564E38B
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 22:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiLOV5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 16:57:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiLOV5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 16:57:12 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC4E5E082
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 13:57:11 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFL3f6Z030117;
        Thu, 15 Dec 2022 21:57:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2022-7-12;
 bh=ucvbiyH158wsBk5mxWNciSAMN1uSNZE8Q+RMg7gAhOE=;
 b=e8lM0e1Zr3vbHPs+7oan3PiznL0Br6jgkgjO69huS26wsXGMZ4ULTYREjFCLVc8/Rpb2
 Kyi8jNRgLDv87LRWrNcRzeEqk013T/954Yfj+KrmzEwTeGbIG+VAx1adyOJSWezDYJ6w
 9yFlppQVO8ranTvKyrxBijbnTtMSdd5SEWqLLNq7h7FO2tHV6LpBTvLBVSc+vDRxKxlJ
 xojimUXfBzWzT0OwhHtLA5lnxCmiDTMAYxuTeXOiJgpSE2L5GecravJZ+Du5cEnCjeNG
 CqL1bE7kncMIHrEtlgs04HD2RC5+ca83NWY7Jx2/ym+zUiScfbOP+SrI2pbl/A8W0drW aA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeue9qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 21:57:06 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFKHqtm032951;
        Thu, 15 Dec 2022 21:57:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyerdf2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 21:57:05 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BFLv5XG007209;
        Thu, 15 Dec 2022 21:57:05 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3meyerdf2f-1;
        Thu, 15 Dec 2022 21:57:05 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V5 0/7] fixes for virtual address update
Date:   Thu, 15 Dec 2022 13:56:57 -0800
Message-Id: <1671141424-81853-1-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_11,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150182
X-Proofpoint-ORIG-GUID: qnPmY28295y1dNNK6Ya-PwlX5KBijhB2
X-Proofpoint-GUID: qnPmY28295y1dNNK6Ya-PwlX5KBijhB2
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

Steve Sistare (7):
  vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
  vfio/type1: prevent locked_vm underflow
  vfio/type1: count reserved pages
  vfio/type1: restore locked_vm
  vfio/type1: revert "block on invalid vaddr"
  vfio/type1: revert "implement notify callback"
  vfio: revert "iommu driver notify callback"

 drivers/vfio/container.c        |   5 -
 drivers/vfio/vfio.h             |   7 --
 drivers/vfio/vfio_iommu_type1.c | 215 +++++++++++++++++++---------------------
 include/uapi/linux/vfio.h       |  15 +--
 4 files changed, 110 insertions(+), 132 deletions(-)

-- 
1.8.3.1

