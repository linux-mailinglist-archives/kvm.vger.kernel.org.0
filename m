Return-Path: <kvm+bounces-64550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44EA1C86D0E
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:28:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D67703AAD7C
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 19:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA93C338921;
	Tue, 25 Nov 2025 19:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="frsl9wax"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010025.outbound.protection.outlook.com [52.101.193.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45621337B80;
	Tue, 25 Nov 2025 19:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764098914; cv=fail; b=bBDGu2CM7MJROzooaayEaWU+bR9UkiDrB355T75zv9/ouDw0Otl/1hCnS5fLRjYQy+LXVoQSQ9RJgles6J/iT4zIrXh8axAYGmIoME+kRLINnGzlVAio9m2RgdpSvO/jB1788Q9lDGmb+Lv1UiG2q2xucXI9vaTey6mScGcXHbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764098914; c=relaxed/simple;
	bh=WjD/7NNz8kuz91cInhFi+0V8HFkSSlVjd+Hjy2Bc9Q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=R1hYEscLrWj6cFBKka+xEpcjpR3+r6iyUZn/5k+Zprgqh8nahlKCPuyaVMMJvyqUpHUfd8cbrcnGAd8143TNAQcCGPzATJEu2GVKWIp/rB1ZzNNIYPWAa3yQdGknsdBGCtxZgPu4E4F4vy6HuN5FOIQCfJHAIPpEfVR1qlk/3Fo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=frsl9wax; arc=fail smtp.client-ip=52.101.193.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S7LUIjsOqhYXGRwh/21U9MQAVKSeWzDmNXO/EwQCzjKPLLuFKyDAqW9QsxdePl3UZRxzBxwEwfVbRJCJulM54gk4JPHHS6hwXm6QztWUxNAITc0T4V9ti+RUkjj1HbvuW6kqsX2yclne5AIwU4OqRhEA/msdbEGhAfFvxEDv5P6H7Nd3qVDbuBvFteYNzGZ0Nig6siS17bmDRt+YhE9JKcMREVMBt+7nQH3ITlsGSf6NxjrMURBRXlwdGcgF3KlgqIFZRPc8xT2PExpAmvAscmYHkxpKIz0wzUfwffaOZk3rB/M+5o+/KeMx++CJjoq3jZZHuGpaI+9qPEd7v9ekLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J/HAsNDQj1qE/ffAZxv18f1V91dREcJYRt/WA/SuQPM=;
 b=k6U46vVN5CUIcHJNqh6eD46qY1SpqdakLWi1t/Y6A6AqkILNLvkkwvo3SnQoFacpyegtG91eUAtjRqdh4rVkkwEUhW2C5IC+86PA7c0j7OAddFn0/p43HeUR+3cIbcRzrizNzDF7YQGFAH3+4kou/etkrSAs3NicTZ3WJMfG45F+Ss5PG4A0cAg9zhy3wLbCN4vdwdI0I4OfvxoRNREDhWe79E2u1it1t3mktgagwLsMoEkxtfhE2iU+w0ApugTCifKdNbgbXC6FVX+piRUmQbWzkbJCr0nYRnyCtZ7RrkSJIkJhe50GnX1euGEC9EwXdRYv/aLhTCWjckp9Avo7+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/HAsNDQj1qE/ffAZxv18f1V91dREcJYRt/WA/SuQPM=;
 b=frsl9waxJUzdOpRrf/+89N9z0H2s4WIx1lOKDEZh9eEY+6VQDZsWKTdtG+noOTBwUawOdGbzUEiDnQ+4jaLAhbBeIe23R+GAU8vPbaRmz0RDSFY2AhwvMUpspM+zlexNB9WJGWbli6e2vpWGxIlF6Fh3V6fHPbWF8tCX2dz93JzyO+1fhJdS2IRCeqf68H8M++CLeJESHgjFgFc7cTQvHfNRhaRnPJJyl9htEMXqCWHGG47t0cdzNDE0kWt2m4IRMgQLiY2O4THkrg9g1CxzzlsptWwWmT0RgYvcjGQ4gdWC5x3pX0U52cK4ImAqcqlNSqRVoKyoma3ZSZemE+E03Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by SA1PR12MB7221.namprd12.prod.outlook.com (2603:10b6:806:2bd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.16; Tue, 25 Nov
 2025 19:28:30 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9343.009; Tue, 25 Nov 2025
 19:28:30 +0000
Date: Tue, 25 Nov 2025 15:28:29 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: joro@8bytes.org, afael@kernel.org, bhelgaas@google.com,
	alex@shazbot.org, will@kernel.org, robin.murphy@arm.com,
	lenb@kernel.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	patches@lists.linux.dev, pjaroszynski@nvidia.com, vsethi@nvidia.com,
	helgaas@kernel.org, etzhao1900@gmail.com
Subject: Re: [PATCH v7 5/5] PCI: Suspend iommu function prior to resetting a
 device
Message-ID: <20251125192829.GG520526@nvidia.com>
References: <cover.1763775108.git.nicolinc@nvidia.com>
 <4d2444cc52cf3885bfd5c8d86d5eeea8a5f67df8.1763775108.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d2444cc52cf3885bfd5c8d86d5eeea8a5f67df8.1763775108.git.nicolinc@nvidia.com>
X-ClientProxiedBy: MN2PR13CA0025.namprd13.prod.outlook.com
 (2603:10b6:208:160::38) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|SA1PR12MB7221:EE_
X-MS-Office365-Filtering-Correlation-Id: c3dad913-e97d-4020-83dd-08de2c58d078
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tXfQLkEi66AErwbb5AjLZ6fLu5x7Jt2X6l+dQxSWdD9k2xbeg3YAZYkb7fZP?=
 =?us-ascii?Q?+Gq8ez+VhFHkN4dn0daEj2fM99YMeX6Vljq0BqqJJcHU8zOuuaSREcC8hSrc?=
 =?us-ascii?Q?8qUg8UuMWA1jrExV/5B5h9TCVXMcQX1My+v5ikwp0VFTeFL034kTP9plPwD7?=
 =?us-ascii?Q?OeknzxrZkJscRz2E7MAh4zhO7e5RwVbBLDcW93Q7iFE+bhOcsXPWOtMskZva?=
 =?us-ascii?Q?diYDLPmRaRjyXdMk4C+u5RjzOtG6EHKe7M9yFTU/0ijPRgJQoYs4fK6N2Fv+?=
 =?us-ascii?Q?SOH22U6SlWFgr8lwaLE29dWAAeN02Gia13fiJWwRSSe2nju41jknLlT4It68?=
 =?us-ascii?Q?dYjxwOeDUBnq4+7NynC27/J+J0ENgRpYmNSr6X2A8xTVNBXn4cO1jSlgvW0m?=
 =?us-ascii?Q?TwLAuJEp+YXi6dXYYo4d0LMoTdgYFkYSMED3Y3QMf9neAwtEx3r7w8L5cJWK?=
 =?us-ascii?Q?+88T/wUvTpaQd8RGzs8P/w55UA/Ozzkg40tSfFLnVSnNGez+s0ZhPDETI1SG?=
 =?us-ascii?Q?p1UtI0fVlWenOd7CiWd49nmdHP0r+4HYNxprK8hGeJcrGXITOp6wjFwFP07J?=
 =?us-ascii?Q?P2nrsR0avY5g87/CQ5Og7G0RCmNHAtQMEsGOL7VwhHhJOnumGUf5v9/ZDv6f?=
 =?us-ascii?Q?rl/D2HMVoj1VTFXC1n0lXUrK/y3kJ3TpOPqu9Tu1lUP1+u+i6C2X6E4gU4iG?=
 =?us-ascii?Q?eSzJRGaDYwqugBewLdCCyGgJ0ZP1Pcc9NSLR84c6cVPvRT91p8wfWQUHVsn6?=
 =?us-ascii?Q?eHpgbZl9yKIWj4GTLGLbyjxN6+WaowP3YnT99CXZXyNfa/UsNoYEMS2PcxKo?=
 =?us-ascii?Q?r/DPju4E9cF622WaT3F5d1iCrzPNeltKY5TmHmB8wBq+AjEk35OgGQ9g7ABM?=
 =?us-ascii?Q?ck5FqjOcszLvrPSENETcQ1nyNMcBkbApraMTAaNiFKUYqhnV0DolazaEBlrj?=
 =?us-ascii?Q?NDLfoE90zWXXEVpy1UJwk9Jfczym5Mf8lrjdNfODyuYJYFXuvPMgWrk5T2Qp?=
 =?us-ascii?Q?9sIqAKsI+F4A4gxzbYghFH+S5JlkvljfM5dhPpwMQqOSA2Dr7m3bFaHMfbPk?=
 =?us-ascii?Q?E+STmliOFChG+UEmro1YoWzlENHVyQg/MejlOD2I+YUKiMjbbgBvjXgzNfkF?=
 =?us-ascii?Q?gvyi6SZI1RmKRpPRmUzbRjpXCfWPQo/eCBP0zmTbCVmhUkWfTLuLGntspr7Y?=
 =?us-ascii?Q?Pyn8kIFADHRJEwcYiTcOTgqUzOoj680KWQj5HPpDTvvf6XI0zUAWH7HOvqkG?=
 =?us-ascii?Q?vCUmp05zB1QNGYh+ua1XN9kOYH4UmErl805V6JACdml3E5R+mhkslXE8RdOq?=
 =?us-ascii?Q?NOWvVxLKwLHqWLQQohl8JAypGBS4xhspXL/f4VBFvolw/78U0WSdFyXsXypP?=
 =?us-ascii?Q?KpWX+vejrX9y+dB5kGNdRUnYt4S2DSBmKrLpSzczn+uXlSvtKl7pojroJxTf?=
 =?us-ascii?Q?Dc4Re8lDUloLMoWQkQ7kZiCfLQro++cz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/0QTmTYCWzns6T2JwJv0xOQXih8OasXyuoDlrpDGXCkHL94pdLiQA0/yysE1?=
 =?us-ascii?Q?kDKZPPSCaYVTf2ng4MwgCbeWA4ppYLDpUY52MZfvRjUCEFZnz4OtUvOEkuHK?=
 =?us-ascii?Q?U4p2EtN2CaT4o1jB+/cl+ihmH6gSPmZQLHH56nWntPSvHk7CyyF9SVD8wPOX?=
 =?us-ascii?Q?5e231jSHulIX3DxUb2RMMVPcILGv2BhHGejPBEndAJTM0kzrFuYhfewgk6Nb?=
 =?us-ascii?Q?MqTEglGyuez7bRWIE55uPc7RCbXLg4qNI2OBp7+9+JRRB2HesBDIkbpnGVop?=
 =?us-ascii?Q?5200I5SU1LupYI+++qtZG2mrHmce/rh6FpQXPkk+TyyfCBgYrno5mONXKWvI?=
 =?us-ascii?Q?bBGUtRXJ+hcBuBo2FHHn4zD09AvxZClkmDN6Uy8VxMb6fFnc7kgQA9jSsIvr?=
 =?us-ascii?Q?m7ZiFzgNf5gYFzzKPCyfbcuRQkd/iMkH0FqXVikawBLkCwK5F0v5r8NSoDr+?=
 =?us-ascii?Q?SRokMk/+ka3y59WsJiCSjXxrVe2kDO7HWU2hDFdWVlk8lQts3NUfEwoJ8eJ7?=
 =?us-ascii?Q?cpjGzjK7BlGPePYvHrvRtpLiVAsfideYi/akPSgMrLGTGNwmIWDrG63zVMCG?=
 =?us-ascii?Q?lPYjIk/XsEommcgLqv+TZhLR2C1+dGj5PVculzDSF2ZhaQmFI0WKWObkKB+7?=
 =?us-ascii?Q?9y9QzqVOLjHyZPVmcWrow2iIxLjKpk1mrpOw8cJnYtx1B4cU63OP+RLk2lkU?=
 =?us-ascii?Q?NFggr7EUAPi/PbyX9Tf9W8GySlta82I1W301rbj86wpSrVUnPkEj9xh2CxoI?=
 =?us-ascii?Q?RwdyDw1TJzlTTla69MDzCnEqxxgilQhYRC6UKRhCR7AaRO6GFJFy7x5b/Mh+?=
 =?us-ascii?Q?CARO4fnOBUCJL7SGh3elXjs7TBO5uNZNpzWK/zRWnhmTM+PkvRwL1Qy/dVeh?=
 =?us-ascii?Q?owRH1Ksp1UaBJ5ryNoeSKsENFkqkLudtpYDNSLD/+xLOAHw6/Tq9ck1ZlZJB?=
 =?us-ascii?Q?DchHUrz2LatDpMO9vC+xZoJ8rQog/sSXggTpiCod++Ym7HimakBB2ZYkJ25Y?=
 =?us-ascii?Q?QJlJDyQYJsmabO4QafW2yKsFqkd9yZ3miRnbGPXawR0eOj30hOmBGX3jjNcw?=
 =?us-ascii?Q?o5pAbFu4zdOf70eV6cf/4BlskRsCwxemFonF5nlysxZMFUm9Kk0G80HdjZ2f?=
 =?us-ascii?Q?t2+BXb3umrhT87f7MqsPJAN8YzpQ+Tgo51YykqFpNfRFhubPOi+F1CbsZev9?=
 =?us-ascii?Q?H5MyP+b1P/Ljzg/r4fAXm8fl+672V8SJuS+pY6y484UlifyZk1UZdckXp49R?=
 =?us-ascii?Q?T2JDtOWyjvRbl8MkcqgJStk+G58GNERZyrQAQxM9lvYw5WdR3aXxhJHw/IpO?=
 =?us-ascii?Q?op4KpkhQTBQNzU3jH11cRjBtuf40+0tVd4XV5R31hUc5q1Vxe3/tVHD71pCF?=
 =?us-ascii?Q?GC5O3jRHbU1eUMkZ0NBDCnhl4QGClkhzdVoMCG7xZxIHaek840hY6LdqIz+u?=
 =?us-ascii?Q?fvghQfZUiM68iJpFsO0zswko6L6Pj5QBdjbuVP7vKKv+G/B8oL7/J3wqhJEo?=
 =?us-ascii?Q?bVDJ7f7j69km4OoaY4Gd4HQ7hb4OpB1J+ZYCj1nhWkVpo+qVsF0O0Dwq0zfg?=
 =?us-ascii?Q?RjdkZ7EFHD5vxUdLxwU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3dad913-e97d-4020-83dd-08de2c58d078
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 19:28:30.1454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EFnLDE+qTP5/xwwm7RmAJkZp1zodKm4IzzfausHCNunrLfrWWW+7U8DiOkloBH5c
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7221

On Fri, Nov 21, 2025 at 05:57:32PM -0800, Nicolin Chen wrote:
> PCIe permits a device to ignore ATS invalidation TLPs while processing a
> reset. This creates a problem visible to the OS where an ATS invalidation
> command will time out: e.g. an SVA domain will have no coordination with a
> reset event and can racily issue ATS invalidations to a resetting device.
> 
> The PCIe r6.0, sec 10.3.1 IMPLEMENTATION NOTE recommends SW to disable and
> block ATS before initiating a Function Level Reset. It also mentions that
> other reset methods could have the same vulnerability as well.
> 
> The IOMMU subsystem provides pci_dev_reset_iommu_prepare/done() callback
> helpers for this matter. Use them in all the existing reset functions.
> 
> This will attach the device to its iommu_group->blocking_domain during the
> device reset, so as to allow IOMMU driver to:
>  - invoke pci_disable_ats() and pci_enable_ats(), if necessary
>  - wait for all ATS invalidations to complete
>  - stop issuing new ATS invalidations
>  - fence any incoming ATS queries
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/pci/pci-acpi.c | 13 +++++++--
>  drivers/pci/pci.c      | 65 +++++++++++++++++++++++++++++++++++++-----
>  drivers/pci/quirks.c   | 19 +++++++++++-
>  3 files changed, 87 insertions(+), 10 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

