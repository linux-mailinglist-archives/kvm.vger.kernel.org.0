Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91774636089
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 14:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237672AbiKWNyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 08:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237620AbiKWNyb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 08:54:31 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E299E018
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 05:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669211315; x=1700747315;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=25YLpByT+Hjjckky0yYYOpcedQM0J10ZApkdgPvxBys=;
  b=Qv4AQbyPHNuGy/EfZis3Z8jq72pIb7oWxqtAAooVQSTmSinxzA+VIuil
   mNZCESm9nJr28oZa7ejryIUy+aazVCF0UO1uDrxVn0I7P4gepxr2BeA3n
   /5nW0fvwz1S2kBTBZsxwn/e3tphQUm+5YjBqgU/U+B3SoKfTeixgwegGt
   dS2xyOGADr22xExRHTjlbzAiVLIna6p81Aw+RuFMvVsO+dD4Rzx1HJfBI
   8e03IWLYif9m0/HZ2/HfxPylRZfgI4P688oCDBjIJ2SHJU82Ig7ojo7RX
   YX7Ij8uqNkJzZsO/4uLUctWSDdjX6kVGAJ20tokn563sKngPlsuH7qmbr
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="293776000"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="293776000"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 05:48:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="619619630"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="619619630"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 23 Nov 2022 05:48:34 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     jgg@nvidia.com
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, chao.p.peng@linux.intel.com,
        kvm@vger.kernel.org, yi.y.sun@linux.intel.com,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: [iommufd 0/2] Make mdev driver dma_unmap callback tolerant to unmaps come before device open
Date:   Wed, 23 Nov 2022 05:48:30 -0800
Message-Id: <20221123134832.429589-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jason's "Connect VFIO to IOMMUFD" introduces vfio iommufd compat mode. Under
this mode, vfio_iommufd_bind() creates an access which has an unmap callback,
which can be called immediately. This means mdev drivers may receive unmap
requests before the mdev is opened. For now, most dma_unmap() callbacks are
tolerant with such unmap requests, except for gvt-g and vfio-ap. This series
tries to enhance the two drivers.

This series is based on Jason's below branch.

https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/log/?h=for-next
(commit: 57f62422b6f0477afaddd2fc77a4bb9b94275f42)

Cc: Tony Krowiak <akrowiak@linux.ibm.com>
Cc: Halil Pasic <pasic@linux.ibm.com>
Cc: Jason Herne <jjherne@linux.ibm.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Zhi Wang <zhi.a.wang@intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>

Regards,
	Yi Liu

Matthew Rosato (1):
  vfio/ap: validate iova during dma_unmap and trigger irq disable

Yi Liu (1):
  i915/gvt: Move kvmgt_protect_table_init() and gvt_cache_init() into
    init

 drivers/gpu/drm/i915/gvt/gvt.h    |  2 ++
 drivers/gpu/drm/i915/gvt/kvmgt.c  |  7 ++-----
 drivers/gpu/drm/i915/gvt/vgpu.c   |  2 ++
 drivers/s390/crypto/vfio_ap_ops.c | 24 +++++++++++++++++++++++-
 4 files changed, 29 insertions(+), 6 deletions(-)

-- 
2.34.1

