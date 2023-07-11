Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D7274F56F
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 18:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbjGKQcw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 12:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbjGKQce (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 12:32:34 -0400
Received: from out-53.mta0.migadu.com (out-53.mta0.migadu.com [91.218.175.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1308C10EF
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 09:32:30 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689093148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qerYEjJsYQa89wBNUybGoMjyzLMs27H7zUPn+Dcw/G0=;
        b=Guu9GWOLPIQdkgo6IRvQX7zSkVsf7DNZDKM8AeogWr5E6rpQEYaIWbmNDJLcGU6Fen+QLD
        9RIN+CGIDpMCU7gRAg76N6VsCw8OMavcu0tA+en7SF2lOR2aMCsxFl2WxdHYKo8LFblL7F
        uBqREnG+4qj40UxbrWCEHB6XPKqAuvc=
From:   Sui Jingfeng <sui.jingfeng@linux.dev>
To:     Alex Deucher <alexander.deucher@amd.com>,
        Christian Koenig <christian.koenig@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Jocelyn Falempe <jfalempe@redhat.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Maxime Ripard <mripard@kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Ben Skeggs <bskeggs@redhat.com>, Lyude Paul <lyude@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Helge Deller <deller@gmx.de>,
        Mario Limonciello <mario.limonciello@amd.com>
Cc:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Sui Jingfeng <suijingfeng@loongson.cn>
Subject: [PATCH v3 3/9] PCI/VGA: Switch to aperture_contain_firmware_fb_nonreloc()
Date:   Wed, 12 Jul 2023 00:31:49 +0800
Message-Id: <20230711163155.791522-4-sui.jingfeng@linux.dev>
In-Reply-To: <20230711163155.791522-1-sui.jingfeng@linux.dev>
References: <20230711163155.791522-1-sui.jingfeng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sui Jingfeng <suijingfeng@loongson.cn>

The observation behind this is that we should avoid accessing the global
screen_info directly. Call the aperture_contain_firmware_fb_nonreloc()
function to implement the detection of whether an aperture contains the
firmware FB.

This patch helps to decouple the determination from the implementation.
Or, in other words, we intend to make the determination opaque to the
caller. The determination may choose to be arch-dependent or
arch-independent. But vgaarb, as a consumer of the determination,
shouldn't care how the does determination is implemented.

Signed-off-by: Sui Jingfeng <suijingfeng@loongson.cn>
---
 drivers/pci/vgaarb.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/vgaarb.c b/drivers/pci/vgaarb.c
index bf96e085751d..953daf731b2c 100644
--- a/drivers/pci/vgaarb.c
+++ b/drivers/pci/vgaarb.c
@@ -14,6 +14,7 @@
 #define vgaarb_info(dev, fmt, arg...)	dev_info(dev, "vgaarb: " fmt, ##arg)
 #define vgaarb_err(dev, fmt, arg...)	dev_err(dev, "vgaarb: " fmt, ##arg)
 
+#include <linux/aperture.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
@@ -26,7 +27,6 @@
 #include <linux/poll.h>
 #include <linux/miscdevice.h>
 #include <linux/slab.h>
-#include <linux/screen_info.h>
 #include <linux/vt.h>
 #include <linux/console.h>
 #include <linux/acpi.h>
@@ -558,20 +558,11 @@ void vga_put(struct pci_dev *pdev, unsigned int rsrc)
 }
 EXPORT_SYMBOL(vga_put);
 
+/* Select the device owning the boot framebuffer if there is one */
 static bool vga_is_firmware_default(struct pci_dev *pdev)
 {
 #if defined(CONFIG_X86) || defined(CONFIG_IA64)
-	u64 base = screen_info.lfb_base;
-	u64 size = screen_info.lfb_size;
 	struct resource *r;
-	u64 limit;
-
-	/* Select the device owning the boot framebuffer if there is one */
-
-	if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
-		base |= (u64)screen_info.ext_lfb_base << 32;
-
-	limit = base + size;
 
 	/* Does firmware framebuffer belong to us? */
 	pci_dev_for_each_resource(pdev, r) {
@@ -581,10 +572,8 @@ static bool vga_is_firmware_default(struct pci_dev *pdev)
 		if (!r->start || !r->end)
 			continue;
 
-		if (base < r->start || limit >= r->end)
-			continue;
-
-		return true;
+		if (aperture_contain_firmware_fb_nonreloc(r->start, r->end))
+			return true;
 	}
 #endif
 	return false;
-- 
2.25.1

