Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B87308B72
	for <lists+kvm@lfdr.de>; Fri, 29 Jan 2021 18:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbhA2RXU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jan 2021 12:23:20 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43214 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhA2RXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jan 2021 12:23:06 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10THAU2Z084667;
        Fri, 29 Jan 2021 17:22:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=qNS/ux2mvp4CbiboRHQeseZysbcuTCPocxxY/OI6R0Q=;
 b=vAMr0svoOw+xCEb+PJEhCk2jmFIpzpj8/tldM9xx3owHEBG1D4zXfbfflMBVwi+yHMz9
 uu7U+EmyuOViinmZz5N9FCqqPiFW32T6y0HOuBK5oTZLJp+6nhKbINRieO/YcKFZFe6a
 csxOPny/Hbw5laN7006R5FnV5m/Adj97GTdKsObdWtdK2ksO+dvsoArvMZ1uumVSsROn
 kjl/97NdMljWWFkO5xjW9/Ig9f2RTT5zq1cK/cqQAF/GHeK7dd4K30HmN9iu+jRRhM4J
 IbvyWHVjhJpEsjtpTbVLlMoWuYK0R/1lMkGjk8bez4YnwOWBIw+hvqrp9wjv3+gwT/xo MA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 3689ab2kff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:22:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TH6KIc192628;
        Fri, 29 Jan 2021 17:22:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 368wr26wpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 17:22:20 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10THMJwf019124;
        Fri, 29 Jan 2021 17:22:19 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 29 Jan 2021 09:22:19 -0800
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V3 0/9] vfio virtual address update
Date:   Fri, 29 Jan 2021 08:54:03 -0800
Message-Id: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290084
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290084
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

Patches 1-3 define and implement the flag to unmap all ranges.
Patches 4-6 define and implement the flags to update vaddr.
Patches 7-9 add blocking to complete the implementation.

Changes in V2:
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

Changes in V3:
 - add vaddr_invalid_count to fix pin_pages race with unmap
 - refactor the wait helper functions
 - traverse dma entries more efficiently in unmap
 - check unmap flag conflicts more explicitly
 - rename some local variables and functions

Steve Sistare (9):
  vfio: option to unmap all
  vfio/type1: unmap cleanup
  vfio/type1: implement unmap all
  vfio: interfaces to update vaddr
  vfio/type1: massage unmap iteration
  vfio/type1: implement interfaces to update vaddr
  vfio: iommu driver notify callback
  vfio/type1: implement notify callback
  vfio/type1: block on invalid vaddr

 drivers/vfio/vfio.c             |   5 +
 drivers/vfio/vfio_iommu_type1.c | 251 +++++++++++++++++++++++++++++++++++-----
 include/linux/vfio.h            |   5 +
 include/uapi/linux/vfio.h       |  27 +++++
 4 files changed, 256 insertions(+), 32 deletions(-)

-- 
1.8.3.1

