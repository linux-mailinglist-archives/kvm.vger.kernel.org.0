Return-Path: <kvm+bounces-52334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D48BCB041A5
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 16:30:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A8EB18888D5
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 14:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFB402571AA;
	Mon, 14 Jul 2025 14:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RMd1smpA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3CF22129F
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 14:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752503350; cv=fail; b=upRZgSQAXv3l0ynrJfH3rA0gWMkOkLEmNaDT66He6Xlc82MMZpQO9+XWqNnTzidhdHaN5hlKXqtt03gWDiFXoBosX43xns5hRgbdAAtR7VQdVXqq0/xNeU6V5voI7WkeSp+0KjhdGMUdWdA43qp10mbxIlZYMOv5PfhOxtyLUxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752503350; c=relaxed/simple;
	bh=3hz+PaKCnJriZMkFg2nNBiYrTYhXiIwjz3qrFFSqH8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SDSOS4aWxmepvbaYClWGWUnrQlngSFrA6uvFt5xlFZd+G6rin+fp1m38NMcY+G9U5ryaW0wGp5jVNBYuFSnIZmu9EXityufGPqQo75+mez+bIYaYG4+NlGX7UtXAnG3r9lgmlaDpP+c/XwvrvxON70ToHBy6CjiJFe5UIPo9ntQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RMd1smpA; arc=fail smtp.client-ip=40.107.93.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VcSfpXxeuDhLpz4Ce8fReGLZQQU1wAWyDJ3gC7l2wNysUmoqRTi0ahZZhqLp1dxTQiGGRcTE5f8tllzzodsu2Gf+6XO1gjwcVRmnjeu8xmDM5oD4CmUgknm/ygu0uIh7r5GEwDih0FG7kgz2Hx66+Xw4UTplPwSTkq21/ebWJMzkyFNbTtivPpIFYX1h7HryZ/YM0k7/5qWJwI1kdGUNd+utp+HVwuKzpNxJ20wbezvEnsFjzxupTFoTMJkJK/kW9e1s1U7V0zxZ8SWZPY6Ut+3kK5yG+eNJ1vpQwkLFbO/DVzh236IjII5EqKXiF29EIzMSa6BUcVPf3F3h8cAbDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VrAddBCVgyb+rSDDanIrnt3Fn7L+pNCErNYOS+o5ke0=;
 b=TnbPAJkQjnT8KX0wVjAYzAONIVCdvmhMe6F9t1JbrV6XPWIxbKfu4y4JdZVP5BkZvp/+/QRewm49V3vqB7E5AfS7qjif4CK/pQd6XIKSaei8KN5Pkl1Zc1/CxP63KYomRbBVuPx9E6VKluLdbQmXccbR2/E4ZTfAzA/1n9H7HFJEEa56Dl9g0jrIQp4/u+M6VTfgMqf9UgKneiot//Lc58RwbGu3ppdHIa9Kd6qyKv6E6NObgEyz3wBlzclLdKZ/MEQNyrHnTr3mvQHYBA2sf3sqFRFYMiNaXFUczn5P/k9ojfpKIahHmOYxaaJesAsYn0a+3UOCuEZKkYX1asaRAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VrAddBCVgyb+rSDDanIrnt3Fn7L+pNCErNYOS+o5ke0=;
 b=RMd1smpA4KWXzJf+gDo4FZSsMM4AQzJ6rpLGtu9LuUHQ2NWLFiv/lZeTHI8bGwbIIIRxs5snBl6YSmdP+yWb+5fHczNjtNzwk1b7ZBVU1ho53xHz8uEdLs0+fG2y2M1lljLGTkuPkCgZGQ0QNl1Pud3M3HiuVqvEJcsVA+d1Vu5JQkkRrw8qIxqoy3/h0Fl7RIAm+vUtBx0FMQ3q18Kn5zxfBOjH45XZGHT21mVMCICp61Y4/MJkNCxNbRCSQ1wCTunjA5TQCtURCad7iTCG63TsN0YBtuAC/y3uskjyp+4tTYHFnJEiWs6SrXSpvtL+6wJFIuogsZRyaTIOH6bIow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB7915.namprd12.prod.outlook.com (2603:10b6:510:27c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Mon, 14 Jul
 2025 14:29:05 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Mon, 14 Jul 2025
 14:29:05 +0000
Date: Mon, 14 Jul 2025 11:29:04 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: Ankit Agrawal <ankita@nvidia.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Longfang Liu <liulongfang@huawei.com>, qat-linux@intel.com,
	virtualization@lists.linux.dev, Xin Zeng <xin.zeng@intel.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Terrence Xu <terrence.xu@intel.com>,
	Yanting Jiang <yanting.jiang@intel.com>,
	Zhenzhong Duan <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v2] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20250714142904.GA2059966@nvidia.com>
