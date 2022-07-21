Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D2657D6FA
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 00:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233986AbiGUWfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 18:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbiGUWfF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 18:35:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8BD98972C5
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 15:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658442902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zQrqvQae0nT9vUViRQZp7Ez/9bySudCkbGQS1j5hfg4=;
        b=ZVVNVgBLPuKTrYnWdLE9eoi3nHgoQF809TpOJaXP6tXEWPK6Bfa4QErL82/T8Mn3RyxZwW
        R3o/XHO/H7PuGX6kTESS6hthTm/N1k6Prtu6NKaHD0d/88gNI0KmOV/vAjZAaZsKPxB0n6
        5HzOooK3NS7YC5UQuXIaXMzvFxkzjhE=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-LPaPHZ7PNgmKzCFEf0G8hA-1; Thu, 21 Jul 2022 18:35:01 -0400
X-MC-Unique: LPaPHZ7PNgmKzCFEf0G8hA-1
Received: by mail-il1-f199.google.com with SMTP id i8-20020a056e020d8800b002d931252904so1621493ilj.23
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 15:35:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zQrqvQae0nT9vUViRQZp7Ez/9bySudCkbGQS1j5hfg4=;
        b=UUABsDgXWK03Y1Co13yoraY3miEuqQWYJWOOrP9F3ZQYLVqK6oCMmtpE85JP8uoL1Z
         EPfMFRtclJI6j+piUARkObdocoBZpKrX2Px3bdtsd+YZoVMNoQjq5RUYQfNlcyIh5QG8
         CWg21uc8szwWOGQezYlTt/QuFj8dy/c+GR75c6GUBXjGzEp5qXImaT+QJKWcVyfXTQLU
         E14xmnRqvTLm4PYb/58lfqd8aaxViwqB21sTeAvf6qFhwHf6UkHk71kiwSioZCZauzWi
         Xjs5z6VkWHGt+qKXltphVubjugm4zI4iJn7XQxJnX1pMMdVydYbogefFWa3761lgUVk5
         Foyg==
X-Gm-Message-State: AJIora9dT4eawCDoFG26ud0j1gKoUDNAmHOywvcc5XzcLp4UZmwOPtfv
        +Ga4tyga9kEaVVk3q0Xs+AHKtsD4SEKuz9ENbqsASAxbIjEGwlF2AD+0H28fzRjY458XECCFg9P
        2WSgcxWSMJuTp
X-Received: by 2002:a05:6602:131a:b0:67b:dbd5:49dd with SMTP id h26-20020a056602131a00b0067bdbd549ddmr264953iov.1.1658442900813;
        Thu, 21 Jul 2022 15:35:00 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tJFnoMguZlc1Z7oT0fKTHJ1BAiYSHgtApsSpqA9L2qtYfvHOiuhSW9HHH3cajGtE9TONif2w==
X-Received: by 2002:a05:6602:131a:b0:67b:dbd5:49dd with SMTP id h26-20020a056602131a00b0067bdbd549ddmr264946iov.1.1658442900492;
        Thu, 21 Jul 2022 15:35:00 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z2-20020a926502000000b002dd0cb24c16sm1145042ilb.17.2022.07.21.15.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 15:35:00 -0700 (PDT)
Date:   Thu, 21 Jul 2022 16:34:45 -0600
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
Subject: Re: [PATCH v5 1/5] vfio: Add the device features for the low power
 entry and exit
Message-ID: <20220721163445.49d15daf.alex.williamson@redhat.com>
In-Reply-To: <20220719121523.21396-2-abhsahu@nvidia.com>
References: <20220719121523.21396-1-abhsahu@nvidia.com>
        <20220719121523.21396-2-abhsahu@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Jul 2022 17:45:19 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> This patch adds the following new device features for the low
> power entry and exit in the header file. The implementation for the
> same will be added in the subsequent patches.
> 
> - VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY
> - VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP
> - VFIO_DEVICE_FEATURE_LOW_POWER_EXIT
> 
> With the standard registers, all power states cannot be achieved. The

We're talking about standard PCI PM registers here, let's make that
clear since we're adding a device agnostic interface here.

> platform-based power management needs to be involved to go into the
> lowest power state. For doing low power entry and exit with
> platform-based power management, these device features can be used.
> 
> The entry device feature has two variants. These two variants are mainly
> to support the different behaviour for the low power entry.
> If there is any access for the VFIO device on the host side, then the
> device will be moved out of the low power state without the user's
> guest driver involvement. Some devices (for example NVIDIA VGA or
> 3D controller) require the user's guest driver involvement for
> each low-power entry. In the first variant, the host can move the
> device into low power without any guest driver involvement while

