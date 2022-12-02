Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17FD3640803
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 14:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbiLBNyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 08:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbiLBNyM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 08:54:12 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEE1BF910;
        Fri,  2 Dec 2022 05:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669989251; x=1701525251;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dA0jLnWflQfc0oKFFy7Fcze9aV4au1U5pXgipaOev9I=;
  b=JWgg8dzZqUOeJ00mtuR65Uc7pZU4w7mm5Q1BX2nQVwswjO2WBFqbvh59
   9Y6dGPziTjEWWTKML5SNX+EyZS7zoSEmjbW6UL6rvCYhAr31GqijdXoDi
   HL70tDitVZgOHfNUa2JOVMNkst0SueH4f1OWRG6WOJ/QHRTl/I4LNH42m
   TQB/oFPWNBSdyLYlmNipYtn/I/1YH5FuGBUgyLQOmX4JWjvksG8ey6u8R
   CpSddrLKFULxLvJd1VcVW603Fz9r2nFXtN/IBZkIjPtHuj3oBSNb/CUsA
   w5rCXtFgiSfERw6gDN33Hjlan4U4iu6nuPF6EWl4ApSbRe/xHW9ShLpu9
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="315983406"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="315983406"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 05:54:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="675834132"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="675834132"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga008.jf.intel.com with ESMTP; 02 Dec 2022 05:54:04 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     jgg@nvidia.com
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, intel-gvt-dev@lists.freedesktop.org,
        linux-s390@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: [[iommufd] PATCH v3 1/2] i915/gvt: Move gvt mapping cache initialization to intel_vgpu_init_dev()
Date:   Fri,  2 Dec 2022 05:54:01 -0800
Message-Id: <20221202135402.756470-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221202135402.756470-1-yi.l.liu@intel.com>
References: <20221202135402.756470-1-yi.l.liu@intel.com>
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
 drivers/gpu/drm/i915/gvt/kvmgt.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 7a45e5360caf..aaf0d9e8da95 100644
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
@@ -718,6 +715,11 @@ static void intel_vgpu_close_device(struct vfio_device *vfio_dev)
 	kvmgt_protect_table_destroy(vgpu);
 	gvt_cache_destroy(vgpu);
 
+	WARN_ON(vgpu->nr_cache_entries);
+
+	vgpu->gfn_cache = RB_ROOT;
+	vgpu->dma_addr_cache = RB_ROOT;
+
 	intel_vgpu_release_msi_eventfd_ctx(vgpu);
 
 	vgpu->attached = false;
@@ -1451,9 +1453,17 @@ static int intel_vgpu_init_dev(struct vfio_device *vfio_dev)
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

