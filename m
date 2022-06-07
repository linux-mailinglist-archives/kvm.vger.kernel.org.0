Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB6C541350
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 21:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356644AbiFGT71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 15:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357669AbiFGT6Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 15:58:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BBC181B5877
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 11:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654626231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UVERor1pDjv50JOPQD6dbA5hWF6IpXrW4mZT/xer28A=;
        b=StC4cluhx0W7Rllbrgc/pueXaApx6GQrB2WlIMVpuw8PQ5KGWRGmw++iJA19cskdMd8SuJ
        zVYdnSzhCBP7/VCRhTnT5+1JO6DZqKsao/VuTBHTA8y1qrFxNBGXUCfBMTV0VMhmUJHry8
        wPX2AyPy0rOlWA7W025iZ2w6claPzrs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-i7HuBmFYPZCa33UBMAUsJw-1; Tue, 07 Jun 2022 14:23:50 -0400
X-MC-Unique: i7HuBmFYPZCa33UBMAUsJw-1
Received: by mail-wm1-f71.google.com with SMTP id o2-20020a05600c510200b0039747b0216fso13121598wms.0
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 11:23:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UVERor1pDjv50JOPQD6dbA5hWF6IpXrW4mZT/xer28A=;
        b=JPDHdpfWkZKTnpmJOKDrYYJNfvTMSKE3yUuLngthLQIueCbaQSIwe+fKAr+xBkwfvI
         crSvsMSYGdi95BYMCPxeiuRjhNQJPvM8Oe3gY+zZ9oUs2HLmGEBw/5EWb4gv20n6qBPH
         hvU2/2/IxowvggWV4CbKuT82bQVIC0C48yTn82G01utBdJMm7WLI1y351fszzB6sGl8L
         O6wvFnJ5o2XuT1/KK4L92KQCyNQTgCh0xk/6Liz9FV5D/AlaKexvDMXGoEfe50ZFWA8f
         cArBv6ksmiHrGTDNJUEA5DjvHZUEtDRd1NS5nViZQNebiA9nOY5O3Xm2u8NEyZ//rFNc
         9q1A==
X-Gm-Message-State: AOAM532o/weYGPXAp8N9ffP8BHA9qgjF+0e1Q/YPJfieCN/qlM+TC7bd
        ovlPw79q8h/k20jW7ZFMgCrdkp/n1UGcHRqWYDAF+C51duqApCwsCx7NYrfeU7Zzt9HB6TeTZFI
        OJCiiqBiK6th+
X-Received: by 2002:a05:6000:1b03:b0:216:43b4:82f1 with SMTP id f3-20020a0560001b0300b0021643b482f1mr18992412wrz.232.1654626229027;
        Tue, 07 Jun 2022 11:23:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIJ2ZaSX69tcbwGyt9OTbAcEXndsJiDIZKc+WEe5sBYC0UmDo7XaAT1uT5eNOYdA7eP4tzzQ==
X-Received: by 2002:a05:6000:1b03:b0:216:43b4:82f1 with SMTP id f3-20020a0560001b0300b0021643b482f1mr18992391wrz.232.1654626228799;
        Tue, 07 Jun 2022 11:23:48 -0700 (PDT)
Received: from minerva.home (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id m8-20020a05600c4f4800b003942a244f51sm28267502wmq.42.2022.06.07.11.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 11:23:48 -0700 (PDT)
From:   Javier Martinez Canillas <javierm@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     dri-devel@lists.freedesktop.org,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Laszlo Ersek <lersek@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, kvm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>, Helge Deller <deller@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: [PATCH v6 3/5] fbdev: Disable sysfb device registration when removing conflicting FBs
Date:   Tue,  7 Jun 2022 20:23:36 +0200
Message-Id: <20220607182338.344270-4-javierm@redhat.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607182338.344270-1-javierm@redhat.com>
References: <20220607182338.344270-1-javierm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The platform devices registered by sysfb match with firmware-based DRM or
fbdev drivers, that are used to have early graphics using a framebuffer
provided by the system firmware.

DRM or fbdev drivers later are probed and remove all conflicting framebuffers,
leading to these platform devices for generic drivers to be unregistered.

But the current solution has a race, since the sysfb_init() function could
be called after a DRM or fbdev driver is probed and request to unregister
the devices for drivers with conflicting framebuffes.

To prevent this, disable any future sysfb platform device registration by
calling sysfb_disable(), if a driver requests to remove the conflicting
framebuffers.

Suggested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---

Changes in v6:
- Move the sysfb_disable() before the remove conflicting framebuffers
  loop (Daniel Vetter).

Changes in v5:
- Move the sysfb_disable() call at conflicting framebuffers again to
  avoid the need of a DRIVER_FIRMWARE capability flag.
- Add Daniel Vetter's Reviewed-by tag again since reverted to the old
  patch that he already reviewed in v2.

Changes in v3:
- Call sysfb_disable() when a DRM dev and a fbdev are registered rather
  than when conflicting framebuffers are removed (Thomas Zimmermann).
- Call sysfb_disable() when a fbdev framebuffer is registered rather
  than when conflicting framebuffers are removed (Thomas Zimmermann).
- Drop Daniel Vetter's Reviewed-by tag since patch changed a lot.

Changes in v2:
- Explain in the commit message that fbmem has to unregister the device
  as fallback if a driver registered the device itself (Daniel Vetter).
- Also explain that fallback in a comment in the code (Daniel Vetter).
- Don't encode in fbmem the assumption that sysfb will always register
  platform devices (Daniel Vetter).
- Add a FIXME comment about drivers registering devices (Daniel Vetter).

 drivers/video/fbdev/core/fbmem.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 2fda5917c212..e0720fef0ee6 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/major.h>
 #include <linux/slab.h>
+#include <linux/sysfb.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/vt.h>
@@ -1764,6 +1765,17 @@ int remove_conflicting_framebuffers(struct apertures_struct *a,
 		do_free = true;
 	}
 
+	/*
+	 * If a driver asked to unregister a platform device registered by
+	 * sysfb, then can be assumed that this is a driver for a display
+	 * that is set up by the system firmware and has a generic driver.
+	 *
+	 * Drivers for devices that don't have a generic driver will never
+	 * ask for this, so let's assume that a real driver for the display
+	 * was already probed and prevent sysfb to register devices later.
+	 */
+	sysfb_disable();
+
 	mutex_lock(&registration_lock);
 	do_remove_conflicting_framebuffers(a, name, primary);
 	mutex_unlock(&registration_lock);
-- 
2.36.1

