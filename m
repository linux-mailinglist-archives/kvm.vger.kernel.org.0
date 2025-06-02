Return-Path: <kvm+bounces-48169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DC56AACAE37
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 14:43:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7FB5A7A7C77
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 12:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0CA521ABCB;
	Mon,  2 Jun 2025 12:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7emBN1D"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE6028EC;
	Mon,  2 Jun 2025 12:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748868207; cv=none; b=Arym7EM+DVgA55DkHDTe7gnAJueERBhujBaqBHWk3FItNkJdnwJNhSVkL3bPauZ5Hmr3x23qutQqROsRHGdKTpyGnqqrJKDUw32VYAtEbh5Y/33d5mId7tHu0sK9IaQEQus/holAvQvOSZpISH/cXNkPchdX48UuoR+R4v5rsNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748868207; c=relaxed/simple;
	bh=M6LDVbtStMrFljOaOf+mHoY8Wc3iP1Za9Pz7obGiIR0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BnsS76s+s0twv7RdtLkXRebObSQt0Kpy33QjEYsbVsy1A5g03He2FuBNyySAnNP2QQrxBO4AMa+70R1vXyHKh+tp1upyP+9XcToAHSJwoNXT29dkEBDEYtdk8oMCrQrm6OQFiJ9OLoadz3psyAcm8mHrzrZMX+luEoeEyTKqV0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V7emBN1D; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7750AC4CEEB;
	Mon,  2 Jun 2025 12:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748868207;
	bh=M6LDVbtStMrFljOaOf+mHoY8Wc3iP1Za9Pz7obGiIR0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=V7emBN1DTn/BdreyF48omyyY5HquD4e3+BG3qXe6/FkYUvF1MajlqGEBgNtJEkuNy
	 t3gUfvBr9HaS0UXytdOaxhHlEhndd48jqkq+u2O10jhbN7iF8cNbBzosYiIIJoK/MI
	 O6FsQHx7mJkQQp1y+HpDlBM1eF3KEjXP2Kh5bxQ3TF3qgcbGL3BmyqmGhAh9/OTtLT
	 f1rfCN9BT48rQYKV0lzqFTtrSiN6uv003iw1TWY/rsAkm4iljcH6CJvi5DAiZW8/Gp
	 dEHTA5FgGMr1QBxmoEtvBUvmSnzWEPkfzb9z3p75qcwgRxw/fBzg7u+0FpenxuKr//
	 rX2+rlIkEUdBw==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Xu Yilun <yilun.xu@linux.intel.com>, kvm@vger.kernel.org,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	jgg@nvidia.com, dan.j.williams@intel.com, aik@amd.com,
	linux-coco@lists.linux.dev
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, vivek.kasireddy@intel.com,
	yilun.xu@intel.com, yilun.xu@linux.intel.com,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, tao1.su@intel.com,
	linux-pci@vger.kernel.org, zhiw@nvidia.com, simona.vetter@ffwll.ch,
	shameerali.kolothum.thodi@huawei.com, iommu@lists.linux.dev,
	kevin.tian@intel.com
Subject: Re: [RFC PATCH 17/30] iommufd/device: Add TSM Bind/Unbind for TIO
 support
In-Reply-To: <20250529053513.1592088-18-yilun.xu@linux.intel.com>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
 <20250529053513.1592088-18-yilun.xu@linux.intel.com>
Date: Mon, 02 Jun 2025 18:13:16 +0530
Message-ID: <yq5awm9ujouz.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Xu Yilun <yilun.xu@linux.intel.com> writes:

....

> +/**
> + * iommufd_device_tsm_bind - Move a device to TSM Bind state
> + * @idev: device to attach
> + * @vdev_id: Input a IOMMUFD_OBJ_VDEVICE
> + *
> + * This configures for device Confidential Computing(CC), and moves the =
device
> + * to the TSM Bind state. Once this completes the device is locked down =
(TDISP
> + * CONFIG_LOCKED or RUN), waiting for guest's attestation.
> + *
> + * This function is undone by calling iommufd_device_tsm_unbind().
> + */
> +int iommufd_device_tsm_bind(struct iommufd_device *idev, u32 vdevice_id)
> +{
> +	struct iommufd_vdevice *vdev;
> +	int rc;
> +
> +	if (!dev_is_pci(idev->dev))
> +		return -ENODEV;
> +
> +	vdev =3D container_of(iommufd_get_object(idev->ictx, vdevice_id, IOMMUF=
D_OBJ_VDEVICE),
> +			    struct iommufd_vdevice, obj);
> +	if (IS_ERR(vdev))
> +		return PTR_ERR(vdev);
> +
> +	if (vdev->dev !=3D idev->dev) {
> +		rc =3D -EINVAL;
> +		goto out_put_vdev;
> +	}
> +
> +	mutex_lock(&idev->igroup->lock);
> +	if (idev->vdev) {
> +		rc =3D -EEXIST;
> +		goto out_unlock;
> +	}
> +
> +	rc =3D iommufd_vdevice_tsm_bind(vdev);
> +	if (rc)
> +		goto out_unlock;
> +
> +	idev->vdev =3D vdev;
> +	refcount_inc(&vdev->obj.users);
> +	mutex_unlock(&idev->igroup->lock);
> +
> +	/*
> +	 * Pairs with iommufd_device_tsm_unbind() - catches caller bugs attempt=
ing
> +	 * to destroy a bound device.
> +	 */
> +	refcount_inc(&idev->obj.users);
>

Do we really need this refcount_inc? As I understand it, the objects
aren't being pinned directly. Instead, the reference count seems to be
used more as a way to establish an object hierarchy, ensuring that
objects are freed in the correct order.

In vfio_pci_core_close_device(), you=E2=80=99re decrementing the reference,=
 and
on the iommufd side, we=E2=80=99re covered because the VFIO bind operation =
takes
a file reference (fget)=E2=80=94so iommufd_fops_release() won=E2=80=99t be =
called
prematurely.

Wouldn=E2=80=99t it be simpler to skip the reference count increment altoge=
ther
and just call tsm_unbind in the virtual device=E2=80=99s destroy callback?
(iommufd_vdevice_destroy())

> +	goto out_put_vdev;
> +
> +out_unlock:
> +	mutex_unlock(&idev->igroup->lock);
> +out_put_vdev:
> +	iommufd_put_object(idev->ictx, &vdev->obj);
> +	return rc;
> +}
> +EXPORT_SYMBOL_NS_GPL(iommufd_device_tsm_bind, "IOMMUFD");

-aneesh

