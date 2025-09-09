Return-Path: <kvm+bounces-57107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 383D1B4FD58
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 15:37:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BDB05435B6
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 13:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFB78352069;
	Tue,  9 Sep 2025 13:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DAbXhSX9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAD0341658;
	Tue,  9 Sep 2025 13:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757424698; cv=fail; b=qVCZsM+4dAIxHLWGyZoeTRzesyw3n75P3sS1UdOxKLkcqWp7zZraWLji6uekrp8U49DW0Rf7CXlaTCKwW8+z1Gv+mbm3wV04Iq2XzwN1dpGqMfKv6S4lD9AEAx/XAEa/Y2ZWIDMNXuvBnqEMo7BsLXVioOnXUrO5NgvXlBzqP9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757424698; c=relaxed/simple;
	bh=eao5XMBpUCkAbf1ekSctzFTPQ8W/4dvaIUPEB66cCv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RwPRo0TZ+U3v0u5fdwVy1Bxb8ZG5UkGY3/vSRzL5VsJENsOeAnVy09I90pLr4rLi1C/ELWX5d0HSu36W8j4fyAI4ohvPyOVttaQega3ur5tBjzQXB36ERFTICxzFqawPiwr+b926lUCPpnUHmkA10fUog/Mw6IRegu8FPs8MksA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DAbXhSX9; arc=fail smtp.client-ip=40.107.92.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y/x1y8fPvgOuf5lwNSXgQFRrODbTIRn/R5fTlRE+b85Uotel2Kv0mIGfr1JtE1t9/InCbhizomOi6OND0dfRtjH7Lumq7UypFBUvW6/BnKJn6HbIIQqtYO6Lzs3C9tBg2ke1oBaFHwK0w2bgN13QSyk+TG4hDFB2hYaAyIbCD1uyPk69Q8Ph02jde9b5O4Bwm0R91PxpSRFdn/m0rFywpj4olX+bTakwK+Uga/nHGel/m5JLleMr8eUX01ysbzV6fy2t9KDYynrUVbje8ydCxzaPThma4gptl+o37n8cdmVyjMc2hX9GEtW6AkAaNKv15DTdlMwnv24e0ec9YSuB9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eao5XMBpUCkAbf1ekSctzFTPQ8W/4dvaIUPEB66cCv0=;
 b=zA0lhBWr88o5oyWtx/SymDbdhbKG1tM/PWRBjoVKSuV3t0qWov4y2phSWzhqbX+zbehhrty58SwjXP8RyoQzaP0FP4GIct35EaYPJgOwx0VFd3fVPbkfGVnA0ZwdTSas419CoKx2bk6xXqno1UnAQaArmVyyp9NvOip9paHWZ3l24bZXap673eA+Zn0HbRUsEfnIDtqa2JdAwGoXt/UX3dBXnyVaQ3rtSunOmCTjyOPwtpTBzxEg1DTu+/gGEuO2PA2/3dUpufKHaVjMo59gqvgDthtRsQ/YHZH/qxnyRdeAEFIM34/Wh9/wh1SE/Ot5ZNcHjyhBhpwqUsvKixyqhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eao5XMBpUCkAbf1ekSctzFTPQ8W/4dvaIUPEB66cCv0=;
 b=DAbXhSX9o3GonLja3MloN3VOOFxn0qTefNmef1jQ+hxKo+q00BWM2jCvvTSoCcwOCvdSJQI/3pormFepvfMMUBxT9Vb4h+komF0jq84efTW4YFraAZP3vwJZI4zIhxXeR44RezwaKD34DkRp6jrMvAJTE9ABlvM8+3PPdxNKx98n2uLjXPkRF44DFmZj47+MywT+m+SLvOQXS8HnNtoaOJh1kWlTxxAAKtHbp7YHiOmwLjtEe51BaZ2lCw5Z2w7/ZlTONJrMvjUroOCieaiyKrj3ngiUlVEeMerEaDjO+VgBwRbkTm77T0dkkCzKSommrROw/BDCcHrB1QQKZIPphg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by CH3PR12MB9456.namprd12.prod.outlook.com (2603:10b6:610:1c2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 13:31:31 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 13:31:30 +0000
Date: Tue, 9 Sep 2025 10:31:28 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Donald Dutile <ddutile@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v3 06/11] iommu: Compute iommu_groups properly for PCIe
 MFDs
Message-ID: <20250909133128.GK789684@nvidia.com>
References: <6-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
 <d0a5052e-fbbc-4bb7-b1cd-f3f72c7085d3@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0a5052e-fbbc-4bb7-b1cd-f3f72c7085d3@redhat.com>
