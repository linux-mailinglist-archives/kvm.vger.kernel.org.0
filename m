Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E2763BE5B
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 11:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbiK2K6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 05:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbiK2K6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 05:58:35 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFEF317F2;
        Tue, 29 Nov 2022 02:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669719514; x=1701255514;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=67kRFHqzmUGB9qguOhZFndL6g8y4s9H/Z5kjkjhRQz4=;
  b=RMA9mdcjp0N4iyZis1Ku/GdLKuU6sN7Ofx67MOLXfgMn0RgyVVtjKtS0
   qjkuJvOXBEISwyUwBq7aSrkdXA9Cj/X/6OuPiJhDKM756OX9PkFDhx9Gf
   s/osr63f+1b3iaNSnUW25GMA1wGXsnQqDTXmrwu8+BaJGBFnkuGRROl47
   wYgJI4JlNcW8bOhmyFmZ4qIzD8/+JZqT7kCqH/rjaCuyS4+p0WkJ+sNpQ
   jXOtCvEZYYNoC0zlmy38Kpu8ScbNa5Xy4yZGpLEq7O8tXiDZYBF76PZM7
   gGSnHMKi6SC6H+hkTE1LmRrhkb+9ASt0eoON0pFR8t7n8zrbPYPIR3/Ei
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="295457250"
X-IronPort-AV: E=Sophos;i="5.96,202,1665471600"; 
   d="scan'208";a="295457250"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 02:58:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="621411021"
X-IronPort-AV: E=Sophos;i="5.96,202,1665471600"; 
   d="scan'208";a="621411021"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 29 Nov 2022 02:58:34 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     jgg@nvidia.com
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, intel-gvt-dev@lists.freedesktop.org,
        linux-s390@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: [[RESEND] iommufd PATCH v2 1/2] i915/gvt: Move gvt mapping cache initialization to intel_vgpu_init_dev()
Date:   Tue, 29 Nov 2022 02:58:30 -0800
Message-Id: <20221129105831.466954-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129105831.466954-1-yi.l.liu@intel.com>
References: <20221129105831.466954-1-yi.l.liu@intel.com>
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

vfio container registers .dma_unmap() callback after the device is opened.
So it's fine for mdev drivers to initialize internal mapping cache in
.open_device(). See vfio_device_container_register().

Now with iommufd an access ops with an unmap callback is registered
when the device is bound to iommufd which is before .open_device()
is called. This implies gvt's .dma_unmap() could be called before its
internal mapping cache is initialized.

The fix is moving gvt mapping cache initialization to vGPU init. While
at it also move ptable initialization together.

Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Zhi Wang <zhi.a.wang@intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: intel-gvt-dev@lists.freedesktop.org
Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 7a45e5360caf..f563e5dbe66f 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -671,9 +671,6 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
 
 	vgpu->attached = true;
 
-	kvmgt_protect_table_init(vgpu);
-	gvt_cache_init(vgpu);
-
 	vgpu->track_node.track_write = kvmgt_page_track_write;
 	vgpu->track_node.track_flush_slot = kvmgt_page_track_flush_slot;
 	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
@@ -1451,9 +1448,17 @@ static int intel_vgpu_init_dev(struct vfio_device *vfio_dev)
 	struct intel_vgpu *vgpu = vfio_dev_to_vgpu(vfio_dev);
 	struct intel_vgpu_type *type =
 		container_of(mdev->type, struct intel_vgpu_type, type);
+	int ret;
 
 	vgpu->gvt = kdev_to_i915(mdev->type->parent->dev)->gvt;
-	return intel_gvt_create_vgpu(vgpu, type->conf);
+	ret = intel_gvt_create_vgpu(vgpu, type->conf);
+	if (ret)
+		return ret;
+
+	kvmgt_protect_table_init(vgpu);
+	gvt_cache_init(vgpu);
+
+	return 0;
 }
 
 static void intel_vgpu_release_dev(struct vfio_device *vfio_dev)
-- 
2.34.1

