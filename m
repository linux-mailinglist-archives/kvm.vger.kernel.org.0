Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 672B313637B
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 23:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729574AbgAIWss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 17:48:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33959 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729555AbgAIWsr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 17:48:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578610126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cNp9+eI9bd4l6L0fnKNGDWaGwy3Bc+YaQcs2zVT5MjE=;
        b=inAqhF+8SHs4pS5XZac5jLfl8LUdxJWTv3Q8WQOp442pgeU4/S6inrp2pmpWb+910ZYwbN
        llEW1AGQY9CALqz421WcA1UxR04Zg9dPWBufMpo/OJbTePsfK2A/P5fBcmfFupMVu3Ikwi
        lA6Qf8bmWkUukcSCDRRhMdWjvBYBjOI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-xS-f0i8sNeqP9ogrX0y32g-1; Thu, 09 Jan 2020 17:48:45 -0500
X-MC-Unique: xS-f0i8sNeqP9ogrX0y32g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 236AE189DF43;
        Thu,  9 Jan 2020 22:48:44 +0000 (UTC)
Received: from w520.home (ovpn-116-128.phx2.redhat.com [10.3.116.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93FFE7D979;
        Thu,  9 Jan 2020 22:48:43 +0000 (UTC)
Date:   Thu, 9 Jan 2020 15:48:21 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     kwankhede@nvidia.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kevin.tian@intel.com, joro@8bytes.org,
        peterx@redhat.com, baolu.lu@linux.intel.com
Subject: Re: [PATCH v4 01/12] vfio_pci: refine user config reference in
 vfio-pci module
Message-ID: <20200109154821.047f700a@w520.home>
In-Reply-To: <1578398509-26453-2-git-send-email-yi.l.liu@intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
        <1578398509-26453-2-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Jan 2020 20:01:38 +0800
Liu Yi L <yi.l.liu@intel.com> wrote:

> This patch adds three fields in struct vfio_pci_device to pass the user
> configurations of vfio-pci.ko module to some functions which could be
> common in future usage. The values stored in struct vfio_pci_device will
> be initiated in probe and refreshed in device open phase to allow runtime
> modifications to parameters. e.g. disable_idle_d3 and nointxmask.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci.c         | 37 ++++++++++++++++++++++++++-----------
>  drivers/vfio/pci/vfio_pci_private.h |  8 ++++++++
>  2 files changed, 34 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 379a02c..af507c2 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -54,10 +54,10 @@ module_param(disable_idle_d3, bool, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(disable_idle_d3,
>  		 "Disable using the PCI D3 low power state for idle, unused devices");
>  
> -static inline bool vfio_vga_disabled(void)
> +static inline bool vfio_vga_disabled(struct vfio_pci_device *vdev)
>  {
>  #ifdef CONFIG_VFIO_PCI_VGA
> -	return disable_vga;
> +	return vdev->disable_vga;
>  #else
>  	return true;
>  #endif
> @@ -78,7 +78,8 @@ static unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga)
>  	unsigned char max_busnr;
>  	unsigned int decodes;
>  
> -	if (single_vga || !vfio_vga_disabled() || pci_is_root_bus(pdev->bus))
> +	if (single_vga || !vfio_vga_disabled(vdev) ||
> +		pci_is_root_bus(pdev->bus))
>  		return VGA_RSRC_NORMAL_IO | VGA_RSRC_NORMAL_MEM |
>  		       VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM;
>  
> @@ -289,7 +290,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
>  	if (!vdev->pci_saved_state)
>  		pci_dbg(pdev, "%s: Couldn't store saved state\n", __func__);
>  
> -	if (likely(!nointxmask)) {
> +	if (likely(!vdev->nointxmask)) {
>  		if (vfio_pci_nointx(pdev)) {
>  			pci_info(pdev, "Masking broken INTx support\n");
>  			vdev->nointx = true;
> @@ -326,7 +327,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
>  	} else
>  		vdev->msix_bar = 0xFF;
>  
> -	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
> +	if (!vfio_vga_disabled(vdev) && vfio_pci_is_vga(pdev))
>  		vdev->has_vga = true;
>  
>  
> @@ -462,10 +463,17 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
>  
>  	vfio_pci_try_bus_reset(vdev);
>  
> -	if (!disable_idle_d3)
> +	if (!vdev->disable_idle_d3)
>  		vfio_pci_set_power_state(vdev, PCI_D3hot);
>  }
>  
> +void vfio_pci_refresh_config(struct vfio_pci_device *vdev,
> +			bool nointxmask, bool disable_idle_d3)
> +{
> +	vdev->nointxmask = nointxmask;
> +	vdev->disable_idle_d3 = disable_idle_d3;

These two are selected (not disable_vga) because they're the only
writable module options, correct?

> +}
> +
>  static void vfio_pci_release(void *device_data)
>  {
>  	struct vfio_pci_device *vdev = device_data;
> @@ -490,6 +498,8 @@ static int vfio_pci_open(void *device_data)
>  	if (!try_module_get(THIS_MODULE))
>  		return -ENODEV;
>  
> +	vfio_pci_refresh_config(vdev, nointxmask, disable_idle_d3);
> +
>  	mutex_lock(&vdev->reflck->lock);
>  
>  	if (!vdev->refcnt) {
> @@ -1330,6 +1340,11 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	spin_lock_init(&vdev->irqlock);
>  	mutex_init(&vdev->ioeventfds_lock);
>  	INIT_LIST_HEAD(&vdev->ioeventfds_list);
> +	vdev->nointxmask = nointxmask;
> +#ifdef CONFIG_VFIO_PCI_VGA
> +	vdev->disable_vga = disable_vga;
> +#endif
> +	vdev->disable_idle_d3 = disable_idle_d3;

But this could still use vfio_pci_refresh_config() for those writable
options and set disable_vga separately, couldn't it?  Also, since
disable_idle_d3 is related to power handling of the device while it is
not opened by the user, shouldn't the config also be refreshed when the
device is released by the user?

>  
>  	ret = vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
>  	if (ret) {
> @@ -1354,7 +1369,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	vfio_pci_probe_power_state(vdev);
>  
> -	if (!disable_idle_d3) {
> +	if (!vdev->disable_idle_d3) {
>  		/*
>  		 * pci-core sets the device power state to an unknown value at
>  		 * bootup and after being removed from a driver.  The only
> @@ -1385,7 +1400,7 @@ static void vfio_pci_remove(struct pci_dev *pdev)
>  	kfree(vdev->region);
>  	mutex_destroy(&vdev->ioeventfds_lock);
>  
> -	if (!disable_idle_d3)
> +	if (!vdev->disable_idle_d3)
>  		vfio_pci_set_power_state(vdev, PCI_D0);
>  
>  	kfree(vdev->pm_save);
> @@ -1620,7 +1635,7 @@ static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
>  		if (!ret) {
>  			tmp->needs_reset = false;
>  
> -			if (tmp != vdev && !disable_idle_d3)
> +			if (tmp != vdev && !tmp->disable_idle_d3)
>  				vfio_pci_set_power_state(tmp, PCI_D3hot);
>  		}
>  
> @@ -1636,7 +1651,7 @@ static void __exit vfio_pci_cleanup(void)
>  	vfio_pci_uninit_perm_bits();
>  }
>  
> -static void __init vfio_pci_fill_ids(void)
> +static void __init vfio_pci_fill_ids(char *ids)

This might be more clear if the global was also renamed vfio_pci_ids.

>  {
>  	char *p, *id;
>  	int rc;
> @@ -1691,7 +1706,7 @@ static int __init vfio_pci_init(void)
>  	if (ret)
>  		goto out_driver;
>  
> -	vfio_pci_fill_ids();
> +	vfio_pci_fill_ids(ids);
>  
>  	return 0;
>  
> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> index 8a2c760..0398608 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -122,6 +122,11 @@ struct vfio_pci_device {
>  	struct list_head	dummy_resources_list;
>  	struct mutex		ioeventfds_lock;
>  	struct list_head	ioeventfds_list;
> +	bool			nointxmask;
> +#ifdef CONFIG_VFIO_PCI_VGA
> +	bool			disable_vga;
> +#endif
> +	bool			disable_idle_d3;

It seems like there are more relevant places these could be within this
structure, ex. nointxmask next to nointx, disable_vga near has_vga,
disable_idle_d3 maybe near needs_pm_restore (even though those aren't
conceptually related).  Not necessarily related to this series, it
might be time to convert the existing bools to bit fields, but even
before that the alignment of adding these as bools grouped with the
existing bools is probably better.  Thanks,

Alex

>  };
>  
>  #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
> @@ -130,6 +135,9 @@ struct vfio_pci_device {
>  #define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
>  #define irq_is(vdev, type) (vdev->irq_type == type)
>  
> +extern void vfio_pci_refresh_config(struct vfio_pci_device *vdev,
> +				bool nointxmask, bool disable_idle_d3);
> +
>  extern void vfio_pci_intx_mask(struct vfio_pci_device *vdev);
>  extern void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
>  

