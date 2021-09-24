Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8754C417811
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 17:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347186AbhIXQAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233624AbhIXQAE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 12:00:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE91C061571
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 08:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=+Cb2+9b8ea4FBKTh75TXoJ74wjINTLgu5o284axmKP4=; b=IazU+A6sF6aR0d0x2kXm04Uoxp
        tYNVCCVFd4DOWihxiglHxFt3CGJNmyjHe8XUeQXgLHMP9cPZGZW1muNlL3sEMs1+PCZiSpvIensc6
        eOgBDN97aheLDB5LDMncZbQF6RovfCYzDkfmtAfybGvtCtwspuWODmRQEj/coJMi09RzbK1i6O4qo
        UCHMxh2DrNTHe53FpOqv1MaG8tp+RpPrWjN719Xy786+csuu61JBAU+zDL1gJysc2DmyGGlnNguSS
        YT88wo+Jv5w4iOYNyn4JJ/+FXkqlv5TFVOA8d966MXlN+y5UzRQnI6QIWb4k7vXVesaP71woGylB1
        nJCzG6og==;
Received: from [2001:4bb8:184:72db:e8f6:c47e:192b:5622] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mTnZV-007MvT-1R; Fri, 24 Sep 2021 15:57:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org
Subject: cleanup vfio iommu_group creation v6
Date:   Fri, 24 Sep 2021 17:56:50 +0200
Message-Id: <20210924155705.4258-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

this series cleans up how iommu group are created in VFIO as well as
various other lose ends around that.

Changes since v5:
 - update a ommit messag
 - move a hunk into the correct patch
 - add a new patch to initialize pgsize_bitmap to ULONG_MAX in ->open

Changes since v4:
 - clean up an intermediate version of vfio_group_find_or_alloc to avoid
   reviewer confusion
 - replace an incorrect NULL check with IS_ERR
 - rebased ontop of the vfio_ap_ops changes in Linux 5.15-rc
 - improve a commit message

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
 drivers/s390/crypto/vfio_ap_ops.c            |    2 
 drivers/vfio/fsl-mc/vfio_fsl_mc.c            |   17 -
 drivers/vfio/mdev/mdev_driver.c              |   45 ---
 drivers/vfio/mdev/vfio_mdev.c                |    2 
 drivers/vfio/pci/vfio_pci_core.c             |   13 -
 drivers/vfio/platform/vfio_platform_common.c |   13 -
 drivers/vfio/vfio.c                          |  307 ++++++++++++---------------
 drivers/vfio/vfio.h                          |   72 ++++++
 drivers/vfio/vfio_iommu_spapr_tce.c          |    6 
 drivers/vfio/vfio_iommu_type1.c              |  256 ++++++----------------
 include/linux/mdev.h                         |   20 -
 include/linux/vfio.h                         |   53 ----
 samples/vfio-mdev/mbochs.c                   |    2 
 samples/vfio-mdev/mdpy.c                     |    2 
 samples/vfio-mdev/mtty.c                     |    2 
 15 files changed, 304 insertions(+), 508 deletions(-)
