Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29C7568E02
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 17:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbiGFPs0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 11:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbiGFPsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 11:48:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90F6C2BB3E
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 08:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657122056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LEoUbxgsePf+OXuUNkCuNmp2U3FI3n3qfmJydYglPV4=;
        b=izuvelDxI9LawtXwwSvKteCxk6Kom2DvkKAEM/tm5DtR8t+brKa6oIjsK+XEZVeFICPW41
        FEF5QdQ4g+BYwtyhmsn/WcLAj3EIt34s7CLlCx8w4alRyfgYUHLGSskqsDE9S6A4Ef2Ald
        OSya7DXK9j4DXmqfpjCxtRPbW6ToXTk=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-176-YheD5da5NRKZJqkA-vVWdg-1; Wed, 06 Jul 2022 11:40:55 -0400
X-MC-Unique: YheD5da5NRKZJqkA-vVWdg-1
Received: by mail-io1-f69.google.com with SMTP id r18-20020a6bd912000000b00675a6c915c9so8380233ioc.10
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 08:40:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=LEoUbxgsePf+OXuUNkCuNmp2U3FI3n3qfmJydYglPV4=;
        b=ZYffqI6PoM8xCRsEJmKpQ6qYVoO/uR7GgF50f6DDoAbwKDUzTCoG4qE1ktMDLE9oaj
         t0zTq/vO/oIUSIx4RRpo2qG5JDI3PTJSyk8Hj5HjnwdMVgtSxEjnTTgXFwNzc0y0nKBg
         R2gnhRjSA4j6u9QnrqlJ4Qn+vFBosVwWpObuB6w47OGxmgsnvasR7oFZ12gjHFXZItlz
         /V6iU4PooAw4XCaYUOSbCwNVF68ucijwYmgSPqc6az9OnTTi0S3Zu06H6MAsfxIY3CxB
         tBIFYG1fvcO6MurqdjkPeZRGJsf0uDQpMZ28ow6nsOHI++vGoAMb+BVXOOJGutgaYQQ1
         Zpcw==
X-Gm-Message-State: AJIora9ZnI1VoP22g95BKbfutujk7vv3LX1W41C20nWocQBw4kzj/W2U
        Qt2pLcKBisqXJ8kR+HOS0KmCgooVrEgImbfQ6ofDy4ZbbATHAFpR9zLPIjZSJS6lpX/QncJcGfe
        dCSxJd5Kb1yf7
X-Received: by 2002:a05:6602:1802:b0:675:7d87:aacf with SMTP id t2-20020a056602180200b006757d87aacfmr22783707ioh.110.1657122054767;
        Wed, 06 Jul 2022 08:40:54 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uw3J8g+FHvcgDOZiei+pAS2xPcEwiEhiLpXoXncwE3BpEJ7hqCd3vxBziEnUMPcby61f6v4w==
X-Received: by 2002:a05:6602:1802:b0:675:7d87:aacf with SMTP id t2-20020a056602180200b006757d87aacfmr22783682ioh.110.1657122054454;
        Wed, 06 Jul 2022 08:40:54 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id d12-20020a0566022bec00b0066958ec56d9sm17003884ioy.40.2022.07.06.08.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 08:40:53 -0700 (PDT)
Date:   Wed, 6 Jul 2022 09:40:21 -0600
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
Subject: Re: [PATCH v4 5/6] vfio/pci: Prevent low power re-entry without
 guest driver
Message-ID: <20220706094021.39b0ef73.alex.williamson@redhat.com>
In-Reply-To: <20220701110814.7310-6-abhsahu@nvidia.com>
References: <20220701110814.7310-1-abhsahu@nvidia.com>
        <20220701110814.7310-6-abhsahu@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 1 Jul 2022 16:38:13 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> Some devices (Like NVIDIA VGA or 3D controller) require driver
