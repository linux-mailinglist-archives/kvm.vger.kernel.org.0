Return-Path: <kvm+bounces-41725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6B00A6C424
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 21:29:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EF853B7A0F
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 20:29:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C673230268;
	Fri, 21 Mar 2025 20:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oOsFUznd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE5F4A00
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 20:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742588978; cv=fail; b=ZDDPiKUEcGdJg2cahyxAX2FtkO6s5wLat5dZSDYzaOyeIIGRJIdsBYDWZPvkdz1ezX83UXWcwDcrEUSI/QSSn/I7YbQpDSGfNJWK8pSSnoN4OQNZhy2/uwZLYCM3UPYhzI33E3nu4pbSyD3yl5RZiOaetPZohF7FUThKtp8IQic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742588978; c=relaxed/simple;
	bh=lVWWoU5piCeL6klxBqBt1PpZnhX1khd+BHIrMUGGemM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nXaTmTm5XvUiJ2ap3YS/wZ5acjfwD7np8sCCa0X22/p1qss2RlgoWsnJl3F/wl7u3dCFecHsV6livXjTTxL1KJXQSOWZhw+eWPirnKPfVQtqjsYXqH8AXFbLqN0AQyn0phVMDKY4AA5aTQQcugb28TyhaiRtbOeJaF508Ade3Gk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oOsFUznd; arc=fail smtp.client-ip=40.107.243.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZpnDp32LFfgWO+6ZI4WFvPVg0HCVpAthub/W7+4Gw6FzWNM4Zec035F5+GK//uHtifhItYKIEsCGpKXZUAbvo1tX0x6UGNhQVpDAtuqmo5LpgKaOMTTxXjj/J9X9q0Q2URfcQQBk6zx5BHj2v2NYk5qe6WLKfmrgBp+XODQgqq4m9e7E1xg11SfE0+KBuMIK0oJj2q0vl4h1cbaHEE1if3RVm8tvGiP2bAJclvH1QasiRoKBWdpV7l5v973E8ZWtXoavopY0rWdwGNLn7qvMaXF0GljvbOCz2W5lycYpjjKbljT2XCaq1+pFtbALxs8WY/wXf2A2f/71sFhwfouaxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eUwAYPV+gpXZiO5u+Kx8lkpB7xQ1hX7xFTreG9SJcZU=;
 b=LTCqcbNnBdxmWSWaOFCLbwKWpjPsm2njx2FI++GVDul4aXDGZGI449pGbNQz1xGIef635btd8Gvol14ojbN+VQfcLMqmfcgmnT7egWaYqPRusXjNxwGonfNGFVQShVd2O0XZl1OqGMVra9E0sbZIGJ+iwSsVptu2hvFtaXii973yALIcc2H38HbSzdvfNf/m2WVOIqkYbLw3m+3QYHsuqmJ930CBOSIgTW+VDKJObsJOg1bzbOxP2ZDfo1jqskqOCyoAbycaSjLI55vVsGuRFfaWGeHc/qY9TqS/JIz6cbpiuYIzYlCMj+BP0Y4N01VkOcRKEHBRCg9ErvPieBhRzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eUwAYPV+gpXZiO5u+Kx8lkpB7xQ1hX7xFTreG9SJcZU=;
 b=oOsFUzndHeKZNPj184UNTatJPhdopd9R496C52NWfCs6VGy+jxSfdlnULTRTmlTfvtIX8NxX846bGyw3VNb9lNEg9EIE5BxMeMUMDYQ5qE1w/SeAept1z/WJD3GeFS18oHPUcl3TuKosUQ33gsW61cHMCOsKsf8fjMTNYsTrEEmOgb9qRBIOtVl8Mw7y8zZyaCSqooPezpvp+cDckK5kH2hXwI7YQSZ7ROosR/UTsnDbnvM4JrfEVjp4Dzm2pJdrDvXfkXzKvVaz8S2CApbcMqS4s9cC73w4hqokut6DdC52bqo4fPajl7RCS8/OB1Iyn0lvVXPNy66uaCJb/ulB8g==
