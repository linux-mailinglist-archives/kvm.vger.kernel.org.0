Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED655703B0
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 14:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiGKM7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 08:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbiGKM6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 08:58:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2A8367599
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 05:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657544275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o5Nsw6JQqAFz7iPy3gn9GJSjCtE8dQQPM/HAEaey5x4=;
        b=bWCf7rU3vsMx1OLNGWpIiaBYD/KoeMlBpQbomQe/sJRX0kF0s8u1dVxJwszh6ZODrsTRYz
        us6KOUAW5kprNNlQgVbQwAormsx8CqnVETUAJkyIS9J2gUrCRB222Gwv3xNnbJ5YOpo28h
        eeCYIlRMMQCq+AF9Yppu1YswPoqlZHI=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-mzrdqCBqMHK5gPQvqMLJtQ-1; Mon, 11 Jul 2022 08:57:54 -0400
X-MC-Unique: mzrdqCBqMHK5gPQvqMLJtQ-1
Received: by mail-io1-f69.google.com with SMTP id 205-20020a6b14d6000000b0067b7b6b3c77so2613361iou.14
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 05:57:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=o5Nsw6JQqAFz7iPy3gn9GJSjCtE8dQQPM/HAEaey5x4=;
        b=bXmU+8DP5ELbviOqQ6gItZ3oaMsmOaiUmckaCg57RY5Y5NhQu41ppAYI3zgl2aeW8s
         07w+bJ+Qzvj3y5zn8ovRf/+mxTAWEgmrPKJMqYulx7VQ+dkhGVnwlbY+FeaapgSWgD+U
         LKEVJvTcD0/CsTeKsw8f24Q8b5MWB6xKhBOqhr3JXTnR+7oxhE8+s+42IuLpGUtzG9FW
         4dRde63vPE9OU8iHt6FUD1p46p6fxI5jXDIlfw2FJ53tKg2Vfj7sZpqmljb0EBhJJUUo
         rO1UV8AayBQE86Axo0epkanrFjMM/+djdXzKx3F5kaZeUmd00UHcCVIvvFnrW7EUnzy6
         L44w==
X-Gm-Message-State: AJIora86DMg51z8h/SGfTeEX2oAGRaggh+doDTvWC3YsVvkknOD5A16t
        R/PdvwYwpyoRyWOjBGrUKrlld69+U9M9gXJBpRpMP2MClN+CsTASeOJuQzaKjz0hzVBkAPC/GwD
        6wPCwNC4EbORp
X-Received: by 2002:a92:d342:0:b0:2dc:365b:28f2 with SMTP id a2-20020a92d342000000b002dc365b28f2mr9706507ilh.67.1657544273915;
        Mon, 11 Jul 2022 05:57:53 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vykKbfv8Khf64NN0lmMPSoXDbZrcv9tsbqYhk70TqkgEDeZ1eTfuZs3u8OS2iSy5LTVaChyA==
X-Received: by 2002:a92:d342:0:b0:2dc:365b:28f2 with SMTP id a2-20020a92d342000000b002dc365b28f2mr9706494ilh.67.1657544273607;
        Mon, 11 Jul 2022 05:57:53 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id d6-20020a92d5c6000000b002dc78ec7f2bsm1480601ilq.48.2022.07.11.05.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 05:57:53 -0700 (PDT)
Date:   Mon, 11 Jul 2022 06:57:51 -0600
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v4 1/6] vfio/pci: Mask INTx during runtime suspend
Message-ID: <20220711065751.4c082618.alex.williamson@redhat.com>
In-Reply-To: <31109e06-48f5-0a12-b310-e284a7b517db@nvidia.com>
References: <20220701110814.7310-1-abhsahu@nvidia.com>
        <20220701110814.7310-2-abhsahu@nvidia.com>
        <20220706093945.30d65ce6.alex.williamson@redhat.com>
        <3b143762-d6ce-ac70-59ae-a0c2e66ffc1b@nvidia.com>
        <20220708094508.49ba647f.alex.williamson@redhat.com>
        <31109e06-48f5-0a12-b310-e284a7b517db@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 11 Jul 2022 14:48:34 +0530
Abhishek Sahu <abhsahu@nvidia.com> wrote:

