Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C898E6C3629
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 16:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbjCUPtA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 11:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbjCUPs7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 11:48:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBC94ECEE
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 08:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679413692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5fZfqjM11oy2Vtn/lVIZfuetr5wAdozVuLjydoFPWVI=;
        b=JYezWSuq2H3FLqpzknCDxl8AGwDieIecUcKkML0fqD6WCSLBIOEFcWgooZNljNO0prFmqg
        FNAV/gdMb0EceWMBqguefq1ajTWauqVKgODRPS6IdNXophozxovnuC1/qeKZromIfE5i7G
        60NA/wmu2BjzAl1jRh5PXYYdo1Tw0xw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367--SWbHcVRNPm79ONGabrK7Q-1; Tue, 21 Mar 2023 11:48:10 -0400
X-MC-Unique: -SWbHcVRNPm79ONGabrK7Q-1
Received: by mail-wr1-f72.google.com with SMTP id c3-20020adfa303000000b002d5737d3835so801055wrb.21
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 08:48:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679413689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5fZfqjM11oy2Vtn/lVIZfuetr5wAdozVuLjydoFPWVI=;
        b=M1Y6vAShHUj9WsNp/5nA67DwDZhoU9IFqveqA+UqLSuyjfUo2TfOTruruA9Eo1qMVe
         6b45ofHa/0nn0mjpkMBoGPjjCqNP9BJTV5W0p5ZkF70xT+HbUgLzI2MAXZtcvHhO+lJj
         T2uhOLN4sUzO7IQHK3B/PiDnjwhfoXwLvVyzk8H0bBIPjDXkFX9ekD8qa1ZRMaDZlL8I
         NNhvXQy4ZaL4rZVPLwfqS1fFlT2Gjq+BhnydkrvcHGVHtvdLgp/HNZ4yNwyLfbF+DF4B
         bA4rSTZYe5Twq69zedVatymN0Afv26pp6ze6vE/fYDIc43QSUIjRyBwmQXrFA72e4nO1
         Pa+g==
X-Gm-Message-State: AO0yUKU2uFkTs6Nh5W5vtfzPvSIUpWIbGoT9GW/p50cSgXk4DsPj+ndu
        X13ZJY6i6A4BnPea2HdUxqnwfoPbp2ub5iJBHmMTF0rWG1i+3gJYesOoUFYmtiYwMNpwNrhh1Gq
        mm1xXKnPDYvzj
X-Received: by 2002:adf:fe07:0:b0:2cf:e343:b8b0 with SMTP id n7-20020adffe07000000b002cfe343b8b0mr2517580wrr.56.1679413689583;
        Tue, 21 Mar 2023 08:48:09 -0700 (PDT)
X-Google-Smtp-Source: AK7set+H3aD54i1Y3Lohtokw09es5cXqYDux9QaK4NnzMmJA80+x6PfFzAJ0zMnpeblLwpDY1gLteA==
X-Received: by 2002:adf:fe07:0:b0:2cf:e343:b8b0 with SMTP id n7-20020adffe07000000b002cfe343b8b0mr2517561wrr.56.1679413689321;
        Tue, 21 Mar 2023 08:48:09 -0700 (PDT)
Received: from step1.redhat.com (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id z15-20020a5d44cf000000b002ce9f0e4a8fsm11692694wrr.84.2023.03.21.08.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 08:48:08 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        stefanha@redhat.com, linux-kernel@vger.kernel.org,
        eperezma@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        netdev@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v3 6/8] vdpa_sim: use kthread worker
Date:   Tue, 21 Mar 2023 16:48:02 +0100
Message-Id: <20230321154804.184577-2-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230321154804.184577-1-sgarzare@redhat.com>
References: <20230321154228.182769-1-sgarzare@redhat.com>
 <20230321154804.184577-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's use our own kthread to run device jobs.
This allows us more flexibility, especially we can attach the kthread
to the user address space when vDPA uses user's VA.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Notes:
    v3:
    - fix `dev` not initialized in the error path [Simon Horman]

 drivers/vdpa/vdpa_sim/vdpa_sim.h |  3 ++-
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 19 +++++++++++++------
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
index acee20faaf6a..ce83f9130a5d 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
@@ -57,7 +57,8 @@ struct vdpasim_dev_attr {
 struct vdpasim {
 	struct vdpa_device vdpa;
 	struct vdpasim_virtqueue *vqs;
-	struct work_struct work;
+	struct kthread_worker *worker;
+	struct kthread_work work;
 	struct vdpasim_dev_attr dev_attr;
 	/* spinlock to synchronize virtqueue state */
 	spinlock_t lock;
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index f6329900e61a..1cfa56c52e5a 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -11,8 +11,8 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
+#include <linux/kthread.h>
 #include <linux/slab.h>
-#include <linux/sched.h>
 #include <linux/dma-map-ops.h>
 #include <linux/vringh.h>
 #include <linux/vdpa.h>
@@ -127,7 +127,7 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
 static const struct vdpa_config_ops vdpasim_config_ops;
 static const struct vdpa_config_ops vdpasim_batch_config_ops;
 
-static void vdpasim_work_fn(struct work_struct *work)
+static void vdpasim_work_fn(struct kthread_work *work)
 {
 	struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
 
@@ -170,11 +170,17 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
 
 	vdpasim = vdpa_to_sim(vdpa);
 	vdpasim->dev_attr = *dev_attr;
-	INIT_WORK(&vdpasim->work, vdpasim_work_fn);
+	dev = &vdpasim->vdpa.dev;
+
+	kthread_init_work(&vdpasim->work, vdpasim_work_fn);
+	vdpasim->worker = kthread_create_worker(0, "vDPA sim worker: %s",
+						dev_attr->name);
+	if (IS_ERR(vdpasim->worker))
+		goto err_iommu;
+
 	spin_lock_init(&vdpasim->lock);
 	spin_lock_init(&vdpasim->iommu_lock);
 
-	dev = &vdpasim->vdpa.dev;
 	dev->dma_mask = &dev->coherent_dma_mask;
 	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)))
 		goto err_iommu;
@@ -223,7 +229,7 @@ EXPORT_SYMBOL_GPL(vdpasim_create);
 
 void vdpasim_schedule_work(struct vdpasim *vdpasim)
 {
-	schedule_work(&vdpasim->work);
+	kthread_queue_work(vdpasim->worker, &vdpasim->work);
 }
 EXPORT_SYMBOL_GPL(vdpasim_schedule_work);
 
@@ -623,7 +629,8 @@ static void vdpasim_free(struct vdpa_device *vdpa)
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 	int i;
 
-	cancel_work_sync(&vdpasim->work);
+	kthread_cancel_work_sync(&vdpasim->work);
+	kthread_destroy_worker(vdpasim->worker);
 
 	for (i = 0; i < vdpasim->dev_attr.nvqs; i++) {
 		vringh_kiov_cleanup(&vdpasim->vqs[i].out_iov);
-- 
2.39.2

