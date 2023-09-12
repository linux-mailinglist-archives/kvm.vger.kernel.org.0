Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D95A79C410
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 05:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236916AbjILDYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 23:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236360AbjILDYc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 23:24:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E6E912DA41
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 20:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694487664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WI0RMvdlyM2CoPU0JPuivhklmmTZZnT8q78FFwqlw28=;
        b=dHwFah8/xFuUa7LDbUiD4zjrZQ9ImhPotS1JFUd9a5ImWc+G0x7xox1i4Jrl2v18co9bop
        DvBkXJJC2LKJ0Oh8M0xjklusm0BoQ/Z5pmBZQWnH6F11s4Niu4d2rdmkYMNPXONRKnSR3P
        EC2TiFvyD9UUw+H+Hy4JOUtbYczvJ/I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-281-ozpCd5wROgmlUEP7zF_bpA-1; Mon, 11 Sep 2023 23:00:59 -0400
X-MC-Unique: ozpCd5wROgmlUEP7zF_bpA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 488CB803C96;
        Tue, 12 Sep 2023 03:00:59 +0000 (UTC)
Received: from server.redhat.com (unknown [10.72.112.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7725110005D4;
        Tue, 12 Sep 2023 03:00:55 +0000 (UTC)
From:   Cindy Lu <lulu@redhat.com>
To:     lulu@redhat.com, jasowang@redhat.com, mst@redhat.com,
        maxime.coquelin@redhat.com, xieyongji@bytedance.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [RFC v2 4/4] vduse: Add new ioctl VDUSE_GET_RECONNECT_INFO
Date:   Tue, 12 Sep 2023 11:00:08 +0800
Message-Id: <20230912030008.3599514-5-lulu@redhat.com>
In-Reply-To: <20230912030008.3599514-1-lulu@redhat.com>
References: <20230912030008.3599514-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In VDUSE_GET_RECONNECT_INFO, the Userspace App can get the map size
and The number of mapping memory pages from the kernel. The userspace
App can use this information to map the pages.

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 15 +++++++++++++++
 include/uapi/linux/vduse.h         | 15 +++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 680b23dbdde2..c99f99892b5c 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1368,6 +1368,21 @@ static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
 		ret = 0;
 		break;
 	}
+	case VDUSE_GET_RECONNECT_INFO: {
+		struct vduse_reconnect_mmap_info info;
+
+		ret = -EFAULT;
+		if (copy_from_user(&info, argp, sizeof(info)))
+			break;
+
+		info.size = PAGE_SIZE;
+		info.max_index = dev->vq_num + 1;
+
+		if (copy_to_user(argp, &info, sizeof(info)))
+			break;
+		ret = 0;
+		break;
+	}
 	default:
 		ret = -ENOIOCTLCMD;
 		break;
diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
index d585425803fd..ce55e34f63d7 100644
--- a/include/uapi/linux/vduse.h
+++ b/include/uapi/linux/vduse.h
@@ -356,4 +356,19 @@ struct vhost_reconnect_vring {
 	_Bool avail_wrap_counter;
 };
 
+/**
+ * struct vduse_reconnect_mmap_info
+ * @size: mapping memory size, always page_size here
+ * @max_index: the number of pages allocated in kernel,just
+ * use for check
+ */
+
+struct vduse_reconnect_mmap_info {
+	__u32 size;
+	__u32 max_index;
+};
+
+#define VDUSE_GET_RECONNECT_INFO \
+	_IOWR(VDUSE_BASE, 0x1b, struct vduse_reconnect_mmap_info)
+
 #endif /* _UAPI_VDUSE_H_ */
-- 
2.34.3

