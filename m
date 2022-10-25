Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2291360D4EE
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 21:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbiJYTtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 15:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbiJYTtm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 15:49:42 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2ECB37
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 12:49:27 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 3-20020a17090a0f8300b00212d5cd4e5eso11885290pjz.4
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 12:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kzHE8qUOrnZbVgEao5KIQPfh0k9CuMJWkxVcD7LoNGc=;
        b=hHQfIe3/SDtiYhvtIQ3aVNU2AyMfAc17qTeql39uE4U0aM+gZYtABeLk3rbVyRo9MI
         gCGPw4ytWQGqRv/qoJ13S2ztvJIke0akthrQQn45FR+qyAzz2cVoaTjpuOxS+qpcLo/Y
         dPRmGcZWaVodnhL3L/a8JT47nmUVFNVFXgUkv8q+Ek+VE0Mz055s9Eoj/wZPt3eviquR
         aV1xA39tdq+lU8zU3Bt3ftE/aDqhBHftBLq8fKzDNCxZEN4DB9JRfBPGA4FH5a+5hEzG
         VI+l/BEuumCRvq3+Ksrd/aIF0+rrV2cyJcPBdYNi+Ut2xmwZHicbNXJha2c0LnJA+gea
         Xumg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kzHE8qUOrnZbVgEao5KIQPfh0k9CuMJWkxVcD7LoNGc=;
        b=3O2JbLqUFji4LAmclj89eX/IfBP5q/SnKm+uCKNKJMmJ9S5vV3HJ0swymlomDDUXi/
         Vfl2W2tJRXYLfcVilvbjR5aqBymPBsdkQROI9mvKiTDIMxN7AvtYW0hDpZB99ZhTSvPZ
         2b1BeCliRaC3pvdr5X0SaCmJkglfIqXy/+evWSvDmgLc5kHuZRDAe4JkjXjqe07DTncL
         MmoT5EL7GZyFRU7ScNNPhDl0DPSXnoe1KC+geTOpDHf/c0YlE5i799nvP59dFQ5OnCes
         hT2bFrUF+fEPgK2Qk3abl/nnO87IqyyOEU0Xme3qSYXTj8d1c9Ebo9LvbbNP3/4xbMPi
         XIJQ==
X-Gm-Message-State: ACrzQf2Gi6XYLjBc8oCQpR6MNzkEi3cN2A/8r0Es5o3sY3iVcHbejkaI
        +GdQdyqGWcrHbWVk3iTTIwwDE0UxT0PcKg==
X-Google-Smtp-Source: AMsMyM7iQbRWHRfUinZ+Y7e0irNlNlDQEMTNgYDxBvMs0VthU8o46mR80uTvdBw9amaaWMHwXu+9Zw==
X-Received: by 2002:a17:903:246:b0:179:96b5:1ad2 with SMTP id j6-20020a170903024600b0017996b51ad2mr39685546plh.37.1666727366272;
        Tue, 25 Oct 2022 12:49:26 -0700 (PDT)
Received: from crazyhorse.local ([174.127.229.57])
        by smtp.googlemail.com with ESMTPSA id v6-20020a17090a00c600b001ef8ab65052sm1715961pjd.11.2022.10.25.12.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 12:49:25 -0700 (PDT)
From:   Anthony DeRossi <ajderossi@gmail.com>
To:     kvm@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, jgg@ziepe.ca,
        yishaih@nvidia.com, kevin.tian@intel.com
Subject: [PATCH] vfio: Decrement open_count before close_device()
Date:   Tue, 25 Oct 2022 12:38:20 -0700
Message-Id: <20221025193820.4412-1-ajderossi@gmail.com>
X-Mailer: git-send-email 2.37.4
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

The implementation of close_device() for vfio-pci inspects the
open_count of every device in the device set to determine whether a
reset is needed. Unless open_count is decremented before invoking
close_device(), the device set will always contain a device with
open_count > 0, effectively disabling the reset logic.

After commit 2cd8b14aaa66 ("vfio/pci: Move to the device set
infrastructure"), failure to create a new file for a device would cause
the reset to be skipped when closing the device in the error path.

After commit eadd86f835c6 ("vfio: Remove calls to
vfio_group_add_container_user()"), releasing a device would always skip
the reset.

Failing to reset the device leaves it in an unknown state, potentially
causing errors when it is bound to a different driver.

This issue was observed with a Radeon RX Vega 56 [1002:687f] (rev c3)
assigned to a Windows guest. After shutting down the guest, unbinding
the device from vfio-pci, and binding the device to amdgpu:

[  548.007102] [drm:psp_hw_start [amdgpu]] *ERROR* PSP create ring failed!
[  548.027174] [drm:psp_hw_init [amdgpu]] *ERROR* PSP firmware loading failed
[  548.027242] [drm:amdgpu_device_fw_loading [amdgpu]] *ERROR* hw_init of IP block <psp> failed -22
[  548.027306] amdgpu 0000:0a:00.0: amdgpu: amdgpu_device_ip_init failed
[  548.027308] amdgpu 0000:0a:00.0: amdgpu: Fatal error during GPU init

Fixes: 2cd8b14aaa66 ("vfio/pci: Move to the device set infrastructure")
Fixes: eadd86f835c6 ("vfio: Remove calls to vfio_group_add_container_user()")
Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>
---
 drivers/vfio/vfio_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 2d168793d4e1..7c3f1734fb35 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -763,8 +763,10 @@ static struct file *vfio_device_open(struct vfio_device *device)
 
 		if (device->ops->open_device) {
 			ret = device->ops->open_device(device);
-			if (ret)
-				goto err_undo_count;
+			if (ret) {
+				device->open_count--;
+				goto err_unlock;
+			}
 		}
 		vfio_device_container_register(device);
 		mutex_unlock(&device->group->group_lock);
@@ -801,14 +803,13 @@ static struct file *vfio_device_open(struct vfio_device *device)
 err_close_device:
 	mutex_lock(&device->dev_set->lock);
 	mutex_lock(&device->group->group_lock);
-	if (device->open_count == 1 && device->ops->close_device) {
+	if (!--device->open_count && device->ops->close_device) {
 		device->ops->close_device(device);
 
 		vfio_device_container_unregister(device);
 	}
-err_undo_count:
+err_unlock:
 	mutex_unlock(&device->group->group_lock);
-	device->open_count--;
 	if (device->open_count == 0 && device->kvm)
 		device->kvm = NULL;
 	mutex_unlock(&device->dev_set->lock);
@@ -1017,12 +1018,11 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	mutex_lock(&device->dev_set->lock);
 	vfio_assert_device_open(device);
 	mutex_lock(&device->group->group_lock);
-	if (device->open_count == 1 && device->ops->close_device)
+	if (!--device->open_count && device->ops->close_device)
 		device->ops->close_device(device);
 
 	vfio_device_container_unregister(device);
 	mutex_unlock(&device->group->group_lock);
-	device->open_count--;
 	if (device->open_count == 0)
 		device->kvm = NULL;
 	mutex_unlock(&device->dev_set->lock);
-- 
2.37.4

