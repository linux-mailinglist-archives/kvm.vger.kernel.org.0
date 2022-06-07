Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C68A541358
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 21:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357629AbiFGT7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 15:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354513AbiFGT5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 15:57:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 28E91C1ED3
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 11:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654626229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oeKZwEXEPcVasf7F1CNd9feC/iLhpeWLvWAJd8mL+VI=;
        b=a/2xGQolRghD3zMUdM0ChjDMEGEn2TFm6ueRJ3Oi9TjatIeYpsJzn+k0oRtfvMZ7lgPOCs
        Fac4VYRUQoK1LXqFq/DXrohP2LP2ZceRVSbr6O2HB2RxB8E+v62eah2CYi4VdY9REedivE
        QA6uNm7gkdFyNMx773PHNL/HgFv2V3E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-IkCwT4feODGCFPyAwVOBVQ-1; Tue, 07 Jun 2022 14:23:48 -0400
X-MC-Unique: IkCwT4feODGCFPyAwVOBVQ-1
Received: by mail-wr1-f72.google.com with SMTP id bv8-20020a0560001f0800b002183c5d5c26so2064589wrb.20
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 11:23:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oeKZwEXEPcVasf7F1CNd9feC/iLhpeWLvWAJd8mL+VI=;
        b=5U24UEp5xPL5LHEakO4ojD2jmekCGGBbe4zwhug0Ty/jfNzz0T9NuvIvKM4fRFX6n6
         JSIvhnYFLyHvHrgGMPsKTKlLgHEcKQ2LDV06FgidEhXeR8YypvKrFiDgDUxcXuCUwGM9
         9xpCCngTMnMmBXH2Uoz5zthZ2XtL7i4KMBn/0ycgkord3qKzzO+vq2PCcmOiDbSOqrfD
         aZtZHKqCZobXyjWRwnaOUU2Lpn7fA0t1+SXxmlWsp/kMIIJCbMGsi9J9978uZejMAb1J
         8fTbU+WdiEh+pGYgKqaL2BPrFxHAR6ly4CP3hJUYnQAlaWada5Mq0ONqF410Ho5rznc+
         Kbxw==
X-Gm-Message-State: AOAM530qSCNxAg1SKIzMQ/22rgIT2SehiKf2/F8V33+k0J32mCXj168t
        o3EOUq/T2Y0VOjClSYU79/g3e0V5jgiwRKrYe1/2I1fBbwPtZH5pKnygqJQdJ3mo7EDKKpmS67b
        OXW4NJExmCFFr
X-Received: by 2002:a5d:4526:0:b0:210:bac2:ba63 with SMTP id j6-20020a5d4526000000b00210bac2ba63mr30068063wra.677.1654626227375;
        Tue, 07 Jun 2022 11:23:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3NykQdMwif9epScM2xkEJ+WQL2CXLMZHRuVgUZST1zsqWvA2TpoYWLilwG1xnetgJI+uYXQ==
X-Received: by 2002:a5d:4526:0:b0:210:bac2:ba63 with SMTP id j6-20020a5d4526000000b00210bac2ba63mr30068041wra.677.1654626227134;
        Tue, 07 Jun 2022 11:23:47 -0700 (PDT)
Received: from minerva.home (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id m8-20020a05600c4f4800b003942a244f51sm28267502wmq.42.2022.06.07.11.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 11:23:46 -0700 (PDT)
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
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH v6 2/5] firmware: sysfb: Add sysfb_disable() helper function
Date:   Tue,  7 Jun 2022 20:23:35 +0200
Message-Id: <20220607182338.344270-3-javierm@redhat.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607182338.344270-1-javierm@redhat.com>
References: <20220607182338.344270-1-javierm@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This can be used by subsystems to unregister a platform device registered
by sysfb and also to disable future platform device registration in sysfb.

Suggested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---

Changes in v6:
- Drop sysfb_try_unregister() helper since is no longer needed.

Changes in v4:
- Make sysfb_disable() to also attempt to unregister a device.

Changes in v2:
- Add kernel-doc comments and include in other_interfaces.rst (Daniel Vetter).

 .../driver-api/firmware/other_interfaces.rst  |  6 +++
 drivers/firmware/sysfb.c                      | 54 ++++++++++++++++---
 include/linux/sysfb.h                         | 13 +++++
 3 files changed, 67 insertions(+), 6 deletions(-)

