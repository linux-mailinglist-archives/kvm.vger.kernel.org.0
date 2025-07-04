Return-Path: <kvm+bounces-51532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C34C3AF84E5
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 02:37:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E9281C27937
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 00:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1037E22612;
	Fri,  4 Jul 2025 00:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BNwmRt1W"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2075.outbound.protection.outlook.com [40.107.243.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C241EEE6;
	Fri,  4 Jul 2025 00:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751589444; cv=fail; b=YamvpqpVE69M4f/ILBkuALOKC89YQ4/yB74nHwQQHRCBlcS0JXjFZV6mu7AFmjSjKjiWu0cXoI014cMaJ63Evd3jVaGG4l6FHtMKPOrlhGq0AeXD91hbQ0iR8XmZtRHyJmrHGU893F272gytUKRjQhCo3GfISuvg0+HtSLzi9RQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751589444; c=relaxed/simple;
	bh=wVTLbQmDPK96iug2ixLynG++xncuF13M3y6iiulLgKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=naDELQmb8qlLr/01QM0KA2gtOGkm8E+HpAT0aTq3j44RWhfJDi3cbSheEceLkAREJfxXBvdLoF/ZevxZ2obn03mNYo8YWPtLpvEM7lOmOHfvxVDhIpgcVmkUwws/7ViR9De74Yycef+nww1UhICG4uTX2DlsPNj1YDvH5QRK45w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BNwmRt1W; arc=fail smtp.client-ip=40.107.243.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uj9jwBkpJZRlDYaLlq4lC8fQxGgOUjpqbAT+zBdBnQolugeVp4ezOwy5bZkul//PVZSgz3shcLBJZsToMDJD3evhX3BfMB1kU/E7ETVxNCoDCfH3WBRGGq5D1+Vby/CYsCPJXFi1oSf7QGllVEXkwG1y6NCHdoWY5Ccu29B2HJIRYlsviiK2iDcP2sMYxUL5NU17W3VYJ+aquxeRdXXWEtkJ6yIXkMqn4ZA2iNtYDsrfbUkwyoTU5rwGjA70pM3JDSfAs6SbmALOVVujvAe+PJmFxbUsPPndU7DBwiWd1Rwi+UelOpb1ozygKzsSxTvqYV+PdIfaxg9okBnBVdqPvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4L/gsRvcQz+CIp8noAyyZ+zGyQ5tpEJUQ3A/0WKEyUg=;
 b=D9yRCMwbu0jGOLXfskwkEL9w4w5zvbtCL1HiEVV6ZrbBQxumgYZo3cNJHinSUPWHS2oTrh9yzrxCHxySv3zYen1wrRgRHPpxRu/2ePG3NY9g5zkjWIyCZk5cfip9cMS+0A5NcVkXHZJ3d0HsB30Qi3BjdOvkL/mCnR4QQEvWKmxO/w1kkTy02cipTfU2jDPuBBtC87yII+9KoheKjRlMSycrymrEUVAllf68tgw589VjeWgmT+NciCXPGusolwMomNvQutI8nACqbiAOdphH6meVY70ncI4WVIft0uUqW0elfOqctPuLG3nfyn5HDx7tiC4MjJkTKj2h8WQrbWLUbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4L/gsRvcQz+CIp8noAyyZ+zGyQ5tpEJUQ3A/0WKEyUg=;
 b=BNwmRt1WlE6Csy0yRa6UVe7PSh/FRPbKRr7wxH5yccCpSXjpmhDw0ey5TwiWc5Z2n9JhC7ONZCU9EnFFppWtk78md9IdcfnHaojtz+usvkB2hOXaurctkCoYrbRVgrut1899+zPAQx6zO+OKR/UJD/19HBVvzWX+BUMgXrF1icd5SJLU1f6pWNSh1Ye2VGgtrrMZQleSQjTD8OO4hZJyJ/EDZ/gAH+lCnJ/GwXSW/uFYAybw0pQ+I5IlOPvOlbeJJsAurPsYAsX5G43/TOhIzO42eqKe3txcZ+jjIswGlNzWht6e4bLgnvCoIQDBJVEFG+G5Uce8fnHZizseDG5Pbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW4PR12MB6681.namprd12.prod.outlook.com (2603:10b6:303:1e1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.34; Fri, 4 Jul
 2025 00:37:13 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Fri, 4 Jul 2025
 00:37:12 +0000
Date: Thu, 3 Jul 2025 21:37:09 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH 00/11] Fix incorrect iommu_groups with PCIe switches
Message-ID: <20250704003709.GJ1209783@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
 <20250701154826.75a7aba6.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701154826.75a7aba6.alex.williamson@redhat.com>
