Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29226AFAAA
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 00:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjCGXm7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 18:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjCGXmp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 18:42:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF7D8ABE1
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 15:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678232523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HP+YuaeE+JCFy23nDDaTiuL6lmE86qB9t2l2lPD5ick=;
        b=hMzIEv33npJzPkymSiUzwF6S7LM1flrrFBq8rS3N/ZwFOezNpnaOIjI9iHMP00+P6XPsym
        Es7UI48bBRu+GtPdFkoUIQR0Hpd3fChyuj6TK8sMZD/ERCDVQ1dKMxachojIHwtZyL5ll1
        X47KuGtYeRVifTKDD9j1272wPWhRjAs=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-Mb6cMjdTOcaAbVDSleYmFQ-1; Tue, 07 Mar 2023 18:42:01 -0500
X-MC-Unique: Mb6cMjdTOcaAbVDSleYmFQ-1
Received: by mail-io1-f69.google.com with SMTP id i2-20020a5d9e42000000b0074cfcc4ed07so8063025ioi.22
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 15:42:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678232520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HP+YuaeE+JCFy23nDDaTiuL6lmE86qB9t2l2lPD5ick=;
        b=lrvoPegPMs08XfGAJPxUL0jXFu+GkBzitNd49LtEQxplQopGbk+VU+/XLuZB1kr8Nl
         FCldcgj1BHt5HOQiG+jaNqgb7zLlum19ITc0LImNzcGeXCK1Cgo3UVV6D+/WxJax0HgX
         9qPL5X+dM+J2UYvCQY5zyv5ktmJX/l5yPZ2ia6TF8Xdjm7u3r61WcEZNIe1UopyyUeJJ
         DONkOJojq6badt5V/Ztp1ChHe1kv7R9BJhPvYVJ3Jz2LjBDn2mKANF+hurRQH6u19raw
         FzgTUMs7DmIzJHnGBVfFguj7PM1iIA/u1Ej/qmZa/DBmhsdF+QG1D3OZblIdH6Mv4wRJ
         1rRQ==
X-Gm-Message-State: AO0yUKWFgjby/E1Oa6DDBh0yniX7CFmSR32IM1BWJ4lh7ZdlahcwGs/v
        UcCY/NuamrfAABYh0zVIPiEDMM92WenQ2Z8RIKN4m+7iXlXG7WM4QfwxLqXRNFHzOuIbNK26fSM
        LXFrtz45EmsG/
X-Received: by 2002:a05:6e02:1b0b:b0:314:e56:54fc with SMTP id i11-20020a056e021b0b00b003140e5654fcmr15172821ilv.1.1678232520235;
        Tue, 07 Mar 2023 15:42:00 -0800 (PST)
X-Google-Smtp-Source: AK7set8PNQd44wYB+cvDuz+qswU7+gqLx/X7JGrITD/K98r7p4bM+Nl2h+vv7bqgvIBvwrcNfYr3zA==
X-Received: by 2002:a05:6e02:1b0b:b0:314:e56:54fc with SMTP id i11-20020a056e021b0b00b003140e5654fcmr15172801ilv.1.1678232520002;
        Tue, 07 Mar 2023 15:42:00 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s16-20020a02cf30000000b003c4f7dd7554sm4541461jar.5.2023.03.07.15.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 15:41:59 -0800 (PST)
Date:   Tue, 7 Mar 2023 16:41:58 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Grzegorz Jaszczyk <jaz@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, dmy@semihalf.com, tn@semihalf.com,
        dbehr@google.com, upstream@semihalf.com, dtor@google.com,
        jgg@ziepe.ca, kevin.tian@intel.com, cohuck@redhat.com,
        abhsahu@nvidia.com, yishaih@nvidia.com, yi.l.liu@intel.com,
        kvm@vger.kernel.org, Dominik Behr <dbehr@chromium.org>
Subject: Re: [PATCH] vfio/pci: Propagate ACPI notifications to the
 user-space
