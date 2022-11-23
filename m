Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F42F63629B
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 16:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236497AbiKWPBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 10:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235568AbiKWPBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 10:01:41 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2E823168
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 07:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669215700; x=1700751700;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HkIDfH3RKQ54da5+X7Hpc3mnnrwNy+00lUsc9A6vla0=;
  b=Aw3oQd4V4jfeTkmDpP7jtu9vhbz0jkoiizMkhFx1BarjpJJdzCAXeKyY
   LyX7fSAVKHXJT9dX9kdzXauSfcCx3fuEf7Ia5GWsW1F4zUGzei93qB5ED
   I2FFC/oUHw3ZeTr6zM4L0+boDBnmktIOCn9oWkLN0bR68t5YSBL5YBtDq
   FpjhxG5UaMMLZ+15M+0n2BqUVbFkdMM1PgrVEVOICS7FNHC2nhtfz5uIT
   bi92+xck8ZcNigCPHCCJ1HGOmxBvKFiFwCMvRbbLVgdbwc5mHVpY/Xhie
   KCUAvOqioPBW/h0ritZ+nE95oIAbRH/CWWa+4Ycj+Sm/UVzaKaBWn1ZOU
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="301642911"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="301642911"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 07:01:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="674750866"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="674750866"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga001.jf.intel.com with ESMTP; 23 Nov 2022 07:01:15 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, eric.auger@redhat.com, cohuck@redhat.com,
        nicolinc@nvidia.com, yi.y.sun@linux.intel.com,
        chao.p.peng@linux.intel.com, mjrosato@linux.ibm.com,
        kvm@vger.kernel.org, yi.l.liu@intel.com
Subject: [RFC 00/10]  Move group specific code into group.c
Date:   Wed, 23 Nov 2022 07:01:03 -0800
Message-Id: <20221123150113.670399-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

https://github.com/yiliu1765/iommufd/commits/vfio_group_split_rfcv1

This is based on Jason's "Connect VFIO to IOMMUFD"[3] and my "Make mdev driver
dma_unmap callback tolerant to unmaps come before device open"[4]

[1] https://lore.kernel.org/all/0-v5-4001c2997bd0+30c-iommufd_jgg@nvidia.com/
[2] https://github.com/yiliu1765/iommufd/tree/wip/vfio_device_cdev
[3] https://lore.kernel.org/kvm/063990c3-c244-1f7f-4e01-348023832066@intel.com/T/#t
[4] https://lore.kernel.org/kvm/20221123134832.429589-1-yi.l.liu@intel.com/T/#t

Regards,
	Yi Liu

Jason Gunthorpe (2):
  vfio: Simplify vfio_create_group()
  vfio: Move the sanity check of the group to vfio_create_group()

Yi Liu (8):
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
 drivers/vfio/group.c     | 834 +++++++++++++++++++++++++++++++++++++
 drivers/vfio/vfio.h      |  52 ++-
 drivers/vfio/vfio_main.c | 863 +++------------------------------------
 5 files changed, 942 insertions(+), 828 deletions(-)
 create mode 100644 drivers/vfio/group.c

-- 
2.34.1

