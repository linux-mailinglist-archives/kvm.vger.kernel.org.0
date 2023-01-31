Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B402683320
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 17:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbjAaQ6Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 11:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbjAaQ6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 11:58:20 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A3F1026C
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 08:58:15 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30VEDchq015092;
        Tue, 31 Jan 2023 16:58:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2022-7-12;
 bh=D4Ur5pAwve7YT7Q0A8n4AyX8W65IbLLdA+s3KnLI6yo=;
 b=SuJszX+nZaWqpY8Q1O4PHxp+8YfwCq49Oz3gix0fQP73Lq1TP6XXnV65Je3AE3ruQ4ki
 HWj+GQDPduGitiO3Di1o5xRXjFsvIhG9jC6cAkC9LeM7CZOqQmn/hbfX3DmTTNtnPGTa
 hVaOSBTGpma3ddRwHLKKTlvm/o6XSnC9v7ASW44OXaIzu64fg2t+HATC+uULF9H0A6O9
 ebaRQn7hZx+NY5QjVA502E795VQp6VmXK9RWA7kpY6d2g15p/Sz8Fr8X1mlfawHN/CUP
 xxUIaBrh+LFX9lLqW4ZOgTXuxICyRvMtwEOqGUoTJXIE58DCTMd9C9f/MNngStavoCs+ +Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvmhp4t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 16:58:11 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30VGXH9c025085;
        Tue, 31 Jan 2023 16:58:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct566vab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 16:58:10 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30VGw98h002013;
        Tue, 31 Jan 2023 16:58:09 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3nct566v9x-1;
        Tue, 31 Jan 2023 16:58:09 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V8 0/7] fixes for virtual address update
Date:   Tue, 31 Jan 2023 08:58:02 -0800
Message-Id: <1675184289-267876-1-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_08,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301310150
X-Proofpoint-ORIG-GUID: zXEo6XSX8E8iKuql9JNpzBSz-YQz5AAz
X-Proofpoint-GUID: zXEo6XSX8E8iKuql9JNpzBSz-YQz5AAz
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

Changes in v8:
  * updated group_leader comment in vfio_dma_do_map
  * delete async arg from mm_lock_acct
  * pass async=false to vfio_lock_acct in vfio_pin_page_external
  * locked_vm becomes size_t
  * improved commit message in "restore locked_vm"
  * simplified flow in vfio_change_dma_owner
  * rebase to v6.2-rc6

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
 drivers/vfio/vfio_iommu_type1.c | 248 ++++++++++++++++++----------------------
 include/uapi/linux/vfio.h       |  15 ++-
 4 files changed, 120 insertions(+), 155 deletions(-)

-- 
1.8.3.1

