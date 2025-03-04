Return-Path: <kvm+bounces-39953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D50B6A4D1F3
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 04:13:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9CDF07A7669
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 03:12:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 596091DAC92;
	Tue,  4 Mar 2025 03:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bLUSA9tT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C9D33D8
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 03:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741057983; cv=none; b=ksPC8Pv+2Ie4kzT6x/g4XSqIgjdI48KYbKhH1sL4uBrkmx+gX9ygswMM6ydvnUAul58EkARVFWvoMPF1DHprYfP66z6BRSy0EeJOFAvPk6y54xkDeTSIWV0iX3bJSOftl/ox1YsfSzvRtrwoCl+C4A4kzLvI6seGNOYo9kXPUQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741057983; c=relaxed/simple;
	bh=keABWMxhcylI1t6EvFw6fzncjg7BwbXtUaSTYDrCcGg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FxZmI1si+WmRhzV6TEe9sBPTOKqj4I02oZ0WzoyKAQxY2pFOE/C0RtTXYNN/YiAY4dbpmYBnsm3WZv9DhbOGhb9hcfoOcst4frXwWwjtgcfUPt4ilU0/+xkUnVw+oN+d7E7JwLVQA3kVpt3Cm01u+fvhFjfLDgy9ylsAgSC8bes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bLUSA9tT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741057978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OtDKjDLxchTmgeo3fCPdqZ75vdxjYgf+mwp2fB0rais=;
	b=bLUSA9tTAhHJ9UVYvZca+f/h6b71AERyweLDS6X/RyI3G1wx9dDE/KPUR7zfH49NhlWcr7
	o7QZdcMyLEUushhyE6poDDYXdI0waL18RawBlripKSvbKg95RjqVb+CCatokBG67wn5Qbc
	sxY1UM0NXqta5qW38d4GdzCYOtkb8hk=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-5xygoUUGMHmJFYgiGyg76w-1; Mon, 03 Mar 2025 22:12:57 -0500
X-MC-Unique: 5xygoUUGMHmJFYgiGyg76w-1
X-Mimecast-MFC-AGG-ID: 5xygoUUGMHmJFYgiGyg76w_1741057976
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d401ede48dso3085105ab.1
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 19:12:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741057976; x=1741662776;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OtDKjDLxchTmgeo3fCPdqZ75vdxjYgf+mwp2fB0rais=;
        b=THk79aM0ikBYo7HbElrzGixx+RhOBs+f09FqY3j8FPK76LUy41fh9epZmfwSc7mSn/
         PMDf39P38qbxCjRtRfUVR2bqsp7NvNVvhhPBVWZw/HTB6x2j89EWcrKNWg/qdmUhi3Ki
         5wU/GgTc2TlFn1lP28z2jk+f+i/QKcfVAAOsXYdutb75EeziDdeOh26RjFoRBnylPIaT
         aHM96F0kqN/x3XjkqbIYaR/t83t4I3noOx6uKigwuwOmZOj8GBlfthAgcZWHwR9M2AEt
         0egox6P7rlET5RbZjY2Oyg0ZzLTcozNt/SGjl3+uZlP/JVfbVfHUtVwGnwcZZygLAQt3
         FH1g==
X-Forwarded-Encrypted: i=1; AJvYcCWF2v4M7tVlSiL39gAE0lj2zW42GrKn80JCwu1sH33TgN2KBK7Y/FsG98QwdfsfNqtBUx0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOexssiopyFd2fU6vyaQDJxjElm9Qdcf6+8WfhMxDF6njHJCTu
	MyacKEHTh6z+XWTU30mnAJU2XpZUmtk6vBu1HNKrlbxqB1qUY5egzhemIBLnzLn0wpOHC5aJ1Ho
	Um+GzAAk6gwdwXPcQ6SguMFk5RT6vwfweNaorqVkJrSpZih8drA==
X-Gm-Gg: ASbGncuXVIBj5HKFWcotNBkamPfBCBXD2I2+nI7n27HLN0hO8Ld4Lm9D7H6GjFQuc1y
	k44SnrZueZvSeOD2DOpZA5mCuhUd0NRzca7fNfNFswBTTClXOcgQEw6Zn5x6kBfygOuhDEo4SZC
	bhcAH/f22xFDMsQPqdBVh8MwGhhQZJOKmk99pUkDP8eXvm103q2qhl1kM6inZrXHLF/DOAtqX/7
	W+LrQqSjU7F2ZURoczujWX5Zlq6nc2y05aAaNJHSfOO8ywWiETBsnMZY5asSQoaO5oy3ctpGIuC
	rlSfER9/ZliES3YhNOg=
