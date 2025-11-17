Return-Path: <kvm+bounces-63412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A142C65F9E
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 20:31:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9FD064EE62B
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 19:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAEE9332919;
	Mon, 17 Nov 2025 19:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b5WhB4iI"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011047.outbound.protection.outlook.com [52.101.52.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225D138DF9;
	Mon, 17 Nov 2025 19:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763407701; cv=fail; b=RofVj7wlVcZBMe7M20DQI2zdYFECX2I0mE/DJha11n0pF7tXyZE44Wgq3WY5vh4Krx4TeBAe2E3nM/HHbefsMnaXBW2K1UJPtf1UbpYj2UxvKhyLwVv5e+FRrR4lpuCja5JIwgS3BjaMAPenr+wC81FwmmLi18YBirFHMpHDuXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763407701; c=relaxed/simple;
	bh=3NvoNggcBCBmWsLL/9+km05mi2yv9/QAb84MkZVQSKM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rFtRe7lPPT1zdjsYCIA2Xmbmi5vAIaSxJaGqeLAGeulPAZtn5M4rx2VS0CUlHbcbgVaalNJSEakaPqz9afVZNucW7sf0xGAHwVlhK4+mooC8YzsYdwe9f6PfAl6xZ/GdPLU3RVjbkXFpjTfLzFArUBXTtrIhCgSnAhSBb2UQJ7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b5WhB4iI; arc=fail smtp.client-ip=52.101.52.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mPZDDFEuqAD4NEovi63ll4XEvLeyJ23RNBvL7D+3Bn+7aICoM33/ftgcKOtTqKc1EdVz+arijmsMgJzM15XgQ+cDV+fzTbNuutm6SclO9aULLrfHlPXa9js+O6ZYi/8FgJH8lFpi4xjl7vAPZRcsnQJ39j+1bmtGDiW6/IalCk3qkzviXp50swx2NFM7MdaSPkse01w5afPm/9yHFIt40QjE6kzeuIvJJRWpuxRVY1RhJwWhQN1rMwiTE4GKBEfdpfxnpMvnOMVqppRDXdQIZM/kUP8PvZrXTdqLKuUf2Wb0UUnf5+AYgageSS3fngFxHYCVkkkDfVSnKMNmIiqC7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HiwMZ1ipvSzOQItCr38RgrwRsNhCiN1R6Lz3hNnXM0s=;
 b=FAKWCVlwMbaabtngy9c8xR3obGbNQWlPiAEFvp0vtOiy0ct7c5DET3kphJWCY+/gqpsGHcBQZiWCYwEkGrYws3KayTXaetEvOJPXc6ubPaILLDJhKTugcJZxVAnV4mlo4Bsozba0+obTAfzX4SbulIG4AKSYRo5/I6PlBgoJkGMfvc/gCZ9a5AZq2T+jmWYkpT7AALqMkiXEOAIeJUjQN1n9ZrB6FXpexXoQM/AWMKatA+NU20YSAXFHCIRLg+0RE9Owz/WKkpVtHo+d/eEag3upCmNLlXN3R2FTNdsjPuWp7XJc2HdgF7uJ1Qdvn4Xc8tFwbyPhdPA5upzfGKo8Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HiwMZ1ipvSzOQItCr38RgrwRsNhCiN1R6Lz3hNnXM0s=;
 b=b5WhB4iIKo4AdBxGPRgqprHrbBOPptYZWTq7cmsWNJHEgdlaRQezNBje0Kei+Xta81aBumDTUX5vpMW1DbfBEjlPMepW4PB12NMjfUq8yVtwpMF9fGCVSBkx6E0hh/fmkeH/yOBy/ILSX2vVeTfZl6Me3XIYGq4HJxDzWRABY9mIXmPiZkAyWVB2sKgGzfIQZOhb3ZH71j9VQVD/LtKYSCclfBAe8qvFuCPH0VJJ74YROLQYNmHDfwtoA5miB5JTHmHnZwg8n5bFsxIiHUbG4t2s0wMBP3gnGyEqnBQDiXgb8CQ8RcIfWlxYEdJRPAfDM3Sjv2nW+ZYTcGMhIwS+LQ==
