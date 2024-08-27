Return-Path: <kvm+bounces-25199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC3B0961869
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 22:16:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B6611C232BE
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 20:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F451D31B5;
	Tue, 27 Aug 2024 20:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FMqWkiui"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C02823DF;
	Tue, 27 Aug 2024 20:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724789784; cv=fail; b=hSyYJnsg4pOwjPG7kPG9C2U/M2GgSnPshAtoSF+t4yZKEiNEtsZRKXI0f0PLf0B4OGYIduCsJVbWp1SVHAHOZQodqvbI9yz1ATvDf8muH7Hy+/Amkh2Iz9z5r/IjJzQZapvvMzl3IWU4/jAbs6ZWb4kjIARpbhGaCDPtO+3Poos=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724789784; c=relaxed/simple;
	bh=1qU7PkEaM+viAhrrpz1b0acWgKEwRb6dHejPnZ1A4BI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uDP1XU4BSGSEYrjKszg8VweVPpUCqgkE8B4WL0c91wqToN3EfMosnn6I4v3MoNAQiZf/cULhbJtTA3mSCAJwoWBT3AhMIwwRq2xHZNgRJoN/rmDA1nASln00/21wyfXg/bBZMO7tNLRqYzqj/k40d33ksI2gzj7TUxXK6VgdCVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FMqWkiui; arc=fail smtp.client-ip=40.107.220.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wI0BQkAquAV4DdtMTCKY9Eb9zMJgFt0V6cxuOObFh3nhcxWXH1/AIIjZYo4zRim9AYhbtHpCq6MQy92U7uWQHKI2hTXV2OMuVpGH+oCES4+YBw+491j6nAMBzALfatkRaaRwaNPIt6OuR5Zw3JxytLV3YSIfjAeJRBvYy9QLACuAZFMeNg8vZ5sqaHs4RR6jMr8kBD8IjQpqEO9Ft2bpP6VjaYgZv6n14HfnRFulTJF6Ar+6AZrR1pfD1bik64s3NhQoH6zbEfxZRzIEV/3NO9VoYA60v4S5wDOlZRz1e7Ik7keDjeemRnxBmVMzxQytg27+ojpwQNpQD+5749VW0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=anOoSeiBszZZU9tCV/5c2nUMMCT+ZYeUV5NLuI0P9Sw=;
 b=N2Vaav7Bmxdo0IboAeC7/ay7cmXUd/LVCDkdNS4G1Cvwehw75mUAbICygH6lE+sLjT67YoXinYIRiZIbrNHYjbR+apZCsV3yXTjWUiKNBdPunx7ZKgDnMk9LiDPjpkxks9jZHU/8Pytz3QlqR/HuKqEka8ct9AP36JXK29k05LFxDGxauF4Oj47QHgmXlS4+RJlRCVA934CrizzrJuC+cixSVY3KYMrUSO+xxlB4ChYF00KB2suZFlGAbqVBO/w7hbZz1cvyEAd7kq3cuRlpR4JZihcXwOieiWy8l7fiOUREE6LaXyRHv/OWVJHrEMI16VvJNExZjotlGsA4lw+ziQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=anOoSeiBszZZU9tCV/5c2nUMMCT+ZYeUV5NLuI0P9Sw=;
 b=FMqWkiuiRznSONyuU9yr12Ww2/2cweENd1LP8epidBZz+YXe6NLVgI/qvV7GMN2J26RM39vXvuMvEh5xiS497aJ3TZYiJcV5JwABwUz7xYISVkx6EDvRfvq5WpmDHso5rIEP0sNPaL+vjYTAmWNcAg9VeeOVvxIeTumUIfk8hMK1mdcfnnmERjtpCI2oMA77qd00HLPur9rzoNZgA6I0knJm7uJzthmQ+zz9MCBHQ+Nv3FTy9l3PRzOlEsOvXn9Phz6ugPSYgu53yEHY/wjto7lBLaTktxfiFGThKGcXER5nsNdqR+GHW5g6U3bCSWd3kER5uGMFsmIo2QLUZi/Dkg==
