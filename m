Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3853740A67
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbjF1IEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:04:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50045 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232343AbjF1ICB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jun 2023 04:02:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687939273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=csNRQntj+qYkEtYEdA8LKIDg2tovNr8UB73l+ephPGs=;
        b=QuiqpCe/zYsnrWuCooc1WBuN7YSAMHirjIDRfHFqolfKAtwUHo7j9Xp5KJ/TxO4VpayGyg
        hbp7CsqPdx3HcVeyGnxj696DZyNsx0dwotyhidbU70yWKdHrHmwEuMORwz6lvt5r/ZwXhA
        FIaRxUHX4RA1E2lKkwVgRgxPb9HOzEA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-t2pgzsuqNTeSfM39pUP_9w-1; Wed, 28 Jun 2023 02:59:35 -0400
X-MC-Unique: t2pgzsuqNTeSfM39pUP_9w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DC8B1C08783;
        Wed, 28 Jun 2023 06:59:35 +0000 (UTC)
Received: from server.redhat.com (ovpn-13-142.pek2.redhat.com [10.72.13.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E413492B02;
        Wed, 28 Jun 2023 06:59:31 +0000 (UTC)
From:   Cindy Lu <lulu@redhat.com>
To:     lulu@redhat.com, jasowang@redhat.com, mst@redhat.com,
        maxime.coquelin@redhat.com, xieyongji@bytedance.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [RFC 2/4] vduse: Add file operation for mmap
Date:   Wed, 28 Jun 2023 14:59:17 +0800
Message-Id: <20230628065919.54042-3-lulu@redhat.com>
In-Reply-To: <20230628065919.54042-1-lulu@redhat.com>
References: <20230628065919.54042-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Your Name <you@example.com>

Add the operation for mmap, The user space APP will
use this function to map the pages to userspace

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 49 ++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index f845dc46b1db..1b833bf0ae37 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1313,6 +1313,54 @@ static struct vduse_dev *vduse_dev_get_from_minor(int minor)
 	return dev;
 }
 
+
+static vm_fault_t vduse_vm_fault(struct vm_fault *vmf)
+{
+	struct vduse_dev *dev = vmf->vma->vm_file->private_data;
+	struct vm_area_struct *vma = vmf->vma;
+	u16 index = vma->vm_pgoff;
+
+	struct vdpa_reconnect_info *info;
+	info = &dev->reconnect_info[index];
+
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
+static int vduse_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct vduse_dev *dev = file->private_data;
+	struct vdpa_reconnect_info *info;
+	unsigned long index = vma->vm_pgoff;
+
+	if (vma->vm_end - vma->vm_start != PAGE_SIZE)
+		return -EINVAL;
+	if ((vma->vm_flags & VM_SHARED) == 0)
+		return -EINVAL;
+
+	if (index > 65535)
+		return -EINVAL;
+
+	info = &dev->reconnect_info[index];
+	if (info->addr & (PAGE_SIZE - 1))
+		return -EINVAL;
+	if (vma->vm_end - vma->vm_start != info->size) {
+		return -ENOTSUPP;
+	}
+
+	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
+	vma->vm_ops = &vduse_vm_ops;
+
+	return 0;
+}
+
 static int vduse_dev_open(struct inode *inode, struct file *file)
 {
 	int ret;
@@ -1345,6 +1393,7 @@ static const struct file_operations vduse_dev_fops = {
 	.unlocked_ioctl	= vduse_dev_ioctl,
 	.compat_ioctl	= compat_ptr_ioctl,
 	.llseek		= noop_llseek,
+	.mmap		= vduse_mmap,
 };
 
 static struct vduse_dev *vduse_dev_create(void)
-- 
2.34.3

