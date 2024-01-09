Return-Path: <kvm+bounces-5876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CD8382853F
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 12:42:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 841E71C23923
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 11:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C98C37168;
	Tue,  9 Jan 2024 11:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rkN+8lXg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2074.outbound.protection.outlook.com [40.107.243.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C871E4B1;
	Tue,  9 Jan 2024 11:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNiQViJJjAdqop24KIDcDRRUc3HF5tBaauVNs7fSLXLOtgH0wizhnRb+PAZgDvOjYSlDY4PdpTh8mRYMHoz2sCxpenZinRyfIRYr0mSavEWTLf5nGFyrLK8uTSB0/7pzaY2OGl8vYt3riJwXT8RwNgvmtNSUmROJARbGG1f7TayP10WOXDHbZH7QgcfAjGTElMcs/xqZTCyWQy2EdDLz838M4UZZLt0/bPE8c7RMJMJIMJJNumJxJvM/NLPKl1fNujh+3rx9+a3DsaOMkCdc0tNzHXOM4oxvGkW94U0aUuWDhLLFMJzMXD0IuGNP+5WqMWTlqtm3IbmQv9d3vrAoYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O8HB93j58h4N5WH/j5sNG2izvfB6e2JymbYZgfPH3Pk=;
 b=XHLW3HM5I9SWd+j/wcwFnpG3oMy7Zdb5RBdWrUpi2jiXwcZVCxON8WEmEHqfRd0vsvkcWePxqp9lOZ2vKg6pbHd28GVaGPJxa1b5aAapyh592s/NUWkoSwVCN8/Yk46vLsiR1tDAuWNyzPU5N01nc4YKvCIjp0HcAe7tXikXOsCrzgJZzhZ65L0lof2anoFuqpRoKQIeinOCW8TtpM6MYF/TGX5v3ijg6955NeyFo75hYJxhgTUHp49A1kA0VL2tSz653UF1Y5AXRe/JEnv9ecV2M3jhZOJhzZvgN2HJsA0YzrUgTTXFrIeI97FwjOD5n1syH5ZsNcNDWu1xE2Kz6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8HB93j58h4N5WH/j5sNG2izvfB6e2JymbYZgfPH3Pk=;
 b=rkN+8lXgdAaviyoVKaYO4Klvjq7KOnlD1P39qnkvgy91SLNHzL4lFUWLUr/nJV2j4Qw/kNZw3ISXW2NIf9cen7fGHnaLAlWtSydGLnBd/ZLzgxT/fVxeD1bW18bd9YbWysu/TgLFOhShzmknj6VL8apGra5U/Tu7PXDx8JfQqxxSZsW7olSOqKVj3jcrrh1aH2isCU84lvqopBZALk7jpMoVOwH5Yc+hss5bBoi12SxzJ2Ey7ZjWkWV8S8dp+BifZAXaKW/8oF5zhU49MVyWhjyQTkZrbK+Sf3VVL1VCxib2KREiLvAdm5n4uEUCy+jfqRMIrbF/OwVnRJT9mbwWdw==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by IA0PR12MB8328.namprd12.prod.outlook.com (2603:10b6:208:3dd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.23; Tue, 9 Jan
 2024 11:42:37 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::e23f:7791:dfd2:2a2d]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::e23f:7791:dfd2:2a2d%7]) with mapi id 15.20.7159.020; Tue, 9 Jan 2024
 11:42:37 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: Yishai Hadas <yishaih@nvidia.com>, "shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"brett.creeley@amd.com" <brett.creeley@amd.com>, "horms@kernel.org"
	<horms@kernel.org>, Aniket Agashe <aniketa@nvidia.com>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj Aggarwal
 (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 1/1] vfio/nvgrace-gpu: Add vfio pci variant module for
 grace hopper
Thread-Topic: [PATCH v15 1/1] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Thread-Index:
 AQHaMRy7X+OP5n0180qPNLjY5sy83LCvnbKAgBcsduSAAZ96gIAAEY0AgAAaLACAAFEqAIAABG8AgAiQms4=
Date: Tue, 9 Jan 2024 11:42:37 +0000
Message-ID:
 <SA1PR12MB719969304142495D09BF7204B06A2@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20231217191031.19476-1-ankita@nvidia.com>
 <20231218151717.169f80aa.alex.williamson@redhat.com>
 <BY5PR12MB3763179CAC0406420AB0C9BAB095A@BY5PR12MB3763.namprd12.prod.outlook.com>
 <20240102091001.5fcc8736.alex.williamson@redhat.com>
 <20240103165727.GQ50406@nvidia.com>
 <20240103110016.5067b42e.alex.williamson@redhat.com>
 <20240103193356.GU50406@nvidia.com>
 <20240103172426.0a1f4ae6.alex.williamson@redhat.com>
 <20240104004018.GW50406@nvidia.com>
