Return-Path: <kvm+bounces-36287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1027A19841
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 19:15:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A72416171C
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 18:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD828215776;
	Wed, 22 Jan 2025 18:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bnYsyRBM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B63A2153F5;
	Wed, 22 Jan 2025 18:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737569705; cv=fail; b=nG1RKdjI1ehuLEQ3U/0ENnoiVcPzn/hG3rKRLBZNkFSWF75cOFu9WnwZj8Hbtvou3crdWCJNu9ZuSj5eZhFdTNN8ZrOR45zvlpx70Jya1kTRZWJ4Mb4Bo0lNvgRCSnIlw8laV1pYNbBsdLTuXbnK+iGz6dT0Rz4JlRSLXhN9KvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737569705; c=relaxed/simple;
	bh=fu/tNjx8iXgJ3oiIMbc5l4CCNYNg+TD/Pl7xpAANyHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nsGcOdGOP3PHv12tWVmfNS0YND+BaVXJY+mDcqEVbpIbSNGiB3GTNo4PJBEAEMz+fAjFf0oGlUqnK2RqpWoOuUPj9PS9729xU1e22yAeP5YwNfMwhezaUWe1X9z5h8/qmPoOH1r/4AEnu9p5Oo4azuY1CgmPjOhpa8SiduyMN28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bnYsyRBM; arc=fail smtp.client-ip=40.107.93.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yaBkPnQ2WnFfM0faHchEo8YFWuM+t3rSG5DeWaWl1fkcEhO3mH/TYSjNo+nBuaqxByFLzRg+9LFmMm7mBhRggxxY9Q4fi52oynbPlG4QrZCY5GpxSYIZJgt3wGt7AmiEBbegahIK1CwvCDbmr5zQ0H5JZvRcF+Rgeq1KYmtlyCgpu/cMdRckUl8/eFDAtrY+hw8waXFF+3P6IjZNvWaCaQmRPc86SWVKQd4moPFqqxe0BG0y83sh36ak1HB4BxO/l0JQPntXZhFJcTAhcedfCS69HRfgvMrWdooVz9t0zj8MrGC4HavhojKDALrM5hHXRLlmfntfLYMY+2hw479nEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o9tmxKl/qe9fRVLMvq8SY9gZ+f3Yfo9uLadkAZVif3I=;
 b=YoW95dBU3ooi3WQdrSJPle3IIRExkaPYh+cDwMzag3fzUdDfZP9WXQa+XDUrOItRsNQeORn/Bqpjz+//adCoy+IovgMA3jm5uOKIpftdJ4zUOv1+vjeB/7BPhv69gCKqochLI60cBGuR5OYhbrx/G8Q1gFtV0BEpE15zebgLDeMh9YmQ4Q84D6iXusf6T9o6ROzMig5ArYohlIzLCeC2ncGJNHtSOuqfYKDqMmau9kaTXdGhrp3GmsUPhFWwNcVnKHKU3MUOw+WeVmy1AZZJNFuIHCx0FSPMsxn7qWr1r3/xhooP0Kezpp9coZX9h+2K3zp5TVKakJdziLUTlfN67g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o9tmxKl/qe9fRVLMvq8SY9gZ+f3Yfo9uLadkAZVif3I=;
 b=bnYsyRBMYvnM/DwX9AbKswQspbgLoRKe3B0xlzQczNzf7jPOSAefnK9I2Pi9Nl68QcpaTDoeG9tqcju/RZ5usDVnS9m+MrlQvXTXFIgfQlLhnE4YGOYLiHxhFp4yJKIoJgBJlI+ErjGKEeRaVejYa7gfBz0AmN/s1qooYAP+lk8vonF+DBgw8TMwEPKJMbbWWCGhVBQrGz9YAoiNNMkC4imkZNfgcyhdDmyqCGY7ipxlW8yPPxeSrHolzm8DgJO8QOzpCVIFTpgnJU6QioQ7id4TojsahQorqkFTuMHxouEObWtTAlK0KSwc+hP8Fz8f3jqsu/BoPGcscnngnw/Nsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4524.namprd12.prod.outlook.com (2603:10b6:303:2d::12)
 by SA3PR12MB7975.namprd12.prod.outlook.com (2603:10b6:806:320::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.21; Wed, 22 Jan
 2025 18:15:00 +0000
Received: from MW3PR12MB4524.namprd12.prod.outlook.com
 ([fe80::b134:a3d5:5871:979e]) by MW3PR12MB4524.namprd12.prod.outlook.com
 ([fe80::b134:a3d5:5871:979e%4]) with mapi id 15.20.8377.009; Wed, 22 Jan 2025
 18:15:00 +0000
Date: Wed, 22 Jan 2025 12:14:56 -0600
From: Nishanth Aravamudan <naravamudan@nvidia.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Raphael Norwitz <raphael.norwitz@nutanix.com>,
	Amey Narkhede <ameynarkhede03@gmail.com>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] pci: account for sysfs-disabled reset in
 pci_{slot,bus}_resettable
