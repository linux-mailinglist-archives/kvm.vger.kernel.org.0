Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9AA94D3779
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 18:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237044AbiCIR2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 12:28:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237049AbiCIR2B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 12:28:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E978BDF9B
        for <kvm@vger.kernel.org>; Wed,  9 Mar 2022 09:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646846811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vvlBkbmQBwaRN/Y8AlyojG37Pu+7Rnj1d5BPN+iT2eE=;
        b=D1JVrhYGiMN4ZtYQFjLn+pZ8QRKAd8zixrGUXtFPFHSCAwZD2HXlyUHnyddH5hE+zL5WWf
        WCqYzHhBsIYycL3pmR1OAyyLCH46ZcF5kBuh2EQexSPb0ozXmtHHuS6dX4PgiG9dzZNbwM
        SEaIWEkQ2F5cMUTmku4HU6qL+K3TH9Y=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-414oRrckMxifH9tAeS1KAg-1; Wed, 09 Mar 2022 12:26:47 -0500
X-MC-Unique: 414oRrckMxifH9tAeS1KAg-1
Received: by mail-oi1-f198.google.com with SMTP id ay31-20020a056808301f00b002d06e828c00so2017899oib.2
        for <kvm@vger.kernel.org>; Wed, 09 Mar 2022 09:26:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=vvlBkbmQBwaRN/Y8AlyojG37Pu+7Rnj1d5BPN+iT2eE=;
        b=ri3M3wu9BOL/fRRRel+Gb7PyoHyiG0h2iFg0zizyoAiJdT14XcBIpKSGqnJeHZuwWH
         25OrQpmJvz5Dit0m+v6bi6y198gh6UEER1lCOgX/18lfWwwvULrPHlzfn7QarqbPnfAU
         nNhytBv+QYo1l4tP5ifkqe8aZbi9CUXvsdTPhancy9k0xSINkaOq1ICn5L67ygC6ExfG
         QBwUbtibrfhXKON7UqBlA4AziYqG1SSn7HQSDqsGkSLVc75dYiIj6+R2a+E6YHys1QA1
         9zkjhASiJ5Q2F/ZxbUgYssifh4MCNKPm9VB04RT4VGLcCp2X2CqXJ0WIu6kWogZrfaFG
         qw6Q==
X-Gm-Message-State: AOAM530rUmi5NTnvqXh181LRIJdRUxOXDFuzrOpHbmVCbuC3US73EiEW
        YLptAE2WUBYqpmpHTzeK5X2a1eAulXdLOru/iU+NQtoxQAqjnoYn4kti6ACsCdzKDQGTLy9JYhw
        DUQINWgre3R3B
X-Received: by 2002:a05:6808:1706:b0:2d3:8946:a4e with SMTP id bc6-20020a056808170600b002d389460a4emr6460113oib.153.1646846806948;
        Wed, 09 Mar 2022 09:26:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxNmTiiMnb6Vzwpuiu3gdZB7p/R4MF0HDUU3Sb8VDJM4uvek3y0QMdkoCymRSlxJ7XrYdOWkA==
X-Received: by 2002:a05:6808:1706:b0:2d3:8946:a4e with SMTP id bc6-20020a056808170600b002d389460a4emr6460061oib.153.1646846806137;
        Wed, 09 Mar 2022 09:26:46 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id az10-20020a056808164a00b002d9c98e551bsm1111236oib.36.2022.03.09.09.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 09:26:45 -0800 (PST)
Date:   Wed, 9 Mar 2022 10:26:42 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 5/5] vfio/pci: add the support for PCI D3cold
 state
Message-ID: <20220309102642.251aff25.alex.williamson@redhat.com>
In-Reply-To: <20220124181726.19174-6-abhsahu@nvidia.com>
References: <20220124181726.19174-1-abhsahu@nvidia.com>
        <20220124181726.19174-6-abhsahu@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Jan 2022 23:47:26 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> Currently, if the runtime power management is enabled for vfio-pci
