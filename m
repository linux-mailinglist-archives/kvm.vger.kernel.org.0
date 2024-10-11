Return-Path: <kvm+bounces-28633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 00E3099A5A3
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 16:00:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1162D1C24DA5
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 14:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B1322141BB;
	Fri, 11 Oct 2024 14:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AZ1FNoA2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0254431;
	Fri, 11 Oct 2024 14:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728655242; cv=fail; b=qFus/asXdA5fMzGa0mk8aAnwxBUXuYBJVm+BnDITuOvuwTMhRMykXMWID311xcf76JugvM35gCORul0VK5qeOtBL/D6Y7Xk1Pt5AinsPVLMJb4x+RCuKEV67fWnGk6dIcYClXn78unyvUQW3H2BPqh1D5caPZOd39UMFM8NbBIk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728655242; c=relaxed/simple;
	bh=G155PUHCeuWphoiA6/OR5PNk8FnlVu2bBjomsQB8jQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EH2uyMLePJgueZh3nJTpi79HehTuMxY0p2bXPo9facgYHK/59HSXYIr6rVlcjRn9p1ucaXDYW9JQiG1hHdzi7xHgfSoPNWAKr7Du1TNkivfTndWMmEtwM1zEoViJU2yCR4a3ezLgO3ASWf+l6u5YqpGf/UYF5lim4nL1egxsBOA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AZ1FNoA2; arc=fail smtp.client-ip=40.107.223.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SOGz2JK6UVKaHK/pfabmdXsjcmfCg9DjYGPLWJbIJZ9YE5nfpSQ6n2ydAYrEkILHhmxvWWjd9noWwlpqFpIPu31t2FWo+MQ/1Oo6xUfEupfgWVMSO9AzpalDgNq9MEFKyQmj12SkdXuql14r5sGjg16g465pOoG9RVrWJ4duhNEk2n5YVnMlubRuW/xE6PJcUe1xGsDkTpbj592G85HibaoWB/a/uOBCbf5nWOHzQ2MbHHNcYnpdvkTLFWtkrknZHfuHkXU1Go26iQ77uOvUkJo1ilV5bBXKXY0gdE0CmeWAlNZ8E9cKeB3LypSYcKyRHPsISKaEQrz6rKGJ/ImorQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T3Ca7u3ubIqCaJzJlP/CXCb624cmjnk/2NVA7TQk9Os=;
 b=R1ZMQCPpb5p/284QWrRlIVBXejftxYPEKGBHM2JPmVSYoUBYQTY8NBJPr0ySZExZxwDGOR+Hp9BC5hPgYWcjJmNuCTIk5/FMrHnDDVNe1nhW0jTBycS0vYNJP6qti+t/iFQG7uSyu5g7PRBAaVWrzcLLYbP3labWSzmZi0hV1T6UfeGWo+yaMQJqJ1u/Fu8+q9fWmVEt1AwU5IjFq3j2T4yCmXQzXiUusng2AJ7LSB3/E3tzBFUqYBkNJRFv5d/lwUDSFcJmwO8GYBqibvtB0vvEgvac8OUPD4QKbFNAOP5hJtPwHfcbXpJ+VQepvRjxzXbbANoXmddf7Jxm62hedQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3Ca7u3ubIqCaJzJlP/CXCb624cmjnk/2NVA7TQk9Os=;
 b=AZ1FNoA282P/t+MmURA5VcFLpa6/9ua1hsCA+jahYGGWI4Xb07lQrHZlbJUjRa5TCsLehwcysVUf+fSPUXDs1b6RW4bU0UvDmaxTzYzq0y6GS5F1mOdQ0JMPDUdIB4eHi2hA/v3bWLx9rHIMfjJa9SNAtAbk9bptjWTKgrLy+2E1Lis3mi1Manm6MIp2KRNXUpkVKhqbTcB6Q+rDl3vw9mj2vz+cpGshpIOgbnGmYo5n8MYwNX0UTY1qjPwJAooeUpJtui1xTUNZyRUFBRELsLMYYcZhEaOSyMybWNu5EHjQwJIGezQpmVxeLOfVbuXTY2fjLGxp1HOhr4tjHdslog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN2PR12MB4063.namprd12.prod.outlook.com (2603:10b6:208:1dc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Fri, 11 Oct
 2024 14:00:36 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.020; Fri, 11 Oct 2024
 14:00:36 +0000
Date: Fri, 11 Oct 2024 11:00:35 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
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
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 9/9] iommu/arm-smmu-v3: Use S2FWB for NESTED domains
Message-ID: <20241011140035.GB1652089@nvidia.com>
References: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <9-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <ZwbAbK0HkYHs1cza@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwbAbK0HkYHs1cza@Asurada-Nvidia>
X-ClientProxiedBy: BN0PR04CA0095.namprd04.prod.outlook.com
 (2603:10b6:408:ec::10) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN2PR12MB4063:EE_
