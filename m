Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463CB52C1EC
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 20:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241149AbiERRvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 13:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241250AbiERRvg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 13:51:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D70836163
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652896292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nk8FG1zVlK+b3cf8Z9HOHSMj2oGGXMKoRhmwTtaFzXg=;
        b=awERrsvg2MQ7E8oIgWuNDW/kZKqWrIBF6PrRGZVzV4+10W+nH3cYSaVRb67yYpJolUiWak
        vW7MxRUGmu/ItWoQynaVBrXZzy1AwS2Gs/DojJIMpMpgPZft1ReCia6f+K9iqXTQ88Kboh
        OJNjH8eBuz2GZ+xGRmQIP/95NzGXjXM=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-dYsHXiEOMSyTJjdzF9hsIw-1; Wed, 18 May 2022 13:51:31 -0400
X-MC-Unique: dYsHXiEOMSyTJjdzF9hsIw-1
Received: by mail-il1-f199.google.com with SMTP id e3-20020a056e020b2300b002d10200d90fso1696676ilu.2
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:51:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Nk8FG1zVlK+b3cf8Z9HOHSMj2oGGXMKoRhmwTtaFzXg=;
        b=HvP+aUF+DM4KbFz2fv3s6dGp2wlaCiKlA/ZgHFDhYfk+UGD0hBplGcayj0hHlM8zaJ
         cDRb+34+nySzYMkZxo2GJ7ICrA/n79jsVxIS+beUqhVJMAds3hGpxOyhRGqVC0H8ky+t
         35bW4lbMhxKM7Src3D8KN+dNojZMS3uzVUx3nGZav3Z39OE5vp/3O/H89J4j2xI/uig5
         y+1fY/Y2LG44E6Gk/LVbGGTYbL23gvAXWhh4NiVDoArNVmkKZfx+a7FvUWAlbaWOOL5K
         3lgMrVKMb+cWixKcfxXR/uQIuUJSD/kpvfFhumnzrOFo8VknDYJnvN+1bYkRihGAH0n1
         4x6w==
X-Gm-Message-State: AOAM532yii2qqkpX7EDnhlK5AIKEap2OZeKzOjshA8CawymJRJ3E7h5O
        qHiqnvIcygB9zRu+KgV04kCU0kCP5IHBQsdcq5Wdf4ikvZ5Cki8jGbDvgFUsc6mnkBkFZnsyH/3
        JaihiXiCDmRFZ
X-Received: by 2002:a05:6e02:170b:b0:2cf:970f:6050 with SMTP id u11-20020a056e02170b00b002cf970f6050mr502314ill.5.1652896290458;
        Wed, 18 May 2022 10:51:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyvGIXeh5ZKDwW8XXL/TqH2zn8XMIgmzLTRYqD89L8R+HvJolPMaoY0IBC9xwKmkIM5aMFVTw==
X-Received: by 2002:a05:6e02:170b:b0:2cf:970f:6050 with SMTP id u11-20020a056e02170b00b002cf970f6050mr502296ill.5.1652896290223;
        Wed, 18 May 2022 10:51:30 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id d15-20020a02a48f000000b0032b3a7817bdsm31618jam.129.2022.05.18.10.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 10:51:29 -0700 (PDT)