In-Reply-To: <20240104004018.GW50406@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|IA0PR12MB8328:EE_
x-ms-office365-filtering-correlation-id: 6260edd7-7234-4fc7-11b1-08dc11081401
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 xuQThxmZEGZLtkEfJfZCCgba4Jd0UCTj4vk6CfavvXYs5BKVj5ZRf9rYE+iF3aC1SZlb/p2RYUJUrKkJLp6dBpnuht+3M+2mL+ttu8wN4yBjei6+QhxbV3PoWhCQF3Q9pvljBwFrtofSjeeXP+2Z43kBX/jeiyhvl/J2z1/1AtwF/Av6XTVOdtDfT5buvU/aKX8mDU09uHxMy0fJJspfvZgHuiO0aFovb6r41EdznJDGSawd62oXloP+2dd9spI6UhJYs4m7h31GzSk2oEaskeeYWMDJEMjPxN+ptQJOEF/kijHb7yS6XWEW3cX3NhfwuBphNQUCoCqnbc8XwTULV0aa8C1+5A0iHVRMAouT0KTWelOeO6Up3EsVvTFRSXaW2swWLIKSmdynUQe8TECcPAlxBiwes4jdFQjRB4GFB2NDNj9TQGwHyd+Y3vTvTnkeSuCB1FgtpckFj3mDkAAnG5ZLKwNEIKT2HwK7ksNSyM9RO390yT970KMVE5hUlZVi2EYLGQAphRyn/JLVRiO40B7oU5Pz+h6ud3aB5VEBnFmSCdTxTqTwmSKt8KsTFxuZx2ob34Jcz/9nAlMj+FH/yq7EwmdBhwAzghYLH4Je1AlRiRIAy0g8i35O+otVfQIB
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(396003)(136003)(376002)(366004)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(55016003)(83380400001)(91956017)(66946007)(41300700001)(76116006)(33656002)(86362001)(38070700009)(38100700002)(122000001)(26005)(6506007)(9686003)(2906002)(7696005)(66556008)(66476007)(66446008)(64756008)(316002)(110136005)(478600001)(54906003)(71200400001)(8936002)(8676002)(4326008)(52536014)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?8Ef40vc+JW6rMEfFRPG97EBKzdNOC2lxw7yVjrHgucjoL+kfdupYSi98Cf?=
 =?iso-8859-1?Q?TwIJBiWswjMIHFC8HuHeSzyiwf3hsZkcNwtSWsLdZtJJOT22cjRZYF0Wer?=
 =?iso-8859-1?Q?EymlavxZKYz0N3+Gx0pvV6Y+v4sWR6wVG6UldrFjXrH1VXYt6q2Q3CGMLF?=
 =?iso-8859-1?Q?9rrnh+YXeFa5wlHB6OubHTwiE4u3xE7Cl0hYOdhnTck6OUtkuuyiqhggto?=
 =?iso-8859-1?Q?sl2aMg/HzyOK+wBD8ThkVYkKq17LnGz6p15ELMzzDmlxiPwMWPFOmn7VYf?=
 =?iso-8859-1?Q?5XLIchNjnn+DcYRYZgycC+lLlwKyeT15Z2SrzJnT/A2OU1ZOv2A4Yjo3em?=
 =?iso-8859-1?Q?yeE9qA2jbzwaVEPloG80xUqT8lNSwDuLzN5/t4OKLCBK56leYpVWT9Kb3g?=
 =?iso-8859-1?Q?Ziaqkv8pIpaeCEWojnUCctE4cE0RDOvbPq2NGWG1UYkhMesUy1FrA8sc1e?=
 =?iso-8859-1?Q?XLfi7xNAsPO2Car5L88ED3dEYs+axuUSW2xjhnRCD50dddWRiFrckaHv3C?=
 =?iso-8859-1?Q?BryW5xyI2C5PZmcQqfsdW8liLHfcurM3il2E1rX7bMxRKQuKyt/PO/yEdw?=
 =?iso-8859-1?Q?zD9A34emf9qjZa2jPFO6/a4uEWvjclXkHHICq0fe29IAFsEenpuglkreUF?=
 =?iso-8859-1?Q?EquUhYckilN76jSotYT+fdeRMJF8nM0u/lR3klv6JqRWyHs/RIES6jGZBQ?=
 =?iso-8859-1?Q?iNExZhnFz1U24618Z0eJd11cvLuUQGa2h90rDjNpjACwFMX2dM9wkjpPLz?=
 =?iso-8859-1?Q?9zYKZZoUMpNuaNFepRAiD6MTFlSBWtFh0j6Zu5sKgdebWuFbt5f4nHtoaB?=
 =?iso-8859-1?Q?/h3xpqVeCSyeGt9boOOL9pSgBK0cgzCBmpvIAwbcEX3mcWkbopFBqdpB8T?=
 =?iso-8859-1?Q?3Z9vs3G6uvalfd/VhRMc/VLo5V/EH7UQZkQ0E2G576lMXD2MvrlxWVthXz?=
 =?iso-8859-1?Q?vuHHwhtlqWC/MHSCww6rSPQRlFLh+e1sfINJXfNFBbz8Qz+iNTBHa4ir1N?=
 =?iso-8859-1?Q?t+NvZoamoHwdWKmi8oCKOO5f+jRbUff90xDrBHAY848FtitB21dz6SwI2L?=
 =?iso-8859-1?Q?ta0gIm0iE33bYAZjzzqwixNtxbv1u+ndTBSGa7JyKE0KsQ0F24Ets1CvU8?=
 =?iso-8859-1?Q?t7IEu0NpPtLUdUPZ/bWFke5zPs9557HY5LQkHdDJMflwO7dUCT4lx74IQh?=
 =?iso-8859-1?Q?G967CEs1WRQDx9/8hhdjjNYwU0GVKEJOds25a8V9MqIhD6xQ0kbvqExVc7?=
 =?iso-8859-1?Q?rKhicsexGX2ZRx6+RufAs/0p8GH5PNfAxJELLww3qV7MmwTmZYP2+Wc4/+?=
 =?iso-8859-1?Q?P7Gp6dZD3cJQblRBxqTN8rIHVsCg+GmdLqYnMZEwieD5QmihN5dwhgS97T?=
 =?iso-8859-1?Q?Z1ykVtBgbsmF5mF/Q0+VeyUTEj/ELfdeznfq4U3oXUqzsjIH36Cxjy/aa1?=
 =?iso-8859-1?Q?Hda6h2QnuExzeDXeIBVfSyxDZi7veH72xj+W8nf1NwaXSq4KDFsMikFko1?=
 =?iso-8859-1?Q?GB9YORhFZQ/nTZzI8OhpzfEULhkrG/B9B7HtKA31jKIO5k7C2rm0IkGhU1?=
 =?iso-8859-1?Q?zpg989vRBElPKjOP8svtjIexfDiTHBHV0giX13/0ODLi6rs7102z9iXn34?=
 =?iso-8859-1?Q?PfiS1tkWwU1OQ=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6260edd7-7234-4fc7-11b1-08dc11081401
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2024 11:42:37.2597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SBA1ywaK3kAmlpFfND6MOBuCRtLUYVuCQzWPVAc0MUSQqTmJkkYjjWkShUvZBbRveEr6FCgJOWsTNSBcvO/1RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8328