> On 7/8/2022 9:15 PM, Alex Williamson wrote:
> > On Fri, 8 Jul 2022 14:51:30 +0530
> > Abhishek Sahu <abhsahu@nvidia.com> wrote:
> >  =20
> >> On 7/6/2022 9:09 PM, Alex Williamson wrote: =20
> >>> On Fri, 1 Jul 2022 16:38:09 +0530
> >>> Abhishek Sahu <abhsahu@nvidia.com> wrote:
> >>>    =20
> >>>> This patch adds INTx handling during runtime suspend/resume.
> >>>> All the suspend/resume related code for the user to put the device
> >>>> into the low power state will be added in subsequent patches.
> >>>>
> >>>> The INTx are shared among devices. Whenever any INTx interrupt comes=
   =20
> >>>
> >>> "The INTx lines may be shared..."
> >>>    =20
> >>>> for the VFIO devices, then vfio_intx_handler() will be called for ea=
ch
> >>>> device. Inside vfio_intx_handler(), it calls pci_check_and_mask_intx=
()   =20
> >>>
> >>> "...device sharing the interrupt."
> >>>    =20
> >>>> and checks if the interrupt has been generated for the current devic=
e.
> >>>> Now, if the device is already in the D3cold state, then the config s=
pace
> >>>> can not be read. Attempt to read config space in D3cold state can
> >>>> cause system unresponsiveness in a few systems. To prevent this, mask
> >>>> INTx in runtime suspend callback and unmask the same in runtime resu=
me
> >>>> callback. If INTx has been already masked, then no handling is needed
> >>>> in runtime suspend/resume callbacks. 'pm_intx_masked' tracks this, a=
nd
> >>>> vfio_pci_intx_mask() has been updated to return true if INTx has been
> >>>> masked inside this function.
> >>>>
> >>>> For the runtime suspend which is triggered for the no user of VFIO
> >>>> device, the is_intx() will return false and these callbacks won't do
> >>>> anything.
> >>>>
> >>>> The MSI/MSI-X are not shared so similar handling should not be
> >>>> needed for MSI/MSI-X. vfio_msihandler() triggers eventfd_signal()
> >>>> without doing any device-specific config access. When the user perfo=
rms
> >>>> any config access or IOCTL after receiving the eventfd notification,
> >>>> then the device will be moved to the D0 state first before
> >>>> servicing any request.
> >>>>
> >>>> Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
> >>>> ---
> >>>>  drivers/vfio/pci/vfio_pci_core.c  | 37 +++++++++++++++++++++++++++-=
---
> >>>>  drivers/vfio/pci/vfio_pci_intrs.c |  6 ++++-
> >>>>  include/linux/vfio_pci_core.h     |  3 ++-
> >>>>  3 files changed, 40 insertions(+), 6 deletions(-)
> >>>>
> >>>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfi=
o_pci_core.c
> >>>> index a0d69ddaf90d..5948d930449b 100644
> >>>> --- a/drivers/vfio/pci/vfio_pci_core.c
> >>>> +++ b/drivers/vfio/pci/vfio_pci_core.c
> >>>> @@ -259,16 +259,45 @@ int vfio_pci_set_power_state(struct vfio_pci_c=
ore_device *vdev, pci_power_t stat
> >>>>  	return ret;
> >>>>  }
> >>>> =20
> >>>> +#ifdef CONFIG_PM
> >>>> +static int vfio_pci_core_runtime_suspend(struct device *dev)
> >>>> +{
> >>>> +	struct vfio_pci_core_device *vdev =3D dev_get_drvdata(dev);
> >>>> +
> >>>> +	/*
> >>>> +	 * If INTx is enabled, then mask INTx before going into the runtime
> >>>> +	 * suspended state and unmask the same in the runtime resume.
> >>>> +	 * If INTx has already been masked by the user, then
> >>>> +	 * vfio_pci_intx_mask() will return false and in that case, INTx
> >>>> +	 * should not be unmasked in the runtime resume.
> >>>> +	 */
> >>>> +	vdev->pm_intx_masked =3D (is_intx(vdev) && vfio_pci_intx_mask(vdev=
));
> >>>> +
> >>>> +	return 0;
> >>>> +}
> >>>> +
> >>>> +static int vfio_pci_core_runtime_resume(struct device *dev)
> >>>> +{
> >>>> +	struct vfio_pci_core_device *vdev =3D dev_get_drvdata(dev);
> >>>> +
> >>>> +	if (vdev->pm_intx_masked)
> >>>> +		vfio_pci_intx_unmask(vdev);
> >>>> +
> >>>> +	return 0;
> >>>> +}
> >>>> +#endif /* CONFIG_PM */
> >>>> +
> >>>>  /*
> >>>> - * The dev_pm_ops needs to be provided to make pci-driver runtime P=
M working,
> >>>> - * so use structure without any callbacks.
> >>>> - *
> >>>>   * The pci-driver core runtime PM routines always save the device s=
tate
> >>>>   * before going into suspended state. If the device is going into l=
ow power
> >>>>   * state with only with runtime PM ops, then no explicit handling i=
s needed
> >>>>   * for the devices which have NoSoftRst-.
> >>>>   */
> >>>> -static const struct dev_pm_ops vfio_pci_core_pm_ops =3D { };
> >>>> +static const struct dev_pm_ops vfio_pci_core_pm_ops =3D {
> >>>> +	SET_RUNTIME_PM_OPS(vfio_pci_core_runtime_suspend,
> >>>> +			   vfio_pci_core_runtime_resume,
> >>>> +			   NULL)
> >>>> +};
> >>>> =20
> >>>>  int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
> >>>>  {
> >>>> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vf=
io_pci_intrs.c
> >>>> index 6069a11fb51a..1a37db99df48 100644
> >>>> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> >>>> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> >>>> @@ -33,10 +33,12 @@ static void vfio_send_intx_eventfd(void *opaque,=
 void *unused)
> >>>>  		eventfd_signal(vdev->ctx[0].trigger, 1);
> >>>>  }
> >>>> =20
> >>>> -void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
> >>>> +/* Returns true if INTx has been masked by this function. */
> >>>> +bool vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
> >>>>  {
> >>>>  	struct pci_dev *pdev =3D vdev->pdev;
> >>>>  	unsigned long flags;
> >>>> +	bool intx_masked =3D false;
> >>>> =20
> >>>>  	spin_lock_irqsave(&vdev->irqlock, flags);
> >>>> =20
> >>>> @@ -60,9 +62,11 @@ void vfio_pci_intx_mask(struct vfio_pci_core_devi=
ce *vdev)
> >>>>  			disable_irq_nosync(pdev->irq);
> >>>> =20
> >>>>  		vdev->ctx[0].masked =3D true;
> >>>> +		intx_masked =3D true;
> >>>>  	}
> >>>> =20
> >>>>  	spin_unlock_irqrestore(&vdev->irqlock, flags);
> >>>> +	return intx_masked;
> >>>>  }   =20
> >>>
> >>>
> >>> There's certainly another path through this function that masks the
> >>> interrupt, which makes the definition of this return value a bit
> >>> confusing.   =20
> >>
> >>  For our case we should not hit that path. But we can return the
> >>  intx_masked true from that path as well to align return value.
> >> =20
> >>> Wouldn't it be simpler not to overload the masked flag on
> >>> the interrupt context like this and instead set a new flag on the vdev
> >>> under irqlock to indicate the device is unable to generate interrupts.
> >>> The irq handler would add a test of this flag before any tests that
> >>> would access the device.  Thanks,
> >>>
> >>> Alex
> >>>     =20
> >>
> >>  We will set this flag inside runtime_suspend callback but the
> >>  device can be in non-D3cold state (For example, if user has
> >>  disabled d3cold explicitly by sysfs, the D3cold is not supported in
> >>  the platform, etc.). Also, in D3cold supported case, the device will
> >>  be in D0 till the PCI core moves the device into D3cold. In this case,
> >>  there is possibility that the device can generate an interrupt.
> >>  If we add check in the IRQ handler, then we won=E2=80=99t check and c=
lear
> >>  the IRQ status, but the interrupt line will still be asserted
> >>  which can cause interrupt flooding.
> >>
> >>  This was the reason for disabling interrupt itself instead of
> >>  checking flag in the IRQ handler. =20
> >=20
> > Ok, maybe this is largely a clarification of the return value of
> > vfio_pci_intx_mask().  I think what you're looking for is whether the
> > context mask was changed, rather than whether the interrupt is masked,
> > which I think avoids the confusion regarding whether the first branch
> > should return true or false.  So the variable should be something like
> > "masked_changed" and the comment changed to "Returns true if the INTx
> > vfio_pci_irq_ctx.masked value is changed".
> >  =20
>=20
>  Thanks Alex.
>  I will rename the variable and update the comment.
>=20
> > Testing is_intx() outside of the irqlock is potentially racy, so do we
> > need to add the pm-get/put wrappers on ioctls first to avoid the
> > possibility that pm-suspend can race a SET_IRQS ioctl?  Thanks,
> >=20
> > Alex
> >  =20
> =20
>  Even after adding this patch, the runtime suspend will not be supported
>  for the device with users. It will be supported only after patch 4 in
>  this patch series. So with this patch, the pm-suspend can be called only
>  for the cases where vfio device has no user and there we should not see
>  the race condition.

We should also not see is_intx() true for unused devices.  Thanks,

Alex