> involvement each time before going into D3cold. In the regular flow,
> the guest driver do all the required steps inside the guest OS and
> then the IOCTL will be called for D3cold entry by the hypervisor. Now,
> if there is any activity on the host side (For example user has run
> lspci, dump the config space through sysfs, etc.), then the runtime PM
> framework will resume the device first, perform the operation and then
> suspend the device again. This second time suspend will be without
> guest driver involvement. This patch adds the support to prevent
> second-time runtime suspend if there is any wake-up. This prevention
> is either based on the predefined vendor/class id list or the user can
> specify the flag (VFIO_PM_LOW_POWER_REENTERY_DISABLE) during entry for
> the same.
> 
> 'pm_runtime_reentry_allowed' flag tracks if this re-entry is allowed.
> It will be set during the entry time.
> 
> 'pm_runtime_resumed' flag tracks if there is any wake-up before the
> guest performs the wake-up. If re-entry is not allowed, then during
> runtime resume, the runtime PM count will be incremented, and this
> flag will be set. This flag will be checked during guest D3cold exit
> and then skip the runtime PM-related handling if this flag is set.
> 
> During guest low power exit time, all vdev power-related flags are
> accessed under 'memory_lock' and usage count will be incremented. The
> resume will be triggered after releasing the lock since the runtime
> resume callback again requires the lock. pm_runtime_get_noresume()/
> pm_runtime_resume() have been used instead of
> pm_runtime_resume_and_get() to handle the following scenario during
> the race condition.
> 
>  a. The guest triggered the low power exit.
>  b. The guest thread got the lock and cleared the vdev related
>     flags and released the locks.
>  c. Before pm_runtime_resume_and_get(), the host lspci thread got
>     scheduled and triggered the runtime resume.
>  d. Now, all the vdev related flags are cleared so there won't be
>     any extra handling inside the runtime resume.
>  e. The runtime PM put the device again into the suspended state.
>  f. The guest triggered pm_runtime_resume_and_get() got called.
> 
> So, at step (e), the suspend is happening without the guest driver
> involvement. Now, by using pm_runtime_get_noresume() before releasing
> 'memory_lock', the runtime PM framework can't suspend the device due
> to incremented usage count.

Nak, this policy should be implemented in userspace.  Thanks,

Alex
 
> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 87 ++++++++++++++++++++++++++++++--
>  include/linux/vfio_pci_core.h    |  2 +
>  2 files changed, 84 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 8c17ca41d156..1ddaaa6ccef5 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -191,6 +191,20 @@ static bool vfio_pci_nointx(struct pci_dev *pdev)
>  	return false;
>  }
>  
> +static bool vfio_pci_low_power_reentry_allowed(struct pci_dev *pdev)
> +{
> +	/*
> +	 * The NVIDIA display class requires driver involvement for every
> +	 * D3cold entry. The audio and other classes can go into D3cold
> +	 * without driver involvement.
> +	 */
> +	if (pdev->vendor == PCI_VENDOR_ID_NVIDIA &&
> +	    ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY))
> +		return false;
> +
> +	return true;
> +}
> +
>  static void vfio_pci_probe_power_state(struct vfio_pci_core_device *vdev)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
> @@ -295,6 +309,27 @@ static int vfio_pci_core_runtime_resume(struct device *dev)
>  	if (vdev->pm_intx_masked)
>  		vfio_pci_intx_unmask(vdev);
>  
> +	down_write(&vdev->memory_lock);
> +
> +	/*
> +	 * The runtime resume callback will be called for one of the following
> +	 * two cases:
> +	 *
> +	 * - If the user has called IOCTL explicitly to move the device out of
> +	 *   the low power state or closed the device.
> +	 * - If there is device access on the host side.
> +	 *
> +	 * For the second case, check if re-entry to the low power state is
> +	 * allowed. If not, then increment the usage count so that runtime PM
> +	 * framework won't suspend the device and set the 'pm_runtime_resumed'
> +	 * flag.
> +	 */
> +	if (vdev->pm_runtime_engaged && !vdev->pm_runtime_reentry_allowed) {
> +		pm_runtime_get_noresume(dev);
> +		vdev->pm_runtime_resumed = true;
> +	}
> +	up_write(&vdev->memory_lock);
> +
>  	return 0;
>  }
>  #endif /* CONFIG_PM */
> @@ -415,9 +450,12 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
>  	 */
>  	down_write(&vdev->memory_lock);
>  	if (vdev->pm_runtime_engaged) {
> +		if (!vdev->pm_runtime_resumed) {
> +			pm_runtime_get_noresume(&pdev->dev);
> +			do_resume = true;
> +		}
> +		vdev->pm_runtime_resumed = false;
>  		vdev->pm_runtime_engaged = false;
> -		pm_runtime_get_noresume(&pdev->dev);
> -		do_resume = true;
>  	}
>  	up_write(&vdev->memory_lock);
>  
> @@ -1227,12 +1265,17 @@ static int vfio_pci_pm_validate_flags(u32 flags)
>  	if (!flags)
>  		return -EINVAL;
>  	/* Only valid flags should be set */
> -	if (flags & ~(VFIO_PM_LOW_POWER_ENTER | VFIO_PM_LOW_POWER_EXIT))
> +	if (flags & ~(VFIO_PM_LOW_POWER_ENTER | VFIO_PM_LOW_POWER_EXIT |
> +		      VFIO_PM_LOW_POWER_REENTERY_DISABLE))
>  		return -EINVAL;
>  	/* Both enter and exit should not be set */
>  	if ((flags & (VFIO_PM_LOW_POWER_ENTER | VFIO_PM_LOW_POWER_EXIT)) ==
>  	    (VFIO_PM_LOW_POWER_ENTER | VFIO_PM_LOW_POWER_EXIT))
>  		return -EINVAL;
> +	/* re-entry disable can only be set with enter */
> +	if ((flags & VFIO_PM_LOW_POWER_REENTERY_DISABLE) &&
> +	    !(flags & VFIO_PM_LOW_POWER_ENTER))
> +		return -EINVAL;
>  
>  	return 0;
>  }
> @@ -1255,10 +1298,17 @@ static int vfio_pci_core_feature_pm(struct vfio_device *device, u32 flags,
>  
>  	if (flags & VFIO_DEVICE_FEATURE_GET) {
>  		down_read(&vdev->memory_lock);
> -		if (vdev->pm_runtime_engaged)
> +		if (vdev->pm_runtime_engaged) {
>  			vfio_pm.flags = VFIO_PM_LOW_POWER_ENTER;
> -		else
> +			if (!vdev->pm_runtime_reentry_allowed)
> +				vfio_pm.flags |=
> +					VFIO_PM_LOW_POWER_REENTERY_DISABLE;
> +		} else {
>  			vfio_pm.flags = VFIO_PM_LOW_POWER_EXIT;
> +			if (!vfio_pci_low_power_reentry_allowed(pdev))
> +				vfio_pm.flags |=
> +					VFIO_PM_LOW_POWER_REENTERY_DISABLE;
> +		}
>  		up_read(&vdev->memory_lock);
>  
>  		if (copy_to_user(arg, &vfio_pm, sizeof(vfio_pm)))
> @@ -1286,6 +1336,19 @@ static int vfio_pci_core_feature_pm(struct vfio_device *device, u32 flags,
>  		}
>  
>  		vdev->pm_runtime_engaged = true;
> +		vdev->pm_runtime_resumed = false;
> +
> +		/*
> +		 * If there is any access when the device is in the runtime
> +		 * suspended state, then the device will be resumed first
> +		 * before access and then the device will be suspended again.
> +		 * Check if this second time suspend is allowed and track the
> +		 * same in 'pm_runtime_reentry_allowed' flag.
> +		 */
> +		vdev->pm_runtime_reentry_allowed =
> +			vfio_pci_low_power_reentry_allowed(pdev) &&
> +			!(vfio_pm.flags & VFIO_PM_LOW_POWER_REENTERY_DISABLE);
> +
>  		up_write(&vdev->memory_lock);
>  		pm_runtime_put(&pdev->dev);
>  	} else if (vfio_pm.flags & VFIO_PM_LOW_POWER_EXIT) {
> @@ -1296,6 +1359,20 @@ static int vfio_pci_core_feature_pm(struct vfio_device *device, u32 flags,
>  		}
>  
>  		vdev->pm_runtime_engaged = false;
> +		if (vdev->pm_runtime_resumed) {
> +			vdev->pm_runtime_resumed = false;
> +			up_write(&vdev->memory_lock);
> +			return 0;
> +		}
> +
> +		/*
> +		 * The 'memory_lock' will be acquired again inside the runtime
> +		 * resume callback. So, increment the usage count inside the
> +		 * lock and call pm_runtime_resume() after releasing the lock.
> +		 * If there is any race condition between the wake-up generated
> +		 * at the host and the current path. Then the incremented usage
> +		 * count will prevent the device to go into the suspended state.
> +		 */
>  		pm_runtime_get_noresume(&pdev->dev);
>  		up_write(&vdev->memory_lock);
>  		ret = pm_runtime_resume(&pdev->dev);
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index bf4823b008f9..18cc83b767b8 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -126,6 +126,8 @@ struct vfio_pci_core_device {
>  	bool			needs_pm_restore;
>  	bool			pm_intx_masked;
>  	bool			pm_runtime_engaged;
> +	bool			pm_runtime_resumed;
> +	bool			pm_runtime_reentry_allowed;
>  	struct pci_saved_state	*pci_saved_state;
>  	struct pci_saved_state	*pm_save;
>  	int			ioeventfds_nr;

