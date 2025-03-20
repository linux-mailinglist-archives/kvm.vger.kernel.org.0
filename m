Return-Path: <kvm+bounces-41637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E863A6B1D2
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 00:50:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 483D71898E4F
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:49:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7363521C9E7;
	Thu, 20 Mar 2025 23:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X37JO+3w"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2054.outbound.protection.outlook.com [40.107.95.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDCA1FC7D9
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 23:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742514525; cv=fail; b=Pxbv0MiowfNXyB2RyyiCTiH/QsPiv7USetTPDZpXJicVsaRSr3fqqTkVnHpJMGPYO5Y/upszteM8NC4g2xHNVTPWk+6m4SXu8Fy341n57iinwr/PY76AAAz51h5y11bV3/UgU2nuaWkpO2Rq2Gwl8RElCSa/aaKSjzkTzhxDwj0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742514525; c=relaxed/simple;
	bh=hnsptirepJ/xUwVBbxqXssoZUUOGMUVcvuO6DnVK2H8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DqQR6cDe3teWgHsa0djzd8sBxwsV90VmCWdFRX3v8VFBjZBR6RMUWdtGv17dOwov0B5Wd6cCsYUr3yp7N0xRzxWBPkzevV0iofqzP9+jX8oP4xcwJif/dKWF80JtWJYDNDBrPbjy/8JjhcBsX42w7KKYOjouhedIyWMoASogWUQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X37JO+3w; arc=fail smtp.client-ip=40.107.95.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pEke5INxqD0gpcNtPduTb4VlZTHOdc7ZvklrJZKzXaoQKdtv/rpj55MFGlrnXrpK+BHr+Vb3v91DMfWczpbbJ6AogUyTW6dkW8++OK9Mav3Ar7yypfhNdn9TJvYGQg2twQ6rBBGIQCxHb7jcViwoP6Edafez1pZq6CBxi/LhZWZBvtT7HxX3mUZQUPTG0N7tb4yLVqzNuXb6J5+dPUbUWIddNXtiklwtj5CQgMCsklTCeLc7YDVIB2BGIto1IF4OFayQx9mSI+Ut/qerlyGrxv+FjKVKRKMZ1RyoC1J5e34/mfKzSohzO51wsI3IL+yYu51NgSjhscsj7D7iFwDKlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oJgyKtN/Vgcdc9yZpBQKO0bfwfqUP16i3PHimPPrQ6w=;
 b=YYqFfrUxm4rVl7NQ0WcAjDh7kHkE1xdNQCygMzSA7D/fxDQtzQvCwinT76it4JESB94tlMyRYTEOYl3popL0frf6hMyIgSZ/As2RaNK5AeYQuXnSOF1UGA6MrHjoHEA+UQYpkbZVz+uRBYuUUl5htxk9QuK/SwnSYR802qNyutdazXLbHi6rk+XvoMOet/Piq4IUyT1sIL+XNJlx7lYTYvzo15Me88MAruYKvUgtoiMZyRyhxh6gwEOSfN4FEB90T4kpUHDyXJ6aOTO9MqFes8xSUcg3ho8V+sr5DQ9sreCYGZBKU4ApmJGKim6XNzHA9/b7JBpTRu+6K4V4nnJWsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJgyKtN/Vgcdc9yZpBQKO0bfwfqUP16i3PHimPPrQ6w=;
 b=X37JO+3wwlGcXZLbLzJ2HTeFaihrKOLrgZ7eaTPHD5zqag+McyK6eHQjAn++85FxiWIbs+8deYrAOe6khMM2FsEU4/Aa+GjCb+cvGGO7UyxsQM+I7x5q2QDlM2MdahCOI9GcjQgwFtyEB2hPt6V7qHRjwkS1TEvFPthMVXBVU3IFt2mSXbL5/+dDl8Hi5PV4CZIG3AHuJW5vx0oK/5BaT1cmwOdbedC1FyWIMzJUFEBfS8b3CIuekRgfTdnntZe8+/eFTwNj5e+vjYxpLaVkkQo/RaODKzITDLgocNu0v37H1wB6gyQLNESm13FWqeK5EaXs/fJa//P8xgN85OSq+g==
