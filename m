Return-Path: <kvm+bounces-9475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 13E62860907
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 03:51:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9018B1F23D2E
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 02:51:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2A70C14F;
	Fri, 23 Feb 2024 02:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Mhhbh9+7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E901628EB;
	Fri, 23 Feb 2024 02:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708656689; cv=fail; b=rHQPhZtIKVBuYkK/oQq/1eAk/caVvQ20EGDcbbbXxLKs+qMGrSXeu6tJgp/U6Md1+AXmIwk0A2o2RWQXFnW4exQ6U5sOb6QFiEYmPrs+5AUSV1gJSCqC4AKHg0hV/IEUt1xhsh1bxE89GoxkMImrez1lI6tZJza1C4avHnsfN48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708656689; c=relaxed/simple;
	bh=jnwJDNfwx7HLqjw7CTBC083ygY7K2m9YyPqw/Hywlc8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Iua9ljY15OXSloLvx8elQP1DjJsDTIp6MjN+ECe5wQsrSRelzMP1UE9HYyv6zZq8nhX1UQAHMRyAthJu4efoHKMJ0H7fDMFKRTo82GXzv/ZDaibcnNtvET3l/L5ukZgNOnwq6JZQjX+OLSzTi3+FFFpJ60Yg+9+yEaykExE2jSY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Mhhbh9+7; arc=fail smtp.client-ip=40.107.93.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bY7OozWsggbOp1MfapCSYQrRdz/z++hTs32HsxGhUOPUCyAY53kxDbYyLYMHrdVu1kboLo1h/kwfzgw6WcXHwa5oX8jneB1P96hUA246xAu8N/YZ/W71YBYS6PbIs4i9G8H7M1OhZy2Us7wis9NR7453LM4Kwsd1dNve+jHdXOd3LK0qZ9/UlTjUObW+1ltGigb7WmdMY21BJbpVHgmhtdJOqtfrigTX9C4VrFvFIEaKJnmabKkl7MSlrMecsIZ7bTpNlrG/nqumW7x+OCMF2YCDAz53s6XmnSrKO66noZ8N+65s6mojyZ2/Pnrz9PX1k21VvpxKgTpz5NcVxH/cXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jnwJDNfwx7HLqjw7CTBC083ygY7K2m9YyPqw/Hywlc8=;
 b=ImGkQuYL/U9BbTJamK3zMqU0s3STpL7Q+VSbRYwM9zcDw8iwsLl0gXSacWAMj8NfvGTK6usH4a+Lgfmognunx/FfN6FpimJGBeDhuaq3VzBhqnlwXuwZNedKFZL9J3NlP7zduXeuThY+26d7vwrI73aAzE45UKIlaZK5BvoogmLQXNSeTCINRTrN6qiEp2fu3Q1bGnjJNkHKxWPI53q/J2QEecOQdc8Mh954wXDKtHEqSc6ZK4EI9P6eozCJW/5P6kBr3gTcZN7XFq58+BUEoLevtySjU2bhGikfYPWvw/haILG1qCvJUxyMIXsldtuuou5MOYbIiZ1liSIhF63e1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jnwJDNfwx7HLqjw7CTBC083ygY7K2m9YyPqw/Hywlc8=;
 b=Mhhbh9+7p7nCG9mxlAPvV8ROyTjaCtwW6TTARJR9CNIvzx4q7l4AaWo/2D9CjiHFg1aDjklIHbXgRGuA8NJr2EeT29AMpIdVm7Hy2gU3FFIiOx+Xcry4qsTeu8ndDsoGri1FvpzqyTKVtLrb+XRSWTyjWF08e1z44wNNbrWz1YYXtuIz2ug5TVMp/jc0tgQqDDtbyxBlbR0DGoUI+RMJhPX3wtpuF5O/gq1x/LC7QV9urzJnOTmY6aUMe7mYHJxJfyj90SbCNdga1sOQ9hvhqGjC0ZvcB3VCT6ottcMBp5Gmc0rDaH3YkDyc2eo5DqTGXLpCNxftG2Sw+UO8Zs415w==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by CO6PR12MB5489.namprd12.prod.outlook.com (2603:10b6:303:139::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.24; Fri, 23 Feb
 2024 02:51:25 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::284c:211f:16dc:f7b2%5]) with mapi id 15.20.7316.018; Fri, 23 Feb 2024
 02:51:24 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "mst@redhat.com" <mst@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "jgg@ziepe.ca"
	<jgg@ziepe.ca>, "oleksandr@natalenko.name" <oleksandr@natalenko.name>,
	"clg@redhat.com" <clg@redhat.com>, "satyanarayana.k.v.p@intel.com"
	<satyanarayana.k.v.p@intel.com>, "brett.creeley@amd.com"
	<brett.creeley@amd.com>, "horms@kernel.org" <horms@kernel.org>,
	"shannon.nelson@amd.com" <shannon.nelson@amd.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>, Matt
 Ochs <mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v19 0/3] vfio/nvgrace-gpu: Add vfio pci variant module for
 grace hopper
