Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD70F6407FA
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 14:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbiLBNyN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 08:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233535AbiLBNyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 08:54:11 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403FFC3FE0;
        Fri,  2 Dec 2022 05:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669989250; x=1701525250;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7n0SkAtXNEP54Rvy3eAXZE7g3DEKAPeKCMLcGkCqZks=;
  b=oCJgPUER6HGtT3V27zsJlML7QNTkbsKM9KtJ0MRq/8uXfZv04Hejw0CV
   Nt0UcEqHOC200+mHw/+emG+PSDzX0QhD4SAm2d9YORjF6kE0Iq8EcAE2X
   uUNqoOC7qaYyZu7xspsUZEOX0FbMAZHS8OP47PGXJuZmuBcXEtL1m3bK/
   +aChi2Hyn2N0pMcw8C8xTWNXetref/9YxbhDR/wzFB4mTeIq6oZudZ0tG
   CljLwxzeekGvI0JUgb5NjGeisJARSn1qfFi+yd+CECk2XtD3Xjnuu08Ib
   slkS+z1BhDLpAoLEmoWxQAYHzPsk4pRVWDjJ1Bj52PycxQQgV9VOsYUiq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="315983400"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="315983400"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 05:54:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="675834126"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="675834126"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga008.jf.intel.com with ESMTP; 02 Dec 2022 05:54:03 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     jgg@nvidia.com
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, intel-gvt-dev@lists.freedesktop.org,
        linux-s390@vger.kernel.org, Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: [[iommufd] PATCH v3 0/2] Make mdev driver dma_unmap callback tolerant to unmaps come before device open
Date:   Fri,  2 Dec 2022 05:54:00 -0800
Message-Id: <20221202135402.756470-1-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jason's "Connect VFIO to IOMMUFD" introduces vfio iommufd compat mode. Under
this mode, vfio_iommufd_bind() creates an access which has an unmap callback,
which can be called immediately. This means mdev drivers may receive unmap
requests before the mdev is opened. For now, there are only three drivers
(gvt, vfio-ap and vfio-ccw) providing dma_unmap(). vfio-ccw is fine with
such requests. While gvt-g and vfio-ap may have potential problem with such
requests due to internal implementation. This series tries to enhance the two
drivers.

This series is based on Jason's below branch.

https://github.com/jgunthorpe/linux/tree/iommufd

(commit: 2079f24ce168f580a30e8eea94e660461d7d0d7a)

Change:
v3:
 - Add explicit check on vgpu->nr_cache_entries, explicitly reset gvt cache (Zhenyu)
 - Add Tony Krowiak's r-b for patch 0002

v2: https://lore.kernel.org/kvm/20221129105831.466954-1-yi.l.liu@intel.com/
 - Refine the cover letter and commit message of patch 0001 (Kevin)
 - Rename patch 0001 to better fit the commit message
 - Add r-b from Zhi for patch 0001
 - Tweak iova range test to assume page-aligned for patch 0002 (Jason)
 - Remove break so all queues within range are removed for patch 0002 (Kevin)

v1: https://lore.kernel.org/kvm/20221123134832.429589-1-yi.l.liu@intel.com/

Cc: Tony Krowiak <akrowiak@linux.ibm.com>
Cc: Halil Pasic <pasic@linux.ibm.com>
Cc: Jason Herne <jjherne@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Zhi Wang <zhi.a.wang@intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: intel-gvt-dev@lists.freedesktop.org

Regards,
	Yi Liu

Matthew Rosato (1):
  iommufd PATCH v2 2/2] vfio/ap: validate iova during dma_unmap and
    trigger irq disable

Yi Liu (1):
  i915/gvt: Move gvt mapping cache initialization to
    intel_vgpu_init_dev()

 drivers/gpu/drm/i915/gvt/kvmgt.c  | 18 ++++++++++++++----
 drivers/s390/crypto/vfio_ap_ops.c | 18 +++++++++++++++++-
 2 files changed, 31 insertions(+), 5 deletions(-)

-- 
2.34.1

