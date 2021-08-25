Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383D93F7A6C
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 18:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241073AbhHYQWg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 12:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbhHYQWf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 12:22:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2F3C061757
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 09:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=4ScOU/SlDFGbcBIlCjL3ysFOwvdxzSaqA8KAtzKLGP0=; b=wEq33z/Rt4wT5LAKhSbXMaBFbm
        QoF7TB2JMOv5tNtbWabm4IYYwugBFQRH1Oi2BxPpvkZyn80pr09s8ZhIj7QEsjbN6+cKAkS4Ht1r5
        FLOE+i5bq4SIg1W2k/qNaBR7Dvj353AqN5XzOFpPDfYDUB8dGjMhIGvAruTBONK5CqQifSJQbLM/E
        i1YwY6wK1+bqfnlsI8wD4l92XbCEU8PuSrGWj0Qfcr2XCLhTjb9Tc1yJQWR6s+vlldvmZMMprBIKb
        0h4Y3BZX1Crbp/FtqlczuIOjFtBhnGOVqvMjJ7xzBEIA7wYi/x4z83Q4Gb+jswO0mjRyqtG2d4+Uo
        Six8yDbg==;
Received: from [2001:4bb8:193:fd10:a3f9:5689:21a4:711f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIvcT-00CSh8-4h; Wed, 25 Aug 2021 16:19:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: cleanup vfio iommu_group creation v3
Date:   Wed, 25 Aug 2021 18:19:01 +0200
Message-Id: <20210825161916.50393-1-hch@lst.de>
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
 drivers/vfio/vfio.c                          |  310 ++++++++++++---------------
 drivers/vfio/vfio.h                          |   52 ++++
 drivers/vfio/vfio_iommu_spapr_tce.c          |    6 
 drivers/vfio/vfio_iommu_type1.c              |  256 ++++++----------------
 include/linux/mdev.h                         |   20 -
 include/linux/vfio.h                         |   53 ----
 samples/vfio-mdev/mbochs.c                   |    2 
 samples/vfio-mdev/mdpy.c                     |    2 
 samples/vfio-mdev/mtty.c                     |    2 
 14 files changed, 283 insertions(+), 511 deletions(-)
