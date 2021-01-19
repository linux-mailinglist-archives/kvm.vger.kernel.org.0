Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C832FBEDF
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 19:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392593AbhASSZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 13:25:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41650 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731808AbhASSQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 13:16:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JIADZs064407;
        Tue, 19 Jan 2021 18:16:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=vgp9jsVnFm/gP6aJyenQcGYZM+2qBozeWW8dnlKiEEo=;
 b=qHU0go1B6VsVYjzpALx9Y1o/w7OLso2lPAuiV/zNipaUWqQAXRDNvPYqkR39chtleZm2
 PhRkgAWRo7NEtl+nWUuJH0qbKM8YP4BRvuFXn/bQojA68XtdUW4FwVqADevDB6M7Mzf7
 X6XPJgjy1ROWC+0fzfwAi3EXynyMo05vv/R/oyQBSqulHhULO+0+Y2kR2qg+G25tvrPp
 G70eyHiphjEr8Umk08E8KDLeGOMkokCh8dHzjS0UaVVfUJRbW/qJv4euGpAFStFFnolS
 mA91/jvmsyIY3/oQX2I0NdORwo3M41tJhS5ERsgAjAdxiF1iW0TtCqCYeTBWlPVjwDJ+ dQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 363r3ktcpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:16:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JIAdkQ051066;
        Tue, 19 Jan 2021 18:16:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 3661khmfr8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:16:00 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10JIFxPc027489;
        Tue, 19 Jan 2021 18:15:59 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Jan 2021 10:15:59 -0800
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V2 0/9] vfio virtual address update
Date:   Tue, 19 Jan 2021 09:48:20 -0800
Message-Id: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add interfaces that allow the underlying memory object of an iova range
to be mapped to a new virtual address in the host process:

  - VFIO_DMA_UNMAP_FLAG_VADDR for VFIO_IOMMU_UNMAP_DMA
  - VFIO_DMA_MAP_FLAG_VADDR flag for VFIO_IOMMU_MAP_DMA
  - VFIO_UPDATE_VADDR for VFIO_CHECK_EXTENSION
  - VFIO_DMA_UNMAP_FLAG_ALL for VFIO_IOMMU_UNMAP_DMA
  - VFIO_UNMAP_ALL for VFIO_CHECK_EXTENSION

Unmap-vaddr invalidates the host virtual address in an iova range and blocks
vfio translation of host virtual addresses, but DMA to already-mapped pages
continues.  Map-vaddr updates the base VA and resumes translation.  The
implementation supports iommu type1 and mediated devices.  Unmap-all allows
all ranges to be unmapped or invalidated in a single ioctl, which simplifies
userland code.

This functionality is necessary for live update, in which a host process
such as qemu exec's an updated version of itself, while preserving its
guest and vfio devices.  The process blocks vfio VA translation, exec's
its new self, mmap's the memory object(s) underlying vfio object, updates
the VA, and unblocks translation.  For a working example that uses these
new interfaces, see the QEMU patch series "[PATCH V2] Live Update" at
https://lore.kernel.org/qemu-devel/1609861330-129855-1-git-send-email-steven.sistare@oracle.com

Patches 1-4 define and implement the flag to unmap all ranges.
Patches 5-6 define and implement the flags to update vaddr.
Patches 7-9 add blocking to complete the implementation.

Changes from V1:
 - define a flag for unmap all instead of special range values
 - define the VFIO_UNMAP_ALL extension
 - forbid the combination of unmap-all and get-dirty-bitmap
 - unwind in unmap on vaddr error
 - add a new function to find first dma in a range instead of modifying
   an existing function
 - change names of update flags
 - fix concurrency bugs due to iommu lock being dropped
 - call down from from vfio to a new backend interface instead of up from
   driver to detect container close
 - use wait/wake instead of sleep and polling
 - refine the uapi specification
 - split patches into vfio vs type1

Steve Sistare (9):
  vfio: option to unmap all
  vfio/type1: find first dma
  vfio/type1: unmap cleanup
  vfio/type1: implement unmap all
  vfio: interfaces to update vaddr
  vfio/type1: implement interfaces to update vaddr
  vfio: iommu driver notify callback
  vfio/type1: implement notify callback
  vfio/type1: block on invalid vaddr

 drivers/vfio/vfio.c             |   5 +
 drivers/vfio/vfio_iommu_type1.c | 229 ++++++++++++++++++++++++++++++++++------
 include/linux/vfio.h            |   5 +
 include/uapi/linux/vfio.h       |  27 +++++
 4 files changed, 231 insertions(+), 35 deletions(-)

-- 
1.8.3.1

