Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F302640B0A
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 17:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbiLBQrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 11:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbiLBQrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 11:47:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D4DC773B
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 08:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669999579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=bDZB9/UWBP2K8rOod3EiStKnFBOCd1JU4UtUL2I7L4s=;
        b=H1HkDoG1DwVSvFJcZn4lDolHlVIE6nXf7vvpPeXuRZ7nItKhc7Ew2OTStXW14hu7oGIjHt
        hHVKjWX6oiJ+w/W9rvOPsWP015AdcPACwxPbGSdEJGSnBGUq4/M4zcX7UYvCcBYudCgGMG
        TryAsOiQzK4K7Xnuaazd1KuJXKW0yuw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-Qi2ujFK3NKW2JVwfSMsgOw-1; Fri, 02 Dec 2022 11:46:18 -0500
X-MC-Unique: Qi2ujFK3NKW2JVwfSMsgOw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 216C41C06EE6;
        Fri,  2 Dec 2022 16:46:18 +0000 (UTC)
Received: from [172.30.42.193] (unknown [10.22.33.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63EDD1410DDA;
        Fri,  2 Dec 2022 16:46:17 +0000 (UTC)
Subject: [PATCH] vfio/ap/ccw/samples: Fix device_register() unwind path
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     ruanjinjie <ruanjinjie@huawei.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Farman <farman@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 02 Dec 2022 09:46:15 -0700
Message-ID: <166999942139.645727.12439756512449846442.stgit@omen>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We always need to call put_device() if device_register() fails.
All vfio drivers calling device_register() include a similar unwind
stack via gotos, therefore split device_unregister() into its
device_del() and put_device() components in the unwind path, and
add a goto target to handle only the put_device() requirement.

Reported-by: Ruan Jinjie <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/all/20221118032827.3725190-1-ruanjinjie@huawei.com
Fixes: d61fc96f47fd ("sample: vfio mdev display - host device")
Fixes: 9d1a546c53b4 ("docs: Sample driver to demonstrate how to use Mediated device framework.")
Fixes: a5e6e6505f38 ("sample: vfio bochs vbe display (host device for bochs-drm)")
Fixes: 9e6f07cd1eaa ("vfio/ccw: create a parent struct")
Fixes: 36360658eb5a ("s390: vfio_ap: link the vfio_ap devices to the vfio_ap bus subsystem")
Cc: Tony Krowiak <akrowiak@linux.ibm.com>
Cc: Halil Pasic <pasic@linux.ibm.com>
Cc: Jason Herne <jjherne@linux.ibm.com>
Cc: Kirti Wankhede <kwankhede@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

I didn't intend to usurp Ruan's patch, but since the inline version is
collecting reviews, formally post it and include additional fixes tags
for vfio-ccw and vfio-ap.

 drivers/s390/cio/vfio_ccw_drv.c   |    3 ++-
 drivers/s390/crypto/vfio_ap_drv.c |    2 +-
 samples/vfio-mdev/mbochs.c        |    7 ++++---
 samples/vfio-mdev/mdpy.c          |    7 ++++---
 samples/vfio-mdev/mtty.c          |    7 ++++---
 5 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index c2a65808605a..54aba7cceb33 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -199,8 +199,9 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 	return 0;
 
 out_unreg:
-	device_unregister(&parent->dev);
+	device_del(&parent->dev);
 out_free:
+	put_device(&parent->dev);
 	dev_set_drvdata(&sch->dev, NULL);
 	return ret;
 }
diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index f43cfeabd2cc..997b524bdd2b 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -122,7 +122,7 @@ static int vfio_ap_matrix_dev_create(void)
 	return 0;
 
 matrix_drv_err:
-	device_unregister(&matrix_dev->device);
+	device_del(&matrix_dev->device);
 matrix_reg_err:
 	put_device(&matrix_dev->device);
 matrix_alloc_err:
diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
index 8b5a3a778a25..e54eb752e1ba 100644
--- a/samples/vfio-mdev/mbochs.c
+++ b/samples/vfio-mdev/mbochs.c
@@ -1430,7 +1430,7 @@ static int __init mbochs_dev_init(void)
 
 	ret = device_register(&mbochs_dev);
 	if (ret)
-		goto err_class;
+		goto err_put;
 
 	ret = mdev_register_parent(&mbochs_parent, &mbochs_dev, &mbochs_driver,
 				   mbochs_mdev_types,
@@ -1441,8 +1441,9 @@ static int __init mbochs_dev_init(void)
 	return 0;
 
 err_device:
-	device_unregister(&mbochs_dev);
-err_class:
+	device_del(&mbochs_dev);
+err_put:
+	put_device(&mbochs_dev);
 	class_destroy(mbochs_class);
 err_driver:
 	mdev_unregister_driver(&mbochs_driver);
diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index 721fb06c6413..e8400fdab71d 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -717,7 +717,7 @@ static int __init mdpy_dev_init(void)
 
 	ret = device_register(&mdpy_dev);
 	if (ret)
-		goto err_class;
+		goto err_put;
 
 	ret = mdev_register_parent(&mdpy_parent, &mdpy_dev, &mdpy_driver,
 				   mdpy_mdev_types,
@@ -728,8 +728,9 @@ static int __init mdpy_dev_init(void)
 	return 0;
 
 err_device:
-	device_unregister(&mdpy_dev);
-err_class:
+	device_del(&mdpy_dev);
+err_put:
+	put_device(&mdpy_dev);
 	class_destroy(mdpy_class);
 err_driver:
 	mdev_unregister_driver(&mdpy_driver);
diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 3c2a421b9b69..e887de672c52 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -1330,7 +1330,7 @@ static int __init mtty_dev_init(void)
 
 	ret = device_register(&mtty_dev.dev);
 	if (ret)
-		goto err_class;
+		goto err_put;
 
 	ret = mdev_register_parent(&mtty_dev.parent, &mtty_dev.dev,
 				   &mtty_driver, mtty_mdev_types,
@@ -1340,8 +1340,9 @@ static int __init mtty_dev_init(void)
 	return 0;
 
 err_device:
-	device_unregister(&mtty_dev.dev);
-err_class:
+	device_del(&mtty_dev.dev);
+err_put:
+	put_device(&mtty_dev.dev);
 	class_destroy(mtty_dev.vd_class);
 err_driver:
 	mdev_unregister_driver(&mtty_driver);


