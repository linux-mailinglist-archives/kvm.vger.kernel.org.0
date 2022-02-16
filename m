Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781FC4B94B5
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 00:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238633AbiBPXs1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 18:48:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbiBPXsZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 18:48:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D5F32258479
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 15:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645055291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3yxXnQ8NcQVI3R2VSTCwUm2NlS2NbQO6IZlz6uxtttI=;
        b=h6aE7CfpklfKg+4oUOgIerIrtD5QYfok3NxuSkirylWpNhnrJjmxUgmuorPszqR0mVyaw1
        7VJ4HtVIvXDhE3OrJbR0oIElFQ6x3oe00c706hE4c0Yl9dyPbYBoKx9NeoFpLzPevSelyk
        GWF0Isosp7SEH3vZLQdQul3DTq3OsM4=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-O-yefNZ-MfuRgtGRlILj_w-1; Wed, 16 Feb 2022 18:48:09 -0500
X-MC-Unique: O-yefNZ-MfuRgtGRlILj_w-1
Received: by mail-oi1-f200.google.com with SMTP id r15-20020a056808210f00b002d0d8b35b4eso1544093oiw.23
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 15:48:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=3yxXnQ8NcQVI3R2VSTCwUm2NlS2NbQO6IZlz6uxtttI=;
        b=v+UBlK9HgS/Poxh60EIhEVICOGQle9gF/9SLT2872+oUe+RUBFiZTZDQDpgDCc+/nJ
         5QemjQNcqrKEvqqDXEUC/4wUEp+5eJVYNdMMbcYcWTKBXu+tZ9mjToNhXLtF3ENXbjZ/
         ABNYg8Nj/nM5Yt5Iewhrd11kkBE3ZKRr6hZlPXdlx7bd8mahr3Tpu9xNo9kmmj7R2dw9
         lkg1iYumzOdcI0dk/FGLTzAyDi1sgZeI0OVYJtxrTcT9wQq3UCuia/NHPF1lDsgXnbe8
         FOnBFVhFWYYcUVe37nKWEDqSRr6S3/M1bkT/JJ8Vrebj8Plusc99I9pdoY7nzaY+xp5e
         HRzQ==
X-Gm-Message-State: AOAM530VqFB1dTIAJEdOhG0qYA8TKSDxv++BYCNebb2C90biPiV6Xmvg
        U6XL1WwH0YDQFtAwCfobG3LpQCzs6iOh73/D0T5c1fAcsNseNN+kgJq/vu+Yi3CJmcgxDiqpzqV
        IXc1ld3Drr70e
X-Received: by 2002:a05:6870:4248:b0:d2:c3a4:5b4c with SMTP id v8-20020a056870424800b000d2c3a45b4cmr1378277oac.40.1645055288807;
        Wed, 16 Feb 2022 15:48:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwHwiwa7LUVi3R9fBV+IMF/WBh/f8giV2tlCFrpwtq5zY75nHBLPRui6wwyxbqkuInjx2yxSw==
X-Received: by 2002:a05:6870:4248:b0:d2:c3a4:5b4c with SMTP id v8-20020a056870424800b000d2c3a45b4cmr1378267oac.40.1645055288418;
        Wed, 16 Feb 2022 15:48:08 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x1sm15614544oto.38.2022.02.16.15.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 15:48:07 -0800 (PST)
Date:   Wed, 16 Feb 2022 16:48:06 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 1/5] vfio/pci: register vfio-pci driver with
 runtime PM framework
Message-ID: <20220216164806.0d391821.alex.williamson@redhat.com>
In-Reply-To: <20220124181726.19174-2-abhsahu@nvidia.com>
References: <20220124181726.19174-1-abhsahu@nvidia.com>
        <20220124181726.19174-2-abhsahu@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Jan 2022 23:47:22 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> Currently, there is very limited power management support