I am working to get the code changes suggested in this thread to get=0A=
to the next version.=0A=
=0A=
Moreover based on the other design related comments for BAR approach=0A=
and support for the enable/disable bit, comments follow.=0A=
=0A=
> There are a lot of VMMs and OSs this needs to support so it must all=0A=
> be consistent. For better or worse the decision was taken for the vPCI=0A=
> spec to use BAR not ACPI, in part due to feedback from the broader VMM=0A=
> ecosystem, and informed by future product plans.=0A=
> =0A=
> So, if vfio does special regions then qemu and everyone else has to=0A=
> fix it to meet the spec.=0A=
=0A=
Ack, I'm putting this into the commit log as a reason to go with the BAR=0A=
approach for future reference.=0A=
=0A=
>>> I'd suggest we take a look at whether we need to continue to pursue=0A=
>>> honoring the memory enable bit for these BARs and make a conscious and=
=0A=
>>> documented decision if we choose to ignore it.=0A=
>>=0A=
>> Let's document it.=0A=
> Ok, I'd certainly appreciate more background around why it was chosen=0A=
> to expose the device differently than bare metal in the commit log and=0A=
> code comments and in particular why we're consciously choosing not to=0A=
> honor these specific PCI semantics.  Presumably we'd remove the -EIO=0A=
> from the r/w path based on the memory enable state as well.=0A=
=0A=
Ack, will add to the commit log and remove EIO.=0A=
=0A=
>> unprogrammed BARs are ignored (ie. not exposed to userspace), so perhaps=
=0A=
>> as long as it can be guaranteed that an access with the address space=0A=
>> enable bit cleared cannot generate a system level fault, we actually=0A=
>> have no strong argument to strictly enforce the address space bits.=0A=
>=0A=
> This is what I think, yes.=0A=
=0A=
Ack, so given the access does not cause system level fault, I'll not enforc=
e=0A=
the enable/disable bit. Though I'll put this information in the commit log=
=0A=
for reference as well and the reason for this choice.=

