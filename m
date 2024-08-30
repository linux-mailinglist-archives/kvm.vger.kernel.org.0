Return-Path: <kvm+bounces-25527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D46C96637D
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 15:56:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9449283FE2
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 503521B1D41;
	Fri, 30 Aug 2024 13:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SOWXnIlp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099BE190472;
	Fri, 30 Aug 2024 13:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725026160; cv=fail; b=W+b9hR8wDhR9PT8o4CHHtNIbHycfXCoSDlVyYx2R/7qWL3wRfuV2Bx+5PbTLrAPt7sGL2MoIYu6vDjqqGZRBDUQeIFePI7DjnZHiNckY/ukZCTi0cHtbvdShMyIXA3JuiIIwTu4ycAZ+TQ9FKJHyybrIZbPBOOv+iiV8KPyAwys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725026160; c=relaxed/simple;
	bh=loSCPfrTqaN6ihS7yEbORfib+WrnkINEYWf/gaToF8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CT5XWK6/bp9BGXMEDerqAjlItr0yR2G94GuTas5itk1I7lO1ENM3F6Cr+lwz4l9hBVPZGikDGHC1G6Iv5j1EYgrcwqOuGaB1mcd1096DUzlKbrf0oueHWmuH/HjgOIH7h549/qu4Lb/jPtOKW6Q2d0AqAaE6qjbw9D/u1ulEvRo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SOWXnIlp; arc=fail smtp.client-ip=40.107.243.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t2HSQLXMXAa/MqYWZF3nhGzigysJTQepNN2OpHFFQIayBBHf/49iyy0BOxix+qURxgpueVY/TOOmgCQZXpivms5wenJapKiVAO2Sd9t1T8rx4ku5gVjrlPavkZigfMuBWC5solAEBfF8061gRkAHgMdUqm/ljQXl5iLuKTUsZp28Z2oqFK4/HcO1/ZYwaiIss91lFTDGQROHNhzY/PZjsvkb1MvHT2eVIaA0Zug3XkSf4j5TRTgsENZPnKaKws4qpWBPo5NDxg1F6fRwQjrlHRQdRWPrLRTSfJDNsVJ+V9DGhnknXuLReWyRUWMQp7FeRPngADA29nDLsyfGcT+cdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=scPke+ollVigay78YNjb6uNxcjKxOtSrtZcz1D4D72k=;
 b=mcYEa299Bi5r+bsnbfYFXYbEVGTFW0//IvHTrbgkMWARN/zjgMkhyCpB8qDzUlbfdztwkjE2ImhM+qFKm7EQgvSbZQvXEl4/kw+kYzn1F4XpsSZQjrwMlzTUNfvmbddVTrGlcvs7PPerKMSOAQaLYPRG/S2i8oLavLvL1RKPcGAthaS5uE0Wa39PvWTbkhvJ1v6peJTPD1uaPkLzZiq/GtcIOfVeSGtdrcEtM13+B+hfiIi6tY2mrhbahb8u+MtOULfi9e6GxaxJJTRQduflxFFozfx6hLuOMHwU2Fvdg+rrBW6v7TuHckxglDrkRiLkapAi0vrTHV0u+eGIdcNJvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=scPke+ollVigay78YNjb6uNxcjKxOtSrtZcz1D4D72k=;
 b=SOWXnIlpHm3HivVl+aVkE9wQWm2/DuWDqJbBay82XUDOCTNDW648bweJ+9LkNlIvaKElGzPF1eC3A7I0iS1skSwIBWI7UJA1hiDdG6UknY7eD0gV+pyivHPNddYWhG3cfL3RZ1JmyhJ8t3/brtkh8b+59MlgTpBH4jthH0UyHEUX61qzRv9lTE+oeg3sg+nIDkW7W5uW21PqTU3RV58i1Gk/VqPS2n9LPnxqTDAysLOhKkm9Lpq7Q7PxLw4U1dYCvUjKbpkVd8Qoc83+UlF29LGK++hAIztkhB/dHR/e1Gz5iEI8NOnPwVr51ub7GsgzFpnGYWykLaDxNtyLrkz9hg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DS0PR12MB6487.namprd12.prod.outlook.com (2603:10b6:8:c4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 13:55:56 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 13:55:56 +0000
Date: Fri, 30 Aug 2024 10:55:55 -0300
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
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 7/8] iommu/arm-smmu-v3: Implement
 IOMMU_HWPT_ALLOC_NEST_PARENT
