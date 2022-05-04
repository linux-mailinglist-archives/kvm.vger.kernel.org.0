Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A684E51AE4A
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 21:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355177AbiEDTtf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 15:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357418AbiEDTte (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 15:49:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 53FF64D61A
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 12:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651693555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lqWDETaBSM1oXhA2yig1NgRvStszOkEoUDnZv1hPIn0=;
        b=ZjNTNgmg4+7fRWhFjoUUKUeknJc4RLC7t/njCQhRGDTttwKNceTUT/dqynl4Q1hv0wi3Tp
        9HlwiwBWot92LPlN/ej2W+p1oltMcDvVQii59w9+V0ojA9ci8G1ze5fcxFJeUjXNJc97ur
        iQx9aRn/2l7YdF+o8dXyJxPXMRYylW8=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-pfFcj_NtMZeMcF5irtv0-w-1; Wed, 04 May 2022 15:45:54 -0400
X-MC-Unique: pfFcj_NtMZeMcF5irtv0-w-1
Received: by mail-il1-f199.google.com with SMTP id q6-20020a056e0215c600b002c2c4091914so1232391ilu.14
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 12:45:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=lqWDETaBSM1oXhA2yig1NgRvStszOkEoUDnZv1hPIn0=;
        b=IBwPjN4GpP1PHWkAesb79A3jZvT6BzxpXLZqFemKhuUfKHk3RAjVqN0vY/n1rJyTOp
         kQtbdFZrnRgSfksliBIIv0L+gMDbBJY3qLcz4VEe5sTSKKdWpMfuLGOumAG2vfGC0FI2
         SkrJbJd9E3NC+JBNgP0rJYwoWEHHPU9zhiRTUHBkSD47QomQoYhyUqw0k8tHbOwInyxy
         1YkIn6wFm8jM6g2OFIzzYYhzsd3UG+Ne4+Bb083UofKi/LCzVP57hqfULF9hIh21kip0
         uwOjldgztp+NULSxJ12TxV3SqPB+Vaaz1Jv0hHpF+QNNHNOSxgFN4plN6uMZZLnJQVFD
         6i9Q==
X-Gm-Message-State: AOAM5312IR2PIXjX4OBpvgiUb1Bb4enWGOkc8iKKvFYKSCEgeFPpm0AF
        jSGWqEcvzZEXEcafkOBaCfrv33y8NDDL9lwHIMPAiq/044++vCgEkGvxeiQLvRwAGpFr46w6iUO
        t6SZVACKpz9RB
X-Received: by 2002:a05:6e02:15ca:b0:2bf:ad58:4a6d with SMTP id q10-20020a056e0215ca00b002bfad584a6dmr10003560ilu.13.1651693553305;
        Wed, 04 May 2022 12:45:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBakRcByTrf10xyeQeGfa+sU4WiMUSIDJQCSTaCOy9e2ypvJuTO0BS6idX86lmgQoYQGz23g==
X-Received: by 2002:a05:6e02:15ca:b0:2bf:ad58:4a6d with SMTP id q10-20020a056e0215ca00b002bfad584a6dmr10003532ilu.13.1651693552896;
        Wed, 04 May 2022 12:45:52 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w26-20020a02b0da000000b0032b3a781784sm4926652jah.72.2022.05.04.12.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 12:45:52 -0700 (PDT)
Date:   Wed, 4 May 2022 13:45:51 -0600
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
Subject: Re: [PATCH v3 8/8] vfio/pci: Add the support for PCI D3cold state
Message-ID: <20220504134551.70d71bf0.alex.williamson@redhat.com>
In-Reply-To: <20220425092615.10133-9-abhsahu@nvidia.com>
References: <20220425092615.10133-1-abhsahu@nvidia.com>
        <20220425092615.10133-9-abhsahu@nvidia.com>
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

On Mon, 25 Apr 2022 14:56:15 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> Currently, if the runtime power management is enabled for vfio pci
> based device in the guest OS, then guest OS will do the register
> write for PCI_PM_CTRL register. This write request will be handled in
> vfio_pm_config_write() where it will do the actual register write
> of PCI_PM_CTRL register. With this, the maximum D3hot state can be
> achieved for low power. If we can use the runtime PM framework,
> then we can achieve the D3cold state which will help in saving
> maximum power.
> 
> 1. Since D3cold state can't be achieved by writing PCI standard
>    PM config registers, so this patch adds a new feature in the
>    existing VFIO_DEVICE_FEATURE IOCTL. This IOCTL can be used
>    to change the PCI device from D3hot to D3cold state and
>    then D3cold to D0 state. The device feature uses low power term
>    instead of D3cold so that if other vfio driver wants to implement
>    low power support, then the same IOCTL can be used.

How does this enable you to handle the full-off vs memory-refresh modes
for NVIDIA GPUs?

The feature ioctl supports a probe, but here the probe only indicates
that the ioctl is available, not what degree of low power support
available.  Even if the host doesn't support d3cold for the device, we
can still achieve root port d3hot, but can we provide further
capability info to the user?
 
> 2. The hypervisors can implement virtual ACPI methods. For
>    example, in guest linux OS if PCI device ACPI node has _PR3 and _PR0
>    power resources with _ON/_OFF method, then guest linux OS makes the
>    _OFF call during D3cold transition and then _ON during D0 transition.
>    The hypervisor can tap these virtual ACPI calls and then do the D3cold
>    related IOCTL in the vfio driver.
> 
> 3. The vfio driver uses runtime PM framework to achieve the
>    D3cold state. For the D3cold transition, decrement the usage count and
>    for the D0 transition, increment the usage count.
> 
> 4. For D3cold, the device current power state should be D3hot.
>    Then during runtime suspend, the pci_platform_power_transition() is
>    required for D3cold state. If the D3cold state is not supported, then
>    the device will still be in D3hot state. But with the runtime PM, the
>    root port can now also go into suspended state.

Why do we create this requirement for the device to be in d3hot prior
to entering low power when our pm ops suspend function wakes the device
do d0?

> 5. For most of the systems, the D3cold is supported at the root
>    port level. So, when root port will transition to D3cold state, then
>    the vfio PCI device will go from D3hot to D3cold state during its
>    runtime suspend. If root port does not support D3cold, then the root
>    will go into D3hot state.
> 
> 6. The runtime suspend callback can now happen for 2 cases: there
>    are no users of vfio device and the case where user has initiated
>    D3cold. The 'platform_pm_engaged' flag can help to distinguish
>    between these 2 cases.

If this were the only use case we could rely on vfio_device.open_count
instead.  I don't think it is though.
 
> 7. In D3cold, all kind of BAR related access needs to be disabled
>    like D3hot. Additionally, the config space will also be disabled in
>    D3cold state. To prevent access of config space in D3cold state, do
>    increment the runtime PM usage count before doing any config space
>    access.

Or we could actually prevent access to config space rather than waking
the device for the access.  Addressed in further comment below.
 
> 8. If user has engaged low power entry through IOCTL, then user should
>    do low power exit first. The user can issue config access or IOCTL
>    after low power entry. We can add an explicit error check but since
>    we are already waking-up device, so IOCTL and config access can be
>    fulfilled. But 'power_state_d3' won't be cleared without issuing
>    low power exit so all BAR related access will still return error till
>    user do low power exit.

The fact that power_state_d3 no longer tracks the device power state
when platform_pm_engaged is set is a confusing discontinuity.

> 9. Since multiple layers are involved, so following is the high level
>    code flow for D3cold entry and exit.
> 
> D3cold entry:
> 
> a. User put the PCI device into D3hot by writing into standard config
>    register (vfio_pm_config_write() -> vfio_lock_and_set_power_state() ->
>    vfio_pci_set_power_state()). The device power state will be D3hot and
>    power_state_d3 will be true.
> b. Set vfio_device_feature_power_management::low_power_state =
>    VFIO_DEVICE_LOW_POWER_STATE_ENTER and call VFIO_DEVICE_FEATURE IOCTL.
> c. Inside vfio_device_fops_unl_ioctl(), pm_runtime_resume_and_get()
>    will be called first which will make the usage count as 2 and then
>    vfio_pci_core_ioctl_feature() will be invoked.
> d. vfio_pci_core_feature_pm() will be called and it will go inside
>    VFIO_DEVICE_LOW_POWER_STATE_ENTER switch case. platform_pm_engaged will
>    be true and pm_runtime_put_noidle() will decrement the usage count
>    to 1.
> e. Inside vfio_device_fops_unl_ioctl() while returning the
>    pm_runtime_put() will make the usage count to 0 and the runtime PM
>    framework will engage the runtime suspend entry.
> f. pci_pm_runtime_suspend() will be called and invokes driver runtime
>    suspend callback.
> g. vfio_pci_core_runtime_suspend() will change the power state to D0
>    and do the INTx mask related handling.
> h. pci_pm_runtime_suspend() will take care of saving the PCI state and
>    all power management handling for D3cold.
> 
> D3cold exit:
> 
> a. Set vfio_device_feature_power_management::low_power_state =
>    VFIO_DEVICE_LOW_POWER_STATE_EXIT and call VFIO_DEVICE_FEATURE IOCTL.
> b. Inside vfio_device_fops_unl_ioctl(), pm_runtime_resume_and_get()
>    will be called first which will make the usage count as 1.
> c. pci_pm_runtime_resume() will take care of moving the device into D0
>    state again and then vfio_pci_core_runtime_resume() will be called.
> d. vfio_pci_core_runtime_resume() will do the INTx unmask related
>    handling.
> e. vfio_pci_core_ioctl_feature() will be invoked.
> f. vfio_pci_core_feature_pm() will be called and it will go inside
>    VFIO_DEVICE_LOW_POWER_STATE_EXIT switch case. platform_pm_engaged and
>    power_state_d3 will be cleared and pm_runtime_get_noresume() will make
>    the usage count as 2.
> g. Inside vfio_device_fops_unl_ioctl() while returning the
>    pm_runtime_put() will make the usage count to 1 and the device will
>    be in D0 state only.
> 
> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_config.c |  11 ++-
>  drivers/vfio/pci/vfio_pci_core.c   | 131 ++++++++++++++++++++++++++++-
>  include/linux/vfio_pci_core.h      |   1 +
>  include/uapi/linux/vfio.h          |  18 ++++
>  4 files changed, 159 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> index af0ae80ef324..65b1bc9586ab 100644
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
> @@ -1936,16 +1937,23 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
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

Alternatively we could just check platform_pm_engaged here and return
-EINVAL, right?  Why is waking the device the better option?

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
> @@ -1953,6 +1961,7 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
>  		pos += ret;
>  	}
>  
> +	pm_runtime_put(dev);
>  	*ppos += done;
>  
>  	return done;
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 05a68ca9d9e7..beac6e05f97f 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -234,7 +234,14 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
>  	ret = pci_set_power_state(pdev, state);
>  
>  	if (!ret) {
> -		vdev->power_state_d3 = (pdev->current_state >= PCI_D3hot);
> +		/*
> +		 * If 'platform_pm_engaged' is true then 'power_state_d3' can
> +		 * be cleared only when user makes the explicit request to
> +		 * move out of low power state by using power management ioctl.
> +		 */
> +		if (!vdev->platform_pm_engaged)
> +			vdev->power_state_d3 =
> +				(pdev->current_state >= PCI_D3hot);

power_state_d3 is essentially only used as a secondary test to
__vfio_pci_memory_enabled() to block r/w access to device regions and
generate a fault on mmap access.  Its existence already seems a little
questionable when we could just look at vdev->pdev->current_state, and
we could incorporate that into __vfio_pci_memory_enabled().  So rather
than creating this inconsistency, couldn't we just make that function
return:

!vdev->platform_pm_enagaged && pdev->current_state < PCI_D3hot &&
(pdev->no_command_memory || (cmd & PCI_COMMAND_MEMORY))


>  
>  		/* D3 might be unsupported via quirk, skip unless in D3 */
>  		if (needs_save && pdev->current_state >= PCI_D3hot) {
> @@ -266,6 +273,25 @@ static int vfio_pci_core_runtime_suspend(struct device *dev)
>  {
>  	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
>  
> +	down_read(&vdev->memory_lock);
> +
> +	/* 'platform_pm_engaged' will be false if there are no users. */
> +	if (!vdev->platform_pm_engaged) {
> +		up_read(&vdev->memory_lock);
> +		return 0;
> +	}
> +
> +	/*
> +	 * The user will move the device into D3hot state first before invoking
> +	 * power management ioctl. Move the device into D0 state here and then
> +	 * the pci-driver core runtime PM suspend will move the device into
> +	 * low power state. Also, for the devices which have NoSoftRst-,
> +	 * it will help in restoring the original state (saved locally in
> +	 * 'vdev->pm_save').
> +	 */
> +	vfio_pci_set_power_state(vdev, PCI_D0);
> +	up_read(&vdev->memory_lock);
> +
>  	/*
>  	 * If INTx is enabled, then mask INTx before going into runtime
>  	 * suspended state and unmask the same in the runtime resume.
> @@ -395,6 +421,19 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  
>  	/*
>  	 * This function can be invoked while the power state is non-D0.
> +	 * This non-D0 power state can be with or without runtime PM.
> +	 * Increment the usage count corresponding to pm_runtime_put()
> +	 * called during setting of 'platform_pm_engaged'. The device will
> +	 * wake up if it has already went into suspended state. Otherwise,
> +	 * the next vfio_pci_set_power_state() will change the
> +	 * device power state to D0.
> +	 */
> +	if (vdev->platform_pm_engaged) {
> +		pm_runtime_resume_and_get(&pdev->dev);
> +		vdev->platform_pm_engaged = false;
> +	}
> +
> +	/*
>  	 * This function calls __pci_reset_function_locked() which internally
>  	 * can use pci_pm_reset() for the function reset. pci_pm_reset() will
>  	 * fail if the power state is non-D0. Also, for the devices which
> @@ -1192,6 +1231,80 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
>  
> +#ifdef CONFIG_PM
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
> +		vfio_pm.low_power_state = vdev->platform_pm_engaged ?
> +				VFIO_DEVICE_LOW_POWER_STATE_ENTER :
> +				VFIO_DEVICE_LOW_POWER_STATE_EXIT;
> +		up_read(&vdev->memory_lock);
> +		if (copy_to_user(arg, &vfio_pm, sizeof(vfio_pm)))
> +			return -EFAULT;
> +		return 0;
> +	}
> +
> +	if (copy_from_user(&vfio_pm, arg, sizeof(vfio_pm)))
> +		return -EFAULT;
> +
> +	/*
> +	 * The vdev power related fields are protected with memory_lock
> +	 * semaphore.
> +	 */
> +	down_write(&vdev->memory_lock);
> +	switch (vfio_pm.low_power_state) {
> +	case VFIO_DEVICE_LOW_POWER_STATE_ENTER:
> +		if (!vdev->power_state_d3 || vdev->platform_pm_engaged) {
> +			ret = EINVAL;
> +			break;
> +		}
> +
> +		vdev->platform_pm_engaged = true;
> +
> +		/*
> +		 * The pm_runtime_put() will be called again while returning
> +		 * from ioctl after which the device can go into runtime
> +		 * suspended.
> +		 */
> +		pm_runtime_put_noidle(&pdev->dev);
> +		break;
> +
> +	case VFIO_DEVICE_LOW_POWER_STATE_EXIT:
> +		if (!vdev->platform_pm_engaged) {
> +			ret = EINVAL;
> +			break;
> +		}
> +
> +		vdev->platform_pm_engaged = false;
> +		vdev->power_state_d3 = false;
> +		pm_runtime_get_noresume(&pdev->dev);
> +		break;
> +
> +	default:
> +		ret = EINVAL;
> +		break;
> +	}
> +
> +	up_write(&vdev->memory_lock);
> +	return ret;
> +}
> +#endif
> +
>  static int vfio_pci_core_feature_token(struct vfio_device *device, u32 flags,
>  				       void __user *arg, size_t argsz)
>  {
> @@ -1226,6 +1339,10 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
>  	switch (flags & VFIO_DEVICE_FEATURE_MASK) {
>  	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
>  		return vfio_pci_core_feature_token(device, flags, arg, argsz);
> +#ifdef CONFIG_PM
> +	case VFIO_DEVICE_FEATURE_POWER_MANAGEMENT:
> +		return vfio_pci_core_feature_pm(device, flags, arg, argsz);
> +#endif
>  	default:
>  		return -ENOTTY;
>  	}
> @@ -2189,6 +2306,15 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
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
> @@ -2244,6 +2370,9 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
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
> index e84f31e44238..337983a877d6 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -126,6 +126,7 @@ struct vfio_pci_core_device {
>  	bool			needs_pm_restore;
>  	bool			power_state_d3;
>  	bool			pm_intx_masked;
> +	bool			platform_pm_engaged;
>  	struct pci_saved_state	*pci_saved_state;
>  	struct pci_saved_state	*pm_save;
>  	int			ioeventfds_nr;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index fea86061b44e..53ff890dbd27 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -986,6 +986,24 @@ enum vfio_device_mig_state {
>  	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
>  };
>  
> +/*
> + * Use platform-based power management for moving the device into low power
> + * state.  This low power state is device specific.
> + *
> + * For PCI, this low power state is D3cold.  The native PCI power management
> + * does not support the D3cold power state.  For moving the device into D3cold
> + * state, change the PCI state to D3hot with standard configuration registers
> + * and then call this IOCTL to setting the D3cold state.  Similarly, if the
> + * device in D3cold state, then call this IOCTL to exit from D3cold state.
> + */
> +struct vfio_device_feature_power_management {
> +#define VFIO_DEVICE_LOW_POWER_STATE_EXIT	0x0
> +#define VFIO_DEVICE_LOW_POWER_STATE_ENTER	0x1
> +	__u64	low_power_state;
> +};
> +
> +#define VFIO_DEVICE_FEATURE_POWER_MANAGEMENT	3

__u8 seems more than sufficient here.  Thanks,

Alex

> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
>  
>  /**

