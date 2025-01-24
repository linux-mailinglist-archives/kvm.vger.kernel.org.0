Return-Path: <kvm+bounces-36562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78421A1BBBE
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 18:51:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB83E16BE76
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 17:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E14A1DB158;
	Fri, 24 Jan 2025 17:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZrBPtidE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3FE288B1;
	Fri, 24 Jan 2025 17:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737741078; cv=fail; b=AQ3r8bKgcxNlCYa1K7Gv4UvTHBibsfzLLzosE/0iwMr58arGSYpb7HsVyqLhXPljCJapnxASXlJ39l1KAEQYs2lFX5AvqBZlk5F6HZgkDSzlk4647H4y8BYCUDRr00tO4bCojaPn+knzEfenx8Ngunl2yXjL3n2J2upAxHrqt2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737741078; c=relaxed/simple;
	bh=HZ69Qvr9VZv43QV7jC3dkOWx6VsvxluN6XC0F6l7dRE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ktm1ndGKT+gMFARBcNV6TYi1yzbDRNpR06tSKV56etd4R8+rM4RXuK132KBmxfIBw48Nj7sB/thQznafR4ZPXkl3lNsrIE41/r6zl/6J0KoVLXViv/3Wx/swGVRfIHVC21zIUdyhmFz0iMAPddLg4g5SsJ/mOxWQfcsvrmAJ+8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZrBPtidE; arc=fail smtp.client-ip=40.107.220.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FMsowVbCKTzT2+25xLWt1+AZVUDoiEf8B9AXSUMIgCIHOkxqhxHsQ7MSW1HNexzwIpQJcCh30in3ug+we9PmhCi8LotqN8Lpxxc4TwO2vPldf4r5/CK5BgjSSVyW5MPq1EOygGnN8dBpOHPJ54Gcz2PlBnmPK1C8hCgXSAx3OL7pTZOXEndfh1kBEhHHEli6Bfhv6QEPT3NouAUB8qbTma5WFg+FHON90t+ZaXHRqT9Tf7kfvn7EIznYzqWSirM/NH8X3dA6tDvPO9PiZW9rWGYCsmu7PJ1sx/77Q0uCOsYpX3VAjD4mJG3iehhnuth6yGs3gIGi0rzya/a0vZUskA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HZ69Qvr9VZv43QV7jC3dkOWx6VsvxluN6XC0F6l7dRE=;
 b=PT9hp8ufXNDT7X/mmVH2IcHL8ZNenSbHMBbWrIscH/eNxpc8VLWryJlXvnH1vb2yZfbPCGE6XNpT/6jD51qVT3NqoSujG8QNFrgnfPo5DLw/1xCKCNbbSQzwf4hX6tgkZP05enIXgHS1TyRLE/Lfd37d5Q78aACCwujqamm1d34EVmLfh/zKB5jmA+kWmxGqEC/ifImK85U8XhZ+HeF+LR64rlBHOgcSU07+rKAz+h2rby/Jo4GnS6yCwpriUD8on8NcuFayaVd9ZJUvyQLJV+fSXY2AiHhVwDktqX3FSCr95jw3MLxyuFOd8RRZ0hj30ytnm0ZK7D7iis51kAUxlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZ69Qvr9VZv43QV7jC3dkOWx6VsvxluN6XC0F6l7dRE=;
 b=ZrBPtidEoA08JG9uSKOLhKxU96Dd3nR49NcIhkMABtbEQPSiSrypzG4/V08NMdP9fPIAROWKg7B8g4otTDfmbA+6/9B6i/lJINqS//bxvKxGMft2Ikb13f/VYSHHYFq7o7J7LFszVpUm24wWgOUZnwp+Dn1nFDF+JHhhAVv3V1BApnyooqp1P1tK7bsv0h7Ww0ETIQ/Uv8CfHKxcCjYXhRh17/PjlUQKDLrwW806RcOMt13bWUD1ReCHn56qpxkFdKZcXPvjaaEnagA3/zRWZ/zSrstCdMxO9xP7kbdcD/yKIxoLGk/DHQfZt0rJKtRdp7zz5qACp0R8dY5wOd/cSg==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by SJ2PR12MB7800.namprd12.prod.outlook.com (2603:10b6:a03:4c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.19; Fri, 24 Jan
 2025 17:51:14 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%5]) with mapi id 15.20.8356.020; Fri, 24 Jan 2025
 17:51:14 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, Zhi Wang <zhiw@nvidia.com>, Aniket Agashe
	<aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>, Kirti Wankhede
	<kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram
 Sethi <vsethi@nvidia.com>, Andy Currid <acurrid@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Dan Williams
	<danw@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>, "Anuj Aggarwal
 (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] vfio/nvgrace-gpu: Read dvsec register to determine
 need for uncached resmem
