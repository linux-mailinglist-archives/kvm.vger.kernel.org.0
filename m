Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85EF96D83A0
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 18:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbjDEQ0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 12:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbjDEQ0h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 12:26:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5069EE64
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 09:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680711950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X4+7nnzXcAT9Lcy2NEAc7Oy4ojychP/NJ1oPMxWfZgk=;
        b=NtefZDXYWRZRFZHLgV/a8UPEhYg5W5fQJpbyX36VI7jcEkTBZA0D3bRKBJnCqJItviMpzv
        fdEMhP1fBNOFL3EVa31VzAf2DuP060pzSTIhw0s0Q26diVGCD3O/X/VPrYru33Ik/rZQ42
        s7j7A7q0MoOUWVzGKYAitH3Ugbpmpws=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-XReQOMR1OLamErWn5ogsRw-1; Wed, 05 Apr 2023 12:25:49 -0400
X-MC-Unique: XReQOMR1OLamErWn5ogsRw-1
Received: by mail-il1-f197.google.com with SMTP id x5-20020a056e021ca500b00327f726c6c0so713173ill.9
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 09:25:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680711948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X4+7nnzXcAT9Lcy2NEAc7Oy4ojychP/NJ1oPMxWfZgk=;
        b=002PfZh0L4eeZt+BHaZegJMGYoLZ7/K62SywoQX2Bd3IlhQ2FrNa7PluWBvRs+c3WV
         PJ3phaqEfpKMJf6sy2ifpmWAD71lMfuPKJaYDznEnE0amZArcZNlgL1i4oBrEOOJr8rU
         hCNVVVk6vK0yB8df9LP0xi/KDDIt9R4PZ82bi5E/bpVA4oYUqRAa7ZaPXkUVRIasUx+g
         oKhsWE+JXpX0q8q9Maa+zzN4FCNQOEabNXgxOIov2rzBw/FvsZM1nazu3zN+Wtm8fGsb
         p893EBmhCMzBreqLvicikUkBU8IqX/H7r+OtxvarG/Vwm74LcFAjUBAbQaAJgA9dJbFj
         PGxA==
X-Gm-Message-State: AAQBX9czQ6qRoWPMoAEVvW1L4RYnIvxwhH1SHis2lN5JlUiXHsenpyQ1
        Wkz+FByHWU4laOcQLOfHsdT7y9c8buGq45e5aUZ52nPf9mG9fri4mDwD6qCMoG4AbVPRX9gCz+e
        FNgpI8L8Fynd/
X-Received: by 2002:a5e:c64c:0:b0:759:a96e:1d00 with SMTP id s12-20020a5ec64c000000b00759a96e1d00mr4878199ioo.6.1680711948606;
        Wed, 05 Apr 2023 09:25:48 -0700 (PDT)
X-Google-Smtp-Source: AKy350ap9t/2WA2FI+KNtC7x4KXiBcgP56i9y3IyNpkKbLzahAQJ6d+5h+xwHnIb+sx5Zqd7qmAlGw==
X-Received: by 2002:a5e:c64c:0:b0:759:a96e:1d00 with SMTP id s12-20020a5ec64c000000b00759a96e1d00mr4878172ioo.6.1680711948192;
        Wed, 05 Apr 2023 09:25:48 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r22-20020a056638131600b0040b1ada219fsm4018655jad.26.2023.04.05.09.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 09:25:47 -0700 (PDT)
Date:   Wed, 5 Apr 2023 10:25:45 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <20230405102545.41a61424.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB7529D4E354C3B85D7698017DC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-13-yi.l.liu@intel.com>
        <a937e622-ce32-6dda-d77c-7d8d76474ee0@redhat.com>
        <DS0PR11MB7529D4E354C3B85D7698017DC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Apr 2023 14:04:51 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> Hi Eric,
>=20
> > From: Eric Auger <eric.auger@redhat.com>
> > Sent: Wednesday, April 5, 2023 8:20 PM
> >=20
> > Hi Yi,
> > On 4/1/23 16:44, Yi Liu wrote: =20
> > > for the users that accept device fds passed from management stacks to=
 be
