Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE16683820
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 21:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbjAaU5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 15:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbjAaU5S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 15:57:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DD85AA73
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 12:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675198520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e5sOZ7T4rCePKl4jrRxs/NjtPktVEIznS6j5QtdTwBU=;
        b=hLRlaIhiQ3n6tMxX4J/X97BHqYm7f6f3+0/AyN7DBzS9oQQmFzu4BEAWGcdn7sqVRUbQqK
        A5JqFdO1Y8qRixPsxKArjn7yO32VeRURzIR79+ifXBfp1+g0Gbid7tCsutm685yUgGAniq
        8a3BlMQcd6Kkr1c4OlfMpCfMC5QYvJA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-KfQuH0jZMUmX5IAMhOQ70Q-1; Tue, 31 Jan 2023 15:55:15 -0500
X-MC-Unique: KfQuH0jZMUmX5IAMhOQ70Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D22B7811E9C;
        Tue, 31 Jan 2023 20:55:13 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 483ED40C2004;
        Tue, 31 Jan 2023 20:55:07 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com, alex.williamson@redhat.com,
        clg@redhat.com, qemu-devel@nongnu.org
Cc:     david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, kevin.tian@intel.com, chao.p.peng@intel.com,
        peterx@redhat.com, shameerali.kolothum.thodi@huawei.com,
        zhangfei.gao@linaro.org, berrange@redhat.com, apopple@nvidia.com,
        suravee.suthikulpanit@amd.com
Subject: [RFC v3 18/18] vfio/as: Allow the selection of a given iommu backend
Date:   Tue, 31 Jan 2023 21:53:05 +0100
Message-Id: <20230131205305.2726330-19-eric.auger@redhat.com>
In-Reply-To: <20230131205305.2726330-1-eric.auger@redhat.com>
References: <20230131205305.2726330-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now we support two types of iommu backends, let's add the capability
to select one of them. This depends on whether an iommufd object has
been linked with the vfio-pci device:

if the user wants to use the legacy backend, it shall not
link the vfio-pci device with any iommufd object:

-device vfio-pci,host=0000:02:00.0

This is called the legacy mode/backend.

If the user wants to use the iommufd backend (/dev/iommu) it
shall pass an iommufd object id in the vfio-pci device options:

 -object iommufd,id=iommufd0
 -device vfio-pci,host=0000:02:00.0,iommufd=iommufd0

Note the /dev/iommu device may have been pre-opened by a
management tool such as libvirt. This mode is no more considered
for the legacy backend. So let's remove the "TODO" comment.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
---
 hw/vfio/pci.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 8689b3053c..ebf8f8ca83 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -42,6 +42,7 @@
 #include "qapi/error.h"
 #include "migration/blocker.h"
 #include "migration/qemu-file.h"
+#include "sysemu/iommufd.h"
 
 #define TYPE_VFIO_PCI_NOHOTPLUG "vfio-pci-nohotplug"
 
@@ -2852,6 +2853,13 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     int i, ret;
     bool is_mdev;
 
+    if (vbasedev->iommufd) {
+        iommufd_backend_connect(vbasedev->iommufd, errp);
+        if (*errp) {
+            return;
+        }
+    }
+
     if (!vbasedev->sysfsdev) {
         if (!(~vdev->host.domain || ~vdev->host.bus ||
               ~vdev->host.slot || ~vdev->host.function)) {
@@ -3134,6 +3142,7 @@ error:
 static void vfio_instance_finalize(Object *obj)
 {
     VFIOPCIDevice *vdev = VFIO_PCI(obj);
+    VFIODevice *vbasedev = &vdev->vbasedev;
 
     vfio_display_finalize(vdev);
     vfio_bars_finalize(vdev);
@@ -3146,6 +3155,9 @@ static void vfio_instance_finalize(Object *obj)
      *
      * g_free(vdev->igd_opregion);
      */
+    if (vbasedev->iommufd) {
+        iommufd_backend_disconnect(vbasedev->iommufd);
+    }
     vfio_put_device(vdev);
 }
 
@@ -3281,11 +3293,8 @@ static Property vfio_pci_dev_properties[] = {
                                    qdev_prop_nv_gpudirect_clique, uint8_t),
     DEFINE_PROP_OFF_AUTO_PCIBAR("x-msix-relocation", VFIOPCIDevice, msix_relo,
                                 OFF_AUTOPCIBAR_OFF),
-    /*
-     * TODO - support passed fds... is this necessary?
-     * DEFINE_PROP_STRING("vfiofd", VFIOPCIDevice, vfiofd_name),
-     * DEFINE_PROP_STRING("vfiogroupfd, VFIOPCIDevice, vfiogroupfd_name),
-     */
+    DEFINE_PROP_LINK("iommufd", VFIOPCIDevice, vbasedev.iommufd,
+                     TYPE_IOMMUFD_BACKEND, IOMMUFDBackend *),
     DEFINE_PROP_END_OF_LIST(),
 };
 
-- 
2.37.3

