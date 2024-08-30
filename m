Return-Path: <kvm+bounces-25480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F57E965C53
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:07:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59139281BC0
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 09:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9410F171E68;
	Fri, 30 Aug 2024 09:07:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E07816EBF7;
	Fri, 30 Aug 2024 09:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725008846; cv=none; b=PuJsz14FSTMzGYGX8YxynnjgixfVBRbed7xsbSSJYfNEIWfCNI/zjwFF0aQfebUyQJJhyPW6nqFk+b/kGrNaXOxS9MpAsnRNSQjH9hP+++KWdLTltHn35+lVjUsPA3+w5Hq+9ubd9YGAJIPEt9kfxytadPOrlZq8fcjDB5q3zAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725008846; c=relaxed/simple;
	bh=iuEsNRJ1f9bQ5sE4VjORXs3N3K9LStzfvHVKVl4XWb8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MDDmf93inyFjvXXndzwBfFCEVTUDMyyhJcmGOC5ihWBBeCCfvoi2U1NrPp0ioipMpXRgfaDyuY59oS+5n39ntz4aSbn7YD/0PeokHVrNXhX2hcACqbXfV5oyz/83tv1jU7IETpYmmSZwFgQP3gSkejXoLLt4kj1f7fagy36qGo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WwBxH4p6vzQqpk;
	Fri, 30 Aug 2024 17:02:27 +0800 (CST)
