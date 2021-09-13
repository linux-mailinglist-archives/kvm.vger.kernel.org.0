Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC0F408536
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 09:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237617AbhIMHTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 03:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237613AbhIMHTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 03:19:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18076C061762
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 00:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=SOtG1TGwI1J6/dCJVnASOJrQ+z3258v4wgMHP8O6/5U=; b=tKCrviynJluwVAnrOuJXrVEEuU
        TAIkP5WgsBj0MDJm9opMo5F8AyTNcVMTd8UuILzTj0Odhq4XlwAZn0qtjlUChAUyO/57T1bF4Tg5c
        PVGHj9/LJCxJCdiaBcHWH6EfSn9i+qdwZNf94n0oWMkYEeobQlm474RQfZ6xZkqEJxDNjGutNh0am
        Hm8A3CZSg9AOVdZuG3FHZl4RJ/Z0oQFO5ACQTkgtAPaWp6Eb8sQ2IzqvOpI/atUM4D+ctEVWDe1RN
        wA0PotJS+AwD16DppvvYCNY7VTMw+LPvPhgh7IOZZIpYc/3Ocp4k+qefs6JXH6W7CksA2t8JothZ0
        nSlsHDNQ==;
Received: from 213-225-6-64.nat.highway.a1.net ([213.225.6.64] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mPgCG-00DGB4-GT; Mon, 13 Sep 2021 07:16:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org
Subject: cleanup vfio iommu_group creation v5
Date:   Mon, 13 Sep 2021 09:15:52 +0200
Message-Id: <20210913071606.2966-1-hch@lst.de>
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

Terrence: I did not pick up your Tested-by as there were quite a few
changes and a major rebase.

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