> available in the upstream vfio-pci driver. If there is no user of vfio-pci
> device, then the PCI device will be moved into D3Hot state by writing
> directly into PCI PM registers. This D3Hot state help in saving power
> but we can achieve zero power consumption if we go into the D3cold state.
> The D3cold state cannot be possible with native PCI PM. It requires
> interaction with platform firmware which is system-specific.
> To go into low power states (including D3cold), the runtime PM framework
> can be used which internally interacts with PCI and platform firmware and
> puts the device into the lowest possible D-States.
> 
> This patch registers vfio-pci driver with the runtime PM framework.
> 
> 1. The PCI core framework takes care of most of the runtime PM
>    related things. For enabling the runtime PM, the PCI driver needs to
>    decrement the usage count and needs to register the runtime
>    suspend/resume callbacks. For vfio-pci based driver, these callback
>    routines can be stubbed in this patch since the vfio-pci driver
>    is not doing the PCI device initialization. All the config state
>    saving, and PCI power management related things will be done by
>    PCI core framework itself inside its runtime suspend/resume callbacks.
> 
> 2. Inside pci_reset_bus(), all the devices in bus/slot will be moved
>    out of D0 state. This state change to D0 can happen directly without
>    going through the runtime PM framework. So if runtime PM is enabled,
>    then pm_runtime_resume() makes the runtime state active. Since the PCI
>    device power state is already D0, so it should return early when it
>    tries to change the state with pci_set_power_state(). Then
>    pm_request_idle() can be used which will internally check for
>    device usage count and will move the device again into the low power
>    state.
> 
> 3. Inside vfio_pci_core_disable(), the device usage count always needs
>    to be decremented which was incremented in vfio_pci_core_enable().
> 
> 4. Since the runtime PM framework will provide the same functionality,
>    so directly writing into PCI PM config register can be replaced with
>    the use of runtime PM routines. Also, the use of runtime PM can help
>    us in more power saving.
> 
>    In the systems which do not support D3Cold,
> 
>    With the existing implementation:
> 
>    // PCI device
>    # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
>    D3hot
>    // upstream bridge
>    # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
>    D0
> 
>    With runtime PM:
> 
>    // PCI device
>    # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
>    D3hot
>    // upstream bridge
>    # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
>    D3hot
> 
>    So, with runtime PM, the upstream bridge or root port will also go
>    into lower power state which is not possible with existing
>    implementation.
> 
>    In the systems which support D3Cold,
> 
>    // PCI device
>    # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
>    D3hot
>    // upstream bridge
>    # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
>    D0
> 
>    With runtime PM:
> 
>    // PCI device
>    # cat /sys/bus/pci/devices/0000\:01\:00.0/power_state
>    D3cold
>    // upstream bridge
>    # cat /sys/bus/pci/devices/0000\:00\:01.0/power_state
>    D3cold
> 
>    So, with runtime PM, both the PCI device and upstream bridge will
>    go into D3cold state.
> 
> 5. If 'disable_idle_d3' module parameter is set, then also the runtime
>    PM will be enabled, but in this case, the usage count should not be
>    decremented.
> 
> 6. vfio_pci_dev_set_try_reset() return value is unused now, so this
>    function return type can be changed to void.
> 
> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci.c      |  3 +
>  drivers/vfio/pci/vfio_pci_core.c | 95 +++++++++++++++++++++++---------
>  include/linux/vfio_pci_core.h    |  4 ++
>  3 files changed, 75 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index a5ce92beb655..c8695baf3b54 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -193,6 +193,9 @@ static struct pci_driver vfio_pci_driver = {
>  	.remove			= vfio_pci_remove,
>  	.sriov_configure	= vfio_pci_sriov_configure,
>  	.err_handler		= &vfio_pci_core_err_handlers,
> +#if defined(CONFIG_PM)
> +	.driver.pm              = &vfio_pci_core_pm_ops,
> +#endif
>  };
>  
>  static void __init vfio_pci_fill_ids(void)
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index f948e6cd2993..c6e4fe9088c3 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -152,7 +152,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
>  }
>  
>  struct vfio_pci_group_info;
> -static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
> +static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
>  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>  				      struct vfio_pci_group_info *groups);
>  
> @@ -245,7 +245,11 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>  	u16 cmd;
>  	u8 msix_pos;
>  
> -	vfio_pci_set_power_state(vdev, PCI_D0);
> +	if (!disable_idle_d3) {
> +		ret = pm_runtime_resume_and_get(&pdev->dev);
> +		if (ret < 0)
> +			return ret;
> +	}

Sorry for the delay in review, I'm a novice in pm runtime, but I
haven't forgotten about the remainder of this series.

I think we're removing the unconditional wake here because we now wake
the device in the core registration function below, but I think there
might be a subtle dependency here on the fix to always wake devices in
the disable function as well, otherwise I'm afraid the power state of a
device released in D3hot could leak to the next user here.

>  
>  	/* Don't allow our initial saved state to include busmaster */
>  	pci_clear_master(pdev);
> @@ -405,8 +409,11 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  out:
>  	pci_disable_device(pdev);
>  
> -	if (!vfio_pci_dev_set_try_reset(vdev->vdev.dev_set) && !disable_idle_d3)
> -		vfio_pci_set_power_state(vdev, PCI_D3hot);
> +	vfio_pci_dev_set_try_reset(vdev->vdev.dev_set);
> +
> +	/* Put the pm-runtime usage counter acquired during enable */
> +	if (!disable_idle_d3)
> +		pm_runtime_put(&pdev->dev);
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
>  
> @@ -1847,19 +1854,20 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>  
>  	vfio_pci_probe_power_state(vdev);
>  
> -	if (!disable_idle_d3) {
> -		/*
> -		 * pci-core sets the device power state to an unknown value at
> -		 * bootup and after being removed from a driver.  The only
> -		 * transition it allows from this unknown state is to D0, which
> -		 * typically happens when a driver calls pci_enable_device().
> -		 * We're not ready to enable the device yet, but we do want to
> -		 * be able to get to D3.  Therefore first do a D0 transition
> -		 * before going to D3.
> -		 */
> -		vfio_pci_set_power_state(vdev, PCI_D0);
> -		vfio_pci_set_power_state(vdev, PCI_D3hot);
> -	}
> +	/*
> +	 * pci-core sets the device power state to an unknown value at
> +	 * bootup and after being removed from a driver.  The only
> +	 * transition it allows from this unknown state is to D0, which
> +	 * typically happens when a driver calls pci_enable_device().
> +	 * We're not ready to enable the device yet, but we do want to
> +	 * be able to get to D3.  Therefore first do a D0 transition
> +	 * before enabling runtime PM.
> +	 */
> +	vfio_pci_set_power_state(vdev, PCI_D0);
> +	pm_runtime_allow(&pdev->dev);
> +
> +	if (!disable_idle_d3)
> +		pm_runtime_put(&pdev->dev);

