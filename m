Return-Path: <kvm+bounces-63657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 233F0C6C813
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 04:02:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 585F24F2EAB
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 02:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E9CA2D373F;
	Wed, 19 Nov 2025 02:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FWEAaOKY"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013043.outbound.protection.outlook.com [40.93.201.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585F925EFB6;
	Wed, 19 Nov 2025 02:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763521060; cv=fail; b=nDKVnJGNBeEAnlU40zKiuTLG2HACHvZ06P/+ipQJ95+6LAc2VBOFYg5tXa/ITd8yoW3bEjXzQ+7dkMNDQc6xLguaPZ1wREuEPJKFNm/2WfdtdiDxAkYU7WnaDm1IhRVsyiwS4oSJTXL0jyT3gOVB7SH5Bpp2CGithXRdGzqvSQU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763521060; c=relaxed/simple;
	bh=fQKrVrwHRKLhnEMM5gHKRGDSiCTkaqgqzHYOdDHaPmI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eraJlb4rwL0SJspnkWiX6FffdAR9PKUulhGE02msQ6VbZdf/jXzydFrcT60uLdymds6zXnKGVOlcLwHaTWTAoOOWStYAnjn52yYn2NY/hz/fI111BA6csSXWGlHRl9prMt51FE+c2CqoNfGN6VAZO0a1ym49hjnUiIQuUbSJsS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FWEAaOKY; arc=fail smtp.client-ip=40.93.201.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bxm3RXxvubiwG4dOPhIVnJPy8h8SFYdyUflcBn4Ef8t2snJLVzEE/x0F8QQr11Kv4oY53ZliRK6niX5SJZGNnRAdwb0U8IhdLohfzb+a2djntIuX+xA/LwrwLPvkGDAnU5WFijHDv6eSIk6ZfuoB+LC7ez6Ovj371kmVgrWxv9Kgd0HeR99JgUx4rGEMo/LzwQg5Rt+8Y/03kNIoQMmdrc5nCri7WlXSNPDoFvrgaBIPyXTmFe9YU9STv46FziyJSszgtK8UPTwMrrny16yWWy0LDYWz50jBo5aVEyZN/v1tMb0NcA8NopvOJi54brUBPpZ67a036ECVthAt5D+Bpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nKjwVPwmJFzJqbdbyIv7KhtlryrsG3+BBiTqRk3yV4E=;
 b=HDAgRmoYx4bxUWi1RLfoQ5qqa7imxTLA8eSn3R7ySf9tGDVhWtNlv0iRZ81CmjJo7YKHlEFOowRdvNUV+eeK3OGIq81bXUGPmcEniIbN4T4uNij/TBFPzMyS5gSGgv0zGkX0iYM2ipVM241exCxkqdbAs1oPtj+l2rNZAlNG6UHNpZK5Gpx63WnQgAVOhWFHx+vpH3evDiLuGH0VCL1RFAh/XtqYhdbU/zgM8sHEuO9gmqrgMr0+B8beMSJGxmg0IcsfbIZ/fOC7yL2CqxMmT4HPwb8lQxo9FRh+5Rs4uh4f7t+0cv0N39rQlnidElDms1XeMvdT0+bOhbuzWYjO+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nKjwVPwmJFzJqbdbyIv7KhtlryrsG3+BBiTqRk3yV4E=;
 b=FWEAaOKY75gJSAkXUqzqb1Lk/+MJb3IOz+gqWksdkE0tjwpmpy9eqDRHiEIEYQGfWrjJEriEvz5V2dLeAMpazYPCFxMxByOmzL3M/UMbJ2tw6n8K+meWP8WWhnwsDGC3al/DMWJEh800XLfs3GFJSAGrWTtsJv2voxp0BwWwXi+CXkzD84vZjcXcMLPmS1dpDqvG06nr2w3XLyxNeprYG5eLqJ0RzugEk7CndBb6zXNVJrlWzrAvTo4KfSrxkiJzL4Xb84lE0dVIZZqnneqhXRY3sfkHRiXV5aIjcG0fxMhXdAxf0Bu0DdFQzuhy3fobWwqohAJKLyD7S07QeOvcJw==
