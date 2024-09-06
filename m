Return-Path: <kvm+bounces-26044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BC2496FE5B
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 01:15:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97C581C225D8
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 23:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB5FC15B13C;
	Fri,  6 Sep 2024 23:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m/rqCw7Z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584503EA83;
	Fri,  6 Sep 2024 23:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725664549; cv=fail; b=oOC9xUJZlidS97I1jl7KzbLpWz0Ie48oy1/b8DQmEvTq8hEVlK2EYp5CLM/1nqlj4M9jNJwWuxUEbI9NSYLRUxEhBMzDV144yWUYevnO6gkgFoCscF609906uMckEUFR1O0v1204O8QpOQ7iDF6B8G8IShP9B5XLQAaQYCEBTtg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725664549; c=relaxed/simple;
	bh=2hrivCz9dmEgOcrh7AqRYSVeO79xyVrT/HmXS/Tyzqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CSmGNUqGiC1PcLcxdksB/RhpkAHw0jY7b28pDTxywpEyzbMhgKsECbmOdCzcGbYGCBGAEiEXMEvaQIK3MEmJC6M/M8gVruZUQQVoyZRhA1fguRSqO31XuF6GOXJZyi5HhFtdUvUJHDW4qZhXAIQNLJHxX8Egt7uK4NIPOeKgJ74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=m/rqCw7Z; arc=fail smtp.client-ip=40.107.93.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QjbLUIVkxpuA4agTUJDuP6lOnUZ8BYjTT3ljF2A0gPPFu8bx4v7rmxiltIhsjINCIGdHJo9ewAEHiMVpjK1u06pPMF9eYW6mseXllyjDMfFJ6SBeABIQRgBI4TP1tAQnmqBzc599Gc2gM71l0zTpPWaDE1oizemHvUbt5R/Cj0AmaR1dc3U+yzv/gDJNYCnI5s3Kr4VbniHTpM0rty24hJ03rZr+O7nGpZYT3Rq0aYkgXE3bK00Qu54NJDChQ33+n/Y0uheT+67e0OPXZN3+mPnrGeRoGsd/rbr9uMmxP/QFEISjbIJb5RXnHMZT1rLodz9iaxUbf7nE2zu/2LCfcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iw2eYuUvNUNaLLTUXhOPUaMe+hz3TKTQcU3XcehuRG8=;
 b=L7b6Ji/dRzLKKTcMujzMHHtjtNGrJ7YkQosd/ofpl/jttMneBHu1BkjMAJxG66fW863SvB/g69Gv24Vdtdoge5IEZLKGbkSq/saGj3+co4YHfrwy7YB195Vr9porpkzjkInls7mjxIafVd0bInyhjZIBcIC1GBf4xHCUKWzl0UY5+aMWWEWWU6zuDBDb6GbBCsosTbiZzo8YtYs6J+JaE1No30vCV6IsLbuTr3KkEeK88/P58xOPqH6X+nuNPvMGWqgimEgfN4VYIKD+DtlMzFWnRt4ZLIZb8vrxTTG6F2Tj7qqJuW07MTQGaSi++pM13ywl0YMVhCY3wFkSvSlUfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iw2eYuUvNUNaLLTUXhOPUaMe+hz3TKTQcU3XcehuRG8=;
 b=m/rqCw7ZVgQByo2Kbm9akIUuo85u4L0ID+xeiheoFkJ1DsB1sutS8NTThWgNa8FXQbn4rBdwnfG/4HgrwlUMg3rSyKU4l2p2HPTL/zyr5YKYObAHRjOEw2ho4rsDRccY50b7brf45HKXrsbC47y/yRKrGgpHrrTk+0GoSvupI6Mojv6m0iYIWrUcwuJ60ifDvozjaCQlma4LK2Sfbtj1pZdAg7O+X/5CPlnAh7cY6Fjcd4m4oMC15aqZg+8ozO1GySs+Oz+9J+Vt3Em/5mFE3TbmVN760Umfl3TvqqoBWhN41uDpd8S3lPcY9PAsDPs4iBqM20ldCedfdPm8Kv/x3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SJ2PR12MB8035.namprd12.prod.outlook.com (2603:10b6:a03:4d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Fri, 6 Sep
 2024 23:15:44 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 23:15:44 +0000
Date: Fri, 6 Sep 2024 20:15:43 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: Mostafa Saleh <smostafa@google.com>, acpica-devel@lists.linux.dev,
	Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 8/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <20240906231543.GA1264073@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHuoDWbe54H1nhZ@google.com>
 <20240830170426.GV3773488@nvidia.com>
 <20240906182831.GN1358970@nvidia.com>
 <ZttOpB3lAPc2+RHv@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZttOpB3lAPc2+RHv@nvidia.com>
X-ClientProxiedBy: MN2PR02CA0026.namprd02.prod.outlook.com
 (2603:10b6:208:fc::39) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SJ2PR12MB8035:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a657d3f-46db-4dcc-159d-08dccec9d57f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XUkE5+j28a1buYX9/WQjq4+TLqbwobY5Tlcze3Ve8TBB8AM2s6HE3KURKFoD?=
 =?us-ascii?Q?nypXy4lYUe8GrfnxMJGrIldBOOwjhE9zJ8xVbWFXK/RAvolecz1MY0AQt9Hm?=
 =?us-ascii?Q?oh4PiS/9j3OwElz1k+dN0OLCVBw0ZBEr88WXzeZIra2R6YiK++w8IZdBoWbr?=
 =?us-ascii?Q?afqVPjSTLycgPVz6G/uxAmk0Hy/wudF4pJOwmpLeaja1tlao58ma53d1qOqR?=
 =?us-ascii?Q?t3RGQo95nhacEe92yXK7BUfdbVzp8pHR6+a0Eidc8FDyzUJthDGwyohhMOOO?=
 =?us-ascii?Q?wtzRN1YUEj7EyjNpadXaoDMZeYl8N405jUOn2kxoQqENEKQoSE3+HvyQ9wvr?=
 =?us-ascii?Q?Yl2o2/gEFtD2qIXbS9JhO5mzi1ugxghjaXsD5bGBuM+jrJ7uUOrOAXkfnRYE?=
 =?us-ascii?Q?Q+bQTdQQpMH1HgPMcqGgWmg72BGWgp+qTbjCQc7eH2FriiEKUVjGpC9je+6A?=
 =?us-ascii?Q?zbal2LH9HSsITexC3ucmOoS9DfXyk1TBFavJ+IpaLnw1J0a0Cyo2LKrTQkFN?=
 =?us-ascii?Q?HQmnJIygNrdGanEctL17FravlHbUGSSQ8WK+rllLYrnL/aosBhgR12ZlBDXS?=
 =?us-ascii?Q?Ikv9hEgqfruB2cEfYupevtXRAIC9JqoRScoc61XNY9OlMDI+XH7/5njbWkCS?=
 =?us-ascii?Q?XMEp7ky2uS0ZEARjJc7Kuqaw5cKtLF6oXujFqcBxli0+mAs3U7aHlZT805yo?=
 =?us-ascii?Q?lUXk6Alz6C+3/6YOGLxjYI47KYn0QHlbUFXfYlQ6A1Rmr5F1GD2gn7bdCuS+?=
 =?us-ascii?Q?pJ7Zn2n/UQjRH8qKtzQt9mfaqDw72s5YYZWA9S0gzIJUSSAEYRBTwTUwFu/c?=
 =?us-ascii?Q?mU/Nm/erGtqvTSlaTUJIiLc722O4UGXBdf2FzpQ4rJ8pDrQbgV/B7qeoZRPN?=
 =?us-ascii?Q?CcA/SfhtUPU2jKsmqykDkL6I/IXhDCjvtF1rkKP1lEOBgpYwoNJx5C6n0H82?=
 =?us-ascii?Q?ERKFcEA1eoRJFPBRkiGqxwmcuUXOUQNykQBQsCJZJVXbK7brn6lhXYXxR1Ez?=
 =?us-ascii?Q?nDd3ZW9EQ8E0MBMvngNsP/Vn36yBVKSvOP0fdOLGjKIk96tBI+oM1XuOrlGN?=
 =?us-ascii?Q?TFK8H/m3w3Djzb8HlMaWd3nZ4B+d1u+V/0RlJG67zsIziZ4FUec1MyubNP8o?=
 =?us-ascii?Q?XK3NpKatQwqItgkTjPIMQ2AECdj6kgAT/EnWfrq4+Epc1DkgibyYGBSMO9Jt?=
 =?us-ascii?Q?e67QPugHORC6nHMRHQJe7ENzsWPDYeA5zTifEu7ySHDvIRbbHYPXlUrFfWYQ?=
 =?us-ascii?Q?hlRQvlXTiLdaoE9Lyp4D1uDDlzyV3noSHJC+1NFJiAw+9bd533D5ZyjiUrT+?=
 =?us-ascii?Q?/pXjBIYr7U6y0H1gyM0YcKcrfJITXycmpUt5ju3RgkxTaQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zLaCBPfB+uaLXTjFU1fay4HSlgxdHVto31GjtyFp4+Xn7/oS44e7WJ2c3GS1?=
 =?us-ascii?Q?6fFnBdwMuF9FcPwUm3979EubqMHO9XDBlGRi1XANUEDR13hERaAnCEELBRii?=
 =?us-ascii?Q?GObpJ5AyFmhz609y74QJ8Wyki3pb1uerh36ANEO02OLV91bY/DOgC3v3TVmE?=
 =?us-ascii?Q?O3w7eoqJP5eeNqeCYxpp7sbSdtOPM+bnTGw6lbjAjl9CiQ7Rxs36qTdtTbEd?=
 =?us-ascii?Q?Uitq5tYoOKejS+FP4x2vKwsU6ZaCXWjykvhUkY5buIeLgaWoQOnBN5QR7JU+?=
 =?us-ascii?Q?OreRRJL6gHVZxEPssAZpUkV/WlIrPWqYHS0XXx4ITrLffJkSHx8HjSzKjSAu?=
 =?us-ascii?Q?AUnc+VRCAGxgbOLhr97oo9FNSzCOKUHU5RI9Wxl2BfMJEdDcdJj+ohZnet8U?=
 =?us-ascii?Q?pTNLDGj2vQuQQe56T2c3VbS1SCWRHSRREgxzP8d0YeejdLKdtJ9kU2i7hq4Q?=
 =?us-ascii?Q?I7M2J4wpaCAe2/vgAvRQ/GbGiUT0CvuzLsGlZOWbW1OSHHJ5a/TY+siajBWs?=
 =?us-ascii?Q?ha+FQaOre/06k4+ycolpvxLZ5cW1CRsdaSq5mPoKXNV5vgYh0d6kniBM8/Ae?=
 =?us-ascii?Q?tpZc9sW/P3O61ZM42ji4nXVjZX27XQAkZR90xGvgBh8vt+60BhoDB81FjyUE?=
 =?us-ascii?Q?rSE+Tqs53axMNOuPqgScxR5ojPoy+RR5QrmSDCxju+HhpDURfQ2+s7nfLg9v?=
 =?us-ascii?Q?/JChEUuaDoudTKf+Mgw7zhiaa0NLcV8PUNY7Ecj5fW6IjdgRE7ZYnA5Ygxen?=
 =?us-ascii?Q?WsIfYIJhT5Ht8Wf/2jXEy/sGhvToWRhpyTt0NrPvPmQj9+zjOtJIIxmkHN8c?=
 =?us-ascii?Q?WEJSikGXji3FQOPR0gdSZ3lYi5qMLAE9FKncuFcd0cHqbOT8LbaqyrgZ8eDU?=
 =?us-ascii?Q?9TpXRPF9GtjGYkteGFeXJzr5kQf1EDcZ72iO3/f2p4U3RCdhZkyuTNVLZMTv?=
 =?us-ascii?Q?q+3v0yaV0Kr9q6R13m0Clz2tkYEB16aUOMvvcmvmtmaX/1eJcJGfRs89fV5W?=
 =?us-ascii?Q?YBTAXOFDJDtWScVApckdhMdwg8ThzKsKiUV391qgDrgPqGeHrEFO163ZDLhM?=
 =?us-ascii?Q?0XfRbxr5XYOWu8fzxgAuaphXdLlIsW1sPSaXWvn589OhOJMwHvl67DD3CbgT?=
 =?us-ascii?Q?XSEst+K40U6ZKs1hx1UmCrv0hps9d7AlTrhV398v5mRpzdHfyE3oDHZPaHAX?=
 =?us-ascii?Q?8h6PPY0LdBNxsXvgjdCYbxHLmfXWtiO4npXPFngUyUIRBfQSHMW0QT3VYTaA?=
 =?us-ascii?Q?kgQUBVJDYsdwgdVR43A1Pn1NTUsm8XNMuF60owJGO2HgqfrUBA2uPDdESCMx?=
 =?us-ascii?Q?OTKfJ4DAJS4GpNIu8UxtOLbtq9cBmSgtq0Zy3SFkxn0Qdf/enXcuGcV7mkAz?=
 =?us-ascii?Q?sHLb3DVrIN9AByX8f4kyumfN8EIix4qzFUb/c5vzSoKzi5fPPihVdGps4Z2/?=
 =?us-ascii?Q?yMwdcDnyFqoHoOqW3aQGlKSBd2O+ECDErSHxFhsLQ7rGn3N/5PqstucwDwNS?=
 =?us-ascii?Q?1Ga1iFztYkM1pKdLle7shmUQb1XfnCbm/RFBM0BJqoomXm1/tcv/dWTGuFEi?=
 =?us-ascii?Q?/XgCx0OIP2j6mvdmF/6OY8mXZQmll8UOLypaVfqg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a657d3f-46db-4dcc-159d-08dccec9d57f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 23:15:44.6876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OpUsh3MYQkQzsDdvEOFh6evix89+MxjyGeGqlTlFofr1/0XSyr4TTzvlxwyx406p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8035

On Fri, Sep 06, 2024 at 11:49:08AM -0700, Nicolin Chen wrote:
> > We'd leave the kconfig off until all of the parts are merged. There
> > are enough dependent series here that this seems to be the best
> > compromise.. Embedded cases can turn it off so it is longterm useful.
> 
> You mean doing that so as to merge two series separately? 

Not just the two series, but the ITS fix too.

> I wonder if somebody might turn it on while the 2nd series isn't
> merge...

As long as distro's don't and I trust them to do a good job.

Jason

