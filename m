Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA576C816D
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 16:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbjCXPht (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 11:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbjCXPhj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 11:37:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCFD20A2B
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 08:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679672184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4MlJ8boSBAN33TyWlK9MdNtuYbz66i2Pl/D7dBKo3iE=;
        b=cUboR778KpKd1GmvNtCHbLGJpDevVFxJ3Ly+6aC1tYwc/ia9GiBPZ8J8JJkWj469kCd5QH
        L3z8MYU9oSZD3jLRxIqz5L2pm2qaK0Gds1dCGHE8flP140/InX358G0KfTMwVWMRLj3oVV
        t9ZJKzetnYRNIhtCXBQw8PoLPlZieCA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-Ur9Ep2-PPHaSVDXsTeqxsg-1; Fri, 24 Mar 2023 11:36:22 -0400
X-MC-Unique: Ur9Ep2-PPHaSVDXsTeqxsg-1
Received: by mail-ed1-f72.google.com with SMTP id a27-20020a50c31b000000b0050047ecf4bfso3731593edb.19
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 08:36:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679672182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4MlJ8boSBAN33TyWlK9MdNtuYbz66i2Pl/D7dBKo3iE=;
        b=FIZFKlDL1wacmgeR8vVpSNMe6O6pVVOdHgs3pb0zbXpOlIeVl1DeysZEmYw0px/5Qu
         jud3afMHszNuALlu4TiDr7YQnlkaNk87vdSLfoLCURpxPRn6x7M5OUQ/6m5rDZbAAorl
         FCLUudF2xU+Wb1E5uGd935g7sflwpJvlg0fOH+FJ4i/cPUKALMRBDzvyRCZJOct4jUIo
         vt3sJx0jGg7CqX4REp4k87I+C/ef+nXCZb7freSsTElK8g6HZ4d1KpbdZKgXRzdZNVyK
         6gzqp/5mgQZCIZtuUCDtP/M+TWd9YZ4uFh85xXsyS0HtXejCq5LFqtqNR1pVyxETrwMl
         tJTg==
X-Gm-Message-State: AAQBX9dKCxTOtbzzlaHPj8tDJZNDSfFVvAavHSXGVzPDWe5i//JzNgtd
        8Q7g2yoVRIZuXIDQaUL4pq85sCkWKlcoRxsSk/W9mKlS7YBdnu6MCSQDfq/v5IA+Q8Hf2P+tdpD
        Twy2DzkhiZ5dc
X-Received: by 2002:aa7:c790:0:b0:4fc:d837:2c44 with SMTP id n16-20020aa7c790000000b004fcd8372c44mr3252018eds.35.1679672181883;
        Fri, 24 Mar 2023 08:36:21 -0700 (PDT)
X-Google-Smtp-Source: AKy350aJBTEFkP6aqAHdaeIIvmOP9rVekfmxxI9LgulqMr7BZcxEwnh21R3RMUZwmFE3QIQUAwYc0g==
X-Received: by 2002:aa7:c790:0:b0:4fc:d837:2c44 with SMTP id n16-20020aa7c790000000b004fcd8372c44mr3252001eds.35.1679672181598;
        Fri, 24 Mar 2023 08:36:21 -0700 (PDT)
Received: from localhost.localdomain (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id a27-20020a509b5b000000b00501dd53dbfbsm5468613edj.75.2023.03.24.08.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 08:36:20 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     stefanha@redhat.com, Jason Wang <jasowang@redhat.com>,
        linux-kernel@vger.kernel.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, eperezma@redhat.com,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v4 2/9] vhost-vdpa: use bind_mm/unbind_mm device callbacks
Date:   Fri, 24 Mar 2023 16:36:00 +0100
Message-Id: <20230324153607.46836-3-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324153607.46836-1-sgarzare@redhat.com>
References: <20230324153607.46836-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the user call VHOST_SET_OWNER ioctl and the vDPA device
has `use_va` set to true, let's call the bind_mm callback.
In this way we can bind the device to the user address space
and directly use the user VA.

The unbind_mm callback is called during the release after
stopping the device.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Notes:
    v4:
    - added new switch after vhost_dev_ioctl() [Jason]
    v3:
    - added `case VHOST_SET_OWNER` in vhost_vdpa_unlocked_ioctl() [Jason]
    v2:
    - call the new unbind_mm callback during the release [Jason]
    - avoid to call bind_mm callback after the reset, since the device
      is not detaching it now during the reset

 drivers/vhost/vdpa.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 7be9d9d8f01c..3824c249612f 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -219,6 +219,28 @@ static int vhost_vdpa_reset(struct vhost_vdpa *v)
 	return vdpa_reset(vdpa);
 }
 
+static long vhost_vdpa_bind_mm(struct vhost_vdpa *v)
+{
+	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
+
+	if (!vdpa->use_va || !ops->bind_mm)
+		return 0;
+
+	return ops->bind_mm(vdpa, v->vdev.mm);
+}
+
+static void vhost_vdpa_unbind_mm(struct vhost_vdpa *v)
+{
+	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
+
+	if (!vdpa->use_va || !ops->unbind_mm)
+		return;
+
+	ops->unbind_mm(vdpa);
+}
+
 static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *argp)
 {
 	struct vdpa_device *vdpa = v->vdpa;
@@ -716,6 +738,17 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 		break;
 	}
 
+	if (r)
+		goto out;
+
+	switch (cmd) {
+	case VHOST_SET_OWNER:
+		r = vhost_vdpa_bind_mm(v);
+		if (r)
+			vhost_dev_reset_owner(d, NULL);
+		break;
+	}
+out:
 	mutex_unlock(&d->mutex);
 	return r;
 }
@@ -1287,6 +1320,7 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 	vhost_vdpa_clean_irq(v);
 	vhost_vdpa_reset(v);
 	vhost_dev_stop(&v->vdev);
+	vhost_vdpa_unbind_mm(v);
 	vhost_vdpa_config_put(v);
 	vhost_vdpa_cleanup(v);
 	mutex_unlock(&d->mutex);
-- 
2.39.2