X-ClientProxiedBy: YT4PR01CA0502.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::11) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|CH3PR12MB9456:EE_
X-MS-Office365-Filtering-Correlation-Id: d43ddd0a-8bb0-4a8f-2b46-08ddefa52fbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ruGr/GbJK8fb3WpIZKlAhTewNAdnh9EAE5hRSa0Q0I4mk0RSpha0wmn3HgDn?=
 =?us-ascii?Q?9be+UQQsOCciZFcjNngBbOHqOcTBqmwE0cc1+zJaY13yCUox90pxKETbeu91?=
 =?us-ascii?Q?+Kxh5TAkVDJNv6iiF//T7wUWhsNXgrdwtM71nZAvBSZm+9Cfgq7M+F3Fl2vO?=
 =?us-ascii?Q?ENhooukfbej3/W/GIPK7RFBa8HuwkdlgOHaw37kv6EGZiwlfqvaWnva+Ysoj?=
 =?us-ascii?Q?Y+ZerRPOZP69kr8TxZWzCTieA8+3tUvkWFqOLa4p2VEjLi1PGX6iWXcqjn/F?=
 =?us-ascii?Q?gi/25uzAIFM535OhPB3NeK4kkClw3NZEL58QrNpexvkwgmSQmdvnyvDktECx?=
 =?us-ascii?Q?5MvcLLnSX8sGaQ9Y9kuAy7vLiMmaq0hDiYwsV4NVBZwRsga6wmGFTgPr4oq8?=
 =?us-ascii?Q?cifKD3dLp1uBn1lxPL9SNUIfM+IlXF9+403eoxycFQFjwgKjedwSH4gXtPv3?=
 =?us-ascii?Q?1fbNoreQMOXiO6DiJVNUeR+AOfRm/tQtiu6vrHZhvbxPCr7NR1jfPCi/vwKC?=
 =?us-ascii?Q?Zy5gy2rhsdBslmIwNqBAi020z9ydO/mZOY+G85/btWzltDRxMy1I0LkBRMW8?=
 =?us-ascii?Q?8f+y2hNyGm7nFUUdJWXZozo5obb6NZvbX1DIuYJ6rqeNol4E/f4j9oau8Qyn?=
 =?us-ascii?Q?mCKluB+TcFdMOadvyFQgmtEBcOJHkoXlwrL5D4h6VrKs15DJNfrSkPhQ/o9x?=
 =?us-ascii?Q?rmTraBXbP9sR7VVTO0UXSAUwgkUbeHLdkLNQbUqmTgyiS7C16Hui/WRxKIc8?=
 =?us-ascii?Q?jak+S7Z1Z4r0y+/M0O3ckU8icJJ1O7KKo1kOL8rlJ1vndhiAblJf3b8Zw4dZ?=
 =?us-ascii?Q?uXV1G/08AMmSBb5aexvEJ7XjEn9ISb207JQlaQww4fv0TEWKaVe6ky9VddmM?=
 =?us-ascii?Q?qvGVhpcVpopWOk62L4WY20amnglksGq7EiknLYDwWuvzUHsUTe0cJrrvfxT8?=
 =?us-ascii?Q?9PiCH17m1sieTNCobvFnl8jo85y1BOqsuy4NKoYzv/+kjdpCAkv79pxMWqm7?=
 =?us-ascii?Q?GCD8QyZCxI0Rq4V7vhCKn/TRn0GDxVsawzgF09uNCJBaSxa39UAeqJ1Nelqb?=
 =?us-ascii?Q?6HEnANwar2uOLt5Du0RnVuSc4JiE6NDvZCp1xUui4kkSA2A7W563+6/7g70D?=
 =?us-ascii?Q?bl+LA1d7o+f/ph/rdiSRS1VB+FxNKDDrEB7sURZO2x5nqzR+ATfu0rS/d895?=
 =?us-ascii?Q?ygKmhU9yq745KK4kxCFRMqFl0iEIUE2ySXbT3AlXG+rqxLcUaHgVfrY07Grl?=
 =?us-ascii?Q?kbZ99ATmnsd9ddi9e5RwJ6ROMb6J7s8JKkaoijaUAl5h056l7UcYBYYnjxJz?=
 =?us-ascii?Q?ijYlDMDqwu2Sa930LWSK/oudbWLcxgVQHiwYE8HxBm+zuJ+2WvRl/CuKmYjP?=
 =?us-ascii?Q?EVMowPmblCzGLaT3/Drim2PFyMi7nXHVRpTKI73YWpEV0FPPnl6Qy/luTeRW?=
 =?us-ascii?Q?r70vC02Pa4E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FTNQQ5bD8jQ89k4uaYqb0SUrpjMkV8+ol4Hl5wigew1+AQE5yTl7IliG0QH3?=
 =?us-ascii?Q?1OkkdNP5ac05S/HRFk0azO8Xa5auLq7t9OsuTwki2P5naiSYdCgh5STUvNXN?=
 =?us-ascii?Q?Kf6hnUGFPi1B53cJgDUXc5DfvLeEd7X2b4ROXmyOp8XCN3Vf0Ehl/WGnABRs?=
 =?us-ascii?Q?6IQBYgk8bYOn7WCR1f03TCy8HtLVs8YqvR0ddGGHUACY4ACpnvvlQfaxaQnE?=
 =?us-ascii?Q?4IxaMpAae4PzHQPvhruSh6b1piEft3KomdDrqmslvNanrcx9LL+9bPZzkJlt?=
 =?us-ascii?Q?0pksGtJh71ofF3i6ye85uF1c9GPoRWORLE7w/0K+LG2BRKNbvILXFfUeNTTR?=
 =?us-ascii?Q?cFiJCMlI/dLSj+sjSY+mH5PLeDYI3AmDwzZIGL+n0uA2tE9kCh9rLmzYxjYl?=
 =?us-ascii?Q?Cixmc1y9VhnWhVQkkp8eotMGcme3eep0wl+hmjcX841+d0f6X3vS6fNfXZX8?=
 =?us-ascii?Q?Co3KfvxPhoJPIf+60DTe1Jaf8h6erkdVKA/dtEwj3Aj1iBvAfSpMEsmYA6Gu?=
 =?us-ascii?Q?VlkD1WBvhuu/LundCww99OSERSXc3GGHQxkaLoDC2n1mrJ2IKSFIUhrryeU5?=
 =?us-ascii?Q?bUJurD3y086r2p4CzIJr0+AFdVcr449NU5CN6hGFkYZzOMSTzZiopC0WSI6D?=
 =?us-ascii?Q?53mewe335e8O+hOGpfbrATc2Gg6GcrarNpzgN+x14piqMcWwHzsKK/5xzZvj?=
 =?us-ascii?Q?4u5qzZamO3F8jnNig0r1VaD9RFnNwbZC+XLFMnYRvw/vgCS2jdDzrXqX+N3r?=
 =?us-ascii?Q?Mw315nqlRJfkT4MNyiENAlyWCbAvJa0jpNiBLXiEq8Cbte35urKWB1mMLsbg?=
 =?us-ascii?Q?nrDDdyWjNATyB1JIE55tI/ts/09DSPoLP4oP5lyUSx8uvCQaf87JFCCO+NNf?=
 =?us-ascii?Q?5Q9UqAHWChlkUs9FThoxjd33vaYli8vJMaGu5sm7IXIUNlWLlKhZd9hBsEdc?=
 =?us-ascii?Q?xylO2jTmmjHyveo1+8oF4NlERppSeYA2TH95wTVkotWiLbPM+gz+VBVLpmDf?=
 =?us-ascii?Q?xgTzMCZ+wd/vclkSeaD2V/UoZfH6qwhs9yG638xxXO4ov7ZDhIgVxq93oNUl?=
 =?us-ascii?Q?ZQZx5PI+0EP5iFJnJO5DHHUGhmvigJVBa0UTdhzQEg5E34RVlaNKLlPcMtfP?=
 =?us-ascii?Q?ZAbyoiCJyVmQe/H2t3wGlkt0rnA8wSEnZYeqB9GBjWFXAeNQGuaG94gz3XM4?=
 =?us-ascii?Q?eIwOjTTuJhYmb83y/sBsdyVsjnZP/hgur/2uxzOXZjX+MYfNmDQPx/6RSbIh?=
 =?us-ascii?Q?pwKQI4wwBOlf85+Dva0li7CRXvh3m9NbsliovV318jJf3uRTzvXoGATzZ6Sz?=
 =?us-ascii?Q?atEFd1KY6nzNd6Mus5k+RG4ha3vQitZhoWszpXxiKXWD3UD+ZjHqDK9911TN?=
 =?us-ascii?Q?fNuens3Co31H16rVt3ppN5xFG+SxiCP/3RFVPykinynNke27CJI/aAlTGGYa?=
 =?us-ascii?Q?zuy6KdfTpw7Te+Muihv+yYdrzv1qweVEngsyXscArmleUnWJb7oZhhkEWZs+?=
 =?us-ascii?Q?OD2BUTPwQ5wR1SrIbDRHeWkTAU31XlLpVRMWkpZINz2sLxoySoVPGA7t2LYp?=
 =?us-ascii?Q?t+iBOgEKnhKqzErRbhw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d43ddd0a-8bb0-4a8f-2b46-08ddefa52fbc
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 13:31:30.8638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VVWuSCXb49TNWpm5qq6dNlCmcaRVIiGHL9KnJQKKONg744Gb4PTPh0NA/0NVXisQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9456

On Tue, Sep 09, 2025 at 12:57:59AM -0400, Donald Dutile wrote:

> ... and why was the above code done in patch 3 and then undone here to
> use the reachable() support in patch 5 below, when patch 5 could be moved before
> patch 3, and we just get to this final implementation, dropping (some of) patch 3?

If you use that order then the switch stuff has to be done and redone :(

I put it in this order because the switch change seems lower risk to
me. Fewer people have switches in their system. While the MFD change
on top is higher risk, even my simple consumer test systems hit
troubles with it.

Jason

