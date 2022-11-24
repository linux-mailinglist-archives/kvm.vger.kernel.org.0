Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6F7637D49
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 16:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiKXPxT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 10:53:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiKXPxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 10:53:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A164812E213
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 07:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669305136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TSjVQAN1hGLhWwbJytaWeNULUe7TeqdaxnpYJGUlvrs=;
        b=Jnh7Rc4f/h+PY++46THteTq+47z4gbPWNaJEqi1YVK103WpYXoogG3axBZBaw/hYnj1SIp
        loHVtVK4gSb2j/szGkgC+lusje6C25JIWbYy0Cme1pjpGAa6QQDDqT5JQ/5tXvVF6isNd3
        joEsApUm7kX+0V0GDDZwSGsiyGXFc7A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-65-JM78j4smMnO63DX_IuidHQ-1; Thu, 24 Nov 2022 10:52:13 -0500
X-MC-Unique: JM78j4smMnO63DX_IuidHQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB533833A06;
        Thu, 24 Nov 2022 15:52:12 +0000 (UTC)
Received: from eperezma.remote.csb (unknown [10.39.192.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3FE7111DCE6;
        Thu, 24 Nov 2022 15:52:09 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Eli Cohen <eli@mellanox.com>, Jason Wang <jasowang@redhat.com>,
        Cindy Lu <lulu@redhat.com>, Parav Pandit <parav@mellanox.com>,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
        Liuxiangdong <liuxiangdong5@huawei.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH for 8.0 v8 02/12] vhost: set SVQ device call handler at SVQ start
Date:   Thu, 24 Nov 2022 16:51:48 +0100
Message-Id: <20221124155158.2109884-3-eperezma@redhat.com>
In-Reply-To: <20221124155158.2109884-1-eperezma@redhat.com>
References: <20221124155158.2109884-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By the end of this series CVQ is shadowed as long as the features
support it.

Since we don't know at the beginning of qemu running if this is
supported, move the event notifier handler setting to the start of the
SVQ, instead of the start of qemu run. This will avoid to create them if
the device does not support SVQ.

Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 hw/virtio/vhost-shadow-virtqueue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shadow-virtqueue.c
index 5bd14cad96..264ddc166d 100644
--- a/hw/virtio/vhost-shadow-virtqueue.c
+++ b/hw/virtio/vhost-shadow-virtqueue.c
@@ -648,6 +648,7 @@ void vhost_svq_start(VhostShadowVirtqueue *svq, VirtIODevice *vdev,
 {
     size_t desc_size, driver_size, device_size;
 
+    event_notifier_set_handler(&svq->hdev_call, vhost_svq_handle_call);
     svq->next_guest_avail_elem = NULL;
     svq->shadow_avail_idx = 0;
     svq->shadow_used_idx = 0;
@@ -704,6 +705,7 @@ void vhost_svq_stop(VhostShadowVirtqueue *svq)
     g_free(svq->desc_state);
     qemu_vfree(svq->vring.desc);
     qemu_vfree(svq->vring.used);
+    event_notifier_set_handler(&svq->hdev_call, NULL);
 }
 
 /**
@@ -740,7 +742,6 @@ VhostShadowVirtqueue *vhost_svq_new(VhostIOVATree *iova_tree,
     }
 
     event_notifier_init_fd(&svq->svq_kick, VHOST_FILE_UNBIND);
-    event_notifier_set_handler(&svq->hdev_call, vhost_svq_handle_call);
     svq->iova_tree = iova_tree;
     svq->ops = ops;
     svq->ops_opaque = ops_opaque;
@@ -763,7 +764,6 @@ void vhost_svq_free(gpointer pvq)
     VhostShadowVirtqueue *vq = pvq;
     vhost_svq_stop(vq);
     event_notifier_cleanup(&vq->hdev_kick);
-    event_notifier_set_handler(&vq->hdev_call, NULL);
     event_notifier_cleanup(&vq->hdev_call);
     g_free(vq);
 }
-- 
2.31.1

