Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5BC51AE21
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 21:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377593AbiEDTqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 15:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358696AbiEDTqf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 15:46:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 32E9B4D9E0
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 12:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651693376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RGEmRYEdNvJND2/+wEsW7QIppOzBfSn18Tv9D3BrSCY=;
        b=AAPnff4qp5NigwgbnBh2lQudnn0IFZOat4kQe1Z5Fyt/3AvOZ3U7MNyO/83pCLkcD/F4Lp
        R0I6ba44LyvMNtJhN275c3pt9OFI/V1amrmtiZrouzS4l0N/79M5Smq1yqoyRgKIF5O9AJ
        apIkK3wPtRy5Orhd2/5j5eYABrNO27g=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-uNk6Z7qhONmJNHkIcEl1mA-1; Wed, 04 May 2022 15:42:55 -0400
X-MC-Unique: uNk6Z7qhONmJNHkIcEl1mA-1
Received: by mail-io1-f70.google.com with SMTP id 204-20020a6b01d5000000b00657bb7a0f33so1633089iob.4
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 12:42:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=RGEmRYEdNvJND2/+wEsW7QIppOzBfSn18Tv9D3BrSCY=;
        b=erN3QopMJ+hSU5yuq2mAObS2bE9tnC+TgOWhGbTooVdcODzUBJ/BH4pUzLn9yrKnsg
         yEulMUbDKBKmwurUAAa7VJvP4c3X2kDBHESxBUrjwFAx/fduTiMBfHr+Mfd3E98WbLtJ
         cy3jZiicWojpS/kzQjUUKCYaoV6tx1XZNh1+jSVRrenUCgszSjf6fQlOBRLWsDcOFWHA
         6wHA57+YA/ESi0Rbl6hEq8L29QZbc6wdazVEmg65GxLcVMUYBkH4pqsskskAK9Ga2ruC
         6Ra7cvrB692ve0S0xIQci+4PCkEElZat8oTK6707WEHZwYWMqqKSGeybjkCQhFuQQGQe
         +Xpg==
X-Gm-Message-State: AOAM533ivTgh7T74CjObAwfho4vwXmFoPhAXxdgCjNFbPNAa2iIkenmA
        PbdBsUg0UMnUMr/z/1unSwriceYxbOE81Bvrqux3vvO1j0+X8O+PGDGIZdaqbCLtSpcYKYIWluS
        7cktrhtZ60v8h
X-Received: by 2002:a02:a690:0:b0:32b:7cc3:af6c with SMTP id j16-20020a02a690000000b0032b7cc3af6cmr5178067jam.217.1651693373990;
        Wed, 04 May 2022 12:42:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxh/UrybHm6ZrjyaVfMFSjydozfllWg24qx8F49l7BTxLeNYANtdbbA2w1d/Ys0a1oCmL1Ww==
X-Received: by 2002:a02:a690:0:b0:32b:7cc3:af6c with SMTP id j16-20020a02a690000000b0032b7cc3af6cmr5178056jam.217.1651693373688;
        Wed, 04 May 2022 12:42:53 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z2-20020a92da02000000b002cdfeead6basm3540168ilm.63.2022.05.04.12.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 12:42:53 -0700 (PDT)
Date:   Wed, 4 May 2022 13:42:52 -0600
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
Subject: Re: [PATCH v3 5/8] vfio/pci: Enable runtime PM for vfio_pci_core
 based drivers
Message-ID: <20220504134252.6d556d66.alex.williamson@redhat.com>
In-Reply-To: <20220425092615.10133-6-abhsahu@nvidia.com>
References: <20220425092615.10133-1-abhsahu@nvidia.com>
        <20220425092615.10133-6-abhsahu@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Apr 2022 14:56:12 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> Currently, there is very limited power management support
