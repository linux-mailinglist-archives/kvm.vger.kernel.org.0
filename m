Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2950B4DB811
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 19:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353818AbiCPSpX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 14:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240663AbiCPSpW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 14:45:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B0024340E2
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 11:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647456245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fso1MxLUHOC8Hn/1Z1loysw7OKInWEYJXLEHyRkpDrQ=;
        b=BOeXomZ0+cCUFM3dhNTGt1+C5Bx63RFoDs6KduuVcgOLbjio7hU0jRcNPMFjtKyWr7dRJb
        LUJO2zjWPMPSlL3FzIQ1r77Ut1cOzd0uoeoKdiyf3Vx1MxjCn1NnSD73yTBrVTd8/8RZ+X
        HqHU/RzDUR2h/GD0j1/8xyiFm1i5gK4=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-258-67501hemM2arGvLFhNyz0w-1; Wed, 16 Mar 2022 14:44:04 -0400
X-MC-Unique: 67501hemM2arGvLFhNyz0w-1
Received: by mail-io1-f70.google.com with SMTP id w25-20020a6bd619000000b00640ddd0ad11so1834438ioa.2
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 11:44:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Fso1MxLUHOC8Hn/1Z1loysw7OKInWEYJXLEHyRkpDrQ=;
        b=hBq9habk9k3apSKYxKOyAYLCuCfZdsi4m7nvOxB/Kam3GyLrG2qCHoOx9Sbj9a2owx
         TgGi5PEcUiHOgVoMuPBNJOQhgnwme9BhDr0sfSFT2irOqE9UykoR0/SULnpSd/VlsLI7
         YSi+sO5STNyTkFnUWUe6V3hFDVHWAr/qIv2qRnrQbkcwYydtgFOJJY1sFOQPNdS0dKIw
         YQVdzk4ik/06mvVPOyGprJNFk6GJK0qGYEGEtOgkggHCiuQZP2WgRmYE/w2LY7MzNOxM
         JP6DYQD+7wZqrHnRMXVw34XIiFdI1SMBankxxr8L0t3m2maDaB7YHA8PV97jT0Df4eYa
         01tA==
X-Gm-Message-State: AOAM530PZc6CcwTBvNXxkHC3NFf57sgOCynD2uB+nlc6VUlAx3Zv4zxs
        5c6Jsa5qZDIwlZVvwEhSuPk9NQQLl/5jecU3MbPX2ve9Bj82o732wTe7CoLW3FY+Qmg1xORAk3g
        WLEYjG93mNRFB
X-Received: by 2002:a05:6e02:188d:b0:2c6:70cd:2d66 with SMTP id o13-20020a056e02188d00b002c670cd2d66mr447935ilu.36.1647456242973;
        Wed, 16 Mar 2022 11:44:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbY9xq06Shy/Eh04qeYw/8i1beUctYGpzX4aGs1pc0KVwqz200Lbm257OGsOgYvLpby9ElNw==
X-Received: by 2002:a05:6e02:188d:b0:2c6:70cd:2d66 with SMTP id o13-20020a056e02188d00b002c670cd2d66mr447922ilu.36.1647456242517;
        Wed, 16 Mar 2022 11:44:02 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w6-20020a056e021c8600b002c602537ab9sm1514472ill.54.2022.03.16.11.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 11:44:02 -0700 (PDT)
Date:   Wed, 16 Mar 2022 12:44:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 5/5] vfio/pci: add the support for PCI D3cold
 state
Message-ID: <20220316124401.5e1d5554.alex.williamson@redhat.com>
In-Reply-To: <02691b8d-1aa7-e6a3-f179-8793410e7263@nvidia.com>
References: <20220124181726.19174-1-abhsahu@nvidia.com>
        <20220124181726.19174-6-abhsahu@nvidia.com>
        <20220309102642.251aff25.alex.williamson@redhat.com>
        <a6c73b9e-577b-4a18-63a2-79f0b3fa1185@nvidia.com>
        <20220311160627.6ec569a9.alex.williamson@redhat.com>
        <02691b8d-1aa7-e6a3-f179-8793410e7263@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Mar 2022 11:11:04 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> On 3/12/2022 4:36 AM, Alex Williamson wrote:
> > On Fri, 11 Mar 2022 21:15:38 +0530
> > Abhishek Sahu <abhsahu@nvidia.com> wrote:
> >  =20
> >> On 3/9/2022 10:56 PM, Alex Williamson wrote: =20
> >>> On Mon, 24 Jan 2022 23:47:26 +0530
> >>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
...
> >>>> +             struct vfio_power_management vfio_pm;
> >>>> +             struct pci_dev *pdev =3D vdev->pdev;
> >>>> +             bool request_idle =3D false, request_resume =3D false;
> >>>> +             int ret =3D 0;
> >>>> +
> >>>> +             if (copy_from_user(&vfio_pm, (void __user *)arg, sizeo=
f(vfio_pm)))
> >>>> +                     return -EFAULT;
> >>>> +
> >>>> +             /*
> >>>> +              * The vdev power related fields are protected with me=
mory_lock
> >>>> +              * semaphore.
> >>>> +              */
> >>>> +             down_write(&vdev->memory_lock);
> >>>> +             switch (vfio_pm.d3cold_state) {
> >>>> +             case VFIO_DEVICE_D3COLD_STATE_ENTER:
> >>>> +                     /*
> >>>> +                      * For D3cold, the device should already in D3=
hot
> >>>> +                      * state.
> >>>> +                      */
> >>>> +                     if (vdev->power_state < PCI_D3hot) {
> >>>> +                             ret =3D EINVAL;
> >>>> +                             break;
> >>>> +                     }
> >>>> +
> >>>> +                     if (!vdev->runtime_suspend_pending) {
> >>>> +                             vdev->runtime_suspend_pending =3D true;
> >>>> +                             pm_runtime_put_noidle(&pdev->dev);
> >>>> +                             request_idle =3D true;
> >>>> +                     } =20
> >>>
> >>> If I call this multiple times, runtime_suspend_pending prevents it fr=
om
> >>> doing anything, but what should the return value be in that case?  Sa=
me
> >>> question for exit.
> >>> =20
> >>
> >>  For entry, the user should not call moving the device to D3cold, if i=
t has
> >>  already requested. So, we can return error in this case. For exit,
> >>  currently, in this patch, I am clearing runtime_suspend_pending if the
> >>  wake-up is triggered from the host side (with lspci or some other com=
mand).
> >>  In that case, the exit should not return error. Should we add code to
> >>  detect multiple calling of these and ensure only one
> >>  VFIO_DEVICE_D3COLD_STATE_ENTER/VFIO_DEVICE_D3COLD_STATE_EXIT can be c=
alled. =20
> >=20
> > AIUI, the argument is that we can't re-enter d3cold w/o guest driver
> > support, so if an lspci which was unknown to have occurred by the
> > device user were to wake the device, it seems the user would see
> > arbitrarily different results attempting to put the device to sleep
> > again.
> >  =20
>=20
>  Sorry. I still didn't get this point.
>=20
>  For guest to go into D3cold, it will follow 2 steps
>=20
>  1. Move the device from D0 to D3hot state by using config register.
>  2. Then use this IOCTL to move D3hot state to D3cold state.
>=20
> Now, on the guest side if we run lspci, then following will be behavior:
>=20
>  1. If we call it before step 2, then the config space register
>     can still be read in D3hot.
>  2. If we call it after step 2, then the guest os should move the
>     device into D0 first, read the config space and then again,
>     the guest os should move the device to D3cold with the
>     above steps. In this process, the guest OS driver will be involved.
>     This is current behavior with Linux guest OS.=20
>=20
>  Now, on the host side, if we run lspci,
>=20
>  1. If we call it before step 2, then the config space register can
>     still be read in D3hot.
>  2. If we call after step 2, then the D3cold to D0 will happen in
>     the runtime resume and then it will be in D0 state. But if we
>     add support to allow re-entering into D3cold again as I mentioned
>     below. then it will again go into D3cold state.=20

I was speculating about the latter scenario mechanics.  If the user has
already called STATE_ENTER for d3cold, should a subsequent STATE_ENTER
for d3cold generate an error?  Likewise should STATE_EXIT generate an
error if the device was not previously placed in d3cold?  But then any
host access that triggers vfio_pci_core_runtime_resume() is effective
the same as a STATE_EXIT, which may be unknown to the user.  So if we
had decided to generate errors on duplicate STATE_ENTER/EXIT calls, the
user's state model is broken by the arbitrary host activity and either
way the device is no longer in the user requested state and the user
receives no notification of this.

...
> >>>> +long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned in=
t cmd,
> >>>> +                      unsigned long arg)
> >>>> +{
> >>>> +#ifdef CONFIG_PM
> >>>> +     struct vfio_pci_core_device *vdev =3D
> >>>> +             container_of(core_vdev, struct vfio_pci_core_device, v=
dev);
> >>>> +     struct device *dev =3D &vdev->pdev->dev;
> >>>> +     bool skip_runtime_resume =3D false;
> >>>> +     long ret;
> >>>> +
> >>>> +     /*
> >>>> +      * The list of commands which are safe to execute when the PCI=
 device
> >>>> +      * is in D3cold state. In D3cold state, the PCI config or any =
other IO
> >>>> +      * access won't work.
> >>>> +      */
> >>>> +     switch (cmd) {
> >>>> +     case VFIO_DEVICE_POWER_MANAGEMENT:
> >>>> +     case VFIO_DEVICE_GET_INFO:
> >>>> +     case VFIO_DEVICE_FEATURE:
> >>>> +             skip_runtime_resume =3D true;
> >>>> +             break; =20
> >>>
> >>> How can we know that there won't be DEVICE_FEATURE calls that touch t=
he
> >>> device, the recently added migration via DEVICE_FEATURE does already.
> >>> DEVICE_GET_INFO seems equally as prone to breaking via capabilities
> >>> that could touch the device.  It seems easier to maintain and more
> >>> consistent to the user interface if we simply define that any device
> >>> access will resume the device. =20
> >>
> >>  In that case, we can resume the device for all case without
> >>  maintaining the safe list.
> >> =20
> >>> We need to do something about interrupts though. > Maybe we could err=
or the user ioctl to set d3cold
> >>> for devices running in INTx mode, but we also have numerous ways that
> >>> the device could be resumed under the user, which might start
> >>> triggering MSI/X interrupts?
> >>> =20
> >>
> >>  All the resuming we are mainly to prevent any malicious sequence.
> >>  If we see from normal OS side, then once the guest kernel has moved
> >>  the device into D3cold, then it should not do any config space
> >>  access. Similarly, from hypervisor, it should not invoke any
> >>  ioctl other than moving the device into D0 again when the device
> >>  is in D3cold. But, preventing the device to go into D3cold when
> >>  any other ioctl or config space access is happening is not easy,
> >>  so incrementing usage count before these access will ensure that
> >>  the device won't go into D3cold.
> >>
> >>  For interrupts, can the interrupt happen (Both INTx and MSI/x)
> >>  if the device is in D3cold? =20
> >=20
> > The device itself shouldn't be generating interrupts and we don't share
> > MSI interrupts between devices (afaik), but we do share INTx interrupts.
> >  =20
> >>  In D3cold, the PME events are possible
> >>  and these events will anyway resume the device first. If the
> >>  interrupts are not possible then can we disable all the interrupts
> >>  somehow before going calling runtime PM API's to move the device into=
 D3cold
> >>  and enable it again during runtime resume. We can wait for all existi=
ng
> >>  Interrupt to be finished first. I am not sure if this is possible. =20
> >=20
> > In the case of shared INTx, it's not just inflight interrupts.
> > Personally I wouldn't have an issue if we increment the usage counter
> > when INTx is in use to simply avoid the issue, but does that invalidate
> > the use case you're trying to enable? =20
>=20
>  It should not invalidate the use case which I am trying to support.
>=20
>  But incrementing the usage count for device already in D3cold
>  state will cause it to wake-up. Wake-up from D3cold may take
>  somewhere around 500 ms =E2=80=93 1500 ms (or sometimes more than that s=
ince
>  it depends upon root port wake-up time). So, it will make the
>  ISR time high. For the root port wake-up time, please refer
>=20
>  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commi=
t/?id=3Dad9001f2f41198784b0423646450ba2cb24793a3
>=20
>  where it can take 1100ms alone for the port port on
>  older platforms.=20


Configuring interrupts on the device requires it to be in D0, there's
no case I can imagine where we're incrementing the usage counter for
the purpose of setting INTx where the device is not already in D0.  I'm
certainly not suggesting incrementing the usage counter from within the
interrupt handler.


> > Otherwise I think we'd need to
> > remove and re-add the handler around d3cold.
> >  =20
> >>  Returning error for user ioctl to set d3cold while interrupts are
> >>  happening needs some synchronization at both interrupt handler and
> >>  ioctl code and using runtime resume inside interrupt handler
> >>  may not be safe. =20
> >=20
> > It's not a race condition to synchronize, it's simply that a shared
> > INTX interrupt can occur any time and we need to make sure we don't
> > touch the device when that occurs, either by preventing d3cold and INTx
> > in combination, removing the handler, or maybe adding a test in the
> > handler to not touch the device - either of the latter we need to be
> > sure we're not risking introducing interrupts storms by being out of
> > sync with the device state.
> >  =20
>=20
>  Adding a test to detect the D3cold seems to be better option in
>  this case but not sure about interrupts storms.

This seems to be another case where the device power state being out of
sync from the user is troublesome.  For instance, if an arbitrary host
access to the device wakes it to D0, it could theoretically trigger
device interrupts.  Is a guest prepared to handle interrupts from a
device that it's put in D3cold and not known to have been waked?

...
> >>>> @@ -2219,11 +2341,61 @@ static void vfio_pci_dev_set_try_reset(struc=
t vfio_device_set *dev_set)
> >>>>  #ifdef CONFIG_PM
> >>>>  static int vfio_pci_core_runtime_suspend(struct device *dev)
> >>>>  {
> >>>> +     struct pci_dev *pdev =3D to_pci_dev(dev);
> >>>> +     struct vfio_pci_core_device *vdev =3D dev_get_drvdata(dev);
> >>>> +
> >>>> +     down_read(&vdev->memory_lock);
> >>>> +
> >>>> +     /*
> >>>> +      * runtime_suspend_pending won't be set if there is no user of=
 vfio pci
> >>>> +      * device. In that case, return early and PCI core will take c=
are of
> >>>> +      * putting the device in the low power state.
> >>>> +      */
> >>>> +     if (!vdev->runtime_suspend_pending) {
> >>>> +             up_read(&vdev->memory_lock);
> >>>> +             return 0;
> >>>> +     } =20
> >>>
> >>> Doesn't this also mean that idle, unused devices can at best sit in
> >>> d3hot rather than d3cold?
> >>> =20
> >>
> >>  Sorry. I didn't get this point.
> >>
> >>  For unused devices, the PCI core will move the device into D3cold dir=
ectly. =20
> >=20
> > Could you point out what path triggers that?  I inferred that this
> > function would be called any time the usage count allows transition to
> > d3cold and the above test would prevent the device entering d3cold
> > unless the user requested it.
> >  =20
>=20
>  For PCI runtime suspend, there are 2 options:
>=20
>  1. Don=E2=80=99t change the device power state from D0 in the driver
>     runtime suspend callback. In this case, pci_pm_runtime_suspend()
>     will handle all the things.
>=20
>     https://elixir.bootlin.com/linux/v5.17-rc8/source/drivers/pci/pci-dri=
ver.c#L1285
>    =20
>     For unused device, runtime_suspend_pending will be false since
>     it can be set by d3cold ioctl.

So our runtime_suspend callback is not gating putting the device into
d3cold, we effectively do the same thing either way, it's only
protected by the memory_lock in the case that the user has requested
it.  Using runtime_suspend_pending here seems a bit misleading since
theoretically we'd want to hold memory_lock in any case of getting to
th runtime_suspend callback while the device is opened.

>  2. With the used device, the device state will be changed to D3hot first
>     with vfio_pm_config_write(). In this case, the pci_pm_runtime_suspend=
()
>     expects that all the handling has already been done by driver,
>     otherwise it will print the warning and return early.
>=20
>     =E2=80=9CPCI PM: State of device not saved by %pS=E2=80=9D
>=20
>     https://elixir.bootlin.com/linux/v5.17-rc8/source/drivers/pci/pci-dri=
ver.c#L1280
>=20
> >>  For the used devices, the config space write is happening first before
> >>  this ioctl is called and the config space write is moving the device
> >>  into D3hot so we need to do some manual thing here. =20
> >=20
> > Why is it that a user owned device cannot re-enter d3cold without
> > driver support, but and idle device does?  Simply because we expect to
> > reset the device before returning it back to the host or exposing it to
> > a user?  I'd expect that after d3cold->d0 we're essentially at a
> > power-on state, which ideally would be similar to a post-reset state,
> > so I don't follow how driver support factors in to re-entering d3cold.
> >  =20
>=20
>  In terms of nvidia GPU, the idle unused device is equivalent to
>  uninitialized PCI device. In this case, no internal HW modules
>  will be initialized like video memory. So, it does not matter
>  what we do with the device before that. It is fine to re-enter
>  d3cold since the HW itself is not initialized. Once the device
>  is owned by user, then in the guest OS side the nvidia driver will run
>  and initialize all the HW modules including video memory. Now,
>  before removing the power, we need to make sure that video
>  memory should come in the same state after resume as before
>  suspending.=20
>=20
>  If we don=E2=80=99t keep the video memory in self refresh state, then it=
 is
>  equivalent to power on state. But if we keep the video memory
>  in self refresh state, then it is different from power-on state.
>=20
> >>>> +
> >>>> +     /*
> >>>> +      * The runtime suspend will be called only if device is alread=
y at
> >>>> +      * D3hot state. Now, change the device state from D3hot to D3c=
old by
> >>>> +      * using platform power management. If setting of D3cold is not
> >>>> +      * supported for the PCI device, then the device state will st=
ill be
> >>>> +      * in D3hot state. The PCI core expects to save the PCI state,=
 if
> >>>> +      * driver runtime routine handles the power state management.
> >>>> +      */
> >>>> +     pci_save_state(pdev);
> >>>> +     pci_platform_power_transition(pdev, PCI_D3cold);
> >>>> +     up_read(&vdev->memory_lock);
> >>>> +
> >>>>       return 0;
> >>>>  }
> >>>>
> >>>>  static int vfio_pci_core_runtime_resume(struct device *dev)
> >>>>  {
> >>>> +     struct pci_dev *pdev =3D to_pci_dev(dev);
> >>>> +     struct vfio_pci_core_device *vdev =3D dev_get_drvdata(dev);
> >>>> +
> >>>> +     down_write(&vdev->memory_lock);
> >>>> +
> >>>> +     /*
> >>>> +      * The PCI core will move the device to D0 state before callin=
g the
> >>>> +      * driver runtime resume.
> >>>> +      */
> >>>> +     vfio_pci_set_power_state_locked(vdev, PCI_D0); =20
> >>>
> >>> Maybe this is where vdev->power_state is kept synchronized?
> >>> =20
> >>
> >>  Yes. vdev->power_state will be changed here.
> >> =20
> >>>> +
> >>>> +     /*
> >>>> +      * Some PCI device needs the SW involvement before going to D3=
cold
> >>>> +      * state again. So if there is any wake-up which is not trigge=
red
> >>>> +      * by the guest, then increase the usage count to prevent the
> >>>> +      * second runtime suspend.
> >>>> +      */ =20
> >>>
> >>> Can you give examples of devices that need this and the reason they
> >>> need this?  The interface is not terribly deterministic if a random
> >>> unprivileged lspci on the host can move devices back to d3hot. =20
> >>
> >>  I am not sure about other device but this is happening for
> >>  the nvidia GPU itself.
> >>
> >>  For nvidia GPU, during runtime suspend, we keep the GPU video memory
> >>  in self-refresh mode for high video memory usage. Each video memory
> >>  self refesh entry before D3cold requires nvidia SW involvement.
> >>  Without SW self-refresh sequnece involvement, it won't work. =20
> >=20
> >=20
> > So we're exposing acpi power interfaces to turn a device off, which
> > don't really turn the device off, but leaves it in some sort of
> > low-power memory refresh state, rather than a fully off state as I had
> > assumed above.  Does this suggest the host firmware ACPI has knowledge
> > of the device and does different things?
> >  =20
>=20
>  I was trying to find the public document regarding this part and
>  it seems following Windows document can help in providing some
>  information related with this
>=20
>  https://docs.microsoft.com/en-us/windows-hardware/drivers/bringup/firmwa=
re-requirements-for-d3cold
>=20
>  =E2=80=9CPutting a device in D3cold does not necessarily mean that all
>   sources of power to the device have been removed=E2=80=94it means only
>   that the main power source, Vcc, is removed. The auxiliary power
>   source, Vaux, might also be removed if it is not required for
>   the wake logic=E2=80=9D.
> =20
>  So, for generic self-refresh D3cold (means in Desktop), it is mainly
>  relying on auxiliary power. For notebooks, we ask to do some
>  customization in acpi power interfaces side to support
>  video memory self-refresh.=20

And that customization must rely on some aspect of the GPU state,
right?  We send the GPU to d3cold the first time and we get this memory
self-refresh behavior, but the claim here is that if we wake the device
to d0 and send it back to d3cold that video memory will be lost.  So
the variable here has something to do with the device state itself.
Therefore is there some device register that could be preserved and
restored around d3cold so that we could go back into the self-refresh
state?


> >>  Details regarding runtime suspend with self-refresh can be found in
> >>
> >>  https://download.nvidia.com/XFree86/Linux-x86_64/495.46/README/dynami=
cpowermanagement.html#VidMemThreshold
> >>
> >>  But, if GPU video memory usage is low, then we turnoff video memory
> >>  and save all the allocation in system memory. In this case, SW involv=
ement
> >>  is not required. =20
> >=20
> > Ok, so there's some heuristically determined vram usage where the
> > driver favors suspend latency versus power savings and somehow keeps
> > the device in this low-power, refresh state versus a fully off state.
> > How unique is this behavior to NVIDIA devices?  It seems like we're
> > trying to add d3cold, but special case it based on a device that might
> > have a rather quirky d3cold behavior.  Is there something we can test
> > about the state of the device to know which mode it's using?  =20
>=20
>  Since vfio is generic driver so testing the device mode here
>  seems to be challenging.
> =20
> > Is there something we can virtualize on the device to force the driver =
to use
> > the higher latency, lower power d3cold mode that results in fewer
> > restrictions?  Or maybe this is just common practice?
> >  =20
>=20
>  Yes. We can enforce this. But this option won=E2=80=99t be useful for mo=
dern
>  use cases. Let=E2=80=99s assume if we have 16GB video memory usage, in t=
hat
>  case, it will take lot of time in entry and exit and make the feature
>  unusable. Also, the system memory will be limited in the guest
>  side so enough system memory is again challenge.=20

Good point, the potential extent of video memory is too excessive to
not support a self-refresh mode.

> >>> How useful is this implementation if a notice to the guest of a resum=
ed
> >>> device is TBD?  Thanks,
> >>>
> >>> Alex
> >>> =20
> >>
> >>  I have prototyped this earlier by using eventfd_ctx for pme and whene=
ver we get
> >>  a resume triggered by host, then it will forward the same to hypervis=
or.
> >>  Then in the hypervisor, it can write into virtual root port PME relat=
ed registers
> >>  and send PME event which will wake-up the PCI device in the guest sid=
e.
> >>  It will help in handling PME events related wake-up also which are cu=
rrently
> >>  disabled in PATCH 2 of this patch series. =20
> >=20
> > But then what does the guest do with the device?  For example, if we
> > have a VM with an assigned GPU running an idle desktop where the
> > monitor has gone into power save, does running lspci on the host
> > randomly wake the desktop and monitor? =20
>=20
>  For Linux OS + NVIDIA driver, it seems it will just wake-up the
>  GPU up and not the monitor. With the bare-metal setup, I waited
>  for monitor to go off with DPMS and then the GPU went into
>  suspended state. After that, If I run lspci command,
>  then the GPU moved to active state but monitor was
>  still in the off state and after lspci, the GPU went
>  into suspended state again.=20
>=20
>  The monitor is waking up only if I do keyborad or mouse
>  movement.

The monitor waking would clearly be a user visible sign that this
doesn't work according to plan, but we still have the fact that the GPU
is awake and consuming power, wasting battery on a mobile platform,
still seems like a symptom that this solution is incomplete.

> > I'd like to understand how
> > unique the return to d3cold behavior is to this device and whether we
> > can restrict that in some way.  An option that's now at our disposal
> > would be to create an NVIDIA GPU variant of vfio-pci that has
> > sufficient device knowledge to perhaps retrigger the vram refresh
> > d3cold state rather than lose vram data going into a standard d3cold
> > state.  Thanks,
> >=20
> > Alex
> >  =20
>=20
>  Adding vram refresh d3cold state with vfio-pci variant is not straight
>  forward without involvement of nvidia driver itself.=20
>=20
>  One option is to add one flag in D3cold IOCTL itself to differentiate
>  between 2 variants of D3cold entry (One which allows re-entering to
>  D3cold and another one which won=E2=80=99t allow re-entering to D3cold) =
and
>  set it default for re-entering to D3cold. For nvidia or similar use
>  case, the hypervisor can set this flag to prevent re-entering to D3cold.

QEMU doesn't know the hardware behavior either.
=20
>  Otherwise, we can add NVIDIA vendor ID check and restrict this
>  to nvidia alone.=20

Either of these solutions presumes there's a worthwhile use case
regardless of the fact that the GPU can be woken by arbitrary,
unprivileged actions on the host.  It seems that either we should be
able to put the device back into a low power state ourselves after such
an event or be able to trigger an eventfd to the user which is plumbed
through pme in the guest so that the guest can put the device back to
low power after such an event.  Getting the device into a transient low
power state that it can slip out of so easily doesn't seem like a
complete solution to me.  Thanks,

Alex

