Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 568AC29FCE3
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 06:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbgJ3FFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 01:05:08 -0400
Received: from mga06.intel.com ([134.134.136.31]:5284 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbgJ3FFH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 01:05:07 -0400
IronPort-SDR: AEDj3Sg4HS/CNXXZBfYKiBXA30f3WOL2e5opgr6fuo24A22dKinkFceEftY7xd0Qb07Xh7pP/J
 MuOdDZjz2qWQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9789"; a="230196538"
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="230196538"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 22:05:04 -0700
IronPort-SDR: yA/8uLhnMK0V46kNAp34cxMA+s1WXTmWTVtL9265fjUb9AtY4ndlRl2EAqyl1S3MC2fCwfyUEF
 LBIDN+mqCFTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="425261524"
Received: from allen-box.sh.intel.com ([10.239.159.139])
  by fmsmga001.fm.intel.com with ESMTP; 29 Oct 2020 22:05:01 -0700
From:   Lu Baolu <baolu.lu@linux.intel.com>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Liu Yi L <yi.l.liu@intel.com>, Zeng Xin <xin.zeng@intel.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v6 0/5] iommu aux-domain APIs extensions
Date:   Fri, 30 Oct 2020 12:58:04 +0800
Message-Id: <20201030045809.957927-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Joerg and Alex,

A description of purpose for this series could be found here.

https://lore.kernel.org/linux-iommu/20200901033422.22249-1-baolu.lu@linux.intel.com/

The previous version was posted here.

https://lore.kernel.org/linux-iommu/20200922061042.31633-1-baolu.lu@linux.intel.com/

This version is evolved according to Joerg's comments posted here.

https://lore.kernel.org/linux-iommu/20200924095532.GK27174@8bytes.org/

This basic idea is that IOMMU registers an iommu_ops for subdevice
bus (for example, the vfio/mdev bus), so that the upper layer device
passthrough framework could use the standard iommu-core code to setup
the IOMMU logistics.

This series was tested by Dave Jiang <dave.jiang@intel.com> with his
idxd driver posted here. Very appreciated!

https://lore.kernel.org/lkml/160021250454.67751.3119489448651243709.stgit@djiang5-desk3.ch.intel.com/

Please help to review and comment.

Best regards,
baolu

Lu Baolu (5):
  vfio/mdev: Register mdev bus earlier during boot
  iommu: Use bus iommu ops for aux related callback
  iommu/vt-d: Make some static functions global
  iommu/vt-d: Add iommu_ops support for subdevice bus
  vfio/type1: Use mdev bus iommu_ops for IOMMU callbacks

 drivers/iommu/intel/Kconfig      |  13 ++++
 drivers/iommu/intel/Makefile     |   1 +
 drivers/iommu/intel/iommu.c      |  79 +++++--------------
 drivers/iommu/intel/siov.c       | 119 ++++++++++++++++++++++++++++
 drivers/iommu/iommu.c            |  16 ++--
 drivers/vfio/mdev/mdev_core.c    |  22 +-----
 drivers/vfio/mdev/mdev_driver.c  |   6 ++
 drivers/vfio/mdev/mdev_private.h |   1 -
 drivers/vfio/vfio_iommu_type1.c  | 128 +++----------------------------
 include/linux/intel-iommu.h      |  53 +++++++++++++
 include/linux/mdev.h             |  14 ----
 11 files changed, 236 insertions(+), 216 deletions(-)
 create mode 100644 drivers/iommu/intel/siov.c

-- 
2.25.1

