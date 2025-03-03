Return-Path: <kvm+bounces-39862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1E8FA4B887
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 08:49:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAA2B16B346
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 07:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C1BA1EE03D;
	Mon,  3 Mar 2025 07:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TAOjglqX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1447B1EBFE2
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 07:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740988166; cv=none; b=fnEiE+uLEVcXJGuubu8GFDh8nSqIRW6NZ1G2vFT3TgOjUN6LsoPm4nYWyJkywxdUok872Yc9MsMXn/Vv77zGBEXK6zo0+37hUZdc7bkWeZ8Xxj8z9z9gCR4g+kfshQltxZM0Ak1qvKWoT9nHzCNQ4C6JfdQgmYJkr6Bap5iwlog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740988166; c=relaxed/simple;
	bh=vCfo8Si81Fc8nSDEzgrvG+DjczdcBP03Iz2zVEFG6e8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BL35cr9DFkJEHLWubdV8zVEZGeX8zU3TDRQcmGeSMviCIABDvfNWaAuFLSfH4ym0tJLKSFmeRc4Kjp6yg2IqcGZMe5wFxlpk4OYW4xGNBTWtW0fOhuTIEuGQ8nRs7WCcRUmsPyzzO5WevNdtR/EFcTZ72CcaoudUwBvXxfhI+ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TAOjglqX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740988163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UQ3rxpXvtWrZciJzkD/ZcttgC8TJTauI4ZtB7gsejbk=;
	b=TAOjglqXsJwqwfM2iKM/QNIbc/GnengiyICpFvLe0NjCzJK1VY6ezuxVyzWHcO9aVkF9ZP
	ZqfInoovMfGdhxuld23+8z6lnWyXs+55tdzfqkhIl57AC3EPDaOpkq8Pu3Rtkt+65A3Z3V
	EbBjKG1aZ/BbunDj5giQHM9eiiK0FVI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-RgJ8VhlPPCyYaZRezI24ww-1; Mon, 03 Mar 2025 02:49:11 -0500
X-MC-Unique: RgJ8VhlPPCyYaZRezI24ww-1
X-Mimecast-MFC-AGG-ID: RgJ8VhlPPCyYaZRezI24ww_1740988151
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4394c747c72so15362205e9.1
        for <kvm@vger.kernel.org>; Sun, 02 Mar 2025 23:49:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740988151; x=1741592951;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UQ3rxpXvtWrZciJzkD/ZcttgC8TJTauI4ZtB7gsejbk=;
        b=hFpq3ksi4JMSIYkzODIeHWAmsptM9hT5u2YSVxdC69KLHmHqr0b8/3p7jmP+7uN0Ko
         SzdpVP9f7yx1HELfyMnuL/xMm3SNUDWXiOgrWO33tTpzYzbYN4AxrvK282b169gjXbxU
         h7s6XVsQynr24YIVrd2CtsOgB9kWxV+yHKSE3XjidzEn4dstECPygIwLHwixInrSUhnF
         XcT76+gU4FLclk+04f0wwlIq1nlFrPDit+MHw/K16V6S9BBvWxllRqjGSfanuJAHNyzH
         NxoYD3j81ZcwkmfOdDZRGmE/HILoQ/ATPklroCrNKh9ZR7ruNa5GefoPoHG+TewhtaHX
         q88g==
X-Forwarded-Encrypted: i=1; AJvYcCU6OtlMNCfvJoBEgySWTvWD8E6rJPye/k/5Sj0OA1CU9qXOa6xoU7CCvFmGkDjwDfpsc/I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKOYWAckB1OJLnrKBZjzUKJmnRtMN5V19DEUsTrXzJjdK/P4oh
	ucxu37Wen2SoJUfjW9aNoFbBS15OsigncN+MG3nG6Og7E1xJJi9mCTOp1XEccLDEV+HMDzRe7Pr
	7++HB4vCJN6o+yW5NH9kL7oRz9xM6sVAKdgtCV9Y0hRSg+QkLsQ==
