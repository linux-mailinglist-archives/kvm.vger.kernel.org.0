Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D56034AE3BE
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 23:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386714AbiBHWX0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 17:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386944AbiBHV0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 16:26:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 11241C0612B8
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 13:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644355590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PTAFf6Y1OuJIwU7w/pTZW7vGcikOtshmmvlk0mY9Rzw=;
        b=Sl7FUXOj5yDS6CDhoGmOabghz2KyUbHMVd6xWoT2oOmzk8NOCI8/3Q9GxG0gWo9KpDbMlo
        Z3qwIPzWvHVoYnfvSuEKLRE5ppWnmTOYxj1ovDt8HMgLZjROu4WDDdg2zdzmnYcQdJSkgW
        8zbiD3dCiuVsiZv2FCud2RrSkhxfUhA=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-LzRQWCrvOVWbtt_k4ZgQdw-1; Tue, 08 Feb 2022 16:26:28 -0500
X-MC-Unique: LzRQWCrvOVWbtt_k4ZgQdw-1
Received: by mail-io1-f71.google.com with SMTP id o189-20020a6bbec6000000b00604e5f63337so362390iof.15
        for <kvm@vger.kernel.org>; Tue, 08 Feb 2022 13:26:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=PTAFf6Y1OuJIwU7w/pTZW7vGcikOtshmmvlk0mY9Rzw=;
        b=1cK7e/PBClAMifQSfgHXOrD+Kmc7HAUigobeoGbHBXC/jjmvxICxH/d+bXUxlV6ork
         ifbn65guZkizLnUkFsGDV4wjE9EXZh/kX4ZryAql/Th0H7AVBh/BPpkwRj+Ro8vBysXq
         5JyJBJazTTa6iHLSmzXCJGjPSgeDNxGKZ+o3sy+n8Xs11TFMOErYdJ5Kp8+Qqq4uCYQI
         kbkt9FmLSlw9pdx9wI3A9YtCGph8QAzjCBsBYs9Wii3Spt/Uy3+a6OXECyXJxYPPxFUq
         QOR78skKm+X7Qrjf0um1GgU3tkuMF6R5UEhFEoqvocJr3Rzp06jHDF5piUoSeGjArk+P
         Xehg==
X-Gm-Message-State: AOAM532VvIQas4ygL9tUWtQ/krvpTO6qeAYmaZkV5umGEg5fwyycvq2i
        PA1ZFFbld8w9OefeRsupgkOcqauzXnw5trdz3kp2logmnuZ/RyFirUTxyFBh2tL9CifSva7jbh0
        84HgixylgLj/t
X-Received: by 2002:a02:852e:: with SMTP id g43mr3064736jai.46.1644355588132;
        Tue, 08 Feb 2022 13:26:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyeypPlbVpDHVg/rGfSETNHOsgypuWJjiGaKKCdPGrykSxU2dju7TFGfz2AANH4krceRKqUQA==
X-Received: by 2002:a02:852e:: with SMTP id g43mr3064724jai.46.1644355587695;
        Tue, 08 Feb 2022 13:26:27 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c13sm4272634ilr.55.2022.02.08.13.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 13:26:27 -0800 (PST)
Date:   Tue, 8 Feb 2022 14:26:24 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vfio/pci: fix memory leak during D3hot to D0
 transition
Message-ID: <20220208142624.4700fb21.alex.williamson@redhat.com>
In-Reply-To: <f7167fa2-f75c-3fc2-7061-adc7de83f571@nvidia.com>
References: <20220131112450.3550-1-abhsahu@nvidia.com>
        <20220131131151.4f113557.alex.williamson@redhat.com>
        <948e7798-7337-d093-6296-cedd09c733f5@nvidia.com>
        <20220201163155.0529edc1.alex.williamson@redhat.com>
        <f7167fa2-f75c-3fc2-7061-adc7de83f571@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Feb 2022 00:50:08 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> On 2/2/2022 5:01 AM, Alex Williamson wrote:
> > On Tue, 1 Feb 2022 17:06:43 +0530
> > Abhishek Sahu <abhsahu@nvidia.com> wrote:
> >  =20
> >> On 2/1/2022 1:41 AM, Alex Williamson wrote: =20
> >>> On Mon, 31 Jan 2022 16:54:50 +0530
> >>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> >>> =20
> >>>> If needs_pm_restore is set (PCI device does not have support for no
> >>>> soft reset), then the current PCI state will be saved during D0->D3h=
ot
> >>>> transition and same will be restored back during D3hot->D0 transitio=
n.
> >>>> For saving the PCI state locally, pci_store_saved_state() is being
> >>>> used and the pci_load_and_free_saved_state() will free the allocated
> >>>> memory.
> >>>>
> >>>> But for reset related IOCTLs, vfio driver calls PCI reset related
> >>>> API's which will internally change the PCI power state back to D0. S=
o,
> >>>> when the guest resumes, then it will get the current state as D0 and=
 it
