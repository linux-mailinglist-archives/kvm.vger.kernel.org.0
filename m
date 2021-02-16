Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337F631C84F
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 10:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhBPJqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 04:46:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33576 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229923AbhBPJqh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Feb 2021 04:46:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613468711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DCpAAD0R3f5DpHYdniOmpnpZ0gH4EPVC6kj5APUQyNw=;
        b=ZERLiRIaklb9TzbbDmWFdbD0eGRfnqBXNmfnoL9cq+Xmla/0WUC/igKMpiGRKoi3E9LT5f
        3Ye6MMMFndvpgHelPFbG5S4NZJGnvAtyfbNQ9wbDGs0YNjW+DPygk4v2aohysEEGQzSboU
        zPjQi7nUSYEE8bV9/28ETIJugaSK8zU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-Hw12bHLRO-2iSN7t9QeHiw-1; Tue, 16 Feb 2021 04:45:07 -0500
X-MC-Unique: Hw12bHLRO-2iSN7t9QeHiw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95A9D801965;
        Tue, 16 Feb 2021 09:45:06 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-212.ams2.redhat.com [10.36.113.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 609555D9C0;
        Tue, 16 Feb 2021 09:45:03 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [RFC PATCH 01/10] vdpa: add get_config_size callback in vdpa_config_ops
Date:   Tue, 16 Feb 2021 10:44:45 +0100
Message-Id: <20210216094454.82106-2-sgarzare@redhat.com>
In-Reply-To: <20210216094454.82106-1-sgarzare@redhat.com>
References: <20210216094454.82106-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This new callback is used to get the size of the configuration space
of vDPA devices.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/linux/vdpa.h              | 4 ++++
 drivers/vdpa/ifcvf/ifcvf_main.c   | 6 ++++++
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 6 ++++++
 drivers/vdpa/vdpa_sim/vdpa_sim.c  | 9 +++++++++
 4 files changed, 25 insertions(+)

diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 4ab5494503a8..fddf42b17573 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -150,6 +150,9 @@ struct vdpa_iova_range {
  * @set_status:			Set the device status
  *				@vdev: vdpa device
  *				@status: virtio device status
+ * @get_config_size:		Get the size of the configuration space
+ *				@vdev: vdpa device
+ *				Returns size_t: configuration size
  * @get_config:			Read from device specific configuration space
  *				@vdev: vdpa device
  *				@offset: offset from the beginning of
@@ -231,6 +234,7 @@ struct vdpa_config_ops {
 	u32 (*get_vendor_id)(struct vdpa_device *vdev);
 	u8 (*get_status)(struct vdpa_device *vdev);
 	void (*set_status)(struct vdpa_device *vdev, u8 status);
+	size_t (*get_config_size)(struct vdpa_device *vdev);
 	void (*get_config)(struct vdpa_device *vdev, unsigned int offset,
 			   void *buf, unsigned int len);
 	void (*set_config)(struct vdpa_device *vdev, unsigned int offset,
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 7c8bbfcf6c3e..2443271e17d2 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -332,6 +332,11 @@ static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
 	return IFCVF_QUEUE_ALIGNMENT;
 }
 
+static size_t ifcvf_vdpa_get_config_size(struct vdpa_device *vdpa_dev)
+{
+	return sizeof(struct virtio_net_config);
+}
+
 static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
 				  unsigned int offset,
 				  void *buf, unsigned int len)
@@ -392,6 +397,7 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
 	.get_device_id	= ifcvf_vdpa_get_device_id,
 	.get_vendor_id	= ifcvf_vdpa_get_vendor_id,
 	.get_vq_align	= ifcvf_vdpa_get_vq_align,
+	.get_config_size	= ifcvf_vdpa_get_config_size,
 	.get_config	= ifcvf_vdpa_get_config,
 	.set_config	= ifcvf_vdpa_set_config,
 	.set_config_cb  = ifcvf_vdpa_set_config_cb,
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 10e9b09932eb..78043ee567b6 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1814,6 +1814,11 @@ static void mlx5_vdpa_set_status(struct vdpa_device *vdev, u8 status)
 	ndev->mvdev.status |= VIRTIO_CONFIG_S_FAILED;
 }
 
+static size_t mlx5_vdpa_get_config_size(struct vdpa_device *vdev)
+{
+	return sizeof(struct virtio_net_config);
+}
+
 static void mlx5_vdpa_get_config(struct vdpa_device *vdev, unsigned int offset, void *buf,
 				 unsigned int len)
 {
@@ -1900,6 +1905,7 @@ static const struct vdpa_config_ops mlx5_vdpa_ops = {
 	.get_vendor_id = mlx5_vdpa_get_vendor_id,
 	.get_status = mlx5_vdpa_get_status,
 	.set_status = mlx5_vdpa_set_status,
+	.get_config_size = mlx5_vdpa_get_config_size,
 	.get_config = mlx5_vdpa_get_config,
 	.set_config = mlx5_vdpa_set_config,
 	.get_generation = mlx5_vdpa_get_generation,
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index d5942842432d..779ae6c144d7 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -439,6 +439,13 @@ static void vdpasim_set_status(struct vdpa_device *vdpa, u8 status)
 	spin_unlock(&vdpasim->lock);
 }
 
+static size_t vdpasim_get_config_size(struct vdpa_device *vdpa)
+{
+	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
+
+	return vdpasim->dev_attr.config_size;
+}
+
 static void vdpasim_get_config(struct vdpa_device *vdpa, unsigned int offset,
 			     void *buf, unsigned int len)
 {
@@ -566,6 +573,7 @@ static const struct vdpa_config_ops vdpasim_config_ops = {
 	.get_vendor_id          = vdpasim_get_vendor_id,
 	.get_status             = vdpasim_get_status,
 	.set_status             = vdpasim_set_status,
+	.get_config_size        = vdpasim_get_config_size,
 	.get_config             = vdpasim_get_config,
 	.set_config             = vdpasim_set_config,
 	.get_generation         = vdpasim_get_generation,
@@ -593,6 +601,7 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops = {
 	.get_vendor_id          = vdpasim_get_vendor_id,
 	.get_status             = vdpasim_get_status,
 	.set_status             = vdpasim_set_status,
+	.get_config_size        = vdpasim_get_config_size,
 	.get_config             = vdpasim_get_config,
 	.set_config             = vdpasim_set_config,
 	.get_generation         = vdpasim_get_generation,
-- 
2.29.2