Received: from DS7PR03CA0018.namprd03.prod.outlook.com (2603:10b6:5:3b8::23)
 by DS5PPF016FC81DF.namprd12.prod.outlook.com (2603:10b6:f:fc00::644) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Mon, 17 Nov
 2025 19:28:15 +0000
Received: from CH3PEPF00000012.namprd21.prod.outlook.com
 (2603:10b6:5:3b8:cafe::27) by DS7PR03CA0018.outlook.office365.com
 (2603:10b6:5:3b8::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.22 via Frontend Transport; Mon,
 17 Nov 2025 19:28:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH3PEPF00000012.mail.protection.outlook.com (10.167.244.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.1 via Frontend Transport; Mon, 17 Nov 2025 19:28:15 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 11:27:53 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 17 Nov 2025 11:27:52 -0800
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 17 Nov 2025 11:27:51 -0800
Date: Mon, 17 Nov 2025 11:27:50 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: "joro@8bytes.org" <joro@8bytes.org>, "afael@kernel.org"
	<afael@kernel.org>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"alex@shazbot.org" <alex@shazbot.org>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "lenb@kernel.org" <lenb@kernel.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Jaroszynski, Piotr"
	<pjaroszynski@nvidia.com>, "Sethi, Vikram" <vsethi@nvidia.com>,
	"helgaas@kernel.org" <helgaas@kernel.org>, "etzhao1900@gmail.com"
	<etzhao1900@gmail.com>
Subject: Re: [PATCH v5 4/5] iommu: Introduce iommu_dev_reset_prepare() and
 iommu_dev_reset_done()
Message-ID: <aRt3NhpODR7mz2pY@Asurada-Nvidia>
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <28af027371a981a2b4154633e12cdb1e5a11da4a.1762835355.git.nicolinc@nvidia.com>
 <BN9PR11MB527668CC33F2356E689AF8F38CC9A@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527668CC33F2356E689AF8F38CC9A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000012:EE_|DS5PPF016FC81DF:EE_
X-MS-Office365-Filtering-Correlation-Id: f4381474-262e-47d8-efc5-08de260f74a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zf69GiL7MMwjzvF46tDQIQQTSOtgFxVJg980/zmeiQxRIoMmSh1W81m/LUYj?=
 =?us-ascii?Q?XYkqiDzT3GQQf2Yg3DwuoJPM0JXvKBxxZGXSPtBRz/vPwm1sy+5YvYMtInQo?=
 =?us-ascii?Q?X4pLcpc5ly8pEEZb42TtjXP5ynsYatLxv6nf0L1NzKhaapg7wB3dwlbzhr+T?=
 =?us-ascii?Q?6Ewgf0xNpc3botBmAsQtriP6iNNaKVD0BqCVqGWbm3A+WjY8Gh6MWDXlY97M?=
 =?us-ascii?Q?A2KAjmHlM6gj7LmMk7Zq41Hs1cFJKxMEdSP6K8cenB0kNYW/DDnTy3EproOE?=
 =?us-ascii?Q?TSAAOm/+RaOFapmMeWgLYySva1t4dNhJHdaym+lfQf9k9kHlW4jXkmSx6uID?=
 =?us-ascii?Q?l+tZP1YV/nrKdNASpqK5MQ3W/0Q/6Y3q5uUjJBsRrh95JnoYe/pkO6TkYnFV?=
 =?us-ascii?Q?nbrr2uibSXWxIpXamoXq5IFQzqued4dhB25yNqg7K6I46gbDijMnBcvgRVvB?=
 =?us-ascii?Q?7WdQ3ypmZGyDQoD5BVEKKPl/1LnhOw8noGdxsNitIyvwiRkz1LAdBTZJorDb?=
 =?us-ascii?Q?PfOV6n7dw7LHtbPZ5b98jYuMe1PixhM/m/UOHlBrkuxTE5Yzn7u8H5hrXFgm?=
 =?us-ascii?Q?O4W+ujoU6fk2NLu6dO2M3rswKqHqGmwkExDHdwbCXiNacjBhLjiGKbqLeTOw?=
 =?us-ascii?Q?/CK7olHEQPAfmikvUu9IBaC61/Dq/H6F7wbi8wAwm8sAMLyd4uZNLus2nQqW?=
 =?us-ascii?Q?7iJBOwwQAt1uTzNb7Gi2jihpM3OSktADWst7rXsmuF/rE3bd+d+hn6hssDFM?=
 =?us-ascii?Q?dkkUh2AaXPOwkvBKX8ttuJD3Z4UTXOq/hLphJw/uwmOl7eFR7EcQK36uNxFe?=
 =?us-ascii?Q?CszADy0TGfoDNXUQc2Lou2LcXXrsXkH6Wn0ziO6GG3T6oFugqL/4lmx9gpA9?=
 =?us-ascii?Q?P/TeZpMYZlH4z0t9hJT48Vu3MpwLb2J+cC+Ya3qOMFC/gno+CB0HtEaR1Le8?=
 =?us-ascii?Q?BkIHbhquHvgKnIxdcipxAptXPn95yfUke8W8c22LbooJsRLZz4yPVIJA9LJh?=
 =?us-ascii?Q?B5TPvPLpUCAfIb6I0w95cmgahWeMNVoeNvsVYr/iLZWvZGa56XjodikcvvEG?=
 =?us-ascii?Q?+lLOEdhpCxNDLY+0bD2kAOScXU7fYCNFDhG9dvy9jiRS27Bubo/Dkl9k/fLd?=
 =?us-ascii?Q?CDq67+KMBluQsbKICQ+9m9GZOc3crebBSM1IMcvQ34AuWqLB+zNOHWVKufDj?=
 =?us-ascii?Q?Fn1rIoQkVgvQixP3NQ2d1mV8RD+EG30SCq81oCgOgDSXRggAGfWiBNSLmi2j?=
 =?us-ascii?Q?UIkjjkj30GE/UERpHZXIBKNp0Yide43vS+EU5UJxTFN4dw0bOjohEDbyLqBr?=
 =?us-ascii?Q?3c6cTGPgv8rteE9KA+bKJy4ikFq00GzQ2qIwaDwEDxh1HbAJN10cOwsZaNs8?=
 =?us-ascii?Q?V5gpLHIz37efvtwf7JN3Jhb3LIWiV+R6k5rACPH0jS/3n1WH8MhzwUOM9zUx?=
 =?us-ascii?Q?vxQEUH9mY7fbvyuyAR9vOc8q7pMeBu1J9vYZl1dPBt0fjPQL/kh8iy921kZl?=
 =?us-ascii?Q?c/ihCrvZxis+MA4A+IQ+vPn8d8rSSquqqLtlmLJ9MAKZ1EkXXMie/VI0pHUl?=
 =?us-ascii?Q?vgmOeLPxtC5utFhVhxo=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 19:28:15.4841
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4381474-262e-47d8-efc5-08de260f74a0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000012.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF016FC81DF

On Mon, Nov 17, 2025 at 04:59:33AM +0000, Tian, Kevin wrote:
> > From: Nicolin Chen <nicolinc@nvidia.com>
> > Sent: Tuesday, November 11, 2025 1:13 PM
> > 
> > + *
> > + * This function attaches all RID/PASID of the device's to
> > IOMMU_DOMAIN_BLOCKED
> > + * allowing any blocked-domain-supporting IOMMU driver to pause
> > translation and
> 
> __iommu_group_alloc_blocking_domain() will allocate a paging
> domain if a driver doesn't support blocked_domain itself. So in the
> end this applies to all IOMMU drivers.
> 
> I saw several other places mention IOMMU_DOMAIN_BLOCKED in this
> series. Not very accurate.

OK. I will replace that with "group->blocked_domain"

Nicolin