References: <0-v2-470f044801ef+a887e-vfio_token_jgg@nvidia.com>
 <a8484641-34d9-40bf-af8a-e472afdab0cc@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8484641-34d9-40bf-af8a-e472afdab0cc@intel.com>
X-ClientProxiedBy: BLAP220CA0029.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB7915:EE_
X-MS-Office365-Filtering-Correlation-Id: ab947831-7953-45f4-c172-08ddc2e2c91d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9Bfa83P+A55NchijAWeK8FcfCDW2z6LvqAzz+46BZ66pWClVJJuBYlpwvVgN?=
 =?us-ascii?Q?NIqUef7wI7k6LVo8yfA/0bxf8Z+vbxL+qp7P/SwZHF462g7bgRm8urX/X2ve?=
 =?us-ascii?Q?gIrqPoJWRiMkEnz8rsSGIY53409x1lKE576AqSI8/dCUD27Y18d1BgvjRJXU?=
 =?us-ascii?Q?38PGbmw1W5E/F63EUUHjZr4VucU00E4X2/jH3PP4ZxaCsS4uwpsfV4u2etcR?=
 =?us-ascii?Q?INq+LGqXBjU9Zji7FmKnnPC+3PxNTT6F02aU7+aHNBeeawtlb24e0v8kA8Pv?=
 =?us-ascii?Q?dudtUEWGpxZuXXDltkIGC+mDqUUErHJnJYGBkdtgjejnWwCE+cNJ1toJykxb?=
 =?us-ascii?Q?8HPhWgtiV/fiZIsjZujdyvIqswg4Pq8HOhNcM7JL4RNgMYnU6ex6uUzD5WYA?=
 =?us-ascii?Q?YSyLstZmDtdQ5sWRMfUtjXfeoq9IVdVSdW6l7otZtIL5LHX1zKux88VRK63D?=
 =?us-ascii?Q?0P5Kgj7KRCUW/MoIQYGkQrWeXvxdqbQjk0gtoLDayUxAyfheQWBzv2OnyFfx?=
 =?us-ascii?Q?I6O6eAH14vQxRNbUCpQ99MowfPaIuSDnABASEec6fsqIm/C/wblqkbB4/9d6?=
 =?us-ascii?Q?Z6o7E5/eJQLJ3zMwC7Yjn88Q9UDXtu2zLCsNdqPiBkqAkQhvl89GRW8VlEPz?=
 =?us-ascii?Q?qPAZIYcylO50KIdtlHJmcfVsSjLezEW0gILQEtmU13J5B46Q/cpR8ESf5R/N?=
 =?us-ascii?Q?LrI4+wJxeP2jjI8QsWrM90kRWpQNcJy/xkb0yU/Y+OuxY3UqTAdn7BMTag+S?=
 =?us-ascii?Q?coCtgC3jDPk/kJIj5fHbu8+uUF5jriYG1BX9alphwHdy0D/zRL1RGAglzE06?=
 =?us-ascii?Q?CuZbMXQfpcq/PACbeCWCE8nGEVnNfRx0dp9gAl9is/vfcLlOpQAaMNLUInDd?=
 =?us-ascii?Q?bZ0CxE9OypT8/LMOFg1JEwfuBMpegJkxopJslizlZFsnO+3JWuUP5Qn9WTBw?=
 =?us-ascii?Q?DCjCdUH04F8HRBJntdocNOlvY9oMnekoYaFXQvmRZH16o967yDd855IaN9wn?=
 =?us-ascii?Q?iWNnE8ZNNZmSB448Cn8uX1/ii91Ka1ROJJxswlVzNzAnG8e+TiA4rYCM7J/6?=
 =?us-ascii?Q?A4BUR5uNWzb5kWvCxhRWU/J6cxWp/Fpi5r1FmBA1WSVelIPykBg3c1TfLx/K?=
 =?us-ascii?Q?rNcWfmi2+Jj9wQ5q7q56nV685pLdw6tC0aZzVsu6HVUhTtaAUiDr6yr8psF0?=
 =?us-ascii?Q?RegrlVZsh7lw8IDNXNtyXmxSjCBxc7B8aUs7zUaJBgb5nBta/6CoSOR4j37g?=
 =?us-ascii?Q?nXhp+nyR0vsYo+AGrWU6uI2W7/oJ0wW+NKH9MXpmSCCbZDnGn1vjQkxrPas7?=
 =?us-ascii?Q?Fk0XZD9hjeY9TmWZwnZPtiuDOcF5UTjoTDI/SIaNn9HMufeFJYSjOmPPL+r4?=
 =?us-ascii?Q?ScW+OG7sj3qBzsyBofXHSHL2MzJ0AHkmCxjejXMiLhHZPCrlqw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KNtYygOZjuKp6ZdwfhPekTcOfeJXeGOFexnBFLkF506q7nAfkBfJ8GuZGKNl?=
 =?us-ascii?Q?5/jCWDhb6XvMQMtFpzKZMsG16xr8sF6BGuc0m4MTmbnmntZ7Jcq+wUJ7HNP6?=
 =?us-ascii?Q?fBDjfOwVdnyWvA1OuzjstgSkPazO4iwCsl+mYIwANVCpW58U7qtugQH+8Ky0?=
 =?us-ascii?Q?uOmpTJlgkbxxvtyV0rV2+1PtB9rVldJJx7qVWT1kRCFQnoDkNAyCzMGV1qfR?=
 =?us-ascii?Q?1NwbDi/GJVZxSuzTysDzWgHbOj9+3Qn4vx3yAvkB3rEcpCWwwm1HVungGk2h?=
 =?us-ascii?Q?f0tJcrgP8A/tIzUQDHRudLTSiVqMguyNG5CTh6hGou3uQujskqs83v/Whtgt?=
 =?us-ascii?Q?wnHkW/GMAwZdb2bIdk0v2/66jUkaRtjPTAGjX++tt+29ts401HgUyUtic9u5?=
 =?us-ascii?Q?r4MNqpTfBG8uozQIuOPEh/DX/t4u/Ejuz7OFZjxTr1xIGRbf2DeV36DIEF5d?=
 =?us-ascii?Q?/1Jja+jxyR8WS+Rwk8JCirZbuS16u8YccreUU3sgxyH+VAModd974j2bZP8t?=
 =?us-ascii?Q?dtkpc9bgvzOvnhNBFdGMLudd+eokVGN1WnC41bgF9TDOsDc2oda9BP6sR3rq?=
 =?us-ascii?Q?73pACx/4LWdP2dfYsnii1k59twZDjNqSVgUm24Ib1Qh9SDCeb9Vhvd/QZuvn?=
 =?us-ascii?Q?5GWyuD+BumpTJvyPXuFqu8O7Chn2Ji2xJPhpmZiLyR+EQx0geZgeyA0GVTrm?=
 =?us-ascii?Q?PFcxrnQZW+dNjs8rVNPTUBQd33kAsD/2RORn+AzrNh7nROEu0yZjqu00A5nM?=
 =?us-ascii?Q?XYuYXf08cP8TOQbeVrHQqOio1nlPul2UcC3EQbszuIQzylAyiPN5tJ6oEOYq?=
 =?us-ascii?Q?LJQapL8Jn/CZlCY1aVTHI9oqejUdH5VMcTDa2wN/oh8TN5P+6aOvi/0zZDWa?=
 =?us-ascii?Q?ZhEk9B5u43vG4jOVWr7fGGIFG157wWAs3fHVobNugs3tHuO7wD0J6og2gQo5?=
 =?us-ascii?Q?IBFtPVuUM8VjOvgkQ+xuKnLEhIY0RYNKhyLGPg9o7glm1gJBecBIeC6w2QE3?=
 =?us-ascii?Q?o5waDggn6ZPcxuqCnW3aFOV1myCWZvh3o+UN5MwcWTxL62iPe2a/GNZbaJAt?=
 =?us-ascii?Q?iXW9UTZLttOKy4+te+/baO9kKDAlxxdHsOBtw0Z3ngJImcC5BbQqpBazXKPP?=
 =?us-ascii?Q?FIF/k1ZPy2cs04bFO12l60ZeNQgCf3KGcV6JpHLzooCjDKjsRCbiasjIchLx?=
 =?us-ascii?Q?X18hMwOnm42TvGnBMQOVQe1VAAyQH/e7Vo+cwLNFw3n5Y1s3bzEncOcNNDLE?=
 =?us-ascii?Q?OJ9eyvSOZGKN5NmCaNIOP3A5VdUACEUM5X4lIrgm2sxjRSAFOBV8WRDvbPKg?=
 =?us-ascii?Q?mAFdr4mIrlDwZO6Ok6FJd+WfqEjyw76oEQoRuH0PmAnflReNrOZrPdo3DGvF?=
 =?us-ascii?Q?pxVKek8ErPProsLAsaOFAmbmjRDQU+eUkckMWFKoqFL77k6uHMuvAd546XBJ?=
 =?us-ascii?Q?LDCvRNr+aQkXw+S7aaw5M3TNOMx5LaaqZnrfgC+6QNbJLfSVQTPMr6krYSF5?=
 =?us-ascii?Q?utJrGu01vFX4AmBoghebPCrFhLAkv5O/YTllgd/A6L/TunWxru2DNFFgr2dN?=
 =?us-ascii?Q?K9H4uaAgqp1NzzK/Q3yERbn3gUCUaoN45XcVe2dD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab947831-7953-45f4-c172-08ddc2e2c91d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 14:29:05.1018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6xeEBqq8d6NiTQn+u7qSPCJiBOC1L/7RfvJPBuaPyQdaCAFXQ/M4EQBMvPJsPDNK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7915

On Mon, Jul 14, 2025 at 09:12:30PM +0800, Yi Liu wrote:
> On 2025/7/10 23:30, Jason Gunthorpe wrote:
> > This was missed during the initial implementation. The VFIO PCI encodes
> > the vf_token inside the device name when opening the device from the group
> > FD, something like:
> > 
> >    "0000:04:10.0 vf_token=bd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"
> > 
> > This is used to control access to a VF unless there is co-ordination with
> > the owner of the PF.
> > 
> > Since we no longer have a device name, pass the token directly through
> > VFIO_DEVICE_BIND_IOMMUFD using an optional field indicated by
> > VFIO_DEVICE_BIND_TOKEN.
> 
> two nits though I think the code is clear enough :)
> 
> s/Since we no longer have a device name/Since we no longer have a device
> name in the device cdev path/
> 
> s/VFIO_DEVICE_BIND_TOKEN/VFIO_DEVICE_BIND_FLAG_TOKEN/

Alex, can you fix this when applying the v3 version?

Jason

