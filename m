Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2EA57D6EE
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 00:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbiGUWex (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 18:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiGUWev (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 18:34:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 06065796BA
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 15:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658442888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FbHoTM5Rt91OdmCyo1W3xeRtGZ9iC9uA5MFK7g8w+Fg=;
        b=Ks/h8aZhClK8Mk9OFL7G+GvG2Lee+T28pMQg03UYyqdtxjUpJ1usCuql1H8WRYvDTB86at
        WuUjVSreMIpEuMUvcXYJPh4La+EHk4VYukIpOLW/ruNqc+DeTOz2opHqYJ/gQATxU4oiYQ
        y1/r2mFbxbZIJ69TSkhAuSTbI3z2jaU=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-8ASmRbolMx-OLKkcAK31mQ-1; Thu, 21 Jul 2022 18:34:46 -0400
X-MC-Unique: 8ASmRbolMx-OLKkcAK31mQ-1
Received: by mail-il1-f199.google.com with SMTP id l10-20020a056e021aaa00b002dd08016baeso1624662ilv.13
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 15:34:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=FbHoTM5Rt91OdmCyo1W3xeRtGZ9iC9uA5MFK7g8w+Fg=;
        b=N3r9r81FPxjnG1oxiIWciSVL+pRthJGcFqTb+JMvkDpgp2WQYzZi8wRD/lH4/4gmQD
         XQRDP5DGSASgynARAfvqezKrhGGlhfVBKpO0h/fP0Z2oT//HuCN2vX5dBC5bXtLnBTpn
         WGRQVHlhmNe4PjXMP+ru0CDgdyC2FaiTWGsM/V4us1qKdBpH75AmPHQ39PzTB9mVVN9l
         0oJGSXmI9X/GS7Vs+miK85urINiLfYhi2lRNb79GJgSk0kJ3X395oI8bRqzfNA5Q/14e
         DYOlmwdd3phEOxNX9RD4uyFxPesIKLti9Rp7axh/7rB66C+LXo/NZeB8Gd37Inlh3m5Y
         5vGQ==
X-Gm-Message-State: AJIora9vZUP8alQ13cT7gWTvnSeDPiIrLsTRE4Ucf9GRE8aALxdngX+g
        fd26q4gJX7wbsKg4aRmEApsxHwP5cJ1M3XNzK9kyZocGNrLbZvJdQwU+QNntaJDFbxL+l+QGyhS
        f4u8NmbO/PYtp
X-Received: by 2002:a05:6638:3589:b0:33f:88f2:2545 with SMTP id v9-20020a056638358900b0033f88f22545mr311974jal.229.1658442885837;
        Thu, 21 Jul 2022 15:34:45 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u3YiP6JXEgjAKXrBeop0N46j1B+Tfjsl9+kS03iKFvuVf+mnHSNfypqaXgylDjjdtyx72oZQ==
X-Received: by 2002:a05:6638:3589:b0:33f:88f2:2545 with SMTP id v9-20020a056638358900b0033f88f22545mr311963jal.229.1658442885478;
        Thu, 21 Jul 2022 15:34:45 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x8-20020a0566022c4800b0067c09fd0b53sm1330034iov.21.2022.07.21.15.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 15:34:44 -0700 (PDT)
Date:   Thu, 21 Jul 2022 16:34:42 -0600
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
Subject: Re: [PATCH v5 5/5] vfio/pci: Implement
 VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP
Message-ID: <20220721163442.7d2ae47f.alex.williamson@redhat.com>
In-Reply-To: <20220719121523.21396-6-abhsahu@nvidia.com>
References: <20220719121523.21396-1-abhsahu@nvidia.com>
        <20220719121523.21396-6-abhsahu@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Jul 2022 17:45:23 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> This patch implements VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP
> device feature. In the VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY, if there is
> any access for the VFIO device on the host side, then the device will
> be moved out of the low power state without the user's guest driver
> involvement. Once the device access has been finished, then the device
> will be moved again into low power state. With the low power
> entry happened through VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP,
> the device will not be moved back into the low power state and
> a notification will be sent to the user by triggering wakeup eventfd.
> 
> vfio_pci_core_pm_entry() will be called for both the variants of low
> power feature entry so add an extra argument for wakeup eventfd context
> and store locally in 'struct vfio_pci_core_device'.
> 
> For the entry happened without wakeup eventfd, all the exit related
> handling will be done by the LOW_POWER_EXIT device feature only.
> When the LOW_POWER_EXIT will be called, then the vfio core layer
> vfio_device_pm_runtime_get() will increment the usage count and will
> resume the device. In the driver runtime_resume callback,
> the 'pm_wake_eventfd_ctx' will be NULL so the vfio_pci_runtime_pm_exit()
> will return early. Then vfio_pci_core_pm_exit() will again call
> vfio_pci_runtime_pm_exit() and now the exit related handling will be done.
> 
> For the entry happened with wakeup eventfd, in the driver resume
> callback, eventfd will be triggered and all the exit related handling will
> be done. When vfio_pci_runtime_pm_exit() will be called by
> vfio_pci_core_pm_exit(), then it will return early. But if the user has
> disabled the runtime PM on the host side, the device will never go
> runtime suspended state and in this case, all the exit related handling
> will be done during vfio_pci_core_pm_exit() only. Also, the eventfd will
> not be triggered since the device power state has not been changed by the
> host driver.
> 
> For vfio_pci_core_disable() also, all the exit related handling
> needs to be done if user has closed the device after putting into
> low power. In this case eventfd will not be triggered since
> the device close has been initiated by the user only.
> 
> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 78 ++++++++++++++++++++++++++++++--
>  include/linux/vfio_pci_core.h    |  1 +
>  2 files changed, 74 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 726a6f282496..dbe942bcaa67 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -259,7 +259,8 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
>  	return ret;
>  }
>  
> -static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev)
> +static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev,
> +				     struct eventfd_ctx *efdctx)
>  {
>  	/*
>  	 * The vdev power related flags are protected with 'memory_lock'
> @@ -272,6 +273,7 @@ static int vfio_pci_runtime_pm_entry(struct vfio_pci_core_device *vdev)
>  	}
>  
>  	vdev->pm_runtime_engaged = true;
> +	vdev->pm_wake_eventfd_ctx = efdctx;
>  	pm_runtime_put_noidle(&vdev->pdev->dev);
>  	up_write(&vdev->memory_lock);
>  
> @@ -295,21 +297,67 @@ static int vfio_pci_core_pm_entry(struct vfio_device *device, u32 flags,
>  	 * while returning from the ioctl and then the device can go into
>  	 * runtime suspended state.
>  	 */
> -	return vfio_pci_runtime_pm_entry(vdev);
> +	return vfio_pci_runtime_pm_entry(vdev, NULL);
>  }
>  
> -static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
> +static int
> +vfio_pci_core_pm_entry_with_wakeup(struct vfio_device *device, u32 flags,
> +				   void __user *arg, size_t argsz)
> +{
> +	struct vfio_pci_core_device *vdev =
> +		container_of(device, struct vfio_pci_core_device, vdev);
> +	struct vfio_device_low_power_entry_with_wakeup entry;
> +	struct eventfd_ctx *efdctx;
> +	int ret;
> +
> +	ret = vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_SET,
> +				 sizeof(entry));
> +	if (ret != 1)
> +		return ret;
> +
> +	if (copy_from_user(&entry, arg, sizeof(entry)))
> +		return -EFAULT;
> +
> +	if (entry.wakeup_eventfd < 0)
> +		return -EINVAL;
> +
> +	efdctx = eventfd_ctx_fdget(entry.wakeup_eventfd);
> +	if (IS_ERR(efdctx))
> +		return PTR_ERR(efdctx);
> +
> +	ret = vfio_pci_runtime_pm_entry(vdev, efdctx);
> +	if (ret)
> +		eventfd_ctx_put(efdctx);
> +
> +	return ret;
> +}
> +
> +static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev,
> +				     bool resume_callback)
>  {
>  	/*
>  	 * The vdev power related flags are protected with 'memory_lock'
>  	 * semaphore.
>  	 */
>  	down_write(&vdev->memory_lock);
> +	if (resume_callback && !vdev->pm_wake_eventfd_ctx) {
> +		up_write(&vdev->memory_lock);
> +		return;
> +	}
> +
>  	if (vdev->pm_runtime_engaged) {
>  		vdev->pm_runtime_engaged = false;
>  		pm_runtime_get_noresume(&vdev->pdev->dev);
>  	}
>  
> +	if (vdev->pm_wake_eventfd_ctx) {
> +		if (resume_callback)
> +			eventfd_signal(vdev->pm_wake_eventfd_ctx, 1);
> +
> +		eventfd_ctx_put(vdev->pm_wake_eventfd_ctx);
> +		vdev->pm_wake_eventfd_ctx = NULL;
> +	}
> +
>  	up_write(&vdev->memory_lock);
>  }
>  