Thread-Topic: [PATCH v5 1/3] vfio/nvgrace-gpu: Read dvsec register to
 determine need for uncached resmem
Thread-Index: AQHbbb8heHXFuJBwwkqfATG0HPgCQrMmHYCAgAAXkgA=
Date: Fri, 24 Jan 2025 17:51:14 +0000
Message-ID:
 <SA1PR12MB7199CFED7C5872095B1B08B1B0E32@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250123174854.3338-1-ankita@nvidia.com>
	<20250123174854.3338-2-ankita@nvidia.com>
 <20250124092453.7d3df3d6.alex.williamson@redhat.com>
In-Reply-To: <20250124092453.7d3df3d6.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|SJ2PR12MB7800:EE_
x-ms-office365-filtering-correlation-id: c199059d-b1f8-40e4-62ea-08dd3c9fb204
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?spPOUB+abaqoP9kHkh7P17clspVH99yMoL/xIPIxQJp9aQcUbnM40zm+SV?=
 =?iso-8859-1?Q?8llz0j4UNzUDd8Uli3pyTJHIOlSx9GlASYDI+FMunbxi42VzuvsmgPhdg1?=
 =?iso-8859-1?Q?XfQf2EGIdBXKoJETufyCLcPScU+xertarsjZ7EqjshwZXVgpLA8OH0U0t2?=
 =?iso-8859-1?Q?P/xYarspyXLWPmPgGMfdWtcl7KekR5I1EkJCw09xbjwUyX9avtf5Ldvqut?=
 =?iso-8859-1?Q?v5EMxKXi4wDynBvPTa6JUVxFlSb3ccHGxSn7lJhxGQJWbBSP4zEQnDwqWw?=
 =?iso-8859-1?Q?27j08N1DfconNB6GyTE6V/HwS3XOlGQcsdDhF75T7Qr8ZC8pV2aol+YHfB?=
 =?iso-8859-1?Q?OQx16m4O1liL+CevFoH2taMoAM6e4KqE8LCjyj0ecVRe0wJdbERYEL+feM?=
 =?iso-8859-1?Q?RSToIfgmCIcpt1DPPYEKqr2jrVYiAcsooxh8m2tdcK3Cp+38sLia3HR+Ri?=
 =?iso-8859-1?Q?CV+yIqFmG5d1mZRaw2Jdc9+xQteqCmGVFsythEuBjcj4CEARn4E3WKJzYM?=
 =?iso-8859-1?Q?Q8etCT1cGBIsTEhMUsF0izeJCDTnd4U96aNwe4jwNNLe2vjvf0YMkUlvsO?=
 =?iso-8859-1?Q?hByzKnxjn/qfo5ygoXFOOfzroFSLN5D7wW6Q3L4AsF/4kOVs8RnhtdOC8k?=
 =?iso-8859-1?Q?111TIfz0AebodipyZJoZt1gQTgAneXDJwWGUICZMhi9bK1a1JXROgayjFS?=
 =?iso-8859-1?Q?UbL+Ai4bbOM1vma8auMgsl22ozOp5rHh6NJ05d0IBIpcygim1VfgjxIPF1?=
 =?iso-8859-1?Q?lwC2dliJ1QFTnm3vyziMmf+/SDA86i8R9r8tjIMp5mc1oavBr3JPNqoNQT?=
 =?iso-8859-1?Q?qP1wrVNAz0r5pM7LoJ4fWOqlwfBJY3XhJHHZ9k5/3ipgWq1ftnJQF1oDLY?=
 =?iso-8859-1?Q?OKswB5dqMIslChtkeRN66sU0NQ6Ioydly2NSMJCum05+yFlMWgrS1c3DZL?=
 =?iso-8859-1?Q?POT6bdtaZH8V6EyjBLf/Ai1hqb/nK3JGn3NFVvIHGUSL9hXVPZ+aNBTbha?=
 =?iso-8859-1?Q?PCSmvsv2Dk8oBz+/LDJEimQOdx0YF/+Pc/PBx1/5gqC48hKGEPyW3j+6uN?=
 =?iso-8859-1?Q?OO/jKn8pf0vhQ6XSyQrWCVL3lCX0QuS1lrfrEUZMojZXVUyBKhVnhZ/IjG?=
 =?iso-8859-1?Q?ZuVVfmDNXWirbLbC0Rs5pyFjOqysdgQUMaFVzJH97RNkOTyidkR8jyTHim?=
 =?iso-8859-1?Q?xc3wD3sMX6KtukB+LcvcrMf4exhz52DyQ8qUFIvUbXC8sIInp98H8+E2hh?=
 =?iso-8859-1?Q?wDKK0OzsfKoqELJkUj0QJZgUjKc1JfaKcAKXQNaYbKZZHjOS2pw55moVkN?=
 =?iso-8859-1?Q?0KyxoowqhmuYLldQJXOBFGLcnM+NnaQeKIDl7fPa6MpviIRVBe7Kfo9eqZ?=
 =?iso-8859-1?Q?V3FOCmGDegLKv6j9idy3zUYDO6B6NJS+fubLYrfbWMxObb5tZheMkxLL/p?=
 =?iso-8859-1?Q?dAxel6x3l90reWvb8gnriyJvrF1ZemhAR8BBY0Q4+aOAcx5zbiL4o15Ed3?=
 =?iso-8859-1?Q?rd/owjDPJyjUWX7KzncWIn?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?gZCXuCLQBDAsP4gp/4e3UYNFxqXRGZcmR/oombbhCxxmno73ET43q1wuXC?=
 =?iso-8859-1?Q?hmzxjmV1tkO4jDkZfC/DCJDq3IstClYhCnfnkY/kS/oT5AaX72QZUXWqGi?=
 =?iso-8859-1?Q?VNVK7lIa+Kk1f0ZU5Usvd3Pc/5OGKq62Z6XpoNAlcC4/2aET3XU3dkOVr+?=
 =?iso-8859-1?Q?K8/YOldHYS5FoQRL1UY8Xe1RpyqRgRH+rX9sdxetZcbgk/7Wxshl5juMDc?=
 =?iso-8859-1?Q?2uNWZlajUuROJKGSeUskCnwUu6BuJP1+JmKl2Vi5ReLZfhXSHutXk135Wn?=
 =?iso-8859-1?Q?UEXsIkZcdrnzbe3L6DOCygyPuQVsTkc3KN5r1dTXyuQ3IxvWW1Ewh6dugs?=
 =?iso-8859-1?Q?nAkVwBrxN6XkYAbvGkt3M7p231N83OT4bhXfn0OhKth2mcDKS7AYfWETFY?=
 =?iso-8859-1?Q?I/OJuJ723bgQiQXbh0OVaohli9S64Iky2N9IuyzImCGWjZCkdRvGwoijAx?=
 =?iso-8859-1?Q?VzO0gQSeR7ADFnHbtOzkGBk0jdB9rGcnj6syzDmSKXp/NDapg/SuuwYVyc?=
 =?iso-8859-1?Q?CFkCDD+M4MeENE6evcBVHtwZjZ8/vH2+hRwLARKcQC5sOfPyaQYXo/941Q?=
 =?iso-8859-1?Q?O870CJ4JYtf1cQCW2fnk7YTN0Qt4AIlNPKQosYqniiHkdvHI5VbVkF0kI5?=
 =?iso-8859-1?Q?C0Ist3QcxutD30LMnIpafLIoGfJ2cMkaNlhT7HHrTFXspJ4pHauMKi6Wzx?=
 =?iso-8859-1?Q?Ess/fUZIEia4ui7LkCfTu8Nr1VettuoHatKrEfs9/+mAbYXgamsr7f8Y7I?=
 =?iso-8859-1?Q?wqWNn803xYtsLtNNbs/yQCuq3agLeqG4aia2xBLlaGlG6b8+pH4DuVPL9M?=
 =?iso-8859-1?Q?KtZQXRvih92/VXnzCMl0mzOUeByxVrWGrHLIwk2vVFc3zPiywfDuPOR/t3?=
 =?iso-8859-1?Q?fhqqI4uilASWRwQzqaiI2bJuIdjM/YtjPJOj57fqbpCNhm2sZtHdUZ8gc+?=
 =?iso-8859-1?Q?QA0abhWM1WDEnyiZgJfOtjv25tnciC21g52+v0msFQ1BQ53aOhQhf5UWsE?=
 =?iso-8859-1?Q?+boDHP9IDMUDoLmSrDgby70ItQMz6TlYJg6FP0kLpKFFidtTxXQIYn/gAB?=
 =?iso-8859-1?Q?BxOgb25EAjOJp+bxnnNiamgtixzsMKwivlj+TWETmqz7c/hElr/NNepApp?=
 =?iso-8859-1?Q?qA6NiGUHQoE4Qhh2M8GnLh+3/J/SMOKtU7wXlUJDSkH8l3aQVmiKR+riXh?=
 =?iso-8859-1?Q?ROx7KA+fmOSU1xBMu5t/T/iRWEV8UXVdEpm/Scvn83/WwU6DoEGOek/0BL?=
 =?iso-8859-1?Q?SiABHykfY8/kTVSUCzRz/UCcjGXgJP1XNCvlC0ZgeENKHhXX9OP3QhGRtU?=
 =?iso-8859-1?Q?900pM6bh3lUPJvANxjO/OvgCn935rSUfeoVivvs9Gw9sPM6fKngfDFlSWP?=
 =?iso-8859-1?Q?BWt/ZbXLb7veYcPVWHkH4paz03n05uNBvHX7d5P4GDpdJ79gxke6bvYFx0?=
 =?iso-8859-1?Q?sHIP/t8PwwgMaPI5Gl9w0LKQntiqyVWTn9W9S4gfe7mPwThJtgZTAzwjMY?=
 =?iso-8859-1?Q?C2y5v5RX83yotFf8mPiuGb0Qw78D5aSi5sKDA7RCSTQ6orWOctQIWwXc3R?=
 =?iso-8859-1?Q?uJeGRGesZs1lxZQYAuNFqkAH+coZc44ByKn6t3TIoPiCRkdIBjfSixCmt1?=
 =?iso-8859-1?Q?653rE84PPFspg=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c199059d-b1f8-40e4-62ea-08dd3c9fb204
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2025 17:51:14.0095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QYD9OaNBydCwh2Tq5CbvI9R9Mn291XjQsuCGP3Kd3cCdIcvsgH+J19Pjl19ZGfII3pL/MsN8C8AOJ1BcKQU6+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7800

>> @@ -868,6 +896,8 @@ static const struct pci_device_id nvgrace_gpu_vfio_p=
ci_table[] =3D {=0A=
>>=A0=A0=A0=A0=A0=A0 { PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA=
, 0x2345) },=0A=
>>=A0=A0=A0=A0=A0=A0 /* GH200 SKU */=0A=
>>=A0=A0=A0=A0=A0=A0 { PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA=
, 0x2348) },=0A=
>> +=A0=A0=A0=A0 /* GB200 SKU */=0A=
>> +=A0=A0=A0=A0 { PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x=
2941) },=0A=
>>=A0=A0=A0=A0=A0=A0 {}=0A=
>>=A0 };=0A=
>>=0A=
>=0A=
> GB support isn't really complete until patch 3, so shouldn't we hold=0A=
> off on adding the ID to the table until a trivial patch 4, adding only=0A=
> the chunk above?=A0 Thanks,=0A=
>=0A=
> Alex=0A=
=0A=
Yeah, thanks for pointing that out. Will move it to a new patch.=

