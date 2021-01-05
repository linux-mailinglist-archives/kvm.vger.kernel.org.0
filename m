Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FF62EAF98
	for <lists+kvm@lfdr.de>; Tue,  5 Jan 2021 17:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbhAEQEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 11:04:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45488 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbhAEQEo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 11:04:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105Ftaxt138051;
        Tue, 5 Jan 2021 16:04:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=+WNDGZkjkmbGjD0qeySWyhmpjWQiseiHSGHdw478vEY=;
 b=zyRRCjc06y2W0yacgp6ggzXAJQYzv81TOoHS/IqqFQC9Ku290PZG33y7jOj232N1BqdQ
 fSYniiGhU54EMnl/lRhnnozjp1QV50InHPgwAI4GKB37FWLejycz6jlMZ2lQyAQdAfyD
 pmGq7QcMtsm9XJoCaRg3EC0znfaDKU0hmU6sl9+1NZUr/xso9cYOHbEo7nvyXtK2Fq0L
 UfcGqmksXowujSfGOjFej+klgorfUFZ8ND0nWyNOFkl6KiZgNZkajaU2B0S7VJkaCDQe
 jYiJHBVQ7izmr+U7KmRpdMH5duBBYujrOTYSy40KXB6JOajGa9ARrbuQTu2XKBvjOwT/ Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 35tg8r1g67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 05 Jan 2021 16:04:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105Fuk53187327;
        Tue, 5 Jan 2021 16:03:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 35v1f8sedd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jan 2021 16:03:59 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 105G3vhM015328;
        Tue, 5 Jan 2021 16:03:58 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 16:03:57 +0000
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V1 0/5] vfio virtual address update
Date:   Tue,  5 Jan 2021 07:36:48 -0800
Message-Id: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=917 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 mlxlogscore=938
 mlxscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050099
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add interfaces that allow the underlying memory object of an iova range
to be mapped to a new virtual address in the host process:

  - VFIO_DMA_UNMAP_FLAG_SUSPEND for VFIO_IOMMU_UNMAP_DMA
  - VFIO_DMA_MAP_FLAG_RESUME flag for VFIO_IOMMU_MAP_DMA
  - VFIO_SUSPEND extension for VFIO_CHECK_EXTENSION

The suspend interface blocks vfio translation of host virtual addresses in
a range, but DMA to already-mapped pages continues.  The resume interface
records the new base VA and resumes translation.  The implementation
supports iommu type1 and mediated devices.

This functionality is necessary for live update, in which a host process
such as qemu exec's an updated version of itself, while preserving its
guest and vfio devices.  The process suspends vfio VA translation, exec's
its new self, mmap's the memory object(s) underlying vfio object, and
resumes VA translation.  For a working example that uses these new
interfaces, see the QEMU patch series "[PATCH V2] Live Update".

Patch 1 modifies the iova rbtree to allow iteration over ranges with gaps,
  without deleting each entry.  This is required by patch 4.
Patch 2 adds an option to unmap all ranges, which simplifies userland code.
Patch 3 adds an interface to detect if an iommu_group has a valid container,
  which patch 5 uses to release a blocked thread if a container is closed.
Patch 4 implements the new ioctl's.
Patch 5 adds blocking to complete the implementation .

Steve Sistare (5):
  vfio: maintain dma_list order
  vfio: option to unmap all
  vfio: detect closed container
  vfio: VA suspend interface
  vfio: block during VA suspend

 drivers/vfio/vfio.c             |  12 ++++
 drivers/vfio/vfio_iommu_type1.c | 122 ++++++++++++++++++++++++++++++++++------
 include/linux/vfio.h            |   1 +
 include/uapi/linux/vfio.h       |  19 ++++++-
 4 files changed, 135 insertions(+), 19 deletions(-)

-- 
1.8.3.1

