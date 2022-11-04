Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F55361A1D3
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 21:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiKDUC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 16:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiKDUC2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 16:02:28 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936714E432
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 13:01:41 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 130so5402861pfu.8
        for <kvm@vger.kernel.org>; Fri, 04 Nov 2022 13:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e5SjKpl5wQpBKJaujaO+g62YnASncJMmHCTnqeXvOsQ=;
        b=G/2wdby9XEOdzpBgg5EDh+iPs5wZ5HXoJv2WWfzydjtLTKSHnZM762oIKwPbtwN//E
         /C3tND2qrcxcMOn4I22EXHmx1VCdwmR3W3vy0l0rYcxseP6VvKE0ZVEsQ46A81VRLlVK
         qZBtAghw5K57jdIAtKuhdZYzbnD686BHRopAs4ou70vFfRW9shoIRyhs8Obt2uAwbQJP
         6I/AkzEVziRxi12JvOmhnpP4akRJczRyJ7oTAwlxC3ewewoQBhkfVvt10tXUNnEDvPmg
         qE65p8s5QveEz4LQX1to5Ba6b1k1ktvBMVez0G/v2cjUHsqVyTSWHYBjcnDps7tQ/idC
         9t9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e5SjKpl5wQpBKJaujaO+g62YnASncJMmHCTnqeXvOsQ=;
        b=VdrJ8G3rW+h8BZCPcS/U7CFiQlaIXqqd9qSaJ4Sh8PNSOUnw6T4u9esyH9jMLCnb7V
         r4P/yWDsWBGmbfKMQCvcAx6zPrXSwpCsh+LK2+AHBLdTtPI4IrQDZSGqU73Gf47NBrpr
         GmayjYXs3scZoXpea1YWIQBW4lEQ24rpJvet1ddzRE4jx16lXgqXHh37zrg2gGS+FbXj
         n4DIi4inKH8J47pK1aR6grUNG0Jq4WJhtz40xA8R7Mz+C5KX2Udg/Zx3zATvDf5v6ZNB
         yEEAkmuFRkD8/OpCCejCrIepzbufdn59MWWqevuZTVwCwEuRyJ4Vd9/gtjq/ETu6PjzZ
         IOoA==
X-Gm-Message-State: ACrzQf1yU5Udrhszwrk4U54m/2rvAjPIMWdopQJOrbLRjlpB+upL+XWE
        g92qAdR+e+bOCaoRw+dwYQqg8m0g16EIwg==
X-Google-Smtp-Source: AMsMyM7pb9CmSFsMnnMrwDUvg5VMpuKhP6ltHNmb7Zm8m+q139VycgLcuCmeNeFsWv0c8xKKoSoihQ==
X-Received: by 2002:a63:5a63:0:b0:42f:e143:80d4 with SMTP id k35-20020a635a63000000b0042fe14380d4mr32485104pgm.456.1667592100697;
        Fri, 04 Nov 2022 13:01:40 -0700 (PDT)
Received: from crazyhorse.local ([174.127.229.57])
        by smtp.googlemail.com with ESMTPSA id q23-20020a63cc57000000b0046f6d7dcd1dsm122545pgi.25.2022.11.04.13.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 13:01:40 -0700 (PDT)
From:   Anthony DeRossi <ajderossi@gmail.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, jgg@ziepe.ca,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Subject: [PATCH v4 1/3] vfio: Fix container device registration life cycle
Date:   Fri,  4 Nov 2022 12:57:25 -0700
Message-Id: <20221104195727.4629-2-ajderossi@gmail.com>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221104195727.4629-1-ajderossi@gmail.com>
References: <20221104195727.4629-1-ajderossi@gmail.com>
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

