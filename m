Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D017744FCB
	for <lists+kvm@lfdr.de>; Sun,  2 Jul 2023 20:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjGBS24 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Jul 2023 14:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjGBS2v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Jul 2023 14:28:51 -0400
Received: from out-46.mta0.migadu.com (out-46.mta0.migadu.com [IPv6:2001:41d0:1004:224b::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0F3CD
        for <kvm@vger.kernel.org>; Sun,  2 Jul 2023 11:28:34 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688322512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3gdqYsSHavNjy6uu6OI5/B6vHhjDXBQp6xohAWX8uZE=;
        b=m25TPTQophaiDUZ//UGt3Os2cQOocfRXNRltUvkgGKUmmO1Z9ZWC0+jbrfZCCmk5ZDhcWG
        RwWTo0rs4bnl6YWCbMPzsuPUmdOIrtmtok5pZW7Bwy9cqQ4Ab13vfqjcUiKXmWEE53TSZU
        DBeEwVD0D5LNY0mxMcaZN1DBsAGHjbk=
From:   Sui Jingfeng <sui.jingfeng@linux.dev>
To:     Alex Deucher <alexander.deucher@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Maxime Ripard <mripard@kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Lyude Paul <lyude@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Cc:     dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Sui Jingfeng <suijingfeng@loongson.cn>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>
Subject: [PATCH v2 5/6] drm/i915: Implement the is_boot_device callback function
Date:   Mon,  3 Jul 2023 02:27:43 +0800
Message-Id: <20230702182744.755467-6-sui.jingfeng@linux.dev>
In-Reply-To: <20230702182744.755467-1-sui.jingfeng@linux.dev>
References: <20230702182744.755467-1-sui.jingfeng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sui Jingfeng <suijingfeng@loongson.cn>

This patch add a function to identify if a device is the default boot
selected by the firmware, it require the GPU has firmware framebuffer
driver support (such as efifb). If a specific hardware doesn't have
firmware framebuffer support, then the introduced function will just
return false. But even in this case, it still do no harms.

Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: "Ville Syrjälä" <ville.syrjala@linux.intel.com>
Cc: Lyude Paul <lyude@redhat.com>
Signed-off-by: Sui Jingfeng <suijingfeng@loongson.cn>
---
 drivers/gpu/drm/i915/display/intel_vga.c | 31 +++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_vga.c b/drivers/gpu/drm/i915/display/intel_vga.c
index 98d7d4dffe9f..7a0ba677c932 100644
--- a/drivers/gpu/drm/i915/display/intel_vga.c
+++ b/drivers/gpu/drm/i915/display/intel_vga.c
@@ -6,6 +6,8 @@
 #include <linux/pci.h>
 #include <linux/vgaarb.h>
 
+#include <drm/drm_aperture.h>
+
 #include <video/vga.h>
 
 #include "soc/intel_gmch.h"
@@ -113,6 +115,32 @@ intel_vga_set_decode(struct pci_dev *pdev, bool enable_decode)
 		return VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM;
 }
 
+static bool intel_vga_is_default_boot_device(struct pci_dev *pdev)
+{
+	struct drm_i915_private *i915 = pdev_to_i915(pdev);
+	struct drm_device *drm = &i915->drm;
+	struct i915_gem_mm *mm = &i915->mm;
+	struct intel_memory_region *mr;
+	unsigned int i;
+	bool ret;
+
+	for (i = 0; i < ARRAY_SIZE(mm->regions); i++) {
+		mr = mm->regions[i];
+		if (mr) {
+			ret = drm_aperture_contain_firmware_fb(mr->io_start,
+							       mr->io_size);
+
+			if (ret) {
+				drm_dbg(drm, "%s contains firmware fb\n",
+					mr->name);
+				return true;
+			}
+		}
+	}
+
+	return false;
+}
+
 int intel_vga_register(struct drm_i915_private *i915)
 {
 	struct pci_dev *pdev = to_pci_dev(i915->drm.dev);
@@ -126,7 +154,8 @@ int intel_vga_register(struct drm_i915_private *i915)
 	 * then we do not take part in VGA arbitration and the
 	 * vga_client_register() fails with -ENODEV.
 	 */
-	ret = vga_client_register(pdev, intel_vga_set_decode, NULL);
+	ret = vga_client_register(pdev, intel_vga_set_decode,
+				  intel_vga_is_default_boot_device);
 	if (ret && ret != -ENODEV)
 		return ret;
 
-- 
2.25.1

