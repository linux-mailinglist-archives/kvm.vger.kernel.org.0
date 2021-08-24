Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF9A3F60EE
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 16:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237939AbhHXOuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 10:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237755AbhHXOuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 10:50:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D877C061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 07:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=OSjy8Km1mu+D3bVQf5wGi0eXBZUasLSbxKM6IzmM01Y=; b=PAmbDONWZX+XdHgyuhC4AO3jsf
        UlLDCrN+HUbjSY0sTKE1guNa15GVcm+vsIR7tO0rYtmE7wzcdktoalpQZ/CqDMwgSzsKIWLZXo5W1
        Km3/9LckRm2uYgbJP8uYFG1h85a+9BtjQOwowzCxadwtm9vDJOe/kRnqbwTXnPmWWovZ1WU2j08jA
        BbXB26IaM7eNzH7JV09jvH1mlQxQiai2diV0tZaNFvnG9GGPAO4hfGxiNTbZ2OlJVec/c4RTvpbfQ
        4Xq7QlxpIb2c+HVG2ox78F+KDbClv2/KG3Y3KwLY1P5bhkJTI9HZLRhLIoZC2rmXoX7SC34lE6GIw
        7fG7qYSQ==;
Received: from [2001:4bb8:193:fd10:b8ba:7bad:652e:75fa] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIXhS-00BBzk-FE; Tue, 24 Aug 2021 14:47:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: cleanup vfio iommu_group creation v2
Date:   Tue, 24 Aug 2021 16:46:35 +0200
Message-Id: <20210824144649.1488190-1-hch@lst.de>
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

    "Provide core infrastructure for managing open/release"

series from Jason.

Changes since v1:
 - only taint if a noiommu group was successfully created

Diffstat:
 drivers/vfio/fsl-mc/vfio_fsl_mc.c            |   17 -
 drivers/vfio/mdev/mdev_driver.c              |   46 ----
 drivers/vfio/mdev/vfio_mdev.c                |    2 
 drivers/vfio/pci/vfio_pci.c                  |   15 -
 drivers/vfio/platform/vfio_platform_common.c |   13 -
 drivers/vfio/vfio.c                          |  305 +++++++++++----------------
 drivers/vfio/vfio.h                          |   52 ++++
 drivers/vfio/vfio_iommu_spapr_tce.c          |    6 
 drivers/vfio/vfio_iommu_type1.c              |  259 ++++++----------------
 include/linux/mdev.h                         |   20 -
 include/linux/vfio.h                         |   53 ----
 samples/vfio-mdev/mbochs.c                   |    2 
 samples/vfio-mdev/mdpy.c                     |    2 
 samples/vfio-mdev/mtty.c                     |    2 
 14 files changed, 281 insertions(+), 513 deletions(-)
