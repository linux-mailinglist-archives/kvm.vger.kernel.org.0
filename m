Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89493568E2D
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 17:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbiGFPtP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 11:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234569AbiGFPtB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 11:49:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6031BB6
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 08:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657122128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NwxK+LJ4YwtJcqot7ZiGKZWRmu6sXwT0ELdPJBy7MB4=;
        b=TuhFE0pRO8bQK+NMopYT7I+VlnYcHZzGG+jCGcF8gPsBO9Uc6VU+3dQ/8XZL7iEoX60H4o
        cOKPYwpe+/tbTBaKCo3aNejnvmMe6OUFfKG4KWAqMkLog/aLJUuzx+KnP3Cfkk0AYFg1Kg
        AbiZ7Fk72VrOy/Am3lV4ELgbVvElIYg=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-bDVTEu4bNAalPcNJQpBZ9A-1; Wed, 06 Jul 2022 11:42:05 -0400
X-MC-Unique: bDVTEu4bNAalPcNJQpBZ9A-1
Received: by mail-il1-f199.google.com with SMTP id x11-20020a056e021cab00b002dada9d2a50so7833388ill.15
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 08:42:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=NwxK+LJ4YwtJcqot7ZiGKZWRmu6sXwT0ELdPJBy7MB4=;
        b=Lxv9nqvqQwrohrPqp5oOybtW8/dWDFj5tEa0JU6aYjUPdUUJSzwOBxl43VAAueCnyi
         iPmosGy0qykdPPyGSSY5uvCNHsIT1XZGFtMT0tdrA9MYKpoKc/cJss0Buqz7SZV7dLSl
         A1Z+CB/arapngDBLz4ORscN1exWCDZdsARd0WwQmXnpj7moigY/MzGpHls++fefFfSaZ
         3lRdwGaM3OGtmfepxOxfuk+HpdtZFTKbsg0HB8ita1YTXctJXD6bEAVOCp5viBINIbsZ
         CNPMmTT38Rv9lCQk/foGiOQKyP7WWSqPzb0gNQ+BIbCKCX3bfZWCDtwOOAvVQ2xe4ZyH
         /i8w==
X-Gm-Message-State: AJIora9HgKGUpnMSS8ZSPizQKYt+U1buD/JgC87kl6TIZEly+BstU3Q7
        54RUcYgJmt7WDLntlkvlHNpx5xyR9qVpvDQP7NvTfeVv72Uj3P/TbTJVgkbcmGrTk1VMbMFqABp
        RmC8gVF3zhOl7
X-Received: by 2002:a05:6e02:928:b0:2dc:759:7817 with SMTP id o8-20020a056e02092800b002dc07597817mr12109800ilt.84.1657122124761;
        Wed, 06 Jul 2022 08:42:04 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vRnBvyBs1iQEytHZjhJNY/jbe6ymUt9IK6La8Sjln4gVo4DBa7prz0Pjh2mep2viliPh+10w==
X-Received: by 2002:a05:6e02:928:b0:2dc:759:7817 with SMTP id o8-20020a056e02092800b002dc07597817mr12109787ilt.84.1657122124458;
        Wed, 06 Jul 2022 08:42:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id bt6-20020a056638430600b0033c9beb0e19sm12592536jab.22.2022.07.06.08.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 08:42:04 -0700 (PDT)
Date:   Wed, 6 Jul 2022 09:40:41 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v4 4/6] vfio/pci: Add the support for PCI D3cold state
Message-ID: <20220706094041.29875c80.alex.williamson@redhat.com>
In-Reply-To: <20220701110814.7310-5-abhsahu@nvidia.com>
References: <20220701110814.7310-1-abhsahu@nvidia.com>
        <20220701110814.7310-5-abhsahu@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 1 Jul 2022 16:38:12 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> Currently, if the runtime power management is enabled for vfio-pci