X-ClientProxiedBy: BY5PR16CA0029.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::42) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW4PR12MB6681:EE_
X-MS-Office365-Filtering-Correlation-Id: e44425be-c8e3-427d-d400-08ddba92ea72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KXb+Gm6nyMxSEklUnPgpR6ImNd+gt0iuJ7/fTP3xv4a7H3oI6KWRj2aKIi0u?=
 =?us-ascii?Q?9cqj6KLQ9yRhR+noQO/Dx0QaifLyA1m2Ey+eHFdSCALw9HJZL2BhBGYuMD1E?=
 =?us-ascii?Q?Xz4zTEI/ISqBSAm5Y6NvvOrKScJ29DEEp8Nrl7eGHrGyfL7bjZ1z3GhWAlUf?=
 =?us-ascii?Q?V8172KP3OhOvZOxnkAia/uQrklKZDs4oW3stypq1q9fyqp3O7gDBOn2L6dAG?=
 =?us-ascii?Q?J3HZH57iiUM3Hj5W7yvbUW0+XOdp4UZgPjH7pKhG69chZZSh+z7PPGHUTalg?=
 =?us-ascii?Q?1r8ZKkaDaYfwmOmKCZ6KJMxKAOjOAsGDjKQBNxp+iQLgMDZfAywTjg/pyU3w?=
 =?us-ascii?Q?f39tvuNUBZFz1oXOwGyqrJ2H4MaOA4w+4L6oBgiGIhs6CslsAsxuWPINN5R9?=
 =?us-ascii?Q?y/f5KMHQN+rVYguIdloHdZwXnpmCVPII/whrO8hAVlUElzEfBE/vV+gCEDS9?=
 =?us-ascii?Q?MhwS9wSNPqJWvfA9omgWgVKp+A+vscI56PHKq78X6J1cDjQ1Lv+k3Pn8wpCN?=
 =?us-ascii?Q?X2k/ETXvS4MfhoyWu/nBWnIJU+YTl233OGdusyEnZjJysQ8vft6g4wx9fS44?=
 =?us-ascii?Q?r0BCdMeX+DCiIQE78JuCOZUv/tRtB8mxlD267+2AENNfLCwChHQ6mqGnDQRd?=
 =?us-ascii?Q?t5vDcuWpKfdHU/uzbt6wEnh75otvv/sMvW9pHW56TSZNI3hqEpjpzJ1K/sBK?=
 =?us-ascii?Q?f5o4Vs/2frfrUCsNwxpOVFyLmRu4i9D5kZbv4zknu76yeqKjGNB91oQtqnX7?=
 =?us-ascii?Q?J3welheYE05Hmvf7/YXWFeIbPvtbW/LFWmOnc1XiZJalkiOFlwNPu0QH5hxk?=
 =?us-ascii?Q?bcgnAvEJ36drpU43sQ3JXu8AXOsDiDzOEHHbhjvd1AF0LTN6WcMznuxpsYLx?=
 =?us-ascii?Q?L64mdlLZNBqlhzZ/K1VRJqIzajYUSn+jMOjfr5eT6GtDemfM8wnsd4H6yYtw?=
 =?us-ascii?Q?Gk6BlAGvgDl5acH0DcpWSt1p7cZ6tA4/h1y+AvvSP2e5QzY7Kz1UcS5W75NM?=
 =?us-ascii?Q?ee8UB0doh51+Nmv6ELKNJHP4Xmq67NHA+k1OAPPPvSI+lmyurqka96ObqSPT?=
 =?us-ascii?Q?JlbJFQV8GJt3bMEPk9/OY8aloNbv1uksm9a37uZl4El6L6sHlMUjOwppkU6N?=
 =?us-ascii?Q?bNHRRcXiOBSa6euna37uwUuZRQPIqBnzkAOpjWFeJhtrAS+99zeILxijdq8c?=
 =?us-ascii?Q?y4QqXvI8PW/S2mQsGYesPyq5vN257Fe531iK3SXmzMAIjswBGby+y1QT2Her?=
 =?us-ascii?Q?eIUwoFT7engQkCwAb3gRv9uATQMvhqcG3BdsGnnRNkG1KkfPLVIWKCDeFPcF?=
 =?us-ascii?Q?GRF/Bk5OLQBm43x/pC4t6EiueyHMNXPMWYXf0T+7Y+67kROjMJIvd48fR9xn?=
 =?us-ascii?Q?suBE97Mmpd6HRCuPZbmLpotC9JL5P5g6J/eUoiaE8299lea//17inTHZyybW?=
 =?us-ascii?Q?4VGwlR+EOp8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v9ok10DhQtZoviANQAJr8ZyyLDd0FAQelpH5Es0AQltalG/gbrAbescGm6gz?=
 =?us-ascii?Q?px7iBL4E/jGp3OUZN47DH1gquA54QsbldVvfi+7hsingesbBHbiT89H9UDYa?=
 =?us-ascii?Q?Ju84UKTzhBygudm7jPpfMpJssH/el0Q/HKZl5wC4gYA+mNtDB1vCVjY4WCPQ?=
 =?us-ascii?Q?y36RnYG2Cp+xpXo1HVEA/y4G2OulcyyNo4czCpO+I/QZI+Uhe85CBjOiPQV5?=
 =?us-ascii?Q?j1KyCHiXbne8of+zrMwoyf1uWB/YUyBkxX4wvHtjwNqcE/NVqru2GlceTEH3?=
 =?us-ascii?Q?jqvUDYanYCo8viRyNjvfGVwCQLGmD/z2tasLP0CKgakm4iW5HO5LMibKsQca?=
 =?us-ascii?Q?QTzFs1HWjtC2SNi4cDj8KKxKgAEXSkYmfXfcEgcEjXWdj4yYXfVtA0PPRZdg?=
 =?us-ascii?Q?1JsLLysW/fc68uu5ZAWRzzjkCwefAhCLKLUharpfzDIgKihPLLocdjTnwzkO?=
 =?us-ascii?Q?eWPAXWIrFkul+OBd+Z8oWOclqUQQpBWlXBQn2hvnERpSANvSuOs/J9Gq80hG?=
 =?us-ascii?Q?MFeDqc7XE0KUpHnjKLxm58Jk3K2chdNHufQ7OLe4afAd/bNpPdCZq3c9mYSR?=
 =?us-ascii?Q?7xFnDkjMA0GZtBMHFB43qabRQ5oabukgLehwl8bZCocKvjB70QQb0GJbvE/3?=
 =?us-ascii?Q?zZMzQzabr6eHlVFajH6Ial/UMng6eU9khX4MfYc4zF97h4OfSEmAVkE6wcyf?=
 =?us-ascii?Q?IZqhkeMLrFG87TkNFLiKTCNDE87HaC1+Wm5oClelHc7D2BjKKnWkoHy7yG1k?=
 =?us-ascii?Q?K0lS7ZN6KYcrc3MOrb1UZgIUjBb6/pg0fWj/xid3+YiBNoONI72XsUrVhUEK?=
 =?us-ascii?Q?eB5JGdbE21lJ25EBKGipxqf7pPTK0S9ZeUvjngyzBvaMcUAx1SXbBWFrsvFA?=
 =?us-ascii?Q?SIO8QBLXIGN9vlY5n2l7J81iuQmbIhdCLrE4q8+VIZxwuVVV13oKeoG57I6W?=
 =?us-ascii?Q?Wlt4cr0KAwimObyAHeZjyKB1LvUqounWcxggsbHWOGtIAN1Fbarf993K1xV9?=
 =?us-ascii?Q?yqGknp9nlW3O3hsi0jMV50/LrjK+NTOA9wvyoJ4+Ys7LSSE1lNdBNqm2GMFx?=
 =?us-ascii?Q?CbliNkw3+cG0GFICXJ7FfNgBj4MYnQs5iA8lKqdRMa3GZyVyO3GS5f4Rhz1M?=
 =?us-ascii?Q?TeQohltG12apyfUb2iTNBjYatC+jPNWcfTI1omkZuStEDRY0pNnYWdxhq0t3?=
 =?us-ascii?Q?t85ROe7yiw/kv8I6cjM9kRp9ViiCpbcAoNN2Dw0oiAKdI6ZJLTc7T6EYHXYM?=
 =?us-ascii?Q?zC+ZD7dGQ97FDAfL3365UqqP8H1DhmUpr+u7vpFF085joW8cL3X3h+73mrIv?=
 =?us-ascii?Q?+pDNGap7DFe9jnS79iI0Lmb1yXU/6wwuGRgiD716eIr0kJ/IKaGppjJ91Cbj?=
 =?us-ascii?Q?cnpG61ScMD+O1t92FcSRSAY2HtEPNBN+bNRz1HR7RkM/Eu7cyIksG2HYOSnw?=
 =?us-ascii?Q?fqynu4GTY/VRy0DOG08+htEPqFNbtGqYJbR/aaptUlUVOIMDmfJdEBgTiAEX?=
 =?us-ascii?Q?tK2M5exX/Ofa4ODRYrKDPCTYx9uEH1NuqRBO14v7IPjlkk3aJC23yOO1GXDn?=
 =?us-ascii?Q?mub2/0PGCeKPgUuAo2iHW2GaWFdefWWcu+Xam0ec?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e44425be-c8e3-427d-d400-08ddba92ea72
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2025 00:37:12.5088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eC3eOo6/Y8VlcRR7mjmjdOGeMENpt5G0Ge1Mt2x+It8gnzKDRvB0u7d+yJ8myy6C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6681