I find the pm_exit handling here confusing.  We only have one caller
that can signal the eventfd, so it seems cleaner to me to have that
caller do the eventfd signal.  We can then remove the arg to pm_exit
and pull the core of it out to a pre-locked function for that call
path.  Sometime like below (applies on top of this patch).  Also moved
the intx unmasking until after the eventfd signaling.  What do you
think?  Thanks,

Alex

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index dbe942bcaa67..93169b7d6da2 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -332,32 +332,27 @@ vfio_pci_core_pm_entry_with_wakeup(struct vfio_device *device, u32 flags,
 	return ret;
 }
 
-static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev,
-				     bool resume_callback)
+static void __vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
 {
-	/*
-	 * The vdev power related flags are protected with 'memory_lock'
-	 * semaphore.
-	 */
-	down_write(&vdev->memory_lock);
-	if (resume_callback && !vdev->pm_wake_eventfd_ctx) {
-		up_write(&vdev->memory_lock);
-		return;
-	}
-
 	if (vdev->pm_runtime_engaged) {
 		vdev->pm_runtime_engaged = false;
 		pm_runtime_get_noresume(&vdev->pdev->dev);
-	}
-
-	if (vdev->pm_wake_eventfd_ctx) {
-		if (resume_callback)
-			eventfd_signal(vdev->pm_wake_eventfd_ctx, 1);
 
-		eventfd_ctx_put(vdev->pm_wake_eventfd_ctx);
-		vdev->pm_wake_eventfd_ctx = NULL;
+		if (vdev->pm_wake_eventfd_ctx) {
+			eventfd_ctx_put(vdev->pm_wake_eventfd_ctx);
+			vdev->pm_wake_eventfd_ctx = NULL;
+		}
 	}
+}
 
