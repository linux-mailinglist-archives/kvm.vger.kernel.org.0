Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8296863BD0E
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 10:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbiK2Jfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 04:35:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbiK2Jfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 04:35:46 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A361253ED8;
        Tue, 29 Nov 2022 01:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669714545; x=1701250545;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=imlqJJLzk3XCQrZvkhpFqQz0O/HUPdUfvXwA2mtMm7Q=;
  b=PBJxJVCdqlrEMC/Av2d7KR+aMIRP7/ndsBobH9GogkLaY0l88RLBiDbK
   wKIkmE1ba8OxMtNtS8QdkrENjtFBYQ1rfzjqBe/Mttl2a2HrS70v/vWVD
   f6nDL1jikzau08VWj3kb7EAw78d/TktTbqruXimsbsb+L6LmEaLhTlV6f
   g5u3ImZA0EnBRCTv6a19koB5XHhspFq5cLW0GHJTrqrF3TabGzp0TgFlD
   fukmPTcSXAIv6bDb8hhokEUa00XD8d8vScmoEafBVvDdMTgc86dawPKAP
   PhGHbz4ZiN3kIiJ4bna0fFYR2W6fy5Q+Q54AwoH2kss713PS9w86cLTWS
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="295442195"
X-IronPort-AV: E=Sophos;i="5.96,202,1665471600"; 
   d="scan'208";a="295442195"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 01:35:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="818156892"
X-IronPort-AV: E=Sophos;i="5.96,202,1665471600"; 
   d="scan'208";a="818156892"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga005.jf.intel.com with ESMTP; 29 Nov 2022 01:35:38 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     jgg@nvidia.com
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, intel-gvt-dev@lists.freedesktop.org,
        linux-s390@vger.kernel.org, Zhi Wang <zhi.a.wang@intel.com>
Subject: [iommufd PATCH v2 1/2] i915/gvt: Move gvt mapping cache initialization to vGPU creation
Date:   Tue, 29 Nov 2022 01:35:34 -0800
Message-Id: <20221129093535.359357-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129093535.359357-1-yi.l.liu@intel.com>
References: <20221129093535.359357-1-yi.l.liu@intel.com>
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

The fix is moving gvt mapping cache initialization to vGPU creation.
While at it also move ptable initialization together.

Reviewed-by: Zhi Wang <zhi.a.wang@intel.com>
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
index 7a45e5360caf..a9e4eda94057 100644
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

