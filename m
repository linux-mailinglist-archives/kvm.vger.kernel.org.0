Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8DC611FBB2
	for <lists+kvm@lfdr.de>; Sun, 15 Dec 2019 23:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfLOWqo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Dec 2019 17:46:44 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21065 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726260AbfLOWqo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 15 Dec 2019 17:46:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576450001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1mDIE4yV3gO3GJ7uJlLH28+/Nf2ichtTQZHkkl1glyU=;
        b=a8qvtYqeFwhPYmhoXStIZTYhPglTgps1uy3K6ySNu8OIhSXgHZJpnTEFrMTPDtTe0rPqLo
        8oLbxNWXPSLkun5ed0Svr52TyZMTo4OXE8OGeC3KbO5VW4+nu6nl4KA/tKKwF0Zbx8jR2p
        SEQZ5EfL/3H4JO6Vt5/bUWEYz08vXKs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-d_asFhl3Mf-K3i5jWDHGsg-1; Sun, 15 Dec 2019 17:46:39 -0500
X-MC-Unique: d_asFhl3Mf-K3i5jWDHGsg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A79A6593A0;
        Sun, 15 Dec 2019 22:46:37 +0000 (UTC)
Received: from x1.home (ovpn-116-53.phx2.redhat.com [10.3.116.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20B7D6046C;
        Sun, 15 Dec 2019 22:46:34 +0000 (UTC)
Date:   Sun, 15 Dec 2019 15:46:33 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     kwankhede@nvidia.com, kevin.tian@intel.com,
        baolu.lu@linux.intel.com, yi.y.sun@intel.com, joro@8bytes.org,
        jean-philippe.brucker@arm.com, peterx@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 08/10] vfio/pci: protect cap/ecap_perm bits
 alloc/free
Message-ID: <20191215154633.4641b05e@x1.home>
In-Reply-To: <1574335427-3763-9-git-send-email-yi.l.liu@intel.com>
References: <1574335427-3763-1-git-send-email-yi.l.liu@intel.com>
        <1574335427-3763-9-git-send-email-yi.l.liu@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Nov 2019 19:23:45 +0800
Liu Yi L <yi.l.liu@intel.com> wrote:

> This patch add a user numer track for the shared cap/ecap_perms bits,
> and the alloc/free will hold a semaphore to protect the operations.
> With the changes, first caller of vfio_pci_init_perm_bits() will
> initialize the bits. While the last caller of vfio_pci_uninit_perm_bits()
> will free the bits. This is a preparation to have multiple cap/ecap_perms
> bits users.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c | 33 +++++++++++++++++++++++++++++++--
>  1 file changed, 31 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index f0891bd..274c993 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -36,6 +36,13 @@
>  	 (offset >= PCI_ROM_ADDRESS && offset < PCI_ROM_ADDRESS + 4))
>  
>  /*
> + * vfio_perm_bits_sem: prorects the shared perm_bits alloc/free
> + * vfio_pci_perm_bits_users: tracks the user of the shared perm_bits
> + */
> +static DEFINE_SEMAPHORE(vfio_perm_bits_sem);
> +static int vfio_pci_perm_bits_users;
> +
> +/*
>   * Lengths of PCI Config Capabilities
>   *   0: Removed from the user visible capability list
>   *   FF: Variable length
> @@ -995,7 +1002,7 @@ static int __init init_pci_ext_cap_pwr_perm(struct perm_bits *perm)
>  /*
>   * Initialize the shared permission tables
>   */
> -void vfio_pci_uninit_perm_bits(void)
> +static void vfio_pci_uninit_perm_bits_internal(void)
>  {
>  	free_perm_bits(&cap_perms[PCI_CAP_ID_BASIC]);
>  
> @@ -1009,10 +1016,30 @@ void vfio_pci_uninit_perm_bits(void)
>  	free_perm_bits(&ecap_perms[PCI_EXT_CAP_ID_PWR]);
>  }
>  
> +void vfio_pci_uninit_perm_bits(void)
> +{
> +	down(&vfio_perm_bits_sem);
> +
> +	if (--vfio_pci_perm_bits_users > 0)
> +		goto out;
> +
> +	vfio_pci_uninit_perm_bits_internal();
> +
> +out:
> +	up(&vfio_perm_bits_sem);
> +}
> +
>  int __init vfio_pci_init_perm_bits(void)
>  {
>  	int ret;
>  
> +	down(&vfio_perm_bits_sem);
> +
> +	if (++vfio_pci_perm_bits_users > 1) {
> +		ret = 0;
> +		goto out;
> +	}
> +
>  	/* Basic config space */
>  	ret = init_pci_cap_basic_perm(&cap_perms[PCI_CAP_ID_BASIC]);
>  
> @@ -1030,8 +1057,10 @@ int __init vfio_pci_init_perm_bits(void)
>  	ecap_perms[PCI_EXT_CAP_ID_VNDR].writefn = vfio_raw_config_write;
>  
>  	if (ret)
> -		vfio_pci_uninit_perm_bits();
> +		vfio_pci_uninit_perm_bits_internal();
>  
> +out:
> +	up(&vfio_perm_bits_sem);
>  	return ret;
>  }
>  

