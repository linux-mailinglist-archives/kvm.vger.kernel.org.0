Return-Path: <kvm+bounces-26127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02436971C03
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 16:01:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0410284565
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 14:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B148E1BA28F;
	Mon,  9 Sep 2024 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ViHpRv6k"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D291EEFC
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 13:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725890396; cv=fail; b=GTxP1uB4DwsqbF9/ZKCfV6Th6qvt9dZkvyp4BduWIe83RPglKOOSweW6j3hwhi0cEFxvV9yxv8xb9iO10hKRShQhQ2iRCcoCfaYSv9TxDN3TKghr3vULX2KrLGcZ2neKXnxuU/GC1UH7dwShSX1rt9MoZAMUAUu0v0GmdCo93Ys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725890396; c=relaxed/simple;
	bh=fGqJRqIb32nwbZyULvNODjKl1LsB3xMf+Z+QZFToqcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eXc+7GWGcz5q9SJz7vY2D8cytUw0XXEwlRDu3VTz0gADHBVHeJrRnbwDXowjgcfKf7wcOm+DbW5caPIs2GUnKDLSGd8syelW6AUBU9pkl7KXloQA2AE8D6xJL/eDjAyDBklfnXy9De1ySjIZOFlp+1bWb0TN090JrxR7OGfk/S4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ViHpRv6k; arc=fail smtp.client-ip=40.107.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KVA+hq2TLJomyGmaOaWmc6u59DaybBa6oPkWo75aVO0K1tj588kFo8MsbmgudPbsbZ5Ut9k6hH8mhzG9f7AD1ZmBG/fZFKCqVgjsoF8ek4DVJnxatPyI/CU6XSreDP/0z+rXujYovVDua3b6qXdGC/wmJy2x/2HFPXJFMXANgyt5FM2SZC/tjlbwSkWO2ZAgqlmt0fAylGMzjYi5r0wZIMhVB0e6xywxcLXUW1x597qwHpVCJQLm5fN/b00dZgkLHMtdkToiGaMz2/uarKSTf6GZXIDJ381INNdCdqMeMenW2kOY3upTwxTiiLX96u9BVsPtx2nrakz6GgiQ08kFnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fGqJRqIb32nwbZyULvNODjKl1LsB3xMf+Z+QZFToqcI=;
 b=tOa3CUHTbHFOv+DsKXf3UEbyLcW0XcIF8ImmRrChf37BGfFFOxKjqYHzVXBjNVzpcJbUE7YmUzqFlkEfaSYnOkOexWo8weNlzbtv/uVtKo9VaXOxMvQlrlZPVTxm+4AMjRPiAxAM/ogWfxyqgcoHRw2298QW762e4SQtGy0H/5KQS3BwnPKxD3zWQuK/VpNi5gxdeBPK3JQnxIFEsr96YldRSuHVNVm13FAbTQ9D6HRKqJl8JcL7O5uc0dCM3gEG6/VB3qYCzJBwjCCaUv4FqXxBY3mZO1JSor82ecvUPwqx+rzPy8NOS6MvDvK99EszedTv1PdX3iszB+nCN6NX8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGqJRqIb32nwbZyULvNODjKl1LsB3xMf+Z+QZFToqcI=;
 b=ViHpRv6k6pujdJWjOpTmW3b0m4L/Jffdbo2FlOhlJFgK9zytAA6kz/V5jwfQniD7jaP7tPzzVmvtTna3hFf5xzVj+S4UpIBorfVzcfBuJIWw9fA2OtzR+s3wLBqVuJJVYKFEviwAg3xIjzsX5/SZ01st1HBMKT7eJNOuOwuEShy40Wy3ZC0hyVsUG/ecDcjTIMXBtSCYOitdEf2BLSCDdCWassqksHqYabypDbg0/VWYNdBQux+KXZq8oxK/sSNoh8/myoOcw+Wb/VapfZu4p+S/lbZ5UgMGMUagjyYOGnN3viNYrcVxa5sveB2bZ3a5TQBoSXMhoFQyNbvhkPFj1w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SA3PR12MB7808.namprd12.prod.outlook.com (2603:10b6:806:31b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.20; Mon, 9 Sep
 2024 13:59:51 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Mon, 9 Sep 2024
 13:59:50 +0000
Date: Mon, 9 Sep 2024 10:59:49 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240909135949.GD58321@nvidia.com>
References: <20240802122528.329814a7.alex.williamson@redhat.com>
 <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240806142047.GN478300@nvidia.com>
 <0ae87b83-c936-47d2-b981-ef1e8c87f7fa@intel.com>
 <BN9PR11MB5276871E150DC968B2F652798C872@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4f2daf50-a5ad-4599-ab59-bcfc008688d8@intel.com>
 <20240909130437.GB58321@nvidia.com>
 <bf023188-ba72-457c-b1df-7209be423567@intel.com>
 <20240909134048.GC58321@nvidia.com>
 <32b4cbc5-ed7c-4d4f-98ee-029b6e1d346b@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32b4cbc5-ed7c-4d4f-98ee-029b6e1d346b@intel.com>
X-ClientProxiedBy: BL6PEPF00016412.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:a) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SA3PR12MB7808:EE_
X-MS-Office365-Filtering-Correlation-Id: de5976d9-9c3f-472c-48b7-08dcd0d7ac01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RMe12SEG/KxGpwUT6APAgtMfSuPhstuo9o3DQXy+x2wxcdqg/OvsBBlQYgmx?=
 =?us-ascii?Q?uDeIInCeCJfUXiF17N5njEdeSeJZ2KAGo0ge0MSqYXCE3eAsSFZq4m4Fmf/+?=
 =?us-ascii?Q?Ubf5F3cf1/pDbHWetqhpVQyTwPyt8mWr3DpRT4NO54sbNPIaAk/cZY7YvIEs?=
 =?us-ascii?Q?aHcKRkysxeSH6BFsEWYgoP9zlDdjah1wGQSBq0rBlUFm1BVBNhdN3bWjaz52?=
 =?us-ascii?Q?9tOgmNVQ8S2neJ3BEIu6jl+UTi/FlAsCqHq1/vdTM3/2U39hz8mBeewIWyM7?=
 =?us-ascii?Q?1vLlt5DSfVqDDx+Y7eoeFMiM3SVmG8by3r4isqMmXnmUrgRGtT+uwv+Yesx4?=
 =?us-ascii?Q?DMeLgtthOywMByMlNGxAGJ/egJQlJaIqHr4d5gMXu6KTh35uM5LS/38wmJtG?=
 =?us-ascii?Q?MjkObijCcP/FBwXj9Rz1/oCdjqJrdLm6FmKQJA5OKyUr+yo5DjsiT1094cUJ?=
 =?us-ascii?Q?o3UVu3a83YnPyMiLWmwcNreUsp0ChqhZHL8OtbVAPxsMNsiPnPsaVI3IDK9U?=
 =?us-ascii?Q?OJK83esgLxHsDzE/pKP0Kez5U6/wYwKZ+eiG3QCt276gxGxNbiZ9cIOAcooB?=
 =?us-ascii?Q?fI00yhGpPPYJapaUik5611Gtzy3QaGcU0b6PGEwaqaCtL7EnZwUSj0NXmORw?=
 =?us-ascii?Q?+tDV8GLVcHxPwWK5jLK0sCUAFGwfJDKX3WK166i3AZHs0NMzPCpDqCVqi5uN?=
 =?us-ascii?Q?cCeXoxuiFMcoQAjDqS4pJZ7YSPcUmIv+q2NSAsIsIseUj4Sdsx6dxLwiqeaA?=
 =?us-ascii?Q?f7R/7P55v7ULotZgG6N7qTvIu48AA+2bykBIypR5Pvi9bw9DUbuqAJqXc/fw?=
 =?us-ascii?Q?l42AzWNiKZeNHMuwI9sDxZm0VxdAe56S4B1TDCpMQfqbvXyd+Z2hRctr8Svd?=
 =?us-ascii?Q?SlssPzivmegPlxG8G5bgrymbQq05Xt96yRaZH9WgK4optJ971gc8HzQovIKr?=
 =?us-ascii?Q?Fy7cidJ3k1QpE2ge+ERtqyiRW8fw12+RYUzZIuPDFi727o8NrFBchWRvTFRB?=
 =?us-ascii?Q?SGheY8nSZPd9mEYsEYyG7KxxFpTWFXt5MVX6VFh4ZL6p8b9eZiaZ+0+MKKo7?=
 =?us-ascii?Q?oSG5A4OEbKnsvz33Z9dflUwpG0RvTWrTagmvdKSwwBd+Le1oud7P5NP1EZMB?=
 =?us-ascii?Q?7AtGKSBMEVH/9uSbLBrjwDrXZpeSWc4XHarbNz3+GDnGOCWA0bNlrfEn6v25?=
 =?us-ascii?Q?KTXUWmrLC55jLXVdVnDzH9EZckoQHZrjSmfPD6oHv+LgB0oBIU9haOwtnAfP?=
 =?us-ascii?Q?PIyB1uz+ABt4+LQL3L8PjiD7zvV401Uvlb9cpvGY2JkojhgHxnYolcbB5i66?=
 =?us-ascii?Q?oqr5iN8dW2bpuh8mXZPiOjJ7OHibau7WS2/iPUBxVEUNxA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MWh+T+7R9zHCOysZYhRdwhkAo2yQ2074l5vhJMt/z1fRVMQ1HLZVhuWoyyaH?=
 =?us-ascii?Q?sNuS5z+RtqOmtAufjgPdkTDWyWsjuAoxSDOzBxtlPX4RhoKqHBAD5zlUtZYK?=
 =?us-ascii?Q?MWKqEIQTWgLMfcXCfZWnzWxhOYK2amMKnwffsgFOUUaPMiuB3+jXDQRbIgi2?=
 =?us-ascii?Q?aktTyW13udTV712G7EZrlHpugk1+So4nMjqQ/y4W5TcOQd3sFXKTgoQRym5f?=
 =?us-ascii?Q?xK0VsAzoiW/q9+sZwDYWju2hRFC8RkYKydH/YiFbqzIP1JGbHelk4oATqow5?=
 =?us-ascii?Q?uZ0uB0wocN3Oaj2JF5e7lXCt9jBJAWtcUdtVuHDDb4i3xfs0JPraLNjPisSx?=
 =?us-ascii?Q?aVxnKyi3pu4fXTtIp8v8YvDlrYn3nm1HqFNM0T4iEg0geoxSz7jIcF8JYS4j?=
 =?us-ascii?Q?zdQgnmq7N9a9sOpOaf3w2An/yq6Pggna1hH+Yr+qU53fAZjxe0mDbxnW1qXZ?=
 =?us-ascii?Q?0cWCbyN6C7ndUSRdMekEXYi5AGa41Bch09/wsaEhHEN2veqjXJEHPNru5NDm?=
 =?us-ascii?Q?kkhccjw4Hmz4O+8ZlfbkuJ6ZAiqNhmvPevLFRSLbB17jI+NQGHDq8wslKiXF?=
 =?us-ascii?Q?DapFmXNA7HzNhQHJZ1FPMcxTOkEgB2zoHXZXFTZVHjHdA5LYYcz6WC72TmZ7?=
 =?us-ascii?Q?BrLEOIfsCZWjGJpYC2gXvNxswRtiqBoy8fH+t4Kk225mWPVpAm+8f0r7BSbg?=
 =?us-ascii?Q?uMQAS8ytwPUqfGeVGCCOI88LNn1OeQntUyc+X2eZb6fs7+6Qp7f9+0Wo8XdH?=
 =?us-ascii?Q?4fNJFssYapnjbaNGN93wb53JtbhvNmvHSQrSozY2Xzkxf1DpD8nv2m6Uq/1X?=
 =?us-ascii?Q?9K0WQubGkKr/KBl741JhkrvJNWv1V6QVFRAaiR2dPnr9oSyU942V57x6ADpg?=
 =?us-ascii?Q?VEg6RUpvOYJNVN1Nzce60EBUp4Cj+mjHJLuklA6atZdSk6q3HqgCvlQtqppK?=
 =?us-ascii?Q?JDhqoKTbaLhD17GlSFfrnBB4jsW0HIKGCut52gv4JbL8827xNnmsGd+TBhif?=
 =?us-ascii?Q?meP5fmBFqFrPQA8gKZ/XyofY6RvsHe6NCqder05Ax5xGJm9HT/5nW9TDZRsi?=
 =?us-ascii?Q?ApRD1a+K5Xz+D6wKW1rRJicsQSCFZIb58jw6WJlaDRQQkLYnpigD3A1NuPmv?=
 =?us-ascii?Q?LpyE1/GthbRVM4USJ8AOODJI97sh4AF9DuRI/olnXSCenytyQVYENIA5IYXR?=
 =?us-ascii?Q?M2bw5+qNtlAjO3+6nmKLBwPoSx2fINYISTYtbAGEx/2qYGRTtbIVLToY1848?=
 =?us-ascii?Q?DG4avLZjNXbQ8Eiwv8TRdoTxOoTkfGzVUM7xYUXgv9fy0ieH/I69qd85kgqp?=
 =?us-ascii?Q?VZAJZG64tLnsykWI2dK213UJCFieumYe6Gw2i6pVk4UedIIyM01RJnPt0Q+2?=
 =?us-ascii?Q?ksYqMrwjZ4T7QFQ/rADsLtUFKr4XGDxdwPwwxytEAAKtHaXlXfX/OOxCB6zV?=
 =?us-ascii?Q?+b6Y02ZBncs9wPLo4W/5iSPAliNcSiUzqvPibrG00w7jW11GxVpVGtIQvhMF?=
 =?us-ascii?Q?TxS5D2U30SJiyE4HNa5X+gBO1q9BvBN9zp8E3faEZNR9FB+S91+Wrlh4GlEk?=
 =?us-ascii?Q?VIRAFR+YTzEJWr4p9vEJSqNVzr3TB3ccK1SmcmAz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de5976d9-9c3f-472c-48b7-08dcd0d7ac01
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2024 13:59:50.3512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j88wIOrGbfNOt1wqTKOBanPvSAQFk14COgBG2M/DdIdYpkVal9kXczpodSJk8XRN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7808

On Mon, Sep 09, 2024 at 10:02:02PM +0800, Yi Liu wrote:

> However, I have one scalability concern. Do we only have PASID and PRI that
> needs to be synthesized by userspace? For PRI, kernel would need to report
> Outstanding Page Request Capacity to userspace. If only PASID and PRI cap,
> it's fine. But if there are more such caps, then the struct iommu_hw_info
> may grow bigger and bigger.

I don't see a particular issue with this though?

As long as it is well defined and it is clear to userspace when what
parts are valid or not it is fine to get pretty big.

Jason

