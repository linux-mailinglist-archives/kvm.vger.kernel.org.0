Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 285E161DF2C
	for <lists+kvm@lfdr.de>; Sat,  5 Nov 2022 23:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiKEWtl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Nov 2022 18:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiKEWtk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Nov 2022 18:49:40 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD380EE21
        for <kvm@vger.kernel.org>; Sat,  5 Nov 2022 15:49:39 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y4so7999243plb.2
        for <kvm@vger.kernel.org>; Sat, 05 Nov 2022 15:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e5SjKpl5wQpBKJaujaO+g62YnASncJMmHCTnqeXvOsQ=;
        b=VFH6RS+O3lhv0kawwFy4GqXV8uGlb/yNBb1JaE+x8ghjRBzS1ugbBZm3CTqzAic4h2
         uCjk2OWTFHAITNd2ZHoFR/zIzjybtgkEe/OEuOZfMKe0QzWuWQPUWCRCj6CiycnBCn2G
         k/tXvI23ZIMZ29XRRYS9gGcFuLdyYwxoQQEUwb1q8n5m7Ix6XNxn0NAHBUcgUhdL7oR5
         /0EApsDhsgf7C245qF0QFYJCNQkUx1tZ8tXRHvEUxoOrIwU8PQ6tzNm9jDYhri8V56Yx
         B0dz/gFBNP8n8ti6H74/flnh8Es3qnuZMKU5WzGULsGZMnQ5bj7t9AQJ8PqZ4BcZZoje
         Np8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e5SjKpl5wQpBKJaujaO+g62YnASncJMmHCTnqeXvOsQ=;
        b=LIu/y1qDhXVG5DyupUl1C1bYWUuG16flqsFUD9OS5dc7SVqMdnAIM1BADPbdBhlrWs
         oiHx8xJVmhGVDMIa7xiyuaOkHnM3XnAgQ0BCv6PnMW6lBh+2UFZb8jZr1CiSmz7tsmOW
         RuVEhDrWWHmgLW6e3555qs6xkL/SUCW7BTt6j2IYMe75KP1AkUPFLKEPZNTxmeM4hhSS
         By0azsnuiFVRMABESdIqCWFh06ts2mroYvDoxhgc0n4tKoYiF6Q+9AU938jcmDRYK+TX
         xSh6+eYZUY0awWQuuf/ivXfddrs5ONkRNrTETNsZL9OjN6OQj5UPCF/z0q9UEjitf4V8
         qp+g==
X-Gm-Message-State: ACrzQf1u75hAulUsIwkUt0eGpp6rMdnSuRLHkyp0kQGWn/BS3CtGeQpQ
        gqumckfVjAgAw0JzmTjNsmgPuFBzAOpwsQ==
X-Google-Smtp-Source: AMsMyM6bB2lywVy13ko/5gWhZIRg+2nHiO19flXRewLtimzUgdyDe/aw/3YB1qU9thY0Nqfo9mzTqw==
X-Received: by 2002:a17:90b:4c8a:b0:214:2ed8:6501 with SMTP id my10-20020a17090b4c8a00b002142ed86501mr21276436pjb.70.1667688579014;
        Sat, 05 Nov 2022 15:49:39 -0700 (PDT)
Received: from crazyhorse.local ([174.127.229.57])
        by smtp.googlemail.com with ESMTPSA id rj14-20020a17090b3e8e00b001fde655225fsm14716728pjb.2.2022.11.05.15.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Nov 2022 15:49:38 -0700 (PDT)
From:   Anthony DeRossi <ajderossi@gmail.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, jgg@ziepe.ca,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Subject: [PATCH v5 1/3] vfio: Fix container device registration life cycle
Date:   Sat,  5 Nov 2022 15:44:56 -0700
Message-Id: <20221105224458.8180-2-ajderossi@gmail.com>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221105224458.8180-1-ajderossi@gmail.com>
References: <20221105224458.8180-1-ajderossi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In vfio_device_open(), vfio_container_device_register() is always called
when open_count == 1. On error, vfio_device_container_unregister() is
only called when open_count == 1 and close_device is set. This leaks a
registration for devices without a close_device implementation.

In vfio_device_fops_release(), vfio_device_container_unregister() is
called unconditionally. This can cause a device to be unregistered
multiple times.

Treating container device registration/unregistration uniformly (always
when open_count == 1) fixes both issues.

Fixes: ce4b4657ff18 ("vfio: Replace the DMA unmapping notifier with a callback")
Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>
---
 drivers/vfio/vfio_main.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 2d168793d4e1..9a4af880e941 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -801,8 +801,9 @@ static struct file *vfio_device_open(struct vfio_device *device)
 err_close_device:
 	mutex_lock(&device->dev_set->lock);
 	mutex_lock(&device->group->group_lock);
-	if (device->open_count == 1 && device->ops->close_device) {
-		device->ops->close_device(device);
+	if (device->open_count == 1) {
+		if (device->ops->close_device)
+			device->ops->close_device(device);
 
 		vfio_device_container_unregister(device);
 	}
@@ -1017,10 +1018,12 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	mutex_lock(&device->dev_set->lock);
 	vfio_assert_device_open(device);
 	mutex_lock(&device->group->group_lock);
-	if (device->open_count == 1 && device->ops->close_device)
-		device->ops->close_device(device);
+	if (device->open_count == 1) {
+		if (device->ops->close_device)
+			device->ops->close_device(device);
 
-	vfio_device_container_unregister(device);
+		vfio_device_container_unregister(device);
+	}
 	mutex_unlock(&device->group->group_lock);
 	device->open_count--;
 	if (device->open_count == 0)
-- 
2.37.4

