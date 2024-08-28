Return-Path: <kvm+bounces-25297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 73A24963147
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 21:51:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 184232821E5
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 19:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44F201AC43C;
	Wed, 28 Aug 2024 19:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jzA1AgRn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A2A1A4F06;
	Wed, 28 Aug 2024 19:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724874666; cv=fail; b=S9f2v4/0q0s/byjva5CU3MVF7abvOs1g8zMyB3R9wGQrEbAQ2EAk/Lhymnxgzd5t+Aehwe0N63NV1FPBch/N/xmyRy1OeAl0GQN4Y1n6w3ad3BCThMvK6usZJAoERkgjzikvJ0XmVmHgUlX45/38g57GVBgBfa5BTAf99dFaIbE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724874666; c=relaxed/simple;
	bh=xMnDpBjke+DzFt2lBozl/M3sOwxXFyiw356zSBD4qNA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rh/6ge2OE6AiRpl5lgHOlUFGCOw8rRvFU/IZ2xugIHOy4a6ww4mmClVOyJjxm76HOPeL8kSTzAv4iEQ0BqjiDxeOwT+RnR34MHRToc3w7S53xSaMvdnLnHa4X2vyLxJxI7oFlg/dKV2JZXb1b+F86dB06ePrL4brLellpHk5e5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jzA1AgRn; arc=fail smtp.client-ip=40.107.237.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gYLxHD3/SNqVLf4twuCyiFZBLSRd2UyceeULbznamR25csM56Uul93iNIBio+Z1s+KG8IDe5KVy3JFrqv7Rrn87uIEhRD9nLKsAyd5zyIgJONzT469ZiMZnL7sittZnecKZhX4XWpO0B77JrLTOa2ZGYkyEs4ryfj4QHu+UmpVPUUZbQ8VprS1iRg5TKGg58PPnEyKyD9u4Ojjk05BA3ZCfB2iaIBGj0Jbtx2f8uKfP3LylIEJhjicqy1RTtGOUkSt1kLz6AEowIHGXLBqUmLMqtPcFN7tPi8yzxTFZx1yYIiUKZnIBPYjO1NHRcPLm/oh/vG1bGt2r1u0mxkG5c8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qIfLOEqZdjO5vhwpjtzk69BI8Y9ZU6ucW9WPeMH9qQo=;
 b=PeeFqNWq7ou6sVMFcvDMcYvoaP3xDuyiNyADKGy44F7mzoAPdYaSa3nlvPX2+dmTncOE32CKpvqwyr4cZZ42Ast7jvvEp4b/xtkuK01YDk2E81DqPndUFqVDbqY9ArCH2pT9FIhRW+zrDUpzHjTuIPeGsAO8ca4TpsUnmcM8SPmAzPEp2I/WI0YyjfcepUPBSOEcEay1X6PCmd2XTzK3yTjwasb/UImpcGLR6kfs69UlasdxJUe5RbNTMkzJK3JoQqyOX0JanVVDprD5E+X+c93siTlabBGBiK03djxoeXdxGm5+C1a4nkbGi4R84D5NqxXWaiohNoaOExmdL9PHFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qIfLOEqZdjO5vhwpjtzk69BI8Y9ZU6ucW9WPeMH9qQo=;
 b=jzA1AgRn3UhIMD4NHhPJZBVJKJZkQgwxUqbttbsT+vCJmQ4KZheW87it6hPp0jWDrHwoPbO+bL4KiXiwHsH5Q8FwJme7/D/puBsCq5Um9xGBarYWta9BVl6Ra55vabz7W/Z3w//tvtMJ6lBXTTOCqH7rxYmYeKJ5H3xGNyH1j5CUYO7ESfVKwJIyKQUT4CVwUjBr67LO2YETXUHts9LRFgOAaobKnL+uy3UT50l2s5iabVf9Kk7W7yygYvDsN6ezytdBgA3VUHDzbLiHj6x+6sZS4lUs8FyaZb683aMSpSOB0e64wr0+jdG1yrpLRRG7264Lr+McQZjpaNZmpsFFAQ==
