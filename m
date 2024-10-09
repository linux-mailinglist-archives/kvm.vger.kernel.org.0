Return-Path: <kvm+bounces-28290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BAD12997291
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:04:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66A641F22FFB
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 17:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6A3019AD7D;
	Wed,  9 Oct 2024 17:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FcSKQyzk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2063.outbound.protection.outlook.com [40.107.96.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D80648CDD;
	Wed,  9 Oct 2024 17:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728493446; cv=fail; b=InXpCMnemEVLDm/+BN0706EMzK30IxWr2CD66+jHuw7Qr9SyIaJWRDPFc7Smi454t6wJfkqI1nE1Ys0RDsVuDKZcOk1dlX5jbQZvfw4tXMQY0YLK6haaIAHBdCDwC4nFq+OhKBSFygYQPquaY0Q6GUDr7QjnC0LjjrvZmbMZ92A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728493446; c=relaxed/simple;
	bh=IT7uAnEsXz4+B078L+SPFSTvWIP9Ipzt9uIZC5h/tGM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QUfrfg6rpouoKwr2C4nfiadQXDjLmNw1qLfbNdFWhR5uZBQfdEK5cXhh84x7lziPLzgosB7tVqcmaL2qAke8TRLrjb+PJDR/qQh5/c/D63PPc/CjsffJmWRhFquT14yFDRamOPO87T1tE+Qfu6vvhNZeJ9FpKVR6/6OmwSMgyNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FcSKQyzk; arc=fail smtp.client-ip=40.107.96.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P7Ia1qSLt0RwFWkK9b5eQY/KsXT9EdZkOqAGM0b+tJ0DxMv3/8BhkYD5xLoXl6xhcsrSPIBm9iAIaIVq6FLtRxD08cpOse8Q4QKVWRmUuk0DerVCAZcZbzKCIUvLXxb+2jq6b38s9Ae/oY9reWDmliZ0cvdRBWn9Lnk2xZTmQp+TeJHYzq3NC6XdNaySM0GQduyFWV9nzBSZg2LCMOKu36tu5B/cyqhzi6aKGwNRKVB9G7cDgCmPczA6dyv29g6fxespMdURGulcgC6RdZdexA3eurFG2e4OmyPkXcL///CRk1+VkM6ht1sVXBzxkysyeuNtKe+vnZU1y1XG0v2KfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ti2rkxh3lhEmIdHFHXW/NPDrHl5+EbL20e9u4FdgLas=;
 b=kCshkSBRrEu1iHlJq9gsmMhsck2//7rMpWrhuhfGYQggmWDtu0Xs3766htp9HAzNPiz9idJAz4kwxnY2SbNkTY+io43wzKYK7j847HNb3pPRP0OqojO/925WiNdC8SDgLHp65/GKUKDvbQYCcNayS8d/G/IizUW1OpdAPmDc8FiuLLbvfCynpp5ehY88j1Hxqxc1Opkxpusb/QiEYvY+eZyfzPgtcHFLasfXx1bOKbv1/zwoQKg6+wWvGitNYuJrKVHQCUmN4S6aE2h6EsFLI/5OuTg5y2GQsXM4MeCN4meKAT7rVAkqs4e4DlXyaXAF460S1kUDwC4rAwBXtdOFpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ti2rkxh3lhEmIdHFHXW/NPDrHl5+EbL20e9u4FdgLas=;
 b=FcSKQyzknV1AnPI47Xa5aRuncBrosEeYVuWLuwWFTM4s1JUgfpo0Bh4T4igRki6lnLjsRuWbgTtpwexq6jKvmUGuszzW+qHgl/4zlY0GruuW7sWvqf6wMKH98IgYs8OTVCUg+P5RnIr6hlFPInN3dMOiTCStT+bys/Uz1cMY3wQ/Oj3Y7hcOfM2+qlntIgGPDs9rzaVFbkx/SC9fsTd9EQwRsus6j6g/Avq4drUXsTiH/PtcLMxZLI3Wj3HrgBXlPCM5EobGzi8iWA4mLIxl6akmwK2/OQFN5WGGFo3wsFaI4gW9H8t7RNOHiNo5Q9xOH0OWR4Td8VolyTGqowbPjQ==
Received: from BY5PR03CA0024.namprd03.prod.outlook.com (2603:10b6:a03:1e0::34)
 by CY8PR12MB7097.namprd12.prod.outlook.com (2603:10b6:930:51::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Wed, 9 Oct
 2024 17:03:57 +0000
Received: from MWH0EPF000A6732.namprd04.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::5f) by BY5PR03CA0024.outlook.office365.com
 (2603:10b6:a03:1e0::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.17 via Frontend
 Transport; Wed, 9 Oct 2024 17:03:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000A6732.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 17:03:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Oct 2024
 10:03:43 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Oct 2024
 10:03:42 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 9 Oct 2024 10:03:40 -0700
Date: Wed, 9 Oct 2024 10:03:39 -0700
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
	<patches@lists.linux.dev>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, "Mostafa
 Saleh" <smostafa@google.com>
Subject: Re: [PATCH v3 7/9] iommu/arm-smmu-v3: Expose the arm_smmu_attach
 interface
Message-ID: <Zwa3aySjN8YmrfBW@Asurada-Nvidia>
References: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <7-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6732:EE_|CY8PR12MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: 482da53d-e36b-405c-3e08-08dce8845cf2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OWRKl//dlQJwErvMUyD+dlJ0IH+CB00lEncr+ncuJwiUZqx70Hl86iO/VVJC?=
 =?us-ascii?Q?lTDMYDP8NPxO8Be0VicwJry5tB6Fn1Ghaw/NOEWsarGQAvpV8CRo2bpVGqOi?=
 =?us-ascii?Q?ayMlvezUGkMJIQAqoyTyFN94qtuMlUgeZ4CUxOzTclKbZrSHVXoVbMbN/s6Z?=
 =?us-ascii?Q?ekmnocLvCp/B+hfVG+5+jhv1W3GRaJ9+yq7qCdOn3vxGqtJ1wVmEzwn64e1w?=
 =?us-ascii?Q?MhGRMErbJjQQgFxLQkEwuZcNEaG6qV9NNuPYL0Z/YrvK48M9bE5b0ROin8xW?=
 =?us-ascii?Q?/K04SQ7gwQyE1K61ePf9YCFkSC8wvgurYVgb4yOBBYXeCsDMZgSBSZDdERKu?=
 =?us-ascii?Q?LXCL/azhf8E4snj9Dv22jzywlHp2MhmDornE2FikpwOFd/gAokDP1jwJAaTv?=
 =?us-ascii?Q?xpvoVeW8q9xKk3s6wj0Xir/OazwLzgIHxrebOEUwLbpg0q20FJAC5avYsBEl?=
 =?us-ascii?Q?ZjISJz4zEFIT4X2lJfBbzwLpc9cjKBzIdajMxjvvMPcMR13/yNgpXdXL5XOM?=
 =?us-ascii?Q?quoTDZjdivNELrUyIROr38ENOLHj1DIJlZp/GOX7wz6iAxW5fZkg+pKfAKJV?=
 =?us-ascii?Q?9ipK8jYB12yNuoaQZiyxfefuYuA4cU/ppyL385Crltt7bGfFcw+XeW64soei?=
 =?us-ascii?Q?K8VUPfIZ9imABCL4jGVzOk+dDUGaVTJpO/qkQVrxQaHBhaFJHSjJSA3scifw?=
 =?us-ascii?Q?PwyE3+MQQA3sBfeQDTZ3tFFKD+X5XhRp4tKPHOja67w0UBx4y+3DOdWa66sG?=
 =?us-ascii?Q?jYk+dyP6p8zNrzfYPaQVCcwTIIR1lDQbgwnpDyFPyujYOQX8nXN68CZTb+nL?=
 =?us-ascii?Q?jfTmte+BJ1pXOWb0cepp0q0TgfQayslAhPgUEnS8QeXLwOlqHafBRwLfL5P2?=
 =?us-ascii?Q?+aeBS1nxEUUeuM8F3LSzjSGJRe0Ol2/tBftCg1D3glGKh9m2Dfyz73lw0ofb?=
 =?us-ascii?Q?3NzHLDOK0lKGoFObkTtYgVKd+11lB5JpidGYFpzP/mT5O/keNjYAoa6YVYhd?=
 =?us-ascii?Q?GFW3WSevX6QL5RX1gqm9r1Wvh/gGH060mrG7j40BuaohJDF+GCS5vC91KIBO?=
 =?us-ascii?Q?DGCHCpcqgID7FAw2kRAhfPdlxWymDf3LLAzyvPO9GxH6aw87qptZaxoX425w?=
 =?us-ascii?Q?QmymnqUtsIo5vrZbrO2Hn+9cFedncAOrFgxNf2dQVnuG9AAox1vmO8LySNhY?=
 =?us-ascii?Q?MYx38GQjNnQmhn+7xnKPn50ZC+06Yt159F7JvfavplZrz3CuCsSj2sF9oEBK?=
 =?us-ascii?Q?oD7+CBUD/hNtCKaUfbYNeJXkKuc2YLrGYyPAYRmX9swQzJYm/ubuNu+uIJUK?=
 =?us-ascii?Q?8TRl21k5adtsFw/5W4X6i5uwo2A17R0Ozw7EgjA18MuLKBxifgtelmcloxbs?=
 =?us-ascii?Q?Zzzi2Ew/ZW2spkEciBzY7M6IW5u7?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 17:03:57.1067
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 482da53d-e36b-405c-3e08-08dce8845cf2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6732.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7097

On Wed, Oct 09, 2024 at 01:23:13PM -0300, Jason Gunthorpe wrote:
> The arm-smmuv3-iommufd.c file will need to call these functions too.
> Remove statics and put them in the header file. Remove the kunit
> visibility protections from arm_smmu_make_abort_ste() and
> arm_smmu_make_s2_domain_ste().
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