> device in the guest OS, then guest OS will do the register write for
> PCI_PM_CTRL register. This write request will be handled in
> vfio_pm_config_write() where it will do the actual register write
> of PCI_PM_CTRL register. With this, the maximum D3hot state can be
> achieved for low power. If we can use the runtime PM framework,
> then we can achieve the D3cold state which will help in saving
> maximum power.
> 
> 1. Since D3cold state can't be achieved by writing PCI standard
>    PM config registers, so this patch adds a new IOCTL which change the
>    PCI device from D3hot to D3cold state and then D3cold to D0 state.
> 
> 2. The hypervisors can implement virtual ACPI methods. For
>    example, in guest linux OS if PCI device ACPI node has _PR3 and _PR0
>    power resources with _ON/_OFF method, then guest linux OS makes the
>    _OFF call during D3cold transition and then _ON during D0 transition.
>    The hypervisor can tap these virtual ACPI calls and then do the D3cold
>    related IOCTL in the vfio driver.
> 
> 3. The vfio driver uses runtime PM framework to achieve the
>    D3cold state. For the D3cold transition, decrement the usage count and
>    during D0 transition increment the usage count.
> 
> 4. For D3cold, the device current power state should be D3hot.
>    Then during runtime suspend, the pci_platform_power_transition() is
>    required for D3cold state. If the D3cold state is not supported, then
>    the device will still be in D3hot state. But with the runtime PM, the
>    root port can now also go into suspended state.
> 
> 5. For most of the systems, the D3cold is supported at the root
>    port level. So, when root port will transition to D3cold state, then
>    the vfio PCI device will go from D3hot to D3cold state during its
>    runtime suspend. If root port does not support D3cold, then the root
>    will go into D3hot state.
> 
> 6. The runtime suspend callback can now happen for 2 cases: there
>    is no user of vfio device and the case where user has initiated
>    D3cold. The 'runtime_suspend_pending' flag can help to distinguish
>    this case.
> 
> 7. There are cases where guest has put PCI device into D3cold
>    state and then on the host side, user has run lspci or any other
>    command which requires access of the PCI config register. In this case,
>    the kernel runtime PM framework will resume the PCI device internally,
>    read the config space and put the device into D3cold state again. Some
>    PCI device needs the SW involvement before going into D3cold state.
>    For the first D3cold state, the driver running in guest side does the SW
>    side steps. But the second D3cold transition will be without guest
>    driver involvement. So, prevent this second d3cold transition by
>    incrementing the device usage count. This will make the device
>    unnecessary in D0 but it's better than failure. In future, we can some
>    mechanism by which we can forward these wake-up request to guest and
>    then the mentioned case can be handled also.
> 
> 8. In D3cold, all kind of BAR related access needs to be disabled
>    like D3hot. Additionally, the config space will also be disabled in
>    D3cold state. To prevent access of config space in the D3cold state,
>    increment the runtime PM usage count before doing any config space
>    access. Also, most of the IOCTLs do the config space access, so
>    maintain one safe list and skip the resume only for these safe IOCTLs
>    alone. For other IOCTLs, the runtime PM usage count will be
>    incremented first.
> 
> 9. Now, runtime suspend/resume callbacks need to get the vdev
>    reference which can be obtained by dev_get_drvdata(). Currently, the
>    dev_set_drvdata() is being set after returning from
>    vfio_pci_core_register_device(). The runtime callbacks can come
>    anytime after enabling runtime PM so dev_set_drvdata() must happen
>    before that. We can move dev_set_drvdata() inside
>    vfio_pci_core_register_device() itself.
> 
> 10. The vfio device user can close the device after putting
>     the device into runtime suspended state so inside
>     vfio_pci_core_disable(), increment the runtime PM usage count.
> 
> 11. Runtime PM will be possible only if CONFIG_PM is enabled on
>     the host. So, the IOCTL related code can be put under CONFIG_PM
>     Kconfig.
> 
> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci.c        |   1 -
>  drivers/vfio/pci/vfio_pci_config.c |  11 +-
>  drivers/vfio/pci/vfio_pci_core.c   | 186 +++++++++++++++++++++++++++--
>  include/linux/vfio_pci_core.h      |   1 +
>  include/uapi/linux/vfio.h          |  21 ++++
>  5 files changed, 211 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index c8695baf3b54..4ac3338c8fc7 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -153,7 +153,6 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	ret = vfio_pci_core_register_device(vdev);
>  	if (ret)
>  		goto out_free;
> -	dev_set_drvdata(&pdev->dev, vdev);

Relocating the setting of drvdata should be proposed separately rather
than buried in this patch.  The driver owns drvdata, the driver is the
only consumer of drvdata, so pushing this into the core to impose a
standard for drvdata across all vfio-pci variants doesn't seem like a
good idea to me.