Received: from PH0PR07CA0021.namprd07.prod.outlook.com (2603:10b6:510:5::26)
 by CH3PR12MB8354.namprd12.prod.outlook.com (2603:10b6:610:12f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Tue, 27 Aug
 2024 20:16:19 +0000
Received: from SA2PEPF000015C9.namprd03.prod.outlook.com
 (2603:10b6:510:5:cafe::2d) by PH0PR07CA0021.outlook.office365.com
 (2603:10b6:510:5::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25 via Frontend
 Transport; Tue, 27 Aug 2024 20:16:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SA2PEPF000015C9.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Tue, 27 Aug 2024 20:16:19 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 27 Aug
 2024 13:16:10 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 27 Aug 2024 13:16:09 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 27 Aug 2024 13:16:08 -0700
Date: Tue, 27 Aug 2024 13:16:06 -0700
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
Subject: Re: [PATCH v2 7/8] iommu/arm-smmu-v3: Implement
 IOMMU_HWPT_ALLOC_NEST_PARENT
Message-ID: <Zs40BijzV6MCej5E@Asurada-Nvidia>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <7-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C9:EE_|CH3PR12MB8354:EE_
X-MS-Office365-Filtering-Correlation-Id: b5e4a4e1-bad4-4ed9-0765-08dcc6d51cc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?123b9jEIArrpt4PyYOXUMgw8bEca7lyWmCcwG4T5GSlBycH1pTi2GgEGalyV?=
 =?us-ascii?Q?jxJtTE4xmrQ+oOuUJhycWOnujWOuWFsy0JSVbogOVzdubUv0897g7eDkGaRf?=
 =?us-ascii?Q?wfsstEV1B0XCBrd0CqBxtALDU2AzTd+8L/1xV3ziudPN+mK+ihOhRdG7b5bN?=
 =?us-ascii?Q?H9kib5zIu9bV06oMl01pe9VJXjpLmQkIbuGYuhbHdZFQAwe7xB4Y+65T74hC?=
 =?us-ascii?Q?AgvFQPTE/DtT7SLrTGJmkQKfGqcH6lW8RFPDlR6sBLTRh+bktWlBTtonc/Xg?=
 =?us-ascii?Q?7tvGkeONhbEVACLMTPRddLwONGQI1jwd11j/5mCseC+UiailGFFAXdsaTlTj?=
 =?us-ascii?Q?rPDEJWO5s7HjAqnVW3FzrAY2d5YKuEO31spv/4TFrCvQJrC7JN3GVSmcqJJJ?=
 =?us-ascii?Q?pCBIG94OkU8F9GUdUFFmRTCKDonN3kAo+g5a+j1mn+dFP5/Z9CJS30zj5a/I?=
 =?us-ascii?Q?iBMhumlsHiovhyeLG0bzH9J42CUK4cf3lUlWRU8CdtkmRN/dZCLX/3bc9WNr?=
 =?us-ascii?Q?Iz5gCPk73ire52HBT/72AlMzZm7FQ+4MaY5VTM0KaSnbDauBeYde/8XFiOtc?=
 =?us-ascii?Q?HQMbzJcQ7Q0r+1EIEqyV17i/A7P05ne4bG0Vw5wfpFsXPxYjzt2148oGUp02?=
 =?us-ascii?Q?aJKLlyD1oZw/Y1Q5Iuhfgidq4egmI/8QP24RvHrIt0NkKefDNSCkd1tb1U6D?=
 =?us-ascii?Q?hJkH8kLKe1VkzaMvXrvJH4X7n3Y/nwRMKc+lDh9NiW8QwuIrF8jIhSb5hX1z?=
 =?us-ascii?Q?ou2zhEqqVddhbyTfJYgka01pHS5fcf27ZGonayw5w6G8g3fB4mLyoYdj8U9F?=
 =?us-ascii?Q?nYPRUjV1mfQu7kOaDiARF6bu3l7sEbNM9CkbhL1DttnQ/TdCvehsBWFzA0/1?=
 =?us-ascii?Q?3OmmEXBOm82pu+xUxErRPoggKEYiWxBfLmrd8+OMCcA220/rC5kQvhAfiVCH?=
 =?us-ascii?Q?WRjicXV/5aqRrnabDodYsOABLtKa9rwcQwsOS5eW4TfMvRQ3wXp4+ON0zD/c?=
 =?us-ascii?Q?tNwBnmdcsE5tE/zID4dfh1Cwl+34OB2kbmoDGPJ9ChWNPfE5zLxtIe1pp3La?=
 =?us-ascii?Q?0U+PRmVwwLkIB4tnK2QKsQO8uatqPnZ5YYT4EbRdRU33l2nrmIkB+F3si8sd?=
 =?us-ascii?Q?L8GsVuAh+j9kqlIC1nZ+kDs26ZdHsMHJd0vnpISQ98WZXNp2nipxKKh8ttyw?=
 =?us-ascii?Q?1sAxud/ErSGIlumeiYRb3dw5GYdVCke6cE+tUY7xYQw63d/H/gLbvALoOXHZ?=
 =?us-ascii?Q?yxCJCdA/xIGnObOjV8k45UCJeksOPD98L3QbkAPwzsMTrrNUtaslxsvynwuc?=
 =?us-ascii?Q?sst8njJn4/we/KVIsbcLM2syA0WRH2p2I5v6PPgjue+KtttaFfy0nA89sFwr?=
 =?us-ascii?Q?3tBpDcJrVjLUw2vYFY8JvL+pJQDVp9uPqec7xm2UpVAI1sEzbCSDujyPlJDA?=
 =?us-ascii?Q?LXjDcJo+rFeruCnXJzBLGXwDLYP2u6Cv?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 20:16:19.0795
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5e4a4e1-bad4-4ed9-0765-08dcc6d51cc1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8354

On Tue, Aug 27, 2024 at 12:51:37PM -0300, Jason Gunthorpe wrote:
> For SMMUv3 the parent must be a S2 domain, which can be composed
> into a IOMMU_DOMAIN_NESTED.
> 
> In future the S2 parent will also need a VMID linked to the VIOMMU and
> even to KVM.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