Message-ID: <Z5E1oHd8FQs46tZs@6121402-lcelt>
References: <20250106215231.2104123-1-naravamudan@nvidia.com>
 <20250113232540.GA442403@bhelgaas>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250113232540.GA442403@bhelgaas>
X-ClientProxiedBy: SJ0PR03CA0134.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::19) To MW3PR12MB4524.namprd12.prod.outlook.com
 (2603:10b6:303:2d::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4524:EE_|SA3PR12MB7975:EE_
X-MS-Office365-Filtering-Correlation-Id: a81f390a-9e43-4c90-5c6e-08dd3b10af2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sV7fe6NjtO0DZv1Rb+8TwksK5yftr1MqPnlEHYZ57aXPARyMDiRa35hfAnsF?=
 =?us-ascii?Q?Ir8lSqsvehpmshhvITcG7ygN2n3HZRS/uEDASJOnN2WZlB6Za3qQMZoNzzua?=
 =?us-ascii?Q?QsvEeYHQDimHGRgnZHGiH91qNhaQkepxDlERICXb4iyUj0B1ldTgQooQwxSQ?=
 =?us-ascii?Q?vaL4WsZTjNhtd3kcdk/phJX8WXBGm1IO6Mc63RnJZ/vhQwHRm63kiD2pJ89U?=
 =?us-ascii?Q?7VtoAwkygZn8VIRJMdw+IUXfvO9MaWiTUxGoGhFyg1zT7DwoQt/E3EW2yD1n?=
 =?us-ascii?Q?jpjkM1aBmXrzsm6awMHIpOzkEMD66f5+4ijkgvOFMsVYGUOBRqJPSjuCHdkz?=
 =?us-ascii?Q?BXBCnOTcSca3bpioqvoP3yLQqJZ3sfTrvjFimFjj0XEsHaC8O4g9Yg0MNOG6?=
 =?us-ascii?Q?ONV/H640CZOKI/RWdD6QuztPti6kyuLitLvgwiqkkJriAKouHBGMqKJRWqFW?=
 =?us-ascii?Q?PG8SnHDegJCnXrUR4AkDe4pbUZvXmuHeelmnNdXU7T3+mssjZ7897zri0mri?=
 =?us-ascii?Q?ON9lcLifGt6krijn8TVWsLG72cUWqActhkFGUPXgN/L+4XFM0dL+VFVTO6LS?=
 =?us-ascii?Q?KGgZ5/lGo5secjfx4MqhCy/yTzJLe+mGu1+pp4+qGC1iTw5vf/kTgy0nhZjx?=
 =?us-ascii?Q?VzHXry2f803C4rq65aSlJ4m1WfLiuKoc+nPoTOM0N0+luH5EARWtULMZM0Gn?=
 =?us-ascii?Q?6IGbSd2RT1B5Sw/aT4xQwLtTdBWWlmW3WLj8F/h/DBXJiUj3m5eLbje/WFol?=
 =?us-ascii?Q?0p7hdQdaueA22rtnzFUFcZweph6lMI4Y/rSJtoyUauLPowhp/8beE8/QbX6l?=
 =?us-ascii?Q?pCNAV3U4Yz2xWrnwoHrZ1FIKnRdrejMno9KxXT9w1mnN1rf1MtTIKhk1u+qB?=
 =?us-ascii?Q?djHeBs56ST6Qb6atkXrkIc0MEvRhd+rdBA8EC4Z/nzEiCV9EUn40GRqhFLhS?=
 =?us-ascii?Q?TJ166I2m3U73Ic4hAOIF0NMxm49vTL2SqrWcILi/siVa+qoiMxwaHHmObzC7?=
 =?us-ascii?Q?2+S5Vhwz2L0h+1ysHqdr3g0pdPobIJqHgM6OT1hQdY/c7Pv2FKp9ZLPbpcIt?=
 =?us-ascii?Q?gu5VN8uCLsY7ju+6ApjmAQjw1sEN8eav/gB62wOCzEoI1W2jBZDaP4UVX78P?=
 =?us-ascii?Q?GDo3VuAKdmBIC4PbN2joP+cusLxuVCjaZyR0IsCpy9IM8ydM3+551UpziJEq?=
 =?us-ascii?Q?y0VaV2bMhP/V1jLiC2Afj6fII8nQpCI6yyUQXZsbu1Wee0R8V8sg9J8wZFED?=
 =?us-ascii?Q?kmKdNcWIQ4pIgcu/aLv9Ez5wbAiEf4L7X3mzKDdvemhem/zC68px3esYGndq?=
 =?us-ascii?Q?YD4zOuchSKXOu3SdC2Pygtub4D7JQ9j+LfthbNrbehRmZud6oPQuO9TCZIvH?=
 =?us-ascii?Q?Dj5YuG+boU0QbKaLsgvU8fl3B0tB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4524.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ngSsLOhBYcajZ8Eg/qttlKJep5NXlfwIkF9289a2a7MFyp5cX02oWG44iSJp?=
 =?us-ascii?Q?IEJHztzTFfixjvNzwad2fXrDPWTDOBAgLuMaHRL3moupZYJ9cNgIXV+yx7I8?=
 =?us-ascii?Q?M16ccTnrHGCV5rO9TrKn/mlitrCyRCsfemdo4zowhu3A4XTHP/BbSOOA7yt/?=
 =?us-ascii?Q?EGgdShtxEujKN9mpJCFTRquE3YazewDnmKFpYCdmV+3DHn43/1/DQjaDYMUb?=
 =?us-ascii?Q?mZUtAIYNOWuwcai5Q48c/+TErc6HcsEYEpbByF60W5uhjULQ5n8I+whwfDdk?=
 =?us-ascii?Q?IAK367g1MzigMhCGty8ijI2VnYJ/4E74F4vIH0b8p9IFNXzM/2rcRkVg+qEt?=
 =?us-ascii?Q?pJi3oLqweYXYlDyvp4a2oMb1F41aivEmChh3p6b6uaPhaONyNjWKs80Ve1xR?=
 =?us-ascii?Q?wF80yFKdvmZpBXkVlooZFv1UCQjkMP9aIbTgUPIp47YQjE5xJ5PEb4KbrlOw?=
 =?us-ascii?Q?XEOplrYOlPn4uoJcVhCjMO0vuudK9QU4ktNuMdYr9N0+vAmb0Lw7ULkNIsLZ?=
 =?us-ascii?Q?kUkujVBr3H1wDxiefpsq4J8zfjWaegbdsRZU69L6nnZv5xH1DEBBDnB0rTbn?=
 =?us-ascii?Q?7rEP2mPSvIiir9UYa67rJQcxWrjAJNp6Ztbs2teQGLCeb8v8Pj49IJTKcZ5/?=
 =?us-ascii?Q?2tz7INQjS/3dYm98U3hBpDNzQu8ed7OWBPvrlnljvETrGbLvAmBn0hEWtQsL?=
 =?us-ascii?Q?SntuP7ioXZayChiPntvwnojU0doOm/n0fk80XOTwT1wefrA0Yy8qsxAYbaVu?=
 =?us-ascii?Q?dajQhs7d+iciaxowWt01fF+69kVo5JdoRn6n8CB4H7MTx9PSXXc5fyq3GzRl?=
 =?us-ascii?Q?bK/KJqMBQ/8R8IU/XXNVMHv+235cqqMY/urQhg6XYjptZBnoZTrlvZCAmqHS?=
 =?us-ascii?Q?zVnYG49Qm1+lsW23bxmH5Sk+6VKGP2gwZLdNnaEMJMbJlaIzmGg2gUUC68Iw?=
 =?us-ascii?Q?G14BVRXZyxUpyaqMTkpWLHwJSmwKB0yoTCrfdgTSyqhhoLQpNFQgdk3OD81P?=
 =?us-ascii?Q?od4dobKb3ZRkYTTHCUwvVpKbJl6o6lUeYM+CJWoKOlZTgndFShzxWn3ur7db?=
 =?us-ascii?Q?y1M3X0FFZAgWyEOTjG+kEX7Z1M/Ru3Fe5SDBIZRabaUcH1Yp4OgfzNQScOEZ?=
 =?us-ascii?Q?f/z511NhAmZThDiYcltlTPNINk0+9II1SWvh/bMTIEuU+LLFOyHXiLNiMm+M?=
 =?us-ascii?Q?+hyD5JYpMLYYBbgJ+6nCXVsW07cs8GlEXa2Vx/EOGXWp0hG30Xhom/UM2bFo?=
 =?us-ascii?Q?mOE3KeNHPeRoOXrPen6ALVdiLpC9ErvStvDSfTNFagjSuqW+HVAkBo40dgPQ?=
 =?us-ascii?Q?Z//t0yrOW0+7/dgkmVFgmserGgpddTimrWG2i/tKBUxNpY4OY5VrmOiaai6n?=
 =?us-ascii?Q?e+bpgHZNlAUNhEWQJ7a/l4gaykGXvuFSS0ptIqxa/VhyCgx/DiUwycoeNI6l?=
 =?us-ascii?Q?OCKNzwbMoNrTUFZvLwDH98PukuPZ62TNC9mlbw0Fy2V5BEMAbSQ60cp3ZSu6?=
 =?us-ascii?Q?s7soAWMHSB9pGTUPK/ceYuxqqcn/nRX7ugd0yz00k4ULBbKA0TQ83dsjYMx8?=
 =?us-ascii?Q?AsqN4MVI2eWnK6CoobWuaAGyXHPv+uJXJtLWxPFJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a81f390a-9e43-4c90-5c6e-08dd3b10af2f
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4524.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 18:15:00.2441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J94ZXBRLNK9ERRubbgmYKH040O7Obs8ww+ky9QS0WTq5zgNYmrvhn2D/zhyyy8q+8wBCkkqNi0JtdeBQEkvIQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7975

On Mon, Jan 13, 2025 at 05:25:40PM -0600, Bjorn Helgaas wrote:
> Please update subject line to match historical capitalization
> convention.

Thank you, I will fix in v2.

> 
> On Mon, Jan 06, 2025 at 03:52:31PM -0600, Nishanth Aravamudan wrote:
> > vfio_pci_ioctl_get_pci_hot_reset_info checks if either the vdev's slot
> > or bus is not resettable by calling pci_probe_reset_{slot,bus}. Those
> > functions in turn call pci_{slot,bus}_resettable() to see if the PCI
> > device supports reset.
> >
> > However, commit d88f521da3ef ("PCI: Allow userspace to query and set
> > device reset mechanism") added support for userspace to disable reset of
> > specific PCI devices (by echo'ing "" into reset_method) and
> > pci_{slot,bus}_resettable methods do not check pci_reset_supported() to
> > see if userspace has disabled reset. Therefore, if an administrator
> > disables PCI reset of a specific device, but then uses vfio-pci with
> > that device (e.g. with qemu), vfio-pci will happily end up issuing a
> > reset to that device.
> 
> Please consistently add "()" after function names.

Will fix in v2, as well.

-Nish

