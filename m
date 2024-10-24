Return-Path: <kvm+bounces-29653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73ABB9AEA5F
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 17:28:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 910791C21FC6
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 15:28:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E663C1EF085;
	Thu, 24 Oct 2024 15:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FfOP1PVm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2079.outbound.protection.outlook.com [40.107.102.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC5B1EC006;
	Thu, 24 Oct 2024 15:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729783677; cv=fail; b=qoFs3QgF38MU9az5/zOkuWOFOqH54RtYrtSEyvSOdpcC9pOOqzQyDssG5G//6FC2DAgjg2pc2R+bZkt4yJfGA19jLBcyN4cA9YESe4crCcEQcDgi4BzH2yGeUzu3Pf0ZqFTol4k1PkVfDEXWzDokEJZpJkqfkW1lyFKP1FtGXIY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729783677; c=relaxed/simple;
	bh=dHRUuJgM/d9OE1vVeWxR4gise1fGv5Jp5UxeaT3k2gM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DoUdIEllGML+ptgmzeodXw/PcIxXLEcGJQMqo0Y5RlPbXrMEerk/NA7Lc0LGGoaLwc76+n3RKqt5L1+AmRW7cEFaw3Xy02TUqqZYpU9e29GOtlU0b5xGxHxX78TlUqeL1d5XyjfYU5W+1kIKHh1h1CRRoMgW0k+CZSoSAKtrKDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FfOP1PVm; arc=fail smtp.client-ip=40.107.102.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZhnAN0TcfjY1nl3SmfnP/3fiGRKd4EW3HKe7wHQA5cQA7GVIcikRUzQMDIGpq/Ig6exkFZDAC0kHk7uIhicR8c7icXmv5YR+tj5/4+XGbwcQ5y4IW58kC2q8zF3abbbPz9q4yNyKvh4GPeELm7QmW1BbgyTUsLheVB+F19ZYNVvp7GSKkllJUD91y7rocHElYDMIP+ep2hpGIkUzK8Hhcn+IIVaSb+3IXpoa82hVnuBLIjSs7sMgNAOxOJXRKNFs/E9gkOk0gizz++r1WgkI5kGg6iA6m4DdwdyBaZgWQkGo6wQPA7V9gGB8qiVEySXzC3W63TH+XBOXR+y5W3FP3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lf6HJgtxTtySAwu4gxJVcs2t5D6mHO/UBc40MdoNKsI=;
 b=th1CR0kNjQizvNCODuSnpdiso+VYRDT9X2QKzBQ7NHrDizVGOg+DUWmFgmlskPTIAFewusqBb5OAib81wfuazZlBY/v3fWz7posaNlVhwO6DcbEoajDxjBuC5YxZd7X/bk1wVSorNt+X2JuAvjMPjNALFvJ1l/70c9drqbJXjnSmVjKdAQoJZH8V8VhGqURPqIGbXKrJT8j81hN137iATb3fSp5MasN2Zwnzx4t0mgIf5ya85+tF5MDYFAZhW1JM5fKal2RRZthj+TYF+l4zBEVUWDw/YDc8NsyP6MT0zsSmyu9tUVLcYXrBdhu9miFQPLXchAFV0mK/3bsQbafBtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lf6HJgtxTtySAwu4gxJVcs2t5D6mHO/UBc40MdoNKsI=;
 b=FfOP1PVmfg8lcpAPZ93CYXaXQjEIqk8vsmtNWKQbB7aRHGeURw1CQOJQKlICIJPmDcWwGn6cPfrg5wxihWJTlUhtlYqBYuErd0yLm8vwI8VoSzDzscwivpT4Xxu5jPzjJ/JBmAtsA1W1TsQOv53P2qDvXX9aAP5auk7ppu955FM1586t9feoP4DHEAUxRRW4UY2ahbnk7LnptjqT+tUSeYKVTHJrKpyCP/fmaGCEQY4KTt/Ai8j5MIskRf3QV/bobaYgQEJjQraogLPDi9J2gnhcM/2U5Nkp2gQ6PWT8GhMlRQAtNh5gmdeo8sbJ7ePDdoq0IJSJZA68wX1+QatgcA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM6PR12MB4044.namprd12.prod.outlook.com (2603:10b6:5:21d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.18; Thu, 24 Oct
 2024 15:27:50 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8069.027; Thu, 24 Oct 2024
 15:27:50 +0000
Date: Thu, 24 Oct 2024 12:27:49 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: liulongfang <liulongfang@huawei.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: Re: [PATCH v10 0/4] debugfs to hisilicon migration driver
Message-ID: <20241024152749.GB6956@nvidia.com>
References: <20241016012308.14108-1-liulongfang@huawei.com>
 <3ede2cf97ffd4dd6948aa06084a09d2d@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ede2cf97ffd4dd6948aa06084a09d2d@huawei.com>
X-ClientProxiedBy: MN2PR20CA0065.namprd20.prod.outlook.com
 (2603:10b6:208:235::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM6PR12MB4044:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d989faf-3d8d-4093-368e-08dcf4406bea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WmviAv/bk/wRIrwecEoBHGF0+JH3Dl2hHknH069Xzk1HhqwjDwztIbRGj7Sl?=
 =?us-ascii?Q?wrjJNiRzursXgWvUYDyM5Sc5LcQxXQDc/WuLfhLhGZ7CuyajfpW8sk0YeQty?=
 =?us-ascii?Q?OghftqF6Yn2RMH9pZJlOEaFP77kFvYEcHPkNhuNi7MHBERdhMoWxyAJydfV2?=
 =?us-ascii?Q?48GaRNmi2k1/tSxmCTy3y25b6NeAZWMsgr3lHk1+3PDOqAgz0XnSSD9lgNtS?=
 =?us-ascii?Q?FimUBMohesqicMbP2xzAAiHeGBzKo0dwadIznFNzjfVdNvVpmz8kvlMJYQvs?=
 =?us-ascii?Q?pVyMzDpM2B3JcFUb5j+8Kop+fjZru5VK9ywiMIeEVleOke1XUt9J5KWIE+W2?=
 =?us-ascii?Q?8THRnxyZl2TOwS50pknplCl63EzCavOm91ITHdWNppUcU/iDBzWqHoicC5Ek?=
 =?us-ascii?Q?o1Voy6LJItIqpt+BCrq1A0/1hJf5XUmChu1b84kCbRMTA9/bJhbsqb4gMU0H?=
 =?us-ascii?Q?b36CljF5Uh9k3f0yYpnSKd0McHO3xvOzjSi6ADzbKLkanLKa8ojtw1OiFMdQ?=
 =?us-ascii?Q?0xzUNx1zTdt5a9xFV+ZYkj5k8qZutlmQ1VlXCubs/IaSeOEutmh/2mLDkWna?=
 =?us-ascii?Q?vez+EH/EDjB5QmEhlYeBFNgO9hWkYuVFr/VXfNa7BKktwZFtc4wWZA7rjWaE?=
 =?us-ascii?Q?ixYnWMXs8G+G4GDEg+rK379uAOcwgKaLf1U1WiSnfoVHSwDRXC88rGuqxyhK?=
 =?us-ascii?Q?ZQy8cBx3VeRgYuDQPlgLCWW4x28SAsgveQlcT8IURmiOaTva5GjAuXrQBlL/?=
 =?us-ascii?Q?V6FIyB70Z8lzaEay+JI1+698YxStAQv0hWeFLncROaH8U1iqvhgnS5OCFX14?=
 =?us-ascii?Q?E9AU6BQ2UbCPCaozINrhxKnD6+FvpByUmgds4HooAunsvn9O9dlMJH5/MefK?=
 =?us-ascii?Q?rqgM9AR+U7fdByeUOkkk6r1o/KEvqV46DcmQgLx0DNLRRRbN57eZzshtRudo?=
 =?us-ascii?Q?ObzK8HzWIalU2pE+8ZvtDUXO+f0j/4l91VqiqiZC9t6Yf07v5b23JSMUYxkl?=
 =?us-ascii?Q?MQeSlBD2xrfVM6w3arWaHIn+LCCFHcilTJKOKsUk9Xhk06Z27oW6kYz69fGz?=
 =?us-ascii?Q?r4n2fU2Y2QWkrj248LiXn4Id9DiEHbcLrSC49V2FY70FT1GrhjpgkanLDslZ?=
 =?us-ascii?Q?FkZwb11aqnTVtdcm8+csWOkOdEixzxDVifCBTw3OWsUkJ9M84Xsw73BT677E?=
 =?us-ascii?Q?U2o8003pEnKw0o7NsAyX0Xjka/gpm3UEozljsUoMFcsZsqPYHdFKb+KeNHRS?=
 =?us-ascii?Q?PUq9jCm1AADpej+zIKcsZT1tu/txyFYZZ5Sk5+QsgkHx+3Voj/Cy4MdxCaON?=
 =?us-ascii?Q?l+8aV14CgIzb+LjmxPEaARTv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mfmoTeXkCwm4FV/TC5sbozrfMLgmRrdoYFWz7JP+HRHPW7OaxUilVEN3UrQd?=
 =?us-ascii?Q?fEO6XEAh01M5kjj4IkcZTiS2VZfGVD3MWyNi8x1vgf6Ns14SVgyKQ5XzB7pl?=
 =?us-ascii?Q?Six7i1ivK5zzs6Me9M4D8q5/i2BNhPs5MpUB6XUDNgbjxDBzA+VwGUNxG/vs?=
 =?us-ascii?Q?F1JmfZF3rF/Ib+IBEHDqvL+nhe0HZDUCTYso+SPa2Uf0N+1J+iidoTEXLiRk?=
 =?us-ascii?Q?5POz/Cq7zgvTeNoE1OWqVcjgwwVOwQHNXXgQCepXWJdk86zCysASS4S56WOZ?=
 =?us-ascii?Q?RUkk5U0203mGGI5pa+K4kEcblbreAUc5lcGnShoPSWqau2jf2m23VNOmH1Ot?=
 =?us-ascii?Q?d6zp4GVchRVRZli3lQl0ERftnTh6kVqdDlqRw9YpYJMvwyInMkifHC+q4vOV?=
 =?us-ascii?Q?+/kogNRtH/MUE6ps7b4M8vNbLiI7nv5Ok7dDfKwmVExG+I5SfjS0gDuRkJCT?=
 =?us-ascii?Q?OPHyAudgqXMKBj67cDqVb8MmtkHt5tVJNrpxfS1S8Y5fcy0W7pUOAwcnGhN/?=
 =?us-ascii?Q?pC1mav5cdMzlmtFGeR/HFRWMWzZFnXoyDojGoau99pFDDryAUKjHXDRimCoa?=
 =?us-ascii?Q?G2vThCGAKWQJ+e8FgmmjliEqvO4qHsj0PmjQ8+JNIde2/BIVDb56qDzP3cKl?=
 =?us-ascii?Q?WC0xaS1XbnvxHZSTKDNuJMMR/MAFes9n70JuptZ2DAxUJbVICVwTnQMSPBhV?=
 =?us-ascii?Q?5QoUh03kkuNk5GT8P6A/uCTh81aw+2LYTmbMkVsNEXPxCcLPDcOla/mGku9S?=
 =?us-ascii?Q?uH2dXyVo5fCB6E830ME1meKxUMddNtB4lElIq4lk3Pt4k6r5e1Oq7PO/4tTr?=
 =?us-ascii?Q?Iv69a+J4sDgo0niKLPX0Op9zP5HJf3pTxXgBUi2aqr4ti6g1Yo/DDqt4s7qz?=
 =?us-ascii?Q?u/gGImnwB/NWvlKqYnoP90NnDVN/RKxajDDmUEdPEju/h1tMA0FFOlJL38Ii?=
 =?us-ascii?Q?wlKG4Xu5dKPoSKQ26+JU/shSxLUiJ10+pymHcvlTY0wBoNZ6X0ixQU82VNIs?=
 =?us-ascii?Q?+BpHi83xn9mfH6HiSu8NndIGFuwSimFGlxw3TH56cjINnhyn1fd6I+Dv/cDT?=
 =?us-ascii?Q?lx/WUiNfkHanmWtSGzzcSqOrLwbgVlvYAU7rkMMJAyiKfL3GnBPptmh7Mo6B?=
 =?us-ascii?Q?BkfpqufYETNCUzxYHxP3+iN2lTZcqT6cP/10HWUsi5d6B7YhMQxmscTEa3Lq?=
 =?us-ascii?Q?agoOr7aOUm7pygiMi8MQ6J7STNvddEZTu6XVooBOz6uCCcFb20wc8sokkDfd?=
 =?us-ascii?Q?wm1nP4u/Ktjj2M/v7LHXYDdSDYLAxL7RmYJKwVOWpJOyENCGjKNp4cHkEZny?=
 =?us-ascii?Q?QlolJ6JeRLxSsp7wGH7j1GOCI99CoPKuPrzjfixpoWQjWnUB8mwed8uIfaNP?=
 =?us-ascii?Q?xtKqXC48/clgseVIH6b0/Cuv58/mfwPaMO3kLgxyr13qnS1iLqSTeSLklqZc?=
 =?us-ascii?Q?7ToOKfWew0U2KCGjqj6y4v5aTDPOjs+q4lIdPfSMlLPLX97n2DrKU3XE7/fG?=
 =?us-ascii?Q?OrkWgOGmsq0e+3lXeWZ58GC1oZ4L8G+mMgmP0/67YvZWRWg81vXdzgmIgCBd?=
 =?us-ascii?Q?AN9tIpY4gxFTJm+OfksgTUjajRly0wU2jYTHYjn+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d989faf-3d8d-4093-368e-08dcf4406bea
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 15:27:50.7179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JvNERspyWiqS2rdKbIcb3lvwZ32NIY0Q4Hf30TbUe1SyEI3+wZ2lO5P8ySLeVjoF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4044

On Thu, Oct 24, 2024 at 01:18:55PM +0000, Shameerali Kolothum Thodi wrote:
> > Add a debugfs function to the hisilicon migration driver in VFIO to
> > provide intermediate state values and data during device migration.
> > 
> > When the execution of live migration fails, the user can view the
> > status and data during the migration process separately from the
> > source and the destination, which is convenient for users to analyze
> > and locate problems.
> 
> Could you please take another look at this series as it looks like almost there.

Why are we so keen to do this? Nobody else needed a complex debugfs
for their live migration?

Jason

