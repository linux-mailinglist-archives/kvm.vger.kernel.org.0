Return-Path: <kvm+bounces-25290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18113962FFE
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 20:30:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CBBE1C2481C
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 18:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 066051AAE23;
	Wed, 28 Aug 2024 18:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RWqSkj8O"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2049.outbound.protection.outlook.com [40.107.96.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A87B145B11;
	Wed, 28 Aug 2024 18:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724869849; cv=fail; b=Jl9eBgAyAtavhVNzhCq2jo5BbrW0YEcBJehdC0pfHJac9/e/PG3ERArjx83vX4AyL8eBa/n7vXt1GXOH/y43nO5nkZvrmGT73nJN3bWxvw9aCU0An8iHVCtI4LyONO6jCvN+k2vzcHEcqBAOVhaUQBoPfMbNK9/BWsX37BRSdk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724869849; c=relaxed/simple;
	bh=NofYMuoVYqxk82949aci4A8FlridcXzWcX+LzqCPFC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Cy1wdt9Z2G/jLC7opCDuF3pIH/5SrG5rXbGjlgRw9xNicOHuF1F+0FhJVb6y7eiVlKjZLJ8k1kOw0R/ni9sEgHGXOBQCWpoFjwkO/b8G+AwqPzOqjShB9xnYryM3M6iPdkPWCsN1f4URv0MntKyMZpDzjA2lpuLkCzNMcTsFIyA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RWqSkj8O; arc=fail smtp.client-ip=40.107.96.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rEM41ntXvAY1f0fgVjo3J7H3BI7YM8JL3SFeDEntfelYjXOlC3X5UMBcQlmmfIRRmIpBosD0a5KRu1cHE/kvUWSYzzeTgXuKgGieCB+Y3IPJj5UUF8oVdv7Ypo+XeiZrChXyE2TBr6HG6kkfDAiC98wGqassdEGcf67UDznBRK3+RJYpfd26bvC4M6AMQ9MpsVBawEc0NGtoC0/7t7GKeXIxhYGnMXSAs2X5u2y1PE6PUlbilHvor97Z5pGcqYu3uSy/516/Yvol96+HZWLg+YJ/uwiVqeY/uZVGNVYWgldqSFK5Az27f57cEozLAIMKtxyrkpDyKv7MNIohoqpBFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nL9ypJoojtvmWK7zbqo6oQcokvGUPaoBxao98PST10I=;
 b=t0b5rnQ7SmZdELgBOpO2M8pYiJGZT43u7FdoyRJpTGKs7S2z4fJVHFAHsn3TEG1ld55MyjB3BrzGRTa1VdT+HjHkuzyR0k5I3noFvTupFJv/wpfT6T87l1Zz2+gaDxn6mnMud/7Y74eJTlb+QY4DRl/+Hy0No+3tQ/wMiIsuXTpfM7JdM40RT3tdrE0IpHAnLnlIyAfSjxuKVjC0PVQZmFdmAz+KFavVZA5+dR8fKDHN1dSG1L/LvhZy02jTc8cB225TAerDWomcyD4FkaUdsF64fJKZs+2FXRBIqB4CJcF19YijOUIcmX2++/ZC3i7DPZTg6FDPqhVIwE3AcAz7nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nL9ypJoojtvmWK7zbqo6oQcokvGUPaoBxao98PST10I=;
 b=RWqSkj8OBT8bzdmC8oX+z3MC7NITn02plZbXuCGqI/voFQt6ND3ViEc1BfttSrp6WFabMSwNTc9CqhJNlBwV0dSHBvdrMO7NXQIERw58vFvrZHcmr0qaEn3blRzrWY2JdMTwxRvxbr6K1WcWbFgSwkNFnbvwfkJkuT1oXmaN3Uy/fM722mTJcSsDpo/MBgvwlv2dpqFHjMB+91dCgQgA4r4jK2rCm3wfDmjGFEh89oxdhpw4GZ4qRCmxnkipeW0nWWRz/Y6aJxDGjrip8aV52Dv+CANIGiO0pUEBVbs7DBFoiaJOOI1vAGgVR3xFt/P4c+WbcwSKWPD16ywP0uFHWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SA1PR12MB8965.namprd12.prod.outlook.com (2603:10b6:806:38d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.27; Wed, 28 Aug
 2024 18:30:44 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 18:30:38 +0000
Date: Wed, 28 Aug 2024 15:30:37 -0300
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
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Message-ID: <20240828183037.GC3773488@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs4tffQ9twCLL9+6@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs4tffQ9twCLL9+6@Asurada-Nvidia>
X-ClientProxiedBy: BN9PR03CA0657.namprd03.prod.outlook.com
 (2603:10b6:408:13b::32) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SA1PR12MB8965:EE_
X-MS-Office365-Filtering-Correlation-Id: c035539b-c317-4f8a-f751-08dcc78f83c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DjbWGfPRiQwTN1+8hPiLD2y0uR0w76oGTBge80tZP8Q0FhHO2IV3RtkI8ZvR?=
 =?us-ascii?Q?YuH8S3HCvmGDvK2WYjNUoc1tlmhRg5t5PR9WipFyAuvaS/Rq7evzqnCEV9nw?=
 =?us-ascii?Q?2L8mBnHak37ZubbccMWR1tQhcsJu1YvgECDGjzo3AWm73g8LDIdN372Q34Ug?=
 =?us-ascii?Q?dfWwW+UDYlAPPu2H7PsJH5BtG5PuyuM+h0D0sZ4+LNyg3g8CWWByBmFTe2oR?=
 =?us-ascii?Q?l9yV8H2hEP9Tie7+UcmP73d5u2xoCpqz9MmzzC5/TjCwMbHhpkSBf6ywrxol?=
 =?us-ascii?Q?nLAZNh0rkPgGkypxj0LOgBH+7o1Ym7C+JHJXF2KW5OTS9aIY3wCv9eM4g2J5?=
 =?us-ascii?Q?IdHqNNwN3gGGR0Jj9aNFPcAkPmZongTOP1yH2mK871NpPCYRSZYmyo/95n0K?=
 =?us-ascii?Q?kDrQyBZ9UR0WfJVGdNv53i+1f4arW1MEvTGBYxjdv8QC5gXyZ6t5f2LEiUO6?=
 =?us-ascii?Q?avyGOJml6Mmw3mUFGgQxKmkDBIX8ogOOoERQJmFtj/emfH6hLwURgVSyzLkC?=
 =?us-ascii?Q?rGe3aHK4ZDWHIeAGTmJbChOKdnYOZbTLK9BM2p4XuYNyN30i6YyWkO4MTzr2?=
 =?us-ascii?Q?mMPv4GgJmq5OpcarA3XfncCqPc7Xad+QVJlsvhavvqXPQs/1wgwRpWrV44mY?=
 =?us-ascii?Q?xTLiXH1QSvjX87kHEvLk8OgoFYRX/FHbXUYqJiBg4qA5J52iD5OHKCXcy92+?=
 =?us-ascii?Q?aYoTk3h2akQ/dsOLLCL+kjpqRSM7Q4W3LwuroErbsLQrY5mZa8wAS9aNzjA1?=
 =?us-ascii?Q?MR5CamT/8osxodZbnQyXkZWFeNgcAtjIcI5/4TRySpFfX5UFSyfEi/C0h65v?=
 =?us-ascii?Q?JN0w3BoGnTRcC+HOMTpS7YpkX+BQjGfr9O/LS0EoKLxto88GQZsoxaxqk5w6?=
 =?us-ascii?Q?/pdoYn6+GumOfjNx57gS9DkDRPQrCveKmmiu6ZOxEvl6MFhk+sRB+hMEmylt?=
 =?us-ascii?Q?Elf4HsXRBYEvqCWeiZs4mhfS41NRpAZpW+GWsPMmtoegUbmgp5zWJMRB/P0I?=
 =?us-ascii?Q?HNzkndMlzCfjarG6xTqpOFSMCw+7Cm3yDWupQSPyExHWha4ZMeGcLUX3WnXX?=
 =?us-ascii?Q?z0VlRVECp9eiu5FubWLC06zgNCWq6lQ9wwaifSlVJpI1Bssqx6yclFJ1WMSv?=
 =?us-ascii?Q?/7AecyTSe8NnJFaJlJmt7BjSLdcPt7ZP5D6VVX9zxm2nxUkgPKtyPu4ABOL0?=
 =?us-ascii?Q?9RlBmddE9dkdxRqeg2uyOeGyW1XxSx2CvuCy29WxNU4DvOz+p+vP6zYtn42L?=
 =?us-ascii?Q?r6u6u1FItFmgtY1diCAjn5AkAuAz/s4etPF9Dc93OjPITu30OD9GZnMCnO5m?=
 =?us-ascii?Q?sDXKBi82Th0fSX8rzznB3Q4MKCUuWiWj5UX3hJfKL9TbUQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/NQOGWVdixv+Afd6JWPqPrwBndVnNBo5ytt5bBG1oDxH8C39J+UkEeCTgd4p?=
 =?us-ascii?Q?yjJDvZDKg0cX2Ac84s6NQps8KA6L8O/n703Nbi4qRnGzOFIpjVyjtuNR71Ff?=
 =?us-ascii?Q?GgIVmF8crveJ+qBxGu0LnTevJNAog6dSTNoVzc7e/nj8vgosni7sm/GxORKJ?=
 =?us-ascii?Q?u1zsUXODdNM3PKKirJ5UNXxnxVfNQWhMHlmVPs+OyseN3yEToyYIU/cZoTZp?=
 =?us-ascii?Q?0kPpTmBMkyDPdOnN7lJS3BPQddh90pGIJgdQ+vn7dGEX7nozY+UOqRy7S4lk?=
 =?us-ascii?Q?oUJExX4G7QQjK0u4YQRY9rMywzMko3zkmryLtJOSj/F1hg4/2PT42NPMFrDF?=
 =?us-ascii?Q?IzWQB+xJ1rwHfh+BIbcItP4YyVI29fXxbNzfloYsDHcmrU8wbZIEq1IMRIkW?=
 =?us-ascii?Q?Wu3n6mC7pAUmzUTrSV9Prob+Kr8/uKNPcfT/jaQx0AxTGXKgGykiLDj0H1sk?=
 =?us-ascii?Q?EWhRG7m5+mCg0aFcepXQvl7omhUwm5NmPMXS2RXCA+xdD2EqDYB6K2QMaQDZ?=
 =?us-ascii?Q?3xEucPaiq2WUL/H9HmyD1E8HZq8MwepYPL1vnpigVUIRZeOttz60fy9ODZZu?=
 =?us-ascii?Q?fnt3XwvVbjoktyPR1Gxjd2hAI95wywluAwJN+6EcCISioJuPiUQJWUwXodjD?=
 =?us-ascii?Q?tMXhYHH/ZDvvDEeXgyAc2FDaaF1w9LIkVBXIZgWkF50agYV75sa7OmqqMRGg?=
 =?us-ascii?Q?t3nO2uR1OTCoVjzzLA5mo2IkVjN5eEm9iCMWmi27VkSOVaBqOTVb4hjnhc0f?=
 =?us-ascii?Q?ttLZFfs7u1NvrudHtMLNGR+GpUf/5n1rMpR6DN1KKSis49vu+hhifKavQ2EC?=
 =?us-ascii?Q?nhybDbn/Y0njo9PzgHwqCE9KXcDNx7pDxqZsYwTvNjj/i6aYRpxwIxwe7wiu?=
 =?us-ascii?Q?xICOgiW7nLlUj36zW6zl+T/BdFMc/vIZY3LM2qlCX95XZGNN4hNwbA0pwwBH?=
 =?us-ascii?Q?eqoP7DA+8+Erg2ctbpsdsnHwyznSEQ86o6M36MpG6ip02uE2VWTQ4kUUBdz/?=
 =?us-ascii?Q?/VBH5NK2WXdyjJkJ1xlclXy0sg6+cmSEDVYWn0AgfbLginYwcxXuUWBsg+iE?=
 =?us-ascii?Q?nmLQlu0prZYO416VLMKQBcaW2BfOGepEIQD8pPTOaYuj1ygrrWd2MtxthxS5?=
 =?us-ascii?Q?+ekJDL6YGy9QfOyoSmqlHJSfWTSArJSNkbMKt4BDsu2dQ7knp6ukW/uF0UFR?=
 =?us-ascii?Q?bevZTGLsA9rERt1ZbVeU9aPU8NizrcsgywYwxxfwJjCVlskfEGh4GjAmM5rQ?=
 =?us-ascii?Q?pUAnhoXtb93Q+msxRX5W24FfKe2qz2b2xsnJ50ybH5V66E92fnhJI2+x9opO?=
 =?us-ascii?Q?EHQq2931zBybsluOZ07BLp9ezH/Mx9X6b/ZrE3nM974mRIRqLBfvO9WEFdSH?=
 =?us-ascii?Q?+nPFOMn302K6xfKN20ckV3uVh1Qlxg7V7nBWOdMKbAkxGF/CfNW9X6z2dSuQ?=
 =?us-ascii?Q?A/piPbaDiUraldgQ6uJE6boCRp72SVdWee5NZwzE2Plgrwv1cx4lEKhAfU0h?=
 =?us-ascii?Q?PvefFypH73VdkNWb1G2x0YD45MPAwmD7S+RTQN70bPqcLEccp9ciFrQ45bzl?=
 =?us-ascii?Q?VVvrcTGhi6EMrUDoiB8QJJeB1Z/i9iTzN9e6uMPv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c035539b-c317-4f8a-f751-08dcc78f83c2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 18:30:38.6216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BybH/x+iVcCarYDDa392HmugQqhBaGDMgWRXeDBCkeK+BiRanF7izN1QvSV3XDYL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8965

On Tue, Aug 27, 2024 at 12:48:13PM -0700, Nicolin Chen wrote:
> Hi Jason,
> 
> On Tue, Aug 27, 2024 at 12:51:32PM -0300, Jason Gunthorpe wrote:
> > diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
> > index f5d9fd1f45bf49..9b3658aae21005 100644
> > --- a/drivers/iommu/io-pgtable-arm.c
> > +++ b/drivers/iommu/io-pgtable-arm.c
> > @@ -106,6 +106,18 @@
> >  #define ARM_LPAE_PTE_HAP_FAULT		(((arm_lpae_iopte)0) << 6)
> >  #define ARM_LPAE_PTE_HAP_READ		(((arm_lpae_iopte)1) << 6)
> >  #define ARM_LPAE_PTE_HAP_WRITE		(((arm_lpae_iopte)2) << 6)
> > +/*
> > + * For !FWB these code to:
> > + *  1111 = Normal outer write back cachable / Inner Write Back Cachable
> > + *         Permit S1 to override
> > + *  0101 = Normal Non-cachable / Inner Non-cachable
> > + *  0001 = Device / Device-nGnRE
> > + * For S2FWB these code:
> > + *  0110 Force Normal Write Back
> > + *  0101 Normal* is forced Normal-NC, Device unchanged
> > + *  0001 Force Device-nGnRE
> > + */
> > +#define ARM_LPAE_PTE_MEMATTR_FWB_WB	(((arm_lpae_iopte)0x6) << 2)
> 
> The other part looks good. Yet, would you mind sharing the location
> that defines this 0x6 explicitly?

I'm looking at an older one ARM DDI 0487F.c

D5.5.5 Stage 2 memory region type and Cacheability attributes when FEAT_S2FWB is implemented

The text talks about the bits in the PTE, not relative to the MEMATTR
field, so 6 << 2 encodes to:

 543210
 011000

Then see table D5-40 Effect of bit[4] == 1 on Cacheability and Memory Type)

 Bit[5] = 0 = is RES0.
 Bit[4] = 1 = determines the interpretation of bits [3:2].
 Bits[3:2] == 10 == Normal Write-Back 

Here Bit means 'bit of the PTE' because the MemAttr does not have 5
bits.

> Where it has the followings in D8.6.6:
>  "For stage 2 translations, if FEAT_MTE_PERM is not implemented, then
>   FEAT_S2FWB has all of the following effects on the MemAttr[3:2] bits:
>    - MemAttr[3] is RES0.
>    - The value of MemAttr[2] determines the interpretation of the
>      MemAttr[1:0] bits.

And here the text switches from talking about the PTE bits to the
Field bits. MemAttr[3] == PTE[5], and the above text matches D5.5

The use of numbering schemes relative to the start of the field and
also relative to the PTE is tricky.

Jason

