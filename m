Return-Path: <kvm+bounces-33729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 495219F0C93
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 13:40:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0988928939D
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 12:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B884D1DFD9E;
	Fri, 13 Dec 2024 12:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ibZyk1Zf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB701DFD83
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 12:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734093644; cv=fail; b=Wx1JhkMYlehqiFQFaLozgoZ5Ale03NKhAWZ76A2x0llje355ybMpfWDg1uwDKsAEhOkfT2O0rIixzq/ElrVZJS8+m45emXpN4ZRPlSbLdRjbwMyv/ZLOhi582/bhclACVw3XvVqGKKK4LrtGcQhqJ0Cy4z3+Un7DIMwCRhFDr7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734093644; c=relaxed/simple;
	bh=OHJdlcT0EvlRuyc0xUoT4k1LK3y2XN2vdDHI5vAB85o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=W3r/+11AleQ1kcZaZ76Tdf2c5Qe3lBMCcC97+Pr3ht1UAwtGRZUcN21g7dqh1xezUfBzRm4IXn8pwqtZQl8nIEulfundWt1TBOrKF1PUBMlFh0M5oTqZpvsDGJseTMt1S7jqMs7VHcHrguJW41nV48rKGlTNfdI0KRSZN4EDzU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ibZyk1Zf; arc=fail smtp.client-ip=40.107.243.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FZFrAwwBbjKRsSNOTU1QyBA9wVg10p8STxrFMfoRIJ3aKrjSPWy5l6+o3KWhG1fJN4ZyxvTksTZ53+B5Y/SjDLi2nzS84llKwFIDbEqThS+23a55ock/UcjKvdVDS6fWcBWHWiL0J4uoB3OT2IcfJLO+36YYuYLXGkvBLqgo+xhQa3xvkmLMh5i/94tslR05Xmybrxnb4H8OeGH75NlLYcyG5i/Ea8jVM+Qfxf/luuvvnaL3pz0EFKScV223idIWnGsiEmlSEJAfCT8gqmnUpXTMIcx6ID0Nbq/emMJaTWS8nzKiD0W+3GrtFLiwdt4EyRmuCW1Hx5aBPXppcsnpQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXXKJeaTIGoY5cX4hc7VimPvJ531z1k7V2oI1mZZ/l0=;
 b=J6u1vvbvyhf25winPF4D8k6IrQzfSmHjJD2KpHNosDbITKDNB+gumGLAct3opoQRQa8ew9vAwJOLwXVzcSAN6cMRtUHWsn8X740zer0RfvNZz1TlKOT0ur/XV/I91oev2sMV1KU0MCEUM3BvROe/GMf1Yyiftu5YyBr6eB+lGpPZM4FJFZryczZ6HJcQ0V1biRIMYGeLgnDsEXi9LLGE8zHTVkqXN88g5qq9eI6ANn76eRFI6zukbAnBjbIBXmilLU7g622Nn0ojL3ATIEiTFPFtoXmClOLaAACrWa10Fl1dK9T4CUvEUUusPgRe9tFnQu/fQmVDt/bpzOIX4kw4NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXXKJeaTIGoY5cX4hc7VimPvJ531z1k7V2oI1mZZ/l0=;
 b=ibZyk1ZfY2M6qHZQlRjUWk7s7SUBROP1XlHS7Vaqaes50QILD/QQXZ2Em/l6lD0WQcXNEV83POUzhMr8YsMY2M/xri8HGdMBugCUI29/cXf6i7Et6Mr0SWN+mODzNE4R2/r/d8dgYwvFODlVIdxmsfne43ARTWioUAptvkfFUzyPgq6v8EtI6La2UMqfREF5IVZg/ngCF+nkgg486X7+ZoRho9kuMQd7W9Jyma+g0alInVJGWu0Q757RhiYOigRLANKO0ir7ZpDhCdvYdbZL91vSvjy8VX1oaaUlE+IXZD8L5/IcoWvrywj6kp/wgyNQGtvw5wOp8tms4bGeDt4jGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ2PR12MB8135.namprd12.prod.outlook.com (2603:10b6:a03:4f3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.16; Fri, 13 Dec
 2024 12:40:37 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8251.008; Fri, 13 Dec 2024
 12:40:37 +0000
Date: Fri, 13 Dec 2024 08:40:35 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"vasant.hegde@amd.com" <vasant.hegde@amd.com>
Subject: Re: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
Message-ID: <Z1wrQ+kgV53BsodW@nvidia.com>
References: <0f93cdeb-2317-4a8f-be22-d90811cb243b@intel.com>
 <20241209145718.GC2347147@nvidia.com>
 <9a3b3ae5-10d2-4ad6-9e3b-403e526a7f17@intel.com>
 <BN9PR11MB5276563840B2D015C0F1104B8C3E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <a9e7c4cd-b93f-4bc9-8389-8e5e8f3ba8af@intel.com>
 <BN9PR11MB52762E5F7077BF8107BDE07C8C3F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <98229361-52a8-43ef-a803-90a3c7b945a7@intel.com>
 <BN9PR11MB5276E01F29F76F38BE4909828C382@BN9PR11MB5276.namprd11.prod.outlook.com>
 <c91ea47c-ca71-4b37-b66c-821c92e3d191@intel.com>
 <BN9PR11MB5276655399B4523F4CEEA63D8C382@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276655399B4523F4CEEA63D8C382@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: YQBPR01CA0084.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:3::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB8135:EE_
X-MS-Office365-Filtering-Correlation-Id: 17255f93-346a-42dd-fdf1-08dd1b735836
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Meg92JzsGTR9wb9akSCsOJ/1QEAlRyKCqLRossG+CHjnw4rnLvnK2Ta3CIpT?=
 =?us-ascii?Q?Ixfe7vpRqycQFW2SNDR65iKfAMPx+FDxmnTo44Ca1sIJXesuqCNjIRnKOYFw?=
 =?us-ascii?Q?qp6gK9ebZ2lSvv8IDoAe49xzk4/nCzGheivMMwUB4HqL5g8DOT5k+KRPMG0Y?=
 =?us-ascii?Q?NqJPzk8Xw5y+awLHY1plwObCm/bmIBr+cRP2dDJut7wX26Q394fEmd4m+8JO?=
 =?us-ascii?Q?AAbkDn4xYJbjn3Y6NC0UuD37fLqYjRe7L/s3gSqi97PXDt4aGiNUNB//szhD?=
 =?us-ascii?Q?6YCwaLgpOzBix+ibI+07jOYIx7HmW1X5UYLSGHz4nJZ/GvjEm8ygfeck+X6W?=
 =?us-ascii?Q?XshEPNLoJuKsIwL7E7nHUyXSIb7NbqT4n56OTe67L+X4wCv6MxMEwGniRCvW?=
 =?us-ascii?Q?K+223wS/r8rXAOLsGJkI4rDWZHowdk6zmU7XQ18J3u3e6H6YYOjZshujepNl?=
 =?us-ascii?Q?PFocmOMtGSOpwGKkELCVz/srKW9NOuUreFvCzEPp+QXtTAfmO53mPfXUmIUD?=
 =?us-ascii?Q?+C98yDgf/hPNXtjXuSC/ir8BrekEPkXkToC4cd71fcWS1AOEt6oylnzoU+3b?=
 =?us-ascii?Q?u+kdqNrmQWEUuEXIISM2B/IKZURSY8KO+lBk/dpcLlwZ2ckV+5lDzaQ6PyqE?=
 =?us-ascii?Q?r1rmE4QnaBgzTBMiL2trpXX9mswMZJ+MG2jxxzCRn2i6AwEGQlvqZ6Y4X8mo?=
 =?us-ascii?Q?Ko7sYk9TUiPEEXCEW6PwtT4BxJDpkVa56HWP/ESGPyjlFoCaV9/bABFabBem?=
 =?us-ascii?Q?pdVCIieunh7yQzIpJQ+rhnRVEUOg+0G86Rxew4hFKG63vZ30xzzlQplZMENM?=
 =?us-ascii?Q?rhCKQCZpCPvOFYR2GT9I/C8sYTtAtZvHNFGCD5KVj3/40TEfdMbSM6+FcUp9?=
 =?us-ascii?Q?0sKGF5OvJHxFsb0oqbj9y0bPTNSecwqGC/EjKGvHFm1Sq/9gPM8vStex7XAt?=
 =?us-ascii?Q?MyY7awqTjJpBhElrOOo4gL2Ydli4f8JNx1UiMjtPmLstwb9yOwDAiUfSft2l?=
 =?us-ascii?Q?b67TbisDjZNIrljrffl2vAF2pjCGFT4EhokS91VkXD2I4wS9GkdEWhE64pYB?=
 =?us-ascii?Q?Yjwwe8uJsukuNIocCUptiLgAukB+SVcWFRcq0XnGIMxxqxLG4WNDF0iJMI5v?=
 =?us-ascii?Q?7PwH60YLzJ/OJ0ygGfT6u7CTz5uA7cdDaIps4I29YzIa7/jc/K3PYV8PdraC?=
 =?us-ascii?Q?op/KqgrD9/LmF7ItqNRTsNODfLLIhDbnNjajjqfls2f/cTkTigUmNJDuZ2x5?=
 =?us-ascii?Q?AnTjkHNiyUujbpkP/XEeQ4sRrFejDmffZVowDemhAGR0T4U4qUxYisBpO5KL?=
 =?us-ascii?Q?4JRvsM6PhrjvDS15aavPh/vQ9TYT6kGkMX9JxXNPUBq2Nw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+D3bTYk+vaVT8Ssslrr+2LQhcjRrWDf2jXh1Mypr6kgHYbETdle17joD6TBo?=
 =?us-ascii?Q?D3DWR2390e51TUhHislvwxnxRffUU3peK7t4wXOMbPQzOsOOhts5woWjxHa3?=
 =?us-ascii?Q?LtkcxueYDPhAskggbANyopkTSucjULuM0Zt9h5QMe9rGYBa2sULA7RpNgfMR?=
 =?us-ascii?Q?07XHW9wS5aWpDhsWOpOCjtaAC93lcyHjsTnidVrXbD/+oGt04pzdtU9OuakM?=
 =?us-ascii?Q?YR4ZNZRF/LDWNvEo5ZoPN4zVnm/tAs+4dmlGuMWzIT2Rzkfn582C2SDe5PeT?=
 =?us-ascii?Q?05TAoU9nt7QoE5cVm6a3WODZlwDmyR4ymCcporW3CXR3lVVPclFHOdqw5uDg?=
 =?us-ascii?Q?WrNdr8GBQgHUhXOb/yOYStv86y6qicU4mpFM5+Pbm9KDTLEUK54/vFynuEL0?=
 =?us-ascii?Q?/YnVGEHVg6otIGIqLOvMRrPj2YVMzVFz8ZtmfXdu2TZXt/paPdHomy4NQcgX?=
 =?us-ascii?Q?eSvmhInmSFaAlz7tscv3atNYZBS+BtREoAm4zCq6Aul4wtWwljpMryNnTABx?=
 =?us-ascii?Q?S8o1nuFr6X4tQxYai4RbLw8eKBOx4hCUVtIWw5S9ul0b1ULaVMrNAx0ZoQo1?=
 =?us-ascii?Q?yERxWtWRYStANBa1gIP1bhkhvB26yRSKsaGUhb0EC1vWdF+5gPRX8g4p66YJ?=
 =?us-ascii?Q?yEjNqxymBbQQhZeFTiLhePDy34DYoMb6SzUiuTGiARJ1NFQLIa4vKtNet96W?=
 =?us-ascii?Q?EmaXQ0pCFQybtMOfJBJh7WWJS7JjT+h6Irr95DWDEEehuti44N9z/oeASSGF?=
 =?us-ascii?Q?gu0eAmPb1NWCyz3XKsuqmjyjc/X8mpeI+bCKYGyZrWLAKHI6UVXe6YYiiuf8?=
 =?us-ascii?Q?lbRCd8raHDut26SjYbdvVSz6TpQD6rw1hmVN6luv7f/+96s9RvJlSSRQfY2P?=
 =?us-ascii?Q?2gpGiXGd4NSyN8CO/8eyCRTfLPO+NDR5CKM+SyQrFFeXxoY/HCjEwngLFrRN?=
 =?us-ascii?Q?85Ix55GegfWumHtsFtIChJ7IIfOA1ekNMA54WpXTPHwqdD6WWlwvaEIh2erv?=
 =?us-ascii?Q?A3nUnIhZkZDxaieepnSx3t7NmdsC1clOVczO44OzMaY94CX+T0ZSeEwGM+Gr?=
 =?us-ascii?Q?pahkRGvT45lhofsSQwjlkQiC8FtkzU/TGADEE8s2epfeX77Jk20u0hdwiK7a?=
 =?us-ascii?Q?z9gez1wau7j6nfAe1qy20hHHSaWWZYpItddCDKaBXKhs6VufsSpRSTYeRT3W?=
 =?us-ascii?Q?/muOknn8z1fKt/Z9L/CkSHFLgrePcIqY6yPWK8Vb67bqdrPqqRH8CJmf3NWf?=
 =?us-ascii?Q?ly46QnsJy69tcFsbBe0tSuXReYWzwKg6S+OeEcKOL1QJXmkNGCayuthV6gkJ?=
 =?us-ascii?Q?RaoFxUf+n98f/j3+uJqNcYb9KEkuisSD0VOfdXhG8cxz3Ai3k4xlZV7yVVpz?=
 =?us-ascii?Q?yzNqOpVWQ0EFeZgE2D8NTTesJ4HPR78E8guN+4zFMLZKEGVlsbUTvvfjKwH3?=
 =?us-ascii?Q?5MeNfkE6j1S3wi09I6brb2+CTZtgRTXyOjZpho9UYUpLLovG/My7rwysrS7X?=
 =?us-ascii?Q?XaMhSPgmkMok1pXvXJlo06rc2sPw1eTH7CwRnZGb9Lx2y9PmTVs2syFAh1qn?=
 =?us-ascii?Q?wGCla5+DIW2HohSPcnlUtUn7oBknJucOEElrfmf9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17255f93-346a-42dd-fdf1-08dd1b735836
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2024 12:40:37.3054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b5K0SE3H1Jnc+3Yf6EiybIWW/ojbi1QdMA1TvHUxCkg5wHZZLdOpoC+f0FwEq1w8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8135

On Fri, Dec 13, 2024 at 07:52:40AM +0000, Tian, Kevin wrote:

> I'm not sure where that requirement comes from. Does AMD require RID
> and PASID to use the same format when nesting is disabled? If yes, that's
> still a driver burden to handle, not iommufd's...

Yes, ARM and AMD require this too

The point of the iommufd enforcement of ALLOC_PAGING is to try to
discourage bad apps - ie apps that only work on Intel. We can check
the rid attach too if it is easy to do

Jason 