Thread-Topic: [PATCH v19 0/3] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Thread-Index: AQHaY/Mekx2WvnlRDEKdWWLWleC5bbEW5psAgABXBe0=
Date: Fri, 23 Feb 2024 02:51:24 +0000
Message-ID:
 <SA1PR12MB71992D7E87AD9DA2C89669BAB0552@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240220115055.23546-1-ankita@nvidia.com>
 <20240222143654.0ed77f85.alex.williamson@redhat.com>
In-Reply-To: <20240222143654.0ed77f85.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|CO6PR12MB5489:EE_
x-ms-office365-filtering-correlation-id: 028bb4f1-47f5-4488-37a2-08dc341a5330
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ItwRBTbMHmtfT6jHr9pLqxCAlHm4TSp3HAfJLn+eFd8mTgnqe3MTi5GHvQ5/ptZ2idRws7CVMS3R7rhTAFCpRYiYvn39iMSY111t6WAwXH+reCRzUAXWqnBEc45Mdd7sYl1lt5Y/04gDtBkGbn+5Ruwid3cGLHHCOyHjk+ezqNvjDrP+ChRT1FVcw3qIjnsM2PFntyW3wNsw2jKQWyYiHTwKnsozmsQBTcxSkUduFOC6BkaZhBlPpirc+rY3FMkzuKCFd21BR4IFEuY/C0sfrOBJOWJr/4m3Xv+aPmgLjt+XIQ4coAaN41REXBH057LPzmsLwnvMKMlelSuiN34JSe85kIaQdxup7QwcvaAHw7LnR1sSsoOFdXOV/xsgwURPisDOwUAK6LTtUb15LzgYsBLqrzWKulLgLN7bcQg8Mz0mW+ZTiM7mdq8o9dF8T7Fr2hIYZFvoufTNIGml3mkpDL1Jn79QUYVXfmRkvM2BD2Xn7mYDVIdxySrCCZPbPpKX/o7DkXtONDcPlh9zRywnA6eTm1+YVr9SsH3dsEtVEwCsOxMDFoVFcsRvcg+65Fj5A7px4YQGm85m5qG6oj8fhRQwCmP3rA+RKWxlhJBT51xPnojI/f28rNH/Z886aPya
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?jWIg48zdyQCOsy3FFrRq+3Ic7zk1Nq4QXgsxf0j+OjbzT3x7c/fhd5SpuH?=
 =?iso-8859-1?Q?odgtkbBo95vdpQcjvEd0kCYIIbsdH5D8z40LsQETky5jrOErLjMTrfVyqb?=
 =?iso-8859-1?Q?mTvQCfwuahSEYd28XVbqV2MM8Kcj4SSSt25ARfdigcz2OP452o7Z0G4WBJ?=
 =?iso-8859-1?Q?AzrsKqHtsaJ06Ltd0xsxNMr2bpfdRvyy/JMCIBsePghlPVOlLJJ43P/BLp?=
 =?iso-8859-1?Q?ySLRDDLqMmvZpKYtYdHDPC96b+4NBjLW+nOupAYsfl5dmo5XV1YA4Z5hvE?=
 =?iso-8859-1?Q?nCYNwKYNI4SheGyP/hrc2tETHEYHwW26h4vafF/pwhqSVzM8pqY0wr6UZo?=
 =?iso-8859-1?Q?YzPHcdbnHhwBcNUd/PloTWrnO5pR0UoimfFoC91OwzGEkAWagOcPuKt+u+?=
 =?iso-8859-1?Q?4hSf6qPf85JJLokL5uv0Yed1eF+6f2qHG+FamemNVUFbOO+tWJ8ljO4uqS?=
 =?iso-8859-1?Q?Cy/i2pwkuk0DNKSA+lGVp7g+hI2Ijz7tn+aPRziATxTARzxIAcQAAgk64e?=
 =?iso-8859-1?Q?iS8rNzjKzDR9XXcAUAygkRywDFc+QWTZ1u/oqnZJZE86q+Vtaew57tzaJB?=
 =?iso-8859-1?Q?ADD7Uv/e2Vk+HKAJMDaulImGbn/+OZhPcYez0SeV+DPx43z/F6Y7/xkz1g?=
 =?iso-8859-1?Q?9VG/T7n+F/mgZuZJknunqW89Ka2tbC8SQTvxL8ic9ZrCnDBcRDMoDt1Ojv?=
 =?iso-8859-1?Q?bphCJk3uLJYf/FysJmRU8Klgn/qomUaeQ7eWKH5duX9Q/9pVCVkWLqdYUj?=
 =?iso-8859-1?Q?M9P3hucwxusyAhmnmU4G5zRXbR+WD3rDhcsvM5rZFK7YeHZA+xDKozwYsz?=
 =?iso-8859-1?Q?90X7a0bQYi/SzH8DqhweTFx2YXlOS569FC49Z0C28VUmxyez3ZmfQlcHhH?=
 =?iso-8859-1?Q?IezUDVvTCpaR8qHQ/wTxp+T1ueDIfQdlgUoRsapar9Df4Klevs9LILPpCk?=
 =?iso-8859-1?Q?wWy3efhg5n+r0JTKB0UCJ/F63tIkweptIcwjXiCnoVOsdxcEfRS/shZ6tm?=
 =?iso-8859-1?Q?0lPGrsAkNIkW49cnI6ARUBtzS4rB5ylpDuKqeTpChGkMlCXXBLEyDbxzla?=
 =?iso-8859-1?Q?lVz+CUHhQ8mDi98tKQjQKp98XhZCpxG7SW+GWpSISWUjWNaeWII3Cxs6I2?=
 =?iso-8859-1?Q?Q5RPK0azZNeuLp4WBZ8ex9xKhT9TcengykLtSiE++aXZgQN5USDxeZytcL?=
 =?iso-8859-1?Q?YiaO6SLsYh6mVB1TK/PhlknoRlAx9IE3dcVNDvi0VlsobMsS63bYhRkWR+?=
 =?iso-8859-1?Q?8FN9GmU1ijekFLUY5tjPrAYWooJLbjQSz387ayFKnMnPu8eEp61N76WAhg?=
 =?iso-8859-1?Q?hASRnyTgwzfZffR7hrSjtRBGtCm/eENcyGQVIzqF8ACrdzJEaOhq0PURsT?=
 =?iso-8859-1?Q?XbIH9BhHbPe1quI18NLeN03FJozHPBRqGUjv+hIKqpWGalgarXRz52ycRy?=
 =?iso-8859-1?Q?e6BaZ7C2al4LXjt7haWn2O3vZ+8IWx2+Qhw2r23x1sGzdYI+d8+7le44R/?=
 =?iso-8859-1?Q?A/hLqLQR8r0ptBpTGpGG2EkY08OAbW0Umo0u/h/fkDdtwQ/jDVCVOkxSgi?=
 =?iso-8859-1?Q?rIBEcSCjvLSGxRRH3oNpoJ6N+y8trOdaoL3A+TjM/tTvZzw0cLDVqzH5U7?=
 =?iso-8859-1?Q?YnLbjhJgSFWIo=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 028bb4f1-47f5-4488-37a2-08dc341a5330
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2024 02:51:24.8913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1QzOJ2FBkf7WuaJ0LLTHtDuHE+fOSD7uLZIbiygdCbBhstQcUiAcCfuyG/rjPNSrqZ7dpn0nR1LtwQqjPY5bRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5489

