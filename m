Return-Path: <kvm+bounces-53381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B43F9B10CD1
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 16:11:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32A4D3B2D54
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 14:09:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 949D42C2ACE;
	Thu, 24 Jul 2025 14:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UJhS/Z4u"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09A772625
	for <kvm@vger.kernel.org>; Thu, 24 Jul 2025 14:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753366184; cv=none; b=SBvnVh2cVDhEroQHXOW8PMBuYt+LXBK16RQVcu2xT9YXkYYFjGbEC5uetDejrbEDc1W67bFOPfqi3MxZtAwC/oS6vatg4wyYKGbtbNTOPG1b+y7Yv2YPiPvqedY7jjz7s9zLxgYzSTIwjEmQ5EdiPdUHJGBi52wZqNlFZFsI/oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753366184; c=relaxed/simple;
	bh=WxI+PjLJREaIH/wZfYF3sAD2XPJXx8Hz+BWWBlQrgnk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tlPxBLo7/c2/oIGqUUbaR/yhgZ0Avkt+l3rgisOudKwFA/QuFtGxVRXAN/JHC3//qfMCag1WI/uBrNEmK3BbMVW3gMo+/T0sTuTr4DYB4DaSRiEHPghr5Wl+xeIpzzIkhzYijrQ+4S7Dpmq5kzpwMqUW2qz7BxHcWJZTO1ofVoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UJhS/Z4u; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D01C4CEED;
	Thu, 24 Jul 2025 14:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753366184;
	bh=WxI+PjLJREaIH/wZfYF3sAD2XPJXx8Hz+BWWBlQrgnk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=UJhS/Z4um+G/fbAt0xSy06JgchYu1cOyInMogo4kXpfo0hRjUaBq2auSuE2/ba9RD
	 o/SsmBBVPOHF77DI7wdQPSv+MNajkLBJlLp3UNP1GVUzmuH03mevGhDD8baKrS1e4a
	 EJIaGV2PAzwX/KjeF/Cs9RwZMQUxA9RPLhrqeF+z2+LF+6siwzi1nHLXKtcxm4RMaI
	 LvSJKMsV/Wxu/qDNuaPr70Ui2xdrVXJd5ChlU3tFgnWEA+tcmnn/z5IlNpkWU274gd
	 Di/0VgrBaPxdK10hFV4X+ou30ODKpw9HVlD+VYLhK9bTc3cXoD4xBK36dzWeBZSohm
	 qzNncpNYyCDwA==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC PATCH kvmtool 09/10] vfio/iommufd: Add viommu and vdevice
 objects
In-Reply-To: <aH4yMUWTuVtgqD7T@willie-the-truck>
References: <20250525074917.150332-1-aneesh.kumar@kernel.org>
 <20250525074917.150332-9-aneesh.kumar@kernel.org>
 <aH4yMUWTuVtgqD7T@willie-the-truck>
Date: Thu, 24 Jul 2025 19:39:37 +0530
Message-ID: <yq5att31brz2.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Will Deacon <will@kernel.org> writes:

> On Sun, May 25, 2025 at 01:19:15PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> This also allocates a stage1 bypass and stage2 translate table.
>
> Please write your commit messages as per Linux kernel guidelines.
>
>> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
>> ---
>>  builtin-run.c            |   2 +
>>  include/kvm/kvm-config.h |   1 +
>>  vfio/core.c              |   4 +-
>>  vfio/iommufd.c           | 115 ++++++++++++++++++++++++++++++++++++++-
>
> [...]
>
>>  4 files changed, 119 insertions(+), 3 deletions(-)
>> diff --git a/vfio/iommufd.c b/vfio/iommufd.c
>> index 742550705746..39870320e4ac 100644
>> --- a/vfio/iommufd.c
>> +++ b/vfio/iommufd.c
>> @@ -108,6 +108,116 @@ err_out:
>>  	return ret;
>>  }
>>=20=20
>> +static int iommufd_alloc_s1bypass_hwpt(struct vfio_device *vdev)
>> +{
>> +	int ret;
>> +	unsigned long dev_num;
>> +	unsigned long guest_bdf;
>> +	struct vfio_device_bind_iommufd bind;
>> +	struct vfio_device_attach_iommufd_pt attach_data;
>> +	struct iommu_hwpt_alloc alloc_hwpt;
>> +	struct iommu_viommu_alloc alloc_viommu;
>> +	struct iommu_hwpt_arm_smmuv3 bypass_ste;
>> +	struct iommu_vdevice_alloc alloc_vdev;
>> +
>> +	bind.argsz =3D sizeof(bind);
>> +	bind.flags =3D 0;
>> +	bind.iommufd =3D iommu_fd;
>> +
>> +	/* now bind the iommufd */
>> +	if (ioctl(vdev->fd, VFIO_DEVICE_BIND_IOMMUFD, &bind)) {
>> +		ret =3D -errno;
>> +		vfio_dev_err(vdev, "failed to get info");
>> +		goto err_out;
>> +	}
>> +
>> +	alloc_hwpt.size =3D sizeof(struct iommu_hwpt_alloc);
>> +	alloc_hwpt.flags =3D IOMMU_HWPT_ALLOC_NEST_PARENT;
>> +	alloc_hwpt.dev_id =3D bind.out_devid;
>> +	alloc_hwpt.pt_id =3D ioas_id;
>> +	alloc_hwpt.data_type =3D IOMMU_HWPT_DATA_NONE;
>> +	alloc_hwpt.data_len =3D 0;
>> +	alloc_hwpt.data_uptr =3D 0;
>> +
>> +	if (ioctl(iommu_fd, IOMMU_HWPT_ALLOC, &alloc_hwpt)) {
>> +		ret =3D -errno;
>> +		pr_err("Failed to allocate HWPT");
>> +		goto err_out;
>> +	}
>> +
>> +	attach_data.argsz =3D sizeof(attach_data);
>> +	attach_data.flags =3D 0;
>> +	attach_data.pt_id =3D alloc_hwpt.out_hwpt_id;
>> +
>> +	if (ioctl(vdev->fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &attach_data)) {
>> +		ret =3D -errno;
>> +		vfio_dev_err(vdev, "failed to attach to IOAS ");
>> +		goto err_out;
>> +	}
>> +
>> +	alloc_viommu.size =3D sizeof(alloc_viommu);
>> +	alloc_viommu.flags =3D 0;
>> +	alloc_viommu.type =3D IOMMU_VIOMMU_TYPE_ARM_SMMUV3;
>> +	alloc_viommu.dev_id =3D bind.out_devid;
>> +	alloc_viommu.hwpt_id =3D alloc_hwpt.out_hwpt_id;
>> +
>> +	if (ioctl(iommu_fd, IOMMU_VIOMMU_ALLOC, &alloc_viommu)) {
>> +		ret =3D -errno;
>> +		vfio_dev_err(vdev, "failed to allocate VIOMMU %d", ret);
>> +		goto err_out;
>> +	}
>> +#define STRTAB_STE_0_V			(1UL << 0)
>> +#define STRTAB_STE_0_CFG_S2_TRANS	6
>> +#define STRTAB_STE_0_CFG_S1_TRANS	5
>> +#define STRTAB_STE_0_CFG_BYPASS		4
>> +
>> +	/* set up virtual ste as bypass ste */
>> +	bypass_ste.ste[0] =3D STRTAB_STE_0_V | (STRTAB_STE_0_CFG_BYPASS << 1);
>> +	bypass_ste.ste[1] =3D 0x0UL;
>> +
>> +	alloc_hwpt.size =3D sizeof(struct iommu_hwpt_alloc);
>> +	alloc_hwpt.flags =3D 0;
>> +	alloc_hwpt.dev_id =3D bind.out_devid;
>> +	alloc_hwpt.pt_id =3D alloc_viommu.out_viommu_id;
>> +	alloc_hwpt.data_type =3D IOMMU_HWPT_DATA_ARM_SMMUV3;
>> +	alloc_hwpt.data_len =3D sizeof(bypass_ste);
>> +	alloc_hwpt.data_uptr =3D (unsigned long)&bypass_ste;
>> +
>> +	if (ioctl(iommu_fd, IOMMU_HWPT_ALLOC, &alloc_hwpt)) {
>> +		ret =3D -errno;
>> +		pr_err("Failed to allocate S1 bypass HWPT %d", ret);
>> +		goto err_out;
>> +	}
>> +
>> +	alloc_vdev.size =3D sizeof(alloc_vdev),
>> +	alloc_vdev.viommu_id =3D alloc_viommu.out_viommu_id;
>> +	alloc_vdev.dev_id =3D bind.out_devid;
>> +
>> +	dev_num =3D vdev->dev_hdr.dev_num;
>> +	/* kvmtool only do 0 domain, 0 bus and 0 function devices. */
>> +	guest_bdf =3D (0ULL << 32) | (0 << 16) | dev_num << 11 | (0 << 8);
>
> I don't understand this. Shouldn't the BDF correspond to the virtual
> configuration space? That's not allocated until later, but just going
> with 0 isn't going to work.
>
> What am I missing?
>

As I understand it, kvmtool supports only bus 0 and does not allow
multifunction devices. Based on that, I derived the guest BDF as follows
(correcting what was wrong in the original patch):

guest_bdf =3D (0ULL << 16) | (0 << 8) | dev_num << 3 | (0 << 0);

Are you suggesting that this approach is incorrect, and that we can use
a bus number other than 0?

From what I see, device__register() places the device in configuration
space using dev_num, which matches what we see in dev_hdr.

Separately, I did find a bug w.r.t iommufd while testing for bdf value
other than 00:00:0 : I was calling vfio_pci_setup_device() too late on
the iommufd side. I=E2=80=99ve fixed that now.

But just to clarify: is your feedback about that specific bug, or is it
about my assumption that kvmtool supports only domain 0, bus 0, and
function 0?

-aneesh

