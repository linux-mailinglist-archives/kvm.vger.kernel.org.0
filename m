Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F12179C467
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 05:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237561AbjILDwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 23:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237570AbjILDwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 23:52:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B80E2913E
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 20:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694487631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kwKuz+pEy562YxDwzJRjoqIMWX9vZPgr9ApgXLFv6FY=;
        b=DD9FMrBs+YSg16LGhq9HnLCP515/0eaJHuNOIvG4E1qYSbeX5o4RoJdM4N9upjKFEXSdTF
        A3GXdjBd6y/95u33Bj2b72usIE9azBOY2XizVzlLc9E19I4dgcTsnxHocHGZtXTBt6fWj2
        INmWDu/hDIPllVuGKm/Ua5dxLKO4v58=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-yWHp0cIoMQqnm9uiFbZKbQ-1; Mon, 11 Sep 2023 23:00:25 -0400
X-MC-Unique: yWHp0cIoMQqnm9uiFbZKbQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FB723C0D859;
        Tue, 12 Sep 2023 03:00:24 +0000 (UTC)
Received: from server.redhat.com (unknown [10.72.112.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B456C40C6EA8;
        Tue, 12 Sep 2023 03:00:20 +0000 (UTC)
From:   Cindy Lu <lulu@redhat.com>
To:     lulu@redhat.com, jasowang@redhat.com, mst@redhat.com,
        maxime.coquelin@redhat.com, xieyongji@bytedance.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [RFC v2 1/4] vduse: Add function to get/free the pages for reconnection
Date:   Tue, 12 Sep 2023 11:00:05 +0800
Message-Id: <20230912030008.3599514-2-lulu@redhat.com>
In-Reply-To: <20230912030008.3599514-1-lulu@redhat.com>
References: <20230912030008.3599514-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the function vduse_alloc_reconnnect_info_mem
and vduse_alloc_reconnnect_info_mem
In this 2 function, vduse will get/free (vq_num + 1)*page  
Page 0 will be used to save the reconnection information, The
Userspace App will maintain this. Page 1 ~ vq_num + 1 will save
the reconnection information for vqs.

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 86 ++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 26b7e29cb900..4c256fa31fc4 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -30,6 +30,10 @@
 #include <uapi/linux/virtio_blk.h>
 #include <linux/mod_devicetable.h>
 
+#ifdef CONFIG_X86
+#include <asm/set_memory.h>
+#endif
+
 #include "iova_domain.h"
 
 #define DRV_AUTHOR   "Yongji Xie <xieyongji@bytedance.com>"
@@ -41,6 +45,23 @@
 #define VDUSE_IOVA_SIZE (128 * 1024 * 1024)
 #define VDUSE_MSG_DEFAULT_TIMEOUT 30
 
+/* struct vdpa_reconnect_info save the page information for reconnection
+ * kernel will init these information while alloc the pages
+ * and use these information to free the pages
+ */
+struct vdpa_reconnect_info {
+	/* Offset (within vm_file) in PAGE_SIZE,
+	 * this just for check, not using
+	 */
+	u32 index;
+	/* physical address for this page*/
+	phys_addr_t addr;
+	/* virtual address for this page*/
+	unsigned long vaddr;
+	/* memory size, here always page_size*/
+	phys_addr_t size;
+};
+
 struct vduse_virtqueue {
 	u16 index;
 	u16 num_max;
@@ -57,6 +78,7 @@ struct vduse_virtqueue {
 	struct vdpa_callback cb;
 	struct work_struct inject;
 	struct work_struct kick;
+	struct vdpa_reconnect_info reconnect_info;
 };
 
 struct vduse_dev;
@@ -106,6 +128,7 @@ struct vduse_dev {
 	u32 vq_align;
 	struct vduse_umem *umem;
 	struct mutex mem_lock;
+	struct vdpa_reconnect_info reconnect_status;
 };
 
 struct vduse_dev_msg {
@@ -1030,6 +1053,65 @@ static int vduse_dev_reg_umem(struct vduse_dev *dev,
 	return ret;
 }
 
+int vduse_alloc_reconnnect_info_mem(struct vduse_dev *dev)
+{
+	struct vdpa_reconnect_info *info;
+	struct vduse_virtqueue *vq;
+	void *addr;
+
+	/*page 0 is use to save status,dpdk will use this to save the information
+	 *needed in reconnection,kernel don't need to maintain this
+	 */
+	info = &dev->reconnect_status;
+	addr = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!addr)
+		return -1;
+
+	info->addr = virt_to_phys(addr);
+	info->vaddr = (unsigned long)(addr);
+	info->size = PAGE_SIZE;
+	/* index is vm Offset in PAGE_SIZE */
+	info->index = 0;
+
+	/*page 1~ vq_num + 1 save the reconnect info for vqs*/
+	for (int i = 0; i < dev->vq_num + 1; i++) {
+		vq = &dev->vqs[i];
+		info = &vq->reconnect_info;
+		addr = (void *)get_zeroed_page(GFP_KERNEL);
+		if (!addr)
+			return -1;
+
+		info->addr = virt_to_phys(addr);
+		info->vaddr = (unsigned long)(addr);
+		info->size = PAGE_SIZE;
+		info->index = i + 1;
+	}
+
+	return 0;
+}
+
+int vduse_free_reconnnect_info_mem(struct vduse_dev *dev)
+{
+	struct vdpa_reconnect_info *info;
+	struct vduse_virtqueue *vq;
+
+	info = &dev->reconnect_status;
+	free_page(info->vaddr);
+	info->size = 0;
+	info->addr = 0;
+	info->vaddr = 0;
+	for (int i = 0; i < dev->vq_num + 1; i++) {
+		vq = &dev->vqs[i];
+		info = &vq->reconnect_info;
+		free_page(info->vaddr);
+		info->size = 0;
+		info->addr = 0;
+		info->vaddr = 0;
+	}
+
+	return 0;
+}
+
 static long vduse_dev_ioctl(struct file *file, unsigned int cmd,
 			    unsigned long arg)
 {
@@ -1390,6 +1472,8 @@ static int vduse_destroy_dev(char *name)
 		mutex_unlock(&dev->lock);
 		return -EBUSY;
 	}
+	vduse_free_reconnnect_info_mem(dev);
+
 	dev->connected = true;
 	mutex_unlock(&dev->lock);
 
@@ -1542,6 +1626,8 @@ static int vduse_create_dev(struct vduse_dev_config *config,
 		ret = PTR_ERR(dev->dev);
 		goto err_dev;
 	}
+
+	vduse_alloc_reconnnect_info_mem(dev);
 	__module_get(THIS_MODULE);
 
 	return 0;
-- 
2.34.3

