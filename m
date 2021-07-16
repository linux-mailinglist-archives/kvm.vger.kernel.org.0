Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68B33CB267
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 08:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbhGPGZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 02:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbhGPGZq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 02:25:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC40C06175F
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 23:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=QEK+KmUpqEVYeABztaGsomTup/cuJPtMjSQmQNmnaeU=; b=CBLLPmi1cHqDxd9jBgNdwFecLM
        8Shpk0ZMRVvvgKYlZ8G94PanX+EV1SPy32xgUazLM5KP7RiDDQZp7sm3AW6qqsS2EDR3miLIqTv36
        yq/zMp+rIBxgXvs55OWnbl9G87OqnVue9P5srldGoZb7KGJiJwxr8fyvuP7oHAKwAnX6IRX8UZ+VR
        gTQzM/uAHdLgpMtWDXL5KyrJG6bBRSGr2TFW/GzAeRwl7J+D/Si+k+ca/pFx6wiV/XB36u77DZ3KR
        kfckmmKUO6c+fetvaqIfibaCr9SIYtrKEmwg0QzVb0wYA88lZjiVMewt8LVHPA28M3Zttf6pV79GF
        E2YYDuJQ==;
Received: from [2001:4bb8:184:8b7c:6b57:320d:f068:19c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m4HDN-004D3r-1Z; Fri, 16 Jul 2021 06:20:58 +0000
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
Subject: [PATCH 6/7] vgaarb: remove the unused irq_set_state argument to vga_client_register
Date:   Fri, 16 Jul 2021 08:16:33 +0200
Message-Id: <20210716061634.2446357-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210716061634.2446357-1-hch@lst.de>
References: <20210716061634.2446357-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All callers pass NULL as the irq_set_state argument, so remove it and
the ->irq_set_state member in struct vga_device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |  2 +-
 drivers/gpu/drm/i915/display/intel_vga.c   |  2 +-
 drivers/gpu/drm/nouveau/nouveau_vga.c      |  2 +-
 drivers/gpu/drm/radeon/radeon_device.c     |  2 +-
 drivers/gpu/vga/vgaarb.c                   | 23 +---------------------
 drivers/vfio/pci/vfio_pci.c                |  2 +-
 include/linux/vgaarb.h                     |  4 +---
 7 files changed, 7 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 53afe0198e52..e433fab6bcf6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3715,7 +3715,7 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 	/* this will fail for cards that aren't VGA class devices, just
 	 * ignore it */
 	if ((adev->pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA)
-		vga_client_register(adev->pdev, adev, NULL, amdgpu_device_vga_set_decode);
+		vga_client_register(adev->pdev, adev, amdgpu_device_vga_set_decode);
 
 	if (amdgpu_device_supports_px(ddev)) {
 		px = true;
diff --git a/drivers/gpu/drm/i915/display/intel_vga.c b/drivers/gpu/drm/i915/display/intel_vga.c
index 833f9ec14493..0222719e0824 100644
--- a/drivers/gpu/drm/i915/display/intel_vga.c
+++ b/drivers/gpu/drm/i915/display/intel_vga.c
@@ -147,7 +147,7 @@ int intel_vga_register(struct drm_i915_private *i915)
 	 * then we do not take part in VGA arbitration and the
 	 * vga_client_register() fails with -ENODEV.
 	 */
-	ret = vga_client_register(pdev, i915, NULL, intel_vga_set_decode);
+	ret = vga_client_register(pdev, i915, intel_vga_set_decode);
 	if (ret && ret != -ENODEV)
 		return ret;
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_vga.c b/drivers/gpu/drm/nouveau/nouveau_vga.c
index de7a3a860139..d071c11249a3 100644
--- a/drivers/gpu/drm/nouveau/nouveau_vga.c
+++ b/drivers/gpu/drm/nouveau/nouveau_vga.c
@@ -94,7 +94,7 @@ nouveau_vga_init(struct nouveau_drm *drm)
 		return;
 	pdev = to_pci_dev(dev->dev);
 
-	vga_client_register(pdev, dev, NULL, nouveau_vga_set_decode);
+	vga_client_register(pdev, dev, nouveau_vga_set_decode);
 
 	/* don't register Thunderbolt eGPU with vga_switcheroo */
 	if (pci_is_thunderbolt_attached(pdev))
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index d781914f8bcb..11e8e42d99b3 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1434,7 +1434,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	/* if we have > 1 VGA cards, then disable the radeon VGA resources */
 	/* this will fail for cards that aren't VGA class devices, just
 	 * ignore it */
-	vga_client_register(rdev->pdev, rdev, NULL, radeon_vga_set_decode);
+	vga_client_register(rdev->pdev, rdev, radeon_vga_set_decode);
 
 	if (rdev->flags & RADEON_IS_PX)
 		runtime = true;
diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 85b765b80abf..4bde017f6f22 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -72,9 +72,7 @@ struct vga_device {
 	unsigned int io_norm_cnt;	/* normal IO count */
 	unsigned int mem_norm_cnt;	/* normal MEM count */
 	bool bridge_has_one_vga;
-	/* allow IRQ enable/disable hook */
 	void *cookie;
-	void (*irq_set_state)(void *cookie, bool enable);
 	unsigned int (*set_vga_decode)(void *cookie, bool decode);
 };
 
@@ -218,13 +216,6 @@ int vga_remove_vgacon(struct pci_dev *pdev)
 #endif
 EXPORT_SYMBOL(vga_remove_vgacon);
 
-static inline void vga_irq_set_state(struct vga_device *vgadev, bool state)
-{
-	if (vgadev->irq_set_state)
-		vgadev->irq_set_state(vgadev->cookie, state);
-}
-
-
 /* If we don't ever use VGA arb we should avoid
    turning off anything anywhere due to old X servers getting
    confused about the boot device not being VGA */
@@ -325,10 +316,8 @@ static struct vga_device *__vga_tryget(struct vga_device *vgadev,
 			if ((match & conflict->decodes) & VGA_RSRC_LEGACY_IO)
 				pci_bits |= PCI_COMMAND_IO;
 
-			if (pci_bits) {
-				vga_irq_set_state(conflict, false);
+			if (pci_bits)
 				flags |= PCI_VGA_STATE_CHANGE_DECODES;
-			}
 		}
 
 		if (change_bridge)
@@ -365,9 +354,6 @@ static struct vga_device *__vga_tryget(struct vga_device *vgadev,
 
 	pci_set_vga_state(vgadev->pdev, true, pci_bits, flags);
 
-	if (!vgadev->bridge_has_one_vga)
-		vga_irq_set_state(vgadev, true);
-
 	vgadev->owns |= wants;
 lock_them:
 	vgadev->locks |= (rsrc & VGA_RSRC_LEGACY_MASK);
@@ -855,15 +841,10 @@ EXPORT_SYMBOL(vga_set_legacy_decoding);
  * vga_client_register - register or unregister a VGA arbitration client
  * @pdev: pci device of the VGA client
  * @cookie: client cookie to be used in callbacks
- * @irq_set_state: irq state change callback
  * @set_vga_decode: vga decode change callback
  *
  * Clients have two callback mechanisms they can use.
  *
- * @irq_set_state callback: If a client can't disable its GPUs VGA
- * resources, then we need to be able to ask it to turn off its irqs when we
- * turn off its mem and io decoding.
- *
  * @set_vga_decode callback: If a client can disable its GPU VGA resource, it
  * will get a callback from this to set the encode/decode state.
  *
@@ -882,7 +863,6 @@ EXPORT_SYMBOL(vga_set_legacy_decoding);
  * Returns: 0 on success, -1 on failure
  */
 int vga_client_register(struct pci_dev *pdev, void *cookie,
-			void (*irq_set_state)(void *cookie, bool state),
 			unsigned int (*set_vga_decode)(void *cookie,
 						       bool decode))
 {
@@ -895,7 +875,6 @@ int vga_client_register(struct pci_dev *pdev, void *cookie,
 	if (!vgadev)
 		goto bail;
 
-	vgadev->irq_set_state = irq_set_state;
 	vgadev->set_vga_decode = set_vga_decode;
 	vgadev->cookie = cookie;
 	ret = 0;
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 47d13a1fb7fb..cc7d7592e7b1 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1954,7 +1954,7 @@ static int vfio_pci_vga_init(struct vfio_pci_device *vdev)
 	if (!vfio_pci_is_vga(pdev))
 		return 0;
 
-	ret = vga_client_register(pdev, vdev, NULL, vfio_pci_set_vga_decode);
+	ret = vga_client_register(pdev, vdev, vfio_pci_set_vga_decode);
 	if (ret)
 		return ret;
 	vga_set_legacy_decoding(pdev, vfio_pci_set_vga_decode(vdev, false));
diff --git a/include/linux/vgaarb.h b/include/linux/vgaarb.h
index 7bca61a08700..ea45d3e86fff 100644
--- a/include/linux/vgaarb.h
+++ b/include/linux/vgaarb.h
@@ -52,7 +52,6 @@ struct pci_dev *vga_default_device(void);
 void vga_set_default_device(struct pci_dev *pdev);
 int vga_remove_vgacon(struct pci_dev *pdev);
 int vga_client_register(struct pci_dev *pdev, void *cookie,
-			void (*irq_set_state)(void *cookie, bool state),
 			unsigned int (*set_vga_decode)(void *cookie, bool state));
 #else /* CONFIG_VGA_ARB */
 static inline void vga_set_legacy_decoding(struct pci_dev *pdev,
@@ -79,7 +78,6 @@ static inline int vga_remove_vgacon(struct pci_dev *pdev)
 	return 0;
 }
 static inline int vga_client_register(struct pci_dev *pdev, void *cookie,
-				      void (*irq_set_state)(void *cookie, bool state),
 				      unsigned int (*set_vga_decode)(void *cookie, bool state))
 {
 	return 0;
@@ -118,7 +116,7 @@ static inline int vga_get_uninterruptible(struct pci_dev *pdev,
 
 static inline void vga_client_unregister(struct pci_dev *pdev)
 {
-	vga_client_register(pdev, NULL, NULL, NULL);
+	vga_client_register(pdev, NULL, NULL);
 }
 
 #endif /* LINUX_VGA_H */
-- 
2.30.2

