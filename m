Return-Path: <kvm+bounces-30306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0F019B91F8
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 14:25:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A24DA28492D
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 13:25:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 205B619B595;
	Fri,  1 Nov 2024 13:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Nbd8GLFw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2066.outbound.protection.outlook.com [40.107.101.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E876F1A0B08;
	Fri,  1 Nov 2024 13:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730467512; cv=fail; b=DrJQqol12A2XxgxNeFHbAZ1I/rK5JZ40924bL9z6DlhCbihHWx0D+qRIplhZSTmmwhnHVdwyVXu5ZfogjTTnJNRf/JMqsT8z11O7yvpckxPFQf9XXZfFdH7rdWbN10bGmbRzQCjn539UppgHvXwWguoRJSr4gOIGHmUw8oyRtho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730467512; c=relaxed/simple;
	bh=BWI7iVOxtLXqHK15ldcNnS2TwV/xea3of7oXhsoA9Nk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iXKhJMaZhXNNYWzzjQS3oF6g4Zw0A1ZkSsWZFVkA/9be85vD4T2QQnAAZ5iN8OP+lP6//+/7FytD+OZaXLbqodR6IbC9BlmmXcr3gfIjqNtXDJautlG7Lwp/KKvYdJyzxexJ6Cv7EyaICtNfvZMKM8piMCq5v9pjJ66SYHSj21E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Nbd8GLFw; arc=fail smtp.client-ip=40.107.101.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hqUrDKYThbRQs5v1dcW1GzrhVa3Pp+QAEasaLz/lOx8THzQCmGVTfbbs9JLYpBLRqSsRsAAYCpoqeVr6+eAn3QE4ezL7v2JRxcf9gHbsFIJYaR4RBYaaTF7BL6cGxX51cOu4QE5TCf7ox+Cz405DSV5jVE6vsBN22RUh6sIFmsbSPtZ+wnWQYJmL3OUve+XAIsdQGOdU8yf75Ffsnzn5tlZ8DXJ+Q4QFhiGjW34xh/SEs7ymijta0eTdKY3z0aaL20XGj6TPcgHKebAqu30ttkBubuOtiLFb7105THarGjueH43FBWCbCXLg4QobpoZ9JwsIPCnZGr42st04YDCsXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nDalwpw141im1g5ua+wAL9t7v528fwlzrJ32D50VFQI=;
 b=TpG5SAP/Ne6cv5SlhoAKOtvorKkdDrMYoo6FEMQLN7xn56PYbqQkKLXxux0hvbsB70iozAzpz8VuZfnczefASCLmuBzAe3VaA65QubihYkARe0cPTmLyHi3tZlxtGaFBmarn3Cs1c/hyR+ZEV1lg21sCdYR6v/syjrtUaa1SPPlqpLZwAs80p0bNhDG2XvOFg0yxHdc+vei1ZZsY2bPHyVau8rg5tv+/tep0Y4vgahXcpTLZePZZe9aNixjLu5QGD4jT8sINZGsNx35I5oBOh6gjh2VJGlA3x2RaU6xbwkqTRqxtyJk2ossPNX+ZhnnNROHvgj+RzAlXJvuIIs8iyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDalwpw141im1g5ua+wAL9t7v528fwlzrJ32D50VFQI=;
 b=Nbd8GLFw3rIC6cg4iWr2CK3e/6DFm0Nz05Q/0zhkv8mHUIdjwK8xvG2p9+4Z4DOct6pdx2LAulKk2Wy8bFWGcyi4qXUOdU/CiZVFrLyTyEQLIsAixCOowqzcB5y9E6651B5/P8pwiimlMpeyLw8Bz+RZWF22Jvg1NHjfxbCKS0zk/r0gEziFrC5+EgxFQhO/DWtH3X7Wsg2hKygtw0PBV9hVNEjtlHsOWNh/EAWK24I1EmZXCAdjmQn2btISrh1Mae48D4b8zMucNWVy0lUBTL0VVqv1yi6JNwiiwNcTy134t+X4akndRN9zMuo9pTr29z5Tlpi8HI6KRCljn/ypLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY8PR12MB8194.namprd12.prod.outlook.com (2603:10b6:930:76::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.20; Fri, 1 Nov
 2024 13:25:06 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8093.018; Fri, 1 Nov 2024
 13:25:04 +0000
Date: Fri, 1 Nov 2024 10:25:03 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: acpica-devel@lists.linux.dev, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
Message-ID: <20241101132503.GU10193@nvidia.com>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241101121849.GD8518@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241101121849.GD8518@willie-the-truck>
X-ClientProxiedBy: BN7PR02CA0033.namprd02.prod.outlook.com
 (2603:10b6:408:20::46) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY8PR12MB8194:EE_
X-MS-Office365-Filtering-Correlation-Id: ed31feef-f259-479e-c20a-08dcfa7898ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?e0nhQf1lOBrhFtMBNpmIj0KPp5ywpOHS/TQBEBiAOae1Am/0tT257hxp8jO6?=
 =?us-ascii?Q?5ZqdaXFDk8I25TNUUj6jkjTWGO0/rq1DrHrj3tkLiU+G4VqKxkHrjFhlLGZo?=
 =?us-ascii?Q?ubR/9a/c4dAZ8WJjtF/Ut9/632Lfu+E6qEOAuVg5Wi/yU9km53PowQkwYbhF?=
 =?us-ascii?Q?FQyBYumiWtXCSyMUdXIOfqSYnZvfT1uQDYPoGxla2J4ms10Ldv50eH4sOTuh?=
 =?us-ascii?Q?KW9zPAtEcHooWZyPHpB4GdISLX3yzX9+lOMB8Vl+CylwQH6dlVAwv3kvTBHj?=
 =?us-ascii?Q?CVoPpvGNh1g+YqEEgWhUshDHy38or7aa5tiD/26whiO8M0rBWd8EDdpuLUoa?=
 =?us-ascii?Q?s3TV7Rcy80szhYo+D+c2IGgLf/AIT9zSfNNcQj2lv3KGzhTmaBxGbEGEGspx?=
 =?us-ascii?Q?MhqwV8DfoPv19GFtEJTmTb1xi4XxrwvFB8oYKnRXa4v4smIAokP/kxtyo7Yw?=
 =?us-ascii?Q?rUlOvbrmDJSCGeo8fNn8Vbgda54gKsCYB3/wN7SjNTrLYVhPRRYEX1KmT3xm?=
 =?us-ascii?Q?CxCPkgjKvWzPurGsFGFs66t7ePDhaon2XcomiW2nPg2rYwJdvb4m98uFLojJ?=
 =?us-ascii?Q?3gbUjDTZ3p/aSa+ZKEwvrA42XPdL81l/+f9IgqBmRT6eWOxub/e6TY+UScQz?=
 =?us-ascii?Q?KG6qYERcQIya2TLPq1dB4FfMK20DIeAfEYzejRguVjD6aD0ZRZH501zMdSrB?=
 =?us-ascii?Q?dREfkFpTFFOqR41XtnEokgXppJEthzzrwIB4I0SRIm5jPPDg/tWid3iEyYVc?=
 =?us-ascii?Q?PGbfmIXtFrUsOYJiLUvDocuOcHmncjdyF3v7M9fjvB+klkKtgoPWyGTyOJTK?=
 =?us-ascii?Q?GYUr61ltmA6jwpuiCp/PmqHVsdgqC5YUF5W0re4wYoCrODLvOEHARcW4jfUL?=
 =?us-ascii?Q?P0izC+Hq3+nACzPkzDPu4r1APCB3MTza5JRlvQhJu5TVBJx14vurwYxg+2JU?=
 =?us-ascii?Q?VM2VPxIjC/wjf70dTtp4OoQy0xoaYoN6LVXymUbZqczP+mQk/jMrZBN9R5l4?=
 =?us-ascii?Q?Md65st2g+przAb3dM1uSDp6uN6DTltsOZZOzydfmmDLSRJL0/gwyUDaYeqRL?=
 =?us-ascii?Q?wbhyjZx+WN0+t7HLRB3+3YSLQtAPwJdX8q3TnLtTVFo8Dx7NPUi6XbkEc5gl?=
 =?us-ascii?Q?IxQ05bdl9gwCoORDOdEd+JgaDgCTTS8cDfxWMcRJgI2AYOwnJvehVeJgePYM?=
 =?us-ascii?Q?g/dpKQlxGmcOM4gMd3GukyiM0XarE5KJ0q9dpL2/u24+vqIQI7spGbtsJfoN?=
 =?us-ascii?Q?q5944IPeqaLjrK6Xdv/sjTT3TKU6bj4XvOlbqDs5CARbkjL1sdee3JtHczo9?=
 =?us-ascii?Q?QhbCwKlS8mBZocVI2o4x8VwA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Jh071/xHVWV/5VorazXt25qlujlhcdmb0w7Skcv4XihPGFa4cB/wv4/Xepwd?=
 =?us-ascii?Q?97oL/EcOrjPrid/v/7GoxN3TMhLv3a9d9HywY7/rjWT3eAhOXtvnDBccrmxT?=
 =?us-ascii?Q?rAnhU8V4skWxTh/utjQce9zBIxTzno8w8Z+gYxtWo587Nu2vNRGyv5TepFZL?=
 =?us-ascii?Q?KdJSGOrFI1+yMSoulHhNOdYhxE7vz+6h+QtgKXHJwd60Bkaver2Pi47mPJ8i?=
 =?us-ascii?Q?HyMZWZESaoG4l1sRXAV6F4Y4yJLTlomcmZe8YXJ2njd/z5ruBf6lTisqRFDg?=
 =?us-ascii?Q?gMRhwvRW8IgHtiLFRXvBVdEs4pMYX3U+62GaWcamyfz4uXyIg4ycxAGHdQ76?=
 =?us-ascii?Q?bP/oN7zB9dN9wC9kRpnqjtqHXfCwcMvMgHsk7gAl3D0UHhFRAcDLPSPuO96g?=
 =?us-ascii?Q?le4WogqMMbHVDnG86O4muQYkXXbAFwgsYA1sjfV21hyk5+3Voz5CnqcOUksb?=
 =?us-ascii?Q?NqfMJdRSsaTJ/SROF+9Y0TE6oDSBz2l3nC2EOdO/KZIoPZHzkvWZQacpvifc?=
 =?us-ascii?Q?9LcLUH1n7vBKiYhNFMjjO/9N2oEsZHZxhk9XUpPna6JnHfdzPexxUOZiMVF/?=
 =?us-ascii?Q?Gk/VuaQjc4HjvGRvkwksdIkgaGt+vJEcwt1Xsy3s9v/F7ek07rki2bzB/T6j?=
 =?us-ascii?Q?G2l/OtWyWu6+xznTed1ARqUBLaKBDCL+efmtyEqnKzPKKfC4uo70dDnOusmu?=
 =?us-ascii?Q?3rWS7WO2UdSygL5IfLF1ns1GyjXpH0zVTR5sVwFi/9I6vGqqCH9B4YynuNLX?=
 =?us-ascii?Q?HXOiP2ShuN8h1Y9D3rVRjcVZw9JRg4/X4Jqhd7HdXp6fF77RauZry3mSpcwi?=
 =?us-ascii?Q?4eKIu/rdWzIrVREW4Q07rQem9d59bp0AE17T1eKVHd5KfAC9hKO8ZVd7m4fW?=
 =?us-ascii?Q?EA/zo0BUO6vs/56RJnYuGaOOzcWSwZ9/5vu9a/O6qJYUTBET1YrQ5syWlyWl?=
 =?us-ascii?Q?Us4GpQ5yi7Vx4g0SwK24LmJH/jiE/6bGnxlGg42sMrGyOC8cB11FpxOmaOtI?=
 =?us-ascii?Q?JMm0RM1aJAKgpWU3w8gouJxwU29pzKkgqJ7v/E20ViI8ZD7lE5pG6ECQeBx3?=
 =?us-ascii?Q?heRJqchbJ6svgfoOEFp10autZ8N1LC8ZbRLFSXLLomcvhOZCeE7ERrXlFVOZ?=
 =?us-ascii?Q?ZsmGtWLUrA562/Ud/vOv9/gb5beGyrn7KmEXk9ce5UzwVKMGFt5+au9iQWGO?=
 =?us-ascii?Q?q8BZLFFyyJDL6p/R9Afsz4CpEUy1wV5vKvcqt/v/6TSkAVZ3bHspx2woMFwR?=
 =?us-ascii?Q?lpOcESsX/+wX8kJPtMRJCDDnXiR5x7dkC+OP93j0WF+XpyUk3foC2prBm72s?=
 =?us-ascii?Q?Emk2Qr20+ajdL/bT1Mteipv1HfsJ2S3X5gdLhz1zoZD3iXJEwrdx44qEAuBw?=
 =?us-ascii?Q?zGEVLeIDSyYOGHIwPJWw3L+q/VXUbCBWpETeKlu1GIFAWWvRUv2dOjZPOn3f?=
 =?us-ascii?Q?W7sPIvUueIkIgee6U1R7tMsHoNRwg0VGpOhboV8DjXy491o0FqWMcGprz/qS?=
 =?us-ascii?Q?HWAmcdHdi+pun+sC9iyseb4f9VZdpRMFb6WrLM7Sspiq0C3XtoEGMemcHXBJ?=
 =?us-ascii?Q?bXDoGI6zvX98MjvNmUA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed31feef-f259-479e-c20a-08dcfa7898ae
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2024 13:25:04.6475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pGeHYI6m1/YUhjtJAXTgqQPhVPoAcwRcBhdoVuwO6npbI2SiDBTSNsCqkfuKX4pM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8194

On Fri, Nov 01, 2024 at 12:18:50PM +0000, Will Deacon wrote:
> On Wed, Oct 30, 2024 at 09:20:44PM -0300, Jason Gunthorpe wrote:
> > [This is now based on Nicolin's iommufd patches for vIOMMU and will need
> > to go through the iommufd tree, please ack]
> 
> Can't we separate out the SMMUv3 driver changes? They shouldn't depend on
> Nicolin's work afaict.

We can put everything before "iommu/arm-smmu-v3: Support
IOMMU_VIOMMU_ALLOC" directly on a rc and share a branch with your tree.

That patch and following all depend on Nicolin's work, as they rely on
the VIOMMU due to how different ARM is from Intel.

How about you take these patches:

 [PATCH v4 01/12] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
 [PATCH v4 02/12] ACPICA: IORT: Update for revision E.f
 [PATCH v4 03/12] ACPI/IORT: Support CANWBS memory access flag
 [PATCH v4 04/12] iommu/arm-smmu-v3: Report IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
 [PATCH v4 05/12] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via struct arm_smmu_hw_info
 [PATCH v4 06/12] iommu/arm-smmu-v3: Implement IOMMU_HWPT_ALLOC_NEST_PARENT
 [PATCH v4 07/12] iommu/arm-smmu-v3: Expose the arm_smmu_attach interface

Onto a branch.

I'll take these patches after merging your branch and Nicolin's:

 [PATCH v4 08/12] iommu/arm-smmu-v3: Support IOMMU_VIOMMU_ALLOC
 [PATCH v4 09/12] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
 [PATCH v4 10/12] iommu/arm-smmu-v3: Use S2FWB for NESTED domains
 [PATCH v4 11/12] iommu/arm-smmu-v3: Allow ATS for IOMMU_DOMAIN_NESTED
 [PATCH v4 12/12] iommu/arm-smmu-v3: Support IOMMU_HWPT_INVALIDATE using a VIOMMU object

?

I can also probably push most of S2FWB and ATS into the first batch.

Please let me know, I would like this to be done this cycle, Nicolin's
vIOMMU series are all reviewed now.

Jason

