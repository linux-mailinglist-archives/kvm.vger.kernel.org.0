Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458713CB264
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 08:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhGPGY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 02:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbhGPGY6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 02:24:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D748CC06175F
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 23:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=POrh8TT8rL33I5j7m4S6Q8p5Nh+x8Ba5lIisohE8mc0=; b=qCAZ7/56ZEGN23250LJGg3r+yp
        +1tKia6C2UbxyRWHqO2WN8/tvGxqIqlR3+mcmmh2rS/XjTLRw5lxasw5rXY9GTGFl+zVTmfadiLpb
        iZXFbA2n2CWt+knRPY3eDAj+FsIrjTqILtnZHrn/B5Yu4hOl2ZXggl96TAs/uWsNkbKmNiJ28YUHg
        i1S8uv8c38vvn3Y6VPtDOwa0RrQ79mmBq5kdPBvizeBxlI/brx9gaHjeJmoy3BlYNLbkHoXUp1Lpe
        MPmhmW1VC+WyTvIxzn91zyJ5koPIylwFYSNE7m9niYwbPGEVCiUyuA41YSty1QyuTFCOTj2g6nFs+
        8so40APg==;
Received: from [2001:4bb8:184:8b7c:6b57:320d:f068:19c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m4HCO-004D0U-5H; Fri, 16 Jul 2021 06:20:09 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        kvm@vger.kernel.org
Subject: [PATCH 5/7] vgaarb: provide a vga_client_unregister wrapper
Date:   Fri, 16 Jul 2021 08:16:32 +0200
Message-Id: <20210716061634.2446357-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210716061634.2446357-1-hch@lst.de>
References: <20210716061634.2446357-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a trivial wrapper for the unregister case that sets all fields to
NULL.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 +-
 drivers/gpu/drm/drm_irq.c                  | 4 ++--
 drivers/gpu/drm/i915/display/intel_vga.c   | 2 +-
 drivers/gpu/drm/nouveau/nouveau_vga.c      | 2 +-
 drivers/gpu/drm/radeon/radeon_device.c     | 2 +-
 drivers/gpu/vga/vgaarb.c                   | 3 +--
 drivers/vfio/pci/vfio_pci.c                | 2 +-
 include/linux/vgaarb.h                     | 5 +++++
 8 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index d303e88e3c23..53afe0198e52 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3838,7 +3838,7 @@ void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 		vga_switcheroo_fini_domain_pm_ops(adev->dev);
 	}
 	if ((adev->pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA)
-		vga_client_register(adev->pdev, NULL, NULL, NULL);
+		vga_client_unregister(adev->pdev);
 
 	if (IS_ENABLED(CONFIG_PERF_EVENTS))
 		amdgpu_pmu_fini(adev);
diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index c3bd664ea733..c87b0fb384e4 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -140,7 +140,7 @@ int drm_irq_install(struct drm_device *dev, int irq)
 	if (ret < 0) {
 		dev->irq_enabled = false;
 		if (drm_core_check_feature(dev, DRIVER_LEGACY))
-			vga_client_register(to_pci_dev(dev->dev), NULL, NULL, NULL);
+			vga_client_unregister(to_pci_dev(dev->dev));
 		free_irq(irq, dev);
 	} else {
 		dev->irq = irq;
@@ -203,7 +203,7 @@ int drm_irq_uninstall(struct drm_device *dev)
 	DRM_DEBUG("irq=%d\n", dev->irq);
 
 	if (drm_core_check_feature(dev, DRIVER_LEGACY))
-		vga_client_register(to_pci_dev(dev->dev), NULL, NULL, NULL);
+		vga_client_unregister(to_pci_dev(dev->dev));
 
 	if (dev->driver->irq_uninstall)
 		dev->driver->irq_uninstall(dev);
diff --git a/drivers/gpu/drm/i915/display/intel_vga.c b/drivers/gpu/drm/i915/display/intel_vga.c
index f002b82ba9c0..833f9ec14493 100644
--- a/drivers/gpu/drm/i915/display/intel_vga.c
+++ b/drivers/gpu/drm/i915/display/intel_vga.c
@@ -158,5 +158,5 @@ void intel_vga_unregister(struct drm_i915_private *i915)
 {
 	struct pci_dev *pdev = to_pci_dev(i915->drm.dev);
 
-	vga_client_register(pdev, NULL, NULL, NULL);
+	vga_client_unregister(pdev);
 }
diff --git a/drivers/gpu/drm/nouveau/nouveau_vga.c b/drivers/gpu/drm/nouveau/nouveau_vga.c
index 7c4b374b3eca..de7a3a860139 100644
--- a/drivers/gpu/drm/nouveau/nouveau_vga.c
+++ b/drivers/gpu/drm/nouveau/nouveau_vga.c
@@ -118,7 +118,7 @@ nouveau_vga_fini(struct nouveau_drm *drm)
 		return;
 	pdev = to_pci_dev(dev->dev);
 
-	vga_client_register(pdev, NULL, NULL, NULL);
+	vga_client_unregister(pdev);
 
 	if (pci_is_thunderbolt_attached(pdev))
 		return;
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 46eea01950cb..d781914f8bcb 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1530,7 +1530,7 @@ void radeon_device_fini(struct radeon_device *rdev)
 		vga_switcheroo_unregister_client(rdev->pdev);
 	if (rdev->flags & RADEON_IS_PX)
 		vga_switcheroo_fini_domain_pm_ops(rdev->dev);
-	vga_client_register(rdev->pdev, NULL, NULL, NULL);
+	vga_client_unregister(rdev->pdev);
 	if (rdev->rio_mem)
 		pci_iounmap(rdev->pdev, rdev->rio_mem);
 	rdev->rio_mem = NULL;
diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 3ed3734f66d9..85b765b80abf 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -877,8 +877,7 @@ EXPORT_SYMBOL(vga_set_legacy_decoding);
  * This function does not check whether a client for @pdev has been registered
  * already.
  *
- * To unregister just call this function with @irq_set_state and @set_vga_decode
- * both set to NULL for the same @pdev as originally used to register them.
+ * To unregister just call vga_client_unregister().
  *
  * Returns: 0 on success, -1 on failure
  */
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 318864d52837..47d13a1fb7fb 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1967,7 +1967,7 @@ static void vfio_pci_vga_uninit(struct vfio_pci_device *vdev)
 
 	if (!vfio_pci_is_vga(pdev))
 		return;
-	vga_client_register(pdev, NULL, NULL, NULL);
+	vga_client_unregister(pdev);
 	vga_set_legacy_decoding(pdev, VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM |
 					      VGA_RSRC_LEGACY_IO |
 					      VGA_RSRC_LEGACY_MEM);
diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
index 05171fc7e26a..7bca61a08700 100644
--- a/include/linux/vgaarb.h
+++ b/include/linux/vgaarb.h
@@ -116,4 +116,9 @@ static inline int vga_get_uninterruptible(struct pci_dev *pdev,
        return vga_get(pdev, rsrc, 0);
 }
 
+static inline void vga_client_unregister(struct pci_dev *pdev)
+{
+	vga_client_register(pdev, NULL, NULL, NULL);
+}
+
 #endif /* LINUX_VGA_H */
-- 
2.30.2

