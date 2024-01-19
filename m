Return-Path: <kvm+bounces-6467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 808C1832734
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 11:04:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28EC728559B
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 10:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF5BD3C482;
	Fri, 19 Jan 2024 10:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="liNuv6qB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817633C466;
	Fri, 19 Jan 2024 10:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705658666; cv=fail; b=XiJcvFAE6bpVOTQqcedgW3hzBUwwStNxVWw9dk8B2O6z2FLglBGSHpHrHW38rxBSUNZi5UoWzqRQRRdeCUcpFzE22/J9h8V4rUy83v7P0Aatp5aMR/1j4k4iFm1/9Gf0fdptU2JhtCSzPWgmNPA7HiF6IAzOufy8U5j25mqJGZ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705658666; c=relaxed/simple;
	bh=VFbaPiEQqggrM3E1kQS9iuMQVuWLgkzBtYhFRkjJcy8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r7k8hXPCQJ9Hb7MferkbckPmJ+uQg8wUWSrT8sQwyYcVWUVL7DjPZ7z0YKPmmrT/LlNpe8FOG57r8OWm2o6ZDEFbkT4qc0aU1bko7MvMWmKBnIXVhAroKDCRq76iqk4Jwun5p67tZgF/+OcJPWLtfeNZWn4zFfOCbTAIckbaU0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=liNuv6qB; arc=fail smtp.client-ip=40.107.220.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L64/lNRtIm3Z9LaKAvyC0ETb8rz3NkQpmSsvTiEBR6JaOjY+un5jc/i6aLg/NNs/eZaeAg45xHd8adfpscwK9eOtTc4ZYAZcEj8rp6dehtZUZGzM4K5W/CUz75tEGxHaOp5gfvA0vSnUyWXDY2I4MnbIJoy23gjUlaKV0UO2QROxQuhgIO4LcwhWtL9VUBdNMtcV9aMU/g0Igf6jTA32un7pgKvUSCTDoSUIH8dAIdvqyBy5UG5nbysv6BzpsVCvgboBYdUhkU0fjfqk4kQ0VIUNj6NRMjAwPgi4CwoSlL3NWy6qS1ak+nQssq8uQTI3r0Tz8H9wQKqqgbQHbhu/5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VFbaPiEQqggrM3E1kQS9iuMQVuWLgkzBtYhFRkjJcy8=;
 b=KOOISuCHad8lwrVDtg/QKRF3f9plq8GnM+K8f4+sjypIwuelP6RUhUSjV5eQj2CI1Dou7OfU+x97KSQouUaZ5WdPKWD6fxbouV3vgs5lnqjZU4n66WVfBF7yV2wSsf7vkeL7a4dZ/tnRfHRHdnjA3pp/6YK+Fu5K5iudfdIO/o0Jgd6Hix7Va+GnK1vCv/JOlsqBmcpDxfHgyjTykyISWtxUaDaNOyWOxAZhSVDCMCXzq4oTf2v7NMoe99oy+M30iD0lsl2aarg0O4Fc/maSBA0+rFYqBj6DmibnRdsjTqtFy796NPpEOkjtB/297/IoQDnAfP6KUXExfofNT3vJug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VFbaPiEQqggrM3E1kQS9iuMQVuWLgkzBtYhFRkjJcy8=;
 b=liNuv6qBMxfIbIf77bXIiO7l1MeecmeY5GF+d3vhTPYyFK1BT3McIapH/Uk8ARz9VFgvtKd8areItsW4yYLo6PT2QjxPCPjLpG+P4l/OWMHHhhk6ZADREwGU+dBtqHUgU8f7XKQrsEbR1g3b9cyF9YefZA5adOph3O0rLt4s/i01ZK9os2DaNcGWxJCkwVge2q++Vi5YbGQOawNgzAzKARS+dMFYhiF6xQLZeS3hQHuihER8qowZIA7Rpm1SGpFHHdnSV/9GC44KPDo2kuh+RmNFjxOPYdKKaVsAV9jrFf7NN0sMmSjDbt432yjCeIH9Oz0oEzZ5PWCABGctHmuAiQ==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by BY5PR12MB4084.namprd12.prod.outlook.com (2603:10b6:a03:205::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.26; Fri, 19 Jan
 2024 10:04:22 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::e23f:7791:dfd2:2a2d]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::e23f:7791:dfd2:2a2d%7]) with mapi id 15.20.7202.024; Fri, 19 Jan 2024
 10:04:20 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "brett.creeley@amd.com" <brett.creeley@amd.com>,
	"horms@kernel.org" <horms@kernel.org>, Aniket Agashe <aniketa@nvidia.com>,
	Neo Jia <cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun
 Gupta (SW-GPU)" <targupta@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, Andy
 Currid <acurrid@nvidia.com>, Alistair Popple <apopple@nvidia.com>, John
 Hubbard <jhubbard@nvidia.com>, Dan Williams <danw@nvidia.com>, "Anuj Aggarwal
 (SW-GPU)" <anuaggarwal@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v16 3/3] vfio/nvgrace-gpu: Add vfio pci variant module for
 grace hopper
