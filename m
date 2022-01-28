Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F9249EF1B
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344203AbiA1AFa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:05:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42842 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235006AbiA1AFa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 19:05:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643328329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1kDY4D1mXvpE1jWkxnC/tXbhdHlfPAHU4sGKUH4Wpqg=;
        b=Irgu40VxbF0u7x+VHZ73qJ9QbbHgLL4w3pfNjZyr/RisdctChLUjvByEv5c91W4SeEjv1k
        QEvo+UcwTKTs53VO/7LyIIDakLgFxJ8b99T7Sdf6DVWL2ykjhP50bmQIAXbKSRE1cHu06w
        GTCAbDeQHdWJjSpi2kLM6cnJtVBXpCE=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-GM3NTfzbO8-EDGTed_3Zww-1; Thu, 27 Jan 2022 19:05:27 -0500
X-MC-Unique: GM3NTfzbO8-EDGTed_3Zww-1
Received: by mail-oi1-f197.google.com with SMTP id t6-20020a056808158600b002cec2812d52so2304063oiw.9
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:05:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1kDY4D1mXvpE1jWkxnC/tXbhdHlfPAHU4sGKUH4Wpqg=;
        b=Hti1lLoBxj3oOhuzrnB552SNKpQN0kkIiS7E4mkKcNEK/Dy0AJzqLUiZzeNWYGThHh
         P3xqaoqTCej1Wq+S7RNusuSRuPOnzF4CDbsKFm2c8uxFfm8jyA1jLKI9TgTc0m41kQfP
         aqYs+X5FIzT56vFHWmOWfKlOr/44SxcJZ+paqlypR5JPgBXYlK+a2DVN4jsn9sKpqpSm
         xB0pCiB0pnBQMHn7W9FFENtR5ZVvfeG3m7sG9orfjCsH+GOhJIUxlxyPE6F7C8XAO9qi
         tY2Xon01nSQgxqwaRDWFdxjWvD7iE7u31um7rPLBwl7X656Day4S4jApQKcYYIg+d8jA
         PkZA==
X-Gm-Message-State: AOAM531EqBT6Ahm3mityM5CSMM8Fra85VMCeCd0n8xfovHtKA46xMyLF
        DvVpTPLZzHdYGF1mTJfr9Sqcqnu8UcnZMJWNqoze2r7Gyhjon9HmhVlVuTVGyqcVbz1WhW7yKi3
        2jd+yl4T4ojmp
X-Received: by 2002:a05:6830:113:: with SMTP id i19mr943102otp.60.1643328327077;
        Thu, 27 Jan 2022 16:05:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyIK94l0A9A3uq1ux/qHbPLg2ctECju1d+LhCK4S59+oHEYaluuSsFzhp9bODyG/4MH44w+CA==
X-Received: by 2002:a05:6830:113:: with SMTP id i19mr943090otp.60.1643328326770;
        Thu, 27 Jan 2022 16:05:26 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id 4sm5672973oon.21.2022.01.27.16.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 16:05:26 -0800 (PST)
Date:   Thu, 27 Jan 2022 17:05:25 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 3/5] vfio/pci: fix memory leak during D3hot to D0
 tranistion
Message-ID: <20220127170525.51043f23.alex.williamson@redhat.com>
In-Reply-To: <20220124181726.19174-4-abhsahu@nvidia.com>
References: <20220124181726.19174-1-abhsahu@nvidia.com>
        <20220124181726.19174-4-abhsahu@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Jan 2022 23:47:24 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> If needs_pm_restore is set (PCI device does not have support for no
> soft reset), then the current PCI state will be saved during D0->D3hot
> transition and same will be restored back during D3hot->D0 transition.
> For saving the PCI state locally, pci_store_saved_state() is being
> used and the pci_load_and_free_saved_state() will free the allocated
> memory.
> 
> But for reset related IOCTLs, vfio driver calls PCI reset related
> API's which will internally change the PCI power state back to D0. So,
> when the guest resumes, then it will get the current state as D0 and it
> will skip the call to vfio_pci_set_power_state() for changing the
> power state to D0 explicitly. In this case, the memory pointed by
> pm_save will never be freed.
> 
> Also, in malicious sequence, the state changing to D3hot followed by
> VFIO_DEVICE_RESET/VFIO_DEVICE_PCI_HOT_RESET can be run in loop and
> it can cause an OOM situation. This patch stores the power state locally
> and uses the same for comparing the current power state. For the
> places where D0 transition can happen, call vfio_pci_set_power_state()
> to transition to D0 state. Since the vfio power state is still D3hot,
> so this D0 transition will help in running the logic required
> from D3hot->D0 transition. Also, to prevent any miss during
> future development to detect this condition, this patch puts a
> check and frees the memory after printing warning.
> 
> This locally saved power state will help in subsequent patches
> also.

Ideally let's put fixes patches at the start of the series, or better
yet send them separately, and don't include changes that only make
sense in the context of a subsequent patch.

Fixes: 51ef3a004b1e ("vfio/pci: Restore device state on PM transition")

> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 53 ++++++++++++++++++++++++++++++--
>  include/linux/vfio_pci_core.h    |  1 +
>  2 files changed, 51 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index c6e4fe9088c3..ee2fb8af57fa 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -206,6 +206,14 @@ static void vfio_pci_probe_power_state(struct vfio_pci_core_device *vdev)
>   * restore when returned to D0.  Saved separately from pci_saved_state for use
>   * by PM capability emulation and separately from pci_dev internal saved state
>   * to avoid it being overwritten and consumed around other resets.
> + *
> + * There are few cases where the PCI power state can be changed to D0
> + * without the involvement of this API. So, cache the power state locally
> + * and call this API to update the D0 state. It will help in running the
> + * logic that is needed for transitioning to the D0 state. For example,
> + * if needs_pm_restore is set, then the PCI state will be saved locally.
> + * The memory taken for saving this PCI state needs to be freed to
> + * prevent memory leak.
>   */
>  int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t state)
>  {
> @@ -214,20 +222,34 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
>  	int ret;
>  
>  	if (vdev->needs_pm_restore) {
> -		if (pdev->current_state < PCI_D3hot && state >= PCI_D3hot) {
> +		if (vdev->power_state < PCI_D3hot && state >= PCI_D3hot) {
>  			pci_save_state(pdev);
>  			needs_save = true;
>  		}
>  
> -		if (pdev->current_state >= PCI_D3hot && state <= PCI_D0)
> +		if (vdev->power_state >= PCI_D3hot && state <= PCI_D0)
>  			needs_restore = true;
>  	}
>  
>  	ret = pci_set_power_state(pdev, state);
>  
>  	if (!ret) {
> +		vdev->power_state = pdev->current_state;
> +
>  		/* D3 might be unsupported via quirk, skip unless in D3 */
> -		if (needs_save && pdev->current_state >= PCI_D3hot) {
> +		if (needs_save && vdev->power_state >= PCI_D3hot) {
> +			/*
> +			 * If somehow, the vfio driver was not able to free the
> +			 * memory allocated in pm_save, then free the earlier
> +			 * memory first before overwriting pm_save to prevent
> +			 * memory leak.
> +			 */
> +			if (vdev->pm_save) {
> +				pci_warn(pdev,
> +					 "Overwriting saved PCI state pointer so freeing the earlier memory\n");
> +				kfree(vdev->pm_save);
> +			}

The minimal fix for the described issue would simply be:

			kfree(vdev->pm_save);

It seems like the only purpose of the warning is try to make sure we
haven't missed any wake-up calls, where this would be a pretty small
breadcrumb to actually debug such an issue.

> +
>  			vdev->pm_save = pci_store_saved_state(pdev);
>  		} else if (needs_restore) {
>  			pci_load_and_free_saved_state(pdev, &vdev->pm_save);
> @@ -326,6 +348,14 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  	/* For needs_reset */
>  	lockdep_assert_held(&vdev->vdev.dev_set->lock);
>  
> +	/*
> +	 * If disable has been called while the power state is other than D0,
> +	 * then set the power state in vfio driver to D0. It will help
> +	 * in running the logic needed for D0 power state. The subsequent
> +	 * runtime PM API's will put the device into the low power state again.
> +	 */
> +	vfio_pci_set_power_state(vdev, PCI_D0);
> +

I do think we have an issue here, but the reason is that pci_pm_reset()
returns -EINVAL if we try to reset a device that isn't currently in D0.
Therefore any path where we're triggering a function reset that could
use a PM reset and we don't know if the device is in D0, should wake up
the device before we try that reset.

We're about to load the initial state of the device that was saved when
it was opened, so I don't think pdev->current_state vs
vdev->power_state matters here, we only care that the device is in D0.

>  	/* Stop the device from further DMA */
>  	pci_clear_master(pdev);
>  
> @@ -929,6 +959,15 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
>  
>  		vfio_pci_zap_and_down_write_memory_lock(vdev);
>  		ret = pci_try_reset_function(vdev->pdev);
> +
> +		/*
> +		 * If pci_try_reset_function() has been called while the power
> +		 * state is other than D0, then pci_try_reset_function() will
> +		 * internally set the device state to D0 without vfio driver
> +		 * interaction. Update the power state in vfio driver to perform
> +		 * the logic needed for D0 power state.
> +		 */
> +		vfio_pci_set_power_state(vdev, PCI_D0);

For the case where pci_try_reset_function() might use a PM reset, we
should set D0 before that call.  In doing so, the pdev->current_state
should match the actual device power state, so we still don't need to
stash power state on the vdev.

>  		up_write(&vdev->memory_lock);
>  
>  		return ret;
> @@ -2071,6 +2110,14 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>  
>  err_undo:
>  	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
> +		/*
> +		 * If pci_reset_bus() has been called while the power
> +		 * state is other than D0, then pci_reset_bus() will
> +		 * internally set the device state to D0 without vfio driver
> +		 * interaction. Update the power state in vfio driver to perform
> +		 * the logic needed for D0 power state.
> +		 */
> +		vfio_pci_set_power_state(cur, PCI_D0);

Here pci_reset_bus() will wakeup the device and I think the concern is
that around that bus reset we'll save and restore the device state, but
that's potentially bogus device state if waking it triggers a soft
reset.  We could again wake devices before the reset to make the state
correct, or we could test pm_save and perform the load and restore if
it exists.  Either of those would avoid needing to cache the power
state on the vdev.  Thanks,

Alex

>  		if (cur == cur_mem)
>  			is_mem = false;
>  		if (cur == cur_vma)
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index aafe09c9fa64..05db838e72cc 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -124,6 +124,7 @@ struct vfio_pci_core_device {
>  	bool			needs_reset;
>  	bool			nointx;
>  	bool			needs_pm_restore;
> +	pci_power_t		power_state;
>  	struct pci_saved_state	*pci_saved_state;
>  	struct pci_saved_state	*pm_save;
>  	int			ioeventfds_nr;

