Return-Path: <kvm+bounces-17845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A0DE78CB1D4
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 18:00:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3F1C1C21FA9
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 16:00:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 730ED1C68C;
	Tue, 21 May 2024 16:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BlRiQe+t"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2067.outbound.protection.outlook.com [40.107.236.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7A518054;
	Tue, 21 May 2024 16:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716307227; cv=fail; b=SKE0qV7pfUruc/ZbVeLiYiugwL1bZXJeZP4G7Djo0J77S6IItMjKUbngDShM8UNPkGDjxXnJ/leFsB1B8rSU1MhmV+pyTRxt1/hVl/vZECvhCdLuBVzxLX7aUwyhfSGyuaYlhNFFlWwZ3N26PLWOndryrHUmQAkQsdos5dxidMs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716307227; c=relaxed/simple;
	bh=k6wkXTooJZRKMSFRHnW9QXOy9m/njrQareOxDfQLcyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nzeA2XCwX020Eo7+KgBKd5eWJZ8hPXFkheqBvelSAFi7di0Heg7aDJT7YlVngm68jCL/okiyJNI1DfRiF0Bothz2pvq4rZ7Iyq76bfhHf7rEmMYY/eOFj5AVy1JVcakyBWEIO9Q+GSigrS5eKmK7I4nKz1Tf+zEJINK/ZiLJBVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BlRiQe+t; arc=fail smtp.client-ip=40.107.236.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3BPJV3YVrLhvEYAK0cDXSQMT4DAF0OG9mVEr7Da/gGHBx69m2NJ9uf6tPR17VkN5Gz9MUYKLu98uFtic7SC2cNic+rkIP6HvP5zh0EVg2gdT1hfXVumUN+cztEGbBW7e79U1mDDbbTulxuKQtiAtn5doLs+cQ1m3KUV3H30zo0GGDia99wE9paRRnz2jxdQCWx9RCb7cOnQHv95DxdJmmk6GpNDfaLlRT6osyv4Ye/QvW9XxARXQSNcN/3cJCQ1tlM9uo6cpivevw5Dw5oRH74WQyqbjsWC1/WW7NUv5TLsSbSd8UGx7U+30ruVZHje4bf787MJtQHRTxHQ+c/log==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ysZxCGrnJkiHzZE4qQn2TOTQF2JhRC0TuyImelGdn/0=;
 b=DzrMDvUnCH3kF+CYuaQZfL1hB36YZtYqXQDT8O2X4QBMsKwr2/9jL3peVApefu8DWdthNHUOWQj1ztjU6zPUzp5KR5bAR+uuVhFnQrRVBMAaQXhNHsqWa0qoNIFiUSo065E7nPtc7v2C7Pw1O5x61HJMuApQcVgwgF04VbpHWMwX/uw7Efg1tH9yB/rsN74UP7uIPVLvMX6Ypgcag/ZmnMVmMP4pGk2P2pry1PhvYF/qeIOanosqKMHr+WAF5fmgvtH0FjFU0h6jJG1LefBIfBjnt72HjWg3rF+/eXRKblwnd8osYLv/X4Kkawj0oDhfB7FqKwL+PvOF7eQWOtanKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ysZxCGrnJkiHzZE4qQn2TOTQF2JhRC0TuyImelGdn/0=;
 b=BlRiQe+tSNzs6aQoYIvZ4xsCDJ/FzaQv6K4VQXV7UXjWwIcjMe0HtcYylcw0gXp7ATj0ciYTZKItVmkMzl4ZQpEhYmjPZIU/SNdl98FjehA4KYP+uc3Ja0K/JxlzDODXooJjB9eUWXqHIYftxhrP2WJreBVk6TMRXnLXnU5B6/cwu2uppqmuHhmAQh8YuOSJzSS2cukQuV8PHSHIxC22R8ABI6EC8DLa2z2uzT/qWMDhqcUaZ4EREcUkUw/c9p++jtcUOHZVt7yl6LCAJeGQ5np9ImKHwXzWxBmlqipMty+z2jxFZYBBB6zJLIP6vtS83ElQyh5/ZCJR6niX42SAPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN2PR12MB4318.namprd12.prod.outlook.com (2603:10b6:208:1d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Tue, 21 May
 2024 16:00:17 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7587.035; Tue, 21 May 2024
 16:00:17 +0000
Date: Tue, 21 May 2024 13:00:16 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	iommu@lists.linux.dev, pbonzini@redhat.com, seanjc@google.com,
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	corbet@lwn.net, joro@8bytes.org, will@kernel.org,
	robin.murphy@arm.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com,
	Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH 3/5] x86/mm: Introduce and export interface
 arch_clean_nonsnoop_dma()
Message-ID: <20240521160016.GA2513156@nvidia.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062044.20399-1-yan.y.zhao@intel.com>
 <ZktZDmcNnsHhp4Tm@infradead.org>
 <20240521154939.GH20229@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521154939.GH20229@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::27) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN2PR12MB4318:EE_
