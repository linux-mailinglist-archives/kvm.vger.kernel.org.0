Return-Path: <kvm+bounces-26236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 64B9797362A
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 13:26:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E38731F25751
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 11:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1583C18EFCE;
	Tue, 10 Sep 2024 11:26:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D861552FD;
	Tue, 10 Sep 2024 11:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725967563; cv=none; b=eE2GN/2pq216BuClGGJFn/XSZ5eX3D6BOXcxbqn1j0lcqiyM1jOXWz2yqds3HEQu7GgVt+0ZKxuHJ2KXHtywwnpWM4MwmkWwT4BbqYaesfz7i1f9Kur+OpqA3DPMQiYK8A7pK3qw828twIllGG1fGFeLAzjdjNcPiinN4DtRyIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725967563; c=relaxed/simple;
	bh=+q2bPFd6vBiv0igNdKQbKcSyGGd+Jk11U321LBkZs5Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JlY3XkQC0mgUQv25kpA9aU7QHddB2vcPaD4zQ9g+CDlcI7pmQCl9w1L0kelmna/qMGlKtgxNuq3oLftKggXZFQCOsfOqEG9aMTxBpd3D6rIBtyl0GIK0Qew14J6SUiksG/jh18tGBsnT54GeaJjucBlw6zG4YWiFjk6PhDas3ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4X31YJ4ND8zfbxj;
	Tue, 10 Sep 2024 19:23:48 +0800 (CST)
