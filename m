Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB497272BD
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 01:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbjFGXKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 19:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbjFGXKT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 19:10:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64C21FE2
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 16:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686179370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=dysQuN+uazTgJL7C6nnaq2BtgZcnf9o3YmYMh/9hDnw=;
        b=JJebmBuL6keXqzkhPhoN41wGrI9EMyKPE2KTPZOfDhhF/2qiMCOyenFmc4NV8C3vWhHKE0
        uTnfHNuVI14MGwItuuGFTJh2a4h2lIbNdxevnYxddTmM+bka7wYm/XUUW8evHCPQLVcyUT
        aZtVcl+pWNXbLTMnRbRU8j0jMZssBVE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-YCLETpnKN9C8qzMpTy80TA-1; Wed, 07 Jun 2023 19:09:27 -0400
X-MC-Unique: YCLETpnKN9C8qzMpTy80TA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6421929AA3B7;
        Wed,  7 Jun 2023 23:09:26 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.33.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53DB640D1B66;
        Wed,  7 Jun 2023 23:09:25 +0000 (UTC)
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>, jgg@nvidia.com,
        clg@redhat.com, eric.auger@redhat.com, diana.craciun@oss.nxp.com,
        liulongfang@huawei.com, shameerali.kolothum.thodi@huawei.com,
        yishaih@nvidia.com, kevin.tian@intel.com
Subject: [PATCH v2 0/3] vfio: Cleanup Kconfigs
Date:   Wed,  7 Jun 2023 17:09:15 -0600
Message-Id: <20230607230918.3157757-1-alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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

v2: Move dependencies from config VFIO_PLATFORM to menu, make existing
    platform reset drivers depend on VFIO_PLATFORM.  Add R-bs.

[1]https://lore.kernel.org/all/0-v1-7eacf832787f+86-vfio_pci_kconfig_jgg@nvidia.com/


Alex Williamson (3):
  vfio/pci: Cleanup Kconfig
  vfio/platform: Cleanup Kconfig
  vfio/fsl: Create Kconfig sub-menu

 drivers/vfio/Makefile               |  4 ++--
 drivers/vfio/fsl-mc/Kconfig         |  4 ++++
 drivers/vfio/pci/Kconfig            |  8 ++++++--
 drivers/vfio/pci/hisilicon/Kconfig  |  4 ++--
 drivers/vfio/pci/mlx5/Kconfig       |  2 +-
 drivers/vfio/platform/Kconfig       | 18 ++++++++++++++----
 drivers/vfio/platform/Makefile      |  9 +++------
 drivers/vfio/platform/reset/Kconfig |  2 ++
 8 files changed, 34 insertions(+), 17 deletions(-)

-- 
2.39.2

