Return-Path: <kvm+bounces-39764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 24446A4A216
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 19:49:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85E6E177F24
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 18:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5511B277014;
	Fri, 28 Feb 2025 18:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cRCb4TPa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596EE277000
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 18:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740768501; cv=none; b=KiowcSdjPmlFIMQqecJ+k5O0BhwNsYMU1wmELvpyzVradx2h6BCz/kNEp88kUtwCeh62oYPLqRTeTgXHL19v3/Kso0cWkGgyRrnzKLnfJkbo/9NTfgDAF9M1JQ3ZgXJP4+i3cypHO7xTCAx3r3PR3CQ7yV5nXWwiigzca2H0piw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740768501; c=relaxed/simple;
	bh=JdbMrO62Y4zC05HjU+iVmnj3wX6vMJBY2D9JscCwUPA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nHdiQRY7VOotbwDoeNEavqcBOE2Nyg93FEfRScQ3pvNRREcWz50L1kz5M33H36hpdRL3T7jDUaxPlUve2xRYaJCWSWdH63kGexO/14rFPInwfT9UAu8gSufW4vTpRCRLDa9QNI7MS9zI3XG9jQhzUDre81PsQinS4RA1gj1koGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cRCb4TPa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740768498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HEhNRQEX/XtyImrxDo80Pae4kdXbmpmgxsYv7h1bYqk=;
	b=cRCb4TPaGOxQyJ6Ymy9kDW5WF+cU3iOx+dxjoE8rMgJ0iks/hMNuei2ntr2V7WomI2lpEy
	VQqtAghYU930JJZmpvag1ySIoRvHRAw1djCbXKXrUoYbvWLQU5JZbEa2OU8xDDM+rJG5M8
	X8M2PIG0SFGvTZwYGU5Cs8R3B6CpyHY=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-LoMS2f7uOqW-PsIiDDH0cQ-1; Fri, 28 Feb 2025 13:48:16 -0500
X-MC-Unique: LoMS2f7uOqW-PsIiDDH0cQ-1
X-Mimecast-MFC-AGG-ID: LoMS2f7uOqW-PsIiDDH0cQ_1740768496
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3d19bfdd82bso1830625ab.0
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 10:48:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740768495; x=1741373295;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HEhNRQEX/XtyImrxDo80Pae4kdXbmpmgxsYv7h1bYqk=;
        b=UzNniimIDoAi77hmYQPcTzuWCruym1safhzOMeKtsQSkGb2isyzYku2LnAIPeqmQXp
         OjCeZkaQxkv090zG1XnbDZ7zjyHy1uYc4VRsyjgyhacF3ov1V5Civ5z82K7OKYQXoNPv
         sfppowoL6vx9jZ+oQiigHS8+TeQ/KKuBk7jFh4wegxWXHT9MfkPatr3awjsHnPPwvRVX
         9lCFJyAWpcUHCX3d8P0884P0hMoo2/aGCc2aByXSCKN/CcMchweAcT2RHNXmjOMvl4Se
         920tMoTSPf7zbAeg1mul5GRCJsQCrR/sm3+n9sMTWwMdSKO1dRghZ3pBbUAR+usGdC3u
         SiOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUx2ITzvD0YWfFzQwwlBD/w2+OK8qFwd7L70N6uKGGIpcgzXrt2WdSmcb2MGrjZtg4cgU4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWx3FCyBkRrhqjQsW5qjOgBABBXRAnZjXBrPDfefzh36Y4JSLC
	Ms162l9ABUxiV0gMQOBuUV3q3OaIFGvX5mgAIN59v83rV3ebHhDaum8G4tjI+jj1N3jVh1hCjsZ
	80EXNKcitDoADApi8SLY5InzKardJTdWtPFFp7IW8U6mllo+Pg/86R4GGAg==
X-Gm-Gg: ASbGnctFcZDbipoQqMAIEVaJ8BjPvnr6+0rxV00Sdt5O/gfd6ygB78iDbOJ8ntTpnrU
	h/P7VSayVFVLyYef7rszDw+rI1GVXsCf/IcUiOkkRdbK8m434FpKYyVYy/1C5yP2mRRP0mmfOSe
	OpUGxk3EFFdZgNlniwA+l1O2T4d5GVuWJ3gKV231GQWM99o7aUt8KwX4h6di5iQpycWBDeaOOkx
	Ch0TdF6LSpTUc4rqyJVtNLnmgEjLVgYY5UqjCK2i8jKfU/ndNzqLzBEJZnS0G+MYffd+H15GbbA
	/42bLUzMK03+PJC73NM=
