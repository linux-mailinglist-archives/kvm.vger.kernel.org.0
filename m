Return-Path: <kvm+bounces-23697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BECBD94D245
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 16:36:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A514280FB2
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 14:36:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0C45195FEC;
	Fri,  9 Aug 2024 14:36:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDD613FFC;
	Fri,  9 Aug 2024 14:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723214201; cv=none; b=p+Emo2i5mJn8yoMAfwygV5/x9yFGo2qWDrFCo1NwcWs0LcyL9RG8W5ZjuAoLJaziC3pnSZ069JK7JD6Xorwqsxzya1qbLL0awT3C66BJu/F4wXpxh5mhxXugFDU5/sipHUwKXqLBpT2iYajl1WG/IFlyLfKjWYgiiZIIjgPgPMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723214201; c=relaxed/simple;
	bh=eHN0OzcqiuAahgUMxCBPKqeaecfaUuOHwKDo/+UxO1A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eehjEQSBFPQ7r/I9sbSuqI22oC+qYhBKy6i4k4VVbwor0nnDpC10sImhR+Y/O/E+bFBtI6KYw67fQyRB2C6H4Br4iB7vX5WqQ/LZAlg7T/jSwoP4T0FFWCpJmRp3+NmzSofYa+VCu2ao18u5TwvqbZoIQSX+VmQnpmSpE4l34qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4WgRF02Bfwz1S76G;
	Fri,  9 Aug 2024 22:31:48 +0800 (CST)
Received: from dggpemf500003.china.huawei.com (unknown [7.185.36.204])
	by mail.maildlp.com (Postfix) with ESMTPS id 6779A18002B;
	Fri,  9 Aug 2024 22:36:34 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 dggpemf500003.china.huawei.com (7.185.36.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 9 Aug 2024 22:36:33 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Fri, 9 Aug 2024 15:36:31 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "acpica-devel@lists.linux.dev"
	<acpica-devel@lists.linux.dev>, Alex Williamson <alex.williamson@redhat.com>,
	"Guohanjun (Hanjun Guo)" <guohanjun@huawei.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Kevin Tian
	<kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Len
 Brown" <lenb@kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Robert
 Moore" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, "Sudeep
 Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>
CC: Eric Auger <eric.auger@redhat.com>, Jean-Philippe Brucker
	<jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, Michael Shavit
	<mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH 3/8] ACPI/IORT: Support CANWBS memory access flag
Thread-Topic: [PATCH 3/8] ACPI/IORT: Support CANWBS memory access flag
Thread-Index: AQHa6FotpRfMo8Wi40urDv/LZ+pM/rIfAPiQ
Date: Fri, 9 Aug 2024 14:36:31 +0000
Message-ID: <c2dc5966ab794825a69e2ae2b2905632@huawei.com>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <3-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <3-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
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
> Sent: Wednesday, August 7, 2024 12:41 AM
> To: acpica-devel@lists.linux.dev; Alex Williamson
> <alex.williamson@redhat.com>; Guohanjun (Hanjun Guo)
> <guohanjun@huawei.com>; iommu@lists.linux.dev; Joerg Roedel
> <joro@8bytes.org>; Kevin Tian <kevin.tian@intel.com>; kvm@vger.kernel.org=
;
> Len Brown <lenb@kernel.org>; linux-acpi@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; Lorenzo Pieralisi <lpieralisi@kernel.org>; Ra=
fael J.
> Wysocki <rafael@kernel.org>; Robert Moore <robert.moore@intel.com>; Robin
> Murphy <robin.murphy@arm.com>; Sudeep Holla <sudeep.holla@arm.com>;
> Will Deacon <will@kernel.org>
> Cc: Eric Auger <eric.auger@redhat.com>; Jean-Philippe Brucker <jean-
> philippe@linaro.org>; Moritz Fischer <mdf@kernel.org>; Michael Shavit
> <mshavit@google.com>; Nicolin Chen <nicolinc@nvidia.com>;
> patches@lists.linux.dev; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>
> Subject: [PATCH 3/8] ACPI/IORT: Support CANWBS memory access flag
>=20
> From: Nicolin Chen <nicolinc@nvidia.com>
>=20
> The IORT spec, Issue E.f (April 2024), adds a new CANWBS bit to the Memor=
y
> Access Flag field in the Memory Access Properties table, mainly for a PCI
> Root Complex.
...
> diff --git a/include/acpi/actbl2.h b/include/acpi/actbl2.h
> index e27958ef82642f..56ce7fc35312c8 100644
> --- a/include/acpi/actbl2.h
> +++ b/include/acpi/actbl2.h
> @@ -524,6 +524,7 @@ struct acpi_iort_memory_access {
>=20
>  #define ACPI_IORT_MF_COHERENCY          (1)
>  #define ACPI_IORT_MF_ATTRIBUTES         (1<<1)
> +#define ACPI_IORT_MF_CANWBS             (1<<2)

I think we need to update Document number to E.f in IORT section in=20
this file. Also isn't it this file normally gets updated through ACPICA pul=
l ?

Thanks,
Shameer

