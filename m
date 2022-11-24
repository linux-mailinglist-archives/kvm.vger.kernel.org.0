Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC1B6378D2
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 13:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiKXM1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 07:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiKXM1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 07:27:14 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891A5DEAFD
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 04:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669292833; x=1700828833;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NsoKAEv0R/MaNz9px5Wnv5St1nm47QgaT0+AyJVX9fM=;
  b=TI+9cDfcnnO2W/YKpw6d1afSRqGoDUL5ZQLuI0UfnPpcK9Exh4kua2y4
   AMW5XT9+t0tSEkUh6Wiokl5O7JZsxaec3PCyE9BVWmKsv8k/EGP2cLvRA
   kW2gj4xaxZCwdXKAWZbMmTCM3ht+YfJm3H1KvhAc2E+x3DoxIl0zCxxcI
   UsUI/sdA7n8/TMsqg+iDlwJPlA11CUCT5iMWs5POW9LKYh9ufKJQsa2Iw
   kTxvzhR1dgWidOH+Pj99twQtIxXtqIEd6hLfFaCY0YDzj7ESqxfItot1W
   OVk2ujiNpM9IsG1jOc0fRg3poHam18vJ4BzQV1XpMNAWgoJ5jrvdwVeIv
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="297649625"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="297649625"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 04:27:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="642337144"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="642337144"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga002.jf.intel.com with ESMTP; 24 Nov 2022 04:27:12 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, eric.auger@redhat.com, cohuck@redhat.com,
        nicolinc@nvidia.com, yi.y.sun@linux.intel.com,
        chao.p.peng@linux.intel.com, mjrosato@linux.ibm.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [RFC v2 00/11] Move group specific code into group.c
Date:   Thu, 24 Nov 2022 04:26:51 -0800
Message-Id: <20221124122702.26507-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

https://github.com/yiliu1765/iommufd/commits/vfio_group_split_rfcv2

This is based on Jason's "Connect VFIO to IOMMUFD"[3] and my "Make mdev driver
dma_unmap callback tolerant to unmaps come before device open"[4]

[1] https://lore.kernel.org/all/0-v5-4001c2997bd0+30c-iommufd_jgg@nvidia.com/
[2] https://github.com/yiliu1765/iommufd/tree/wip/vfio_device_cdev
[3] https://lore.kernel.org/kvm/063990c3-c244-1f7f-4e01-348023832066@intel.com/T/#t
[4] https://lore.kernel.org/kvm/20221123134832.429589-1-yi.l.liu@intel.com/T/#t

v2:
 - Remove device->group reference in vfio_main.c suggested by Jason.
 - Cherry-pick the patches in Alex's vfio/next branch, and rebased this
   series on the top.

v1: https://lore.kernel.org/kvm/20221123150113.670399-1-yi.l.liu@intel.com/T/#t

Regards,
	Yi Liu

Jason Gunthorpe (2):
  vfio: Simplify vfio_create_group()
  vfio: Move the sanity check of the group to vfio_create_group()

Yi Liu (9):
  vfio: Set device->group in helper function
  vfio: Wrap group codes to be helpers for __vfio_register_dev() and
    unregister
  vfio: Make vfio_device_open() group agnostic
  vfio: Move device open/close code to be helpfers
  vfio: Swap order of vfio_device_container_register() and open_device()
  vfio: Refactor vfio_device_first_open() and _last_close()
  vfio: Wrap vfio group module init/clean code into helpers
  vfio: Refactor dma APIs for emulated devices
  vfio: Move vfio group specific code into group.c

 drivers/vfio/Makefile    |   1 +
 drivers/vfio/container.c |  20 +-
 drivers/vfio/group.c     | 842 ++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h      |  49 ++-
 drivers/vfio/vfio_main.c | 896 +++------------------------------------
 5 files changed, 959 insertions(+), 849 deletions(-)
 create mode 100644 drivers/vfio/group.c

-- 
2.34.1

