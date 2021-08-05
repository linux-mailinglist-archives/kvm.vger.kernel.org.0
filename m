Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C6C3E1A05
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 19:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237217AbhHERHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 13:07:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43733 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237396AbhHERHr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Aug 2021 13:07:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628183252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fMfIvFu91OrZADMlmkZk2yLTz+kS1Ic9Q6C56vZ5Z1M=;
        b=TSbWeM0BaewiGVnW8arGoi3CmPsPcYi76WrcnZekgz4o0x/a9QioJMBehFDnhbEO3RdJAE
        yyK+DNCPI8kEV7pFFiDjqJEXAl/KOEruPXMYzwO7g3bl8a8GsfyoSKA5iAoR9xPN2EbCf5
        M8SfePcV6DOf3kaDNe8glfbRyx41JaU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-IfSVrlTANxqgf5EXrnP1wQ-1; Thu, 05 Aug 2021 13:07:31 -0400
X-MC-Unique: IfSVrlTANxqgf5EXrnP1wQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25FF9101C8A9;
        Thu,  5 Aug 2021 17:07:30 +0000 (UTC)
Received: from [172.30.41.16] (ovpn-113-77.phx2.redhat.com [10.3.113.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64C6E544F1;
        Thu,  5 Aug 2021 17:07:22 +0000 (UTC)
Subject: [PATCH 2/7] vfio: Export unmap_mapping_range() wrapper
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jgg@nvidia.com,
        peterx@redhat.com
Date:   Thu, 05 Aug 2021 11:07:22 -0600
Message-ID: <162818324222.1511194.15934590640437021149.stgit@omen>
In-Reply-To: <162818167535.1511194.6614962507750594786.stgit@omen>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
User-Agent: StGit/1.0-8-g6af9-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow bus drivers to use vfio pseudo fs mapping to zap all mmaps
across a range of their device files.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio.c  |    7 +++++++
 include/linux/vfio.h |    2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index b88de89bda31..1e4fc69fee7d 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -560,6 +560,13 @@ static struct inode *vfio_fs_inode_new(void)
 	return inode;
 }
 
+void vfio_device_unmap_mapping_range(struct vfio_device *device,
+				     loff_t start, loff_t len)
+{
+	unmap_mapping_range(device->inode->i_mapping, start, len, true);
+}
+EXPORT_SYMBOL_GPL(vfio_device_unmap_mapping_range);
+
 /**
  * Device objects - create, release, get, put, search
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 90bcc2e9c8eb..712813703e5a 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -66,6 +66,8 @@ int vfio_register_group_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
 extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
 extern void vfio_device_put(struct vfio_device *device);
+extern void vfio_device_unmap_mapping_range(struct vfio_device *device,
+					    loff_t start, loff_t len);
 
 /* events for the backend driver notify callback */
 enum vfio_iommu_notify_type {


