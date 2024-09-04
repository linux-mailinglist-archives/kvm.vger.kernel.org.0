Return-Path: <kvm+bounces-25886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D143B96C032
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 16:23:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 021311C250F9
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 14:23:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CCC71E00BB;
	Wed,  4 Sep 2024 14:20:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DEB1D4170;
	Wed,  4 Sep 2024 14:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725459645; cv=none; b=CDDg74boSo9STR95b2yaL5elDzkjCxTc63OKYtbjgkM1FLgtoq3Go9oCa8DjHf9wa9m1jnDf1ucXCh4vQarG3eLeUCH3bakauwSsfOVbWDwfbCcLDhxFPRP748KIdw66wkJracaANG15eVI/tKpHjbaOeYlGHFh5RCpnccWrIoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725459645; c=relaxed/simple;
	bh=3NFixX3Kl1y5WBzsUh6ZkbNWiMteGWvyfBElaxW/K1Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hnz0mWuBFVkecVvbldDSrtEloQGFf6Ucdr4K4JnBlkPsphMb34b6mTSO5T3ncl8rlMkJRKjfGVDvD5A7hfrF4qvqzipsjxAxjz8q7o/tWQZQbCERlXJ1/5ZaJuUNTckh8KNIJcNrBwEcCUONc+NbgMB7mhM9kj3vwdRIWmZbvBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WzPfQ4FJsz20nLZ;
	Wed,  4 Sep 2024 22:15:42 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id CDD681400D7;
	Wed,  4 Sep 2024 22:20:39 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 22:20:38 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Wed, 4 Sep 2024 15:20:37 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "acpica-devel@lists.linux.dev"
	<acpica-devel@lists.linux.dev>, "Guohanjun (Hanjun Guo)"
	<guohanjun@huawei.com>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Robert
 Moore" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, "Sudeep
 Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>
CC: Alex Williamson <alex.williamson@redhat.com>, Eric Auger
	<eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	"Nicolin Chen" <nicolinc@nvidia.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, Mostafa Saleh <smostafa@google.com>
Subject: RE: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Thread-Topic: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Thread-Index: AQHa+JkNXX8oIDp/tkauz0b2cgKn4bJHsELw
Date: Wed, 4 Sep 2024 14:20:36 +0000
Message-ID: <85aa5e8eb6f243fd9df754fdc96471b8@huawei.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
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
> Sent: Tuesday, August 27, 2024 4:52 PM
> To: acpica-devel@lists.linux.dev; Guohanjun (Hanjun Guo)
> <guohanjun@huawei.com>; iommu@lists.linux.dev; Joerg Roedel
> <joro@8bytes.org>; Kevin Tian <kevin.tian@intel.com>;
> kvm@vger.kernel.org; Len Brown <lenb@kernel.org>; linux-
> acpi@vger.kernel.org; linux-arm-kernel@lists.infradead.org; Lorenzo Piera=
lisi
> <lpieralisi@kernel.org>; Rafael J. Wysocki <rafael@kernel.org>; Robert
> Moore <robert.moore@intel.com>; Robin Murphy
> <robin.murphy@arm.com>; Sudeep Holla <sudeep.holla@arm.com>; Will
> Deacon <will@kernel.org>
> Cc: Alex Williamson <alex.williamson@redhat.com>; Eric Auger
> <eric.auger@redhat.com>; Jean-Philippe Brucker <jean-
> philippe@linaro.org>; Moritz Fischer <mdf@kernel.org>; Michael Shavit
> <mshavit@google.com>; Nicolin Chen <nicolinc@nvidia.com>;
> patches@lists.linux.dev; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; Mostafa Saleh
> <smostafa@google.com>
> Subject: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
>=20
> Force Write Back (FWB) changes how the S2 IOPTE's MemAttr field
> works. When S2FWB is supported and enabled the IOPTE will force cachable
> access to IOMMU_CACHE memory when nesting with a S1 and deny cachable
> access otherwise.
>=20
> When using a single stage of translation, a simple S2 domain, it doesn't
> change anything as it is just a different encoding for the exsting mappin=
g
> of the IOMMU protection flags to cachability attributes.
>=20
> However, when used with a nested S1, FWB has the effect of preventing the
> guest from choosing a MemAttr in it's S1 that would cause ordinary DMA to
> bypass the cache. Consistent with KVM we wish to deny the guest the
> ability to become incoherent with cached memory the hypervisor believes i=
s
> cachable so we don't have to flush it.
>=20
> Turn on S2FWB whenever the SMMU supports it and use it for all S2
> mappings.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---

