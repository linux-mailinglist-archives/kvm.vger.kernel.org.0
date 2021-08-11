Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE403E9461
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 17:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbhHKPRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 11:17:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233145AbhHKPQq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 11:16:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F0FC061765
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 08:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=zYV/P2D2mu33JsEzIm77pUwL1SaHZ+u2IakOk7PIsjM=; b=Q04tAzlIVgmACRsUG9dU0MT3vP
        yeIq18PGHuXvdUAtl5VkrHNZH/718N9uk409Tnw6sIvXYpCLvxoW33oTd7gSJpVrF6M0PAaYY2EWs
        RYDy1j9tejmaKldheUq1Iwxq3ALZN8TIxW5KyLwbNF8wsMXDNLyRjtmQu/yP1R7dSQou2W+nEtpOn
        wV6e4BXdOd2j3y5Fe3yDtYaWDb/YHkItYfmRjvVLyc2+7uzTDby6JoRddAw+9d5EwkCdhor2Z39fT
        9z6isx51o9IfC0sM1aT5O0nHbYH5X+7LxqbH9zTjxCmJFlcMOyq5e+dQTy6FpLz8060R6YB23EDz2
        lcis1Cgw==;
Received: from [2001:4bb8:184:6215:ac7b:970b:bd9c:c36c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDpwb-00DY9f-RJ; Wed, 11 Aug 2021 15:15:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: cleanup vfio iommu_group creation
Date:   Wed, 11 Aug 2021 17:14:46 +0200
Message-Id: <20210811151500.2744-1-hch@lst.de>
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

Diffstat:
 drivers/vfio/fsl-mc/vfio_fsl_mc.c            |   17 -
 drivers/vfio/mdev/mdev_driver.c              |   46 ----
 drivers/vfio/mdev/vfio_mdev.c                |    2 
 drivers/vfio/pci/vfio_pci.c                  |   15 -
 drivers/vfio/platform/vfio_platform_common.c |   13 -
 drivers/vfio/vfio.c                          |  303 +++++++++++----------------
 drivers/vfio/vfio.h                          |   52 ++++
 drivers/vfio/vfio_iommu_spapr_tce.c          |    6 
 drivers/vfio/vfio_iommu_type1.c              |  259 ++++++-----------------
 include/linux/mdev.h                         |   20 -
 include/linux/vfio.h                         |   53 ----
 samples/vfio-mdev/mbochs.c                   |    2 
 samples/vfio-mdev/mdpy.c                     |    2 
 samples/vfio-mdev/mtty.c                     |    2 
 14 files changed, 279 insertions(+), 513 deletions(-)
