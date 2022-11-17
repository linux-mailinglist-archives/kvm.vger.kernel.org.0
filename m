Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5980362E5B0
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 21:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240517AbiKQUP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 15:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240368AbiKQUPw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 15:15:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BD931369
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 12:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668716096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JK4ai078+KOKnWAxhgDzS1fGTGm86wmNjjf3ufBXQKM=;
        b=A7qpV876UQIJxz0OuOf8sxGHYMUxyK5ux+NU+3+GXSyj/5YpMysybV5wHoC+xPEfHqrE6Z
        0WlbI9AouoCTQY6+o+MMPmGjj0hl3bpq2lDHoXRFKHV4zy2Oiv7ewaMvGK5m2X9q6xm2Eg
        eqq4/9xMKNCq1JVmZg6yOEdZzOubepI=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-653-JD3G0tbnNx69ASZCHSTEfg-1; Thu, 17 Nov 2022 15:14:54 -0500
X-MC-Unique: JD3G0tbnNx69ASZCHSTEfg-1
Received: by mail-io1-f69.google.com with SMTP id w16-20020a6b4a10000000b006a5454c789eso1479731iob.20
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 12:14:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JK4ai078+KOKnWAxhgDzS1fGTGm86wmNjjf3ufBXQKM=;
        b=r1W8hocQBRwNdFkETm9ywkWxyZRBXgq7bupcEn2byXAe92gH2oeNZlEZJRnQptS+Oy
         lTeYOuAypYBSyO9B1FglP8i7FnnEmvDVWLZG19fX7t9PiqFASLU8NtZFMlT0wv0Ss40x
         ObtvFA7/at8msKnqjoeAMpjAnDZNDs/wWACJ8sB7YAoTM8r65Ta4fT8IeSPMpKsHGvOQ
         J2/KN06gkw0qyc0409XsPVTC/wVrS848NWnHMYUX2G/ayXUsrY/TcOwlt1ZIfbGVDUpl
         XOy6Mq5zhhxjwHgRLui7wGBEh4G9qZ3IMxF8Hyp9ffgnj04jPqSdKZmTr7j7LncZHc8d
         P1vA==
X-Gm-Message-State: ANoB5plg5OfTgrYVpMXNayY1SABgc9XnJ0PHe1kY0tqA1qq4wsLP9RdH
        WWxOITnxE5Vk3UCWmh/JwruzaGiz/jrnsYU0t96+bZ9muJcBprcXuwIFSUhZik3BWOllON/38Nz
        /NEBS1Jc5FUQp
X-Received: by 2002:a92:1902:0:b0:2f9:8a1e:914b with SMTP id 2-20020a921902000000b002f98a1e914bmr2000280ilz.259.1668716094169;
        Thu, 17 Nov 2022 12:14:54 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6sxJxU9hbW9SOa2xrjWxVkJlk7ChnOe1tzHJAYG2zy32p7kesTKB6r9Cgh7eZrtadRdtumxQ==
X-Received: by 2002:a92:1902:0:b0:2f9:8a1e:914b with SMTP id 2-20020a921902000000b002f98a1e914bmr2000269ilz.259.1668716093909;
        Thu, 17 Nov 2022 12:14:53 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m27-20020a026d1b000000b00374f8a0ed3csm550504jac.103.2022.11.17.12.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 12:14:53 -0800 (PST)
Date:   Thu, 17 Nov 2022 13:14:51 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: Re: [PATCH v3 04/11] vfio: Move storage of allow_unsafe_interrupts
 to vfio_main.c
Message-ID: <20221117131451.7d884cdc.alex.williamson@redhat.com>
In-Reply-To: <4-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
        <4-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Nov 2022 17:05:29 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This legacy module knob has become uAPI, when set on the vfio_iommu_type1
> it disables some security protections in the iommu drivers. Move the
> storage for this knob to vfio_main.c so that iommufd can access it too.
> 
> The may need enhancing as we learn more about how necessary
> allow_unsafe_interrupts is in the current state of the world. If vfio
> container is disabled then this option will not be available to the user.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Yi Liu <yi.l.liu@intel.com>
> Tested-by: Lixiao Yang <lixiao.yang@intel.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Yu He <yu.he@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.h             | 2 ++
>  drivers/vfio/vfio_iommu_type1.c | 5 ++---
>  drivers/vfio/vfio_main.c        | 3 +++
>  3 files changed, 7 insertions(+), 3 deletions(-)

It's really quite trivial to convert to a vfio_iommu.ko module to host
a separate option for this.  Half of the patch below is undoing what's
done here.  Is your only concern with this approach that we use a few
KB more memory for the separate module?