Hi Yi,

Sorry for slowness in providing feedback on this series.  If we
provided a vfio-pci-common module that vfio-pci and vfio-mdev-pci
depend on, doesn't this entire problem go away?  I played a little bit
with this in the crude patch below, it seems to work.  To finish this,
I think we'd move the function declarations out of the "private" header
file and into one under include/linux, then we could also move
vfio_mdev_pci.c to the samples directory like we intended originally.
I know you had tried to link things from samples and it didn't work,
but is the below a better attempt at resolving this?  It commits us to
exporting a bunch of functions, we'll need to decide whether that's a
good idea.  Thanks,

Alex

(patch applies to 5.4 + this series, thus includes a revert of this patch)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index ac3c1dd3edef..1a1fb3b7fd46 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -1,9 +1,14 @@
 # SPDX-License-Identifier: GPL-2.0-only
-config VFIO_PCI
-	tristate "VFIO support for PCI devices"
+
+config VFIO_PCI_COMMON
 	depends on VFIO && PCI && EVENTFD
 	select VFIO_VIRQFD
 	select IRQ_BYPASS_MANAGER
+	tristate
+
+config VFIO_PCI
+	tristate "VFIO support for PCI devices"
+	select VFIO_PCI_COMMON
 	help
 	  Support for the PCI VFIO bus driver.  This is required to make
 	  use of PCI drivers using the VFIO framework.
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index ac118ef246a4..9f599cb6e207 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -1,14 +1,13 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-vfio-pci-y := vfio_pci.o vfio_pci_common.o vfio_pci_intrs.o \
+vfio-pci-common-y := vfio_pci_common.o vfio_pci_intrs.o \
 		vfio_pci_rdwr.o vfio_pci_config.o
-vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
-vfio-pci-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2.o
+vfio-pci-common-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
+vfio-pci-common-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2.o
 
-vfio-mdev-pci-y := vfio_mdev_pci.o vfio_pci_common.o vfio_pci_intrs.o \
-			vfio_pci_rdwr.o vfio_pci_config.o
-vfio-mdev-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
-vfio-mdev-pci-$(CONFIG_VFIO_PCI_NVLINK2) += vfio_pci_nvlink2.o
+vfio-pci-y := vfio_pci.o
+vfio-mdev-pci-y := vfio_mdev_pci.o
 
+obj-$(CONFIG_VFIO_PCI_COMMON) += vfio-pci-common.o
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
 obj-$(CONFIG_SAMPLE_VFIO_MDEV_PCI) += vfio-mdev-pci.o
