Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E28372D7F4
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 05:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239419AbjFMDFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 23:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239386AbjFMDEG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 23:04:06 -0400
Received: from 189.cn (ptr.189.cn [183.61.185.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4AE8210A;
        Mon, 12 Jun 2023 20:03:07 -0700 (PDT)
HMM_SOURCE_IP: 10.64.8.43:47948.1267835893
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-114.242.206.180 (unknown [10.64.8.43])
        by 189.cn (HERMES) with SMTP id 2B88B1002F4;
        Tue, 13 Jun 2023 11:02:26 +0800 (CST)
Received: from  ([114.242.206.180])
        by gateway-151646-dep-75648544bd-7vx9t with ESMTP id 9b21112c8a744a598e4680c08d0d9487 for bhelgaas@google.com;
        Tue, 13 Jun 2023 11:02:30 CST
X-Transaction-ID: 9b21112c8a744a598e4680c08d0d9487
X-Real-From: 15330273260@189.cn
X-Receive-IP: 114.242.206.180
X-MEDUSA-Status: 0
Sender: 15330273260@189.cn
From:   Sui Jingfeng <15330273260@189.cn>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Sui Jingfeng <suijingfeng@loongson.cn>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian Konig <christian.koenig@amd.com>,
        Pan Xinhui <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>
Subject: [PATCH v7 8/8] drm/radeon: Implement the is_boot_device callback function
Date:   Tue, 13 Jun 2023 11:01:51 +0800
Message-Id: <20230613030151.216625-9-15330273260@189.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230613030151.216625-1-15330273260@189.cn>
References: <20230613030151.216625-1-15330273260@189.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FROM_LOCAL_DIGITS,
        FROM_LOCAL_HEX,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sui Jingfeng <suijingfeng@loongson.cn>

[why]

The vga_is_firmware_default() defined in drivers/pci/vgaarb.c is
arch-dependent, it's a dummy on non-x86 architectures currently.
This made VGAARB lost an important condition for the arbitration.
It could still be wrong even if we remove the #ifdef and #endif guards.
because the PCI bar will move (resource re-allocation).

[how]

The device that owns the firmware framebuffer should be the default boot
device. This patch adds an arch-independent function to enforce this rule.
The vgaarb subsystem will call back to radeon_is_boot_device() function
when drm/radeon is successfully bound to a radeon GPU device.

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian Konig <christian.koenig@amd.com>
Cc: Pan Xinhui <Xinhui.Pan@amd.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Sui Jingfeng <suijingfeng@loongson.cn>
---
 drivers/gpu/drm/radeon/radeon_device.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 71f2ff39d6a1..afb49000830c 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -34,6 +34,7 @@
 #include <linux/vga_switcheroo.h>
 #include <linux/vgaarb.h>
 
+#include <drm/drm_aperture.h>
 #include <drm/drm_cache.h>
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_device.h>
@@ -1263,6 +1264,15 @@ static const struct vga_switcheroo_client_ops radeon_switcheroo_ops = {
 	.can_switch = radeon_switcheroo_can_switch,
 };
 
+static bool radeon_is_boot_device(struct pci_dev *pdev)
+{
+	struct drm_device *dev = pci_get_drvdata(pdev);
+	struct radeon_device *rdev = dev->dev_private;
+	struct radeon_mc *gmc = &rdev->mc;
+
+	return drm_aperture_contain_firmware_fb(gmc->aper_base, gmc->aper_size);
+}
+
 /**
  * radeon_device_init - initialize the driver
  *
@@ -1425,7 +1435,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	/* if we have > 1 VGA cards, then disable the radeon VGA resources */
 	/* this will fail for cards that aren't VGA class devices, just
 	 * ignore it */
-	vga_client_register(rdev->pdev, radeon_vga_set_decode, NULL);
+	vga_client_register(rdev->pdev, radeon_vga_set_decode, radeon_is_boot_device);
 
 	if (rdev->flags & RADEON_IS_PX)
 		runtime = true;
-- 
2.25.1