X-Received: by 2002:a05:6e02:451a:b0:3d3:febc:1e37 with SMTP id e9e14a558f8ab-3d3febc3588mr15222255ab.2.1741057975930;
        Mon, 03 Mar 2025 19:12:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFr7mXZ3rWgq3N34duAN/UkQuvybvYEiviVBXvs7xlnX1yQ3bmoDKoMpIODOIcLCS30p8RnSw==
X-Received: by 2002:a05:6e02:451a:b0:3d3:febc:1e37 with SMTP id e9e14a558f8ab-3d3febc3588mr15222185ab.2.1741057975420;
        Mon, 03 Mar 2025 19:12:55 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d3deeca7adsm27853305ab.58.2025.03.03.19.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 19:12:53 -0800 (PST)
Date: Mon, 3 Mar 2025 20:12:46 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, nd
 <nd@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian
 <kevin.tian@intel.com>, Philipp Stanner <pstanner@redhat.com>, Yunxiang Li
 <Yunxiang.Li@amd.com>, "Dr. David Alan Gilbert" <linux@treblig.org>, Ankit
 Agrawal <ankita@nvidia.com>, "open list:VFIO DRIVER" <kvm@vger.kernel.org>,
 Jeremy Linton <Jeremy.Linton@arm.com>, Honnappa Nagarahalli
 <Honnappa.Nagarahalli@arm.com>, Dhruv Tripathi <Dhruv.Tripathi@arm.com>
Subject: Re: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Message-ID: <20250303201246.5122beb5.alex.williamson@redhat.com>
In-Reply-To: <PAWPR08MB890947144D61177C7BDD2D669FC92@PAWPR08MB8909.eurprd08.prod.outlook.com>
References: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
	<20250228114809.57a974c7.alex.williamson@redhat.com>
	<PAWPR08MB890947144D61177C7BDD2D669FC92@PAWPR08MB8909.eurprd08.prod.outlook.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Mar 2025 04:20:24 +0000
Wathsala Wathawana Vithanage <wathsala.vithanage@arm.com> wrote:

> Hi Alex,
>=20
> > > Linux v6.13 introduced the PCIe TLP Processing Hints (TPH) feature for
> > > direct cache injection. As described in the relevant patch set [1],
> > > direct cache injection in supported hardware allows optimal platform
> > > resource utilization for specific requests on the PCIe bus. This
> > > feature is currently available only for kernel device drivers.
> > > However, user space applications, especially those whose performance
> > > is sensitive to the latency of inbound writes as seen by a CPU core,
> > > may benefit from using this information (E.g., DPDK cache stashing RFC
> > > [2] or an HPC application running in a VM).
> > >
> > > This patch enables configuring of TPH from the user space via
> > > VFIO_DEVICE_FEATURE IOCLT. It provides an interface to user space
> > > drivers and VMMs to enable/disable the TPH feature on PCIe devices and
> > > set steering tags in MSI-X or steering-tag table entries using
> > > VFIO_DEVICE_FEATURE_SET flag or read steering tags from the kernel
> > > using VFIO_DEVICE_FEATURE_GET to operate in device-specific mode. =20
> >=20
> > Unless I'm missing it, the RFC in [2] doesn't make use of this proposal=
.  Is there
> > published code anywhere that does use this interface?
> >  =20
> > > [1]
> > > lore.kernel.org/linux-pci/20241002165954.128085-1-wei.huang2@amd.com
> > > [2]
> > > inbox.dpdk.org/dev/20241021015246.304431-2-wathsala.vithanage@arm.com
> > > =20
>=20
> The DPDK RFC in question is on hold for now because there is no way to ge=
t steering-tags
> from the user space.=20
> Consequently, I had to stop working on [2] and start working on the kerne=
l to get VFIO ready
> for it. This was discussed in a DPDK community call sometime back.
> https://mails.dpdk.org/archives/dev/2024-October/305408.html

