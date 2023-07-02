Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335DC744FCF
	for <lists+kvm@lfdr.de>; Sun,  2 Jul 2023 20:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjGBS3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Jul 2023 14:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjGBS26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Jul 2023 14:28:58 -0400
Received: from out-54.mta0.migadu.com (out-54.mta0.migadu.com [91.218.175.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DDB1A5
        for <kvm@vger.kernel.org>; Sun,  2 Jul 2023 11:28:38 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688322516;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JD+BSfEOubeM4NaunZhKuggns+1jx3KG/ygiczCTpQY=;
        b=hsPJDuYj9iRgllcgTdnKnVeIWHI4dbFO6cetTcGBRitOohcizdBhNOgpXttZSEDOrRYB5m
        YFJNaZLsmoLXvdcfKsN/KjXlvPsWffQ20eToqWq6ZBWru43mzpRqHFZmlFwwfPaOHCHF4R
        FpaJ05EzBAAFuai3Fohx7nkMzTFuZlM=
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
        Jocelyn Falempe <jfalempe@redhat.com>
Subject: [PATCH v2 6/6] drm/ast: Register as a vga client to vgaarb by calling vga_client_register()
Date:   Mon,  3 Jul 2023 02:27:44 +0800
Message-Id: <20230702182744.755467-7-sui.jingfeng@linux.dev>
In-Reply-To: <20230702182744.755467-1-sui.jingfeng@linux.dev>
References: <20230702182744.755467-1-sui.jingfeng@linux.dev>
MIME-Version: 1.0
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

Becasuse the VGA Display Controller in the ASpeed BMC chip is also a PCIe
device, the Software Programming guide of AST2400 say that it is Fully
IBM VGA compliant, thus, it should also particiate in the arbitration.

Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Signed-off-by: Sui Jingfeng <suijingfeng@loongson.cn>
---
 drivers/gpu/drm/ast/ast_drv.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/gpu/drm/ast/ast_drv.c b/drivers/gpu/drm/ast/ast_drv.c
index e1224ef4ad83..5ce681142679 100644
--- a/drivers/gpu/drm/ast/ast_drv.c
+++ b/drivers/gpu/drm/ast/ast_drv.c
@@ -28,6 +28,7 @@
 
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/vgaarb.h>
 
 #include <drm/drm_aperture.h>
 #include <drm/drm_atomic_helper.h>
@@ -89,6 +90,32 @@ static const struct pci_device_id ast_pciidlist[] = {
 
 MODULE_DEVICE_TABLE(pci, ast_pciidlist);
 
+static bool ast_is_boot_device(struct pci_dev *pdev)
+{
+	struct drm_device *drm = pci_get_drvdata(pdev);
+	struct ast_device *ast = to_ast_device(drm);
+
+	return drm_aperture_contain_firmware_fb(ast->vram_base, ast->vram_size);
+}
+
+static unsigned int ast_vga_set_decode(struct pci_dev *pdev, bool state)
+{
+	struct drm_device *drm = pci_get_drvdata(pdev);
+	struct ast_device *ast = to_ast_device(drm);
+
+	if (state) {
+		/* Enable standard VGA decode and Enable normal VGA decode */
+		ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa1, 0x04);
+
+		return VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM |
+		       VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM;
+	}
+
+	ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa1, 0x07);
+
+	return VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM;
+}
+
 static int ast_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct ast_device *ast;
@@ -112,6 +139,8 @@ static int ast_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		return ret;
 
+	vga_client_register(pdev, ast_vga_set_decode, ast_is_boot_device);
+
 	drm_fbdev_generic_setup(dev, 32);
 
 	return 0;
-- 
2.25.1