X-Gm-Gg: ASbGncvGpETnK9+GRCL9Qhmj3mEHbzjGlfeLmM7aGtPYf+n841eSae+VkCICLRepv3G
	UlB0PH1NRgc+T95kdbj2JBUrtn8di8pCA7a9LvaW4npXZ3HRQ37/BvC7fH9R8G9QyCUucjxa9PW
	YhGasH1SABuaz5SjBnjNEShqb5Nc+ZrJHHmzwC+eAvylyfF/rmAypstqhKF5Gow/TuHJSLNOUNB
	LwllF1qn1supPbzAXAZdldLW2U7w4GxFT9pVs08pxJeUn1EwklLBjMR0sB+5S0m8+XGasDYYVqG
	AEberAx7Q57lKRPV82bRWoifd7yuJbStlWQNSEZAhA==
X-Received: by 2002:a05:600c:4f0d:b0:439:9828:c450 with SMTP id 5b1f17b1804b1-43ba67082e6mr106879205e9.15.1740988150623;
        Sun, 02 Mar 2025 23:49:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFwmaUSKw8vl4D53Zl5WMKGz2JojfST6NBmM0dcIV/ZRRivWaZoU5wAG5nL/+BYKajcvCKQ9Q==
X-Received: by 2002:a05:600c:4f0d:b0:439:9828:c450 with SMTP id 5b1f17b1804b1-43ba67082e6mr106879025e9.15.1740988150271;
        Sun, 02 Mar 2025 23:49:10 -0800 (PST)
Received: from [10.32.64.164] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43aba5711fcsm185156615e9.28.2025.03.02.23.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Mar 2025 23:49:09 -0800 (PST)
Message-ID: <c30b50066aa0910538bf3cacd046d9c58984fb60.camel@redhat.com>
Subject: Re: [RFC PATCH] vfio/pci: add PCIe TPH to device feature ioctl
From: Philipp Stanner <pstanner@redhat.com>
To: Wathsala Vithanage <wathsala.vithanage@arm.com>, 
	linux-kernel@vger.kernel.org
Cc: nd@arm.com, Alex Williamson <alex.williamson@redhat.com>, Jason
 Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, Yunxiang Li
 <Yunxiang.Li@amd.com>, "Dr. David Alan Gilbert" <linux@treblig.org>, Ankit
 Agrawal <ankita@nvidia.com>, "open list:VFIO DRIVER" <kvm@vger.kernel.org>