Received: from DM6PR02CA0099.namprd02.prod.outlook.com (2603:10b6:5:1f4::40)
 by SN7PR12MB8169.namprd12.prod.outlook.com (2603:10b6:806:32f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.27; Wed, 28 Aug
 2024 19:51:01 +0000
Received: from DS1PEPF0001709A.namprd05.prod.outlook.com
 (2603:10b6:5:1f4:cafe::44) by DM6PR02CA0099.outlook.office365.com
 (2603:10b6:5:1f4::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28 via Frontend
 Transport; Wed, 28 Aug 2024 19:51:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0001709A.mail.protection.outlook.com (10.167.18.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Wed, 28 Aug 2024 19:51:00 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 28 Aug
 2024 12:50:47 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 28 Aug
 2024 12:50:47 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 28 Aug 2024 12:50:45 -0700
Date: Wed, 28 Aug 2024 12:50:44 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <acpica-devel@lists.linux.dev>, Hanjun Guo <guohanjun@huawei.com>,
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Kevin Tian
	<kevin.tian@intel.com>, <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	"Lorenzo Pieralisi" <lpieralisi@kernel.org>, "Rafael J. Wysocki"
	<rafael@kernel.org>, Robert Moore <robert.moore@intel.com>, Robin Murphy
	<robin.murphy@arm.com>, Sudeep Holla <sudeep.holla@arm.com>, Will Deacon
	<will@kernel.org>, "Alex Williamson" <alex.williamson@redhat.com>, Eric Auger
	<eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Message-ID: <Zs9/lIKtlQhjLN1z@Asurada-Nvidia>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001709A:EE_|SN7PR12MB8169:EE_
X-MS-Office365-Filtering-Correlation-Id: fc67e7c7-a334-4a74-87db-08dcc79abdfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mCEofK+ilSDG1rc35qVpdFxWMZ/6eTvxoPkS63giLUo1sGeSCz74Vr+aJSsd?=
 =?us-ascii?Q?ljML949mF/YeUUEYwehoLVLFftfy5rODFENVKpzJqFT5hwaprCkkiPLxKzE3?=
 =?us-ascii?Q?eQJ2y8/jXgJaL3qTZQ9osoNGThcg/hjs/KFI9meZM0U4JLiE+sbUAWz8fzIz?=
 =?us-ascii?Q?2TWREZcixCnGZcoKdnss9vptwPM2t5fKFzjAHekuM08FLICKD0Ugy/CpcKgf?=
 =?us-ascii?Q?7jx4hiTiDTQpha9cG1kyiKYGCoNLJPm9BAYuWQtH1rJshGzL3VWzA8g+Ekf3?=
 =?us-ascii?Q?vX9qxWP43+8eBkVDQPETu5JERT5SpsvGZ5PUmZMZ7vBchiEz+uj3pPc3hYIl?=
 =?us-ascii?Q?JR8nN8PfR4JT8yoXjv3VY6NAWpMn3oejj5fD29a5BBQSrYAznm1oT7bTKS65?=
 =?us-ascii?Q?ecWVYww15VBr+LrXKTKAk8xnPMEfpQbHx50cUCETJQFIRK+L0lP63fygp0pi?=
 =?us-ascii?Q?3Id9qV+7uxlDZclFdrZsM3NQ+79WuIVz2F0wq9gZkI5D3QgQ5qbKcNQ1rMEj?=
 =?us-ascii?Q?FDZnMzV2Mj/nA8O02qDVRC4PvdhrVCxvIWASn5+ZgnR/bigVDyTT1oAd9Osh?=
 =?us-ascii?Q?BHdMwFunfpVIDKaHw6iqmROJGRxRTdEFwzvZXC4U1S5/NgaFuq1Cp5hw3YDU?=
 =?us-ascii?Q?pqc0XIq7tTNCkaTvno2TqoSM5tQXQGYUk8SXos8+NOb99fxGjZbDZomGsCoj?=
 =?us-ascii?Q?bRxiOAE0A7X8syvccYp0DO3sEJRObIV71EFqHIVa5++VE+dOAQENM2FNJRKd?=
 =?us-ascii?Q?/mQwE6s89XkqV4jQXB5Q/MFH/5wsNHi3UDh/IMuS9rrqhldtAr8RBcHPZWoF?=
 =?us-ascii?Q?0W9tl/tfDm9kuuyzGoDhy1wcuhrriATjDQ4AjCFeRhRsDvU52TaIYHqLWkd5?=
 =?us-ascii?Q?zAnsaydpw+MJGqVb0qHcw1AEDKEaCZSZY13Dj26tyoL/rLvwKtrIG0gosrOJ?=
 =?us-ascii?Q?4eE9hMWAQcRKU56WZrt6g7TrdrWoL4gEabfifOnqe+kwEi+HKi+T/OV78L5R?=
 =?us-ascii?Q?786b3MYfnfmLCHg8fIiDtL4NjeT/IxK8e1kTPhdP9v0Knwm5Q3MXWSyIbw/M?=
 =?us-ascii?Q?vHAqT0Ae7hVyMNOoK9Ct0k0rwXJh/5whHW+nmstSGQDGtp88TKDq2It41tmt?=
 =?us-ascii?Q?QMftRcH6pionT5gXnY/46d5CCEQM9sBnC5URID9zfrmD8xNlgoKplN+Hl8l8?=
 =?us-ascii?Q?6hw1V0eOkrsPrBITXCAjMS+KXYDsbIYd79rU/h9L8XTQZGPJ3VEWSrc3e8j+?=
 =?us-ascii?Q?CjMNX0L5UQe2JjP65eArEuQTDFI+6DGhn0q5BrTjDNf5wlf9kIYK4ZMRvJcp?=
 =?us-ascii?Q?q+Zy3El7OYTbY87tOrXM20kdOatyKOwl9c66PjaH2zLiOO3oZjj7517Z3Ijb?=
 =?us-ascii?Q?4tAFEztV+OmLnjwwoSL4fdJ08CQcTICGaGuR0CfcdSlqjib8ojM1tLhKpHhw?=
 =?us-ascii?Q?JdzSKjSairbVsaKrOLeCLawCFc72y7p8?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 19:51:00.4671
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc67e7c7-a334-4a74-87db-08dcc79abdfe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001709A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8169

On Tue, Aug 27, 2024 at 12:51:32PM -0300, Jason Gunthorpe wrote:
> Force Write Back (FWB) changes how the S2 IOPTE's MemAttr field
> works. When S2FWB is supported and enabled the IOPTE will force cachable
> access to IOMMU_CACHE memory when nesting with a S1 and deny cachable
> access otherwise.
> 
> When using a single stage of translation, a simple S2 domain, it doesn't
> change anything as it is just a different encoding for the exsting mapping
> of the IOMMU protection flags to cachability attributes.
> 
> However, when used with a nested S1, FWB has the effect of preventing the
> guest from choosing a MemAttr in it's S1 that would cause ordinary DMA to
> bypass the cache. Consistent with KVM we wish to deny the guest the
> ability to become incoherent with cached memory the hypervisor believes is
> cachable so we don't have to flush it.
> 
> Turn on S2FWB whenever the SMMU supports it and use it for all S2
> mappings.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

