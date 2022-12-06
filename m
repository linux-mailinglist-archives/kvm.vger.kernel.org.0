Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB0B644E3C
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 22:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiLFV4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 16:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiLFVz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 16:55:59 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8051D43849
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 13:55:58 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6LKhF7002954;
        Tue, 6 Dec 2022 21:55:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2022-7-12;
 bh=Wj9cvautm9aIV3D5M5fR8xaZT+w420AnZJFccrvtOPg=;
 b=CX3TGu8YCpD2GH69zK+D8d4rKICbX1Sc+eTTc35FnMRcULWr8vAIvbT+WEoJo85/J5Zy
 BI9ADXukRoBG+qHOc/XneZVOHr6aerERAvXDcYlF7awsCtRexvGlhqjwb1EXDaJ4/JiB
 GejOno8uOwxkZlDZ/rZq35SHRFqBR8KhBR4ERPCx7Wd9zdhLCu44MliaWF3P/X3VvcaT
 juwHo8rwYFSMOupI2lr15+m89qWPAgoOJsjD4XLbAXGiYr17qVEE6nVUCn1gl14iZF0S
 2eeB1MTQxbxJFNheJ9RSBPucvpf9e+DnYJiKAbBElsLvmrC3x7GooELB/QQF8VS0YDOW ig== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ydjhbfn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 21:55:55 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B6LM3Yg033054;
        Tue, 6 Dec 2022 21:55:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7b2m96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 21:55:55 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B6Lts0h038701;
        Tue, 6 Dec 2022 21:55:54 GMT
Received: from ca-dev63.us.oracle.com (ca-dev63.us.oracle.com [10.211.8.221])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3maa7b2m8v-1;
        Tue, 06 Dec 2022 21:55:54 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V1 0/8] vfio virtual address update redo
Date:   Tue,  6 Dec 2022 13:55:45 -0800
Message-Id: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_12,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=907 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212060184
X-Proofpoint-ORIG-GUID: zeLbD4jNzesE-ilCps293GtESIbcIChI
X-Proofpoint-GUID: zeLbD4jNzesE-ilCps293GtESIbcIChI
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Re-architect the interfaces that allow the underlying memory object of an
iova range to be mapped in a new address space.  The old interfaces allow
userland to indefinitely block vfio mediated device kernel threads, and do
not propagate the locked_vm count to a new mm.

Interface changes:
  - disable the VFIO_UPDATE_VADDR extension
  - delete VFIO_DMA_UNMAP_FLAG_VADDR
  - redefine VFIO_DMA_MAP_FLAG_VADDR

New interfaces:
  - VFIO_CHANGE_DMA_OWNER iommu driver ioctl
  - VFIO_DMA_OWNER extension, consisting of VFIO_CHANGE_DMA_OWNER and the
    redefined VFIO_DMA_MAP_FLAG_VADDR.

VFIO_DMA_MAP_FLAG_VADDR changes the base virtual address for a dma mapping.
It is called after exec, after the application remaps the corresponding shared
memory object that was preserved across exec.  However, the change does not
take effect until VFIO_CHANGE_DMA_OWNER is called.  This allows the application
to iterate and register a new vaddr for all dma's, and have them take effect
atomically.

VFIO_CHANGE_DMA_OWNER changes the task and mm for all dma mappings to that of
the caller, and transfers the locked_vm count from the old to the new mm.  The
vaddr for each mapping must either be the same in the old and new mm (eg after
fork), or must have been updated with VFIO_DMA_MAP_FLAG_VADDR (eg after exec).
Subsequently, the caller is the only task that is allowed to pin pages for dma.
This prevents an application from exceeding the initial task's RLIMIT_MEMLOCK
by fork'ing and pinning in children.

These interfaces can be used to implement live update, in which a process such
as qemu exec's an updated version of itself, while preserving its guest and
vfio devices.  The application must preserve the vfio descriptors across fork
and exec, and must not start each step below until the previous step has
finished.

  parent				      child

  1. fork
					      2. ioctl(VFIO_CHANGE_DMA_OWNER)
  3. exec new binary

  4. foreach dma mapping
       va = mmap()
       ioctl(, VFIO_DMA_MAP_FLAG_VADDR, va)

     ioctl(VFIO_CHANGE_DMA_OWNER)

					      5. exit

With this arrangement, the dma mappings are always associated with a valid
mm, and mediated device requests such as vfio_pin_pages and vfio_dma_rw block
only briefly during the ioctls.  Thanks to Jason Gunthorpe for suggesting fork
and the change mm ioctl.

Lastly, if a task exits or execs, and it still owns any dma mappings, they
are unmapped and unpinned.  This guarantees that pages do not remain pinned
indefinitely if a vfio descriptor is leaked to another process, and requires
tasks to explicitly transfer ownership of dma (and hence locked_vm) to a new
task and mm when continued operation is desired.  The vfio driver maps a
special vma so it can detect exit and exec, via the vm_operations_struct
close callback.

Steve Sistare (8):
  vfio: delete interfaces to update vaddr
  vfio/type1: dma owner permission
  vfio: close dma owner
  vfio/type1: close dma owner
  vfio/type1: track locked_vm per dma
  vfio/type1: update vaddr
  vfio: change dma owner
  vfio/type1: change dma owner

 drivers/vfio/container.c        | 169 ++++++++++++++++++-
 drivers/vfio/vfio.h             |   9 +-
 drivers/vfio/vfio_iommu_type1.c | 362 +++++++++++++++++++++++-----------------
 include/uapi/linux/vfio.h       |  54 ++++--
 4 files changed, 412 insertions(+), 182 deletions(-)

-- 
1.8.3.1