Date: Mon, 03 Mar 2025 08:49:08 +0100
In-Reply-To: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
References: <20250221224638.1836909-1-wathsala.vithanage@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2025-02-21 at 22:46 +0000, Wathsala Vithanage wrote:
> Linux v6.13 introduced the PCIe TLP Processing Hints (TPH) feature
> for
> direct cache injection. As described in the relevant patch set [1],
> direct cache injection in supported hardware allows optimal platform
> resource utilization for specific requests on the PCIe bus. This
> feature
> is currently available only for kernel device drivers. However,
> user space applications, especially those whose performance is
> sensitive
> to the latency of inbound writes as seen by a CPU core, may benefit
> from
> using this information (E.g., DPDK cache stashing RFC [2] or an HPC
> application running in a VM).
>=20
> This patch enables configuring of TPH from the user space via
> VFIO_DEVICE_FEATURE IOCLT. It provides an interface to user space
> drivers and VMMs to enable/disable the TPH feature on PCIe devices
> and
> set steering tags in MSI-X or steering-tag table entries using
> VFIO_DEVICE_FEATURE_SET flag or read steering tags from the kernel
> using
> VFIO_DEVICE_FEATURE_GET to operate in device-specific mode.
>=20
> [1]=C2=A0
> lore.kernel.org/linux-pci/20241002165954.128085-1-wei.huang2@amd.com
> [2]=C2=A0
> inbox.dpdk.org/dev/20241021015246.304431-2-wathsala.vithanage@arm.com
>=20
> Signed-off-by: Wathsala Vithanage <wathsala.vithanage@arm.com>
> ---
> =C2=A0drivers/vfio/pci/vfio_pci_core.c | 163
> +++++++++++++++++++++++++++++++
> =C2=A0include/uapi/linux/vfio.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 |=C2=A0 68 +++++++++++++
> =C2=A02 files changed, 231 insertions(+)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci_core.c
> b/drivers/vfio/pci/vfio_pci_core.c
> index 586e49efb81b..d6dd0495b08b 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -29,6 +29,7 @@
> =C2=A0#include <linux/nospec.h>
> =C2=A0#include <linux/sched/mm.h>
> =C2=A0#include <linux/iommufd.h>
> +#include <linux/pci-tph.h>
> =C2=A0#if IS_ENABLED(CONFIG_EEH)
> =C2=A0#include <asm/eeh.h>
> =C2=A0#endif
> @@ -1510,6 +1511,165 @@ static int vfio_pci_core_feature_token(struct
> vfio_device *device, u32 flags,
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
> +static ssize_t vfio_pci_tph_uinfo_dup(struct vfio_pci_tph *tph,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void __user *arg, size_t
> argsz,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct vfio_pci_tph_info
> **info)
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

You can use memdup_array_user() instead of the lines above. It does the
multiplication plus overflow check for you and will make your code more
compact.

> +	if (IS_ERR(info))
> +		return PTR_ERR(info);
> +
> +	return minsz;

see below=E2=80=A6

> +}
> +
> +static int vfio_pci_feature_tph_st_op(struct vfio_pci_core_device
> *vdev,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct vfio_pci_tph *tph,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 void __user *arg, size_t
> argsz)
> +{
> +	int i, mtype, err =3D 0;
> +	u32 cpu_uid;
> +	struct vfio_pci_tph_info *info =3D NULL;
> +	ssize_t data_size =3D vfio_pci_tph_uinfo_dup(tph, arg, argsz,
> &info);
> +
> +	if (data_size <=3D 0)
> +		return data_size;

So it seems you return here in case of an error. However, that would
result in a length of 0 being an error?

I would try to avoid to return 0 for an error whenever possible. That
breaks convention.

How about you return the result value of memdup_array_user() in
=E2=80=A6uinfo_dup()?

The only thing I can't tell is whether tph->count =3D=3D 0 should be
treated as an error. Maybe map it to -EINVAL?


Regards,
P.

> +
> +	for (i =3D 0; i < tph->count; i++) {
> +		if (!(info[i].cpu_id < nr_cpu_ids &&
> cpu_present(info[i].cpu_id))) {
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
> +		info[i].err =3D pcie_tph_get_cpu_st(vdev->pdev, mtype,
> cpu_uid,
> +						=C2=A0 &info[i].st);
> +		if (info[i].err)
> +			continue;
> +
> +		if (tph->flags & VFIO_DEVICE_FEATURE_TPH_SET_ST) {
> +			info[i].err =3D pcie_tph_set_st_entry(vdev-
> >pdev,
> +							=C2=A0=C2=A0=C2=A0
> info[i].index,
> +							=C2=A0=C2=A0=C2=A0
> info[i].st);
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
> +static int vfio_pci_feature_tph_enable(struct vfio_pci_core_device
> *vdev,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct vfio_pci_tph *arg)
> +{
> +	int mode =3D arg->flags & VFIO_TPH_ST_MODE_MASK;
> +
> +	switch (mode) {
> +	case VFIO_TPH_ST_NS_MODE:
> +		return pcie_enable_tph(vdev->pdev,
> PCI_TPH_ST_NS_MODE);
> +
> +	case VFIO_TPH_ST_IV_MODE:
> +		return pcie_enable_tph(vdev->pdev,
> PCI_TPH_ST_IV_MODE);
> +
> +	case VFIO_TPH_ST_DS_MODE:
> +		return pcie_enable_tph(vdev->pdev,
> PCI_TPH_ST_DS_MODE);
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +}
> +
> +static int vfio_pci_feature_tph_disable(struct vfio_pci_core_device
> *vdev)
> +{
> +	pcie_disable_tph(vdev->pdev);
> +	return 0;
> +}
> +
> +static int vfio_pci_feature_tph_prepare(struct vfio_pci_tph __user
> *arg,
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
> +		return (flags & VFIO_DEVICE_FEATURE_SET) ? 0 : -
> EINVAL;
> +
> +	case VFIO_DEVICE_FEATURE_TPH_GET_ST:
> +		return (flags & VFIO_DEVICE_FEATURE_GET) ? 0 : -
> EINVAL;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static int vfio_pci_core_feature_tph(struct vfio_device *device, u32
> flags,
> +				=C2=A0=C2=A0=C2=A0=C2=A0 struct vfio_pci_tph __user
> *arg,
> +				=C2=A0=C2=A0=C2=A0=C2=A0 size_t argsz)
> +{
> +	u32 op;
> +	struct vfio_pci_tph tph;
> +	void __user *uinfo;
> +	size_t infosz;
> +	struct vfio_pci_core_device *vdev =3D
> +		container_of(device, struct vfio_pci_core_device,
> vdev);
> +	int err =3D vfio_pci_feature_tph_prepare(arg, argsz, flags,
> &tph);
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
> +		uinfo =3D (u8 *)(arg) + offsetof(struct vfio_pci_tph,
> info);
> +		infosz =3D argsz - sizeof(struct vfio_pci_tph);
> +		return vfio_pci_feature_tph_st_op(vdev, &tph, uinfo,
> infosz);
> +
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> =C2=A0int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32
> flags,
> =C2=A0				void __user *arg, size_t argsz)
> =C2=A0{
> @@ -1523,6 +1683,9 @@ int vfio_pci_core_ioctl_feature(struct
> vfio_device *device, u32 flags,
> =C2=A0		return vfio_pci_core_pm_exit(device, flags, arg,
> argsz);
> =C2=A0	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
> =C2=A0		return vfio_pci_core_feature_token(device, flags,
> arg, argsz);
> +	case VFIO_DEVICE_FEATURE_PCI_TPH:
> +		return vfio_pci_core_feature_tph(device, flags,
> +						 arg, argsz);
> =C2=A0	default:
> =C2=A0		return -ENOTTY;
> =C2=A0	}
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index c8dbf8219c4f..608d57dfe279 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1458,6 +1458,74 @@ struct vfio_device_feature_bus_master {
> =C2=A0};
> =C2=A0#define VFIO_DEVICE_FEATURE_BUS_MASTER 10
> =C2=A0
> +/*
> + * Upon VFIO_DEVICE_FEATURE_SET, enable or disable PCIe TPH or set
> steering tags
> + * on the device. Data provided when setting this feature is a __u32
> with the
> + * following flags. VFIO_DEVICE_FEATURE_TPH_ENABLE enables PCIe TPH
> in
> + * no-steering-tag, interrupt-vector, or device-specific mode when
> feature flags
> + * VFIO_TPH_ST_NS_MODE, VFIO_TPH_ST_IV_MODE, and VFIO_TPH_ST_DS_MODE
> are set
> + * respectively.
> + * VFIO_DEVICE_FEATURE_TPH_DISABLE disables PCIe TPH on the device.
> + * VFIO_DEVICE_FEATURE_TPH_SET_ST set steering tags on a device at
> an index in
> + * MSI-X or ST-table depending on the VFIO_TPH_ST_x_MODE flag used
> and device
> + * capabilities. The caller can set multiple steering tags by
> passing an array
> + * of vfio_pci_tph_info objects containing cpu_id, cache_level, and
> + * MSI-X/ST-table index. The caller can also set the intended memory
> type and
> + * the processing hint by setting VFIO_TPH_MEM_TYPE_x and
> VFIO_TPH_HINT_x flags,
> + * respectively. The return value for each vfio_pci_tph_info object
> is stored in
> + * err, with the steering-tag set on the device and the ph_ignore
> status bit
> + * resulting from the steering-tag lookup operation. If err < 0, the
> values
> + * stored in the st and ph_ignore fields should be considered
> invalid.
> + *
> + * Upon VFIO_DEVICE_FEATURE_GET,=C2=A0 return steering tags to the
> caller.
> + * VFIO_DEVICE_FEATURE_TPH_GET_ST returns steering tags to the
> caller.
> + * The return values per vfio_pci_tph_info object are stored in the
> st,
> + * ph_ignore, and err fields.
> + */
> +struct vfio_pci_tph_info {
> +	/* in */
> +	__u32 cpu_id;
> +	__u32 cache_level;
> +	__u8=C2=A0 flags;
> +#define VFIO_TPH_MEM_TYPE_MASK		0x1
> +#define VFIO_TPH_MEM_TYPE_SHIFT		0
> +#define VFIO_TPH_MEM_TYPE_VMEM		0	/* Request volatile
> memory ST */
> +#define VFIO_TPH_MEM_TYPE_PMEM		1	/* Request
> persistent memory ST */
> +
> +#define VFIO_TPH_HINT_MASK		0x3
> +#define VFIO_TPH_HINT_SHIFT		1
> +#define VFIO_TPH_HINT_BIDIR		0
> +#define VFIO_TPH_HINT_REQSTR		(1 << VFIO_TPH_HINT_SHIFT)
> +#define VFIO_TPH_HINT_TARGET		(2 << VFIO_TPH_HINT_SHIFT)
> +#define VFIO_TPH_HINT_TARGET_PRIO	(3 << VFIO_TPH_HINT_SHIFT)
> +	__u16 index;			/* MSI-X/ST-table index to
> set ST */
> +	/* out */
> +	__u16 st;			/* Steering-Tag */
> +	__u8=C2=A0 ph_ignore;		/* Processing hint was
> ignored by */
> +	__s32 err;			/* Error on getting/setting
> Steering-Tag*/
> +};
> +
> +struct vfio_pci_tph {
> +	__u32 argsz;			/* Size of vfio_pci_tph and
> info[] */
> +	__u32 flags;
> +#define VFIO_DEVICE_FEATURE_TPH_OP_MASK		0x7
> +#define VFIO_DEVICE_FEATURE_TPH_OP_SHIFT	3
> +#define VFIO_DEVICE_FEATURE_TPH_ENABLE		0	/* Enable
> TPH on device */
> +#define VFIO_DEVICE_FEATURE_TPH_DISABLE	1	/* Disable
> TPH on device */
> +#define VFIO_DEVICE_FEATURE_TPH_GET_ST		2	/* Get
> steering-tags */
> +#define VFIO_DEVICE_FEATURE_TPH_SET_ST		4	/* Set
> steering-rags */
> +
> +#define	VFIO_TPH_ST_MODE_MASK	(0x3 <<
> VFIO_DEVICE_FEATURE_TPH_OP_SHIFT)
> +#define	VFIO_TPH_ST_NS_MODE	(0 <<
> VFIO_DEVICE_FEATURE_TPH_OP_SHIFT)
> +#define	VFIO_TPH_ST_IV_MODE	(1 <<
> VFIO_DEVICE_FEATURE_TPH_OP_SHIFT)
> +#define	VFIO_TPH_ST_DS_MODE	(2 <<
> VFIO_DEVICE_FEATURE_TPH_OP_SHIFT)
> +	__u32 count;				/* Number of entries
> in info[] */
> +	struct vfio_pci_tph_info info[];
> +#define VFIO_TPH_INFO_MAX	64		/* Max entries
> allowed in info[] */
> +};
> +
> +#define VFIO_DEVICE_FEATURE_PCI_TPH 11
> +
> =C2=A0/* -------- API for Type1 VFIO IOMMU -------- */
> =C2=A0
> =C2=A0/**