On Tue, Jul 01, 2025 at 03:48:26PM -0600, Alex Williamson wrote:

> 00:1c. are all grouped together.  Here 1c.0 does not report ACS, but
> the other root ports do:

I dug an older Intel system out of my closet and got it to run this
kernel, it has another odd behavior, maybe related to what you are
seeing..

00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v6/7th Gen Core Processor Host Bridge/DRAM Registers (rev 05)
00:01.0 PCI bridge: Intel Corporation 6th-10th Gen Core Processor PCIe Controller (x16) (rev 05)
00:02.0 VGA compatible controller: Intel Corporation HD Graphics 630 (rev 04)
00:14.0 USB controller: Intel Corporation 100 Series/C230 Series Chipset Family USB 3.0 xHCI Controller (rev 31)
00:14.2 Signal processing controller: Intel Corporation 100 Series/C230 Series Chipset Family Thermal Subsystem (rev 31)
00:16.0 Communication controller: Intel Corporation 100 Series/C230 Series Chipset Family MEI Controller #1 (rev 31)
00:17.0 SATA controller: Intel Corporation Q170/Q150/B150/H170/H110/Z170/CM236 Chipset SATA Controller [AHCI Mode] (rev 31)
00:1b.0 PCI bridge: Intel Corporation 100 Series/C230 Series Chipset Family PCI Express Root Port #17 (rev f1)
00:1f.0 ISA bridge: Intel Corporation C236 Chipset LPC/eSPI Controller (rev 31)
00:1f.2 Memory controller: Intel Corporation 100 Series/C230 Series Chipset Family Power Management Controller (rev 31)
00:1f.3 Audio device: Intel Corporation 100 Series/C230 Series Chipset Family HD Audio Controller (rev 31)
00:1f.4 SMBus: Intel Corporation 100 Series/C230 Series Chipset Family SMBus (rev 31)
00:1f.6 Ethernet controller: Intel Corporation Ethernet Connection (2) I219-LM (rev 31)
00:01.0/01:00.0 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5]
00:01.0/01:00.1 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5]
00:1b.0/02:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller SM961/PM961/SM963