diff --git a/drivers/vfio/pci/vfio_mdev_pci.c b/drivers/vfio/pci/vfio_mdev_pci.c
index a1f62cf30d08..e6b070ff84ac 100644
--- a/drivers/vfio/pci/vfio_mdev_pci.c
+++ b/drivers/vfio/pci/vfio_mdev_pci.c
@@ -390,35 +390,26 @@ static struct pci_driver vfio_mdev_pci_driver = {
 	.id_table	= NULL, /* only dynamic ids */
 	.probe		= vfio_mdev_pci_driver_probe,
 	.remove		= vfio_mdev_pci_driver_remove,
-	.err_handler	= &vfio_err_handlers,
+	.err_handler	= &vfio_pci_err_handlers,
 };
 
 static void __exit vfio_mdev_pci_cleanup(void)
 {
 	pci_unregister_driver(&vfio_mdev_pci_driver);
-	vfio_pci_uninit_perm_bits();
 }
 
 static int __init vfio_mdev_pci_init(void)
 {
 	int ret;
 
-	/* Allocate shared config space permision data used by all devices */
-	ret = vfio_pci_init_perm_bits();
-	if (ret)
-		return ret;
-
 	/* Register and scan for devices */
 	ret = pci_register_driver(&vfio_mdev_pci_driver);
 	if (ret)
-		goto out_driver;
+		return ret;
 
 	vfio_pci_fill_ids(ids, &vfio_mdev_pci_driver);
 
 	return 0;
-out_driver:
-	vfio_pci_uninit_perm_bits();
-	return ret;
 }
 
 module_init(vfio_mdev_pci_init);
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 7e24da25f176..704766714c11 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -225,36 +225,26 @@ static struct pci_driver vfio_pci_driver = {
 	.id_table	= NULL, /* only dynamic ids */
 	.probe		= vfio_pci_probe,
 	.remove		= vfio_pci_remove,
-	.err_handler	= &vfio_err_handlers,
+	.err_handler	= &vfio_pci_err_handlers,
 };
 
 static void __exit vfio_pci_cleanup(void)
 {
 	pci_unregister_driver(&vfio_pci_driver);
-	vfio_pci_uninit_perm_bits();
 }
 
 static int __init vfio_pci_init(void)
 {
 	int ret;
 
-	/* Allocate shared config space permision data used by all devices */
-	ret = vfio_pci_init_perm_bits();
-	if (ret)
-		return ret;
-
 	/* Register and scan for devices */
 	ret = pci_register_driver(&vfio_pci_driver);
 	if (ret)
-		goto out_driver;
+		return ret;
 
 	vfio_pci_fill_ids(ids, &vfio_pci_driver);
 
 	return 0;
-
-out_driver:
-	vfio_pci_uninit_perm_bits();
-	return ret;
 }
 
 module_init(vfio_pci_init);
diff --git a/drivers/vfio/pci/vfio_pci_common.c b/drivers/vfio/pci/vfio_pci_common.c
index 42b46d040cb4..dd6f8fd208ce 100644
--- a/drivers/vfio/pci/vfio_pci_common.c
+++ b/drivers/vfio/pci/vfio_pci_common.c
@@ -30,6 +30,10 @@
 
 #include "vfio_pci_private.h"
 
