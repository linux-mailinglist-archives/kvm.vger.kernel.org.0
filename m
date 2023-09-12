Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B9179C46E
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 05:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238479AbjILDws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 23:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238466AbjILDwd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 23:52:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1FCF296D1
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 20:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694487636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GC7kin1JeAsa+JwSskswsZ+EfkakP69SisNc/3XqZfo=;
        b=LZO+cJYrHpuC/7dW4i2kwvJynoFNsAT1z4PrJRWS3Pqixw9OlbesQhUVdDobrzNNof8NJb
        gwTpcWAbfgJpjEBTA++Ac7/2olrgg8tU8mlXpwpUgPhuCxRjjB1q9+Ad2Jhw5OhYflp7Al
        U2Z7ALlFHwq2UMXJTJtCwm1R7yxnFHQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-696-iLfAFYcYN1yjSWG1J-LD9A-1; Mon, 11 Sep 2023 23:00:33 -0400
X-MC-Unique: iLfAFYcYN1yjSWG1J-LD9A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A7A93801BC2;
        Tue, 12 Sep 2023 03:00:33 +0000 (UTC)
Received: from server.redhat.com (unknown [10.72.112.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7EC5440C6EA8;
        Tue, 12 Sep 2023 03:00:29 +0000 (UTC)
From:   Cindy Lu <lulu@redhat.com>
To:     lulu@redhat.com, jasowang@redhat.com, mst@redhat.com,
        maxime.coquelin@redhat.com, xieyongji@bytedance.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [RFC v2 3/4] vduse: update the vq_info in ioctl
Date:   Tue, 12 Sep 2023 11:00:07 +0800
Message-Id: <20230912030008.3599514-4-lulu@redhat.com>
In-Reply-To: <20230912030008.3599514-1-lulu@redhat.com>
References: <20230912030008.3599514-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In VDUSE_VQ_GET_INFO, the driver will sync the last_avail_idx
with reconnect info, After mapping the reconnect pages to userspace
The userspace App will update the reconnect_time in
struct vhost_reconnect_vring, If this is not 0 then it means this
vq is reconnected and will update the last_avail_idx

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 13 +++++++++++++
 include/uapi/linux/vduse.h         |  6 ++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 2c69f4004a6e..680b23dbdde2 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1221,6 +1221,8 @@ static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
 		struct vduse_vq_info vq_info;
 		struct vduse_virtqueue *vq;
 		u32 index;
+		struct vdpa_reconnect_info *area;
+		struct vhost_reconnect_vring *vq_reconnect;
 
 		ret = -EFAULT;
 		if (copy_from_user(&vq_info, argp, sizeof(vq_info)))
@@ -1252,6 +1254,17 @@ static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
 
 		vq_info.ready = vq->ready;
 
+		area = &vq->reconnect_info;
+
+		vq_reconnect = (struct vhost_reconnect_vring *)area->vaddr;
+		/*check if the vq is reconnect, if yes then update the last_avail_idx*/
+		if ((vq_reconnect->last_avail_idx !=
+		     vq_info.split.avail_index) &&
+		    (vq_reconnect->reconnect_time != 0)) {
+			vq_info.split.avail_index =
+				vq_reconnect->last_avail_idx;
+		}
+
 		ret = -EFAULT;
 		if (copy_to_user(argp, &vq_info, sizeof(vq_info)))
 			break;
diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
index 11bd48c72c6c..d585425803fd 100644
--- a/include/uapi/linux/vduse.h
+++ b/include/uapi/linux/vduse.h
@@ -350,4 +350,10 @@ struct vduse_dev_response {
 	};
 };
 
+struct vhost_reconnect_vring {
+	__u16 reconnect_time;
+	__u16 last_avail_idx;
+	_Bool avail_wrap_counter;
+};
+
 #endif /* _UAPI_VDUSE_H_ */
-- 
2.34.3