> based devices in the guest OS, then the guest OS will do the register
> write for PCI_PM_CTRL register. This write request will be handled in
> vfio_pm_config_write() where it will do the actual register write of
> PCI_PM_CTRL register. With this, the maximum D3hot state can be
> achieved for low power. If we can use the runtime PM framework, then
> we can achieve the D3cold state (on the supported systems) which will
> help in saving maximum power.
> 
> 1. D3cold state can't be achieved by writing PCI standard
>    PM config registers. This patch implements the newly added
>    'VFIO_DEVICE_FEATURE_POWER_MANAGEMENT' device feature which
>     can be used for putting the device into the D3cold state.
> 
> 2. The hypervisors can implement virtual ACPI methods. For example,
>    in guest linux OS if PCI device ACPI node has _PR3 and _PR0 power
>    resources with _ON/_OFF method, then guest linux OS invokes
>    the _OFF method during D3cold transition and then _ON during D0
>    transition. The hypervisor can tap these virtual ACPI calls and then
>    call the  'VFIO_DEVICE_FEATURE_POWER_MANAGEMENT' with respective flags.
> 
> 3. The vfio-pci driver uses runtime PM framework to achieve the
>    D3cold state. For the D3cold transition, decrement the usage count and
>    for the D0 transition, increment the usage count.
> 
> 4. If the D3cold state is not supported, then the device will
>    still be in the D3hot state. But with the runtime PM, the root port
>    can now also go into the suspended state.
> 
> 5. The 'pm_runtime_engaged' flag tracks the entry and exit to
>    runtime PM. This flag is protected with 'memory_lock' semaphore.
> 
> 6. During exit time, the flag clearing and usage count increment
>    are protected with 'memory_lock'. The actual wake-up is happening
>    outside 'memory_lock' since 'memory_lock' will be needed inside
>    runtime_resume callback also in subsequent patches.
> 
> 7. In D3cold, all kinds of device-related access (BAR read/write,
>    config read/write, etc.) need to be disabled. For BAR-related access,
>    we can use existing D3hot memory disable support. During the low power
>    entry, invalidate the mmap mappings and add the check for
>    'pm_runtime_engaged' flag.

Not disabled, just wrapped in pm-get/put.  If the device is indefinitely
in low-power without a wake-up eventfd, mmap faults are fatal to the
user.
 
> 8. For config space, ideally, we need to return an error whenever
>    there is any config access from the user side once the user moved the
>    device into low power state. But adding a check for
>    'pm_runtime_engaged' flag alone won't be sufficient due to the
>    following possible scenario from the user side where config space
>    access happens parallelly with the low power entry IOCTL.
> 
>    a. Config space access happens and vfio_pci_config_rw() will be
>       called.
>    b. The IOCTL to move into low power state is called.
>    c. The IOCTL will move the device into d3cold.
>    d. Exit from vfio_pci_config_rw() happened.
> 
>    Now, if we just check 'pm_runtime_engaged', then in the above
>    sequence the config space access will happen when the device already
>    is in the low power state. To prevent this situation, we increment the
>    usage count before any config space access and decrement the same
>    after completing the access. Also, to prevent any similar cases for
>    other types of access, the usage count will be incremented for all
>    kinds of access.

Unnecessary, just wrap in pm-get/put.  Thanks,

Alex

> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c |   2 +-
>  drivers/vfio/pci/vfio_pci_core.c   | 169 +++++++++++++++++++++++++++--
>  include/linux/vfio_pci_core.h      |   1 +
>  3 files changed, 164 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index 9343f597182d..21a4743d011f 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -408,7 +408,7 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev)
>  	 * PF SR-IOV capability, there's therefore no need to trigger
>  	 * faults based on the virtual value.
>  	 */
> -	return pdev->current_state < PCI_D3hot &&
> +	return !vdev->pm_runtime_engaged && pdev->current_state < PCI_D3hot &&
>  	       (pdev->no_command_memory || (cmd & PCI_COMMAND_MEMORY));
>  }
>  
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 5948d930449b..8c17ca41d156 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -264,6 +264,18 @@ static int vfio_pci_core_runtime_suspend(struct device *dev)
>  {
>  	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
>  
> +	down_write(&vdev->memory_lock);
> +	/*
> +	 * The user can move the device into D3hot state before invoking
> +	 * power management IOCTL. Move the device into D0 state here and then
> +	 * the pci-driver core runtime PM suspend function will move the device
> +	 * into the low power state. Also, for the devices which have
> +	 * NoSoftRst-, it will help in restoring the original state
> +	 * (saved locally in 'vdev->pm_save').
> +	 */
> +	vfio_pci_set_power_state(vdev, PCI_D0);
> +	up_write(&vdev->memory_lock);
> +
>  	/*
>  	 * If INTx is enabled, then mask INTx before going into the runtime
>  	 * suspended state and unmask the same in the runtime resume.
> @@ -386,6 +398,7 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  	struct pci_dev *pdev = vdev->pdev;
>  	struct vfio_pci_dummy_resource *dummy_res, *tmp;
>  	struct vfio_pci_ioeventfd *ioeventfd, *ioeventfd_tmp;
> +	bool do_resume = false;
>  	int i, bar;
>  
>  	/* For needs_reset */
> @@ -393,6 +406,25 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  
>  	/*
>  	 * This function can be invoked while the power state is non-D0.
> +	 * This non-D0 power state can be with or without runtime PM.
> +	 * Increment the usage count corresponding to pm_runtime_put()
> +	 * called during setting of 'pm_runtime_engaged'. The device will
> +	 * wake up if it has already gone into the suspended state.
> +	 * Otherwise, the next vfio_pci_set_power_state() will change the
> +	 * device power state to D0.
> +	 */
> +	down_write(&vdev->memory_lock);
> +	if (vdev->pm_runtime_engaged) {
> +		vdev->pm_runtime_engaged = false;
> +		pm_runtime_get_noresume(&pdev->dev);
> +		do_resume = true;
> +	}
> +	up_write(&vdev->memory_lock);
> +
> +	if (do_resume)
> +		pm_runtime_resume(&pdev->dev);
> +
> +	/*
>  	 * This function calls __pci_reset_function_locked() which internally
>  	 * can use pci_pm_reset() for the function reset. pci_pm_reset() will
>  	 * fail if the power state is non-D0. Also, for the devices which
> @@ -1190,6 +1222,99 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
>  
> +static int vfio_pci_pm_validate_flags(u32 flags)
> +{
> +	if (!flags)
> +		return -EINVAL;
> +	/* Only valid flags should be set */
> +	if (flags & ~(VFIO_PM_LOW_POWER_ENTER | VFIO_PM_LOW_POWER_EXIT))
> +		return -EINVAL;
> +	/* Both enter and exit should not be set */
> +	if ((flags & (VFIO_PM_LOW_POWER_ENTER | VFIO_PM_LOW_POWER_EXIT)) ==
> +	    (VFIO_PM_LOW_POWER_ENTER | VFIO_PM_LOW_POWER_EXIT))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int vfio_pci_core_feature_pm(struct vfio_device *device, u32 flags,
> +				    void __user *arg, size_t argsz)
> +{
> +	struct vfio_pci_core_device *vdev =
> +		container_of(device, struct vfio_pci_core_device, vdev);
> +	struct pci_dev *pdev = vdev->pdev;
> +	struct vfio_device_feature_power_management vfio_pm = { 0 };
> +	int ret = 0;
> +
> +	ret = vfio_check_feature(flags, argsz,
> +				 VFIO_DEVICE_FEATURE_SET |
> +				 VFIO_DEVICE_FEATURE_GET,
> +				 sizeof(vfio_pm));
> +	if (ret != 1)
> +		return ret;
> +
> +	if (flags & VFIO_DEVICE_FEATURE_GET) {
> +		down_read(&vdev->memory_lock);
> +		if (vdev->pm_runtime_engaged)
> +			vfio_pm.flags = VFIO_PM_LOW_POWER_ENTER;
> +		else
> +			vfio_pm.flags = VFIO_PM_LOW_POWER_EXIT;
> +		up_read(&vdev->memory_lock);
> +
> +		if (copy_to_user(arg, &vfio_pm, sizeof(vfio_pm)))
> +			return -EFAULT;
> +
> +		return 0;
> +	}
> +
> +	if (copy_from_user(&vfio_pm, arg, sizeof(vfio_pm)))
> +		return -EFAULT;
> +
> +	ret = vfio_pci_pm_validate_flags(vfio_pm.flags);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * The vdev power related flags are protected with 'memory_lock'
> +	 * semaphore.
> +	 */
> +	if (vfio_pm.flags & VFIO_PM_LOW_POWER_ENTER) {
> +		vfio_pci_zap_and_down_write_memory_lock(vdev);
> +		if (vdev->pm_runtime_engaged) {
> +			up_write(&vdev->memory_lock);
> +			return -EINVAL;
> +		}
> +
> +		vdev->pm_runtime_engaged = true;
> +		up_write(&vdev->memory_lock);
> +		pm_runtime_put(&pdev->dev);
> +	} else if (vfio_pm.flags & VFIO_PM_LOW_POWER_EXIT) {
> +		down_write(&vdev->memory_lock);
> +		if (!vdev->pm_runtime_engaged) {
> +			up_write(&vdev->memory_lock);
> +			return -EINVAL;
> +		}
> +
> +		vdev->pm_runtime_engaged = false;
> +		pm_runtime_get_noresume(&pdev->dev);
> +		up_write(&vdev->memory_lock);
> +		ret = pm_runtime_resume(&pdev->dev);
> +		if (ret < 0) {
> +			down_write(&vdev->memory_lock);
> +			if (!vdev->pm_runtime_engaged) {
> +				vdev->pm_runtime_engaged = true;
> +				pm_runtime_put_noidle(&pdev->dev);
> +			}
> +			up_write(&vdev->memory_lock);
> +			return ret;
> +		}
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
>  				       void __user *arg, size_t argsz)
>  {
> @@ -1224,6 +1349,8 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
>  	switch (flags & VFIO_DEVICE_FEATURE_MASK) {
>  	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
>  		return vfio_pci_core_feature_token(device, flags, arg, argsz);
> +	case VFIO_DEVICE_FEATURE_POWER_MANAGEMENT:
> +		return vfio_pci_core_feature_pm(device, flags, arg, argsz);
>  	default:
>  		return -ENOTTY;
>  	}
> @@ -1234,31 +1361,47 @@ static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  			   size_t count, loff_t *ppos, bool iswrite)
>  {
>  	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	int ret;
>  
>  	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
>  		return -EINVAL;
>  
> +	ret = pm_runtime_resume_and_get(&vdev->pdev->dev);
> +	if (ret < 0) {
> +		pci_info_ratelimited(vdev->pdev, "runtime resume failed %d\n",
> +				     ret);
> +		return -EIO;
> +	}
> +
>  	switch (index) {
>  	case VFIO_PCI_CONFIG_REGION_INDEX:
> -		return vfio_pci_config_rw(vdev, buf, count, ppos, iswrite);
> +		ret = vfio_pci_config_rw(vdev, buf, count, ppos, iswrite);
> +		break;
>  
>  	case VFIO_PCI_ROM_REGION_INDEX:
>  		if (iswrite)
> -			return -EINVAL;
> -		return vfio_pci_bar_rw(vdev, buf, count, ppos, false);
> +			ret = -EINVAL;
> +		else
> +			ret = vfio_pci_bar_rw(vdev, buf, count, ppos, false);
> +		break;
>  
>  	case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR5_REGION_INDEX:
> -		return vfio_pci_bar_rw(vdev, buf, count, ppos, iswrite);
> +		ret = vfio_pci_bar_rw(vdev, buf, count, ppos, iswrite);
> +		break;
>  
>  	case VFIO_PCI_VGA_REGION_INDEX:
> -		return vfio_pci_vga_rw(vdev, buf, count, ppos, iswrite);
> +		ret = vfio_pci_vga_rw(vdev, buf, count, ppos, iswrite);
> +		break;
> +
>  	default:
>  		index -= VFIO_PCI_NUM_REGIONS;
> -		return vdev->region[index].ops->rw(vdev, buf,
> +		ret = vdev->region[index].ops->rw(vdev, buf,
>  						   count, ppos, iswrite);
> +		break;
>  	}
>  
> -	return -EINVAL;
> +	pm_runtime_put(&vdev->pdev->dev);
> +	return ret;
>  }
>  
>  ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
> @@ -2157,6 +2300,15 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>  		goto err_unlock;
>  	}
>  
> +	/*
> +	 * Some of the devices in the dev_set can be in the runtime suspended
> +	 * state. Increment the usage count for all the devices in the dev_set
> +	 * before reset and decrement the same after reset.
> +	 */
> +	ret = vfio_pci_dev_set_pm_runtime_get(dev_set);
> +	if (ret)
> +		goto err_unlock;
> +
>  	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
>  		/*
>  		 * Test whether all the affected devices are contained by the
> @@ -2212,6 +2364,9 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>  		else
>  			mutex_unlock(&cur->vma_lock);
>  	}
> +
> +	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
> +		pm_runtime_put(&cur->pdev->dev);
>  err_unlock:
>  	mutex_unlock(&dev_set->lock);
>  	return ret;
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index cdfd328ba6b1..bf4823b008f9 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -125,6 +125,7 @@ struct vfio_pci_core_device {
>  	bool			nointx;
>  	bool			needs_pm_restore;
>  	bool			pm_intx_masked;
> +	bool			pm_runtime_engaged;
>  	struct pci_saved_state	*pci_saved_state;
>  	struct pci_saved_state	*pm_save;
>  	int			ioeventfds_nr;