Received: from PH7PR17CA0020.namprd17.prod.outlook.com (2603:10b6:510:324::11)
 by BN7PPFFC4F04B28.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6ea) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Thu, 20 Mar
 2025 23:48:39 +0000
Received: from SN1PEPF00036F40.namprd05.prod.outlook.com
 (2603:10b6:510:324:cafe::92) by PH7PR17CA0020.outlook.office365.com
 (2603:10b6:510:324::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.33 via Frontend Transport; Thu,
 20 Mar 2025 23:48:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SN1PEPF00036F40.mail.protection.outlook.com (10.167.248.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Thu, 20 Mar 2025 23:48:39 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 20 Mar
 2025 16:48:33 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 20 Mar 2025 16:48:33 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 20 Mar 2025 16:48:32 -0700
Date: Thu, 20 Mar 2025 16:48:30 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Yi Liu <yi.l.liu@intel.com>, <alex.williamson@redhat.com>,
	<kevin.tian@intel.com>, <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <zhenzhong.duan@intel.com>,
	<willy@infradead.org>, <zhangfei.gao@linaro.org>, <vasant.hegde@amd.com>
Subject: Re: [PATCH v8 4/5] iommufd: Extend IOMMU_GET_HW_INFO to report PASID
 capability
Message-ID: <Z9ypThcqtCQwp2ps@Asurada-Nvidia>
References: <20250313124753.185090-1-yi.l.liu@intel.com>
 <20250313124753.185090-5-yi.l.liu@intel.com>
 <Z9sFteIJ70PicRHB@Asurada-Nvidia>
 <444284f3-2dae-4aa9-a897-78a36e1be3ca@intel.com>
 <Z9xGpLRE8wPHlUAV@Asurada-Nvidia>
 <20250320185726.GF206770@nvidia.com>
 <Z9x0AFJkrfWMGLsV@Asurada-Nvidia>
 <20250320234057.GS206770@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250320234057.GS206770@nvidia.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F40:EE_|BN7PPFFC4F04B28:EE_
X-MS-Office365-Filtering-Correlation-Id: b8fd2725-671e-497b-4c04-08dd6809bd2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DMAuSF3saFm2rmKBOqdTtCDbMta46O537OuEXP9iPDyuumbz2scXSgqism0S?=
 =?us-ascii?Q?vXQvMsHf/2x6VzDh4VuUMz7l15jSYhsHwXS9QRijv/XtcRpo71meZXE5tZap?=
 =?us-ascii?Q?lvGZ8KbgGECm5p/FZFX+Ao+YeA9A1YO+jHDawxBaXfD3wWYpyhiGw3avAC4s?=
 =?us-ascii?Q?wldh4nh2z0cdAYPcIh4PVBOa0BWAIJRjrCMkSD08HkKErgxUDvCWU0jpevM+?=
 =?us-ascii?Q?EyHXm7ktuzP95AwHLkC4Fi4Gkvz+PDVpRNXvNVEBYJq+IcXfDd/SP8mVPi/v?=
 =?us-ascii?Q?GnONh6XUwl7gT/2B29AyDwmzerfSRPHmgPpsl3x1uJ2SEcV2zvMA9mPRAY6D?=
 =?us-ascii?Q?cZGXrt/rYeb4cQsAdKLmgWI+XXDJNQYUd+9tTVxH1x0tCKrV12nDOZONT9wk?=
 =?us-ascii?Q?2OAEFiDrM2joI8jfDmVzMEqgUWo4njwnTxqRS64Yro8XkBSQJbEP6eh1vxxR?=
 =?us-ascii?Q?mNEgB6CicBDs2g4e9PhLlPFg9/51d+xLXX6MU4o/FXLYJAD0rxBr1XvIgVx0?=
 =?us-ascii?Q?WDRB620HiX1tJAa7wqMhEkjlR6YHwQFNDiwqDX2/2eJ7NkfeLvdzs7QEACGN?=
 =?us-ascii?Q?Bi6WBdXQqxHa2LzzNAvt6FXW5tNvroILBEJ/xJHkg3k1iREdXeMyMv7JK8vG?=
 =?us-ascii?Q?R4CMS7QFqvgf6bt6cuIs9jESs3SUvQj6RJX973L26XPCiN1rHbbr/m/z7arW?=
 =?us-ascii?Q?oT3MwFY75kgvzajXD8SrZZF5tC8k50ne/SBULVWWoVNXv6fMRAKSfZQVmvKc?=
 =?us-ascii?Q?FuMfGU8ZMEdUFK8cFIguU6GTtmVgCGG+anbuKaK4eUuGhi+8Q2kZGrychIFt?=
 =?us-ascii?Q?gh0UbZotTPiFot7X9C5+C2JgTuzdHfudshu1hg1JSRWfOfgA4XdoTZDeL4Xy?=
 =?us-ascii?Q?f5FbEMeK/69E7jZyHa4S8VB7XaMdZPupuk0NOZ+fvzoBhVzWeQQnpfU13N7A?=
 =?us-ascii?Q?U+9p0h2QgBMK/YuYqimXj/iTrOkydIIJhd+Pc2shb0xAI6P1DQQLiM4prF54?=
 =?us-ascii?Q?CQFkW71vdOm6lpOGDJW4xYMbsYtt41pGlrqE8ENsSOxpU8Mz/qiO4dfN4jBs?=
 =?us-ascii?Q?Tn42r0VdObs46Yp5aN7E54aRGcRKVnHzbyn6cHduNL/Y4GWriAyBEzImQ02J?=
 =?us-ascii?Q?WXZadmSsldfgVOQwT6Gin4OpPjN7XXTo7g3+Tsky5ddKGXad3XNwNw1thfAe?=
 =?us-ascii?Q?SWHBmooCsdy0EQCwaJt0PfFE+CwNbN02jwuwzSLXwJcABQ4sTCx90m3jexFX?=
 =?us-ascii?Q?Ijsd5KrCBcADY8/mHOapm6/pRshDqEsZ7M77J3BMd5L2G/JJ0ZzUM468kwpc?=
 =?us-ascii?Q?vhoW1Z5i9+fNXDK6JkYdFcQXFUmCfxl4kTc5ynJYBfBdAZMghw3YgIDpOnTX?=
 =?us-ascii?Q?ML86WhaGk+XBZ9oOt/aZOorWr/AbxN4f+/GfwGUzGpF/U3HhYZCR2eddgFzP?=
 =?us-ascii?Q?3lEk4O1nB5FIbZLRCARJidpQ08dKpbpSD8DnQiC7202JqNpuvZpJokOLiAfJ?=
 =?us-ascii?Q?QMQLK8szLbuo1qs=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 23:48:39.3397
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8fd2725-671e-497b-4c04-08dd6809bd2d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F40.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFFC4F04B28

On Thu, Mar 20, 2025 at 08:40:57PM -0300, Jason Gunthorpe wrote:
> On Thu, Mar 20, 2025 at 01:02:54PM -0700, Nicolin Chen wrote:
> > On Thu, Mar 20, 2025 at 03:57:26PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Mar 20, 2025 at 09:47:32AM -0700, Nicolin Chen wrote:
> > > 
> > > > In that regard, honestly, I don't quite get this out_capabilities.
> > > 
> > > Yeah, I think it is best thought of as place to put discoverability if
> > > people want discoverability.
> > > 
> > > I have had a wait and see feeling in this area since I don't know what
> > > qemu or libvirt would actually use.
> > 
> > Both ARM and Intel have max_pasid_log2 being reported somewhere
> > in their vendor data structures. So, unless user space really
> > wants that info immediately without involving the vendor IOMMU,
> > this max_pasid_log2 seems to be redundant.
> 
> I don't expect that PASID support should require a userspace driver
> component, it should work generically. So generic userspace should
> have a generic way to get the pasid range.

OK.

> > Also, this patch polls two IOMMU caps out of pci_pasid_status()
> > that is a per device function. Is this okay?
> 
> I think so, the hw_info is a per-device operation
> 
> > Can it end up with two devices (one has PASID; the other doesn't)
> > behind the same IOMMU reporting two different sets of
> > out_capabilities, which were supposed to be the same since it the
> > same IOMMU HW?
> 
> Yes it can report differences, but that is OK as the iommu is not
> required to be uniform across all devices? Did you mean something else?

Hmm, I thought hw_info is all about a single IOMMU instance.

Although the ioctl is per-device operation, it feels odd that
different devices behind the same IOMMU will return different
copies of "IOMMU" hw_info for that IOMMU HW..

Thanks
Nicolin