X-MS-Office365-Filtering-Correlation-Id: bc8929b9-d526-4e8c-6dee-08dc79af1be9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|376005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QzCpG5zRTnaMqx+dZ3eSO/OceGZ7Xl+YTif0LV4biZVIdTx8z5k8DAedUeGX?=
 =?us-ascii?Q?AGKrfKO8oyXNIDi4ukNRntfRsW9vpjK9uyO03MUO4yPKKPkhIYnwUgBAXO0R?=
 =?us-ascii?Q?V/Ea353Q64eLAKodgZfvbtZS5UqJjCu/ASjgTXcRz7g0bukkPrBQXCPuh54K?=
 =?us-ascii?Q?Cjuac2ZR2rB2fP/v672LKMq19DNw3o6juDpdlts50Di38O9yfxR3D0FOuFMy?=
 =?us-ascii?Q?DqKd2V5AGIJvMWsYOpbAyACrXGlrBCnGfb4f0uST38Zw3odAJXorGpkwGCSu?=
 =?us-ascii?Q?eSn+faun+60T0Bmw7atCX+Dhc2Z//op4I4ALo1DBzEu4RRcunOJW0zSX1LFQ?=
 =?us-ascii?Q?FwZhYhA/9pCttZSnhPfbnMH2mnxRSdWAnc9oaXbwhn6LTBrTfXUBp85UETS5?=
 =?us-ascii?Q?+GfKxpQaCOM+kVicyfe18Or1mPiboYrLwSqN4NudqOEvPCqtAv8eN3eV4Ys2?=
 =?us-ascii?Q?Oh2pjfOXpou2sdKnCllAScSCaLFBz7qGagJxzgCABkYPSgM1nbnC8yqSph0/?=
 =?us-ascii?Q?s6kglstbtOIGXhqaoDet5IgS4Uk8j+WvOzlkiN9+GDVzEA64AzIGywlCKVew?=
 =?us-ascii?Q?LmTQx/flopEwrIvWMTYVg6bY614nIpdjxiJPfa8vZVUvwi+01SO1HispoOkj?=
 =?us-ascii?Q?nk8qqg0R91PsFonoCuFMfJaxhCnRVcDrBfHJljQj1wRkf6u94b332+oHN+fu?=
 =?us-ascii?Q?HxuKApduc5T7EoJqgklW0+S+Lgm8XMu5iR/VRvIGqret7kG/JHuYLbW2c1XE?=
 =?us-ascii?Q?uYieV1cfIxgFqsnDD6HjHvHiBYd/8QYv633nw1O6JiQvaUL+BU1yG2RhPIQO?=
 =?us-ascii?Q?3j2VUJc99fN+GAc/7V37kxoD1TFUxx2nuSG1Ma8s2hn81st6/6K3OwuCG0oi?=
 =?us-ascii?Q?LhBFcXfC7VgzCPtvlG1kPXev+7VqpR1bxrRFNco9MpRbsTWHy+qILtVBDXnQ?=
 =?us-ascii?Q?uzBcnzmwA9mN49FEIrgQBdV3F1c1BygQoC1RSThIvl94c+S05rZmAopAn8lc?=
 =?us-ascii?Q?6lvLRzbuKuGyWUd31OvhnPjbknEcW2gKyYscL+ghafANV+yFNCeReRSS5e4P?=
 =?us-ascii?Q?7ij3NZ99I2NM0FkdTWoegOeLdgWespXBTIFKfK3nxEW+p6FMFlucP2ESC4QM?=
 =?us-ascii?Q?XXCmB0MTxf6FeXLTkzFTbhHDmmm9Oagg89xIJncAZF4ijMTmbqRcHYsdvN2x?=
 =?us-ascii?Q?u4G+ooNz6fhvj6lp7ftxPCHjwVMd0yQ4vg7/y7wq5VAmPKK+bJJYDJ2M1xUZ?=
 =?us-ascii?Q?d3yAFrr0QmT4Pfvduf1IZO8ixfDDHdxTvNjQ95ZUtA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0XcLevDCx5VQ4YzTX+Fkc8fqP7ZEjnPmm1yrS57E2lVRXh6JTP47ybf5Nnxw?=
 =?us-ascii?Q?NhUIkfk4P/FRfwZruitTheyxNkbsTu0rkProGMqEg6C/lks5YZ9ePrMJjc3O?=
 =?us-ascii?Q?SfVI1oLsV+NGD57cbogyG6Y0iaQp5Wyocj0aX9FiczRPecaMgrY5MuncrYhf?=
 =?us-ascii?Q?chbJS89qwHfKtac8WtpKCeEFAY03pnu0L3S88DyXtmI49pHnIIi3421diB0g?=
 =?us-ascii?Q?xMA4DABCDBC/T4FcWY3Ody8oeb5IxgkBNNlalMP2MCz8scr35CyCZm0K/+OW?=
 =?us-ascii?Q?czqLyLmTZpLAOzuoIeQdlJf7fiwsiaM6rshcCUqK1tk5Nmxn8h07LsS/1vgz?=
 =?us-ascii?Q?bQ/1bLmNN7Kv5hWvYbcDqO/VY/0pyYIj1TA0Wkz//5SkttMjSvdIT/nsnxbS?=
 =?us-ascii?Q?HMzDvwUd9/P/n/ncgD27A6WGlRScxAb29scVM4cbKyQMlo8m3qZOzVsGhrpk?=
 =?us-ascii?Q?vhNjcpEY8Iy1kQLzSEJJGhrwHeKgxcKu5va8B+ku98JFeZJ2saC2LUHXdyFf?=
 =?us-ascii?Q?9SFzLRoOGOVzxp1UR825mUZV+Ovdll80etYFHrujRhl3txQaoDNHDSSbmSp2?=
 =?us-ascii?Q?d5T3Cyn1wCvotBP3n7t4v/6SIOR6f66KFOEzA5PLb95rlmbLP+Fcmz22p5sX?=
 =?us-ascii?Q?S6pKZdiqJx4bCRazdTn/HBrm3T4SW4qmpK/dEbOWjkCUSK7V4o+GWQUSnSTV?=
 =?us-ascii?Q?GJnVEA4Rs9KxFFjogk/O5tvhOgczJh4j4Ij7q3+Ub6ux07qRLTS7EBCo2Qir?=
 =?us-ascii?Q?LVRB57wna46YC9Hygq6nzByxis7mSU/z/72MsLInzsxXfNvmy7nsdxZdhU5k?=
 =?us-ascii?Q?K2UX2FmrU6qzlj4k2QXtfyJlZ77FNR01wfJd0uMcFc0+B8fZZTEOZTpXXAr1?=
 =?us-ascii?Q?xlFPIyhgnjsyMI+gk8OcHx6FMes4ybq8g04EaBSQ433ivusB1v03eJyjfPfa?=
 =?us-ascii?Q?3ZTOC43qKqb9AXPJpZLk/tqmAUPd4u/GZ5886zuoZi8a0lq8avXyYntKx0jr?=
 =?us-ascii?Q?Vm01ULH+dqOR0CmFSMvn0KFwvkTjRuXO3cgTVUyuLEOz+aWoXecy2BnD6tGx?=
 =?us-ascii?Q?ODXgYs7h6S+qg32aCbenshk3TK57T/gFVG+6Chak/rK/kFEQ+4tY8K79nuWq?=
 =?us-ascii?Q?l0sunJu7Z3Vn2ze55o6KXvC0S2JfXvwEhRV/cooSVfJMcFv96ba04W+fym9J?=
 =?us-ascii?Q?0miTn59eOHj0nABegxgne40+Ua1u7hm/fHnBEDlVpiz5eZqaA+gpZ4we2eDV?=
 =?us-ascii?Q?aHTQ3eS41ZHNVTkIm9KfZUzFQy95LQNb4lmLDyW4r8/cQDQRQQdxaqanlWm9?=
 =?us-ascii?Q?dsFNNtjOcdMqU5nzE4d4i9qURF9V5hVGbH7tMboGOBIbR+NxZBOJJB0P5G+e?=
 =?us-ascii?Q?/5Gd9fjsW7yQ8iBpm+YABEXjTXX50YhOceOX8PELkqPkyVP8kualzItXqk8g?=
 =?us-ascii?Q?Rw0xdrKqGvhc0j8f2ez+Sqco8ATmcDkvnZopkAcHnb8nDMUEU0MBydKhLPLO?=
 =?us-ascii?Q?M+04MB1zMenTgdTbkrJ5w6mtgJmzWp99Tvo4n56gUhbdTJ2jt7v43XvIt3fk?=
 =?us-ascii?Q?FceDwSFIHfxxgQfqHA2Mnk24cCIfrzOv3mQN8Wiy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc8929b9-d526-4e8c-6dee-08dc79af1be9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2024 16:00:17.5727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HlffQ1PzNZAngEzK5XzDs5X4F5AGOB31Ev8KxD5SFAs3iFDHUiIeHcRQC7UuhmUh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4318

On Tue, May 21, 2024 at 12:49:39PM -0300, Jason Gunthorpe wrote:
> On Mon, May 20, 2024 at 07:07:10AM -0700, Christoph Hellwig wrote:
> > On Tue, May 07, 2024 at 02:20:44PM +0800, Yan Zhao wrote:
> > > Introduce and export interface arch_clean_nonsnoop_dma() to flush CPU
> > > caches for memory involved in non-coherent DMAs (DMAs that lack CPU cache
> > > snooping).
> > 
> > Err, no.  There should really be no exported cache manipulation macros,
> > as drivers are almost guaranteed to get this wrong.  I've added
> > Russell to the Cc list who has been extremtly vocal about this at least
> > for arm.
> 
> We could possibly move this under some IOMMU core API (ie flush and
> map, unmap and flush), the iommu APIs are non-modular so this could
> avoid the exported symbol.

Though this would be pretty difficult for unmap as we don't have the
pfns in the core code to flush. I don't think we have alot of good
options but to make iommufd & VFIO handle this directly as they have
the list of pages to flush on the unmap side. Use a namespace?

Jason

