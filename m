Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4531774F555
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 18:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbjGKQch (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 12:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232314AbjGKQca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 12:32:30 -0400
Received: from out-45.mta0.migadu.com (out-45.mta0.migadu.com [91.218.175.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C13B172A
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 09:32:25 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689093143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GBy5pJ1hlnJ55l3+0FoW8CoU4fx5kPQd0O17NeAPNiY=;
        b=KYZlRghveBlPMMdTqgJuH2AOo5abl3+OkOVDjyy45nGSjfPLiaDVmnhOlljKyx8oMCa60y
        d7BFmREY8tPS1z9BIqw+xfPILjT53tOeW9fmTmFDOC4vkTkMTAw4mABB/S2iui/+v/n05V
        4vY56OUQGLAxs6SUJ/Lz8uxkPskosok=
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
Subject: [PATCH v3 2/9] video/aperture: Add a helper for determining if an unmoved aperture contain FB
Date:   Wed, 12 Jul 2023 00:31:48 +0800
Message-Id: <20230711163155.791522-3-sui.jingfeng@linux.dev>
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

This patch is intended to form a uniform approach to determining if an
unmoved aperture contains the firmware FB. I believe that the global
screen_info is more about video-specific things.

Putting it in video/aperture.c helps form a uniform approach.

Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Sui Jingfeng <suijingfeng@loongson.cn>
---
 drivers/video/aperture.c | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/aperture.h |  7 +++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/video/aperture.c b/drivers/video/aperture.c
index 34eb962cfae8..f03dfcabc303 100644
--- a/drivers/video/aperture.c
+++ b/drivers/video/aperture.c
@@ -6,6 +6,7 @@
 #include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
+#include <linux/screen_info.h>
 #include <linux/slab.h>
 #include <linux/sysfb.h>
 #include <linux/types.h>
@@ -406,3 +407,38 @@ bool aperture_contain_firmware_fb(resource_size_t ap_start, resource_size_t ap_e
 	return false;
 }
 EXPORT_SYMBOL(aperture_contain_firmware_fb);
+
+/**
+ * aperture_contain_firmware_fb_nonreloc - Detect if the firmware framebuffer
+ * belong to a non-relocatable aperture, such as the aperture of platform
+ * device. Note that this function relay on the global screen info.
+ * @ap_start: the aperture's start address in physical memory
+ * @ap_end: the aperture's end address in physical memory
+ *
+ * Returns:
+ * true if there is a firmware framebuffer belong to the aperture passed in,
+ * or false otherwise.
+ */
+bool aperture_contain_firmware_fb_nonreloc(resource_size_t ap_start, resource_size_t ap_end)
+{
+	u64 fb_start;
+	u64 fb_end;
+
+	if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE) {
+		fb_start = (u64)screen_info.ext_lfb_base << 32 | screen_info.lfb_base;
+		fb_end = fb_start + screen_info.lfb_size;
+	} else {
+		fb_start = screen_info.lfb_base;
+		fb_end = fb_start + screen_info.lfb_size;
+	}
+
+	/* No firmware framebuffer support */
+	if (!fb_start || !fb_end)
+		return false;
+
+	if (fb_start >= ap_start && fb_end <= ap_end)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(aperture_contain_firmware_fb_nonreloc);
diff --git a/include/linux/aperture.h b/include/linux/aperture.h
index d4dc5917c49b..906d23532b56 100644
--- a/include/linux/aperture.h
+++ b/include/linux/aperture.h
@@ -21,6 +21,8 @@ int __aperture_remove_legacy_vga_devices(struct pci_dev *pdev);
 int aperture_remove_conflicting_pci_devices(struct pci_dev *pdev, const char *name);
 
 bool aperture_contain_firmware_fb(resource_size_t ap_start, resource_size_t ap_end);
+
+bool aperture_contain_firmware_fb_nonreloc(resource_size_t ap_start, resource_size_t ap_end);
 #else
 static inline int devm_aperture_acquire_for_platform_device(struct platform_device *pdev,
 							    resource_size_t base,
@@ -49,6 +51,11 @@ static inline bool aperture_contain_firmware_fb(resource_size_t ap_start, resour
 {
 	return false;
 }
+
+static bool aperture_contain_firmware_fb_nonreloc(resource_size_t ap_start, resource_size_t ap_end)
+{
+	return false;
+}
 #endif
 
 /**
-- 
2.25.1