X-MS-Office365-Filtering-Correlation-Id: 07cb8206-303a-4ebd-ba4d-08dce9fd14c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W+PftHXGo4UkfO2WwL02E8f3RML1bm+V/06+jzclc61LKXbPYcORF27KXRP9?=
 =?us-ascii?Q?bFX8TaD7ev2ZBXaPfIhi2LBMrAuO/tFmhhzO82LWeuoEbyqLrMzPVag7oGXM?=
 =?us-ascii?Q?xwJmYV8MI6oRPRO8qV+2CXu9UIAj35O6pNns3qd8Rfk8nVh3Ut5uMIODHMxi?=
 =?us-ascii?Q?CuSIHQ8iUnCJ9DUhQBE+3uaWLeUyxQbRx31YooOCEZutmjFfV5FtGHcCulVw?=
 =?us-ascii?Q?s68cesx//5YlqiwTp87QGlMeOPIbpSHLqbWFTaWe9PHvgvp9lgJ/ImqaQgBI?=
 =?us-ascii?Q?0y7M3wo1g7KArXDpre3EQFTZqpEH+3HP1/0kXxzLZdSCXC0db5lkQ6R4w68q?=
 =?us-ascii?Q?gHf6L9/tk8LaEuzi3ZePDC7EL0U8WCyB5abn7Pjw5ylYZadxIC66ILd1C1/w?=
 =?us-ascii?Q?YMAqg+5gTqBKIt3pKp+vebJbiUFY5jt5P+zluZM2H8yDIzXf4/5n3r6Rk65Q?=
 =?us-ascii?Q?b0+xFvEDCt8Ka26g+4SGx3NxT0O0SpXcRsTrXIxo3YNw94sEQGBIy6XG3Fk0?=
 =?us-ascii?Q?1zF0kCXaa9cItvYL+ozeM2wg+g52LB9PUlPAziohnerEoBtpNaE+ClyXp1Wn?=
 =?us-ascii?Q?H5eu5cdYxjhJCzad6l6eX7rbn+AVkcz3eAeamspwpOmTUXGU2jFeVkkj3K9D?=
 =?us-ascii?Q?hZ/g/5vlyMo4y/fF5vfhLkjPu4yaDcaGDG1wBdWTtyq6iT9or6bGo7G3jUyv?=
 =?us-ascii?Q?XkxxRYJ1tyoJKJ6hcUaYYBjOCLfISgr1gm+1bDVeWJMNQDk9cOHX6qPlWU5R?=
 =?us-ascii?Q?XeUJWqhzblsoTvOacD3d35XgwnauFrL06aGunKZqb/C50ZA7sEljOVgZmxX7?=
 =?us-ascii?Q?BPng1DdPzuQdPFdMxQ4imK9MoFijgnAJ7Ov3wDu8YbWwZed+dFL6TreokWt4?=
 =?us-ascii?Q?HT724qzNgLVMzDIvAemUTTJW2YrhZisWzJAdHYZeD2PFXX/nh9DP/dlUjf9o?=
 =?us-ascii?Q?bmf1Sm9Mx0zEjTSf2DFttwFMgsGft2yE4pdLa35QA9yYRWu9+HskQEVARreN?=
 =?us-ascii?Q?pzRJddQvPmkf8nVs4z3OEFKVPuQU9nEwmd4rNTsghttsWAhQJ4AJdSlMIYgI?=
 =?us-ascii?Q?IyHcK2AkI1wpmI9yffOnx2VUTmtHXxo/IENIxumghEpkJ1sVm2mRfyXror2F?=
 =?us-ascii?Q?f0X2+X11rSPWc8O9ENU3DdCZUTOKURUCdSEutXvFfHMzjeebaTpRN4FyQ+wG?=
 =?us-ascii?Q?7LinhBh8ZEaLrot/re2iAjc/NW2JTGWplnX1ImyRNkRiDY1lv6VOfGE6r8a+?=
 =?us-ascii?Q?dAEZxgihLgorYMOzTBZaoMoIGWkiIY5sIfU3TVkT7w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rgLLIeHOdMacQEbzsshhkM0LVZj+jdyUwwvWPFoHZi1Z4jxEDmVWe6npdet8?=
 =?us-ascii?Q?ly7exE49lF/HMlIbnA9QSFIhvJzyEz+e3OhOI6rr3vntJLkaCuLna6Epl8De?=
 =?us-ascii?Q?XUoSzLslEMGdf8ovX7Lut3bN+bZwTMFTUT3P/ltyWln7lh5uFoQ5Lb8PR/l7?=
 =?us-ascii?Q?ed9Pk2NvBrbro6IdxhpJQ2FDuDqVFM/M8RqyHuotH+kxs6qsNAR0WECYXXr7?=
 =?us-ascii?Q?gQfhUp4bnTMqp38F36QTe9m+y5a/toUkfS5Jfnu2e031t0UDKSTuDHJj3mKr?=
 =?us-ascii?Q?u4T/DAZ8HCAQlD9JSCZdSI2aPOMT7YeE+nrdud5NJ8+F5RGWc4Yi7+V9FxYF?=
 =?us-ascii?Q?PWIfXXq5B87Y8ae4uxURvtbnfWqXCNAW8SvccDxzTNPlhaETfwOvFl2obNys?=
 =?us-ascii?Q?WGK+1B5q7Md8/hgZOa4TMnVHZHR71kdDQ3td07ZnlbSV1pfNI4c7xhNQE1TI?=
 =?us-ascii?Q?8bAG+DPYqu0lZZjFOPNdL14cKf7GU999QKM3Xam8uoWFztP7YVTF62OgHlcl?=
 =?us-ascii?Q?oYPkmsAbagcQvUMoBjWKf5b4MkCCgo6hMP2gjNzzh/Wbzioc7IKT8i9Z5pLp?=
 =?us-ascii?Q?BMVRF4kMhutGA6oxTsZ2HmUaPUAesbFa+Y+4MeSStTQFaqRaWLSmPBhRigtL?=
 =?us-ascii?Q?26RuCOAJE/xnJPPpDd/cBEn59c3qLUImEszYLSIS/pcbhnKan33iA9bDIdC/?=
 =?us-ascii?Q?8O1UJynMTomPfAdbTJURiS+dSnXUCWxb04Cbi3RFFPeyJeN0+GSpQJWBfAsm?=
 =?us-ascii?Q?t1GJAy7zDAYhbvLpC68tq9o8P5yuZvQk6+YTEZHQezKe4aSe1crp4XChNhH9?=
 =?us-ascii?Q?tbRSuy+yHYIimvRAwCivViochcRSUdrkJCrCcRKhGgG/0mISB1zY8wbEvQp3?=
 =?us-ascii?Q?LXrm8BiiK1rE3bdKkJ7VaYrurxkt1VUI/f28WwmVKpMPqVKg1wC2bm5twcyA?=
 =?us-ascii?Q?XGPPM2pePxgTGnh1Dvw5Csydqj4FgY42F4XCXJspKf7kY59OlofxMw4ghUMt?=
 =?us-ascii?Q?4oXJyuYMETq+x5k/jQ/uL7Xrg2yGYn6DFqwJQjUygY6GtiO+9LE2HhoA98XO?=
 =?us-ascii?Q?cnpoETwxWFGnvdvRAshoROyYXyt6XXhjaeEpsTIPHQqPJdg/xHLXUh0QSHaM?=
 =?us-ascii?Q?PsttZh7bsqcQvH8LjD7Vu0EWJWnXcdAnNYWvKTWjRyiuFHkD8WwEJP7cGoG3?=
 =?us-ascii?Q?eqSjFc5p///7RzSsuICFbvspgStRcBryPCACGrYnGl4qUxctnEP53FNaXeAT?=
 =?us-ascii?Q?NZxM9HU0CyrtrpWvM4bzBEq+XbQqUaKrlto39qY2WnWbvBSMfR/eU7GOxIh/?=
 =?us-ascii?Q?fr2Cfy5IT3ZPA/Dg87Vmrw4iuwbtG+9+UPwZPIFkS5restpx4m3pXsgpUg2f?=
 =?us-ascii?Q?osDo4RydwMFcYbcLcjnZmw9E25yHFRbTa3GcfmAi1qEtHbzYEAeZK7ApJIu0?=
 =?us-ascii?Q?Jh6byJtPTguTY6TEQcecmu1xlnqkatUDZ6HQmNODc6589CaRkt7QARKJE+7Y?=
 =?us-ascii?Q?kAV3opuZy5h7Kkzv0bGV6/r1Q9rwPLmhXhJk16Hs2Y/sfHsSPWNa+DoH2peh?=
 =?us-ascii?Q?hijzOi7t9N2knalR8Nk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07cb8206-303a-4ebd-ba4d-08dce9fd14c8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2024 14:00:36.6422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ytRmmT1yZEtbC5kaJCkvWu7anXrtZrCjgHTEyVYJrAQIZIRn9Qv1MVGU3LE7k9wN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4063

On Wed, Oct 09, 2024 at 10:42:04AM -0700, Nicolin Chen wrote:
> > @@ -265,6 +266,7 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
> >  #define STRTAB_STE_1_S1CSH		GENMASK_ULL(7, 6)
> >  
> >  #define STRTAB_STE_1_S1STALLD		(1UL << 27)
> > +#define STRTAB_STE_1_S2FWB		(1UL << 25)
> 
> Nit: seems that it should be in ascending order.

Done

Jason

