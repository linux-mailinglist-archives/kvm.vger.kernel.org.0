Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7A0740A6A
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbjF1IGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:06:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30353 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231588AbjF1ICw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jun 2023 04:02:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687939321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JAxb7d8d9hAo9Ep6Vle9AGPfDkrTVJl7Nk2Fi7I0ejI=;
        b=iPnOD3cO34trA79QROPmXXFfLnFyFR1PbHWH4K29UoghN2DoG6SfKuKgdPNf0VVyyR8tzi
        DxlMiSut+9TWldpVbBQpgbju/HkEt5IIuoEMKP/+Hq5HpiogJ3hVK/EUtVtHZzScbhOheB
        zTHG/U4RU08DchEWW/rTwdhQMCTFCXM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-3YrzZBg_P96LFy3lVXhYaA-1; Wed, 28 Jun 2023 03:00:05 -0400
X-MC-Unique: 3YrzZBg_P96LFy3lVXhYaA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 327188ED600;
        Wed, 28 Jun 2023 07:00:05 +0000 (UTC)
Received: from server.redhat.com (ovpn-13-142.pek2.redhat.com [10.72.13.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FB7540BB4D;
        Wed, 28 Jun 2023 07:00:01 +0000 (UTC)
From:   Cindy Lu <lulu@redhat.com>
To:     lulu@redhat.com, jasowang@redhat.com, mst@redhat.com,
        maxime.coquelin@redhat.com, xieyongji@bytedance.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [RFC 4/4] vduse: update the vq_info in ioctl
Date:   Wed, 28 Jun 2023 14:59:19 +0800
Message-Id: <20230628065919.54042-5-lulu@redhat.com>
In-Reply-To: <20230628065919.54042-1-lulu@redhat.com>
References: <20230628065919.54042-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Your Name <you@example.com>

in VDUSE_VQ_GET_INFO, driver will sync the last_avail_idx
with reconnect info, I have olny test the split mode, so
only use this here, will add more information later

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 3df1256eccb4..b8e453eac0ce 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -141,6 +141,11 @@ static u32 allowed_device_id[] = {
 	VIRTIO_ID_NET,
 };
 
+struct vhost_reconnect_vring {
+	uint16_t last_avail_idx;
+	bool avail_wrap_counter;
+};
+
 static inline struct vduse_dev *vdpa_to_vduse(struct vdpa_device *vdpa)
 {
 	struct vduse_vdpa *vdev = container_of(vdpa, struct vduse_vdpa, vdpa);
@@ -1176,6 +1181,17 @@ static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
 				vq->state.split.avail_index;
 
 		vq_info.ready = vq->ready;
+		struct vdpa_reconnect_info *area;
+
+		area = &dev->reconnect_info[index];
+		struct vhost_reconnect_vring *log_reconnect;
+
+		log_reconnect = (struct vhost_reconnect_vring *)area->vaddr;
+		if (log_reconnect->last_avail_idx !=
+		    vq_info.split.avail_index) {
+			vq_info.split.avail_index =
+				log_reconnect->last_avail_idx;
+		}
 
 		ret = -EFAULT;
 		if (copy_to_user(argp, &vq_info, sizeof(vq_info)))
-- 
2.34.3