I don't think a per-device sysfs setting makes a lot of sense, if we're
on a host w/o MSI isolation, all devices are affected.  Thanks,

Alex


 Makefile           |    4 +++-
 iommufd.c          |   12 +++++++++++-
 vfio.h             |    2 --
 vfio_iommu_type1.c |    5 +++--
 vfio_main.c        |    6 +++---
 5 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index b953517dc70f..34b7d91112e5 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -5,9 +5,11 @@ obj-$(CONFIG_VFIO) += vfio.o
 
 vfio-y += vfio_main.o \
 	  iova_bitmap.o
-vfio-$(CONFIG_IOMMUFD) += iommufd.o
 vfio-$(CONFIG_VFIO_CONTAINER) += container.o
 
+obj-$(CONFIG_IOMMUFD) += vfio_iommufd.o
+vfio_iommufd-y += iommufd.o
+
 obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
 obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
 obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index dad8935d71f7..b6b4038ba036 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -10,6 +10,12 @@
 MODULE_IMPORT_NS(IOMMUFD);
 MODULE_IMPORT_NS(IOMMUFD_VFIO);
 
+static bool allow_unsafe_interrupts;
+module_param_named(allow_unsafe_interrupts,
+		   allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(allow_unsafe_interrupts,
+		 "Enable VFIO IOMMUFD support on platforms without MSI/X isolation facilities.");
+
 int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 {
 	u32 ioas_id;
@@ -47,6 +53,7 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
 		vdev->ops->unbind_iommufd(vdev);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_iommufd_bind);
 
 void vfio_iommufd_unbind(struct vfio_device *vdev)
 {
@@ -55,6 +62,7 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
 	if (vdev->ops->unbind_iommufd)
 		vdev->ops->unbind_iommufd(vdev);
 }
+EXPORT_SYMBOL_GPL(vfio_iommufd_unbind);
 
 /*
  * The physical standard ops mean that the iommufd_device is bound to the
@@ -92,7 +100,7 @@ int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
 	unsigned int flags = 0;
 	int rc;
 
-	if (vfio_allow_unsafe_interrupts)
+	if (allow_unsafe_interrupts)
 		flags |= IOMMUFD_ATTACH_FLAGS_ALLOW_UNSAFE_INTERRUPT;
 	rc = iommufd_device_attach(vdev->iommufd_device, pt_id, flags);
 	if (rc)
@@ -159,3 +167,5 @@ int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_iommufd_emulated_attach_ioas);
+
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 3378714a7462..ce5fe3fc493b 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -216,6 +216,4 @@ extern bool vfio_noiommu __read_mostly;
 enum { vfio_noiommu = false };
 #endif
 
-extern bool vfio_allow_unsafe_interrupts;
-
 #endif
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 186e33a006d3..23c24fe98c00 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -44,8 +44,9 @@
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
 #define DRIVER_DESC     "Type1 IOMMU driver for VFIO"
 
+static bool allow_unsafe_interrupts;
 module_param_named(allow_unsafe_interrupts,
-		   vfio_allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
+		   allow_unsafe_interrupts, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(allow_unsafe_interrupts,
 		 "Enable VFIO IOMMU support for on platforms without interrupt remapping support.");
 
@@ -2281,7 +2282,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		    iommu_group_for_each_dev(iommu_group, (void *)IOMMU_CAP_INTR_REMAP,
 					     vfio_iommu_device_capable);
 
-	if (!vfio_allow_unsafe_interrupts && !msi_remap) {
+	if (!allow_unsafe_interrupts && !msi_remap) {
 		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
 		       __func__);
 		ret = -EPERM;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index f3c48b8c4562..48b3aa8582aa 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -42,6 +42,9 @@
 #define DRIVER_AUTHOR	"Alex Williamson <alex.williamson@redhat.com>"
 #define DRIVER_DESC	"VFIO - User Level meta-driver"
 
+MODULE_IMPORT_NS(IOMMUFD);
+MODULE_IMPORT_NS(IOMMUFD_VFIO);
+
 static struct vfio {
 	struct class			*class;
 	struct list_head		group_list;
@@ -52,9 +55,6 @@ static struct vfio {
 	struct ida			device_ida;
 } vfio;
 
-bool vfio_allow_unsafe_interrupts;
-EXPORT_SYMBOL_GPL(vfio_allow_unsafe_interrupts);
-
 static DEFINE_XARRAY(vfio_device_set_xa);
 static const struct file_operations vfio_group_fops;
 

