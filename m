Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5EF74F624
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 18:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbjGKQxk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 12:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbjGKQxe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 12:53:34 -0400
Received: from out-13.mta1.migadu.com (out-13.mta1.migadu.com [IPv6:2001:41d0:203:375::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D030310EB
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 09:53:32 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689093824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NIlpd2OuXAqZBmAKqEiHOVF8G3KI4fwGrKLh4KCVTtk=;
        b=ecINMnuvOGXb9BbruD5LvN4Yp3H0QtakNbtBqZGtbF+uuD1Ia0wIToBo3dNnNdqp2wca3L
        /dYsRshA52X9SZ13jGxCqAkY/HzcvDJ4zQmkUC31Et0p3dmpUkcI+j+ErMq5ZjHq/6QDJz
        5m4MiOwv+urTFm8EUQit+44ndOvrrvU=
From:   Sui Jingfeng <sui.jingfeng@linux.dev>
To:     David Airlie <airlied@gmail.com>
Cc:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Sui Jingfeng <suijingfeng@loongson.cn>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian Konig <christian.koenig@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH v3 5/9] drm/amdgpu: Implement the is_primary_gpu callback of vga_client_register()
Date:   Wed, 12 Jul 2023 00:43:06 +0800
Message-Id: <20230711164310.791756-6-sui.jingfeng@linux.dev>
In-Reply-To: <20230711164310.791756-1-sui.jingfeng@linux.dev>
References: <20230711164310.791756-1-sui.jingfeng@linux.dev>
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

[why]

The vga_is_firmware_default() function defined in drivers/pci/vgaarb.c is
arch-dependent, it's a dummy on non-x86 architectures. This made VGAARB
lost an important condition for the arbitration on non-x86 platform. The
rules about which GPU is (or should be) the primary display device get used
by userspace are obscure on non-x86 platform, let's made the things clear.

[how]

The device that owns the firmware framebuffer should be the default boot
device. This patch adds an arch-independent function to implement this
rule. The vgaarb subsystem will call back to amdgpu_is_primary_gpu() when
drm/amdgpu is bound to an AMDGPU device successfully.

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian Konig <christian.koenig@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sui Jingfeng <suijingfeng@loongson.cn>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index d98f0801ac77..b638eff58636 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3690,6 +3690,15 @@ static void amdgpu_device_set_mcbp(struct amdgpu_device *adev)
 		DRM_INFO("MCBP is enabled\n");
 }
 
+static bool amdgpu_is_primary_gpu(struct pci_dev *pdev)
+{
+	struct drm_device *dev = pci_get_drvdata(pdev);
+	struct amdgpu_device *adev = drm_to_adev(dev);
+	struct amdgpu_gmc *gmc = &adev->gmc;
+
+	return drm_aperture_contain_firmware_fb(gmc->aper_base, gmc->aper_size);
+}
+
 /**
  * amdgpu_device_init - initialize the driver
  *
@@ -4103,7 +4112,8 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 	/* this will fail for cards that aren't VGA class devices, just
 	 * ignore it */
 	if ((adev->pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA)
-		vga_client_register(adev->pdev, amdgpu_device_vga_set_decode, NULL);
+		vga_client_register(adev->pdev, amdgpu_device_vga_set_decode,
+				    amdgpu_is_primary_gpu);
 
 	px = amdgpu_device_supports_px(ddev);
 
-- 
2.25.1