I could use some enlightenment here.  pm_runtime_allow() only does
something if power.runtime_allow is false, in which case it sets that
value to true and decrements power.usage_count.  runtime_allow is
enabled by default in pm_runtime_init(), but pci_pm_init() calls
pm_runtime_forbid() which does the reverse of pm_runtime_allow().  So
do I understand correctly that PCI devices are probed with
runtime_allow = false and a usage_count of 2?

>  
>  	ret = vfio_register_group_dev(&vdev->vdev);
>  	if (ret)
> @@ -1868,7 +1876,9 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>  
>  out_power:
>  	if (!disable_idle_d3)
> -		vfio_pci_set_power_state(vdev, PCI_D0);
> +		pm_runtime_get_noresume(&pdev->dev);
> +
> +	pm_runtime_forbid(&pdev->dev);
>  out_vf:
>  	vfio_pci_vf_uninit(vdev);
>  	return ret;
> @@ -1887,7 +1897,9 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
>  	vfio_pci_vga_uninit(vdev);
>  
>  	if (!disable_idle_d3)
> -		vfio_pci_set_power_state(vdev, PCI_D0);
> +		pm_runtime_get_noresume(&pdev->dev);
> +
> +	pm_runtime_forbid(&pdev->dev);
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
>  
> @@ -2093,33 +2105,62 @@ static bool vfio_pci_dev_set_needs_reset(struct vfio_device_set *dev_set)
>   *  - At least one of the affected devices is marked dirty via
>   *    needs_reset (such as by lack of FLR support)
>   * Then attempt to perform that bus or slot reset.
> - * Returns true if the dev_set was reset.
>   */
> -static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
> +static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
>  {
>  	struct vfio_pci_core_device *cur;
>  	struct pci_dev *pdev;
>  	int ret;
>  
>  	if (!vfio_pci_dev_set_needs_reset(dev_set))
> -		return false;
> +		return;
>  
>  	pdev = vfio_pci_dev_set_resettable(dev_set);
>  	if (!pdev)
> -		return false;
> +		return;
>  
>  	ret = pci_reset_bus(pdev);
>  	if (ret)
> -		return false;
> +		return;
>  
>  	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
>  		cur->needs_reset = false;
> -		if (!disable_idle_d3)
> -			vfio_pci_set_power_state(cur, PCI_D3hot);
> +		if (!disable_idle_d3) {
> +			/*
> +			 * Inside pci_reset_bus(), all the devices in bus/slot
> +			 * will be moved out of D0 state. This state change to

s/out of/into/?

> +			 * D0 can happen directly without going through the
> +			 * runtime PM framework. pm_runtime_resume() will
> +			 * help make the runtime state as active and then
> +			 * pm_request_idle() can be used which will
> +			 * internally check for device usage count and will
> +			 * move the device again into the low power state.
> +			 */
> +			pm_runtime_resume(&pdev->dev);
> +			pm_request_idle(&pdev->dev);
> +		}
>  	}
> -	return true;
>  }
>  
> +#ifdef CONFIG_PM
> +static int vfio_pci_core_runtime_suspend(struct device *dev)
> +{
> +	return 0;
> +}
> +
> +static int vfio_pci_core_runtime_resume(struct device *dev)
> +{
> +	return 0;
> +}
> +
> +const struct dev_pm_ops vfio_pci_core_pm_ops = {
> +	SET_RUNTIME_PM_OPS(vfio_pci_core_runtime_suspend,
> +			   vfio_pci_core_runtime_resume,
> +			   NULL)
> +};
> +EXPORT_SYMBOL_GPL(vfio_pci_core_pm_ops);
> +#endif

It looks like the vfio_pci_core_pm_ops implementation should all be
moved to where we implement D3cold support, it's not necessary to
implement stubs for any of the functionality of this patch.  Thanks,

Alex

> +
>  void vfio_pci_core_set_params(bool is_nointxmask, bool is_disable_vga,
>  			      bool is_disable_idle_d3)
>  {
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index ef9a44b6cf5d..aafe09c9fa64 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -231,6 +231,10 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
>  void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
>  void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
>  
> +#ifdef CONFIG_PM
> +extern const struct dev_pm_ops vfio_pci_core_pm_ops;
> +#endif
> +
>  static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
>  {
>  	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;

