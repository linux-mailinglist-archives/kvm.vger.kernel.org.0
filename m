Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F11661A1D4
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 21:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiKDUDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 16:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiKDUCg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 16:02:36 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48F650F06
        for <kvm@vger.kernel.org>; Fri,  4 Nov 2022 13:01:48 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id b185so5402854pfb.9
        for <kvm@vger.kernel.org>; Fri, 04 Nov 2022 13:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lL1U+nSAOKGAWh3pKMUaEtjhsNJnzcDwQbCqQSSfvwA=;
        b=PiBpvMYwmV8P8Zgt9o13BTOVxy5NGSgCssKtEu0l9EItx60jcrjboAxqz0nzvKly1O
         Vk2osvdOYIIH3D1zkQ267NUKfsN3WpwEtVhO7LsoOMdWAYe8c6NvelJhzGITEZjuMxEA
         8xaD2n3ybfIOwUV5T3Veknoam5EBaLLm7C4cQ8CkRLyzwUqAxm+UkZwuWrrjyPvNmszy
         N3+mm0h7js21kBsD9kKZ7fZnqRo7b2Wo1mTcfcqFvVnCCPEc49RWwDZyznbsOwMA3UAG
         qk3Q4ODa8lPk7poBC17LU16Z1Fs+gerCUAQuF1UFs57P1p9om2lmMgNM3Pb9pyZ3MeXN
         dr7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lL1U+nSAOKGAWh3pKMUaEtjhsNJnzcDwQbCqQSSfvwA=;
        b=xnDua78e7bYNVCgulXj7LeapuCwYDy1U/LkhnaVypFdPGnOJfaq8AibhV1SIfFnmg0
         faQtk23E1U6oCwb3PucZzJolo8XO7tGQBIo+MWrRajixwZFPfStn9xHoijqeDqga+1r6
         tWfqqr3sfQhvMAEyows9NNu2dKysPIYmekuVpTesH2oQZoUjdfDg4HCw+YZYJayA2W9M
         pYivArmsyyEiHTblplfBxTk9nwFRRpxk5ni5aBEw2tSqoEmq77TKIHc0IOZSbrpcHvTM
         CJFgw6hiod4FVujjK/FJDVm3gguPK/MawsN1ZrFGPPVVvo8ia/aQTOvauYeLsUC5TNJy
         59/g==
X-Gm-Message-State: ACrzQf2mYh+dkWBMMJIZFyeIX6aXt2OlwVlq/EcWybJkg8i5pMX071xx
        RPJHiGUIUK3ouP2ybo1EGmijBMe8766+eQ==
X-Google-Smtp-Source: AMsMyM5S7nUujFSB1BxUltmovyDz1SV4zC1L6VvtHOcjvj54fCuLoprNGQHWMKEr0nWskL9ivV7jDg==
X-Received: by 2002:a05:6a00:8ce:b0:56e:6961:c6b6 with SMTP id s14-20020a056a0008ce00b0056e6961c6b6mr7976225pfu.3.1667592107992;
        Fri, 04 Nov 2022 13:01:47 -0700 (PDT)
Received: from crazyhorse.local ([174.127.229.57])
        by smtp.googlemail.com with ESMTPSA id q23-20020a63cc57000000b0046f6d7dcd1dsm122545pgi.25.2022.11.04.13.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 13:01:47 -0700 (PDT)
From:   Anthony DeRossi <ajderossi@gmail.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, jgg@ziepe.ca,
        kevin.tian@intel.com, abhsahu@nvidia.com, yishaih@nvidia.com
Subject: [PATCH v4 2/3] vfio: Add an open counter to vfio_device_set
Date:   Fri,  4 Nov 2022 12:57:26 -0700
Message-Id: <20221104195727.4629-3-ajderossi@gmail.com>
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

open_count is incremented before open_device() and decremented after
close_device() for each device in the set. This allows devices to
determine whether shared resources are in use without tracking them
manually or accessing the private open_count in vfio_device.

Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>
---
 drivers/vfio/vfio_main.c | 3 +++
 include/linux/vfio.h     | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 9a4af880e941..6c65418fc7e3 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -761,6 +761,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
 		mutex_lock(&device->group->group_lock);
 		device->kvm = device->group->kvm;
 
+		device->dev_set->open_count++;
 		if (device->ops->open_device) {
 			ret = device->ops->open_device(device);
 			if (ret)
@@ -809,6 +810,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	}
 err_undo_count:
 	mutex_unlock(&device->group->group_lock);
+	device->dev_set->open_count--;
 	device->open_count--;
 	if (device->open_count == 0 && device->kvm)
 		device->kvm = NULL;
@@ -1023,6 +1025,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 			device->ops->close_device(device);
 
 		vfio_device_container_unregister(device);
+		device->dev_set->open_count--;
 	}
 	mutex_unlock(&device->group->group_lock);
 	device->open_count--;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e7cebeb875dd..5becdcdf4ba2 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -28,6 +28,7 @@ struct vfio_device_set {
 	struct mutex lock;
 	struct list_head device_list;
 	unsigned int device_count;
+	unsigned int open_count;
 };
 
 struct vfio_device {
-- 
2.37.4