Received: from dggpemf200003.china.huawei.com (unknown [7.185.36.52])
	by mail.maildlp.com (Postfix) with ESMTPS id 93FB9140202;
	Fri, 30 Aug 2024 17:07:19 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 dggpemf200003.china.huawei.com (7.185.36.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 30 Aug 2024 17:07:18 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Fri, 30 Aug 2024 10:07:16 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Nicolin Chen <nicolinc@nvidia.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "acpica-devel@lists.linux.dev"
	<acpica-devel@lists.linux.dev>, "Guohanjun (Hanjun Guo)"
	<guohanjun@huawei.com>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Robert
 Moore" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, "Sudeep
 Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, Alex Williamson
	<alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Mostafa Saleh
	<smostafa@google.com>
Subject: RE: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
Thread-Topic: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
Thread-Index: AQHa+JkQkcFFSAeDsUqyXyGP6/LaZLI7ju0AgAFNDID///2PgIAAHqvg///xn4CAAU4tEIAAHHjggAAFZgCAASrxMA==
Date: Fri, 30 Aug 2024 09:07:16 +0000
Message-ID: <a008993d270b4cc381abbcc5c44e5bb9@huawei.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs5Fom+JFZimFpeS@Asurada-Nvidia>
 <7debe8f99afa4e33aa1872be0d4a63e1@huawei.com>
 <Zs9a9/Dc0vBxp/33@Asurada-Nvidia>
 <cd36b0e460734df0ae95f5e82bfebaef@huawei.com>
 <Zs9ooZLNtPZ8PwJh@Asurada-Nvidia>
 <d2ad792fe9dd44d38396c5646fa956c6@huawei.com>
 <d1dc23f484784413bb3f6658717de516@huawei.com>
 <ZtCdXjkzVbFMBJjy@Asurada-Nvidia>
In-Reply-To: <ZtCdXjkzVbFMBJjy@Asurada-Nvidia>
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
> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Thursday, August 29, 2024 5:10 PM
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>; acpica-devel@lists.linux.dev;
> Guohanjun (Hanjun Guo) <guohanjun@huawei.com>; iommu@lists.linux.dev;
> Joerg Roedel <joro@8bytes.org>; Kevin Tian <kevin.tian@intel.com>;
> kvm@vger.kernel.org; Len Brown <lenb@kernel.org>; linux-
> acpi@vger.kernel.org; linux-arm-kernel@lists.infradead.org; Lorenzo Piera=
lisi
> <lpieralisi@kernel.org>; Rafael J. Wysocki <rafael@kernel.org>; Robert Mo=
ore
> <robert.moore@intel.com>; Robin Murphy <robin.murphy@arm.com>; Sudeep
> Holla <sudeep.holla@arm.com>; Will Deacon <will@kernel.org>; Alex
> Williamson <alex.williamson@redhat.com>; Eric Auger
> <eric.auger@redhat.com>; Jean-Philippe Brucker <jean-philippe@linaro.org>=
;
> Moritz Fischer <mdf@kernel.org>; Michael Shavit <mshavit@google.com>;
> patches@lists.linux.dev; Mostafa Saleh <smostafa@google.com>
> Subject: Re: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
>=20
> On Thu, Aug 29, 2024 at 02:52:23PM +0000, Shameerali Kolothum Thodi wrote=
:
> > > That makes some progress. But still I am not seeing the assigned dev =
 in
> > > Guest.
> > >
> > > -device vfio-pci-nohotplug,host=3D0000:75:00.1,iommufd=3Diommufd0
> > >
> > > root@ubuntu:/# lspci -tv#
> > >
> > > root@ubuntu:/# lspci -tv
> > > -+-[0000:ca]---00.0-[cb]--
> > >  \-[0000:00]-+-00.0  Red Hat, Inc. QEMU PCIe Host bridge
> > >              +-01.0  Red Hat, Inc Virtio network device
> > >              +-02.0  Red Hat, Inc. QEMU PCIe Expander bridge
> > >              +-03.0  Red Hat, Inc. QEMU PCIe Expander bridge
> > >              +-04.0  Red Hat, Inc. QEMU PCIe Expander bridge
> > >              +-05.0  Red Hat, Inc. QEMU PCIe Expander bridge
> > >              +-06.0  Red Hat, Inc. QEMU PCIe Expander bridge
> > >              +-07.0  Red Hat, Inc. QEMU PCIe Expander bridge
> > >              +-08.0  Red Hat, Inc. QEMU PCIe Expander bridge
> > >              \-09.0  Red Hat, Inc. QEMU PCIe Expander bridge
>=20
> Hmm, the tree looks correct..
>=20
> > > The new root port is created, but no device attached.
> > It looks like Guest finds the config invalid:
> >
> > [    0.283618] PCI host bridge to bus 0000:ca
> > [    0.284064] ACPI BIOS Error (bug):
> \_SB.PCF7.PCEE.PCE5.PCDC.PCD3.PCCA._DSM: Excess arguments - ASL declared
> 5, ACPI requires 4 (20240322/nsarguments-162)
>=20
> Looks like the DSM change wasn't clean. Yet, this might not be the
> root cause, as mine could boot with it.

Yes. This is not the culprit in this case and was reported earlier as well,

https://patchew.org/QEMU/20211005085313.493858-1-eric.auger@redhat.com/2021=
1005085313.493858-2-eric.auger@redhat.com/

> Here is mine (I added a print to that conflict part, for success):
>=20
> [    0.340733] ACPI BIOS Error (bug): \_SB.PCF7.PCEE.PCE5.PCDC._DSM: Exce=
ss
> arguments - ASL declared 5, ACPI requires 4 (20230628/nsarguments-162)
> [    0.341776] pci 0000:dc:00.0: [1b36:000c] type 01 class 0x060400 PCIe =
Root
> Port
> [    0.344895] pci 0000:dc:00.0: BAR 0 [mem 0x10400000-0x10400fff]
> [    0.347935] pci 0000:dc:00.0: PCI bridge to [bus dd]
> [    0.348410] pci 0000:dc:00.0:   bridge window [mem 0x10200000-0x103fff=
ff]
> [    0.349483] pci 0000:dc:00.0:   bridge window [mem 0x42000000000-
> 0x44080ffffff 64bit pref]
> [    0.351459] pci_bus 0000:dd: busn_res: insert [bus dd] under [bus dc-d=
d]
>=20
> In my case:
> [root bus (00)] <---[pxb (dc)] <--- [root-port (dd)] <--- dev
>=20
> In your case:
> [root bus (00)] <---[pxb (ca)] <--- [root-port (cb)] <--- dev
>=20
> > [    0.285533] pci_bus 0000:ca: root bus resource [bus ca]
> > [    0.286214] pci 0000:ca:00.0: [1b36:000c] type 01 class 0x060400 PCI=
e Root
> Port
> > [    0.287717] pci 0000:ca:00.0: BAR 0 [mem 0x00000000-0x00000fff]
> > [    0.288431] pci 0000:ca:00.0: PCI bridge to [bus 00]
>=20
> This starts to diff. Somehow the link is reversed? It should be:
>  [    0.288431] pci 0000:ca:00.0: PCI bridge to [bus cb]
>=20
> > [    0.290649] pci 0000:ca:00.0: bridge configuration invalid ([bus 00-=
00]),
> reconfiguring
> > [    0.292476] pci_bus 0000:cb: busn_res: can not insert [bus cb-ca] un=
der [bus
> ca] (conflicts with (null) [bus ca])
> > [    0.293597] pci_bus 0000:cb: busn_res: [bus cb-ca] end is updated to=
 cb
> > [    0.294300] pci_bus 0000:cb: busn_res: can not insert [bus cb] under=
 [bus ca]
> (conflicts with (null) [bus ca])
>=20
> And then everything went south...
>=20
> Would you please try adding some prints?
> ----------------------------------------------------------------------
> @@ -1556,6 +1556,7 @@ static char *create_new_pcie_port(VirtNestedSmmu
> *nested_smmu, Error **errp)
>      uint32_t bus_nr =3D pci_bus_num(nested_smmu->pci_bus);
>      DeviceState *dev;
>      char *name_port;
> +    bool ret;
>=20
>      /* Create a root port */
>      dev =3D qdev_new("pcie-root-port");
> @@ -1571,7 +1572,9 @@ static char *create_new_pcie_port(VirtNestedSmmu
> *nested_smmu, Error **errp)
>      qdev_prop_set_uint32(dev, "chassis", chassis_nr);
>      qdev_prop_set_uint32(dev, "slot", port_nr);
>      qdev_prop_set_uint64(dev, "io-reserve", 0);
> -    qdev_realize_and_unref(dev, BUS(nested_smmu->pci_bus), &error_fatal)=
;
> +    ret =3D qdev_realize_and_unref(dev, BUS(nested_smmu->pci_bus),
> &error_fatal);
> +    fprintf(stderr, "ret=3D%d, pcie-root-port ID: %s, added to pxb_bus n=
um: %x,
> chassis: %d\n",
> +            ret, name_port, pci_bus_num(nested_smmu->pci_bus), chassis_n=
r);
>      return name_port;
>  }