X-Received: by 2002:a05:6e02:1748:b0:3d3:d156:7836 with SMTP id e9e14a558f8ab-3d3e6f97e8bmr14475485ab.7.1740768495106;
        Fri, 28 Feb 2025 10:48:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHj9qQMw7QCZRXxjlh1mMaHaANOoR/Pe9gZPG0CzWddy7JRGt3rs0ubsuw6vjilT9lo1H1nAQ==
X-Received: by 2002:a05:6e02:1748:b0:3d3:d156:7836 with SMTP id e9e14a558f8ab-3d3e6f97e8bmr14475425ab.7.1740768494637;
        Fri, 28 Feb 2025 10:48:14 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d3dee67ae1sm9759195ab.25.2025.02.28.10.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 10:48:12 -0800 (PST)
Date: Fri, 28 Feb 2025 11:48:09 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Wathsala Vithanage <wathsala.vithanage@arm.com>
Cc: linux-kernel@vger.kernel.org, nd@arm.com, Jason Gunthorpe
 <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, Philipp Stanner
 <pstanner@redhat.com>, Yunxiang Li <Yunxiang.Li@amd.com>, "Dr. David Alan
 Gilbert" <linux@treblig.org>, Ankit Agrawal <ankita@nvidia.com>,
 kvm@vger.kernel.org (open list:VFIO DRIVER)
Subject: Re: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
Message-ID: <20250228114809.57a974c7.alex.williamson@redhat.com>
In-Reply-To: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
References: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Feb 2025 22:46:33 +0000
Wathsala Vithanage <wathsala.vithanage@arm.com> wrote:

> Linux v6.13 introduced the PCIe TLP Processing Hints (TPH) feature for
> direct cache injection. As described in the relevant patch set [1],
> direct cache injection in supported hardware allows optimal platform
> resource utilization for specific requests on the PCIe bus. This feature
> is currently available only for kernel device drivers. However,
> user space applications, especially those whose performance is sensitive
> to the latency of inbound writes as seen by a CPU core, may benefit from
> using this information (E.g., DPDK cache stashing RFC [2] or an HPC
> application running in a VM).
>=20
> This patch enables configuring of TPH from the user space via
> VFIO_DEVICE_FEATURE IOCLT. It provides an interface to user space
> drivers and VMMs to enable/disable the TPH feature on PCIe devices and
> set steering tags in MSI-X or steering-tag table entries using
> VFIO_DEVICE_FEATURE_SET flag or read steering tags from the kernel using
> VFIO_DEVICE_FEATURE_GET to operate in device-specific mode.

Unless I'm missing it, the RFC in [2] doesn't make use of this
proposal.  Is there published code anywhere that does use this
interface?

