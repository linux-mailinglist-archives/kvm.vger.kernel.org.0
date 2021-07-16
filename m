Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5393CB270
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 08:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhGPG1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 02:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbhGPG1K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 02:27:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CC0C06175F
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 23:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=pNT+tlhb1TLZaD7zJSk0QSZZNpZ5j/lxFFrE1P5YCYo=; b=OhO+1fdiWv/p4CkMbSy5g3Uh5T
        zca2YmlRA3/jiwSte2lroKP9h6yVgPBj+BLiYBILyoYtwwY3Wyk/s8EcfbaShtqtgtETAdG0omTO8
        XskZEB4ze+dQmqvkgZrcQ9hbkS0q+k4xYXPhJgPFGZy/UQqi96jG08qvbeAayxDrQi1r3dcpou02/
        A6EGq7EJR0lDqVxp7WbsJWZFSnOSsA3kig2JSJ1V4KtxDx/O1C6J9oBu01WWX4mPsVPbAMrfbjjG0
        m7VpYIRA2oYazBh6c25rIiiPCTXf+i9iKUqHx2aA4dGDPd1c0hksggfWZX65f9OCnPDmpkW7JvSXp
        PGlYb8Lg==;
Received: from [2001:4bb8:184:8b7c:6b57:320d:f068:19c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m4HEM-004D75-AS; Fri, 16 Jul 2021 06:22:02 +0000
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
Subject: [PATCH 7/7] vgaarb: don't pass a cookie to vga_client_register
Date:   Fri, 16 Jul 2021 08:16:34 +0200
Message-Id: <20210716061634.2446357-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210716061634.2446357-1-hch@lst.de>
References: <20210716061634.2446357-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VGA arbitration is entirely based on pci_dev structures, so just pass
that back to the set_vga_decode callback.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |  9 ++++----
 drivers/gpu/drm/i915/display/intel_vga.c   |  7 ++++---
 drivers/gpu/drm/nouveau/nouveau_vga.c      |  6 +++---
 drivers/gpu/drm/radeon/radeon_device.c     |  9 ++++----
 drivers/gpu/vga/vgaarb.c                   | 24 +++++++++-------------
 drivers/vfio/pci/vfio_pci.c                |  9 ++++----
 include/linux/vgaarb.h                     | 10 ++++-----
 7 files changed, 36 insertions(+), 38 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index e433fab6bcf6..8398daa0c06a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1266,15 +1266,16 @@ bool amdgpu_device_need_post(struct amdgpu_device *adev)
 /**
  * amdgpu_device_vga_set_decode - enable/disable vga decode
  *
- * @cookie: amdgpu_device pointer
+ * @pdev: PCI device pointer
  * @state: enable/disable vga decode
  *
  * Enable/disable vga decode (all asics).
  * Returns VGA resource flags.
  */
-static unsigned int amdgpu_device_vga_set_decode(void *cookie, bool state)
+static unsigned int amdgpu_device_vga_set_decode(struct pci_dev *pdev,
+		bool state)
 {
-	struct amdgpu_device *adev = cookie;
+	struct amdgpu_device *adev = drm_to_adev(pci_get_drvdata(pdev));
 	amdgpu_asic_set_vga_state(adev, state);
 	if (state)
 		return VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM |
@@ -3715,7 +3716,7 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 	/* this will fail for cards that aren't VGA class devices, just
 	 * ignore it */
 	if ((adev->pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA)
-		vga_client_register(adev->pdev, adev, amdgpu_device_vga_set_decode);
+		vga_client_register(adev->pdev, amdgpu_device_vga_set_decode);
 
 	if (amdgpu_device_supports_px(ddev)) {
 		px = true;
diff --git a/drivers/gpu/drm/i915/display/intel_vga.c b/drivers/gpu/drm/i915/display/intel_vga.c
index 0222719e0824..16c250700985 100644
--- a/drivers/gpu/drm/i915/display/intel_vga.c
+++ b/drivers/gpu/drm/i915/display/intel_vga.c
@@ -121,9 +121,9 @@ intel_vga_set_state(struct drm_i915_private *i915, bool enable_decode)
 }
 
 static unsigned int
-intel_vga_set_decode(void *cookie, bool enable_decode)
+intel_vga_set_decode(struct pci_dev *pdev, bool enable_decode)
 {
-	struct drm_i915_private *i915 = cookie;
+	struct drm_i915_private *i915 = pdev_to_i915(pdev);
 
 	intel_vga_set_state(i915, enable_decode);
 
@@ -136,6 +136,7 @@ intel_vga_set_decode(void *cookie, bool enable_decode)
 
 int intel_vga_register(struct drm_i915_private *i915)
 {
+
 	struct pci_dev *pdev = to_pci_dev(i915->drm.dev);
 	int ret;
 
@@ -147,7 +148,7 @@ int intel_vga_register(struct drm_i915_private *i915)
 	 * then we do not take part in VGA arbitration and the
 	 * vga_client_register() fails with -ENODEV.
 	 */
-	ret = vga_client_register(pdev, i915, intel_vga_set_decode);
+	ret = vga_client_register(pdev, intel_vga_set_decode);
 	if (ret && ret != -ENODEV)
 		return ret;
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_vga.c b/drivers/gpu/drm/nouveau/nouveau_vga.c
index d071c11249a3..60cd8c0463df 100644
--- a/drivers/gpu/drm/nouveau/nouveau_vga.c
+++ b/drivers/gpu/drm/nouveau/nouveau_vga.c
@@ -11,9 +11,9 @@
 #include "nouveau_vga.h"
 
 static unsigned int
-nouveau_vga_set_decode(void *priv, bool state)
+nouveau_vga_set_decode(struct pci_dev *pdev, bool state)
 {
-	struct nouveau_drm *drm = nouveau_drm(priv);
+	struct nouveau_drm *drm = nouveau_drm(pci_get_drvdata(pdev));
 	struct nvif_object *device = &drm->client.device.object;
 
 	if (drm->client.device.info.family == NV_DEVICE_INFO_V0_CURIE &&
@@ -94,7 +94,7 @@ nouveau_vga_init(struct nouveau_drm *drm)
 		return;
 	pdev = to_pci_dev(dev->dev);
 
-	vga_client_register(pdev, dev, nouveau_vga_set_decode);
+	vga_client_register(pdev, nouveau_vga_set_decode);
 
 	/* don't register Thunderbolt eGPU with vga_switcheroo */
 	if (pci_is_thunderbolt_attached(pdev))
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 11e8e42d99b3..cec03238e14d 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1067,15 +1067,16 @@ void radeon_combios_fini(struct radeon_device *rdev)
 /**
  * radeon_vga_set_decode - enable/disable vga decode
  *
- * @cookie: radeon_device pointer
+ * @pdev: PCI device
  * @state: enable/disable vga decode
  *
  * Enable/disable vga decode (all asics).
  * Returns VGA resource flags.
  */
-static unsigned int radeon_vga_set_decode(void *cookie, bool state)
+static unsigned int radeon_vga_set_decode(struct pci_dev *pdev, bool state)
 {
-	struct radeon_device *rdev = cookie;
+	struct drm_device *dev = pci_get_drvdata(pdev);
+	struct radeon_device *rdev = dev->dev_private;
 	radeon_vga_set_state(rdev, state);
 	if (state)
 		return VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM |
@@ -1434,7 +1435,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	/* if we have > 1 VGA cards, then disable the radeon VGA resources */
 	/* this will fail for cards that aren't VGA class devices, just
 	 * ignore it */
-	vga_client_register(rdev->pdev, rdev, radeon_vga_set_decode);
+	vga_client_register(rdev->pdev, radeon_vga_set_decode);
 
 	if (rdev->flags & RADEON_IS_PX)
 		runtime = true;
diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 4bde017f6f22..569930552957 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -72,8 +72,7 @@ struct vga_device {
 	unsigned int io_norm_cnt;	/* normal IO count */
 	unsigned int mem_norm_cnt;	/* normal MEM count */
 	bool bridge_has_one_vga;
-	void *cookie;
-	unsigned int (*set_vga_decode)(void *cookie, bool decode);
+	unsigned int (*set_decode)(struct pci_dev *pdev, bool decode);
 };
 
 static LIST_HEAD(vga_list);
@@ -806,7 +805,7 @@ static void __vga_set_legacy_decoding(struct pci_dev *pdev,
 		goto bail;
 
 	/* don't let userspace futz with kernel driver decodes */
-	if (userspace && vgadev->set_vga_decode)
+	if (userspace && vgadev->set_decode)
 		goto bail;
 
 	/* update the device decodes + counter */
@@ -840,12 +839,11 @@ EXPORT_SYMBOL(vga_set_legacy_decoding);
 /**
  * vga_client_register - register or unregister a VGA arbitration client
  * @pdev: pci device of the VGA client
- * @cookie: client cookie to be used in callbacks
- * @set_vga_decode: vga decode change callback
+ * @set_decode: vga decode change callback
  *
  * Clients have two callback mechanisms they can use.
  *
- * @set_vga_decode callback: If a client can disable its GPU VGA resource, it
+ * @set_decode callback: If a client can disable its GPU VGA resource, it
  * will get a callback from this to set the encode/decode state.
  *
  * Rationale: we cannot disable VGA decode resources unconditionally some single
@@ -862,9 +860,8 @@ EXPORT_SYMBOL(vga_set_legacy_decoding);
  *
  * Returns: 0 on success, -1 on failure
  */
-int vga_client_register(struct pci_dev *pdev, void *cookie,
-			unsigned int (*set_vga_decode)(void *cookie,
-						       bool decode))
+int vga_client_register(struct pci_dev *pdev,
+		unsigned int (*set_decode)(struct pci_dev *pdev, bool decode))
 {
 	int ret = -ENODEV;
 	struct vga_device *vgadev;
@@ -875,8 +872,7 @@ int vga_client_register(struct pci_dev *pdev, void *cookie,
 	if (!vgadev)
 		goto bail;
 
-	vgadev->set_vga_decode = set_vga_decode;
-	vgadev->cookie = cookie;
+	vgadev->set_decode = set_decode;
 	ret = 0;
 
 bail:
@@ -1386,9 +1382,9 @@ static void vga_arbiter_notify_clients(void)
 			new_state = false;
 		else
 			new_state = true;
-		if (vgadev->set_vga_decode) {
-			new_decodes = vgadev->set_vga_decode(vgadev->cookie,
-							     new_state);
+		if (vgadev->set_decode) {
+			new_decodes = vgadev->set_decode(vgadev->pdev,
+							 new_state);
 			vga_update_device_decodes(vgadev, new_decodes);
 		}
 	}
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index cc7d7592e7b1..cf27df8048db 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -119,10 +119,9 @@ static bool vfio_pci_is_denylisted(struct pci_dev *pdev)
  * has no way to get to it and routing can be disabled externally at the
  * bridge.
  */
-static unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga)
+static unsigned int vfio_pci_set_decode(struct pci_dev *pdev, bool single_vga)
 {
-	struct vfio_pci_device *vdev = opaque;
-	struct pci_dev *tmp = NULL, *pdev = vdev->pdev;
+	struct pci_dev *tmp = NULL;
 	unsigned char max_busnr;
 	unsigned int decodes;
 
@@ -1954,10 +1953,10 @@ static int vfio_pci_vga_init(struct vfio_pci_device *vdev)
 	if (!vfio_pci_is_vga(pdev))
 		return 0;
 
-	ret = vga_client_register(pdev, vdev, vfio_pci_set_vga_decode);
+	ret = vga_client_register(pdev, vfio_pci_set_decode);
 	if (ret)
 		return ret;
-	vga_set_legacy_decoding(pdev, vfio_pci_set_vga_decode(vdev, false));
+	vga_set_legacy_decoding(pdev, vfio_pci_set_decode(pdev, false));
 	return 0;
 }
 
diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
index ea45d3e86fff..b4b9137f9792 100644
--- a/include/linux/vgaarb.h
+++ b/include/linux/vgaarb.h
@@ -51,8 +51,8 @@ void vga_put(struct pci_dev *pdev, unsigned int rsrc);
 struct pci_dev *vga_default_device(void);
 void vga_set_default_device(struct pci_dev *pdev);
 int vga_remove_vgacon(struct pci_dev *pdev);
-int vga_client_register(struct pci_dev *pdev, void *cookie,
-			unsigned int (*set_vga_decode)(void *cookie, bool state));
+int vga_client_register(struct pci_dev *pdev,
+		unsigned int (*set_decode)(struct pci_dev *pdev, bool state));
 #else /* CONFIG_VGA_ARB */
 static inline void vga_set_legacy_decoding(struct pci_dev *pdev,
 		unsigned int decodes)
@@ -77,8 +77,8 @@ static inline int vga_remove_vgacon(struct pci_dev *pdev)
 {
 	return 0;
 }
-static inline int vga_client_register(struct pci_dev *pdev, void *cookie,
-				      unsigned int (*set_vga_decode)(void *cookie, bool state))
+static inline int vga_client_register(struct pci_dev *pdev,
+		unsigned int (*set_decode)(struct pci_dev *pdev, bool state))
 {
 	return 0;
 }
@@ -116,7 +116,7 @@ static inline int vga_get_uninterruptible(struct pci_dev *pdev,
 
 static inline void vga_client_unregister(struct pci_dev *pdev)
 {
-	vga_client_register(pdev, NULL, NULL);
+	vga_client_register(pdev, NULL);
 }
 
 #endif /* LINUX_VGA_H */
-- 
2.30.2

