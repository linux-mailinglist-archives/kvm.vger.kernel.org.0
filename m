Return-Path: <kvm+bounces-10211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C847786AAE8
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 10:08:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68C64B285F0
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 09:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28EF93A1CC;
	Wed, 28 Feb 2024 09:05:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF89D38F98;
	Wed, 28 Feb 2024 09:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709111132; cv=none; b=i47jlOyTDfDNljFISuGdllX+0PaNE53+IWm42PHFpiJTFz1FKQjnILXYQ4aqsMNj5/TlGupyWF8cpPPHyjaryBBQbgnMC/X/eF8/FcDnkxxKXdb1tRl37cYA8W+hKuxc5nGv4xn7uVpd1lKoEkrGHYByc9+dT9omsv+KNcfzVEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709111132; c=relaxed/simple;
	bh=WESIMAsMI+WtLCwW+GE6axyaA0i2azKiuAhul2HjH24=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XydAYhByJo4GC8eIq/TKfxs2wpKrWXbQh7e+czvLv2iDzXCzkoG7sRNb6mCJzU/q36kS0m7VcIBubU3qhv8QzaYR+ZtGZAWlBCWwfgPXfNpgZM4iuByNDbMFEjkSf6zEicXaJnRMw5ydrdmsLzr1acGVu4z9yCjZ738zggXByfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Tl7dJ6k78z67Q86;
	Wed, 28 Feb 2024 17:01:40 +0800 (CST)
Received: from lhrpeml100005.china.huawei.com (unknown [7.191.160.25])
	by mail.maildlp.com (Postfix) with ESMTPS id D4BB8140A1B;
	Wed, 28 Feb 2024 17:05:26 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100005.china.huawei.com (7.191.160.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 28 Feb 2024 09:05:26 +0000
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.035;
 Wed, 28 Feb 2024 09:05:26 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Brett Creeley <brett.creeley@amd.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v2 vfio 0/2] vfio/pds: Fix and simplify resets
Thread-Topic: [PATCH v2 vfio 0/2] vfio/pds: Fix and simplify resets
Thread-Index: AQHaad2kYsrb/UByXUeVSA/PNWDN9LEfdD1A
Date: Wed, 28 Feb 2024 09:05:26 +0000
Message-ID: <ead300c6e249429f92a4ce124fc0fd56@huawei.com>
References: <20240228003205.47311-1-brett.creeley@amd.com>
In-Reply-To: <20240228003205.47311-1-brett.creeley@amd.com>
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
> From: Brett Creeley <brett.creeley@amd.com>
> Sent: Wednesday, February 28, 2024 12:32 AM
> To: jgg@ziepe.ca; yishaih@nvidia.com; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; kevin.tian@intel.com;
> alex.williamson@redhat.com; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: shannon.nelson@amd.com; brett.creeley@amd.com
> Subject: [PATCH v2 vfio 0/2] vfio/pds: Fix and simplify resets
>=20
> This small series contains a fix and readability improvements for
> resets.
>=20
> v2:
> - Split single patch into 2 patches
> - Improve commit messages

Just a query on the reset_done handler and the deferred_reset()
logic in this driver. From a quick look, it doesn't look like you have=20
a condition where a copy_to/from_user() is under state_mutex. So
do you think we can get rid of the deferred_reset logic from this=20
driver? Please see the discussion here,
https://lore.kernel.org/kvm/20240220132459.GM13330@nvidia.com/

For HiSilicon, we do have the lock taken for PRE_COPY, but that needs fixin=
g
and then can get rid of the deferred_reset. I will sent out a patch for
that soon.

Thanks,
Shameer

>=20
> v1:
> https://lore.kernel.org/kvm/20240126183225.19193-1-
> brett.creeley@amd.com/
>=20
> Brett Creeley (2):
>   vfio/pds: Always clear the save/restore FDs on reset
>   vfio/pds: Refactor/simplify reset logic
>=20
>  drivers/vfio/pci/pds/pci_drv.c  |  2 +-
>  drivers/vfio/pci/pds/vfio_dev.c | 14 +++++++-------
>  drivers/vfio/pci/pds/vfio_dev.h |  7 ++++++-
>  3 files changed, 14 insertions(+), 9 deletions(-)
>=20
> --
> 2.17.1