> >>>> will skip the call to vfio_pci_set_power_state() for changing the
> >>>> power state to D0 explicitly. In this case, the memory pointed by
> >>>> pm_save will never be freed. In a malicious sequence, the state chan=
ging
> >>>> to D3hot followed by VFIO_DEVICE_RESET/VFIO_DEVICE_PCI_HOT_RESET can=
 be
> >>>> run in a loop and it can cause an OOM situation.
> >>>>
> >>>> Also, pci_pm_reset() returns -EINVAL if we try to reset a device that
> >>>> isn't currently in D0. Therefore any path where we're triggering a
> >>>> function reset that could use a PM reset and we don't know if the de=
vice
> >>>> is in D0, should wake up the device before we try that reset.
> >>>>
> >>>> This patch changes the device power state to D0 by invoking
> >>>> vfio_pci_set_power_state() before calling reset related API's.
> >>>> It will help in fixing the mentioned memory leak and making sure
> >>>> that the device is in D0 during reset. Also, to prevent any similar
> >>>> memory leak for future development, this patch frees memory first
> >>>> before overwriting 'pm_save'.
> >>>>
> >>>> Fixes: 51ef3a004b1e ("vfio/pci: Restore device state on PM transitio=
n")
> >>>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> >>>> ---
> >>>>
> >>>> * Changes in v2
> >>>>
> >>>> - Add the Fixes tag and sent this patch independently.
> >>>> - Invoke vfio_pci_set_power_state() before invoking reset related AP=
I's.
> >>>> - Removed saving of power state locally.
> >>>> - Removed warning before 'kfree(vdev->pm_save)'.
> >>>> - Updated comments and commit message according to updated changes.
> >>>>
> >>>> * v1 of this patch was sent in
> >>>> https://lore.kernel.org/lkml/20220124181726.19174-4-abhsahu@nvidia.c=
om/
> >>>>
> >>>>  drivers/vfio/pci/vfio_pci_core.c | 27 +++++++++++++++++++++++++++
> >>>>  1 file changed, 27 insertions(+)
> >>>>
> >>>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfi=
o_pci_core.c
> >>>> index f948e6cd2993..d6dd4f7c4b2c 100644
> >>>> --- a/drivers/vfio/pci/vfio_pci_core.c
> >>>> +++ b/drivers/vfio/pci/vfio_pci_core.c
> >>>> @@ -228,6 +228,13 @@ int vfio_pci_set_power_state(struct vfio_pci_co=
re_device *vdev, pci_power_t stat
> >>>>       if (!ret) {
> >>>>               /* D3 might be unsupported via quirk, skip unless in D=
3 */
> >>>>               if (needs_save && pdev->current_state >=3D PCI_D3hot) {
> >>>> +                     /*
> >>>> +                      * If somehow, the vfio driver was not able to=
 free the
> >>>> +                      * memory allocated in pm_save, then free the =
earlier
> >>>> +                      * memory first before overwriting pm_save to =
prevent
> >>>> +                      * memory leak.
> >>>> +                      */
> >>>> +                     kfree(vdev->pm_save);
> >>>>                       vdev->pm_save =3D pci_store_saved_state(pdev);
> >>>>               } else if (needs_restore) {
> >>>>                       pci_load_and_free_saved_state(pdev, &vdev->pm_=
save);
> >>>> @@ -322,6 +329,12 @@ void vfio_pci_core_disable(struct vfio_pci_core=
_device *vdev)
> >>>>       /* For needs_reset */
> >>>>       lockdep_assert_held(&vdev->vdev.dev_set->lock);
> >>>>
> >>>> +     /*
> >>>> +      * This function can be invoked while the power state is non-D=
0,
> >>>> +      * Change the device power state to D0 first. =20
> >>>
> >>> I think we need to describe more why we're doing this than what we're
> >>> doing.  We need to make sure the device is in D0 in case we have a
> >>> reset method that depends on that directly, ex. pci_pm_reset(), or
> >>> possibly device specific resets that may access device BAR resources.
> >>> I think it's placed here in the function so that the config space
> >>> changes below aren't overwritten by restoring the saved state and may=
be
> >>> also because the set_irqs_ioctl() call might access device MMIO space.
> >>> =20
> >>
> >>  Thanks Alex.
> >>  I will add more details here in the comment.
> >> =20
> >>>> +      */
> >>>> +     vfio_pci_set_power_state(vdev, PCI_D0);
> >>>> +
> >>>>       /* Stop the device from further DMA */
> >>>>       pci_clear_master(pdev);
> >>>>
> >>>> @@ -921,6 +934,13 @@ long vfio_pci_core_ioctl(struct vfio_device *co=
re_vdev, unsigned int cmd,
> >>>>                       return -EINVAL;
> >>>>
> >>>>               vfio_pci_zap_and_down_write_memory_lock(vdev);
> >>>> +
> >>>> +             /*
> >>>> +              * This function can be invoked while the power state =
is non-D0,
> >>>> +              * Change the device power state to D0 before doing re=
set.
> >>>> +              */ =20
> >>>
> >>> See below, reconsidering this...
> >>> =20
> >>>> +             vfio_pci_set_power_state(vdev, PCI_D0);
> >>>> +
> >>>>               ret =3D pci_try_reset_function(vdev->pdev);
> >>>>               up_write(&vdev->memory_lock);
> >>>>
> >>>> @@ -2055,6 +2075,13 @@ static int vfio_pci_dev_set_hot_reset(struct =
vfio_device_set *dev_set,
> >>>>       }
> >>>>       cur_mem =3D NULL;
> >>>>
> >>>> +     /*
> >>>> +      * This function can be invoked while the power state is non-D=
0.
> >>>> +      * Change power state of all devices to D0 before doing reset.
> >>>> +      */ =20
> >>>
> >>> Here I have trouble convincing myself exactly what we're doing.  As y=
ou
> >>> note in patch 1/ of the RFC series, pci_reset_bus(), or more precisely
> >>> pci_dev_save_and_disable(), wakes the device to D0 before reset, so we
> >>> can't be doing this only to get the device into D0.  The function lev=
el
> >>> resets do the same.
> >>>
> >>> Actually, now I'm remembering and debugging where I got myself confus=
ed
> >>> previously with pci_pm_reset().  The scenario was a Windows guest with
> >>> an assigned Intel 82574L NIC.  When doing a shutdown from the guest t=
he
> >>> device is placed in D3hot and we enter vfio_pci_core_disable() in that
> >>> state.  That function however uses __pci_reset_function_locked(), whi=
ch
> >>> skips the pci_dev_save_and_disable() since much of it is redundant for
> >>> that call path (I think I generalized this to all flavors of
> >>> pci_reset_function() in my head). =20
> >>
> >>  Thanks for providing the background related with the original issue.
> >> =20
> >>>
> >>> The standard call to pci_try_reset_function(), as in the previous
> >>> chunk, will make use of pci_dev_save_and_disable(), so for either of
> >>> these latter cases the concern cannot be simply having the device in =
D0,
> >>> we need a reason that we want the previously saved state restored on =
the
> >>> device before the reset, and thus restored to the device after the
> >>> reset as the rationale for the change.
> >>> =20
> >>
> >>  I will add this as a comment.
> >> =20
> >>>> +     list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_l=
ist)
> >>>> +             vfio_pci_set_power_state(cur, PCI_D0);
> >>>> +
> >>>>       ret =3D pci_reset_bus(pdev);
> >>>>
> >>>>  err_undo: =20
> >>>
> >>>
> >>> We also call pci_reset_bus() in vfio_pci_dev_set_try_reset().  In that
> >>> case, none of the other devices can be in use by the user, but they c=
an
> >>> certainly be in D3hot with previous device state saved off into our
> >>> pm_save cache.  If we don't have a good reason to restore in that cas=
e,
> >>> I'm wondering if we really have a good reason to restore in the above
> >>> two cases.
> >>>
> >>> Perhaps we just need the first chunk above to resolve the memory leak=
, =20
> >>
> >>  First chunk means only the changes done in vfio_pci_set_power_state()
> >>  which is calling kfree() before calling pci_store_saved_state().
> >>  Or I need to include more things in the first patch ? =20
> >=20
> > Correct, first chunk as is the first change in the patch.  Patch chunks
> > are delineated by the @@ offset lines.
> >  =20
>=20
>  Thanks for confirming this.
>=20
> >>
> >>  With the kfree(), the original memory leak issue should be solved.
> >> =20
> >>> and the second chunk as a separate patch to resolve the issue with
> >>> devices entering vfio_pci_core_disable() in non-D0 state.  Sorry if I=
 =20
> >>
> >>  And this second patch will contain rest of the things where
> >>  we will call vfio_pci_set_power_state() explicitly for moving to
> >>  D0 state ? =20
> >=20
> > At least the first one in vfio_pci_core_disable(), the others need
> > justification.
> >  =20
>=20
>  Yes. First one is needed.
>=20
> >>  Also, We need to explore if setting to D0 state is really required at
> >>  all these places and If it is not required, then we don't need second
> >>  patch ? =20
> >=20
> > We need a second patch, I'm convinced that we don't otherwise wake the
> > device to D0 before we potentially get to pci_pm_reset() in
> > vfio_pci_core_disable().  It's the remaining cases of setting D0 that
> > I'm less clear on.  If it's the case that we need to restore config
> > space any time a NoSoftRst- device is woken from D3hot and the state
> > saved and restored around the reset is meaningless otherwise, that's a
> > valid justification, but is it accurate?  If so, we should recheck the
> > other case of calling pci_reset_bus() too.  Thanks,
> >=20
> > Alex
> >  =20
>=20
>  I was analyzing this part in detail and added some debug prints and
>  made user space program to understand it better. Also, I have gone
>  through the patch 51ef3a004b1e (=E2=80=9Cvfio/pci: Restore device state =
on
>  PM transition=E2=80=9D).=20
>=20
>  We have 2 cases here:
>=20
>  1. The devices which has NoSoftRst+  (needs_pm_restore is false).
>     This case should work fine for all the cases (Apart from vfio_pci_cor=
e_disable())
>     without waking-up the device explicitly.
>=20
>  2. The devices which has NoSoftRst- (needs_pm_restore is true).=20
>=20
>  For case 2, let=E2=80=99s consider following example:
>=20
>  a. The device is in D3hot.=20
>  b. User made VFIO_DEVICE_RESET ioctl.
>  c. pci_try_reset_function() will be called which internally
>     invokes pci_dev_save_and_disable().
>  d. pci_set_power_state(dev, PCI_D0) will be called first.
>  e. pci_save_state() will happen then.
>=20
>  Now, for the devices which has NoSoftRst-,
>  the pci_set_power_state() should trigger soft reset and
>  we may lose the original state at step (d) and this state
>  cannot be restored.
>=20
>  For example, lets assume the case, where SBIOS or host
>  linux kernel (In the aspm.c) enables PCIe LTR setting for the
>  PCIe device. When this soft reset will be triggered, then this
>  LTR setting may be reset, and the device state saved at step (e)
>  will also have this setting cleared so it cannot be restored.
>  Same thing can be happened for other PCIe capabilities. Since the
>  vfio driver only exposes limited enhanced capabilities to its user
>  So, the vfio-driver user also won=E2=80=99t have option to save and
>  restore these capabilities state and these original
>  settings will be permanently lost.=20

Yes, this is my concern, thanks for confirming.

>  So, it seems we need to always move the device explicitly to
>  D0 state by calling vfio_pci_set_power_state() before
>  any reset for the reset triggered by IOCTLs. This is mainly to
>  preserve the state around soft reset.

The other option would be to test for vdev->pm_save and if found do a
load-and-free + restore-state after reset.  For simplicity, I'd tend to
favor your approach to wake the device with vfio_pci_set_power_state()
before reset.  Either approach seems roughly equal to me.

>  For vfio_pci_dev_set_try_reset() also, we can have the above
>  mentioned situation. The other functions/devices can be in D3hot
>  state and the D0 transition can cause soft reset there also.
>  For example, in my case, NVIDIA GPU has VGA (func 0) and audio
>  (func 1) function. I added debug print to dump the current state
>  before and after pci_reset_bus(). Before pci_reset_bus() the func 1
>  state was D3hot and after pci_reset_bus() the func 1 state got
>  changed to D0. This pci_reset_bus() was called during closing of
>  func 0 device so there are chances of soft reset for other=20
>  function/devices.

Ok, so we'll always wakeup devices for both the pci_reset_function()
class of resets and bus resets.  This seems to logically fit with the
fix to wakeup the device on release, so shall we do patch 1 of the
fixes series includes the kfree only and patch 2 resolves all the cases
of waking devices before reset?  Thanks,

Alex