> [1]=C2=A0lore.kernel.org/linux-pci/20241002165954.128085-1-wei.huang2@amd=
.com
> [2]=C2=A0inbox.dpdk.org/dev/20241021015246.304431-2-wathsala.vithanage@ar=
m.com
>=20
> Signed-off-by: Wathsala Vithanage <wathsala.vithanage@arm.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 163 +++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h        |  68 +++++++++++++
>  2 files changed, 231 insertions(+)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci=
_core.c
> index 586e49efb81b..d6dd0495b08b 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -29,6 +29,7 @@
>  #include <linux/nospec.h>
>  #include <linux/sched/mm.h>
>  #include <linux/iommufd.h>
> +#include <linux/pci-tph.h>
>  #if IS_ENABLED(CONFIG_EEH)
>  #include <asm/eeh.h>
>  #endif
> @@ -1510,6 +1511,165 @@ static int vfio_pci_core_feature_token(struct vfi=
o_device *device, u32 flags,
>  	return 0;
>  }
> =20
> +static ssize_t vfio_pci_tph_uinfo_dup(struct vfio_pci_tph *tph,
> +				      void __user *arg, size_t argsz,
> +				      struct vfio_pci_tph_info **info)
> +{
> +	size_t minsz;
> +
> +	if (tph->count > VFIO_TPH_INFO_MAX)
> +		return -EINVAL;
> +	if (!tph->count)
> +		return 0;
> +
> +	minsz =3D tph->count * sizeof(struct vfio_pci_tph_info);
> +	if (minsz < argsz)
> +		return -EINVAL;
> +
> +	*info =3D memdup_user(arg, minsz);
> +	if (IS_ERR(info))
> +		return PTR_ERR(info);
> +
> +	return minsz;
> +}
> +
> +static int vfio_pci_feature_tph_st_op(struct vfio_pci_core_device *vdev,
> +				      struct vfio_pci_tph *tph,
> +				      void __user *arg, size_t argsz)
> +{
> +	int i, mtype, err =3D 0;
> +	u32 cpu_uid;
> +	struct vfio_pci_tph_info *info =3D NULL;
> +	ssize_t data_size =3D vfio_pci_tph_uinfo_dup(tph, arg, argsz, &info);
> +
> +	if (data_size <=3D 0)
> +		return data_size;
> +
> +	for (i =3D 0; i < tph->count; i++) {
> +		if (!(info[i].cpu_id < nr_cpu_ids && cpu_present(info[i].cpu_id))) {

Not intuitive logic, imo.  This could easily be:

		if (info[i].cpu_id >=3D nr_cpu_ids || !cpu_present(info[i].cpu_id))

> +			info[i].err =3D -EINVAL;
> +			continue;
> +		}
> +		cpu_uid =3D topology_core_id(info[i].cpu_id);
> +		mtype =3D (info[i].flags & VFIO_TPH_MEM_TYPE_MASK) >>
> +			VFIO_TPH_MEM_TYPE_SHIFT;
> +
> +		/* processing hints are always ignored */
> +		info[i].ph_ignore =3D 1;
> +
> +		info[i].err =3D pcie_tph_get_cpu_st(vdev->pdev, mtype, cpu_uid,
> +						  &info[i].st);
> +		if (info[i].err)
> +			continue;
> +
> +		if (tph->flags & VFIO_DEVICE_FEATURE_TPH_SET_ST) {
> +			info[i].err =3D pcie_tph_set_st_entry(vdev->pdev,
> +							    info[i].index,
> +							    info[i].st);
> +		}
> +	}
> +
> +	if (copy_to_user(arg, info, data_size))
> +		err =3D -EFAULT;
> +
> +	kfree(info);
> +	return err;
> +}
> +
> +
> +static int vfio_pci_feature_tph_enable(struct vfio_pci_core_device *vdev,
> +				       struct vfio_pci_tph *arg)
> +{
> +	int mode =3D arg->flags & VFIO_TPH_ST_MODE_MASK;
> +
> +	switch (mode) {
> +	case VFIO_TPH_ST_NS_MODE:
> +		return pcie_enable_tph(vdev->pdev, PCI_TPH_ST_NS_MODE);
> +
> +	case VFIO_TPH_ST_IV_MODE:
> +		return pcie_enable_tph(vdev->pdev, PCI_TPH_ST_IV_MODE);
> +
> +	case VFIO_TPH_ST_DS_MODE:
> +		return pcie_enable_tph(vdev->pdev, PCI_TPH_ST_DS_MODE);
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +}
> +
> +static int vfio_pci_feature_tph_disable(struct vfio_pci_core_device *vde=
v)
> +{
> +	pcie_disable_tph(vdev->pdev);
> +	return 0;
> +}
> +
> +static int vfio_pci_feature_tph_prepare(struct vfio_pci_tph __user *arg,
> +					size_t argsz, u32 flags,
> +					struct vfio_pci_tph *tph)
> +{
> +	u32 op;
> +	int err =3D vfio_check_feature(flags, argsz,
> +				 VFIO_DEVICE_FEATURE_SET |
> +				 VFIO_DEVICE_FEATURE_GET,
> +				 sizeof(struct vfio_pci_tph));
> +	if (err !=3D 1)
> +		return err;

We don't seem to account for a host booted with pci=3Dnotph.

> +
> +	if (copy_from_user(tph, arg, sizeof(struct vfio_pci_tph)))
> +		return -EFAULT;
> +
> +	op =3D tph->flags & VFIO_DEVICE_FEATURE_TPH_OP_MASK;
> +
> +	switch (op) {
> +	case VFIO_DEVICE_FEATURE_TPH_ENABLE:
> +	case VFIO_DEVICE_FEATURE_TPH_DISABLE:
> +	case VFIO_DEVICE_FEATURE_TPH_SET_ST:
> +		return (flags & VFIO_DEVICE_FEATURE_SET) ? 0 : -EINVAL;
> +
> +	case VFIO_DEVICE_FEATURE_TPH_GET_ST:
> +		return (flags & VFIO_DEVICE_FEATURE_GET) ? 0 : -EINVAL;

This is a convoluted mangling of an ioctl into a vfio feature.

> +
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static int vfio_pci_core_feature_tph(struct vfio_device *device, u32 fla=
gs,
> +				     struct vfio_pci_tph __user *arg,
> +				     size_t argsz)
> +{
> +	u32 op;
> +	struct vfio_pci_tph tph;
> +	void __user *uinfo;
> +	size_t infosz;
> +	struct vfio_pci_core_device *vdev =3D
> +		container_of(device, struct vfio_pci_core_device, vdev);
> +	int err =3D vfio_pci_feature_tph_prepare(arg, argsz, flags, &tph);
> +
> +	if (err)
> +		return err;
> +
> +	op =3D tph.flags & VFIO_DEVICE_FEATURE_TPH_OP_MASK;
> +
> +	switch (op) {
> +	case VFIO_DEVICE_FEATURE_TPH_ENABLE:
> +		return vfio_pci_feature_tph_enable(vdev, &tph);
> +
> +	case VFIO_DEVICE_FEATURE_TPH_DISABLE:
> +		return vfio_pci_feature_tph_disable(vdev);
> +
> +	case VFIO_DEVICE_FEATURE_TPH_GET_ST:
> +	case VFIO_DEVICE_FEATURE_TPH_SET_ST:
> +		uinfo =3D (u8 *)(arg) + offsetof(struct vfio_pci_tph, info);
> +		infosz =3D argsz - sizeof(struct vfio_pci_tph);
> +		return vfio_pci_feature_tph_st_op(vdev, &tph, uinfo, infosz);

This is effectively encoding a regular ioctl as a feature.  See below.

> +
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>  int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
>  				void __user *arg, size_t argsz)
>  {
> @@ -1523,6 +1683,9 @@ int vfio_pci_core_ioctl_feature(struct vfio_device =
*device, u32 flags,
>  		return vfio_pci_core_pm_exit(device, flags, arg, argsz);
>  	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
>  		return vfio_pci_core_feature_token(device, flags, arg, argsz);
> +	case VFIO_DEVICE_FEATURE_PCI_TPH:
> +		return vfio_pci_core_feature_tph(device, flags,
> +						 arg, argsz);
>  	default:
>  		return -ENOTTY;
>  	}
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index c8dbf8219c4f..608d57dfe279 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1458,6 +1458,74 @@ struct vfio_device_feature_bus_master {
>  };
>  #define VFIO_DEVICE_FEATURE_BUS_MASTER 10
> =20
> +/*
> + * Upon VFIO_DEVICE_FEATURE_SET, enable or disable PCIe TPH or set steer=
ing tags
> + * on the device. Data provided when setting this feature is a __u32 wit=
h the
> + * following flags. VFIO_DEVICE_FEATURE_TPH_ENABLE enables PCIe TPH in
> + * no-steering-tag, interrupt-vector, or device-specific mode when featu=
re flags
> + * VFIO_TPH_ST_NS_MODE, VFIO_TPH_ST_IV_MODE, and VFIO_TPH_ST_DS_MODE are=
 set
> + * respectively.
> + * VFIO_DEVICE_FEATURE_TPH_DISABLE disables PCIe TPH on the device.
> + * VFIO_DEVICE_FEATURE_TPH_SET_ST set steering tags on a device at an in=
dex in
> + * MSI-X or ST-table depending on the VFIO_TPH_ST_x_MODE flag used and d=
evice
> + * capabilities. The caller can set multiple steering tags by passing an=
 array
> + * of vfio_pci_tph_info objects containing cpu_id, cache_level, and
> + * MSI-X/ST-table index. The caller can also set the intended memory typ=
e and
> + * the processing hint by setting VFIO_TPH_MEM_TYPE_x and VFIO_TPH_HINT_=
x flags,
> + * respectively. The return value for each vfio_pci_tph_info object is s=
tored in
> + * err, with the steering-tag set on the device and the ph_ignore status=
 bit
> + * resulting from the steering-tag lookup operation. If err < 0, the val=
ues
> + * stored in the st and ph_ignore fields should be considered invalid.
> + *

Sorry, I don't understand ph_ignore as described here.  It's only ever
set to 1.  I guess we assume the incoming state is zero.  But what does
it mean?

> + * Upon VFIO_DEVICE_FEATURE_GET,=C2=A0 return steering tags to the calle=
r.
> + * VFIO_DEVICE_FEATURE_TPH_GET_ST returns steering tags to the caller.
> + * The return values per vfio_pci_tph_info object are stored in the st,
> + * ph_ignore, and err fields.

Why do we need to provide an interface to return the steering tags set
by the user?  Seems like this could be a write-only, SET, interface.

> + */
> +struct vfio_pci_tph_info {

This seems more of an _entry than an _info.  Note that vfio has various
INFO ioctls which make this nomenclature confusing.

> +	/* in */
> +	__u32 cpu_id;

The logical ID?

> +	__u32 cache_level;

Zero based?  1-based?  How many cache levels are there?  What's valid
here?

> +	__u8  flags;
> +#define VFIO_TPH_MEM_TYPE_MASK		0x1
> +#define VFIO_TPH_MEM_TYPE_SHIFT		0
> +#define VFIO_TPH_MEM_TYPE_VMEM		0	/* Request volatile memory ST */
> +#define VFIO_TPH_MEM_TYPE_PMEM		1	/* Request persistent memory ST */

Is there a relation to the cache_level here?  Spec references here and
below, assuming those are relevant to these values.

> +
> +#define VFIO_TPH_HINT_MASK		0x3
> +#define VFIO_TPH_HINT_SHIFT		1
> +#define VFIO_TPH_HINT_BIDIR		0
> +#define VFIO_TPH_HINT_REQSTR		(1 << VFIO_TPH_HINT_SHIFT)
> +#define VFIO_TPH_HINT_TARGET		(2 << VFIO_TPH_HINT_SHIFT)
> +#define VFIO_TPH_HINT_TARGET_PRIO	(3 << VFIO_TPH_HINT_SHIFT)

There needs to be a __u8 padding in here somewhere or flags extended to
__u16.

> +	__u16 index;			/* MSI-X/ST-table index to set ST */
> +	/* out */
> +	__u16 st;			/* Steering-Tag */

Sorry if I'm just not familiar with TPH, but why do we need to return
the ST?  Doesn't hardware make use of the ST index and the physical
value gets applied automatically in HW?

> +	__u8  ph_ignore;		/* Processing hint was ignored by */

Padding/alignment, same as above.  "ignored by..."  By what?  Is that
an error?

> +	__s32 err;			/* Error on getting/setting Steering-Tag*/
> +};

Generally we'd expect a system call either works or fails.  Why do we
need per entry error report?  Can't we validate and prepare the entire
operation before setting any of it into the device?  Ultimately we're
just writing hints to config space or MSI-X table space, so the write
operation itself is not likely to be the point of failure.

> +
> +struct vfio_pci_tph {
> +	__u32 argsz;			/* Size of vfio_pci_tph and info[] */
> +	__u32 flags;
> +#define VFIO_DEVICE_FEATURE_TPH_OP_MASK		0x7
> +#define VFIO_DEVICE_FEATURE_TPH_OP_SHIFT	3
> +#define VFIO_DEVICE_FEATURE_TPH_ENABLE		0	/* Enable TPH on device */
> +#define VFIO_DEVICE_FEATURE_TPH_DISABLE	1	/* Disable TPH on device */
> +#define VFIO_DEVICE_FEATURE_TPH_GET_ST		2	/* Get steering-tags */
> +#define VFIO_DEVICE_FEATURE_TPH_SET_ST		4	/* Set steering-rags */

s/rags/tags/

vfio device features already have GET and SET as part of their base
structure, why are they duplicated here?  It really seems like there
are two separate features here, one that allows enabling with a given
mode or disable, and another that allows writing specific steering
tags.  Both seem like they could be SET-only features.  It's also not
clear to me that there's a significant advantage to providing an array
of steering tags.  Isn't updating STs an infrequent operation and
likely bound to at most 2K tags in the case of MSI-X?

> +
> +#define	VFIO_TPH_ST_MODE_MASK	(0x3 << VFIO_DEVICE_FEATURE_TPH_OP_SHIFT)
> +#define	VFIO_TPH_ST_NS_MODE	(0 << VFIO_DEVICE_FEATURE_TPH_OP_SHIFT)
> +#define	VFIO_TPH_ST_IV_MODE	(1 << VFIO_DEVICE_FEATURE_TPH_OP_SHIFT)
> +#define	VFIO_TPH_ST_DS_MODE	(2 << VFIO_DEVICE_FEATURE_TPH_OP_SHIFT)
> +	__u32 count;				/* Number of entries in info[] */
> +	struct vfio_pci_tph_info info[];
> +#define VFIO_TPH_INFO_MAX	64		/* Max entries allowed in info[] */

This seems to match the limit if the table is located in extended
config space, but it's not particularly relevant if the table is
located in MSI-X space.  Why is this a good limit?

Also, try to keep these all in 80 column.  Thanks,

Alex

> +};
> +
> +#define VFIO_DEVICE_FEATURE_PCI_TPH 11
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
> =20
>  /**


