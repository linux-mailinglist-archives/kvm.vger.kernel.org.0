Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E035C4A6889
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 00:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242888AbiBAXcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 18:32:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54289 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230000AbiBAXb7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Feb 2022 18:31:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643758318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q4nXqGkSOBhfpqUihr9Nmqi8YqjX2zF+f6WealGvq4g=;
        b=JAB9k6h2yNaUG6mNSg8WVuza6O7b5cjRk5X/U7I85BoHbBPqR7re1FrJKBRCxTnj5XFXjj
        ZN8cAWOO07n3NaICth7VJ0GSDn9bxq1ik6BHHHSV3wLGfyG0axYFS0H+cu6fcVKX/Ozz5A
        4q0q2RTekqimf/gCgw0yanYr/xHolZk=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-o_UjXP5iM0qilyvM3z59Kw-1; Tue, 01 Feb 2022 18:31:57 -0500
X-MC-Unique: o_UjXP5iM0qilyvM3z59Kw-1
Received: by mail-ot1-f72.google.com with SMTP id h5-20020a9d5545000000b0059ecbfae94eso10255726oti.17
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 15:31:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q4nXqGkSOBhfpqUihr9Nmqi8YqjX2zF+f6WealGvq4g=;
        b=Fk3z+jx2b8LlGAxBxK9ALSWv3cBqt+e2bnwYgunK+RmcTd2DfBui5ef3LrMXvqkd6K
         A7/sDPmAmzsGOwyKVYi7t5sXE77Ob74RoFrkDe4K6+YzowfamIakisHTvKkxl3b0A6uW
         dpfy6GNjbogE8XWw2jb8kFOqBsFo8VlIP1oikdP1OwrJIqiJcWkhvvJ12k/Otvg58joZ
         1rGARMiJdNCc2N08JPll4SauKR386v/oe+uLSKkCsUfSLfhH0UbW2a0ekwenEPCGjvp3
         ur9X799gCuqA/i9zPxhLzDhJv7cvJZ7B142JoRczR45g1krghkJ4F6xnQv0SJuvE7W0q
         ycmA==
X-Gm-Message-State: AOAM5339T4bLJ+7CuPeQk4Thwuy6G5OGEEB1TJjcir+fZQrUl1kyvLb0
        1YIDEdlTDzAj8NKXln/QZl1vmpB7BitXhKfrAMatOhZBaFwvc9HZavmmFrEfSouhUc04c8ynk+X
        Q7X/lML1CTxLQ
X-Received: by 2002:a05:6830:4081:: with SMTP id x1mr15380064ott.272.1643758316824;
        Tue, 01 Feb 2022 15:31:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz7xbNBp424qduMgZNlEc7ffNGRkTuF/WEghc+E6iYgQoKm1sGpOUPXXnci61cs8iln5CdbTQ==
X-Received: by 2002:a05:6830:4081:: with SMTP id x1mr15380056ott.272.1643758316507;
        Tue, 01 Feb 2022 15:31:56 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l1sm13638894otd.18.2022.02.01.15.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 15:31:56 -0800 (PST)
Date:   Tue, 1 Feb 2022 16:31:54 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vfio/pci: fix memory leak during D3hot to D0
 transition
Message-ID: <20220201163155.0529edc1.alex.williamson@redhat.com>
In-Reply-To: <948e7798-7337-d093-6296-cedd09c733f5@nvidia.com>
References: <20220131112450.3550-1-abhsahu@nvidia.com>
        <20220131131151.4f113557.alex.williamson@redhat.com>
        <948e7798-7337-d093-6296-cedd09c733f5@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 1 Feb 2022 17:06:43 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> On 2/1/2022 1:41 AM, Alex Williamson wrote:
> > On Mon, 31 Jan 2022 16:54:50 +0530
> > Abhishek Sahu <abhsahu@nvidia.com> wrote:
> >   
> >> If needs_pm_restore is set (PCI device does not have support for no
> >> soft reset), then the current PCI state will be saved during D0->D3hot
> >> transition and same will be restored back during D3hot->D0 transition.
> >> For saving the PCI state locally, pci_store_saved_state() is being
> >> used and the pci_load_and_free_saved_state() will free the allocated
> >> memory.
> >>
> >> But for reset related IOCTLs, vfio driver calls PCI reset related
> >> API's which will internally change the PCI power state back to D0. So,
> >> when the guest resumes, then it will get the current state as D0 and it
> >> will skip the call to vfio_pci_set_power_state() for changing the
> >> power state to D0 explicitly. In this case, the memory pointed by
> >> pm_save will never be freed. In a malicious sequence, the state changing
> >> to D3hot followed by VFIO_DEVICE_RESET/VFIO_DEVICE_PCI_HOT_RESET can be
> >> run in a loop and it can cause an OOM situation.
> >>
> >> Also, pci_pm_reset() returns -EINVAL if we try to reset a device that
> >> isn't currently in D0. Therefore any path where we're triggering a
> >> function reset that could use a PM reset and we don't know if the device
> >> is in D0, should wake up the device before we try that reset.
> >>
> >> This patch changes the device power state to D0 by invoking
> >> vfio_pci_set_power_state() before calling reset related API's.
> >> It will help in fixing the mentioned memory leak and making sure
> >> that the device is in D0 during reset. Also, to prevent any similar
> >> memory leak for future development, this patch frees memory first
> >> before overwriting 'pm_save'.
> >>
> >> Fixes: 51ef3a004b1e ("vfio/pci: Restore device state on PM transition")
> >> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> >> ---
> >>
> >> * Changes in v2
> >>
> >> - Add the Fixes tag and sent this patch independently.
> >> - Invoke vfio_pci_set_power_state() before invoking reset related API's.
> >> - Removed saving of power state locally.
> >> - Removed warning before 'kfree(vdev->pm_save)'.
> >> - Updated comments and commit message according to updated changes.
> >>
> >> * v1 of this patch was sent in
> >> https://lore.kernel.org/lkml/20220124181726.19174-4-abhsahu@nvidia.com/
> >>
> >>  drivers/vfio/pci/vfio_pci_core.c | 27 +++++++++++++++++++++++++++
> >>  1 file changed, 27 insertions(+)
> >>
> >> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> >> index f948e6cd2993..d6dd4f7c4b2c 100644
> >> --- a/drivers/vfio/pci/vfio_pci_core.c
> >> +++ b/drivers/vfio/pci/vfio_pci_core.c
> >> @@ -228,6 +228,13 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
> >>       if (!ret) {
> >>               /* D3 might be unsupported via quirk, skip unless in D3 */
> >>               if (needs_save && pdev->current_state >= PCI_D3hot) {
> >> +                     /*
> >> +                      * If somehow, the vfio driver was not able to free the
> >> +                      * memory allocated in pm_save, then free the earlier
> >> +                      * memory first before overwriting pm_save to prevent
> >> +                      * memory leak.
> >> +                      */
> >> +                     kfree(vdev->pm_save);
> >>                       vdev->pm_save = pci_store_saved_state(pdev);
> >>               } else if (needs_restore) {
> >>                       pci_load_and_free_saved_state(pdev, &vdev->pm_save);
> >> @@ -322,6 +329,12 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
> >>       /* For needs_reset */
> >>       lockdep_assert_held(&vdev->vdev.dev_set->lock);
> >>
> >> +     /*
> >> +      * This function can be invoked while the power state is non-D0,
> >> +      * Change the device power state to D0 first.  
> > 
> > I think we need to describe more why we're doing this than what we're
> > doing.  We need to make sure the device is in D0 in case we have a
> > reset method that depends on that directly, ex. pci_pm_reset(), or
> > possibly device specific resets that may access device BAR resources.
> > I think it's placed here in the function so that the config space
> > changes below aren't overwritten by restoring the saved state and maybe
> > also because the set_irqs_ioctl() call might access device MMIO space.
> >   
>  
>  Thanks Alex.
>  I will add more details here in the comment.
> 
> >> +      */
> >> +     vfio_pci_set_power_state(vdev, PCI_D0);
> >> +
> >>       /* Stop the device from further DMA */
> >>       pci_clear_master(pdev);
> >>
> >> @@ -921,6 +934,13 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
> >>                       return -EINVAL;
> >>
> >>               vfio_pci_zap_and_down_write_memory_lock(vdev);
> >> +
> >> +             /*
> >> +              * This function can be invoked while the power state is non-D0,
> >> +              * Change the device power state to D0 before doing reset.
> >> +              */  
> > 
> > See below, reconsidering this...
> >   
> >> +             vfio_pci_set_power_state(vdev, PCI_D0);
> >> +
> >>               ret = pci_try_reset_function(vdev->pdev);
> >>               up_write(&vdev->memory_lock);
> >>
> >> @@ -2055,6 +2075,13 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> >>       }
> >>       cur_mem = NULL;
> >>
> >> +     /*
> >> +      * This function can be invoked while the power state is non-D0.
> >> +      * Change power state of all devices to D0 before doing reset.
> >> +      */  
> > 
> > Here I have trouble convincing myself exactly what we're doing.  As you
> > note in patch 1/ of the RFC series, pci_reset_bus(), or more precisely
> > pci_dev_save_and_disable(), wakes the device to D0 before reset, so we
> > can't be doing this only to get the device into D0.  The function level
> > resets do the same.
> > 
> > Actually, now I'm remembering and debugging where I got myself confused
> > previously with pci_pm_reset().  The scenario was a Windows guest with
> > an assigned Intel 82574L NIC.  When doing a shutdown from the guest the
> > device is placed in D3hot and we enter vfio_pci_core_disable() in that
> > state.  That function however uses __pci_reset_function_locked(), which
> > skips the pci_dev_save_and_disable() since much of it is redundant for
> > that call path (I think I generalized this to all flavors of
> > pci_reset_function() in my head).  
> 
>  Thanks for providing the background related with the original issue.
> 
> > 
> > The standard call to pci_try_reset_function(), as in the previous
> > chunk, will make use of pci_dev_save_and_disable(), so for either of
> > these latter cases the concern cannot be simply having the device in D0,
> > we need a reason that we want the previously saved state restored on the
> > device before the reset, and thus restored to the device after the
> > reset as the rationale for the change.
> >   
> 
>  I will add this as a comment.
> 
> >> +     list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
> >> +             vfio_pci_set_power_state(cur, PCI_D0);
> >> +
> >>       ret = pci_reset_bus(pdev);
> >>
> >>  err_undo:  
> > 
> > 
> > We also call pci_reset_bus() in vfio_pci_dev_set_try_reset().  In that
> > case, none of the other devices can be in use by the user, but they can
> > certainly be in D3hot with previous device state saved off into our
> > pm_save cache.  If we don't have a good reason to restore in that case,
> > I'm wondering if we really have a good reason to restore in the above
> > two cases.
> > 
> > Perhaps we just need the first chunk above to resolve the memory leak,  
> 
>  First chunk means only the changes done in vfio_pci_set_power_state()
>  which is calling kfree() before calling pci_store_saved_state().
>  Or I need to include more things in the first patch ?

Correct, first chunk as is the first change in the patch.  Patch chunks
are delineated by the @@ offset lines.

> 
>  With the kfree(), the original memory leak issue should be solved.
> 
> > and the second chunk as a separate patch to resolve the issue with
> > devices entering vfio_pci_core_disable() in non-D0 state.  Sorry if I  
> 
>  And this second patch will contain rest of the things where
>  we will call vfio_pci_set_power_state() explicitly for moving to
>  D0 state ?

At least the first one in vfio_pci_core_disable(), the others need
justification.

>  Also, We need to explore if setting to D0 state is really required at
>  all these places and If it is not required, then we don't need second
>  patch ?

We need a second patch, I'm convinced that we don't otherwise wake the
device to D0 before we potentially get to pci_pm_reset() in
vfio_pci_core_disable().  It's the remaining cases of setting D0 that
I'm less clear on.  If it's the case that we need to restore config
space any time a NoSoftRst- device is woken from D3hot and the state
saved and restored around the reset is meaningless otherwise, that's a
valid justification, but is it accurate?  If so, we should recheck the
other case of calling pci_reset_bus() too.  Thanks,

Alex