Message-ID: <20230307164158.4b41e32f.alex.williamson@redhat.com>
In-Reply-To: <20230307220553.631069-1-jaz@semihalf.com>
References: <20230307220553.631069-1-jaz@semihalf.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Mar 2023 22:05:53 +0000
Grzegorz Jaszczyk <jaz@semihalf.com> wrote:

> From: Dominik Behr <dbehr@chromium.org>
> 
> Hitherto there was no support for propagating ACPI notifications to the
> guest drivers. In order to provide such support, install a handler for
> notifications on an ACPI device during vfio-pci device registration. The
> handler role is to propagate such ACPI notifications to the user-space
> via acpi netlink events, which allows VMM to receive and propagate them
> further to the VMs.
> 
> Thanks to the above, the actual driver for the pass-through device,
> which belongs to the guest, can receive and react to device specific
> notifications.

What consumes these events?  Has this been proposed to any VM
management tools like libvirt?  What sort of ACPI events are we
expecting to see here and what does userspace do with them?

> Signed-off-by: Dominik Behr <dbehr@chromium.org>
> Co-developed-by: Grzegorz Jaszczyk <jaz@semihalf.com>
> Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 33 ++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index a5ab416cf476..92b8ed8d087c 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -10,6 +10,7 @@
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> +#include <linux/acpi.h>
>  #include <linux/aperture.h>
>  #include <linux/device.h>
>  #include <linux/eventfd.h>
> @@ -2120,10 +2121,20 @@ void vfio_pci_core_release_dev(struct vfio_device *core_vdev)
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_release_dev);
>  
> +static void vfio_pci_core_acpi_notify(acpi_handle handle, u32 event, void *data)
> +{
> +	struct vfio_pci_core_device *vdev = (struct vfio_pci_core_device *)data;
> +	struct device *dev = &vdev->pdev->dev;
> +
> +	acpi_bus_generate_netlink_event("vfio_pci", dev_name(dev), event, 0);

Who listens to this?  Should there be an in-band means to provide
notifies related to the device?  How does a userspace driver know to
look for netlink events for a particular device?

> +}
> +
>  int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>  {
> +	acpi_status status;
>  	struct pci_dev *pdev = vdev->pdev;
>  	struct device *dev = &pdev->dev;
> +	struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
>  	int ret;
>  
>  	/* Drivers must set the vfio_pci_core_device to their drvdata */
> @@ -2201,8 +2212,24 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>  	ret = vfio_register_group_dev(&vdev->vdev);
>  	if (ret)
>  		goto out_power;
> +
> +	if (!adev) {
> +		pci_info(pdev, "No ACPI companion");

This would be a log message generated for 99.99% of devices.

> +		return 0;
> +	}
> +
> +	status = acpi_install_notify_handler(adev->handle, ACPI_DEVICE_NOTIFY,
> +					vfio_pci_core_acpi_notify, (void *)vdev);

vfio-pci supports non-ACPI platforms, I don't see any !CONFIG_ACPI
prototypes for this function.  Thanks,

Alex

> +
> +	if (ACPI_FAILURE(status)) {
> +		pci_err(pdev, "Failed to install notify handler");
> +		goto out_group_register;
> +	}
> +
>  	return 0;
>  
> +out_group_register:
> +	vfio_unregister_group_dev(&vdev->vdev);
>  out_power:
>  	if (!disable_idle_d3)
>  		pm_runtime_get_noresume(dev);
> @@ -2216,6 +2243,12 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_register_device);
>  
>  void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
>  {
> +	struct acpi_device *adev = ACPI_COMPANION(&vdev->pdev->dev);
> +
> +	if (adev)
> +		acpi_remove_notify_handler(adev->handle, ACPI_DEVICE_NOTIFY,
> +					   vfio_pci_core_acpi_notify);
> +
>  	vfio_pci_core_sriov_configure(vdev, 0);
>  
>  	vfio_unregister_group_dev(&vdev->vdev);