> available in the upstream vfio_pci_core based drivers. If there
> are no users of the device, then the PCI device will be moved into
> D3hot state by writing directly into PCI PM registers. This D3hot
> state help in saving power but we can achieve zero power consumption
> if we go into the D3cold state. The D3cold state cannot be possible
> with native PCI PM. It requires interaction with platform firmware
> which is system-specific. To go into low power states (including D3cold),
> the runtime PM framework can be used which internally interacts with PCI
> and platform firmware and puts the device into the lowest possible
> D-States.
> 
> This patch registers vfio_pci_core based drivers with the
> runtime PM framework.
> 
> 1. The PCI core framework takes care of most of the runtime PM
>    related things. For enabling the runtime PM, the PCI driver needs to
>    decrement the usage count and needs to provide 'struct dev_pm_ops'
>    at least. The runtime suspend/resume callbacks are optional and needed
>    only if we need to do any extra handling. Now there are multiple
>    vfio_pci_core based drivers. Instead of assigning the
>    'struct dev_pm_ops' in individual parent driver, the vfio_pci_core
>    itself assigns the 'struct dev_pm_ops'. There are other drivers where
>    the 'struct dev_pm_ops' is being assigned inside core layer
>    (For example, wlcore_probe() and some sound based driver, etc.).
> 
> 2. This patch provides the stub implementation of 'struct dev_pm_ops'.
>    The subsequent patch will provide the runtime suspend/resume
>    callbacks. All the config state saving, and PCI power management
>    related things will be done by PCI core framework itself inside its
>    runtime suspend/resume callbacks (pci_pm_runtime_suspend() and
>    pci_pm_runtime_resume()).
> 
> 3. Inside pci_reset_bus(), all the devices in dev_set needs to be
>    runtime resumed. vfio_pci_dev_set_pm_runtime_get() will take
>    care of the runtime resume and its error handling.
> 
> 4. Inside vfio_pci_core_disable(), the device usage count always needs
>    to be decremented which was incremented in vfio_pci_core_enable().
> 
> 5. Since the runtime PM framework will provide the same functionality,
>    so directly writing into PCI PM config register can be replaced with
>    the use of runtime PM routines. Also, the use of runtime PM can help
>    us in more power saving.
> 
>    In the systems which do not support D3cold,
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
>    In the systems which support D3cold,
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
> 6. If 'disable_idle_d3' module parameter is set, then also the runtime
>    PM will be enabled, but in this case, the usage count should not be
>    decremented.
> 
> 7. vfio_pci_dev_set_try_reset() return value is unused now, so this
>    function return type can be changed to void.
> 
> 8. Use the runtime PM API's in vfio_pci_core_sriov_configure().
>    For preventing any runtime usage mismatch, pci_num_vf() has been
>    called explicitly during disable.
> 
> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 169 +++++++++++++++++++++----------
>  1 file changed, 114 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 953ac33b2f5f..aee5e0cd6137 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -156,7 +156,7 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
>  }
>  
>  struct vfio_pci_group_info;
> -static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
> +static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
>  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>  				      struct vfio_pci_group_info *groups);
>  
> @@ -261,6 +261,19 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
>  	return ret;
>  }
>  
> +#ifdef CONFIG_PM
> +/*
> + * The dev_pm_ops needs to be provided to make pci-driver runtime PM working,
> + * so use structure without any callbacks.
> + *
> + * The pci-driver core runtime PM routines always save the device state
> + * before going into suspended state. If the device is going into low power
> + * state with only with runtime PM ops, then no explicit handling is needed
> + * for the devices which have NoSoftRst-.
> + */
> +static const struct dev_pm_ops vfio_pci_core_pm_ops = { };
> +#endif
> +
>  int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
> @@ -268,21 +281,23 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>  	u16 cmd;
>  	u8 msix_pos;
>  
> -	vfio_pci_set_power_state(vdev, PCI_D0);
> +	if (!disable_idle_d3) {
> +		ret = pm_runtime_resume_and_get(&pdev->dev);
> +		if (ret < 0)
> +			return ret;
> +	}
>  
>  	/* Don't allow our initial saved state to include busmaster */
>  	pci_clear_master(pdev);
>  
>  	ret = pci_enable_device(pdev);
>  	if (ret)
> -		return ret;
> +		goto out_power;
>  
>  	/* If reset fails because of the device lock, fail this path entirely */
>  	ret = pci_try_reset_function(pdev);
> -	if (ret == -EAGAIN) {
> -		pci_disable_device(pdev);
> -		return ret;
> -	}
> +	if (ret == -EAGAIN)
> +		goto out_disable_device;
>  
>  	vdev->reset_works = !ret;
>  	pci_save_state(pdev);
> @@ -306,12 +321,8 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>  	}
>  
>  	ret = vfio_config_init(vdev);
> -	if (ret) {
> -		kfree(vdev->pci_saved_state);
> -		vdev->pci_saved_state = NULL;
> -		pci_disable_device(pdev);
> -		return ret;
> -	}
> +	if (ret)
> +		goto out_free_state;
>  
>  	msix_pos = pdev->msix_cap;
>  	if (msix_pos) {
> @@ -332,6 +343,16 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
>  
>  
>  	return 0;
> +
> +out_free_state:
> +	kfree(vdev->pci_saved_state);
> +	vdev->pci_saved_state = NULL;
> +out_disable_device:
> +	pci_disable_device(pdev);
> +out_power:
> +	if (!disable_idle_d3)
> +		pm_runtime_put(&pdev->dev);
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
>  
> @@ -439,8 +460,11 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
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
> @@ -1879,19 +1903,24 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev,
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
> +
> +#if defined(CONFIG_PM)
> +	dev->driver->pm = &vfio_pci_core_pm_ops,
> +#endif
> +
> +	pm_runtime_allow(dev);
> +	if (!disable_idle_d3)
> +		pm_runtime_put(dev);
>  
>  	ret = vfio_register_group_dev(&vdev->vdev);
>  	if (ret)
> @@ -1900,7 +1929,9 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev,
>  
>  out_power:
>  	if (!disable_idle_d3)
> -		vfio_pci_set_power_state(vdev, PCI_D0);
> +		pm_runtime_get_noresume(dev);
> +
> +	pm_runtime_forbid(dev);
>  out_vf:
>  	vfio_pci_vf_uninit(vdev);
>  out_drvdata:
> @@ -1922,8 +1953,9 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
>  	vfio_pci_vga_uninit(vdev);
>  
>  	if (!disable_idle_d3)
> -		vfio_pci_set_power_state(vdev, PCI_D0);
> +		pm_runtime_get_noresume(dev);
>  
> +	pm_runtime_forbid(dev);
>  	dev_set_drvdata(dev, NULL);
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
> @@ -1984,18 +2016,26 @@ int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
>  
>  		/*
>  		 * The PF power state should always be higher than the VF power
> -		 * state. If PF is in the low power state, then change the
> -		 * power state to D0 first before enabling SR-IOV.
> +		 * state. If PF is in the runtime suspended state, then resume
> +		 * it first before enabling SR-IOV.
>  		 */
> -		vfio_pci_set_power_state(vdev, PCI_D0);
> -		ret = pci_enable_sriov(pdev, nr_virtfn);
> +		ret = pm_runtime_resume_and_get(&pdev->dev);
>  		if (ret)
>  			goto out_del;
> +
> +		ret = pci_enable_sriov(pdev, nr_virtfn);
> +		if (ret) {
> +			pm_runtime_put(&pdev->dev);
> +			goto out_del;
> +		}
>  		ret = nr_virtfn;
>  		goto out_put;
>  	}
>  
> -	pci_disable_sriov(pdev);
> +	if (pci_num_vf(pdev)) {
> +		pci_disable_sriov(pdev);
> +		pm_runtime_put(&pdev->dev);
> +	}
>  
>  out_del:
>  	mutex_lock(&vfio_pci_sriov_pfs_mutex);
> @@ -2072,6 +2112,30 @@ vfio_pci_dev_set_resettable(struct vfio_device_set *dev_set)
>  	return pdev;
>  }
>  
> +static int vfio_pci_dev_set_pm_runtime_get(struct vfio_device_set *dev_set)
> +{
> +	struct vfio_pci_core_device *cur_pm;
> +	struct vfio_pci_core_device *cur;
> +	int ret = 0;
> +
> +	list_for_each_entry(cur_pm, &dev_set->device_list, vdev.dev_set_list) {
> +		ret = pm_runtime_resume_and_get(&cur_pm->pdev->dev);
> +		if (ret < 0)
> +			break;
> +	}
> +
> +	if (!ret)
> +		return 0;
> +
> +	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
> +		if (cur == cur_pm)
> +			break;
> +		pm_runtime_put(&cur->pdev->dev);
> +	}
> +
> +	return ret;
> +}

