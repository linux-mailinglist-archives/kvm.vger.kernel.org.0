Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE663F8912
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 15:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242701AbhHZNgn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 09:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242644AbhHZNgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 09:36:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E693C061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 06:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=i/su09JIQK3bzHUmExBFZLoqB4R30ufXPmO1BoSFIKE=; b=VLmWH790z6jK8qDhvVlnQVu1p6
        CVZD/QR+t1HkuGqbiS5ZlMjGYyjAOa6m2/f9yx6iy+/4gYoYsd7OgInA4fuEnmE+TJc03wNYyH4F2
        QjVhu8MLcYaqjOMZWv31pBAEbXZc6/PD93ox5ZZxPPvG4V851Su3efEj2zD2ypRWdeHIJRmwfWM1V
        lF2dyTNCW3bCX4WdfMwwegHLI7FhWx9XC3m2MOiSU+jPkdoWNLxVNcrEHGGHyxkgcSLqtvzsKPS6S
        Gk5p4trv1FBW+FKooibyykwfEalhlSp3susUjHUnRCCz5tcOrA1cRybdrZ4vPO/jA8OZA4qrfaYkL
        L7HiUGwQ==;
Received: from [2001:4bb8:193:fd10:d9d9:6c15:481b:99c4] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJFWU-00DKvB-37; Thu, 26 Aug 2021 13:34:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: cleanup vfio iommu_group creation v4
Date:   Thu, 26 Aug 2021 15:34:10 +0200
Message-Id: <20210826133424.3362-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

this series cleans up how iommu group are created in VFIO as well as
various other lose ends around that.  It sits on top of the

    "Introduce vfio_pci_core subsystem"

series from Yishai

Changes since v3:
 - restore the attribution to Jason for patch 1, which git-rebase lost
 - fix a vfio vs iommu group counting issue that I added over Jasons
   original patch
 - add comments describing the VFIO_EMULATED_IOMMU and VFIO_NO_IOMMU
   flags
 - use the emulated iommu naming consistently in comments
 - a spelling fix

Changes since v2:
 - cosmetic changes to the code flow in vfio_group_find_or_alloc
 - replace "mediated" with "emulated iommu"
 - add a comment describing vfio_register_emulated_iommu_dev
 - rebased on top of the "Introduce vfio_pci_core subsystem" series

Changes since v1:
 - only taint if a noiommu group was successfully created

Diffstat:
 drivers/vfio/fsl-mc/vfio_fsl_mc.c            |   17 -
 drivers/vfio/mdev/mdev_driver.c              |   46 ----
 drivers/vfio/mdev/vfio_mdev.c                |    2 
 drivers/vfio/pci/vfio_pci_core.c             |   13 -
 drivers/vfio/platform/vfio_platform_common.c |   13 -
 drivers/vfio/vfio.c                          |  306 ++++++++++++---------------
 drivers/vfio/vfio.h                          |   63 +++++
 drivers/vfio/vfio_iommu_spapr_tce.c          |    6 
 drivers/vfio/vfio_iommu_type1.c              |  255 ++++++----------------
 include/linux/mdev.h                         |   20 -
 include/linux/vfio.h                         |   53 ----
 samples/vfio-mdev/mbochs.c                   |    2 
 samples/vfio-mdev/mdpy.c                     |    2 
 samples/vfio-mdev/mtty.c                     |    2 
 14 files changed, 292 insertions(+), 508 deletions(-)