diff --git a/Documentation/driver-api/firmware/other_interfaces.rst b/Documentation/driver-api/firmware/other_interfaces.rst
index b81794e0cfbb..06ac89adaafb 100644
--- a/Documentation/driver-api/firmware/other_interfaces.rst
+++ b/Documentation/driver-api/firmware/other_interfaces.rst
@@ -13,6 +13,12 @@ EDD Interfaces
 .. kernel-doc:: drivers/firmware/edd.c
    :internal:
 
+Generic System Framebuffers Interface
+-------------------------------------
+
+.. kernel-doc:: drivers/firmware/sysfb.c
+   :export:
+
 Intel Stratix10 SoC Service Layer
 ---------------------------------
 Some features of the Intel Stratix10 SoC require a level of privilege
diff --git a/drivers/firmware/sysfb.c b/drivers/firmware/sysfb.c
index b032f40a92de..1f276f108cc9 100644
--- a/drivers/firmware/sysfb.c
+++ b/drivers/firmware/sysfb.c
@@ -34,21 +34,59 @@
 #include <linux/screen_info.h>
 #include <linux/sysfb.h>
 
+static struct platform_device *pd;
+static DEFINE_MUTEX(disable_lock);
+static bool disabled;
+
+static bool sysfb_unregister(void)
+{
+	if (IS_ERR_OR_NULL(pd))
+		return false;
+
+	platform_device_unregister(pd);
+	pd = NULL;
+
+	return true;
+}
+
+/**
+ * sysfb_disable() - disable the Generic System Framebuffers support
+ *
+ * This disables the registration of system framebuffer devices that match the
+ * generic drivers that make use of the system framebuffer set up by firmware.
+ *
+ * It also unregisters a device if this was already registered by sysfb_init().
+ *
+ * Context: The function can sleep. A @disable_lock mutex is acquired to serialize
+ *          against sysfb_init(), that registers a system framebuffer device.
+ */
+void sysfb_disable(void)
+{
+	mutex_lock(&disable_lock);
+	sysfb_unregister();
+	disabled = true;
+	mutex_unlock(&disable_lock);
+}
+EXPORT_SYMBOL_GPL(sysfb_disable);
+
 static __init int sysfb_init(void)
 {
 	struct screen_info *si = &screen_info;
 	struct simplefb_platform_data mode;
-	struct platform_device *pd;
 	const char *name;
 	bool compatible;
-	int ret;
+	int ret = 0;
+
+	mutex_lock(&disable_lock);
+	if (disabled)
+		goto unlock_mutex;
 
 	/* try to create a simple-framebuffer device */
 	compatible = sysfb_parse_mode(si, &mode);
 	if (compatible) {
 		pd = sysfb_create_simplefb(si, &mode);
 		if (!IS_ERR(pd))
-			return 0;
+			goto unlock_mutex;
 	}
 
 	/* if the FB is incompatible, create a legacy framebuffer device */
@@ -60,8 +98,10 @@ static __init int sysfb_init(void)
 		name = "platform-framebuffer";
 
 	pd = platform_device_alloc(name, 0);
-	if (!pd)
-		return -ENOMEM;
+	if (!pd) {
+		ret = -ENOMEM;
+		goto unlock_mutex;
+	}
 
 	sysfb_apply_efi_quirks(pd);
 
@@ -73,9 +113,11 @@ static __init int sysfb_init(void)
 	if (ret)
 		goto err;
 
-	return 0;
+	goto unlock_mutex;
 err:
 	platform_device_put(pd);
+unlock_mutex:
+	mutex_unlock(&disable_lock);
 	return ret;
 }
 
diff --git a/include/linux/sysfb.h b/include/linux/sysfb.h
index 708152e9037b..e9baee4ae361 100644
--- a/include/linux/sysfb.h
+++ b/include/linux/sysfb.h
@@ -55,6 +55,19 @@ struct efifb_dmi_info {
 	int flags;
 };
 
+#ifdef CONFIG_SYSFB
+
+void sysfb_disable(void);
+
+#else /* CONFIG_SYSFB */
+
+static inline void sysfb_disable(void)
+{
+
+}
+
+#endif /* CONFIG_SYSFB */
+
 #ifdef CONFIG_EFI
 
 extern struct efifb_dmi_info efifb_dmi_list[];
-- 
2.36.1