Print shows everything fine:
create_new_pcie_port: name_port smmu_bus0xca_port0, bus_nr 0xca chassis_nr =
0xfd, nested_smmu->index 0x2, pci_bus_num 0xca, ret 1

It looks like a problem with old QEMU_EFI.fd(2022 build and before).
I tried with 2023 QEMU_EFI.fd and with that it looks fine.

root@ubuntu:/# lspci -tv
-+-[0000:ca]---00.0-[cb]----00.0  Huawei Technologies Co., Ltd. Device a251
 \-[0000:00]-+-00.0  Red Hat, Inc. QEMU PCIe Host bridge
             +-01.0  Red Hat, Inc Virtio network device
             +-02.0  Red Hat, Inc. QEMU PCIe Expander bridge
             +-03.0  Red Hat, Inc. QEMU PCIe Expander bridge
             +-04.0  Red Hat, Inc. QEMU PCIe Expander bridge
             +-05.0  Red Hat, Inc. QEMU PCIe Expander bridge
             +-06.0  Red Hat, Inc. QEMU PCIe Expander bridge
             +-07.0  Red Hat, Inc. QEMU PCIe Expander bridge
             +-08.0  Red Hat, Inc. QEMU PCIe Expander bridge
             \-09.0  Red Hat, Inc. QEMU PCIe Expander bridge

So for now, I can proceed.

Thanks,
Shameer



