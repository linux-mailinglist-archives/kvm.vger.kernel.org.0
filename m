Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983692FB052
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 06:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388491AbhASFYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 00:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387667AbhASFKM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 00:10:12 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26A8C0613D6
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 21:08:24 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id g15so12281069pgu.9
        for <kvm@vger.kernel.org>; Mon, 18 Jan 2021 21:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l78+ic827fPeMtI4N3ruxnowwLavtkMdAQhrpxNvn10=;
        b=oLZ/lu9L9mSnnZyW00ltwHXyo44TYvX+ccpYXJTgwbiOiMXgHoMO3elQD5sQez2Sny
         ZrfOE/n85EPsc0U/9VpAgeIEA3Bcl8zawvPFtB5Y4kE1S2fBT//UvJjqi9ZqS/WlGhou
         qPeifQuk6xDi/b1qB/VrpXDIZcZ4x21hH7SLerZvvs+3QaAWVUkX4ggU7otSMaD3NF6N
         MM8TX7MrijhH3YO8q6l7lJym+s52rruIvIx1XhXorEqEXSF2k/V5Npl6vr4kcHngP8sq
         8JGHk470/POpPqUVzGcbHTKpIjWt8zPdr0PBjgDCyGUsX7I/oymzLxsqaClwVfX5WZU3
         4qGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l78+ic827fPeMtI4N3ruxnowwLavtkMdAQhrpxNvn10=;
        b=Dr+x5NiHFE+7AJodJVzvuFEaxxbQhtoez90g4zG7QtSnvZoMKIiESUMusgZKPcMRma
         fIvo840SWAIzxYwxSZMmMaR+bDJL+MhV24M6g76VAk1mRJ3L2e2ifM7O2hcrkSUf+5Xa
         jbZuke8HEM9NNXP8D6WsGvsJWWJ73lrd49yEEaOMk+33mMlvQYd6/qSuBSNrQT/TpBKD
         RUAPznv6to41mXDC16639QdYjc9P/6z8nYU1JuGxyy/L1Qmd0QTH9mCsw5IzpRD9vKkT
         saLHwg73MHqmalEFdRcfs83kH0V4/anEEOzqSB6E/2jABm5H13a3tKpGW2GVaj+k1ze1
         eGxA==
X-Gm-Message-State: AOAM531LJ/pxuzIwXcNCdlWJvQqocBw4JBiHHiZjO8VRJ2hGI1JAT648
        EGUUhvNeh2yU1NclzCQgjhp9
X-Google-Smtp-Source: ABdhPJz/fxwy4DYXVrnw1qnj25AW0O26rp73QlbMoxmwaU+d+WKNpvYSFfXNGAXSbsWGK45vrdkKRw==
X-Received: by 2002:a62:160d:0:b029:1b3:fc7b:9237 with SMTP id 13-20020a62160d0000b02901b3fc7b9237mr2578724pfw.35.1611032904596;
        Mon, 18 Jan 2021 21:08:24 -0800 (PST)
Received: from localhost ([139.177.225.243])
        by smtp.gmail.com with ESMTPSA id b11sm17087042pfr.38.2021.01.18.21.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 21:08:24 -0800 (PST)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, bob.liu@oracle.com,
        hch@infradead.org, rdunlap@infradead.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v3 09/11] vduse: Add VDUSE_GET_DEV ioctl
Date:   Tue, 19 Jan 2021 13:07:54 +0800
Message-Id: <20210119050756.600-3-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119050756.600-1-xieyongji@bytedance.com>
References: <20210119045920.447-1-xieyongji@bytedance.com>
 <20210119050756.600-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This new ioctl will be used to retrieve the file descriptor
referring to userspace vDPA device to support reconnecting.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 30 ++++++++++++++++++++++++++++++
 include/uapi/linux/vduse.h         |  1 +
 2 files changed, 31 insertions(+)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 1cf759bc5914..4d21203da5b6 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -872,9 +872,14 @@ static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
 static int vduse_dev_release(struct inode *inode, struct file *file)
 {
 	struct vduse_dev *dev = file->private_data;
+	struct vduse_dev_msg *msg;
 
 	vduse_kickfd_release(dev);
 	vduse_virqfd_release(dev);
+
+	while ((msg = vduse_dev_dequeue_msg(dev, &dev->recv_list)))
+		vduse_dev_enqueue_msg(dev, msg, &dev->send_list);
+
 	dev->connected = false;
 
 	return 0;
@@ -937,6 +942,28 @@ static struct vduse_dev *vduse_find_dev(u32 id)
 	return dev;
 }
 
+static int vduse_get_dev(u32 id)
+{
+	int fd;
+	char name[64];
+	struct vduse_dev *dev = vduse_find_dev(id);
+
+	if (!dev)
+		return -EINVAL;
+
+	if (dev->connected)
+		return -EBUSY;
+
+	snprintf(name, sizeof(name), "[vduse-dev:%u]", dev->id);
+	fd = anon_inode_getfd(name, &vduse_dev_fops, dev, O_RDWR | O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
+	dev->connected = true;
+
+	return fd;
+}
+
 static int vduse_destroy_dev(u32 id)
 {
 	struct vduse_dev *dev = vduse_find_dev(id);
@@ -1024,6 +1051,9 @@ static long vduse_ioctl(struct file *file, unsigned int cmd,
 		ret = vduse_create_dev(&config);
 		break;
 	}
+	case VDUSE_GET_DEV:
+		ret = vduse_get_dev(arg);
+		break;
 	case VDUSE_DESTROY_DEV:
 		ret = vduse_destroy_dev(arg);
 		break;
diff --git a/include/uapi/linux/vduse.h b/include/uapi/linux/vduse.h
index 9fb555ddcfbd..b3694f0d3b77 100644
--- a/include/uapi/linux/vduse.h
+++ b/include/uapi/linux/vduse.h
@@ -117,6 +117,7 @@ struct vduse_vq_eventfd {
 
 #define VDUSE_CREATE_DEV	_IOW(VDUSE_BASE, 0x01, struct vduse_dev_config)
 #define VDUSE_DESTROY_DEV	_IO(VDUSE_BASE, 0x02)
+#define VDUSE_GET_DEV		_IO(VDUSE_BASE, 0x03)
 
 #define VDUSE_IOTLB_GET_FD	_IOWR(VDUSE_BASE, 0x04, struct vduse_iotlb_entry)
 #define VDUSE_VQ_SETUP_KICKFD	_IOW(VDUSE_BASE, 0x05, struct vduse_vq_eventfd)
-- 
2.11.0

