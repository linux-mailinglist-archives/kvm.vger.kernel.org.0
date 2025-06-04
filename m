Return-Path: <kvm+bounces-48380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01451ACDA6F
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 11:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B15A0176632
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 09:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29D1C28C2DD;
	Wed,  4 Jun 2025 09:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YNMi0PRV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3300A247296;
	Wed,  4 Jun 2025 09:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749027609; cv=none; b=kzJnhu96Ual3fFRk8OmzEgOs5p+5E2k0gWXxz+JY0EGZld+Oys32PRbTkkb+q7sV1QLtE12xVKMtVTXj90/MfM/HzPUfZ+mLOEJ2+4jUU5GmAd2nMD0uSehIyvnOgILdoKnzeu0Ee1K7d+R145YRjSbublToOxfY3jAcMX1y7UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749027609; c=relaxed/simple;
	bh=JHeR87LeBvTOD+NcJ7rkJFug+cKe5v03755b/Yn77RY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lz/eGM2TwjyWWDbV6xTtZmVpGcl+Ru5AsbNtPLW+ggOtnNpF6njm8yCHBRVn+d4gWcCer6270B69fVNHk7ALS4MnN8b05UWQkAd+3NyvJ7jBV1u/6/KEHFSXmNA+2N1l5y5mPMKf5zrPFNvgvuhshHyPnFIeT6SnDqp6dE7MwvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YNMi0PRV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67319C4CEE7;
	Wed,  4 Jun 2025 08:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749027608;
	bh=JHeR87LeBvTOD+NcJ7rkJFug+cKe5v03755b/Yn77RY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=YNMi0PRVBrQL7TUZfEAggFUQ4cYerIUDHHQvXVQ4Ql7w6vrNZ2Q+4XcAYwCt1QDYw
	 1eJo1GcCdFQI/aDuDsgi7yZqP3ooz5vQOCtHW2UFhSnYtVDbartpf//xtFic2nNvGc
	 7Hy3/KWhXsNA3huwmTLjAG9GPwRMsIkjND6zyKaDnmxnpA0YbF6/XoFTSudZgMh/HG
	 7r/WM6InNriNEyLQ6Ll4pfLVhKjCZfNR0v2Z968XGgwjSPXzMonP2yIIVDKKgMSkRr
	 nRkrE+KcTPlA2UsqKlOe4qOUYuQLLwY4Z5+bEf2vVmovEaqg8begmD8Ec3aY3eqyF5
	 K39U0EXJ7q5Gg==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 Q)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>, Xu Yilun <yilun.xu@linux.intel.com>
Cc: kvm@vger.kernel.org, sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	dan.j.williams@intel.com, aik@amd.com, linux-coco@lists.linux.dev,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, vivek.kasireddy@intel.com,
	yilun.xu@intel.com, linux-kernel@vger.kernel.org, lukas@wunner.de,
	yan.y.zhao@intel.com, daniel.vetter@ffwll.ch, leon@kernel.org,
	baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	tao1.su@intel.com, linux-pci@vger.kernel.org, zhiw@nvidia.com,
	simona.vetter@ffwll.ch, shameerali.kolothum.thodi@huawei.com,
	iommu@lists.linux.dev, kevin.tian@intel.com
Subject: Re: [RFC PATCH 17/30] iommufd/device: Add TSM Bind/Unbind for TIO
 support
In-Reply-To: <20250603122149.GH376789@nvidia.com>
References: <20250529053513.1592088-1-yilun.xu@linux.intel.com>
 <20250529053513.1592088-18-yilun.xu@linux.intel.com>
 <yq5awm9ujouz.fsf@kernel.org> <aD6UQy4KwKcdSvVE@yilunxu-OptiPlex-7050>
 <20250603122149.GH376789@nvidia.com>
Date: Wed, 04 Jun 2025 14:10:43 +0530
Message-ID: <yq5aplfj99x0.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Jason Gunthorpe <jgg@nvidia.com> writes:

> On Tue, Jun 03, 2025 at 02:20:51PM +0800, Xu Yilun wrote:
>> > Wouldn=E2=80=99t it be simpler to skip the reference count increment a=
ltogether
>> > and just call tsm_unbind in the virtual device=E2=80=99s destroy callb=
ack?
>> > (iommufd_vdevice_destroy())
>>=20
>> The vdevice refcount is the main concern, there is also an IOMMU_DESTROY
>> ioctl. User could just free the vdevice instance if no refcount, while V=
FIO
>> is still in bound state. That seems not the correct free order.
>
> Freeing the vdevice should automatically unbind it..
>

One challenge I ran into during implementation was the dependency of
vfio on iommufd_device. When vfio needs to perform a tsm_unbind,
it only has access to an iommufd_device.

However, TSM operations like binding and unbinding are handled at the
iommufd_vdevice level. The issue? There=E2=80=99s no direct link from
iommufd_device back to iommufd_vdevice.

To address this, I modified the following structures:

modified   drivers/iommu/iommufd/iommufd_private.h
@@ -428,6 +428,7 @@ struct iommufd_device {
 	/* protect iopf_enabled counter */
 	struct mutex iopf_lock;
 	unsigned int iopf_enabled;
+	struct iommufd_vdevice *vdev;
 };
=20
 static inline struct iommufd_device *
@@ -613,6 +614,7 @@ struct iommufd_vdevice {
 	struct iommufd_object obj;
 	struct iommufd_ctx *ictx;
 	struct iommufd_viommu *viommu;
+	struct iommufd_device *idev;
 	struct device *dev;
 	struct mutex	mutex;	/* mutex to synchronize updates to tsm_bound */
 	u64 id; /* per-vIOMMU virtual ID */

These fields are updated during tsm_bind and tsm_unbind, so they must be
protected by the appropriate locks:

Updating vdevice->idev requires holding vdev->mutex (vdev_lock).
Updating device->vdev requires idev->igroup->lock (idev_lock).

tsm_unbind in vdevice_destroy:

vdevice_destroy() ends up calling tsm_unbind() while holding only the
vdev_lock. At first glance, this seems unsafe. But in practice, it's
fine because the corresponding iommufd_device has already been destroyed
when the VFIO device file descriptor was closed=E2=80=94triggering
vfio_df_iommufd_unbind().

I=E2=80=99ve added an in-code comment to explain why tsm_unbind() is safe h=
ere
without acquiring the idev_lock. Hope that is ok.

-aneesh