>> Ankit Agrawal (3):=0A=
>>=A0=A0 vfio/pci: rename and export do_io_rw()=0A=
>>=A0=A0 vfio/pci: rename and export range_intersect_range=0A=
>>=A0=A0 vfio/nvgrace-gpu: Add vfio pci variant module for grace hopper=0A=
>>=0A=
>>=A0 MAINTAINERS=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 |=A0 16 +-=0A=
>>=A0 drivers/vfio/pci/Kconfig=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=
=A0 2 +=0A=
>>=A0 drivers/vfio/pci/Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=
 2 +=0A=
>>=A0 drivers/vfio/pci/nvgrace-gpu/Kconfig=A0 |=A0 10 +=0A=
>>=A0 drivers/vfio/pci/nvgrace-gpu/Makefile |=A0=A0 3 +=0A=
>>=A0 drivers/vfio/pci/nvgrace-gpu/main.c=A0=A0 | 879 +++++++++++++++++++++=
+++++=0A=
>>=A0 drivers/vfio/pci/vfio_pci_config.c=A0=A0=A0 |=A0 42 ++=0A=
>>=A0 drivers/vfio/pci/vfio_pci_rdwr.c=A0=A0=A0=A0=A0 |=A0 16 +-=0A=
>>=A0 drivers/vfio/pci/virtio/main.c=A0=A0=A0=A0=A0=A0=A0 |=A0 72 +--=0A=
>>=A0 include/linux/vfio_pci_core.h=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 10 +-=0A=
>>=A0 10 files changed, 993 insertions(+), 59 deletions(-)=0A=
>>=A0 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Kconfig=0A=
>>=A0 create mode 100644 drivers/vfio/pci/nvgrace-gpu/Makefile=0A=
>>=A0 create mode 100644 drivers/vfio/pci/nvgrace-gpu/main.c=0A=
>>=0A=
>=0A=
> Applied to vfio next branch for v6.9.=A0 Thanks,=0A=
>=0A=
> Alex=0A=
=0A=
Thanks Alex! Appreciate this along with your guidance and help in the revie=
ws.=