And here we are interested in this group:

00:1f.0 ISA bridge: Intel Corporation C236 Chipset LPC/eSPI Controller (rev 31)
00:1f.2 Memory controller: Intel Corporation 100 Series/C230 Series Chipset Family Power Management Controller (rev 31)
00:1f.3 Audio device: Intel Corporation 100 Series/C230 Series Chipset Family HD Audio Controller (rev 31)
00:1f.4 SMBus: Intel Corporation 100 Series/C230 Series Chipset Family SMBus (rev 31)
00:1f.6 Ethernet controller: Intel Corporation Ethernet Connection (2) I219-LM (rev 31)

Which the current code puts into two groups
  [00:1f.0 00:1f.2 00:1f.3 00:1f.4]
  [00:1f.6]

While this series puts them all in one group.

No device in the MFD 00:1f has an ACS capability however only 00:1f.6 has a quirk:

	{ PCI_VENDOR_ID_INTEL, 0x15b7, pci_quirk_mf_endpoint_acs },
	/*
	 * SV, TB, and UF are not relevant to multifunction endpoints.
	 *
	 * Multifunction devices are only required to implement RR, CR, and DT
	 * in their ACS capability if they support peer-to-peer transactions.
	 * Devices matching this quirk have been verified by the vendor to not
	 * perform peer-to-peer with other functions, allowing us to mask out
	 * these bits as if they were unimplemented in the ACS capability.
	 */

