Return-Path: <kvm+bounces-29711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 68FB69B04DF
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 16:01:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEC43283A38
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 14:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE1D51F757E;
	Fri, 25 Oct 2024 14:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CrpY7Tkx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2054.outbound.protection.outlook.com [40.107.102.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06FC7083F;
	Fri, 25 Oct 2024 14:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729864854; cv=fail; b=PYot4m7dQBnvpJoTVQCwIjhjeKLRq54EXoVZKrq1ha1YGg0MfBZQ4mvo8FpK5+stUwe3+jHncwDfCl5AwZJbdO0vIfok0M6btHjVjB38OPX2UGXyRB4YqBCzODkKMYj9ljaI1XMHSF0QbsMssLW4dMhI/ObwPew6vKWoVfX19B8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729864854; c=relaxed/simple;
	bh=Oc+UtHm2UAaar7wgqZtUJIoh4MlEm8ZpTvxmCRb9ZLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NE69bfmT4EyD8tmPTU68pSvhFAbJjEijCm8DWhOoIcJTiFwG33JWLCnf/NzefL2IdhoffYlsSqpJJkY1YvXcok8dyWBUIYGuQGYc7P+WsPiHQcCFb42vDzlvITwFFPTZ40BA71/dsP08hLJ7r1NqkTZhU6Yf8p5PPlzwlT5LxDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CrpY7Tkx; arc=fail smtp.client-ip=40.107.102.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q6VR+hJ5ZrtbcifNxAYfT3MqKs7VvRxAVfEUFEkjsMWEMPjTlXpLN1TzJF2LMkWYdeb83N7E3gMQsYe5pXPdqHnyrxKtIf6Vh5GnRNViDRT2fWzRFMctc2iKjv9oMjWPyJt56weaNAXg4HhDj69eKVn5dVp+QVAAbjVVwieAxQfRCzhznNZyTs9OmhuhNaGkW7sd7+y4HaYnd7FLRLodyHXnsHRQ2U6hn8Lht0Qo03ttWRYelbgvDMUw1h+AuyR8MF2CsEz935eRU03gvrCHdE4IDPYG2OSp2m3Kf/dcgCgjsyDAXTfRLCV4LKNGffuSpUuHUzk4mVYFmnSQYuru2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HF7E9GxunQXOglzBZSufPGugXvqVoqtvZTiLe5T9cOM=;
 b=BBIga4FKxD7XCQd4Iz8Rlnzz4XJIcFKe+IhYALF6dRHtsPZSsHasvGBnzdb6fIiM3uTjWeMu/tvDj9F5d0iugcin35frzTR5EdY7SO9etKcsbe0LfjEXb4v7YHcJGp11TiAVMxdDdv2NNBNOddvAfYrcfARSHWqifGQR9RjXEC8uFutKrn9oZKR4EJDex9uArNniuS6Qs4AI9YfCKIKsxmWETOY9p7JvyNMSYcqIG40+l6L9rq8ijtVWMVi9zQ356LTviBnAFM5HoB55pQR0ZSIPCyWH4x+tiZewoNj9z33iHa6vkap6Wdvb85+uytJMGnsL5BmaKTyfm3iyTfk5Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HF7E9GxunQXOglzBZSufPGugXvqVoqtvZTiLe5T9cOM=;
 b=CrpY7Tkx+yNmDo2FQeXYKAreZdPyS4Wdg8oDIqPZt+g1UCWHJBAkx7IN7jswnMno4qUTYdkuhZMWud+ispHnNQafrWeLoShGuyk7Pp2gX/RIrEyqJZBwV3gEaS7XiikVIEQatpZh065cTf+lcnZziZ4VXpyy4wDZa3DH/lRrqhJz1soUgo32Rc5XGQqKYansvJ1783iQrXKVQL0pWO0OEkB72oYsYgsNLsbm7XwPCDjXNZeUW5g0omHTZtu9GO67bMB9RjpYDBQlFHUluOXqxeiDB6e2VRv/2n9C44/F786Glx6vUXJF7a+L7ZEptHb5LkA0euemxRoJtDp2Lbedyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB6679.namprd12.prod.outlook.com (2603:10b6:806:252::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.19; Fri, 25 Oct
 2024 14:00:49 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8093.018; Fri, 25 Oct 2024
 14:00:49 +0000
Date: Fri, 25 Oct 2024 11:00:48 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>,
	Hanjun Guo <guohanjun@huawei.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	"Moore, Robert" <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 9/9] iommu/arm-smmu-v3: Use S2FWB for NESTED domains
Message-ID: <20241025140048.GG6956@nvidia.com>
References: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <9-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <BN9PR11MB5276A5BCD028849E1658416D8C4E2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276A5BCD028849E1658416D8C4E2@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BN9PR03CA0041.namprd03.prod.outlook.com
 (2603:10b6:408:fb::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB6679:EE_
X-MS-Office365-Filtering-Correlation-Id: d0d09501-5672-421a-baeb-08dcf4fd6e13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f30H2238AQ3zvKQA5Q6O2TEq7lVa+ts+eDYaKJmitLimCHAcG+Bf8/ktKrqJ?=
 =?us-ascii?Q?y+bCb0uQpNAnVjB5ZzEEx8nXG5a/FIWs/VOPSromXN1U5yDGtbId+QHpza96?=
 =?us-ascii?Q?bRtUd62dYQCX42MJZB9m57GUXTa+NVaE/VKjN2+gJ8+d0MFPnYuOy7kboN8M?=
 =?us-ascii?Q?IE2JOo29ERkKnQQNngp9PXx2Q5jdEy4SEqKxWnHrWTYkhkT7sQq1jjGesV+r?=
 =?us-ascii?Q?E+HeRyBBZqPxjI5c6oHWIsi1CtMZjoAStzu+xwkjKBh5/DXxwTi2vXYU1jVw?=
 =?us-ascii?Q?d9GY8osExfT9PKbWwjvl7RVeyp/Cq4J4ArAllQOYBOWw3PS3CN/xFxvNyvhy?=
 =?us-ascii?Q?+a8h2qXgwi1DH5KZiAdJR2tKHHF7VsuYyiCW0Z0K/R1otjECPZtBt3lPxFp6?=
 =?us-ascii?Q?OpcLcTcpjib6sOersJhJH91DiTBd6wQ0Cx7+42fPfkfGBaP+i7SnsDmCyjcu?=
 =?us-ascii?Q?EK7xyJ9wXyY82zw0zmLbIlXYY7oBYFa8FYPau7l4fWDiYgJ8EkGQi10GSyFn?=
 =?us-ascii?Q?Ij9wdnedr0fBIKgeaMNTTZBptTLU/i906JC2Ou/pdJ2F84z/iJNhRf4CVTrm?=
 =?us-ascii?Q?WpIQAW3fPILzFUtbE6LsNOY1fjG3dkNyJjSD3Ac9DP3shkpp6neUVb0p4zJN?=
 =?us-ascii?Q?iTQJoCJhxVCsR33A10E/HEtd63PAU3LTSYbkZA1q1oKheNo4rJSGbc9utbrN?=
 =?us-ascii?Q?I2+nmyqdnlxDNf3DDnbbqvYKHHtR1ZrAjuyGqsL+v2WORSmbPvzAuQy20cy6?=
 =?us-ascii?Q?Pgf99dSOos1aIJwSLto9ks8WpsJ3n+C8JQ5tAqC02Y/a7/dInDcrIeyVISyn?=
 =?us-ascii?Q?Zf5T8wrts/KxoYuyxZ9Dcp4Sv/qy+jvWSEyMSzgQIi+UW0qGJbpFASIpHgJe?=
 =?us-ascii?Q?oMfwb/+hdFWRASx7wsyO/NUeMxtImaubNDDDSRlA7JDYiZTeFoByitmlyd0u?=
 =?us-ascii?Q?aHwqOxBpis76v2+OstTxrEkcErNzkW/mznbkjVA3xlMk4o6VCkhASIXCcffe?=
 =?us-ascii?Q?jwHrdijpLHkYPQp05tvRfXZRjC6TeZAonG3ED5flsI8yMRoFAwXwNrJRgJYL?=
 =?us-ascii?Q?S6krMgULPlqM9a4GhI//fH4EIjH6Oz927bKR7pZ25Xe8fuUqFjqjSBjEMpEC?=
 =?us-ascii?Q?BJRskHa5adUC02Tj7fo5ZpWOoT2KTYl/sCPgpxmlSLDHAH4SbgDqyPLs2kOq?=
 =?us-ascii?Q?1/yvfOHVNpmJy5KeKP8N87V9k2f4CVMKxDD5mBxUfF5tcFpQ9K5aWxBfhqCL?=
 =?us-ascii?Q?n4b98BYRpAjd9fgBjwmGLKi4hi7Y5BitBVLL/moCUhA/HUJDEpxVr7OdL6Il?=
 =?us-ascii?Q?PskGYOB6k9KxJAjYbZRVWLvG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6rytUPg5snRmQMKTA9zzCnLTknBvHNYLRDv6WY8qRG7GIy9xMENR2gk24BWp?=
 =?us-ascii?Q?fGYFMSJuVD/1MYJi4unwQKHAqNeZ79JRytKfwDtPtVelLZBGMsmRC0vh8FAC?=
 =?us-ascii?Q?uOsE5OYnFlQbPSAifg9ht/M1ShTCUkgFZRoSQoBctyQgLepEzhUBQ6d01dQ/?=
 =?us-ascii?Q?jD+90M7N4w9aJ6yGR3TEJi3hmrxxtZOsyv9R1C+cldiUkwiyn3wbEYTnHtEQ?=
 =?us-ascii?Q?OItSfn2tJlrE5GKF1IxyvvY4U6WMP3F+xXNOyE5aUd0iKFlet5yIfqGaR2qR?=
 =?us-ascii?Q?74smatIlfpNoBm7QQ6lI7ftMA7CERVpX7rOPDGIWYuAeBzDKaKVYAUGKCjtA?=
 =?us-ascii?Q?HcwCyv2ZGIMoQbrITVyjgtgGMAT50+5t281oVGBeWaCDv5smU2Mi45S2bIJS?=
 =?us-ascii?Q?uVXslGJpf20wVGkUckGiMg+JD30cZs88DC/jkyNcxXxLsoKMZFcAdmBPdjqP?=
 =?us-ascii?Q?uIEGgFJpp938aeReR5lnW6fp+xp8TP0g62tWx9/v47s+aRM6R1tcrBBkXb7Z?=
 =?us-ascii?Q?HtLU6egr3UkP91/pYr+FyjYpVFQDr8yMdkRFq16LA2qZpIQUEJ8s7eDgBeSz?=
 =?us-ascii?Q?qATpAFzv7d1DNKGD9alnogehcl9odjI8r7LFYzvCDEKbB2XnSagk+eh3n1RH?=
 =?us-ascii?Q?mgladKpW5umJIc7wYVBJluzeVGonZoSABbOoDKKs0R+cNtrgXaz2gtrM+KiX?=
 =?us-ascii?Q?lBbpJIAlBE5K4fIUpgVO9nQfKnY/VwTSFrd8va6E1NHY7Rpo3sNmmVQDCpWU?=
 =?us-ascii?Q?i8elVBzo6Sic4zSvc6HJio9WEPTfFky6jmyGrKWkHYzaB1WYHGKiOmz5Jex9?=
 =?us-ascii?Q?tXihO0lwG74ynK4zMBlU4FTMcWOw8ZUJWiDybyHf05WUUpxlxXRFIxdvKKa6?=
 =?us-ascii?Q?9dGIBDDCXyTRup2yJvBlSLFKV2Dlz1fcKM0uqj2El1Yyn2yAkwC/svQv39Iv?=
 =?us-ascii?Q?QXzqnH286xpuEzAFLTCZOqQQFZ8jZ8vz5fgpTzdsI5aUu+1QO5Aj81vOr+Cc?=
 =?us-ascii?Q?F9vBR2T34D4q22vaeTrYFi0GJWyUdltn6czzi2bUjUEbekDyIRKzUvg7ODUm?=
 =?us-ascii?Q?89Rf6M6AMwXDX0t8wsCqBKijJpv4rEq+qByoxNoShsG6HvNw1Ms35PQ5wLM+?=
 =?us-ascii?Q?u6Vh7cUvCkUkdFSRM6Q0FA8oB9LtSFZgn3I0prXhzehShvVViPSZm17OZH3a?=
 =?us-ascii?Q?DmEaWSXBqNfHF5G1csUauU95eHiVzsz/Pvqbnu7gI5Oq4j7/y4kXk4zo2RvM?=
 =?us-ascii?Q?XDvO8OYaVFxAzSOt+0Gl8IJsXBWIZqZZe8qbIRWOiVCo10w7AJdNRsFrFMOk?=
 =?us-ascii?Q?epT2ExoVUQe74mjYhOJPrdwH3FGxcng3G89wKPzouCGXCwyHirXNJXoYxJ9L?=
 =?us-ascii?Q?rxbeeYpei2O1uvjeRgCJDqB8Xi3vnUxdHhY/UHEV1EGsl2JJ1aVmWItcJMA/?=
 =?us-ascii?Q?g4L97WR6DnxW2fWCw5piAh4MdRmnG74/4kBOe7H6L8BAe/8dBCt0JXVnpgQz?=
 =?us-ascii?Q?J0TgMYSqTI2xnWQ/+BkK70QN9lJtJyKuSu/MVwgX9lI4IX2/p9GR73etnnpa?=
 =?us-ascii?Q?1elt6QOqIEOKzNEC77xsXc/cpbmPSHk9OExDcprl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d09501-5672-421a-baeb-08dcf4fd6e13
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2024 14:00:49.2778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4xeKJmuR5HHRC9KB/K2QFbdn8b3gIcVyAzJ65da8mh9yyKZGz2pK2ku+mGUgv4Va
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6679

On Thu, Oct 24, 2024 at 07:54:10AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, October 10, 2024 12:23 AM
> > 
> > Force Write Back (FWB) changes how the S2 IOPTE's MemAttr field
> > works. When S2FWB is supported and enabled the IOPTE will force cachable
> > access to IOMMU_CACHE memory when nesting with a S1 and deny cachable
> > access otherwise.
> 
> didn't get the last part "deny cacheable access otherwise"

 Force Write Back (FWB) changes how the S2 IOPTE's MemAttr field
 works. When S2FWB is supported and enabled the IOPTE will force cachable
 access to IOMMU_CACHE memory when nesting with a S1 and deny cachable
 access when !IOMMU_CACHE.

?

> > @@ -169,7 +169,8 @@ arm_smmu_domain_alloc_nesting(struct device *dev,
> > u32 flags,
> >  	 * Must support some way to prevent the VM from bypassing the
> > cache
> >  	 * because VFIO currently does not do any cache maintenance.
> >  	 */
> > -	if (!arm_smmu_master_canwbs(master))
> > +	if (!arm_smmu_master_canwbs(master) &&
> > +	    !(master->smmu->features & ARM_SMMU_FEAT_S2FWB))
> >  		return ERR_PTR(-EOPNOTSUPP);
> 
> Probably can clarify the difference between CANWBS and S2FWB here
> by copying some words from the previous commit message. especially
> about the part of PCI nosnoop.

	/*
	 * Must support some way to prevent the VM from bypassing the cache
	 * because VFIO currently does not do any cache maintenance. canwbs
	 * indicates the device is fully coherent and no cache maintenance is
	 * ever required, even for PCI No-Snoop. S2FWB means the S1 can't make
	 * things non-coherent using the memattr, but No-Snoop behavior is not
	 * effected.
	 */
	if (!arm_smmu_master_canwbs(master) &&
	    !(master->smmu->features & ARM_SMMU_FEAT_S2FWB))
		return ERR_PTR(-EOPNOTSUPP);

?

Thanks,
Jason

