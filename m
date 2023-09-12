Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7AC79C413
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 05:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236392AbjILDYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 23:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237009AbjILDYc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 23:24:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 32C38296C7
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 20:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694487633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RvcAHd1Sx6r1hbCkmerjsL+BU6ZA4iisCRaqRkbDPg0=;
        b=UAiwLbvybP/AeV7VlxpoGZ19dMjezIetC9OtkxuD5FioILqGbWI5/G6dV9ekgC6acZk1MS
        oM1GbRe3TJD+JuL3e0hhoSEeMmx8j8BsC9qVb416jYtqnWg8+g8JoonVORS5UT1R+N830t
        X+PGHVYsObqYMkcgOeM0trOu5HmOLPw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-LtaHkr5JNEGcRN0MMZ4H8w-1; Mon, 11 Sep 2023 23:00:29 -0400
X-MC-Unique: LtaHkr5JNEGcRN0MMZ4H8w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE9F98A21EE;
        Tue, 12 Sep 2023 03:00:28 +0000 (UTC)
Received: from server.redhat.com (unknown [10.72.112.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FDCB40C6EA8;
        Tue, 12 Sep 2023 03:00:24 +0000 (UTC)
From:   Cindy Lu <lulu@redhat.com>
To:     lulu@redhat.com, jasowang@redhat.com, mst@redhat.com,
        maxime.coquelin@redhat.com, xieyongji@bytedance.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [RFC v2 2/4] vduse: Add file operation for mmap
Date:   Tue, 12 Sep 2023 11:00:06 +0800
Message-Id: <20230912030008.3599514-3-lulu@redhat.com>
In-Reply-To: <20230912030008.3599514-1-lulu@redhat.com>
References: <20230912030008.3599514-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the operation for mmap, The user space APP will
use this function to map the pages to userspace

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 63 ++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 4c256fa31fc4..2c69f4004a6e 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1388,6 +1388,67 @@ static struct vduse_dev *vduse_dev_get_from_minor(int minor)
 	return dev;
 }
 
+static vm_fault_t vduse_vm_fault(struct vm_fault *vmf)
+{
+	struct vduse_dev *dev = vmf->vma->vm_file->private_data;
+	struct vm_area_struct *vma = vmf->vma;
+	u16 index = vma->vm_pgoff;
+	struct vduse_virtqueue *vq;
+	struct vdpa_reconnect_info *info;
+
+	if (index == 0) {
+		info = &dev->reconnect_status;
+	} else {
+		vq = &dev->vqs[index - 1];
+		info = &vq->reconnect_info;
+	}
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	if (remap_pfn_range(vma, vmf->address & PAGE_MASK, PFN_DOWN(info->addr),
+			    PAGE_SIZE, vma->vm_page_prot))
+		return VM_FAULT_SIGBUS;
+	return VM_FAULT_NOPAGE;
+}
+
+static const struct vm_operations_struct vduse_vm_ops = {
+	.fault = vduse_vm_fault,
+};
+
+static int vduse_dev_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct vduse_dev *dev = file->private_data;
+	struct vdpa_reconnect_info *info;
+	unsigned long index = vma->vm_pgoff;
+	struct vduse_virtqueue *vq;
+
+	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
+		return -EINVAL;
+	if ((vma->vm_flags & VM_SHARED) == 0)
+		return -EINVAL;
+
+	if (index > 65535)
+		return -EINVAL;
+
+	if (index == 0) {
+		info = &dev->reconnect_status;
+	} else {
+		vq = &dev->vqs[index - 1];
+		info = &vq->reconnect_info;
+	}
+
+	if (info->index != index)
+		return -EINVAL;
+
+	if (info->addr & (PAGE_SIZE - 1))
+		return -EINVAL;
+	if (vma->vm_end - vma->vm_start != info->size)
+		return -EOPNOTSUPP;
+
+	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTDUMP);
+	vma->vm_ops = &vduse_vm_ops;
+
+	return 0;
+}
+
 static int vduse_dev_open(struct inode *inode, struct file *file)
 {
 	int ret;
@@ -1420,6 +1481,8 @@ static const struct file_operations vduse_dev_fops = {
 	.unlocked_ioctl	= vduse_dev_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
 	.llseek		= noop_llseek,
+	.mmap		= vduse_dev_mmap,
+
 };
 
 static struct vduse_dev *vduse_dev_create(void)
-- 
2.34.3