Received: from CH2PR14CA0043.namprd14.prod.outlook.com (2603:10b6:610:56::23)
 by DM3PR12MB9349.namprd12.prod.outlook.com (2603:10b6:0:49::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Wed, 19 Nov
 2025 02:57:33 +0000
Received: from CH3PEPF00000012.namprd21.prod.outlook.com
 (2603:10b6:610:56:cafe::f9) by CH2PR14CA0043.outlook.office365.com
 (2603:10b6:610:56::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Wed,
 19 Nov 2025 02:57:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH3PEPF00000012.mail.protection.outlook.com (10.167.244.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.1 via Frontend Transport; Wed, 19 Nov 2025 02:57:33 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 18 Nov
 2025 18:57:25 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 18 Nov 2025 18:57:25 -0800
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 18 Nov 2025 18:57:24 -0800
Date: Tue, 18 Nov 2025 18:57:23 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
CC: <joro@8bytes.org>, <afael@kernel.org>, <bhelgaas@google.com>,
	<alex@shazbot.org>, <jgg@nvidia.com>, <kevin.tian@intel.com>,
	<will@kernel.org>, <robin.murphy@arm.com>, <lenb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
	<patches@lists.linux.dev>, <pjaroszynski@nvidia.com>, <vsethi@nvidia.com>,
	<helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: Re: [PATCH v5 3/5] iommu: Add iommu_driver_get_domain_for_dev()
 helper
Message-ID: <aR0yEyFoKQk7AXcx@Asurada-Nvidia>
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <0303739735f3f49bcebc244804e9eeb82b1c41dc.1762835355.git.nicolinc@nvidia.com>
 <d5445875-76bd-453d-b959-25989f5d3060@linux.intel.com>
 <aRTGwJ2CABOIKtq6@Asurada-Nvidia>
 <aRwaHMcgQNqV/cCG@Asurada-Nvidia>
 <69ebd6cc-7620-4156-b64c-35ae1344d54f@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <69ebd6cc-7620-4156-b64c-35ae1344d54f@linux.intel.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000012:EE_|DM3PR12MB9349:EE_
X-MS-Office365-Filtering-Correlation-Id: cd9d1163-36ff-4a91-486e-08de271762fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4eK6mE6CB1kvtaSM+Jl5kn8X751w5m40QcHkx+uiIIYyH6EpdklI4E7WRw3T?=
 =?us-ascii?Q?KS18WmHCAyDnW8vkBYKmJuwqb06c+w/buuai8cKWjoZprft5YDUBJQypOOTY?=
 =?us-ascii?Q?ob7w0XrP+oCz6LKZ6X+5XlPnNhK5yr69AQQbpz0moOw66wvXccaSCBF0xFIQ?=
 =?us-ascii?Q?a2nf50R+T8rgTSGroJmxIlei17v9wsrHDpCwNd+wo1B51pNzebGnl7kRS5WO?=
 =?us-ascii?Q?/lrfMe7ERx7R/RGv6nK5Uegu8Nv4apHfQA1Z+bx6sYeScr7xoMyXJ7MawL9X?=
 =?us-ascii?Q?Ph0nZ6x4g59KFuaWuHpy6bBKoEVfxlQ+HGJ8GxtljRU1mlphv3gU/gPBixlM?=
 =?us-ascii?Q?QbVUEMt3eIhloUzBfs7hQQBrKplT+pTsK+5ed2CkSQK81NcQuD0tj8KIDxDK?=
 =?us-ascii?Q?wYIzRkGRDn/H7ElQJY1tw7pZ2RH7hiJ5BXydr+J7/WfO+6nzvCuzjoJzTKrC?=
 =?us-ascii?Q?Wa/a4a+w9nfY2IiEu4DwDv63TxumLhukVb6JkO9xgps+hz/xPO0Gi4HJkGDl?=
 =?us-ascii?Q?Nd6+cdmUj+671afY3vmK2luwKvDA8UPQ9avkNRF+cdlyC5qf9qVJNEcRRAd7?=
 =?us-ascii?Q?UTrKpGID8FhzrotXyCYbtCjKQz1ZcHvTv8y4kyvQa+oONBhC6wkKiVIgvZqT?=
 =?us-ascii?Q?DlCnkBkUiBaIJQaGqX/+9gn4CaJWm4+ovG9v8e1cpwJcNxkBaqlJN0cI7Jtf?=
 =?us-ascii?Q?lEZDWawVHyBNmlHP0t1eSCqdGIKY1dJ6d4Fku7F44TEW31r1LSyqEH5ZTgYe?=
 =?us-ascii?Q?EmEYGt2b1Ir+ctvMZAY3SigdrNPKHTG7nG2iaCakZl9NnxZnyjiMnhJOR2Tk?=
 =?us-ascii?Q?FhKPDGggQ2AVoaZ/yMaFehVND1m5KcjKdGpLtmTHYQcRO8VheQ0CsYT9/XFt?=
 =?us-ascii?Q?IjxVNDrGYpZRgTuG31lq7Fa+2DBy5ua1RLk5JjhBnbscDpSBJ+QyDVRocJ3l?=
 =?us-ascii?Q?TNaj6NHrLFZ7mW625KuFMPp91j9mOw353LEG2e89nbjEgoZTu7fBYMGMyz7O?=
 =?us-ascii?Q?Ze0WFjVpPcvfmrYJMrzyAzPfKp5sLdctdYh18smzoDxSmgJedaOTWRlYY0k1?=
 =?us-ascii?Q?Pm0999EOsSrnI5A3b5jzlBK5zeXFQX0wD/dsu59u1MeCdWKiJrABYgZDNJDi?=
 =?us-ascii?Q?eLMLuReE6ccQ+HeIpZRo2T7NYqFed4QUFZY/FtzorGQtvETIfSdoXH+X/zrz?=
 =?us-ascii?Q?ggpv3OI6eN8BrH3+TyayFIsnYf5+MNpE/MeAFOo3kqyIOlj6U8LJhCPwtVdl?=
 =?us-ascii?Q?z1fXx0XIow+UI0tQZBrpKGs1Rd2ubuwG3sCJb/DT0oVv848v/XRIH6VHa3/S?=
 =?us-ascii?Q?V91YHJECYvLASqcBr1AVkqdyJNRz88XknPy91HjQoRSNa9S1NfAHOK4kP7+u?=
 =?us-ascii?Q?BVseQX9EKaLleAXpO5N3mt5GSfhm9kRYrbpRePHu1Xyz1XxyvzBwhk+9k4qj?=
 =?us-ascii?Q?/Doux6fYlG5cSqCnI19rXaE7NyEpsiibclTUS7qjwDmZ6xSMqTI0zq8Xp4Is?=
 =?us-ascii?Q?5O2/rzGgETUgLBP9Pd9DiEQFekx5T23Cc02unWm2bseG+YX5xkqaz9f945Ki?=
 =?us-ascii?Q?WnLTuPeR7gMxohjpG7k=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 02:57:33.0345
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd9d1163-36ff-4a91-486e-08de271762fe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000012.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9349

On Wed, Nov 19, 2025 at 10:47:26AM +0800, Baolu Lu wrote:
> On 11/18/25 15:02, Nicolin Chen wrote:
> > For v6, I tend to keep this API as-is, trying not to give troubles
> > to existing callers. Jason suggested a potential followup series:
> > https://lore.kernel.org/linux-iommu/20250821131304.GM802098@nvidia.com/
> > That would replace this function, so maybe we can think about that.
> > 
> > If you have a strong feeling about the WARN_ON, please let me know.
> > 
> No strong feeling. I am fine with it because the comments have already
> stated that "This function can be called within a driver bound to dev.".

Ack. Thanks!

Nicolin

