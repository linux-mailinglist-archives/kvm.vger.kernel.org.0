Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF069568DFA
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 17:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbiGFPsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 11:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233190AbiGFPr6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 11:47:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50B3F2A244
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 08:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657122048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kw+hePrwDbzDiEREmLImOf93xliKHYFU7TLXwcjNYt0=;
        b=hUE1mYZSWlHItNs6sxfnXPS6EFxerqOp8ISLGYlxaxxIBx+xzy2w+MoFRw/nEtKSf5VB4I
        qt1UAq2HLmQysJ3K/UYC/m6k58nO46aTOWvGNTuCLqj3Eg3i7jfRDeE9abEyd6EiRJ9abm
        7D3VyBkBBHKoa26Tz1B2WsgEI/fzZcQ=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-84-rDJ68GRJNWObXF7RQAVw2g-1; Wed, 06 Jul 2022 11:40:46 -0400
X-MC-Unique: rDJ68GRJNWObXF7RQAVw2g-1
Received: by mail-il1-f198.google.com with SMTP id k10-20020a056e021a8a00b002dacb91b6ebso7773876ilv.1
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 08:40:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Kw+hePrwDbzDiEREmLImOf93xliKHYFU7TLXwcjNYt0=;
        b=bLbrRPT19l1NGUNwDg6LbnJvsgrW1fdw+wdRmTWXklUUzYLZ3E3HQ+3IMVvVoCG9Ak
         SZOczkmCXVMyH3o2tBHrGrP1gD6Gr5sxz7D9w79Tb1LTPcCflka77fBf0h5LrbeFQE56
         QHPhVq1nkmbzHhGnpaUGjQr36JLl9M57ZGILjh542nnSdvV89kktMrWy82CjAeyKpQVh
         EeCMGclfCfgVkZSAPsk2216F15KrHMqWM+QZxMJpXdeecUbF5lhCjRwS0PHnFLx4qCHV
         auFB/Am2WBG9b+FYiMg7xel46scGmBj87DPCNoQKsGrJ2eXPsFboq67Wr85JYz4nteWj
         k6GA==
X-Gm-Message-State: AJIora+j3uxMul93PS+H0DctDka9F+qHS95nvpxNu1RVX/7apjuKsLLe
        4NtQ/TqJR4uR0W6MXYtVDX3RPO7pnrJPONGe1WvSJO3L7MZRiRYyjJHOezwrEtv425U873Nj3Om
        rhE/La+t++Xkq
X-Received: by 2002:a05:6e02:1b8d:b0:2dc:32dc:a03d with SMTP id h13-20020a056e021b8d00b002dc32dca03dmr2819809ili.261.1657122045312;
        Wed, 06 Jul 2022 08:40:45 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tJknWA5fe5K/3hOcpi9Lvkw/Sr30glLgGICdmPgj3KJLKzuRHboplxHCnha46TsS2+ft6XbQ==
X-Received: by 2002:a05:6e02:1b8d:b0:2dc:32dc:a03d with SMTP id h13-20020a056e021b8d00b002dc32dca03dmr2819788ili.261.1657122044997;
        Wed, 06 Jul 2022 08:40:44 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a17-20020a056e0208b100b002d955fab9dbsm14702119ilt.23.2022.07.06.08.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 08:40:44 -0700 (PDT)
Date:   Wed, 6 Jul 2022 09:39:59 -0600
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
Subject: Re: [PATCH v4 2/6] vfio: Add a new device feature for the power
 management
Message-ID: <20220706093959.3bd2cbbb.alex.williamson@redhat.com>
In-Reply-To: <20220701110814.7310-3-abhsahu@nvidia.com>
References: <20220701110814.7310-1-abhsahu@nvidia.com>
        <20220701110814.7310-3-abhsahu@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 1 Jul 2022 16:38:10 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> This patch adds the new feature VFIO_DEVICE_FEATURE_POWER_MANAGEMENT