Message-ID: <20240830135555.GQ3773488@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <7-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <BN9PR11MB5276FA0C2A0F8734C2F506BB8C972@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276FA0C2A0F8734C2F506BB8C972@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::7) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS0PR12MB6487:EE_
X-MS-Office365-Filtering-Correlation-Id: cb738c53-3616-4490-1b66-08dcc8fb7830
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OZITJnyWvs+MiSAutEq2v5GcVfa2fsJwGPlJAVFKD4QaO+INRbAC5J18f/6f?=
 =?us-ascii?Q?RUax7yjw4tUkpq3tMkhSjphdxPxfZ7CecPGnxRICmkMgRFOAln3FI7yX+PBE?=
 =?us-ascii?Q?hpdqTFtPvSx2dfLQKW17GPglTE2XsvrJoXLXurzi7GfXC2CB/QPlgq7wE2k6?=
 =?us-ascii?Q?H2vcTQ54qILiElH0EuZaxmrdhgNIGNsTJOOkkYoTrAz9CRx2JUf/qNV9g/j+?=
 =?us-ascii?Q?r3+JS2Qs1pz6EuOuB6lQxSPlOi3wJwyFBFaCkEkivj5O57q+EqAQUBkbTV1h?=
 =?us-ascii?Q?5d5ZCMxXhL2LAIDy6MUNbUHtidmCCvIaj6Cyez0LMSeibs5PjulYMjSiEeV7?=
 =?us-ascii?Q?8ZnOFivRLKQy8B4aOgS7oO1WMYQYbla71plMI8rYZtNeYwrHU/aAUUU9X5BZ?=
 =?us-ascii?Q?W9sU4pustOW/4vcUYLTbkTuEkgVFDZbFKiqQh9z6qKosFJkYky5hPi0Nn5Rc?=
 =?us-ascii?Q?pY6xtt2CK8GRlvxA3/z2zKyN06nelr9yCw33sBRsf+y+jAOc3t+jsJirGonK?=
 =?us-ascii?Q?meINW0ILzLrFoiszeWJ65JvYQSRxGabajEeWM0SDRy2FT8e28UT7Xx5xFRvH?=
 =?us-ascii?Q?Tvp9t1R18urWjhPkYYtKbStXnpi7zSqw6kEKwMDwss774ivxX3l6pB4/NAv7?=
 =?us-ascii?Q?UT7kp9bvV04YzbTgf94QUGNPnLDulgWPzCiQ00+n97wLOWjVH8lrl9Xt+JvK?=
 =?us-ascii?Q?FIsITgdDdrsh8rcltLoRdVVk+vSxfmBBR+wnCEbyZkQlxSp0Apwl+zzPvXAM?=
 =?us-ascii?Q?QL3JAOqW7QUHexNmerF5PsT1k8NytK1n7CUZLAFndemG1vkwVn8YMxm83rpQ?=
 =?us-ascii?Q?OMrzF+tCCqOzoCFk/AEYE2U0vJTCF59zze1UEryFpzRGy7ReLXImY/d9ECIE?=
 =?us-ascii?Q?+idClao3ys7sULGAjXtjla1M7vvpbimDzTCrw1ybTgmYc2ufpBlGcKJ09hoU?=
 =?us-ascii?Q?lMFqMH9pOzWM8QK6sV7lCKK/4/+WzGd6+QG4wBLuwOFXacNcaqqHxthorRff?=
 =?us-ascii?Q?YBERD+SLAeb3U9mBSusfXaUDAc8w9yKZASuQ8kdBCyCkqMxNgVrYHpm6EcQb?=
 =?us-ascii?Q?b4lc2LgnCSG2bzkkU2GzM0gY1mOL86DcRn7njI5AuwmcLqL0/TyTgIiihqL1?=
 =?us-ascii?Q?45OXPgTAWzszUpKFulhCyQpOKgpyfgpxaSvwDNdilQH/FVLeALgUBLK9++Ii?=
 =?us-ascii?Q?Sl9KjbYJpksAlQJqIp6WwSgJoCIgRizd3qnsMtRxY7GPGWv509HmZgY69H80?=
 =?us-ascii?Q?gyiSsnRxOX9hcVj6708oZLjG9S9cKmQN9zwu6+x6TwzhD2ciRGd21UGFnD39?=
 =?us-ascii?Q?zLwBateJQurgnnyroIpoiChcWNDH4eL0yvP2b8JuJC8gRw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZVMFXWBkxkYrViRBh8AhXoE6/knYlXo3L08oM/k9c5LxU23qLNHHi4oaOXdm?=
 =?us-ascii?Q?+mUlnwEzfAP3gTdaJ4XkXZqhm0B3tuxbsrbAiQ4xGrJSPUqqjujiE1yZ8Z6V?=
 =?us-ascii?Q?835jEYWhyj+MKjl1rYlGRDGV69ey7cqQi/H1D6LiodS9faUZNa8UUDm98LI1?=
 =?us-ascii?Q?VS5mJ5ZL4306yPOqa2nlU/Dxx7Ue7La28XpItPC/qFFSQrJu64fcAKQUXWL0?=
 =?us-ascii?Q?fEpfzp4n4yzIZzmMavatYxMcqLoI/zf/4IwhwMWvCf0YasYKDdhl+dZnRwzn?=
 =?us-ascii?Q?XX5Fm8jk+yNSAqCFsVsp5tH79utQoqPO7w3RddhnQ+EGD2dmlUuQSKZXC0kH?=
 =?us-ascii?Q?CTeO5V19nwnyULkweiBc6VefKaVduWUpaGFPbQ/68udXIBExlzc8GETISz/C?=
 =?us-ascii?Q?IgDy6uZ5ZxO1bC4jRbJVzd5ssPR/SUpo6hy8kOpRHJ7gxRX00cWi64nafq//?=
 =?us-ascii?Q?vIWOog3c1u34WqWHBq8wCOvg1FeVyF3vGOjVZLPbEYrf7qhqRHAJtHUkkP8O?=
 =?us-ascii?Q?Nw1PYRlbT468gltakrek56ydhnDr+efwo1pu29SNcLOPv+tzVS2c3xn3jCpO?=
 =?us-ascii?Q?452nsj4Pq9I+OQcKUyB8vMQnvUQ35dMdPmL7taBwNQEmoIvtniKlR7Rj4dLk?=
 =?us-ascii?Q?7X80jjvspkHbLiMk3zVt49dhDe71SRhK+GvE7MILcVGmwuoGmq3vQgh0St88?=
 =?us-ascii?Q?cFHsl9HvyLWWWtoutXZ/Ijbpi526VdJ68dPBvRXslBChnFGFNa1RVAiugqsv?=
 =?us-ascii?Q?fQhMYcdou+Z0sw/qP2LQOAei2p4kFzXFe/wg5KNKHVUvt9gYGrFVPqCEdgzl?=
 =?us-ascii?Q?AuhA2fLFXV3YNnL05z2ih3XwQXHW4ZHAI/DShgNLLkLDqP86c9z1dXZZ6VqZ?=
 =?us-ascii?Q?Zv8OHmd46Nlhh4PhJw/At+MEGoKl5wq36X3P3R4h9RMT4o5CZZD5tmxx2aQ8?=
 =?us-ascii?Q?p1vs1HFb6EBfaHCknnjPznk8ICHaCCoc+UdjIwqUtO3gdrg7+Dc56zLBjvZy?=
 =?us-ascii?Q?zY9PtYn0IkxNsSJ0j0OWrkNzkLYpPbcIjRI4XdN+N3+31o6oEPIkXqkhVNn9?=
 =?us-ascii?Q?mLCdDxhHVp99y04Perf6DT/W0H88OJiMtBQMGxtcQa5IDJthDVFir9aT885G?=
 =?us-ascii?Q?VoiePI0zJb1pwmxP739TbXQBA567QFuwBZLxNyp4ddho4MvPKzi1smeWMaYZ?=
 =?us-ascii?Q?FyPpuuZlwl2DDYxUsRnETii4R9ELOiwNfLSkRiHn6IXuZ7tGO9Q6BtX7s7OH?=
 =?us-ascii?Q?CnvDWzPkFUkx4nmKwnouQZZbaPeXqJZNvNQl6MEehEiMSPQVxmY8BNthvpYE?=
 =?us-ascii?Q?W6qXrfwi4q+0szb2xcoVv30epNbnFwstiGlGFyktwEiqdufcxVOqxpAwH1ku?=
 =?us-ascii?Q?nbzlHWZHHx23XeBdrtbDiLjRYGj7sKhrkcnbpXqwX0bA8I33O1IyFkEdYpnw?=
 =?us-ascii?Q?t5o11ZWxMOzOeinykudF4SP5InzaoABWyoM2KbAs6K+pjqoFa5vg2QLuZ1Wd?=
 =?us-ascii?Q?N/S3wGJABsEGJMkNV6fCmhHxaPEdg4fDh1eEol9MO1s9Zg9UHuOMAtgXECM+?=
 =?us-ascii?Q?2S5z1w41HevD1vMEST7M3ibHwww0ubTkf0nPZMJ3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb738c53-3616-4490-1b66-08dcc8fb7830
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 13:55:56.0110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ttKm9EWcXiVSCjWcXFwCp25m8ZsqINGs5EMUTYDY9+botwv6SIc6tGvlPsd2YEXH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6487

On Fri, Aug 30, 2024 at 07:58:09AM +0000, Tian, Kevin wrote:
> > @@ -3103,7 +3103,8 @@ arm_smmu_domain_alloc_user(struct device *dev,
> > u32 flags,
> >  			   const struct iommu_user_data *user_data)
> >  {
> >  	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> > -	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
> > +	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
> > +				 IOMMU_HWPT_ALLOC_NEST_PARENT;
> 
> lowercase for variable name.

Ah, but it is constant :) I have no idea if there is a style consensus
here

Thanks,
Jason

