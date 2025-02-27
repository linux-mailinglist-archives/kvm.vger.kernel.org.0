Return-Path: <kvm+bounces-39632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8AA7A48A36
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 21:59:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3E9B164DBA
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 20:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 854D7270ED8;
	Thu, 27 Feb 2025 20:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UP5/b7jU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2081.outbound.protection.outlook.com [40.107.236.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108C03C1F;
	Thu, 27 Feb 2025 20:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740689965; cv=fail; b=pRCC+3Jou+M4cQW/JIlh6ddqoeFSPAHsS/MV6o2wM2vEhNElpfaIWpD5YUP9OQFSlzr9KX6yASGeTD4g/rIwI04yryJiVSBacC8jysuDP0EVNa4y2kLzkP15qI+ommVZs/Q81hRfLCGmajTIvZVGZQ6iBFwTbs2tLeqLU/tgUGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740689965; c=relaxed/simple;
	bh=xLuBv6c/WkEOJf6t27mlpF8KZ73L4n1+Hoi/tGUs1r8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BD8geMzT1o4u3lvkNks3q2GwdpVLSvidWONDcxkQEeUI836wy3HhoSE8dU7ZJ7dw4OyH9xRCW7xIzTG10Cl5whPihfZ47Wxejs5F2LUCETopGi/Z9K1dOeHKRj849Sgbm0oBXujRL3ttP0fG1xRADzqu1sYvFYkDdkAe+4c3WX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UP5/b7jU; arc=fail smtp.client-ip=40.107.236.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QB933X0wjiWJF00G0uPA6kEcEhAaRN5BMzmMVODONwmNnI1mgkyvlw0x6nJRmH7YXLPI9waPZJU0wxdHYGz0eOJmwYHXr3ETzQB5+HNI/j7dElemqToQUUagGzGncYUKyr06EmmwKUMAjJe6zCycXs212rlL3UiTPl+p0nRGShfkLKcAdGSB461/eZOZDv1g1TGRjo1id8AoGGE/l/VKIFqvfpIPqGdFUCaBFsBVb9Nps9OnZCVvRxLBmr69bjddUK4nkX3MM8lBzBhh8+7KVzBE0opm5Z1LhsZFf4SvtWiO074qB+GdJQO2ra1Qn6qV2pLb7siUxSty51M3Wyrmaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pLvDPmlayCoEFf41UbU2ErzHcMek0xlxHAKD7SOr0a0=;
 b=q+ZNrqxyuDZmbG/v/ecUHiINNCfc9lhEYyvGXDU+T0GMbnTYo9byuVkyUKeb6ot67P/DAsGociZ+KLUUongPejiPgm7XSuahw/70iMdV5DoWSfLWBf+QsMNHIzTF0caLdVqO0CEHRXzkd/XdYF5XJWcVNf//2vE6noGD2AClf+ffNrZqMOSEQiK+mQqCdpZmOyuoKZHTn8wo1mjJT73h8yPq1nX9jY3Jx8DeMxX9qOeFG1gZKn50SA59G8xbFv4MPWe3RMnXxXRNEno5TIiWRjg7ZVcTXJmX0FeSsML1lXjTTF0m3d+RQJEcqUTp7ZNc90AzfIj0RGhgtgRhWJVY1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLvDPmlayCoEFf41UbU2ErzHcMek0xlxHAKD7SOr0a0=;
 b=UP5/b7jUisIZsZ551aQhje/BVXHJEa/Quong562qDjkqjEXK4g7Zut6l9jaoPlPJlkbdOgDXrhHgcYa69/pe8Ur9pZwyCNHkJbpAuVXLE53UmPvBlq0KOJP+pO2+LVV5qNF4e94Wo/XoWZpKN3++1zS/d7sADQdQw6lwbo2beF+lmm6euGZrBofSMAaDkEcVC07scvfBKqrdfPfULePX9yxFQo/quXDKzbQTamJP4PkYDYnAhpwHPYelZdMofwOpGafZBXT9j4zEeFUN4mBYkw5CjgVG+ncnp+uWIKlcSJQdzCx/X/oQnMNOooKyeVuqy/textRf7tuM5s1TB4FOxQ==
Received: from PH7PR13CA0004.namprd13.prod.outlook.com (2603:10b6:510:174::25)
 by CYXPR12MB9340.namprd12.prod.outlook.com (2603:10b6:930:e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Thu, 27 Feb
 2025 20:59:19 +0000
Received: from SJ1PEPF000026C9.namprd04.prod.outlook.com
 (2603:10b6:510:174:cafe::67) by PH7PR13CA0004.outlook.office365.com
 (2603:10b6:510:174::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.20 via Frontend Transport; Thu,
 27 Feb 2025 20:59:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF000026C9.mail.protection.outlook.com (10.167.244.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Thu, 27 Feb 2025 20:59:18 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 27 Feb
 2025 12:59:06 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 27 Feb 2025 12:59:06 -0800
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 27 Feb 2025 12:59:06 -0800
Date: Thu, 27 Feb 2025 12:59:04 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <robin.murphy@arm.com>, <joro@8bytes.org>, <will@kernel.org>,
	<alex.williamson@redhat.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v1 2/4] iommu: Add iommu_default_domain_free helper
Message-ID: <Z8DSGF0tGgvkJh41@Asurada-Nvidia>
References: <cover.1740600272.git.nicolinc@nvidia.com>
 <64511b5e5b2771e223799b92db40bee71e962b56.1740600272.git.nicolinc@nvidia.com>
 <20250227195036.GK39591@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250227195036.GK39591@nvidia.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C9:EE_|CYXPR12MB9340:EE_
X-MS-Office365-Filtering-Correlation-Id: 61d77ee6-6b19-4b54-d96d-08dd57719a52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xJ2Pa0ELpDWto2Evwcm0ALrWIDrpxrAL0V8ESLZaWBqfyqfzLm6C2ixy6nTg?=
 =?us-ascii?Q?CiDJq/HAVwTQEE5tihE8im43tWrZuO+wNVHnYU7DWo/ONm2zO6UP0z3K3Y8t?=
 =?us-ascii?Q?l2S/qU+a/AgZIg+K7C4aM9w38/VqZxPXFye9Xk75JO1WckdgQDkF1iNG1+51?=
 =?us-ascii?Q?HEB0HLyaKaIsPv/TfuOrAvVOeGgPUHzAKnU634p05uBkIbXGn3dthw0pve8K?=
 =?us-ascii?Q?odUsChwJNdXfN/xDALJSYoVgvfwl0qsFL+bHhQasvxqkYGncGl+22n0edag+?=
 =?us-ascii?Q?qXCFJy/xCj/rl/4iyczwnoOIvBBKLBn+6nz1+M7Xx/BN7rBHdghKvxe+CDea?=
 =?us-ascii?Q?cUEHuWWCOje5+K3TJpRSaqG8fF6w/Y5B6yVSgUPr2j2QQlhFYlNukKnoDXkn?=
 =?us-ascii?Q?P4qlzkCSeuAcTF8kB6zzeQ7vVxPV75yxyUizJ3qZxfj7Wft23wiSJs/FdKRB?=
 =?us-ascii?Q?+g9jkzGmFwr2cmQ809OfMP4jEkVkZ2cKkGnszzUuk6URu39MV8CxxqmtRfzY?=
 =?us-ascii?Q?xnxpHTdcCJx4J0Q9q4NIYKbyM72E39eDBJBSTLo2ZGH7cBIcM4N4w+fwzFe5?=
 =?us-ascii?Q?/AMo+dqeHiUsutHvwmnR8FFx2nIk4zozmIXB2Tyb7jcvfNwFo5a/F+oe4prq?=
 =?us-ascii?Q?QxURiu3Jj8PSN7YjloIdrTeotT3YSm9OnZjxaUclmb6a21SkE5HeFQkviSMb?=
 =?us-ascii?Q?dox0HdWAGO2L3e3ImCss9FgeutPbCJTUA+bSa677P9WzWWHOHbkBDhS2Yoem?=
 =?us-ascii?Q?Ux30hibztHJDhKU61EaupW2H8Sh16oQZadirL7/ADP+6UFeCqyWwpWFU3UO/?=
 =?us-ascii?Q?mucZZzH9laPriXCUZNiKsezTDwRpQ+3zR22iOpgeoZblIpqcYPprHf5IXkLP?=
 =?us-ascii?Q?2hbG/fSrDFFIT9IKOagrO5gS0mpsgQHNiBoN0ccINAhywI8cmkPtUIW6Abtb?=
 =?us-ascii?Q?USznyf9ijS8y26HiuKWGh4hleW7XPEP6bOonsmYCpK6xKO60992YrtpLDTeI?=
 =?us-ascii?Q?WGfhDTdGybguDmINy5+x8QD3L1SR1RxYEaWbmhPMilVsUDVqssLHwcwYwbts?=
 =?us-ascii?Q?7TLLHSkKQn0tAXw+sE6b7UHnhRAgd8vvIYiDVkxGACAn12Ro73ZOEjXfM2Sz?=
 =?us-ascii?Q?2Vh7+aDTFH7bKixJLcAqcZuJvT2358v6CLN2hFkyzoRIYUBbGgY1BTshy2OJ?=
 =?us-ascii?Q?TpEmW+TFWGNlAXO8rlxGomXcTXuRE3SzVj4k9yMei5srKjJIObmZ518MK9ui?=
 =?us-ascii?Q?vQH2sqtGyBZxrqbvFXCqJIQ1o/1S6Okj4hfrFwXJp24oFFotccr2Gii4iaUt?=
 =?us-ascii?Q?URZjeSGKkc+ofOFX+V44ug1uorxEIQ04hPWe6pLZEGkL1tT1I1L9pLI81bH8?=
 =?us-ascii?Q?TrHp0/UfEzYr83u0TO2L3C2kBqhhSbMGMm4I9rQ3qyiIkm4BUDnO3NJ9kVYH?=
 =?us-ascii?Q?DeA+8e0/BNA2SKBpf7n+VslOTVoDOiGcjC5cUd70c4PTudOpr1GK4ERrOziZ?=
 =?us-ascii?Q?L5jQ/oHX5Hu9uEI=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 20:59:18.7895
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61d77ee6-6b19-4b54-d96d-08dd57719a52
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9340

On Thu, Feb 27, 2025 at 03:50:36PM -0400, Jason Gunthorpe wrote:
> On Wed, Feb 26, 2025 at 12:16:05PM -0800, Nicolin Chen wrote:
> > The iommu_put_dma_cookie() will be moved out of iommu_domain_free(). For a
> > default domain, iommu_put_dma_cookie() can be simply added to this helper.
> > 
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> > ---
> >  drivers/iommu/iommu.c | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> Let's try to do what Robin suggested and put a private_data_owner
> value in the struct then this patch isn't used, we'd just do
> 
>       if (domain->private_data_owner == DMA)
> 	iommu_put_dma_cookie(domain);
> 
> Instead of this change and the similar VFIO change

Ack. I assume I should go with a smaller series starting with this
"private_data_owner", and then later a bigger series for the other
bits like translation_type that you mentioned in the other thread.

Thanks
Nicolin