(...)

> @@ -932,7 +948,8 @@ arm_64_lpae_alloc_pgtable_s1(struct io_pgtable_cfg
> *cfg, void *cookie)
>  	if (cfg->quirks & ~(IO_PGTABLE_QUIRK_ARM_NS |
>  			    IO_PGTABLE_QUIRK_ARM_TTBR1 |
>  			    IO_PGTABLE_QUIRK_ARM_OUTER_WBWA |
> -			    IO_PGTABLE_QUIRK_ARM_HD))
> +			    IO_PGTABLE_QUIRK_ARM_HD |
> +			    IO_PGTABLE_QUIRK_ARM_S2FWB))
>  		return NULL;

This should be added to arm_64_lpae_alloc_pgtable_s2(), not here.

With the above fixed, I was able to assign a n/w VF dev to a Guest on a
test hardware that supports S2FWB.

However host kernel has this WARN message:
[ 1546.165105] WARNING: CPU: 5 PID: 7047 at drivers/iommu/arm/arm-smmu-v3/a=
rm-smmu-v3.c:1086 arm_smmu_entry_qword_diff+0x124/0x138
....
[ 1546.330312]  arm_smmu_entry_qword_diff+0x124/0x138
[ 1546.335090]  arm_smmu_write_entry+0x38/0x22c
[ 1546.339346]  arm_smmu_install_ste_for_dev+0x158/0x1ac
[ 1546.344383]  arm_smmu_attach_dev+0x138/0x240
[ 1546.348639]  __iommu_device_set_domain+0x7c/0x11c
[ 1546.353330]  __iommu_group_set_domain_internal+0x60/0x134
[ 1546.358714]  iommu_group_replace_domain+0x3c/0x68
[ 1546.363404]  iommufd_device_do_replace+0x334/0x398
[ 1546.368181]  iommufd_device_change_pt+0x26c/0x650
[ 1546.372871]  iommufd_device_replace+0x18/0x24
[ 1546.377214]  vfio_iommufd_physical_attach_ioas+0x28/0x68
[ 1546.382514]  vfio_df_ioctl_attach_pt+0x98/0x170


And when I tried to use the assigned n/w dev, it seems to do a reset
continuously.

root@localhost:/# ping 150.0.124.42
PING 150.0.124.42 (150.0.124.42): 56 data bytes
64 bytes from 150.0.124.42: seq=3D0 ttl=3D64 time=3D47.648 ms
[ 1395.958630] hns3 0000:c2:00.0 eth1: NETDEV WATCHDOG: CPU: 1: transmit qu=
eue 10 timed out 5260 ms
[ 1395.960187] hns3 0000:c2:00.0 eth1: DQL info last_cnt: 42, queued: 42, a=
dj_limit: 0, completed: 0
[ 1395.961758] hns3 0000:c2:00.0 eth1: queue state: 0x6, delta msecs: 5260
[ 1395.962925] hns3 0000:c2:00.0 eth1: tx_timeout count: 1, queue id: 10, S=
W_NTU: 0x1, SW_NTC: 0x0, napi state: 16
[ 1395.964677] hns3 0000:c2:00.0 eth1: tx_pkts: 0, tx_bytes: 0, sw_err_cnt:=
 0, tx_pending: 0
[ 1395.966114] hns3 0000:c2:00.0 eth1: seg_pkt_cnt: 0, tx_more: 0, restart_=
queue: 0, tx_busy: 0
[ 1395.967598] hns3 0000:c2:00.0 eth1: tx_push: 1, tx_mem_doorbell: 0
[ 1395.968687] hns3 0000:c2:00.0 eth1: BD_NUM: 0x7f HW_HEAD: 0x0, HW_TAIL: =
0x0, BD_ERR: 0x0, INT: 0x1
[ 1395.970291] hns3 0000:c2:00.0 eth1: RING_EN: 0x1, TC: 0x0, FBD_NUM: 0x0 =
FBD_OFT: 0x0, EBD_NUM: 0x400, EBD_OFT: 0x0
[ 1395.972134] hns3 0000:c2:00.0: received reset request from VF enet

All this works fine on a hardware without S2FWB though.

Also on this test hardware, it works fine with legacy VFIO assignment.

Not debugged further. Please let me know if you have any hunch.

Thanks,
Shameer