Received: from dggpemf500001.china.huawei.com (unknown [7.185.36.173])
	by mail.maildlp.com (Postfix) with ESMTPS id AEA9A180087;
	Tue, 10 Sep 2024 19:25:58 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 dggpemf500001.china.huawei.com (7.185.36.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 10 Sep 2024 19:25:57 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Tue, 10 Sep 2024 12:25:55 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>, "Guohanjun
 (Hanjun Guo)" <guohanjun@huawei.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Kevin Tian
	<kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Len
 Brown" <lenb@kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Robert
 Moore" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, "Sudeep
 Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, Alex Williamson
	<alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>, Nicolin Chen
	<nicolinc@nvidia.com>, "patches@lists.linux.dev" <patches@lists.linux.dev>,
	Mostafa Saleh <smostafa@google.com>
Subject: RE: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Thread-Topic: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Thread-Index: AQHa+JkNXX8oIDp/tkauz0b2cgKn4bJHsELwgAAEFICACUCfAA==
Date: Tue, 10 Sep 2024 11:25:55 +0000
Message-ID: <7482d2b872304e0ebf0f8fe7424616ac@huawei.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <85aa5e8eb6f243fd9df754fdc96471b8@huawei.com>
 <20240904150015.GH3915968@nvidia.com>
In-Reply-To: <20240904150015.GH3915968@nvidia.com>
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
> Sent: Wednesday, September 4, 2024 4:00 PM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: acpica-devel@lists.linux.dev; Guohanjun (Hanjun Guo)
> <guohanjun@huawei.com>; iommu@lists.linux.dev; Joerg Roedel
> <joro@8bytes.org>; Kevin Tian <kevin.tian@intel.com>; kvm@vger.kernel.org=
;
> Len Brown <lenb@kernel.org>; linux-acpi@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; Lorenzo Pieralisi <lpieralisi@kernel.org>; Ra=
fael J.
> Wysocki <rafael@kernel.org>; Robert Moore <robert.moore@intel.com>; Robin
> Murphy <robin.murphy@arm.com>; Sudeep Holla <sudeep.holla@arm.com>;
> Will Deacon <will@kernel.org>; Alex Williamson
> <alex.williamson@redhat.com>; Eric Auger <eric.auger@redhat.com>; Jean-
> Philippe Brucker <jean-philippe@linaro.org>; Moritz Fischer <mdf@kernel.o=
rg>;
> Michael Shavit <mshavit@google.com>; Nicolin Chen <nicolinc@nvidia.com>;
> patches@lists.linux.dev; Mostafa Saleh <smostafa@google.com>
> Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
>=20
> On Wed, Sep 04, 2024 at 02:20:36PM +0000, Shameerali Kolothum Thodi wrote=
:
>=20
> > This should be added to arm_64_lpae_alloc_pgtable_s2(), not here.
>=20
> Woops! Yes:
>=20
> -       /* The NS quirk doesn't apply at stage 2 */
> -       if (cfg->quirks)
> +       if (cfg->quirks & ~(IO_PGTABLE_QUIRK_ARM_S2FWB))
>                 return NULL;
>=20
> > With the above fixed, I was able to assign a n/w VF dev to a Guest on
> > a test hardware that supports S2FWB.
>=20
> Okay great
>=20
> > However host kernel has this WARN message:
> > [ 1546.165105] WARNING: CPU: 5 PID: 7047 at
> > drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c:1086
> > arm_smmu_entry_qword_diff+0x124/0x138
> > ....
>=20
> Yes, my dumb mistake again, thanks for testing
>=20
> @@ -1009,7 +1009,8 @@ void arm_smmu_get_ste_used(const __le64 *ent,
> __le64 *used_bits)
>         /* S2 translates */
>         if (cfg & BIT(1)) {
>                 used_bits[1] |=3D
> -                       cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_SHCF=
G);
> +                       cpu_to_le64(STRTAB_STE_1_S2FWB | STRTAB_STE_1_EAT=
S |
> +                                   STRTAB_STE_1_SHCFG);
>=20
> > root@localhost:/# ping 150.0.124.42
> > PING 150.0.124.42 (150.0.124.42): 56 data bytes
> > 64 bytes from 150.0.124.42: seq=3D0 ttl=3D64 time=3D47.648 ms
>=20
> So DMA is not totally broken if a packet flowed.
>=20
> > [ 1395.958630] hns3 0000:c2:00.0 eth1: NETDEV WATCHDOG: CPU: 1:
> > transmit queue 10 timed out 5260 ms
>=20
> Timeout? Maybe interrupts are not working? Does /proc/interrupts suggest
> that? That would point at the ITS mapping

Interrupt seems to be Ok in this case as I can see /proc/interrupts increas=
ing.

> Do you have all of Nicolin's extra patches in this kernel to make the ITS=
 work
> with nesting?

Yes. I am using his
 https://github.com/nicolinc/iommufd/commits/iommufd_viommu_p1-v2/

> From a page table POV, iommu_dma_get_msi_page() has:
>=20
> 	int prot =3D IOMMU_WRITE | IOMMU_NOEXEC | IOMMU_MMIO;
>=20
> So the ITS page should be:
>=20
> 		if (prot & IOMMU_MMIO) {
> 			pte |=3D ARM_LPAE_PTE_MEMATTR_DEV;
>=20
> Which which still looks right under S2FWB unless I've misread the manual?
>=20
> > [ 1395.960187] hns3 0000:c2:00.0 eth1: DQL info last_cnt: 42, queued:
> > 42, adj_limit: 0, completed: 0 [ 1395.961758] hns3 0000:c2:00.0 eth1:
> > queue state: 0x6, delta msecs: 5260 [ 1395.962925] hns3 0000:c2:00.0
> > eth1: tx_timeout count: 1, queue id: 10, SW_NTU: 0x1, SW_NTC: 0x0,
> > napi state: 16 [ 1395.964677] hns3 0000:c2:00.0 eth1: tx_pkts: 0,
> > tx_bytes: 0, sw_err_cnt: 0, tx_pending: 0 [ 1395.966114] hns3
> > 0000:c2:00.0 eth1: seg_pkt_cnt: 0, tx_more: 0, restart_queue: 0,
> > tx_busy: 0 [ 1395.967598] hns3 0000:c2:00.0 eth1: tx_push: 1,
> > tx_mem_doorbell: 0 [ 1395.968687] hns3 0000:c2:00.0 eth1: BD_NUM: 0x7f
> > HW_HEAD: 0x0, HW_TAIL: 0x0, BD_ERR: 0x0, INT: 0x1 [ 1395.970291] hns3
> > 0000:c2:00.0 eth1: RING_EN: 0x1, TC: 0x0, FBD_NUM: 0x0 FBD_OFT: 0x0,
> > EBD_NUM: 0x400, EBD_OFT: 0x0 [ 1395.972134] hns3 0000:c2:00.0:
> > received reset request from VF enet
> >
> > All this works fine on a hardware without S2FWB though.
> >
> > Also on this test hardware, it works fine with legacy VFIO assignment.
>=20
> So.. Legacy VFIO assignment will use the S1, no nesting and not enable S2=
FWB?

Yes S1
=20
> Try to isolate if S2FWB is the exact cause by disabling it in the kernel =
on this
> system vs something else wrong?

It looks like not related to S2FWB. I tried  commenting out S2FWB and issue=
 is still
there.  Probably something related to this test setup.

Thanks,
Shameer