Giving these ACS results:

pci 0000:00:1f.0: pci_acs_enabled:3693   result=0 1d
pci 0000:00:1f.2: pci_acs_enabled:3693   result=0 1d
pci 0000:00:1f.3: pci_acs_enabled:3693   result=0 1d
pci 0000:00:1f.4: pci_acs_enabled:3693   result=0 1d
pci 0000:00:1f.6: pci_acs_enabled:3693   result=1 1d

Which shows the logic here:

static struct iommu_group *get_pci_function_alias_group(struct pci_dev *pdev,
							unsigned long *devfns)
{
	if (!pdev->multifunction || pci_acs_enabled(pdev, REQ_ACS_FLAGS))
		return NULL;

Is causing the grouping difference. When it checks 00:1f.6 it sees
pci_acs_enabled = true and then ignores the rest of the MFD.  This is
basically part of my issue #2 that off-path ACS is not considered.

AFAIK ACS is a per-function egress property (eg it is why it is called
the ACS Egress Vector). Meaning if 01f.4 sends a P2P DMA targetting
MMIO in 1f.6 it is the ACS of 01f.4 as the egress that is responsible
to block it. The ACS of 1f.6 as the ingress is not considered.

By our rules if 01f.4 can DMA into 01f.6 they should be in the same
group.

I point to "Table 6-10 ACS P2P Request Redirect and ACS P2P Egress
Control Interactions" as supporting this. None of these options are
'block incoming request' - they are all talking about how to route the
original outgoing request.

So I think the above is a bug in the current kernel, the logic should
require that all functions in the MFD have ACS on, otherwise they need
to share a single group. It is what is implemented in this series, and
I think it is why you saw other cases where a single bad ACS "spoils"
the MFD?

It seems the qurking should have included all the functions in this
MFD, not just the NIC.

Does this seem right to you?

Jason