+static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
+{
+	/*
+	 * The vdev power related flags are protected with 'memory_lock'
+	 * semaphore.
+	 */
+	down_write(&vdev->memory_lock);
+	__vfio_pci_runtime_pm_exit(vdev);
 	up_write(&vdev->memory_lock);
 }
 
@@ -373,22 +368,13 @@ static int vfio_pci_core_pm_exit(struct vfio_device *device, u32 flags,
 		return ret;
 
 	/*
-	 * The device should already be resumed by the vfio core layer.
-	 * vfio_pci_runtime_pm_exit() will internally increment the usage
-	 * count corresponding to pm_runtime_put() called during low power
-	 * feature entry.
-	 *
-	 * For the low power entry happened with wakeup eventfd, there will
-	 * be two cases:
-	 *
-	 * 1. The device has gone into runtime suspended state. In this case,
-	 *    the runtime resume by the vfio core layer should already have
-	 *    performed all exit related handling and the
-	 *    vfio_pci_runtime_pm_exit() will return early.
-	 * 2. The device was in runtime active state. In this case, the
-	 *    vfio_pci_runtime_pm_exit() will do all the required handling.
+	 * The device is always in the active state here due to pm wrappers
+	 * around ioctls.  If the device had entered a low power state and
+	 * pm_wake_eventfd_ctx is valid, vfio_pci_core_runtime_resume() has 
+	 * already signaled the eventfd and exited low power mode itself.
+	 * pm_runtime_engaged protects the redundant call here.
 	 */
-	vfio_pci_runtime_pm_exit(vdev, false);
+	vfio_pci_runtime_pm_exit(vdev);
 	return 0;
 }
 
@@ -425,15 +411,19 @@ static int vfio_pci_core_runtime_resume(struct device *dev)
 {
 	struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
 
-	if (vdev->pm_intx_masked)
-		vfio_pci_intx_unmask(vdev);
-
 	/*
-	 * Only for the low power entry happened with wakeup eventfd,
-	 * the vfio_pci_runtime_pm_exit() will perform exit related handling
-	 * and will trigger eventfd. For the other cases, it will return early.
+	 * Resume with a pm_wake_eventfd_ctx signals the eventfd and exits
+	 * low power mode.
 	 */
-	vfio_pci_runtime_pm_exit(vdev, true);
+	down_write(&vdev->memory_lock);
+	if (vdev->pm_wake_eventfd_ctx) {
+		eventfd_signal(vdev->pm_wake_eventfd_ctx, 1);
+		__vfio_pci_runtime_pm_exit(vdev);
+	}
+	up_write(&vdev->memory_lock);
+
+	if (vdev->pm_intx_masked)
+		vfio_pci_intx_unmask(vdev);
 
 	return 0;
 }
@@ -553,7 +543,7 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	 * the vfio_pci_set_power_state() will change the device power state
 	 * to D0.
 	 */
-	vfio_pci_runtime_pm_exit(vdev, false);
+	vfio_pci_runtime_pm_exit(vdev);
 	pm_runtime_resume(&pdev->dev);
 
 	/*