Received: from MW4PR03CA0111.namprd03.prod.outlook.com (2603:10b6:303:b7::26)
 by SN7PR12MB7321.namprd12.prod.outlook.com (2603:10b6:806:298::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Fri, 21 Mar
 2025 20:29:32 +0000
Received: from SJ5PEPF000001CB.namprd05.prod.outlook.com
 (2603:10b6:303:b7:cafe::50) by MW4PR03CA0111.outlook.office365.com
 (2603:10b6:303:b7::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.37 via Frontend Transport; Fri,
 21 Mar 2025 20:29:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ5PEPF000001CB.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Fri, 21 Mar 2025 20:29:31 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 21 Mar
 2025 13:29:24 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 21 Mar 2025 13:29:23 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 21 Mar 2025 13:29:23 -0700
Date: Fri, 21 Mar 2025 13:29:21 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
CC: <alex.williamson@redhat.com>, <jgg@nvidia.com>, <kevin.tian@intel.com>,
	<eric.auger@redhat.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <zhenzhong.duan@intel.com>,
	<willy@infradead.org>, <zhangfei.gao@linaro.org>, <vasant.hegde@amd.com>
Subject: Re: [PATCH v9 5/5] iommufd/selftest: Add coverage for reporting
 max_pasid_log2 via IOMMU_HW_INFO
Message-ID: <Z93MIWxPutO4FDP6@Asurada-Nvidia>
References: <20250321180143.8468-1-yi.l.liu@intel.com>
 <20250321180143.8468-6-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250321180143.8468-6-yi.l.liu@intel.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CB:EE_|SN7PR12MB7321:EE_
X-MS-Office365-Filtering-Correlation-Id: a651d8f2-a819-4558-2be9-08dd68b71662
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/V/QHGlEFqWQkcpph3BjrELeE6xqBcfYUyrcbYPm2OvEoxokyFf3HPz3D/Ch?=
 =?us-ascii?Q?g8ZDDfU8u3tjCy/rcRdeRdASXBNs204jAkyJ0kg2SLRrQLqmVuZgjQtfeVDG?=
 =?us-ascii?Q?42NA4Z1hWFrRQg4nFKwuJ22nXAMj+H4qgOSPkUTvkXj4eq7VVQoULUEFy0ru?=
 =?us-ascii?Q?Rfph9PZiXtMjvPuPhpvd2ULz2ywuAh89PYZWMcHkbHlJd5WhjFCjSZ2DhxmY?=
 =?us-ascii?Q?OZfhrNtJHpIgxyp3JDRk/JI3ye7NjVrcSNsbZu8f+NEcKDTdCfejrPejQgN+?=
 =?us-ascii?Q?XBo7npsVpNUb0K8g1jYDZztkTvO+qGVGscZinNVjD8K4FDGjoFtjXOrYQ06C?=
 =?us-ascii?Q?ym+hG9YEcJa0mY+a4swYCQGTW90byATC3EzaytJ5UDTKj9mVL/EHTO3RtAQv?=
 =?us-ascii?Q?1oXHRVMV1/y0fiye9HfZSX6HtGTo3+Vmlw3N40q52mkxIR4RyuzLgtHKwlc9?=
 =?us-ascii?Q?8Zic6pkB/5N5/es//5l+nhuJ+nbKlPvlo0imxNkbbmIXdQ9If12bUrUNKmlT?=
 =?us-ascii?Q?5SCBOC+1LrarKj1c4aqxIdWyagnAd5nuv3q3MQaHQ27WekYn+MX2mBNHpbRW?=
 =?us-ascii?Q?q8rExJv3Tlm+s2gdy2LuleDniJQnc1YYVq56pcp6hRHbh8Gz4Acgmby05dmh?=
 =?us-ascii?Q?nMvR90/ZzBkE/penp+DoAPQmMOZZL6oGAWoatjpGMrwYKD9t+u13TvL5a7GM?=
 =?us-ascii?Q?1T266M1M2v9B5+UoPKwqMTp2WlylwbTdxdVrvsHOej84+DRSf6SUSExcd0Sc?=
 =?us-ascii?Q?bPTfzaZ8Ghs+6JrJZI6CnBudikPY2nayYKHQtKm/u3W/Nr+W+pzBw/y4tzb4?=
 =?us-ascii?Q?5K4SA30jqw8yn1HvBm5rOW3ShnJipe0VYWQtvmvuzWmA0F4Utycy2BIkdS9P?=
 =?us-ascii?Q?YrWJz9pAhA4leJ6mRSSxNNBAoOG9jNOji+h+qoK2S8jkHd3e1o0gVDXWs7f8?=
 =?us-ascii?Q?Z8CCJmhoxxf9afu4OgmvXbiRzf/tpAM1Hod8kR9ss7Jc1BgWYqG3FiqtKYJm?=
 =?us-ascii?Q?NoeDIV702uu/EakiKwuxkgD8YxPdfnN7jztFXa5Bgdb1y12ImN2RLEI3nw/p?=
 =?us-ascii?Q?xpD/12WDALfm789N8MMtLozuKdPZ9DTGvy95xYVbf6s6Cgih0EbARmTSCr5q?=
 =?us-ascii?Q?8x9OkgdpKDvBSkkgYLHdLx/7WuuDyDNa3xOysCA+PPxXgZkr0NzxXyaMRjwC?=
 =?us-ascii?Q?e0++ESChHDHTRgrWYgTgtVX227url8k8skJz+AupzwxkkOCdV6A7EXBiyeSw?=
 =?us-ascii?Q?Fv9RnN8Is654M/p8ZUSWu/livEzlQzc0LygGRE3+Zyfpx97l0a/5zAXGaTDc?=
 =?us-ascii?Q?LT+wJqL0g2/aBwbwJG7AMJDRhoRKASn9IBojnbVcyMPOR+vPtZQnqbE1oLkz?=
 =?us-ascii?Q?nfU6m90lBtDoOGgvykvzVrH4NhOrRaVINrhvm7o5En9PDFG9BJS7rWAd0wvB?=
 =?us-ascii?Q?9wUJnBlF7XqsbFjd0AkcVLyZCDluBIe73UV0Sy0i08P6E3wuywl2yGYtcdya?=
 =?us-ascii?Q?BmccfHZemdb/6+Y=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 20:29:31.9689
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a651d8f2-a819-4558-2be9-08dd68b71662
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7321

On Fri, Mar 21, 2025 at 11:01:43AM -0700, Yi Liu wrote:
> IOMMU_HW_INFO is extended to report max_pasid_log2, hence add coverage
> for it.
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

It seems that I was CCed only in two patches of this v9. So, I
have to reply to this one.

For the whole series,
Tested-by: Nicolin Chen <nicolinc@nvidia.com>

With an integration of Yi's QEMU patches, I am able to detect
the PASID cap to run vSVA cases in a VM enabling vSMMU.

Selftest also runs correctly.

Thanks
Nicolin

