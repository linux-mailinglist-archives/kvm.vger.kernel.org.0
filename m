Return-Path: <kvm+bounces-30504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7820D9BB4CE
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 13:41:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC3BEB228A3
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 12:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9744A1B6D03;
	Mon,  4 Nov 2024 12:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Unog1UPH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259EE1EEE6;
	Mon,  4 Nov 2024 12:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730724068; cv=fail; b=tndtMaLfWg6MATrWRCMSM9or8qvFtIg1xGTRwk1BTUYpCvJcTYZhiND71CV9vrJO7F0srCIqeFzkaim+S1TXTkTpZvBrzz14JmfTTR+1Jr2tc/YCs7cndibYanABvnfoLN5EGObX1hvb1U2H4Y7hWzA6VSG/J8RAJn7qX5LYjL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730724068; c=relaxed/simple;
	bh=58J7u7JnfJx2oj3fqw8OTE9DzSraU9qXhMOcvlgDz9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=t3WOwvwP6qfIwyANfBfzenh5f0HdyIW4bPgUw5ZK3+uW+4YAl7yTCekJ/rtniljvLHiPA6ABLCM4jDZaXtTxwrgTU0MxspyVNdXU676aN0xZz6hAA/R9yj2NsAauQv6b8bnxaQ8siluOfw6Hy2NlmAv+NsemzatQZBodHzt+x3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Unog1UPH; arc=fail smtp.client-ip=40.107.220.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u4dZLTC0iQ/U3DS5lJKTPNg4qNbDGsI1GH9gAk9WXk+ts5jDzwLx/LA5WoRSrnrj6QO5CY3xmwugK/o2rr1FPixLWqSkbjT/sCUOm/oQiYI4Zs9BIIxOwuB5G7twSWz70NdoCFICqS1rue7r70nbJM3bEY+Ef3ijJISpbL4tKusSDKTIhDz5nl8XVVpX92CbXf2+R2BN7RUGKcOO1lJ6vbMfcDlid0RypELqZxGlbtjJxjN2vcUNJMJ5sdENvSJRNM+pbl+Mp5HESe9RBZLYyaViocbxhz+050+04LOcHEtquinTrX5P2YsMXaLs50ZBXU2Hv7l8+SdZjsBeNFvh0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VinmZfunsDsWF0UhJLqKRTnraNxSEAh/PhIPTN48UEg=;
 b=S1JgX6PvP5m4+1f/BtTzieYXPN5fJ3u4vDkFzPRYq7CXFsyYavv85zEHsMyaCUQu3HaCmrxNzhZdyMrBAD/TV0yiCYNZafFsLM30yzQm4U5piegMhDIc9u1lumWRrxewG4IV+g+gNr9wpRkBk9pm/DAzaCjugB5I9zvRwJWx0iCdYnL795DELV1GvSB7Ebj+yZmhP5+OePtvWh7Krfvi0jcsawKSZ3kK1W188W469970OLpuIFhhfvhmf6absioPaDYfnluxZ29IqNoDxoI9pboLGhYYo72aJMUozOvd3TRnI3Bar6qQYvh+KO4IW2hkEUqMKRyzSegvOcYfKb2LnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VinmZfunsDsWF0UhJLqKRTnraNxSEAh/PhIPTN48UEg=;
 b=Unog1UPH9hu1MYu9Fz0two/KL+/3lgjBYBXyoKltPFXO8KnUvHfMIxunYjmCnaO7bzs7HQtLX+JaBPgJqrjsRlqxeJWAOJoEqYvnxNY2FMSAzTkx2cQ56QyssAf/xc5AafU01mFfOZBXycLvv0Fo3zfIpHsnk84J2HgVUcdfVHMk0GGPSstUatqcfPtbUG1uoXxhrV97GS7R+Cx6YcHqja9enOER7ozjXS6BbvXoigCXZUqeSyFN6Qdev6m5hI11KFQHXN1uYMMfuSNQV+Zbqb5m00bWfrD/u6EL1I8qvAZshaylXFeXNVeubblrDu+mxVNa/o+a0H7ISIS0BZn1IA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB6981.namprd12.prod.outlook.com (2603:10b6:806:263::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Mon, 4 Nov
 2024 12:41:03 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8114.015; Mon, 4 Nov 2024
 12:41:03 +0000
Date: Mon, 4 Nov 2024 08:41:02 -0400
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
Subject: Re: [PATCH v4 05/12] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO
 via struct arm_smmu_hw_info
Message-ID: <20241104124102.GX10193@nvidia.com>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <5-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241104114723.GA11511@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104114723.GA11511@willie-the-truck>
X-ClientProxiedBy: BN1PR12CA0003.namprd12.prod.outlook.com
 (2603:10b6:408:e1::8) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB6981:EE_
X-MS-Office365-Filtering-Correlation-Id: 779f1224-d9a7-4e81-4892-08dcfccdf192
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0CJ9d+QOnsPwP9XLtxtaQtQyI+jmxQvsBBrWL84KvK/pxd7E74BYrKoGCXk7?=
 =?us-ascii?Q?nONTDx0pmKm2XnKeCQ0PXMsXQvAA6bduAEP+6nOB1iURRiCiANGz1PeHNyoV?=
 =?us-ascii?Q?9+WydJ0yGR6yb6j5cotRfy3w5liznvZf0TPeLkdlR6aXYinKbWgZSXtwCvDO?=
 =?us-ascii?Q?NXG0elBpv40XSdaNXnvvnBkUjAERgQgoCXtbIyEvA2LA9TFzYQq6bXs+6c3u?=
 =?us-ascii?Q?Gp10kNyBGZvHFAD7loBA3YHUDWaojQWZDCjH7sovQWIYVKDUtVwcWIwzh4IM?=
 =?us-ascii?Q?NqIGkxbpX6AaJj5aBYJgh3423QYAqU4kjLnfW/4rbLiJexqPeCV2bfGA9qe1?=
 =?us-ascii?Q?IbbzWxyyMo/bWOnrckeP5DVZqy1h89fnaLp3fzHZeZmJEf9xzBr2JdSLs5xd?=
 =?us-ascii?Q?JWUKd7nF2mB7of40JW15u5kDDw3rbmnX8rs3ZVzSm7gP7St9U4xroScvMyNd?=
 =?us-ascii?Q?vFLeAQRmrKhVRzNtQEeZTuWJUc1qUumT87WImv3r5VnSWsad2IzV3776bywi?=
 =?us-ascii?Q?S5hZISIkBlOlL54RghCyjDRwfY+DBjXVf2j0S5CsMWQh9LRRpRK9UeO8rn0S?=
 =?us-ascii?Q?c5XdomjP5Z8qdeviRnQkXg8FEOeWXvTxP4QN230/0ZPcjLhISH4torM4KBu4?=
 =?us-ascii?Q?rLX3yrj1JK/FhSzVrk+V+OtekywqFMOUERbFBUSyTk3RXQTAqrn9AVj6aviR?=
 =?us-ascii?Q?wwN/CmEzFKFD6ec3w1Lu2uQiY8sZecDf45Qx5XJeV7Y0wighdxUFz0CqZO9Z?=
 =?us-ascii?Q?JIb/lse0ivpPA6cnYwQFpwIju3YB6DFZcjLUuzej/Cytden8e308cwZSweSI?=
 =?us-ascii?Q?vohcMMSxA1sSRp0+BPwuWFv8R6ZP8OfLpdIzj6yz8VxbCmiXscB1wqqV6p8o?=
 =?us-ascii?Q?TbpevU9yYnzp4LK2LQcgIli+FklVdwukkJ/5jSQeq+ISCq9bHIVfhgZPdpmD?=
 =?us-ascii?Q?c2IAv3B4dCRV1PpPye/Yt7XeZ11qRpsk2GXNgGcge9oOBPaZEXbJqo2VPbMN?=
 =?us-ascii?Q?jqtkLXGDBqPozRoHMPrwUWIm9HwEELGU6nkwe/UP60Pfl+cwqe+mHQswuoRc?=
 =?us-ascii?Q?KGgIL1P9mywOktdH9aoJ2uTCHsfe/N0O0PCa8De1tMAA0Mlg1MYTIKBSl4JB?=
 =?us-ascii?Q?hlLJ+IUMkI7Rv4+Ls4f7S5SWvry1QENK4CaBFsCf9H81jKZyPebRX3ymkoFx?=
 =?us-ascii?Q?seOhHelS7squR/NKAwg8I2XWonZmiPArPE7E4HEAutQ0M3oCyXxJ+sVdR9iI?=
 =?us-ascii?Q?Q8i15KDZxmThMljQVf0xOsebp4GhHhsdtMxxi5MSqGw+2aj9pqXYGuHOKNwa?=
 =?us-ascii?Q?j7mihqBqcMWqoFCPaopZDNvb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l6XXC73VavdwXQhhV2LT++uOxmcszj/BG5lo6TX8Rt4+z6wNmPTbsrW6BYHJ?=
 =?us-ascii?Q?ZAaJ0efrqC0mtajH9ZrqFT9SEpWkC0wTIgN1p0cJ4juOgnzTFKnhddJVH8ss?=
 =?us-ascii?Q?08cORRyv5OVPDDXeZulAs6npV1Y6iDINjiT90H1K931PKPmmN1toQH4H06MW?=
 =?us-ascii?Q?Pc9QVrfWWIJYdZfJ9icClamXVrlsA5KcTAWsRdNnX6OQq3vyL0ydWzQDKs5Z?=
 =?us-ascii?Q?nHb3wNDaaSZOwZR2C7PanT6ZbRZzQtzZ4nQaudtxInqmvCRKhwOFt4g9qgqA?=
 =?us-ascii?Q?mlVrvLkvmAC/QqZZAzF7aZKqlbG1XH81jDPPsg1O6TMcP58sC0vfALsz1H2H?=
 =?us-ascii?Q?4ftGrQ2xJ9EHhpyScsjOmSBGYsAIhXuxGRhbN7p5Mn0aaVUsGg6xIWQRMDwW?=
 =?us-ascii?Q?54AFRSD6aSaQuhQipbtBBFGjcQZ5gCGO6H07bGks0fe1d2V9LAKx2XR+NmIv?=
 =?us-ascii?Q?SqG7qtg5/6VYnYPbMHyFDEaYIMA8H//mlvG65oQpFXWEYdyvFmZTnzQ43LmE?=
 =?us-ascii?Q?3zFAHQ1P444IOkp42GfZhqJCMywVr3GBCIPOU02+TJPD12X0ZsdaT77rjRcq?=
 =?us-ascii?Q?GhlpS6H6y5HmeJk2b1mKx9E5W3bT7cEmHl18HTS08wr7OpLJFd/DyTEaHCVz?=
 =?us-ascii?Q?Bg4GtOiv7ukB2edCPBaWZrRIWPS8dEsPTapuJV+M+OB2sHvEjJTIsvdPZC8I?=
 =?us-ascii?Q?dxiyiqsXtXpoepGcnXtw29dPZi4Ebm+WmbS68fXI+NWeylNdrmerkdSZOxw6?=
 =?us-ascii?Q?YqAFQuVSHZiEIeCusxNN7eGaw3JxnhQfjTna5oZl+SYxe+jRQfgbcjE+3tbv?=
 =?us-ascii?Q?4dOE2lvhGGaohua/+Wd0aqe/N7tyPtjIw3eJU158b7qSJf5wnXYZJLDqZgpW?=
 =?us-ascii?Q?daTTkLhjgxula7fuo+b3PI0H0vuZQK7TTDeuXLnvQ0CgTFcFubPbPFgZ+H3t?=
 =?us-ascii?Q?qrymCL2yrML/AD40GKVkoejg3+dXp0wFuCjX5s+1lIbvLfQTrSMqU8fiuY0j?=
 =?us-ascii?Q?7/kJiCqju3mRcBVOh4Ygfe8BWFm2JQ3CQCD/WJ2EPRwjUUECJHZMBdVrSxs3?=
 =?us-ascii?Q?Nrni5TG1rgIvlOAVCROfj/C+bRYn7kklaNHe+e0lPJLeKYQm/e2F50kpeCcq?=
 =?us-ascii?Q?z30iCCI3SNAvGSB9rgzi0DLoSxQeB1uLMoENTa79PuXPUTKeQ+5DYDVDL+nb?=
 =?us-ascii?Q?PJa8SNQg8eQc/Y/QPCFG3qkmClclr1vJjfuGJw9d1/gFpZ9qsIDVQ3sFb1i8?=
 =?us-ascii?Q?QH90CVS/qeVn3AEdLD5J1fAytoqJHVg97IdMsh3qlvXIctAGkUGlB+dDb9hj?=
 =?us-ascii?Q?wAdpg29LGJiJSJ38cp1+Y4/9lVG1Sf2BgZvPqTT5/8UvE0cVk/75Q5ajdRsW?=
 =?us-ascii?Q?wv3ofCWDYwJ8uwuaqFb/tFx0tM6AUqtwWVFx7n6ofEQaD48f2j9w7Rp7Eb/r?=
 =?us-ascii?Q?mfoLu8GZ2h0H1CPlkiM5oGUHteiJ1jCueF+Ev6iTtF5RjeASDyzipaW82A10?=
 =?us-ascii?Q?BKh5eCErw1vq3VUW029EvNUGKB0GZOYzDex0zZpdY+6p9pO92cE3N8ZDka/3?=
 =?us-ascii?Q?7bMUwelbQOnBjg7/FIs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 779f1224-d9a7-4e81-4892-08dcfccdf192
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 12:41:03.3715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JrXLQ9TwYd8RH9rAH73yEPdGyes6o91GvY3mit2NwoYwzrernZaktKjnutN0GwTQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6981

On Mon, Nov 04, 2024 at 11:47:24AM +0000, Will Deacon wrote:
> > +/**
> > + * struct iommu_hw_info_arm_smmuv3 - ARM SMMUv3 hardware information
> > + *                                   (IOMMU_HW_INFO_TYPE_ARM_SMMUV3)
> > + *
> > + * @flags: Must be set to 0
> > + * @__reserved: Must be 0
> > + * @idr: Implemented features for ARM SMMU Non-secure programming interface
> > + * @iidr: Information about the implementation and implementer of ARM SMMU,
> > + *        and architecture version supported
> > + * @aidr: ARM SMMU architecture version
> > + *
> > + * For the details of @idr, @iidr and @aidr, please refer to the chapters
> > + * from 6.3.1 to 6.3.6 in the SMMUv3 Spec.
> > + *
> > + * User space should read the underlying ARM SMMUv3 hardware information for
> > + * the list of supported features.
> > + *
> > + * Note that these values reflect the raw HW capability, without any insight if
> > + * any required kernel driver support is present. Bits may be set indicating the
> > + * HW has functionality that is lacking kernel software support, such as BTM. If
> > + * a VMM is using this information to construct emulated copies of these
> > + * registers it should only forward bits that it knows it can support.
> > + *
> > + * In future, presence of required kernel support will be indicated in flags.
> 
> What about the case where we _know_ that some functionality is broken in
> the hardware? For example, we nobble BTM support on MMU 700 thanks to
> erratum #2812531 yet we'll still cheerfully advertise it in IDR0 here.
> Similarly, HTTU can be overridden by IORT, so should we update the view
> that we advertise for that as well?

My knee jerk answer is no, these struct fields should just report the
raw HW register. A VMM should not copy these fields directly into a
VM. The principle purpose is to give the VMM the same details about the
HW as the kernel so it can apply erratas/etc.

For instance, if we hide these fields how will the VMM/VM know to
apply the various flushing errata? With vCMDQ/etc the VM is directly
pushing flushes to HW, it must know the errata.

For BTM/HTTU/etc - those all require kernel SW support and per-device
permission in the kernel to turn on. For instance requesting a nested
vSTE that needs BTM will fail today during attach. Turning on HTTU on
the S2 already has an API that will fail if the IORT blocks it.

Incrementally dealing with expanding the support is part of the
"required kernel support will be indicated in flags."

Basically, exposing the information as-is doesn't do any harm.

Jason