+#define DRIVER_VERSION  "0.2"
+#define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
+#define DRIVER_DESC     "VFIO PCI Common"
+
 /*
  * Our VGA arbiter participation is limited since we don't know anything
  * about the device itself.  However, if the device is the only VGA device
@@ -69,6 +73,7 @@ unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga)
 
 	return decodes;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_set_vga_decode);
 
 static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
 {
@@ -181,6 +186,7 @@ void vfio_pci_probe_power_state(struct vfio_pci_device *vdev)
 
 	vdev->needs_pm_restore = !(pmcsr & PCI_PM_CTRL_NO_SOFT_RESET);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_probe_power_state);
 
 /*
  * pci_set_power_state() wrapper handling devices which perform a soft reset on
@@ -219,6 +225,7 @@ int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_set_power_state);
 
 int vfio_pci_enable(struct vfio_pci_device *vdev)
 {
@@ -326,6 +333,7 @@ int vfio_pci_enable(struct vfio_pci_device *vdev)
 	vfio_pci_disable(vdev);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_enable);
 
 void vfio_pci_disable(struct vfio_pci_device *vdev)
 {
@@ -424,6 +432,7 @@ void vfio_pci_disable(struct vfio_pci_device *vdev)
 	if (!vdev->disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D3hot);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_disable);
 
 void vfio_pci_refresh_config(struct vfio_pci_device *vdev,
 			bool nointxmask, bool disable_idle_d3)
@@ -431,6 +440,7 @@ void vfio_pci_refresh_config(struct vfio_pci_device *vdev,
 	vdev->nointxmask = nointxmask;
 	vdev->disable_idle_d3 = disable_idle_d3;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_refresh_config);
 
 static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
 {
@@ -615,6 +625,7 @@ int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_register_dev_region);
 
 long vfio_pci_ioctl(void *device_data,
 		   unsigned int cmd, unsigned long arg)
@@ -1069,6 +1080,7 @@ long vfio_pci_ioctl(void *device_data,
 
 	return -ENOTTY;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_ioctl);
 
 static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
@@ -1110,6 +1122,7 @@ ssize_t vfio_pci_read(void *device_data, char __user *buf,
 
 	return vfio_pci_rw(device_data, buf, count, ppos, false);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_read);
 
 ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 			      size_t count, loff_t *ppos)
@@ -1119,6 +1132,7 @@ ssize_t vfio_pci_write(void *device_data, const char __user *buf,
 
 	return vfio_pci_rw(device_data, (char __user *)buf, count, ppos, true);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_write);
 
 int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 {
@@ -1181,6 +1195,7 @@ int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
 			       req_len, vma->vm_page_prot);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_mmap);
 
 void vfio_pci_request(void *device_data, unsigned int count)
 {
@@ -1202,6 +1217,7 @@ void vfio_pci_request(void *device_data, unsigned int count)
 
 	mutex_unlock(&vdev->igate);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_request);
 
 static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 						  pci_channel_state_t state)
@@ -1231,9 +1247,10 @@ static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 	return PCI_ERS_RESULT_CAN_RECOVER;
 }
 
-const struct pci_error_handlers vfio_err_handlers = {
+const struct pci_error_handlers vfio_pci_err_handlers = {
 	.error_detected = vfio_pci_aer_err_detected,
 };
+EXPORT_SYMBOL_GPL(vfio_pci_err_handlers);
 
 static DEFINE_MUTEX(reflck_lock);
 
@@ -1300,6 +1317,7 @@ int vfio_pci_reflck_attach(struct vfio_pci_device *vdev)
 
 	return PTR_ERR_OR_ZERO(vdev->reflck);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_reflck_attach);
 
 static void vfio_pci_reflck_release(struct kref *kref)
 {
@@ -1315,6 +1333,7 @@ void vfio_pci_reflck_put(struct vfio_pci_reflck *reflck)
 {
 	kref_put_mutex(&reflck->kref, vfio_pci_reflck_release, &reflck_lock);
 }
+EXPORT_SYMBOL_GPL(vfio_pci_reflck_put);
 
 struct vfio_devices {
 	struct vfio_device **devices;
@@ -1429,7 +1448,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
 	kfree(devs.devices);
 }
 
-void __init vfio_pci_fill_ids(char *ids, struct pci_driver *driver)
+void vfio_pci_fill_ids(char *ids, struct pci_driver *driver)
 {
 	char *p, *id;
 	int rc;
@@ -1469,3 +1488,22 @@ void __init vfio_pci_fill_ids(char *ids, struct pci_driver *driver)
 				class, class_mask);
 	}
 }
+EXPORT_SYMBOL_GPL(vfio_pci_fill_ids);
+
+static int __init vfio_pci_common_init(void)
+{
+	/* Allocate shared config space permision data used by all devices */
+	return vfio_pci_init_perm_bits();
+}
+module_init(vfio_pci_common_init);
+
+static void __exit vfio_pci_common_exit(void)
+{
+	vfio_pci_uninit_perm_bits();
+}
+module_exit(vfio_pci_common_exit);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 274c99311edc..f0891bd8444c 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -35,13 +35,6 @@
 	((offset >= PCI_BASE_ADDRESS_0 && offset < PCI_BASE_ADDRESS_5 + 4) || \
 	 (offset >= PCI_ROM_ADDRESS && offset < PCI_ROM_ADDRESS + 4))
 