The above works, but maybe could be a little cleaner taking advantage
of list_for_each_entry_continue_reverse as:

{
	struct vfio_pci_core_device *cur;
	int ret;

	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
		ret = pm_runtime_resume_and_get(&cur->pdev->dev);
		if (ret)
			goto unwind;
	}

	return 0;

unwind:
	list_for_each_entry_continue_reverse(cur, &dev_set->device_list, vdev.dev_set_list)
		pm_runtime_put(&cur->pdev->dev);

	return ret;
}

Thanks,
Alex

> +
>  /*
>   * We need to get memory_lock for each device, but devices can share mmap_lock,
>   * therefore we need to zap and hold the vma_lock for each device, and only then
> @@ -2178,43 +2242,38 @@ static bool vfio_pci_dev_set_needs_reset(struct vfio_device_set *dev_set)
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
> -	int ret;
> +	bool reset_done = false;
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
>  	/*
> -	 * The pci_reset_bus() will reset all the devices in the bus.
> -	 * The power state can be non-D0 for some of the devices in the bus.
> -	 * For these devices, the pci_reset_bus() will internally set
> -	 * the power state to D0 without vfio driver involvement.
> -	 * For the devices which have NoSoftRst-, the reset function can
> -	 * cause the PCI config space reset without restoring the original
> -	 * state (saved locally in 'vdev->pm_save').
> +	 * Some of the devices in the bus can be in the runtime suspended
> +	 * state. Increment the usage count for all the devices in the dev_set
> +	 * before reset and decrement the same after reset.
>  	 */
> -	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
> -		vfio_pci_set_power_state(cur, PCI_D0);
> +	if (!disable_idle_d3 && vfio_pci_dev_set_pm_runtime_get(dev_set))
> +		return;
>  
> -	ret = pci_reset_bus(pdev);
> -	if (ret)
> -		return false;
> +	if (!pci_reset_bus(pdev))
> +		reset_done = true;
>  
>  	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
> -		cur->needs_reset = false;
> +		if (reset_done)
> +			cur->needs_reset = false;
> +
>  		if (!disable_idle_d3)
> -			vfio_pci_set_power_state(cur, PCI_D3hot);
> +			pm_runtime_put(&cur->pdev->dev);
>  	}
> -	return true;
>  }
>  
>  void vfio_pci_core_set_params(bool is_nointxmask, bool is_disable_vga,