> for the power management in the header file. The implementation for the
> same will be added in the subsequent patches.
> 
> With the standard registers, all power states cannot be achieved. The
> platform-based power management needs to be involved to go into the
> lowest power state. For all the platform-based power management, this
> device feature can be used.
> 
> This device feature uses flags to specify the different operations. In
> the future, if any more power management functionality is needed then
> a new flag can be added to it. It supports both GET and SET operations.
> 
> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 55 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 733a1cddde30..7e00de5c21ea 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -986,6 +986,61 @@ enum vfio_device_mig_state {
>  	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
>  };
>  
> +/*
> + * Perform power management-related operations for the VFIO device.
> + *
> + * The low power feature uses platform-based power management to move the
> + * device into the low power state.  This low power state is device-specific.
> + *
> + * This device feature uses flags to specify the different operations.
> + * It supports both the GET and SET operations.
> + *
> + * - VFIO_PM_LOW_POWER_ENTER flag moves the VFIO device into the low power
> + *   state with platform-based power management.  This low power state will be
> + *   internal to the VFIO driver and the user will not come to know which power
> + *   state is chosen.  Once the user has moved the VFIO device into the low
> + *   power state, then the user should not do any device access without moving
> + *   the device out of the low power state.

Except we're wrapping device accesses to make this possible.  This
should probably describe how any discrete access will wake the device
but ongoing access through mmaps will generate user faults.

> + *
> + * - VFIO_PM_LOW_POWER_EXIT flag moves the VFIO device out of the low power
> + *    state.  This flag should only be set if the user has previously put the
> + *    device into low power state with the VFIO_PM_LOW_POWER_ENTER flag.

Indenting.

> + *
> + * - VFIO_PM_LOW_POWER_ENTER and VFIO_PM_LOW_POWER_EXIT are mutually exclusive.
> + *
> + * - VFIO_PM_LOW_POWER_REENTERY_DISABLE flag is only valid with
> + *   VFIO_PM_LOW_POWER_ENTER.  If there is any access for the VFIO device on
> + *   the host side, then the device will be moved out of the low power state
> + *   without the user's guest driver involvement.  Some devices require the
> + *   user's guest driver involvement for each low-power entry.  If this flag is
> + *   set, then the re-entry to the low power state will be disabled, and the
> + *   host kernel will not move the device again into the low power state.
> + *   The VFIO driver internally maintains a list of devices for which low
> + *   power re-entry is disabled by default and for those devices, the
> + *   re-entry will be disabled even if the user has not set this flag
> + *   explicitly.

Wrong polarity.  The kernel should not maintain the policy.  By default
every wakeup, whether from host kernel accesses or via user accesses
that do a pm-get should signal a wakeup to userspace.  Userspace needs
to opt-out of that wakeup to let the kernel automatically re-enter low
power and userspace needs to maintain the policy for which devices it
wants that to occur.

> + *
> + * For the IOCTL call with VFIO_DEVICE_FEATURE_GET:
> + *
> + * - VFIO_PM_LOW_POWER_ENTER will be set if the user has put the device into
> + *   the low power state, otherwise, VFIO_PM_LOW_POWER_EXIT will be set.
> + *
> + * - If the device is in a normal power state currently, then
> + *   VFIO_PM_LOW_POWER_REENTERY_DISABLE will be set for the devices where low
> + *   power re-entry is disabled by default.  If the device is in the low power
> + *   state currently, then VFIO_PM_LOW_POWER_REENTERY_DISABLE will be set
> + *   according to the current transition.

Very confusing semantics.

What if the feature SET ioctl took an eventfd and that eventfd was one
time use.  Calling the ioctl would setup the eventfd to notify the user
on wakeup and call pm-put.  Any access to the device via host, ioctl,
or region would be wrapped in pm-get/put and the pm-resume handler
would perform the matching pm-get to balance the feature SET and signal
the eventfd.  If the user opts-out by not providing a wakeup eventfd,
then the pm-resume handler does not perform a pm-get.  Possibly we
could even allow mmap access if a wake-up eventfd is provided.  The
feature GET ioctl would be used to exit low power behavior and would be
a no-op if the wakeup eventfd had already been signaled.  Thanks,

Alex

> + */
> +struct vfio_device_feature_power_management {
> +	__u32	flags;
> +#define VFIO_PM_LOW_POWER_ENTER			(1 << 0)
> +#define VFIO_PM_LOW_POWER_EXIT			(1 << 1)
> +#define VFIO_PM_LOW_POWER_REENTERY_DISABLE	(1 << 2)
> +	__u32	reserved;
> +};
> +
> +#define VFIO_DEVICE_FEATURE_POWER_MANAGEMENT	3
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
>  
>  /**