>  	return 0;
>  
>  out_free:
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index dd9ed211ba6f..d20420657959 100644
> --- a/drivers/vfio/pci/vfio_pci_config.c
> +++ b/drivers/vfio/pci/vfio_pci_config.c
> @@ -25,6 +25,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/vfio.h>
>  #include <linux/slab.h>
> +#include <linux/pm_runtime.h>
>  
>  #include <linux/vfio_pci_core.h>
>  
> @@ -1919,16 +1920,23 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
>  ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  			   size_t count, loff_t *ppos, bool iswrite)
>  {
> +	struct device *dev = &vdev->pdev->dev;
>  	size_t done = 0;
>  	int ret = 0;
>  	loff_t pos = *ppos;
>  
>  	pos &= VFIO_PCI_OFFSET_MASK;
>  
> +	ret = pm_runtime_resume_and_get(dev);
> +	if (ret < 0)
> +		return ret;
> +
>  	while (count) {
>  		ret = vfio_config_do_rw(vdev, buf, count, &pos, iswrite);
> -		if (ret < 0)
> +		if (ret < 0) {
> +			pm_runtime_put(dev);
>  			return ret;
> +		}
>  
>  		count -= ret;
>  		done += ret;
> @@ -1936,6 +1944,7 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  		pos += ret;
>  	}
>  
> +	pm_runtime_put(dev);

What about other config accesses, ex. shared INTx?  We need to
interact with the device command and status register on an incoming
interrupt to test if our device sent an interrupt and to mask it.  The
unmask eventfd can also trigger config space accesses.  Seems
incomplete relative to config space.

>  	*ppos += done;
>  
>  	return done;
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 38440d48973f..b70bb4fd940d 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -371,12 +371,23 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  	lockdep_assert_held(&vdev->vdev.dev_set->lock);
>  
>  	/*
> -	 * If disable has been called while the power state is other than D0,
> -	 * then set the power state in vfio driver to D0. It will help
> -	 * in running the logic needed for D0 power state. The subsequent
> -	 * runtime PM API's will put the device into the low power state again.
> +	 * The vfio device user can close the device after putting the device
> +	 * into runtime suspended state so wake up the device first in
> +	 * this case.
>  	 */
> -	vfio_pci_set_power_state_locked(vdev, PCI_D0);
> +	if (vdev->runtime_suspend_pending) {
> +		vdev->runtime_suspend_pending = false;
> +		pm_runtime_resume_and_get(&pdev->dev);

Doesn't vdev->power_state become unsynchronized from the actual device
state here and maybe elsewhere in this patch?  (I see below that maybe
the resume handler accounts for this)

> +	} else {
> +		/*
> +		 * If disable has been called while the power state is other
> +		 * than D0, then set the power state in vfio driver to D0. It
> +		 * will help in running the logic needed for D0 power state.
> +		 * The subsequent runtime PM API's will put the device into
> +		 * the low power state again.
> +		 */
> +		vfio_pci_set_power_state_locked(vdev, PCI_D0);
> +	}
>  
>  	/* Stop the device from further DMA */
>  	pci_clear_master(pdev);
> @@ -693,8 +704,8 @@ int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_register_dev_region);
>  
> -long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
> -		unsigned long arg)
> +static long vfio_pci_core_ioctl_internal(struct vfio_device *core_vdev,
> +					 unsigned int cmd, unsigned long arg)
>  {
>  	struct vfio_pci_core_device *vdev =
>  		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> @@ -1241,10 +1252,119 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>  		default:
>  			return -ENOTTY;
>  		}
> +#ifdef CONFIG_PM
> +	} else if (cmd == VFIO_DEVICE_POWER_MANAGEMENT) {

I'd suggest using a DEVICE_FEATURE ioctl for this.  This ioctl doesn't
follow the vfio standard of argsz/flags and doesn't seem to do anything
special that we couldn't achieve with a DEVICE_FEATURE ioctl.

> +		struct vfio_power_management vfio_pm;
> +		struct pci_dev *pdev = vdev->pdev;
> +		bool request_idle = false, request_resume = false;
> +		int ret = 0;
> +
> +		if (copy_from_user(&vfio_pm, (void __user *)arg, sizeof(vfio_pm)))
> +			return -EFAULT;
> +
> +		/*
> +		 * The vdev power related fields are protected with memory_lock
> +		 * semaphore.
> +		 */
> +		down_write(&vdev->memory_lock);
> +		switch (vfio_pm.d3cold_state) {
> +		case VFIO_DEVICE_D3COLD_STATE_ENTER:
> +			/*
> +			 * For D3cold, the device should already in D3hot
> +			 * state.
> +			 */
> +			if (vdev->power_state < PCI_D3hot) {
> +				ret = EINVAL;
> +				break;
> +			}
> +
> +			if (!vdev->runtime_suspend_pending) {
> +				vdev->runtime_suspend_pending = true;
> +				pm_runtime_put_noidle(&pdev->dev);
> +				request_idle = true;
> +			}

If I call this multiple times, runtime_suspend_pending prevents it from
doing anything, but what should the return value be in that case?  Same
question for exit.

> +
> +			break;
> +
> +		case VFIO_DEVICE_D3COLD_STATE_EXIT:
> +			/*
> +			 * If the runtime resume has already been run, then
> +			 * the device will be already in D0 state.
> +			 */
> +			if (vdev->runtime_suspend_pending) {
> +				vdev->runtime_suspend_pending = false;
> +				pm_runtime_get_noresume(&pdev->dev);
> +				request_resume = true;
> +			}
> +
> +			break;
> +
> +		default:
> +			ret = EINVAL;
> +			break;
> +		}
> +
> +		up_write(&vdev->memory_lock);
> +
> +		/*
> +		 * Call the runtime PM API's without any lock. Inside vfio driver
> +		 * runtime suspend/resume, the locks can be acquired again.
> +		 */
> +		if (request_idle)
> +			pm_request_idle(&pdev->dev);
> +
> +		if (request_resume)
> +			pm_runtime_resume(&pdev->dev);
> +
> +		return ret;
> +#endif
>  	}
>  
>  	return -ENOTTY;
>  }
> +
> +long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
> +			 unsigned long arg)
> +{
> +#ifdef CONFIG_PM
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	struct device *dev = &vdev->pdev->dev;
> +	bool skip_runtime_resume = false;
> +	long ret;
> +
> +	/*
> +	 * The list of commands which are safe to execute when the PCI device
> +	 * is in D3cold state. In D3cold state, the PCI config or any other IO
> +	 * access won't work.
> +	 */
> +	switch (cmd) {
> +	case VFIO_DEVICE_POWER_MANAGEMENT:
> +	case VFIO_DEVICE_GET_INFO:
> +	case VFIO_DEVICE_FEATURE:
> +		skip_runtime_resume = true;
> +		break;

How can we know that there won't be DEVICE_FEATURE calls that touch the
device, the recently added migration via DEVICE_FEATURE does already.
DEVICE_GET_INFO seems equally as prone to breaking via capabilities
that could touch the device.  It seems easier to maintain and more
consistent to the user interface if we simply define that any device
access will resume the device.  We need to do something about
interrupts though.  Maybe we could error the user ioctl to set d3cold
for devices running in INTx mode, but we also have numerous ways that
the device could be resumed under the user, which might start
triggering MSI/X interrupts?

> +
> +	default:
> +		break;
> +	}
> +
> +	if (!skip_runtime_resume) {
> +		ret = pm_runtime_resume_and_get(dev);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	ret = vfio_pci_core_ioctl_internal(core_vdev, cmd, arg);
> +

I'm not a fan of wrapping the main ioctl interface for power management
like this.

> +	if (!skip_runtime_resume)
> +		pm_runtime_put(dev);
> +
> +	return ret;
> +#else
> +	return vfio_pci_core_ioctl_internal(core_vdev, cmd, arg);
> +#endif
> +}
>  EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
>  
>  static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
> @@ -1897,6 +2017,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>  		return -EBUSY;
>  	}
>  
> +	dev_set_drvdata(&pdev->dev, vdev);
>  	if (pci_is_root_bus(pdev->bus)) {
>  		ret = vfio_assign_device_set(&vdev->vdev, vdev);
>  	} else if (!pci_probe_reset_slot(pdev->slot)) {
> @@ -1966,6 +2087,7 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
>  		pm_runtime_get_noresume(&pdev->dev);
>  
>  	pm_runtime_forbid(&pdev->dev);
> +	dev_set_drvdata(&pdev->dev, NULL);
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
>  
> @@ -2219,11 +2341,61 @@ static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
>  #ifdef CONFIG_PM
>  static int vfio_pci_core_runtime_suspend(struct device *dev)
>  {
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
> +
> +	down_read(&vdev->memory_lock);
> +
> +	/*
> +	 * runtime_suspend_pending won't be set if there is no user of vfio pci
> +	 * device. In that case, return early and PCI core will take care of
> +	 * putting the device in the low power state.
> +	 */
> +	if (!vdev->runtime_suspend_pending) {
> +		up_read(&vdev->memory_lock);
> +		return 0;
> +	}

Doesn't this also mean that idle, unused devices can at best sit in
d3hot rather than d3cold?

> +
> +	/*
> +	 * The runtime suspend will be called only if device is already at
> +	 * D3hot state. Now, change the device state from D3hot to D3cold by
> +	 * using platform power management. If setting of D3cold is not
> +	 * supported for the PCI device, then the device state will still be
> +	 * in D3hot state. The PCI core expects to save the PCI state, if
> +	 * driver runtime routine handles the power state management.
> +	 */
> +	pci_save_state(pdev);
> +	pci_platform_power_transition(pdev, PCI_D3cold);
> +	up_read(&vdev->memory_lock);
> +
>  	return 0;
>  }
>  
>  static int vfio_pci_core_runtime_resume(struct device *dev)
>  {
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
> +
> +	down_write(&vdev->memory_lock);
> +
> +	/*
> +	 * The PCI core will move the device to D0 state before calling the
> +	 * driver runtime resume.
> +	 */
> +	vfio_pci_set_power_state_locked(vdev, PCI_D0);

Maybe this is where vdev->power_state is kept synchronized?

> +
> +	/*
> +	 * Some PCI device needs the SW involvement before going to D3cold
> +	 * state again. So if there is any wake-up which is not triggered
> +	 * by the guest, then increase the usage count to prevent the
> +	 * second runtime suspend.
> +	 */

Can you give examples of devices that need this and the reason they
need this?  The interface is not terribly deterministic if a random
unprivileged lspci on the host can move devices back to d3hot.  How
useful is this implementation if a notice to the guest of a resumed
device is TBD?  Thanks,

Alex

> +	if (vdev->runtime_suspend_pending) {
> +		vdev->runtime_suspend_pending = false;
> +		pm_runtime_get_noresume(&pdev->dev);
> +	}
> +
> +	up_write(&vdev->memory_lock);
>  	return 0;
>  }
>  
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index 05db838e72cc..8bbfd028115a 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -124,6 +124,7 @@ struct vfio_pci_core_device {
>  	bool			needs_reset;
>  	bool			nointx;
>  	bool			needs_pm_restore;
> +	bool			runtime_suspend_pending;
>  	pci_power_t		power_state;
>  	struct pci_saved_state	*pci_saved_state;
>  	struct pci_saved_state	*pm_save;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ef33ea002b0b..7b7dadc6df71 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1002,6 +1002,27 @@ struct vfio_device_feature {
>   */
>  #define VFIO_DEVICE_FEATURE_PCI_VF_TOKEN	(0)
>  
> +/**
> + * VFIO_DEVICE_POWER_MANAGEMENT - _IOW(VFIO_TYPE, VFIO_BASE + 18,
> + *			       struct vfio_power_management)
> + *
> + * Provide the support for device power management.  The native PCI power
> + * management does not support the D3cold power state.  For moving the device
> + * into D3cold state, change the PCI state to D3hot with standard
> + * configuration registers and then call this IOCTL to setting the D3cold
> + * state.  Similarly, if the device in D3cold state, then call this IOCTL
> + * to exit from D3cold state.
> + *
> + * Return 0 on success, -errno on failure.
> + */
> +#define VFIO_DEVICE_POWER_MANAGEMENT		_IO(VFIO_TYPE, VFIO_BASE + 18)
> +struct vfio_power_management {
> +	__u32	argsz;
> +#define VFIO_DEVICE_D3COLD_STATE_EXIT		0x0
> +#define VFIO_DEVICE_D3COLD_STATE_ENTER		0x1
> +	__u32	d3cold_state;
> +};
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
>  
>  /**

