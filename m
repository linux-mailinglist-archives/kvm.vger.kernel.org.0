Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4E7F63608D
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 14:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236131AbiKWNy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 08:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236175AbiKWNyc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 08:54:32 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A46E10B77
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 05:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669211316; x=1700747316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0HsnLLEZBZhW1ooYBiHC02VGBykxQBOghgIdYJ9vSpc=;
  b=HxIK8ifVF+gD8VTuTbuc27BHwPniFDt3oFENRNgu3hgHZLcmBVsT/z6o
   aYyGsyDduPK+Udykk3dY2DjpvjFIC1+WRVMvkG1302t6B6wOhS1tI9eR+
   0dBFAak1kBvxXabRhxBiRfBM2JNzFO4IPOXymzKd3E/7YgkeYeYzlqwMm
   RvhHA/SPo/onx0nT4+b0aH6JW/m/tTM8xR9F6+2VtPyflTTyBf76K1s3R
   XwfybO34HHcvkeiUwTq+oKejNGwlTV8unR9RMk7AnTea5vMc2vWRYMolW
   qNu2tkvKj3RwexGj6TBuG1hMAYYw54Y+jhlt3AA6/BeRZj35IN7rRBIHX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="293776007"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="293776007"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 05:48:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="619619637"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="619619637"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 23 Nov 2022 05:48:35 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     jgg@nvidia.com
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, chao.p.peng@linux.intel.com,
        kvm@vger.kernel.org, yi.y.sun@linux.intel.com,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: [iommufd 1/2] i915/gvt: Move kvmgt_protect_table_init() and gvt_cache_init() into init
Date:   Wed, 23 Nov 2022 05:48:31 -0800
Message-Id: <20221123134832.429589-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221123134832.429589-1-yi.l.liu@intel.com>
References: <20221123134832.429589-1-yi.l.liu@intel.com>
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

vfio_iommufd_bind() creates an access which has an unmap callback, which
can be called immediately. So dma_unmap() callback should tolerate the
unmaps that come before the emulated device is opened.

To achieve above, move the protect_table_init and gvt_cache_init into the
init op which is supposed to be triggered prior to the open_device() op.

Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Zhi Wang <zhi.a.wang@intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/gpu/drm/i915/gvt/gvt.h   | 2 ++
 drivers/gpu/drm/i915/gvt/kvmgt.c | 7 ++-----
 drivers/gpu/drm/i915/gvt/vgpu.c  | 2 ++
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/gvt.h b/drivers/gpu/drm/i915/gvt/gvt.h
index dbf8d7470b2c..a3a7e16078ba 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.h
+++ b/drivers/gpu/drm/i915/gvt/gvt.h
@@ -754,6 +754,8 @@ void intel_gvt_debugfs_remove_vgpu(struct intel_vgpu *vgpu);
 void intel_gvt_debugfs_init(struct intel_gvt *gvt);
 void intel_gvt_debugfs_clean(struct intel_gvt *gvt);
 
+void gvt_cache_init(struct intel_vgpu *vgpu);
+void kvmgt_protect_table_init(struct intel_vgpu *info);
 int intel_gvt_page_track_add(struct intel_vgpu *info, u64 gfn);
 int intel_gvt_page_track_remove(struct intel_vgpu *info, u64 gfn);
 int intel_gvt_dma_pin_guest_page(struct intel_vgpu *vgpu, dma_addr_t dma_addr);
diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 579b230a0f58..cb21b1ba4162 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -322,7 +322,7 @@ static void gvt_cache_destroy(struct intel_vgpu *vgpu)
 	}
 }
 
-static void gvt_cache_init(struct intel_vgpu *vgpu)
+void gvt_cache_init(struct intel_vgpu *vgpu)
 {
 	vgpu->gfn_cache = RB_ROOT;
 	vgpu->dma_addr_cache = RB_ROOT;
@@ -330,7 +330,7 @@ static void gvt_cache_init(struct intel_vgpu *vgpu)
 	mutex_init(&vgpu->cache_lock);
 }
 
-static void kvmgt_protect_table_init(struct intel_vgpu *info)
+void kvmgt_protect_table_init(struct intel_vgpu *info)
 {
 	hash_init(info->ptable);
 }
@@ -671,9 +671,6 @@ static int intel_vgpu_open_device(struct vfio_device *vfio_dev)
 
 	vgpu->attached = true;
 
-	kvmgt_protect_table_init(vgpu);
-	gvt_cache_init(vgpu);
-
 	vgpu->track_node.track_write = kvmgt_page_track_write;
 	vgpu->track_node.track_flush_slot = kvmgt_page_track_flush_slot;
 	kvm_page_track_register_notifier(vgpu->vfio_device.kvm,
diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c b/drivers/gpu/drm/i915/gvt/vgpu.c
index 56c71474008a..036e1a72a26b 100644
--- a/drivers/gpu/drm/i915/gvt/vgpu.c
+++ b/drivers/gpu/drm/i915/gvt/vgpu.c
@@ -382,6 +382,8 @@ int intel_gvt_create_vgpu(struct intel_vgpu *vgpu,
 
 	intel_gvt_update_reg_whitelist(vgpu);
 	mutex_unlock(&gvt->lock);
+	kvmgt_protect_table_init(vgpu);
+	gvt_cache_init(vgpu);
 	return 0;
 
 out_clean_sched_policy:
-- 
2.34.1