Date:   Wed, 18 May 2022 11:51:29 -0600
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
Subject: Re: [PATCH v5 0/4] vfio/pci: power management changes
Message-ID: <20220518115129.72beddcd.alex.williamson@redhat.com>
In-Reply-To: <20220518111612.16985-1-abhsahu@nvidia.com>
References: <20220518111612.16985-1-abhsahu@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 May 2022 16:46:08 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> Currently, there is very limited power management support available
> in the upstream vfio-pci driver. If there is no user of vfio-pci device,
> then it will be moved into D3Hot state. Similarly, if we enable the
> runtime power management for vfio-pci device in the guest OS, then the
> device is being runtime suspended (for linux guest OS) and the PCI
> device will be put into D3hot state (in function
> vfio_pm_config_write()). If the D3cold state can be used instead of
> D3hot, then it will help in saving maximum power. The D3cold state can't
> be possible with native PCI PM. It requires interaction with platform
> firmware which is system-specific. To go into low power states
> (including D3cold), the runtime PM framework can be used which
> internally interacts with PCI and platform firmware and puts the device
> into the lowest possible D-States.
> 
> This patch series registers the vfio-pci driver with runtime
> PM framework and uses the same for moving the physical PCI
> device to go into the low power state for unused idle devices.
> There will be separate patch series that will add the support
> for using runtime PM framework for used idle devices.
> 
> The current PM support was added with commit 6eb7018705de ("vfio-pci:
> Move idle devices to D3hot power state") where the following point was
> mentioned regarding D3cold state.
> 
>  "It's tempting to try to use D3cold, but we have no reason to inhibit
>   hotplug of idle devices and we might get into a loop of having the
>   device disappear before we have a chance to try to use it."
> 
> With the runtime PM, if the user want to prevent going into D3cold then
> /sys/bus/pci/devices/.../d3cold_allowed can be set to 0 for the
> devices where the above functionality is required instead of
> disallowing the D3cold state for all the cases.
> 
> The BAR access needs to be disabled if device is in D3hot state.
> Also, there should not be any config access if device is in D3cold
> state. For SR-IOV, the PF power state should be higher than VF's power
> state.
> 
> * Changes in v5
> 
> - Rebased over https://github.com/awilliam/linux-vfio/tree/next.
> - Renamed vfio_pci_lock_and_set_power_state() to
>   vfio_lock_and_set_power_state() and made it static.
> - Inside vfio_pci_core_sriov_configure(), protected setting of
>   power state and sriov enablement with 'memory_lock'.
> - Removed CONFIG_PM macro use since it is not needed with current
>   code.

Applied to vfio next branch for v5.19.  Thanks!

Alex

> * Changes in v4
>   (https://lore.kernel.org/lkml/20220517100219.15146-1-abhsahu@nvidia.com)
> 
> - Rebased over https://github.com/awilliam/linux-vfio/tree/next.
> - Split the patch series into 2 parts. This part contains the patches
>   for using runtime PM for unused idle device.
> - Used the 'pdev->current_state' for checking if the device in D3 state.
> - Adds the check in __vfio_pci_memory_enabled() function itself instead
>   of adding power state check at each caller.
> - Make vfio_pci_lock_and_set_power_state() global since it is needed
>   in different files.
> - Used vfio_pci_lock_and_set_power_state() instead of
>   vfio_pci_set_power_state() before pci_enable_sriov().
> - Inside vfio_pci_core_sriov_configure(), handled both the cases
>   (the device is in low power state with and without user).
> - Used list_for_each_entry_continue_reverse() in
>   vfio_pci_dev_set_pm_runtime_get().
> 
> * Changes in v3
>   (https://lore.kernel.org/lkml/20220425092615.10133-1-abhsahu@nvidia.com)
> 
> - Rebased patches on v5.18-rc3.
> - Marked this series as PATCH instead of RFC.
> - Addressed the review comments given in v2.
> - Removed the limitation to keep device in D0 state if there is any
>   access from host side. This is specific to NVIDIA use case and
>   will be handled separately.
> - Used the existing DEVICE_FEATURE IOCTL itself instead of adding new
>   IOCTL for power management.
> - Removed all custom code related with power management in runtime
>   suspend/resume callbacks and IOCTL handling. Now, the callbacks
>   contain code related with INTx handling and few other stuffs and
>   all the PCI state and platform PM handling will be done by PCI core
>   functions itself.
> - Add the support of wake-up in main vfio layer itself since now we have
>   more vfio/pci based drivers.
> - Instead of assigning the 'struct dev_pm_ops' in individual parent
>   driver, now the vfio_pci_core tself assigns the 'struct dev_pm_ops'. 
> - Added handling of power management around SR-IOV handling.
> - Moved the setting of drvdata in a separate patch.
> - Masked INTx before during runtime suspended state.
> - Changed the order of patches so that Fix related things are at beginning
>   of this patch series.
> - Removed storing the power state locally and used one new boolean to
>   track the d3 (D3cold and D3hot) power state 
> - Removed check for IO access in D3 power state.
> - Used another helper function vfio_lock_and_set_power_state() instead
>   of touching vfio_pci_set_power_state().
> - Considered the fixes made in
>   https://lore.kernel.org/lkml/20220217122107.22434-1-abhsahu@nvidia.com
>   and updated the patches accordingly.
> 
> * Changes in v2
>   (https://lore.kernel.org/lkml/20220124181726.19174-1-abhsahu@nvidia.com)
> 
> - Rebased patches on v5.17-rc1.
> - Included the patch to handle BAR access in D3cold.
> - Included the patch to fix memory leak.
> - Made a separate IOCTL that can be used to change the power state from
>   D3hot to D3cold and D3cold to D0.
> - Addressed the review comments given in v1.
> 
> * v1
>   https://lore.kernel.org/lkml/20211115133640.2231-1-abhsahu@nvidia.com/
> 
> Abhishek Sahu (4):
>   vfio/pci: Invalidate mmaps and block the access in D3hot power state
>   vfio/pci: Change the PF power state to D0 before enabling VFs
>   vfio/pci: Virtualize PME related registers bits and initialize to zero
>   vfio/pci: Move the unused device into low power state with runtime PM
> 
>  drivers/vfio/pci/vfio_pci_config.c |  56 ++++++++-
>  drivers/vfio/pci/vfio_pci_core.c   | 178 ++++++++++++++++++++---------
>  2 files changed, 178 insertions(+), 56 deletions(-)
> 