I think the userspace and kernel support need to be co-developed, we
don't want to be adding kernel code and uAPIs that don't have users.
=20
> > > Signed-off-by: Wathsala Vithanage <wathsala.vithanage@arm.com>
> > > ---
> > >  drivers/vfio/pci/vfio_pci_core.c | 163 +++++++++++++++++++++++++++++=
++
> > >  include/uapi/linux/vfio.h        |  68 +++++++++++++
> > >  2 files changed, 231 insertions(+)
> > >
> > > diff --git a/drivers/vfio/pci/vfio_pci_core.c
> > > b/drivers/vfio/pci/vfio_pci_core.c
> > > index 586e49efb81b..d6dd0495b08b 100644
> > > --- a/drivers/vfio/pci/vfio_pci_core.c
> > > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > > @@ -29,6 +29,7 @@
> > >  #include <linux/nospec.h>
> > >  #include <linux/sched/mm.h>
> > >  #include <linux/iommufd.h>
> > > +#include <linux/pci-tph.h>
> > >  #if IS_ENABLED(CONFIG_EEH)
> > >  #include <asm/eeh.h>
> > >  #endif
> > > @@ -1510,6 +1511,165 @@ static int vfio_pci_core_feature_token(struct=
 =20
> > vfio_device *device, u32 flags, =20
> > >  	return 0;
> > >  }
> > >
> > > +static ssize_t vfio_pci_tph_uinfo_dup(struct vfio_pci_tph *tph,
> > > +				      void __user *arg, size_t argsz,
> > > +				      struct vfio_pci_tph_info **info) {
> > > +	size_t minsz;
> > > +
> > > +	if (tph->count > VFIO_TPH_INFO_MAX)
> > > +		return -EINVAL;
> > > +	if (!tph->count)
> > > +		return 0;
> > > +
> > > +	minsz =3D tph->count * sizeof(struct vfio_pci_tph_info);
> > > +	if (minsz < argsz)
> > > +		return -EINVAL;
> > > +
> > > +	*info =3D memdup_user(arg, minsz);
> > > +	if (IS_ERR(info))
> > > +		return PTR_ERR(info);
> > > +
> > > +	return minsz;
> > > +}
> > > +
> > > +static int vfio_pci_feature_tph_st_op(struct vfio_pci_core_device *v=
dev,
> > > +				      struct vfio_pci_tph *tph,
> > > +				      void __user *arg, size_t argsz) {
> > > +	int i, mtype, err =3D 0;
> > > +	u32 cpu_uid;
> > > +	struct vfio_pci_tph_info *info =3D NULL;
> > > +	ssize_t data_size =3D vfio_pci_tph_uinfo_dup(tph, arg, argsz, &info=
);
> > > +
> > > +	if (data_size <=3D 0)
> > > +		return data_size;
> > > +
> > > +	for (i =3D 0; i < tph->count; i++) {
> > > +		if (!(info[i].cpu_id < nr_cpu_ids && cpu_present(info[i].cpu_id)))
> > > +{ =20
> >=20
> > Not intuitive logic, imo.  This could easily be:
> >=20
> > 		if (info[i].cpu_id >=3D nr_cpu_ids || !cpu_present(info[i].cpu_id))
> >  =20
>=20
> Agree, looks more intuitive.
>=20
> > > +			info[i].err =3D -EINVAL;
> > > +			continue;
> > > +		}
> > > +		cpu_uid =3D topology_core_id(info[i].cpu_id);
> > > +		mtype =3D (info[i].flags & VFIO_TPH_MEM_TYPE_MASK) >>
> > > +			VFIO_TPH_MEM_TYPE_SHIFT;
> > > +
> > > +		/* processing hints are always ignored */
> > > +		info[i].ph_ignore =3D 1;
> > > +
> > > +		info[i].err =3D pcie_tph_get_cpu_st(vdev->pdev, mtype, cpu_uid,
> > > +						  &info[i].st);
> > > +		if (info[i].err)
> > > +			continue;
> > > +
> > > +		if (tph->flags & VFIO_DEVICE_FEATURE_TPH_SET_ST) {
> > > +			info[i].err =3D pcie_tph_set_st_entry(vdev->pdev,
> > > +							    info[i].index,
> > > +							    info[i].st);
> > > +		}
> > > +	}
> > > +
> > > +	if (copy_to_user(arg, info, data_size))
> > > +		err =3D -EFAULT;
> > > +
> > > +	kfree(info);
> > > +	return err;
> > > +}
> > > +
> > > +
> > > +static int vfio_pci_feature_tph_enable(struct vfio_pci_core_device *=
vdev,
> > > +				       struct vfio_pci_tph *arg)
> > > +{
> > > +	int mode =3D arg->flags & VFIO_TPH_ST_MODE_MASK;
> > > +
> > > +	switch (mode) {
> > > +	case VFIO_TPH_ST_NS_MODE:
> > > +		return pcie_enable_tph(vdev->pdev, PCI_TPH_ST_NS_MODE);
> > > +
> > > +	case VFIO_TPH_ST_IV_MODE:
> > > +		return pcie_enable_tph(vdev->pdev, PCI_TPH_ST_IV_MODE);
> > > +
> > > +	case VFIO_TPH_ST_DS_MODE:
> > > +		return pcie_enable_tph(vdev->pdev, PCI_TPH_ST_DS_MODE);
> > > +
> > > +	default:
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +}
> > > +
> > > +static int vfio_pci_feature_tph_disable(struct vfio_pci_core_device
> > > +*vdev) {
> > > +	pcie_disable_tph(vdev->pdev);
> > > +	return 0;
> > > +}
> > > +
> > > +static int vfio_pci_feature_tph_prepare(struct vfio_pci_tph __user *=
arg,
> > > +					size_t argsz, u32 flags,
> > > +					struct vfio_pci_tph *tph)
> > > +{
> > > +	u32 op;
> > > +	int err =3D vfio_check_feature(flags, argsz,
> > > +				 VFIO_DEVICE_FEATURE_SET |
> > > +				 VFIO_DEVICE_FEATURE_GET,
> > > +				 sizeof(struct vfio_pci_tph));
> > > +	if (err !=3D 1)
> > > +		return err; =20
> >=20
> > We don't seem to account for a host booted with pci=3Dnotph.
> >  =20
>=20
> pcie_enable_tph() looks for pci=3Dnotph and fails if it's set.
> If pcie_enable_tph() fails, pcie_tph_get_cpu_st() and=20
> pcie_tph_set_st_entry() fail too.
>=20
> Is it required to check pci=3Dnotph here as well?

Does it make sense to probe affirmatively for a feature that can't be
enabled?  I think I previously also overlooked that we never actually
check that the device supports TPH at probe time.
=20
> > > +
> > > +	if (copy_from_user(tph, arg, sizeof(struct vfio_pci_tph)))
> > > +		return -EFAULT;
> > > +
> > > +	op =3D tph->flags & VFIO_DEVICE_FEATURE_TPH_OP_MASK;
> > > +
> > > +	switch (op) {
> > > +	case VFIO_DEVICE_FEATURE_TPH_ENABLE:
> > > +	case VFIO_DEVICE_FEATURE_TPH_DISABLE:
> > > +	case VFIO_DEVICE_FEATURE_TPH_SET_ST:
> > > +		return (flags & VFIO_DEVICE_FEATURE_SET) ? 0 : -EINVAL;
> > > +
> > > +	case VFIO_DEVICE_FEATURE_TPH_GET_ST:
> > > +		return (flags & VFIO_DEVICE_FEATURE_GET) ? 0 : -EINVAL; =20
> >=20
> > This is a convoluted mangling of an ioctl into a vfio feature.
> >  =20
>=20
> Do you prefer all four operations to fold under a single ioctl? Or split =
them
> such that enabling and disabling TPH remains a VFIO SET feature while
> SET_ST and GET_ST moved to a regular ioctl?

Splitting the functionality between a feature and a new ioctl doesn't
make any sense.  As I noted, I can imagine this interface being two
related features where one allows the TPH state to be set enabled or
disabled and the other allows setting steering tags.

> > > +
> > > +	default:
> > > +		return -EINVAL;
> > > +	}
> > > +}
> > > +
> > > +static int vfio_pci_core_feature_tph(struct vfio_device *device, u32=
 flags,
> > > +				     struct vfio_pci_tph __user *arg,
> > > +				     size_t argsz)
> > > +{
> > > +	u32 op;
> > > +	struct vfio_pci_tph tph;
> > > +	void __user *uinfo;
> > > +	size_t infosz;
> > > +	struct vfio_pci_core_device *vdev =3D
> > > +		container_of(device, struct vfio_pci_core_device, vdev);
> > > +	int err =3D vfio_pci_feature_tph_prepare(arg, argsz, flags, &tph);
> > > +
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	op =3D tph.flags & VFIO_DEVICE_FEATURE_TPH_OP_MASK;
> > > +
> > > +	switch (op) {
> > > +	case VFIO_DEVICE_FEATURE_TPH_ENABLE:
> > > +		return vfio_pci_feature_tph_enable(vdev, &tph);
> > > +
> > > +	case VFIO_DEVICE_FEATURE_TPH_DISABLE:
> > > +		return vfio_pci_feature_tph_disable(vdev);
> > > +
> > > +	case VFIO_DEVICE_FEATURE_TPH_GET_ST:
> > > +	case VFIO_DEVICE_FEATURE_TPH_SET_ST:
> > > +		uinfo =3D (u8 *)(arg) + offsetof(struct vfio_pci_tph, info);
> > > +		infosz =3D argsz - sizeof(struct vfio_pci_tph);
> > > +		return vfio_pci_feature_tph_st_op(vdev, &tph, uinfo, infosz); =20
> >=20
> > This is effectively encoding a regular ioctl as a feature.  See below.
> >  =20
>=20
> Addressed this in the above comment.
>=20
> > > +
> > > +	default:
> > > +		return -EINVAL;
> > > +	}
> > > +}
> > > +
> > >  int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flag=
s,
> > >  				void __user *arg, size_t argsz)
> > >  {
> > > @@ -1523,6 +1683,9 @@ int vfio_pci_core_ioctl_feature(struct vfio_dev=
ice =20
> > *device, u32 flags, =20
> > >  		return vfio_pci_core_pm_exit(device, flags, arg, argsz);
> > >  	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
> > >  		return vfio_pci_core_feature_token(device, flags, arg, argsz);
> > > +	case VFIO_DEVICE_FEATURE_PCI_TPH:
> > > +		return vfio_pci_core_feature_tph(device, flags,
> > > +						 arg, argsz);
> > >  	default:
> > >  		return -ENOTTY;
> > >  	}
> > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > index c8dbf8219c4f..608d57dfe279 100644
> > > --- a/include/uapi/linux/vfio.h
> > > +++ b/include/uapi/linux/vfio.h
> > > @@ -1458,6 +1458,74 @@ struct vfio_device_feature_bus_master {  };
> > > #define VFIO_DEVICE_FEATURE_BUS_MASTER 10
> > >
> > > +/*
> > > + * Upon VFIO_DEVICE_FEATURE_SET, enable or disable PCIe TPH or set
> > > +steering tags
> > > + * on the device. Data provided when setting this feature is a __u32
> > > +with the
> > > + * following flags. VFIO_DEVICE_FEATURE_TPH_ENABLE enables PCIe TPH
> > > +in
> > > + * no-steering-tag, interrupt-vector, or device-specific mode when
> > > +feature flags
> > > + * VFIO_TPH_ST_NS_MODE, VFIO_TPH_ST_IV_MODE, and =20
> > VFIO_TPH_ST_DS_MODE =20
> > > +are set
> > > + * respectively.
> > > + * VFIO_DEVICE_FEATURE_TPH_DISABLE disables PCIe TPH on the device.
> > > + * VFIO_DEVICE_FEATURE_TPH_SET_ST set steering tags on a device at an
> > > +index in
> > > + * MSI-X or ST-table depending on the VFIO_TPH_ST_x_MODE flag used
> > > +and device
> > > + * capabilities. The caller can set multiple steering tags by passing
> > > +an array
> > > + * of vfio_pci_tph_info objects containing cpu_id, cache_level, and
> > > + * MSI-X/ST-table index. The caller can also set the intended memory
> > > +type and
> > > + * the processing hint by setting VFIO_TPH_MEM_TYPE_x and
> > > +VFIO_TPH_HINT_x flags,
> > > + * respectively. The return value for each vfio_pci_tph_info object
> > > +is stored in
> > > + * err, with the steering-tag set on the device and the ph_ignore
> > > +status bit
> > > + * resulting from the steering-tag lookup operation. If err < 0, the
> > > +values
> > > + * stored in the st and ph_ignore fields should be considered invali=
d.
> > > + * =20
> >=20
> > Sorry, I don't understand ph_ignore as described here.  It's only ever =
set to 1.  I
> > guess we assume the incoming state is zero.  But what does it mean?
> >  =20
>=20
> Agree, it's confusing and it has something to do with the current impleme=
ntation
> of TPH in the Kernel.=20
> PCIe firmware specification states root-port ACPI _DSM as the single sour=
ce of
> truth for steering-tags. Its job is to maintain a table of steering-tags =
indexed by
> a tuple of CPU/Container UID, Cache-id and a processing-hint>. Each tuple=
 is mapped
> to two steering-tags for persistent or volatile memory (either or both de=
pending on
> the platform).
> A caller looking to acquire a steering tag for a cache closer to a CPU wi=
ll pass above
> tuple in the format defined in the PCIe firmware specification.=20
> But PCIe spec also allows implementing TPH without processing-hints, in s=
uch cases
> the _DSM is supposed to set ph_ignore bit in the return structure.
> Current TPH implementation in the Linux kernel ignores some of these deta=
ils,
> it sets cache-id and the processing-hint in the above tuple to zeros. It =
also ignores the
> ph_ignore bit return by the _DSM as well.=20
> However, I wrote this RFC to match the PCI firmware specification, theref=
ore it sets
> ph_ignore bit to 1 to inform the caller that it is ignored so that caller=
 can make an
> informed decision to stick with the default (bidirectional hint) or exit =
with error.
> This is why the cache_level is ignored as well, ideally cache levels (0 f=
or L1D, 1 for L2D,
> Etc.) should be converted to a PPTT cache_id and passed into the _DSM.
> I'm working on a separate PCI patch to fix above issues.
>=20
> > > + * Upon VFIO_DEVICE_FEATURE_GET,=C2=A0 return steering tags to the c=
aller.
> > > + * VFIO_DEVICE_FEATURE_TPH_GET_ST returns steering tags to the calle=
r.
> > > + * The return values per vfio_pci_tph_info object are stored in the
> > > + st,
> > > + * ph_ignore, and err fields. =20
> >=20
> > Why do we need to provide an interface to return the steering tags set =
by the
> > user?  Seems like this could be a write-only, SET, interface.
> >  =20
>=20
> VFIO_DEVICE_FEATURE_TPH_GET_ST calls the _DSM to read the steering-tag
> for a vector of tuples of a cpu-id, cache-id, processing-hint. It is for =
devices that operate
> in device specific mode where they don't set steering-tags in the MSI-X o=
r ST tables but
> in another construct like a queue context accessible from the user/kernel=
 space.=20
> For instance, this is what will be used by DPDK poll mode drivers as [2] =
fleshes
> out.=20
>=20
> So, VFIO_DEVICE_FEATURE_TPH_GET_ST doesn't return steering-tags set by the
> user. It's there to read the platform database of steering-tags which is =
an ACPI _DSM
> bound each PCIe root port.
>=20
> > > + */
> > > +struct vfio_pci_tph_info { =20
> >=20
> > This seems more of an _entry than an _info.  Note that vfio has various=
 INFO
> > ioctls which make this nomenclature confusing.
> >  =20
>=20
> It is, it's more of a struct that describes the request.
> Perhaps vfio_pci_tph_request_descriptor, but that's too long.=20
> Suggestions are welcome.
>=20
>=20
> > > +	/* in */
> > > +	__u32 cpu_id; =20
> >=20
> > The logical ID?
> >  =20
> Yes, this is logical ID.
>=20
> > > +	__u32 cache_level; =20
> >=20
> > Zero based?  1-based?  How many cache levels are there?  What's valid h=
ere?
> >  =20
> It's Zero based. This is currently ignored due to limitations in the kern=
el TPH.=20
> One way to validate would be iterating through the topology to find it, d=
ecrementing
> a copy_of_cache_level as we move further away from the cpu_id until the v=
alue
> reaches zero. If loop terminates before copy_of_cache_level reaching zero=
, -EINVAL.
> Is that a good approach?

Sounds like a try and hope for the best interface.  How would userspace
realistically infer the cache levels?  I don't think we want vfio
describing that.

> > > +	__u8  flags;
> > > +#define VFIO_TPH_MEM_TYPE_MASK		0x1
> > > +#define VFIO_TPH_MEM_TYPE_SHIFT		0
> > > +#define VFIO_TPH_MEM_TYPE_VMEM		0	/* Request =20
> > volatile memory ST */ =20
> > > +#define VFIO_TPH_MEM_TYPE_PMEM		1	/* Request =20
> > persistent memory ST */
> >=20
> > Is there a relation to the cache_level here?  Spec references here and =
below,
> > assuming those are relevant to these values.
> >  =20
> There is no relation to cache level. Return from the _DSM has PMEM and VM=
EM
> sections. If either of those are not supported a valid bit is set to 0 in=
 the return.
>=20
> PCIe spec has four processing-hints, VFIO_TPH_HINT_* are there to set them
> in the flags field. Hints are forced to VFIO_TPH_HINT_BIDIR by current TPH
> implementation as I described above.=20
>=20
> > > +
> > > +#define VFIO_TPH_HINT_MASK		0x3
> > > +#define VFIO_TPH_HINT_SHIFT		1
> > > +#define VFIO_TPH_HINT_BIDIR		0
> > > +#define VFIO_TPH_HINT_REQSTR		(1 << VFIO_TPH_HINT_SHIFT)
> > > +#define VFIO_TPH_HINT_TARGET		(2 << VFIO_TPH_HINT_SHIFT)
> > > +#define VFIO_TPH_HINT_TARGET_PRIO	(3 << VFIO_TPH_HINT_SHIFT) =20
> >=20
> > There needs to be a __u8 padding in here somewhere or flags extended to
> > __u16.
> >  =20
> > > +	__u16 index;			/* MSI-X/ST-table index to set ST */
> > > +	/* out */
> > > +	__u16 st;			/* Steering-Tag */ =20
> >=20
> > Sorry if I'm just not familiar with TPH, but why do we need to return t=
he ST?
> > Doesn't hardware make use of the ST index and the physical value gets a=
pplied
> > automatically in HW?
> >  =20
>=20
> Device specific mode requires this. For instance, intel E810 NIC can set
> Steering-tags in queue context which is in user-space when used with DPDK.
> For such use cases we must return steering-tags read from the _DSM.=20
> Going back to DPDK RFC mentioned here, if TPH gets enabled in VFIO, the E=
810=20
> poll mode driver in the DPDK will ask the kernel a steering-tag for a com=
bination
> of a cpu-id, a cache-level and a processing-hint. In response the kernel =
will
> invoke the ACPI _DSM for the root port of the device via pcie_tph_get_cpu=
_st()
> and return the steering-tag back to the user. E810 driver will set the re=
turned tag
> in appropriate queue context.
>=20
> For cases where steering-tag is not required in user-space (VMMs), caller=
 asks the
> kernel to set steering-tag that corresponds the cpu-id, cache-level, and =
PH
> combination at a given MSI-X vector entry or ST table in config space. Fo=
r such
> cases too, the kernel will read the steering-tag from the _DSM and set th=
e tag
> in the corresponding MSI-X or ST table entry.

We need to consider that there are vfio-pci variant drivers that
support migration and make use of the vfio-pci-core feature interface.
TPH programming appears to be very non-migration friendly, the
attributes are very specific to the current host system.  Should
migration and TPH be mutually exclusive?  This may be a factor in the
decision to use a feature or ioctl.

> > > +	__u8  ph_ignore;		/* Processing hint was ignored by */ =20
> >=20
> > Padding/alignment, same as above.  "ignored by..."  By what?  Is that a=
n error?
> >  =20
>=20
> An error. "Processing hint was ignored by the platform"
>=20
> > > +	__s32 err;			/* Error on getting/setting Steering- =20
> > Tag*/ =20
> > > +}; =20
> >=20
> > Generally we'd expect a system call either works or fails.  Why do we n=
eed per
> > entry error report?  Can't we validate and prepare the entire operation=
 before
> > setting any of it into the device?  Ultimately we're just writing hints=
 to config
> > space or MSI-X table space, so the write operation itself is not likely=
 to be the
> > point of failure.
> >  =20
>=20
> Write to MSI-X won't fail but reading the steering-tag from the _DSM for =
an
> invalid <cpu_id, cach_id, ph_hint> combo can fail in both GET_ST and SET_=
ST
> cases.
> We can change this to an all or nothing interface, such that success if a=
ll the
> entries are valid and otherwise if at least one is invalid. But in that c=
ase the
> caller may not know which entries were invalid. If you think that's ok, I=
 can
> change it.

It's not exactly uncommon for an ioctl to fail for a single bad arg
among many.  I think it's harder for userspace to deal with recovering
from a partially implemented call.

> > > +
> > > +struct vfio_pci_tph {
> > > +	__u32 argsz;			/* Size of vfio_pci_tph and info[] */
> > > +	__u32 flags;
> > > +#define VFIO_DEVICE_FEATURE_TPH_OP_MASK		0x7
> > > +#define VFIO_DEVICE_FEATURE_TPH_OP_SHIFT	3
> > > +#define VFIO_DEVICE_FEATURE_TPH_ENABLE		0	/* =20
> > Enable TPH on device */ =20
> > > +#define VFIO_DEVICE_FEATURE_TPH_DISABLE	1	/* Disable TPH =20
> > on device */ =20
> > > +#define VFIO_DEVICE_FEATURE_TPH_GET_ST		2	/* Get =20
> > steering-tags */ =20
> > > +#define VFIO_DEVICE_FEATURE_TPH_SET_ST		4	/* Set =20
> > steering-rags */
> >=20
> > s/rags/tags/
> >=20
> > vfio device features already have GET and SET as part of their base str=
ucture, why
> > are they duplicated here?  It really seems like there are two separate =
features
> > here, one that allows enabling with a given mode or disable, and anothe=
r that
> > allows writing specific steering tags.  Both seem like they could be SE=
T-only
> > features.  It's also not clear to me that there's a significant advanta=
ge to providing
> > an array of steering tags.  Isn't updating STs an infrequent operation =
and likely
> > bound to at most 2K tags in the case of MSI-X?
> >  =20
>=20
> VFIO_DEVICE_FEATURE_TPH_ENABLE and VFIO_DEVICE_FEATURE_TPH_DISABLE
> are SET features.
> Since, VFIO_DEVICE_FEATURE_TPH_SET_ST requires writing to ST table, so th=
at too
> falls under SET features.
> Therefore, these flags are only valid when VFIO_DEVICE_FEATURE_SET flag i=
s set.
> The only GET features use case here is VFIO_DEVICE_FEATURE_TPH_GET_ST that
> reads the steering-tags from the _DSM and returns it back to caller. Only=
 valid
> with VFIO_DEVICE_FEATURE_GET flag.=20
> These are checked in vfio_pci_feature_tph_prepare().
>=20
> As I mentioned earlier, does it make sense to leave enable/disable under =
VFIO
> Feature and move GET_ST and SET_ST to a separate ioctl?

Splitting TPH between a feature and new ioctls doesn't seem like a
logical interface.

> There isn't much rational to providing an array of tuples other than foll=
owing
> the format VFIO_DEVICE_SET_IRQS that sets eventfds.
>=20
> > > +
> > > +#define	VFIO_TPH_ST_MODE_MASK	(0x3 << =20
> > VFIO_DEVICE_FEATURE_TPH_OP_SHIFT) =20
> > > +#define	VFIO_TPH_ST_NS_MODE	(0 << =20
> > VFIO_DEVICE_FEATURE_TPH_OP_SHIFT) =20
> > > +#define	VFIO_TPH_ST_IV_MODE	(1 << =20
> > VFIO_DEVICE_FEATURE_TPH_OP_SHIFT) =20
> > > +#define	VFIO_TPH_ST_DS_MODE	(2 << =20
> > VFIO_DEVICE_FEATURE_TPH_OP_SHIFT) =20
> > > +	__u32 count;				/* Number of entries in info[] =20
> > */ =20
> > > +	struct vfio_pci_tph_info info[];
> > > +#define VFIO_TPH_INFO_MAX	64		/* Max entries allowed =20
> > in info[] */
> >=20
> > This seems to match the limit if the table is located in extended confi=
g space, but
> > it's not particularly relevant if the table is located in MSI-X space. =
 Why is this a
> > good limit? =20
>=20
> Yes, for MSI-X the caller may have to invoke the ioctl multiple times if =
more
> than 64 entries need to be updated.=20
>=20
> >=20
> > Also, try to keep these all in 80 column.  Thanks,
> >  =20
>=20
> I will, try to keep these under 80 columns.
>=20
> Thanks Alex, for your input. Let me know what you think about moving SET_=
ST
> and GET_ST to an ioctl and keep ENABLE/DISABLE TPH as a vfio feature.

It seems like kind of a hodgepodge to split the interface like that,
imo.  Sorry for a less that complete reply, I'm on PTO this week.
Thanks,

Alex


