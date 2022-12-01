Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3333663F331
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 15:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbiLAOzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 09:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiLAOzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 09:55:39 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A724CBD880
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 06:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669906538; x=1701442538;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=g5p7f7owW9jMlDNKpehYvDhDe+EdhZLB8GlUmDXmJpM=;
  b=mtsuvgzOVeMRFx/TYJkd0feHNU5wxc6+1ODE4MHGj8QKleuFkoO+qlii
   74PqRd6oefxPLINvRYQGPUv85TR98ZcD++G7CbxlYnXfMAXmKjdXLkBf9
   xYSSQhEYVHqI0H87mgBJTpx7wLOAPclMN9zDj4ad7Ws0GBgFI/gG1wGld
   zT5zVCbCkhZBUFpm5bVT/ia69sAoSm8qyC1NSOAERctiJaO3dieMEq+bc
   33w5JNyMVwcj9QKkjK43zya03nDIdh67t1tCKRhGFsQc+qPk+chRD87u+
   6RrBknmn4w+auSF22i0e0DKSWPkSg4HiE0V08yUlnEts7tF9Ytsxh2MCT
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="317569278"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="317569278"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 06:55:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="708095139"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="708095139"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga008.fm.intel.com with ESMTP; 01 Dec 2022 06:55:37 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com
Subject: [PATCH 00/10] Move group specific code into group.c
Date:   Thu,  1 Dec 2022 06:55:25 -0800
Message-Id: <20221201145535.589687-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the introduction of iommufd[1], VFIO is towarding to provide device
centric uAPI after adapting to iommufd. With this trend, existing VFIO
group infrastructure is optional once VFIO converted to device centric.

This series moves the group specific code out of vfio_main.c, prepares
for compiling group infrastructure out after adding vfio device cdev[2]

Complete code in below branch:

https://github.com/yiliu1765/iommufd/commits/vfio_group_split_v1

This is based on Jason's "Connect VFIO to IOMMUFD"[3] and my "Make mdev driver
dma_unmap callback tolerant to unmaps come before device open"[4]

[1] https://lore.kernel.org/all/0-v5-4001c2997bd0+30c-iommufd_jgg@nvidia.com/
[2] https://github.com/yiliu1765/iommufd/tree/wip/vfio_device_cdev
[3] https://lore.kernel.org/kvm/0-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com/
[4] https://lore.kernel.org/kvm/20221129105831.466954-1-yi.l.liu@intel.com/

v1:
 - Keep the iommufd code in vfio_main.c just move group code out (Jason)
 - Add r-b from Kevin
 - Reorder the patch sequence
 - Drop "vfio: Make vfio_device_open() group agnostic"

rfcv2: https://lore.kernel.org/kvm/20221124122702.26507-1-yi.l.liu@intel.com/
 - Remove device->group reference in vfio_main.c suggested by Jason.
 - Cherry-pick the patches in Alex's vfio/next branch, and rebased this
   series on the top.

rfcv1: https://lore.kernel.org/kvm/20221123150113.670399-1-yi.l.liu@intel.com/T/#t

Regards,
	Yi Liu

Jason Gunthorpe (2):
  vfio: Simplify vfio_create_group()
  vfio: Move the sanity check of the group to vfio_create_group()

Yi Liu (8):
  vfio: Create wrappers for group register/unregister
  vfio: Set device->group in helper function
  vfio: Swap order of vfio_device_container_register() and open_device()
  vfio: Move device open/close code to be helpfers
  vfio: Refactor vfio_device open and close
  vfio: Wrap vfio group module init/clean code into helpers
  vfio: Refactor dma APIs for emulated devices
  vfio: Move vfio group specific code into group.c

 drivers/vfio/Makefile    |   1 +
 drivers/vfio/container.c |  20 +-
 drivers/vfio/group.c     | 877 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h      |  54 ++-
 drivers/vfio/vfio_main.c | 909 +++------------------------------------
 5 files changed, 986 insertions(+), 875 deletions(-)
 create mode 100644 drivers/vfio/group.c

-- 
2.34.1