-/*
- * vfio_perm_bits_sem: prorects the shared perm_bits alloc/free
- * vfio_pci_perm_bits_users: tracks the user of the shared perm_bits
- */
-static DEFINE_SEMAPHORE(vfio_perm_bits_sem);
-static int vfio_pci_perm_bits_users;
-
 /*
  * Lengths of PCI Config Capabilities
  *   0: Removed from the user visible capability list
@@ -1002,7 +995,7 @@ static int __init init_pci_ext_cap_pwr_perm(struct perm_bits *perm)
 /*
  * Initialize the shared permission tables
  */
-static void vfio_pci_uninit_perm_bits_internal(void)
+void vfio_pci_uninit_perm_bits(void)
 {
 	free_perm_bits(&cap_perms[PCI_CAP_ID_BASIC]);
 
@@ -1016,30 +1009,10 @@ static void vfio_pci_uninit_perm_bits_internal(void)
 	free_perm_bits(&ecap_perms[PCI_EXT_CAP_ID_PWR]);
 }
 
-void vfio_pci_uninit_perm_bits(void)
-{
-	down(&vfio_perm_bits_sem);
-
-	if (--vfio_pci_perm_bits_users > 0)
-		goto out;
-
-	vfio_pci_uninit_perm_bits_internal();
-
-out:
-	up(&vfio_perm_bits_sem);
-}
-
 int __init vfio_pci_init_perm_bits(void)
 {
 	int ret;
 
-	down(&vfio_perm_bits_sem);
-
-	if (++vfio_pci_perm_bits_users > 1) {
-		ret = 0;
-		goto out;
-	}
-
 	/* Basic config space */
 	ret = init_pci_cap_basic_perm(&cap_perms[PCI_CAP_ID_BASIC]);
 
@@ -1057,10 +1030,8 @@ int __init vfio_pci_init_perm_bits(void)
 	ecap_perms[PCI_EXT_CAP_ID_VNDR].writefn = vfio_raw_config_write;
 
 	if (ret)
-		vfio_pci_uninit_perm_bits_internal();
+		vfio_pci_uninit_perm_bits();
 
-out:
-	up(&vfio_perm_bits_sem);
 	return ret;
 }
 
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 5d1739460559..562b7c1c06f7 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -135,7 +135,7 @@ struct vfio_pci_device {
 #define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
 #define irq_is(vdev, type) (vdev->irq_type == type)
 
-extern const struct pci_error_handlers vfio_err_handlers;
+extern const struct pci_error_handlers vfio_pci_err_handlers;
 
 static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 {
diff --git a/samples/Kconfig b/samples/Kconfig
index 1513feff0255..97c1cc07f657 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -171,9 +171,7 @@ config SAMPLE_VFS
 
 config SAMPLE_VFIO_MDEV_PCI
 	tristate "Sample driver for wrapping PCI device as a mdev"
-	depends on PCI && EVENTFD && VFIO_MDEV_DEVICE
-	select VFIO_VIRQFD
-	select IRQ_BYPASS_MANAGER
+	select VFIO_PCI_COMMON
 	help
 	  Sample driver for wrapping a PCI device as a mdev. Once bound to
 	  this driver, device passthru should through mdev path.

