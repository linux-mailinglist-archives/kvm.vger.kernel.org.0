Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6044D6A40
	for <lists+kvm@lfdr.de>; Sat, 12 Mar 2022 00:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiCKXHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 18:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiCKXHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 18:07:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D0E041385B7
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 15:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647039991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gOkZnMw4EFXXNBGRHrbUgXL0qyiQdxtkcu4QKfjCv+g=;
        b=Y4X5BRAvKmaTrfCZiUYv45ybfRTJ56GQf/h0ZoG9N2iyP8hA5wRcD7i/Cg1uvGwTtYVjfz
        QoMcNdlLQII/m9cWUtjGnLxmtQakQv5ggJFArw6EdNeGR5ctcQvxetpFSr7k9uMfz+eLAW
        duPb9fcgZJrQq+1Haa8i4JI5/OX3ZMQ=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-TyiIqIRaNSqeknyxio3rcg-1; Fri, 11 Mar 2022 18:06:30 -0500
X-MC-Unique: TyiIqIRaNSqeknyxio3rcg-1
Received: by mail-io1-f72.google.com with SMTP id g11-20020a056602072b00b00645cc0735d7so7232564iox.1
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 15:06:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=gOkZnMw4EFXXNBGRHrbUgXL0qyiQdxtkcu4QKfjCv+g=;
        b=Mlt6pEYrJSa1+15YDfGHdfYjrILhkOHlLLVYq9pbjrPF5fLxDP5163mLCAJ2ujJyuX
         41jz9qGTUwMgZcdUFcuTVXENNRIqb573b0QF4TXdmQ/ulFG26CHedaTdPPuZUNDn9eSZ
         s/C5sOwiLxL6W5T84XX/kToQCI7ldopaNmyvTwq29P9EvJmxcB74RU5cH6CHe7C1ETAn
         cQsQVahz3Tlxm6aha0fDviP6LKJY0UcP4kI8AVcOYtldGFIayhq2QxiHnaplgqR3HPme
         6m9+6yvmzDrcjw3Px9sMRuyudqBhvzq6gyjVSdMLxaT8g31DaYgrIhNyP4tLb6wWjMUO
         /yFQ==
X-Gm-Message-State: AOAM532A5ZeOPXW11riegxBBQ2K/88BnI/px5S72+eFPqjCkFd4WvrHI
        bLVpwywdgCF9btCKVyWGe98o91ox0E+PRDeDYyMAer3af4xcjQonz4GgTV61of98wgyxHT1R0f1
        s0UQR+ntS6iXG
X-Received: by 2002:a05:6e02:15c6:b0:2c2:5ab0:948 with SMTP id q6-20020a056e0215c600b002c25ab00948mr9720004ilu.171.1647039989452;
        Fri, 11 Mar 2022 15:06:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxhArWUoNW80l6HL/eIDHMs+R3e/tESmR05/T5/uO6nTve8pJSLnJGKOStok9dfJW5L+EoZZQ==
X-Received: by 2002:a05:6e02:15c6:b0:2c2:5ab0:948 with SMTP id q6-20020a056e0215c600b002c25ab00948mr9719975ilu.171.1647039988887;
        Fri, 11 Mar 2022 15:06:28 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id t3-20020a922c03000000b002c6509399c4sm5082888ile.26.2022.03.11.15.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 15:06:28 -0800 (PST)
Date:   Fri, 11 Mar 2022 16:06:27 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 5/5] vfio/pci: add the support for PCI D3cold
 state
Message-ID: <20220311160627.6ec569a9.alex.williamson@redhat.com>
In-Reply-To: <a6c73b9e-577b-4a18-63a2-79f0b3fa1185@nvidia.com>
References: <20220124181726.19174-1-abhsahu@nvidia.com>
        <20220124181726.19174-6-abhsahu@nvidia.com>
        <20220309102642.251aff25.alex.williamson@redhat.com>
        <a6c73b9e-577b-4a18-63a2-79f0b3fa1185@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Mar 2022 21:15:38 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> On 3/9/2022 10:56 PM, Alex Williamson wrote:
> > On Mon, 24 Jan 2022 23:47:26 +0530
> > Abhishek Sahu <abhsahu@nvidia.com> wrote:
> >   
> >> Currently, if the runtime power management is enabled for vfio-pci
> >> device in the guest OS, then guest OS will do the register write for
> >> PCI_PM_CTRL register. This write request will be handled in
> >> vfio_pm_config_write() where it will do the actual register write
> >> of PCI_PM_CTRL register. With this, the maximum D3hot state can be
> >> achieved for low power. If we can use the runtime PM framework,
> >> then we can achieve the D3cold state which will help in saving
> >> maximum power.
> >>
> >> 1. Since D3cold state can't be achieved by writing PCI standard
> >>    PM config registers, so this patch adds a new IOCTL which change the
> >>    PCI device from D3hot to D3cold state and then D3cold to D0 state.
> >>
> >> 2. The hypervisors can implement virtual ACPI methods. For
> >>    example, in guest linux OS if PCI device ACPI node has _PR3 and _PR0
> >>    power resources with _ON/_OFF method, then guest linux OS makes the
> >>    _OFF call during D3cold transition and then _ON during D0 transition.
> >>    The hypervisor can tap these virtual ACPI calls and then do the D3cold
> >>    related IOCTL in the vfio driver.
> >>
> >> 3. The vfio driver uses runtime PM framework to achieve the
> >>    D3cold state. For the D3cold transition, decrement the usage count and
> >>    during D0 transition increment the usage count.
> >>
> >> 4. For D3cold, the device current power state should be D3hot.
> >>    Then during runtime suspend, the pci_platform_power_transition() is
> >>    required for D3cold state. If the D3cold state is not supported, then
> >>    the device will still be in D3hot state. But with the runtime PM, the
> >>    root port can now also go into suspended state.
> >>
> >> 5. For most of the systems, the D3cold is supported at the root
> >>    port level. So, when root port will transition to D3cold state, then
> >>    the vfio PCI device will go from D3hot to D3cold state during its
> >>    runtime suspend. If root port does not support D3cold, then the root
> >>    will go into D3hot state.
> >>
> >> 6. The runtime suspend callback can now happen for 2 cases: there
> >>    is no user of vfio device and the case where user has initiated
> >>    D3cold. The 'runtime_suspend_pending' flag can help to distinguish
> >>    this case.
> >>
> >> 7. There are cases where guest has put PCI device into D3cold
> >>    state and then on the host side, user has run lspci or any other
> >>    command which requires access of the PCI config register. In this case,
> >>    the kernel runtime PM framework will resume the PCI device internally,
> >>    read the config space and put the device into D3cold state again. Some
> >>    PCI device needs the SW involvement before going into D3cold state.
> >>    For the first D3cold state, the driver running in guest side does the SW
> >>    side steps. But the second D3cold transition will be without guest
> >>    driver involvement. So, prevent this second d3cold transition by
> >>    incrementing the device usage count. This will make the device
> >>    unnecessary in D0 but it's better than failure. In future, we can some
> >>    mechanism by which we can forward these wake-up request to guest and
> >>    then the mentioned case can be handled also.
> >>
> >> 8. In D3cold, all kind of BAR related access needs to be disabled
> >>    like D3hot. Additionally, the config space will also be disabled in
> >>    D3cold state. To prevent access of config space in the D3cold state,
> >>    increment the runtime PM usage count before doing any config space
> >>    access. Also, most of the IOCTLs do the config space access, so
> >>    maintain one safe list and skip the resume only for these safe IOCTLs
> >>    alone. For other IOCTLs, the runtime PM usage count will be
> >>    incremented first.
> >>
> >> 9. Now, runtime suspend/resume callbacks need to get the vdev
> >>    reference which can be obtained by dev_get_drvdata(). Currently, the
> >>    dev_set_drvdata() is being set after returning from
> >>    vfio_pci_core_register_device(). The runtime callbacks can come
> >>    anytime after enabling runtime PM so dev_set_drvdata() must happen
> >>    before that. We can move dev_set_drvdata() inside
> >>    vfio_pci_core_register_device() itself.
> >>
> >> 10. The vfio device user can close the device after putting
> >>     the device into runtime suspended state so inside
> >>     vfio_pci_core_disable(), increment the runtime PM usage count.
> >>
> >> 11. Runtime PM will be possible only if CONFIG_PM is enabled on
> >>     the host. So, the IOCTL related code can be put under CONFIG_PM
> >>     Kconfig.
> >>
> >> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> >> ---
> >>  drivers/vfio/pci/vfio_pci.c        |   1 -
> >>  drivers/vfio/pci/vfio_pci_config.c |  11 +-
> >>  drivers/vfio/pci/vfio_pci_core.c   | 186 +++++++++++++++++++++++++++--
> >>  include/linux/vfio_pci_core.h      |   1 +
> >>  include/uapi/linux/vfio.h          |  21 ++++
> >>  5 files changed, 211 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> >> index c8695baf3b54..4ac3338c8fc7 100644
> >> --- a/drivers/vfio/pci/vfio_pci.c
> >> +++ b/drivers/vfio/pci/vfio_pci.c
> >> @@ -153,7 +153,6 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> >>       ret = vfio_pci_core_register_device(vdev);
> >>       if (ret)
> >>               goto out_free;
> >> -     dev_set_drvdata(&pdev->dev, vdev);  
> > 
> > Relocating the setting of drvdata should be proposed separately rather
> > than buried in this patch.  The driver owns drvdata, the driver is the
> > only consumer of drvdata, so pushing this into the core to impose a
> > standard for drvdata across all vfio-pci variants doesn't seem like a
> > good idea to me.
> >   
>  
>  I will check regarding this part.
>  Mainly drvdata is needed for the runtime PM callbacks which are added
>  inside core layer and we need to get vdev from struct device.
> 
> >>       return 0;
> >>
> >>  out_free:
> >> diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
> >> index dd9ed211ba6f..d20420657959 100644
> >> --- a/drivers/vfio/pci/vfio_pci_config.c
> >> +++ b/drivers/vfio/pci/vfio_pci_config.c
> >> @@ -25,6 +25,7 @@
> >>  #include <linux/uaccess.h>
> >>  #include <linux/vfio.h>
> >>  #include <linux/slab.h>
> >> +#include <linux/pm_runtime.h>
> >>
> >>  #include <linux/vfio_pci_core.h>
> >>
> >> @@ -1919,16 +1920,23 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user
> >>  ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
> >>                          size_t count, loff_t *ppos, bool iswrite)
> >>  {
> >> +     struct device *dev = &vdev->pdev->dev;
> >>       size_t done = 0;
> >>       int ret = 0;
> >>       loff_t pos = *ppos;
> >>
> >>       pos &= VFIO_PCI_OFFSET_MASK;
> >>
> >> +     ret = pm_runtime_resume_and_get(dev);
> >> +     if (ret < 0)
> >> +             return ret;
> >> +
> >>       while (count) {
> >>               ret = vfio_config_do_rw(vdev, buf, count, &pos, iswrite);
> >> -             if (ret < 0)
> >> +             if (ret < 0) {
> >> +                     pm_runtime_put(dev);
> >>                       return ret;
> >> +             }
> >>
> >>               count -= ret;
> >>               done += ret;
> >> @@ -1936,6 +1944,7 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
> >>               pos += ret;
> >>       }
> >>
> >> +     pm_runtime_put(dev);  
> > 
> > What about other config accesses, ex. shared INTx?  We need to
> > interact with the device command and status register on an incoming
> > interrupt to test if our device sent an interrupt and to mask it.  The
> > unmask eventfd can also trigger config space accesses.  Seems
> > incomplete relative to config space.
> >   
> 
>  I will check this path thoroughly.
>  But from initial analysis, it seems we have 2 path here:
> 
>  Most of the mentioned functions are being called from
>  vfio_pci_set_irqs_ioctl() and pm_runtime_resume_and_get()
>  should be called for this ioctl also in this patch.
> 
>  Second path is when we are inside IRQ handler. For that, we need some
>  other mechanism which I explained below.
>  
> >>       *ppos += done;
> >>
> >>       return done;
> >> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> >> index 38440d48973f..b70bb4fd940d 100644
> >> --- a/drivers/vfio/pci/vfio_pci_core.c
> >> +++ b/drivers/vfio/pci/vfio_pci_core.c
> >> @@ -371,12 +371,23 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
> >>       lockdep_assert_held(&vdev->vdev.dev_set->lock);
> >>
> >>       /*
> >> -      * If disable has been called while the power state is other than D0,
> >> -      * then set the power state in vfio driver to D0. It will help
> >> -      * in running the logic needed for D0 power state. The subsequent
> >> -      * runtime PM API's will put the device into the low power state again.
> >> +      * The vfio device user can close the device after putting the device
> >> +      * into runtime suspended state so wake up the device first in
> >> +      * this case.
> >>        */
> >> -     vfio_pci_set_power_state_locked(vdev, PCI_D0);
> >> +     if (vdev->runtime_suspend_pending) {
> >> +             vdev->runtime_suspend_pending = false;
> >> +             pm_runtime_resume_and_get(&pdev->dev);  
> > 
> > Doesn't vdev->power_state become unsynchronized from the actual device
> > state here and maybe elsewhere in this patch?  (I see below that maybe
> > the resume handler accounts for this)
> >   
> 
>  Yes. Inside runtime resume handler, it is being changed back to D0.
> 
> >> +     } else {
> >> +             /*
> >> +              * If disable has been called while the power state is other
> >> +              * than D0, then set the power state in vfio driver to D0. It
> >> +              * will help in running the logic needed for D0 power state.
> >> +              * The subsequent runtime PM API's will put the device into
> >> +              * the low power state again.
> >> +              */
> >> +             vfio_pci_set_power_state_locked(vdev, PCI_D0);
> >> +     }
> >>
> >>       /* Stop the device from further DMA */
> >>       pci_clear_master(pdev);
> >> @@ -693,8 +704,8 @@ int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
> >>  }
> >>  EXPORT_SYMBOL_GPL(vfio_pci_register_dev_region);
> >>
> >> -long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
> >> -             unsigned long arg)
> >> +static long vfio_pci_core_ioctl_internal(struct vfio_device *core_vdev,
> >> +                                      unsigned int cmd, unsigned long arg)
> >>  {
> >>       struct vfio_pci_core_device *vdev =
> >>               container_of(core_vdev, struct vfio_pci_core_device, vdev);
> >> @@ -1241,10 +1252,119 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
> >>               default:
> >>                       return -ENOTTY;
> >>               }
> >> +#ifdef CONFIG_PM
> >> +     } else if (cmd == VFIO_DEVICE_POWER_MANAGEMENT) {  
> > 
> > I'd suggest using a DEVICE_FEATURE ioctl for this.  This ioctl doesn't
> > follow the vfio standard of argsz/flags and doesn't seem to do anything
> > special that we couldn't achieve with a DEVICE_FEATURE ioctl.
> >   
> 
>  Sure. DEVICE_FEATURE can help for this.
> 
> >> +             struct vfio_power_management vfio_pm;
> >> +             struct pci_dev *pdev = vdev->pdev;
> >> +             bool request_idle = false, request_resume = false;
> >> +             int ret = 0;
> >> +
> >> +             if (copy_from_user(&vfio_pm, (void __user *)arg, sizeof(vfio_pm)))
> >> +                     return -EFAULT;
> >> +
> >> +             /*
> >> +              * The vdev power related fields are protected with memory_lock
> >> +              * semaphore.
> >> +              */
> >> +             down_write(&vdev->memory_lock);
> >> +             switch (vfio_pm.d3cold_state) {
> >> +             case VFIO_DEVICE_D3COLD_STATE_ENTER:
> >> +                     /*
> >> +                      * For D3cold, the device should already in D3hot
> >> +                      * state.
> >> +                      */
> >> +                     if (vdev->power_state < PCI_D3hot) {
> >> +                             ret = EINVAL;
> >> +                             break;
> >> +                     }
> >> +
> >> +                     if (!vdev->runtime_suspend_pending) {
> >> +                             vdev->runtime_suspend_pending = true;
> >> +                             pm_runtime_put_noidle(&pdev->dev);
> >> +                             request_idle = true;
> >> +                     }  
> > 
> > If I call this multiple times, runtime_suspend_pending prevents it from
> > doing anything, but what should the return value be in that case?  Same
> > question for exit.
> >   
> 
>  For entry, the user should not call moving the device to D3cold, if it has
>  already requested. So, we can return error in this case. For exit,
>  currently, in this patch, I am clearing runtime_suspend_pending if the
>  wake-up is triggered from the host side (with lspci or some other command).
>  In that case, the exit should not return error. Should we add code to 
>  detect multiple calling of these and ensure only one
>  VFIO_DEVICE_D3COLD_STATE_ENTER/VFIO_DEVICE_D3COLD_STATE_EXIT can be called.

AIUI, the argument is that we can't re-enter d3cold w/o guest driver
support, so if an lspci which was unknown to have occurred by the
device user were to wake the device, it seems the user would see
arbitrarily different results attempting to put the device to sleep
again.

> >> +
> >> +                     break;
> >> +
> >> +             case VFIO_DEVICE_D3COLD_STATE_EXIT:
> >> +                     /*
> >> +                      * If the runtime resume has already been run, then
> >> +                      * the device will be already in D0 state.
> >> +                      */
> >> +                     if (vdev->runtime_suspend_pending) {
> >> +                             vdev->runtime_suspend_pending = false;
> >> +                             pm_runtime_get_noresume(&pdev->dev);
> >> +                             request_resume = true;
> >> +                     }
> >> +
> >> +                     break;
> >> +
> >> +             default:
> >> +                     ret = EINVAL;
> >> +                     break;
> >> +             }
> >> +
> >> +             up_write(&vdev->memory_lock);
> >> +
> >> +             /*
> >> +              * Call the runtime PM API's without any lock. Inside vfio driver
> >> +              * runtime suspend/resume, the locks can be acquired again.
> >> +              */
> >> +             if (request_idle)
> >> +                     pm_request_idle(&pdev->dev);
> >> +
> >> +             if (request_resume)
> >> +                     pm_runtime_resume(&pdev->dev);
> >> +
> >> +             return ret;
> >> +#endif
> >>       }
> >>
> >>       return -ENOTTY;
> >>  }
> >> +
> >> +long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
> >> +                      unsigned long arg)
> >> +{
> >> +#ifdef CONFIG_PM
> >> +     struct vfio_pci_core_device *vdev =
> >> +             container_of(core_vdev, struct vfio_pci_core_device, vdev);
> >> +     struct device *dev = &vdev->pdev->dev;
> >> +     bool skip_runtime_resume = false;
> >> +     long ret;
> >> +
> >> +     /*
> >> +      * The list of commands which are safe to execute when the PCI device
> >> +      * is in D3cold state. In D3cold state, the PCI config or any other IO
> >> +      * access won't work.
> >> +      */
> >> +     switch (cmd) {
> >> +     case VFIO_DEVICE_POWER_MANAGEMENT:
> >> +     case VFIO_DEVICE_GET_INFO:
> >> +     case VFIO_DEVICE_FEATURE:
> >> +             skip_runtime_resume = true;
> >> +             break;  
> > 
> > How can we know that there won't be DEVICE_FEATURE calls that touch the
> > device, the recently added migration via DEVICE_FEATURE does already.
> > DEVICE_GET_INFO seems equally as prone to breaking via capabilities
> > that could touch the device.  It seems easier to maintain and more
> > consistent to the user interface if we simply define that any device
> > access will resume the device.  
> 
>  In that case, we can resume the device for all case without
>  maintaining the safe list.
> 
> > We need to do something about interrupts though. > Maybe we could error the user ioctl to set d3cold
> > for devices running in INTx mode, but we also have numerous ways that
> > the device could be resumed under the user, which might start
> > triggering MSI/X interrupts?
> >   
> 
>  All the resuming we are mainly to prevent any malicious sequence.
>  If we see from normal OS side, then once the guest kernel has moved
>  the device into D3cold, then it should not do any config space
>  access. Similarly, from hypervisor, it should not invoke any
>  ioctl other than moving the device into D0 again when the device
>  is in D3cold. But, preventing the device to go into D3cold when
>  any other ioctl or config space access is happening is not easy,
>  so incrementing usage count before these access will ensure that
>  the device won't go into D3cold. 
> 
>  For interrupts, can the interrupt happen (Both INTx and MSI/x)
>  if the device is in D3cold?

The device itself shouldn't be generating interrupts and we don't share
MSI interrupts between devices (afaik), but we do share INTx interrupts.

>  In D3cold, the PME events are possible
>  and these events will anyway resume the device first. If the
>  interrupts are not possible then can we disable all the interrupts
>  somehow before going calling runtime PM API's to move the device into D3cold
>  and enable it again during runtime resume. We can wait for all existing
>  Interrupt to be finished first. I am not sure if this is possible. 

In the case of shared INTx, it's not just inflight interrupts.
Personally I wouldn't have an issue if we increment the usage counter
when INTx is in use to simply avoid the issue, but does that invalidate
the use case you're trying to enable?  Otherwise I think we'd need to
remove and re-add the handler around d3cold.

>  Returning error for user ioctl to set d3cold while interrupts are
>  happening needs some synchronization at both interrupt handler and
>  ioctl code and using runtime resume inside interrupt handler
>  may not be safe.

It's not a race condition to synchronize, it's simply that a shared
INTX interrupt can occur any time and we need to make sure we don't
touch the device when that occurs, either by preventing d3cold and INTx
in combination, removing the handler, or maybe adding a test in the
handler to not touch the device - either of the latter we need to be
sure we're not risking introducing interrupts storms by being out of
sync with the device state.

> >> +
> >> +     default:
> >> +             break;
> >> +     }
> >> +
> >> +     if (!skip_runtime_resume) {
> >> +             ret = pm_runtime_resume_and_get(dev);
> >> +             if (ret < 0)
> >> +                     return ret;
> >> +     }
> >> +
> >> +     ret = vfio_pci_core_ioctl_internal(core_vdev, cmd, arg);
> >> +  
> > 
> > I'm not a fan of wrapping the main ioctl interface for power management
> > like this.
> >   
> 
>  We need to increment the usage count at entry and decrement it
>  again at exit. Currently, from lot of places directly, we are
>  calling 'return' instead of going at function end. If we need to
>  get rid of wrapper function, then I need to replace all return with
>  'goto' for going at the function end and return after decrementing
>  the usage count. Will this be fine ?


Yes, I think that would be preferable.
 
 
> >> +     if (!skip_runtime_resume)
> >> +             pm_runtime_put(dev);
> >> +
> >> +     return ret;
> >> +#else
> >> +     return vfio_pci_core_ioctl_internal(core_vdev, cmd, arg);
> >> +#endif
> >> +}
> >>  EXPORT_SYMBOL_GPL(vfio_pci_core_ioctl);
> >>
> >>  static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
> >> @@ -1897,6 +2017,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
> >>               return -EBUSY;
> >>       }
> >>
> >> +     dev_set_drvdata(&pdev->dev, vdev);
> >>       if (pci_is_root_bus(pdev->bus)) {
> >>               ret = vfio_assign_device_set(&vdev->vdev, vdev);
> >>       } else if (!pci_probe_reset_slot(pdev->slot)) {
> >> @@ -1966,6 +2087,7 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
> >>               pm_runtime_get_noresume(&pdev->dev);
> >>
> >>       pm_runtime_forbid(&pdev->dev);
> >> +     dev_set_drvdata(&pdev->dev, NULL);
> >>  }
> >>  EXPORT_SYMBOL_GPL(vfio_pci_core_unregister_device);
> >>
> >> @@ -2219,11 +2341,61 @@ static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
> >>  #ifdef CONFIG_PM
> >>  static int vfio_pci_core_runtime_suspend(struct device *dev)
> >>  {
> >> +     struct pci_dev *pdev = to_pci_dev(dev);
> >> +     struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
> >> +
> >> +     down_read(&vdev->memory_lock);
> >> +
> >> +     /*
> >> +      * runtime_suspend_pending won't be set if there is no user of vfio pci
> >> +      * device. In that case, return early and PCI core will take care of
> >> +      * putting the device in the low power state.
> >> +      */
> >> +     if (!vdev->runtime_suspend_pending) {
> >> +             up_read(&vdev->memory_lock);
> >> +             return 0;
> >> +     }  
> > 
> > Doesn't this also mean that idle, unused devices can at best sit in
> > d3hot rather than d3cold?
> >   
> 
>  Sorry. I didn't get this point.
> 
>  For unused devices, the PCI core will move the device into D3cold directly.

Could you point out what path triggers that?  I inferred that this
function would be called any time the usage count allows transition to
d3cold and the above test would prevent the device entering d3cold
unless the user requested it.

>  For the used devices, the config space write is happening first before
>  this ioctl is called and the config space write is moving the device
>  into D3hot so we need to do some manual thing here.

Why is it that a user owned device cannot re-enter d3cold without
driver support, but and idle device does?  Simply because we expect to
reset the device before returning it back to the host or exposing it to
a user?  I'd expect that after d3cold->d0 we're essentially at a
power-on state, which ideally would be similar to a post-reset state,
so I don't follow how driver support factors in to re-entering d3cold.

> >> +
> >> +     /*
> >> +      * The runtime suspend will be called only if device is already at
> >> +      * D3hot state. Now, change the device state from D3hot to D3cold by
> >> +      * using platform power management. If setting of D3cold is not
> >> +      * supported for the PCI device, then the device state will still be
> >> +      * in D3hot state. The PCI core expects to save the PCI state, if
> >> +      * driver runtime routine handles the power state management.
> >> +      */
> >> +     pci_save_state(pdev);
> >> +     pci_platform_power_transition(pdev, PCI_D3cold);
> >> +     up_read(&vdev->memory_lock);
> >> +
> >>       return 0;
> >>  }
> >>
> >>  static int vfio_pci_core_runtime_resume(struct device *dev)
> >>  {
> >> +     struct pci_dev *pdev = to_pci_dev(dev);
> >> +     struct vfio_pci_core_device *vdev = dev_get_drvdata(dev);
> >> +
> >> +     down_write(&vdev->memory_lock);
> >> +
> >> +     /*
> >> +      * The PCI core will move the device to D0 state before calling the
> >> +      * driver runtime resume.
> >> +      */
> >> +     vfio_pci_set_power_state_locked(vdev, PCI_D0);  
> > 
> > Maybe this is where vdev->power_state is kept synchronized?
> >   
>  
>  Yes. vdev->power_state will be changed here.
> 
> >> +
> >> +     /*
> >> +      * Some PCI device needs the SW involvement before going to D3cold
> >> +      * state again. So if there is any wake-up which is not triggered
> >> +      * by the guest, then increase the usage count to prevent the
> >> +      * second runtime suspend.
> >> +      */  
> > 
> > Can you give examples of devices that need this and the reason they
> > need this?  The interface is not terribly deterministic if a random
> > unprivileged lspci on the host can move devices back to d3hot.   
> 
>  I am not sure about other device but this is happening for
>  the nvidia GPU itself. 
>  
>  For nvidia GPU, during runtime suspend, we keep the GPU video memory
>  in self-refresh mode for high video memory usage. Each video memory
>  self refesh entry before D3cold requires nvidia SW involvement.
>  Without SW self-refresh sequnece involvement, it won't work. 


So we're exposing acpi power interfaces to turn a device off, which
don't really turn the device off, but leaves it in some sort of
low-power memory refresh state, rather than a fully off state as I had
assumed above.  Does this suggest the host firmware ACPI has knowledge
of the device and does different things?

>  Details regarding runtime suspend with self-refresh can be found in
> 
>  https://download.nvidia.com/XFree86/Linux-x86_64/495.46/README/dynamicpowermanagement.html#VidMemThreshold
> 
>  But, if GPU video memory usage is low, then we turnoff video memory
>  and save all the allocation in system memory. In this case, SW involvement 
>  is not required. 

Ok, so there's some heuristically determined vram usage where the
driver favors suspend latency versus power savings and somehow keeps
the device in this low-power, refresh state versus a fully off state.
How unique is this behavior to NVIDIA devices?  It seems like we're
trying to add d3cold, but special case it based on a device that might
have a rather quirky d3cold behavior.  Is there something we can test
about the state of the device to know which mode it's using?  Is there
something we can virtualize on the device to force the driver to use
the higher latency, lower power d3cold mode that results in fewer
restrictions?  Or maybe this is just common practice?

> > How useful is this implementation if a notice to the guest of a resumed
> > device is TBD?  Thanks,
> > 
> > Alex
> >   
> 
>  I have prototyped this earlier by using eventfd_ctx for pme and whenever we get
>  a resume triggered by host, then it will forward the same to hypervisor.
>  Then in the hypervisor, it can write into virtual root port PME related registers
>  and send PME event which will wake-up the PCI device in the guest side.
>  It will help in handling PME events related wake-up also which are currently
>  disabled in PATCH 2 of this patch series.

But then what does the guest do with the device?  For example, if we
have a VM with an assigned GPU running an idle desktop where the
monitor has gone into power save, does running lspci on the host
randomly wake the desktop and monitor?  I'd like to understand how
unique the return to d3cold behavior is to this device and whether we
can restrict that in some way.  An option that's now at our disposal
would be to create an NVIDIA GPU variant of vfio-pci that has
sufficient device knowledge to perhaps retrigger the vram refresh
d3cold state rather than lose vram data going into a standard d3cold
state.  Thanks,

Alex

