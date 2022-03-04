Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039DF4CD21C
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 11:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239543AbiCDKMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 05:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239535AbiCDKMF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 05:12:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 073B71A9077
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 02:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646388677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ztDvj7fiM7xkapi0r03fC+oUdKdfsZD0L/E+xi9O+Iw=;
        b=cbgSqwWcxFPhc7N7nD49KRKOTPvrj5AMXcOfOlvj6SXDDAobEGzWi1Tjgtsn+upJ43e3am
        rCPjotMN6B9YRB0nqm0Y4XCCpHJEjAzcJkiolPpVbnJQsGlt0EvkG/uN8sqbCAqTLlZiDR
        5vnzKGslEMnueuXF0SSUDmPggidNuqc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-LTD4M1sSPUWJyQrxSp1IhQ-1; Fri, 04 Mar 2022 05:11:14 -0500
X-MC-Unique: LTD4M1sSPUWJyQrxSp1IhQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 258E851DF;
        Fri,  4 Mar 2022 10:11:12 +0000 (UTC)
Received: from toolbox.redhat.com (unknown [10.33.36.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 48B4C842BA;
        Fri,  4 Mar 2022 10:09:39 +0000 (UTC)
From:   Sergio Lopez <slp@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, qemu-block@nongnu.org,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-s390x@nongnu.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>, vgoyal@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>, Sergio Lopez <slp@redhat.com>
Subject: [PATCH v4 2/4] vhost: use wfd on functions setting vring call fd
Date:   Fri,  4 Mar 2022 11:08:52 +0100
Message-Id: <20220304100854.14829-3-slp@redhat.com>
In-Reply-To: <20220304100854.14829-1-slp@redhat.com>
References: <20220304100854.14829-1-slp@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When ioeventfd is emulated using qemu_pipe(), only EventNotifier's wfd
can be used for writing.

Use the recently introduced event_notifier_get_wfd() function to
obtain the fd that our peer must use to signal the vring.

Signed-off-by: Sergio Lopez <slp@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 hw/virtio/vhost.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 7b03efccec..b643f42ea4 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -1287,7 +1287,7 @@ static int vhost_virtqueue_init(struct vhost_dev *dev,
         return r;
     }
 
-    file.fd = event_notifier_get_fd(&vq->masked_notifier);
+    file.fd = event_notifier_get_wfd(&vq->masked_notifier);
     r = dev->vhost_ops->vhost_set_vring_call(dev, &file);
     if (r) {
         VHOST_OPS_DEBUG(r, "vhost_set_vring_call failed");
@@ -1542,9 +1542,9 @@ void vhost_virtqueue_mask(struct vhost_dev *hdev, VirtIODevice *vdev, int n,
 
     if (mask) {
         assert(vdev->use_guest_notifier_mask);
-        file.fd = event_notifier_get_fd(&hdev->vqs[index].masked_notifier);
+        file.fd = event_notifier_get_wfd(&hdev->vqs[index].masked_notifier);
     } else {
-        file.fd = event_notifier_get_fd(virtio_queue_get_guest_notifier(vvq));
+        file.fd = event_notifier_get_wfd(virtio_queue_get_guest_notifier(vvq));
     }
 
     file.index = hdev->vhost_ops->vhost_get_vq_index(hdev, n);
-- 
2.35.1

