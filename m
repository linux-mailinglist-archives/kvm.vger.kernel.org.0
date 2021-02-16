Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86AB831C855
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 10:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhBPJrh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 04:47:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38790 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230060AbhBPJrG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Feb 2021 04:47:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613468740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aKEudwAL0ABOP6RtR9S4wa4bhOuDErjR+HWjbOMiYD4=;
        b=DUb+tMgnBUKYLVZxauhNws1TvQ9V8Mct26pEGhIQ8NxDlGeCsRzQW1gZijKjbKpAf2p4s7
        dpmm7nnp1tC9jJbbIRRMEaUtJHaQ4I+iRTLkwdBRR4XhCB+fAXUrL2LJoZx7hARrRkROcw
        F3T9T/T2iQ3MKXds+4xMJRBI8YfOJLs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-WHfg1IYJPuup6N6pV86-aQ-1; Tue, 16 Feb 2021 04:45:36 -0500
X-MC-Unique: WHfg1IYJPuup6N6pV86-aQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA36BAFA80;
        Tue, 16 Feb 2021 09:45:35 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-212.ams2.redhat.com [10.36.113.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 569F0163F1;
        Tue, 16 Feb 2021 09:45:31 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [RFC PATCH 04/10] vdpa: remove param checks in the get/set_config callbacks
Date:   Tue, 16 Feb 2021 10:44:48 +0100
Message-Id: <20210216094454.82106-5-sgarzare@redhat.com>
In-Reply-To: <20210216094454.82106-1-sgarzare@redhat.com>
References: <20210216094454.82106-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vdpa_get_config() and vdpa_set_config() now check parameters before
calling callbacks, so we can remove these redundant checks.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 3 +--
 drivers/vdpa/vdpa_sim/vdpa_sim.c  | 6 ------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 78043ee567b6..ab63dc9b8432 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1825,8 +1825,7 @@ static void mlx5_vdpa_get_config(struct vdpa_device *vdev, unsigned int offset,
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
 
-	if (offset + len <= sizeof(struct virtio_net_config))
-		memcpy(buf, (u8 *)&ndev->config + offset, len);
+	memcpy(buf, (u8 *)&ndev->config + offset, len);
 }
 
 static void mlx5_vdpa_set_config(struct vdpa_device *vdev, unsigned int offset, const void *buf,
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 779ae6c144d7..392180c6f2cf 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -451,9 +451,6 @@ static void vdpasim_get_config(struct vdpa_device *vdpa, unsigned int offset,
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 
-	if (offset + len > vdpasim->dev_attr.config_size)
-		return;
-
 	if (vdpasim->dev_attr.get_config)
 		vdpasim->dev_attr.get_config(vdpasim, vdpasim->config);
 
@@ -465,9 +462,6 @@ static void vdpasim_set_config(struct vdpa_device *vdpa, unsigned int offset,
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 
-	if (offset + len > vdpasim->dev_attr.config_size)
-		return;
-
 	memcpy(vdpasim->config + offset, buf, len);
 
 	if (vdpasim->dev_attr.set_config)
-- 
2.29.2