Thread-Topic: [PATCH v16 3/3] vfio/nvgrace-gpu: Add vfio pci variant module
 for grace hopper
Thread-Index: AQHaR/gAEOL7lpwjh0CYcImo8660H7Detk6AgAG/dl+AABtv/4AAQBMAgAAcU2w=
Date: Fri, 19 Jan 2024 10:04:20 +0000
Message-ID:
 <SA1PR12MB7199BCEB5DA1B2A985B6F181B0702@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20240115211516.635852-1-ankita@nvidia.com>
	<20240115211516.635852-4-ankita@nvidia.com>
 <20240117171311.40583fa7.alex.williamson@redhat.com>
 <SA1PR12MB719904680D5961E6F1806F12B0702@SA1PR12MB7199.namprd12.prod.outlook.com>
 <SA1PR12MB71994FAB7CCB7A39AB4190D4B0702@SA1PR12MB7199.namprd12.prod.outlook.com>
 <BN9PR11MB5276124930AE10F1AC563FF38C702@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To:
 <BN9PR11MB5276124930AE10F1AC563FF38C702@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|BY5PR12MB4084:EE_
x-ms-office365-filtering-correlation-id: 1b0bc0a4-db23-48bc-1ef1-08dc18d6019a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 BHuN8OrDw2E9sSIU1Hx9yGoPP3DwgoVgMenu61rzXqmRoK8zi0+GTUTjWXY/8izy3j2CrhiDQciJPQMpbM/w7CmbuT2k7oUpH5J5lXhaP+afOVFV0faLsO9hujklnbJBIJ3w2ODIyzpMNegjlOwkU7mekfFdvrM3ASc0QTQC3xo6prD9j9PInuWprURZ7BxU0fuLNcmNsci3xMiQesEDwvXbkRTxCJ3Yj9pnKqjCQnOLjXK43fRaLkA5Xjer0vEczTQwBd12R6cxhWHSNoced1JwPeWFPSHzMeGRG2uIZbC88rlygqRnYG2ueyLCSEKBiyUDTv/VSsn7cvzLv7yT88vji0FScVw80qG7pGcai3KAfPhMquRdrbEK1S1SSMRTqpkG0xsR4bUtvxBYwTduO6WqwNpfLUCR1gPAaXsdfTFHTv53+junLXs+HlCB9gbs0DX4/4/nBGRdrM7y92b0Vwex6Dti191neKwF+LJyMRC/4elCYKkhPhG5hGWyBbslFs4wuUYRw47wpZo0a/OMhrSACDImMl4/hZRKYVKGm4FLFh0BMdOQBXdZ55URpRzRP3/QMNZMR2oB8p4kYK5fGWVTGfZOhHgImFhb4iDC7OgIxrHmvxOqQxYLWs6uVQoM
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(396003)(366004)(376002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(7696005)(26005)(6506007)(71200400001)(9686003)(5660300002)(2906002)(4744005)(52536014)(41300700001)(478600001)(110136005)(66946007)(8676002)(8936002)(66446008)(66476007)(66556008)(4326008)(76116006)(64756008)(91956017)(54906003)(316002)(33656002)(38100700002)(86362001)(122000001)(38070700009)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?m46PXqvJroyCKMerxxH1QhC9/oHMeIeUbIDJoeivYmBq1v0WeswT7+ADE8?=
 =?iso-8859-1?Q?vNlp2t9GMns7fxC/7axz1zRwTPrFr5HtvJ2H+9VMb5FEOkPKpJG+b2M1Le?=
 =?iso-8859-1?Q?JL/xUA2Ob4jhZFhS0UDEjd0ydENRCy7wq0AoJZGJmnfJwoYaYGHJMwxUd4?=
 =?iso-8859-1?Q?Otp/9270dAtuWqAuacO+8l40039SlUJoXVmL/6hH5/Ih6sSoAyPEld9icD?=
 =?iso-8859-1?Q?offv21J7pXgMiOiFByiA0oLjRh2Jv1UbOAVgXRUowlpNsLEquEkish8F25?=
 =?iso-8859-1?Q?NWXALCtEO/yd3moSR++HWKP8Q0aEgl8HKzZQMdcyM3iRsoQIZKITxCNh6n?=
 =?iso-8859-1?Q?rg3U7Ib87qdQSrChpEkZFSLjBCoHfXN/dWmnZ166lMJ2vYt1dn/awPWH17?=
 =?iso-8859-1?Q?e4GU0IZ/TvxE9e7e1hLxawWRFw4TOilXszrqtXvJbw1KJo8BBWrb4DBWaK?=
 =?iso-8859-1?Q?qVNcia4TKAW+tlDYjOIimcx18tZgLq9ebpml9nQJdWH/6SMD0CHKGm5WsC?=
 =?iso-8859-1?Q?8MeWOCWW+G4LF9INUzXMZ/wtd7uG5duokvyeHTFxcSSUoU02D6UCYCNO0f?=
 =?iso-8859-1?Q?vYNVWiYlT/umfG9km6VHA08/VBOcSZOZRDhNxOmnIZkhYGZ4KjCoGffveC?=
 =?iso-8859-1?Q?kwaBMIt0p3onRwMQ68EFL1E+WXgPK632Oqv9tAkirNvBnCy/W38LZYrYNH?=
 =?iso-8859-1?Q?qgjqvhnldcU43ftwjXeN7hZkMec/GdSc+zT6S1rvR6ZxI+OI/OzgGtNGtH?=
 =?iso-8859-1?Q?WDYNsBJHuPTUCUpjKj5tqHWDfJjUZLZiMzDSbnCA3U4M1SIkkgUdd4VMMb?=
 =?iso-8859-1?Q?k+GhU/ZHUVnrzX2GtiVbGJMKSi+MkvrL+owGxpb3u52exb4d47BpNZz+Bs?=
 =?iso-8859-1?Q?acFgzOIrgfCM5OLYRChYpXO2Iood/yYZp9xpx3KO3udigznPLp3N4lnZ73?=
 =?iso-8859-1?Q?05TeXRiK2F7RtEUSOl2ewM4N3F5zOPQGl+RFambISzMYtoLMOOwL5KmVn8?=
 =?iso-8859-1?Q?b1BMNhcng+eTCEHqC0fsIrRg1mDptzOvPYiuhcLvWLLtYeNN19TedHON2C?=
 =?iso-8859-1?Q?GKtHWS9FNUONhm4EDNdFnwPox+3WHokRaLgVKIJZuAAY1WKZdlHNi9w6jn?=
 =?iso-8859-1?Q?G7gDbul2erUCLLjSwlnHfJuY4VAEFqy29S2cw3J0kX/nIq3RqEhBVGOwBb?=
 =?iso-8859-1?Q?4P7B+cD9znWYAQCKVgYWrs/7RTD+JkKIZqemlOitfMRL+j2vgYidPjuxhE?=
 =?iso-8859-1?Q?k+8aW/ejubeJX3t5B0rfkouxsdGLx53wiyNRL7sciGEVCUVYZ7TI9MuO5c?=
 =?iso-8859-1?Q?Qhio6RH9DdgW07uL9ejwF+h8CiH8aFT4RsYjDmYP/6rRG19GJ6YNO3WfWf?=
 =?iso-8859-1?Q?VM21E4wXveQldv6uFwHUWqT3NcLIrjwvWd9wvn+HXUXCTK3HoWYz98dWAj?=
 =?iso-8859-1?Q?rCVnpqKgUC1nzU9JCumDN05sx5foRNc2IhIPngjfZhvQEYnBAm3WN2O5tf?=
 =?iso-8859-1?Q?VJA62njWiph7qQ9JmyRXERiSglnR+w9UPnfa6kiH4fXni61qDy7HlZVeEM?=
 =?iso-8859-1?Q?9MfyWSAFFrcupEU+Cb2GYy2A5aSl8As128zvYGWriV9DThAaZpHOrqZT26?=
 =?iso-8859-1?Q?3h0FRNG9k7xKI=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b0bc0a4-db23-48bc-1ef1-08dc18d6019a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2024 10:04:20.8292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bAD9hHk3GiEAlrV7TAvOPoGtNcMcDDyU6ilvFb4hPf/mWSAtLQYHhAVMGKDi+bRz9ZSpLJ4NLeOpMlt3oMH9Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4084

>> >>> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>=0A=
>> >>> Signed-off-by: Aniket Agashe <aniketa@nvidia.com>=0A=
>> >>> Tested-by: Ankit Agrawal <ankita@nvidia.com>=0A=
>> >>=0A=
>> >> Dunno about others, but I sure hope and assume the author tests ;)=0A=
>> >> Sometimes I'm proven wrong.=0A=
>> >=0A=
>> > Yeah, does not hurt to keep it then I suppose. :)=0A=
>>=0A=
>> Sorry I misread the comment. I'll remove the Tested-by as it is=0A=
>> redundant with Signed-off-by.=0A=
>=0A=
> and your s-o-b should be the last one.=0A=
=0A=
Ack.=