> > > able to figure out the host reset affected devices among the devices
> > > opened by the user. This is needed as such users do not have BDF (bus,
> > > devfn) knowledge about the devices it has opened, hence unable to use
> > > the information reported by existing VFIO_DEVICE_GET_PCI_HOT_RESET_IN=
FO
> > > to figure out the affected devices.
> > >
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > >  drivers/vfio/pci/vfio_pci_core.c | 58 ++++++++++++++++++++++++++++--=
--
> > >  include/uapi/linux/vfio.h        | 24 ++++++++++++-
> > >  2 files changed, 74 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio=
_pci_core.c
> > > index 19f5b075d70a..a5a7e148dce1 100644
> > > --- a/drivers/vfio/pci/vfio_pci_core.c
> > > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > > @@ -30,6 +30,7 @@
> > >  #if IS_ENABLED(CONFIG_EEH)
> > >  #include <asm/eeh.h>
> > >  #endif
> > > +#include <uapi/linux/iommufd.h>
> > >
> > >  #include "vfio_pci_priv.h"
> > >
> > > @@ -767,6 +768,20 @@ static int vfio_pci_get_irq_count(struct =20
> > vfio_pci_core_device *vdev, int irq_typ =20
> > >  	return 0;
> > >  }
> > >
> > > +static struct vfio_device *
> > > +vfio_pci_find_device_in_devset(struct vfio_device_set *dev_set,
> > > +			       struct pci_dev *pdev)
> > > +{
> > > +	struct vfio_device *cur;
> > > +
> > > +	lockdep_assert_held(&dev_set->lock);
> > > +
> > > +	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
> > > +		if (cur->dev =3D=3D &pdev->dev)
> > > +			return cur;
> > > +	return NULL;
> > > +}
> > > +
> > >  static int vfio_pci_count_devs(struct pci_dev *pdev, void *data)
> > >  {
> > >  	(*(int *)data)++;
> > > @@ -776,13 +791,20 @@ static int vfio_pci_count_devs(struct pci_dev *=
pdev, void =20
> > *data) =20
> > >  struct vfio_pci_fill_info {
> > >  	int max;
> > >  	int cur;
> > > +	bool require_devid;
> > > +	struct iommufd_ctx *iommufd;
> > > +	struct vfio_device_set *dev_set;
> > >  	struct vfio_pci_dependent_device *devices;
> > >  };
> > >
> > >  static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
> > >  {
> > >  	struct vfio_pci_fill_info *fill =3D data;
> > > +	struct vfio_device_set *dev_set =3D fill->dev_set;
> > >  	struct iommu_group *iommu_group;
> > > +	struct vfio_device *vdev;
> > > +
> > > +	lockdep_assert_held(&dev_set->lock);
> > >
> > >  	if (fill->cur =3D=3D fill->max)
> > >  		return -EAGAIN; /* Something changed, try again */
> > > @@ -791,7 +813,21 @@ static int vfio_pci_fill_devs(struct pci_dev *pd=
ev, void =20
> > *data) =20
> > >  	if (!iommu_group)
> > >  		return -EPERM; /* Cannot reset non-isolated devices */
> > >
> > > -	fill->devices[fill->cur].group_id =3D iommu_group_id(iommu_group);
> > > +	if (fill->require_devid) {
> > > +		/*
> > > +		 * Report dev_id of the devices that are opened as cdev
> > > +		 * and have the same iommufd with the fill->iommufd.
> > > +		 * Otherwise, just fill IOMMUFD_INVALID_ID.
> > > +		 */
> > > +		vdev =3D vfio_pci_find_device_in_devset(dev_set, pdev);
> > > +		if (vdev && vfio_device_cdev_opened(vdev) &&
> > > +		    fill->iommufd =3D=3D vfio_iommufd_physical_ictx(vdev))
> > > +			vfio_iommufd_physical_devid(vdev, &fill->devices[fill-
> > >cur].dev_id);
> > > +		else
> > > +			fill->devices[fill->cur].dev_id =3D IOMMUFD_INVALID_ID;
> > > +	} else {
> > > +		fill->devices[fill->cur].group_id =3D iommu_group_id(iommu_group);
> > > +	}
> > >  	fill->devices[fill->cur].segment =3D pci_domain_nr(pdev->bus);
> > >  	fill->devices[fill->cur].bus =3D pdev->bus->number;
> > >  	fill->devices[fill->cur].devfn =3D pdev->devfn;
> > > @@ -1230,17 +1266,27 @@ static int vfio_pci_ioctl_get_pci_hot_reset_i=
nfo(
> > >  		return -ENOMEM;
> > >
> > >  	fill.devices =3D devices;
> > > +	fill.dev_set =3D vdev->vdev.dev_set;
> > >
> > > +	mutex_lock(&vdev->vdev.dev_set->lock);
> > > +	if (vfio_device_cdev_opened(&vdev->vdev)) {
> > > +		fill.require_devid =3D true;
> > > +		fill.iommufd =3D vfio_iommufd_physical_ictx(&vdev->vdev);
> > > +	}
> > >  	ret =3D vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_fill_dev=
s,
> > >  					    &fill, slot);
> > > +	mutex_unlock(&vdev->vdev.dev_set->lock);
> > >
> > >  	/*
> > >  	 * If a device was removed between counting and filling, we may com=
e up
> > >  	 * short of fill.max.  If a device was added, we'll have a return of
> > >  	 * -EAGAIN above.
> > >  	 */
> > > -	if (!ret)
> > > +	if (!ret) {
> > >  		hdr.count =3D fill.cur;
> > > +		if (fill.require_devid)
> > > +			hdr.flags =3D VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID;
> > > +	}
> > >
> > >  reset_info_exit:
> > >  	if (copy_to_user(arg, &hdr, minsz))
> > > @@ -2346,12 +2392,10 @@ static bool vfio_dev_in_files(struct =20
> > vfio_pci_core_device *vdev, =20
> > >  static int vfio_pci_is_device_in_set(struct pci_dev *pdev, void *dat=
a)
> > >  {
> > >  	struct vfio_device_set *dev_set =3D data;
> > > -	struct vfio_device *cur;
> > >
> > > -	list_for_each_entry(cur, &dev_set->device_list, dev_set_list)
> > > -		if (cur->dev =3D=3D &pdev->dev)
> > > -			return 0;
> > > -	return -EBUSY;
> > > +	lockdep_assert_held(&dev_set->lock);
> > > +
> > > +	return vfio_pci_find_device_in_devset(dev_set, pdev) ? 0 : -EBUSY;
> > >  }
> > >
> > >  /*
> > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > index 25432ef213ee..5a34364e3b94 100644
> > > --- a/include/uapi/linux/vfio.h
> > > +++ b/include/uapi/linux/vfio.h
> > > @@ -650,11 +650,32 @@ enum {
> > >   * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO - _IOWR(VFIO_TYPE, VFIO_BASE +=
 12,
> > >   *					      struct vfio_pci_hot_reset_info)
> > >   *
> > > + * This command is used to query the affected devices in the hot res=
et for
> > > + * a given device.  User could use the information reported by this =
command
> > > + * to figure out the affected devices among the devices it has opene=
d.
> > > + * This command always reports the segment, bus and devfn informatio=
n for
> > > + * each affected device, and selectively report the group_id or the =
dev_id
> > > + * per the way how the device being queried is opened.
> > > + *	- If the device is opened via the traditional group/container man=
ner,
> > > + *	  this command reports the group_id for each affected device.
> > > + *
> > > + *	- If the device is opened as a cdev, this command needs to report=
 =20
> > s/needs to report/reports =20
>=20
> got it.
>=20
> > > + *	  dev_id for each affected device and set the
> > > + *	  VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID flag.  For the affected
> > > + *	  devices that are not opened as cdev or bound to different iommu=
fds
> > > + *	  with the device that is queried, report an invalid dev_id to av=
oid =20
> > s/bound to different iommufds with the device that is queried/bound to
> > iommufds different from the reset device one? =20
>=20
> hmmm, I'm not a native speaker here. This _INFO is to query if want
> hot reset a given device, what devices would be affected. So it appears
> the queried device is better. But I'd admit "the queried device" is also
> "the reset device". may Alex help pick one. =F0=9F=98=8A

	- If the calling device is opened directly via cdev rather than
	  accessed through the vfio group, the returned
	  vfio_pci_depdendent_device structure reports the dev_id
	  rather than the group_id, which is indicated by the
	  VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID flag in
	  vfio_pci_hot_reset_info.  If the reset affects devices that
	  are not opened within the same iommufd context as the calling
	  device, IOMMUFD_INVALID_ID will be provided as the dev_id.

But that kind of brings to light the question of what does the user do
when they encounter this situation.  If the device is not opened, the
reset can complete.  If the device is opened by a different user, the
reset is blocked.  The only logical conclusion is that the user should
try the reset regardless of the result of the info ioctl, which the
null-array approach further solidifies as the direction of the API.
I'm not liking this.  Thanks,

Alex


> > > + *	  potential dev_id conflict as dev_id is local to iommufd.  For s=
uch
> > > + *	  affected devices, user shall fall back to use the segment, bus =
and
> > > + *	  devfn info to map it to opened device.
> > > + *
> > >   * Return: 0 on success, -errno on failure:
> > >   *	-enospc =3D insufficient buffer, -enodev =3D unsupported for devi=
ce.
> > >   */
> > >  struct vfio_pci_dependent_device {
> > > -	__u32	group_id;
> > > +	union {
> > > +		__u32   group_id;
> > > +		__u32	dev_id;
> > > +	};
> > >  	__u16	segment;
> > >  	__u8	bus;
> > >  	__u8	devfn; /* Use PCI_SLOT/PCI_FUNC */
> > > @@ -663,6 +684,7 @@ struct vfio_pci_dependent_device {
> > >  struct vfio_pci_hot_reset_info {
> > >  	__u32	argsz;
> > >  	__u32	flags;
> > > +#define VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID	(1 << 0)
> > >  	__u32	count;
> > >  	struct vfio_pci_dependent_device	devices[];
> > >  }; =20
> > Eric =20
>=20

