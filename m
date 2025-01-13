Return-Path: <kvm+bounces-35305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AE21BA0BDFC
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 17:49:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE179162987
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 16:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6285F1FBBFF;
	Mon, 13 Jan 2025 16:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SFiudsoP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2070.outbound.protection.outlook.com [40.107.96.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE86A38F91;
	Mon, 13 Jan 2025 16:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736786981; cv=fail; b=QTjfKOvRgUrDmYEuDHeKE8JKX3mTB0VGVVVA3FE0980wlLf1zBuzdOUTq4o3IvoHCK/EF0q/9q/n3HBIJOXUUt4Pj/dB59aS6k1mbxRo3oYgm+CWSYdefmSF93bzaS7luaCcbKID3AmVxx4C+2OvSxYejU/9HUOeXKD+H5b+DYo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736786981; c=relaxed/simple;
	bh=OhdVRcxRTIazzWn3nSwVnoeDkT5jp0p/B8F133DFYgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oU0aC1sdp2lQV98MAEUfKKN4lS4Dq/4am2d7IMvhSzgFj3yzqkgEVUEz6obVRbMXTV/G3GKIhL5dIvwK0c9W2VTR5K0GZH9WWIyZ0/kKmtPC38Dl21XTqjbiSDfesgk4hCRdcj7SgXVBtYIcyFZMWkLfKMPg3lpN90Y3cfcfsG4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SFiudsoP; arc=fail smtp.client-ip=40.107.96.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RooA4xQkHHm8iX2prLoHSFQQVg7Nt0TxAhujMtCa4FxQMwomBPI+YSiGBe74tdhYruR5TQMDjBtL4DYi66+8FpTinnBMLSTNsJubBtn6jeRZGIEi5E0wGVXyob+vxohGp6FjGY0XHZLdxMTIjCCknO++QkXcO5J2ylf6JRSyGwwOfxLSHMI3/YuAg1MMz0VqnILKRT74U84Ojev91Aw1KrVCxAwympwywmze68dXyrJCNCsffVGH9DpbCFn3nWgiTLJJTkNUY59uVc0ckF4U5lujy4xhmPvWGF0KrZOcM3IyW6BrzVBU3g3yNHqtUXWYVxTirMWtLpFv67UB4PZVkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=djem/8ro9L6ive8XD6KAyUosq6uW6QhaEDri0g1m1v4=;
 b=sCjwuNVEYX9eXKDLS+8/8sZAyBr4tGXW8UyZALq6VfJv1+RmUeNRzy/h3xAtdihkYAPMNN/1SDyX6Tc+IJtyX0xKPcXIsgLRA70MvPHMjHzQtFzUltD8QhB78aUlSx7khqyucm7UR5asTYpfbXQMpLwS/DSbOXRTkUvpwH0w2dwDgU/413E/OA50G9bBJGpaMoVFXp2yo+M6aNZdyUhheqv2svas/GsAWIpexTvDXtzvxpYu6Yj3DON9xaWd5rf6m3vERrOXEcn6f1UsRzABVnJzYAogW1Njx9k+WtvOc9zGjCvP5pnKEB4oedgJBX/JDm6LgUCsOEipFeI430E0MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djem/8ro9L6ive8XD6KAyUosq6uW6QhaEDri0g1m1v4=;
 b=SFiudsoPxRJFJY5vOmACw4NtoPWqkfbY0I3SKfvYPKAhYi5NIF3bAkS9DviCQJpwCytCTI9RpszrLiBX4gVGnwcG/44WIjQIo20MDNNoL7nDKcZIXo2OqKy4+R/Zm2D3FNDc1zoArjrctpHDu+3ZcGTKa/NKUfq+A1aoSEhPzURtQfomP2t7yxoask2n4OFNcSfgoHiB2v94J7e6ZeIDI/xoOLkYso+4Z2zCghd12kRTElj1ujjy16XQ0YnPjW/ZGnZ8CqMl7xeiaBwQOTH+L+7982zULWyc837rwA5P6sb+QPcDIB1AGhCVuBMNgRAJWsneOtrdnggXvCZVIXcYxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ2PR12MB9209.namprd12.prod.outlook.com (2603:10b6:a03:558::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Mon, 13 Jan
 2025 16:49:36 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8314.022; Mon, 13 Jan 2025
 16:49:36 +0000
Date: Mon, 13 Jan 2025 12:49:35 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org, christian.koenig@amd.com,
	pbonzini@redhat.com, seanjc@google.com, alex.williamson@redhat.com,
	vivek.kasireddy@intel.com, dan.j.williams@intel.com, aik@amd.com,
	yilun.xu@intel.com, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, lukas@wunner.de, yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch, leon@kernel.org, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, tao1.su@intel.com
Subject: Re: [RFC PATCH 08/12] vfio/pci: Create host unaccessible dma-buf for
 private device
Message-ID: <20250113164935.GP5556@nvidia.com>
References: <20250107142719.179636-1-yilun.xu@linux.intel.com>
 <20250107142719.179636-9-yilun.xu@linux.intel.com>
 <20250108133026.GQ5556@nvidia.com>
 <Z36ulpCoJAllp4fP@yilunxu-OptiPlex-7050>
 <20250109144051.GX5556@nvidia.com>
 <Z3/7/PQCLi1GE5Ry@yilunxu-OptiPlex-7050>
 <20250110133116.GF5556@nvidia.com>
 <Z4Hp9jvJbhW0cqWY@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4Hp9jvJbhW0cqWY@yilunxu-OptiPlex-7050>
X-ClientProxiedBy: BL1PR13CA0079.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::24) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB9209:EE_
X-MS-Office365-Filtering-Correlation-Id: 771482f5-4466-4558-797f-08dd33f24359
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RDS52jF/X5vjD+fEQMuFuntbsBVtlSB0g++RLfAx+C5KRj7h+tc4gCBoe/qe?=
 =?us-ascii?Q?8jgtHYDlAMibAGWXdIh3EdRDnHh9+nCT8RHVzO9h24KRQuN0rIwSMham6r9b?=
 =?us-ascii?Q?yU0kzAV/TnEfGRvKP3a0HT7XFvaF7o4GMuI0vGScBXjhuS98bP4jcVfrV7ql?=
 =?us-ascii?Q?pijdrsLj0wmeCyjJJKHXOW1MnzO/MtzZ3pIph9xnXmHWUFER9pefZpFZ4uLZ?=
 =?us-ascii?Q?FXYk4qPVaqGTa6WKY4b7tZWwRAQwUH8loTxd6omRIBRsPZKguEtMZFLaHCgK?=
 =?us-ascii?Q?bNgTT9LFjNCCYCtRXi2XbwwAHr2/oTAjYaHkCmy5tZoRrdyuCphPAN5/5n5j?=
 =?us-ascii?Q?JjHDazz7/g9LPR6GlHScpjcrH8slf9YQpSg4lubQX0aXp5aFX/jq0ge+YhGL?=
 =?us-ascii?Q?BDNwg8c4n7KeQQVFfnVwiPcsAqwsI3kA1L9WyzeOgLtOx8qfUhC900HiFbiy?=
 =?us-ascii?Q?QgnKsFbsUBQnwu4joZ6EUA1fiDI+YF90rA1aWlmHR5H666AXgQUaNYzkU5oO?=
 =?us-ascii?Q?+/aUjVfBhnasu4d00CvECO1T6qK62kTVrGn0kW7KbfifRGUAGZJII7f88jK9?=
 =?us-ascii?Q?BVbnA6/XLle/Dr3tYxC3Cah9plCmdccphEXxTmFq3v0BgiPSkfU+3nUSjb+G?=
 =?us-ascii?Q?Qq4zjoCV9In6+JfbIRhevUkMUQobnHdiqKPZxbsZWdGN0XYpe+MGlAAIp3Xv?=
 =?us-ascii?Q?5ZP6L3SNLPrzW/bAYm3fyHJMx7EwA3O2PJ+6De9knZlTELKHSoRn59X3y0LU?=
 =?us-ascii?Q?uXTNx1HSBI71C6VX5v4xKo5F+2Ke6Erj8h2Yq6vjLIc4qPRH4czI4+QrpMle?=
 =?us-ascii?Q?HUyTkjprWINsXcmZ8nU3TuqWo3inS1VKH+vQKpgYSzHlqX6iTs2hURCoIYTT?=
 =?us-ascii?Q?AYzGDwdHLy6VoSOgx0sfluPKfqjKr2AepWPhksAo2J3TNMLIHItBzhhCliq0?=
 =?us-ascii?Q?kcMEXC3nr/mkZMV+qk7Y60tgfeYynHQxqyJDPMZ/B09qWFgWksuDk6ZdtkhP?=
 =?us-ascii?Q?UttVk948ntaforopafng+R+TXKwks6pE9ZdoQXck4YcE0TmB0xyvY1Av8B8c?=
 =?us-ascii?Q?TWh5Ub8QQJc3Dtk1I8HD3vIHKeQfilocyV9ScJ1fQ399a1NVKMF9ebxNgltW?=
 =?us-ascii?Q?61X8HrF9h97a9aZ7vM9IPEV7ZQUvGh0dRAzdWWqqW6h1MSK/EpkObv/vrcJY?=
 =?us-ascii?Q?XYOIu9VqU1sAvGJjwvdfvXhEguJ47wLb2fmd/E/1sxe/G7kaX+8QJgE2rfzw?=
 =?us-ascii?Q?B/x/Rjh3NL3iGYiM+626sanidpU10FtYbASKuCdRY04Ha9ebsHe+7KEzabNO?=
 =?us-ascii?Q?JDb3ljzL6Zu7b/uX1i6wKBVBE6UxoIBKT7maqvegM01LK3ymu4yApsjAszkF?=
 =?us-ascii?Q?ueFafSk92zLFP7odeLNRIxUgD/9e?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wDhLvScHU5Myk+EzohPuHkt3NjzKlHq50s5PigUiW2zMwQ0W3XKPnrtFEfbP?=
 =?us-ascii?Q?bb0Joa3SEg8mxo2iAzqD14P//kthcW5MU9NM8iApxYWhXzAkTk4emwDlkncG?=
 =?us-ascii?Q?xhjPHYyT2PpXu345uyvoR/X+hS2DQOaJEAeLDn6r5EC9wac+JjL0lokCPo21?=
 =?us-ascii?Q?GmugGHybIbiR2g7bPaHz9EXcclm0SHgUFrs4yF8iorRwcRorEsFBVqodNmH/?=
 =?us-ascii?Q?VeCcIXv2+iSgFFZbuYclCp9Y3TClBhYhmcjtW0wn6Nwdpqi0h+Wm4pZyPu8j?=
 =?us-ascii?Q?c9rm5b6Hcm3lzjKOIXaT8m9SE3CSyXAnqj+LDVOqz0mDuMgMah9w4af9dtiL?=
 =?us-ascii?Q?PbIDsoLk39FW1AnauhaZNpVOhLMzcmwYxaoGjZf1JqpOfreTdiiCU/PdoVl8?=
 =?us-ascii?Q?ydJgl43xsunhXvYsNeSxuV03wc338jmaQ4lgsA6G6zkBbT+NrPZp6XMfTffw?=
 =?us-ascii?Q?zvW8nWbgxi+u7Aq1b+byvFX4DbZxrpT8cC6TxzGJtf9PN3mpgSTcW2qauwIo?=
 =?us-ascii?Q?VP0OTVdGkeGhP3hPRJbNmvJ29Ixj4WjEi/cL2CZYVdYlTskhVTirVqg9yz1v?=
 =?us-ascii?Q?rigGPtR3CvjkcJoWWk/WRY9AAN9eiRi8CVQDZTDb7uiH1GaFWdnot8nPOnwk?=
 =?us-ascii?Q?a1UDNioVn5qcsuvZc71Lquii/2iCSyVzfJgKz9uAhNRJ8JF1Sga+oiivGYWx?=
 =?us-ascii?Q?akuu9X1ddIcCWW1U2mFj1GVaz1t5KsbD2dzlaZI0Cj6JaHB8hJRfNLGvhMz6?=
 =?us-ascii?Q?ZdjySwhYr++caQZE/cxkwkr1eAFvf2JtSRJkZaWh47iQ6s5mtz6CzBhEIRSI?=
 =?us-ascii?Q?GDFLaMT721E7C0SifYBzeXYYCdQRPmjqPMgp7350G2PbTsrXcETWgApYPNTR?=
 =?us-ascii?Q?SUf/nSqc59WjHlZYBXY6P2r6CFmf3DU6E71snZH7q6iqkKUh0eg7B+ztwrCD?=
 =?us-ascii?Q?z1AimCwLJ6CkSE9De0ULAcSINChMy3v4A7QVZq1RikwKS29NM5zRuqQdIsJJ?=
 =?us-ascii?Q?SDZGxPfoQW+936xjYn7SPUfOrg7tZWeIY3jTHC0wgMEbeUwIecrjOmp3UzcH?=
 =?us-ascii?Q?FZJn+f/RPZBo/yd2nh15RJ60K/heURBbBjyC61iBVy9c7utF3wufz3iPJnB+?=
 =?us-ascii?Q?FOySOoat04fQ5aLPc3WtLzcYxVDHCuUPU6zAGqF1iophSvDWmE9ILV7HU88x?=
 =?us-ascii?Q?UgpQN20M1HpxmzZIgeIlmapgljyQjP2bRYbVC+rUX6VFhclxEMyMb3iebIib?=
 =?us-ascii?Q?ogvHhDOIV6evzdNWnHKF/hRtuzrgOJxIfyiraLLCCaGc46pI2zqowKlqxq3+?=
 =?us-ascii?Q?bK3QzLyrVwpzTEqzdjuXFmBv2xQO9rq1RQwR1ZXbhD5iNhsJK/xJf5M6pw48?=
 =?us-ascii?Q?f27DjYLkjlaMIQ4VeGwpW2IpfBNfDADi28iZ4ifhowNZf9vq10l5LCcgoKAe?=
 =?us-ascii?Q?SFQP0JxkwHa7StcVSQ38E6S+OLrpUKgqRh7Phh3VRHzpO+byNMAkEVtAjb+Z?=
 =?us-ascii?Q?WsBUhgVBC4oaiRaid6Z8qQj6T7dBLxBpgU0sVhyF2Rt3QqnvOx3rPZ4XeCO9?=
 =?us-ascii?Q?7PJOLJjPETh5XKIKLrQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 771482f5-4466-4558-797f-08dd33f24359
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2025 16:49:36.3495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DsoIgtO1SzC/WAyUlJJJFWvYbYBMCnKR2tZLFlznbthnbQI2z/Tw+JqhVBh3gG5D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9209

On Sat, Jan 11, 2025 at 11:48:06AM +0800, Xu Yilun wrote:

> > > > can be sure what is the correct UAPI. In other words, make the
> > > > VFIO device into a CC device should also prevent mmaping it and so on.
> > > 
> > > My idea is prevent mmaping first, then allow VFIO device into CC dev (TDI).
> > 
> > I think you need to start the TDI process much earlier. Some arches
> > are going to need work to prepare the TDI before the VM is started.
> 
> Could you elaborate more on that? AFAICS Intel & AMD are all good on
> "late bind", but not sure for other architectures.

I'm not sure about this, the topic has been confused a bit, and people
often seem to  misunderstand what the full scenario actually is. :\

What I'm talking abou there is that you will tell the secure world to
create vPCI function that has the potential to be secure "TDI run"
down the road. The VM will decide when it reaches the run state. This
is needed so the secure world can prepare anything it needs prior to
starting the VM. Setting up secure vIOMMU emulation, for instance. I
expect ARM will need this, I'd be surprised if AMD actually doesn't in
the full scenario with secure viommu.

It should not be a surprise to the secure world after the VM has
started that suddenly it learns about a vPCI function that wants to be
secure. This should all be pre-arranged as possible before starting
the VM, even if alot of steps happen after the VM starts running (or
maybe don't happen at all).

Jason

