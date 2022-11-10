Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8508623903
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 02:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbiKJBk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 20:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiKJBk4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 20:40:56 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600B0275DD
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 17:40:55 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id k5so448407pjo.5
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 17:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=84cwfiBGbrsdwBAij7CyOZvNXUFWqLFNrDP4kbpFKkE=;
        b=qCXI+4uxaI0QXY+ysm5ECir9vYQngH6y6YoQHruOb+5+o8YvyWOQ6YJ+ZA1YHWX6HQ
         XJiYlfILz3Vd0/vbsoNtpprUe7l9PUbgp1TWJQs7KBvruFIgbzQ3oWCr79vBQpFr5+4/
         1InntebPsbLaiQhrAM8nggu+EFyZ+dK0tMvGlzLK4JmNG5l+YHbRTBHJkilalx6LLRHb
         GZE/P9lFyzeLRVQD/QttSArRNvMhagFdj3+FPodgORvlqV8j5EnVQiuyDRGKjFa5ydYP
         Aeb0vw5QmsS9HvisNm0L4VEx+bU0eCI2YmPUoPVH0ZeQqnEpQ3+BKUdrbRh0gxMWW1GS
         27jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=84cwfiBGbrsdwBAij7CyOZvNXUFWqLFNrDP4kbpFKkE=;
        b=VWruH9nUpwV7BfxZnmqqfnId34tmEA1lV2cb/0bAaHZ4mELyJdItutcc0/48aMEhRS
         SxD3qGM9yqgWzAOxngC0DWpMufIC73Ic8pXazpCZfIeJHAMaBkebe5PrP9sj8oS5Do/7
         hOFjfUjFjZmfQprMXfuZvQLgxgeUbaW+rObZ4ddwKHDO0WGHQpm4hNA1X2H9f0sl9Pfd
         qS6DBnQWdm1kHSHHlpDfBH2Q7y7ClPMB3/tLOu1tOCnFtU6zl1vSYq69V9yx6NJJSZJ/
         033KUeoKSHqiBQyvYAH1CbMd8sOcRXvIZo/CAL93GHDHaFBoPapiPISwK0WAyQnOf4cQ
         NISw==
X-Gm-Message-State: ACrzQf3OjAlnhY8bCYGkPXOnJ+2jralmduDr7O+ty8ALp2A7m7V2YeVZ
        koc2D/1bqymgt8g3YlLbLHME0Qg5UTs6Sg==
X-Google-Smtp-Source: AMsMyM60CL1UDHRLUQ2TodZYTLE5/UEcWzfehasbPeR99B/866gAJ6+DKGZmHMPl9I6zc+Vyyh/e6g==
X-Received: by 2002:a17:902:ef85:b0:187:85d:bd2e with SMTP id iz5-20020a170902ef8500b00187085dbd2emr60381202plb.31.1668044454704;
        Wed, 09 Nov 2022 17:40:54 -0800 (PST)
Received: from crazyhorse.local ([174.127.229.57])
        by smtp.googlemail.com with ESMTPSA id pj4-20020a17090b4f4400b00212cf2fe8c3sm3091836pjb.1.2022.11.09.17.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 17:40:54 -0800 (PST)
From:   Anthony DeRossi <ajderossi@gmail.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, jgg@nvidia.com,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Subject: [PATCH v6 1/3] vfio: Fix container device registration life cycle
Date:   Wed,  9 Nov 2022 17:40:25 -0800
Message-Id: <20221110014027.28780-2-ajderossi@gmail.com>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221110014027.28780-1-ajderossi@gmail.com>
References: <20221110014027.28780-1-ajderossi@gmail.com>
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

In vfio_device_open(), vfio_device_container_register() is always called
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
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
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

