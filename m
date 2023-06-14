Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D37573088E
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 21:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbjFNTlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 15:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240402AbjFNTl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 15:41:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB4F26A1
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 12:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686771609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=N0PGlAWtqnSNmRFe+8NHyKS8xC+iNC6ewCGuOltYSZc=;
        b=GUhc2iGJK6fx6XYx/maoXPJ9l0efh9hwGhnX3HHrJlf8fgASnlEP0rPaLrTi3AHnCn7ZqC
        sD9cKQsrOQubCa9JS0lLkMD186U3fmx94lp/Vu71enM2Jvktg3APrWTBMtuM2MKoAxKsSs
        aVWffD5js+VRJhH+b4ipYmSTgSUSeHk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-GrHBNoM2NZW5FdLxWqG9rA-1; Wed, 14 Jun 2023 15:40:04 -0400
X-MC-Unique: GrHBNoM2NZW5FdLxWqG9rA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD9C3800193;
        Wed, 14 Jun 2023 19:40:03 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.33.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4359492C1B;
        Wed, 14 Jun 2023 19:40:02 +0000 (UTC)
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>, jgg@nvidia.com,
        clg@redhat.com, eric.auger@redhat.com, diana.craciun@oss.nxp.com,
        liulongfang@huawei.com, shameerali.kolothum.thodi@huawei.com,
        yishaih@nvidia.com, kevin.tian@intel.com
Subject: [PATCH v3 0/3] vfio: Cleanup Kconfigs
Date:   Wed, 14 Jun 2023 13:39:45 -0600
Message-Id: <20230614193948.477036-1-alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create sub-menus for bus drivers and remove artificial dependencies
between vfio-pci and vfio-platform and other variant drivers like
vfio-amba, mlx5-vfio-pci, or hisi-acc-vfio-pci.

This is an alternative proposal vs [1], which attempts to make the
vfio-pci-core module individually selectable, even without built
dependencies, in order to avoid the select per variant module.

The solution presented here is my preference, I don't see the select as
overly burdensome or error prone, we have very good randconfig test
coverage, and I prefer to not allow building module which have no
in-kernel requirements.  Thanks,

Alex

v3: Move the depends line up to the menu level for fsl Kconfig as
    discussed with Cedric in v2.  Add R-bs.

v2: Move dependencies from config VFIO_PLATFORM to menu, make existing
    platform reset drivers depend on VFIO_PLATFORM.  Add R-bs.

[1]https://lore.kernel.org/all/0-v1-7eacf832787f+86-vfio_pci_kconfig_jgg@nvidia.com/


Alex Williamson (3):
  vfio/pci: Cleanup Kconfig
  vfio/platform: Cleanup Kconfig
  vfio/fsl: Create Kconfig sub-menu

 drivers/vfio/Makefile               |  4 ++--
 drivers/vfio/fsl-mc/Kconfig         |  6 +++++-
 drivers/vfio/pci/Kconfig            |  8 ++++++--
 drivers/vfio/pci/hisilicon/Kconfig  |  4 ++--
 drivers/vfio/pci/mlx5/Kconfig       |  2 +-
 drivers/vfio/platform/Kconfig       | 18 ++++++++++++++----
 drivers/vfio/platform/Makefile      |  9 +++------
 drivers/vfio/platform/reset/Kconfig |  2 ++
 8 files changed, 35 insertions(+), 18 deletions(-)

-- 
2.39.2

