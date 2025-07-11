Return-Path: <kvm+bounces-52141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A837B01B62
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 14:02:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BBBE1CA2FD8
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 12:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A630E29AAFC;
	Fri, 11 Jul 2025 12:01:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A186298987
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 12:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752235318; cv=none; b=cQZpOC5FnxgFWy9HLtG/wH6b4F1b2tonFdWcKdqxuPILjISRLoWtAU7IV0IcMJyViuR8xwXMgr/3jJBiDtqyhI6YkSG4tCU67rqL6XgY38GHN7EjeU/Q2V3c1ZuCeU4cfwozARbKPno5wsFJcgfhU3+8oKXgEQ5H3xsicCu/i08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752235318; c=relaxed/simple;
	bh=oecJucWId5/o+b5zJ8gUDvX8Qe4MVoaRwM3oIE0QEB0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c2x6FjKQLbb6mlSeOGzV8Fneyk7XmeN4ibGeXfBxdpM2lZLGffygft1EoMFox6PFmO0f2BJ9IKY3L+kNHwc8gRYjHGDgbWrmy0AFuZvM7aBP2KhcudIr0lNA28HQatdKj/izTWWvVD01DmXkEXoIES48Y6lS4PCCo0Ezo26t09o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4bdqzf4Z5FztSZT;
	Fri, 11 Jul 2025 20:00:46 +0800 (CST)
Received: from dggpemf200014.china.huawei.com (unknown [7.185.36.229])
	by mail.maildlp.com (Postfix) with ESMTPS id C6C57180489;
	Fri, 11 Jul 2025 20:01:52 +0800 (CST)
Received: from frapeml500008.china.huawei.com (7.182.85.71) by
 dggpemf200014.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 11 Jul 2025 20:01:51 +0800
Received: from frapeml500008.china.huawei.com ([7.182.85.71]) by
 frapeml500008.china.huawei.com ([7.182.85.71]) with mapi id 15.01.2507.039;
 Fri, 11 Jul 2025 14:01:50 +0200
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Ankit Agrawal <ankita@nvidia.com>,
	"Brett Creeley" <brett.creeley@amd.com>, Giovanni Cabiddu
	<giovanni.cabiddu@intel.com>, Kevin Tian <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, liulongfang
	<liulongfang@huawei.com>, "qat-linux@intel.com" <qat-linux@intel.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, Xin Zeng
	<xin.zeng@intel.com>, Yishai Hadas <yishaih@nvidia.com>
CC: Alex Williamson <alex.williamson@redhat.com>, Matthew Rosato
	<mjrosato@linux.ibm.com>, Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Terrence Xu
	<terrence.xu@intel.com>, Yanting Jiang <yanting.jiang@intel.com>, Yi Liu
	<yi.l.liu@intel.com>, Zhenzhong Duan <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v2] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v2] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHb8a+fxqosUj9FP0eBNap5oqWbxbQsz5tg
Date: Fri, 11 Jul 2025 12:01:49 +0000
Message-ID: <30449f7531ae42439136316321b3d60e@huawei.com>
References: <0-v2-470f044801ef+a887e-vfio_token_jgg@nvidia.com>
In-Reply-To: <0-v2-470f044801ef+a887e-vfio_token_jgg@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0



