Return-Path: <kvm+bounces-36563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E3EE6A1BBC5
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 18:53:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48BFD16D996
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 17:53:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D3461DB158;
	Fri, 24 Jan 2025 17:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eee6uSiL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A061E288B1;
	Fri, 24 Jan 2025 17:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737741210; cv=fail; b=Er3RInneJ4PED60eEbOdjBxIQ1nS7oYK14mp2z7MxKv7zSY57MkacVyt8NKlh9Jok11xofNE6ye4G76hWTDnjTwvgeomcpbHE1NK5ddAHTTacPzQH+pdvw31mK0GE0LWs5NxsJI9xDm2+U6Jcr12SHg6RosqDEjwdD1Q/HZkZVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737741210; c=relaxed/simple;
	bh=WpMYaWk4JkoayQO8NCn+Uma5/qLjcKPXE0waYQAzZ4o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Yy+ZOV1SUC+t5k/15qvlF4PW4TuXDgZylOws70WKgbJ662T449bGJRjk3wF/gRBAJ7avsB0SI2B92KQJi4OvaKz1/FEEypVHi6fkTNtrINbO3BrQ0SgmPkjJL4O1ND3QD9Hwg5pnIIWOfX4X/sQKPVBEtovFtPNWTh7hBnbzbrI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eee6uSiL; arc=fail smtp.client-ip=40.107.243.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NmgxqB7LqC87MEgbl35oMqJuO7gL+TpZBR/xjdMAz9GEP+jDFRo0SCr51kSivSeyCXtNYl//pe/LlwtpSmAitCjNccRu0+iWXYgwI4QJPtacsnx/xPipY6ZHSEZdvg042igQjhvSH23vh+rhrrE5bbNN3/7YKLTnroDFSUF1/dUB5VtibjXy0pO/quyB661ZSgCr0m6gRigoNjU+iF2m+JqU93qRGAmDNcWVOfJhh8GjtPakH7oCi66yeTJw2HMQ8zGEsBAg9eByQbDeiYWVPYM0iAopaHQ8IBZ/v/Qusd0Kt34joomqrFpe/i1dTjqmNx/quyVxqqhU+zOFHeInig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WpMYaWk4JkoayQO8NCn+Uma5/qLjcKPXE0waYQAzZ4o=;
 b=FHto77Y/HpQ8MWqyFmhhetYk8WRmEzJUonL2c2vy4hoG2FbeMbYzuAzbfsYGlbdviwFQ/TeXFTwVKjuVL+zYyUO5MSfOGRfSYn7TTCJ8nFXTnjbcyqXKsTFcobkbWpoAMJukNQRJcisB/80kV4f3pFHrKU++Txz2OVrEbi/QJdKMm0E/VmGTVlGSwIeI9H3SI3OTAI+7KYpoLc0thwlvSUPsagHC0QvlKDuFB7JOsxBFUeEpHVL53Is2XE/LfKpkUHoPQU32LaHVis3QnpwoxH4/fsTkjH7kqor/gVQ8CBUkucrfNq6DG4CRZxI2OeZT4OdiSP8t01cAwm/SisQQpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WpMYaWk4JkoayQO8NCn+Uma5/qLjcKPXE0waYQAzZ4o=;
 b=eee6uSiLRVXi37I1fuFk1AAdOI0BvcfxG+QC3gav9ir0JlCeAbtpnqB+pmvWo/r3G7+fYJLNZHLBCPhOoOiUDLp0MxabldylWecvbk5mpgf935g4pjcpKFXZmikGXUIJHT6ePuS/3Uji+LoR+NlfMUXKpk/acXQLPBbkT4TYnvxdeSgcbBl0RslqedKQNjfQMfsmXYObm+WuCntoDV3k70+rhYSPkHzxhPsDuS7LnmkBKdO6Qc4CTDrwjTPpszipFP13YePhD7QFXjQT4aQKqVQpQ2PxvPso3dFmLHdWHuSVj99QlleGWsudNP0x3W7SlGw3CU6GfkGek0zrVvj0JA==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by CYYPR12MB8872.namprd12.prod.outlook.com (2603:10b6:930:c8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.17; Fri, 24 Jan
 2025 17:53:26 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%5]) with mapi id 15.20.8356.020; Fri, 24 Jan 2025
 17:53:26 +0000
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
Subject: Re: [PATCH v5 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Thread-Topic: [PATCH v5 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C
 link status
Thread-Index: AQHbbb8kSBJE6ytOFUC737eJaZbHybMmHYeAgAAYE0Q=
Date: Fri, 24 Jan 2025 17:53:26 +0000
Message-ID:
 <SA1PR12MB7199C5FD0D564C6220C07DDEB0E32@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20250123174854.3338-1-ankita@nvidia.com>
	<20250123174854.3338-4-ankita@nvidia.com>
 <20250124092459.7ef4df51.alex.williamson@redhat.com>
In-Reply-To: <20250124092459.7ef4df51.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|CYYPR12MB8872:EE_
x-ms-office365-filtering-correlation-id: 5c525d9b-0424-4be5-f8d8-08dd3ca000ce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?S8sz8WWYi/zz3fsWcs0iWZoOp1Zop7TPiFCpksLAXOavgsjupXkppOtc92?=
 =?iso-8859-1?Q?8H+po/hlbdAO2bQHZ6fQqoaDIz6V+glfROhVCLzGbFw7ekQdZTAOqpEWio?=
 =?iso-8859-1?Q?gPlUeCB8W6XoPxnT1bg5lsIeMSH8/YPoYSGDfVSY7uiIWgsbGE4bDXz/w1?=
 =?iso-8859-1?Q?GeMxejueyddKbRqSmKJZKKKJ2i1rTf4wmdKnbA+KCw/xhvezYW6wd4FkiY?=
 =?iso-8859-1?Q?xTOWYgYdimGzjkSvpObXrMUt1zMj8cIIS3RKsuKjCePpGWRMlBxRGukbKw?=
 =?iso-8859-1?Q?zetyJ/59s72M2ORfbAcQpect6tISgtsns+/8Arpp+Xeoyj7RY2dDOTg7Vw?=
 =?iso-8859-1?Q?oFE1kZdYY+UybjCo0vQuSWQ0FVIHTgAtg2NQqtQXmbTWa4xXvwG5+w9sEV?=
 =?iso-8859-1?Q?7tsTpMpnznx6SNVuc+PZveesQMVojIhCCSYPBeaok+GxP+Sim7A7hURV4c?=
 =?iso-8859-1?Q?b+HqOUTOXUgg/Fo6ogtJUmCQOhz9zfahibDlaH+z/y2ukrrG6JGw4xggxh?=
 =?iso-8859-1?Q?FeOR/WE8D6z95Nsj+LJiJCe7EG3o74vCDIeF6YBEIx/iGsj2JfkufhysGJ?=
 =?iso-8859-1?Q?rsQZIHBFv3sjwr192KdCjrfW1j/3ECKqPIQJmnzu9oUOkScX+NPuxTP6Qs?=
 =?iso-8859-1?Q?PKw+an56HxNDeLFhpIvkDFZOp0ntNrPWXfh6KQC5PrShTRR5ObhLC7s3R3?=
 =?iso-8859-1?Q?y/daKY45SrEEfFrhbJiCnSZxeAT0VidtFSs8FbVGR048FBW3kl0Wvs9iBW?=
 =?iso-8859-1?Q?K/+qoI2wTRhbvkHXyESqqEmfBohx8A//hXDuIMP19aSSZXAj5G6ZHs7XJo?=
 =?iso-8859-1?Q?hQ7gcL9VHEOkmNwiOva8xzG8UVUMh8jBYF+5G7amfvrdfZWWN8/z7QJp0q?=
 =?iso-8859-1?Q?BnummUiALT9S9VpfUlPtmPsgS08Y4TG8Q3hS8xNcJi3RSIKYo77yT1JLZm?=
 =?iso-8859-1?Q?32Qq1ZRcpjlCRqvPDqWjb1P6JFu5qtxPF00i5Uk7CqzghJTrkQSHFAtqsN?=
 =?iso-8859-1?Q?777UE+a29AZ02CDLp04Pi2rl8Q/NT883ruMoDWhRxGCWVcnn7VMtcHTlXt?=
 =?iso-8859-1?Q?K4fxnaOFdAotk7BMPCGvedN8Q64O4t4vVzrOlpgR/RMd503GAVPe1jjq9v?=
 =?iso-8859-1?Q?59tbMULAsXVOy3Y5twl6O20oDxpVw8yvaDOSZDvwF/OBcPGVxAV/TVaBnr?=
 =?iso-8859-1?Q?1/VwVEUXlOEaLHopzsXSYRat1tH0Lw5hSGLsQyJ8w8qdzjezUUU7LFADUr?=
 =?iso-8859-1?Q?8TDqtdAh8YEjflrRtXoIhwQNT67gb+88rHjt1rSwGBObo/rMnmRuZ+N2IK?=
 =?iso-8859-1?Q?wbSIAo2BqGCLkfo0FkYDXzHhbfSh64Vp+x+TKF6DMHWAU2SWTysR2WgHqh?=
 =?iso-8859-1?Q?M1kU5rZAmR1bhqYZsqSXtBSi29I3To/4ltDinD6eAeh4HVtNo6L0YVXLVf?=
 =?iso-8859-1?Q?MaJNb80p/yUr3E7a9E5YAOcmsRVLS9jzuj4DeqcPr1p4n73AUv2gUAK9Qg?=
 =?iso-8859-1?Q?IBGrP73iZNCXgVlkguJ4Qa?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?jZ1nv1YATDBlsu9kHFaKPeUHVIJi/3PlU4WtIZS57T4Ay4LVyWuj7i/RoO?=
 =?iso-8859-1?Q?Q+WicJoWS+PP/V4K3jEVrscB0fwJwGyggkv5jIIT/j3Dzi9srNa42C/50R?=
 =?iso-8859-1?Q?XmKr2lkvqOzOU6XIfVMb8tV7oju3zIt21yvIRMJWt/2TiX44bv+fTWEB47?=
 =?iso-8859-1?Q?g06hAcYxgToXwB9lPyWOIWag3QnrCHlwVpERDtxwSytLui4kUBJ0/mbGS2?=
 =?iso-8859-1?Q?7SmR0sO+ssOVe+KY5TVnlRs3jElYwDBkZg5TkUNb7uEzVsMNEnWPhimu1t?=
 =?iso-8859-1?Q?8PaOBTCZgOOsbcMjv7i8yFjCIoTIrpMwMyXBxbErNsoFqUZmhESwxWQSUI?=
 =?iso-8859-1?Q?YZZbWRhSFJ9mqaJtmP9PRuTP/1oVJ6ryBKmMrIDAY2r0hGZc2BaDxz862w?=
 =?iso-8859-1?Q?51OEPKsRImnWx3TETaFscOppiB1dtQG+nB+D22J4UwKAIXXnGOno6Zc5E/?=
 =?iso-8859-1?Q?cOo8XmjVwn31eQeQ6SxkwZT8GHtcMiV/SSadPWmarbbuPvWvUy6WqWngtY?=
 =?iso-8859-1?Q?k8rw00B9sxVGnGQomct3/r6Z+s3res2/shKe5ORUtPBTEcrPTQFhcTuStz?=
 =?iso-8859-1?Q?HLyR/S2n76OokR+2MjpYMsY9f/Q0sSzHN6NvulTxrKYtbkIxQrAcWXsDca?=
 =?iso-8859-1?Q?6Uu0HVkcEYl/wlVoPVCwZ7LHIkxbVXr4DBmWVYrS/bvatCP4Gwl6Rw5h75?=
 =?iso-8859-1?Q?HvUy7FQrFJ1yKnTpS/yUU9TtPkTHYnJCxDV9PPP4wT4wYTQTkuIoUR4fxU?=
 =?iso-8859-1?Q?/Lj9mqAkp58ZeTFjBvXgEKkA8dfp3KdD2L7zWMwvGLqJmP/7jb/KZes21F?=
 =?iso-8859-1?Q?K/LUtv3TKhna1r5AfwRzFFC/2CssAxbG564STXX281rrvkot6q66dDjS6O?=
 =?iso-8859-1?Q?1FTP9Yq+q/grsEpECXyCEs3ZssIYw0pNcguHX/EIVltdrjlvevIeaLR9oz?=
 =?iso-8859-1?Q?xhG9ppiSKRBzroOrj8uZCWEkSeZKr/J1P+AxQzR19jHgW7WrFQAeu4KILI?=
 =?iso-8859-1?Q?YsQD/xjFvl8XSuzw9w7xZ1pLpHAWK3jO5L+AKcR8xcL/3V5QhwkExAusJj?=
 =?iso-8859-1?Q?lx583lNK+h9X4ms3Inhfj8I0UcSqSynjmDtyv6bRMR23FfRv3/1YSBiCDf?=
 =?iso-8859-1?Q?8fr95Ri2geO94SSKoCIwg+32Umt7XsM3lonXrBhybInCE7VRjumitZBYgO?=
 =?iso-8859-1?Q?tRaxDXtyUZqxOSOKjxw6hNlTQeXffV76kIzwtC3wqvWxdOi5512d9/qytn?=
 =?iso-8859-1?Q?eanAKPynJc60uS3FrX/73UMnPSBMxqgseunltN1iv3AMKJo0WC31Qg9sRX?=
 =?iso-8859-1?Q?w5Osc6bKw5Zh1Ju/5YjROvg65yTvB5yfUpy9bKrEBVsCxiN9EYSaeZBfZd?=
 =?iso-8859-1?Q?UJnrf0QlZ7CvJ5ZptA0fGSnKOyRN+Z5WRTWL6RrQihjmkaytv4hzhrCro8?=
 =?iso-8859-1?Q?RhOs2KDPCgH/6VMV9HTIUf79EwWfcgqLA2JWK0R9zEP/YvmhBvH7pcHbyP?=
 =?iso-8859-1?Q?Qt9n9NZk6cr6YYzKBnIV9Rg7rol8PeHkev7qsHDMOrf+DUxcjaXDMQwd8d?=
 =?iso-8859-1?Q?oMGeRsUAXCLoVrJOKA538/jfsebb78hD4/FKa6e181Tm9SnsHId/FU5D5Z?=
 =?iso-8859-1?Q?/KpxN1n48aMUM=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c525d9b-0424-4be5-f8d8-08dd3ca000ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2025 17:53:26.1879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9oZqF+P2yRDaQZHt6zeWFkBviuGPIBQwlssszGZZNc9/Meiz/7xqL3HZeZK6lD7yzEApGdvnBokoyhCKYU/CcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8872

>> +static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 unsigned long timeout =3D jiffies + msecs_to_jiffies(POLL_=
TIMEOUT_MS);=0A=
>> +=A0=A0=A0=A0 void __iomem *io;=0A=
>> +=A0=A0=A0=A0 int ret =3D -ETIME;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 ret =3D pci_enable_device(pdev);=0A=
>> +=A0=A0=A0=A0 if (ret)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return ret;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 ret =3D pci_request_selected_regions(pdev, 1 << 0, "vfio-p=
ci");=0A=
>=0A=
> All the overhead of enabling the device and requesting the region, only=
=0A=
> to undo it around this simple test is unfortunate, but I think correct.=
=0A=
=0A=
Yeah, thanks for guiding through that.=0A=
=0A=
> Even though this is only briefly taken, I'd suggest using KBUILD_MODNAME=
=0A=
> there rather than "vfio-pci" to differentiate from the core code.=0A=
> Thanks,=0A=
>=0A=
> Alex=0A=
=0A=
Understood, will make the change.=