Perhaps, "In the first variant, the host can return the device to low
power automatically.  The device will continue to attempt to reach low
power until the low power exit feature is called."

> in the second variant, the host will send a notification to the user
> through eventfd and then the users guest driver needs to move
> the device into low power.

"In the second variant, if the device exits low power due to an access,
the host kernel will signal the user via the provided eventfd and will
not return the device to low power without a subsequent call to one of
the low power entry features.  A call to the low power exit feature is
optional if the user provided eventfd is signaled."
 
> These device features only support VFIO_DEVICE_FEATURE_SET operation.

And PROBE.

> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> ---
>  include/uapi/linux/vfio.h | 55 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 733a1cddde30..08fd3482d22b 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -986,6 +986,61 @@ enum vfio_device_mig_state {
>  	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
>  };
>  
> +/*
> + * Upon VFIO_DEVICE_FEATURE_SET, move the VFIO device into the low power state
> + * with the platform-based power management.  This low power state will be

This is really "allow the device to be moved into a low power state"
rather than actually "move the device into" such a state though, right?

> + * internal to the VFIO driver and the user will not come to know which power
> + * state is chosen.  If any device access happens (either from the host or
> + * the guest) when the device is in the low power state, then the host will
> + * move the device out of the low power state first.  Once the access has been
> + * finished, then the host will move the device into the low power state again.
> + * If the user wants that the device should not go into the low power state
> + * again in this case, then the user should use the
> + * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device feature for the

This should probably just read "For single shot low power support with
wake-up notification, see
VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP below."

> + * low power entry.  The mmap'ed region access is not allowed till the low power
> + * exit happens through VFIO_DEVICE_FEATURE_LOW_POWER_EXIT and will
> + * generate the access fault.
> + */
> +#define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY 3

Note that Yishai's DMA logging set is competing for the same feature
entries.  We'll need to coordinate.

> +
> +/*
> + * Upon VFIO_DEVICE_FEATURE_SET, move the VFIO device into the low power state
> + * with the platform-based power management and provide support for the wake-up
> + * notifications through eventfd.  This low power state will be internal to the
> + * VFIO driver and the user will not come to know which power state is chosen.
> + * If any device access happens (either from the host or the guest) when the
> + * device is in the low power state, then the host will move the device out of
> + * the low power state first and a notification will be sent to the guest
> + * through eventfd.  Once the access is finished, the host will not move back
> + * the device into the low power state.  The guest should move the device into
> + * the low power state again upon receiving the wakeup notification.  The
> + * notification will be generated only if the device physically went into the
> + * low power state.  If the low power entry has been disabled from the host
> + * side, then the device will not go into the low power state even after
> + * calling this device feature and then the device access does not require
> + * wake-up.  The mmap'ed region access is not allowed till the low power exit
> + * happens.  The low power exit can happen either through
> + * VFIO_DEVICE_FEATURE_LOW_POWER_EXIT or through any other access (where the
> + * wake-up notification has been generated).

Seems this could leverage a lot more from the previous, simply stating
that this has the same behavior as VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY
with the exception that the user provides an eventfd for notification
when the device resumes from low power and will not try to re-enter a
low power state without a subsequent user call to one of the low power
entry feature ioctls.  It might also be worth covering the fact that
device accesses by the user, including region and ioctl access, will
also trigger the eventfd if that access triggers a resume.

As I'm thinking about this, that latter clause is somewhat subtle.
AIUI a user can call the low power entry with wakeup feature and
proceed to do various ioctl and region (not mmap) accesses that could
perpetually keep the device awake, or there may be dependent devices
such that the device may never go to low power.  It needs to be very
clear that only if the wakeup eventfd has the device entered into and
exited a low power state making the low power exit ioctl optional.

> + */
> +struct vfio_device_low_power_entry_with_wakeup {
> +	__s32 wakeup_eventfd;
> +	__u32 reserved;
> +};
> +
> +#define VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP 4
> +
> +/*
> + * Upon VFIO_DEVICE_FEATURE_SET, move the VFIO device out of the low power
> + * state.

Any ioctl effectively does that, the key here is that the low power
state may not be re-entered after this ioctl.

>  This device feature should be called only if the user has previously
> + * put the device into the low power state either with
> + * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY or
> + * VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP device feature.  If the

Doesn't really seem worth mentioning, we need to protect against misuse
regardless.

> + * device is not in the low power state currently, this device feature will
> + * return early with the success status.

This is an implementation detail, it doesn't need to be part of the
uAPI.  Thanks,

Alex

> + */
> +#define VFIO_DEVICE_FEATURE_LOW_POWER_EXIT 5
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
>  
>  /**