> -----Original Message-----
> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, July 10, 2025 4:30 PM
> To: Ankit Agrawal <ankita@nvidia.com>; Brett Creeley
> <brett.creeley@amd.com>; Giovanni Cabiddu
> <giovanni.cabiddu@intel.com>; Kevin Tian <kevin.tian@intel.com>;
> kvm@vger.kernel.org; liulongfang <liulongfang@huawei.com>; qat-
> linux@intel.com; virtualization@lists.linux.dev; Xin Zeng
> <xin.zeng@intel.com>; Yishai Hadas <yishaih@nvidia.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>; Matthew Rosato
> <mjrosato@linux.ibm.com>; Nicolin Chen <nicolinc@nvidia.com>;
> patches@lists.linux.dev; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; Terrence Xu
> <terrence.xu@intel.com>; Yanting Jiang <yanting.jiang@intel.com>; Yi Liu
> <yi.l.liu@intel.com>; Zhenzhong Duan <zhenzhong.duan@intel.com>
> Subject: [PATCH v2] vfio/pci: Do vf_token checks for
> VFIO_DEVICE_BIND_IOMMUFD
>=20
> This was missed during the initial implementation. The VFIO PCI encodes
> the vf_token inside the device name when opening the device from the
> group
> FD, something like:
>=20
>   "0000:04:10.0 vf_token=3Dbd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"
>=20
> This is used to control access to a VF unless there is co-ordination with
> the owner of the PF.
>=20
> Since we no longer have a device name, pass the token directly through
> VFIO_DEVICE_BIND_IOMMUFD using an optional field indicated by
> VFIO_DEVICE_BIND_TOKEN.
>=20
> Fixes: 5fcc26969a16 ("vfio: Add VFIO_DEVICE_BIND_IOMMUFD")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/device_cdev.c                    | 38 +++++++++++++++++--
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  1 +
>  drivers/vfio/pci/mlx5/main.c                  |  1 +
>  drivers/vfio/pci/nvgrace-gpu/main.c           |  2 +
>  drivers/vfio/pci/pds/vfio_dev.c               |  1 +
>  drivers/vfio/pci/qat/main.c                   |  1 +
>  drivers/vfio/pci/vfio_pci.c                   |  1 +
>  drivers/vfio/pci/vfio_pci_core.c              | 22 +++++++----
>  drivers/vfio/pci/virtio/main.c                |  3 ++
>  include/linux/vfio.h                          |  4 ++
>  include/linux/vfio_pci_core.h                 |  2 +
>  include/uapi/linux/vfio.h                     | 12 +++++-
>  12 files changed, 76 insertions(+), 12 deletions(-)
>=20
> v2:
>  - Revise VFIO_DEVICE_BIND_TOKEN -> VFIO_DEVICE_BIND_FLAG_TOKEN
>  - Call the match_token_uuid through ops instead of directly
>  - update comments/style
> v1: https://patch.msgid.link/r/0-v1-8639f9aed215+853-
> vfio_token_jgg@nvidia.com
>=20
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index 281a8dc3ed4974..1c96d3627be24b 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -60,22 +60,50 @@ static void vfio_df_get_kvm_safe(struct
> vfio_device_file *df)
>  	spin_unlock(&df->kvm_ref_lock);
>  }
>=20
> +static int vfio_df_check_token(struct vfio_device *device,
> +			       const struct vfio_device_bind_iommufd *bind)
> +{
> +	uuid_t uuid;
> +
> +	if (!device->ops->match_token_uuid) {
> +		if (bind->flags & VFIO_DEVICE_BIND_FLAG_TOKEN)
> +			return -EINVAL;
> +		return 0;
> +	}
> +
> +	if (!(bind->flags & VFIO_DEVICE_BIND_FLAG_TOKEN))
> +		return device->ops->match_token_uuid(device, NULL);
> +
> +	if (copy_from_user(&uuid, u64_to_user_ptr(bind->token_uuid_ptr),
> +			   sizeof(uuid)))
> +		return -EFAULT;
> +	return device->ops->match_token_uuid(device, &uuid);
> +}
> +
>  long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
>  				struct vfio_device_bind_iommufd __user
> *arg)
>  {
> +	const u32 VALID_FLAGS =3D VFIO_DEVICE_BIND_FLAG_TOKEN;
>  	struct vfio_device *device =3D df->device;
>  	struct vfio_device_bind_iommufd bind;
>  	unsigned long minsz;
> +	u32 user_size;
>  	int ret;
>=20
>  	static_assert(__same_type(arg->out_devid, df->devid));
>=20
>  	minsz =3D offsetofend(struct vfio_device_bind_iommufd, out_devid);
>=20
> -	if (copy_from_user(&bind, arg, minsz))
> -		return -EFAULT;
> +	ret =3D get_user(user_size, &arg->argsz);
> +	if (ret)
> +		return ret;
> +	if (bind.argsz < minsz)

The above check should use user_size.

With that fixed, I did a basic sanity testing with a latest Qemu(no BIND_FL=
AG_TOKEN flag),
assigning a vf to a Guest. Seems to be OK.  No regression observed.

FWIW:
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer

> +		return -EINVAL;
> +	ret =3D copy_struct_from_user(&bind, minsz, arg, user_size);
> +	if (ret)
> +		return ret;
>=20
> -	if (bind.argsz < minsz || bind.flags || bind.iommufd < 0)
> +	if (bind.iommufd < 0 || bind.flags & ~VALID_FLAGS)
>  		return -EINVAL;
>=20
>  	/* BIND_IOMMUFD only allowed for cdev fds */
> @@ -93,6 +121,10 @@ long vfio_df_ioctl_bind_iommufd(struct
> vfio_device_file *df,
>  		goto out_unlock;
>  	}
>=20
> +	ret =3D vfio_df_check_token(device, &bind);
> +	if (ret)
> +		return ret;
> +
>  	df->iommufd =3D iommufd_ctx_from_fd(bind.iommufd);
>  	if (IS_ERR(df->iommufd)) {
>  		ret =3D PTR_ERR(df->iommufd);
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 2149f49aeec7f8..397f5e44513639 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1583,6 +1583,7 @@ static const struct vfio_device_ops
> hisi_acc_vfio_pci_ops =3D {
>  	.mmap =3D vfio_pci_core_mmap,
>  	.request =3D vfio_pci_core_request,
>  	.match =3D vfio_pci_core_match,
> +	.match_token_uuid =3D vfio_pci_core_match_token_uuid,
>  	.bind_iommufd =3D vfio_iommufd_physical_bind,
>  	.unbind_iommufd =3D vfio_iommufd_physical_unbind,
>  	.attach_ioas =3D vfio_iommufd_physical_attach_ioas,
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index 93f894fe60d221..7ec47e736a8e5a 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -1372,6 +1372,7 @@ static const struct vfio_device_ops
> mlx5vf_pci_ops =3D {
>  	.mmap =3D vfio_pci_core_mmap,
>  	.request =3D vfio_pci_core_request,
>  	.match =3D vfio_pci_core_match,
> +	.match_token_uuid =3D vfio_pci_core_match_token_uuid,
>  	.bind_iommufd =3D vfio_iommufd_physical_bind,
>  	.unbind_iommufd =3D vfio_iommufd_physical_unbind,
>  	.attach_ioas =3D vfio_iommufd_physical_attach_ioas,
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgra=
ce-
> gpu/main.c
> index e5ac39c4cc6b6f..d95761dcdd58c4 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -696,6 +696,7 @@ static const struct vfio_device_ops
> nvgrace_gpu_pci_ops =3D {
>  	.mmap		=3D nvgrace_gpu_mmap,
>  	.request	=3D vfio_pci_core_request,
>  	.match		=3D vfio_pci_core_match,
> +	.match_token_uuid =3D vfio_pci_core_match_token_uuid,
>  	.bind_iommufd	=3D vfio_iommufd_physical_bind,
>  	.unbind_iommufd	=3D vfio_iommufd_physical_unbind,
>  	.attach_ioas	=3D vfio_iommufd_physical_attach_ioas,
> @@ -715,6 +716,7 @@ static const struct vfio_device_ops
> nvgrace_gpu_pci_core_ops =3D {
>  	.mmap		=3D vfio_pci_core_mmap,
>  	.request	=3D vfio_pci_core_request,
>  	.match		=3D vfio_pci_core_match,
> +	.match_token_uuid =3D vfio_pci_core_match_token_uuid,
>  	.bind_iommufd	=3D vfio_iommufd_physical_bind,
>  	.unbind_iommufd	=3D vfio_iommufd_physical_unbind,
>  	.attach_ioas	=3D vfio_iommufd_physical_attach_ioas,
> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_=
dev.c
> index 76a80ae7087b51..5731e6856deaf1 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.c
> +++ b/drivers/vfio/pci/pds/vfio_dev.c
> @@ -201,6 +201,7 @@ static const struct vfio_device_ops pds_vfio_ops =3D =
{
>  	.mmap =3D vfio_pci_core_mmap,
>  	.request =3D vfio_pci_core_request,
>  	.match =3D vfio_pci_core_match,
> +	.match_token_uuid =3D vfio_pci_core_match_token_uuid,
>  	.bind_iommufd =3D vfio_iommufd_physical_bind,
>  	.unbind_iommufd =3D vfio_iommufd_physical_unbind,
>  	.attach_ioas =3D vfio_iommufd_physical_attach_ioas,
> diff --git a/drivers/vfio/pci/qat/main.c b/drivers/vfio/pci/qat/main.c
> index 845ed15b67718c..5cce6b0b8d2f3e 100644
> --- a/drivers/vfio/pci/qat/main.c
> +++ b/drivers/vfio/pci/qat/main.c
> @@ -614,6 +614,7 @@ static const struct vfio_device_ops qat_vf_pci_ops =
=3D
> {
>  	.mmap =3D vfio_pci_core_mmap,
>  	.request =3D vfio_pci_core_request,
>  	.match =3D vfio_pci_core_match,
> +	.match_token_uuid =3D vfio_pci_core_match_token_uuid,
>  	.bind_iommufd =3D vfio_iommufd_physical_bind,
>  	.unbind_iommufd =3D vfio_iommufd_physical_unbind,
>  	.attach_ioas =3D vfio_iommufd_physical_attach_ioas,
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 5ba39f7623bb76..ac10f14417f2f3 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -138,6 +138,7 @@ static const struct vfio_device_ops vfio_pci_ops =3D =
{
>  	.mmap		=3D vfio_pci_core_mmap,
>  	.request	=3D vfio_pci_core_request,
>  	.match		=3D vfio_pci_core_match,
> +	.match_token_uuid =3D vfio_pci_core_match_token_uuid,
>  	.bind_iommufd	=3D vfio_iommufd_physical_bind,
>  	.unbind_iommufd	=3D vfio_iommufd_physical_unbind,
>  	.attach_ioas	=3D vfio_iommufd_physical_attach_ioas,
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci=
_core.c
> index 6328c3a05bcdd4..d39b0201d910fd 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1821,9 +1821,13 @@ void vfio_pci_core_request(struct vfio_device
> *core_vdev, unsigned int count)
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_request);
>=20
> -static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
> -				      bool vf_token, uuid_t *uuid)
> +int vfio_pci_core_match_token_uuid(struct vfio_device *core_vdev,
> +				   const uuid_t *uuid)
> +
>  {
> +	struct vfio_pci_core_device *vdev =3D
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +
>  	/*
>  	 * There's always some degree of trust or collaboration between SR-
> IOV
>  	 * PF and VFs, even if just that the PF hosts the SR-IOV capability
> and
> @@ -1854,7 +1858,7 @@ static int vfio_pci_validate_vf_token(struct
> vfio_pci_core_device *vdev,
>  		bool match;
>=20
>  		if (!pf_vdev) {
> -			if (!vf_token)
> +			if (!uuid)
>  				return 0; /* PF is not vfio-pci, no VF token */
>=20
>  			pci_info_ratelimited(vdev->pdev,
> @@ -1862,7 +1866,7 @@ static int vfio_pci_validate_vf_token(struct
> vfio_pci_core_device *vdev,
>  			return -EINVAL;
>  		}
>=20
> -		if (!vf_token) {
> +		if (!uuid) {
>  			pci_info_ratelimited(vdev->pdev,
>  				"VF token required to access device\n");
>  			return -EACCES;
> @@ -1880,7 +1884,7 @@ static int vfio_pci_validate_vf_token(struct
> vfio_pci_core_device *vdev,
>  	} else if (vdev->vf_token) {
>  		mutex_lock(&vdev->vf_token->lock);
>  		if (vdev->vf_token->users) {
> -			if (!vf_token) {
> +			if (!uuid) {
>  				mutex_unlock(&vdev->vf_token->lock);
>  				pci_info_ratelimited(vdev->pdev,
>  					"VF token required to access
> device\n");
> @@ -1893,12 +1897,12 @@ static int vfio_pci_validate_vf_token(struct
> vfio_pci_core_device *vdev,
>  					"Incorrect VF token provided for
> device\n");
>  				return -EACCES;
>  			}
> -		} else if (vf_token) {
> +		} else if (uuid) {
>  			uuid_copy(&vdev->vf_token->uuid, uuid);
>  		}
>=20
>  		mutex_unlock(&vdev->vf_token->lock);
> -	} else if (vf_token) {
> +	} else if (uuid) {
>  		pci_info_ratelimited(vdev->pdev,
>  			"VF token incorrectly provided, not a PF or VF\n");
>  		return -EINVAL;
> @@ -1906,6 +1910,7 @@ static int vfio_pci_validate_vf_token(struct
> vfio_pci_core_device *vdev,
>=20
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(vfio_pci_core_match_token_uuid);
>=20
>  #define VF_TOKEN_ARG "vf_token=3D"
>=20
> @@ -1952,7 +1957,8 @@ int vfio_pci_core_match(struct vfio_device
> *core_vdev, char *buf)
>  		}
>  	}
>=20
> -	ret =3D vfio_pci_validate_vf_token(vdev, vf_token, &uuid);
> +	ret =3D core_vdev->ops->match_token_uuid(core_vdev,
> +					       vf_token ? &uuid : NULL);
>  	if (ret)
>  		return ret;
>=20
> diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/mai=
n.c
> index 515fe1b9f94d80..8084f3e36a9f70 100644
> --- a/drivers/vfio/pci/virtio/main.c
> +++ b/drivers/vfio/pci/virtio/main.c
> @@ -94,6 +94,7 @@ static const struct vfio_device_ops
> virtiovf_vfio_pci_lm_ops =3D {
>  	.mmap =3D vfio_pci_core_mmap,
>  	.request =3D vfio_pci_core_request,
>  	.match =3D vfio_pci_core_match,
> +	.match_token_uuid =3D vfio_pci_core_match_token_uuid,
>  	.bind_iommufd =3D vfio_iommufd_physical_bind,
>  	.unbind_iommufd =3D vfio_iommufd_physical_unbind,
>  	.attach_ioas =3D vfio_iommufd_physical_attach_ioas,
> @@ -114,6 +115,7 @@ static const struct vfio_device_ops
> virtiovf_vfio_pci_tran_lm_ops =3D {
>  	.mmap =3D vfio_pci_core_mmap,
>  	.request =3D vfio_pci_core_request,
>  	.match =3D vfio_pci_core_match,
> +	.match_token_uuid =3D vfio_pci_core_match_token_uuid,
>  	.bind_iommufd =3D vfio_iommufd_physical_bind,
>  	.unbind_iommufd =3D vfio_iommufd_physical_unbind,
>  	.attach_ioas =3D vfio_iommufd_physical_attach_ioas,
> @@ -134,6 +136,7 @@ static const struct vfio_device_ops
> virtiovf_vfio_pci_ops =3D {
>  	.mmap =3D vfio_pci_core_mmap,
>  	.request =3D vfio_pci_core_request,
>  	.match =3D vfio_pci_core_match,
> +	.match_token_uuid =3D vfio_pci_core_match_token_uuid,
>  	.bind_iommufd =3D vfio_iommufd_physical_bind,
>  	.unbind_iommufd =3D vfio_iommufd_physical_unbind,
>  	.attach_ioas =3D vfio_iommufd_physical_attach_ioas,
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 707b00772ce1ff..eb563f538dee51 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -105,6 +105,9 @@ struct vfio_device {
>   * @match: Optional device name match callback (return: 0 for no-match,
> >0 for
>   *         match, -errno for abort (ex. match with insufficient or incor=
rect
>   *         additional args)
> + * @match_token_uuid: Optional device token match/validation. Return 0
> + *         if the uuid is valid for the device, -errno otherwise. uuid i=
s NULL
> + *         if none was provided.
>   * @dma_unmap: Called when userspace unmaps IOVA from the container
>   *             this device is attached to.
>   * @device_feature: Optional, fill in the VFIO_DEVICE_FEATURE ioctl
> @@ -132,6 +135,7 @@ struct vfio_device_ops {
>  	int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct
> *vma);
>  	void	(*request)(struct vfio_device *vdev, unsigned int count);
>  	int	(*match)(struct vfio_device *vdev, char *buf);
> +	int	(*match_token_uuid)(struct vfio_device *vdev, const uuid_t
> *uuid);
>  	void	(*dma_unmap)(struct vfio_device *vdev, u64 iova, u64
> length);
>  	int	(*device_feature)(struct vfio_device *device, u32 flags,
>  				  void __user *arg, size_t argsz);
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.=
h
> index fbb472dd99b361..f541044e42a2ad 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -122,6 +122,8 @@ ssize_t vfio_pci_core_write(struct vfio_device
> *core_vdev, const char __user *bu
>  int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct
> vm_area_struct *vma);
>  void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int
> count);
>  int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
> +int vfio_pci_core_match_token_uuid(struct vfio_device *core_vdev,
> +				   const uuid_t *uuid);
>  int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
>  void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
>  void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 5764f315137f99..75100bf009baf5 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -905,10 +905,12 @@ struct vfio_device_feature {
>   * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 18,
>   *				   struct vfio_device_bind_iommufd)
>   * @argsz:	 User filled size of this data.
> - * @flags:	 Must be 0.
> + * @flags:	 Must be 0 or a bit flags of VFIO_DEVICE_BIND_*
>   * @iommufd:	 iommufd to bind.
>   * @out_devid:	 The device id generated by this bind. devid is a
> handle for
>   *		 this device/iommufd bond and can be used in IOMMUFD
> commands.
> + * @token_uuid_ptr: Valid if VFIO_DEVICE_BIND_FLAG_TOKEN. Points to a
> 16 byte
> + *                  UUID in the same format as
> VFIO_DEVICE_FEATURE_PCI_VF_TOKEN.
>   *
>   * Bind a vfio_device to the specified iommufd.
>   *
> @@ -917,13 +919,21 @@ struct vfio_device_feature {
>   *
>   * Unbind is automatically conducted when device fd is closed.
>   *
> + * A token is sometimes required to open the device, unless this is know=
n
> to be
> + * needed VFIO_DEVICE_BIND_FLAG_TOKEN should not be set and
> token_uuid_ptr is
> + * ignored. The only case today is a PF/VF relationship where the VF bin=
d
> must
> + * be provided the same token as VFIO_DEVICE_FEATURE_PCI_VF_TOKEN
> provided to
> + * the PF.
> + *
>   * Return: 0 on success, -errno on failure.
>   */
>  struct vfio_device_bind_iommufd {
>  	__u32		argsz;
>  	__u32		flags;
> +#define VFIO_DEVICE_BIND_FLAG_TOKEN (1 << 0)
>  	__s32		iommufd;
>  	__u32		out_devid;
> +	__aligned_u64	token_uuid_ptr;
>  };
>=20
>  #define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE +
> 18)
>=20
> base-commit: 3e2a9811f6a9cefd310cc33cab73d5435b4a4caa
> --
> 2.43.0


