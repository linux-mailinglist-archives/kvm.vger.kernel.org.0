Return-Path: <kvm+bounces-34967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA32A082EE
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 23:46:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AEE007A37FF
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 22:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2385205E13;
	Thu,  9 Jan 2025 22:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="StQnK2Cb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F87E1FCCF3;
	Thu,  9 Jan 2025 22:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736462784; cv=fail; b=RUwh3GD5PkZJtwQLK4FC3uTnWbwxaL4rc1yQ5CRFQ442VH2nMZNAH5n4MvRGY8TEeT4Ut5BlSga4RM/+4IaoAgHSYg9EU6pHUw9wgmULtMB+8qVL59UsA8wdkhGRDVDuzYD2bsLij4tuFtwveCD69m1tbbWO4Zbw25bcs+7rKqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736462784; c=relaxed/simple;
	bh=sN6YNLoAei7LYvTz3w+rFV/gdJKnuADnXRWmQk69Iow=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KUV7kRCUHBLfWakPtdE9hw9Xdnh/VdP67+cCwz4KclWSnJ9ScNQwnhPmWNgxfM9cZ59oFjE7nbUuDF2VnRG6e+4RNSK3KZQ5SdSnbXONUwgB0pqYeZSxR/by+rRqmZCL5zgbF/us/gq55AgP0uOwRs3YhyYb5vUIw2o2LeUl1YI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=StQnK2Cb; arc=fail smtp.client-ip=40.107.94.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fK2qyX7CAuPswPVE3Zmfsm5cwwfilnUg1ZTRq3x7eSR1sSVr2l1Cfugva0AcbK1t5n4NFcExTslkOfFxzZd6N3Vlw75gCktMinkKYFnMdxDSzPNZLY8VuFeb9s4+TOHbdtMh9AK2FVwKv4J3/a+27urQHAPX/Z3crgRcYfWOLSTXP76S86568/oI8TrOtCMgN3TuG9zysuthqRGj6JK1s+8FcJFMNoTFemxxwS+w9DVZyCxb8nhp0Xz4ljgY0+pbOtxK2tq7Oj3l8Ycwg4kcY6rBZVXsRuI9/BZLwOrTjKmeJb+wVcWM13hpw7MDKcHDit2zjOJ6bIlHp26PbsbVYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sN6YNLoAei7LYvTz3w+rFV/gdJKnuADnXRWmQk69Iow=;
 b=sSGzRwqQlW7g3DKO3EKPv3jRRhxzGg9mLWGcc78ONzhENvB9De+DSJPk45Evec3/SOM7V4Yec4y1DC9f/GEi0LG/QTrMluYeWpblYYRN7dWS6muQkYUJ/EPQWri7bAc3LLOl/IyCBWo1mXM4b3jJCI94nFYL6VkLurvgayNO4dbtVVgQP+erlzojKZu5HbjxO3hzwzopYImuuNsh37YtXAnybSKIktl73NnfzLo5llns5NP/IyauZ+UEI7EcYYHTSfaJCPEkb4l2/3AgBuN2b38WsCpa0CDtcrhXgt7MPK00PdKmHpC8WHTFbgfX3BJEqaYDjIf679QjY5mDyKZBSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sN6YNLoAei7LYvTz3w+rFV/gdJKnuADnXRWmQk69Iow=;
 b=StQnK2Cbsb9KDGxN+Y386rdVnkQohzp6uR83D0K9OaacEORQJy4UwdDM8inOMCdFhv+VdVfETRyarbCqEGezfDjcJ/uXplsPB9ht7LyzhO6OAewgg5X/LvT7ztOmFsdFzvHOu7AgWnebMkx/qI8fdKjlklJVpqF3YjuFdDTYF/QoRgYj2v9Jx/j8LixtXrIMIAZ/f9DnkehRnIU/SJP+DWaJjlOSbyfJzrzXExg30xj1OQszG5rXc92eAbKNmiUHdh4/kXZXyijSYSAemQVbxTdigwb5UEhQ+LPRJDgpzydJY+B0SNntqOgCPI9MQxltFqgEOPV/OdmQxonlaPBYAQ==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by DS0PR12MB9040.namprd12.prod.outlook.com (2603:10b6:8:f5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.11; Thu, 9 Jan
 2025 22:46:21 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%4]) with mapi id 15.20.8335.010; Thu, 9 Jan 2025
 22:46:21 +0000
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
	<danw@nvidia.com>, "Anuj Aggarwal (SW-GPU)" <anuaggarwal@nvidia.com>, Matt
 Ochs <mochs@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Thread-Topic: [PATCH v2 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Thread-Index: AQHbX5hfWv1IJvOySEePzX0lec0w0rMO6LyAgAAn+Rw=
Date: Thu, 9 Jan 2025 22:46:20 +0000
Message-ID:
 <SA1PR12MB719909C3C49CEA0FACB2DF76B0132@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250105173615.28481-1-ankita@nvidia.com>
	<20250105173615.28481-4-ankita@nvidia.com>
 <20250109152045.6d782850.alex.williamson@redhat.com>
In-Reply-To: <20250109152045.6d782850.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|DS0PR12MB9040:EE_
x-ms-office365-filtering-correlation-id: 0e48da68-383d-4daf-a3d3-08dd30ff6fec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?tTCVm2jylt7qw+wVwuXFeDpIKMHbzKJ/Y3Wf++2CHOxxl16qHT1Bh1aXlp?=
 =?iso-8859-1?Q?ZJEXehHGeaQRp/k9xKum6ZRDuJgRHw98RiEooD9lbzJl0i9V8NRVOvMKTf?=
 =?iso-8859-1?Q?mUumblZLoK7M2Z4gFB+cDGlIIPDwsECD9PvsVSsVHA2K9HretjOVvmAZ8I?=
 =?iso-8859-1?Q?0//Ly80k0WITKVEAgPsXtrZ4IZth1GA8N/p80tiFzVypj0CJabvngWnuRW?=
 =?iso-8859-1?Q?mGlfY7h1R+J39IOWqB3cjQZw4Wvw6dr33gDUtA6jVK72UZG4TdIoIWOCaL?=
 =?iso-8859-1?Q?fmuj5qS+xC99plb4CZtWUdywUlHTKV0tKOYKGwUQ9ptj5l4At5Yxq0iFg6?=
 =?iso-8859-1?Q?2zcEjBBO2wmMxHQYmltUlwQHyd52npAvMahj1i1WaP5GKUtuG0V+Vwel+8?=
 =?iso-8859-1?Q?ApeAUkJ03OTUdJWnqVu4xFAVrIgv/Ai1jF8BnRyhRq9B7dtw18n9BOdTbp?=
 =?iso-8859-1?Q?KjxjfGbWK9C90xHAMdcRQI/ypbRtIDenahNMXbMTAP9fP/zFCnmL8tlacF?=
 =?iso-8859-1?Q?GhbO8ziZx/ydK+GfRgNtbujXX6aoPeuLS4AWUAC3Q9s0P8RcZX7i+ALfT8?=
 =?iso-8859-1?Q?zMIqB5sXWSQhg7IyuaEZbEo2oESsbxfDADWvc6225NIQzaGmosr2uxDQrC?=
 =?iso-8859-1?Q?AGafNG9ALTMhYIKjww1ucdCdT3guMV1dJgrQqreNZ/g1GozAZ2hfr8e5Yn?=
 =?iso-8859-1?Q?I87JQORuEQXu8WrDE+wamPrfZM+rWpFFq/qqVj7gec7H2SbI2Yp3wQ9noz?=
 =?iso-8859-1?Q?qXhHcxgZg2077iI1E08FNw7cQGC98tamOfdK+noTfa7AniSYsvJb+FgxXq?=
 =?iso-8859-1?Q?gROQnALn9bLjuIN/ciIqVURFO5FP3bbyV15lNPpYwNLVwYLXNYbEoQ4We1?=
 =?iso-8859-1?Q?UMgqc3N+qtAkf0Vjz2SCx1mEW9ILPJHrdEEhctqPTHpOuZHTBeO+Gcxjcj?=
 =?iso-8859-1?Q?iVvMdXO7N2oVhOkjnaVwy+XBlKqf41aVH+QB1UVtmT7kaQKM4CKnO5SvE2?=
 =?iso-8859-1?Q?Y5J3q5iI4jPRWIV0KsW+a5xTfU1LhJwRHf2Hy85euo8ML/SoYfi9wAXvGg?=
 =?iso-8859-1?Q?d4hOmTx3RmhseFggY7QetPS8bN/GJCs2fUVOsU1wyBLncwahBzamVEW0S0?=
 =?iso-8859-1?Q?RLot5o3FZXCoBdSKu4KrKJySmo8RUSzqi5eNXem19/ZGEF0ZBt9N5XraU7?=
 =?iso-8859-1?Q?CGuf/ss4pT37XTVuTC90tCtFds9vC2QOYkpbyP1u6iGS385+1PRpjcZd5g?=
 =?iso-8859-1?Q?75OMYMUfSnv6yut1AiAymlMfxezLHgkU+0IB1NvWgoFHKKTfscuUfXTxgi?=
 =?iso-8859-1?Q?shyTkmWvPEj9f881Rk7D11OFvoEMtWLfoydvtdNXQDpRqyNQnyYCYyRSCi?=
 =?iso-8859-1?Q?EDwy50hb2a3nqXl3WHnHHJm5kOXASByN4fwUyLRLT3yDPUoF+XuH1n3DQC?=
 =?iso-8859-1?Q?ybQD0xCwNpgKRS2E7coXocXD7VvR1E51hShm4kGUx16N9C2nLJsGoeLtNK?=
 =?iso-8859-1?Q?bnhVdXQgzsB1+lwaU30bIg?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?TerxyZ5Nk6g4FubbUAG5/f3lN9xOp6HTS4WBkcZRBVJb4pipWSsLchUJ46?=
 =?iso-8859-1?Q?uWpR+lZwOsCLWVYkgujrTy5J4REgJNRFJYFw97IbLJ8MYxE3z1mLTuWF8U?=
 =?iso-8859-1?Q?7Ai/uN1BnrqgcXy4jdHZVk2D/vQk3JGKqOYG99LBnwhGqf92Waj3ya8Rjf?=
 =?iso-8859-1?Q?WTXPmLHKArIhyvAwW95PQEiwiGttFJVmqKEueyuGdR8DdLiIrcQcKH9a/q?=
 =?iso-8859-1?Q?zvzhHxbQfnqApVFGEgtp2MHWwmFimR9jeRuw3T+78AGwzQ83F4VlGbo1oN?=
 =?iso-8859-1?Q?4/mTOxa4RWd17dzspjw39HndrjCb8SP7u+PEh8OTvNd3iGMavuXttxzf65?=
 =?iso-8859-1?Q?qsIhv2K0/Azpeyp1YhlYkbTkamjbCDGiZkSKiLV56OIAxVVy6ZUXvvfyZJ?=
 =?iso-8859-1?Q?qQSHChS4wZJKieiF7syho9QDQLhXwo/p8D50T8Zt4cxVqCrzFpP3iRvE1b?=
 =?iso-8859-1?Q?0zouZNXj0JzlSelS4c2DKDP2872m20wGrwIIz6WVrjz8WGWnjtbJHViqJW?=
 =?iso-8859-1?Q?p295eBzCEg+I08J2QYFEiMEh3GtB3zk2DFMyuljyxano4UBuIkg9HjwSbA?=
 =?iso-8859-1?Q?F2GIa3Vn8XjQihQJz7V4wXdSLcaZ6P+C4JPeU5k0wWKFCcYg2dd0F8wwq0?=
 =?iso-8859-1?Q?g8f5nSLlD3tkgU8s5ibpPsMYDB7CGatiJT2wJY0LlTeP/mbRrE4H/c+rN6?=
 =?iso-8859-1?Q?mcdAgsFLrnSmncsdtOxWgJidS1Rb0wWr0fprVgC+JCgcbFtiNnwwxmZmfQ?=
 =?iso-8859-1?Q?4ObkgBQU+UBGAfLqweReo0Cx0vohVKExXXvq4g5l7FAVnOtR7K6PgbXI3T?=
 =?iso-8859-1?Q?wBzpviRh16au18770PWQB8gtTBiTt4r2MB9szaPjpYyn/XK/wctqTV+uSx?=
 =?iso-8859-1?Q?K0yORysvv9PrS4OfqcOorkLxK0lMDrycX6Bg44XNQypgK7mKufqRIr1S9F?=
 =?iso-8859-1?Q?MXT+6gf3z3uTDbz1SS/abeIfjEAketgmcoF/Tcy4E6fps/PQBUoxzPB1Mf?=
 =?iso-8859-1?Q?b76rSILda+nI2KwEwWxfr0vKBDqm5kRudNUbv3LlYKIvo3azVRsr+G5Ns0?=
 =?iso-8859-1?Q?KNXkcV3e+u+2D7ig/X6i+E0d1mgDWkPRc2xhjpYQgCofDpJlVmaQ8vmIKe?=
 =?iso-8859-1?Q?eSLGpEDQixFG0vD/v38bladIGPSWtKfqeot7QgsG7JO8WcrKpfbOMiiknm?=
 =?iso-8859-1?Q?+sskTr6zMBOI7h4ebLIXIg9gt/jiVoS/vNMWiUnbGL90kFP1fsTlkFuRuG?=
 =?iso-8859-1?Q?ONgIVlys1lmln7aDme3blQw90+ftpG2xWa9alXcSSGYel2FCDGRzk832tA?=
 =?iso-8859-1?Q?jAabRbnE7Xf7+P+pg/aSNm6Z8yfazBY7lByFTsj4Q9rHvHAvHLJCvK7ths?=
 =?iso-8859-1?Q?5Y2BoBC2qwB7N7xj4W7ZcSdCgbUryQUS1x/aGI1wYn46ByLKUmwHUE4jv6?=
 =?iso-8859-1?Q?BBor0EkUJ+vaX/n30yZ2KuKLN8GErx4AYVfocpNVroGYEg3eda4NE5hOtM?=
 =?iso-8859-1?Q?A6TJ2M/+Nela/cnx5fVT++8xeD0GKkC9cU+Lnd6YZ0wovppGPPveCcoBl+?=
 =?iso-8859-1?Q?2UDkf8U6q0SyEdkUqpMK2fGIxnFblg40enyNaeM2a8FBCC6r+GUWBUofl2?=
 =?iso-8859-1?Q?2KwXyr7DMJPHY=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e48da68-383d-4daf-a3d3-08dd30ff6fec
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2025 22:46:20.8918
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kF23pk/WCoh3++NuI+5LhkY3igbC5uJY8hf+PKab+CzJoXdQTO5p8m2Kv4AOP2NHGOMVZbeYKA4qjoXi74F9RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9040

Thanks Alex for the review.=0A=
=0A=
>> +static int nvgrace_gpu_check_device_status(struct pci_dev *pdev)=0A=
>=0A=
> "nvgrace_gpu_wait_device_ready()"?=0A=
=0A=
Ok, I'll rename it.=0A=
=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 void __iomem *io;=0A=
>> +=A0=A0=A0=A0 int time_elasped;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 io =3D pci_iomap(pdev, 0, ~0UL);=0A=
>=0A=
> The documentation is unclear here, but existing code suggests passing 0=
=0A=
> here rather than -1 to map the full BAR.=A0 It ends up being equivalent=
=0A=
> since the code doesn't error attempting to map longer than the BAR, but=
=0A=
> there's no reason to add a bad example.=0A=
=0A=
Ack, will change to use 0.=0A=
=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 msleep(POLL_QUANTUM_MS);=0A=
>> +=A0=A0=A0=A0 }=0A=
>=0A=
> time_after() would simplify things here.=A0 I'd also suggest a common=0A=
> exit path.=0A=
=0A=
Understood, will change.=0A=
=0A=
>> +=0A=
>> +=A0=A0=A0=A0 pci_iounmap(pdev, io);=0A=
>> +=A0=A0=A0=A0 return -ENODEV;=0A=
>=0A=
> ETIME could work for the error code too.=A0 Thanks,=0A=
=0A=
Ack.=0A=

